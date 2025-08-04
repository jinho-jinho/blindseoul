package com.github.jinhojinho.blindseoul_backend.controller;

import com.github.jinhojinho.blindseoul_backend.domain.User;
import com.github.jinhojinho.blindseoul_backend.dto.UserLoginRequestDto;
import com.github.jinhojinho.blindseoul_backend.dto.UserResponseDto;
import com.github.jinhojinho.blindseoul_backend.dto.UserSignupRequestDto;
import com.github.jinhojinho.blindseoul_backend.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserController {

    private final UserService userService;

    @PostMapping("/signup")
    public ResponseEntity<String> signup(@Valid @RequestBody UserSignupRequestDto dto) {
        Long userId = userService.signup(dto);
        return ResponseEntity.ok("회원가입 성공 (id: " + userId + ")");
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@Valid @RequestBody UserLoginRequestDto dto) {
        User user = userService.login(dto);
        return ResponseEntity.ok("로그인 성공 (id: " + user.getId() + ")");
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserResponseDto> getUser(@PathVariable Long id) {
        UserResponseDto userDto = userService.getUser(id);
        return ResponseEntity.ok(userDto);
    }
}

