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
  breadcrumbSchema,
  articleSchema,
} from "../data/schema.js";

const schema = graphSchema([
  websiteSchema,
  softwareSchema,
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
  ["Plugin compatibility", "Lite XL API", "Lite XL API (mod-version 4)"],
  ["Windows binary", "About 5 MB", "About 5 MB"],
];

export function CompareLiteXLPage() {
  return (
    <>
      <PageMeta
        title="Lite XL vs T Code — What's New and Who Should Switch"
        description="T Code is built on Lite XL. Compare the interface, integrated terminal, themes, plugin compatibility, and performance to decide which editor fits your workflow."
        path="/compare/lite-xl-vs-t-code"
        type="article"
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow="Comparison · Lite XL vs T Code"
        title={
          <>
            Same core.
            <br />
            More <em>workflow.</em>
          </>
        }
        sub="T Code is a fork of Lite XL. The editor underneath is familiar; the desktop experience on top is not. Here is the honest difference."
        meta={["MIT licensed", "Same plugin API", "About 5 MB"]}
      />

      <section className="site-container" style={{ paddingBottom: 80 }}>
        <div className="prose" style={{ marginLeft: 0 }}>
          <p>
            Lite XL is the reason T Code exists. It is a small, fast, Lua-extensible
            editor with a dedicated community and a plugin ecosystem that has been
            growing for years. T Code does not replace that foundation; it builds
            a desktop workflow on top of it.
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

          <h2>What stays the same</h2>
          <p>
            The core architecture is the same: a C rendering and input layer, Lua
            for the editor, a single-file color theme format, and the Lite XL
            plugin API. If you already use Lite XL plugins, many of them will work
            in T Code without changes. If you already have a color theme, you can
            keep it.
          </p>

          <h2>What is different</h2>
          <p>
            T Code adds the parts of a desktop editor that Lite XL leaves to
            plugins or configuration: a native menu bar, a vertical activity bar,
            an integrated terminal with tabs and shell profiles, live theme
            previews, a Selection menu for multi-cursor work, and a much richer
            Explorer and tab context menu.
          </p>
          <p>
            The result is not a different editor philosophy. It is the same
            philosophy with fewer gaps between what you want to do and where the
            command lives.
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
            assembling them yourself — while keeping the same core, plugin API,
            and roughly the same footprint.
          </p>
          <p>
            You can read the <Link to="/blog/lite-xl-vs-t-code">longer comparison</Link>{" "}
            or go straight to the <Link to="/download">download page</Link>.
          </p>
        </div>
      </section>

      <SectionCta
        kicker="Try the fork"
        title={
          <>
            Keep the core.
            <br />
            <em>Upgrade</em> the workflow.
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
