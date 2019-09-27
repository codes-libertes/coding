<?php
function db_query($bdd,$str_query) {
	try{
		$res=$bdd->query($str_query);
	}
	catch (Exceptio $e){
		echo $str_query;
		echo $e->getMesssage();
	}
	return $res;
}

?>
