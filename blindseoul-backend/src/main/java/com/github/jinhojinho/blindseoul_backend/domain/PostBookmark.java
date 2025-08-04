package com.github.jinhojinho.blindseoul_backend.domain;

import com.github.jinhojinho.blindseoul_backend.domain.id.PostBookmarkId;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "post_bookmarks")
@IdClass(PostBookmarkId.class)
public class PostBookmark {
    @Id
    private Long userId;

    @Id
    private Long postId;
}
