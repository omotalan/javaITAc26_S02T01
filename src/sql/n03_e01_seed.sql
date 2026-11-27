-- USE spotifai;

-- 1. USERS (2 Premium, 1 Free)
INSERT INTO users (user_type, email, password, username, birth_date, gender, country, postal_code) VALUES
                                                                                                       ('premium', 'laia.vila@example.com', 'hashed_pw_123', 'laiav', '1996-04-15', 'Female', 'Spain', '08001'),
                                                                                                       ('premium', 'marc.soler@example.com', 'hashed_pw_456', 'marcs_bcn', '1992-11-03', 'Male', 'Spain', '08015'),
                                                                                                       ('free', 'alex.roca@example.com', 'hashed_pw_789', 'alexr', '2001-08-22', 'Non-binary', 'Spain', '17001');

-- 2. SUBSCRIPTIONS
INSERT INTO subscriptions (user_id, start_date, renewal_date, payment_method) VALUES
                                                                                  (1, '2026-01-15', '2026-12-15', 'credit_card'),
                                                                                  (2, '2026-03-01', '2026-12-01', 'paypal');


-- 3. PAYMENT DETAILS
INSERT INTO credit_cards (user_id, card_number, expiration_month, expiration_year, security_code) VALUES
    (1, '4532015112830366', 9, 2028, '842');

INSERT INTO paypal_accounts (user_id, paypal_username) VALUES
    (2, 'marc.soler.pay');


-- 4. PAYMENTS
INSERT INTO payments (subscription_id, payment_date, order_number, total) VALUES
                                                                              (1, '2026-01-15 10:15:00', 'ORD-2026-0001', 10.99),
                                                                              (1, '2026-02-15 10:15:00', 'ORD-2026-0045', 10.99),
                                                                              (2, '2026-03-01 18:30:00', 'ORD-2026-0089', 10.99);

-- 5. ARTISTS & RELATED ARTISTS
INSERT INTO artists (name, image_url) VALUES
                                          ('Rosalía', 'https://spotifyclone.com'),
                                          ('C. Tangana', 'https://spotifyclone.com'),
                                          ('Wu Tang Clan', 'https://spotifyclone.com'),
                                          ('Racionais MCs', 'https://spotifyclone.com');

INSERT INTO related_artists (artist_id, related_artist_id) VALUES
                                                               (1, 2), (2, 1),
                                                               (3, 4), (4, 3);


-- 6. ALBUMS & SONGS
INSERT INTO albums (artist_id, title, release_year, cover_image_url) VALUES
                                                                         (1, 'MOTOMAMI', 2022, 'https://spotifyclone.com'),
                                                                         (2, 'El Madrileño', 2021, 'https://spotifyclone.com'),
                                                                         (3, 'Enter the Chamber', 2013, 'https://spotifyclone.com');

INSERT INTO songs (album_id, title, duration, play_count) VALUES
                                                              (1, 'SAOKO', 137, 450000000),
                                                              (1, 'BIZCOCHITO', 109, 380000000),
                                                              (2, 'Tú Me Dejaste De Querer', 198, 620000000),
                                                              (3, 'Bells Of War', 369, 1200000000),
                                                              (3, 'Shadowboxin''', 337, 890000000);

-- 7. PLAYLISTS (2 Active, 1 Soft-Deleted)
INSERT INTO playlists (user_id, title, song_count, created_at, status, deleted_at) VALUES
                                                                                       (1, 'Barcelona Vibes', 3, '2026-05-10 14:00:00', 'active', NULL),
                                                                                       (2, 'Coding Focus', 2, '2026-06-01 09:20:00', 'active', NULL),
                                                                                       (1, 'Old Workout Mix', 1, '2025-11-12 17:45:00', 'deleted', '2026-04-02 12:10:00');

-- 8. PLAYLIST SONGS (Demonstrating shared additions by different users)
INSERT INTO playlist_songs (playlist_id, song_id, added_by_user_id, added_at) VALUES
                                                                                  (1, 1, 1, '2026-05-10 14:05:00'),
                                                                                  (1, 3, 2, '2026-05-11 19:12:00'),
                                                                                  (1, 4, 3, '2026-05-12 08:40:00'),
                                                                                  (2, 4, 2, '2026-06-01 09:22:00'),
                                                                                  (2, 5, 2, '2026-06-01 09:25:00'),
                                                                                  (3, 2, 1, '2025-11-12 17:46:00');

-- 9. FAVORITES & FOLLOWS
INSERT INTO user_followed_artists (user_id, artist_id) VALUES
                                                           (1, 1), (1, 3),
                                                           (2, 2), (2, 3),
                                                           (3, 1);

INSERT INTO user_favorite_albums (user_id, album_id) VALUES
                                                         (1, 1), (1, 3),
                                                         (2, 2);

INSERT INTO user_favorite_songs (user_id, song_id) VALUES
                                                       (1, 1), (1, 4),
                                                       (2, 3), (2, 5),
                                                       (3, 2);


-- ==========================================
-- Sample queries
-- ==========================================

SELECT
    p.title AS playlist,
    p.status,
    s.title AS song,
    a.name AS artist,
    u.username AS added_by,
    ps.added_at
FROM playlist_songs ps
         JOIN playlists p ON ps.playlist_id = p.playlist_id
         JOIN songs s ON ps.song_id = s.song_id
         JOIN albums al ON s.album_id = al.album_id
         JOIN artists a ON al.artist_id = a.artist_id
         JOIN users u ON ps.added_by_user_id = u.user_id;

-- ==========================================
-- Constraint test
-- ==========================================

INSERT INTO credit_cards (user_id, card_number, expiration_month, expiration_year, security_code) VALUES (999, '4111111111111111', 12, 2030, '123'); -- FK: credit_cards.user_id → users.user_id (will FAIL)

INSERT INTO related_artists (artist_id, related_artist_id) VALUES (1, 1); -- CHECK: artist_id <> related_artist_id (will FAIL)
