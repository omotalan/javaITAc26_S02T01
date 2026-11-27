-- CREATE DATABASE IF NOT EXISTS spotifai CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE spotifai;

-- 1. USERS
CREATE TABLE users (
                       user_id INT AUTO_INCREMENT PRIMARY KEY,
                       user_type ENUM('free', 'premium') NOT NULL DEFAULT 'free',
                       email VARCHAR(255) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       username VARCHAR(100) NOT NULL UNIQUE,
                       birth_date DATE NOT NULL,
                       gender ENUM('Male', 'Female', 'Non-binary', 'Prefer not to say') NOT NULL,
                       country VARCHAR(100) NOT NULL,
                       postal_code VARCHAR(20) NOT NULL
);

-- 2. SUBSCRIPTIONS (Only for premium users)
CREATE TABLE subscriptions (
                               subscription_id INT AUTO_INCREMENT PRIMARY KEY,
                               user_id INT NOT NULL,
                               start_date DATE NOT NULL,
                               renewal_date DATE NOT NULL,
                               payment_method ENUM('credit_card', 'paypal') NOT NULL,
                               FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 3. PAYMENT DETAILS (Subtype tables for Credit Card AND PayPal)
CREATE TABLE credit_cards (
                              card_id INT AUTO_INCREMENT PRIMARY KEY,
                              user_id INT NOT NULL UNIQUE,
                              card_number VARCHAR(20) NOT NULL,
                              expiration_month TINYINT UNSIGNED NOT NULL,
                              expiration_year SMALLINT UNSIGNED NOT NULL,
                              security_code VARCHAR(4) NOT NULL,
                              FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE paypal_accounts (
                                 paypal_id INT AUTO_INCREMENT PRIMARY KEY,
                                 user_id INT NOT NULL UNIQUE,
                                 paypal_username VARCHAR(100) NOT NULL,
                                 FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 4. PAYMENT HISTORY
CREATE TABLE payments (
                          payment_id INT AUTO_INCREMENT PRIMARY KEY,
                          subscription_id INT NOT NULL,
                          payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          order_number VARCHAR(50) NOT NULL UNIQUE,
                          total DECIMAL(10, 2) NOT NULL,
                          FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id) ON DELETE CASCADE
);

-- 5. ARTISTS AND RELATED ARTISTS
CREATE TABLE artists (
                         artist_id INT AUTO_INCREMENT PRIMARY KEY,
                         name VARCHAR(150) NOT NULL,
                         image_url VARCHAR(255)
);

CREATE TABLE related_artists (
                                 artist_id INT NOT NULL,
                                 related_artist_id INT NOT NULL,
                                 PRIMARY KEY (artist_id, related_artist_id),
                                 FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
                                 FOREIGN KEY (related_artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
                                 CHECK (artist_id <> related_artist_id)
);

-- 6. ALBUMS AND SONGS
CREATE TABLE albums (
                        album_id INT AUTO_INCREMENT PRIMARY KEY,
                        artist_id INT NOT NULL,
                        title VARCHAR(200) NOT NULL,
                        release_year YEAR NOT NULL,
                        cover_image_url VARCHAR(255),
                        FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE
);

CREATE TABLE songs (
                       song_id INT AUTO_INCREMENT PRIMARY KEY,
                       album_id INT NOT NULL,
                       title VARCHAR(200) NOT NULL,
                       duration INT NOT NULL COMMENT 'Duration in seconds',
                       play_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
                       FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE CASCADE
);

-- 7. PLAYLISTS (with soft delete)
CREATE TABLE playlists (
                           playlist_id INT AUTO_INCREMENT PRIMARY KEY,
                           user_id INT NOT NULL,
                           title VARCHAR(150) NOT NULL,
                           song_count INT UNSIGNED NOT NULL DEFAULT 0,
                           created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           status ENUM('active', 'deleted') NOT NULL DEFAULT 'active',
                           deleted_at DATETIME NULL DEFAULT NULL,
                           FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 8. PLAYLIST SONGS
CREATE TABLE playlist_songs (
                                playlist_id INT NOT NULL,
                                song_id INT NOT NULL,
                                added_by_user_id INT NOT NULL,
                                added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                PRIMARY KEY (playlist_id, song_id),
                                FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id) ON DELETE CASCADE,
                                FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
                                FOREIGN KEY (added_by_user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 9. USER FAVORITES AND FOLLOWS
CREATE TABLE user_followed_artists (
                                       user_id INT NOT NULL,
                                       artist_id INT NOT NULL,
                                       PRIMARY KEY (user_id, artist_id),
                                       FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                                       FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE
);

CREATE TABLE user_favorite_albums (
                                      user_id INT NOT NULL,
                                      album_id INT NOT NULL,
                                      PRIMARY KEY (user_id, album_id),
                                      FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                                      FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE CASCADE
);

CREATE TABLE user_favorite_songs (
                                     user_id INT NOT NULL,
                                     song_id INT NOT NULL,
                                     PRIMARY KEY (user_id, song_id),
                                     FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                                     FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE
);
