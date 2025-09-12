package com.netscore.backend.controller.dto.review;

public record NewReviewDTO(int score, String comment, int userId, int websiteId) {
}
