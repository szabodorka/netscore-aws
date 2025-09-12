package com.netscore.backend.dao.model.review;

import java.time.LocalDateTime;

public record NewReview(String score, String comment, int userId, int websiteId) {
}
