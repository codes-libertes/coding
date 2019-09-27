<?php
include_once("db_query.php");
include_once("connexionbdd.php");
?>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hello html page</title>
</head>
<body>
<?php 
	$str_query = "SELECT * FROM artiste ORDER BY nom_artiste";
	$res = db_query($bdd,$str_query);
	
	while($row = $res->fetch()) {
	
		echo $row['nom_artiste'];
		
	
	}
?>

</body>
</html>