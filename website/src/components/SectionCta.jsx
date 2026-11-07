import { Link } from "react-router-dom";

export function SectionCta({ kicker = "Still here?", title, actions }) {
  return (
    <section className="section-cta">
      <div className="site-container">
        <div className="eyebrow" style={{ color: "rgba(250,250,250,.55)" }}>
          {kicker}
        </div>
        <h2 className="display section-cta__title">{title}</h2>
        <div className="section-cta__actions">{actions}</div>
      </div>
    </section>
  );
}
