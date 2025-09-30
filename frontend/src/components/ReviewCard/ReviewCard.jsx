import "./ReviewCard.css";
import CheckRating from "../CheckRating/CheckRating";

export default function ReviewCard({ score, comment, userName, postDate }) {
  return (
    <div className="review-card">
      <div className="review-row">
        <span className="review-score">
          <CheckRating score={score} />
          <span className="review-score-num">{score}/5</span>
        </span>
        <span className="review-username">
          {userName || "Deleted user"} •{" "}
          {postDate ? new Date(postDate).toLocaleString() : "-"}
        </span>
      </div>
      <p className="review-comment">{comment}</p>
    </div>
  );
}
