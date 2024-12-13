unit uVarios;
{$mode objfpc}{$H+}

interface

uses
  Classes, Graphics, SysUtils, IntfGraphics;

const
  tam_max = 1;

type
   Mat3D = array of array of array of byte;
   ArrInt = array [0..3, 0..255] of LongWord;
   ArrLam = array [0..255] of byte;

   //uRegionales
   Mattxd = array[-tam_max .. tam_max, -tam_max .. tam_max] of real;
   M3x3 = array [-1 .. 1] of array [-1 .. 1] of single;
   V9 = array [0 .. 8] of Byte;


   procedure BM_MAT (var B : TBitMap; var M : Mat3D);
   procedure MAT_BM(var M : Mat3D; var B : TBitMap; nc,nr : integer);
   procedure NormalizeRect(var R: TRect);

   function OrdV9(a: V9): Byte;

Var
   BA : TBitMap;
   bCon : Integer = 0;

implementation

//Pasa la imagen a un matriz
procedure BM_MAT (var B : TBitMap; var M : Mat3D);
var
  p : PByteArray;  //Puntero a un arreglo de tipo byte
  i,j, k, Nancho, Nalto : integer;
  t : TLazIntfImage;  //Representa una imagen
begin
  Nancho := B.Width; //Se obtiene el ancho de la imagen
  Nalto := B.Height; //Se obtiene el alto de la imagen
  //Coloca la longitud a un array dinámico
  SetLength(M,Nancho,Nalto,3);
  t := B.CreateIntfImage;

  for j := 0 to Nalto - 1 do
  begin
    p := t.GetDataLineStart(j);  //provee un acceso indexado a cada linea de pixeles
    for i := 0 to Nancho - 1 do
    begin
      k := 4 * i;

      M[i,j,0] := p^[k]; //R
      M[i,j,1] := p^[k + 1]; //G
      M[i,j,2] := p^[k + 2]; //B
    end;
  end;
  t.Free;
end;

//El contenido de la matriz se pasa al bitmap
procedure MAT_BM(var M : Mat3D; var B : TBitMap; nc,nr : integer);
var
  p : PByteArray;  //Puntero a un arreglo de tipo byte
  i,j, k : integer;
  t : TLazIntfImage;  //Representa una imagen
begin
  B.Width := nc;
  B.Height:= nr;
  t := B.CreateIntfImage;

  for j := 0 to nr - 1 do
  begin
    p := t.GetDataLineStart(j); //provee un acceso indexado a cada linea de pixeles
    for i := 0 to nc - 1 do
    begin
      k := 4 * i;
      p^[k    ] := M[i,j,0];  //R
      p^[k + 1] := M[i,j,1]; //G
      p^[k + 2] := M[i,j,2]; //B
    end;
  end;
  B.Assign(t);
  t.Free;
end;

procedure NormalizeRect(var R: TRect);
var
  Temp: Integer;
begin
  if R.Left > R.Right then
  begin
    Temp := R.Left;
    R.Left := R.Right;
    R.Right := Temp;
  end;

  if R.Top > R.Bottom then
  begin
    Temp := R.Top;
    R.Top := R.Bottom;
    R.Bottom := Temp;
  end;
end;

//Ordena vector (9 elementos) por burbuja
function OrdV9(a:V9):byte; //para media
var
  temp:byte;
  i,j:integer;
begin
  for i:=1 to 8 do
    for j:=0 to 7 do
     if (a[j]>a[j+1])then
     begin
       temp:=a[j];
       a[j]:=a[j+1];
       a[j+1]:=temp ;
     end;
  OrdV9:=a[4];
end;

end.


