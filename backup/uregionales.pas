unit uRegionales;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Math, uVarios, Dialogs;

  procedure FRMediaA_gaussiano(var M1: Mat3D;  var M2 : Mat3D; mc, nr : Integer; mconv :  M3x3; peso  : real);
  procedure Llena_MC(var M:M3x3;var f:real);

  procedure FRMediana(var M1: Mat3D;  var M2 : Mat3D; mc, nr : Integer; tamVentana : Integer);
  procedure Burbuja(var arreglo: array of integer);

  procedure FRMedianaMin(var M1: Mat3D; var M2 : Mat3D; mc, nr : Integer; tamVentana : Integer);
  procedure FRMedianaMax(var M1: Mat3D; var M2 : Mat3D; mc, nr : Integer; tamVentana : Integer);

const
  Matmed:M3x3=((1,1,1),
              (1,1,1),
              (1,1,1));

Matgaus:M3x3=((1,2,1),
              (2,4,2),
             (1,2,1));



implementation

//Aplica filtro  media a la imagen también aplica lo mismo para el gaussiano
procedure FRMediaA_gaussiano(var M1: Mat3D;  var M2 : Mat3D; mc, nr : Integer; mconv :  M3x3; peso  : real);
var
  c, i, j, alf, bet, delta : Integer;
  sum : real;
begin
  delta:=1;
  SetLength(M2, mc, nr, 3);
  for c :=0 to 2 do
    for j:= delta to nr -1 -delta do
      for i:=delta to mc -1 -delta do
        begin
          sum:=0.0;
          for alf:=-delta to delta do
            for bet:=-delta to delta do
              sum+=M1[i+alf][j+bet][c] * mconv[alf][bet];
            M2[i][j][c] := Round(peso*sum);
        end;
end;


procedure Llena_MC(var M:M3x3;var f:real);
var
  i,j:integer;
begin
  if bCon=1 then //datos del kernel media
  begin
    for j:=-1 to 1 do
    for i:=-1 to 1 do
    M[i][j]:=Matmed[i][j]; //copia de la matriz media a M de trabajo
    f:=1/9; // 1/9
  end
  else if bCon =2 then //datos del kernel de gaus
  begin
    for j:=-1 to 1 do
      for i:=-1 to 1 do
        M[i][j]:=Matgaus[i][j]; //copia de la matriz de gaus a M de trabajo
      f:=0.0625; // 1/16
  end;
end;

// Filtro mediana para la imagen
procedure FRMediana(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer; tamVentana: Integer);
var
  c, i, j, x, y, pos: Integer;
  ventana: array of Integer;
begin
  SetLength(M2, mc, nr, 3);
  for c := 0 to 2 do // Para cada canal de color
    for j := tamVentana div 2 to nr - 1 - tamVentana div 2 do
      for i := tamVentana div 2 to mc - 1 - tamVentana div 2 do
      begin
        // Inicializar la ventana
        SetLength(ventana, tamVentana * tamVentana);
        pos := 0;
        for y := -tamVentana div 2 to tamVentana div 2 do
          for x := -tamVentana div 2 to tamVentana div 2 do
          begin
            ventana[pos] := M1[i + x][j + y][c];
            inc(pos);
          end;

        Burbuja(ventana);

        // Obtener la mediana y asignarla
        M2[i][j][c] := ventana[Length(ventana) div 2];
      end;
end;

//Filtro  mediana para la imagen (Mínimo)
procedure FRMedianaMax(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer; tamVentana: Integer);
var
  c, i, j, x, y, pos: Integer;
  ventana: array of Integer;
begin
  SetLength(M2, mc, nr, 3);
  for c := 0 to 2 do // Para cada canal de color
    for j := tamVentana div 2 to nr - 1 - tamVentana div 2 do
      for i := tamVentana div 2 to mc - 1 - tamVentana div 2 do
      begin
        // Inicializar la ventana
        SetLength(ventana, tamVentana * tamVentana);
        pos := 0;
        for y := -tamVentana div 2 to tamVentana div 2 do
          for x := -tamVentana div 2 to tamVentana div 2 do
          begin
            ventana[pos] := M1[i + x][j + y][c];
            inc(pos);
          end;

        Burbuja(ventana);

        // Obtener el valor máximo y asignarlo
        M2[i][j][c] := ventana[Length(ventana) - 1];
      end;
end;


// Filtro mediana para la imagen (Máximo)
procedure FRMedianaMin(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer; tamVentana: Integer);
var
  c, i, j, x, y, pos: Integer;
  ventana: array of Integer;
begin
  SetLength(M2, mc, nr, 3);
  for c := 0 to 2 do // Para cada canal de color
    for j := tamVentana div 2 to nr - 1 - tamVentana div 2 do
      for i := tamVentana div 2 to mc - 1 - tamVentana div 2 do
      begin
        // Inicializar la ventana
        SetLength(ventana, tamVentana * tamVentana);
        pos := 0;
        for y := -tamVentana div 2 to tamVentana div 2 do
          for x := -tamVentana div 2 to tamVentana div 2 do
          begin
            ventana[pos] := M1[i + x][j + y][c];
            inc(pos);
          end;

        Burbuja(ventana);

        // Obtener el valor máximo y asignarlo
        M2[i][j][c] := ventana[-1];
      end;
end;

procedure Burbuja(var arreglo: array of integer);
var
  i, j, temp: integer;
begin
  for i := High(arreglo) downto 1 do
    for j := 1 to i - 1 do
      if arreglo[j] > arreglo[j + 1] then

      begin
        temp := arreglo[j];
        arreglo[j] := arreglo[j + 1];
        arreglo[j + 1] := temp;
      end;
end;


end.

