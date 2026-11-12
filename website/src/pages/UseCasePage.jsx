import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { useCases } from "../data/useCases.js";
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  personSchema,
  breadcrumbSchema,
  webPageSchema,
  faqSchema,
} from "../data/schema.js";

const evaluationCopy = {
  windows: {
    title: "Try it on Windows",
    paragraphs: [
      "Start with the portable build so you can test T Code without changing your installed setup. Extract it, open a real project, run a command in the integrated terminal, and check memory use in Task Manager. If the workflow fits, add the installer and the optional PATH entry afterward.",
      "Pay attention to the terminal profile you use most. T Code supports PowerShell, Command Prompt, and other profiles, but the first prompt should feel familiar. If you depend on a Windows-only plugin from another editor, check whether an equivalent exists before you switch.",
    ],
  },
  linux: {
    title: "Try it on Linux",
    paragraphs: [
      "Use the AppImage for the fastest test: make it executable, run it, and open a project from your home directory. If you prefer a system-level install, use the tarball or build from source. Check that the terminal opens with your shell and that your usual keybindings do not conflict with the desktop environment.",
      "Test on the display server you actually use. T Code targets x86_64 Linux with X11 or Wayland, but the experience can vary by compositor and desktop environment. If you use a tiling window manager, check window sizing and menu behavior early.",
    ],
  },
  macos: {
    title: "Try it on macOS",
    paragraphs: [
      "Open the DMG, drag T Code into Applications, and test it on a real project before moving your settings over. Check the menu bar, the terminal profile, and the theme preview on the display you use most. If you use multiple Macs, the portable archive makes it easier to keep the same setup in a folder.",
      "If you rely on macOS-specific automation or a particular shell configuration, test those early. The universal build runs on Apple Silicon and Intel, but your plugins and external tools still need to work on the target machine.",
    ],
  },
  "low-end-pc": {
    title: "Try it on the machine that matters",
    paragraphs: [
      "Benchmark the editor on the laptop you actually use, not on a fast desktop. Open your largest project, start a terminal, and watch memory in the system monitor for a few minutes. A small baseline is useful only if the rest of your workflow fits inside the remaining memory.",
      "Keep the first test lean: no plugins, one project, one terminal. Add your real plugin set afterward and measure again. If the machine struggles, remove the optional pieces before blaming the editor.",
    ],
  },
  portable: {
    title: "Test the portable setup",
    paragraphs: [
      "Create a user folder next to the executable before you customize anything. Change a setting, install a theme, close the editor, and reopen it. Confirm that the change persisted inside the folder rather than in your home directory.",
      "Copy the whole folder to a second machine and repeat the test. Pay attention to platform-specific plugins and file paths. Portable mode keeps the data together; it does not make Windows binaries run on macOS.",
    ],
  },
  "under-10mb": {
    title: "Verify the size yourself",
    paragraphs: [
      "Check the archive size before extracting it, then check the executable size after extraction. Those are different numbers, and both are useful. Compare the same package type when you compare editors.",
      "If size is the main reason you are switching, test the editor with your real plugin set. A small base plus a large language server can be heavier than expected. The base size is the starting point, not the final total.",
    ],
  },
};

export function UseCasePage({ slug }) {
  const useCase = useCases.find((item) => item.slug === slug);

  if (!useCase) {
    return null;
  }

  const path = `/lightweight-code-editor/${useCase.slug}`;
  const schema = graphSchema([
    websiteSchema,
    softwareSchema,
    personSchema,
    webPageSchema({
      title: useCase.metaTitle,
      description: useCase.metaDescription,
      path,
    }),
    breadcrumbSchema([
      { name: "Home", path: "/" },
      { name: "Lightweight code editor", path: "/lightweight-code-editor" },
      { name: useCase.title, path },
    ]),
    faqSchema(
      useCase.faq.map((item) => ({ question: item.q, answer: item.a })),
    ),
  ]);

  return (
    <>
      <PageMeta
        title={useCase.metaTitle}
        description={useCase.metaDescription}
        path={path}
        keywords={`${useCase.eyebrow}, lightweight code editor, T Code`}
        imageAlt={useCase.title}
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow={useCase.eyebrow}
        title={useCase.title}
        sub={useCase.sub}
        meta={["About 5 MB", "Windows · macOS · Linux", "MIT licensed"]}
        actions={
          <Link className="btn btn--blue" to="/download">
            Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
          </Link>
        }
      />

      <section className="site-container" style={{ paddingBottom: 90 }}>
        <div className="prose" style={{ marginLeft: 0 }}>
          {useCase.intro.map((paragraph) => (
            <p key={paragraph}>{paragraph}</p>
          ))}

          {useCase.sections.map((section) => (
            <section key={section.title}>
              <h2>{section.title}</h2>
              {section.paragraphs.map((paragraph) => (
                <p key={paragraph}>{paragraph}</p>
              ))}
            </section>
          ))}

          {evaluationCopy[useCase.slug] ? (
            <section>
              <h2>{evaluationCopy[useCase.slug].title}</h2>
              {evaluationCopy[useCase.slug].paragraphs.map((paragraph) => (
                <p key={paragraph}>{paragraph}</p>
              ))}
            </section>
          ) : null}

          <h2>Frequently asked questions</h2>
          <div className="faq-list">
            {useCase.faq.map((item, index) => (
              <details className="faq-item" key={item.q} open={index === 0}>
                <summary>{item.q}</summary>
                <div className="faq-item__answer">{item.a}</div>
              </details>
            ))}
          </div>

          <p>
            Read <Link to="/lightweight-code-editor">what makes a lightweight code editor</Link>,
            compare <Link to="/best/lightweight-code-editors">the best lightweight editors</Link>,
            or check the <Link to="/benchmarks">benchmark method</Link>.
          </p>
        </div>
      </section>

      <SectionCta
        kicker="Keep it light"
        title={
          <>
            Small editor.
            <br />
            <em>Your</em> workflow.
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
    </>
  );
}
