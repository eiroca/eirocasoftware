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
  eLibCore, uEconomia;

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

