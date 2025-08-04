package com.github.jinhojinho.blindseoul_backend.domain.id;

import java.io.Serializable;
import java.util.Objects;

public class PostBookmarkId implements Serializable {
    private Long userId;
    private Long postId;

    public PostBookmarkId() {}

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PostBookmarkId)) return false;
        PostBookmarkId that = (PostBookmarkId) o;
        return Objects.equals(userId, that.userId) && Objects.equals(postId, that.postId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, postId);
    }
}
