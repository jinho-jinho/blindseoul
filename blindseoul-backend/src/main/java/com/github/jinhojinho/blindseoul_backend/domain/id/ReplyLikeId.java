package com.github.jinhojinho.blindseoul_backend.domain.id;

import java.io.Serializable;
import java.util.Objects;

public class ReplyLikeId implements Serializable {
    private Long userId;
    private Long replyId;

    public ReplyLikeId() {}

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ReplyLikeId)) return false;
        ReplyLikeId that = (ReplyLikeId) o;
        return Objects.equals(userId, that.userId) && Objects.equals(replyId, that.replyId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, replyId);
    }
}
