import { Link } from "react-router-dom";
import { siteConfig } from "../data/site.js";
import { assetPath } from "../data/base.js";

const productLinks = [
  { label: "Features", to: "/features" },
  { label: "Themes", to: "/themes" },
  { label: "Download", to: "/download" },
  { label: "Changelog", to: "/changelog" },
  { label: "FAQ", to: "/faq" },
];

const projectLinks = [
  { label: "About", to: "/about" },
  { label: "Developer", to: "/developer" },
  { label: "Blog", to: "/blog" },
  { label: "License", to: "/license" },
  { label: "Privacy", to: "/privacy" },
];

const resourceLinks = [
  { label: "Build from source", to: "/blog/build-t-code-from-source" },
  { label: "Compare editors", to: "/compare/vs-code-vs-t-code" },
  { label: "Latest release", href: siteConfig.links.releases },
  { label: "Source code", href: siteConfig.links.github },
  { label: "Support", href: `mailto:${siteConfig.links.email}` },
];

const communityLinks = [
  { label: "Portfolio", href: siteConfig.links.portfolio },
  { label: "LinkedIn", href: siteConfig.links.linkedin },
  { label: "Dev.to", href: siteConfig.links.dev },
  { label: "GitHub profile", href: siteConfig.links.githubProfile },
  { label: "Email", href: `mailto:${siteConfig.links.email}` },
];

function FooterList({ title, links }) {
  return (
    <nav className="site-footer__col" aria-label={title}>
      <h3 className="site-footer__colTitle">{title}</h3>
      <ul className="site-footer__list">
        {links.map((link) => (
          <li key={link.label}>
            {link.to ? (
              <Link to={link.to}>{link.label}</Link>
            ) : (
              <a href={link.href} target="_blank" rel="noreferrer">
                {link.label}
              </a>
            )}
          </li>
        ))}
      </ul>
    </nav>
  );
}

export function SiteFooter() {
  return (
    <footer className="site-footer">
      <div className="site-container site-footer__inner">
        <div className="site-footer__grid">
          <div className="site-footer__brand">
            <Link to="/" className="site-footer__brandRow" aria-label="T Code home">
              <img src={assetPath("/brand/logo-mark.svg")} alt="" width="28" height="28" />
              <span className="site-footer__brandName">T Code</span>
              <span className="site-footer__version">v{siteConfig.version} · {siteConfig.license}</span>
            </Link>
            <p className="site-footer__tagline">{siteConfig.tagline}</p>
            <p className="site-footer__platforms">Windows · macOS · Linux — about 5 MB, instant startup.</p>
            <div className="site-footer__actions">
              <Link className="btn btn--dark" to="/download">
                Download T Code
              </Link>
              <a
                className="btn btn--outline"
                href={siteConfig.links.github}
                target="_blank"
                rel="noreferrer"
              >
                View source
              </a>
            </div>
          </div>

          <div className="site-footer__cols">
            <FooterList title="Product" links={productLinks} />
            <FooterList title="Project" links={projectLinks} />
            <FooterList title="Resources" links={resourceLinks} />
            <FooterList title="Connect" links={communityLinks} />
          </div>
        </div>

        <div className="site-footer__bar">
          <span>
            © 2026{" "}
            <a href={siteConfig.links.portfolio} target="_blank" rel="noreferrer">
              {siteConfig.author.name}
            </a>{" "}
            · {siteConfig.license} licensed · free and open source
          </span>
          <span className="site-footer__barRight">
            <Link to="/license">License</Link>
            <span aria-hidden="true"> · </span>
            <Link to="/privacy">Privacy</Link>
            <span aria-hidden="true"> · </span>
            <a href={siteConfig.links.releases} target="_blank" rel="noreferrer">
              Releases
            </a>
          </span>
        </div>
      </div>
    </footer>
  );
}
