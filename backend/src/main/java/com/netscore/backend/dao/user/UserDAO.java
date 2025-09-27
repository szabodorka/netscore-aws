package com.netscore.backend.dao.user;

import com.netscore.backend.dao.model.user.NewUser;
import com.netscore.backend.dao.model.user.User;

public interface UserDAO {
    User getUser(int id);
    int createUser(NewUser user);
    void deleteUser(int id);
    int getUserIdByUsername(String username);
    boolean existsById(int id);
}
