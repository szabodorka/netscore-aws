import { FaCheckCircle } from "react-icons/fa";
import "./CheckRating.css";

export default function CheckRating({ score }) {
  const fullCheck = Math.floor(score);
  const hasHalf = score % 1 >= 0.5;

  return (
    <div className="score-display">
      {Array.from({ length: 5 }).map((_, i) => {
        if (i < fullCheck) {
          return <FaCheckCircle key={i} className="check-filled" />;
        } else if (i === fullCheck && hasHalf) {
          return <FaCheckCircle key={i} className="check-half" />;
        } else {
          return <FaCheckCircle key={i} className="check-empty" />;
        }
      })}
    </div>
  );
}
