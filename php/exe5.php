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
<?php 
	$str_query = "SELECT a.nom_genre, ar.nom_artiste, aa.nb_morceau_art
				  FROM album a 
				  INNER JOIN artiste_album aa ON aa.id_album = a.id_album 
				  INNER JOIN artiste ar ON aa.id_artiste=ar.id_artiste";
	
	$res = db_query($bdd,$str_query);

	while($row = $res->fetch()) {
?>
		<td><?php echo $row['nom_genre']?> <?php  echo $row['nom_artiste']?>  <?php echo $row['nb_morceau_art']?></td>;
<?php 
	}
?>
</tr>
</talbe>
</body>
</html>