import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { lineage } from "../data/story.js";
import { Reveal } from "./Reveal.jsx";
import { ArrowSketch } from "./ArrowSketch.jsx";

export function Lineage() {
  return (
    <section className="lineage">
      <div className="site-container">
        <Reveal className="lineage__head">
          <h2 className="display lineage__title">
            <em>Where</em>
            <br />
            it comes from
          </h2>
          <div className="lineage__aside">
            T Code did not start from zero. It stands on two small editors and a
            community that cares about software staying small.
            <div style={{ marginTop: 22, color: "var(--lime)" }}>
              <ArrowSketch style={{ width: 72, height: 46 }} />
            </div>
          </div>
        </Reveal>

        <div>
          {lineage.map((item, index) => (
            <Reveal className="lineage__row" key={item.name} delay={index * 50}>
              <div className="lineage__name">{item.name}</div>
              <div className="lineage__role">{item.role}</div>
              <div className="lineage__date">{item.date}</div>
            </Reveal>
          ))}
        </div>

        <div className="lineage__actions">
          <Link className="btn btn--blue" to="/changelog">
            View the changelog <ArrowUpRight size={17} strokeWidth={1.6} />
          </Link>
        </div>
      </div>
    </section>
  );
}
