const state = { capsules: [], selected: 0 };
const tabs = document.querySelectorAll('[data-tab]');
const panels = document.querySelectorAll('[data-panel]');

function showTab(name) {
  panels.forEach((panel) => panel.classList.toggle('is-visible', panel.dataset.panel === name));
  tabs.forEach((tab) => tab.classList.toggle('is-active', tab.dataset.tab === name));
  if (name !== 'overview') history.replaceState(null, '', `#${name}`);
  window.scrollTo({ top: 0, behavior: 'smooth' });
}
tabs.forEach((tab) => tab.addEventListener('click', () => showTab(tab.dataset.tab)));

function renderDetail(capsule) {
  const links = capsule.links.flat(Infinity).filter((link) => link && link.url && link.label);
  document.querySelector('#course-detail').innerHTML = `<p class="detail-kicker">Capsule ${String(capsule.number).padStart(2, '0')} · ${capsule.duration}</p><h3>${capsule.title}</h3><p>${capsule.summary}</p><ul class="detail-outcomes">${capsule.outcomes.map((item) => `<li>${item}</li>`).join('')}</ul><div class="detail-topics">${capsule.topics.map((topic) => `<span class="topic">${topic}</span>`).join('')}</div><div class="detail-links">${links.map((link) => `<a href="${link.url}" target="_blank" rel="noreferrer">${link.label} ↗</a>`).join('')}</div>`;
}
function renderCourses(capsules) {
  const list = document.querySelector('#course-list');
  document.querySelector('#nav-course-count').textContent = String(capsules.length).padStart(2, '0');
  list.innerHTML = capsules.map((capsule, index) => `<button class="course-row${index === state.selected ? ' is-selected' : ''}" data-course-index="${index}"><span class="course-number">${String(capsule.number).padStart(2, '0')}</span><span><h3>${capsule.title}</h3><p class="course-meta">${capsule.duration} · ${capsule.level}</p></span><span class="course-arrow">→</span></button>`).join('');
  list.querySelectorAll('[data-course-index]').forEach((row) => row.addEventListener('click', () => { state.selected = Number(row.dataset.courseIndex); renderCourses(state.capsules); }));
  renderDetail(capsules[state.selected]);
}
async function loadCourseData() {
  try { const response = await fetch('data.json'); if (!response.ok) throw new Error('Course data unavailable'); state.capsules = await response.json(); renderCourses(state.capsules); }
  catch (error) { document.querySelector('#course-list').innerHTML = '<p class="loading">Run the site build to load the course capsules.</p>'; }
}
const initialTab = window.location.hash.slice(1);
if (['overview', 'courses', 'resources', 'about'].includes(initialTab)) showTab(initialTab);
loadCourseData();