unit uRegionales;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Math, uVarios;

  procedure FRMediaA(var M1: Mat3D;  var M2 : Mat3D; mc, nr : Integer; mconv :  M3x3; peso  : real);
  procedure Llena_MC(var M:M3x3;var f:real);

const
  Matmed:M3x3=((1,1,1),
              (1,1,1),
              (1,1,1));

Matgaus:M3x3=((1,2,1),
              (2,4,2),
             (1,2,1));



implementation

//Aplica filtro  media a la imagen
procedure FRMediaA(var M1: Mat3D;  var M2 : Mat3D; mc, nr : Integer; mconv :  M3x3; peso  : real);
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

end.

