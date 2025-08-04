package com.github.jinhojinho.blindseoul_backend.repository;

import com.github.jinhojinho.blindseoul_backend.domain.EmailVerification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface EmailVerificationRepository extends JpaRepository<EmailVerification, String> {
    Optional<EmailVerification> findByEmail(String email);
}

