unit uRegionales;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Math, uVarios, Dialogs;

  procedure Llena_MC(var M:M3x3;var f:real);

  procedure FRMediana(var M1: Mat3D;  var M2 : Mat3D; mc, nr : Integer; tamVentana : Integer);
  procedure Burbuja(var arreglo: array of integer);

  procedure FRMedianaMin(var M1: Mat3D; var M2 : Mat3D; mc, nr : Integer; tamVentana : Integer);
  procedure FRMedianaMax(var M1: Mat3D; var M2 : Mat3D; mc, nr : Integer; tamVentana : Integer);

  //bordes
  procedure FReg_X(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
  procedure FReg_Y(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
  procedure FReg_XY(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);

  procedure FBordes(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer; mconv: M3x3; peso: real);

const
  Matmed:M3x3=((1,1,1),
              (1,1,1),
              (1,1,1));

  Matgaus:M3x3=((1,2,1),
              (2,4,2),
             (1,2,1));

  MatSOBx:M3x3=((1,0,-1),
                (2,0,-2),
                (1,0,-1));

  MatSOBy:M3x3=((-1,-2,-1),
                (0,0,0),
                (1,2,1));

  matPrewittX: M3x3 = ((-1, 0, 1),
                       (-1, 0, 1),
                       (-1, 0, 1));

  matPrewittY: M3x3 = ((1, 1, 1),
                       ( 0,  0,  0),
                       (-1, -1, -1));

  matFreix: M3x3 = ((-1, 0, 1),
                    (-sqrt(2), 0, sqrt(2)),
                    (-1, 0, 1));

  matFreiy: M3x3 = ((1, sqrt(2), 1),
                    (0, 0, 0),
                    (-1, -sqrt(2), -1));



implementation

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
  end
  else if bCon=3 then
  begin
    for j:=-1 to 1 do
      for i:=-1 to 1 do
        M[i][j]:=MatSOBx[i][j];
      f:=1;
  end
  else if bCon=4 then
  begin
    for j:=-1 to 1 do
    for i:=-1 to 1 do
      M[i][j]:=MatSOBy[i][j];
    f:=1;
  end
  else if bCon = 5 then // Sobel completo (suma de X e Y)
  begin
    for j := -1 to 1 do
      for i := -1 to 1 do
        M[i][j] := MatSOBx[i][j] + MatSOBy[i][j]; // Suma de matrices Sobel X e Y
      f := 1;
  end
  else if bCon = 6 then // Prewitt Y
    begin
    for j := -1 to 1 do
      for i := -1 to 1 do
        M[i][j] := matPrewittX[i][j];
    f := 1;
  end
  else if bCon = 7 then // Prewitt Y
  begin
    for j := -1 to 1 do
      for i := -1 to 1 do
        M[i][j] := matPrewittY[i][j];
    f := 1;
  end

  else if bCon = 8 then // Frei-Chen X
  begin
    for j := -1 to 1 do
      for i := -1 to 1 do
        M[i][j] := matFreix[i][j];
    f := 1;
  end
  else if bCon = 9 then // Frei-Chen Y
  begin
    for j := -1 to 1 do
      for i := -1 to 1 do
        M[i][j] := matFreiy[i][j];
    f := 1;
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
        M2[i][j][c] := ventana[1];
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

procedure FReg_X(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
var
  x, y, c, z: integer;
begin
  SetLength(M2, mc, nr, 3);
  for y := 0 to nr - 1 do
  begin
    for x := 0 to mc - 2 do
    begin
      for c := 0 to 2 do
      begin
        z := abs(M1[x+1][y][c] - M1[x][y][c]);
        M2[x][y][c] := z;
      end;
    end;
  end;
end;

procedure FReg_Y(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
var
  x, y, c, z: integer;
begin
  SetLength(M2, mc, nr, 3);
  for y := 0 to nr - 2 do
  begin
    for x := 0 to mc - 1 do
    begin
      for c := 0 to 2 do
      begin
        z := abs(M1[x][y+1][c] - M1[x][y][c]);
        M2[x][y][c] := z;
      end;
    end;
  end;
end;

procedure FReg_XY(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer);
var
  x, y, c, z1, z2: integer;
begin
  SetLength(M2, mc, nr, 3);
  for y := 0 to nr - 2 do
  begin
    for x := 0 to mc - 2 do
    begin
      for c := 0 to 2 do
      begin
        z1 := abs(M1[x+1][y][c] - M1[x][y][c]);
        z2 := abs(M1[x][y+1][c] - M1[x][y][c]);
        M2[x][y][c] := Max(z1,z2);
      end;
    end;
  end;
end;

//Sobel
procedure FBordes(var M1: Mat3D; var M2: Mat3D; mc, nr: Integer; mconv: M3x3; peso: real);
var
  c, i, j, alf, bet, delta : integer;
  sum : real;
begin
  delta := 1;
  SetLength(M2, mc, nr, 3);

  for c := 0 to 2 do
    for j := delta to nr -1 - delta do
      for i := delta to mc -1 - delta do
      begin
        sum := 0.0;
        for alf := -delta to delta do
          for bet := -delta to delta do
            sum := sum + M1[i + alf][j + bet][c] * mconv[alf][bet];
        M2[i][j][c]:= round(peso * sum);
      end;
end;

end.

