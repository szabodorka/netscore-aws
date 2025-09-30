import "./Loading.css";

export default function Loading() {
  return (
    <div
      className="loading-wrap"
      role="status"
      aria-live="polite"
      aria-busy="true"
    >
      <div className="spinner" />
      <span className="loading-text">Loading…</span>
    </div>
  );
}
