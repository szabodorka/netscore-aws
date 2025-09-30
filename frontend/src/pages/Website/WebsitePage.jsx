import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import Loading from "../../components/Loading/Loading";
import ReviewCard from "../../components/ReviewCard/ReviewCard";
import CheckRating from "../../components/CheckRating/CheckRating";
import "./WebsitePage.css";

export default function WebsitePage() {
  const { id } = useParams();
  const [website, setWebsite] = useState(null);
  const [websiteUserName, setWebsiteUserName] = useState(null);
  const [reviews, setReviews] = useState([]);
  const [userNames, setUserNames] = useState({});
  const [loadingSite, setLoadingSite] = useState(false);
  const [loadingReviews, setLoadingReviews] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    async function loadWebsite() {
      setLoadingSite(true);
      setError(null);
      try {
        const response = await fetch(`/api/website/${id}`);
        if (!response.ok) {
          setError("Failed to load website details");
          setWebsite(null);
          setLoadingSite(false);
          return;
        }
        const data = await response.json();
        setWebsite(data);
        if (data?.userId != null) {
          try {
            const res = await fetch(`/api/user/name/${data.userId}`);
            if (res.ok) {
              const name = await res.text();
              setWebsiteUserName(name || "deleted user");
            } else {
              setWebsiteUserName("deleted user");
            }
          } catch {
            setWebsiteUserName("deleted user");
          }
        } else {
          setWebsiteUserName("deleted user");
        }
      } catch (err) {
        setError("Error:", err);
        setWebsite(null);
      }
      setLoadingSite(false);
    }

    async function loadReviewsAndUsernames() {
      setLoadingReviews(true);
      try {
        const response = await fetch(`/api/review/website/${id}`);
        if (!response.ok) {
          setReviews([]);
          setUserNames({});
          setLoadingReviews(false);
          return;
        }
        const data = await response.json();
        setReviews(Array.isArray(data) ? data : []);

        const ids = [
          ...new Set(
            data.map((review) => review.userId).filter((id) => id != null)
          ),
        ];
        if (ids.length === 0) {
          setUserNames({});
          setLoadingReviews(false);
          return;
        }
        const cache = {};
        await Promise.all(
          ids.map(async (userId) => {
            try {
              const response = await fetch(`/api/user/name/${userId}`);
              if (response.ok) {
                const name = await response.text();
                cache[userId] = name || "deleted user";
              } else {
                cache[userId] = "deleted user";
              }
            } catch {
              cache[userId] = "deleted user";
            }
          })
        );
        setUserNames(cache);
      } catch {
        setReviews([]);
        setUserNames({});
      }
      setLoadingReviews(false);
    }
    loadWebsite();
    loadReviewsAndUsernames();
  }, [id]);

  const averageScore =
    reviews.length > 0
      ? (
          reviews.reduce((acc, review) => acc + (review.score ?? 0), 0) /
          reviews.length
        ).toFixed(1)
      : null;

  return (
    <section className="website-page">
      <div className="container">
        {loadingSite && <Loading />}
        {error && <p className="website-error">{error}</p>}
        {!loadingSite && website && (
          <>
            <header className="website-header">
              <h2 className="website-title">{website.url}</h2>
              <div className="website-meta">
                <span>
                  Posted:{" "}
                  {website.postDate
                    ? new Date(website.postDate).toLocaleString()
                    : "-"}
                </span>
                <span>By {websiteUserName || "deleted user"}</span>
              </div>
              <div className="website-aggregate">
                {averageScore !== null && (
                  <span className="avg-row">
                    <CheckRating score={averageScore} />
                    <span className="avg-num">{averageScore}/5 </span>
                    <span className="avg-count">
                      ({reviews.length} review{reviews.length > 1 ? "s" : ""})
                    </span>
                  </span>
                )}
              </div>
            </header>

            <section className="reviews-section">
              <h3>Reviews</h3>
              {loadingReviews && <Loading />}
              {!loadingReviews && reviews.length === 0 && (
                <p className="reviews-empty">No reviews yet</p>
              )}
              {!loadingReviews && reviews.length > 0 && (
                <div className="reviews-grid">
                  {reviews.map((review) => (
                    <ReviewCard
                      key={review.id}
                      score={review.score}
                      comment={review.comment}
                      userName={userNames[review.userId] || "deleted user"}
                      postDate={review.postDate}
                    />
                  ))}
                </div>
              )}
            </section>
          </>
        )}
      </div>
    </section>
  );
}
