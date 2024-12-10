//Programa que muestra el histograma de una imagen
unit uImagen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, uVarios, uHistograma, uPuntuales, uGamma, uCalculadora, uExponencial,
  uRegionales, uAyuda;

type

  { TfrmImagen }

  TfrmImagen = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    mnuCoseno: TMenuItem;
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
    procedure Image1Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
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
    procedure mnuCosenoClick(Sender: TObject);
    procedure mnuHerrHistogramaClick(Sender: TObject);
    procedure frmHistogramaClosed(Sender: TObject; var CloseAction: TCloseAction);
  private
    FSelecting: Boolean;
    FStartPoint, FEndPoint: TPoint; // Coordenadas de inicio y fin del rectángulo
    FSelectionRect: TRect; // Rectángulo de selección

    { private declarations }
  public
    { public declarations }
    BM : TBitMap;
    imagenes : array of TBitMap;//Para deshacer
    currentImageIndex : Integer;
    imagenesRehacer: array of TBitMap;// Para rehacer

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

  Image1.OnMouseDown := @Image1MouseDown;
  Image1.OnMouseMove := @Image1MouseMove;
  Image1.OnMouseUp := @Image1MouseUp;
end;

// Obtener perfil de intensidad
procedure TfrmImagen.Image1Click(Sender: TObject);
var
  ClickY: Integer;
  SelectedBitmap: TBitmap;
  RectWidth, RectHeight: Integer;
  SelectionRect: TRect;
begin
  if frmHistograma.Visible = false then
    Exit;

  if Image1.Picture.Bitmap = nil then
  begin
    ShowMessage('No hay imagen cargada.');
    Exit;
  end;

  if (Image1.Picture.Bitmap <> nil) and (currentImageIndex >= 0) then
  begin
    Image1.Picture.Assign(imagenes[currentImageIndex]);
  end;

  // Determina la posición del clic en el eje Y
  ClickY := Mouse.CursorPos.Y - Image1.ClientOrigin.Y;

  // Define las dimensiones del rectángulo
  RectWidth := Image1.Picture.Bitmap.Width;
  RectHeight := 10; // Altura fija de 10 píxeles

  // Ajusta el rectángulo para que no exceda los límites de la imagen
  if ClickY + RectHeight > Image1.Picture.Bitmap.Height then
    ClickY := Image1.Picture.Bitmap.Height - RectHeight;

  SelectionRect := Rect(0, ClickY, RectWidth, ClickY + RectHeight);

  // Crea un nuevo bitmap con las dimensiones seleccionadas
  SelectedBitmap := TBitmap.Create;
  try
    SelectedBitmap.Width := RectWidth;
    SelectedBitmap.Height := RectHeight;

    // Copia la sección seleccionada de la imagen original
    SelectedBitmap.Canvas.CopyRect(
      Rect(0, 0, RectWidth, RectHeight),
      Image1.Picture.Bitmap.Canvas,
      SelectionRect
    );

    // Muestra el recorte en el componente Image1 o úsalo para operaciones futuras
    BM.Assign(SelectedBitmap); // Actualiza la imagen mostrada
    BA.Assign(SelectedBitmap);

    with Image1.Picture.Bitmap.Canvas do
      begin
        Brush.Color := clBlue;  // Establece el color de relleno en azul
        Brush.Style := bsSolid; // Establece el estilo de relleno sólido
        FillRect(SelectionRect); // Rellena el rectángulo con el color azul
      end;
    frmHistograma.UpdateHistogram(BA);
  finally
    SelectedBitmap.Free;
  end;
end;


procedure TfrmImagen.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FSelecting := True;
    FStartPoint := Point(X, Y);
    FEndPoint := FStartPoint;
  end;
end;

procedure TfrmImagen.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FSelecting then
  begin
    FEndPoint := Point(X, Y);

    // Redibujar el rectángulo de selección
    Image1.Picture.Bitmap.Canvas.DrawFocusRect(FSelectionRect); // Borra el anterior
    FSelectionRect := Rect(FStartPoint.X, FStartPoint.Y, FEndPoint.X, FEndPoint.Y);
    Image1.Picture.Bitmap.Canvas.DrawFocusRect(FSelectionRect);
  end;
end;

procedure TfrmImagen.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  SelectedBitmap: TBitmap;
  RectWidth, RectHeight: Integer;
begin
  if FSelecting then
  begin
    FSelecting := False;
    FEndPoint := Point(X, Y);

    // Ajustar el rectángulo final
    FSelectionRect := Rect(FStartPoint.X, FStartPoint.Y, FEndPoint.X, FEndPoint.Y);
    NormalizeRect(FSelectionRect); // Asegura que los límites del rectángulo sean correctos

    // Verificar dimensiones del rectángulo
    RectWidth := FSelectionRect.Right - FSelectionRect.Left;
    RectHeight := FSelectionRect.Bottom - FSelectionRect.Top;

    if (RectWidth > 0) and (RectHeight > 0) then
    begin
      // Crear un bitmap con la región seleccionada
      SelectedBitmap := TBitmap.Create;
      try
        SelectedBitmap.Width := RectWidth;
        SelectedBitmap.Height := RectHeight;
        SelectedBitmap.Canvas.CopyRect(
          Rect(0, 0, RectWidth, RectHeight),
          Image1.Picture.Bitmap.Canvas,
          FSelectionRect
        );

        // Mostrar el recorte en la imagen original (o en otra ventana)
        MImagen(SelectedBitmap);
      finally
        SelectedBitmap.Free;
      end;
    end
  end;
end;

//deshacer
procedure TfrmImagen.MenuItem10Click(Sender: TObject);
begin
  if currentImageIndex > 0 then
  begin
    // Agrega la imagen actual al historial de rehacer
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

// -- Rehacer
procedure TfrmImagen.MenuItem11Click(Sender: TObject);
begin
  if Length(imagenesRehacer) > 0 then
  begin
    // Mueve la imagen del historial de rehacer al historial de deshacer
    currentImageIndex += 1;
    SetLength(imagenes, Length(imagenes) + 1);
    imagenes[High(imagenes)] := imagenesRehacer[High(imagenesRehacer)];

    BM.Assign(imagenesRehacer[High(imagenesRehacer)]);
    MImagen(BM, false);

    // Elimina la imagen del historial
    if Length(imagenesRehacer)>0 then
      SetLength(imagenesRehacer, Length(imagenesRehacer) - 1);
  end
  else
  begin
    ShowMessage('No hay imágenes para rehacer.');
  end;
end;

procedure TfrmImagen.MenuItem12Click(Sender: TObject);
begin
  frmCalculadora.Show;
end;
//Función seno
procedure TfrmImagen.MenuItem13Click(Sender: TObject);
begin
  Iancho:= BM.Width;
  Ialto:= BM.Height;
  BM_MAT(BM, MTR);
  FSeno(MTR, MRES, Iancho, Ialto);
  MAT_BM(MRES, BM, Iancho, Ialto);
  MImagen(BM);
end;
//Función exponencial
procedure TfrmImagen.MenuItem14Click(Sender: TObject);
var
  alf : real;
begin
  frmExponencial.ShowModal;
  if frmExponencial.ModalResult = mrOK then
  begin
    alf := frmExponencial.alfa;
    Iancho:=BM.Width;
    Ialto:=BM.Height;
    BM_MAT(BM, MTR);
    FExponencial(MTR, MRES, Iancho, Ialto, alf);
    MAT_BM(MRES, BM, Iancho, Ialto);
    MImagen(BM);
  end;
end;

//Logaritmo
procedure TfrmImagen.MenuItem15Click(Sender: TObject);
begin
  BM.Assign(imagenes[currentImageIndex]);
  Iancho:=BM.Width;
  Ialto:=BM.Height;
  BM_MAT(BM,MTR);
  FLogaritmo(MTR, MRES, Iancho, Ialto);
  MAT_BM(MRES, BM, Iancho, Ialto);
  MImagen(BM);
end;

//Aplica el filtro de media a la imagen
procedure TfrmImagen.MenuItem17Click(Sender: TObject);
begin
  Iancho:=BM.Width;
  Ialto:=BM.Height;
  BM_MAT(BM, MTR);
  FRMediana(MTR, MRES, Iancho, Ialto, 3);
  MAT_BM(MRES, BM, Iancho, Ialto);
  MImagen(BM);
end;

procedure TfrmImagen.MenuItem18Click(Sender: TObject);
var
  MG : M3x3;
  ff: Real;
begin
  bCon:=2;//bandera gaussiano
  Iancho:=BM.Width;
  Ialto:=BM.Height;
  BM_MAT(BM, MTR);
  //Obtiene la matriz de convolución en un entorno de velocidad de 3x3
  Llena_MC(Mg, ff);
  FRMediaA_gaussiano(MTR, MRES, Iancho, Ialto, Mg, ff);
  MAT_BM(MRES, BM, Iancho, Ialto);
  MImagen(BM);
end;

//Mostrar información de swl programa
procedure TfrmImagen.MenuItem19Click(Sender: TObject);
begin
  frmAyuda.ShowModal;
end;

procedure TfrmImagen.MenuItem20Click(Sender: TObject);
var
  alf:real;
begin
  frmExponencial.ShowModal;
  if frmExponencial.ModalResult=mrOk then
  begin
    alf:=frmExponencial.alfa;
    Iancho:=BM.Width;
    Ialto:=BM.Height;
    BM_Mat(BM, MTr);
    FExponencialOscuro(MTr, MRes, Iancho, Ialto,alf);
    Mat_BM(MRes,BM, Iancho, Ialto);
    MImagen(BM);
  end;
end;

// Suavizado mediana ***********************************************************
procedure TfrmImagen.MenuItem21Click(Sender: TObject);
var
  Mc : M3x3;
  ff : Real;
begin
  bCon := 1;
  Iancho:=BM.Width;
  Ialto:=BM.Height;
  BM_MAT(BM, MTR);
  //Obtiene la matriz de convolución en un entorno de velocidad de 3x3
  Llena_MC(Mc, ff);
  FRMediaA_gaussiano(MTR, MRES, Iancho, Ialto, Mc, ff);
  MAT_BM(MRES, BM, Iancho, Ialto);
  MImagen(BM);
end;

//Negativo
procedure TfrmImagen.MenuItem2Click(Sender: TObject);
begin
  BM.Assign(imagenes[currentImageIndex]);
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
  BM.Assign(imagenes[currentImageIndex]);
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
  BM.Assign(imagenes[currentImageIndex]);
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
    BM.Assign(imagenes[currentImageIndex]);
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
    BM.Assign(imagenes[currentImageIndex]);
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
//Función coseno para oscurecer
procedure TfrmImagen.mnuCosenoClick(Sender: TObject);
begin
  Iancho:=BM.Width;
  Ialto:=BM.Height;
  BM_MAT(BM, MTR);
  FCoseno(MTR, MRES, Iancho, Ialto);
  MAT_BM(MRES, BM,  Iancho, Ialto);
  MImagen(BM);
end;


//Se muestra la ventana del Histograma
procedure TfrmImagen.mnuHerrHistogramaClick(Sender: TObject);
begin
  frmHistograma.OnClose := @frmHistogramaClosed;
  BA.Assign(frmImagen.Image1.Picture.Bitmap);
  frmHistograma.Show;
end;

procedure TfrmImagen.frmHistogramaClosed(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(BM) then
  begin
    // Restaura la imagen anterior
    Image1.Picture.Bitmap.Assign(imagenes[currentImageIndex]);
  end;
end;

end.

