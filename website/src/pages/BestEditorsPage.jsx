import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  personSchema,
  breadcrumbSchema,
  webPageSchema,
  faqSchema,
} from "../data/schema.js";

const editors = [
  {
    rank: "01",
    name: "T Code",
    label: "Best overall tiny editor with a terminal",
    url: "/download",
    internal: true,
    description:
      "T Code is a free, MIT-licensed editor built on a C core and Lua. It is the smallest editor in this list that ships a native menu bar, an integrated terminal with tabs and shell profiles, project search, multi-cursor editing, and 24 themes out of the box.",
    footprint:
      "About 2.6 MB Windows portable zip; about 4.7 MB executable. No Electron, no bundled browser.",
    pros: [
      "Very small download and predictable memory use",
      "Integrated terminal, native menus, and 24 themes included",
      "Free, open source, and compatible with mod-version 4 Lua plugins",
      "Portable mode keeps settings and plugins in one folder",
    ],
    cons: [
      "Smaller plugin ecosystem than Sublime Text or VS Code",
      "Not a full IDE: no first-class debugger or remote containers",
    ],
    bestFor:
      "Developers who want a fast local editor with a terminal and a tiny footprint on Windows, macOS, or Linux.",
  },
  {
    rank: "02",
    name: "Sublime Text",
    label: "Best polished paid editor",
    url: "https://www.sublimetext.com/",
    description:
      "Sublime Text is a mature, native editor with exceptional editing performance, a command palette, Goto Anything, split panes, and a deep package ecosystem. It remains one of the best examples of a fast editor that feels finished.",
    footprint:
      "About 22 MB Windows installer (Build 4215). Native C++ core; no browser runtime.",
    pros: [
      "Extremely polished editing and keyboard workflows",
      "Large Package Control ecosystem",
      "Fast and mature on Windows, macOS, and Linux",
    ],
    cons: [
      "Proprietary and paid; free evaluation",
      "No built-in terminal; terminal support comes from packages",
    ],
    bestFor:
      "Professional developers who value a mature package ecosystem and are happy to pay for a polished editor.",
  },
  {
    rank: "03",
    name: "Lite XL",
    label: "Best minimal Lua editor",
    url: "https://lite-xl.github.io/",
    description:
      "Lite XL is the closest relative to T Code: a small C and Lua editor with a mod-version 4 plugin API and a strong minimalism. It is an excellent choice if you want the smallest possible base and you enjoy assembling your workflow from plugins.",
    footprint:
      "About 2.3 MB Windows x86_64 zip (v2.1.8). No Electron; C and Lua core.",
    pros: [
      "Extremely small and fast",
      "Clean, minimal core with Lua extensibility",
      "Cross-platform and MIT licensed",
    ],
    cons: [
      "Less desktop workflow out of the box: menus, terminal, and Explorer are more plugin-driven",
      "You will spend more time configuring your setup",
    ],
    bestFor:
      "Developers who want the smallest possible base and do not mind building their own workflow.",
  },
  {
    rank: "04",
    name: "Notepad++",
    label: "Best Windows quick-edit editor",
    url: "https://notepad-plus-plus.org/",
    description:
      "Notepad++ is a Windows institution. It is small, fast, native, and excellent for quick edits, macros, file comparison, and everyday text work. Its plugin ecosystem is built around the things Windows users actually do.",
    footprint:
      "About 7 MB Windows installer; about 8.4 MB portable zip (v8.9.9.1).",
    pros: [
      "Very fast and familiar on Windows",
      "Mature plugin ecosystem",
      "Excellent for quick edits and large text files",
    ],
    cons: [
      "Windows only",
      "No built-in terminal; interface feels dated",
    ],
    bestFor:
      "Windows users who want a familiar, tiny editor for quick edits, macros, and file comparison.",
  },
  {
    rank: "05",
    name: "Neovim",
    label: "Best terminal-native editor",
    url: "https://neovim.io/",
    description:
      "Neovim is a modern fork of Vim with Lua configuration, built-in LSP support, and a terminal-first workflow. It is incredibly efficient once the modal editing model becomes muscle memory, and it runs almost anywhere.",
    footprint:
      "About 12.6 MB Windows zip (v0.12.6). The editor itself is small; plugins and language servers add to the footprint.",
    pros: [
      "Runs over SSH, in containers, and on servers",
      "Huge plugin ecosystem and Lua configuration",
      "Keyboard-first workflow with excellent composability",
    ],
    cons: [
      "Steep learning curve",
      "Not a GUI editor by default; you configure the experience",
    ],
    bestFor:
      "Developers who work in a terminal, use SSH regularly, and have invested in modal editing.",
  },
  {
    rank: "06",
    name: "Zed",
    label: "Best modern AI and collaboration editor",
    url: "https://zed.dev/",
    description:
      "Zed is a GPU-accelerated editor written in Rust, with a built-in terminal, language server support, collaborative editing, and optional AI features. It is one of the most credible modern alternatives to VS Code for teams that want a native feel.",
    footprint:
      "About 91 MB Linux x86_64 archive (v1.28.1). Native Rust and GPUI; no Electron.",
    pros: [
      "Fast GPU-accelerated interface",
      "AI and collaboration built into the product",
      "Modern native architecture with LSP support",
    ],
    cons: [
      "Much larger than a 5 MB editor",
      "Windows is not the primary desktop target in the releases we checked",
    ],
    bestFor:
      "Teams that want AI assistance and collaborative editing in a fast native editor on macOS or Linux.",
  },
  {
    rank: "07",
    name: "CodeEdit",
    label: "Best macOS-native open-source editor",
    url: "https://www.codeedit.app/",
    description:
      "CodeEdit is an open-source macOS editor built with Swift and AppKit. It aims to feel native to the Mac and to provide an Xcode-adjacent experience for developers who want an open-source alternative on macOS.",
    footprint:
      "About 36 MB macOS DMG (v0.3.6). Native Swift and AppKit.",
    pros: [
      "Native macOS look and feel",
      "Open source and community-driven",
      "Designed around the Mac development experience",
    ],
    cons: [
      "macOS only",
      "Younger project with a smaller ecosystem",
    ],
    bestFor:
      "macOS developers who want a native, open-source editor built specifically for the Mac.",
  },
];

const faqs = [
  {
    question: "What is the best lightweight code editor in 2026?",
    answer:
      "T Code is the best overall choice if you want a tiny editor with an integrated terminal, native menus, 24 themes, and a free MIT license. Sublime Text is the best polished paid option, Lite XL is the best minimal Lua editor, and Neovim is the best terminal-native choice.",
  },
  {
    question: "Which lightweight editor is best for Windows?",
    answer:
      "T Code and Notepad++ are the strongest Windows options. Notepad++ is excellent for quick edits and Windows-only workflows. T Code adds cross-platform support, an integrated terminal, and a more modern desktop interface.",
  },
  {
    question: "What is the smallest code editor?",
    answer:
      "Lite XL and T Code are both around 5 MB as installed editors, with compressed downloads around 2.3 to 2.6 MB. Vim and Neovim can be smaller in their base form, but plugins and configuration add to the total.",
  },
  {
    question: "Are lightweight editors good for programming?",
    answer:
      "Yes, for local editing, project navigation, search, terminal work, and multi-cursor editing. If you need a full debugger, remote containers, notebooks, or a large extension marketplace, a heavier IDE may be the better main tool.",
  },
  {
    question: "Is T Code really free?",
    answer:
      "Yes. T Code is released under the MIT license and is free to download, use, and modify. There is no account, subscription, or paid tier.",
  },
];

const schema = graphSchema([
  websiteSchema,
  softwareSchema,
  personSchema,
  webPageSchema({
    title: "Best Lightweight Code Editors in 2026",
    description:
      "An honest comparison of the best lightweight code editors in 2026, including T Code, Sublime Text, Lite XL, Notepad++, Neovim, Zed, and CodeEdit.",
    path: "/best/lightweight-code-editors",
  }),
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "Best lightweight code editors", path: "/best/lightweight-code-editors" },
  ]),
  {
    "@type": "ItemList",
    name: "Best lightweight code editors in 2026",
    numberOfItems: editors.length,
    itemListElement: editors.map((editor, index) => ({
      "@type": "ListItem",
      position: index + 1,
      name: editor.name,
    })),
  },
  faqSchema(faqs),
]);

export function BestEditorsPage() {
  return (
    <>
      <PageMeta
        title="Best Lightweight Code Editors in 2026 (Tested & Ranked)"
        description="An honest comparison of the best lightweight code editors in 2026, including T Code, Sublime Text, Lite XL, Notepad++, Neovim, Zed, and CodeEdit."
        path="/best/lightweight-code-editors"
        keywords="best lightweight code editor, lightweight code editor, best code editor for low end pc, small code editor, Lite XL alternative"
        imageAlt="Best lightweight code editors in 2026"
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow="Guide · best editors"
        title={
          <>
            The best <em>lightweight</em>
            <br />
            code editors in 2026.
          </>
        }
        sub="Seven editors for people who want fast local editing without a browser-sized download. We include the trade-offs, not just the winners."
        meta={["7 editors", "Measured sizes", "Honest trade-offs"]}
        actions={
          <>
            <Link className="btn btn--blue" to="/download">
              Try T Code <ArrowUpRight size={17} strokeWidth={1.6} />
            </Link>
            <Link className="btn btn--outline" to="/benchmarks">
              See the benchmark method
            </Link>
          </>
        }
      />

      <section className="site-container" style={{ paddingBottom: 90 }}>
        <div className="prose" style={{ marginLeft: 0 }}>
          <p>
            <strong>Disclosure:</strong> T Code is built by the author of this
            site. It is included because it belongs in the category, but the list
            also includes its closest competitors and the cases where they are the
            better choice. Every size below was taken from an official release
            asset on November 12, 2026.
          </p>
          <p>
            “Lightweight” is not a single number. We looked at download size,
            architecture, platform support, the built-in workflow, the plugin
            model, and the license. We did not rank editors by features alone,
            because a feature list is exactly what makes a small editor look worse
            than a platform it is not trying to replace.
          </p>

          <h2>Quick picks</h2>
          <table className="compare-table">
            <thead>
              <tr>
                <th>Category</th>
                <th>Editor</th>
                <th>Why</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Best overall</td>
                <td>T Code</td>
                <td>Small, free, and includes a terminal, native menus, and themes.</td>
              </tr>
              <tr>
                <td>Best polished paid editor</td>
                <td>Sublime Text</td>
                <td>Mature editing experience and a deep package ecosystem.</td>
              </tr>
              <tr>
                <td>Best minimal editor</td>
                <td>Lite XL</td>
                <td>The smallest possible C and Lua base with familiar plugins.</td>
              </tr>
              <tr>
                <td>Best Windows quick-edit tool</td>
                <td>Notepad++</td>
                <td>Fast, familiar, and excellent for macros and large text files.</td>
              </tr>
              <tr>
                <td>Best terminal-native editor</td>
                <td>Neovim</td>
                <td>Keyboard-first editing that works over SSH and in containers.</td>
              </tr>
              <tr>
                <td>Best AI and collaboration editor</td>
                <td>Zed</td>
                <td>Native speed with built-in collaboration and optional AI.</td>
              </tr>
              <tr>
                <td>Best macOS-native editor</td>
                <td>CodeEdit</td>
                <td>Swift and AppKit, built specifically for the Mac.</td>
              </tr>
            </tbody>
          </table>

          {editors.map((editor) => (
            <section key={editor.name}>
              <h2>
                {editor.rank}. {editor.name} — {editor.label}
              </h2>
              <p>{editor.description}</p>
              <ul>
                <li>
                  <strong>Footprint:</strong> {editor.footprint}
                </li>
                <li>
                  <strong>Pros:</strong> {editor.pros.join("; ")}.
                </li>
                <li>
                  <strong>Cons:</strong> {editor.cons.join("; ")}.
                </li>
                <li>
                  <strong>Best for:</strong> {editor.bestFor}
                </li>
              </ul>
              <p>
                {editor.internal ? (
                  <Link className="link-arrow" to={editor.url}>
                    Download {editor.name} <ArrowUpRight size={16} strokeWidth={1.6} />
                  </Link>
                ) : (
                  <a
                    className="link-arrow"
                    href={editor.url}
                    target="_blank"
                    rel="noreferrer"
                  >
                    Visit {editor.name} <ArrowUpRight size={16} strokeWidth={1.6} />
                  </a>
                )}
              </p>
            </section>
          ))}

          <h2>The comparison table</h2>
          <p>
            Download sizes are compressed packages from official releases, not
            installed folder sizes. They are useful for a first comparison, but
            they are not the whole story. A small installer can expand into a large
            application, and plugins add their own footprint.
          </p>
          <table className="compare-table">
            <thead>
              <tr>
                <th>Editor</th>
                <th>Core</th>
                <th>Platforms</th>
                <th>Download measured</th>
                <th>License</th>
                <th>Terminal</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>T Code</td>
                <td>C + Lua</td>
                <td>Windows, macOS, Linux</td>
                <td>2.6 MB Windows portable zip</td>
                <td>MIT</td>
                <td>Built in</td>
              </tr>
              <tr>
                <td>Sublime Text</td>
                <td>Native C++</td>
                <td>Windows, macOS, Linux</td>
                <td>22 MB Windows installer</td>
                <td>Proprietary</td>
                <td>Packages</td>
              </tr>
              <tr>
                <td>Lite XL</td>
                <td>C + Lua</td>
                <td>Windows, macOS, Linux</td>
                <td>2.3 MB Windows zip</td>
                <td>MIT</td>
                <td>Plugin / external</td>
              </tr>
              <tr>
                <td>Notepad++</td>
                <td>C++ / Scintilla</td>
                <td>Windows</td>
                <td>7 MB installer</td>
                <td>GPL</td>
                <td>Plugins</td>
              </tr>
              <tr>
                <td>Neovim</td>
                <td>C + Lua</td>
                <td>Windows, macOS, Linux</td>
                <td>12.6 MB Windows zip</td>
                <td>Apache-2.0</td>
                <td>Terminal-native</td>
              </tr>
              <tr>
                <td>Zed</td>
                <td>Rust + GPUI</td>
                <td>macOS, Linux</td>
                <td>91 MB Linux archive</td>
                <td>Open-source core</td>
                <td>Built in</td>
              </tr>
              <tr>
                <td>CodeEdit</td>
                <td>Swift + AppKit</td>
                <td>macOS</td>
                <td>36 MB DMG</td>
                <td>Open source</td>
                <td>Built in</td>
              </tr>
            </tbody>
          </table>
          <p>
            The table makes the trade-off visible. T Code and Lite XL are in the
            same weight class. Sublime Text is still small by modern standards but
            larger than the C and Lua editors. VS Code, which is not in this list
            because it is not a lightweight editor in the same sense, is larger
            again: its Windows user installer was about 286 MB when we checked.
          </p>

          <h2>How to choose</h2>
          <p>
            If you want one editor for local editing, a terminal, project search,
            themes, and multi-cursor work, start with T Code. If you want the most
            polished paid editing experience and a deep package ecosystem, choose
            Sublime Text. If you want the smallest possible Lua base and enjoy
            configuring your workflow, choose Lite XL. If you work only on Windows
            and mostly need quick edits, Notepad++ is still excellent.
          </p>
          <p>
            If your work depends on a debugger, remote containers, notebooks, or a
            large extension marketplace, none of these editors is a full
            replacement for VS Code or a JetBrains IDE. The honest answer is to use
            a lightweight editor for the local work it does well and a larger IDE
            for the work that needs a platform.
          </p>

          <h2>What we left out, and why</h2>
          <p>
            VS Code is not in this list. It is an excellent editor, but it is not a
            lightweight editor in the sense this guide uses: its Windows user
            installer was about 286 MB when we measured it, and it carries Electron,
            Chromium, Node, and an extension host. That does not make it bad. It
            makes it a platform, and platforms have a different cost model.
          </p>
          <p>
            JetBrains IDEs and Xcode are also excluded. They are full development
            environments, not small editors. Emacs is a special case: it can be
            small, but a modern configuration with packages is a platform of its
            own. The list is about editors whose default shape is small.
          </p>

          <h2>The size vs capability trade-off</h2>
          <p>
            The smallest editors ask you to assemble more. Lite XL and T Code both
            have a C and Lua core, but T Code ships more desktop workflow out of the
            box. Sublime Text is larger than either, but its package ecosystem is
            deeper. Neovim is small at the core, but a modern configuration adds
            plugins and language servers. Zed and CodeEdit are native applications
            with larger baselines, but they also ship more of the platform.
          </p>
          <p>
            There is no free lunch in that table. The useful question is which parts
            you want to assemble and which parts you want the editor to own. If you
            enjoy configuring your tool, a minimal editor is a feature. If you want
            the editor to make decisions for you, a larger editor is a feature.
          </p>

          <h2>Best editor by use case</h2>
          <table className="compare-table">
            <thead>
              <tr>
                <th>Use case</th>
                <th>Best fit</th>
                <th>Why</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Windows laptop with 4 GB RAM</td>
                <td>T Code or Notepad++</td>
                <td>Small native footprint; T Code adds a terminal and cross-platform support.</td>
              </tr>
              <tr>
                <td>macOS-native development</td>
                <td>CodeEdit or Zed</td>
                <td>Both are designed for the Mac; Zed adds AI and collaboration.</td>
              </tr>
              <tr>
                <td>Linux desktop with a terminal workflow</td>
                <td>Neovim or T Code</td>
                <td>Neovim is terminal-native; T Code keeps a GUI and a terminal in one window.</td>
              </tr>
              <tr>
                <td>Paid, polished editing</td>
                <td>Sublime Text</td>
                <td>Mature editing surface and a deep package ecosystem.</td>
              </tr>
              <tr>
                <td>Minimal C and Lua base</td>
                <td>Lite XL</td>
                <td>The smallest base with the mod-version 4 plugin model.</td>
              </tr>
              <tr>
                <td>Portable USB setup</td>
                <td>T Code</td>
                <td>A user folder next to the binary keeps settings, plugins, and themes together.</td>
              </tr>
            </tbody>
          </table>

          <h2>Before you switch</h2>
          <p>
            Switching editors is a workflow change, not just a download. Before you
            commit, check the things that are hard to replace: a specific plugin, a
            debugger configuration, a keybinding set, a theme you rely on, and any
            external tool that expects a particular editor. Write down the three
            actions you perform most often and test them in the new editor first.
          </p>
          <p>
            If the new editor handles those three actions well, the rest is usually
            learnable. If it does not, no amount of small download size will make
            the switch worthwhile.
          </p>

          <h2>Frequently asked questions</h2>
          <div className="faq-list">
            {faqs.map((faq, index) => (
              <details className="faq-item" key={faq.question} open={index === 0}>
                <summary>{faq.question}</summary>
                <div className="faq-item__answer">{faq.answer}</div>
              </details>
            ))}
          </div>

          <p>
            Want the definition and measurement method behind these picks? Read{" "}
            <Link to="/lightweight-code-editor">
              what makes a lightweight code editor
            </Link>
            , or see the <Link to="/benchmarks">benchmark methodology</Link>.
          </p>
        </div>
      </section>

      <SectionCta
        kicker="Pick your weight"
        title={
          <>
            Small editor.
            <br />
            <em>Serious</em> workflow.
          </>
        }
        actions={
          <>
            <Link className="btn btn--blue" to="/download">
              Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
            </Link>
            <Link className="btn btn--paper" to="/compare">
              Compare editors
            </Link>
          </>
        }
      />
    </>
  );
}
