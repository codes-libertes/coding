<?php
	$bdd = null;
	try {
		$bdd = new PDO('mysql:host=localhost;dbname=elec;charset=utf8', 'elec', 'elec', array(PDO::ATTR_ERRMODE=> PDO::ERRMODE_EXCEPTION));
	}
	catch (Exception $e) {
		die('Erreur : ' . $e->getMessage());
	}
?>