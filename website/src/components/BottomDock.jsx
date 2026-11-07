import { Link, useLocation } from "react-router-dom";
import { ArrowUp } from "lucide-react";

const items = [
  { label: "Features", href: "/features", mobile: true },
  { label: "Themes", href: "/themes", mobile: false },
  { label: "About", href: "/about", mobile: true },
  { label: "Download", href: "/download", mobile: true },
];

export function BottomDock() {
  const location = useLocation();

  const scrollTop = () => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  return (
    <nav className="dock" aria-label="Main navigation">
      <button className="dock__circle" type="button" onClick={scrollTop} aria-label="Back to top">
        <ArrowUp size={17} strokeWidth={1.7} />
      </button>
      {items.map((item) => {
        const active =
          location.pathname === item.href || location.pathname.startsWith(`${item.href}/`);
        return (
          <Link
            key={item.href}
            to={item.href}
            className={[
              "dock__link",
              item.href === "/download" ? "dock__link--download" : "",
              item.mobile ? "" : "dock__link--hide-mobile",
              active ? "is-active" : "",
            ]
              .filter(Boolean)
              .join(" ")}
            aria-current={active ? "page" : undefined}
          >
            {item.label}
          </Link>
        );
      })}
    </nav>
  );
}
