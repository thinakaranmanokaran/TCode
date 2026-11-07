# T Code Website

The application showcase and SEO site for **T Code**.

## Stack

- React 19
- Vite 8
- Tailwind CSS 4
- React Router 6
- `vite-react-ssg` for build-time static rendering
- No TypeScript. Every source/config file is `.js` or `.jsx`.

## Commands

```sh
npm install
npm run dev      # local development
npm run build    # static build + sitemap
npm run preview  # preview the production build
```

`npm run build` writes the static site to `dist/`. Every route is pre-rendered to real HTML, so the content is indexable without waiting for client-side React.

## Configuration

Before deploying, update `src/data/site.js`:

- `url` — the canonical domain (currently `https://thinakaranmanokaran.github.io/TCode`)
- `links.github` / `links.releases` — the public T Code repository and release page (`https://github.com/thinakaranmanokaran/TCode`)
- `downloads.*` — release asset filenames
- `version` — the version shown in the header and download page

The download buttons use the GitHub `releases/latest/download/<asset>` pattern. If the repository or asset names change, update the file names in `siteConfig.downloads`.

## Assets

- `public/images/screenshots/` — optimized app screenshots
- `scripts/screenshots-src/` — source screenshots used to regenerate the web assets
- `public/brand/` — logo, favicons, developer avatar
- `public/fonts/` — self-hosted Instrument Serif, Plus Jakarta Sans, and Geist Mono
- `public/images/og/default.png` — default social share image

Regenerate the optimized screenshots, favicons, and social card with:

```sh
npm run optimize-images
```

Theme data is generated from the editor’s real theme files:

```sh
node scripts/generate-theme-data.js
```

## SEO

- Per-page title, description, canonical, Open Graph, and Twitter cards via `PageMeta`
- JSON-LD for `SoftwareApplication`, `Person`, `FAQPage`, `BreadcrumbList`, and blog articles
- `sitemap.xml` and `robots.txt` generated after the build
- `404.html` generated for static hosts
- Static HTML output with no client-side content dependency
- Images are WebP, lazy-loaded below the fold, and sized to prevent layout shift

## Deploy

### GitHub Pages (recommended)

Repo: `https://github.com/thinakaranmanokaran/TCode` · Site: `https://thinakaranmanokaran.github.io/TCode/`

1. In the repo, go to **Settings → Pages → Build and deployment → Source: GitHub Actions**.
2. Push to `main` (or run **Actions → Deploy website to GitHub Pages → Run workflow**).
   The workflow in `.github/workflows/pages.yml` builds `website/` with `VITE_BASE=/TCode/` and deploys `website/dist/`.

```sh
# Local check of the Pages build
MSYS_NO_PATHCONV=1 VITE_BASE=/TCode/ npm run build
npm run preview   # serves at http://127.0.0.1:4173/TCode/
```

- `vite.config.js` reads `VITE_BASE` (default `/`) and `src/main.jsx` passes `basename: import.meta.env.BASE_URL` to the router, so links/assets resolve under `/TCode/` on Pages and `/` on custom domains.
- `src/data/site.js` `url` includes the `/TCode` subpath so sitemap, canonical, and OG URLs are correct on Pages. Point it back to `https://tcode.thinakaran.dev` for the custom domain.
- `public/.nojekyll` bypasses Jekyll (keeps `_headers` intact).

### Cloudflare Pages

- Build command: `npm run build`
- Output directory: `dist`
- `public/_headers` provides cache and security headers.

### Vercel

- Framework preset: Vite
- Build command: `npm run build`
- Output directory: `dist`
- `vercel.json` enables clean URLs.

## Notes

- Instrument Serif, Plus Jakarta Sans, and Geist Mono are self-hosted in `public/fonts/` and preloaded for faster first paint. Apple Garamond from the design reference is proprietary, so it is intentionally not bundled.
- The interface is a deliberate recreation of the reference design language, not a copy of its content or proprietary assets.
- All public developer details were sourced from Thinakaran Manokaran’s public profiles (`thinakaran.dev`, LinkedIn, GitHub, DEV). Confirm the bio and links before publishing.

## Font licenses

Instrument Serif, Plus Jakarta Sans, and Geist Mono are licensed under the SIL Open Font License 1.1. The license texts are included in `public/fonts/OFL-*.txt`.
