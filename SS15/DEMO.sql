CREATE DATABASE MiniSocialNetwork;
USE MiniSocialNetwork;

-- =========================
-- BẢNG USERS
-- =========================
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- BẢNG POSTS
-- =========================
CREATE TABLE posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    content TEXT NOT NULL,
    like_count INT DEFAULT 0,
    comment_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
) ;

-- =========================
-- BẢNG COMMENTS
-- =========================
CREATE TABLE comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (post_id)
    REFERENCES posts(post_id),

    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
) ;

-- =========================
-- BẢNG FRIENDS
-- =========================
CREATE TABLE friends (
    friendship_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    friend_id INT,
    status VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
    REFERENCES users(user_id),

    FOREIGN KEY (friend_id)
    REFERENCES users(user_id),
    
	CHECK (user_id != friend_id),

    UNIQUE (
        (LEAST(user_id, friend_id)),
        (GREATEST(user_id, friend_id))
    )
) ;

-- =========================
-- BẢNG LIKES
-- =========================
CREATE TABLE likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    post_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
    REFERENCES users(user_id),

    FOREIGN KEY (post_id)
    REFERENCES posts(post_id)
) ;

-- =========================
-- DỮ LIỆU MẪU USERS
-- =========================
INSERT INTO users (username, password, email)
VALUES
('thangdev', '123456', 'thang@gmail.com'),
('linhcute', '123456', 'linh@gmail.com'),
('minhpro', '123456', 'minh@gmail.com'),
('anhkhoa', '123456', 'khoa@gmail.com'),
('trangxinh', '123456', 'trang@gmail.com');

-- =========================
-- DỮ LIỆU MẪU POSTS
-- =========================
INSERT INTO posts (user_id, content)
VALUES
(1, 'Hôm nay học MySQL Trigger'),
(2, 'Mình đang làm bài tập Transaction'),
(3, 'Xin chào mọi người'),
(1, 'Database rất thú vị'),
(4, 'Cuối tuần đi chơi không?');

-- =========================
-- DỮ LIỆU MẪU COMMENTS
-- =========================
INSERT INTO comments (post_id, user_id, content)
VALUES
(1, 2, 'Hay quá'),
(1, 3, 'Mình cũng đang học'),
(2, 1, 'Cố lên nhé'),
(3, 4, 'Chào bạn'),
(4, 5, 'Đúng vậy');

-- =========================
-- DỮ LIỆU MẪU FRIENDS
-- =========================
INSERT INTO friends (user_id, friend_id, status)
VALUES
(1, 2, 'accepted'),
(1, 3, 'accepted'),
(2, 4, 'pending'),
(3, 5, 'accepted');

-- =========================
-- DỮ LIỆU MẪU LIKES
-- =========================
INSERT INTO likes (user_id, post_id)
VALUES
(1, 2),
(2, 1),
(3, 1),
(4, 3),
(5, 4);
-- CHUC NANG 1 -- 
CREATE VIEW view_user_info AS
SELECT user_id, username, email, created_at FROM users ;

SELECT * FROM  view_user_info;
-- CHUC NANG 2 -- 
DELIMITER $$ 
CREATE PROCEDURE sp_add_user(p_username VARCHAR(50), p_password VARCHAR(255), p_email VARCHAR(100))
   
BEGIN
	
    IF EXISTS (
		SELECT 1 FROM users WHERE username = p_username OR email = p_email
        ) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bị trùng name and email ';
	ELSE 
		INSERT INTO users (username ,password, email)
			VALUES 
				(p_username , p_password , p_email);
	END IF;
END $$
DELIMITER ;
CALL sp_add_user('thangdev','123456','thang@gmail.com');
-- CHUC NANG 3 --\

DELIMITER $$
CREATE TRIGGER tg_after_like_insert
AFTER INSERT ON likes 
FOR EACH ROW 
BEGIN 
	
    UPDATE posts SET like_count = like_count + 1 WHERE post_id = NEW.post_id ;
    
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_after_like_delete
AFTER DELETE ON likes 
FOR EACH ROW 
BEGIN 
    UPDATE posts SET like_count = CASE 
		WHEN like_count > 0  THEN like_count - 1  
        ELSE 0
        END 
   WHERE post_id = OLD.post_id ;
   END $$ 
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tg_after_comment_insert
AFTER INSERT ON comments 
FOR EACH ROW 
BEGIN 
	
    UPDATE posts SET comment_count = comment_count + 1 WHERE post_id = NEW.post_id ;
    
END $$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER tg_after_comment_delete
AFTER DELETE ON comments 
FOR EACH ROW 
BEGIN 
    UPDATE posts SET comment_count = CASE 
		WHEN comment_count > 0  THEN comment_count - 1  
        ELSE 0
        END 
   WHERE post_id = OLD.post_id ;
   END $$ 
DELIMITER ;

-- CHUC NANG 4 -- 
-- Dùng COUNT và GROUP BY qua 4 bảng (users, posts, likes, comments) để tổng hợp số lượng bài viết, lượt like, lượt comment của từng user.
DELIMITER $$
CREATE PROCEDURE sp_user_activity_report()
BEGIN 
	SELECT 
		u.user_id ,
        username ,
        COUNT(DISTINCT p.post_id ) AS total_post ,
        COUNT(DISTINCT l.like_id ) AS total_like,
        COUNT(DISTINCT c.comment_id ) AS total_comment 
        FROM users u
        LEFT JOIN posts p
        ON u.user_id =p.user_id
        LEFT JOIN likes l
        ON u.user_id = l.user_id
        LEFT JOIN comments c
        ON u.user_id = c.user_id 
        GROUP BY 
			u.user_id ,
			username 
		ORDER BY u.user_id ;
END $$
DELIMITER ;
-- CHUC NANG 5 -- 

DELIMITER $$
CREATE PROCEDURE sp_delete_user( p_user_id INT ) 
BEGIN 
	DECLARE EXIT HANDLER FOR sqlexception
    BEGIN 
		ROLLBACK ;
    END ;
	START TRANSACTION;
    DELETE FROM likes
    WHERE user_id =  p_user_id OR post_id IN (SELECT post_id FROM posts WHERE user_id = p_user_id);
    
	DELETE FROM comments WHERE user_id =  p_user_id 
    OR post_id IN (SELECT post_id FROM posts WHERE user_id = p_user_id);
    
    DELETE FROM friends WHERE user_id =  p_user_id OR friend_id = p_user_id;
    DELETE FROM posts WHERE user_id =  p_user_id;
    DELETE FROM users WHERE user_id =  p_user_id;
    COMMIT ;
END $$
DELIMITER ;



-- CHỨC NĂNG 6: KIỂM SOÁT KẾT BẠN


DELIMITER $$

CREATE TRIGGER tg_before_friend_insert
BEFORE INSERT ON friends
FOR EACH ROW
BEGIN
    -- 1. Kiểm tra lỗi tự kết bạn với chính mình
    IF NEW.user_id = NEW.friend_id THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Lỗi: Không thể gửi lời mời kết bạn cho chính mình!';
    END IF;

    -- 2 & 3. Kiểm tra trùng lặp dữ liệu (A gửi B rồi lại gửi tiếp) 
    -- HOẶC Lời mời đảo chiều (A đã gửi B, giờ B lại gửi ngược lại cho A)
    IF EXISTS (
        SELECT 1 FROM friends 
        WHERE (user_id = NEW.user_id AND friend_id = NEW.friend_id)
           OR (user_id = NEW.friend_id AND friend_id = NEW.user_id)
    ) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Lỗi: Cặp bạn bè này đã tồn tại hoặc đang có lời mời chờ xử lý!';
    END IF;

END $$

DELIMITER ;
