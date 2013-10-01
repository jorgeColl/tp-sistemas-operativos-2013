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
		print "No existe el archivo de entrada\n";
		return;
	}
	print "¿Desea ingresar un ID de obra o un ID de sala?\nIngrese -o para id de obra, -s para id de sala.\n";
	$entrada = <STDIN>;
	chomp($entrada);
	
	if ( ($entrada ne "-o") and ($entrada ne "-s") ) {
	    print "Opcion incorrecta.. Saliendo.\n";
	    return;
	}
	print "Ingrese un numero para buscar un id, o un rango de ids con el siguiente formato: 'idinicial-idfinal'\n";
	$numid= <STDIN>;
	chomp($numid);
	$indiceguion=index($numid,"-");
	$rango=0;
	if ( $indiceguion ne -1 ) { $rango=1; }
	#Si tengo un rango de valores, rango=-1. Si tengo un sólo valor, rango=0.
	
	if ($rango eq 0) { @valores = ( $numid ); }
	else { 
	  #Valores inicial y final del rango.
	  $valorinicial=substr($numid,0,$indiceguion);
	  $valorfinal=substr($numid,$indiceguion+1);
	  if ( $valorinicial gt $valorfinal ) { 
	      print "Error en el rango introducido...\n"; 
	      return;
	  }
	  while ($valorinicial<=$valorfinal) {
	    push(@valores,$valorinicial);
	    $valorinicial+=1;
	  }
	}
	$encontro=0;
	open(IN, "combos.dis");
	while($linea = <IN>) {
	  chomp($linea);
	  @data= split(";", $linea);
	  
	  #Si no hay suficientes datos, suponer archivo mal formado y saltar esa linea.
	  #TODO: Usar expresiones regulares para verificar que este bien formado.
	  if ($#data ne 6 ) { next; }
	  
	  if ( $entrada eq "-o" ) {
	    $idbus=$data[1];
	  }
	  elsif ( $entrada eq "-s" ) {
	    $idbus=$data[4];
	  }
	 
	  for ($i=0; $i<=$#valores; $i++) {
	      if ($valores[$i] eq $idbus) {
		$encontro=1;
		for ($k=0; $k<5; $k++) { print ( "$data[$k] - "); }
		print ( "$data[5]\n");
	      }
	  }
	  
	}
	close(IN);
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