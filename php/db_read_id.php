<?PHP
function db_read_id($bdd,$p_table,$p_champ,$p_id) {
	try{
		$str_query = sprintf("SELECT * FROM %s WHERE id_album=%d",$p_table,$p_id);
		$res = db_query($bdd,$str_query);
		return $res;
	}
	catch(Exception $e){
		echo $str_query;
		echo $e->getMesssage();
	}
}

?>
