<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
$conn = new mysqli("localhost", "root", "", "pet_hotel_db");

$user_id = $_GET['user_id'];
// ดึงรายชื่อสัตว์เลี้ยงของ user คนนั้นๆ
$sql = "SELECT pet_id, pet_name, pet_type FROM pets WHERE user_id = '$user_id'";
$result = $conn->query($sql);

$pets = [];
while($row = $result->fetch_assoc()) {
    $pets[] = $row;
}
echo json_encode($pets);
$conn->close();
?>