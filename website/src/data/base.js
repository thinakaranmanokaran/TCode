// Base path for runtime asset URLs.
//
// Vite injects import.meta.env.BASE_URL at build time:
//   - "/" on custom domains / local dev (VITE_BASE unset)
//   - "/TCode/" on the GitHub Pages project site (VITE_BASE=/TCode/)
//
// Hardcoded "/brand/..." / "/images/..." strings in JSX are NOT rewritten
// by Vite (only JS-imported assets and CSS url() are), so runtime <img>
// sources go through assetPath(). Canonical/OG URLs keep using
// siteConfig.url (which already includes /TCode/ on Pages).
export const baseUrl = import.meta?.env?.BASE_URL || "/";

export function assetPath(path) {
  if (!path || path.startsWith("http") || path.startsWith("data:") || path.startsWith("#")) {
    return path;
  }
  const clean = path.replace(/^\//, "");
  return baseUrl.endsWith("/") ? `${baseUrl}${clean}` : `${baseUrl}/${clean}`;
}
