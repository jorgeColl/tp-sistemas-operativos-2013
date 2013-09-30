#!/usr/bin/perl

use Switch;

#Deberia pasarse al menos un parametro.
if ( $#ARGV <0 ) {
	print "Debe pasar al menos un parametro\n";
}

$val=$ARGV[0];

switch ($val) {
	
	case "-a" { &imprimir_ayuda; }
	case "-d" { &generar_disponibilidades; }
	else { print "Parametros invalidos. -a para visualizar ayuda\n" }
	
}

sub generar_disponibilidades {
	#TODO: Aca deberia buscar en otro directorio.
	if ( ! (-e "combos.dis") ) {
		return;
	}
	print "¿Desea ingresar un ID de obra o un ID de sala?\nIngrese -o para id de obra, -s para id de sala.\n";
	$entrada = <STDIN>;
	chomp($entrada);
	
	if ( ($entrada ne "-o") and ($entrada ne "-s") ) {
	    print "Opcion incorrecta.. Saliendo.\n"
	}
	print "Ingrese un numero para buscar un id, o un rango de ids con el siguiente formato: 'idinicial-idfinal'\n";
	$numid= <STDIN>;
	chomp($numid);
	$indiceguion=index($numid,"-");
	$rango=0;
	if ( $indiceguion ne -1 ) $rango=1;
	if ( $entrada eq "-o" ) {
	    print "Eligio obra\n"
	}
	elsif ( $entrada eq "-s" ) {
	    print "Eligio sala\n"
	}
}

sub imprimir_ayuda {
		print "Ayuda del comando.\n";
		print "Pueden pasarse los siguientes parametros:\n";
		print " -a : Muestra este manual.\n";
		print " -i : Muestra por pantalla un listado de invitados a un evento.\n";
		print " -d : Muestra por pantalla un listado de los espectaculos disponibles.\n";
		print " -r : Muestra por pantalla un ranking de solicitantes.\n";
		print " -t : Muestra por pantalla el listado de tickets a imprimir.\n";
		print " -w : Opcion solamente combinable con -i,-d,-r o -t. Todas esas opciones imprimen datos en pantalla. Si ademas se indica -w, los datos tambien se guardaran en un archivo de texto.\n";
}