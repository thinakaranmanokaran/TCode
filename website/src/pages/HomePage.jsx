import { Link } from "react-router-dom";
import { ArrowRight, ArrowUpRight, Mail } from "lucide-react";
import { GithubIcon } from "../components/BrandIcons.jsx";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { Reveal } from "../components/Reveal.jsx";
import { ArrowSketch } from "../components/ArrowSketch.jsx";
import { FeatureShowcase } from "../components/FeatureShowcase.jsx";
import { ThemeWall } from "../components/ThemeWall.jsx";
import { QuoteSection } from "../components/QuoteSection.jsx";
import { Lineage } from "../components/Lineage.jsx";
import { StatStrip } from "../components/StatStrip.jsx";
import { siteConfig } from "../data/site.js";
import { graphSchema, websiteSchema, softwareSchema, personSchema } from "../data/schema.js";

const schema = graphSchema([websiteSchema, softwareSchema, personSchema]);

export function HomePage() {
  return (
    <>
      <PageMeta
        title="T Code — The Lightweight Code Editor for Developers"
        description={siteConfig.description}
        path="/"
        keywords="lightweight code editor, T Code, free code editor, C Lua editor, integrated terminal, 24 themes"
        imageAlt="T Code lightweight code editor by Thinakaran Manokaran"
      />
      <JsonLd data={schema} />

      <section className="hero">
        <h1 className="display">
          I want to make coding feel <em>light</em> again.
        </h1>
        <p className="hero__lead">
          T Code is a free, open-source code editor built in C and Lua. Five megabytes.
          Instant startup. A terminal, native menus, and 24 themes — all in one window.
        </p>
        <div className="hero__meta">
          <span>Windows · macOS · Linux</span>
          <span>v{siteConfig.version} · {siteConfig.license}</span>
          <span>Built by Thinakaran Manokaran</span>
        </div>
        <div className="hero__scroll">Scroll to explore</div>
      </section>

      <section className="manifesto">
        <div className="manifesto__note">
          <div className="note-card">
            Don&apos;t you want
            <br />
            to <em>know more</em>
          </div>
          <ArrowSketch
            style={{ width: 70, height: 50, marginLeft: -4, marginTop: 8, color: "var(--paper)" }}
          />
        </div>
        <Reveal>
          <p className="manifesto__copy">
            I&apos;m <em>Thinakaran</em> — developer by trade, toolmaker by obsession.
            I built T Code because modern editors forgot what fast feels like.
          </p>
          <p className="manifesto__copy">
            Developing taught me constraints. Design taught me restraint. A good
            editor is where those two stop arguing and start removing everything
            that isn&apos;t your code.
          </p>
          <Link className="link-arrow manifesto__link" to="/about">
            Read the whole story <ArrowRight size={16} strokeWidth={1.6} />
          </Link>
          <div className="manifesto__caption">
            Thinakaran Manokaran · creator of T Code
          </div>
        </Reveal>
      </section>

      <StatStrip stats={siteConfig.stats} borderTop={false} />

      <FeatureShowcase />

      <ThemeWall />

      <QuoteSection />

      <Lineage />

      <section className="cta">
        <div className="site-container">
          <div className="cta__kicker">Still here?</div>
          <div className="cta__note" style={{ marginTop: 26 }}>
            <div className="note-card note-card--blue">I know you want to</div>
            <ArrowSketch
              flip
              style={{ width: 84, height: 54, marginLeft: -2, marginTop: 12 }}
            />
          </div>
          <h2 className="display cta__title">
            Make something <em>great.</em>
          </h2>
          <div className="cta__actions">
            <Link className="btn btn--dark" to="/download">
              Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
            </Link>
            <a
              className="btn btn--outline"
              href={siteConfig.links.github}
              target="_blank"
              rel="noreferrer"
            >
              <GithubIcon size={17} /> View source
            </a>
          </div>
          <div className="cta__links">
            <a href={`mailto:${siteConfig.links.email}`}>
              <Mail size={13} style={{ display: "inline", marginRight: 6 }} />
              Email
            </a>
            <a href={siteConfig.links.github} target="_blank" rel="noreferrer">
              GitHub
            </a>
            <a href={siteConfig.links.linkedin} target="_blank" rel="noreferrer">
              LinkedIn
            </a>
            <Link to="/developer">About the developer</Link>
          </div>
        </div>
      </section>
    </>
  );
}
