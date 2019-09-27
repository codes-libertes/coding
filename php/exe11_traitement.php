<?php

include_once("db_query.php");
include_once("connexionbdd.php");
include_once("db_read_id.php");

$titre_album="";
$nom_genre="";
$nom_editeur="";
$annee_album="";

if (isset($_POST["titre_album"])){
	$titre_album=$_POST["titre_album"];
	echo "La valeur : " . $titre_album . "<br/>";
}

if (isset($_POST["nom_genre"])){
	$nom_genre=$_POST["nom_genre"];
	echo "La valeur : " . $nom_genre. "<br/>";
}

if (isset($_POST["nom_editeur"])){
	$nom_editeur=$_POST["nom_editeur"];
	echo "La valeur : " . $nom_editeur. "<br/>";
}

if (isset($_POST["annee_album"])){
	$annee_album=date('Y-m-d', strtotime($_POST["annee_album"]));
	echo "La valeur : " . $annee_album. "<br/>";
}

$nom_artiste="";
$prenom_artiste="";
if (isset($_POST["nom_artiste"])){
	$nom_artiste=$_POST["nom_artiste"];
	echo "La valeur : " . $nom_artiste. "<br/>";
}

if (isset($_POST["prenom_artiste"])){
	$prenom_artiste=$_POST["prenom_artiste"];
	echo "La valeur : " . $prenom_artiste. "<br/>";
}

$piste_morceau="";
$title_morceau="";
$duree_morceau="";
$note_morceau="";
$fichier_morceau="";
$fichier_chemin_access="";
$nom_type_fichier="";

if (isset($_POST["piste_morceau"])){
	$piste_morceau=$_POST["piste_morceau"];
	echo "La valeur : " . $piste_morceau. "<br/>";
}
if (isset($_POST["title_morceau"])){
	$title_morceau=$_POST["title_morceau"];
	echo "La valeur : " . $title_morceau. "<br/>";
}
if (isset($_POST["duree_morceau"])){
	$duree_morceau=$_POST["duree_morceau"];
	echo "La valeur : " . $duree_morceau. "<br/>";
}
if (isset($_POST["note_morceau"])){
	$note_morceau=$_POST["note_morceau"];
	echo "La valeur : " . $note_morceau. "<br/>";
}
if (isset($_POST["fichier_morceau"])){
	$fichier_morceau=$_POST["fichier_morceau"];
	echo "La valeur : " . $fichier_morceau. "<br/>";
}
if (isset($_POST["fichier_chemin_access"])){
	$fichier_chemin_access=$_POST["fichier_chemin_access"];
	echo "La valeur : " . $fichier_chemin_access. "<br/>";
}
if (isset($_POST["nom_type_fichier"])){
	$nom_type_fichier=$_POST["nom_type_fichier"];
	echo "La valeur : " . $nom_type_fichier. "<br/>";
}

$str_query = sprintf("INSERT INTO album (id_album,nom_genre,nom_editeur,annee_album) VALUES (NULL,'%s','%s','%s')",$nom_album,$nom_editeur,$annee_album);
$res = db_query($bdd,$str_query);

$str_query_artiste = sprintf("INSERT INTO artiste (id_artiste,nom_artiste,prenom_artiste) VALUES (NULL,'%s','%s')",$nom_artiste,$prenom_artiste);
$res = db_query($bdd,$str_query_artiste);


$str_query_morceaux = sprintf("INSERT INTO morceaux (id_morceaux,piste_morceau,titre_morceau,
							   duree_morceau,note_morceau,id_album,fichier_morceau,fichier_chimen_acces,id_fichier) 
							   VALUES (NULL,'%s','%s','%s','%s',(SELECT album.id_album FROM album ORDER BY album.id_album DESC LIMIT 1),
							   '%s','%s',(SELECT fichier_type.id_fichier FROM fichier_type WHERE fichier_type.nom_type_fichier='%s'))",
							   $piste_morceau,$title_morceau,$duree_morceau,$note_morceau,$fichier_morceau,$fichier_chemin_access,$nom_type_fichier);

$res = db_query($bdd,$str_query_morceaux);


$str_query_check_id="SELECT * FROM artiste_album WHERE artiste_album.id_album=(SELECT album.id_album FROM album ORDER BY album.id_album DESC LIMIT 1)";
$res = db_query($bdd,$str_query_check_id);

if($res){
	$str_query_ajouter_album_artiste="INSERT INTO artiste_album(id_artiste, id_album, nb_morceau_art)
								  VALUES (2,(SELECT album.id_album FROM album ORDER BY album.id_album DESC LIMIT 1),3)";
	$res = db_query($bdd,$str_query_ajouter_album_artiste);
	
	
}

?>
