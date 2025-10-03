package com.netscore.backend.controller.dto.website;

import java.time.LocalDateTime;

public record WebsiteDTO(int id, String domain, String name, String url, String description, Integer userId, LocalDateTime postDate) {
}
