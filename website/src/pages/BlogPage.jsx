import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { blogPosts } from "../data/pages.js";
import {
  graphSchema,
  websiteSchema,
  breadcrumbSchema,
  articleSchema,
} from "../data/schema.js";

const schema = graphSchema([
  websiteSchema,
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "Blog", path: "/blog" },
  ]),
  ...blogPosts.map((post) =>
    articleSchema({
      title: post.title,
      description: post.description,
      path: `/blog/${post.slug}`,
      date: post.date,
    }),
  ),
]);

export function BlogPage() {
  return (
    <>
      <PageMeta
        title="T Code Blog — Lightweight Editing, Builds, and Comparisons"
        description="Notes on lightweight code editors, T Code releases, building from source, and honest comparisons with Lite XL and VS Code."
        path="/blog"
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow="Writing"
        title={
          <>
            Notes on small
            <br />
            software that <em>works.</em>
          </>
        }
        sub="Essays, build guides, and honest comparisons from the making of T Code."
        meta={["3 articles", "Updated 2026", "No fluff"]}
      />

      <section className="site-container" style={{ paddingBottom: 100 }}>
        <div className="blog-grid">
          {blogPosts.map((post) => (
            <Link className="blog-card" to={`/blog/${post.slug}`} key={post.slug}>
              <div className="blog-card__meta">
                <span>{post.category}</span>
                <span>{post.readTime}</span>
              </div>
              <h2 className="blog-card__title">{post.title}</h2>
              <p className="blog-card__desc">{post.description}</p>
              <div className="blog-card__more">
                Read article <ArrowUpRight size={14} strokeWidth={1.6} style={{ display: "inline" }} />
              </div>
            </Link>
          ))}
        </div>
      </section>

      <SectionCta
        kicker="More coming"
        title={
          <>
            Small software.
            <br />
            <em>Long-form</em> thinking.
          </>
        }
        actions={
          <Link className="btn btn--blue" to="/download">
            Try T Code <ArrowUpRight size={17} strokeWidth={1.6} />
          </Link>
        }
      />
    </>
  );
}
