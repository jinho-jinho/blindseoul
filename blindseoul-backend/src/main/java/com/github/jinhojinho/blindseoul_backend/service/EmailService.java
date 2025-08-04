package com.github.jinhojinho.blindseoul_backend.service;

import com.github.jinhojinho.blindseoul_backend.domain.EmailVerification;
import com.github.jinhojinho.blindseoul_backend.repository.EmailVerificationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;
    private final EmailVerificationRepository repository;

    // 인증번호 전송
    public void sendCode(String email) {
        String code = generateCode();
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(5);

        // DB에 저장
        EmailVerification verification = new EmailVerification();
        verification.setEmail(email);
        verification.setCode(code);
        verification.setExpiresAt(expiresAt);
        verification.setVerified(false);
        repository.save(verification);

        // 이메일 전송
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("BlindSeoul 이메일 인증코드");
        message.setText("인증번호: " + code + "\n5분 내로 입력해주세요.");
        mailSender.send(message);
    }

    // 인증번호 검증
    public void verifyCode(String email, String code) {
        EmailVerification verification = repository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("인증 요청을 먼저 해주세요."));

        if (verification.isVerified()) {
            throw new IllegalStateException("이미 인증된 이메일입니다.");
        }

        if (!verification.getCode().equals(code)) {
            throw new IllegalArgumentException("인증번호가 일치하지 않습니다.");
        }

        if (verification.getExpiresAt().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("인증번호가 만료되었습니다.");
        }

        verification.setVerified(true);
        repository.save(verification);
    }

    private String generateCode() {
        return String.format("%06d", new Random().nextInt(999999));
    }
}

