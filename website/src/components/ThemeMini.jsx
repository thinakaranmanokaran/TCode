export function ThemePreview({ theme }) {
  const c = theme.colors;

  return (
    <div
      className="theme-preview"
      style={{ background: c.background, color: c.text }}
      aria-hidden="true"
    >
      <div className="theme-preview__window">
        <span className="theme-preview__dot" style={{ background: c.keyword }} />
        <span className="theme-preview__dot" style={{ background: c.string }} />
        <span className="theme-preview__dot" style={{ background: c.function }} />
      </div>
      <div style={{ fontFamily: "var(--font-mono)", fontSize: 11, lineHeight: 1.9 }}>
        <div>{"// "}{theme.name}</div>
        <div>import {"{ editor }"} from &quot;tcode&quot;</div>
        <div style={{ marginTop: 10 }}>const theme = &quot;{theme.group}&quot;</div>
        <div>function build() {"{"}</div>
        <div style={{ paddingLeft: 14 }}>return 24; {"// themes"}</div>
        <div>{"}"}</div>
        <div style={{ marginTop: 10 }}>{"$ tcode ."}</div>
      </div>
    </div>
  );
}

export function ThemeCard({ theme }) {
  return (
    <article className="theme-page-card">
      <ThemePreview theme={theme} />
      <div className="theme-page-card__meta">
        <span className="theme-page-card__name">{theme.name}</span>
        <span className="theme-page-card__group">{theme.group}</span>
      </div>
    </article>
  );
}
