<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hello html page</title>
</head>
<body>
<FORM METHOD="post" ACTION="exe11_traitement.php" ENCTYPE="x-www-form-urlencoded"> 

	<font size="6" color="black">Album<br></font>
	Titre:<br>
	<input type="text" name="titre_album"><br>
	Genre:<br>
	<input type="text" name="nom_genre"><br>
	editeur:<br>
	<input type="text" name="nom_editeur"><br>
	annee(xxxx-xx-xx):<br>
	<input type="date" name="annee_album" value="<?php echo date('Y-m-d'); ?>"><br>

	<font size="6" color="black">artiste<br></font>
	nom:<br>
	<input type="text" name="nom_artiste"><br>
	prenom:<br>
	<input type="text" name="prenom_artiste"><br>
	
	<font size="6" color="black">Morceaux<br></font>
	piste:<br>
	<input type="text" name="piste_morceau"><br>
	titre:<br>
	<input type="text" name="title_morceau"><br>
	duree:<br>
	<input type="text" name="duree_morceau"><br>
	note:<br>
	<input type="text" name="note_morceau"><br>
	fichier:<br>
	<input type="text" name="fichier_morceau"><br>
	fichier-access:<br>
	<input type="text" name="fichier_chemin_access"><br>
	type:<br>
	<select id="select" name="nom_type_fichier">
		<option value="mp3" selected>mp3</option> 
		<option value="mav" >mav</option>
		<option value="flac">flac</option>
		<option value="aiff">aiff</option>
	</select> <br>
	

	<input type="submit" value="ajouter"><input type="submit" value="supprimer">

</FORM>
</body>
</html>
