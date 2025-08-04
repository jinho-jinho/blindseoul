package com.github.jinhojinho.blindseoul_backend.domain;

import com.github.jinhojinho.blindseoul_backend.domain.id.ReplyLikeId;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "reply_likes")
@IdClass(ReplyLikeId.class)
public class ReplyLike {
    @Id
    private Long userId;

    @Id
    private Long replyId;
}