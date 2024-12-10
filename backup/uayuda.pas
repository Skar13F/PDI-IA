unit uAyuda;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

const
  vrs = 1.0;

type

  { TfrmAyuda }

  TfrmAyuda = class(TForm)
    Autor: TLabel;
    btnCerrar: TButton;
    Materia: TLabel;
    Fecha: TLabel;
    Version: TLabel;
    procedure btnCerrarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  btnCerrar.Color:=clRed;
end;

procedure TfrmAyuda.btnCerrarClick(Sender: TObject);
begin
  Close;
end;

end.

