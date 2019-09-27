<?php

if (isset($_POST["nom_genre"])){
	$id_value=$_POST["nom_genre"];
	echo "La valeur de la selection est : " . $id_value . "<br/>";
}

if (isset($_POST["nom_artiste"])){
	$id_value=$_POST["nom_artiste"];
	echo "La valeur de la selection est : " . $id_value . "<br/>";
}

if (isset($_POST["text_area"])){
	$text=$_POST["text_area"];
	echo "Le text enregistré est : " . $text  . "<br/>";
}

//header('location:exe8.php');
?>
