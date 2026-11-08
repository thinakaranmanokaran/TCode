import { siteConfig } from "./site.js";

const abs = (path) => `${siteConfig.url}${path.startsWith("/") ? path : `/${path}`}`;

export const personSchema = {
  "@type": "Person",
  "@id": `${siteConfig.url}/#thinakaran`,
  name: siteConfig.author.name,
  alternateName: siteConfig.author.alternateName,
  jobTitle: "Full Stack Developer",
  description: siteConfig.author.bio,
  url: siteConfig.links.portfolio,
  image: abs(siteConfig.author.photo),
  sameAs: [
    siteConfig.links.githubProfile,
    siteConfig.links.linkedin,
    siteConfig.links.dev,
    siteConfig.links.portfolio,
  ],
  address: {
    "@type": "PostalAddress",
    addressLocality: "Thanjavur",
    addressRegion: "Tamil Nadu",
    addressCountry: "IN",
  },
  knowsAbout: siteConfig.author.skills,
};

export const websiteSchema = {
  "@type": "WebSite",
  "@id": `${siteConfig.url}/#website`,
  url: siteConfig.url,
  name: siteConfig.name,
  description: siteConfig.description,
  inLanguage: "en",
  publisher: { "@id": `${siteConfig.url}/#thinakaran` },
};

export const softwareSchema = {
  "@type": "SoftwareApplication",
  "@id": `${siteConfig.url}/#software`,
  name: siteConfig.name,
  description: siteConfig.description,
  applicationCategory: "DeveloperApplication",
  applicationSubCategory: "Code editor",
  operatingSystem: "Windows, macOS, Linux",
  softwareVersion: siteConfig.version,
  fileSize: "5.0MB",
  license: "https://opensource.org/licenses/MIT",
  offers: {
    "@type": "Offer",
    price: "0",
    priceCurrency: "USD",
  },
  downloadUrl: siteConfig.links.releases,
  screenshot: abs("/images/screenshots/editor.webp"),
  author: { "@id": `${siteConfig.url}/#thinakaran` },
  featureList: [
    "Integrated terminal with tabs and shell profiles",
    "Native menu bar and activity bar",
    "24 built-in themes with live preview",
    "Multi-cursor and column selection",
    "Portable mode",
    "Plugin compatibility",
  ],
};

export function webPageSchema({ title, description, path }) {
  return {
    "@type": "WebPage",
    "@id": abs(path),
    url: abs(path),
    name: title,
    description,
    inLanguage: "en",
    isPartOf: { "@id": `${siteConfig.url}/#website` },
    author: { "@id": `${siteConfig.url}/#thinakaran` },
    publisher: { "@id": `${siteConfig.url}/#thinakaran` },
  };
}

export function breadcrumbSchema(items) {
  return {
    "@type": "BreadcrumbList",
    itemListElement: items.map((item, index) => ({
      "@type": "ListItem",
      position: index + 1,
      name: item.name,
      item: abs(item.path),
    })),
  };
}

export function faqSchema(faqs) {
  return {
    "@type": "FAQPage",
    mainEntity: faqs.map((faq) => ({
      "@type": "Question",
      name: faq.question,
      acceptedAnswer: {
        "@type": "Answer",
        text: faq.answer,
      },
    })),
  };
}

export function articleSchema({ title, description, path, date, author = siteConfig.author.name }) {
  return {
    "@type": "BlogPosting",
    headline: title,
    description,
    url: abs(path),
    datePublished: date,
    dateModified: date,
    author: {
      "@type": "Person",
      name: author,
      url: siteConfig.links.portfolio,
    },
    publisher: {
      "@type": "Person",
      name: author,
      url: siteConfig.links.portfolio,
    },
    mainEntityOfPage: abs(path),
    image: abs("/images/og/default.png"),
  };
}

export function graphSchema(nodes) {
  return {
    "@context": "https://schema.org",
    "@graph": nodes,
  };
}
