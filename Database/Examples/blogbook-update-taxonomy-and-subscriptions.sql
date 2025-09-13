/* =========================
   BlogBook – Schema Management (1)
   Subscriptions + Generic Taxonomy
   ========================= */

/* ----------  A) Subscriptions  ---------- */

CREATE TABLE IF NOT EXISTS blog_subscriptions (
  subscriptionID        INT AUTO_INCREMENT PRIMARY KEY,
  userID                INT NOT NULL,
  subscription          VARCHAR(50)  NOT NULL,
  subscription_status   VARCHAR(50)  NOT NULL,
  subscriptionCreatedAt DATETIME     NULL,
  subscriptionEndsAt    DATETIME     NULL,
  CONSTRAINT fk_blog_sub_user FOREIGN KEY (userID) REFERENCES blog_users(userID) ON DELETE CASCADE,
  INDEX idx_blog_sub_user (userID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* Copy any legacy columns from blog_users into blog_subscriptions (one row per user if present) */
INSERT INTO blog_subscriptions (userID, subscription, subscription_status, subscriptionCreatedAt, subscriptionEndsAt)
SELECT u.userID, u.subscription, u.subscription_status, u.subscriptionCreatedAt, u.subscriptionEndsAt
FROM blog_users u
LEFT JOIN blog_subscriptions s ON s.userID = u.userID
WHERE u.subscription IS NOT NULL
  AND s.subscriptionID IS NULL;

/* (Optional) Drop legacy columns on blog_users if they still exist */
SET @has_col := (SELECT COUNT(*) FROM information_schema.columns
 WHERE table_schema = DATABASE() AND table_name = 'blog_users' AND column_name = 'subscription');
SET @sql := IF(@has_col = 1, 'ALTER TABLE blog_users DROP COLUMN subscription', 'SELECT 1');
PREPARE x1 FROM @sql; EXECUTE x1; DEALLOCATE PREPARE x1;

SET @has_col := (SELECT COUNT(*) FROM information_schema.columns
 WHERE table_schema = DATABASE() AND table_name = 'blog_users' AND column_name = 'subscription_status');
SET @sql := IF(@has_col = 1, 'ALTER TABLE blog_users DROP COLUMN subscription_status', 'SELECT 1');
PREPARE x2 FROM @sql; EXECUTE x2; DEALLOCATE PREPARE x2;

SET @has_col := (SELECT COUNT(*) FROM information_schema.columns
 WHERE table_schema = DATABASE() AND table_name = 'blog_users' AND column_name = 'subscriptionCreatedAt');
SET @sql := IF(@has_col = 1, 'ALTER TABLE blog_users DROP COLUMN subscriptionCreatedAt', 'SELECT 1');
PREPARE x3 FROM @sql; EXECUTE x3; DEALLOCATE PREPARE x3;

SET @has_col := (SELECT COUNT(*) FROM information_schema.columns
 WHERE table_schema = DATABASE() AND table_name = 'blog_users' AND column_name = 'subscriptionEndsAt');
SET @sql := IF(@has_col = 1, 'ALTER TABLE blog_users DROP COLUMN subscriptionEndsAt', 'SELECT 1');
PREPARE x4 FROM @sql; EXECUTE x4; DEALLOCATE PREPARE x4;


/* ----------  B) Generic taxonomy  ---------- */

CREATE TABLE IF NOT EXISTS blog_taxonomies (
  taxonomyID   INT AUTO_INCREMENT PRIMARY KEY,
  taxonomyName VARCHAR(100) NOT NULL UNIQUE,
  description  TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS blog_taxonomy_terms (
  taxonomyTermID      INT AUTO_INCREMENT PRIMARY KEY,
  taxonomyID          INT NOT NULL,
  taxonomyTermName    VARCHAR(191) NOT NULL,
  description         TEXT NULL,
  parentTaxonomyTerm  INT NULL,
  CONSTRAINT fk_btt_taxonomy FOREIGN KEY (taxonomyID) REFERENCES blog_taxonomies(taxonomyID) ON DELETE CASCADE,
  INDEX idx_btt_taxonomy (taxonomyID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* Unique (taxonomyID, termName) if missing */
SET @idx_exists := (
  SELECT COUNT(*) FROM information_schema.statistics
  WHERE table_schema = DATABASE() AND table_name = 'blog_taxonomy_terms' AND index_name = 'uq_btt_tax_term'
);
SET @sql := IF(@idx_exists = 0,
  'CREATE UNIQUE INDEX uq_btt_tax_term ON blog_taxonomy_terms(taxonomyID, taxonomyTermName)',
  'SELECT 1'
);
PREPARE i1 FROM @sql; EXECUTE i1; DEALLOCATE PREPARE i1;

/* Self FK for parentTaxonomyTerm if missing */
SET @fk_exists := (
  SELECT COUNT(*) FROM information_schema.table_constraints
  WHERE constraint_schema = DATABASE()
    AND table_name = 'blog_taxonomy_terms'
    AND constraint_name = 'fk_btt_parent'
    AND constraint_type = 'FOREIGN KEY'
);
SET @sql := IF(@fk_exists = 0,
  'ALTER TABLE blog_taxonomy_terms ADD CONSTRAINT fk_btt_parent FOREIGN KEY (parentTaxonomyTerm) REFERENCES blog_taxonomy_terms(taxonomyTermID) ON DELETE SET NULL',
  'SELECT 1'
);
PREPARE f1 FROM @sql; EXECUTE f1; DEALLOCATE PREPARE f1;

CREATE TABLE IF NOT EXISTS blog_post_taxonomy (
  postTaxonomyID  INT AUTO_INCREMENT PRIMARY KEY,
  postID          INT NOT NULL,
  taxonomyTermID  INT NOT NULL,
  CONSTRAINT fk_bpt_post  FOREIGN KEY (postID)         REFERENCES blog_posts(postID) ON DELETE CASCADE,
  CONSTRAINT fk_bpt_term  FOREIGN KEY (taxonomyTermID) REFERENCES blog_taxonomy_terms(taxonomyTermID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* Unique link to avoid duplicates */
SET @idx_exists := (
  SELECT COUNT(*) FROM information_schema.statistics
  WHERE table_schema = DATABASE() AND table_name = 'blog_post_taxonomy' AND index_name = 'uq_bpt_post_term'
);
SET @sql := IF(@idx_exists = 0,
  'CREATE UNIQUE INDEX uq_bpt_post_term ON blog_post_taxonomy(postID, taxonomyTermID)',
  'SELECT 1'
);
PREPARE i2 FROM @sql; EXECUTE i2; DEALLOCATE PREPARE i2;

/* Seed standard taxonomy types if missing */
INSERT INTO blog_taxonomies (taxonomyName, description)
SELECT 'category', 'Hierarchical categories'
WHERE NOT EXISTS (SELECT 1 FROM blog_taxonomies WHERE taxonomyName='category');

INSERT INTO blog_taxonomies (taxonomyName, description)
SELECT 'tag', 'Flat tags'
WHERE NOT EXISTS (SELECT 1 FROM blog_taxonomies WHERE taxonomyName='tag');

INSERT INTO blog_taxonomies (taxonomyName, description)
SELECT 'hashtag', 'Hash-style labels'
WHERE NOT EXISTS (SELECT 1 FROM blog_taxonomies WHERE taxonomyName='hashtag');

INSERT INTO blog_taxonomies (taxonomyName, description)
SELECT 'metatag', 'SEO/crawler-only meta tags'
WHERE NOT EXISTS (SELECT 1 FROM blog_taxonomies WHERE taxonomyName='metatag');


/* ----------  C) Migrate old CATEGORY data to taxonomy  ---------- */

/* Create terms from blog_categories into taxonomy=category */
INSERT INTO blog_taxonomy_terms (taxonomyID, taxonomyTermName)
SELECT t.taxonomyID, c.categoryName
FROM blog_categories c
JOIN blog_taxonomies t ON t.taxonomyName='category'
LEFT JOIN blog_taxonomy_terms tt
  ON tt.taxonomyID = t.taxonomyID AND tt.taxonomyTermName = c.categoryName
WHERE tt.taxonomyTermID IS NULL;

/* Link posts to those terms using blog_posts.categoryID */
INSERT INTO blog_post_taxonomy (postID, taxonomyTermID)
SELECT p.postID, tt.taxonomyTermID
FROM blog_posts p
JOIN blog_categories c ON p.categoryID = c.categoryID
JOIN blog_taxonomies t ON t.taxonomyName = 'category'
JOIN blog_taxonomy_terms tt
  ON tt.taxonomyID = t.taxonomyID AND tt.taxonomyTermName = c.categoryName
LEFT JOIN blog_post_taxonomy bpt
  ON bpt.postID = p.postID AND bpt.taxonomyTermID = tt.taxonomyTermID
WHERE bpt.postID IS NULL;

/* Drop FK posts->blog_categories (if present) then drop the column and table */
SET @fk_exists := (
  SELECT COUNT(*) FROM information_schema.table_constraints
  WHERE constraint_schema = DATABASE()
    AND table_name = 'blog_posts'
    AND constraint_name = 'fk_blog_posts_category'
    AND constraint_type = 'FOREIGN KEY'
);
SET @sql := IF(@fk_exists = 1,
  'ALTER TABLE blog_posts DROP FOREIGN KEY fk_blog_posts_category',
  'SELECT 1'
);
PREPARE f2 FROM @sql; EXECUTE f2; DEALLOCATE PREPARE f2;

/* Drop column categoryID if it still exists */
SET @has_col := (SELECT COUNT(*) FROM information_schema.columns
 WHERE table_schema = DATABASE() AND table_name = 'blog_posts' AND column_name = 'categoryID');
SET @sql := IF(@has_col = 1, 'ALTER TABLE blog_posts DROP COLUMN categoryID', 'SELECT 1');
PREPARE d1 FROM @sql; EXECUTE d1; DEALLOCATE PREPARE d1;

/* Old table cleanup */
DROP TABLE IF EXISTS blog_categories;


/* ----------  D) Migrate old TAG data to taxonomy  ---------- */

/* Create terms from blog_tags into taxonomy=tag */
INSERT INTO blog_taxonomy_terms (taxonomyID, taxonomyTermName)
SELECT t.taxonomyID, g.tagName
FROM blog_tags g
JOIN blog_taxonomies t ON t.taxonomyName='tag'
LEFT JOIN blog_taxonomy_terms tt
  ON tt.taxonomyID = t.taxonomyID AND tt.taxonomyTermName = g.tagName
WHERE tt.taxonomyTermID IS NULL;

/* Link posts using blog_post_tags */
INSERT INTO blog_post_taxonomy (postID, taxonomyTermID)
SELECT pt.postID, tt.taxonomyTermID
FROM blog_post_tags pt
JOIN blog_tags g        ON pt.tagID = g.tagID
JOIN blog_taxonomies t  ON t.taxonomyName = 'tag'
JOIN blog_taxonomy_terms tt
  ON tt.taxonomyID = t.taxonomyID AND tt.taxonomyTermName = g.tagName
LEFT JOIN blog_post_taxonomy bpt
  ON bpt.postID = pt.postID AND bpt.taxonomyTermID = tt.taxonomyTermID
WHERE bpt.postID IS NULL;

/* Old tables cleanup */
DROP TABLE IF EXISTS blog_post_tags;
DROP TABLE IF EXISTS blog_tags;
