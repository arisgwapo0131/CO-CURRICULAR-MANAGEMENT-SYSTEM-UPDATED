<?php
// ============================================================
//  INDEX.PHP — Root Entry Point & Smart Setup Router
// ============================================================
require_once __DIR__ . '/app/shared/db.php';

session_start();

if (!empty($_SESSION['user_id'])) {
    header('Location: app/dashboard/dashboard.php');
    exit;
}

// Check if tables are installed
$tableCheck = $conn->query("SHOW TABLES LIKE 'users'");

if (!$tableCheck || $tableCheck->num_rows === 0) {
    // Database empty -> auto-launch setup wizard
    header('Location: app/shared/setup.php');
} else {
    // Database ready -> go to sign in
    header('Location: app/auth/signin.php');
}
exit;
