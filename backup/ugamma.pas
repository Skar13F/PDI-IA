unit uGamma;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls;

type

  { TfrmGamma }

  TfrmGamma = class(TForm)
    bCancelar: TButton;
    bAceptar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblPosicion: TLabel;
    TrackBar1: TTrackBar;
    procedure bCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private

  public
    g : real;

  end;

var
  frmGamma: TfrmGamma;

implementation

{$R *.lfm}

{ TfrmGamma }

procedure TfrmGamma.bCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGamma.FormCreate(Sender: TObject);
begin
  lblPosicion.Caption:=('1.0');
  g:=1.0;
end;

procedure TfrmGamma.TrackBar1Change(Sender: TObject);
begin
  g := TrackBar1.Position/20;
  lblPosicion.Caption:=FloatToStr(g);
end;

end.

