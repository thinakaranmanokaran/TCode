import { Link } from "react-router-dom";
import { siteConfig } from "../data/site.js";

export function SiteFooter() {
  return (
    <footer className="site-footer site-container">
      <div>
        © 2026 T Code · Built by{" "}
        <a href={siteConfig.links.portfolio} target="_blank" rel="noreferrer">
          Thinakaran Manokaran
        </a>{" "}
        · {siteConfig.license} licensed
      </div>
      <div className="site-footer__right">
        <Link to="/license">License</Link> · <Link to="/privacy">Privacy</Link> ·{" "}
        <a href={siteConfig.links.github} target="_blank" rel="noreferrer">
          GitHub
        </a>{" "}
        ·{" "}
        <a href={`mailto:${siteConfig.links.email}`}>Email</a>
      </div>
    </footer>
  );
}
