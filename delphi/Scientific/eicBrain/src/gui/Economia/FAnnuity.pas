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
  eLibCore;

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

