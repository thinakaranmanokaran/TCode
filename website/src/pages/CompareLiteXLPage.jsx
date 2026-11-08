import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { siteConfig } from "../data/site.js";
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  personSchema,
  breadcrumbSchema,
  articleSchema,
} from "../data/schema.js";

const schema = graphSchema([
  websiteSchema,
  softwareSchema,
  personSchema,
  articleSchema({
    title: "Lite XL vs T Code: what's new and who should switch",
    description:
      "An honest comparison of Lite XL and T Code, including the interface, terminal, themes, plugin compatibility, and performance.",
    path: "/compare/lite-xl-vs-t-code",
    date: "2026-11-07",
  }),
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "Compare", path: "/compare/lite-xl-vs-t-code" },
    { name: "Lite XL vs T Code", path: "/compare/lite-xl-vs-t-code" },
  ]),
]);

const rows = [
  ["Base architecture", "C core + Lua", "C core + Lua"],
  ["License", "MIT", "MIT"],
  ["Menu bar", "Minimal / plugin-based", "Native File, Edit, Selection, View, Go, Run, Terminal, Help"],
  ["Activity bar", "Optional plugin", "Built in: Explorer, Search, Terminal, Commands, Settings"],
  ["Integrated terminal", "Plugin / external", "Built in with tabs and shell profiles"],
  ["Theme preview", "Select and apply", "Hover to preview, click to keep"],
  ["Explorer actions", "Core actions", "New, rename, delete, reveal, copy path, split, pin"],
  ["Plugin compatibility", "Mod-version 4 plugins", "Mod-version 4 plugins + built-in workflow"],
  ["Windows binary", "About 5 MB", "About 5 MB"],
];

export function CompareLiteXLPage() {
  return (
    <>
      <PageMeta
        title="Lite XL vs T Code — What's New and Who Should Switch"
        description="Compare Lite XL and T Code on interface, integrated terminal, themes, plugin compatibility, and performance to decide which editor fits your workflow."
        path="/compare/lite-xl-vs-t-code"
        type="article"
        publishedTime="2026-11-07"
        modifiedTime="2026-11-07"
        keywords="Lite XL vs T Code, lightweight editor comparison, C Lua editor"
        imageAlt="Lite XL vs T Code comparison"
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow="Comparison · Lite XL vs T Code"
        title={
          <>
            Two editors.
            <br />
            Different <em>priorities.</em>
          </>
        }
        sub="Lite XL and T Code are both small, fast, Lua-extensible editors. Here is how their workflows compare."
        meta={["MIT licensed", "Mod-version 4 plugins", "About 5 MB"]}
      />

      <section className="site-container" style={{ paddingBottom: 80 }}>
        <div className="prose" style={{ marginLeft: 0 }}>
          <p>
            Both Lite XL and T Code are small, fast, Lua-extensible editors
            with active plugin ecosystems. This page compared their desktop
            workflows side by side.
          </p>

          <table className="compare-table">
            <thead>
              <tr>
                <th>Feature</th>
                <th>Lite XL</th>
                <th>T Code</th>
              </tr>
            </thead>
            <tbody>
              {rows.map(([feature, litexl, tcode]) => (
                <tr key={feature}>
                  <td>{feature}</td>
                  <td>{litexl}</td>
                  <td>{tcode}</td>
                </tr>
              ))}
            </tbody>
          </table>

          <h2>Shared ground</h2>
          <p>
            Both use a C rendering and input layer with Lua for the editor, a
            single-file color theme format, and a mod-version 4 plugin API. If you
            use plugins and themes in one, many will work in the other without
            changes.
          </p>

          <h2>Where they differ</h2>
          <p>
            T Code ships with desktop workflow features included: a native menu
            bar, a vertical activity bar, an integrated terminal with tabs and
            shell profiles, live theme previews, a Selection menu for
            multi-cursor work, and Explorer and tab context menus.
          </p>
          <p>
            The result is a difference in defaults: one editor leans minimal and
            plugin-driven, the other ships the full desktop workflow in the box.
          </p>

          <h2>Which should you use?</h2>
          <p>
            Choose <strong>Lite XL</strong> if you want the smallest possible base,
            you already have a carefully tuned user module, or you prefer to build
            your workflow from plugins.
          </p>
          <p>
            Choose <strong>T Code</strong> if you want a native menu bar, an
            integrated terminal, a modern Explorer, and theme previews without
            assembling them yourself, in a similar 5 MB footprint.
          </p>
          <p>
            You can read the <Link to="/blog/lite-xl-vs-t-code">longer comparison</Link>{" "}
            or go straight to the <Link to="/download">download page</Link>.
          </p>
        </div>
      </section>

      <SectionCta
        kicker="Try T Code"
        title={
          <>
            Open it today.
            <br />
            <em>Feel</em> the workflow.
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
              View source
            </a>
          </>
        }
      />
    </>
  );
}
