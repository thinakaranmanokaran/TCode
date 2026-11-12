# T Code SEO Playbook

This is the operating plan for the organic search work. It covers the
launch assets, the outreach template, the weekly review, and the content
calendar. It is intentionally separate from the site code.

**Goal:** rank in the top 10 for `lightweight code editor` and its
platform/intent variants, then compete for the head term over 6–12 months.
No one can guarantee position 1; this is the legitimate path to give the
site the best chance.

---

## 1. Current baseline

Record this before each phase and update it weekly.

| Metric | Where | Baseline |
| --- | --- | --- |
| Indexed pages | Search Console → Pages | |
| Sitemap submitted | Search Console → Sitemaps | |
| Impressions / clicks | Search Console → Performance | |
| Queries in top 100 | Search Console → Queries | |
| Core Web Vitals | PageSpeed Insights / CrUX | |
| Downloads | Analytics event | |
| GitHub clicks | Analytics event | |

The site is on a GitHub Pages project URL:
`https://thinakaranmanokaran.github.io/TCode/`.

Search Console property: **URL prefix**, not domain property. Verify with
`public/googleb2d538de4396f59b.html`.

---

## 2. Weekly operating checklist

- [ ] Check Search Console → Page indexing. Fix new errors.
- [ ] Check Search Console → Performance. Record clicks, impressions, CTR,
  and average position for the target cluster.
- [ ] Find queries ranking positions 5–20. Add a section or FAQ to the
  matching page; do not create a new page for every query.
- [ ] Check titles with high impressions but low CTR. Rewrite the title and
  description for the matching page.
- [ ] Check the sitemap for new URLs and real `lastmod` dates.
- [ ] Run `npm run seo:check` before every deploy.
- [ ] Check PageSpeed Insights for the homepage and the pillar page.
- [ ] Record one content improvement and one link/outreach action per week.

---

## 3. Launch copy

Use these as starting points, then adapt each one to the community's rules.
Do not cross-post the same text everywhere. Disclose that you built T Code.

### Show HN

**Title:** Show HN: T Code – a 5 MB code editor with a built-in terminal

**Body:**

I built T Code because I wanted a code editor that opens before I finish
deciding what to edit. It is a C and Lua editor with a native menu bar, an
integrated terminal, 24 themes, and a mod-version 4 plugin API.

- Windows executable: about 4.7 MB; portable zip: about 2.6 MB
- No Electron, no browser runtime, no account
- Windows, macOS, and Linux
- MIT licensed

It is built on the Lite XL core and adds a desktop workflow: menus, an
activity bar, terminal tabs, live theme previews, and Explorer/tab context
menus. I would especially appreciate feedback on the terminal workflow and
the plugin compatibility.

GitHub: https://github.com/thinakaranmanokaran/TCode
Site: https://thinakaranmanokaran.github.io/TCode/

### Product Hunt

**Tagline:** A 5 MB code editor that gets out of your way.

**Description:**

T Code is a free, open-source code editor for Windows, macOS, and Linux.
It is built with a C core and Lua, ships in about 5 MB, and includes a
native menu bar, an integrated terminal with tabs and shell profiles, 24
themes, multi-cursor editing, and a mod-version 4 plugin API. No Electron,
no account, MIT licensed.

**First comment:**

Hi Product Hunt! I built T Code because I wanted the editor to feel fast
again — not “fast for an Electron app,” actually fast. It is a small C and
Lua editor with the desktop workflow I use every day. Happy to answer
questions about the architecture, the terminal, or the plugin model.

### Reddit

Check each subreddit's self-promotion rules first. Prefer a discussion post
with real details over a drive-by link.

- **r/opensource:** focus on the MIT license, the architecture, and the
  plugin compatibility. Ask for feedback.
- **r/programming:** focus on the engineering trade-off: what it takes to
  keep an editor at 5 MB.
- **r/linux:** focus on the portable tarball, AppImage, X11/Wayland, and
  PTY terminal. Be explicit that it is a small editor, not a full IDE.
- **r/Windows10 / r/Windows11:** focus on the portable build, ConPTY
  terminal, and the installer.
- **r/macapps:** focus on the universal build, DMG, and native menus.

### DEV / Hashnode

Publish a technical article, not a launch announcement:

- “What it takes to keep a code editor at 5 MB”
- “Why Electron editors feel slow on a 4 GB laptop”
- “Building a terminal drawer in a C and Lua editor”

Link to the canonical article on the site and use the platform's canonical
URL feature.

---

## 4. Outreach template

Send a short, personalized email. Do not send a press release. Offer a
review build and a specific angle.

**Subject:** A 5 MB code editor for your [Windows / low-end laptop / terminal] coverage

Hi [Name],

I read your [specific article/video] about [topic] and thought T Code might
be a useful follow-up. It is a free, MIT-licensed code editor built in C and
Lua: about 4.7 MB on Windows, no Electron, with a native menu bar, an
integrated terminal, and a mod-version 4 plugin API.

It is built on the Lite XL core and adds the desktop workflow that usually
requires a second tool. I have a review build and a reproducible benchmark
sheet if that is useful. No obligation to cover it — I am happy to answer
questions either way.

Site: https://thinakaranmanokaran.github.io/TCode/
GitHub: https://github.com/thinakaranmanokaran/TCode

Thanks,
Thinakaran

---

## 5. Outreach targets

Start with 30 personalized contacts. Track them in a simple spreadsheet
with date, contact, angle, status, and link.

**Newsletters**

- Console.dev
- TLDR Newsletter
- Hacker Newsletter
- Pointer
- Dev Weekly
- JavaScript Weekly (only if the angle is the plugin/Lua layer)
- Linux Weekly News
- Windows Weekly

**YouTube / creators**

- Fireship
- ThePrimeagen
- Dreams of Code
- TJ DeVries (Neovim audience; pitch the plugin/Lua angle)
- Brodie Robertson (Linux desktop)
- Chris Titus Tech (Windows/Linux tools)
- DistroTube (Linux tools)
- Machine Learning Street Talk (only if the angle is small software)

**Directories and communities**

- AlternativeTo
- Slant
- LibHunt
- StackShare
- Product Hunt
- Hacker News
- Lobsters
- Indie Hackers
- awesome-code-editors
- awesome-windows
- awesome-linux
- awesome-macos
- awesome-selfhosted (only if it fits the rules)

**Review sites and blogs**

- It's FOSS
- OMG! Ubuntu
- MakeUseOf
- Zapier blog
- Dev.to
- Hashnode
- Medium publications focused on developer tools

---

## 6. Content calendar

The site already has the pillar, the comparison cluster, the use-case
pages, and the benchmark page. Use this calendar to keep the cluster
growing without thin pages.

| Month | Content | Intent |
| --- | --- | --- |
| 1 | Refresh the homepage and pillar page after GSC query data | Head term |
| 1 | Publish “How to measure editor startup time” | Benchmark support |
| 2 | Publish “T Code vs VS Code for low-end laptops” | Comparison |
| 2 | Publish “Portable development on a USB drive” | Use case |
| 3 | Publish “Lite XL plugins that work in T Code” | Community |
| 3 | Publish “A 5 MB editor on a 4 GB laptop: one month later” | Experience |
| 4 | Refresh benchmark sizes with new releases | Link asset |
| 4 | Publish “What an Electron editor costs in RAM” | Data story |
| 5 | Publish “T Code for Python: what works, what doesn't” | Honest limitation |
| 5 | Publish “T Code for web development” | Use case |
| 6 | Refresh the best-editors listicle with new versions | Commercial |
| 6 | Publish a half-year benchmark update | Link asset |

Rules:

- One substantial page per month is better than ten thin pages.
- Every page needs a unique angle, screenshots or data, and internal links.
- Do not create a page for a keyword the product cannot satisfy.
- Update the `lastmod` date in `src/data/pages.js` when a page changes.

---

## 7. Backlink and PR plan

The head term will not move on content alone. Aim for 20–30 real editorial
links in the first six months.

1. **Launch the benchmark asset.** Pitch the “5 MB vs 286 MB” data to
   newsletters and blogs. Data is easier to cite than a product page.
2. **Get 5–10 honest reviews.** Offer review builds to creators who cover
   editors, Linux, Windows, or small software.
3. **Answer questions in public.** Reddit, Hacker News, Stack Overflow, and
   DEV threads about lightweight editors. Disclose that you built T Code.
4. **Submit to directories.** AlternativeTo, Slant, LibHunt, StackShare,
   and relevant awesome lists.
5. **Link from your own properties.** Personal site, GitHub profile README,
   DEV posts with canonical links, LinkedIn.
6. **Do not buy links, use PBNs, fake reviews, or comment spam.** The risk
   is a manual action that undoes months of work.

---

## 8. KPI targets

These are planning targets, not guarantees.

| Time | Target |
| --- | --- |
| Week 1 | Domain URL verified, sitemap submitted, 20+ pages indexed |
| Month 1 | 20–50 long-tail queries in top 100; first organic clicks |
| Month 3 | Top 10 for 5–15 long-tail terms; top 50 for the head term |
| Month 6 | Top 20 for the head term; top 3 for “T Code editor” and branded comparisons |
| Month 9–12 | Top 5–10 for the head term if links and brand demand compound |

If the target is immediate traffic rather than organic ranking, run Google
Ads on exact/phrase match. Ads are the only way to buy immediate position;
they do not replace organic ranking.

---

## 9. What not to do

- Do not create separate pages for “light weight,” “light-weight,” and
  “lightweight.” Google normalizes the variants.
- Do not keyword-stuff the H1, title, or body copy.
- Do not publish fake benchmark numbers or fake reviews.
- Do not add `aggregateRating` to schema without real ratings.
- Do not buy links or use link exchanges at scale.
- Do not mass-generate AI pages for every keyword permutation.
- Do not change the canonical host without a migration plan and redirects.
