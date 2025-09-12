package com.netscore.backend.dao.model.review;

public record NewReview(int score, String comment, int userId, int websiteId) {
}
