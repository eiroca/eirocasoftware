unit FScoTra;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfmScoTra = class(TForm)
    iFV: TLabeledEdit;
    iPeriodi: TLabeledEdit;
    Label2: TLabel;
    lOutput1: TLabel;
    btCancel: TBitBtn;
    btCalc: TBitBtn;
    iTasso: TLabeledEdit;
    Label1: TLabel;
    Label3: TLabel;
    lOutput2: TLabel;
    procedure btCalcClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmScoTra: TfmScoTra;

implementation

{$R *.dfm}

uses
  eLib, uEconomia;

procedure TfmScoTra.btCalcClick(Sender: TObject);
var
  intSem: TIntSemp;
  x: double;
begin
  intSem:= TIntSemp.Create;
  x:= abs(Parser.DVal(iFV.Text));
  iFV.Text:= FloatToStr(x);
  intSem.m:= x;
  x:= Parser.DVal(iPeriodi.Text);
  if (x<1) then x:= 1;
  intSem.n:= x;
  iPeriodi.Text:= FloatToStr(x);
  x:= abs(Parser.DVal(iTasso.Text));
  iTasso.Text:= FloatToStr(x);
  intSem.r:= 0.01 * x / 365;
  try
    intSem.CalcCI;
    lOutput1.Caption:= Format('%11.2f', [abs(intSem.C)]);
    lOutput2.Caption:= Format('%11.2f', [abs(intSem.I)]);
  except
    lOutput1.Caption:= '?';
    lOutput2.Caption:= '?';
  end;
  intSem.Free;
end;

end.

