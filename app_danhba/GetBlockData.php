<?php 
	header("Access-Control-Allow-Origin: *");
	include "connect.php";
	$sql = "SELECT * FROM danhba WHERE status = 0";
	$data = mysqli_query($conn,$sql);
	$jsonarray = array();
	while($rows = mysqli_fetch_assoc($data))
	{
		array_push($jsonarray,new user(
		$rows['id'],
		$rows['name'],
		$rows['phone'],
		$rows['status'],
	));
	}
	echo json_encode($jsonarray,JSON_UNESCAPED_UNICODE);
	class user{
		function __construct($id,$name,$phone,$status){
			$this->id = $id;
			$this->name = $name;
			$this->phone = $phone;
			$this->status = $status;
		}
	}
?>