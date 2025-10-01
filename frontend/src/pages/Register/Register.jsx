import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Error from "../../components/Error/Error";
import "./Register.css";
import logo from "../../assets/netscore_logo.PNG";

export default function Register() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  async function submit(e) {
    e.preventDefault();
    setError(null);
    const response = await fetch("/api/user/", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, password }),
    });
    if (!response.ok) {
      setError("Registration failed");
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
        <h2 className="auth-title">Sign Up</h2>
        <Error message={error} />
        <form className="auth-form" onSubmit={submit}>
          <label htmlFor="registration-username" className="auth-label">
            Username
          </label>
          <input
            id="registration-username"
            className="auth-input"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />
          <label htmlFor="registration-password" className="auth-label">
            Password
          </label>
          <input
            id="registration-password"
            className="auth-input"
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <button type="submit" className="auth-button">
            Create account
          </button>
        </form>
      </div>
    </div>
  );
}
