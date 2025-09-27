package com.netscore.backend.service;

import com.netscore.backend.controller.dto.user.NewUserDTO;
import com.netscore.backend.controller.dto.user.UserDTO;
import com.netscore.backend.dao.model.user.NewUser;
import com.netscore.backend.dao.model.user.User;
import com.netscore.backend.dao.user.UserDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;


@Service
public class UserService {
    private final UserDAO userDAO;

    @Autowired
    public UserService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    public UserDTO getUserById(int id) {
        try {
            User user = userDAO.getUser(id);
            return new UserDTO(user.id(), user.username(), user.registration_date());
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while getting user by ID", e);
        }
    }

    public int addNewUser(NewUserDTO newUserDTO) {
        try {
            String username = newUserDTO.username();
            String passwordHash = BCrypt.hashpw(newUserDTO.password(), BCrypt.gensalt());
            NewUser newUser = new NewUser(
                    username,
                    passwordHash
            );
            return userDAO.createUser(newUser);
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while adding new user", e);
        }
    }

    public int loginUser(NewUserDTO newUserDTO){
        try {
            int id = userDAO.getUserIdByUsername(newUserDTO.username());
            String passwordHash = userDAO.getPasswordHashById(id);
            if (passwordHash == null || !BCrypt.checkpw(newUserDTO.password(), passwordHash)) {
                return -1;
            }
            return id;
        } catch (RuntimeException e) {
            throw new RuntimeException("Service Error: could not log in user.", e);
        }
    }

    public void deleteUserById(int id) {
        try {
            userDAO.deleteUser(id);
        } catch (RuntimeException e) {
            throw new RuntimeException("Error while deleting user", e);
        }
    }
}
