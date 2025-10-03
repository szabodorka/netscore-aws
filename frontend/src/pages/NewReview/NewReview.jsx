import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Loading from "../../components/Loading/Loading";
import Error from "../../components/Error/Error";
import "./NewReview.css";

function toDomain(input) {
  if (!input) return "";
  let url = input;
  if (!/^https?:\/\//i.test(url)) url = `http://${url}`;
  try {
    const newUrl = new URL(url);
    const host = newUrl.hostname.toLowerCase();
    const parts = host.split(".").filter(Boolean);
    if (parts.length >= 2) {
      return `${parts[parts.length - 2]}.${parts[parts.length - 1]}`;
    }
    return host;
  } catch {
    return "";
  }
}

export default function NewReview() {
  const navigate = useNavigate();
  const userId = Number(localStorage.getItem("userId")) || 0;
  const [websiteInput, setWebsiteInput] = useState("");
  const [domain, setDomain] = useState("");
  const [similar, setSimilar] = useState([]);
  const [selectedWebsite, setSelectedWebsite] = useState(null);
  const [loadingSimilar, setLoadingSimilar] = useState(false);
  const [error, setError] = useState(null);
  const [score, setScore] = useState(5);
  const [comment, setComment] = useState("");
  const [newSiteDescription, setNewSiteDescription] = useState("");
  const [submitting, setSubmitting] = useState(false);

  async function handleShowSimilar(e) {
    e.preventDefault();
    setError(null);
    const domain = toDomain(websiteInput);
    setDomain(domain);
    setSelectedWebsite(null);
    setSimilar([]);
    if (!domain) {
      setError(
        "Please enter a valid URL or domain (e.g., https://google.com)."
      );
      return;
    }
    setLoadingSimilar(true);
    try {
      const response = await fetch(
        `/api/website/search?searchTerm=${encodeURIComponent(domain)}`
      );
      if (!response.ok) {
        setSimilar([]);
      } else {
        const data = await response.json();
        setSimilar(Array.isArray(data) ? data : []);
      }
    } catch {
      setSimilar([]);
    }
    setLoadingSimilar(false);
  }

  function pickSite(website) {
    setSelectedWebsite(website);
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError(null);
    if (!(score >= 1 && score <= 5)) {
      setError("Score must be between 1 and 5");
      return;
    }
    if (!comment) {
      setError("Comment is required");
      return;
    }
    setSubmitting(true);
    try {
      let websiteId;
      if (selectedWebsite?.id) {
        websiteId = selectedWebsite.id;
      } else {
        if (!domain) {
          setError("Click 'Show similar' first to extract a valid domain.");
          setSubmitting(false);
          return;
        }
        const createResponse = await fetch("/api/website/", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            url: domain,
            userId: userId,
            description: newSiteDescription || null,
          }),
        });
        if (!createResponse.ok) {
          setError("Error creating website.");
          setSubmitting(false);
          return;
        }
        websiteId = await createResponse.json();
      }

      const reviewResponse = await fetch("/api/review/", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ score, comment, userId, websiteId }),
      });
      if (!reviewResponse.ok) {
        setError("Error creating review.");
        setSubmitting(false);
        return;
      }
      navigate(`/u/website/${websiteId}`);
    } catch (err) {
      console.error("Error", err);
      setError("Internal Server Error");
    }
    setSubmitting(false);
  }

  const creatingNew = domain && similar.length === 0 && !selectedWebsite?.id;

  return (
    <section className="newreview-page">
      <div className="container">
        <h2 className="newreview-title">Create New Review</h2>
        <Error message={error} />
        <form className="newreview-form" onSubmit={handleSubmit}>
          <div className="newreview-field">
            <label htmlFor="newreview-website" className="newreview-label">
              Website URL
            </label>
            <div className="newreview-row">
              <input
                id="newreview-website"
                className="newreview-input"
                placeholder="e.g. https://www.google.com/"
                value={websiteInput}
                onChange={(e) => setWebsiteInput(e.target.value)}
              />
              <button
                className="newreview-btn similar"
                onClick={handleShowSimilar}
              >
                Show similar
              </button>
            </div>
          </div>
          <div className="newreview-similar">
            {loadingSimilar && <Loading />}
            {!loadingSimilar && similar.length > 0 && (
              <>
                <p className="newreview-similar-title">Similar websites</p>
                <div className="newreview-similar-grid">
                  {similar.map((website) => (
                    <div
                      key={website.id}
                      className={`newreview-similar-card ${
                        selectedWebsite?.id === website.id ? "selected" : ""
                      }`}
                      onClick={() => pickSite(website)}
                      role="button"
                      tabIndex={0}
                      onKeyDown={(e) => {
                        if (e.key === "Enter") pickSite(website);
                      }}
                    >
                      <div className="newreview-similar-url">{website.url}</div>
                      <div className="newreview-similar-meta">
                        posted{" "}
                        {website.postDate
                          ? new Date(website.postDate).toLocaleString()
                          : "-"}
                      </div>
                    </div>
                  ))}
                </div>
              </>
            )}
            {!loadingSimilar && domain && similar.length === 0 && (
              <p className="newreview-empty">
                No matches. Submitting will create a new website:{" "}
                <strong>{domain}</strong>
              </p>
            )}
          </div>
          {creatingNew && (
            <div className="newreview-field">
              <label htmlFor="newreview-desc" className="newreview-label">
                Website description (optional)
              </label>
              <textarea
                id="newreview-desc"
                className="newreview-input"
                rows={4}
                value={newSiteDescription}
                onChange={(e) => setNewSiteDescription(e.target.value)}
                placeholder="Short description of the website"
              />
            </div>
          )}
          <div className="newreview-field">
            <label htmlFor="newreview-score" className="newreview-label">
              Score (1–5)
            </label>
            <select
              id="newreview-score"
              className="newreview-input"
              value={score}
              onChange={(e) => setScore(Number(e.target.value))}
            >
              {[1, 2, 3, 4, 5].map((number) => (
                <option key={number} value={number}>
                  {number}
                </option>
              ))}
            </select>
          </div>
          <div className="newreview-field">
            <label htmlFor="newreview-comment" className="newreview-label">
              Comment
            </label>
            <textarea
              id="newreview-comment"
              className="newreview-input"
              rows={5}
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              placeholder="Share your experience…"
            />
          </div>
          <div className="newreview-actions">
            <button
              className="newreview-btn submit"
              type="submit"
              disabled={submitting || !userId}
            >
              {submitting ? "Submitting…" : "Create review"}
            </button>
          </div>
        </form>
      </div>
    </section>
  );
}
