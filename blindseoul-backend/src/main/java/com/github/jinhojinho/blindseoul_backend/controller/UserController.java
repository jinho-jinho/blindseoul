package com.github.jinhojinho.blindseoul_backend.controller;

import com.github.jinhojinho.blindseoul_backend.domain.User;
import com.github.jinhojinho.blindseoul_backend.dto.UserLoginRequestDto;
import com.github.jinhojinho.blindseoul_backend.dto.UserResponseDto;
import com.github.jinhojinho.blindseoul_backend.dto.UserSignupRequestDto;
import com.github.jinhojinho.blindseoul_backend.dto.common.ApiResponse;
import com.github.jinhojinho.blindseoul_backend.dto.LoginResponseDto;
import com.github.jinhojinho.blindseoul_backend.service.UserService;
import com.github.jinhojinho.blindseoul_backend.config.jwt.JwtTokenProvider;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserController {

    private final UserService userService;
    private final JwtTokenProvider jwtTokenProvider;

    @Value("${jwt.access-token-validity-ms}")
    private long accessTokenValidityMs;

    /** 회원가입 (무인증) */
    @PostMapping("/signup")
    public ResponseEntity<ApiResponse<Long>> signup(@Valid @RequestBody UserSignupRequestDto dto) {
        Long userId = userService.signup(dto);
        return ResponseEntity.ok(new ApiResponse<>(true, userId, "회원가입 성공"));
    }

    /** 로그인 → JWT 발급 (무인증) */
    @PostMapping("/login")
    public ResponseEntity<ApiResponse<LoginResponseDto>> login(@Valid @RequestBody UserLoginRequestDto dto) {
        User user = userService.login(dto); // 이메일/비번 검증
        String accessToken = jwtTokenProvider.createToken(user.getEmail(), user.getId());

        var payload = new LoginResponseDto(accessToken, "Bearer", accessTokenValidityMs);
        return ResponseEntity.ok(new ApiResponse<>(true, payload, "로그인 성공"));
    }

    /** 현재 사용자 정보 (JWT 필요) */
    @GetMapping("/me")
    public ResponseEntity<ApiResponse<UserResponseDto>> me(Authentication authentication) {
        // authentication.getName() == UserDetails.username == 이메일
        UserResponseDto userDto = userService.getByEmail(authentication.getName());
        return ResponseEntity.ok(new ApiResponse<>(true, userDto, "회원 정보 조회 성공"));
    }

    /** (선택) ID로 사용자 조회 — 일반적으로는 /me 사용 권장 (JWT 필요) */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<UserResponseDto>> getUser(@PathVariable Long id) {
        UserResponseDto userDto = userService.getUser(id);
        return ResponseEntity.ok(new ApiResponse<>(true, userDto, "회원 정보 조회 성공"));
    }
}
