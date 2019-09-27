<?php
function AfficherListe_id($bdd,$p_table,$p_champ) {

	 $sQuery=sprintf("SELECT * FROM %s",$p_table);
	 $res=db_query($bdd,$sQuery);

	if ($res) {

		echo "<select name=" . $p_champ . " size=4>";
		
		while ($row=$res->fetch()) {
	      	$output = sprintf("<option value=%s>%s</option>\n",$row["id_album"],$row["$p_champ"]);
	      	echo $output;
		}	
	 	echo "</select>";
	}
}
?>
