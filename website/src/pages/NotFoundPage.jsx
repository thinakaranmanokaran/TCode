import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";

export function NotFoundPage() {
  return (
    <>
      <PageMeta
        title="404 — Lost in the buffer | T Code"
        description="The page you were looking for does not exist."
        path="/404"
        noindex
      />
      <section className="hero" style={{ background: "var(--ink)", color: "var(--paper)" }}>
        <div className="hero__eyebrow eyebrow" style={{ color: "rgba(250,250,250,.55)" }}>
          404 · file not found
        </div>
        <h1 className="display">
          Lost in the <em>buffer.</em>
        </h1>
        <p className="hero__lead" style={{ color: "rgba(250,250,250,.65)" }}>
          This page does not exist. It may have been moved, renamed, or never
          saved in the first place.
        </p>
        <div style={{ display: "flex", gap: 12, flexWrap: "wrap", justifyContent: "center", marginTop: 34 }}>
          <Link className="btn btn--blue" to="/">
            Back home <ArrowUpRight size={17} strokeWidth={1.6} />
          </Link>
          <Link className="btn btn--paper" to="/download">
            Download T Code
          </Link>
        </div>
      </section>
    </>
  );
}
