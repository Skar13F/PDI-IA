unit uAyuda;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fpreportpdfexport, Forms, Controls, Graphics, Dialogs,
  StdCtrls, LCLIntf, fpreportformexport;

const
  vrs = 1.0;

type

  { TfrmAyuda }

  TfrmAyuda = class(TForm)
    Autor: TLabel;
    btnCerrar: TButton;
    Materia: TLabel;
    Fecha: TLabel;
    MemoInfo: TMemo;
    Version: TLabel;
    procedure btnCerrarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmAyuda: TfrmAyuda;

implementation

{$R *.lfm}

{ TfrmAyuda }

procedure TfrmAyuda.FormCreate(Sender: TObject);
begin
  Version.Caption:= 'Versión: ' + vrs.ToString();
  Fecha.Caption:= 'Fecha: ' + DateToStr(Date);

  // Configuración inicial del Memo con la lista anidada
  MemoInfo.Lines.Clear;
  MemoInfo.Lines.Add('Menú de Funciones para el Procesamiento de Imágenes');
  MemoInfo.Lines.Add('1. Archivo');
  MemoInfo.Lines.Add('   • Abrir: Permite cargar imágenes desde el sistema de archivos para su procesamiento.');
  MemoInfo.Lines.Add('   • Guardar: Guarda las imágenes procesadas en el formato deseado.');
  MemoInfo.Lines.Add('   • Salir: Cierra la aplicación.');
  MemoInfo.Lines.Add('');
  MemoInfo.Lines.Add('2. Editar');
  MemoInfo.Lines.Add('   • Deshacer: Revierte el último cambio realizado en la imagen.');
  MemoInfo.Lines.Add('   • Rehacer: Restaura un cambio revertido previamente.');
  MemoInfo.Lines.Add('');
  MemoInfo.Lines.Add('3. Ver');
  MemoInfo.Lines.Add('   • Redimensionar: Cambia el tamaño de la imagen, permitiendo ajustar ancho y alto según sea necesario.');
  MemoInfo.Lines.Add('');
  MemoInfo.Lines.Add('4. Herramientas');
  MemoInfo.Lines.Add('   • Histograma: Muestra la distribución de intensidades de la imagen en un gráfico.');
  MemoInfo.Lines.Add('   • Recorte de un área: Selecciona y recorta una región específica de la imagen.');
  MemoInfo.Lines.Add('   • Perfil de intensidad: Grafica los valores de intensidad a lo largo de una línea definida en la imagen.');
  MemoInfo.Lines.Add('');
  MemoInfo.Lines.Add('5. Operaciones Puntuales');
  MemoInfo.Lines.Add('   • Negativo: Invierte los colores de la imagen, generando un efecto de "negativo".');
  MemoInfo.Lines.Add('   • Gris: Convierte la imagen a escala de grises.');
  MemoInfo.Lines.Add('   • RGB a Gris: Calcula una escala de grises basada en los canales rojo, verde y azul.');
  MemoInfo.Lines.Add('   • Filtro Gamma: Ajusta el brillo de la imagen utilizando una corrección gamma.');
  MemoInfo.Lines.Add('   • Umbral: Convierte la imagen a blanco y negro con base en un nivel de umbral especificado.');
  MemoInfo.Lines.Add('   • Función Seno: Modifica los valores de los píxeles utilizando una transformación sinusoidal.');
  MemoInfo.Lines.Add('   • Exponencial: Aplica una transformación exponencial para resaltar o atenuar detalles.');
  MemoInfo.Lines.Add('   • Función Coseno: Altera los valores de los píxeles con una función cosenoidal.');
  MemoInfo.Lines.Add('   • Logaritmo: Aplica un filtro logarítmico para resaltar detalles en áreas oscuras.');
  MemoInfo.Lines.Add('   • Exponencial para Oscurecer: Oscurece la imagen mediante una transformación exponencial.');
  MemoInfo.Lines.Add('');
  MemoInfo.Lines.Add('6. Operaciones Regionales');
  MemoInfo.Lines.Add('   • Filtro Gaussiano: Suaviza la imagen reduciendo el ruido y preservando bordes.');
  MemoInfo.Lines.Add('   • Filtro Media: Calcula el promedio de los píxeles en una región para suavizar la imagen.');
  MemoInfo.Lines.Add('   • Filtro Mediana: Sustituye el valor de cada píxel por la mediana de los píxeles vecinos, reduciendo el ruido de sal y pimienta.');
  MemoInfo.Lines.Add('   • Filtro Valor Mínimo: Reemplaza cada píxel por el valor más bajo de los vecinos, útil para eliminar puntos brillantes no deseados.');
  MemoInfo.Lines.Add('   • Filtro Valor Máximo: Reemplaza cada píxel por el valor más alto de los vecinos, útil para resaltar puntos brillantes.');

  // Ajuste de propiedades del Memo


end;

procedure TfrmAyuda.FormShow(Sender: TObject);
const
  PDFFilePath = '/home/oscar/Documentos/Dataflow.pdf';
begin
  if FileExists(PDFFilePath) then
  begin
    try
      //OpenDocument(PDFFilePath);
      //ShowMessage('El PDF se ha cargado correctamente.');
    except
      on E: Exception do
        ShowMessage('Error al abrir el PDF: ' + E.Message);
    end;
  end
  else
  begin
    ShowMessage('El archivo PDF no existe.');
  end;
end;

procedure TfrmAyuda.btnCerrarClick(Sender: TObject);
begin
  Close;
end;

end.
