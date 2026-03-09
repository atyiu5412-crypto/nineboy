<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

$conn = new mysqli("localhost", "root", "", "pet_hotel_db");

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed"]));
}

$data = json_decode(file_get_contents("php://input"), true);

if(!empty($data['user_id']) && !empty($data['pet_id'])) {
    $u_id = $data['user_id'];
    $p_id = $data['pet_id'];
    $total = $data['total_price'];
    
    // บันทึกลงตาราง bookings
    $sql = "INSERT INTO bookings (user_id, pet_id, total_price, status, booking_date) 
            VALUES ('$u_id', '$p_id', '$total', 'รอการยืนยัน', NOW())";
    
    if($conn->query($sql)) {
        echo json_encode(["status" => "success", "message" => "จองสำเร็จ"]);
    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "ข้อมูลไม่ครบ"]);
}
$conn->close();
?>