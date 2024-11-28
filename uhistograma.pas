//Muestra el Histograma de una imagen
unit uHistograma;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls,uVarios,Math;

type

  { TfrmHistograma }

  TfrmHistograma = class(TForm)
    bAplicar: TButton;
    bCerrar: TButton;
    chkRojo: TCheckBox;
    chkVerde: TCheckBox;
    chkAzul: TCheckBox;
    chkGris: TCheckBox;
    GroupBox1: TGroupBox;
    imgHisto: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure bAplicarClick(Sender: TObject);
    procedure bCerrarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PintaHisto();
    procedure UpdateHistogram(Bitmap: TBitmap);
    procedure CalcularPerfilDeIntensidad();
  private
    { private declarations }
  public
    { public declarations }
    Han, Hal, nc, nr : integer;
    BH : TBitMap;
    MH : Mat3D;
    HH : ArrInt;
    ModoPerfilIntensidad: Boolean;
  end;

var
  frmHistograma: TfrmHistograma;

implementation

{$R *.lfm}

{ TfrmHistograma }

//Sale de la ventana del Histograma
procedure TfrmHistograma.bCerrarClick(Sender: TObject);
begin
  close;
end;

//Aplica los cambios en el Histograma
procedure TfrmHistograma.bAplicarClick(Sender: TObject);
begin
  Han := imgHisto.Width;  //Ancho y alto de la ventana donde
  Hal := imgHisto.Height; //se muestra el histograma de la imagen activa
  imgHisto.Canvas.Brush.Color := clBlack;
  imgHisto.Canvas.Rectangle(0,0,Han,Hal);
  BH := TBitMap.Create;   //Se crea el área para la imagen
  BH.Assign(BA);   //Se coloca la imagen activa en el BitMap
  nc := BH.Width;  //Se obtiene el ancho y alto del BitMap (imagen)
  nr := BH.Height; //para iniciar a trabajar
  BM_MAT(BH,MH);   //Pasa la imagen a un arreglo
    // Dibuja según el modo seleccionado
  if ModoPerfilIntensidad then
    CalcularPerfilDeIntensidad() // Dibuja el Perfil de Intensidad
  else
    PintaHisto(); // Dibuja el Histograma
end;

//Al salir limpia el Image
procedure TfrmHistograma.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  //antes de salir borra la imagen del histograma (pinta)
  imgHisto.Canvas.Pen.Color := clBlack;
  imgHisto.Canvas.Rectangle(0,0,Han,Hal);
  chkGris.Checked := False;
end;

//Se prepara para trabajar en el histograma
procedure TfrmHistograma.FormCreate(Sender: TObject);
begin
  Han := imgHisto.Width;  //Ancho y alto de la ventana donde se
  Hal := imgHisto.Height; //graficara el histograma
  imgHisto.Canvas.Brush.Color := clBlack;
  imgHisto.Canvas.Rectangle(0,0,Han,Hal);  //Dibuja un rectángulo negro
  BH := TBitMap.Create; //Se crea el área de trabajo
  //por default los tres canales estan activos
  chkRojo.Checked := True;   //rojo
  chkVerde.Checked := True;  //verde
  chkAzul.Checked := True;   //azul
  ModoPerfilIntensidad:= False;
end;

//Los cambios que se aprecian cuando se muestra la ventana
procedure TfrmHistograma.FormShow(Sender: TObject);
begin
  BH.Assign(BA);  //El contenido de BA se asigna a BH
  nc := BH.Width; //Número de columnas
  nr := BH.Height;//Número de renglones
  BM_MAT(BH,MH);  //Pasa la imagen a un matriz
  PintaHisto();   //Pinta el histograma
end;

//Pinta el histograma
procedure TfrmHistograma.PintaHisto();
var
  i,j,ind : integer;
  maxi     : array [0..3] of integer;
  fac      : real;
begin
  for i := 0 to 255 do  //limpia la matriz
  begin
     HH[0,i] := 0;
     HH[1,i] := 0;
     HH[2,i] := 0;
     HH[3,i] := 0;
  end;
  //obtiene la cantidad de cada color 0..255
  for i:= 0 to nc-1 do
    for j := 0 to nr-1 do
    begin
      ind := MH[i][j][0]; //Rojo
      inc(HH[0,ind]);
      ind := MH[i][j][1]; //Verde
      inc(HH[1,ind]);
      ind := MH[i][j][2]; //Azul
      inc(HH[2,ind]);
      ind :=  (MH[i][j][0] + MH[i][j][1] + MH[i][j][2]) div 3;
      inc(HH[3,ind]);     //Gris
    end;
  // pinta
  maxi[0] := 0;
  maxi[1] := 0;
  maxi[2] := 0;
  maxi[3] := 0;
  if chkRojo.Checked then
  begin
    imgHisto.Canvas.Pen.Color := clRed;      //Rojo
    for i := 0 to 255 do
      maxi[0] := Max(HH[0,i], maxi[0]);
    fac := Hal / (maxi[0]+1);
    imgHisto.Canvas.MoveTo(0,Hal-round(fac*HH[0,0]));
    for i := 1 to 255 do
      imgHisto.Canvas.LineTo(round(i * Han/255), Hal-round(fac*HH[0,i]));
  end;
  if chkVerde.Checked then
  begin
    imgHisto.Canvas.Pen.Color := clGreen;   //Verde
    for i := 0 to 255 do
      maxi[1] := Max(HH[1,i], maxi[1]);
    fac := Hal / (maxi[1]+1);
    imgHisto.Canvas.MoveTo(0,Hal-round(fac*HH[1,0]));
    for i := 1 to 255 do
      imgHisto.Canvas.LineTo(round(i * Han/255), Hal-round(fac*HH[1,i]));
  end;
  if chkAzul.Checked then
  begin
    imgHisto.Canvas.Pen.Color := clBlue;    //Azul
    for i := 0 to 255 do
      maxi[2] := Max(HH[2,i], maxi[2]);
    fac := Hal / (maxi[2]+1);
    imgHisto.Canvas.MoveTo(0,Hal-round(fac*HH[2,0]));
    for i := 1 to 255 do
      imgHisto.Canvas.LineTo(round(i * Han/255), Hal-round(fac*HH[2,i]));
  end;
  if chkGris.Checked then
  begin
    imgHisto.Canvas.Pen.Color := clWhite;    //Gris
    for i := 0 to 255 do
      maxi[3] := Max(HH[3,i], maxi[3]);
    fac := Hal / (maxi[3]+1);
    imgHisto.Canvas.MoveTo(0,Hal-round(fac*HH[3,0]));
    for i := 1 to 255 do
      imgHisto.Canvas.LineTo(round(i * Han/255), Hal-round(fac*HH[3,i]));
  end;
end;

procedure TfrmHistograma.UpdateHistogram(Bitmap: TBitmap);
begin
  if (Bitmap = nil) or (Bitmap.Empty) then
  begin
    ShowMessage('No se recibió una región válida para el histograma.');
    Exit;
  end;
  ModoPerfilIntensidad:= True;

  // Limpia la ventana del histograma
  imgHisto.Canvas.Brush.Color := clBlack;
  imgHisto.Canvas.FillRect(0, 0, Han, Hal);

  // Asigna la nueva región seleccionada al bitmap del histograma
  BH.Assign(Bitmap);
  nc := BH.Width;  // Actualiza columnas
  nr := BH.Height; // Actualiza filas
  BM_MAT(BH, MH);  // Convierte el Bitmap en matriz para análisis

  // Calcula el perfil de intensidad del color gris
  CalcularPerfilDeIntensidad();
end;


procedure TfrmHistograma.CalcularPerfilDeIntensidad();
var
  i, j: Integer;
  intensidadRojo, intensidadVerde, intensidadAzul, intensidadGris: array of Integer;
  sumaR, sumaG, sumaB, sumaGris, pixeles: Integer;
  escalaRojo, escalaVerde, escalaAzul, escalaGris: Real;
  maxRojo, maxVerde, maxAzul, maxGris: Integer;
begin
  // Inicializa los arreglos para almacenar la intensidad promedio de cada fila
  SetLength(intensidadRojo, nr);
  SetLength(intensidadVerde, nr);
  SetLength(intensidadAzul, nr);
  SetLength(intensidadGris, nr);

  maxRojo := 0;
  maxVerde := 0;
  maxAzul := 0;
  maxGris := 0;

  // Calcula la intensidad promedio por fila para cada canal
  for j := 0 to nr - 1 do
  begin
    sumaR := 0;
    sumaG := 0;
    sumaB := 0;
    sumaGris := 0;
    pixeles := 0;
    for i := 0 to nc - 1 do
    begin
      sumaR := sumaR + MH[i][j][0]; // Rojo
      sumaG := sumaG + MH[i][j][1]; // Verde
      sumaB := sumaB + MH[i][j][2]; // Azul
      Inc(pixeles);
    end;

    if pixeles > 0 then
    begin
      intensidadRojo[j] := sumaR div pixeles;
      intensidadVerde[j] := sumaG div pixeles;
      intensidadAzul[j] := sumaB div pixeles;
      // Calcula la intensidad gris
      intensidadGris[j] := Round(0.3 * intensidadRojo[j] + 0.59 * intensidadVerde[j] + 0.11 * intensidadAzul[j]);
    end
    else
    begin
      intensidadRojo[j] := 0;
      intensidadVerde[j] := 0;
      intensidadAzul[j] := 0;
      intensidadGris[j] := 0;
    end;

    // Encuentra el valor máximo para escalar
    maxRojo := Max(maxRojo, intensidadRojo[j]);
    maxVerde := Max(maxVerde, intensidadVerde[j]);
    maxAzul := Max(maxAzul, intensidadAzul[j]);
    maxGris := Max(maxGris, intensidadGris[j]);
  end;

  // Limpia la ventana de dibujo
  imgHisto.Canvas.Brush.Color := clBlack;
  imgHisto.Canvas.FillRect(0, 0, Han, Hal);

  // Dibuja los perfiles solo si los checkboxes están activados

  // Canal Rojo
  if chkRojo.Checked then
  begin
    if maxRojo > 0 then escalaRojo := Hal / maxRojo else escalaRojo := 1;
    imgHisto.Canvas.Pen.Color := clRed;
    imgHisto.Canvas.MoveTo(0, Hal - Round(intensidadRojo[0] * escalaRojo));
    for j := 1 to nr - 1 do
      imgHisto.Canvas.LineTo(Round(j * Han / nr), Hal - Round(intensidadRojo[j] * escalaRojo));
  end;

  // Canal Verde
  if chkVerde.Checked then
  begin
    if maxVerde > 0 then escalaVerde := Hal / maxVerde else escalaVerde := 1;
    imgHisto.Canvas.Pen.Color := clGreen;
    imgHisto.Canvas.MoveTo(0, Hal - Round(intensidadVerde[0] * escalaVerde));
    for j := 1 to nr - 1 do
      imgHisto.Canvas.LineTo(Round(j * Han / nr), Hal - Round(intensidadVerde[j] * escalaVerde));
  end;

  // Canal Azul
  if chkAzul.Checked then
  begin
    if maxAzul > 0 then escalaAzul := Hal / maxAzul else escalaAzul := 1;
    imgHisto.Canvas.Pen.Color := clBlue;
    imgHisto.Canvas.MoveTo(0, Hal - Round(intensidadAzul[0] * escalaAzul));
    for j := 1 to nr - 1 do
      imgHisto.Canvas.LineTo(Round(j * Han / nr), Hal - Round(intensidadAzul[j] * escalaAzul));
  end;

  // Canal Gris
  if chkGris.Checked then
  begin
    if maxGris > 0 then escalaGris := Hal / maxGris else escalaGris := 1;
    imgHisto.Canvas.Pen.Color := clWhite;
    imgHisto.Canvas.MoveTo(0, Hal - Round(intensidadGris[0] * escalaGris));
    for j := 1 to nr - 1 do
      imgHisto.Canvas.LineTo(Round(j * Han / nr), Hal - Round(intensidadGris[j] * escalaGris));
  end;
end;







end.

