unit FDepositoMinimo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfmDepositoMinimo = class(TForm)
    iPrelievi: TLabeledEdit;
    iPeriodi: TLabeledEdit;
    iTasso: TLabeledEdit;
    cbAnticipati: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
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
  fmDepositoMinimo: TfmDepositoMinimo;

implementation

{$R *.dfm}

uses
  eLib, uEconomia;

procedure TfmDepositoMinimo.btCalcClick(Sender: TObject);
var
  ann: TAnnuity;
  x: double;
begin
  ann:= TAnnuity.Create;
  x:= abs(Parser.DVal(iPrelievi.Text));
  iPrelievi.Text:= FloatToStr(x);
  ann.p:= -x;
  x:= Parser.DVal(iPeriodi.Text);
  if (x<1) then x:= 1;
  ann.n:= x;
  iPeriodi.Text:= FloatToStr(x);
  x:= Parser.DVal(iTasso.Text) * 0.01;
  if (x<0) then x:= 0;
  ann.r:= x;
  iTasso.Text:= FloatToStr(x*100);
  if cbAnticipati.Checked then ann.t:= 1 
  else ann.t:= 0;
  try
    ann.CalcC;
    lOutput.Caption:= FloatToStr(round(ann.c*100)*0.01);
  except
    lOutput.Caption:= '?';
  end;
  ann.Free;
end;

end.
