import { designNotes } from "../data/story.js";
import { Reveal } from "./Reveal.jsx";

export function QuoteSection() {
  return (
    <section className="quote-section">
      <div className="site-container">
        <Reveal>
          <div className="eyebrow" style={{ color: "var(--lime)", textAlign: "center" }}>
            Design notes
          </div>
          <h2 className="display quote-section__title" style={{ marginTop: 22 }}>
            Built to <em>disappear.</em>
          </h2>
        </Reveal>

        <div className="quote-grid">
          {designNotes.map((note, index) => (
            <Reveal className="quote" key={note.quote} delay={index * 60}>
              <div className="quote__mark" aria-hidden="true">
                “
              </div>
              <div>
                <p className="quote__body">{note.quote}</p>
                <p className="quote__who">{note.attribution}</p>
              </div>
              <div className="quote__mark quote__mark--end" aria-hidden="true">
                ”
              </div>
            </Reveal>
          ))}
        </div>
      </div>

      <div className="marquee" aria-hidden="true">
        <div className="marquee__track">
          {[0, 1].map((copy) => (
            <div className="marquee__item" key={copy}>
              Lightweight. <em>Fast.</em> Open source. Portable. Extensible.{" "}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
