unit uPuntuales;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, uVarios, Math;
const
  Lam = 255;

  procedure FPNegativo(var M1 : Mat3D; var M2 : Mat3D; mc, nr : Integer);
  procedure FPGris(var M1 : Mat3D; var M2 : Mat3D; mc, nr : Integer);
  procedure FPRGBGris(var M1 : Mat3D; var M2 : Mat3D; mc, nr : Integer);
  procedure FPGamma(var M1 : Mat3D; var M2 : Mat3D;  mc, nr : Integer; g : Real);
  procedure AplicaLut(var M1 : Mat3D; var M2 : Mat3D; mc, nr : Integer; T :  ArrLam);

  procedure FPUmbral(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer; sentido: Boolean; p1: Integer);
implementation

var
  Tabla : ArrLam;

//Obtener el negativo de una imagen
procedure FPNegativo(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
var
  i, j, k : Integer;
begin
  SetLength(M2, mc, nr, 3);
  for j := 0 to nr-1 do
    for i := 0 to mc -1 do
      for k := 0 to 2 do
        M2[i][j][k] := NOT M1[i][j][k];

end;

procedure FPGris(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
var
  i, j: Integer;
  gray: Integer;
begin
  SetLength(M2, mc, nr, 3);
  for j := 0 to nr - 1 do
    for i := 0 to mc - 1 do
    begin
      gray := (M1[i][j][0] + M1[i][j][1] + M1[i][j][2]) div 3;

      M2[i][j][0] := gray;
      M2[i][j][1] := gray;
      M2[i][j][2] := gray;
    end;
end;

procedure FPRGBGris(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
var
  i, j: Integer;
  gray: Float;
begin
  SetLength(M2, mc, nr, 3);

  for j := 0 to nr - 1 do
  begin
    for i := 0 to mc - 1 do
    begin
      gray := (M1[i][j][0] * 0.299) + (M1[i][j][1] * 0.587) + (M1[i][j][2] * 0.114);
      M2[i][j][0] := Round(gray);
      M2[i][j][1] := Round(gray);
      M2[i][j][2] := Round(gray);
    end;
  end;
end;


procedure FPGamma(var M1 : Mat3D; var M2 : Mat3D;  mc, nr : Integer; g : Real);
var
  k:  Integer;
begin
  SetLength(M2, mc, nr, 3);
  for k:=1 to Lam do
    Tabla[k] := Round(Lam * Power(k/Lam,g));
  AplicaLut(M1, M2, mc, nr, Tabla);
end;

procedure AplicaLut(var M1 : Mat3D; var M2 : Mat3D; mc, nr : Integer; T :  ArrLam);
var
  i, j, k, z : Integer;
begin
  for j := 0 to nr - 1 do
    for i := 0 to mc -1 do
      for k := 0 to 2 do
      begin
        z := M1[i][j][k];
        M2[i][j][k] :=  Tabla[z];
      end;
end;

procedure FPUmbral(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer; sentido: Boolean; p1: Integer);
var
  i, j: Integer;
begin
  SetLength(M2, mc, nr, 3);

  for j := 0 to nr - 1 do
  begin
    for i := 0 to mc - 1 do
    begin
      if (sentido and (M1[i][j][0] > p1)) or ((not sentido) and (M1[i][j][0] <= p1)) then
        begin
          M2[i][j][0] := 255;
          M2[i][j][1] := 255;
          M2[i][j][2] := 255; // Blanco
        end;
      else
        begin
          M2[i][j][0] := 0;
          M2[i][j][1] := 0;
          M2[i][j][2] := 0;  // Negro
        end;
    end;
  end;
end;


end.

