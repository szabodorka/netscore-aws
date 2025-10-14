import { useEffect, useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import Loading from "../../components/Loading/Loading";
import Error from "../../components/Error/Error";
import ReviewCard from "../../components/ReviewCard/ReviewCard";
import "./MyAccount.css";

export default function MyAccount() {
  const navigate = useNavigate();
  const userId = Number(localStorage.getItem("userId"));
  const [user, setUser] = useState(null);
  const [reviews, setReviews] = useState([]);
  const [websiteNames, setWebsiteNames] = useState({});
  const [loadingUser, setLoadingUser] = useState(false);
  const [loadingReviews, setLoadingReviews] = useState(false);
  const [error, setError] = useState(null);
  const username = localStorage.getItem("username");

  useEffect(() => {
    if (!userId) {
      navigate("/");
      return;
    }

    async function loadUser() {
      setLoadingUser(true);
      setError(null);
      try {
        const response = await fetch(`/api/user/${userId}`);
        if (!response.ok) {
          setUser(null);
          setError("Failed to load user");
        } else {
          const data = await response.json();
          setUser(data);
        }
      } catch (err) {
        console.error("Error:", err);
        setUser(null);
        setError("Internal Server Error");
      }
      setLoadingUser(false);
    }

    async function loadReviews() {
      setLoadingReviews(true);
      try {
        const response = await fetch(`/api/review/user/${userId}`);
        if (!response.ok) {
          setReviews([]);
        } else {
          const data = await response.json();
          setReviews(Array.isArray(data) ? data : []);
        }
      } catch (err) {
        console.error("Error:", err);
        setReviews([]);
      }
      setLoadingReviews(false);
    }

    loadUser();
    loadReviews();
  }, [userId, navigate]);

  useEffect(() => {
    async function fillWebsiteNames() {
      const ids = [
        ...new Set(
          reviews
            .map((review) => review.websiteId)
            .filter((valid) => valid != null)
        ),
      ].filter((id) => websiteNames[id] == null);
      if (ids.length === 0) return;
      const cache = { ...websiteNames };
      await Promise.all(
        ids.map(async (websiteId) => {
          try {
            const response = await fetch(`/api/website/${websiteId}`);
            if (response.ok) {
              const website = await response.json();
              cache[websiteId] = {
                name: website?.name || `Website #${websiteId}`,
                domain: website?.domain || "",
              };
            } else {
              cache[websiteId] = { name: `Website #${websiteId}`, domain: "" };
            }
          } catch (err) {
            console.error("Error", err);
            cache[websiteId] = { name: `Website #${websiteId}`, domain: "" };
          }
        })
      );
      setWebsiteNames(cache);
    }
    if (reviews.length > 0) {
      fillWebsiteNames();
    }
  }, [reviews, websiteNames]);

  async function handleDeleteAccount() {
    const ok = window.confirm(
      "Are you sure you want to permanently delete your account?"
    );
    if (!ok) return;
    try {
      const response = await fetch(`/api/user/${userId}`, { method: "DELETE" });
      if (!response.ok) {
        alert("Failed to delete account.");
        return;
      }
      localStorage.removeItem("userId");
      localStorage.removeItem("username");
      navigate("/");
    } catch (err) {
      console.error("Error:", err);
    }
  }

  return (
    <section className="account-page">
      <div className="container">
        <h2 className="account-title">My Account</h2>
        {error && <Error message={error} />}
        {loadingUser && <Loading />}
        {!loadingUser && user && (
          <div className="account-card">
            <div className="account-row">
              <span className="label">Username:</span>
              <span className="value">{user.username || username}</span>
            </div>
            <div className="account-row">
              <span className="label">Registered:</span>
              <span className="value">
                {new Date(user.registration_date).toLocaleString()}
              </span>
            </div>
            <div className="account-actions">
              <button className="delete" onClick={handleDeleteAccount}>
                Delete account
              </button>
              <Link className="back" to="/u/websites">
                Back to Home page
              </Link>
            </div>
          </div>
        )}

        <section className="account-reviews">
          <h3>My Reviews</h3>
          {loadingReviews && <Loading />}
          {!loadingReviews && reviews.length === 0 && (
            <p className="no-reviews">No reviews to display</p>
          )}
          {!loadingReviews && reviews.length > 0 && (
            <div className="reviews-grid">
              {reviews.map((review) => (
                <div key={review.id} className="review-with-website">
                  <div className="review-website">
                    <span className="website-name">
                      {websiteNames[review.websiteId]?.name ||
                        `Website #${review.websiteId}`}
                    </span>
                    <Link
                      className="website-link"
                      to={`/u/website/${review.websiteId}`}
                    >
                      View website
                    </Link>
                  </div>
                  <ReviewCard
                    score={review.score}
                    comment={review.comment}
                    userName={user?.username || username}
                    postDate={review.postDate}
                  />
                </div>
              ))}
            </div>
          )}
        </section>
      </div>
    </section>
  );
}
