<?php
include_once("db_query.php");
include_once("db_read_id.php");
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
	$ret = db_read_id($bdd,'artiste','nom_artiste',1);
?>
	<p><?php echo $ret?> </p>
	

</body>
</html>