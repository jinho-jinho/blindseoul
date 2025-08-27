package com.github.jinhojinho.blindseoul_backend.config;

import com.github.jinhojinho.blindseoul_backend.config.jwt.JwtAuthenticationFilter;
import com.github.jinhojinho.blindseoul_backend.config.security.JwtAuthenticationEntryPoint;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtFilter;
    private final JwtAuthenticationEntryPoint authenticationEntryPoint;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .csrf(csrf -> csrf.disable())
                .formLogin(form -> form.disable())
                .httpBasic(basic -> basic.disable())
                // 인증/인가 규칙
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/user/signup", "/user/login", "/user/password/reset").permitAll()
                        .requestMatchers("/api/auth/**").permitAll()
                        .requestMatchers("/blindwalk/nearby").permitAll()
                        // OPTIONS(CORS Preflight) 허용 (필요 시)
                        .requestMatchers(org.springframework.http.HttpMethod.OPTIONS, "/**").permitAll()
                        // 나머지는 인증 필요
                        .anyRequest().authenticated()
                )
                // 인증 실패시 401
                .exceptionHandling(ex -> ex.authenticationEntryPoint(authenticationEntryPoint))
                // JWT 필터 등록: UsernamePasswordAuthenticationFilter 앞
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
