import { Link } from "react-router-dom";
import { ArrowUpRight, Download } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { assetPath } from "../data/base.js";
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  personSchema,
  breadcrumbSchema,
  webPageSchema,
  faqSchema,
} from "../data/schema.js";

const measuredOn = "2026-11-12";

const rows = [
  {
    editor: "T Code 2.1.7",
    package: "Windows x86_64 portable zip",
    size: "2.61 MB",
    bytes: "2,606,314",
    source: "https://github.com/thinakaranmanokaran/TCode/releases",
  },
  {
    editor: "Lite XL 2.1.8",
    package: "Windows x86_64 zip",
    size: "2.30 MB",
    bytes: "2,303,776",
    source: "https://github.com/lite-xl/lite-xl/releases",
  },
  {
    editor: "Notepad++ 8.9.9.1",
    package: "Windows x64 installer",
    size: "7.05 MB",
    bytes: "7,048,536",
    source: "https://github.com/notepad-plus-plus/notepad-plus-plus/releases",
  },
  {
    editor: "Neovim 0.12.6",
    package: "Windows x86_64 zip",
    size: "12.62 MB",
    bytes: "12,624,741",
    source: "https://github.com/neovim/neovim/releases",
  },
  {
    editor: "Sublime Text 4 (4215)",
    package: "Windows x64 installer",
    size: "21.98 MB",
    bytes: "21,975,760",
    source: "https://www.sublimetext.com/download",
  },
  {
    editor: "CodeEdit 0.3.6",
    package: "macOS DMG",
    size: "35.96 MB",
    bytes: "35,962,501",
    source: "https://github.com/CodeEditApp/CodeEdit/releases",
  },
  {
    editor: "Zed 1.28.1",
    package: "Linux x86_64 tar.gz",
    size: "91.24 MB",
    bytes: "91,236,005",
    source: "https://github.com/zed-industries/zed/releases",
  },
  {
    editor: "VS Code 1.146.0",
    package: "Windows x64 user installer",
    size: "286.11 MB",
    bytes: "286,108,864",
    source: "https://code.visualstudio.com/download",
  },
];

const faqs = [
  {
    question: "What do these code editor benchmark numbers measure?",
    answer:
      "The table measures the compressed download package from each editor's official release, not the installed folder size or runtime memory. Download size is a useful first comparison because it shows how much runtime and bundled content an editor ships.",
  },
  {
    question: "Why does VS Code have such a large download?",
    answer:
      "VS Code bundles Electron, Chromium, Node, and the extension host. That platform is what makes its extension ecosystem possible, but it also creates a large baseline download and memory footprint.",
  },
  {
    question: "Does a smaller download always mean faster startup?",
    answer:
      "No. Startup also depends on the number of dependencies, disk speed, extensions, plugins, and what the editor initializes before showing a window. Download size is one signal, not a complete performance measurement.",
  },
  {
    question: "How can I measure startup and memory myself?",
    answer:
      "Use a repeatable test on your own machine: restart, time cold start until the window is interactive, open a real project, record idle memory and memory with a terminal open, and repeat the test several times. The page includes a downloadable CSV template.",
  },
  {
    question: "Are these numbers updated for every release?",
    answer:
      "The table is dated and should be re-measured when a new release is published. The CSV template is designed to make that update repeatable.",
  },
];

const schema = graphSchema([
  websiteSchema,
  softwareSchema,
  personSchema,
  webPageSchema({
    title: "Code Editor Benchmarks: Startup, RAM, and Size",
    description:
      "Measured code editor download sizes and a reproducible method for testing startup time and memory use.",
    path: "/benchmarks",
  }),
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "Benchmarks", path: "/benchmarks" },
  ]),
  faqSchema(faqs),
]);

export function BenchmarksPage() {
  return (
    <>
      <PageMeta
        title="Code Editor Benchmarks: Startup, RAM, and Size (2026)"
        description="Measured code editor download sizes and a reproducible method for testing startup time and memory use on your own machine."
        path="/benchmarks"
        keywords="code editor benchmarks, code editor startup time, code editor memory use, lightweight code editor size"
        imageAlt="Code editor benchmark methodology from T Code"
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow="Benchmarks · measured"
        title={
          <>
            Code editor benchmarks:
            <br />
            startup, RAM, and <em>size.</em>
          </>
        }
        sub="A small download is only one signal. This page publishes the sizes we measured, explains how to test startup and memory, and gives you a template to reproduce the results."
        meta={[`Measured ${measuredOn}`, "Official release assets", "Reproducible method"]}
        actions={
          <>
            <a
              className="btn btn--blue"
              href={assetPath("/benchmarks/editor-benchmark-template.csv")}
              download
            >
              <Download size={17} strokeWidth={1.6} /> Download CSV template
            </a>
            <Link className="btn btn--outline" to="/lightweight-code-editor">
              Read the definition
            </Link>
          </>
        }
      />

      <section className="site-container" style={{ paddingBottom: 90 }}>
        <div className="prose" style={{ marginLeft: 0 }}>
          <p>
            Editor comparisons often turn into feature lists. That is useful, but it
            does not answer the question a developer on a 4 GB laptop actually asks:
            how much does this editor cost me before I open a file? Download size is
            the easiest part of that answer to measure, and it is where we start.
          </p>

          <h2>Measured download sizes</h2>
          <p>
            The table below uses the compressed package published on each editor's
            official release page. We measured the latest stable release available
            on {measuredOn}. We used the Windows x64 package where one exists;
            CodeEdit is macOS-only and Zed is measured from its Linux x86_64
            archive. These are download sizes, not installed sizes.
          </p>
          <table className="compare-table">
            <thead>
              <tr>
                <th>Editor</th>
                <th>Package measured</th>
                <th>Size</th>
                <th>Bytes</th>
                <th>Source</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row) => (
                <tr key={row.editor}>
                  <td>{row.editor}</td>
                  <td>{row.package}</td>
                  <td>{row.size}</td>
                  <td>{row.bytes}</td>
                  <td>
                    <a href={row.source} target="_blank" rel="noreferrer">
                      Release
                    </a>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          <p>
            T Code's Windows executable is about 4.68 MB before compression. The
            portable zip is about 2.61 MB. The difference between those two numbers
            is why download size and installed size should not be confused.
          </p>

          <h2>What we measure, and what we do not</h2>
          <p>
            We publish download size because it is objective, repeatable, and easy
            to verify from an official source. We do not publish startup-time or RAM
            numbers for every editor unless we have run the same test on the same
            machine and recorded the result. Hardware, operating system, extensions,
            and project size change those numbers too much to pretend they are
            universal.
          </p>
          <p>
            The method below is the one we use. It is intentionally simple so that
            you can run it on your own machine and compare the result that matters
            to you.
          </p>

          <h2>What download size does not tell you</h2>
          <p>
            Download size is a proxy for how much runtime and bundled content an
            editor ships, not a direct measure of startup speed. A compressed
            archive can expand into a much larger installed application. A small
            binary can still start slowly if it loads a large plugin stack or scans
            a project before showing a window.
          </p>
          <p>
            Memory is even more configuration-dependent. A base editor may idle at a
            modest number, then grow when a language server, a file watcher, a
            terminal, and a large project index are added. That growth is not
            dishonest; it is the cost of the features you chose. The comparison is
            only meaningful when both editors are tested with a similar set of
            capabilities.
          </p>
          <p>
            This is why the page publishes two things separately: objective package
            sizes from official releases, and a method for measuring the runtime
            behavior that matters to you. Do not turn one number into a universal
            claim.
          </p>

          <h2>A fair comparison checklist</h2>
          <ul>
            <li>Use the same operating system and hardware for every editor.</li>
            <li>Measure the same package type: installer, portable archive, or installed folder.</li>
            <li>Use the same project and the same number of open files.</li>
            <li>Test with a comparable plugin set, or test both with no plugins first.</li>
            <li>Record cold start and warm start separately.</li>
            <li>Record idle memory, project memory, and terminal memory separately.</li>
            <li>Repeat each test at least three times and report the median.</li>
            <li>Write down the versions and the test date.</li>
          </ul>

          <h2>Why we do not publish universal startup numbers</h2>
          <p>
            A startup time measured on one machine is not a universal fact. Disk
            speed, CPU, operating system, background processes, extensions, project
            size, and even the state of the file cache all change the result. A
            number that looks authoritative can be misleading when it is applied to a
            different laptop.
          </p>
          <p>
            We prefer a method you can reproduce. If you publish your own numbers,
            publish the hardware, the versions, the project size, and the exact
            steps. That makes the comparison useful to someone else instead of just
            impressive in a screenshot.
          </p>

          <h2>How to measure startup time</h2>
          <ol>
            <li>
              Restart the machine, or at least close the editor and the applications
              that compete for disk and memory.
            </li>
            <li>
              Start a timer when you launch the editor. Stop it when the window is
              interactive and a cursor is visible.
            </li>
            <li>
              Repeat the cold-start test at least three times. Report the median,
              not the fastest run.
            </li>
            <li>
              Repeat the test with a warm start (launch, close, launch again) and
              keep the two numbers separate.
            </li>
            <li>
              Open a real project with a few thousand files and repeat the test.
              A blank window is not the workload you actually use.
            </li>
          </ol>

          <h2>How to measure memory</h2>
          <ol>
            <li>
              Open one file and wait for the editor to settle. Record memory use.
            </li>
            <li>
              Open a real project. Record memory after the file tree and search
              index are ready.
            </li>
            <li>
              Open a terminal session and run a small command. Record memory again.
            </li>
            <li>
              If you use plugins or language servers, record memory with and without
              them. The plugin layer is often the real difference.
            </li>
          </ol>
          <p>
            On Windows, Task Manager's Details tab is enough for a rough number. On
            macOS, use Activity Monitor. On Linux, use your desktop system monitor
            or a tool such as <code>ps_mem</code>. The exact tool matters less than
            using the same one for every editor.
          </p>

          <h2>Download the template</h2>
          <p>
            The CSV template has columns for editor, version, platform, package
            size, cold start, warm start, idle memory, project memory, terminal
            memory, notes, and test date. Fill it in on your own machine and keep
            the raw numbers. A benchmark you cannot reproduce is just a claim.
          </p>
          <p>
            <a
              className="link-arrow"
              href={assetPath("/benchmarks/editor-benchmark-template.csv")}
              download
            >
              Download the editor benchmark template <Download size={16} strokeWidth={1.6} />
            </a>
          </p>

          <h2>Why this matters for lightweight editors</h2>
          <p>
            A lightweight editor is not automatically faster in every dimension. A
            small editor with a large plugin stack can use more memory than a
            heavier editor with a lean configuration. The useful question is what
            the editor costs in the configuration you actually run.
          </p>
          <p>
            That is why the definition of lightweight includes startup, memory,
            dependencies, and workflow. A 5 MB binary is a good start. It is not the
            whole benchmark.
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
        </div>
      </section>

      <SectionCta
        kicker="Run your own test"
        title={
          <>
            Measure it.
            <br />
            <em>Then decide.</em>
          </>
        }
        actions={
          <>
            <Link className="btn btn--blue" to="/download">
              Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
            </Link>
            <Link className="btn btn--paper" to="/best/lightweight-code-editors">
              See the editor shortlist
            </Link>
          </>
        }
      />
    </>
  );
}
