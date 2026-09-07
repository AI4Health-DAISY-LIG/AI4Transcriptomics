# AI4Transcriptomics

Course website for **From Nucleus to Neural Networks: Foundations of AI in Transcriptomics**.

## Local testing

Build the public capsule data from the private course notes, then serve the static site:

```powershell
./scripts/build-site.ps1
python -m http.server 8000 --directory site
```

Open <http://localhost:8000>. The generator extracts only public-facing titles, outcomes, topics, and links into `site/data.json`; the source notes in `data/` are never copied to the Pages artifact.

## Deployment

The workflow in `.github/workflows/pages.yml` rebuilds and deploys the site to GitHub Pages whenever `data/`, `site/`, or `scripts/` changes on `main`. In the repository settings, set **Pages → Build and deployment → Source** to **GitHub Actions**. The generated URL is then shown on the workflow run and in the repository's Pages settings.

## Asset and license audit

- `data/icon.png` is the instructor-provided logo and is copied to `site/icon.png` for the favicon and wordmark. No third-party license is imposed by this repository on that file; retain the author's permission when redistributing it.
- The page's CSS, JavaScript, HTML, and generated `site/data.json` are original project output and contain no embedded third-party dataset.
- The two Google Fonts loaded by the page, DM Sans and Space Grotesk, are distributed under the SIL Open Font License. They are loaded from Google Fonts rather than vendored into this repository.
- The external links in the Resources tab point to their original providers; the site does not copy or redistribute their content.
- The instructor portrait is linked from the instructor's public research website and is not copied into this repository.
