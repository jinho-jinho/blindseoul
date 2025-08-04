package com.github.jinhojinho.blindseoul_backend.domain;

import com.github.jinhojinho.blindseoul_backend.domain.id.CommentLikeId;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "comment_likes")
@IdClass(CommentLikeId.class)
public class CommentLike {
    @Id
    private Long userId;

    @Id
    private Long commentId;
}