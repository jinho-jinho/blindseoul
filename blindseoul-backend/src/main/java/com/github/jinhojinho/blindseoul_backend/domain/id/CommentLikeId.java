package com.github.jinhojinho.blindseoul_backend.domain.id;

import java.io.Serializable;
import java.util.Objects;

public class CommentLikeId implements Serializable {
    private Long userId;
    private Long commentId;

    public CommentLikeId() {}

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof CommentLikeId)) return false;
        CommentLikeId that = (CommentLikeId) o;
        return Objects.equals(userId, that.userId) && Objects.equals(commentId, that.commentId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, commentId);
    }
}