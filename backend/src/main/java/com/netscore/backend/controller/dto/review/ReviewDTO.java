package com.netscore.backend.controller.dto.review;

import java.time.LocalDateTime;

public record ReviewDTO(int id, int score, String comment, Integer userId, LocalDateTime postDate, int websiteId) {
}
