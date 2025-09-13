package com.netscore.backend.dao.model.website;

import java.time.LocalDateTime;

public record Website(int id, String url, int userId, LocalDateTime postDate) {
}
