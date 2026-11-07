export function PageHero({ eyebrow, title, sub, meta = [], actions, dark = false, children }) {
  return (
    <section className={`page-hero ${dark ? "page-hero--dark" : ""}`}>
      <div className="site-container">
        {eyebrow ? <div className="page-hero__eyebrow">{eyebrow}</div> : null}
        <h1 className="display">{title}</h1>
        {sub ? <p className="page-hero__sub">{sub}</p> : null}
        {meta.length ? (
          <div className="page-hero__meta">
            {meta.map((item) => (
              <span key={item}>{item}</span>
            ))}
          </div>
        ) : null}
        {actions ? <div className="page-hero__actions">{actions}</div> : null}
        {children}
      </div>
    </section>
  );
}
