(* GPL > 3.0
Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)
(*
 @author(Enrico Croce)
*)
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
  eLibCore, uEconomia;

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
