unit FTasRen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfmTasRen = class(TForm)
    iPV: TLabeledEdit;
    iFV: TLabeledEdit;
    iPeriodi: TLabeledEdit;
    lOutput: TLabel;
    btCancel: TBitBtn;
    btCalc: TBitBtn;
    procedure btCalcClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmTasRen: TfmTasRen;

implementation

{$R *.dfm}

uses
  eLib, uEconomia;

procedure TfmTasRen.btCalcClick(Sender: TObject);
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
  try
    ann.CalcR;
    if (ann.r<0) then begin
      lOutput.Caption:= Format('Deprezzamento del %7.2f %%', [abs(ann.r)*100]);
    end
    else begin
      lOutput.Caption:= Format('Apprezzamento del %7.2f %%', [abs(ann.r)*100]);
    end;
  except
    lOutput.Caption:= '?';
  end;
  ann.Free;
end;

end.

