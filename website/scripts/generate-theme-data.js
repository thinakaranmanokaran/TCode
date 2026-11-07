import { readFile, writeFile, readdir } from "node:fs/promises";
import path from "node:path";

const colorsDir = path.resolve(process.cwd(), "..", "application", "data", "colors");
const output = path.resolve(process.cwd(), "src", "data", "themes.js");

const files = (await readdir(colorsDir)).filter((file) => file.endsWith(".lua")).sort();

function pickColor(source, key) {
  const match = source.match(new RegExp(`style\\.${key}\\s*=\\s*\\{\\s*common\\.color\\s+"(#[0-9a-fA-F]{6,8})"`));
  return match ? match[1].slice(0, 7) : null;
}

function pickSyntax(source, key) {
  const match = source.match(new RegExp(`style\\.syntax\\["${key}"\\]\\s*=\\s*\\{\\s*common\\.color\\s+"(#[0-9a-fA-F]{6,8})"`));
  return match ? match[1].slice(0, 7) : null;
}

function label(slug) {
  return slug
    .replace(/^bearded-/, "")
    .replace(/^monokai-/, "")
    .split("-")
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(" ");
}

const themes = [];

for (const file of files) {
  const slug = file.replace(/\.lua$/, "");
  const source = await readFile(path.join(colorsDir, file), "utf8");
  let group = "Classic";
  if (slug.startsWith("bearded-")) group = "Bearded";
  else if (slug.startsWith("monokai")) group = "Monokai";

  themes.push({
    slug,
    name: slug === "default" ? "Default" : group === "Bearded" ? `Bearded ${label(slug)}` : group === "Monokai" ? `Monokai ${label(slug)}` : label(slug),
    group,
    colors: {
      background: pickColor(source, "background") || "#1e2227",
      background2: pickColor(source, "background2") || "#17191d",
      accent: pickColor(source, "accent") || "#88c0d0",
      text: pickColor(source, "text") || "#d8dee9",
      comment: pickSyntax(source, "comment") || "#5c6370",
      keyword: pickSyntax(source, "keyword") || "#c678dd",
      string: pickSyntax(source, "string") || "#98c379",
      number: pickSyntax(source, "number") || "#d19a66",
      function: pickSyntax(source, "function") || "#61afef",
    },
  });
}

const contents = `// Generated from application/data/colors by scripts/generate-theme-data.js\nexport const themes = ${JSON.stringify(themes, null, 2)};\n`;

await writeFile(output, contents, "utf8");
console.log(`wrote ${themes.length} themes`);
