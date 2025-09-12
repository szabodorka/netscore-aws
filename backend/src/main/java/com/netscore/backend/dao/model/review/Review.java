package com.netscore.backend.dao.model.review;

import java.time.LocalDateTime;

public record Review(int id, String score, String comment, int userId, LocalDateTime postDate, int websiteId) {
}
