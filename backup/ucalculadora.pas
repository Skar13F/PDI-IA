unit uCalculadora;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfrmCalculadora }

  TfrmCalculadora = class(TForm)
    cmbOperaciones: TComboBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    ScrollBox3: TScrollBox;
  private

  public

  end;

var
  frmCalculadora: TfrmCalculadora;

implementation

{$R *.lfm}

end.

