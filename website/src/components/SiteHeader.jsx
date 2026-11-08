import { Link } from "react-router-dom";
import { assetPath } from "../data/base.js";

export function SiteHeader({ dark = false }) {
  return (
    <header className={`topbar ${dark ? "topbar--dark" : ""}`}>
      <Link to="/" className="topbar__brand" aria-label="T Code home">
        <img src={assetPath("/brand/logo-mark.svg")} alt="" width="22" height="22" />
        T Code
      </Link>
    </header>
  );
}
