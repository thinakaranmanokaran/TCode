import { useEffect } from "react";
import { Outlet, useLocation } from "react-router-dom";
import Lenis from "lenis";
import { SiteHeader } from "./SiteHeader.jsx";
import { BottomDock } from "./BottomDock.jsx";
import { BackToTop } from "./BackToTop.jsx";
import { SiteFooter } from "./SiteFooter.jsx";
import { darkHeaderRoutes } from "../data/site.js";

export function Layout() {
  const location = useLocation();
  const isDark = darkHeaderRoutes.has(location.pathname);

  useEffect(() => {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

    const lenis = new Lenis({ smoothWheel: true, lerp: 0.12 });
    let frame;

    const raf = (time) => {
      lenis.raf(time);
      frame = window.requestAnimationFrame(raf);
    };

    frame = window.requestAnimationFrame(raf);
    return () => {
      window.cancelAnimationFrame(frame);
      lenis.destroy();
    };
  }, []);

  useEffect(() => {
    if (location.hash) {
      const node = document.getElementById(location.hash.slice(1));
      if (node) {
        window.setTimeout(() => node.scrollIntoView({ behavior: "smooth", block: "start" }), 60);
        return;
      }
    }
    window.scrollTo(0, 0);
  }, [location.pathname, location.hash]);

  return (
    <>
      <a className="skip-link" href="#main">
        Skip to content
      </a>
      <SiteHeader dark={isDark} />
      <main id="main">
        <Outlet />
      </main>
      <SiteFooter />
      <BottomDock />
      <BackToTop />
    </>
  );
}
