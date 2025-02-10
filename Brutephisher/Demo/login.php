<?php
$correct_username = "admin";
$correct_password = "fuckyou2";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST["username"];
    $password = $_POST["password"];
    
    if ($username === $correct_username && $password === $correct_password) {
        echo "Login Successful";
        exit();
    } else {
        echo "Login Failed";
        exit();
    }
}
?> 