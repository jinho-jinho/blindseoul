package com.github.jinhojinho.blindseoul_backend.controller;

import com.github.jinhojinho.blindseoul_backend.domain.VerificationPurpose;
import com.github.jinhojinho.blindseoul_backend.dto.ResetPasswordRequest;
import com.github.jinhojinho.blindseoul_backend.dto.common.ApiResponse;
import com.github.jinhojinho.blindseoul_backend.repository.EmailVerificationRepository;
import com.github.jinhojinho.blindseoul_backend.service.EmailService;
import com.github.jinhojinho.blindseoul_backend.service.PasswordResetService;
import com.github.jinhojinho.blindseoul_backend.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
public class PasswordController {

    private final PasswordResetService passwordResetService;

    @PostMapping(value = "/password/reset",
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse<Void>> resetPassword(@Valid @RequestBody ResetPasswordRequest req) {
        passwordResetService.resetPassword(req.getEmail(), req.getCode(), req.getNewPassword());
        return ResponseEntity.ok(new ApiResponse<>(true, null, "비밀번호가 변경되었습니다."));
    }
}
