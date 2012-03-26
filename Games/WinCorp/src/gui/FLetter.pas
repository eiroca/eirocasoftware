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
unit FLetter;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, JvCtrls, StdCtrls, Buttons, WidgetGame, JvExControls, JvLabel;

type
  TfmLetter = class(TForm)
    btOk: TBitBtn;
    lbSign: TLabel;
    lbLetTit: TJvLabel;
    lbLetter4: TLabel;
    lbLetter1: TLabel;
    lbLetter2: TLabel;
    lbLetter3: TLabel;
    procedure btOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    WG: TWidgetGame;
  end;

var
  fmLetter: TfmLetter;

implementation

{$R *.DFM}

uses
  FMain,
  MessageStr;

procedure TfmLetter.btOkClick(Sender: TObject);
begin
  fmMain.Show;
  Close;
end;

procedure TfmLetter.FormShow(Sender: TObject);
var
  sMGN: string;
  sAST: string;
  sTRO: string;
  TRNA: integer;
  MGIN: integer;
  ASET: integer;
  SCOR : integer;
begin
  with WG do begin
    SCOR:= 0;
  (* [ FINAL LETTER ] *)
    try TRNA:= round((CumLft / CumEmp) * 100); except TRNA:= 0; end;
    try MGIN:= round((CumPft / CumRev) * 100); except MGIN:= 0; end;
    try ASET:= round((((CASH + (IVTY * UCST)) / (750 + (50 * 12)) * 100) - 100) / Turns); except ASET:= 0; end;
    lbLetter1.Caption:= IDS_LETTER01+#13+#13+Format(IDS_LETTER02,[Turns]);
    lbLetter2.Caption:=
      Format(IDS_LETTER03,[round(CumRev / Turns)])+#13+
      Format(IDS_LETTER04,[round(CumPft / Turns)])+#13+
      Format(IDS_LETTER05,[TRNA])+#13+
      Format(IDS_LETTER06,[MGIN])+#13+
      Format(IDS_LETTER07,[ASET]);
    if MGIN >= 20 then begin
      sMGN:= IDS_LETMGN1;
      SCOR:= SCOR + 4;
    end
    else if MGIN >= 10 then begin
      sMGN:= IDS_LETMGN2;
      SCOR:= SCOR + 3;
    end
    else if MGIN >= 5 then begin
      sMGN:= IDS_LETMGN3;
      SCOR:= SCOR + 2;
    end
    else begin
      sMGN:= IDS_LETMGN4;
    end;
    if TRNA <= 5 then begin
      sTRO:= IDS_LETTRN1;
      SCOR:= SCOR + 3;
    end
    else if TRNA <= 10 then begin
      sTRO:= IDS_LETTRN2;
      SCOR:= SCOR + 2;
    end
    else if TRNA <= 15 then begin
      sTRO:= IDS_LETTRN3;
      SCOR:= SCOR + 1;
    end
    else begin
      sTRO:= IDS_LETTRN4;
    end;
    if ASET >= 35 then begin
      sAST:= IDS_LETASS1;
      SCOR:= SCOR + 3;
    end
    else if ASET >= 25 then begin
      sAST:= IDS_LETASS2;
      SCOR:= SCOR + 2;
    end
    else if ASET >= 12 then begin
      sAST:= IDS_LETASS3;
      SCOR:= SCOR + 1;
    end
    else begin
      sAST:= IDS_LETASS4;
    end;
    if Bankrupt then begin
      lbLetter3.Caption:= IDS_LETBNKRP;
      SCOR:= 0
    end
    else begin
      lbLetter3.Caption:= sMGN+#13+sTRO+#13+sAST;
    end;
    if SCOR >= 7 then lbLetter4.Caption:= Format(IDS_SCORE1, [CumPft div (Turns * 2)])+#13
    else if SCOR >= 4 then lbLetter4.Caption:= IDS_SCORE2+#13
    else if SCOR < 4 then lbLetter4.Caption:= IDS_SCORE3+#13;
    if SCOR > 3 then btOk.Caption:= IDS_BTOKGOOD
    else btOk.Caption:= IDS_BTOKBAD;
  end;
end;

procedure TfmLetter.FormCreate(Sender: TObject);
begin
  Caption:= IDS_CAPLET;
  lbSign.Caption:= IDS_LBSIGN;
  lbLetTit.Caption:= IDS_LBLETTIT;
end;

end.

