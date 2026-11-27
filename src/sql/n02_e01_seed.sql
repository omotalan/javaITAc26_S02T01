-- USE utube_db;

-- Insert Users
INSERT INTO users (email, password, username, date_of_birth, gender, country, postal_code) VALUES
                                                                                                  ('anna.ferrer@example.com', '$2a$10$Kb...', 'anna_ferr', '1985-03-15', 'home', 'Spain', '08001'),
                                                                                                  ('jordi.soler@example.com', '$2a$10$Kb...', 'jordi_sol', '1990-07-22', 'home', 'Spain', '08002'),
                                                                                                  ('ona.rius@example.com', '$2a$10$Kb...', 'ona_rius', '1992-11-10', 'dona', 'Spain', '08003'),
                                                                                                  ('pau.mas@example.com', '$2a$10$Kb...', 'pau_mas', '1995-05-30', 'home', 'Spain', '08004');

-- Insert Videos
INSERT INTO videos (user_id, title, description, size, filename, duration, thumbnail, views, likes_count, dislikes_count, status, published_at) VALUES
                                                                                                                                           (1, 'Primer vídeo', 'Descripció del primer vídeo', 1024000, 'video1.mp4', 120, 'thumb1.jpg', 150, 12, 3, 'public', '2026-01-15 11:30:00'),
                                                                                                                                           (1, 'Segona incursió', 'Continuem laventura', 2048000, 'video2.mp4', 180, 'thumb2.jpg', 300, 25, 8, 'public', '2026-02-20 14:00:00'),
                                                                                                                                           (2, 'Review de la setmana', 'Analitzem les novetats', 512000, 'video3.mp4', 90, 'thumb3.jpg', 500, 40, 5, 'public', '2026-03-10 17:15:00'),
                                                                                                                                           (3, 'Tutorial de programació', 'Aprenent a codi', 768000, 'video4.mp4', 300, 'thumb4.jpg', 800, 75, 10, 'public', '2026-04-05 09:30:00'),
                                                                                                                                           (4, 'Vlog de viatge', 'Explorant Barcelona', 1536000, 'video5.mp4', 240, 'thumb5.jpg', 600, 50, 7, 'public', '2026-05-12 18:45:00');


-- Insert Tags
INSERT IGNORE INTO tags (name) VALUES
                                   ('programació'),
                                   ('viatge'),
                                   ('tutorial'),
                                   ('review'),
                                   ('youtube');

-- Insert Videos_Tags
INSERT INTO videos_tags (video_id, tag_id) VALUES
                                                (1, 1),
                                                (1, 5),
                                                (2, 2),
                                                (2, 5),
                                                (3, 3),
                                                (3, 5),
                                                (4, 1),
                                                (4, 4),
                                                (5, 2),
                                                (5, 4);

-- Insert Channels
INSERT IGNORE INTO channels (user_id, name, description) VALUES
                                                         (1, 'AnnaFerr', 'Programació i tecnologia'),
                                                         (2, 'JordiSoler', 'Videojocs i ocio'),
                                                         (3, 'OnaRius', 'Viatge i gastronomia'),
                                                         (4, 'PauMas', 'Deport i estil de vida');

-- Insert Subscriptions
INSERT INTO subscriptions (user_id, channel_id, subscribed_at) VALUES
                                                                (1, 2, '2026-01-20 10:00:00'),
                                                                (1, 3, '2026-02-15 14:30:00'),
                                                                (2, 3, '2026-03-01 09:00:00'),
                                                                (2, 4, '2026-04-10 16:00:00'),
                                                                (3, 1, '2026-05-01 11:00:00'),
                                                                (4, 1, '2026-05-15 18:00:00');


-- Insert Video_Reactions
INSERT INTO video_reactions (user_id, video_id, reaction_type, created_at) VALUES
                                                                      (1, 1, 'like', '2026-01-15 11:35:00'),
                                                                      (2, 1, 'like', '2026-01-16 09:00:00'),
                                                                      (3, 1, 'dislike', '2026-01-17 15:00:00'),
                                                                      (1, 2, 'like', '2026-02-21 12:00:00'),
                                                                      (4, 3, 'like', '2026-03-11 10:00:00'),
                                                                      (5, 3, 'dislike', '2026-03-12 14:00:00'),
                                                                      (2, 4, 'like', '2026-04-06 08:00:00'),
                                                                      (3, 5, 'like', '2026-05-13 16:00:00');

-- Insert Playlists
INSERT IGNORE INTO playlists (user_id, name, status) VALUES
                                                    (1, 'Mis favoritas', 'public'),
                                                    (2, 'Programació', 'public'),
                                                    (3, 'Viajes', 'privat'),
                                                    (4, 'Deport', 'public');

-- Insert Playlists_Videos
INSERT INTO playlists_videos (playlist_id, video_id) VALUES
                                                    (1, 1),
                                                    (1, 3),
                                                    (2, 1),
                                                    (2, 4),
                                                    (3, 5),
                                                    (4, 2);

-- Insert Comments
INSERT IGNORE INTO comments (user_id, video_id, comment_body, published_at) VALUES
                                                                  (1, 1, 'Excel·lent vídeo!', '2026-01-15 12:00:00'),
                                                                  (2, 1, 'Més o menys', '2026-01-16 10:00:00'),
                                                                  (3, 2, 'M''hi ha faltat un cop', '2026-02-21 13:00:00'),
                                                                  (4, 3, 'Muy útil, gràcies!', '2026-03-11 11:00:00'),
                                                                  (4, 2, 'M''encanta!', '2026-03-12 09:00:00'),
                                                                  (1, 4, 'Genial', '2026-04-06 12:00:00'),
                                                                  (2, 5, 'Que constància!', '2026-05-13 17:00:00');

-- Insert Comment_Reactions
INSERT INTO comment_reactions (user_id, comment_id, reaction_type, created_at) VALUES
                                                                                  (1, 1, 'like', '2026-01-15 12:30:00'),
                                                                                  (2, 1, 'like', '2026-01-16 11:00:00'),
                                                                                  (3, 2, 'dislike', '2026-01-17 14:00:00'),
                                                                                  (4, 3, 'like', '2026-03-11 12:00:00'),
                                                                                  (4, 5, 'like', '2026-03-12 10:00:00'),
                                                                                  (2, 4, 'dislike', '2026-03-12 15:00:00'),
                                                                                  (3, 5, 'like', '2026-03-13 09:00:00'),
                                                                                  (1, 6, 'dislike', '2026-04-07 10:00:00');


-- ==========================================
-- Sample queries
-- ==========================================

-- 1. List all videos uploaded by a specific user
SELECT v.title, v.description, v.views, v.likes_count, v.dislikes_count, u.username AS uploader
FROM videos v
         JOIN users u ON v.user_id = u.user_id
WHERE u.user_id = 1;

-- 2. List tags for a specific video
SELECT t.name AS tag
FROM tags t
         JOIN videos_tags vt ON t.tag_id = vt.tag_id
WHERE vt.video_id = 1;

-- 3. List all channels a specific user is subscribed to
SELECT c.name, c.description, c.created_at
FROM channels c
         JOIN subscriptions s ON c.channel_id = s.channel_id
WHERE s.user_id = 1;

-- 4. List all videos in a specific playlist
SELECT v.title, v.views, v.likes_count
FROM videos v
         JOIN playlists_videos pv ON v.video_id = pv.video_id
         JOIN playlists p ON pv.playlist_id = p.playlist_id
WHERE p.name = 'Mis favoritas';

-- 5. List comment reactions for a specific video
SELECT u.username, cr.reaction_type, cr.created_at
FROM comment_reactions cr
         JOIN users u ON cr.user_id = u.user_id
         JOIN comments c ON cr.comment_id = c.comment_id
         JOIN videos v ON c.video_id = v.video_id
WHERE v.video_id = 1;

-- ==========================================
-- Constraint test
-- ==========================================

INSERT INTO videos (user_id, title, description, size, filename, duration, thumbnail, views, likes_count, dislikes_count, status, published_at) VALUES (999, 'TestVideo', 'desc', 1000, 'test.mp4', 60, 'thumb.jpg', 0, 0, 0, 'public', NOW()); -- FK: videos.user_id → users.user_id (will FAIL)

INSERT INTO subscriptions (user_id, channel_id, subscribed_at) VALUES (1, 999, NOW()); -- FK: subscriptions.channel_id → channels.channel_id (will FAIL)

INSERT INTO comment_reactions (user_id, comment_id, reaction_type, created_at) VALUES (999, 1, 'like', NOW()); -- FK: comment_reactions.user_id → users.user_id (will FAIL)
