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
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  personSchema,
  organizationSchema,
} from "../data/schema.js";

const schema = graphSchema([
  websiteSchema,
  softwareSchema,
  personSchema,
  organizationSchema,
]);

const compareRows = [
  ["Download size", "About 5 MB", "Hundreds of MB", "About 5 MB"],
  ["Runtime", "C + Lua", "Electron + Chromium", "C + Lua"],
  ["Integrated terminal", "Built in", "Built in", "Plugin / external"],
  ["Menu bar", "Native", "Electron-rendered", "Minimal / plugin"],
  ["Themes", "24 built in", "Marketplace", "Themes / plugins"],
  ["License", "MIT", "Proprietary build", "MIT"],
];

export function HomePage() {
  return (
    <>
      <PageMeta
        title="T Code — Lightweight Code Editor for Windows, macOS & Linux"
        description={siteConfig.description}
        path="/"
        keywords="lightweight code editor, light weight code editor, T Code, free code editor, C Lua editor, portable code editor, integrated terminal, 24 themes"
        imageAlt="T Code lightweight code editor by Thinakaran Manokaran"
      />
      <JsonLd data={schema} />

      <section className="hero">
        <div className="hero__eyebrow">I want to make coding feel light again</div>
        <h1 className="display">
          The <em>lightweight</em> code editor that gets out of your way.
        </h1>
        <p className="hero__lead">
          T Code is a free, open-source lightweight code editor for Windows, macOS,
          and Linux. About 5 MB, instant startup, a real terminal, native menus, and
          24 themes — without Electron or a bundled browser.
        </p>
        <div className="hero__actions">
          <Link className="btn btn--blue" to="/download">
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
        <div className="hero__meta">
          <span>Windows · macOS · Linux</span>
          <span>v{siteConfig.version} · {siteConfig.license}</span>
          <span>Built by Thinakaran Manokaran</span>
        </div>
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

      <section
        className="content-section content-section--mist"
        id="what-is-a-lightweight-code-editor"
      >
        <div className="site-container">
          <div className="grid-2">
            <Reveal>
              <div className="eyebrow" style={{ color: "var(--electric)" }}>
                The definition
              </div>
              <h2 className="display content-section__title">
                What is a <em>lightweight</em> code editor?
              </h2>
            </Reveal>
            <Reveal delay={80}>
              <p className="content-section__lead" style={{ marginTop: 0 }}>
                A lightweight code editor starts quickly, uses very little disk
                space and memory, and avoids bundling a browser runtime. It is
                not just a file size: it is the combination of startup time,
                memory use, dependency count, and how much of the editor stays
                out of your way.
              </p>
              <p className="content-section__lead">
                T Code is about 5 MB on Windows. It pairs a small C core for
                rendering and input with Lua for the editor and plugins. There
                is no Electron runtime, no bundled browser, and no account to
                create.
              </p>
              <h3
                className="display"
                style={{ fontSize: "clamp(28px, 3vw, 40px)", marginTop: 30 }}
              >
                Who it&apos;s <em>for.</em>
              </h3>
              <ul className="content-section__list">
                <li>Older laptops and low-RAM machines that struggle with Electron editors.</li>
                <li>Portable setups where the editor and settings live on a USB drive.</li>
                <li>Developers who want a fast local editor with a terminal and project search.</li>
                <li>Lite XL users who want the same core with a more complete desktop workflow.</li>
              </ul>
            </Reveal>
          </div>

          <Reveal>
            <h2 className="display content-section__title" style={{ marginTop: 70 }}>
              A different <em>weight class.</em>
            </h2>
            <table className="compare-table">
              <thead>
                <tr>
                  <th>Dimension</th>
                  <th>T Code</th>
                  <th>VS Code</th>
                  <th>Lite XL</th>
                </tr>
              </thead>
              <tbody>
                {compareRows.map(([dimension, tcode, vscode, litexl]) => (
                  <tr key={dimension}>
                    <td>{dimension}</td>
                    <td>{tcode}</td>
                    <td>{vscode}</td>
                    <td>{litexl}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            <p style={{ marginTop: 24, color: "var(--muted)", fontSize: 14 }}>
              Sizes are approximate and vary by platform and build. T Code and
              Lite XL use a C and Lua core; VS Code ships an Electron runtime.
            </p>
            <div
              style={{
                display: "flex",
                flexWrap: "wrap",
                gap: 18,
                marginTop: 28,
              }}
            >
              <Link className="link-arrow" to="/lightweight-code-editor">
                Read the full lightweight editor guide{" "}
                <ArrowRight size={16} strokeWidth={1.6} />
              </Link>
              <Link className="link-arrow" to="/best/lightweight-code-editors">
                Best lightweight editors <ArrowRight size={16} strokeWidth={1.6} />
              </Link>
              <Link className="link-arrow" to="/benchmarks">
                Benchmark method <ArrowRight size={16} strokeWidth={1.6} />
              </Link>
            </div>
          </Reveal>
        </div>
      </section>

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
