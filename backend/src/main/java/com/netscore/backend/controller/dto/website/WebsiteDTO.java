package com.netscore.backend.controller.dto.website;

import java.time.LocalDateTime;

public record WebsiteDTO(int id, String url, Integer userId, LocalDateTime postDate) {
}
