-- ============================================================
--  Co-Curricular Student Management System (SMS) Database Export
--  Database Name : `sms_db`
--  Compatibility : MySQL 5.7+ / MariaDB 10.2+ / phpMyAdmin / XAMPP
--  Generated for : BCP Multi-Role Co-Curricular SMS
-- ============================================================

CREATE DATABASE IF NOT EXISTS `sms_db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `sms_db`;

SET FOREIGN_KEY_CHECKS = 0;

-- --------------------------------------------------------
-- Table structure for `users`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
    `id`            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `username`      VARCHAR(60)   NOT NULL UNIQUE,
    `email`         VARCHAR(150)  NOT NULL UNIQUE,
    `first_name`    VARCHAR(100)  NOT NULL,
    `last_name`     VARCHAR(100)  NOT NULL,
    `password_hash` VARCHAR(255)  NOT NULL,
    `role`          ENUM('admin','student','club_adviser','ssc','finance_officer','osa_director') NOT NULL DEFAULT 'student',
    `profile_pic`   VARCHAR(255)  DEFAULT NULL,
    `created_at`    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at`    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `students`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `students`;
CREATE TABLE `students` (
    `id`             INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `student_number` VARCHAR(50)   DEFAULT NULL,
    `first_name`     VARCHAR(100)  NOT NULL,
    `last_name`      VARCHAR(100)  NOT NULL,
    `birthday`       DATE          DEFAULT NULL,
    `course`         VARCHAR(150)  NOT NULL,
    `year_level`     VARCHAR(50)   NOT NULL,
    `section`        VARCHAR(50)   NOT NULL,
    `phone`          VARCHAR(30)   DEFAULT NULL,
    `status`         ENUM('Active','Inactive') NOT NULL DEFAULT 'Active',
    `created_at`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `clubs`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `clubs`;
CREATE TABLE `clubs` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `code`         VARCHAR(20)  NOT NULL UNIQUE,
    `name`         VARCHAR(150) NOT NULL,
    `category`     ENUM('Academic','Cultural','Sports','Advocacy','Religious') NOT NULL DEFAULT 'Academic',
    `description`  TEXT,
    `adviser_name` VARCHAR(150) DEFAULT 'Unassigned',
    `status`       ENUM('Active','Pending Charter','Suspended') NOT NULL DEFAULT 'Active',
    `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `club_memberships`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `club_memberships`;
CREATE TABLE `club_memberships` (
    `id`                 INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `club_id`            INT UNSIGNED NOT NULL,
    `user_id`            INT UNSIGNED NOT NULL,
    `role`               VARCHAR(50) DEFAULT 'Member',
    `status`             ENUM('Active','Pending','Rejected') NOT NULL DEFAULT 'Pending',
    `approved_by`        INT UNSIGNED DEFAULT NULL,
    `letter_intent`      VARCHAR(255) DEFAULT NULL,
    `letter_endorsement` VARCHAR(255) DEFAULT NULL,
    `joined_at`          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uq_club_user` (`club_id`, `user_id`),
    KEY `idx_user` (`user_id`),
    KEY `idx_club` (`club_id`),
    CONSTRAINT `fk_cm_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_cm_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `club_applications`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `club_applications`;
CREATE TABLE `club_applications` (
    `id`                 INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `club_id`            INT UNSIGNED NOT NULL,
    `user_id`            INT UNSIGNED NOT NULL,
    `first_name`         VARCHAR(100) NOT NULL,
    `last_name`          VARCHAR(100) NOT NULL,
    `student_id_no`      VARCHAR(50) DEFAULT NULL,
    `course`             VARCHAR(150) DEFAULT NULL,
    `year_level`         VARCHAR(50) DEFAULT NULL,
    `email`              VARCHAR(150) DEFAULT NULL,
    `phone`              VARCHAR(30) DEFAULT NULL,
    `sex`                VARCHAR(20) DEFAULT NULL,
    `dob`                DATE DEFAULT NULL,
    `address`            TEXT DEFAULT NULL,
    `motivation`         TEXT DEFAULT NULL,
    `letter_intent`      VARCHAR(255) DEFAULT NULL,
    `letter_endorsement` VARCHAR(255) DEFAULT NULL,
    `status`             ENUM('Pending','Approved','Rejected') NOT NULL DEFAULT 'Pending',
    `reviewed_by`        INT UNSIGNED DEFAULT NULL,
    `reviewed_at`        DATETIME DEFAULT NULL,
    `created_at`         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_ca_club` (`club_id`),
    KEY `idx_ca_user` (`user_id`),
    KEY `idx_ca_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `events`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
    `id`             INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `club_id`        INT UNSIGNED NOT NULL,
    `title`          VARCHAR(200) NOT NULL,
    `description`    TEXT,
    `event_date`     DATETIME NOT NULL,
    `venue`          VARCHAR(150) NOT NULL,
    `status`         ENUM('Upcoming','Approved','Completed','Pending SSC','Pending OSA','Rejected') NOT NULL DEFAULT 'Pending SSC',
    `created_by`     INT UNSIGNED DEFAULT NULL,
    `rejection_note` TEXT DEFAULT NULL,
    `created_at`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_events_club` (`club_id`),
    CONSTRAINT `fk_events_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `event_registrations`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `event_registrations`;
CREATE TABLE `event_registrations` (
    `id`            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `event_id`      INT UNSIGNED NOT NULL,
    `user_id`       INT UNSIGNED NOT NULL,
    `registered_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `status`        ENUM('Registered','Attended','Cancelled') NOT NULL DEFAULT 'Registered',
    UNIQUE KEY `uq_event_user_reg` (`event_id`, `user_id`),
    KEY `idx_user` (`user_id`),
    KEY `idx_event` (`event_id`),
    CONSTRAINT `fk_er_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_er_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `budget_requests`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `budget_requests`;
CREATE TABLE `budget_requests` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `club_id`      INT UNSIGNED NOT NULL,
    `title`        VARCHAR(200) NOT NULL,
    `description`  TEXT DEFAULT NULL,
    `amount`       DECIMAL(10,2) NOT NULL,
    `status`       ENUM('Pending Adviser','Pending SSC','Pending Admin','Pending OSA','Pending Finance','Disbursed','Rejected') NOT NULL DEFAULT 'Pending Adviser',
    `requested_by` INT UNSIGNED NOT NULL,
    `notes`        TEXT DEFAULT NULL,
    `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY `idx_br_club` (`club_id`),
    KEY `idx_br_user` (`requested_by`),
    CONSTRAINT `fk_br_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_br_user` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `attendance_logs`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `attendance_logs`;
CREATE TABLE `attendance_logs` (
    `id`        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `event_id`  INT UNSIGNED NOT NULL,
    `user_id`   INT UNSIGNED NOT NULL,
    `check_in`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `method`    ENUM('QR','RFID','Manual','QR_SELF') NOT NULL DEFAULT 'QR',
    `logged_by` INT UNSIGNED DEFAULT NULL,
    UNIQUE KEY `uq_event_user` (`event_id`, `user_id`),
    KEY `idx_user` (`user_id`),
    KEY `idx_event` (`event_id`),
    CONSTRAINT `fk_al_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_al_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `achievements`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `achievements`;
CREATE TABLE `achievements` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `club_id`      INT UNSIGNED NOT NULL,
    `submitted_by` INT UNSIGNED NOT NULL,
    `title`        VARCHAR(250) NOT NULL,
    `competition`  VARCHAR(250) NOT NULL,
    `award_date`   DATE NOT NULL,
    `proof_file`   VARCHAR(300) DEFAULT NULL,
    `status`       ENUM('Pending','Verified','Rejected') NOT NULL DEFAULT 'Pending',
    `verified_by`  INT UNSIGNED DEFAULT NULL,
    `notes`        TEXT DEFAULT NULL,
    `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_ach_club` (`club_id`),
    KEY `idx_ach_user` (`submitted_by`),
    CONSTRAINT `fk_ach_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_ach_user` FOREIGN KEY (`submitted_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `notifications`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
    `id`         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id`    INT UNSIGNED NOT NULL,
    `title`      VARCHAR(200) NOT NULL,
    `message`    TEXT NOT NULL,
    `type`       VARCHAR(50) DEFAULT 'info',
    `is_read`    TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_user_read` (`user_id`, `is_read`),
    CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `audit_logs`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `audit_logs`;
CREATE TABLE `audit_logs` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id`      INT UNSIGNED NOT NULL,
    `action`       VARCHAR(100) NOT NULL,
    `target_table` VARCHAR(100) DEFAULT NULL,
    `target_id`    INT UNSIGNED DEFAULT NULL,
    `detail`       TEXT DEFAULT NULL,
    `ip_address`   VARCHAR(50) DEFAULT NULL,
    `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_audit_user` (`user_id`),
    KEY `idx_audit_created` (`created_at`),
    CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `elections`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `elections`;
CREATE TABLE `elections` (
    `id`            INT AUTO_INCREMENT PRIMARY KEY,
    `election_code` VARCHAR(50) UNIQUE NOT NULL,
    `club_id`       INT NOT NULL,
    `title`         VARCHAR(255) NOT NULL,
    `description`   TEXT NULL,
    `closes_at`     DATETIME NULL,
    `status`        ENUM('open', 'closed', 'counting') DEFAULT 'open',
    `positions`     TEXT NULL,
    `created_by`    INT NOT NULL,
    `created_at`    DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `election_candidates`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `election_candidates`;
CREATE TABLE `election_candidates` (
    `id`             INT AUTO_INCREMENT PRIMARY KEY,
    `election_id`    INT NOT NULL,
    `candidate_code` VARCHAR(50) NOT NULL,
    `name`           VARCHAR(150) NOT NULL,
    `position`       VARCHAR(100) NOT NULL,
    `party`          VARCHAR(150) NULL,
    `year_level`     VARCHAR(50) NULL,
    `program`        VARCHAR(50) NULL,
    `gwa`            VARCHAR(20) NULL,
    `platform_tag`   TEXT NULL,
    `achievements`   TEXT NULL,
    `votes_count`    INT DEFAULT 0,
    `created_at`     DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `election_votes`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `election_votes`;
CREATE TABLE `election_votes` (
    `id`          INT AUTO_INCREMENT PRIMARY KEY,
    `election_id` INT NOT NULL,
    `user_id`     INT NOT NULL,
    `votes_json`  TEXT NOT NULL,
    `created_at`  DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `user_election` (`election_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `org_announcements`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `org_announcements`;
CREATE TABLE `org_announcements` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `club_id`      INT UNSIGNED NOT NULL,
    `author_id`    INT UNSIGNED NOT NULL,
    `title`        VARCHAR(250) NOT NULL,
    `category`     ENUM('Event','Activity','Requirement / Submission','Meeting','General') NOT NULL DEFAULT 'General',
    `priority`     ENUM('Normal','Important','Urgent') NOT NULL DEFAULT 'Normal',
    `content`      TEXT NOT NULL,
    `target_group` VARCHAR(100) DEFAULT 'All Members',
    `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_ann_club` (`club_id`),
    KEY `idx_ann_author` (`author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `ai_recommendation_logs`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `ai_recommendation_logs`;
CREATE TABLE `ai_recommendation_logs` (
    `id`              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id`         INT UNSIGNED NOT NULL,
    `request_type`    ENUM('recommendation','report') NOT NULL,
    `prompt_summary`  TEXT,
    `ai_response`     MEDIUMTEXT,
    `model_used`      VARCHAR(100) DEFAULT 'gemini-2.0-flash',
    `created_at`      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_ai_user` (`user_id`),
    KEY `idx_ai_type` (`request_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
