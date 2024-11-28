unit uCalculadora;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  uOpCalculadora;

type

  { TfrmCalculadora }

  TfrmCalculadora = class(TForm)
    Button1: TButton;
    Button2: TButton;
    cmbOperaciones: TComboBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    OpenDialog1: TOpenDialog; // Agregado para seleccionar archivos
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    ScrollBox3: TScrollBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cmbOperacionesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadImageToBitmap(OpenDialog: TOpenDialog; Bitmap: TBitmap; Image: TImage);
    procedure DisplayBitmapInImage(Bitmap: TBitmap; Image: TImage);
  public
    BM1, BM2, BMR: TBitmap;
    Iancho, Ialto: Integer;
  end;

var
  frmCalculadora: TfrmCalculadora;

implementation

{$R *.lfm}

{ TfrmCalculadora }

// Función auxiliar para cargar imagen en un TBitmap y mostrarla en TImage
procedure TfrmCalculadora.LoadImageToBitmap(OpenDialog: TOpenDialog; Bitmap: TBitmap; Image: TImage);
var
  TempPicture: TPicture;
begin
  if OpenDialog.Execute then
  begin
    TempPicture := TPicture.Create;
    try
      TempPicture.LoadFromFile(OpenDialog.FileName);
      Bitmap.Assign(TempPicture.Graphic);  // Cargar la imagen al TBitmap
      // Llamamos a la función que asigna el Bitmap al Image
      DisplayBitmapInImage(Bitmap, Image);
    except
      on E: Exception do
        ShowMessage('Error: Archivo no soportado o inválido.');
    end;
    TempPicture.Free;
  end;
end;


// Botón para cargar la primera imagen
procedure TfrmCalculadora.Button1Click(Sender: TObject);
begin
  LoadImageToBitmap(OpenDialog1, BM1, Image1);
end;

// Botón para cargar la segunda imagen
procedure TfrmCalculadora.Button2Click(Sender: TObject);
begin
  LoadImageToBitmap(OpenDialog1, BM2, Image2);
end;

procedure TfrmCalculadora.cmbOperacionesChange(Sender: TObject);
var
  bitMapTem : TBitmap;
begin
    // Verificar que BM1 y BM2 tengan imágenes cargadas
  if (BM1 = nil) or (BM2 = nil) or (BM1.Width = 0) or (BM1.Height = 0) or
    (BM2.Width = 0) or (BM2.Height = 0) then
  begin
    ShowMessage('Por favor, asegúrate de que ambas imágenes (BM1 y BM2) estén cargadas.');
    Exit;
  end;

  if cmbOperaciones.Text = 'Suma 1' then//suma 1
    begin
      SumarImagenes(BM1,BM2,BMR);
      DisplayBitmapInImage(BMR, Image3);
    end
  else if cmbOperaciones.Text = 'Suma 2' then//suma 2
    begin
      SumarImagenes2(BM1,BM2,BMR);
      DisplayBitmapInImage(BMR, Image3);
    end
  else if cmbOperaciones.Text = 'Resta 1' then//resta 1
    begin
      RestaImagenes(BM1,BM2,BMR);
      DisplayBitmapInImage(BMR, Image3);
    end
  else if cmbOperaciones.Text = 'Resta 2' then//resta 2
    begin
      RestaImagenesValorAbsoluto(BM1, BM2,  BMR);
      DisplayBitmapInImage(BMR, Image3);
    end
  else if cmbOperaciones.Text = 'Resta 3' then//resta 3
    begin
      RestaImagenesShift(BM1,BM2,BMR);
      DisplayBitmapInImage(BMR, Image3);
    end
  else if cmbOperaciones.Text = 'Rflx. H' then//reflexión H
    begin
      ReflexionHorizontal(BMR);
      DisplayBitmapInImage(BMR, Image3);
    end
  else if cmbOperaciones.Text = 'Rflx. V' then//Reflexión V
    begin
      ReflexionVertical(BMR);
      DisplayBitmapInImage(BMR, Image3);
    end
  else if cmbOperaciones.Text = 'Rflx. Doble' then// Reflexión doble
    begin
      ReflexionDoble(BMR);
      DisplayBitmapInImage(BMR, Image3);
    end
  else if cmbOperaciones.Text = 'A <-- R' then// cambio
    begin
      if (BMR = nil) or (BMR.Width = 0) or (BMR.Height = 0) then
        begin
          ShowMessage('No hay datos en BMR. Realiza una operación antes de intentar esta acción.');
          Exit;
        end;
      bitMapTem.Assign(BM1);
      BM1.Assign(BMR);
      DisplayBitmapInImage(BM1, Image1);
      BMR.Assign(bitMapTem);
      DisplayBitmapInImage(BMR, Image3);
    end
  else if cmbOperaciones.Text = 'B <-- R' then
    begin
      if (BMR = nil) or (BMR.Width = 0) or (BMR.Height = 0) then
        begin
          ShowMessage('No hay datos en BMR. Realiza una operación antes de intentar esta acción.');
          Exit;
        end;
      bitMapTem.Assign(BM2);
      BM2.Assign(BMR);
      DisplayBitmapInImage(BM2, Image2);
      BMR.Assign(bitMapTem);
      DisplayBitmapInImage(BMR, Image3);
    end
  else if cmbOperaciones.Text = 'A<-> B' then
    begin
      if (BMR = nil) or (BMR.Width = 0) or (BMR.Height = 0) then
        begin
          ShowMessage('No hay datos en BMR. Realiza una operación antes de intentar esta acción.');
          Exit;
        end;
      bitMapTem.Assign(BM1);
      BM1.Assign(BM2);
      DisplayBitmapInImage(BM1, Image1);
      BM2.Assign(bitMapTem);
      DisplayBitmapInImage(BM2, Image2);
    end
  else
    ShowMessage('Selecciona una opción válida');

end;

// Inicialización del formulario
procedure TfrmCalculadora.FormCreate(Sender: TObject);
begin
  BM1 := TBitmap.Create;
  BM2 := TBitmap.Create;
  BMR := TBitmap.Create;
end;

procedure TfrmCalculadora.DisplayBitmapInImage(Bitmap: TBitmap; Image: TImage);
begin
  if Assigned(Bitmap) and Assigned(Image) then
  begin
    try
      Image.Picture.Assign(Bitmap); // Asigna el contenido del bitmap al TImage
    except
      on E: Exception do
        ShowMessage('Error al mostrar la imagen: ' + E.Message);
    end;
  end
  else
    ShowMessage('El Bitmap o el TImage no están inicializados.');
end;


end.

