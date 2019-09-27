
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
<td> Afficher tous les elements de album</td>
</tr>
<?php 
	$str_query = "SELECT * FROM album";
	$res= db_query($bdd,$str_query);

	while($row = $res->fetch()) {
?>
		<br><tr><td><?php echo "titre_album" . $row['titre_album']; ?></td></tr>
<?php 
		$resaa = db_read_id($bdd,"artiste_album", "nb_morceau_art",$row["id_album"]);
		while($rowaa = $resaa->fetch()){
?>
			<br><tr><td><?php echo "id_artiste". $rowaa['id_artiste']; ?>  </td></tr>
			<br><tr><td><?php echo "nombre de morceau" . $rowaa['ret_nb_morceau_art']; ?> </td></tr>
<?php 
		}	
?>
		<?php
	}
?>
</tr>
</talbe>
</body>
</html>