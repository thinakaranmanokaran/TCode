export const sitemapPages = [
  { path: "/", priority: "1.0", changefreq: "weekly" },
  { path: "/features", priority: "0.9", changefreq: "monthly" },
  { path: "/themes", priority: "0.9", changefreq: "monthly" },
  { path: "/download", priority: "0.9", changefreq: "weekly" },
  { path: "/about", priority: "0.8", changefreq: "monthly" },
  { path: "/developer", priority: "0.8", changefreq: "monthly" },
  { path: "/changelog", priority: "0.7", changefreq: "weekly" },
  { path: "/faq", priority: "0.7", changefreq: "monthly" },
  { path: "/compare/lite-xl-vs-t-code", priority: "0.7", changefreq: "monthly" },
  { path: "/compare/vs-code-vs-t-code", priority: "0.7", changefreq: "monthly" },
  { path: "/blog", priority: "0.6", changefreq: "weekly" },
  { path: "/blog/why-lightweight-editors-still-matter", priority: "0.6", changefreq: "yearly" },
  { path: "/blog/lite-xl-vs-t-code", priority: "0.6", changefreq: "yearly" },
  { path: "/blog/build-t-code-from-source", priority: "0.6", changefreq: "yearly" },
  { path: "/license", priority: "0.3", changefreq: "yearly" },
  { path: "/privacy", priority: "0.3", changefreq: "yearly" },
];

export const blogPosts = [
  {
    slug: "why-lightweight-editors-still-matter",
    title: "Why lightweight code editors still matter",
    description:
      "Fast software is not nostalgia. It is a practical advantage for developers working on older laptops, large projects, and long days.",
    date: "2026-11-07",
    readTime: "6 min read",
    category: "Craft",
  },
  {
    slug: "lite-xl-vs-t-code",
    title: "Lite XL vs T Code: what's new and who should switch",
    description:
      "Compare Lite XL and T Code on features, workflow, and footprint to decide which editor fits your workflow.",
    date: "2026-11-07",
    readTime: "7 min read",
    category: "Comparison",
  },
  {
    slug: "build-t-code-from-source",
    title: "How to build T Code from source",
    description:
      "A practical build guide for Windows, Linux, and macOS, including the dependencies, Meson commands, and the repo layout.",
    date: "2026-11-07",
    readTime: "8 min read",
    category: "Guide",
  },
];
