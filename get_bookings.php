<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pet_hotel_db";

$conn = new mysqli($servername, $username, $password, $dbname);

// รับ userId เพื่อดึงเฉพาะรายการของคนนั้นๆ
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : 0;

$sql = "SELECT b.booking_id, p.pet_name, p.pet_type, b.total_price, b.status, b.booking_date 
        FROM bookings b
        JOIN pets p ON b.pet_id = p.pet_id
        WHERE b.user_id = '$user_id'
        ORDER BY b.booking_date DESC";

$result = $conn->query($sql);

$bookings = [];
while($row = $result->fetch_assoc()) {
    $bookings[] = $row;
}

echo json_encode($bookings);
$conn->close();
?>