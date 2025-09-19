package com.netscore.backend.controller.dto.user;

import java.time.LocalDateTime;

public record UserDTO(int id, String username, LocalDateTime registration_date) {
}
