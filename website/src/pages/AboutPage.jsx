import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { Lineage } from "../components/Lineage.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { Reveal } from "../components/Reveal.jsx";
import { siteConfig } from "../data/site.js";
import { assetPath } from "../data/base.js";
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  personSchema,
  breadcrumbSchema,
} from "../data/schema.js";

const schema = graphSchema([
  websiteSchema,
  softwareSchema,
  personSchema,
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "About", path: "/about" },
  ]),
]);

export function AboutPage() {
  return (
    <>
      <PageMeta
        title="About T Code — by Thinakaran Manokaran"
        description="Why T Code exists and what a small, fast, native code editor can do on Windows, Linux, and macOS."
        path="/about"
        keywords="About T Code, Thinakaran Manokaran, why lightweight editor, code editor story"
        imageAlt="About T Code by Thinakaran Manokaran"
      />
      <JsonLd data={schema} />

      <div className="dark-surface" style={{ background: "var(--ink)", color: "var(--paper)" }}>
        <PageHero
          dark
          eyebrow="About · the story"
          title={
            <>
              How T Code
              <br />
              got <em>here.</em>
            </>
          }
          sub="A small editor, a stubborn idea, and a developer who wanted the tools to get out of the way."
          meta={["Lightweight editor", "MIT licensed", "2026"]}
        />

        <section className="site-container" style={{ paddingBottom: 90 }}>
          <div className="prose" style={{ margin: "0 auto" }}>
            <Reveal>
              <p>
                T Code did not begin with a business plan. It began with a
                familiar annoyance: opening a code editor and waiting. Waiting
                for a browser runtime to boot. Waiting for an account to sync.
                Waiting for an update notification to finish deciding something.
              </p>
              <p>
                The editor I wanted had to prove that a code editor could be
                small, fast, and extensible without apologizing for it — and
                still ship the desktop workflow I used every day: a native menu
                bar, a proper activity bar, an integrated terminal, live theme
                previews, and the small Explorer actions that make a project feel
                finished.
              </p>
            </Reveal>

            <Reveal>
              <div className="story-quote">
                I wanted an editor that opens before I finish deciding
                <em> what to edit.</em>
              </div>
            </Reveal>

            <Reveal>
              <h2>Start with the core, not the chrome</h2>
              <p>
                T Code uses a compact architecture: a small C core for
                rendering, input, the filesystem, and the window; Lua for the
                editor, commands, and extensions. That decision is why the
                Windows binary is about <strong>5 MB</strong> and why the
                editor can start without a bundled browser.
              </p>
              <p>
                The new work sits on top. A VS Code-style menu bar and activity
                bar make every command discoverable. The integrated terminal
                runs a real PTY on POSIX and ConPTY on Windows. The theme picker
                previews 24 palettes live. The Explorer and tab context menus
                cover the actions that usually send you back to a terminal.
              </p>
              <h2>What “lightweight” actually means</h2>
              <p>
                Lightweight is not a number on a marketing page. It is the
                absence of a hundred small delays: the startup, the file open,
                the search, the terminal tab, the theme switch, the update
                prompt. It is also the absence of a browser process using a
                gigabyte of memory to draw text.
              </p>
              <p>
                T Code is not trying to be every editor. It is trying to be the
                editor you open when you want to work, not when you want to
                configure your editor.
              </p>
              <h2>Built in the open</h2>
              <p>
                T Code is released under the MIT license. The plugin API stays
                compatible, the color theme format stays a single Lua file, and
                the source stays readable. If you want to change something, you
                can.
              </p>
              <p>
                It is created and maintained by{" "}
                <Link to="/developer">Thinakaran Manokaran</Link>, a full-stack
                developer from Thanjavur, Tamil Nadu. You can follow the work on{" "}
                <a href={siteConfig.links.github} target="_blank" rel="noreferrer">
                  GitHub
                </a>{" "}
                and read the release history in the{" "}
                <Link to="/changelog">changelog</Link>.
              </p>
            </Reveal>
          </div>
        </section>

        <Lineage />

        <section className="site-container" style={{ padding: "90px 0" }}>
          <Reveal
            style={{
              display: "grid",
              gridTemplateColumns: "1fr 1fr",
              gap: 50,
              alignItems: "center",
            }}
            className="about-cta"
          >
            <div>
              <div className="eyebrow" style={{ color: "var(--lime)" }}>
                The person behind it
              </div>
              <h2 className="display" style={{ fontSize: "clamp(44px, 5vw, 74px)", marginTop: 18 }}>
                Hello, I&apos;m <em>Thinakaran.</em>
              </h2>
              <p style={{ marginTop: 22, color: "rgba(250,250,250,.66)", maxWidth: 520 }}>
                Also known as Dheena. I build web apps, mobile apps, and small
                tools that make everyday work feel lighter. T Code is the one I
                use every day.
              </p>
              <Link className="link-arrow" to="/developer" style={{ marginTop: 26 }}>
                Meet the developer <ArrowUpRight size={16} strokeWidth={1.6} />
              </Link>
            </div>
            <img
              src={assetPath(siteConfig.author.photo)}
              alt="Thinakaran Manokaran"
              width="400"
              height="400"
              loading="lazy"
              decoding="async"
              style={{
                width: "100%",
                maxWidth: 360,
                justifySelf: "end",
                borderRadius: "50%",
                filter: "grayscale(100%)",
              }}
            />
          </Reveal>
        </section>

        <SectionCta
          kicker="Try the result"
          title={
            <>
              Small software.
              <br />
              <em>Serious</em> workflow.
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
