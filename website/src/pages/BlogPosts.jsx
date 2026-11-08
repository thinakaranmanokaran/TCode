import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { siteConfig } from "../data/site.js";
import {
  graphSchema,
  websiteSchema,
  personSchema,
  breadcrumbSchema,
  articleSchema,
} from "../data/schema.js";

function ArticleShell({ title, description, path, eyebrow, date, readTime, children }) {
  const schema = graphSchema([
    websiteSchema,
    personSchema,
    articleSchema({ title, description, path, date }),
    breadcrumbSchema([
      { name: "Home", path: "/" },
      { name: "Blog", path: "/blog" },
      { name: title, path },
    ]),
  ]);

  return (
    <>
      <PageMeta
        title={`${title} | T Code`}
        description={description}
        path={path}
        type="article"
        publishedTime={date}
        modifiedTime={date}
        imageAlt={`${title} — T Code blog by Thinakaran Manokaran`}
      />
      <JsonLd data={schema} />

      <article>
        <header className="article-hero site-container">
          <div className="article-hero__meta">
            <span>{eyebrow}</span>
            <span>{date}</span>
            <span>{readTime}</span>
          </div>
          <h1 className="display">{title}</h1>
          <p className="article-hero__sub">{description}</p>
        </header>

        <div className="article-body site-container">
          <div className="prose">{children}</div>
        </div>
      </article>

      <SectionCta
        kicker="Put it to the test"
        title={
          <>
            Open it once.
            <br />
            <em>Feel the difference.</em>
          </>
        }
        actions={
          <>
            <Link className="btn btn--blue" to="/download">
              Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
            </Link>
            <Link className="btn btn--paper" to="/blog">
              More articles
            </Link>
          </>
        }
      />
    </>
  );
}

export function BlogLightweightPage() {
  return (
    <ArticleShell
      title="Why lightweight code editors still matter"
      description="Fast software is not nostalgia. It is a practical advantage for developers working on older laptops, large projects, and long days."
      path="/blog/why-lightweight-editors-still-matter"
      eyebrow="Craft"
      date="2026-11-07"
      readTime="6 min read"
    >
      <p>
        There is a story the software industry likes to tell: computers are fast
        now, so editors can be heavy. Memory is cheap, so the browser engine
        inside your text editor does not matter. The cloud will absorb the cost.
        This story is convenient for companies shipping enormous applications.
        It is less convenient for the person using a four-year-old laptop.
      </p>
      <p>
        Lightweight code editors are not nostalgia. They are a practical choice
        with measurable consequences: how quickly you start working, how much
        battery you burn, how many projects you can keep open, and how often your
        tools interrupt your attention.
      </p>

      <h2>The hidden cost of a heavy editor</h2>
      <p>
        A modern editor can be hundreds of megabytes before you install a single
        extension. That number includes a browser runtime, a JavaScript engine, a
        language server host, a telemetry client, and an update service. Most of
        that code exists because the editor is also a platform.
      </p>
      <p>
        A platform is not a bad thing. But every layer adds startup work. The
        first keystroke has to wait for the window, the renderer, the extension
        host, and the workspace index. On a fast machine, the delay is a few
        seconds. On an older machine, it is the difference between opening the
        editor and opening a browser-sized application.
      </p>
      <p>
        There is a second cost: attention. A heavy editor has more surfaces for
        notifications, sync prompts, update banners, and extension suggestions.
        Each one is small. Together they change the shape of a workday.
      </p>

      <h2>What “lightweight” actually buys you</h2>
      <p>
        T Code is about 5 MB on Windows. It does not bundle a browser. The editor
        uses a C core for rendering and input, with Lua for the editor logic and
        plugins. That architecture produces three practical benefits.
      </p>
      <ul>
        <li>
          <strong>Startup is not a negotiation.</strong> The editor opens before
          you have time to open a different app.
        </li>
        <li>
          <strong>Memory stays predictable.</strong> There is no separate browser
          process and extension host competing for the same RAM.
        </li>
        <li>
          <strong>The tool stays comprehensible.</strong> A small core and a Lua
          layer are easier to inspect, patch, and extend than a stack of bundled
          runtimes.
        </li>
      </ul>

      <h2>The modern counterargument</h2>
      <p>
        The strongest argument for heavy editors is not size; it is capability.
        If your work depends on a debugger, remote containers, notebooks, or a
        specific language server, a large editor may be the only realistic choice.
        That is fine. The mistake is assuming that every project needs the same
        tool.
      </p>
      <p>
        A lightweight editor is not trying to win a feature checklist. It is
        trying to be the right tool for a specific shape of work: local editing,
        quick project navigation, a terminal, syntax highlighting, and a theme you
        like. That is still most of the work for most developers.
      </p>

      <h2>Where lightweight editors fit in 2026</h2>
      <p>
        The last few years made small editors more interesting again. Language
        servers can run as separate processes. Terminals are better. File watching
        is reliable. Plugins can add the missing pieces without turning the core
        into a platform.
      </p>
      <p>
        T Code is an example of that approach: a C core with Lua, a mod-version
        4 plugin API, and the desktop pieces that used to require a second tool:
        a native menu bar, an integrated terminal, an activity bar, Explorer and
        tab context menus, multi-cursor tools, and 24 themes with live preview.
      </p>
      <p>
        None of those features require an Electron runtime. They require a team
        willing to care about the small delays.
      </p>

      <h2>A practical test</h2>
      <p>
        If you want to know whether a lightweight editor is worth trying, run a
        simple test. Close everything. Open the editor. Time how long it takes to
        show a cursor. Open a project with a few thousand files. Search for a
        string. Open a terminal. Switch a theme. Then compare that experience with
        the editor you use today.
      </p>
      <p>
        You may decide the heavier editor is still worth it. That is a valid
        answer. But you should make the choice with real numbers and a real
        project, not with the assumption that bigger always means better.
      </p>
      <p>
        The point is not to make every editor small. The point is to remember that
        fast software is a feature — and that it is still possible to build it.
      </p>
    </ArticleShell>
  );
}

export function BlogLiteXLPage() {
  return (
    <ArticleShell
      title="Lite XL vs T Code: what's new and who should switch"
      description="Compare Lite XL and T Code on workflow, features, and footprint to decide which editor fits your workflow."
      path="/blog/lite-xl-vs-t-code"
      eyebrow="Comparison"
      date="2026-11-07"
      readTime="7 min read"
    >
      <p>
        Two lightweight editors, two workflows: why choose one over the other?
        The short answer is workflow defaults. The longer answer is the list
        below.
      </p>

      <h2>What Lite XL gets right</h2>
      <p>
        Both editors are remarkable in their restraint: small, fast, and
        extensible in a way that most editors are not. The C core stays out of the
        way. Lua handles the editor logic. A color theme is a single readable file.
        A plugin can change the interface without rebuilding the application.
      </p>
      <p>
        If you already use Lite XL with a carefully tuned user module, you have a
        setup that is genuinely yours.
      </p>

      <h2>What T Code emphasizes</h2>
      <p>
        T Code emphasizes a desktop workflow out of the box:
      </p>
      <ul>
        <li>A VS Code-style menu bar with File, Edit, Selection, View, Go, Run, Terminal, and Help.</li>
        <li>A vertical activity bar for Explorer, project search, terminal, command palette, and settings.</li>
        <li>An integrated terminal with tabs, shell profiles, ConPTY on Windows, and PTY on POSIX.</li>
        <li>Live theme previews for 10 Bearded and 10 Monokai variations, plus four classics.</li>
        <li>A Selection menu with expand/shrink selection, line-end cursors, occurrence selection, and column selection.</li>
        <li>Explorer and tab context menus with new file/folder, rename, reveal, copy path, split, pin, and reopen.</li>
        <li>Native Open File and Open Project Folder dialogs.</li>
      </ul>
      <p>
        The important word is “integrated.” These are not separate plugins with
        separate settings. They share the same keyboard model, the same theme
        palette, and the same window.
      </p>

      <h2>Shared ground</h2>
      <p>
        Both are C and Lua editors of about 5 MB on Windows. The plugin API
        (mod-version 4) and the color theme format (a single Lua file) are shared,
        and the source is MIT licensed.
      </p>
      <p>
        That means switching cost is low: if you move between the two, many
        plugins and themes carry over. The main difference is the interface
        around them.
      </p>

      <h2>Who should switch</h2>
      <p>
        Switch to T Code if you want a native menu bar, an integrated terminal,
        and a richer Explorer without building that workflow yourself. Switch if
        you like the lightweight core but find yourself opening a separate
        terminal or a second file manager every day.
      </p>

      <h2>Who should stay on Lite XL</h2>
      <p>
        Stay on Lite XL if you want the smallest possible base, you enjoy hand
        assembling a user module, or you depend on a plugin that has not been
        tested with T Code.
      </p>

      <h2>The honest summary</h2>
      <p>
        Neither editor is “better” in every dimension. T Code focuses more on
        desktop workflow out of the box. If that matches how you work, you will
        feel the difference immediately. If it does not, both remain excellent
        lightweight editors.
      </p>
      <p>
        You can compare the two side by side on the{" "}
        <Link to="/compare/lite-xl-vs-t-code">comparison page</Link>, or{" "}
        <Link to="/download">download T Code</Link> and try it for a week.
      </p>
    </ArticleShell>
  );
}

export function BlogBuildPage() {
  return (
    <ArticleShell
      title="How to build T Code from source"
      description="A practical build guide for Windows, Linux, and macOS, including the dependencies, Meson commands, and the repo layout."
      path="/blog/build-t-code-from-source"
      eyebrow="Guide"
      date="2026-11-07"
      readTime="8 min read"
    >
      <p>
        T Code is a Meson project. The core is C, the editor is Lua, and the
        build produces a single native executable. This guide walks through the
        dependencies, the repository layout, and the commands for each platform.
      </p>

      <h2>Prerequisites</h2>
      <p>Install the following before configuring the build:</p>
      <ul>
        <li>Meson 0.63 or newer</li>
        <li>Ninja</li>
        <li>A C compiler (GCC, Clang, or MSVC)</li>
        <li>SDL3 development libraries</li>
        <li>PCRE2, FreeType2, and Lua 5.4</li>
      </ul>
      <p>
        Meson can download PCRE2, FreeType2, and Lua automatically. SDL3 is
        usually provided by the build script or a system package.
      </p>

      <h2>Repository layout</h2>
      <p>
        The application source lives under <code>application/</code>. The root
        <code>meson.build</code> is a thin project file that includes it, so the
        build still runs from the repository root.
      </p>
      <pre>
        <code>{`tcode/
├─ application/
│  ├─ src/          C core and Lua C API
│  ├─ data/         Lua core, themes, fonts, plugins
│  ├─ resources/    icons, packaging assets, cross files
│  ├─ scripts/      build and packaging scripts
│  └─ subprojects/  dependency wraps
├─ meson.build
└─ meson_options.txt`}</code>
      </pre>

      <h2>Build on Windows (MSYS2)</h2>
      <p>
        Open an MSYS2 UCRT64 shell and install the toolchain:
      </p>
      <pre>
        <code>{`pacman -S mingw-w64-ucrt-x86_64-gcc \\
  mingw-w64-ucrt-x86_64-meson \\
  mingw-w64-ucrt-x86_64-ninja \\
  mingw-w64-ucrt-x86_64-pkgconf`}</code>
      </pre>
      <p>
        From the repository root, run the build script with the static fallback
        option:
      </p>
      <pre>
        <code>{`bash application/scripts/build.sh --forcefallback --portable -b build`}</code>
      </pre>
      <p>
        The portable application is staged under{" "}
        <code>application/build/tcode</code>. Run <code>tcode.exe</code> from that
        folder.
      </p>

      <h2>Build on Linux</h2>
      <p>
        Install the development packages for SDL3, PCRE2, FreeType, and Lua, then:
      </p>
      <pre>
        <code>{`meson setup application/build --buildtype=release --prefix=/usr
meson compile -C application/build`}</code>
      </pre>
      <p>
        For a portable package:
      </p>
      <pre>
        <code>{`DESTDIR="$(pwd)/application/tcode" meson install \\
  --skip-subprojects -C application/build`}</code>
      </pre>

      <h2>Build on macOS</h2>
      <p>
        Install a recent bash, Meson, Ninja, and SDL3 with Homebrew, then build a
        portable bundle or a macOS app:
      </p>
      <pre>
        <code>{`meson setup application/build --buildtype=release --Dbundle=true --prefix /
meson compile -C application/build
DESTDIR="$(pwd)/application/T Code.app" meson install \\
  --skip-subprojects -C application/build`}</code>
      </pre>

      <h2>Troubleshooting</h2>
      <p>
        If Meson cannot find SDL3, make sure <code>pkg-config</code> is installed
        and points at the SDL3 <code>.pc</code> file. If the build cannot find Lua,
        use <code>--wrap-mode=forcefallback</code> to build the bundled wrap. If a
        previous build directory exists, delete it or pass <code>--reconfigure</code>.
      </p>
      <p>
        On Windows, the portable build is self-contained. If you want your
        settings to travel with it, create a <code>user</code> folder next to{" "}
        <code>tcode.exe</code>.
      </p>

      <h2>Next steps</h2>
      <p>
        Once the build works, read the <Link to="/features">feature tour</Link>,
        try a few <Link to="/themes">themes</Link>, or inspect the{" "}
        <Link to="/changelog">changelog</Link> to see what changed in the current
        release.
      </p>
    </ArticleShell>
  );
}
