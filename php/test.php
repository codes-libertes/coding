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
<FORM METHOD="post" ACTION="exe9_traitement.php" ENCTYPE="x-www-form-urlencoded"> 
<font size="6" color="black">Album<br></font>
	Titre:<br>
	<input type="text" name="titre_album"><br>
	
<INPUT name="text_area" type="text" size="20">
<INPUT type="submit" value=Valider">

</FORM>
</body>
</html>

