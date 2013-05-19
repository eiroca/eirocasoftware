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
unit FMarketReport;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, JvCtrls, StdCtrls, Buttons, WidgetGame,
  JvSlider, JvExControls, JvLabel;

type
  TfmMarketReport = class(TForm)
    gbPI: TGroupBox;
    gbRI: TGroupBox;
    btOk: TBitBtn;
    lbMarRepTit: TJvLabel;
    Image1: TImage;
    lbQtr: TLabel;
    Image2: TImage;
    gbAI: TGroupBox;
    gbPAMix: TGroupBox;
    lbPrice: TLabel;
    lbQty1: TLabel;
    lbQty2: TLabel;
    lbCst2: TLabel;
    lbChange: TLabel;
    slMix: TJvSlider;
    lbMix1: TLabel;
    lbMIx2: TLabel;
    lbPC: TLabel;
    lbPI: TLabel;
    lbAD: TLabel;
    lbAI: TLabel;
    lbRD: TLabel;
    lbRI: TLabel;
    lbCst1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    WG: TWidgetGame;
  end;

var
  fmMarketReport: TfmMarketReport;

implementation

{$R *.DFM}

uses
  MessageStr;

procedure TfmMarketReport.FormShow(Sender: TObject);
var
  i: integer;
  tmp2, tmp1: string;
begin
  with WG do begin
    RptC:= MktRepCost;
    lbQtr.Caption:= Format(IDS_LBQTR,[Quarter]);
    tmp1:= '';
    tmp2:= '';
    for i:= 1 to 7 do begin
      tmp1:= tmp1 + Format('%3d',[trunc(PriIdx[i].y)])+#13;
      tmp2:= tmp2 + Format('%3d%%',[round(PriIdx[i].q * 100)])+#13;
    end;
    lbPC.Caption:= tmp1;
    lbPI.Caption:= tmp2;
    tmp1:= '';
    tmp2:= '';
    for i:= 1 to 8 do begin
      tmp1:= tmp1 + Format('%3d',[trunc(AdsIdx[i].y)]) + #13;
      tmp2:= tmp2 + Format('%3d%%',[round(AdsIdx[i].q * 100)]) + #13;
    end;
    lbAD.Caption:= tmp1;
    lbAI.Caption:= tmp2;
    tmp1:= '';
    tmp2:= '';
    for i:= 1 to 5 do begin
      tmp1:= tmp1 + Format('%3d',[trunc(ReDeIdx[i].y)]) + #13;
      tmp2:= tmp2 + Format('%4d%%',[round(ReDeIdx[i].q * 100)])+ #13;
    end;
    lbRD.Caption:= tmp1;
    lbRI.Caption:= tmp2;
    slMix.Position:= trunc(PA_D * 100);
  end;
end;

procedure TfmMarketReport.FormCreate(Sender: TObject);
begin
  Caption:= IDS_CAPMARPT;
  lbMarRepTit.Caption:= IDS_LBMRTIT;
  gbPI.Caption:= IDS_GBPRINDX;
  gbAI.Caption:= IDS_GBADINDX;
  gbRI.Caption:= IDS_GBRDINDX;
  lbPrice.Caption:= IDS_LBPRICE;
  lbQty1.Caption:= IDS_LBQTY;
  lbQty2.Caption:= IDS_LBQTY;
  lbCst1.Caption:= IDS_LBCST;
  lbCst2.Caption:= IDS_LBCST;
  lbChange.Caption:= IDS_LBCHANGE;
  gbPAMix.Caption:= IDS_GBPAMIX;
  lbMix1.Caption:= IDS_LBMIX1;
  lbMix2.Caption:= IDS_LBMIX2;
  btOk.Caption:= IDS_MARREPOK;
end;

end.

