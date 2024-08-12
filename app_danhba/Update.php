<?php
    header('Content-Type: application/json');
    include "connect.php";

    $json = file_get_contents('php://input');
    $data = json_decode($json, true);
    $id = $data['id'];
    $name = $data['name'];
    $phone = $data['phone'];

    $sql = "UPDATE danhba SET name=?, phone=? WHERE id=?";
    $stmt = $conn -> prepare($sql);
    $stmt->bind_param("ssi",$name,$phone,$id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }

    $conn->close();
?>