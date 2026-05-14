-- =========================================
-- DATABASE: SOCIAL NETWORK
-- =========================================

CREATE DATABASE social_network;
USE social_network;

-- =========================================
-- 1. TABLE USERS
-- =========================================

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- 2. TABLE POSTS
-- =========================================

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_posts_users
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- =========================================
-- 3. TABLE COMMENTS
-- =========================================

CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_comments_posts
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_comments_users
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

-- =========================================
-- 4. TABLE FRIENDS
-- =========================================

CREATE TABLE friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status VARCHAR(20) NOT NULL,

    PRIMARY KEY (user_id, friend_id),

    CONSTRAINT fk_friends_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_friends_friend
        FOREIGN KEY (friend_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_friend_status
        CHECK (status IN ('pending', 'accepted')),

    CONSTRAINT chk_not_self_friend
        CHECK (user_id <> friend_id)
);

-- =========================================
-- 5. TABLE LIKES
-- =========================================

CREATE TABLE likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,

    PRIMARY KEY (user_id, post_id),

    CONSTRAINT fk_likes_users
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_likes_posts
        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE CASCADE
);


CREATE INDEX idx_posts_created_at
ON posts(created_at);

-- =========================================
-- SAMPLE DATA
-- =========================================

INSERT INTO users(username, password, email)
VALUES
('thang', '123456', 'thang@gmail.com'),
('an', '123456', 'an@gmail.com'),
('minh', '123456', 'minh@gmail.com'),
('linh', '123456', 'linh@gmail.com');

INSERT INTO posts(user_id, content)
VALUES
(1, 'Hello everyone'),
(2, 'Learning MySQL'),
(3, 'Social Network Project'),
(1, 'Today is a good day');

INSERT INTO comments(post_id, user_id, content)
VALUES
(1, 2, 'Nice post'),
(1, 3, 'Great'),
(2, 1, 'Good luck'),
(4, 4, 'Wonderful');

INSERT INTO friends(user_id, friend_id, status)
VALUES
(1, 2, 'accepted'),
(2, 3, 'pending'),
(1, 4, 'accepted');

INSERT INTO likes(user_id, post_id)
VALUES
(1, 2),
(2, 1),
(3, 1),
(4, 4);
-- CHUC NANG 1 -- 
CREATE VIEW view_user_info AS 
SELECT user_id, username, email, created_at FROM users ;
SELECT * FROM view_user_info;

-- CHUC NANG 2 --
CREATE VIEW view_post_statistics AS
SELECT p.post_id , u.username , p.content ,p.created_at , 
COUNT(DISTINCT l.user_id ) AS total_like ,
COUNT(DISTINCT c.comment_id) AS total_comments
FROM posts p
JOIN users u 
ON p.user_id = u.user_id 
LEFT JOIN likes l
ON p.post_id = l.post_id
LEFT JOIN comments c 
ON p.post_id = c.post_id 
GROUP BY 
	p.post_id , u.username , p.content ,p.created_at;
    
SELECT * FROM view_post_statistics;
-- CHUC NĂNG 3 --
DELIMITER $$
CREATE PROCEDURE sp_add_user(p_username_in VARCHAR(50), p_password_in VARCHAR(255), p_email_in VARCHAR(100))
BEGIN 
	
	IF EXISTS(SELECT 1 FROM users WHERE email = p_email_in)  THEN 
			SELECT 'Email đã được sử dụng' AS message ;
		
    ELSE 
		INSERT INTO users(username , password, email)
			VALUES 
				(p_username_in , p_password_in , p_email_in);
			 SELECT 'Đăng ký thành công' AS message;
	END IF ;
END $$ 
DELIMITER ;
CALL sp_add_user('hung', '123456', 'hung@gmail.com');

-- CHUC NĂNG 4 --
DELIMITER $$

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT,
    OUT p_new_post_id INT
)

BEGIN

    INSERT INTO posts(user_id, content)
    VALUES (p_user_id, p_content);

    SET p_new_post_id = LAST_INSERT_ID();

END $$

DELIMITER ;

-- TEST PROCEDURE

CALL sp_create_post(1, 'Bài viết mới của Thắng', @new_post_id);

SELECT @new_post_id AS new_post_id;

-- CHUC NANG 5 --
DELIMITER $$
CREATE PROCEDURE sp_get_friends(
    p_user_id INT, p_limit TINYINT, p_offset TINYINT
)
BEGIN
	SELECT u.* FROM users u
    JOIN friends f
    ON u.user_id = f.friend_id 
    WHERE f.user_id = p_user_id
      AND f.status = 'accepted' 
   
    LIMIT p_limit OFFSET p_offset ;

END $$

DELIMITER ;
CALL sp_get_friends(1,2,1);