import { useEffect, useState } from "react";
import { Link, useLocation } from "react-router-dom";

const items = [
  { label: "Features", href: "/features", mobile: true },
  { label: "Themes", href: "/themes", mobile: false },
  { label: "About", href: "/about", mobile: true },
  { label: "Download", href: "/download", mobile: true },
];

export function BottomDock() {
  const location = useLocation();
  const [footerVisible, setFooterVisible] = useState(false);

  useEffect(() => {
    if (typeof window === "undefined" || !("IntersectionObserver" in window)) {
      return;
    }
    const footer = document.querySelector("footer.site-footer");
    if (!footer) return;

    const observer = new IntersectionObserver(
      ([entry]) => setFooterVisible(entry.isIntersecting),
      { threshold: 0 },
    );
    observer.observe(footer);
    return () => observer.disconnect();
  }, [location.pathname]);

  return (
    <nav
      className={`dock${footerVisible ? " is-hidden" : ""}`}
      aria-label="Main navigation"
      aria-hidden={footerVisible || undefined}
    >
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
            tabIndex={footerVisible ? -1 : undefined}
          >
            {item.label}
          </Link>
        );
      })}
    </nav>
  );
}
