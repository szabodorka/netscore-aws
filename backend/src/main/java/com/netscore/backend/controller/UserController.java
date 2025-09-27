package com.netscore.backend.controller;


import com.netscore.backend.controller.dto.user.NewUserDTO;
import com.netscore.backend.controller.dto.user.UserDTO;
import com.netscore.backend.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api/user")
public class UserController {
    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }


    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable int id) {
        try {
            UserDTO user = userService.getUserById(id);
            if (user == null) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok(user);
        } catch (RuntimeException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/name/{id}")
    public ResponseEntity<String> getUserNameById(@PathVariable int id) {
        try {
            UserDTO user = userService.getUserById(id);
            if (user == null) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok(user.username());
        } catch (RuntimeException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping("/login")
    public ResponseEntity<Integer> login(@RequestBody NewUserDTO newUser) {
        try {
            int userId = userService.loginUser(newUser);
            if (userId == -1) {
                return ResponseEntity.badRequest().build();
            }
            return ResponseEntity.ok(userId);
        } catch (RuntimeException e) {
            return ResponseEntity.internalServerError().build();
        }
    }



    @PostMapping("/")
    public ResponseEntity<Integer> addNewUser(@RequestBody NewUserDTO user) {
        try {
            int id = userService.addNewUser(user);
            return ResponseEntity.status(HttpStatus.CREATED).body(id);

        } catch (RuntimeException e) {
            return ResponseEntity.internalServerError().build();
        }
    }


    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteUserById(@PathVariable int id) {
        userService.deleteUserById(id);
    }
}

