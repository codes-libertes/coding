<?php
function AfficherTableau($res,$tab_champ) {
	echo '<table border="1" cellspacing="0" cellpadding="3">';
	
	while($row=$res->fetch())  {
		echo "<tr>";
		echo "<td>" . $row[$tab_champ] . "</td>";
		echo "</tr>";
	}
	
	echo "</table>";

}
?>
