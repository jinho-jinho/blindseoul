package com.github.jinhojinho.blindseoul_backend.repository;

import com.github.jinhojinho.blindseoul_backend.domain.EmailVerification;
import com.github.jinhojinho.blindseoul_backend.domain.VerificationPurpose;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.Optional;

public interface EmailVerificationRepository extends JpaRepository<EmailVerification, Long> {
    Optional<EmailVerification> findTopByEmailAndPurposeOrderByIdDesc(String email, VerificationPurpose purpose);

    @Modifying
    @Query(value = """
        INSERT INTO public.email_verifications (email, purpose, code, expires_at, verified)
        VALUES (:email, :purpose, :code, :expiresAt, false)
        ON CONFLICT (email, purpose)
        DO UPDATE SET
            code       = EXCLUDED.code,
            expires_at = EXCLUDED.expires_at,
            verified   = false
        """, nativeQuery = true)
    void upsertVerification(@Param("email") String email,
                            @Param("purpose") String purpose,
                            @Param("code") String code,
                            @Param("expiresAt") LocalDateTime expiresAt);

    void deleteByEmailAndPurpose(String email, VerificationPurpose purpose);
}