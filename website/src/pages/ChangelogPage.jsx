import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { Reveal } from "../components/Reveal.jsx";
import { releases } from "../data/changelog.js";
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  breadcrumbSchema,
} from "../data/schema.js";

const schema = graphSchema([
  websiteSchema,
  softwareSchema,
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "Changelog", path: "/changelog" },
  ]),
]);

export function ChangelogPage() {
  return (
    <>
      <PageMeta
        title="T Code Changelog — Release Notes & Updates"
        description="Every T Code release in one place: new features, fixes, terminal improvements, theme updates, and the Lite XL releases underneath the editor."
        path="/changelog"
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow="Changelog"
        title={
          <>
            Every release.
            <br />
            Every <em>fix.</em>
          </>
        }
        sub="T Code ships in public. This is the honest list of what changed, what broke, and what got better."
        meta={[`Current v${releases[0].version}`, "MIT licensed", "Open source"]}
      />

      <section className="site-container" style={{ paddingBottom: 100, maxWidth: 1040 }}>
        {releases.map((release, index) => (
          <Reveal
            key={release.label}
            style={{
              display: "grid",
              gridTemplateColumns: "220px 1fr",
              gap: 40,
              padding: "44px 0",
              borderTop: "1px solid var(--line)",
            }}
            className="release-row"
          >
            <div>
              <div className="display" style={{ fontSize: 44, lineHeight: 0.9 }}>
                {release.version}
              </div>
              <div
                className="eyebrow"
                style={{ marginTop: 14, color: "var(--muted)", letterSpacing: ".06em" }}
              >
                {release.date}
              </div>
              <div
                className="mono"
                style={{
                  display: "inline-block",
                  marginTop: 12,
                  padding: "4px 8px",
                  background: index === 0 ? "var(--electric)" : "var(--mist)",
                  color: index === 0 ? "var(--paper)" : "var(--muted)",
                  fontSize: 10,
                  letterSpacing: ".08em",
                  textTransform: "uppercase",
                }}
              >
                {release.tag}
              </div>
            </div>

            <div>
              <h2 style={{ margin: 0, fontSize: 20, fontWeight: 500 }}>
                {release.label}
              </h2>
              <p style={{ marginTop: 12, color: "var(--muted)", fontSize: 16 }}>
                {release.summary}
              </p>
              {release.groups.map((group) => (
                <div key={group.title} style={{ marginTop: 28 }}>
                  <div className="eyebrow" style={{ color: "var(--electric)" }}>
                    {group.title}
                  </div>
                  <ul
                    style={{
                      marginTop: 12,
                      paddingLeft: 18,
                      color: "var(--charcoal)",
                      fontSize: 15,
                      lineHeight: 1.75,
                    }}
                  >
                    {group.items.map((item) => (
                      <li key={item} style={{ marginTop: 6 }}>
                        {item}
                      </li>
                    ))}
                  </ul>
                </div>
              ))}
            </div>
          </Reveal>
        ))}
      </section>

      <SectionCta
        kicker="Stay current"
        title={
          <>
            The next release
            <br />
            is already <em>smaller.</em>
          </>
        }
        actions={
          <>
            <Link className="btn btn--blue" to="/download">
              Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
            </Link>
            <Link className="btn btn--paper" to="/faq">
              Read the FAQ
            </Link>
          </>
        }
      />
    </>
  );
}
