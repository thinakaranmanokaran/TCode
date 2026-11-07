export function StatStrip({ stats, borderTop = true }) {
  return (
    <div
      className="site-container"
      style={{
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(140px, 1fr))",
        borderTop: borderTop ? "1px solid var(--line)" : undefined,
        paddingTop: 26,
        paddingBottom: 26,
        gap: 20,
      }}
    >
      {stats.map((stat) => (
        <div key={stat.label}>
          <div className="display" style={{ fontSize: "clamp(28px, 3vw, 44px)" }}>
            {stat.value}
          </div>
          <div
            className="eyebrow"
            style={{ marginTop: 8, color: "var(--muted)", letterSpacing: ".06em" }}
          >
            {stat.label}
          </div>
        </div>
      ))}
    </div>
  );
}
