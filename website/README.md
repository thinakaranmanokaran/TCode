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

- `url` — the canonical domain (currently `https://tcode.thinakaran.dev`)
- `links.github` / `links.releases` — the public T Code repository and release page
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
