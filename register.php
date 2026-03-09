<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// 1. ตั้งค่าการเชื่อมต่อฐานข้อมูล
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pet_hotel_db";

// สร้างการเชื่อมต่อ
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

// 2. รับข้อมูล JSON จาก Flutter
$data = json_decode(file_get_contents("php://input"), true);

if (
    !empty($data['fullname']) && 
    !empty($data['email']) && 
    !empty($data['password']) && 
    !empty($data['phone'])
) {
    $fullname = $conn->real_escape_string($data['fullname']);
    $email = $conn->real_escape_string($data['email']);
    $phone = $conn->real_escape_string($data['phone']);
    
    // เทคนิคความปลอดภัย: การเข้ารหัสรหัสผ่าน (Password Hashing)
    $hashed_password = password_hash($data['password'], PASSWORD_DEFAULT);

    // ตรวจสอบว่ามีอีเมลนี้ในระบบหรือยัง
    $checkEmail = "SELECT email FROM users WHERE email = '$email'";
    $result = $conn->query($checkEmail);

    if ($result->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "อีเมลนี้ถูกใช้งานไปแล้ว"]);
    } else {
        // บันทึกข้อมูลลงฐานข้อมูล
        $sql = "INSERT INTO users (fullname, email, password, phone) 
                VALUES ('$fullname', '$email', '$hashed_password', '$phone')";

        if ($conn->query($sql) === TRUE) {
            echo json_encode(["status" => "success", "message" => "สมัครสมาชิกสำเร็จ"]);
        } else {
            echo json_encode(["status" => "error", "message" => "เกิดข้อผิดพลาด: " . $conn->error]);
        }
    }
} else {
    echo json_encode(["status" => "error", "message" => "กรุณากรอกข้อมูลให้ครบถ้วน"]);
}

$conn->close();
?>