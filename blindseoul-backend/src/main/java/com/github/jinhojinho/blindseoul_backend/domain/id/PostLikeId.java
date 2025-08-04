package com.github.jinhojinho.blindseoul_backend.domain.id;

import java.io.Serializable;
import java.util.Objects;

public class PostLikeId implements Serializable {
    private Long userId;
    private Long postId;

    public PostLikeId() {}

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PostLikeId)) return false;
        PostLikeId that = (PostLikeId) o;
        return Objects.equals(userId, that.userId) && Objects.equals(postId, that.postId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, postId);
    }
}
