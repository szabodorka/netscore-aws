import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import Layout from "./components/layout/Layout";
import Home from "./pages/Home/Home";
import WebsitePage from "./pages/Website/WebsitePage";
import NewReview from "./pages/NewReview/NewReview";
import Login from "./pages/Login/Login";
import Register from "./pages/Register/Register";
import MyAccount from "./pages/Account/MyAccount";

export default function App() {
  const userId = localStorage.getItem("userId");

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/register" element={<Register />} />

        <Route path="/u" element={<Layout />}>
          <Route path="/u/websites" element={<Home />} />
          <Route path="/u/website/:id" element={<WebsitePage />} />
          <Route path="/u/review/new" element={<NewReview />} />
          <Route path="/u/account" element={<MyAccount />} />
        </Route>

        <Route
          path="*"
          element={
            userId ? (
              <Navigate to="/u/websites" replace />
            ) : (
              <Navigate to="/" replace />
            )
          }
        />
      </Routes>
    </BrowserRouter>
  );
}
