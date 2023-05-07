
sub JoursOuvres{
	my ($annee,$date_start,$date_stop)=@_; # liste des paramètres de la fonction

	if ($vDebug){
		print "(JoursOuvres) Annee : ${annee}  date_start : ${date_start} date_stop : ${date_stop}  ";
	}
	my @arr_bank_holidays = (); # Tableau des jours feriés	
	
	# calculs pour déterminer la date de Pâques
	my $a=($annee%19);
	my $b=($annee%4);
	my $c=($annee%7);
	
	my $k=round($annee/100);
	my $p=round(8*$k/25);
	my $q=$k/4;

	my $M=(15-$p+$k-$q%30);
	my $N=((4+$k-$q)%7);
	my $d=((19*$a+$M)%30);
	my $e=((2*$b+4*$c+6*$d+$N)%7);

	my $H=22+$d+$e;

	my $strp = DateTime::Format::Strptime->new(
		pattern => '%d-%m-%Y'
	);
	# analyse et création de l'objet date de début
	my $dd=DateTime->new(
		year 	=> $strp->parse_datetime($date_start)->year(),
		month 	=> $strp->parse_datetime($date_start)->month(),
		day		=> $strp->parse_datetime($date_start)->day(),
		hour	=> 0,
		minute	=> 0,
		second	=> 0,
		time_zone=>'Europe/Paris',
	);
	my $dateDebut=$dd->dmy;
	# analyse et création de l'objet date de fin
	my $df=DateTime->new(
		year 	=> $strp->parse_datetime($date_stop)->year(),
		month 	=> $strp->parse_datetime($date_stop)->month(),
		day		=> $strp->parse_datetime($date_stop)->day(),
		hour	=> 0,
		minute	=> 0,
		second	=> 0,
		time_zone=>'Europe/Paris',
	);
	my $dateFin=$df->dmy;
	
	# tableau des jours fériés
	@arr_bank_holidays[0] = $annee.'-01-01'; # Fete du travail
	@arr_bank_holidays[1] = $annee.'-05-01'; # Fete du travail
	@arr_bank_holidays[2] = $annee.'-05-08'; # Victoire 1945
	@arr_bank_holidays[3] = $annee.'-07-14'; # Fete nationale
	@arr_bank_holidays[4] = $annee.'-08-15'; # Assomption
	@arr_bank_holidays[5] = $annee.'-11-01'; # Toussaint
	@arr_bank_holidays[6] = $annee.'-11-11'; # Armistice 1918
	@arr_bank_holidays[7] = $annee.'-12-25'; # Noel

	# Calcul de la date de Pâques
	my ($d0)=DateTime->new(
		year 	=> $vAnnee,
		month 	=> 03,
		day		=> 01,
		hour	=> 00,
		minute	=> 00,
		second	=> 00,
		time_zone=>'Europe/Paris',
	);

	my ($paques)=$d0->clone;
	$paques=$paques->add(days =>$H-1);
	
	#Récupération de paques. Permet ensuite d'obtenir le jour de l'ascension et celui de la pentecote
	my ($tmpJour)=sprintf("%02d",$paques->day());
	my ($tmpMois)=sprintf("%02d",$paques->month());
	@arr_bank_holidays[8] =$annee."-".$tmpMois."-".sprintf("%02d",$tmpJour+1); # Paques

	my ($ascension)=$paques->clone;
	$ascension=$ascension->add(days =>(39)); 
	($tmpJour)=sprintf("%02d",$ascension->day());
	($tmpMois)=sprintf("%02d",$ascension->month());
	@arr_bank_holidays[9] =  $annee."-".$tmpMois."-".$tmpJour; # Ascension

	my ($pentecote)=$paques->clone;
	$pentecote=$pentecote->add(days =>(50));
	($tmpJour)=sprintf("%02d",$pentecote->day());
	($tmpMois)=sprintf("%02d",$pentecote->month());
	@arr_bank_holidays[10] =  $annee."-".$tmpMois."-".$tmpJour; # Pentecote	
	
	my $nb_days_open = 0;
	my ($noJourSem)="";
	
	if ($vDebug) { 	print "d&eacute;but ${dd} ";
					print "d&eacute;butWkD ".$dd->wday ;
					print " &&   fin ${df}   "; 
	}
	
	my $value="";
	$tmp="";
	my $vOk=0;

	#Mettre <= si on souhaite prendre en compte le dernier jour dans le décompte	
	while ($dd <=  $df) {
		#Si le jour suivant n'est ni un dimanche (7) ou un samedi (6), ni un jour férié, on incrémente les jours ouvrés	
		$tmp=$dd->year()."-".sprintf("%02d",$dd->month())."-".sprintf("%02d",$dd->day());
		$vOk=0;
		
		if (($dd->day_of_week != 6 and $dd->day_of_week != 7)){
			for (my $i=0;$i<scalar @arr_bank_holidays;$i ++){
				if ((defined $value) and ($arr_bank_holidays[$i] eq $tmp)){
					$vOk=1;
				}
			}
			if ($vOk==0) { $nb_days_open++; }
		}
		$dd = $dd->add(days =>1);
	}
	
	if ($vDebug) { print "nb_days_open : $nb_days_open<br />"; }
	
	return $nb_days_open;
}

 sub date_cmp {
    state $parser = DateTime::Format::Strptime->new(pattern => '%d-%m-%Y'); # format des dates employées

    my $dt1 = $parser->parse_datetime(shift) or die $parser->errmsg; # paramètre #1
    my $dt2 = $parser->parse_datetime(shift) or return 'invalid';    # paramètre #2

    return 0 if $dt1 eq $dt2;

    return $dt1 > $dt2 ? -1 : 1;
}

sub min{
	my $var1=shift;
	my $var2=shift;
	
    return $var1 if $var1 eq $var2;

    return $var1 < $var2 ? $var1 : $var2

}