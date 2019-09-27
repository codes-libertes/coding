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
<TABLE border= "1">
<tr>
<td>
<?php 
AfficherListe_id($bdd,"album","nom_genre");
?>
</td>
</tr>
<tr>
<td>
<?php 
AfficherListe_id($bdd,"artiste","nom_artiste");
?>
</td>
</tr>
<TR><TD><INPUT name="text_area" type="text" size="20"></TD></TR>
<TR><TH><INPUT type="submit" value=Valider"></TH></TR>
</TABLE>
</FORM>
</body>
</html>
