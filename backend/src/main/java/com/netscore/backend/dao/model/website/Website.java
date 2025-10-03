package com.netscore.backend.dao.model.website;

import java.time.LocalDateTime;

public record Website(int id, String domain, String name, String url, String description, Integer userId, LocalDateTime postDate) {
}
