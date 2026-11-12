// Build-time SEO guardrail. Run with `npm run seo:check` or as part of
// `npm run build`. It catches the mistakes that are easy to miss in review:
// missing metadata, duplicate canonicals, multiple H1s, sitemap/page drift,
// invalid JSON-LD, and canonical URLs that point at a redirect.

import { readdir, readFile } from "node:fs/promises";
import path from "node:path";
import { siteConfig } from "../src/data/site.js";

const dist = path.resolve(process.cwd(), "dist");
const errors = [];
const warnings = [];

const SKIP_DIRS = new Set([
  "assets",
  "fonts",
  "images",
  "brand",
  "static-loader-data",
  ".vite",
]);

async function walk(dir) {
  const entries = await readdir(dir, { withFileTypes: true });
  const files = [];
  for (const entry of entries) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      if (SKIP_DIRS.has(entry.name)) continue;
      files.push(...(await walk(full)));
    } else if (entry.name === "index.html") {
      files.push(full);
    }
  }
  return files;
}

function getMeta(html, key) {
  const tags = [...html.matchAll(/<meta\b[^>]*>/gi)].map((match) => match[0]);
  for (const tag of tags) {
    const name = tag.match(/\b(?:name|property)="([^"]+)"/i);
    const content = tag.match(/\bcontent="([^"]*)"/i);
    if (name && content && name[1].toLowerCase() === key.toLowerCase()) {
      return content[1];
    }
  }
  return null;
}

function getCanonical(html) {
  const links = [...html.matchAll(/<link\b[^>]*>/gi)].map((match) => match[0]);
  for (const link of links) {
    const rel = link.match(/\brel="([^"]+)"/i);
    const href = link.match(/\bhref="([^"]+)"/i);
    if (rel && href && rel[1].toLowerCase() === "canonical") return href[1];
  }
  return null;
}

function textContent(html) {
  return html
    .replace(/<script\b[\s\S]*?<\/script>/gi, " ")
    .replace(/<style\b[\s\S]*?<\/style>/gi, " ")
    .replace(/<[^>]+>/g, " ")
    .replace(/&[a-z#0-9]+;/gi, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function routeForFile(file) {
  const relative = path.relative(dist, file).replaceAll("\\", "/");
  if (relative === "index.html") return "/";
  return `/${relative.replace(/\/index\.html$/, "")}/`;
}

function fileForRoute(route) {
  if (route === "/") return path.join(dist, "index.html");
  return path.join(dist, route.replace(/^\/+/, ""), "index.html");
}

const files = await walk(dist);
const pages = [];

for (const file of files) {
  const html = await readFile(file, "utf8");
  const route = routeForFile(file);
  const title = (html.match(/<title[^>]*>([\s\S]*?)<\/title>/i) || [])[1]?.trim() || "";
  const description = getMeta(html, "description") || "";
  const canonical = getCanonical(html);
  const robots = getMeta(html, "robots") || "";
  const h1Count = (html.match(/<h1\b/gi) || []).length;
  const h2Count = (html.match(/<h2\b/gi) || []).length;
  const text = textContent(html);
  const wordCount = text ? text.split(" ").length : 0;

  pages.push({ file, route, title, description, canonical, robots, h1Count, h2Count, wordCount });

  if (!title) errors.push(`${route}: missing <title>`);
  if (title && title.length > 65) warnings.push(`${route}: title is ${title.length} chars (target <= 65)`);
  if (title && title.length < 20) warnings.push(`${route}: title is only ${title.length} chars`);

  if (!description) errors.push(`${route}: missing meta description`);
  if (description && description.length > 165) warnings.push(`${route}: description is ${description.length} chars (target <= 165)`);
  if (description && description.length < 70) warnings.push(`${route}: description is only ${description.length} chars`);

  if (!canonical) {
    errors.push(`${route}: missing canonical`);
  } else {
    if (!canonical.startsWith(siteConfig.url)) {
      errors.push(`${route}: canonical does not use siteConfig.url (${canonical})`);
    }
    if (!canonical.endsWith("/")) {
      errors.push(`${route}: canonical must end with a slash (${canonical})`);
    }
  }

  if (h1Count !== 1) errors.push(`${route}: expected exactly one H1, found ${h1Count}`);
  if (h2Count === 0 && route !== "/404/") warnings.push(`${route}: no H2 headings`);

  if (route !== "/404/" && /noindex/i.test(robots)) {
    errors.push(`${route}: noindex on an indexable page`);
  }

  const ogUrl = getMeta(html, "og:url");
  if (!getMeta(html, "og:title")) warnings.push(`${route}: missing og:title`);
  if (!getMeta(html, "og:description")) warnings.push(`${route}: missing og:description`);
  if (!getMeta(html, "og:image")) warnings.push(`${route}: missing og:image`);
  if (!ogUrl) {
    warnings.push(`${route}: missing og:url`);
  } else if (canonical && ogUrl !== canonical) {
    errors.push(`${route}: og:url does not match canonical`);
  }
  if (!getMeta(html, "twitter:card")) warnings.push(`${route}: missing twitter:card`);

  const jsonLdBlocks = [
    ...html.matchAll(/<script[^>]*type="application\/ld\+json"[^>]*>([\s\S]*?)<\/script>/gi),
  ];
  for (const [, block] of jsonLdBlocks) {
    try {
      JSON.parse(block);
    } catch {
      errors.push(`${route}: invalid JSON-LD block`);
    }
  }

  if (wordCount < 250 && route !== "/404/") {
    warnings.push(`${route}: only ${wordCount} words`);
  }
}

const home = pages.find((page) => page.route === "/");
if (home && !/lightweight code editor/i.test(home.title + " " + home.description + " " + home.canonical)) {
  errors.push(
    "/: homepage title, description, or canonical does not mention 'lightweight code editor'",
  );
}

for (const key of ["title", "description", "canonical"]) {
  const seen = new Map();
  for (const page of pages) {
    if (page.route === "/404/") continue;
    const value = page[key];
    if (!value) continue;
    if (seen.has(value)) {
      errors.push(`${page.route}: duplicate ${key} also used by ${seen.get(value)}`);
    } else {
      seen.set(value, page.route);
    }
  }
}

const sitemapPath = path.join(dist, "sitemap.xml");
let sitemapRoutes = new Set();
try {
  const sitemap = await readFile(sitemapPath, "utf8");
  const urlBlocks = [...sitemap.matchAll(/<url>([\s\S]*?)<\/url>/g)];
  for (const [, block] of urlBlocks) {
    const loc = (block.match(/<loc>([^<]+)<\/loc>/) || [])[1];
    const lastmod = (block.match(/<lastmod>([^<]+)<\/lastmod>/) || [])[1];
    if (!loc) {
      errors.push("sitemap: <url> without <loc>");
      continue;
    }
    if (!loc.endsWith("/")) errors.push(`sitemap: loc does not end with a slash (${loc})`);
    if (!lastmod) errors.push(`sitemap: missing lastmod for ${loc}`);
    if (!loc.startsWith(siteConfig.url)) {
      errors.push(`sitemap: loc does not use siteConfig.url (${loc})`);
      continue;
    }
    const route = loc.slice(siteConfig.url.length) || "/";
    sitemapRoutes.add(route);
    try {
      await readFile(fileForRoute(route), "utf8");
    } catch {
      errors.push(`sitemap: no built page for ${loc}`);
    }
  }
} catch {
  errors.push("sitemap.xml is missing");
}

const builtRoutes = new Set(
  pages.map((page) => page.route).filter((route) => route !== "/404/"),
);
for (const route of builtRoutes) {
  if (!sitemapRoutes.has(route)) errors.push(`sitemap: missing ${route}`);
}
for (const route of sitemapRoutes) {
  if (!builtRoutes.has(route)) errors.push(`sitemap: extra route ${route}`);
}

try {
  const robots = await readFile(path.join(dist, "robots.txt"), "utf8");
  if (!robots.includes(`Sitemap: ${siteConfig.url}/sitemap.xml`)) {
    errors.push("robots.txt: sitemap URL is missing");
  }
} catch {
  errors.push("robots.txt is missing");
}

try {
  const rootFiles = await readdir(dist);
  if (!rootFiles.some((name) => /^google.*\.html$/i.test(name))) {
    warnings.push("dist: no Google Search Console verification HTML file found");
  }
} catch {
  errors.push("dist directory is missing");
}

for (const warning of warnings) console.warn(`SEO warn: ${warning}`);
for (const error of errors) console.error(`SEO error: ${error}`);

console.log(
  `SEO check: ${pages.length} pages, ${sitemapRoutes.size} sitemap URLs, ${warnings.length} warnings, ${errors.length} errors`,
);

if (errors.length) process.exit(1);
