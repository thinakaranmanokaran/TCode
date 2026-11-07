import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";

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
  ssgOptions: {
    dirStyle: "nested",
    beastiesOptions: false,
  },
});
