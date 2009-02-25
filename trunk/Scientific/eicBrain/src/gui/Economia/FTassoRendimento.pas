unit FTassoRendimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfmTassoRendimento = class(TForm)
    iPV: TLabeledEdit;
    iPeriodi: TLabeledEdit;
    iPayment: TLabeledEdit;
    Label2: TLabel;
    lOutput: TLabel;
    btCancel: TBitBtn;
    btCalc: TBitBtn;
    iFV: TLabeledEdit;
    procedure btCalcClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmTassoRendimento: TfmTassoRendimento;

implementation

{$R *.dfm}

uses
  eLib, uEconomia;

procedure TfmTassoRendimento.btCalcClick(Sender: TObject);
var
  ann: TAnnuity;
  x: double;
begin
  ann:= TAnnuity.Create;
  ann.t:= 0;
  x:= abs(Parser.DVal(iFV.Text));
  iFV.Text:= FloatToStr(x);
  ann.m:= x;
  x:= abs(Parser.DVal(iPV.Text));
  iPV.Text:= FloatToStr(x);
  ann.c:= x;
  x:= Parser.DVal(iPeriodi.Text);
  if (x<1) then x:= 1;
  ann.n:= x;
  iPeriodi.Text:= FloatToStr(x);
  x:= abs(Parser.DVal(iPayment.Text));
  iPayment.Text:= FloatToStr(x);
  ann.p:= -x;
  try
    ann.CalcR;
    lOutput.Caption:= FloatToStr(round(ann.r * 100000) * 0.001);
  except
    lOutput.Caption:= '?';
  end;
  ann.Free;
end;

end.

