(* GPL > 3.0
Copyright (C) 1997-2008 eIrOcA Enrico Croce & Simona Burzio

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
unit FResult;

interface

uses
  Windows, Classes, SysUtils, Graphics, Forms, Controls, WidgetGame, StdCtrls,
  Buttons;

type
  TfmResult = class(TForm)
    btOk: TBitBtn;
    gbOper: TGroupBox;
    gbComp: TGroupBox;
    meOper: TMemo;
    meComp: TMemo;
    gbFlash: TGroupBox;
    lbFlash: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    WG: TWidgetGame;
  end;

var
  fmResult: TfmResult;

implementation

{$R *.DFM}
uses
  MessageStr;

procedure TfmResult.FormShow(Sender: TObject);
var
  f: integer;
  P: array[1..5] of double;
  PStr: array[1..5] of string;
begin
  with WG do begin
    (* COMPARATIVE RESULT *)
    if OldEmpl <= 0 then OldEmpl:= 1;
    if OldIvty <= 0 then OldIvty:= 1;
    if OldSale <= 0 then OldSale:= 1;
    if OldSlry <= 0 then OldSlry:= 1;
    try P[1]:= int(((Empl / OldEmpl) - 1) * 100); except P[1]:= 0; end;
    try P[2]:= int(((Ivty / OldIvty) - 1) * 100); except P[2]:= 0; end;
    try P[3]:= int(((Sale / OldSale) - 1) * 100); except P[3]:= 0; end;
    try P[4]:= int(((UCst / OldUCst) - 1) * 100); except P[4]:= 0; end;
    try P[5]:= int(((Slry / OldSlry) - 1) * 100); except P[5]:= 0; end;
    (* percentage change *)
    for F:= 1 to 5 do begin
      if abs(P[F]) < 1 then begin
        PStr[F]:= IDS_STABLE;
      end
      else if P[f] < 0 then begin
        PStr[F]:= Format(IDS_GODOWN, [P[F]]);
      end
      else begin
        PStr[F]:= Format(IDS_GOUP, [P[F]]);
      end;
    end;
    meOper.Clear;
    meOper.Lines.Add(Format(IDS_OPER1, [Quarter, Empl]));
    meOper.Lines.Add(Format(IDS_OPER2, [NewEmp]));
    meOper.Lines.Add(Format(IDS_OPER3, [LftEmp]));
    meOper.Lines.Add(Format(IDS_OPER4, [trunc(dProduction)]));
    meOper.Lines.Add(Format(IDS_OPER5, [UCst]));
    meOper.Lines.Add(Format(IDS_OPER6, [Ivty]));
    meComp.Clear;
    meComp.Lines.Add(Format(IDS_COMP1, [Sale, dPrice]));
    meComp.Lines.Add(Format(IDS_COMP2, [PStr[1]]));
    meComp.Lines.Add(Format(IDS_COMP3, [PStr[2]]));
    meComp.Lines.Add(Format(IDS_COMP4, [PStr[3]]));
    meComp.Lines.Add(Format(IDS_COMP5, [PStr[4]]));
    meComp.Lines.Add(Format(IDS_COMP6, [PStr[5]]));
  end;
end;

procedure TfmResult.FormCreate(Sender: TObject);
begin
  gbOper.Caption := IDS_CAPOPER;
  gbComp.Caption := IDS_CAPCOMP;
  gbFlash.Caption:= IDS_CAPFLHRP;
  btOk.Caption   := IDS_OK;
  Caption        := IDS_FRESULT;
end;

end.

