<?php
$ip = isset($_SERVER['HTTP_CLIENT_IP']) 
    ? $_SERVER['HTTP_CLIENT_IP'] 
    : (isset($_SERVER['HTTP_X_FORWARDED_FOR']) 
        ? $_SERVER['HTTP_X_FORWARDED_FOR'] 
        : $_SERVER['REMOTE_ADDR']);

$date = date('Y-m-d H:i:s');
$data = "IP: " . $ip . "\nDate: " . $date . "\n\n";

file_put_contents("ip.txt", $data, FILE_APPEND);
?>
