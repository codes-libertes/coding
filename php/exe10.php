<?php
include_once("db_query.php");
include_once("db_read_id.php");
include_once("connexionbdd.php");
include_once("AfficherListe_id.php");
?>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hello html page</title>
</head>
<body>

	
<FORM METHOD="post" ACTION="exe10_traitement.php" ENCTYPE="x-www-form-urlencoded"> 
<TABLE border= "1">
<tr>
<td>
<?php 
	$nom_album="alb_art4";
	$nom_editeur="Dieu";
	
	$str_query = sprintf("INSERT INTO album (id_album,nom_genre,nom_editeur,annee_album) VALUES (NULL,'%s','%s',now())",$nom_album,$nom_editeur);
	$res = db_query($bdd,$str_query);
	
	$str_query_check_id="SELECT * FROM artiste_album WHERE artiste_album.id_album=(SELECT album.id_album FROM album ORDER BY album.id_album DESC LIMIT 1)";
	$res = db_query($bdd,$str_query_check_id);
	
	if($res){
		$str_query_ajouter_album="INSERT INTO artiste_album(id_artiste, id_album, nb_morceau_art) 
								  VALUES (2,(SELECT album.id_album FROM album ORDER BY album.id_album DESC LIMIT 1),3)";
		$res = db_query($bdd,$str_query_ajouter_album);
	}
	
	
?>
</td>
</tr>
</TABLE>
</FORM>
</body>
</html>
