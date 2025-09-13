/* =========================
   BlogBook – Challenge 1 (namespaced)
   ========================= */

CREATE TABLE IF NOT EXISTS blog_users (
  userID              INT AUTO_INCREMENT PRIMARY KEY,
  username            VARCHAR(50)  NOT NULL UNIQUE,
  email               VARCHAR(150) NOT NULL UNIQUE,
  password            VARCHAR(255) NOT NULL,
  email_confirmed_at  DATETIME     NULL,
  created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS blog_posts (
  postID      INT AUTO_INCREMENT PRIMARY KEY,
  title       VARCHAR(200) NOT NULL,
  content     MEDIUMTEXT   NOT NULL,
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  userID      INT          NOT NULL,
  CONSTRAINT fk_blog_posts_user FOREIGN KEY (userID) REFERENCES blog_users(userID) ON DELETE CASCADE,
  INDEX idx_blog_posts_user (userID),
  INDEX idx_blog_posts_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS blog_comments (
  commentID   INT AUTO_INCREMENT PRIMARY KEY,
  commentText TEXT        NOT NULL,
  created_at  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  userID      INT         NOT NULL,
  postID      INT         NOT NULL,
  CONSTRAINT fk_blog_comments_user FOREIGN KEY (userID) REFERENCES blog_users(userID) ON DELETE CASCADE,
  CONSTRAINT fk_blog_comments_post FOREIGN KEY (postID) REFERENCES blog_posts(postID) ON DELETE CASCADE,
  INDEX idx_blog_comments_post (postID),
  INDEX idx_blog_comments_user (userID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* Composite PKs for likes */
CREATE TABLE IF NOT EXISTS blog_post_likes (
  userID     INT NOT NULL,
  postID     INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (userID, postID),
  CONSTRAINT fk_blog_postlikes_user FOREIGN KEY (userID) REFERENCES blog_users(userID) ON DELETE CASCADE,
  CONSTRAINT fk_blog_postlikes_post FOREIGN KEY (postID) REFERENCES blog_posts(postID) ON DELETE CASCADE,
  INDEX idx_blog_postlikes_post (postID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS blog_comment_likes (
  userID     INT NOT NULL,
  commentID  INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (userID, commentID),
  CONSTRAINT fk_blog_commentlikes_user    FOREIGN KEY (userID)    REFERENCES blog_users(userID)    ON DELETE CASCADE,
  CONSTRAINT fk_blog_commentlikes_comment FOREIGN KEY (commentID) REFERENCES blog_comments(commentID) ON DELETE CASCADE,
  INDEX idx_blog_commentlikes_comment (commentID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* =========================
   BlogBook – Challenge 2 (namespaced)
   ========================= */

CREATE TABLE IF NOT EXISTS blog_categories (
  categoryID   INT AUTO_INCREMENT PRIMARY KEY,
  categoryName VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS blog_tags (
  tagID   INT AUTO_INCREMENT PRIMARY KEY,
  tagName VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS blog_post_tags (
  postID INT NOT NULL,
  tagID  INT NOT NULL,
  PRIMARY KEY (postID, tagID),
  CONSTRAINT fk_blog_posttags_post FOREIGN KEY (postID) REFERENCES blog_posts(postID) ON DELETE CASCADE,
  CONSTRAINT fk_blog_posttags_tag  FOREIGN KEY (tagID)  REFERENCES blog_tags(tagID)  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS blog_user_settings (
  entryId   INT AUTO_INCREMENT PRIMARY KEY,
  userID    INT NOT NULL,
  metaKey   VARCHAR(100) NOT NULL,
  metaValue TEXT,
  CONSTRAINT fk_blog_usersettings_user FOREIGN KEY (userID) REFERENCES blog_users(userID) ON DELETE CASCADE,
  INDEX idx_blog_usersettings_user (userID),
  INDEX idx_blog_usersettings_key  (metaKey),
  INDEX idx_blog_usersettings_user_key (userID, metaKey)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* Users: add subscription fields (portable “check-then-add”) */
SET @col_exists := (
  SELECT COUNT(*)
  FROM information_schema.columns
  WHERE table_schema = DATABASE()
    AND table_name   = 'blog_users'
    AND column_name  = 'subscription'
);
SET @sql := IF(@col_exists = 0,
  'ALTER TABLE blog_users ADD COLUMN subscription VARCHAR(50) NULL AFTER password',
  'SELECT 1'
);
PREPARE su1 FROM @sql; EXECUTE su1; DEALLOCATE PREPARE su1;

SET @col_exists := (
  SELECT COUNT(*)
  FROM information_schema.columns
  WHERE table_schema = DATABASE()
    AND table_name   = 'blog_users'
    AND column_name  = 'subscription_status'
);
SET @sql := IF(@col_exists = 0,
  'ALTER TABLE blog_users ADD COLUMN subscription_status VARCHAR(50) NULL AFTER subscription',
  'SELECT 1'
);
PREPARE su2 FROM @sql; EXECUTE su2; DEALLOCATE PREPARE su2;

SET @col_exists := (
  SELECT COUNT(*)
  FROM information_schema.columns
  WHERE table_schema = DATABASE()
    AND table_name   = 'blog_users'
    AND column_name  = 'subscriptionCreatedAt'
);
SET @sql := IF(@col_exists = 0,
  'ALTER TABLE blog_users ADD COLUMN subscriptionCreatedAt DATETIME NULL AFTER subscription_status',
  'SELECT 1'
);
PREPARE su3 FROM @sql; EXECUTE su3; DEALLOCATE PREPARE su3;

SET @col_exists := (
  SELECT COUNT(*)
  FROM information_schema.columns
  WHERE table_schema = DATABASE()
    AND table_name   = 'blog_users'
    AND column_name  = 'subscriptionEndsAt'
);
SET @sql := IF(@col_exists = 0,
  'ALTER TABLE blog_users ADD COLUMN subscriptionEndsAt DATETIME NULL AFTER subscriptionCreatedAt',
  'SELECT 1'
);
PREPARE su4 FROM @sql; EXECUTE su4; DEALLOCATE PREPARE su4;

/* Posts: add categoryID (nullable first; portable) */
SET @col_exists := (
  SELECT COUNT(*)
  FROM information_schema.columns
  WHERE table_schema = DATABASE()
    AND table_name   = 'blog_posts'
    AND column_name  = 'categoryID'
);
SET @sql := IF(@col_exists = 0,
  'ALTER TABLE blog_posts ADD COLUMN categoryID INT NULL AFTER userID',
  'SELECT 1'
);
PREPARE sp1 FROM @sql; EXECUTE sp1; DEALLOCATE PREPARE sp1;

/* Ensure default category exists and backfill any NULLs */
INSERT INTO blog_categories (categoryName)
SELECT 'Uncategorized'
WHERE NOT EXISTS (SELECT 1 FROM blog_categories WHERE categoryName = 'Uncategorized');

UPDATE blog_posts p
JOIN blog_categories c ON c.categoryName = 'Uncategorized'
SET p.categoryID = c.categoryID
WHERE p.categoryID IS NULL;

/* Create index on blog_posts.categoryID if missing */
SET @idx_exists := (
  SELECT COUNT(*)
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
    AND table_name   = 'blog_posts'
    AND index_name   = 'idx_blog_posts_categoryID'
);
SET @sql_idx := IF(@idx_exists = 0,
  'CREATE INDEX idx_blog_posts_categoryID ON blog_posts(categoryID)',
  'SELECT 1'
);
PREPARE s1 FROM @sql_idx; EXECUTE s1; DEALLOCATE PREPARE s1;

/* Add FK blog_posts->blog_categories if missing */
SET @fk_exists := (
  SELECT COUNT(*)
  FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE()
    AND TABLE_NAME = 'blog_posts'
    AND CONSTRAINT_NAME = 'fk_blog_posts_category'
    AND CONSTRAINT_TYPE = 'FOREIGN KEY'
);
SET @sql_fk := IF(@fk_exists = 0,
  'ALTER TABLE blog_posts ADD CONSTRAINT fk_blog_posts_category FOREIGN KEY (categoryID) REFERENCES blog_categories(categoryID) ON DELETE RESTRICT',
  'SELECT 1'
);
PREPARE s2 FROM @sql_fk; EXECUTE s2; DEALLOCATE PREPARE s2;

/* Enforce NOT NULL after backfill */
ALTER TABLE blog_posts MODIFY COLUMN categoryID INT NOT NULL;
