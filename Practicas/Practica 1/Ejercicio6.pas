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
procedure leerCelular(var c:celular);
begin
	writeln('Escribe el nombre del celular');
	readln(c.nombre); 
	if(c.nombre <> 'fin')then begin
		writeln('Escribe la descripcion del celular');
		readln(c.descripcion);
		writeln('Escribe la marca del celular');
		readln(c.marca);
		writeln('Escribe el codigo del celular');
		readln(c.codigo); 
		writeln('Escribe el precio del celular');
		readln(c.precio);
		writeln('Escribe el stock actual del celular');
		readln(c.sdis);
		writeln('Escribe el stock minimo del celular');
		readln(c.smin);
	end;
end;

procedure agregarCelulares(var arc_logico:archivo);
var
	c:celular;
begin
	reset(arc_logico);
	writeln('Ingresa un celular, escribe "fin" para terminar');
	readln(c.nombre);
	leerCelular(c);
	while(c.nombre<>'fin')do begin
		seek(arc_logico,filesize(arc_logico));
		write(arc_logico,c);
		leerCelular(c);
	end;
	close(arc_logico);
end;

procedure modificarStock(var arc_logico:archivo);
var 
	c:celular; nombre:String[15]; ok:boolean;
begin
	ok:=false;
	writeln('Escribe el nombre del celular a modificar');
	readln(nombre); readln(nombre);
	reset(arc_logico);
	while(not eof(arc_logico) and not ok)do begin
		read(arc_logico,c);
		if(c.nombre = nombre)then begin
			ok:=true;
			writeln('Escribe el nuevo stock del celular');
			readln(c.sdis);
			seek(arc_logico,filepos(arc_logico)-1);
			write(arc_logico,c);
			end;
	end;
	close(arc_logico); 
end;
procedure exportarATextoSinStock(var arc_logico:archivo);
var 
	arc_texto: Text; c:celular;
begin
	reset(arc_logico);
	assign(arc_texto,'SinStock.txt');
	rewrite(arc_texto);
	writeln('Exportando a archivo');
	while(not eof(arc_logico))do begin
		read(arc_logico,c);
		if(c.sdis = 0)then begin
			imprimirCelular(c);
			writeln(arc_texto,c.codigo,' ',c.precio:1:2,' ',c.marca);
			writeln(arc_texto,c.sdis,' ',c.smin,' ',c.descripcion);
			writeln(arc_texto,c.nombre);
			writeln('1 Celular cargado..')
			end;
	end;
	writeln('Archivo cargado completamente');
	close(arc_logico); close(arc_texto);
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
	writeln('Opcion 5: Agregar uno o mas celulares');
	writeln('Opcion 6: Modificar el stock de un celular');
	writeln('Opcion 7: Exportar a un archivo de texto los celulares sin stock');
	writeln('Opcion 8: Finalizar el programa');
	read(opcion);
	while( opcion<>8 ) do begin
		case opcion of
			1:cargarArchivo(arc_logico);
			2:stockMenor(arc_logico);
			3:celularesConDescripcion(arc_logico);
			4:exportarATexto(arc_logico);
			5:agregarCelulares(arc_logico);
			6:modificarStock(arc_logico);
			7:exportarATextoSinStock(arc_logico);
		else
			writeln('Ingrese una opcion correcta!');
		end;
		writeln('Bienvenido al menu de la tienda de celulares!');
		writeln('Opcion 1: Crear un archivo con la informacion guardada en "celulares.txt"');
		writeln('Opcion 2: Listar todos los celulares con stock menor al minimo');
		writeln('Opcion 3: Buscar celulares por su descripcion');
		writeln('Opcion 4: Exportar los celulares a un nuevo archivo de texto');
		writeln('Opcion 5: Agregar uno o mas celulares');
		writeln('Opcion 6: Modificar el stock de un celular');
		writeln('Opcion 7: Exportar a un archivo de texto los celulares sin stock');
		writeln('Opcion 8: Finalizar el programa');		
		read(opcion);
	end;
end.

