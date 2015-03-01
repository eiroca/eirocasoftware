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
unit FGame;

interface

uses
  WidgetGame, SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, ExtCtrls, StdCtrls, Mask, Buttons, JvExMask, JvSpin;

type
  TfmGame = class(TForm)
    gbOpPe: TGroupBox;
    lbHSal: TLabel;
    lbHPro: TLabel;
    lbHInf: TLabel;
    lbHPrd: TLabel;
    lbHCst: TLabel;
    lbHCAS: TLabel;
    lbHEmp: TLabel;
    lbHQtr: TLabel;
    gbDECI: TGroupBox;
    btMarRep: TBitBtn;
    lbRes: TLabel;
    lbPro: TLabel;
    lbAdv: TLabel;
    lbPri: TLabel;
    lbPay: TLabel;
    ilPric: TJvSpinEdit;
    ilProd: TJvSpinEdit;
    ilPayr: TJvSpinEdit;
    ilAdve: TJvSpinEdit;
    ilReDe: TJvSpinEdit;
    lbMarRep: TLabel;
    lbMarRepCst: TLabel;
    lbQtr: TLabel;
    lbEmpl: TLabel;
    lbHInv: TLabel;
    lbIvty: TLabel;
    lbCash: TLabel;
    PopupMenu1: TPopupMenu;
    lbUCst: TLabel;
    lbSlry: TLabel;
    lbCPft: TLabel;
    lbPrdn: TLabel;
    lbFltn: TLabel;
    gbOpRe: TGroupBox;
    lbRCas: TLabel;
    lbRPro: TLabel;
    lbRRes: TLabel;
    lbRAdv: TLabel;
    lbRPay: TLabel;
    lbRCst: TLabel;
    lbRRev: TLabel;
    Bevel1: TBevel;
    lbMCst: TLabel;
    lbPayr: TLabel;
    lbRevn: TLabel;
    lbAdvr: TLabel;
    lbReDe: TLabel;
    lbPrft: TLabel;
    lbCsh2: TLabel;
    btExecute: TBitBtn;
    lbErrMsg: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btExecuteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btMarRepClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FlshMsg: string;
    procedure ClearResult;
    procedure ShowStatus;
    procedure ShowResult;
    procedure UpdateMRcost;
    function  CheckDecision: boolean;
    procedure StartGame(Sender: TWidgetGame);
    procedure StartQuarter(Sender: TWidgetGame);
    procedure EndQuarter(Sender: TWidgetGame);
    procedure EndGame(Sender: TWidgetGame);
    procedure FlashReport(Sender: TWidgetGame; Kind: integer; const Msg: string);
    procedure GameEvent(Sender: TWidgetGame; Kind: integer; const Msg: string);
  public
    { Public declarations }
    WG: TWidgetGame;
  end;

var
  fmGame: TfmGame;

implementation

{$R *.DFM}

uses
  System.UITypes,
  FMain, FLetter, FMarketReport, FResult, MessageStr;

procedure TfmGame.FormShow(Sender: TObject);
begin
  WG.OnStartGame:= StartGame;
  WG.OnStartQuarter:= StartQuarter;
  WG.OnEndQuarter:= EndQuarter;
  WG.OnEndGame:= EndGame;
  WG.OnFlashReport:= FlashReport;
  WG.OnGameEvent:= GameEvent;
  WG.StartGame;
end;

procedure TfmGame.ClearResult;
begin
  lbRevn.Caption:= Format('%10d', [0]);
  lbMCst.Caption:= Format('%10d', [0]);
  lbPayr.Caption:= Format('%10d', [0]);
  lbAdvr.Caption:= Format('%10d', [0]);
  lbReDe.Caption:= Format('%10d', [0]);
  lbPrft.Caption:= Format('%10d', [0]);
  lbCsh2.Caption:= Format('%10d', [WG.Cash]);
end;

procedure TfmGame.StartGame(Sender: TWidgetGame);
begin
  ClearResult;
  ilProd.Value:=  0;
  ilPayr.Value:=  0;
  ilPric.Value:= 19.50;
  ilAdve.Value:=  0;
  ilReDe.Value:=  0;
  FlshMsg:= '';
end;

procedure TfmGame.UpdateMRcost;
begin
  lbMarRepCst.Caption:= Format('%d', [WG.RptC]);
end;

procedure TfmGame.StartQuarter(Sender: TWidgetGame);
begin
  ShowStatus;
  UpdateMRcost;
  lbErrMsg.Caption:= IDS_NOERROR;
  btMarRep.Enabled:= true;
  ActiveControl:= ilPric;
end;

procedure TfmGame.EndQuarter(Sender: TWidgetGame);
begin
  fmResult.lbFlash.Caption:= FlshMsg;
  fmResult.ShowModal;
  ShowResult;
  FlshMsg:= '';
end;

procedure TfmGame.EndGame(Sender: TWidgetGame);
begin
  if not Sender.Bankrupt then begin
    MessageDlg(IDS_ENDTERM, mtInformation, [mbOk], 0);
  end;
  Hide;
  fmLetter.ShowModal;
  Close;
end;

procedure TfmGame.FlashReport(Sender: TWidgetGame; Kind: integer; const Msg: string);
begin
  FlshMsg:= Msg;
end;

procedure TfmGame.GameEvent(Sender: TWidgetGame; Kind: integer; const Msg: string);
begin
  if (Kind = WGM_NOCASH) or (Kind = WGM_NOEMP) then begin
    MessageDlg(Msg, mtWarning, [mbOk], 0);
  end
  else begin
    MessageDlg(Msg, mtInformation, [mbOk], 0);
  end;
end;

procedure TfmGame.ShowStatus;
begin
  with WG do begin
    lbQtr.Caption := Format('%d', [Quarter]);
    lbEmpl.Caption:= Format('%d', [Empl]);
    lbIvty.Caption:= Format('%d', [Ivty]);
    lbCash.Caption:= Format('%d', [Cash]);
    lbUCst.Caption:= Format('%g', [UCst]);
    lbPrdn.Caption:= Format('%g', [Prdn]);
    lbFltn.Caption:= Format('%6.2f %%', [Fltn]);
    lbSlry.Caption:= Format('%6.2f', [Slry]);
    lbCPft.Caption:= Format('%d', [CumPft]);
  end;
end;

procedure TfmGame.ShowResult;
begin
  ShowStatus;
  with WG do begin
    lbRevn.Caption:= Format('%d', [Revenue]);
    lbMCst.Caption:= Format('%d', [MCst]);
    lbPayr.Caption:= Format('%d', [trunc(dPayroll)]);
    lbAdvr.Caption:= Format('%d', [trunc(dAdvert)]);
    lbReDe.Caption:= Format('%d', [RCst]);
    lbPrft.Caption:= Format('%d', [Profit]);
    lbCsh2.Caption:= Format('%d', [Cash]);
  end;
end;

procedure TfmGame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fmMain.Show;
end;

function TfmGame.CheckDecision: boolean;
begin
  with WG do begin
    if ilProd.Value > (EMPL * PRDN) then begin
      lbErrMsg.Caption:= Format(IDS_ERROR1, [trunc(ilProd.Value)]);
      ActiveControl:= ilProd;
      Result:= false;
    end
    else if trunc(ilPayr.Value + ilAdve.Value + ilReDe.Value + RptC) > CASH then begin
      lbErrMsg.Caption:= IDS_ERROR2;
      ActiveControl:= ilPayr;
      Result:= false;
    end
    else begin
      Result:= true;
    end;
  end;
end;

procedure TfmGame.btExecuteClick(Sender: TObject);
begin
  if CheckDecision then begin
    WG.SetDecision(ilPric.Value, ilProd.Value, ilPayr.Value, ilAdve.Value, ilReDe.Value);
    WG.EndQuarter;
    WG.StartQuarter;
  end;
end;

procedure TfmGame.btMarRepClick(Sender: TObject);
begin
  btMarRep.Enabled:= false;
  fmMarketReport.ShowModal;
  UpdateMRcost;
end;

procedure TfmGame.FormCreate(Sender: TObject);
begin
  Caption:= IDS_CAPGAME;
  lbHQtr.Caption:= IDS_LBHQTR;
  lbHEmp.Caption:= IDS_LBHEMP;
  lbHInv.Caption:= IDS_LBHINV;
  lbHCas.Caption:= IDS_LBHCAS;
  lbHCst.Caption:= IDS_LBHCST;
  lbHPrd.Caption:= IDS_LBHPRD;
  lbHInf.Caption:= IDS_LBHINF;
  lbHSal.Caption:= IDS_LBHSAL;
  lbHPro.Caption:= IDS_LBHPRO;
  lbMarRep.Caption:= IDS_LBMARREP;
  lbPri.Caption:= IDS_LBPRI;
  lbPro.Caption:= IDS_LBPRO;
  lbPay.Caption:= IDS_LBPAY;
  lbAdv.Caption:= IDS_LBADV;
  lbRes.Caption:= IDS_LBRES;
  lbRRev.Caption:= IDS_LBRREV;
  lbRCst.Caption:= IDS_LBRCST;
  lbRPay.Caption:= IDS_LBRPAY;
  lbRAdv.Caption:= IDS_LBRADV;
  lbRRes.Caption:= IDS_LBRRES;
  lbRPro.Caption:= IDS_LBRPRO;
  lbRCas.Caption:= IDS_LBRCAS;
  gbOpPe.Caption:= IDS_GBOPPE;
  gbDeci.Caption:= IDS_GBDECI;
  gbOpRe.Caption:= IDS_GBOPRE;
  btExecute.Caption:= IDS_BTEXEC;
  btMarRep.Caption:= IDS_BTMARREP;
end;

end.

