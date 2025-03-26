program Ejercicio1;
type
    archivo = file of integer;
var
   arc: archivo;
   arc_fisico: string[12];
   nro,nro2: integer;
begin
   write('Ingrese el nombre del archivo');
   read(arc_fisico);
   assign(arc,arc_fisico);
   Rewrite(arc);
   write('Ingrese un numero distinto de 30.000: ');
   read(nro);
   Reset(arc);
   while nro<>30000 do begin
         write(arc,nro);
         write('Ingrese un numero distinto de 30.000: ');
         read(nro);
   end;
   close(arc);
   
end.
