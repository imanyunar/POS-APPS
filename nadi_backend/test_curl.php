<?php
$ch = curl_init('http://127.0.0.1:8000/api/auth/login');
curl_setopt_array($ch, [
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => json_encode(['email'=>'owner@warung.test','password'=>'password']),
    CURLOPT_HTTPHEADER => ['Content-Type: application/json', 'Accept: application/json'],
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HEADER => true,
]);
$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$contentType = curl_getinfo($ch, CURLINFO_CONTENT_TYPE);
echo 'HTTP Code: ' . $httpCode . PHP_EOL;
echo 'Content-Type: ' . $contentType . PHP_EOL;
echo 'Body: ' . substr($response, -300) . PHP_EOL;
curl_close($ch);
