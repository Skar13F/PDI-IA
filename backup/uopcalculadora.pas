unit uOpCalculadora;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Math;

  procedure SumarImagenes(Bitmap1, Bitmap2, BitmapResult: TBitmap);
  procedure SumarImagenes2(Bitmap1, Bitmap2, BitmapResult: TBitmap);
  procedure RestaImagenes(Bitmap1, Bitmap2, BitmapResult: TBitmap);
  procedure RestaImagenesValorAbsoluto(Bitmap1, Bitmap2, BitmapResult: TBitmap);
  procedure RestaImagenesShift(Bitmap1, Bitmap2, BitmapResult: TBitmap);
  procedure ReflexionHorizontal(BitmapOriginal: TBitmap);
  procedure ReflexionVertical(BitmapOriginal: TBitmap);
  procedure ReflexionDoble(BitmapOriginal: TBitmap);

  function SumaConAcotacion(x, y: Byte): Byte;

implementation

// *** Suma 1
procedure SumarImagenes(Bitmap1, Bitmap2, BitmapResult: TBitmap);
var
  x, y: Integer;
  MinWidth, MinHeight: Integer;
  R1, G1, B1, R2, G2, B2, R, G, B: Byte;
  Color1, Color2: TColor;
begin
  MinWidth := Min(Bitmap1.Width, Bitmap2.Width);
  MinHeight := Min(Bitmap1.Height, Bitmap2.Height);

  BitmapResult.SetSize(MinWidth, MinHeight);
  BitmapResult.PixelFormat := pf24bit;

  for y := 0 to MinHeight - 1 do
  begin
    for x := 0 to MinWidth - 1 do
    begin
      // Obtener los colores de los píxeles correspondientes
      Color1 := Bitmap1.Canvas.Pixels[x, y];
      Color2 := Bitmap2.Canvas.Pixels[x, y];

      // Extraer componentes RGB de ambas imágenes
      R1 := Red(Color1);
      G1 := Green(Color1);
      B1 := Blue(Color1);

      R2 := Red(Color2);
      G2 := Green(Color2);
      B2 := Blue(Color2);

      // Realizar la suma normalizada
      R := (R1 + R2) div 2;
      G := (G1 + G2) div 2;
      B := (B1 + B2) div 2;

      // Asignar el nuevo color al píxel del BitmapResult
      BitmapResult.Canvas.Pixels[x, y] := RGBToColor(R, G, B);
    end;
  end;
end;

// *** Suma 2
procedure SumarImagenes2(Bitmap1, Bitmap2, BitmapResult: TBitmap);
var
  x, y: Integer;
  MinWidth, MinHeight: Integer;
  R1, G1, B1, R2, G2, B2, R, G, B: Byte;
  Color1, Color2: TColor;
begin
  MinWidth := Min(Bitmap1.Width, Bitmap2.Width);
  MinHeight := Min(Bitmap1.Height, Bitmap2.Height);

  // Configurar el Bitmap de resultado
  BitmapResult.SetSize(MinWidth, MinHeight);
  BitmapResult.PixelFormat := pf24bit;

  for y := 0 to MinHeight - 1 do
  begin
    for x := 0 to MinWidth - 1 do
    begin
      Color1 := Bitmap1.Canvas.Pixels[x, y];
      Color2 := Bitmap2.Canvas.Pixels[x, y];

      // Extraer componentes RGB de ambas imágenes
      R1 := Red(Color1);
      G1 := Green(Color1);
      B1 := Blue(Color1);

      R2 := Red(Color2);
      G2 := Green(Color2);
      B2 := Blue(Color2);

      // Usar la función de suma con acotación para cada componente RGB
      R := SumaConAcotacion(R1, R2);
      G := SumaConAcotacion(G1, G2);
      B := SumaConAcotacion(B1, B2);

      // Asignar el nuevo color al píxel del BitmapResult
      BitmapResult.Canvas.Pixels[x, y] := RGBToColor(R, G, B);
    end;
  end;
end;
function SumaConAcotacion(x, y: Byte): Byte;
begin
  if (x + y) < 256 then
    Result := x + y
  else
    Result := 255;
end;


// *** Resta 1
procedure RestaImagenes(Bitmap1, Bitmap2, BitmapResult: TBitmap);
var
  x, y: Integer;
  MinWidth, MinHeight: Integer;
  Color1, Color2: TColor;
  R1, G1, B1, R2, G2, B2: Byte;
  NewR, NewG, NewB: Byte;
begin
  MinWidth := Min(Bitmap1.Width, Bitmap2.Width);
  MinHeight := Min(Bitmap1.Height, Bitmap2.Height);

  BitmapResult.SetSize(MinWidth, MinHeight);
  BitmapResult.PixelFormat := pf24bit;

  for y := 0 to MinHeight - 1 do
  begin
    for x := 0 to MinWidth - 1 do
    begin
      Color1 := Bitmap1.Canvas.Pixels[x, y];
      Color2 := Bitmap2.Canvas.Pixels[x, y];

      // Extraer componentes RGB de ambas imágenes
      R1 := Red(Color1);
      G1 := Green(Color1);
      B1 := Blue(Color1);

      R2 := Red(Color2);
      G2 := Green(Color2);
      B2 := Blue(Color2);

      if R1 >= R2 then NewR := R1 - R2 else NewR := 0;
      if G1 >= G2 then NewG := G1 - G2 else NewG := 0;
      if B1 >= B2 then NewB := B1 - B2 else NewB := 0;

      BitmapResult.Canvas.Pixels[x, y] := RGBToColor(NewR, NewG, NewB);
    end;
  end;
end;

// *** Resta 2
procedure RestaImagenesValorAbsoluto(Bitmap1, Bitmap2, BitmapResult: TBitmap);
var
  x, y: Integer;
  MinWidth, MinHeight: Integer;
  R1, G1, B1, R2, G2, B2, R, G, B: Byte;
  Color1, Color2: TColor;
begin
  MinWidth := Min(Bitmap1.Width, Bitmap2.Width);
  MinHeight := Min(Bitmap1.Height, Bitmap2.Height);

  BitmapResult.SetSize(MinWidth, MinHeight);
  BitmapResult.PixelFormat := pf24bit;

  // Procesar cada píxel dentro del área común
  for y := 0 to MinHeight - 1 do
  begin
    for x := 0 to MinWidth - 1 do
    begin
      // Obtener los colores de los píxeles correspondientes
      Color1 := Bitmap1.Canvas.Pixels[x, y];
      Color2 := Bitmap2.Canvas.Pixels[x, y];

      // Extraer componentes RGB de ambas imágenes
      R1 := Red(Color1);
      G1 := Green(Color1);
      B1 := Blue(Color1);

      R2 := Red(Color2);
      G2 := Green(Color2);
      B2 := Blue(Color2);

      // Calcular la resta con valor absoluto
      R := Abs(R1 - R2);
      G := Abs(G1 - G2);
      B := Abs(B1 - B2);

      // Asignar el nuevo color al píxel del BitmapResult
      BitmapResult.Canvas.Pixels[x, y] := RGBToColor(R, G, B);
    end;
  end;
end;

// *** Resta 3
procedure RestaImagenesShift(Bitmap1, Bitmap2, BitmapResult: TBitmap);
var
  x, y: Integer;
  MinWidth, MinHeight: Integer;
  R1, G1, B1, R2, G2, B2: Byte;
  R, G, B: Integer;
  Color1, Color2: TColor;
begin
  MinWidth := Min(Bitmap1.Width, Bitmap2.Width);
  MinHeight := Min(Bitmap1.Height, Bitmap2.Height);

  BitmapResult.SetSize(MinWidth, MinHeight);
  BitmapResult.PixelFormat := pf24bit;

  for y := 0 to MinHeight - 1 do
  begin
    for x := 0 to MinWidth - 1 do
    begin
      // Obtener los colores de los píxeles correspondientes
      Color1 := Bitmap1.Canvas.Pixels[x, y];
      Color2 := Bitmap2.Canvas.Pixels[x, y];

      // Extraer componentes RGB de ambas imágenes
      R1 := Red(Color1);
      G1 := Green(Color1);
      B1 := Blue(Color1);

      R2 := Red(Color2);
      G2 := Green(Color2);
      B2 := Blue(Color2);

      // Calcular la resta con norma shift
      R := (255 div 2) + ((R1 - R2) div 2);
      G := (255 div 2) + ((G1 - G2) div 2);
      B := (255 div 2) + ((B1 - B2) div 2);

      // Limitar valores al rango [0, 255]
      R := Max(0, Min(255, R));
      G := Max(0, Min(255, G));
      B := Max(0, Min(255, B));

      BitmapResult.Canvas.Pixels[x, y] := RGBToColor(R, G, B);
    end;
  end;
end;

// *** Reflexión horizontal
procedure ReflexionHorizontal(BitmapOriginal: TBitmap);
var
  x, y: Integer;
  BitmapTemp: TBitmap;
begin
  BitmapTemp := TBitmap.Create;
  try
    // Asignar el tamaño y formato de la imagen original al temporal
    BitmapTemp.SetSize(BitmapOriginal.Width, BitmapOriginal.Height);
    BitmapTemp.PixelFormat := BitmapOriginal.PixelFormat;

    // Procesar la reflexión horizontal
    for y := 0 to BitmapOriginal.Height - 1 do
    begin
      for x := 0 to BitmapOriginal.Width - 1 do
      begin
        BitmapTemp.Canvas.Pixels[x, y] :=
          BitmapOriginal.Canvas.Pixels[BitmapOriginal.Width - 1 - x, y];
      end;
    end;
    BitmapOriginal.Assign(BitmapTemp);
  finally
    BitmapTemp.Free;
  end;
end;

// *** Reflexión vertical
procedure ReflexionVertical(BitmapOriginal: TBitmap);
var
  x, y: Integer;
  BitmapTemp: TBitmap;
begin
  // Crear un bitmap temporal para realizar la operación
  BitmapTemp := TBitmap.Create;
  try
    // Asignar el tamaño y formato de la imagen original al temporal
    BitmapTemp.SetSize(BitmapOriginal.Width, BitmapOriginal.Height);
    BitmapTemp.PixelFormat := BitmapOriginal.PixelFormat;

    // Procesar la reflexión vertical
    for y := 0 to BitmapOriginal.Height - 1 do
    begin
      for x := 0 to BitmapOriginal.Width - 1 do
      begin
        // Copiar los píxeles reflejados verticalmente al bitmap temporal
        BitmapTemp.Canvas.Pixels[x, y] :=
          BitmapOriginal.Canvas.Pixels[x, BitmapOriginal.Height - 1 - y];
      end;
    end;

    // Reasignar el bitmap temporal al original
    BitmapOriginal.Assign(BitmapTemp);
  finally
    // Liberar el bitmap temporal
    BitmapTemp.Free;
  end;
end;

// *** Reflexión doble
procedure ReflexionDoble(BitmapOriginal: TBitmap);
var
  BitmapTemp: TBitmap;
begin
  BitmapTemp.Assign(ReflexionHorizontal(BitmapOriginal));


end;

end.

