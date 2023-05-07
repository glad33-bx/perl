


use CGI;
#use CGI::Carp 'fatalsToBrowser';  # affichage erreurs sur pge web

use utf8;



use PHP::Session;
use PHP::Serializer::PHP;




# création de la page web
print CGI::header(-charset => 'utf-8',);
my $cgi =new CGI;

# récupération du sookie de session
my $cookie = $cgi->cookie( -name => $session_name, );

# Vérifions l'existence de la session et du cookie
if (not defined $cookie){
	print "Erreur session, cookie $session_name.";
	exit(-1);
}

# entête page web
print "	<html>
		<head>";
		
print "	</head>
		<body>";

# ouverture session
my $session = PHP::Session->new($cookie,{ save_path => $repertoire_session,auto_save => 1, });
		
# GET (Ajax)
my $vAnnee= $cgi->param( 'annee' );

print '</table>
</div>
</center>
</body>
</html>';


