import { Link, useNavigate } from "react-router-dom";
import { useState } from "react";
import logo from "../../assets/netscore_logo.PNG";
import "./Navbar.css";

export default function Navbar() {
  const [searchTerm, setSearchTerm] = useState("");
  const navigate = useNavigate();
  const username = localStorage.getItem("username");

  function handleSearch(e) {
    e.preventDefault();
    const query = searchTerm.trim();
    navigate(
      `/u/websites${query ? `?searchTerm=${encodeURIComponent(query)}` : ""}`
    );
    setSearchTerm("");
  }

  function handleLogout() {
    localStorage.removeItem("userId");
    localStorage.removeItem("username");
    navigate("/");
  }

  return (
    <header className="navbar">
      <Link className="navbar-logo-container" to="/u/websites">
        <img src={logo} alt="NetScore logo" className="navbar-logo" />
      </Link>

      <form className="navbar-search" onSubmit={handleSearch}>
        <input
          className="navbar-input"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          placeholder="Search websites..."
        />
        <button className="navbar-btn" type="submit">
          Search
        </button>
      </form>

      <nav className="navbar-actions">
        <Link className="navbar-link" to="/u/review/new">
          Create Review
        </Link>
        <Link className="navbar-link" to="/u/account">
          My Account{username ? ` (${username})` : ""}
        </Link>
        <button className="navbar-btn" onClick={handleLogout}>
          Logout
        </button>
      </nav>
    </header>
  );
}
