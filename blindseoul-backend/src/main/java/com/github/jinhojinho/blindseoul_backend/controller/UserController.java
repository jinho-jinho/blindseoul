package com.github.jinhojinho.blindseoul_backend.controller;

import com.github.jinhojinho.blindseoul_backend.domain.User;
import com.github.jinhojinho.blindseoul_backend.dto.UserLoginRequestDto;
import com.github.jinhojinho.blindseoul_backend.dto.UserResponseDto;
import com.github.jinhojinho.blindseoul_backend.dto.UserSignupRequestDto;
import com.github.jinhojinho.blindseoul_backend.dto.common.ApiResponse;
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
    public ResponseEntity<ApiResponse<Long>> signup(@Valid @RequestBody UserSignupRequestDto dto) {
        Long userId = userService.signup(dto);
        return ResponseEntity.ok(
                new ApiResponse<>(true, userId, "회원가입 성공")
        );
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<Long>> login(@Valid @RequestBody UserLoginRequestDto dto) {
        User user = userService.login(dto);
        return ResponseEntity.ok(
                new ApiResponse<>(true, user.getId(), "로그인 성공")
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<UserResponseDto>> getUser(@PathVariable Long id) {
        UserResponseDto userDto = userService.getUser(id);
        return ResponseEntity.ok(
                new ApiResponse<>(true, userDto, "회원 정보 조회 성공")
        );
    }
}

