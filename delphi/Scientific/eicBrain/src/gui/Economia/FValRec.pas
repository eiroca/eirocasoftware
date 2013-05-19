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
unit FValRec;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfmValRec = class(TForm)
    iPV: TLabeledEdit;
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
  fmValRec: TfmValRec;

implementation

{$R *.dfm}

uses
  eLibCore, uEconomia;

procedure TfmValRec.btCalcClick(Sender: TObject);
var
  ann: TAnnuity;
  x: double;
begin
  ann:= TAnnuity.Create;
  ann.t:= 0;
  x:= abs(Parser.DVal(iPV.Text));
  iPV.Text:= FloatToStr(x);
  ann.c:= x;
  x:= Parser.DVal(iPeriodi.Text);
  if (x<1) then x:= 1;
  ann.n:= x;
  iPeriodi.Text:= FloatToStr(x);
  x:= abs(Parser.DVal(iTasso.Text)) * 0.01;
  ann.r:= -x;
  iTasso.Text:= FloatToStr(x*100);
  try
    ann.CalcM;
    lOutput1.Caption:= FloatToStr(round(abs(ann.m)*100)*0.01);
    lOutput2.Caption:= FloatToStr(round(abs(ann.c-ann.m)*100)*0.01);
  except
    lOutput1.Caption:= '?';
    lOutput2.Caption:= '?';
  end;
  ann.Free;
end;

end.

