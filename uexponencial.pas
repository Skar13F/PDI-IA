unit uExponencial;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls;

type

  { TfrmExponencial }

  TfrmExponencial = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TrackBar1: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private

  public
    alfa : Real;

  end;

var
  frmExponencial: TfrmExponencial;

implementation

{$R *.lfm}

{ TfrmExponencial }

procedure TfrmExponencial.FormCreate(Sender: TObject);
begin
  Label3.Caption := '0.05';
  alfa := 0.05;
end;

procedure TfrmExponencial.TrackBar1Change(Sender: TObject);
begin
  alfa := TrackBar1.Position/10;
  Label3.Caption:=FloatToStr(alfa);
end;

end.

