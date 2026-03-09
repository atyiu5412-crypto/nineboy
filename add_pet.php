<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pet_hotel_db";

$conn = new mysqli($servername, $username, $password, $dbname);

$data = json_decode(file_get_contents("php://input"), true);

if(!empty($data['user_id']) && !empty($data['pet_name'])) {
    $user_id = $data['user_id'];
    $pet_name = $data['pet_name'];
    $pet_type = $data['pet_type'];
    $pet_breed = $data['pet_breed'];

    $sql = "INSERT INTO pets (user_id, pet_name, pet_type, pet_breed) 
            VALUES ('$user_id', '$pet_name', '$pet_type', '$pet_breed')";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "เพิ่มสัตว์เลี้ยงสำเร็จ"]);
    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }
}
$conn->close();
?>