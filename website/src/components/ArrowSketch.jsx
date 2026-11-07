export function ArrowSketch({ className = "", flip = false, style }) {
  return (
    <svg
      className={className}
      width="118"
      height="76"
      viewBox="0 0 118 76"
      fill="none"
      aria-hidden="true"
      style={{ ...(flip ? { transform: "scaleX(-1)" } : null), ...style }}
    >
      <path
        d="M4 68C33 64 66 53 91 19"
        stroke="currentColor"
        strokeWidth="3"
        strokeLinecap="round"
      />
      <path
        d="M72 17L95 16L88 38"
        stroke="currentColor"
        strokeWidth="3"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}
