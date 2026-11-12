import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { comparisons } from "../data/comparisons.js";
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  personSchema,
  breadcrumbSchema,
  articleSchema,
} from "../data/schema.js";

export function EditorComparisonPage({ slug }) {
  const comparison = comparisons.find((item) => item.slug === slug);

  if (!comparison) {
    return null;
  }

  const path = `/compare/${comparison.slug}`;
  const schema = graphSchema([
    websiteSchema,
    softwareSchema,
    personSchema,
    articleSchema({
      title: comparison.metaTitle,
      description: comparison.metaDescription,
      path,
      date: "2026-11-12",
      updated: comparison.updated,
    }),
    breadcrumbSchema([
      { name: "Home", path: "/" },
      { name: "Compare", path: "/compare" },
      { name: `${comparison.competitor} vs T Code`, path },
    ]),
  ]);

  return (
    <>
      <PageMeta
        title={comparison.metaTitle}
        description={comparison.metaDescription}
        path={path}
        type="article"
        publishedTime="2026-11-12"
        modifiedTime={comparison.updated}
        keywords={`${comparison.competitor} vs T Code, ${comparison.competitor} alternative, lightweight code editor comparison`}
        imageAlt={`${comparison.competitor} vs T Code comparison`}
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow={comparison.eyebrow}
        title={comparison.title}
        sub={comparison.sub}
        meta={["Lightweight editors", "Honest trade-offs", `Updated ${comparison.updated}`]}
      />

      <section className="site-container" style={{ paddingBottom: 80 }}>
        <div className="prose" style={{ marginLeft: 0 }}>
          {comparison.intro.map((paragraph) => (
            <p key={paragraph}>{paragraph}</p>
          ))}

          <table className="compare-table">
            <thead>
              <tr>
                <th>Dimension</th>
                <th>{comparison.competitor}</th>
                <th>T Code</th>
              </tr>
            </thead>
            <tbody>
              {comparison.rows.map(([dimension, competitor, tcode]) => (
                <tr key={dimension}>
                  <td>{dimension}</td>
                  <td>{competitor}</td>
                  <td>{tcode}</td>
                </tr>
              ))}
            </tbody>
          </table>

          {comparison.sections.map((section) => (
            <section key={section.title}>
              <h2>{section.title}</h2>
              {section.paragraphs.map((paragraph) => (
                <p key={paragraph}>{paragraph}</p>
              ))}
            </section>
          ))}

          {comparison.migration ? (
            <section>
              <h2>{comparison.migrationTitle}</h2>
              {comparison.migration.map((paragraph) => (
                <p key={paragraph}>{paragraph}</p>
              ))}
            </section>
          ) : null}

          <h2>The verdict</h2>
          <p>{comparison.verdict}</p>
          <p>
            <strong>Choose {comparison.competitor} if:</strong>{" "}
            {comparison.bestForCompetitor}
          </p>
          <p>
            <strong>Choose T Code if:</strong> {comparison.bestForTcode}
          </p>
          <p>
            You can read the{" "}
            <a href={comparison.competitorUrl} target="_blank" rel="noreferrer">
              official {comparison.competitor} site
            </a>
            , compare all options in{" "}
            <Link to="/best/lightweight-code-editors">
              the best lightweight code editors guide
            </Link>
            , or start with{" "}
            <Link to="/lightweight-code-editor">
              what makes a lightweight code editor
            </Link>
            .
          </p>
        </div>
      </section>

      <SectionCta
        kicker="Try the alternative"
        title={
          <>
            Small editor.
            <br />
            <em>Real</em> workflow.
          </>
        }
        actions={
          <>
            <Link className="btn btn--blue" to="/download">
              Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
            </Link>
            <Link className="btn btn--paper" to="/compare">
              All comparisons
            </Link>
          </>
        }
      />
    </>
  );
}
