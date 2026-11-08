import { useState } from "react";
import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { ThemeCard } from "../components/ThemeMini.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { themes } from "../data/themes.js";
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  personSchema,
  breadcrumbSchema,
} from "../data/schema.js";

const groups = ["All", "Bearded", "Monokai", "Classic"];

const itemList = {
  "@type": "ItemList",
  name: "T Code built-in themes",
  numberOfItems: themes.length,
  itemListElement: themes.map((theme, index) => ({
    "@type": "ListItem",
    position: index + 1,
    name: theme.name,
  })),
};

const schema = graphSchema([
  websiteSchema,
  softwareSchema,
  personSchema,
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "Themes", path: "/themes" },
  ]),
  itemList,
]);

export function ThemesPage() {
  const [filter, setFilter] = useState("All");
  const visible = filter === "All" ? themes : themes.filter((theme) => theme.group === filter);

  return (
    <>
      <PageMeta
        title="T Code Themes — 24 Built-in Light & Dark Themes"
        description="Browse all 24 themes bundled with T Code: 10 Bearded Theme variations, 10 Monokai variations, plus Default, Fall, Summer, and Textadept."
        path="/themes"
        keywords="T Code themes, Bearded Theme, Monokai themes, dark themes, light themes, code editor themes"
        imageAlt="T Code 24 built-in themes"
      />
      <JsonLd data={schema} />

      <div className="dark-surface" style={{ background: "var(--ink)", color: "var(--paper)" }}>
        <PageHero
          dark
          eyebrow="Themes · 24"
          title={
            <>
              A theme for every
              <br />
              kind of <em>tired.</em>
            </>
          }
          sub="Ten Bearded variations. Ten Monokai variations. Four classics. Hover to preview, click to keep, and T Code remembers your choice."
          meta={["24 bundled", "Live preview", "No plugins required"]}
          actions={
            <Link className="btn btn--blue" to="/download">
              Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
            </Link>
          }
        />

        <section className="site-container" style={{ paddingBottom: 100 }}>
          <div className="theme-filters" aria-label="Filter themes">
            {groups.map((group) => (
              <button
                key={group}
                type="button"
                className={`theme-filter ${filter === group ? "is-active" : ""}`}
                onClick={() => setFilter(group)}
                aria-pressed={filter === group}
              >
                {group}
              </button>
            ))}
            <span
              className="mono"
              style={{
                marginLeft: "auto",
                alignSelf: "center",
                color: "rgba(250,250,250,.62)",
                fontSize: 12,
              }}
            >
              {visible.length} themes
            </span>
          </div>

          <div className="theme-page-grid">
            {visible.map((theme) => (
              <ThemeCard key={theme.slug} theme={theme} />
            ))}
          </div>

          <div
            style={{
              marginTop: 50,
              paddingTop: 30,
              borderTop: "1px solid var(--line-dark)",
              display: "grid",
              gridTemplateColumns: "1fr 1fr",
              gap: 40,
            }}
            className="theme-copy"
          >
            <p style={{ color: "rgba(250,250,250,.66)", fontSize: 17, lineHeight: 1.7 }}>
              Every bundled theme is a complete editor palette, not a color
              filter. Menus, dividers, selections, line numbers, and syntax
              colors all come from the same hand-tuned palette.
            </p>
            <p style={{ color: "rgba(250,250,250,.66)", fontSize: 17, lineHeight: 1.7 }}>
              You can also drop in any color theme. The format is a
              single Lua file, which means a new theme takes minutes, not a
              release cycle.
            </p>
          </div>
        </section>

        <SectionCta
          kicker="Pick a favorite"
          title={
            <>
              Your eyes will
              <br />
              <em>thank you.</em>
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
      </div>
    </>
  );
}
