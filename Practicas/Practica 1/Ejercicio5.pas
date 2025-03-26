program Celulares;
type
	celular = record
		codigo:integer;
		nombre:string;
		descripcion:string;
		marca:string;
		precio:real;
		smin:integer;
		sdis:integer;
		end;
	archivo = file of celular;
	
procedure imprimirCelular(c:celular);
begin
	writeln('| Celular numero: ',c.codigo,' | Nombre: ',c.nombre,' | Marca:',c.marca,' | Descripcion:'
	,c.descripcion,' | Precio:',c.precio:1:2,' | Stock: ',c.sdis, ' | Stock Minimo: ',c.smin);
end;

procedure stockMenor(var arc_logico:archivo);
var c:celular;
begin
	reset(arc_logico);
	while(not eof(arc_logico))do begin
		read(arc_logico,c);
		if(c.sdis<c.smin)then
			imprimirCelular(c);
		end;
	close(arc_logico);
end;

procedure cargarArchivo(var arc_logico:archivo);
var
c:celular; arc_texto:Text;
begin
	rewrite (arc_logico);
	assign (arc_texto,'celulares.txt');
	reset (arc_texto);
	while(not eof(arc_texto))do begin
		readln(arc_texto,c.codigo,c.precio,c.marca);
		readln(arc_texto,c.sdis,c.smin,c.descripcion);
		readln(arc_texto,c.nombre);
		write(arc_logico,c);
	end;
	writeln('Archivo cargado');
	close(arc_logico); close(arc_texto);
end;

procedure celularesConDescripcion(var arc_logico:archivo);
var c:celular; desc:string;
begin
	reset(arc_logico);
	writeln('Escribe una descripcion para buscar!');
	readln(desc); readln(desc);
	while(not eof(arc_logico))do begin
		read(arc_logico,c);
		if(c.descripcion = desc)then begin
			writeln('Se encontro un celular!, mostrando informacion...');
			imprimirCelular(c);
		end;
	end;
	close(arc_logico);
end;

procedure exportarATexto(var arc_logico:archivo);
var c:celular; arc_texto:Text;
begin
	reset(arc_logico);
	assign(arc_texto,'celulares.txt');
	rewrite(arc_texto);
	writeln('Cargando archivo...');
	while(not eof(arc_logico))do begin
		read(arc_logico,c);
		writeln(arc_texto,c.codigo,' ',c.precio,' ',c.marca);
		writeln(arc_texto,c.sdis,' ',c.smin,' ',c.descripcion);
		writeln(arc_texto,c.nombre);
	end;
	writeln('Archivo cargado correctamente!');
	close(arc_logico);close(arc_texto);
end;
var
	arc_logico:archivo; opcion:integer; nom:string;
begin
	writeln ('Ingrese un nombre para el archivo de registros: ');
	readln (nom);
	assign (arc_logico,nom);
	writeln('Bienvenido al menu de la tienda de celulares!');
	writeln('Opcion 1: Crear un archivo con la informacion guardada en "celulares.txt"');
	writeln('Opcion 2: Listar todos los celulares con stock menor al minimo');
	writeln('Opcion 3: Buscar celulares por su descripcion');
	writeln('Opcion 4: Exportar los celulares a un nuevo archivo de texto');
	writeln('Opcion 5: Finalizar el programa');
	read(opcion);
	while( opcion<>5 ) do begin
		case opcion of
			1:cargarArchivo(arc_logico);
			2:stockMenor(arc_logico);
			3:celularesConDescripcion(arc_logico);
			4:exportarATexto(arc_logico);
		else
			writeln('Ingrese una opcion correcta!');
		end;
		writeln('Bienvenido al menu de la tienda de celulares!');
		writeln('Opcion 1: Crear un archivo con la informacion guardada en "celulares.txt"');
		writeln('Opcion 2: Listar todos los celulares con stock menor al minimo');
		writeln('Opcion 3: Buscar celulares por su descripcion');
		writeln('Opcion 4: Exportar los celulares a un nuevo archivo de texto');
		writeln('Opcion 5: Finalizar el programa');
		read(opcion);
	end;
end.
