<?php 
	include "connect.php";
	header('Content-Type: application/json');

	$json = file_get_contents('php://input');
	$data = json_decode($json,true);
	$id = $data['id'];
	$status = $data['status'];;
    $sql = "UPDATE danhba SET status=? WHERE id=?";
    $stmt = $conn -> prepare($sql);
    $stmt->bind_param("ii",$status,$id);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }

    $conn->close();
 ?>