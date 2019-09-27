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
<talbe>
<tr>
<td>
<?php 
AfficherListe_id($bdd,"album","nom_genre");
?>
</td>

</tr>
</talbe>
</body>
</html>