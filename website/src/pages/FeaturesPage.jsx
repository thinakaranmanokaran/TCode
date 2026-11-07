import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { FeatureShowcase } from "../components/FeatureShowcase.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { siteConfig } from "../data/site.js";
import { featureFacts } from "../data/features.js";
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  breadcrumbSchema,
} from "../data/schema.js";
import { Reveal } from "../components/Reveal.jsx";

const schema = graphSchema([
  websiteSchema,
  softwareSchema,
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "Features", path: "/features" },
  ]),
]);

export function FeaturesPage() {
  return (
    <>
      <PageMeta
        title="T Code Features — Terminal, Themes & Multi-Cursor"
        description="Explore T Code's native menu bar, integrated terminal, 24 built-in themes, multi-cursor editing, portable mode, and Lite XL plugin compatibility."
        path="/features"
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow="Features · 07"
        title={
          <>
            Everything you need.
            <br />
            Nothing you <em>don&apos;t.</em>
          </>
        }
        sub="T Code is a small editor with a serious workflow. These are the upgrades that turn a minimal core into a desktop editor you can live in."
        meta={["Integrated terminal", "Native menus", "24 themes", "5 MB"]}
        actions={
          <>
            <Link className="btn btn--blue" to="/download">
              Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
            </Link>
            <Link className="btn btn--outline" to="/themes">
              Browse themes
            </Link>
          </>
        }
      />

      <div className="site-container">
        <div
          style={{
            gap: 20,
            padding: "30px 0 70px",
            borderTop: "1px solid var(--line)",
          }}
          className="feature-facts"
        >
          {featureFacts.map((fact) => (
            <Reveal key={fact.label}>
              <div className="display" style={{ fontSize: "clamp(30px, 3vw, 44px)" }}>
                {fact.value}
              </div>
              <div className="eyebrow" style={{ marginTop: 8, color: "var(--muted)" }}>
                {fact.label}
              </div>
            </Reveal>
          ))}
        </div>
      </div>

      <FeatureShowcase heading={false} />

      <section className="content-section content-section--mist">
        <div className="site-container grid-2">
          <Reveal>
            <div className="eyebrow" style={{ color: "var(--electric)" }}>
              The philosophy
            </div>
            <h2 className="display content-section__title" style={{ marginTop: 18 }}>
              Small is not a compromise. It is the <em>feature.</em>
            </h2>
          </Reveal>
          <Reveal delay={80}>
            <p className="content-section__lead" style={{ marginTop: 0 }}>
              T Code keeps the parts that matter and removes the parts that get in
              the way. No browser engine. No account. No background service
              deciding when your editor should update.
            </p>
            <p className="content-section__lead">
              The result is an editor that opens instantly, stays out of your
              resource monitor, and still gives you a terminal, menus, themes,
              project search, and a plugin ecosystem.
            </p>
            <Link className="link-arrow" to="/about" style={{ marginTop: 20 }}>
              Why T Code exists <ArrowUpRight size={16} strokeWidth={1.6} />
            </Link>
          </Reveal>
        </div>
      </section>

      <SectionCta
        kicker="Ready when you are"
        title={
          <>
            Five megabytes.
            <br />
            <em>Zero excuses.</em>
          </>
        }
        actions={
          <>
            <Link className="btn btn--blue" to="/download">
              Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
            </Link>
            <a
              className="btn btn--paper"
              href={siteConfig.links.github}
              target="_blank"
              rel="noreferrer"
            >
              View on GitHub
            </a>
          </>
        }
      />
    </>
  );
}
