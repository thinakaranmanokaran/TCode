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
    title: "VS Code vs T Code: which lightweight editor should you use?",
    description:
      "A factual comparison of VS Code and T Code covering size, runtime, extensions, terminal, debugging, and performance.",
    path: "/compare/vs-code-vs-t-code",
    date: "2026-11-07",
  }),
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "Compare", path: "/compare/vs-code-vs-t-code" },
    { name: "VS Code vs T Code", path: "/compare/vs-code-vs-t-code" },
  ]),
]);

const rows = [
  ["Download size", "Hundreds of MB", "About 5 MB"],
  ["Runtime", "Electron + Chromium + Node", "C + Lua, no browser runtime"],
  ["Startup", "Fast on modern hardware", "Designed to open instantly"],
  ["Extensions", "Huge marketplace", "Plugins and themes"],
  ["Language support", "Extensive via extensions", "Lua-based syntax and plugin modules"],
  ["Integrated terminal", "Yes", "Yes, with tabs and profiles"],
  ["Debugging", "First-class debugger", "Limited / via plugins"],
  ["Remote development", "First-class", "Not a focus"],
  ["Price", "Free (proprietary build)", "Free and open source (MIT)"],
  ["Best for", "Large teams, debugging, remote work", "Fast local editing, small projects, low-end hardware"],
];

export function CompareVSCodePage() {
  return (
    <>
      <PageMeta
        title="VS Code vs T Code — Lightweight Editor Comparison"
        description="Compare VS Code and T Code: download size, runtime, startup, terminal, extensions, debugging, and which editor fits your workflow."
        path="/compare/vs-code-vs-t-code"
        type="article"
        publishedTime="2026-11-07"
        modifiedTime="2026-11-07"
        keywords="VS Code vs T Code, lightweight editor comparison, Electron vs C Lua editor"
        imageAlt="VS Code vs T Code comparison"
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow="Comparison · VS Code vs T Code"
        title={
          <>
            VS Code vs T Code:
            <br />
            a <em>lightweight</em> comparison.
          </>
        }
        sub="VS Code is a platform. T Code is an editor. That distinction explains almost every difference below."
        meta={["5 MB vs hundreds", "No Electron", "MIT licensed"]}
      />

      <section className="site-container" style={{ paddingBottom: 80 }}>
        <div className="prose" style={{ marginLeft: 0 }}>
          <p>
            This is not a “VS Code killer” argument. VS Code is excellent at what
            it does: a huge extension marketplace, debugging, remote development,
            notebooks, and a workflow that scales across large teams. T Code is
            trying to do something narrower: be a fast, native desktop editor that
            opens instantly and stays out of the way.
          </p>

          <table className="compare-table">
            <thead>
              <tr>
                <th>Dimension</th>
                <th>VS Code</th>
                <th>T Code</th>
              </tr>
            </thead>
            <tbody>
              {rows.map(([feature, vscode, tcode]) => (
                <tr key={feature}>
                  <td>{feature}</td>
                  <td>{vscode}</td>
                  <td>{tcode}</td>
                </tr>
              ))}
            </tbody>
          </table>

          <h2>Where T Code wins</h2>
          <p>
            T Code wins on weight, startup, and simplicity. There is no Electron
            runtime, no browser process, and no extension host competing for
            memory. The download is about 5 MB. The editor is designed to open
            before you finish deciding what to edit.
          </p>
          <p>
            It also wins on focus. If you mostly edit local files, open a terminal,
            search a project, and switch themes, T Code gives you those actions
            without a marketplace, an account, or a settings maze.
          </p>

          <h2>Where VS Code wins</h2>
          <p>
            VS Code wins on ecosystem depth. If you need a debugger for a specific
            runtime, remote containers, Jupyter notebooks, language servers for
            every language, or a large team-standardized setup, VS Code is the
            safer choice.
          </p>
          <p>
            T Code supports third-party plugins, but that is a smaller ecosystem
            than the VS Code marketplace. It is enough for many editing
            workflows; it is not a replacement for every extension.
          </p>

          <h2>The practical answer</h2>
          <p>
            Use VS Code when your work depends on its extension ecosystem, debugging,
            or remote development. Use T Code when you want a fast local editor
            that launches instantly, handles a terminal and project search, and
            does not need a browser engine to draw a text buffer.
          </p>
          <p>
            You can also use both. A small editor for quick edits and a larger IDE
            for heavy projects is not a contradiction.
          </p>
          <p>
            Read the <Link to="/features">feature breakdown</Link> or{" "}
            <Link to="/download">download T Code</Link> and decide for yourself.
          </p>
        </div>
      </section>

      <SectionCta
        kicker="Pick your weight"
        title={
          <>
            Fast local editing.
            <br />
            <em>Five megabytes.</em>
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
