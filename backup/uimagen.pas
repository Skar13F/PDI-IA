//Programa que muestra el histograma de una imagen
unit uImagen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, uVarios, uHistograma, uPuntuales, uGamma;

type

  { TfrmImagen }

  TfrmImagen = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    mnuHerrHistograma: TMenuItem;
    mnuHerramientas: TMenuItem;
    mnuArchivoSalir: TMenuItem;
    mnuArchivoGuardar: TMenuItem;
    mnuArchivoAbrir: TMenuItem;
    mnuArchivo: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ScrollBox1: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure mnuArchivoAbrirClick(Sender: TObject);
    procedure mnuArchivoGuardarClick(Sender: TObject);
    procedure mnuArchivoSalirClick(Sender: TObject);
    procedure MImagen (B : TBitMap; add : Boolean = true);
    procedure mnuHerrHistogramaClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    BM : TBitMap;
    imagenes : array of TBitMap;// guardar las versiones de la imagen --------------------
    currentImageIndex : Integer;
    imagenesRehacer: array of TBitMap;  // Arreglo para el historial de rehacer

    Iancho, Ialto : integer;
    imagen : TPicture;
    MTR, MRES : Mat3D;
  end;

var
  frmImagen: TfrmImagen;

implementation

{$R *.lfm}

{ TfrmImagen }

//Sale del sistema
procedure TfrmImagen.mnuArchivoSalirClick(Sender: TObject);
begin
  Application.Terminate;
end;

//Abre archivo de imagen BMP
procedure TfrmImagen.mnuArchivoAbrirClick(Sender: TObject);
var
  nom : string;
begin
  if OpenDialog1.Execute then
  begin
    nom := OpenDialog1.FileName;
    imagen := TPicture.Create;
    try
      begin
        imagen.LoadFromFile(nom);
        BM.Assign(imagen.Graphic);
      end;
    except
      on E: Exception do
      ShowMessage('Error archivo no soportado');
    end;

    end;

    // Mostrar la imagen cargada
    MImagen(BM);
end;

procedure TfrmImagen.mnuArchivoGuardarClick(Sender: TObject);
var
  nom : String;
begin
  SaveDialog1.Filter:='BMP';
  SaveDialog1.FileName:='BMP';

  if SaveDialog1.Execute then
  begin
    nom := SaveDialog1.FileName;
    if nom <> '' then
    begin
      nom:= nom + '.bmp';
      Image1.Picture.SaveToFile(nom);
    end;
  end;

end;

procedure TfrmImagen.FormCreate(Sender: TObject);
begin
  BM := TBitmap.Create;
  BA := TBitmap.Create;
  currentImageIndex := -1;
end;

procedure TfrmImagen.MenuItem10Click(Sender: TObject);
begin
  // Verifica si hay imágenes anteriores y que no estemos en la posición inicial
  if currentImageIndex > 0 then
  begin
    // Agrega la imagen actual al historial de rehacer antes de deshacer
    SetLength(imagenesRehacer, Length(imagenesRehacer) + 1);
    imagenesRehacer[High(imagenesRehacer)] := imagenes[currentImageIndex];

    // Retrocede a la imagen anterior
    currentImageIndex -= 1;
    BM.Assign(imagenes[currentImageIndex]);
    SetLength(imagenes, Length(imagenes)-1);
    MImagen(BM, false);
  end
  else
  begin
    ShowMessage('No hay imágenes anteriores para deshacer.');
  end;
end;


procedure TfrmImagen.MenuItem11Click(Sender: TObject);
begin
  if Length(imagenesRehacer) > 0 then
  begin
    // Mueve la imagen del historial de rehacer al historial de deshacer
    currentImageIndex += 1;
    SetLength(imagenes, Length(imagenes) + 1);
    imagenes[High(imagenes)] := imagenesRehacer[High(imagenesRehacer)];

    // Asigna la imagen al Bitmap y muestra la imagen
    BM.Assign(imagenesRehacer[High(imagenesRehacer)]);
    MImagen(BM, false);

    // Elimina la imagen del historial de rehacer
    if Length(imagenesRehacer)>0 then
      SetLength(imagenesRehacer, Length(imagenesRehacer) - 1);
  end
  else
  begin
    ShowMessage('No hay imágenes para rehacer.');
  end;
end;

//Negativo
procedure TfrmImagen.MenuItem2Click(Sender: TObject);
begin
  Iancho:=BM.Width;
  Ialto:=BM.Height;
  BM_MAT(BM,MTR);
  FPNegativo(MTR, MRES, Iancho, Ialto);
  MAT_BM(MRES, BM, Iancho, Ialto);
  MImagen(BM);
end;
//Gris
procedure TfrmImagen.MenuItem3Click(Sender: TObject);
begin
  Iancho:=BM.Width;
  Ialto:=BM.Height;
  BM_MAT(BM,MTR);
  FPGris(MTR, MRES, Iancho, Ialto);
  MAT_BM(MRES, BM, Iancho, Ialto);
  MImagen(BM);
end;
//Gris RGB
procedure TfrmImagen.MenuItem4Click(Sender: TObject);
begin
  Iancho:=BM.Width;
  Ialto:=BM.Height;
  BM_MAT(BM,MTR);
  FPRGBGris(MTR, MRES, Iancho, Ialto);
  MAT_BM(MRES, BM, Iancho, Ialto);
  MImagen(BM);
end;

procedure TfrmImagen.MenuItem7Click(Sender: TObject);
begin
  Image1.Stretch := not Image1.Stretch;
end;
//Gamma
procedure TfrmImagen.MenuItem8Click(Sender: TObject);
var
  gam : real;
begin
  frmGamma.ShowModal;
  if frmGamma.ModalResult = mrOK then
  begin
    gam:=frmGamma.g;
    Iancho:=BM.Width;
    Ialto:=BM.Height;
    BM_MAT(BM,MTR);
    FPGamma(MTR, MRES, Iancho, Ialto, gam);
    MAT_BM(MRES, BM, Iancho, Ialto);
    MImagen(BM)
  end;
end;

//Umbral
procedure TfrmImagen.MenuItem9Click(Sender: TObject);
var
  umbralStr: String;
  umbral: Integer;
  sentidoStr: String;
  sentido: Boolean;
begin
  umbralStr := InputBox('Configuración de Umbral', 'Introduzca el umbral (0-255):', '128');
  if TryStrToInt(umbralStr, umbral) and (umbral >= 0) and (umbral <= 255) then
  begin
    sentidoStr := InputBox('Configuración de Sentido', 'Introduzca 1 para invertido, 0 para normal:', '0');
    sentido := (sentidoStr = '1');

    Iancho := BM.Width;
    Ialto := BM.Height;
    BM_MAT(BM, MTR);
    FPRGBGris(MTR, MRES, Iancho, Ialto);
    FPUmbral(MTR, MRES, Iancho, Ialto, sentido, umbral);
    MAT_BM(MRES, BM, Iancho, Ialto);
    MImagen(BM);
  end
  else
  begin
    ShowMessage('El umbral debe ser un número entre 0 y 255.');
  end;
end;


//Muestra el contenido del BitMap en el Image
procedure TfrmImagen.MImagen(B: TBitmap; add: Boolean = true);
var
  copyBitmap: TBitmap;
begin
  Image1.Picture.Assign(B); // Muestra la imagen
  if add then
  begin
    // Limpiar el historial de rehacer al aplicar un nuevo filtro
    SetLength(imagenesRehacer, 0);

    // Agregar la nueva imagen al historial de deshacer
    currentImageIndex += 1;

    copyBitmap := TBitmap.Create;
    copyBitmap.Assign(B);
    SetLength(imagenes, currentImageIndex + 1);

    imagenes[currentImageIndex] := copyBitmap;

  end;
end;


//Se muestra la ventana del Histograma
procedure TfrmImagen.mnuHerrHistogramaClick(Sender: TObject);
begin
  BA.Assign(frmImagen.Image1.Picture.Bitmap);
  frmHistograma.Show;
end;
end.

