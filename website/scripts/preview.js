import { createServer } from "node:http";
import { createReadStream } from "node:fs";
import { stat } from "node:fs/promises";
import path from "node:path";

const dist = path.resolve(process.cwd(), "dist");
const port = Number(process.env.PORT || 4173);
// When previewing the GitHub Pages build (VITE_BASE=/TCode/), the site is
// served under /TCode/. Strip that prefix so local preview matches prod.
// Windows Git Bash/MSYS can mangle a bare "/TCode/" env value (e.g. into
// "/Softwares/Git/TCode/"); normalize it the same way vite.config.js does.
function resolveBase(raw) {
  const v = raw || "/";
  if (v.includes("/TCode/")) return v.slice(v.lastIndexOf("/TCode/"));
  return v.startsWith("/") ? v : `/${v}`;
}
const base = resolveBase(process.env.VITE_BASE);

const types = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".mjs": "text/javascript; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".xml": "application/xml; charset=utf-8",
  ".txt": "text/plain; charset=utf-8",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".webp": "image/webp",
  ".ico": "image/x-icon",
  ".woff2": "font/woff2",
  ".webmanifest": "application/manifest+json",
};

async function resolveFile(urlPath) {
  let clean = decodeURIComponent(urlPath.split("?")[0]);
  // Support both "/" and base-prefixed ("/TCode/...") local preview URLs.
  if (base !== "/" && clean.startsWith(base)) {
    clean = clean.slice(base.length - 1) || "/";
  }
  const candidates = [];

  if (clean === "/") {
    candidates.push(path.join(dist, "index.html"));
  } else {
    const relative = clean.replace(/^\/+/, "");
    candidates.push(path.join(dist, relative));
    if (!path.extname(relative)) {
      candidates.push(path.join(dist, relative, "index.html"));
      candidates.push(path.join(dist, `${relative}.html`));
    }
  }

  for (const candidate of candidates) {
    try {
      const info = await stat(candidate);
      if (info.isFile()) return candidate;
    } catch {
      // try the next candidate
    }
  }
  return null;
}

const server = createServer(async (req, res) => {
  const file = await resolveFile(req.url || "/");

  if (!file) {
    res.writeHead(404, { "Content-Type": "text/html; charset=utf-8" });
    createReadStream(path.join(dist, "404.html")).pipe(res);
    return;
  }

  const ext = path.extname(file);
  res.writeHead(200, {
    "Content-Type": types[ext] || "application/octet-stream",
    "Cache-Control": ext === ".html" ? "no-cache" : "public, max-age=604800",
  });
  createReadStream(file).pipe(res);
});

server.listen(port, "127.0.0.1", () => {
  const prefix = base === "/" ? "" : base.replace(/\/$/, "");
  console.log(`T Code site preview: http://127.0.0.1:${port}${prefix}/`);
});
