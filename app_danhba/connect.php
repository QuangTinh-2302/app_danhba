<?php 
	$servername = "localhost";
	$username = "root";
	$password = "";
	$dbname = "app_danh_ba_flutter";
	$conn = mysqli_connect($servername,$username,$password,$dbname);
	if(!$conn){
		die("Connection failed: " . $conn->connect_error);
	}
	mysqli_set_charset($conn, "utf8");
?>