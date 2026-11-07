import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { features as defaultFeatures } from "../data/features.js";
import { assetPath } from "../data/base.js";
import { SectionHeading } from "./SectionHeading.jsx";
import { Reveal } from "./Reveal.jsx";

const imageSizes = {
  "/images/screenshots/terminal-drawer.webp": { width: 1122, height: 654 },
  "/images/screenshots/terminal.webp": { width: 1122, height: 654 },
  "/images/screenshots/command-palette.webp": { width: 900, height: 654 },
  "/images/screenshots/file-menu.webp": { width: 760, height: 654 },
  "/images/screenshots/find-file.webp": { width: 900, height: 654 },
  "/images/screenshots/editor.webp": { width: 1122, height: 654 },
  "/images/screenshots/editor-oceanic.webp": { width: 1122, height: 654 },
  "/images/screenshots/theme-menu.webp": { width: 760, height: 654 },
  "/images/screenshots/explorer-menu.webp": { width: 560, height: 654 },
  "/images/screenshots/selection-menu.webp": { width: 560, height: 654 },
};

function FeatureVisual({ feature }) {
  if (feature.visual === "plugins") {
    return (
      <div className="plugin-panel">
        <div className="eyebrow" style={{ color: "var(--lime)", marginBottom: 18 }}>
          Lite XL plugin API · mod-version 4
        </div>
        {[
          ["terminal", "built in"],
          ["minimap", "compatible"],
          ["lsp", "compatible"],
          ["projectsearch", "built in"],
          ["settings", "built in"],
        ].map(([name, status]) => (
          <div className="plugin-row" key={name}>
            <span>{name}</span>
            <span>{status}</span>
          </div>
        ))}
      </div>
    );
  }

  if (feature.visual === "specs") {
    return (
      <div
        className="spec-panel"
        style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 30 }}
      >
        {[
          ["5.0 MB", "Windows binary"],
          ["C + Lua", "core"],
          ["24", "themes"],
          ["0", "browser runtimes"],
        ].map(([value, label]) => (
          <div key={label}>
            <div className="spec-panel__value">{value}</div>
            <div className="spec-panel__label">{label}</div>
          </div>
        ))}
        <div
          className="mono"
          style={{
            gridColumn: "1 / -1",
            marginTop: 10,
            paddingTop: 20,
            borderTop: "1px solid rgba(250,250,250,.12)",
            color: "rgba(250,250,250,.55)",
            fontSize: 12,
          }}
        >
          No Electron. No bundled browser. Just an editor.
        </div>
      </div>
    );
  }

  const size = imageSizes[feature.image] || { width: 1200, height: 645 };

  return (
    <img
      className="feature-card__shot"
      src={assetPath(feature.image)}
      alt={feature.imageAlt}
      width={size.width}
      height={size.height}
      loading="lazy"
      decoding="async"
    />
  );
}

function FeatureCard({ feature, index }) {
  return (
    <Reveal as="article" className="feature-card" id={feature.slug} delay={(index % 2) * 60}>
      <span className="blue-tab" aria-hidden="true">
        {feature.number}
      </span>
      <span className="blue-tab blue-tab--bottom" aria-hidden="true">
        {feature.number}
      </span>

      <div className="feature-card__info">
        <div className="feature-card__category">{feature.category}</div>
        <h3 className="feature-card__title">{feature.title}</h3>
        <p className="feature-card__desc">{feature.description}</p>

        <div className="feature-card__specs">
          {feature.specs.map((spec) => (
            <div className="feature-card__spec" key={spec.label}>
              <span>{spec.label}</span>
              <span>{spec.value}</span>
            </div>
          ))}
        </div>

        <div className="feature-card__details">
          {feature.details.map((detail, detailIndex) => (
            <details key={detail.label} open={detailIndex === 0}>
              <summary>{detail.label}</summary>
              <p>{detail.body}</p>
            </details>
          ))}
        </div>

        <div className="feature-card__cta">
          <Link className="link-arrow" to={feature.href}>
            Explore feature <ArrowUpRight size={16} strokeWidth={1.6} />
          </Link>
        </div>
      </div>

      <div className="feature-card__visual">
        <FeatureVisual feature={feature} />
      </div>
    </Reveal>
  );
}

export function FeatureShowcase({ items = defaultFeatures, heading = true }) {
  return (
    <>
      {heading ? (
        <div className="site-container">
          <SectionHeading
            title="Features"
            index={String(items.length).padStart(2, "0")}
            note={
              <>
                The parts you&apos;ll use <em>every day</em>
              </>
            }
            sub="Seven upgrades that make T Code feel like a modern desktop editor — without the browser-sized download."
          />
        </div>
      ) : null}
      <div className="site-container feature-stack">
        {items.map((feature, index) => (
          <FeatureCard feature={feature} index={index} key={feature.slug} />
        ))}
      </div>
    </>
  );
}
