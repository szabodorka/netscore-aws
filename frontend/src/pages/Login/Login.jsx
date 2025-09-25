import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import Error from "../../components/Error/Error";
import "./Login.css";
import logo from "../../assets/netscore_logo.PNG";

export default function Login() {
  const [username, setUsername] = useState(
    localStorage.getItem("username") ?? ""
  );
  const [password, setPassword] = useState("");
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  async function handleSubmit(e) {
    e.preventDefault();
    setError(null);
    const response = await fetch(
      `/api/user/login?username=${encodeURIComponent(
        username
      )}&password=${encodeURIComponent(password)}`
    );
    if (!response.ok) {
      setError(
        response.status === 500 ? "Server error" : "Wrong username or password"
      );
      return;
    }
    const id = await response.json();
    localStorage.setItem("userId", id);
    localStorage.setItem("username", username);
    navigate("/u/websites");
  }

  return (
    <div className="auth-container">
      <div className="auth-card">
        <div className="auth-logo-wrapper">
          <img src={logo} alt="NetScore logo" className="auth-logo" />
        </div>
        <h2 className="auth-title">Login</h2>

        <Error message={error} />

        <form className="auth-form" onSubmit={handleSubmit}>
          <label htmlFor="login-username" className="auth-label">
            Username
          </label>
          <input
            id="login-username"
            className="auth-input"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />

          <label htmlFor="login-password" className="auth-label">
            Password
          </label>
          <input
            id="login-password"
            className="auth-input"
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />

          <button type="submit" className="auth-button">
            Login
          </button>
        </form>

        <p className="auth-subtext">
          Don’t have an account?{" "}
          <Link className="auth-link" to="/register">
            Sign up
          </Link>
        </p>
      </div>
    </div>
  );
}
