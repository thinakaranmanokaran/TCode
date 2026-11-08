import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import path from "node:path";

// GitHub Pages project site is served from /TCode/ (repo name).
// Keep base as "/" for custom domains (tcode.thinakaran.dev) and local dev.
// The Pages workflow sets VITE_BASE=/TCode/ at build time so asset URLs,
// the React Router basename, sitemap/canonical generation, and 404.html
// all resolve under the subpath without code changes.
//
// Windows (Git Bash/MSYS) path-conversion can mangle a bare "/TCode/"
// env value into something like "/Softwares/Git/TCode/". Normalize that
// back to the intended subpath. Set MSYS_NO_PATHCONV=1 around local
// Windows builds instead for an exact value.
function resolveBase() {
  const raw = process.env.VITE_BASE || "/";
  // MSYS/Git-Bash may prepend its install prefix (e.g. /Softwares/Git/).
  // Anything ending in /TCode/ only ever means the Pages subpath.
  if (raw.includes("/TCode/")) {
    return raw.slice(raw.lastIndexOf("/TCode/"));
  }
  return raw.startsWith("/") ? raw : `/${raw}`;
}

const base = resolveBase();

export default defineConfig({
  base,
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      // Drop 20 KB of dev-only prop-types validation from PageMeta chunk.
      "prop-types": path.resolve(process.cwd(), "src/stubs/prop-types.js"),
    },
  },
  ssgOptions: {
    dirStyle: "nested",
    // Inline critical (above-fold) CSS into HTML and load the remaining
    // 40 KB stylesheet async (preload:"swap") so it no longer blocks
    // FCP/LCP. First paint uses the inlined critical rules.
    beastiesOptions: { reduce: true, preload: "swap" },
  },
  build: {
    cssCodeSplit: true,
    reportCompressedSize: true,
    chunkSizeWarningLimit: 600,
    rollupOptions: {
      output: {
        // Vite 8 (rolldown) requires manualChunks as a function.
        // Split large third-party deps into vendor chunks so they can be
        // cached long-term while page chunks stay small.
        // NOTE: check react-router FIRST — "node_modules/react" is a
        // substring of "node_modules/react-router-dom", so the old order
        // lumped the router (≈80 KB) into vendor-react (292 KB).
        manualChunks(id) {
          if (
            id.includes("node_modules/react-router") ||
            id.includes("node_modules/react-router-dom") ||
            id.includes("node_modules/history")
          ) {
            return "vendor-router";
          }
          if (
            id.includes("node_modules/react-dom") ||
            id.includes("node_modules/react/") ||
            id.includes("node_modules/scheduler")
          ) {
            return "vendor-react";
          }
          if (id.includes("node_modules/lenis")) return "vendor-scroll";
          if (id.includes("node_modules/lucide-react")) return "vendor-icons";
          return undefined;
        },
      },
    },
  },
});
