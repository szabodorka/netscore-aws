import { Outlet } from "react-router-dom";
import Navbar from "../Navbar/Navbar";
import "./Layout.css";

export default function Layout() {
  return (
    <div className="layout">
      <Navbar />
      <main className="layout-container">
        <Outlet />
      </main>
    </div>
  );
}
