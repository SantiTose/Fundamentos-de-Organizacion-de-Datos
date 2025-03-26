program Ejercicio2;
const
	val = 1500;
type
	archivo = file of integer;
var
	arc: archivo;
	nombre: string[12];
	num,cant,men,sum:integer;
	prom:real;
begin
	write('Ingrese el nombre del archivo: ');
	read(nombre);
	assign(arc,nombre);
	Reset(arc);
	cant:=0; sum:=0; men:=0;
	while(not eof(arc))do begin
		Read(arc,num);
		if(num<val)then
			men:=men+1;
		cant:=cant+1;
		sum:=sum + num;
		writeln(num);
	end;
	prom:=sum/cant;
	writeln(men);
	writeln(prom);
end.
	
