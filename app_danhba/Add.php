<?php
    header('Content-Type: application/json');
    include "connect.php";

    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    $name = $data['name'];
    $phone = $data['phone'];

    $sql = "INSERT INTO danhba(id, name, phone) VALUES (null,'$name', '$phone')";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }

    $conn->close();
?>
