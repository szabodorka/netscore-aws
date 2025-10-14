import { useEffect, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import Loading from "../../components/Loading/Loading";
import WebsiteCard from "../../components/WebsiteCard/WebsiteCard";
import "./Home.css";

export default function Home() {
  const [websites, setWebsites] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const location = useLocation();
  const navigate = useNavigate();

  const params = new URLSearchParams(location.search);
  const searchTerm = params.get("searchTerm") || "";

  useEffect(() => {
    async function loadWebsites() {
      setLoading(true);
      setError(null);
      try {
        const url = searchTerm
          ? `/api/website/search?searchTerm=${encodeURIComponent(searchTerm)}`
          : `/api/website/all`;

        const response = await fetch(url);
        if (!response.ok) {
          setError("Failed to load websites");
          setWebsites([]);
          setLoading(false);
          return;
        }
        const data = await response.json();
        setWebsites(Array.isArray(data) ? data : []);
      } catch (err) {
        setError("Error:", err);
        setWebsites([]);
      }
      setLoading(false);
    }
    loadWebsites();
  }, [searchTerm]);

  function handleCardClick(id) {
    navigate(`/u/website/${id}`);
  }

  return (
    <section className="home-page">
      <div className="container">
        {loading && <Loading />}
        {!loading && error && <p className="home-error">{error}</p>}
        {!loading && !error && websites.length === 0 && (
          <p className="home-empty">No websites found</p>
        )}
        {!loading && !error && websites.length > 0 && (
          <div className="website-grid">
            {websites.map((website) => (
              <WebsiteCard
                key={website.id}
                domain={website.domain}
                name={website.name}
                postDate={website.postDate}
                onClick={() => handleCardClick(website.id)}
              />
            ))}
          </div>
        )}
      </div>
    </section>
  );
}
