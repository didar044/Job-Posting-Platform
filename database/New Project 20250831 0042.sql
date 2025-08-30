-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema hireme
--

CREATE DATABASE IF NOT EXISTS hireme;
USE hireme;

--
-- Definition of table `hm_applications`
--

DROP TABLE IF EXISTS `hm_applications`;
CREATE TABLE `hm_applications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `hm_job_id` bigint(20) unsigned NOT NULL,
  `cover_letter` text DEFAULT NULL,
  `cv_file` varchar(255) NOT NULL,
  `status` enum('pending','accepted','rejected') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hm_applications_user_id_foreign` (`user_id`),
  KEY `hm_applications_hm_job_id_foreign` (`hm_job_id`),
  CONSTRAINT `hm_applications_hm_job_id_foreign` FOREIGN KEY (`hm_job_id`) REFERENCES `hm_hm_jobs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hm_applications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `hm_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_applications`
--

/*!40000 ALTER TABLE `hm_applications` DISABLE KEYS */;
/*!40000 ALTER TABLE `hm_applications` ENABLE KEYS */;


--
-- Definition of table `hm_cache`
--

DROP TABLE IF EXISTS `hm_cache`;
CREATE TABLE `hm_cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_cache`
--

/*!40000 ALTER TABLE `hm_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `hm_cache` ENABLE KEYS */;


--
-- Definition of table `hm_cache_locks`
--

DROP TABLE IF EXISTS `hm_cache_locks`;
CREATE TABLE `hm_cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_cache_locks`
--

/*!40000 ALTER TABLE `hm_cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `hm_cache_locks` ENABLE KEYS */;


--
-- Definition of table `hm_failed_jobs`
--

DROP TABLE IF EXISTS `hm_failed_jobs`;
CREATE TABLE `hm_failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `hm_failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_failed_jobs`
--

/*!40000 ALTER TABLE `hm_failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `hm_failed_jobs` ENABLE KEYS */;


--
-- Definition of table `hm_hm_jobs`
--

DROP TABLE IF EXISTS `hm_hm_jobs`;
CREATE TABLE `hm_hm_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hm_hm_jobs_user_id_foreign` (`user_id`),
  CONSTRAINT `hm_hm_jobs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `hm_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_hm_jobs`
--

/*!40000 ALTER TABLE `hm_hm_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `hm_hm_jobs` ENABLE KEYS */;


--
-- Definition of table `hm_invoices`
--

DROP TABLE IF EXISTS `hm_invoices`;
CREATE TABLE `hm_invoices` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `application_id` bigint(20) unsigned NOT NULL,
  `amount` decimal(8,2) NOT NULL,
  `payment_method` enum('stripe','sslcommerz','manual') NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `payment_status` enum('pending','paid','cancelled') NOT NULL DEFAULT 'paid',
  PRIMARY KEY (`id`),
  KEY `hm_invoices_user_id_foreign` (`user_id`),
  KEY `hm_invoices_application_id_foreign` (`application_id`),
  CONSTRAINT `hm_invoices_application_id_foreign` FOREIGN KEY (`application_id`) REFERENCES `hm_applications` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hm_invoices_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `hm_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_invoices`
--

/*!40000 ALTER TABLE `hm_invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `hm_invoices` ENABLE KEYS */;


--
-- Definition of table `hm_job_batches`
--

DROP TABLE IF EXISTS `hm_job_batches`;
CREATE TABLE `hm_job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_job_batches`
--

/*!40000 ALTER TABLE `hm_job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `hm_job_batches` ENABLE KEYS */;


--
-- Definition of table `hm_jobs`
--

DROP TABLE IF EXISTS `hm_jobs`;
CREATE TABLE `hm_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hm_jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_jobs`
--

/*!40000 ALTER TABLE `hm_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `hm_jobs` ENABLE KEYS */;


--
-- Definition of table `hm_migrations`
--

DROP TABLE IF EXISTS `hm_migrations`;
CREATE TABLE `hm_migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_migrations`
--

/*!40000 ALTER TABLE `hm_migrations` DISABLE KEYS */;
INSERT INTO `hm_migrations` (`id`,`migration`,`batch`) VALUES 
 (1,'0001_01_01_000000_create_users_table',1),
 (2,'0001_01_01_000001_create_cache_table',1),
 (3,'0001_01_01_000002_create_jobs_table',1),
 (4,'2025_08_29_054530_create_personal_access_tokens_table',2),
 (5,'2025_08_29_183107_create_permission_tables',3),
 (6,'2025_08_29_192926_create_hm_jobs_table',4),
 (7,'2025_08_29_215206_create_hm_applications_table',5),
 (8,'2025_08_29_221008_create_hm_applications_table',6),
 (9,'2025_08_29_222302_create_applications_table',6),
 (10,'2025_08_29_222836_create_invoices_table',7),
 (11,'2025_08_29_223717_create_applications_table',8),
 (12,'2025_08_29_223831_create_invoices_table',9),
 (13,'2025_08_30_074233_add_payment_status_to_invoices',10);
/*!40000 ALTER TABLE `hm_migrations` ENABLE KEYS */;


--
-- Definition of table `hm_model_has_permissions`
--

DROP TABLE IF EXISTS `hm_model_has_permissions`;
CREATE TABLE `hm_model_has_permissions` (
  `permission_id` bigint(20) unsigned NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `hm_model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `hm_permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_model_has_permissions`
--

/*!40000 ALTER TABLE `hm_model_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `hm_model_has_permissions` ENABLE KEYS */;


--
-- Definition of table `hm_model_has_roles`
--

DROP TABLE IF EXISTS `hm_model_has_roles`;
CREATE TABLE `hm_model_has_roles` (
  `role_id` bigint(20) unsigned NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `hm_model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `hm_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_model_has_roles`
--

/*!40000 ALTER TABLE `hm_model_has_roles` DISABLE KEYS */;
INSERT INTO `hm_model_has_roles` (`role_id`,`model_type`,`model_id`) VALUES 
 (1,'App\\Models\\User',3),
 (3,'App\\Models\\User',1),
 (3,'App\\Models\\User',2),
 (3,'App\\Models\\User',4);
/*!40000 ALTER TABLE `hm_model_has_roles` ENABLE KEYS */;


--
-- Definition of table `hm_password_reset_tokens`
--

DROP TABLE IF EXISTS `hm_password_reset_tokens`;
CREATE TABLE `hm_password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_password_reset_tokens`
--

/*!40000 ALTER TABLE `hm_password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `hm_password_reset_tokens` ENABLE KEYS */;


--
-- Definition of table `hm_permissions`
--

DROP TABLE IF EXISTS `hm_permissions`;
CREATE TABLE `hm_permissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hm_permissions_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_permissions`
--

/*!40000 ALTER TABLE `hm_permissions` DISABLE KEYS */;
INSERT INTO `hm_permissions` (`id`,`name`,`guard_name`,`created_at`,`updated_at`) VALUES 
 (1,'view all users','api','2025-08-29 18:42:50','2025-08-29 18:42:50'),
 (2,'view all jobs','api','2025-08-29 18:42:50','2025-08-29 18:42:50'),
 (3,'view all applications','api','2025-08-29 18:42:50','2025-08-29 18:42:50'),
 (4,'filter applications','api','2025-08-29 18:42:50','2025-08-29 18:42:50'),
 (5,'accept application','api','2025-08-29 18:42:50','2025-08-29 18:42:50'),
 (6,'reject application','api','2025-08-29 18:42:50','2025-08-29 18:42:50'),
 (7,'apply for jobs','api','2025-08-29 18:42:50','2025-08-29 18:42:50'),
 (8,'view own applications','api','2025-08-29 18:42:50','2025-08-29 18:42:50');
/*!40000 ALTER TABLE `hm_permissions` ENABLE KEYS */;


--
-- Definition of table `hm_personal_access_tokens`
--

DROP TABLE IF EXISTS `hm_personal_access_tokens`;
CREATE TABLE `hm_personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hm_personal_access_tokens_token_unique` (`token`),
  KEY `hm_personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `hm_personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_personal_access_tokens`
--

/*!40000 ALTER TABLE `hm_personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `hm_personal_access_tokens` ENABLE KEYS */;


--
-- Definition of table `hm_role_has_permissions`
--

DROP TABLE IF EXISTS `hm_role_has_permissions`;
CREATE TABLE `hm_role_has_permissions` (
  `permission_id` bigint(20) unsigned NOT NULL,
  `role_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `hm_role_has_permissions_role_id_foreign` (`role_id`),
  CONSTRAINT `hm_role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `hm_permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hm_role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `hm_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_role_has_permissions`
--

/*!40000 ALTER TABLE `hm_role_has_permissions` DISABLE KEYS */;
INSERT INTO `hm_role_has_permissions` (`permission_id`,`role_id`) VALUES 
 (1,1),
 (2,1),
 (3,1),
 (3,2),
 (4,1),
 (5,1),
 (5,2),
 (6,1),
 (6,2),
 (7,1),
 (7,3),
 (8,1),
 (8,3);
/*!40000 ALTER TABLE `hm_role_has_permissions` ENABLE KEYS */;


--
-- Definition of table `hm_roles`
--

DROP TABLE IF EXISTS `hm_roles`;
CREATE TABLE `hm_roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hm_roles_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_roles`
--

/*!40000 ALTER TABLE `hm_roles` DISABLE KEYS */;
INSERT INTO `hm_roles` (`id`,`name`,`guard_name`,`created_at`,`updated_at`) VALUES 
 (1,'admin','api','2025-08-29 18:42:50','2025-08-29 18:42:50'),
 (2,'employee','api','2025-08-29 18:42:50','2025-08-29 18:42:50'),
 (3,'jobseeker','api','2025-08-29 18:42:50','2025-08-29 18:42:50');
/*!40000 ALTER TABLE `hm_roles` ENABLE KEYS */;


--
-- Definition of table `hm_sessions`
--

DROP TABLE IF EXISTS `hm_sessions`;
CREATE TABLE `hm_sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hm_sessions_user_id_index` (`user_id`),
  KEY `hm_sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_sessions`
--

/*!40000 ALTER TABLE `hm_sessions` DISABLE KEYS */;
INSERT INTO `hm_sessions` (`id`,`user_id`,`ip_address`,`user_agent`,`payload`,`last_activity`) VALUES 
 ('Enav7HEUHFGxB7M6Q7leSntWwmOzeUJm1LhfmkEm',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiVUZhWFpreXhNOUhXdjBGSVMzaDYzRFVtallKREFncjREN3RwZ1pUaCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1756463716),
 ('FOyqpcb4IE2lLPeUw8ptqo7HRz7g3V5WI4lqaS3S',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiNENBUFRmUlUyZ0xpOWxtWFN5RzE0S3FGcU95ZFFXZWx4SUxtN3pQbCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1756446182),
 ('h2n10demgXHVn4uEDe3EUYIRcG6AEBpy65KeiDCI',NULL,'127.0.0.1','PostmanRuntime/7.44.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiRlNXdURWbEgwZXQ5MlZWZ25SU1N1NnYxTmlBUjJqWGpQdlJ3c3NGQSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1756463315),
 ('JBR5ECk36COgC9nOIE58t8iP3VJ10esx0P9qOJE5',NULL,'127.0.0.1','PostmanRuntime/7.44.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiVlZ4d1Q1MGZHbEZjWlhFbWhYSDZKV0NPTTh3SDJjQjVhVEVSY2xreCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1756471935),
 ('Ma7SoU9FxMVqEnt9fjXm96Y2eeC4E4dJb8y9nIfY',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiNk9sYkwyUUFYNDFoNGRRMlc4N1pwWThUeXhWQjJoQWhkV3l4Zk1NMyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1756577434),
 ('Q0AITOxVl9ghyku6cvO4XOe4b6GGC0w9rzPVgfgP',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiMUh3SkFNUFJoeTMzWHNRZEgyS3E4aEZjNUtoR25WSjhjVXZWRDhVaiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1756462745),
 ('YrlzV0gKRVx5GVNh18fE9VrfYnGgMo7MI79ZenvK',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiYTdzN3F3V3BrM2MxN3pzeHNoc0trak9mdnRXUlgzc01oanZEME9qViI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1756498067);
/*!40000 ALTER TABLE `hm_sessions` ENABLE KEYS */;


--
-- Definition of table `hm_users`
--

DROP TABLE IF EXISTS `hm_users`;
CREATE TABLE `hm_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hm_users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hm_users`
--

/*!40000 ALTER TABLE `hm_users` DISABLE KEYS */;
INSERT INTO `hm_users` (`id`,`name`,`email`,`email_verified_at`,`password`,`remember_token`,`created_at`,`updated_at`) VALUES 
 (1,'Test User','test@example.com',NULL,'$2y$12$zLjd8LLiDrqjeP/rLJOMK.Zdka/TSfFzzM.f4eIie4lJiV1r2GMzO',NULL,'2025-08-29 10:36:24','2025-08-29 10:36:24'),
 (2,'Test User','tet@example.com',NULL,'$2y$12$qnnvG7u20ObmPqJIo5vVQ.ormM1MCtcH/sLGKOEYhDqOoLvwaV.qm',NULL,'2025-08-29 12:40:07','2025-08-29 12:40:07'),
 (3,'Admin User','admin@hireme.com',NULL,'$2y$12$Bm44DxWDsDqIKKOXejDI/ODr.23sTfa6IN0PQw61SkMtNwck/Gb3a',NULL,'2025-08-29 18:50:52','2025-08-29 18:50:52'),
 (4,'John Doe','john@example.com',NULL,'$2y$12$FCmRqPMRVEmczyDGa.muCeYNdxomf555CyPwcu5KqGD4hhnNGkTWG',NULL,'2025-08-29 19:01:30','2025-08-29 19:01:30');
/*!40000 ALTER TABLE `hm_users` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
