import "./Error.css";

export default function Error({ message }) {
  if (!message) return null;
  return <div className="error">{message}</div>;
}
