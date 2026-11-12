import { Link } from "react-router-dom";
import { ArrowUpRight, Mail } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { siteConfig } from "../data/site.js";
import { assetPath } from "../data/base.js";
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  personSchema,
  breadcrumbSchema,
  webPageSchema,
  organizationSchema,
} from "../data/schema.js";

const facts = [
  ["Name", "T Code"],
  ["Version", siteConfig.version],
  ["License", "MIT"],
  ["Platforms", "Windows, macOS, Linux"],
  ["Windows binary", "About 4.7 MB"],
  ["Portable zip", "About 2.6 MB"],
  ["Creator", siteConfig.author.name],
  ["Website", "thinakaranmanokaran.github.io/TCode"],
  ["Source", "github.com/thinakaranmanokaran/TCode"],
];

const assets = [
  {
    name: "Logo mark",
    file: "/brand/logo-mark.svg",
    note: "SVG, transparent background",
  },
  {
    name: "App icon",
    file: "/brand/icon-512.png",
    note: "PNG, 512 × 512",
  },
  {
    name: "Wordmark",
    file: "/brand/tcode.png",
    note: "PNG, transparent background",
  },
  {
    name: "Editor screenshot",
    file: "/images/screenshots/editor.webp",
    note: "WebP, 16:9 desktop",
  },
  {
    name: "Terminal screenshot",
    file: "/images/screenshots/terminal-drawer.webp",
    note: "WebP, integrated terminal",
  },
  {
    name: "Social card",
    file: "/images/og/default.png",
    note: "PNG, 1200 × 630",
  },
];

const schema = graphSchema([
  websiteSchema,
  softwareSchema,
  personSchema,
  organizationSchema,
  webPageSchema({
    title: "T Code Press Kit",
    description:
      "Brand assets, screenshots, boilerplate, and facts for writing about T Code, the lightweight code editor.",
    path: "/press",
  }),
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "Press kit", path: "/press" },
  ]),
]);

export function PressPage() {
  return (
    <>
      <PageMeta
        title="T Code Press Kit — Logos, Screenshots & Facts"
        description="Brand assets, screenshots, boilerplate, and facts for writing about T Code, the free lightweight code editor for Windows, macOS, and Linux."
        path="/press"
        keywords="T Code press kit, T Code logo, T Code screenshots, lightweight code editor press"
        imageAlt="T Code press kit"
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow="Press · resources"
        title={
          <>
            T Code
            <br />
            press <em>kit.</em>
          </>
        }
        sub="Everything you need to write about T Code: a short description, the facts, logos, screenshots, and a contact."
        meta={["Logos", "Screenshots", "Boilerplate", "Facts"]}
        actions={
          <a className="btn btn--blue" href={`mailto:${siteConfig.links.email}`}>
            <Mail size={17} strokeWidth={1.6} /> Contact
          </a>
        }
      />

      <section className="site-container" style={{ paddingBottom: 90 }}>
        <div className="prose" style={{ marginLeft: 0 }}>
          <h2>Boilerplate</h2>
          <p>
            <strong>One line:</strong> T Code is a free, open-source lightweight
            code editor for Windows, macOS, and Linux.
          </p>
          <p>
            <strong>Short:</strong> T Code is a small code editor built with a C
            core and Lua. It is about 5 MB, starts quickly, and includes a native
            menu bar, an integrated terminal, 24 themes, and a mod-version 4 plugin
            API. It is MIT licensed and free to download.
          </p>
          <p>
            <strong>Long:</strong> T Code is a lightweight code editor created by{" "}
            {siteConfig.author.name}. It uses a C core for rendering and input with
            Lua for the editor and plugins, avoiding Electron and a bundled browser
            runtime. The Windows executable is about 4.7 MB. The editor includes a
            native menu bar, an activity bar, an integrated terminal with tabs and
            shell profiles, project search, multi-cursor editing, Explorer and tab
            context menus, and 24 themes with live preview. T Code runs on Windows,
            macOS, and Linux and is released under the MIT license.
          </p>

          <h2>Fast facts</h2>
          <table className="compare-table">
            <thead>
              <tr>
                <th>Fact</th>
                <th>Value</th>
              </tr>
            </thead>
            <tbody>
              {facts.map(([label, value]) => (
                <tr key={label}>
                  <td>{label}</td>
                  <td>{value}</td>
                </tr>
              ))}
            </tbody>
          </table>

          <h2>Brand assets</h2>
          <p>
            Use the logo and screenshots to illustrate editorial coverage of T
            Code. Do not alter the logo, recolor it, or use it as your own product
            mark. When you mention the product, write “T Code” with a space and
            link to the official site.
          </p>
          <div className="press-assets">
            {assets.map((asset) => (
              <div className="press-asset" key={asset.name}>
                <div className="press-asset__preview">
                  <img
                    src={assetPath(asset.file)}
                    alt={`${asset.name} — T Code`}
                    loading="lazy"
                  />
                </div>
                <h3>{asset.name}</h3>
                <p>{asset.note}</p>
                <a className="link-arrow" href={assetPath(asset.file)} download>
                  Download <ArrowUpRight size={15} strokeWidth={1.6} />
                </a>
              </div>
            ))}
          </div>

          <h2>Usage notes</h2>
          <ul>
            <li>Write “T Code” with a space, not “TCode” or “T-Code.”</li>
            <li>Describe it as a lightweight code editor, not a full IDE.</li>
            <li>Link to the official site or GitHub repository when possible.</li>
            <li>Do not imply endorsement or partnership without permission.</li>
          </ul>

          <h2>Contact</h2>
          <p>
            For interviews, review builds, or corrections, email{" "}
            <a href={`mailto:${siteConfig.links.email}`}>{siteConfig.links.email}</a>.
            You can also find the project on{" "}
            <a href={siteConfig.links.github} target="_blank" rel="noreferrer">
              GitHub
            </a>
            .
          </p>
          <p>
            Looking for the product story? Read{" "}
            <Link to="/about">how T Code became a lightweight code editor</Link>,
            or see the <Link to="/benchmarks">benchmark method</Link>.
          </p>
        </div>
      </section>

      <SectionCta
        kicker="Write about it"
        title={
          <>
            Small software.
            <br />
            <em>Clear</em> story.
          </>
        }
        actions={
          <>
            <Link className="btn btn--blue" to="/download">
              Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
            </Link>
            <a
              className="btn btn--paper"
              href={siteConfig.links.github}
              target="_blank"
              rel="noreferrer"
            >
              View source
            </a>
          </>
        }
      />
    </>
  );
}
