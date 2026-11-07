import { ArrowSketch } from "./ArrowSketch.jsx";

export function SectionHeading({ title, index, note, sub }) {
  return (
    <div className="section-head">
      {note ? (
        <div className="section-head__note">
          <div className="note-card note-card--dark">{note}</div>
          <ArrowSketch className="arrow-sketch" style={{ width: 54, height: 44 }} />
        </div>
      ) : null}
      <h2 className="display section-head__title">
        {title}
        {index ? <span className="section-head__index">({index})</span> : null}
      </h2>
      {sub ? <p className="section-head__sub">{sub}</p> : null}
    </div>
  );
}
