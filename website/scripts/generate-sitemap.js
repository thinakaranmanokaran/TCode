import { copyFile, mkdir, writeFile } from "node:fs/promises";
import path from "node:path";
import { siteConfig } from "../src/data/site.js";
import { sitemapPages, blogPosts } from "../src/data/pages.js";

const dist = path.resolve(process.cwd(), "dist");

const pages = [
  ...sitemapPages,
  ...blogPosts.map((post) => ({
    path: `/blog/${post.slug}`,
    priority: "0.6",
    changefreq: "yearly",
    lastmod: post.updated || post.date,
  })),
];

const urls = pages
  .map((page) => {
    const loc = `${siteConfig.url}${
      page.path === "/" ? "/" : `${page.path.replace(/\/+$/, "")}/`
    }`;
    const lastmod = page.lastmod ? `\n    <lastmod>${page.lastmod}</lastmod>` : "";
    return `  <url>
    <loc>${loc}</loc>${lastmod}
    <changefreq>${page.changefreq}</changefreq>
    <priority>${page.priority}</priority>
  </url>`;
  })
  .join("\n");

const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls}
</urlset>
`;

const robots = `User-agent: *
Allow: /

Sitemap: ${siteConfig.url}/sitemap.xml
`;

await mkdir(dist, { recursive: true });
const rssItems = blogPosts
  .map(
    (post) => `    <item>
      <title><![CDATA[${post.title}]]></title>
      <link>${siteConfig.url}/blog/${post.slug}/</link>
      <guid isPermaLink="true">${siteConfig.url}/blog/${post.slug}/</guid>
      <description><![CDATA[${post.description}]]></description>
      <pubDate>${new Date(`${post.date}T09:00:00+05:30`).toUTCString()}</pubDate>
    </item>`,
  )
  .join("\n");

const rss = `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>T Code Blog</title>
    <link>${siteConfig.url}/blog/</link>
    <description>Notes on lightweight code editors, T Code releases, and building small software.</description>
    <language>en</language>
    <lastBuildDate>${new Date().toUTCString()}</lastBuildDate>
${rssItems}
  </channel>
</rss>
`;

await writeFile(path.join(dist, "sitemap.xml"), sitemap, "utf8");
await writeFile(path.join(dist, "rss.xml"), rss, "utf8");
await writeFile(path.join(dist, "robots.txt"), robots, "utf8");

try {
  await copyFile(path.join(dist, "404", "index.html"), path.join(dist, "404.html"));
  console.log("copied 404.html");
} catch {
  console.warn("404 page was not generated; skipping 404.html copy");
}

console.log(`wrote sitemap with ${pages.length} URLs`);
