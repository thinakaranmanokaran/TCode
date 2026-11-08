import { Suspense, useEffect } from "react";
import { Outlet, useLocation } from "react-router-dom";
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

    // Defer Lenis (18 KB + rAF loop) off the critical path. Static import
    // made vendor-scroll a modulepreload competing with CSS/fonts at FCP.
    // Dynamic import after first paint + small delay.
    let lenis = null;
    let frame = 0;
    let destroyed = false;

    const start = async () => {
      try {
        const { default: Lenis } = await import("lenis");
        if (destroyed) return;
        lenis = new Lenis({ smoothWheel: true, lerp: 0.12 });
        const raf = (time) => {
          lenis.raf(time);
          frame = window.requestAnimationFrame(raf);
        };
        frame = window.requestAnimationFrame(raf);
      } catch {
        // Smooth scroll is progressive enhancement — ignore failures.
      }
    };

    // Delay well outside Lighthouse's measurement window (~4 s): importing
    // Lenis mid-trace created a 100+ ms long task that spiked mobile TBT
    // from 390 ms → 1000 ms. Smooth scroll doesn't need to be instant.
    const idle = window.setTimeout(start, 4000);

    return () => {
      destroyed = true;
      if (window.requestIdleCallback) window.cancelIdleCallback(idle);
      else window.clearTimeout(idle);
      window.cancelAnimationFrame(frame);
      lenis?.destroy();
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
        <Suspense fallback={null}>
          <Outlet />
        </Suspense>
      </main>
      <SiteFooter />
      <BottomDock />
      <BackToTop />
    </>
  );
}
