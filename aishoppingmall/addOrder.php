<?php
header("content-type:text/javascript;charset=utf-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);
$link = mysqli_connect('localhost', 'root', '', "aishoppingmall");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
				
		$orderDateTime = $_GET['orderDateTime'];
        $idShop = $_GET['idShop'];
        $nameShop = $_GET['nameShop'];
        $distance = $_GET['distance'];
        $transport = $_GET['transport'];
        $idFood = $_GET['idFood'];
        $nameFood = $_GET['nameFood'];
        $price = $_GET['price'];
        $amount = $_GET['amount'];
        $sum = $_GET['sum'];
        $rider = $_GET['rider'];
        $status = $_GET['status'];
		
							
		$sql = "INSERT INTO `order_table`(`id`, `orderDateTime`, `idShop`, `nameShop`, `distance`, `transport`, `idFood`, `nameFood`, `price`, `amount`, `sum`, `rider`, `status`) VALUES (Null ,'$orderDateTime' ,'$idShop' ,'$nameShop' ,'$distance' ,'$transport' ,'$idFood' ,'$nameFood' ,'$price' ,'$amount' ,'$sum' ,'$rider' ,'$status' )";
    
		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master UNG ";
   
}
	mysqli_close($link);
?>

