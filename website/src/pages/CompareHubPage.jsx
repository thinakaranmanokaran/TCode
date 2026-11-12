import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { comparisonLinks } from "../data/comparisons.js";
import { siteConfig } from "../data/site.js";
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  personSchema,
  breadcrumbSchema,
  webPageSchema,
} from "../data/schema.js";

const schema = graphSchema([
  websiteSchema,
  softwareSchema,
  personSchema,
  webPageSchema({
    title: "Compare Lightweight Code Editors",
    description:
      "Honest comparisons of T Code with VS Code, Lite XL, Sublime Text, Notepad++, Zed, Vim/Neovim, and CodeEdit.",
    path: "/compare",
  }),
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "Compare", path: "/compare" },
  ]),
  {
    "@type": "ItemList",
    name: "Code editor comparisons",
    numberOfItems: comparisonLinks.length,
    itemListElement: comparisonLinks.map((item, index) => ({
      "@type": "ListItem",
      position: index + 1,
      name: item.title,
      url: `${siteConfig.url}${item.path}/`,
    })),
  },
]);

export function CompareHubPage() {
  return (
    <>
      <PageMeta
        title="Compare Lightweight Code Editors — T Code"
        description="Honest comparisons of T Code with VS Code, Lite XL, Sublime Text, Notepad++, Zed, Vim/Neovim, and CodeEdit."
        path="/compare"
        keywords="compare code editors, T Code vs, lightweight editor comparison"
        imageAlt="Compare lightweight code editors"
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow="Compare · editors"
        title={
          <>
            Different editors.
            <br />
            Different <em>trade-offs.</em>
          </>
        }
        sub="No editor wins every category. These comparisons explain where each alternative is stronger, where T Code is stronger, and who should choose which."
        meta={[`${comparisonLinks.length} comparisons`, "Honest trade-offs", "Updated 2026"]}
        actions={
          <Link className="btn btn--blue" to="/download">
            Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
          </Link>
        }
      />

      <section className="site-container" style={{ paddingBottom: 100 }}>
        <div className="blog-grid">
          {comparisonLinks.map((item) => (
            <Link className="blog-card" to={item.path} key={item.path}>
              <div className="blog-card__meta">
                <span>Comparison</span>
                <span>T Code</span>
              </div>
              <h2 className="blog-card__title">{item.title}</h2>
              <p className="blog-card__desc">{item.description}</p>
              <div className="blog-card__more">
                Read comparison{" "}
                <ArrowUpRight size={14} strokeWidth={1.6} style={{ display: "inline" }} />
              </div>
            </Link>
          ))}
        </div>

        <div
          style={{
            marginTop: 50,
            paddingTop: 30,
            borderTop: "1px solid var(--line)",
            display: "flex",
            flexWrap: "wrap",
            gap: 16,
          }}
        >
          <Link className="link-arrow" to="/lightweight-code-editor">
            What is a lightweight code editor? <ArrowUpRight size={16} strokeWidth={1.6} />
          </Link>
          <Link className="link-arrow" to="/best/lightweight-code-editors">
            Best lightweight editors in 2026 <ArrowUpRight size={16} strokeWidth={1.6} />
          </Link>
          <Link className="link-arrow" to="/benchmarks">
            Benchmark method and sizes <ArrowUpRight size={16} strokeWidth={1.6} />
          </Link>
        </div>
      </section>

      <SectionCta
        kicker="Pick your weight"
        title={
          <>
            Compare less.
            <br />
            <em>Build</em> more.
          </>
        }
        actions={
          <>
            <Link className="btn btn--blue" to="/download">
              Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
            </Link>
            <Link className="btn btn--paper" to="/features">
              Explore features
            </Link>
          </>
        }
      />
    </>
  );
}
