package com.netscore.backend.dao.model.user;

import java.time.LocalDateTime;

public record User(int id, String username, String password, LocalDateTime registration_date) {
}
