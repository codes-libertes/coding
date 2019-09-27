<?php
include_once("db_query.php");
include_once("db_read_id.php");
include_once("connexionbdd.php");
include_once("AfficherTableau.php");
?>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hello html page</title>
</head>
<body>
Afficher tous les elements de album
<?php 
	$str_query = "SELECT * FROM album";
	$res = db_query($bdd,$str_query);
	AfficherTableau($res,"nom_genre");
?>

</body>
</html>
