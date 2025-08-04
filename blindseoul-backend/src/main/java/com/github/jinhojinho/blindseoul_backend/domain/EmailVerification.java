package com.github.jinhojinho.blindseoul_backend.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "email_verifications")
@Getter
@Setter
public class EmailVerification {
    @Id
    private String email;

    @Column(length = 10)
    private String code;

    private LocalDateTime expiresAt;

    private boolean verified = false;
}
