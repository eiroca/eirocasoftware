unit FAnnuity;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, uEconomia;

type
  TfmAnnuity = class(TForm)
    iPV: TLabeledEdit;
    iPeriodi: TLabeledEdit;
    btCancel: TBitBtn;
    btCalcPV: TBitBtn;
    iTasso: TLabeledEdit;
    Label1: TLabel;
    Label3: TLabel;
    iFV: TLabeledEdit;
    iPMT: TLabeledEdit;
    cbAnticipati: TCheckBox;
    btCalcFV: TBitBtn;
    btCalcR: TBitBtn;
    btCalcN: TBitBtn;
    btCalcPMT: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btCalcPVClick(Sender: TObject);
  private
    { Private declarations }
    ann: TAnnuity;
    procedure ReadInput;
    procedure WriteOutput;
  public
    { Public declarations }
  end;

var
  fmAnnuity: TfmAnnuity;

implementation

{$R *.dfm}

uses
  eLib;

procedure TfmAnnuity.WriteOutput;
begin
  iPV.Text:= Format('%11.2f', [ann.c]);
  iFV.Text:= Format('%11.2f', [ann.m]);
  iTasso.Text:= Format('%7.3f', [ann.r * 100]);
  iPeriodi.Text:= Format('%11.2f', [ann.n]);
  iPMT.Text:= Format('%11.2f', [ann.p]);
end;

procedure TfmAnnuity.ReadInput;
begin
  if cbAnticipati.Checked then ann.t:= 1 else ann.t:= 0;
  ann.c:= Parser.DVal(iPV.Text);
  ann.m:= Parser.DVal(iFV.Text);
  ann.r:= Parser.DVal(iTasso.Text) * 0.01;
  ann.n:= Parser.DVal(iPeriodi.Text);
  ann.p:= Parser.DVal(iPMT.Text);
end;

procedure TfmAnnuity.btCalcPVClick(Sender: TObject);
begin
  ReadInput;
  case (Sender as TBitBtn).Tag of
    0: ann.CalcC;
    1: ann.CalcM;
    2: ann.CalcR;
    3: ann.CalcN;
    4: ann.CalcP;
  end;
  WriteOutput;
end;

procedure TfmAnnuity.FormCreate(Sender: TObject);
begin
  ann:= TAnnuity.Create;
end;

procedure TfmAnnuity.FormDestroy(Sender: TObject);
begin
  ann.Free;
end;

end.

