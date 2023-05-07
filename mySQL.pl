

use Net::MySQL;

# ouverture session : récupération session PHP ouverte via le script qui a appelé ce script
my $session = PHP::Session->new($cookie,{ save_path => $repertoire_session,auto_save => 1, });


# liaison BDD MySQL
my $mysql = Net::MySQL->new(
    hostname => $vDBhost,   # Default use UNIX socket
    database => $vDBName,
    user     => $vDBLogin,
    password => $vDBPwd
);

# Pb accent MySQL
my $vSql="SET NAMES \"utf8\";";
$mysql->query(qq{$vSql});


$vSql="SELECT Annee,Service,Etat,count(Etat) as nb
	FROM controles 
	INNER JOIN services ON services.IDServices=controles.IDServices 
	WHERE Annee=\"".$vAnnee."\" 
	GROUP BY Annee,controles.`IDServices`,Etat
	ORDER BY Annee,controles.`IDServices`,Etat";

# exécution de la requête
$mysql->query(qq{$vSql});

# données
my $vRes = $mysql->create_record_iterator;
	
my $vOldS="";
my $vCoul="";
my $vFCoul="";
my $vVal="";
my $vValEtat="";

# n°ordre des champs
my $fAnnee=0;
my $fService=1;
my $fEtat=2;
my $fnb=3;

while (my $vVal = $vRes->each){
	$vValEtat=lc $vVal->[$fEtat]; # lc = lower case
	
	if		($vValEtat eq "n")	{ $vCoul="Lavender"; $vFCoul="Black"; 	}
	elsif 	($vValEtat eq "o")	{ $vCoul="Yellow"; $vFCoul="Black";		}
	elsif 	($vValEtat eq "r")	{ $vCoul="Crimson"; $vFCoul="White"; 	}
	elsif 	($vValEtat eq "v")	{ $vCoul="SpringGreen"; $vFCoul="Black";}
	else 						{ $vCoul="white"; $vFCoul="Black";	 	}

	if ((not defined $vOldS) and ($vOldS ne $vVal->[$fService])){
		print  "<tr style=\"font-size:3pt;\"><td>&nbsp;</td><td></td><td></td><td></td><td></td></tr>";
	}
	print  "<tr style=\"background:${vCoul};Color:${vFCoul};\">";
	print  "	<td>".$vVal->[$fAnnee]."</td>".$vFf;
	print  "	<td>".$vVal->[$fService]."</td>".$vFf;
	print  "	<td>".uc ($vVal->[$fEtat])."</td>".$vFf;
	print  "	<td>".$vVal->[$fnb]."</td>".$vFf;
	print  "</tr>".$vFf;
	$vOldS=$vVal->[$fService];
}
print "</table>
</div>
</center>";

