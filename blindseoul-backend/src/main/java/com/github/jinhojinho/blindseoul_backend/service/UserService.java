package com.github.jinhojinho.blindseoul_backend.service;

import com.github.jinhojinho.blindseoul_backend.domain.User;
import com.github.jinhojinho.blindseoul_backend.dto.UserLoginRequestDto;
import com.github.jinhojinho.blindseoul_backend.dto.UserResponseDto;
import com.github.jinhojinho.blindseoul_backend.dto.UserSignupRequestDto;
import com.github.jinhojinho.blindseoul_backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    /** 회원가입 */
    @Transactional
    public Long signup(UserSignupRequestDto dto) {
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        User user = new User();
        user.setEmail(dto.getEmail());
        user.setName(dto.getName());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));

        userRepository.save(user);
        return user.getId();
    }

    /** 로그인: 이메일/비번 검증만 수행 (토큰 발급은 컨트롤러에서) */
    @Transactional(readOnly = true)
    public User login(UserLoginRequestDto dto) {
        User user = userRepository.findByEmail(dto.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 이메일입니다."));

        if (!passwordEncoder.matches(dto.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }
        return user;
    }

    /** id로 사용자 조회 (관리자/디버그 용) */
    @Transactional(readOnly = true)
    public UserResponseDto getUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));
        return toDto(user);
    }

    /** /user/me 용: 이메일로 현재 사용자 조회 */
    @Transactional(readOnly = true)
    public UserResponseDto getByEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));
        return toDto(user);
    }

    private static UserResponseDto toDto(User user) {
        return new UserResponseDto(
                user.getId(),
                user.getEmail(),
                user.getName(),
                user.getCreatedAt()
        );
    }
}
