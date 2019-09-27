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
<talbe>
<tr>
<td> Afficher tous les elements de morceau</td>
<?php 
	if (isset($_GET["album_id"])) {
		$id_album= $_GET["album_id"];
	}
	
	$str_query = sprintf("SELECT * FROM morceaux WHERE id_album=%d",$id_album);
	
	$res = db_query($bdd,$str_query);

	while($row = $res->fetch()) {
?>
		<td><?php echo $row['piste_morceau']?> <?php  echo $row['titre_morceau']?>  <?php echo $row['duree_morceau']?></td>;
<?php 
	}
?>
</tr>
</talbe>
</body>
</html>