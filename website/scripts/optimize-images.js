import sharp from "sharp";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";

const root = process.cwd();
const src = path.join(root, "scripts", "screenshots-src");
const out = path.join(root, "public", "images", "screenshots");
const brand = path.join(root, "public", "brand");

await mkdir(out, { recursive: true });
await mkdir(brand, { recursive: true });

const screenshots = [
  { input: "clean-01-editor-default.png", output: "editor.webp", top: 56, height: 654, left: 260, width: 1122 },
  { input: "clean-02-editor-oceanic.png", output: "editor-oceanic.webp", top: 56, height: 654, left: 260, width: 1122 },
  { input: "clean-03-editor-terminal.png", output: "terminal-drawer.webp", top: 56, height: 654, left: 260, width: 1122 },
  { input: "clean-04-terminal-full.png", output: "terminal.webp", top: 56, height: 654, left: 260, width: 1122 },
  { input: "clean-05-command-palette.png", output: "command-palette.webp", top: 56, height: 654, left: 0, width: 900 },
  { input: "clean-06-find-file.png", output: "find-file.webp", top: 56, height: 654, left: 0, width: 900 },
  { input: "clean-11-file-menu.png", output: "file-menu.webp", top: 56, height: 654, left: 0, width: 760 },
  { input: "clean-07-theme-picker.png", output: "theme-menu.webp", top: 56, height: 654, left: 0, width: 760 },
  { input: "clean-09-explorer-menu.png", output: "explorer-menu.webp", top: 56, height: 654, left: 0, width: 560 },
  { input: "clean-10-selection-menu.png", output: "selection-menu.webp", top: 56, height: 654, left: 120, width: 560 },
];

for (const shot of screenshots) {
  const input = path.join(src, shot.input);
  const meta = await sharp(input).metadata();
  const left = shot.left || 0;
  const width = shot.width || meta.width;
  const height = Math.min(shot.height, meta.height - shot.top);

  const mainPath = path.join(out, shot.output);
  await sharp(input)
    .extract({ left, top: shot.top, width, height })
    .resize({ width: Math.min(width, 1400) })
    .webp({ quality: 88, effort: 5 })
    .toFile(mainPath);

  console.log(`optimized ${shot.output} (${width}x${height})`);

  // Responsive derivatives referenced by FeatureShowcase srcSet.
  // -640 bridges 480 → 768 so 1.75× mobile (≈588 CSS px) doesn't jump to
  // a 768 file (Lighthouse image-delivery "wasted bytes").
  for (const w of [480, 640, 768]) {
    if (w >= width) continue;
    const name = shot.output.replace(/\.webp$/, `-${w}.webp`);
    await sharp(mainPath)
      .resize({ width: w })
      .webp({ quality: 85, effort: 5 })
      .toFile(path.join(out, name));
    console.log(`  derivative ${name}`);
  }
}

// Blue T mark used in the header and favicons.
const logoSvg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
  <circle cx="256" cy="256" r="256" fill="#1710E6"/>
  <path d="M136 130 L124 172.5 L127.5 172.5 L143 156.5 L157 146.5 L178 138.5 L220.5 138.5 L230.5 142.5 L235 148 L236 393.5 L234 399.5 L230.5 404 L221.5 407 L209 407 L209 415.5 L302.5 415.5 L302.5 407 L285 406 L277.5 400.5 L275.5 395.5 L275.5 150 L282 141.5 L291 138.5 L324.5 137.5 L337.5 139.5 L355.5 147.5 L374.5 162.5 L384 172.5 L387.5 172.5 L375.5 130 Z" fill="#ffffff"/>
</svg>`;
await writeFile(path.join(brand, "logo-mark.svg"), logoSvg, "utf8");

for (const size of [32, 180, 192, 512]) {
  await sharp(Buffer.from(logoSvg))
    .resize(size, size)
    .png()
    .toFile(path.join(brand, size === 180 ? "apple-touch-icon.png" : `icon-${size}.png`));
}

// Default social card.
const ogSvg = `<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="630">
  <rect width="1200" height="630" fill="#FAFAFA"/>
  <rect x="0" y="0" width="14" height="630" fill="#1710E6"/>
  <text x="64" y="82" font-family="Consolas, monospace" font-size="24" letter-spacing="6" fill="#151515">T CODE</text>
  <circle cx="1096" cy="74" r="12" fill="#1710E6"/>
  <text x="1078" y="81" text-anchor="end" font-family="Consolas, monospace" font-size="20" fill="#1710E6">v2.1.7</text>
  <text x="64" y="286" font-family="Georgia, serif" font-size="104" fill="#151515">Code light.</text>
  <text x="64" y="398" font-family="Georgia, serif" font-style="italic" font-size="104" fill="#8CC651">Ship fast.</text>
  <text x="66" y="486" font-family="Segoe UI, Arial, sans-serif" font-size="26" font-weight="300" fill="#262626">A free, open-source code editor built in C and Lua.</text>
  <text x="66" y="530" font-family="Consolas, monospace" font-size="20" letter-spacing="2" fill="#6B6B6B">5 MB · 24 THEMES · WINDOWS · MACOS · LINUX</text>
  <rect x="66" y="566" width="212" height="42" fill="#1710E6"/>
  <text x="82" y="594" font-family="Consolas, monospace" font-size="18" fill="#FFFFFF">tcode.thinakaran.dev</text>
</svg>`;

await sharp(Buffer.from(ogSvg)).png().toFile(path.join(root, "public", "images", "og", "default.png"));

console.log("brand + OG assets generated");
