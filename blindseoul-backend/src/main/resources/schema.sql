CREATE TABLE users (
                       id SERIAL PRIMARY KEY,
                       name VARCHAR(50) NOT NULL,
                       email VARCHAR(100) UNIQUE NOT NULL,
                       password VARCHAR(100) NOT NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
                       id SERIAL PRIMARY KEY,
                       user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                       title VARCHAR(100),
                       category VARCHAR(50),
                       content TEXT NOT NULL,
                       audio_path VARCHAR(255),
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comments (
                          id SERIAL PRIMARY KEY,
                          post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
                          user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                          content TEXT NOT NULL,
                          audio_path VARCHAR(255),
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE replies (
                         id SERIAL PRIMARY KEY,
                         comment_id INTEGER REFERENCES comments(id) ON DELETE CASCADE,
                         user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                         content TEXT NOT NULL,
                         audio_path VARCHAR(255),
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE post_likes (
                            user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                            post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
                            PRIMARY KEY (user_id, post_id)
);

CREATE TABLE post_bookmarks (
                                user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                                post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
                                PRIMARY KEY (user_id, post_id)
);

CREATE TABLE comment_likes (
                               user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                               comment_id INTEGER REFERENCES comments(id) ON DELETE CASCADE,
                               PRIMARY KEY (user_id, comment_id)
);

CREATE TABLE reply_likes (
                             user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
                             reply_id INTEGER REFERENCES replies(id) ON DELETE CASCADE,
                             PRIMARY KEY (user_id, reply_id)
);
