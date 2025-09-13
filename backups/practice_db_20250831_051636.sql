mysqldump: [Warning] Using a password on the command line interface can be insecure.
-- MySQL dump 10.13  Distrib 8.0.43, for Linux (x86_64)
--
-- Host: localhost    Database: practice_db
-- ------------------------------------------------------
-- Server version	8.0.43-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `blog_comment_likes`
--

DROP TABLE IF EXISTS `blog_comment_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_comment_likes` (
  `userID` int NOT NULL,
  `commentID` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`userID`,`commentID`),
  KEY `idx_blog_commentlikes_comment` (`commentID`),
  CONSTRAINT `fk_blog_commentlikes_comment` FOREIGN KEY (`commentID`) REFERENCES `blog_comments` (`commentID`) ON DELETE CASCADE,
  CONSTRAINT `fk_blog_commentlikes_user` FOREIGN KEY (`userID`) REFERENCES `blog_users` (`userID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_comment_likes`
--

LOCK TABLES `blog_comment_likes` WRITE;
/*!40000 ALTER TABLE `blog_comment_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `blog_comment_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_comments`
--

DROP TABLE IF EXISTS `blog_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_comments` (
  `commentID` int NOT NULL AUTO_INCREMENT,
  `commentText` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `userID` int NOT NULL,
  `postID` int NOT NULL,
  PRIMARY KEY (`commentID`),
  KEY `idx_blog_comments_post` (`postID`),
  KEY `idx_blog_comments_user` (`userID`),
  CONSTRAINT `fk_blog_comments_post` FOREIGN KEY (`postID`) REFERENCES `blog_posts` (`postID`) ON DELETE CASCADE,
  CONSTRAINT `fk_blog_comments_user` FOREIGN KEY (`userID`) REFERENCES `blog_users` (`userID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_comments`
--

LOCK TABLES `blog_comments` WRITE;
/*!40000 ALTER TABLE `blog_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `blog_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_post_likes`
--

DROP TABLE IF EXISTS `blog_post_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_post_likes` (
  `userID` int NOT NULL,
  `postID` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`userID`,`postID`),
  KEY `idx_blog_postlikes_post` (`postID`),
  CONSTRAINT `fk_blog_postlikes_post` FOREIGN KEY (`postID`) REFERENCES `blog_posts` (`postID`) ON DELETE CASCADE,
  CONSTRAINT `fk_blog_postlikes_user` FOREIGN KEY (`userID`) REFERENCES `blog_users` (`userID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_post_likes`
--

LOCK TABLES `blog_post_likes` WRITE;
/*!40000 ALTER TABLE `blog_post_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `blog_post_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_post_taxonomy`
--

DROP TABLE IF EXISTS `blog_post_taxonomy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_post_taxonomy` (
  `postTaxonomyID` int NOT NULL AUTO_INCREMENT,
  `postID` int NOT NULL,
  `taxonomyTermID` int NOT NULL,
  PRIMARY KEY (`postTaxonomyID`),
  UNIQUE KEY `uq_bpt_post_term` (`postID`,`taxonomyTermID`),
  KEY `fk_bpt_term` (`taxonomyTermID`),
  CONSTRAINT `fk_bpt_post` FOREIGN KEY (`postID`) REFERENCES `blog_posts` (`postID`) ON DELETE CASCADE,
  CONSTRAINT `fk_bpt_term` FOREIGN KEY (`taxonomyTermID`) REFERENCES `blog_taxonomy_terms` (`taxonomyTermID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_post_taxonomy`
--

LOCK TABLES `blog_post_taxonomy` WRITE;
/*!40000 ALTER TABLE `blog_post_taxonomy` DISABLE KEYS */;
/*!40000 ALTER TABLE `blog_post_taxonomy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_posts`
--

DROP TABLE IF EXISTS `blog_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_posts` (
  `postID` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `content` mediumtext NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `userID` int NOT NULL,
  PRIMARY KEY (`postID`),
  KEY `idx_blog_posts_user` (`userID`),
  KEY `idx_blog_posts_created` (`created_at`),
  CONSTRAINT `fk_blog_posts_user` FOREIGN KEY (`userID`) REFERENCES `blog_users` (`userID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_posts`
--

LOCK TABLES `blog_posts` WRITE;
/*!40000 ALTER TABLE `blog_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `blog_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_subscriptions`
--

DROP TABLE IF EXISTS `blog_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_subscriptions` (
  `subscriptionID` int NOT NULL AUTO_INCREMENT,
  `userID` int NOT NULL,
  `subscription` varchar(50) NOT NULL,
  `subscription_status` varchar(50) NOT NULL,
  `subscriptionCreatedAt` datetime DEFAULT NULL,
  `subscriptionEndsAt` datetime DEFAULT NULL,
  PRIMARY KEY (`subscriptionID`),
  KEY `idx_blog_sub_user` (`userID`),
  CONSTRAINT `fk_blog_sub_user` FOREIGN KEY (`userID`) REFERENCES `blog_users` (`userID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_subscriptions`
--

LOCK TABLES `blog_subscriptions` WRITE;
/*!40000 ALTER TABLE `blog_subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `blog_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_taxonomies`
--

DROP TABLE IF EXISTS `blog_taxonomies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_taxonomies` (
  `taxonomyID` int NOT NULL AUTO_INCREMENT,
  `taxonomyName` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`taxonomyID`),
  UNIQUE KEY `taxonomyName` (`taxonomyName`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_taxonomies`
--

LOCK TABLES `blog_taxonomies` WRITE;
/*!40000 ALTER TABLE `blog_taxonomies` DISABLE KEYS */;
INSERT INTO `blog_taxonomies` VALUES (1,'category','Hierarchical categories'),(2,'tag','Flat tags'),(3,'hashtag','Hash-style labels'),(4,'metatag','SEO/crawler-only meta tags');
/*!40000 ALTER TABLE `blog_taxonomies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_taxonomy_terms`
--

DROP TABLE IF EXISTS `blog_taxonomy_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_taxonomy_terms` (
  `taxonomyTermID` int NOT NULL AUTO_INCREMENT,
  `taxonomyID` int NOT NULL,
  `taxonomyTermName` varchar(191) NOT NULL,
  `description` text,
  `parentTaxonomyTerm` int DEFAULT NULL,
  PRIMARY KEY (`taxonomyTermID`),
  UNIQUE KEY `uq_btt_tax_term` (`taxonomyID`,`taxonomyTermName`),
  KEY `idx_btt_taxonomy` (`taxonomyID`),
  KEY `fk_btt_parent` (`parentTaxonomyTerm`),
  CONSTRAINT `fk_btt_parent` FOREIGN KEY (`parentTaxonomyTerm`) REFERENCES `blog_taxonomy_terms` (`taxonomyTermID`) ON DELETE SET NULL,
  CONSTRAINT `fk_btt_taxonomy` FOREIGN KEY (`taxonomyID`) REFERENCES `blog_taxonomies` (`taxonomyID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_taxonomy_terms`
--

LOCK TABLES `blog_taxonomy_terms` WRITE;
/*!40000 ALTER TABLE `blog_taxonomy_terms` DISABLE KEYS */;
INSERT INTO `blog_taxonomy_terms` VALUES (1,1,'Uncategorized',NULL,NULL);
/*!40000 ALTER TABLE `blog_taxonomy_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_user_settings`
--

DROP TABLE IF EXISTS `blog_user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_user_settings` (
  `entryId` int NOT NULL AUTO_INCREMENT,
  `userID` int NOT NULL,
  `metaKey` varchar(100) NOT NULL,
  `metaValue` text,
  PRIMARY KEY (`entryId`),
  KEY `idx_blog_usersettings_user` (`userID`),
  KEY `idx_blog_usersettings_key` (`metaKey`),
  KEY `idx_blog_usersettings_user_key` (`userID`,`metaKey`),
  CONSTRAINT `fk_blog_usersettings_user` FOREIGN KEY (`userID`) REFERENCES `blog_users` (`userID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_user_settings`
--

LOCK TABLES `blog_user_settings` WRITE;
/*!40000 ALTER TABLE `blog_user_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `blog_user_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_users`
--

DROP TABLE IF EXISTS `blog_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_users` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email_confirmed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_users`
--

LOCK TABLES `blog_users` WRITE;
/*!40000 ALTER TABLE `blog_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `blog_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `car_part`
--

DROP TABLE IF EXISTS `car_part`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `car_part` (
  `carID` int NOT NULL,
  `partID` int NOT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`carID`,`partID`),
  KEY `partID` (`partID`),
  CONSTRAINT `car_part_ibfk_1` FOREIGN KEY (`carID`) REFERENCES `cars` (`id`) ON DELETE CASCADE,
  CONSTRAINT `car_part_ibfk_2` FOREIGN KEY (`partID`) REFERENCES `parts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `car_part`
--

LOCK TABLES `car_part` WRITE;
/*!40000 ALTER TABLE `car_part` DISABLE KEYS */;
INSERT INTO `car_part` VALUES (1,101,1),(1,102,1),(2,105,3),(2,120,2),(2,127,4),(2,130,1),(2,153,3),(2,157,2),(3,103,3),(3,134,3),(3,146,2),(3,170,2),(3,176,1),(4,106,3),(4,117,3),(4,125,3),(4,135,2),(4,173,4),(5,113,3),(5,130,4),(5,147,3),(5,161,2),(5,186,4),(6,103,1),(6,143,4),(6,144,4),(6,174,4),(6,184,1),(6,189,4),(7,122,2),(7,125,3),(7,154,1),(7,190,3),(7,201,3),(8,116,2),(8,164,4),(8,170,3),(9,164,3),(9,165,1),(9,175,1),(10,114,4),(10,128,3),(10,136,1),(10,138,2),(10,139,4),(10,163,3),(10,171,3),(10,179,2),(11,118,3),(11,134,3),(11,159,4),(12,119,1),(12,133,1),(12,160,1),(12,165,2),(13,133,1),(13,144,3),(13,173,4),(14,104,2),(14,118,1),(14,126,1),(14,163,4),(14,168,3),(14,178,4),(14,179,2),(15,136,2),(15,156,1),(15,189,2),(15,201,1),(16,108,4),(16,144,2),(16,177,2),(16,178,4),(16,179,1),(16,184,3),(17,108,3),(17,110,4),(17,123,2),(17,175,2),(17,193,1),(17,201,1),(18,112,2),(18,149,3),(18,160,4),(18,162,2),(18,187,1),(19,111,3),(19,117,4),(19,127,3),(19,147,1),(19,151,4),(19,168,3),(20,105,4),(20,106,2),(20,139,1),(20,150,1),(20,191,1),(21,106,3),(21,121,3),(21,127,1),(21,128,2),(21,156,1),(21,162,4),(21,192,4);
/*!40000 ALTER TABLE `car_part` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cars`
--

DROP TABLE IF EXISTS `cars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cars` (
  `id` int NOT NULL AUTO_INCREMENT,
  `make` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `year` int DEFAULT NULL,
  `color` varchar(20) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `mileage` float DEFAULT NULL,
  `transmission` varchar(20) DEFAULT NULL,
  `engine` varchar(20) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cars`
--

LOCK TABLES `cars` WRITE;
/*!40000 ALTER TABLE `cars` DISABLE KEYS */;
INSERT INTO `cars` VALUES (1,'Toyota','Corolla',2020,'Blue',20000,1500,'Automatic','Gasoline','Available'),(2,'BMW','Eum',2024,'Fuchsia',17570.1,161389,'Automatic','Diesel','Sold'),(3,'BMW','In',2013,'Fuchsia',52961.1,101614,'Manual','Gasoline','Available'),(4,'Tesla','Dolores',2024,'Aqua',47408.1,69528.5,'Manual','Diesel','Available'),(5,'Toyota','At',2005,'Blue',26806.4,193085,'Manual','Diesel','Available'),(6,'Audi','Qui',2006,'Maroon',5233.22,133906,'Automatic','Hybrid','Used'),(7,'BMW','Ipsum',2013,'Teal',58865.1,16469.4,'Automatic','Hybrid','Available'),(8,'Nissan','Reprehenderit',2022,'Black',22765.3,77171.1,'Manual','Gasoline','Available'),(9,'BMW','Suscipit',2019,'White',45336,93744.8,'Manual','Hybrid','Sold'),(10,'Toyota','Architecto',2013,'Blue',13171.6,25471.5,'Manual','Gasoline','Available'),(11,'Honda','Earum',2011,'Purple',29214.7,47521.3,'Manual','Gasoline','Available'),(12,'Honda','Autem',2011,'Black',10356.6,32322.8,'Manual','Electric','Used'),(13,'Audi','Suscipit',2005,'Aqua',46626.8,135673,'Manual','Diesel','Sold'),(14,'Ford','Aut',2017,'Teal',21490.4,69748.7,'Manual','Hybrid','Sold'),(15,'Nissan','Adipisci',2009,'Silver',36704.7,48720,'Manual','Gasoline','Sold'),(16,'Audi','Non',2005,'Aqua',42581.9,112070,'Automatic','Gasoline','Sold'),(17,'Ford','Placeat',2017,'Blue',13639.9,13715.5,'Manual','Gasoline','Available'),(18,'Audi','Ab',2019,'Olive',25644.3,32665.1,'Manual','Electric','Available'),(19,'Nissan','Eaque',2008,'Gray',51304.4,68671.5,'Automatic','Electric','Available'),(20,'BMW','Optio',2021,'Navy',10644.3,163182,'Automatic','Hybrid','Used'),(21,'Nissan','Blanditiis',2011,'Gray',52195.9,158238,'Automatic','Gasoline','Available');
/*!40000 ALTER TABLE `cars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `change_amount` int DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,1,-1,'Order #1','2025-08-22 03:47:30'),(2,2,-1,'Order #1','2025-08-22 03:47:30'),(3,3,-1,'Order #1','2025-08-22 03:47:30');
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,1,1,1299.99),(2,1,3,1,199.99),(3,1,2,1,29.99);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `total` decimal(10,2) NOT NULL,
  `status` enum('pending','paid','shipped','completed','cancelled') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,2,2329.97,'paid','2025-08-22 03:47:30');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parts`
--

DROP TABLE IF EXISTS `parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `price` float DEFAULT NULL,
  `quantityInStock` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=203 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parts`
--

LOCK TABLES `parts` WRITE;
/*!40000 ALTER TABLE `parts` DISABLE KEYS */;
INSERT INTO `parts` VALUES (1,'eos','Laboriosam cupiditate vel eum natus sunt.',50.25,34),(2,'quo','Non asperiores quia aliquid esse totam.',189.46,52),(3,'ut','Veniam quisquam quas minima occaecati quisquam harum consequatur maxime.',12.88,9),(4,'error','Voluptates totam iste quas et unde ut maiores.',262.8,11),(5,'eum','Ut aut ipsa omnis iure autem voluptatum et.',141.73,65),(6,'reiciendis','Eveniet rem id harum impedit adipisci sint.',19.97,49),(7,'maiores','Praesentium vel aut non maxime eum alias.',136.14,46),(8,'qui','Temporibus et quis reiciendis et tempora ducimus qui.',39.88,68),(9,'earum','Harum velit eum qui numquam voluptatem.',45.32,100),(10,'minus','Eligendi architecto et eveniet dolor debitis.',47.4,56),(11,'ut','Ducimus error ut necessitatibus dolore sequi nobis.',200.96,20),(12,'dolores','Maxime dolor hic alias rerum voluptatem quis aperiam.',291.48,61),(13,'sed','Minima maiores sunt qui architecto consequuntur ut.',244.26,76),(14,'aliquid','Magni distinctio quia omnis iure quibusdam repudiandae.',154.17,80),(15,'dolores','Nemo omnis sapiente velit nulla ut.',279.53,89),(16,'voluptas','Aut non vel veritatis et excepturi et in aliquid.',151.36,47),(17,'et','Veritatis maiores et distinctio.',79.4,48),(18,'eos','Saepe occaecati sed et facilis omnis consequatur quaerat.',29.51,54),(19,'voluptatem','Ab et nemo doloremque architecto molestiae.',155.28,31),(20,'doloribus','Consectetur officiis aspernatur neque quia deleniti provident officia.',243.84,76),(21,'blanditiis','Quia aut eius sequi adipisci autem a nostrum.',291.26,3),(22,'quia','Cupiditate cumque aut autem accusantium.',56.78,9),(23,'eius','Minima ea nemo alias et perspiciatis eligendi.',37.44,39),(24,'quae','Id maiores quos voluptas fugiat.',261.09,75),(25,'incidunt','Aut aspernatur soluta molestiae earum voluptatum.',61.03,71),(26,'architecto','Odit nostrum impedit officiis.',259.26,21),(27,'sunt','Dolor iure voluptatem est sint qui.',65.44,86),(28,'fuga','Dolorum blanditiis voluptatem laborum quo autem debitis.',286.64,17),(29,'optio','Quo ut et provident necessitatibus et aut aperiam.',68.49,76),(30,'quod','Corporis alias nostrum sunt et illo ipsa.',120.51,53),(31,'libero','Nostrum illo et repellendus ratione alias quas rerum omnis.',164.4,40),(32,'autem','Explicabo officia autem atque ad itaque unde sunt.',184.6,67),(33,'velit','Sint harum tempore et earum aut illo.',220.11,86),(34,'nisi','At ut consequatur error eveniet.',175.66,84),(35,'tempore','Harum recusandae temporibus repudiandae fugiat iure asperiores.',211.73,69),(36,'sit','Voluptate aut fuga aut consequuntur quam ipsa vero.',34.22,68),(37,'id','Omnis dolor facere perspiciatis dolorem harum dicta deleniti.',39.7,31),(38,'quaerat','Voluptatem aut omnis facilis corrupti beatae perspiciatis id.',199.92,82),(39,'rerum','Ut maxime ut voluptatum totam assumenda quo.',16.22,51),(40,'perspiciatis','Et eius esse ducimus nulla id quibusdam.',158.2,28),(41,'debitis','Alias commodi distinctio eum placeat a optio quam.',114.13,99),(42,'accusantium','Nulla voluptas nostrum et qui.',237.46,35),(43,'iure','Blanditiis totam quia vero sapiente enim non rem.',229.25,74),(44,'rerum','Est qui deserunt accusamus repellat qui quo beatae minima.',178.74,13),(45,'sit','Cupiditate odio dolores voluptas voluptatibus culpa consectetur.',204.85,44),(46,'est','Aliquam distinctio nobis repudiandae mollitia placeat.',245.02,0),(47,'distinctio','Atque veritatis eaque ut aut.',30.54,100),(48,'labore','Odit quo et inventore iure nemo ad.',57.23,69),(49,'repudiandae','Quis nam aliquam dolorem quidem voluptatem.',138.61,7),(50,'ipsa','Repellendus recusandae velit perferendis tempore eveniet unde.',52.02,74),(51,'debitis','Velit sit maiores accusantium exercitationem et consectetur.',170.2,34),(52,'expedita','Facere nesciunt fuga quo enim.',204.02,13),(53,'et','Est porro qui impedit qui veritatis veritatis sed est.',187.79,69),(54,'harum','Dolores voluptate dicta cupiditate placeat et et ut quia.',179.74,96),(55,'quam','Qui ad doloremque quod dolore quam veritatis.',96.54,65),(56,'sint','Repellendus rerum architecto sit nobis autem ipsa reprehenderit.',92.68,58),(57,'fugiat','Quasi quas voluptatem dolore tempore placeat amet.',23.03,8),(58,'repellat','Deleniti voluptas delectus eum sed.',246.37,28),(59,'sunt','Vero unde veritatis temporibus qui optio.',125.71,90),(60,'voluptas','Eius voluptatem voluptas minus dolores.',224.39,92),(61,'consectetur','Tempore voluptas vero deserunt omnis deserunt qui.',107.8,33),(62,'dolore','Blanditiis eligendi molestiae eum sunt voluptate minus.',234.2,79),(63,'illum','Vel at dolores non voluptatibus corporis.',271.36,79),(64,'fuga','Veniam aut dolor architecto consequatur natus qui.',270.06,49),(65,'aliquam','Et aperiam qui aut temporibus.',128.48,84),(66,'fugit','Et explicabo facilis ad dolores facere nulla.',68.13,5),(67,'saepe','Aut nihil reprehenderit est sint voluptate nemo delectus.',14.72,91),(68,'non','Expedita quia veniam saepe magnam quia recusandae non.',255.78,49),(69,'nam','Sunt aut ut eligendi magni est.',46.42,4),(70,'enim','Nisi aut itaque ab voluptas et quia.',12.42,7),(71,'id','Voluptate ullam qui sed et sint.',98.71,47),(72,'voluptatem','Dolores neque atque voluptas ea corporis.',196.45,26),(73,'reiciendis','Voluptatum omnis expedita modi esse eveniet.',299.31,85),(74,'quod','Animi est necessitatibus iusto veritatis enim.',183.2,43),(75,'est','Earum quos sunt enim eaque fugiat eaque quia.',216,57),(76,'dolorem','Occaecati distinctio id aut iste ea.',295.67,73),(77,'culpa','Atque in tenetur minima non accusantium nisi et.',270.41,22),(78,'qui','Iusto dolorem commodi ut.',141.51,33),(79,'ex','Voluptatem voluptas aut soluta eum et.',65.26,84),(80,'ratione','Consequatur cum voluptatem temporibus aut officia quaerat non et.',223.39,17),(81,'eos','Iure rerum voluptas aspernatur et consequatur a ducimus inventore.',228.08,55),(82,'et','Nisi temporibus ut officia incidunt praesentium est.',62.71,12),(83,'possimus','Occaecati corporis quia eius praesentium dignissimos veritatis molestiae.',258.56,13),(84,'rerum','Et voluptas veniam labore sit fugit.',83.32,44),(85,'quas','At quia nihil commodi eos enim autem.',15.42,47),(86,'in','Quisquam voluptatem consequatur illum tenetur omnis sequi quia.',240.22,46),(87,'est','Voluptatum sit sequi cum commodi laboriosam maiores cumque voluptatem.',196.34,14),(88,'ut','Modi qui dolor veniam nesciunt officiis reiciendis modi.',266.04,4),(89,'voluptatem','Deserunt totam quia consectetur et ut cum.',42.79,64),(90,'et','Nisi ipsum ratione recusandae sed modi ducimus.',16.4,56),(91,'et','Animi et aut maxime animi repellat qui eveniet.',179.73,3),(92,'ut','Enim labore quia qui hic est veritatis placeat repudiandae.',168.12,63),(93,'voluptas','Eos aut asperiores asperiores nemo totam debitis.',86.68,51),(94,'quo','Ut voluptates incidunt voluptate aut non repudiandae voluptatem.',83.61,41),(95,'nesciunt','Non ea molestias aliquid vitae qui qui deserunt totam.',189.84,85),(96,'aut','Vitae et est incidunt velit.',220.7,59),(97,'et','Nesciunt voluptas quisquam unde et voluptatem natus facilis.',286.16,12),(98,'est','Et culpa sed voluptas temporibus expedita numquam.',143.37,61),(99,'dicta','Nam maxime accusantium dolores dolores eos est natus.',150.16,32),(100,'mollitia','Reiciendis et nisi harum inventore libero et.',257.12,11),(101,'Brake Pad','High Quality Brake Pad',45.99,100),(102,'Oil Filter','Long-lasting Oil Filter',10.99,200),(103,'Autem doloremque','Ducimus molestiae eveniet harum repudiandae et dolor modi.',238.55,11),(104,'Aperiam nihil','Quis pariatur et dolorum voluptatem eos.',325.15,265),(105,'Facilis a','Voluptate molestiae eveniet cum voluptatum fugiat quae velit.',256.53,77),(106,'Dolores non','Quas illum repellendus minima dicta modi sit neque possimus.',159.99,479),(107,'Voluptatem aperiam','Sint commodi est qui ullam et quo ut.',443.91,404),(108,'Fugiat quasi','Voluptatem adipisci tempora quasi delectus velit.',348.17,161),(109,'Eaque sint','Corporis qui in neque ex eaque aut.',463.21,94),(110,'Rem laborum','Voluptatem voluptas quasi est ducimus.',172.85,242),(111,'Et sunt','Quis est consequatur voluptatem exercitationem iste voluptatum ipsum.',232.55,179),(112,'Necessitatibus perferendis','Nostrum et porro magni magnam.',191.62,244),(113,'Incidunt rerum','Laboriosam quisquam illum minima nesciunt et sint.',60.56,60),(114,'Voluptatem vitae','Dolor porro ut et architecto tempore necessitatibus.',39.73,182),(115,'Illo corrupti','Qui consequatur sunt nemo culpa sint iusto ratione.',377.73,321),(116,'Qui et','Praesentium eum mollitia esse.',425.01,177),(117,'Dolores magnam','Vel dicta sed vel libero dolorem.',350.9,67),(118,'Iusto similique','Cumque nisi a qui sint.',166.67,72),(119,'Earum sed','Ipsa animi laudantium ut tempora rerum at.',296.37,310),(120,'Quas quo','Vero nisi laudantium optio at quod sint.',346.37,198),(121,'Quasi quae','Et accusamus dolore non ut.',54.44,94),(122,'Molestiae in','Commodi in sequi libero nihil veniam.',453.26,462),(123,'Et ipsam','Ducimus nam consequatur odit.',33.29,305),(124,'Totam debitis','Animi qui ut qui ut quasi similique.',495.07,46),(125,'Repudiandae porro','Iusto aspernatur qui aut dolor.',318.25,161),(126,'Consequatur amet','Nam quisquam consequatur voluptas.',344,373),(127,'Voluptatem quis','Voluptas quis architecto voluptas rerum qui.',73.54,186),(128,'Repellendus consequuntur','Aut eaque illum ipsum.',240.49,121),(129,'Quis non','Est velit vitae deserunt blanditiis error voluptatem.',256,60),(130,'Quia exercitationem','Quia officia commodi soluta pariatur veniam.',86.46,310),(131,'Consequatur hic','Dolores provident qui ullam ad amet maiores.',129.61,130),(132,'Tempora vel','Quas asperiores nihil ut qui quod tempora.',432.33,150),(133,'Deleniti pariatur','Quia explicabo voluptatum aut ullam libero.',158.78,297),(134,'Possimus occaecati','Voluptate cum exercitationem voluptatem laboriosam.',81.58,27),(135,'Aut rerum','Eos quo eum expedita molestiae iure consequatur nobis porro.',195.46,374),(136,'Corrupti aspernatur','Qui enim adipisci odio cupiditate veritatis.',374.9,201),(137,'Et cupiditate','Hic aperiam est et aliquid.',398.51,364),(138,'Facere fuga','Tempora et sint mollitia molestiae dolore placeat iure.',30.08,206),(139,'Omnis exercitationem','Rerum iusto aut aut harum saepe asperiores.',52.93,312),(140,'Nam rerum','Eius non et accusamus et ea nulla.',57.52,452),(141,'Sint velit','Eos minus qui recusandae a et distinctio neque cumque.',398.14,435),(142,'Vero temporibus','Id ut nostrum maiores nam.',115.19,82),(143,'Nemo rerum','Voluptatem tempora qui repellendus non aut aspernatur voluptatum blanditiis.',278.09,173),(144,'Asperiores rem','Optio est et voluptas corporis dolores.',211.84,193),(145,'Occaecati nostrum','Totam libero doloribus esse voluptate facilis molestiae.',428.62,12),(146,'Velit voluptatem','Aut occaecati inventore quas nihil fugit deserunt autem ea.',155.96,197),(147,'Ratione minima','Totam consequatur necessitatibus perferendis aut quasi.',50.57,318),(148,'Accusantium mollitia','Cumque sunt repellendus dicta impedit.',235.53,255),(149,'Et ad','Voluptas quo eveniet id eaque.',342,135),(150,'Cumque neque','Nihil molestiae ut non.',388,115),(151,'Facilis esse','Quas sit rerum id odit omnis a.',437.45,316),(152,'Culpa odit','Quibusdam eveniet molestiae eum enim accusamus optio.',264.63,379),(153,'Sequi ut','Cum consequatur omnis eligendi consequuntur.',382.71,143),(154,'Quam unde','At nulla adipisci ipsam atque delectus accusamus.',457,371),(155,'Sed exercitationem','Iste nihil aliquam aut expedita qui ut.',189.06,213),(156,'Temporibus natus','Deleniti quia consequatur et est ipsam sit.',317.96,142),(157,'Fuga aut','Quia voluptas in et quaerat architecto.',216.22,162),(158,'Illum aut','Eum omnis iste molestias dolore distinctio eos.',367.55,22),(159,'Voluptatum nisi','Harum eos et libero reiciendis minus nihil dolor et.',228.63,469),(160,'Culpa sit','Reiciendis fugiat nulla libero illo.',291.84,5),(161,'Quo mollitia','Pariatur rerum qui et est vero qui architecto.',478.35,221),(162,'Fugit itaque','Modi ut molestiae minus ut minima pariatur quis.',258.7,374),(163,'Ratione natus','Molestiae assumenda animi omnis cumque dolorum voluptas nihil qui.',33.56,274),(164,'Id nobis','Sed sunt enim expedita cupiditate.',208.31,430),(165,'Dolorem vel','Debitis molestiae quidem rerum vel aperiam placeat et.',395.76,304),(166,'Eos aut','Eum sunt aspernatur quo aliquam dolorum ut voluptatum.',299.31,38),(167,'Et id','A numquam accusantium eos temporibus repellendus sunt.',414.35,272),(168,'Quasi consequatur','In qui similique quia dolor et voluptates.',181.21,482),(169,'Vel id','Eligendi illum ut ut neque consequatur.',99.73,181),(170,'Eveniet ut','Velit deleniti qui in unde aliquid accusantium omnis.',35.9,71),(171,'Quis inventore','Aliquid quis est omnis rerum optio.',407.23,427),(172,'Tempora id','Quis corporis magni unde provident.',346.18,10),(173,'Harum aspernatur','Est natus cupiditate adipisci omnis.',209.95,478),(174,'In vero','Provident voluptatem voluptas qui et.',206.66,7),(175,'Perspiciatis perspiciatis','Dolor pariatur sequi reprehenderit ut nihil.',143.12,196),(176,'Quaerat sed','Pariatur magnam sed perspiciatis illo.',121.36,340),(177,'Asperiores deleniti','Est fugiat et labore aspernatur omnis omnis.',166.28,465),(178,'Maxime accusamus','Voluptatibus occaecati nulla et porro.',328.39,460),(179,'Repellat vero','Totam voluptatem accusantium hic veritatis consequatur velit.',20.48,159),(180,'Aspernatur nobis','Nihil reiciendis aspernatur sit quo veniam maxime explicabo.',347.93,47),(181,'Dicta a','Nobis laboriosam voluptatem maiores qui commodi quis.',214.77,467),(182,'Aut dolor','Rerum aut explicabo amet qui sit perferendis repudiandae qui.',304.44,316),(183,'Veritatis blanditiis','Voluptates dolores unde ut est.',293.91,213),(184,'Rerum quaerat','Ex perspiciatis similique maiores laudantium in.',406.25,116),(185,'Modi asperiores','Id in velit nobis velit.',111.6,436),(186,'Quis qui','Rerum unde rerum nihil.',389.36,435),(187,'Sit ad','Dolorum facere nesciunt nulla perspiciatis.',375.03,498),(188,'Aspernatur quam','Iusto nihil atque a.',118.34,308),(189,'Quidem accusantium','Officia sunt voluptas vel.',236.05,29),(190,'Eveniet sed','Nulla vel perferendis aut qui tempora laboriosam.',36.94,500),(191,'Est repudiandae','Voluptatibus nesciunt aut dolores et est atque.',307.38,98),(192,'Consequatur laudantium','Sunt ut id eveniet repellat enim.',59.42,36),(193,'Nam numquam','Eos non omnis omnis eveniet aut vel consequatur.',156.82,181),(194,'Amet beatae','Laudantium incidunt et consectetur unde corrupti facilis.',150.96,362),(195,'Ea quia','Voluptate nesciunt velit et in exercitationem.',25.4,370),(196,'Ex qui','Sint cumque et recusandae non illum ex dolores illum.',365.41,482),(197,'Nihil aliquam','Quia amet vel recusandae iusto totam quisquam et.',46.73,447),(198,'Corrupti fugit','Non dolor voluptatem quibusdam sequi sed ut.',226.77,428),(199,'Nam quasi','Dolores reprehenderit quia et ab quis est est.',326.63,411),(200,'Quas nam','Nesciunt minus quidem autem non iusto eaque.',151.64,33),(201,'Impedit atque','Corrupti rerum rerum omnis eos.',466.61,396),(202,'In a','Doloremque dolor sit qui facilis vel fugiat.',224.15,302);
/*!40000 ALTER TABLE `parts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `stock` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Laptop Pro','High-performance laptop with 16GB RAM and 512GB SSD.',1299.99,10,'2025-08-22 03:47:30','2025-08-22 03:47:30'),(2,'Wireless Mouse','Ergonomic wireless mouse with USB receiver.',29.99,50,'2025-08-22 03:47:30','2025-08-22 03:47:30'),(3,'Noise Cancelling Headphones','Over-ear headphones with active noise cancellation.',199.99,20,'2025-08-22 03:47:30','2025-08-22 03:47:30');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('customer','admin') DEFAULT 'customer',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Alice Admin','alice@example.com','hashedpassword1','admin','2025-08-22 03:47:30'),(2,'Bob Buyer','bob@example.com','hashedpassword2','customer','2025-08-22 03:47:30'),(3,'Charlie Customer','charlie@example.com','hashedpassword3','customer','2025-08-22 03:47:30');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-31 14:16:37
