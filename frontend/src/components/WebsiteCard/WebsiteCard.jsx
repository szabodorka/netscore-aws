import "./WebsiteCard.css";

export default function WebsiteCard({ domain, name, postDate, onClick }) {
  const faviconUrl = domain
    ? `https://www.google.com/s2/favicons?domain=${encodeURIComponent(
        domain
      )}&sz=64`
    : null;

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
      <div className="website-card-logo">
        {faviconUrl && (
          <img
            className="website-card-favicon"
            src={faviconUrl}
            alt={`${name} favicon`}
          />
        )}
      </div>
      <div className="website-card-main">
        <h4 className="website-card-title">{name}</h4>
        <div className="website-card-subrow">
          <span className="website-card-domain">{domain}</span>
        </div>
        <div className="website-card-meta">
          posted {new Date(postDate).toLocaleString()}
        </div>
      </div>
    </div>
  );
}
