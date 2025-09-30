import "./WebsiteCard.css";

export default function WebsiteCard({ url, postDate, onClick }) {
  return (
    <div
      className="website-card"
      role="button"
      tabIndex={0}
      onClick={onClick}
      onKeyDown={(e) => {
        if (e.key === "Enter") onClick?.();
      }}
    >
      <div className="website-card-url">{url}</div>
      <div className="website-card-meta">
        posted {new Date(postDate).toLocaleString()}
      </div>
    </div>
  );
}
