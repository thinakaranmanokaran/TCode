import { Link } from "react-router-dom";
import { ArrowUpRight, Mail } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { faqs } from "../data/faq.js";
import { siteConfig } from "../data/site.js";
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  breadcrumbSchema,
  faqSchema,
} from "../data/schema.js";

const schema = graphSchema([
  websiteSchema,
  softwareSchema,
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "FAQ", path: "/faq" },
  ]),
  faqSchema(faqs),
]);

export function FaqPage() {
  return (
    <>
      <PageMeta
        title="T Code FAQ — Downloads, Plugins & Portable Mode"
        description="Answers about T Code: what it is, platform support, download options, portable mode, Lite XL plugins, themes, and how to build from source."
        path="/faq"
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow="FAQ"
        title={
          <>
            Questions.
            <br />
            <em>Answered.</em>
          </>
        }
        sub="The short answers to the things people ask before trying T Code."
        meta={["10 answers", "Free & open source", "No account required"]}
      />

      <section className="site-container" style={{ paddingBottom: 100 }}>
        <div className="faq-list">
          {faqs.map((faq, index) => (
            <details className="faq-item" key={faq.question} open={index === 0}>
              <summary>{faq.question}</summary>
              <div className="faq-item__answer">{faq.answer}</div>
            </details>
          ))}
        </div>

        <div
          style={{
            marginTop: 50,
            padding: "30px 0",
            borderTop: "1px solid var(--line)",
            display: "flex",
            flexWrap: "wrap",
            alignItems: "center",
            justifyContent: "space-between",
            gap: 20,
          }}
        >
          <div>
            <div className="eyebrow" style={{ color: "var(--electric)" }}>
              Still stuck?
            </div>
            <p style={{ marginTop: 10, color: "var(--muted)", fontSize: 16 }}>
              Open an issue on GitHub or send a direct email.
            </p>
          </div>
          <div style={{ display: "flex", gap: 12, flexWrap: "wrap" }}>
            <a className="btn btn--dark" href={`mailto:${siteConfig.links.email}`}>
              <Mail size={16} strokeWidth={1.6} /> Email
            </a>
            <a
              className="btn btn--outline"
              href={siteConfig.links.github}
              target="_blank"
              rel="noreferrer"
            >
              GitHub <ArrowUpRight size={16} strokeWidth={1.6} />
            </a>
          </div>
        </div>
      </section>

      <SectionCta
        kicker="Enough reading"
        title={
          <>
            See it for
            <br />
            <em>yourself.</em>
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
