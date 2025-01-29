unit uLaplacianos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, uVarios, Math;

type
  TKernel = array[0..2, 0..2] of Integer;

procedure AplicarFiltroLapl(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer; const kernel: TKernel);
procedure FiltroLapl1(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
procedure FiltroLapl2(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
procedure FiltroLapl3(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
procedure FiltroLaplDiagonal(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);

implementation

procedure CopiarBordes(var M1, M2: Mat3D; mc, nr: Integer);
var
  i, j, c: Integer;
begin
  for i := 0 to mc - 1 do
    for c := 0 to 2 do
    begin
      M2[i, 0, c] := M1[i, 0, c];
      M2[i, nr - 1, c] := M1[i, nr - 1, c];
    end;

  for j := 0 to nr - 1 do
    for c := 0 to 2 do
    begin
      M2[0, j, c] := M1[0, j, c];
      M2[mc - 1, j, c] := M1[mc - 1, j, c];
    end;
end;

procedure AplicarFiltroLapl(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer; const kernel: TKernel);
var
  i, j, c: Integer;
  suma: Integer;
begin
  // Crear matriz resultado
  SetLength(M2, mc, nr, 3);

  // Aplicar el filtro
  for i := 1 to mc - 2 do
    for j := 1 to nr - 2 do
      for c := 0 to 2 do
      begin
        suma := 0;

        // Aplicar kernel
        suma := suma + (M1[i - 1, j - 1, c] * kernel[0, 0]);
        suma := suma + (M1[i - 1, j, c] * kernel[0, 1]);
        suma := suma + (M1[i - 1, j + 1, c] * kernel[0, 2]);

        suma := suma + (M1[i, j - 1, c] * kernel[1, 0]);
        suma := suma + (M1[i, j, c] * kernel[1, 1]);
        suma := suma + (M1[i, j + 1, c] * kernel[1, 2]);

        suma := suma + (M1[i + 1, j - 1, c] * kernel[2, 0]);
        suma := suma + (M1[i + 1, j, c] * kernel[2, 1]);
        suma := suma + (M1[i + 1, j + 1, c] * kernel[2, 2]);

        // Asegurar que el valor esté en el rango [0,255]
        suma := Max(0, Min(255, suma));
        M2[i, j, c] := suma;
      end;

  // Copiar bordes
  CopiarBordes(M1, M2, mc, nr);
end;

procedure FiltroLapl1(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
const
  kernel: TKernel = (
    (-1, 0, -1),
    (0, 4, 0),
    (-1, 0, -1)
  );
begin
  AplicarFiltroLapl(M1, M2, mc, nr, kernel);
end;

procedure FiltroLapl2(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
const
  kernel: TKernel = (
    (-1, -1, -1),
    (-1,  8, -1),
    (-1, -1, -1)
  );
begin
  AplicarFiltroLapl(M1, M2, mc, nr, kernel);
end;

procedure FiltroLapl3(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
const
  kernel: TKernel = (
    (-1, -2, -1),
    (-2,  4, -2),
    (-1, -2, -1)
  );
begin
  AplicarFiltroLapl(M1, M2, mc, nr, kernel);
end;

procedure FiltroLapl4(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
const
  kernel: TKernel = (
    (0, 1, 0),
    (1, -4, 1),
    (0, 1, 0)
  );
begin
  AplicarFiltroLapl(M1, M2, mc, nr, kernel);
end;

procedure FiltroLapl5(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
const
  kernel: TKernel = (
    (1, 0, 1),
    (0, -4, 0),
    (1, 0, 1)
  );
begin
  AplicarFiltroLapl(M1, M2, mc, nr, kernel);
end;

procedure FiltroLapl6(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
const
  kernel: TKernel = (
    (1, 1, 1),
    (1,  -8, 1),
    (1, 1, 1)
  );
begin
  AplicarFiltroLapl(M1, M2, mc, nr, kernel);
end;

procedure FiltroLaplDiagonal(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
const
  kernel: TKernel = (
    (0,  -1,  0),
    (-1,  4, -1),
    (0,  -1,  0)
  );
begin
  AplicarFiltroLapl(M1, M2, mc, nr, kernel);
end;

procedure FiltroLaplHorizontal(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
const
  kernel: TKernel = (
    (0,  -1,  0),
    (0,  2, 0),
    (0,  -1,  0)
  );
begin
  AplicarFiltroLapl(M1, M2, mc, nr, kernel);
end;

procedure FiltroLaplVertical(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
const
  kernel: TKernel = (
    (0,  0,  0),
    (-1,  2, -1),
    (0,  0,  0)
  );
begin
  AplicarFiltroLapl(M1, M2, mc, nr, kernel);
end;

end.

