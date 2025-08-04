package com.github.jinhojinho.blindseoul_backend.service;

import com.github.jinhojinho.blindseoul_backend.domain.User;
import com.github.jinhojinho.blindseoul_backend.dto.UserLoginRequestDto;
import com.github.jinhojinho.blindseoul_backend.dto.UserResponseDto;
import com.github.jinhojinho.blindseoul_backend.dto.UserSignupRequestDto;
import com.github.jinhojinho.blindseoul_backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public Long signup(UserSignupRequestDto dto) {
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        User user = new User();
        user.setEmail(dto.getEmail());
        user.setName(dto.getName());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));

        User saved = userRepository.save(user);
        return saved.getId();
    }

    public User login(UserLoginRequestDto dto) {
        User user = userRepository.findByEmail(dto.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 이메일입니다."));

        if (!passwordEncoder.matches(dto.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }

        return user;
    }

    public UserResponseDto getUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("사용자를 찾을 수 없습니다."));

        return new UserResponseDto(user.getId(), user.getEmail(), user.getName(), user.getCreatedAt());
    }
}
