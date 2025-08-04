package com.github.jinhojinho.blindseoul_backend.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class UserLoginRequestDto {

    @Email
    @NotBlank
    private String email;

    @NotBlank
    private String password;
}