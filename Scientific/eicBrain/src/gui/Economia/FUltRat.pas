unit FUltRat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfmUltRat = class(TForm)
    iPeriodi: TLabeledEdit;
    iPV: TLabeledEdit;
    Label2: TLabel;
    lOutput: TLabel;
    btCancel: TBitBtn;
    btCalc: TBitBtn;
    iTasso: TLabeledEdit;
    Label1: TLabel;
    iPMT: TLabeledEdit;
    procedure btCalcClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmUltRat: TfmUltRat;

implementation

{$R *.dfm}

uses
  eLib, uEconomia;

procedure TfmUltRat.btCalcClick(Sender: TObject);
var
  ann: TAnnuity;
  x: double;
begin
  ann:= TAnnuity.Create;
  ann.t:= 0;
  x:= abs(Parser.DVal(iPeriodi.Text));
  iPeriodi.Text:= FloatToStr(x);
  ann.N:= x;
  x:= Parser.DVal(iPV.Text);
  if (x<0) then x:= 0;
  ann.c:= x;
  x:= Parser.DVal(iPMT.Text);
  if (x<0) then x:= 0;
  ann.p:= -x;
  iPMT.Text:= FloatToStr(x);
  x:= Parser.DVal(iTasso.Text) * 0.01;
  if (x<0) then x:= 0;
  ann.r:= x;
  iTasso.Text:= FloatToStr(x*100);
  try
    ann.CalcM;
    lOutput.Caption:= Format('%11.2f', [abs(ann.m)]);
  except
    lOutput.Caption:= '?';
  end;
  ann.Free;
end;

end.

