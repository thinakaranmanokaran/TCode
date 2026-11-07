import { Link } from "react-router-dom";
import { LocalClock } from "./LocalClock.jsx";
import { siteConfig } from "../data/site.js";

export function SiteHeader({ dark = false }) {
  return (
    <header className={`topbar ${dark ? "topbar--dark" : ""}`}>
      <Link to="/" className="topbar__brand" aria-label="T Code home">
        <img src="/brand/logo-mark.svg" alt="" width="22" height="22" />
        T Code
      </Link>

      <div className="topbar__pill">
        <span className="topbar__dot" aria-hidden="true" />
        <span>Open source · v{siteConfig.version}</span>
      </div>

      <div className="topbar__meta">
        <LocalClock />
        <span className="topbar__live">Free &amp; open source</span>
      </div>
    </header>
  );
}
