-- DROP DATABASE IF EXISTS utube_db;
-- CREATE DATABASE utube_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE utube_db;

-- 1. Users
CREATE TABLE users (
                           user_id INT AUTO_INCREMENT PRIMARY KEY,
                           email VARCHAR(255) NOT NULL UNIQUE,
                           password VARCHAR(255) NOT NULL,
                           username VARCHAR(100) NOT NULL UNIQUE,
                           date_of_birth DATE NOT NULL,
                           gender ENUM('home', 'dona', 'no declarat') NOT NULL,
                           country VARCHAR(100) NOT NULL,
                           postal_code VARCHAR(20) NOT NULL
);

-- 2. Videos
CREATE TABLE videos (
                        video_id INT AUTO_INCREMENT PRIMARY KEY,
                        user_id INT NOT NULL,
                        title VARCHAR(255) NOT NULL,
                        description TEXT,
                        size BIGINT NOT NULL COMMENT 'Size in bytes',
                        filename VARCHAR(255) NOT NULL,
                        duration INTEGER NOT NULL COMMENT 'Duration in seconds',
                        thumbnail VARCHAR(255),
                        views INTEGER NOT NULL DEFAULT 0,
                        likes_count INTEGER NOT NULL DEFAULT 0,
                        dislikes_count INTEGER NOT NULL DEFAULT 0,
                        status ENUM('públic', 'ocult', 'privat') NOT NULL DEFAULT 'public',
                        published_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 3. Tags
CREATE TABLE tags (
                        tag_id INT AUTO_INCREMENT PRIMARY KEY,
                        name VARCHAR(50) NOT NULL UNIQUE
);


-- 3.1. Tags vs videos
CREATE TABLE videos_tags (
                         video_id INT NOT NULL,
                         tag_id INT NOT NULL,
                         PRIMARY KEY (video_id, tag_id),
                         FOREIGN KEY (video_id) REFERENCES videos(video_id) ON DELETE CASCADE,
                         FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
);

-- 4. Channels
CREATE TABLE channels (
                           channel_id INT AUTO_INCREMENT PRIMARY KEY,
                           user_id INT NOT NULL,
                           name VARCHAR(50) NOT NULL UNIQUE,
                           description TEXT,
                           created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           CONSTRAINT fk_channels_users
                               FOREIGN KEY (user_id) REFERENCES users(user_id)
                                   ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 5. Subscriptions
CREATE TABLE subscriptions (
                           user_id INT NOT NULL,
                           channel_id INT NOT NULL,
                           subscribed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           PRIMARY KEY (user_id, channel_id),
                           FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                           FOREIGN KEY (channel_id) REFERENCES channels(channel_id) ON DELETE CASCADE
);

-- 6. Video reactions
CREATE TABLE video_reactions (
                             user_id INT NOT NULL,
                             video_id INT NOT NULL,
                             reaction_type ENUM('like', 'dislike') NOT NULL,
                             created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (user_id, video_id),
                             FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                             FOREIGN KEY (video_id) REFERENCES videos(video_id) ON DELETE CASCADE
);

-- 7. Playlists
CREATE TABLE playlists (
                      playlist_id INT AUTO_INCREMENT PRIMARY KEY,
                      user_id INT NOT NULL,
                      name VARCHAR(100) NOT NULL UNIQUE,
                      created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                      status ENUM('públic', 'privat') NOT NULL DEFAULT 'public',
                      FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 7.1. Playlists vs videos
CREATE TABLE playlists_videos (
                      playlist_id INT NOT NULL,
                      video_id INT NOT NULL,
                      PRIMARY KEY (playlist_id, video_id),
                      FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id) ON DELETE CASCADE,
                      FOREIGN KEY (video_id) REFERENCES videos(video_id) ON DELETE CASCADE
);

-- 8. Comments
CREATE TABLE comments (
                             comment_id INT AUTO_INCREMENT PRIMARY KEY,
                             user_id INT NOT NULL,
                             video_id INT NOT NULL,
                             comment_body TEXT NOT NULL,
                             published_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                             FOREIGN KEY (video_id) REFERENCES videos(video_id) ON DELETE CASCADE
);

-- 8.1. Comment reactions
CREATE TABLE comment_reactions (
                           user_id INT NOT NULL,
                           comment_id INT NOT NULL,
                           reaction_type ENUM('like', 'dislike') NOT NULL,
                           created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           PRIMARY KEY (user_id, comment_id),
                           FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                           FOREIGN KEY (comment_id) REFERENCES comments(comment_id) ON DELETE CASCADE
);
