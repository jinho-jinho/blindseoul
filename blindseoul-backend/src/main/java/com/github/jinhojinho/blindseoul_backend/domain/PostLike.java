package com.github.jinhojinho.blindseoul_backend.domain;

import com.github.jinhojinho.blindseoul_backend.domain.id.PostLikeId;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "post_likes")
@IdClass(PostLikeId.class)
public class PostLike {
    @Id
    private Long userId;

    @Id
    private Long postId;
}
