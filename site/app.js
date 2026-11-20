// The page is filled from data.json, which scripts/build-site.ps1 generates from
// data/courseN.md (courses, references) and data/site-config.json (objectives, code, additional resources).
const state = { site: null, selected: 0 };
const panels = document.querySelectorAll('[data-panel]');
const pad = (number) => String(number).padStart(2, '0');
const esc = (value) => String(value ?? '').replace(/[&<>"']/g, (char) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[char]));

function showTab(name) {
  panels.forEach((panel) => panel.classList.toggle('is-visible', panel.dataset.panel === name));
  document.querySelectorAll('[data-tab]').forEach((tab) => tab.classList.toggle('is-active', tab.dataset.tab === name));
  if (name !== 'overview') history.replaceState(null, '', `#${name}`);
  window.scrollTo({ top: 0, behavior: 'smooth' });
}
// Delegated, so buttons rendered later (course detail, objectives) also switch tabs.
document.addEventListener('click', (event) => {
  const tab = event.target.closest('[data-tab]');
  if (!tab) return;
  if (tab.dataset.course !== undefined) { state.selected = Number(tab.dataset.course); renderCourses(); }
  showTab(tab.dataset.tab);
  if (tab.dataset.anchor) document.getElementById(tab.dataset.anchor)?.scrollIntoView({ block: 'start' });
});

function renderObjectives() {
  const { objectives, courses } = state.site;
  document.querySelector('#objective-grid').innerHTML = objectives.map((objective, index) => {
    const chips = objective.courses.map((number) => {
      const courseIndex = courses.findIndex((course) => course.number === number);
      return courseIndex < 0 ? '' : `<button class="topic topic-button" data-tab="courses" data-course="${courseIndex}" title="${esc(courses[courseIndex].title)}">Course ${pad(number)}</button>`;
    }).join('');
    return `<article class="resource-card objective-card"><span class="resource-type">Objective ${pad(index + 1)}</span><h3>${esc(objective.title)}</h3><p>${esc(objective.text)}</p><div class="detail-topics">${chips}</div></article>`;
  }).join('');
}

function renderDetail(course) {
  const objectives = state.site.objectives.filter((objective) => course.objectives.includes(objective.id));
  const video = course.video ? `<a href="${esc(course.video.url)}" target="_blank" rel="noreferrer">Watch the lecture ↗</a>` : '';
  // Hand-maintained resources that name this course in their "courses" field (practical sessions, code).
  const related = [...state.site.resources.code, ...state.site.resources.additional]
    .filter((item) => (item.courses || []).includes(course.number))
    .map((item) => `<a href="${esc(item.url)}"${isExternal(item.url) ? ' target="_blank" rel="noreferrer"' : ''}>${esc(item.title)} ${isExternal(item.url) ? '↗' : '→'}</a>`).join('');
  const further = course.references.length ? `<button class="link-button" data-tab="resources" data-anchor="further-${course.number}">Go further · ${course.references.length} references →</button>` : '';
  document.querySelector('#course-detail').innerHTML = `<p class="detail-kicker">Course ${pad(course.number)} · ${esc(course.duration)}</p><h3>${esc(course.title)}</h3><p>${esc(course.summary)}</p><p class="detail-label">Learning objectives served</p><ul class="detail-outcomes">${objectives.map((objective) => `<li><strong>${esc(objective.title)}.</strong> ${esc(objective.text)}</li>`).join('')}</ul><div class="detail-topics">${course.topics.map((topic) => `<span class="topic">${esc(topic)}</span>`).join('')}</div><div class="detail-links">${video}${related}${further}</div>`;
}

function renderCourses() {
  const { courses } = state.site;
  const list = document.querySelector('#course-list');
  document.querySelector('#nav-course-count').textContent = pad(courses.length);
  list.innerHTML = courses.map((course, index) => `<button class="course-row${index === state.selected ? ' is-selected' : ''}" data-course-index="${index}"><span class="course-number">${pad(course.number)}</span><span><h3>${esc(course.title)}</h3><p class="course-meta">${esc(course.duration)} · ${esc(course.level)}</p></span><span class="course-arrow">→</span></button>`).join('');
  list.querySelectorAll('[data-course-index]').forEach((row) => row.addEventListener('click', () => { state.selected = Number(row.dataset.courseIndex); renderCourses(); }));
  renderDetail(courses[state.selected]);
}

// A card of the hand-maintained lists (repository/code, additional resources).
// A page of this site (relative url) opens in the same tab; an external one opens in a new tab.
const isExternal = (url) => /^https?:/.test(url);
const linkCard = (item) => `<a class="resource-card" href="${esc(item.url)}"${isExternal(item.url) ? ' target="_blank" rel="noreferrer"' : ''}><span class="resource-type">${esc(item.type)}</span><h3>${esc(item.title)}</h3><p>${esc(item.text)}</p><span class="resource-arrow">${isExternal(item.url) ? '↗' : '→'}</span></a>`;

// One generated "go further" card per course: its video and the references of the course file.
function furtherCard(course) {
  const items = course.references.map((reference) => reference.url
    ? `<li><a href="${esc(reference.url)}" target="_blank" rel="noreferrer">${esc(reference.text)} ↗</a></li>`
    : `<li>${esc(reference.text)}</li>`).join('');
  const online = course.references.filter((reference) => reference.url).length;
  const video = course.video ? `<a class="further-video" href="${esc(course.video.url)}" target="_blank" rel="noreferrer">Watch the lecture ↗</a>` : '';
  return `<article class="resource-card further-card" id="further-${course.number}"><span class="resource-type">Course ${pad(course.number)} · Go further</span><h3>${esc(course.title)}</h3>${video}<details><summary>${course.references.length} references · ${online} online</summary><ul class="reference-list">${items}</ul></details></article>`;
}

function renderResources() {
  const { courses, resources } = state.site;
  document.querySelector('#further-grid').innerHTML = courses.map(furtherCard).join('');
  document.querySelector('#code-grid').innerHTML = resources.code.map(linkCard).join('');
  document.querySelector('#additional-grid').innerHTML = resources.additional.map(linkCard).join('');
}

async function loadSiteData() {
  try {
    const response = await fetch('data.json', { cache: 'no-store' });
    if (!response.ok) throw new Error('Course data unavailable');
    state.site = await response.json();
    // "#courses-3" opens the Courses tab on course 3.
    if (courseInHash) state.selected = Math.max(0, state.site.courses.findIndex((course) => course.number === courseInHash));
    renderObjectives(); renderCourses(); renderResources();
  } catch (error) {
    document.querySelectorAll('.loading').forEach((node) => { node.textContent = 'Run the site build to load the courses.'; });
  }
}
const courseInHash = Number((window.location.hash.match(/^#courses-(\d+)$/) || [])[1] || 0);
const initialTab = courseInHash ? 'courses' : window.location.hash.slice(1);
if (['overview', 'courses', 'resources', 'about'].includes(initialTab)) showTab(initialTab);
loadSiteData();
