program Ejercicio2;
const
	valoralto = 9999;
type
	producto = record
		cod:integer;
		nombre: string[20];
		precio:real;
		actual:integer;
		minimo:integer;
		end;
	producto_vendido = record
		cod:integer;
		cantidad:integer;
		end;
	maestro = file of producto;
	detalle = file of producto_vendido;

procedure leer(var det:detalle;var p:producto_vendido);
begin
	if not eof(det) then	
		read(det,p)
	else
		p.cod:=valoralto;
end;	

procedure actualizarMaestro(var mae:maestro; var det:detalle);
var
	regm:producto;
	regd:producto_vendido;
	unidades:integer;
begin
	reset(det); reset(mae);
	leer(det,regd);
	while(regd.cod<>valoralto) do begin
		read(mae,regm);
		unidades :=0;
		while(regd.cod<>valoralto)and(regd.cod = regm.cod)do begin
			unidades:= unidades+regd.cantidad;
			leer(det,regd);
		end;
		regm.actual:=regm.actual-unidades;
		seek(mae,filepos(mae)-1);
		write(mae,regm);
	end;
	close(mae);close(det);
end;

procedure listarMinimos(var mae:maestro);
var
	texto:Text; regm:producto; nombre:string[20];
begin
	reset(mae);
	writeln('Escribi un nombre para el archivo: '); 
	readln(nombre);readln(nombre);
	assign(texto,nombre);
	rewrite(texto);
	while(not eof(mae))do begin
		read(mae,regm);
		if(regm.actual<regm.minimo)then 
			writeln(texto,regm.cod,' ',regm.precio,' ',regm.actual,' ',regm.minimo,' ',regm.nombre);
	end;
	close(texto); close(mae);
end;

procedure leerProd(var p:producto);
begin
	writeln('Escribe el codigo: ');
	readln(p.cod);
	if p.cod<>0 then
	begin
	writeln('Escribe el nombre: ');
	readln(p.nombre);
	writeln('Escribe el precio: ');
	readln(p.precio);
	writeln('Escriba el stock actual: ');
	readln(p.actual);
	writeln('Escriba el stock minimo: ');
	readln(p.minimo);
	end;
end;

procedure cargarMaestro(var mae:maestro);
var p:producto;
begin
	leerProd(p);
	while(p.cod<>0)do begin
		write(mae,p);
		leerProd(p);
	end;
end;

procedure leerProdVend(var p:producto_vendido);
begin
	writeln('Escribe el codigo: ');
	readln(p.cod);
	if(p.cod<>0)then begin
		writeln('Escribe la cantidad: ');
		readln(p.cantidad);
	end;
end;

procedure cargarDetalle(var det:detalle);
var pv:producto_vendido;
begin
	leerProdVend(pv);
	while(pv.cod<>0)do begin
		write(det,pv);
		leerProdVend(pv);
	end;
end;

var
mae:maestro; det:detalle; op:integer;
begin
	assign(det,'Detalle');
	assign(mae,'Maestro');
	writeln('Elegi la opcion: ');
	writeln('Op 1 Actualizar');
	writeln('Op 2 Listar');
	writeln('Op 3 Cerrar' );
	read(op);
	while(op<>3) do begin
		case op of
			1: actualizarMaestro(mae,det);
			2: listarMinimos(mae);
			else
				writeln('Escribe una opcion correcta ');
			end;
			writeln('Elegi la opcion: ');
		writeln('Op 1 Actualizar');
		writeln('Op 2 Listar');
		writeln('Op 3 Cerrar' );
		read(op);
		end;
end.
