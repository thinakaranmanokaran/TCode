import { Head } from "vite-react-ssg";
import { siteConfig } from "../data/site.js";

export function PageMeta({
  title,
  description,
  path = "/",
  image = "/images/og/default.png",
  imageAlt,
  type = "website",
  keywords,
  noindex = false,
  publishedTime,
  modifiedTime,
}) {
  const canonical = `${siteConfig.url}${path === "/" ? "/" : path}`;
  const socialImage = image.startsWith("http") ? image : `${siteConfig.url}${image}`;

  return (
    <Head>
      <title>{title}</title>
      <meta name="description" content={description} />
      <meta name="author" content={siteConfig.author.name} />
      {keywords ? <meta name="keywords" content={keywords} /> : null}
      <meta name="theme-color" content="#fafafa" />
      <meta
        name="robots"
        content={noindex ? "noindex,nofollow" : "index,follow,max-image-preview:large"}
      />
      <link rel="canonical" href={canonical} />
      <link rel="alternate" type="application/rss+xml" title="T Code Blog" href={`${siteConfig.url}/rss.xml`} />

      <meta property="og:type" content={type} />
      <meta property="og:site_name" content={siteConfig.name} />
      <meta property="og:title" content={title} />
      <meta property="og:description" content={description} />
      <meta property="og:url" content={canonical} />
      <meta property="og:image" content={socialImage} />
      <meta property="og:image:width" content="1200" />
      <meta property="og:image:height" content="630" />
      {imageAlt ? <meta property="og:image:alt" content={imageAlt} /> : null}
      <meta property="og:locale" content="en_US" />
      {publishedTime ? (
        <meta property="article:published_time" content={publishedTime} />
      ) : null}
      {modifiedTime ? (
        <meta property="article:modified_time" content={modifiedTime} />
      ) : null}
      {type === "article" ? (
        <meta property="article:author" content={siteConfig.author.name} />
      ) : null}

      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:title" content={title} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={socialImage} />
      {imageAlt ? <meta name="twitter:image:alt" content={imageAlt} /> : null}
      <meta name="twitter:creator" content="@thinakaran" />
    </Head>
  );
}
