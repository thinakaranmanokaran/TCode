import { Link } from "react-router-dom";
import { ArrowUpRight, Command, Download, Monitor, Terminal } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { Reveal } from "../components/Reveal.jsx";
import { siteConfig } from "../data/site.js";
import {
  graphSchema,
  websiteSchema,
  softwareSchema,
  personSchema,
  breadcrumbSchema,
} from "../data/schema.js";

const schema = graphSchema([
  websiteSchema,
  softwareSchema,
  personSchema,
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "Download", path: "/download" },
  ]),
]);

function downloadUrl(file) {
  return `${siteConfig.links.releases}/download/${file}`;
}

function PlatformCard({ icon: Icon, name, version, description, links }) {
  return (
    <Reveal className="platform-card">
      <div className="platform-card__icon">
        <Icon size={21} strokeWidth={1.5} />
      </div>
      <h3 className="platform-card__name">{name}</h3>
      <div className="eyebrow" style={{ marginTop: 10, color: "var(--muted)" }}>
        {version}
      </div>
      <p className="platform-card__desc">{description}</p>
      <div className="platform-card__links">
        {links.map((link) => (
          <a
            className="platform-card__link"
            href={downloadUrl(link.file)}
            key={link.file}
            aria-label={`${link.label} for ${name}`}
          >
            <span>{link.label}</span>
            <span>
              <Download size={15} strokeWidth={1.6} />
            </span>
          </a>
        ))}
      </div>
    </Reveal>
  );
}

export function DownloadPage() {
  const d = siteConfig.downloads;

  return (
    <>
      <PageMeta
        title="Download T Code — Free Editor for Windows, Linux & macOS"
        description="Download T Code 2.1.7 for Windows, Linux, or macOS. Portable builds, installers, AppImage, and DMG packages. Free, open source, and about 5 MB."
        path="/download"
        keywords="download T Code, free code editor, Windows editor, Linux editor, macOS editor, portable editor"
        imageAlt="Download T Code for Windows Linux and macOS"
      />
      <JsonLd data={schema} />

      <PageHero
        eyebrow={`Download · v${siteConfig.version} · ${siteConfig.license}`}
        title={
          <>
            Download T Code.
            <br />
            Stay <em>light.</em>
          </>
        }
        sub="Pick your platform. The portable builds run from a folder with no installer. The packaged builds add T Code to your desktop."
        meta={["Windows 10+", "Linux x86_64", "macOS universal"]}
        actions={
          <a
            className="btn btn--blue"
            href={siteConfig.links.releases}
            target="_blank"
            rel="noreferrer"
          >
            Latest release on GitHub <ArrowUpRight size={17} strokeWidth={1.6} />
          </a>
        }
      />

      <section className="site-container" style={{ paddingBottom: 90 }}>
        <div className="platform-grid">
          <PlatformCard
            icon={Monitor}
            name="Windows"
            version="x86_64 · Windows 10 and later"
            description="ConPTY terminal support, native dialogs, and a portable build that runs from any folder."
            links={[d.windowsPortable, d.windowsInstaller]}
          />
          <PlatformCard
            icon={Command}
            name="macOS"
            version="Universal · Apple Silicon + Intel"
            description="A universal build for modern Macs, packaged as a portable archive or a DMG image."
            links={[d.macPortable, d.macDmg]}
          />
          <PlatformCard
            icon={Terminal}
            name="Linux"
            version="x86_64 · X11 and Wayland"
            description="A portable tarball for any distribution, plus an AppImage you can make executable and run."
            links={[d.linuxPortable, d.linuxAppImage]}
          />
        </div>

        <div className="download-note">
          <div className="download-note__box">
            <h3>Portable mode</h3>
            <p>
              Create a folder named <code>user</code> next to <code>tcode.exe</code>{" "}
              (or the <code>tcode</code> binary). T Code will load and store
              settings, plugins, and themes in that folder. Carry the whole
              directory on a USB drive and your setup travels with you.
            </p>
          </div>
          <div className="download-note__box">
            <h3>Build from source</h3>
            <p>
              Install Meson, Ninja, SDL3, PCRE2, FreeType, and Lua 5.4, then run:
            </p>
            <pre
              style={{
                marginTop: 16,
                padding: 16,
                background: "var(--ink)",
                color: "var(--paper)",
                fontFamily: "var(--font-mono)",
                fontSize: 12,
                lineHeight: 1.8,
                overflowX: "auto",
              }}
            >
              {`meson setup application/build
meson compile -C application/build`}
            </pre>
          </div>
        </div>

        <div
          style={{
            marginTop: 54,
            paddingTop: 28,
            borderTop: "1px solid var(--line)",
            display: "grid",
            gridTemplateColumns: "1fr 1fr",
            gap: 40,
          }}
          className="download-requirements"
        >
          <div>
            <div className="eyebrow" style={{ color: "var(--electric)" }}>
              System requirements
            </div>
            <ul
              style={{
                marginTop: 16,
                paddingLeft: 18,
                color: "var(--muted)",
                lineHeight: 2,
                fontSize: 15,
              }}
            >
              <li>Windows 10 version 1809 or later (ConPTY terminal)</li>
              <li>Linux x86_64 with X11 or Wayland</li>
              <li>macOS 10.11+ · macOS 11+ for Apple Silicon</li>
              <li>No account, subscription, or bundled browser runtime</li>
            </ul>
          </div>
          <div>
            <div className="eyebrow" style={{ color: "var(--electric)" }}>
              What you get
            </div>
            <ul
              style={{
                marginTop: 16,
                paddingLeft: 18,
                color: "var(--muted)",
                lineHeight: 2,
                fontSize: 15,
              }}
            >
              <li>A full editor in about 5 MB</li>
              <li>24 bundled themes and third-party theme support</li>
              <li>Integrated terminal, menus, multi-cursor, and project search</li>
              <li>MIT licensed source code and a plugin ecosystem</li>
            </ul>
            <p style={{ marginTop: 18, color: "var(--muted)", fontSize: 13 }}>
              Assets are published on the{" "}
              <a
                className="link-arrow"
                style={{ fontSize: 13 }}
                href={siteConfig.links.releases}
                target="_blank"
                rel="noreferrer"
              >
                latest GitHub release
              </a>
              .
            </p>
          </div>
        </div>
      </section>

      <SectionCta
        kicker="Make it yours"
        title={
          <>
            A small editor.
            <br />
            A <em>big</em> upgrade.
          </>
        }
        actions={
          <>
            <Link className="btn btn--blue" to="/features">
              Explore features <ArrowUpRight size={17} strokeWidth={1.6} />
            </Link>
            <Link className="btn btn--paper" to="/themes">
              Browse 24 themes
            </Link>
          </>
        }
      />
    </>
  );
}
