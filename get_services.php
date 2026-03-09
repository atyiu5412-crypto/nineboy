<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pet_hotel_db";

$conn = new mysqli($servername, $username, $password, $dbname);

$sql = "SELECT * FROM services";
$result = $conn->query($sql);

$services = [];
while($row = $result->fetch_assoc()) {
    $services[] = $row;
}

echo json_encode($services);
$conn->close();
?>