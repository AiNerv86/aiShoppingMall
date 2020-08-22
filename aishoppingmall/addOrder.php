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
				
		$orderDateTime = $_GET['OrderDateTime'];
		$idUser = $_GET['idUser'];
        $nameUser = $_GET['NameUser'];
        $idShop = $_GET['idShop'];
        $nameShop = $_GET['NameShop'];
        $distance = $_GET['Distance'];
        $transport = $_GET['Transport'];
        $idFood = $_GET['idFood'];
        $nameFood = $_GET['NameFood'];
        $price = $_GET['Price'];
        $amount = $_GET['Amount'];
        $sum = $_GET['Sum'];
        $rider = $_GET['idRider'];
        $status = $_GET['Status'];

        /*$OrderDateTime = $_GET['OrderDateTime'];
        $idShop = $_GET['idShop'];
        $NameShop = $_GET['NameShop'];
        $Distance = $_GET['Distance'];
        $Transport = $_GET['Transport'];
        $idFood = $_GET['idFood'];
        $NameFood = $_GET['NameFood'];
        $Price = $_GET['Price'];
        $Amount = $_GET['Amount'];
        $Sum = $_GET['Sum'];
        $idRider = $_GET['idRider'];
        $Status = $_GET['Status'];*/

		
							
		$sql = "INSERT INTO `order_table`(`id`, `orderDateTime`, `idUser`, `nameUser`,`idShop`, `nameShop`, `distance`, `transport`, `idFood`, `nameFood`, `price`, `amount`, `sum`, `rider`, `status`) VALUES (Null ,'$orderDateTime' ,'$idUser' ,'$nameUser' ,'$idShop' ,'$nameShop' ,'$distance' ,'$transport' ,'$idFood' ,'$nameFood' ,'$price' ,'$amount' ,'$sum' ,'$rider' ,'$status' )";
    
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

