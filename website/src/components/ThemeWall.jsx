import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { themes } from "../data/themes.js";
import { Reveal } from "./Reveal.jsx";

export function ThemeWall() {
  const featured = themes.slice(0, 8);

  return (
    <section className="theme-wall">
      <div className="site-container">
        <Reveal className="theme-wall__head">
          <div>
            <div className="eyebrow" style={{ color: "var(--lime)" }}>
              Craft · 24 themes included
            </div>
            <h2 className="display theme-wall__title" style={{ marginTop: 18 }}>
              Your editor.
              <br />
              <em>Your light.</em>
            </h2>
          </div>
          <Link className="link-arrow theme-wall__link" to="/themes">
            See all 24 themes <ArrowUpRight size={16} strokeWidth={1.6} />
          </Link>
        </Reveal>

        <div className="theme-grid">
          {featured.map((theme, index) => (
            <Reveal key={theme.slug} delay={(index % 4) * 50}>
              <article className="theme-card">
                <div className="theme-card__top">
                  <span
                    className="theme-card__dot"
                    style={{ background: theme.colors.accent }}
                  />
                  <span className="theme-card__group">{theme.group}</span>
                </div>
                <div className="theme-card__name">{theme.name}</div>
                <div
                  className="theme-card__code"
                  style={{
                    background: theme.colors.background,
                    color: theme.colors.text,
                  }}
                >
                  <div>{"// "}{theme.name}</div>
                  <div>const theme = &quot;{theme.group}&quot;</div>
                  <div>function build()</div>
                </div>
              </article>
            </Reveal>
          ))}
        </div>
      </div>
    </section>
  );
}
