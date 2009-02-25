unit FDurPre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfmDurPre = class(TForm)
    iPMT: TLabeledEdit;
    iPV: TLabeledEdit;
    Label2: TLabel;
    lOutput: TLabel;
    btCancel: TBitBtn;
    btCalc: TBitBtn;
    iTasso: TLabeledEdit;
    Label1: TLabel;
    procedure btCalcClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmDurPre: TfmDurPre;

implementation

{$R *.dfm}

uses
  eLib, uEconomia;

procedure TfmDurPre.btCalcClick(Sender: TObject);
var
  ann: TAnnuity;
  x: double;
begin
  ann:= TAnnuity.Create;
  ann.t:= 0;
  x:= abs(Parser.DVal(iPMT.Text));
  iPMT.Text:= FloatToStr(x);
  ann.p:= -x;
  x:= Parser.DVal(iPV.Text);
  if (x<0) then x:= 0;
  ann.c:= x;
  iPV.Text:= FloatToStr(x);
  x:= Parser.DVal(iTasso.Text) * 0.01;
  if (x<0) then x:= 0;
  ann.r:= x;
  iTasso.Text:= FloatToStr(x*100);
  try
    ann.CalcN;
    lOutput.Caption:= FloatToStr(round(abs(ann.N)*365)/365);
  except
    lOutput.Caption:= '?';
  end;
  ann.Free;
end;

end.

