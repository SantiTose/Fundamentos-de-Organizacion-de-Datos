program p1ej4;
type
	empleado = record
		numero: integer;
		apellido: string[15];
		nombre: string[15];
		edad: integer;
		dni: integer;
	end;
	
	archivo = file of empleado;

procedure imprimirEmpleado (e: empleado);
begin
	write (' | Numero: ' , e.numero , ' | Apellido: ' , e.apellido , ' | Nombre: ' , e.nombre , ' | Edad: ' , e.edad , ' | DNI: ' , e.dni , ' | ');
	writeln ();
end;

procedure leerEmpleado(var e: empleado);
begin
	writeln (' Ingrese apellido: ');
	readln (e.apellido);
	if (e.apellido <> 'fin') then begin
		writeln (' Ingrese numero de empleado: ');
		readln (e.numero);
		writeln ('Ingrese nombre: ' );
		readln (e.nombre);
		writeln (' Ingrese edad: ');
		readln (e.edad);
		writeln (' Ingrese DNI: ');
		readln (e.dni);
	end;
end;

procedure cargarEmpleados (var arc_logico: archivo);
var
	e: empleado;
begin
	leerEmpleado (e);
	while (e.apellido <> 'fin') do begin
		write (arc_logico,e);
		leerEmpleado (e);
	end;
end;


function cumple (nombre, apellido, dato: string): boolean;
begin
	cumple:= ((nombre = dato) or (apellido = dato));
end;

procedure datosDeterminado (var arc_logico: archivo);
var
	dato: string[15];
	e: empleado;
	
begin
	reset (arc_logico);
	writeln (' Ingrese un apellido: ');
	readln (dato);
	while (not EOF(arc_logico)) do begin
		read (arc_logico, e);
		if (cumple(e.nombre, e.apellido, dato)) then 
			imprimirEmpleado (e);
	end;
	close (arc_logico);
end;

procedure datosEmpleados (var arc_logico: archivo);
var
	e: empleado;
begin
	reset (arc_logico);
	while (not EOF(arc_logico)) do begin
		read (arc_logico, e);
		imprimirEmpleado (e);
	end;
	close (arc_logico);
end;

procedure datosMayores70 (var arc_logico: archivo);
var
	e: empleado;
begin
	reset (arc_logico);
	while (not EOF(arc_logico)) do begin
		read (arc_logico, e);
		if (e.edad >= 70) then 
			imprimirEmpleado (e);
	end;
	close (arc_logico);
end;

//iii

function controlarUnicidad(var arc_logico:archivo; num:integer):boolean;
var e:empleado; ok:boolean;
begin
	ok:=false;
	while(not EOF(arc_logico)and not ok)do begin
		read (arc_logico,e);
		if(e.numero = num)then begin
			writeln('Ingresaste un numero que ya exite en nuestro sistema!!');
			writeln('Empleado no agregado! Escribe nuevamente con valores validos');
			writeln('');
			ok:=true;
		end
	end;
	controlarUnicidad:=ok;
end;

procedure agregarUnEmpleado(var arc_logico:archivo);
var e:empleado;
begin
	reset(arc_logico);
	leerEmpleado(e);
	while(e.apellido <> 'fin') do begin
		if(not controlarUnicidad(arc_logico,e.numero))then begin
			seek(arc_logico,fileSize(arc_logico));
			write(arc_logico,e);
		end;
		leerEmpleado(e);
	end;
	close(arc_logico);
end;

procedure modificarEdad(var arc_logico:archivo);
var 
	e:empleado;
	nom:string;
begin
	reset(arc_logico);
	writeln('Ingrese el nombre de un empleado para modificar su edad: ');
	read(nom);
	while(not eof(arc_logico))do begin
		read(arc_logico,e);
		if(e.nombre =nom)then begin
			writeln('Ingrese la nueva edad del empleado: ');
			read(e.edad);
			seek(arc_logico,filepos(arc_logico)-1);
			write(arc_logico,e);
		end;
	end;
	close(arc_logico);
end;

procedure exportarATexto(var arc_logico:archivo);
var arc_texto: Text; e:empleado;
begin
	writeln('Exportando...');
	assign(arc_texto,'todos_empleados.txt'); // enlazamos la ruta
	reset(arc_logico);
	rewrite(arc_texto); // creamos archivo de texto
	while(not eof(arc_logico))do begin
		read(arc_logico,e);
		writeln(arc_texto,e.numero,' ',e.edad,' ',e.dni,' ',e.apellido);
		writeln(arc_texto,e.nombre);
	end;
	close(arc_logico); close(arc_texto);
	writeln('Archivo exportado correctamente.');
end;

procedure exportarATextoSinDNI(var arc_logico:archivo);
var e:empleado; arc_texto:Text; cant:integer;
begin
	writeln('Esportando archivo con empleados sin dni...');
	assign(arc_texto,'faltaDNIEmpleado.txt');
	cant:=0; // agregado para que se vea lindo no lo agregues
	reset(arc_logico);
	rewrite(arc_texto);
	while(not eof(arc_logico))do begin
		read(arc_logico,e);
		if(e.dni = 00)then begin
			writeln(arc_texto,e.numero,' ',e.edad,' ',e.dni,' ',e.apellido);
			writeln(arc_texto,e.nombre);
			cant:=cant+1;
		end;
	end;
	writeln('Se exportaron un total de: ',cant,' empleados sin dni.');
	close(arc_texto); close(arc_logico);
end;

procedure elegirOpcion (var arc_logico: archivo);
var
	opcion: integer;
begin
	writeln ('Bienvenido al menu' );
	writeln (' Opcion 1: Buscar empleado por apellido');
	writeln (' Opcion 2: Mostrar todos los empleados ' );
	writeln (' Opcion 3: Buscar empleados mayores de 75 años ');
	writeln (' Opcion 4: Agregar un nuevo empleado al archivo');
	writeln (' Opcion 5: Modificar edad de un empleado ');
	writeln (' Opcion 6: Exportar a un archivo de texto ');
	writeln (' Opcion 7: Exportar a un archivo de texto los empleados con dni = 00 ');
	writeln (' Opcion 8: Cerrar el programa ');	
	readln (opcion);
	while (opcion <> 8) do begin
		case opcion of
			1: datosDeterminado (arc_logico);
			2: datosEmpleados (arc_logico);
			3: datosMayores70 (arc_logico);
			4: agregarUnEmpleado (arc_logico);
			5: modificarEdad (arc_logico);
			6: exportarATexto (arc_logico);
			7: exportarATextoSinDNI (arc_logico);
		else
			writeln (' Ingrese una opcion que exista ');
		end;
		
		writeln ('Bienvenido al menu' );
		writeln (' Opcion 1: Buscar empleado por apellido');
		writeln (' Opcion 2: Mostrar todos los empleados ' );
		writeln (' Opcion 3: Buscar empleados mayores de 75 años ');
		writeln (' Opcion 4: Agregar un nuevo empleado al archivo');
		writeln (' Opcion 5: Modificar edad de un empleado ');
		writeln (' Opcion 6: Exportar a un archivo de texto ');
		writeln (' Opcion 7: Exportar a un archivo de texto los empleados con dni = 00 ');
		writeln (' Opcion 8: Cerrar el programa ');
		readln (opcion);
	end;	
end;

var
	arc_logico: archivo;
	arc_fisico: string[15];
begin

	writeln (' Ingrese el nombre de archivo: ');
	readln (arc_fisico);
	assign (arc_logico, arc_fisico);
	rewrite (arc_logico); //creo un archivo nuevo
	cargarEmpleados (arc_logico);
	elegirOpcion (arc_logico);
	
end.
