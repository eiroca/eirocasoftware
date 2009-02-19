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
unit WidgetGame;

interface

uses
  Classes, SysUtils;

const
  WGM_NOCASH = 0;
  WGM_STRIKE = 1;
  WGM_NOEMP  = 2;
  WGM_BANKRP = 3;

type
  EVENT = (WFLNONE, WFLFIRE, WFLTRAN, WFLMAJR1, WFLCSTDW, WFLPRDUP, WFLCSTUP,
  WFLEMPUP, WFLEMPDW, WFLSLLUP, WFLMAJR2, WMSTRIKE, WMNOCASH, WMNOEMP, WMBANKRP);

var
  MsgDesc: array[EVENT] of String;

type

  TWidgetGame = class;

  TNotifyGamePhase = procedure(Sender: TWidgetGame) of object;
  TNotifyGameEvent = procedure(Sender: TWidgetGame; Kind: integer; const Msg: string) of object;

  TFlashEvent = record
    Kind: integer;
    Param: double;
  end;

  TLevel = record
    q: double;
    y: double;
  end;

  TWidgetGame = class
    private
     fOnStartGame: TNotifyGamePhase;
     fOnStartQuarter: TNotifyGamePhase;
     fOnEndQuarter: TNotifyGamePhase;
     fOnEndGame: TNotifyGamePhase;
     fOnFlashReport: TNotifyGameEvent;
     fOnGameEvent: TNotifyGameEvent;
    private
     SldFlg: boolean;
     Flash: TFlashEvent;
    public
     Bankrupt: boolean;
     Turns   : integer;
     Quarter : integer;
     MktRepCost: integer;
     OldEmpl: integer;
     OldIvty: integer;
     OldSale: integer;
     OldUCst: double;
     OldSlry: double;
     Empl : integer;
     Ivty : integer;
     Sale : integer;
     UCst : double;
     Slry : double;
     CumRev: integer;
     CumPft: integer;
     CumEmp: integer;
     CumLft: integer;
     NewEmp: integer;
     LftEmp: integer;
     Profit: integer;
     Revenue : integer;
     Prdn : double;
     Fltn : double;
     PA_D : double;
     Cash : integer;
     MCst : integer;
     RCst : integer;
     RptC : integer;
     ReDeIdx: array[1..5] of TLevel;
     PriIdx: array[1..7] of TLevel;
     AdsIdx: array[1..8] of TLevel;
     dPayroll: double;
     dPrice: double;
     dAdvert: double;
     dProduction: double;
     dResDev: double;
    public
     constructor Create(aTurns: integer);
     procedure StartGame;
     procedure StartQuarter;
     function  SetDecision(aPric, aProd, aPayr, aAdve, aReDe: double): boolean;
     procedure EndQuarter;
     procedure EndGame;
    private
     procedure BuildIndex;
     procedure FlashReport;
     procedure CalcResult;
    public
     property OnStartGame: TNotifyGamePhase read fOnStartGame write fOnStartGame;
     property OnStartQuarter: TNotifyGamePhase read fOnStartQuarter write fOnStartQuarter;
     property OnEndQuarter: TNotifyGamePhase read fOnEndQuarter write fOnEndQuarter;
     property OnEndGame: TNotifyGamePhase read fOnEndGame write fOnEndGame;
     property OnFlashReport: TNotifyGameEvent read fOnFlashReport write fOnFlashReport;
     property OnGameEvent: TNotifyGameEvent read fOnGameEvent write fOnGameEvent;
  end;

implementation

constructor TWidgetGame.Create(aTurns: integer);
begin
  Turns:= aTurns;
end;

(* CALCULATE BUSINESS INDEXES *)
procedure TWidgetGame.BuildIndex;
var
  q: double;
  f: integer;
  temp: integer;
  AMT: double;
  RN: double;
begin
  (* PRICE SENSITIVITY *)
  q:= 1.0;
  for F:= 1 to 6 do begin
    PriIdx[F].q:= q;
    if F < 3 then q:= q - 0.15 else q:= q - 0.10;
  end;
  PriIdx[7].q:= 0;
  temp:= Random(7) + 6; (* RANGE 6-12 *)
  PriIdx[1].y:=  9.95;
  PriIdx[7].y:= 29.95;
  PriIdx[4].y:= temp + 9.95;
  PriIdx[6].y:= PriIdx[4].y + ((PriIdx[7].y - PriIdx[4].y) * 0.5);
  PriIdx[5].y:= PriIdx[4].y + ((PriIdx[6].y - PriIdx[4].y) * 0.5);
  PriIdx[2].y:= PriIdx[1].y + ((PriIdx[4].y - PriIdx[1].y) * 0.5);
  PriIdx[3].y:= PriIdx[2].y + ((PriIdx[4].y - PriIdx[2].y) * 0.5);
  (* ADVTSG INDEX *)
  q:= 1.0;
  AdsIdx[1].q:= 0.0;
  for f:= 2 to 8 do begin
    AdsIdx[f].q:= q; if f < 5 then q:= q + 0.20;
    if f > 4 then q:= q + 0.10;
  end;
  temp:= Random(50) + 75; (* RANGE 75-124 *)
  AdsIdx[1].y:=  25;
  AdsIdx[4].y:= temp;
  AdsIdx[8].y:= 200;
  AdsIdx[2].y:= INT((AdsIdx[4].y - AdsIdx[1].y) * 0.5) + AdsIdx[1].y;
  AdsIdx[3].y:= INT((AdsIdx[4].y - AdsIdx[2].y) * 0.5) + AdsIdx[2].y;
  AdsIdx[6].y:= INT((AdsIdx[8].y - AdsIdx[4].y) * 0.5) + AdsIdx[4].y;
  AdsIdx[5].y:= INT((AdsIdx[6].y - AdsIdx[4].y) * 0.5) + AdsIdx[4].y;
  AdsIdx[7].y:= INT((AdsIdx[8].y - AdsIdx[6].y) * 0.5) + AdsIdx[6].y;
  (* R&D INDEX *)
  AMT:= 0.30;
  temp:= 25;
  for F:= 1 to 5 do begin
    temp:= temp + 25;
    RN:= Random(25) + 1;
    ReDeIdx[F].y:= temp + RN;
    ReDeIdx[F].q:= AMT;
    AMT:= AMT - 0.15;
  end;
  (* PRICE/AD IMPACT *)
  PA_D:= (Random(30) + 40) * 0.01;
end;

(* Flash report *)
procedure TWidgetGame.FlashReport;
var
  fa: integer;
  msg: string;
begin
  msg:= '';
  Flash.Kind:= 0;
  Flash.Param:= 0;
  FA:= random(20) + 1; (* 1-20 *)
  if FA > 10 then FA:= 11;
  Flash.Kind:= FA;
  case FA of
    1: begin
      Flash.Param:= random(100) + 125;
      msg:= Format(MsgDesc[WFLFIRE], [Flash.Param]);
    end;
    2: begin
      Flash.Param:= random(20) + 10;
      msg:= Format(MsgDesc[WFLTRAN], [Flash.Param]);
    end;
    3: begin
      Flash.Param:= INT(random(1) * 15) + 20;
      Msg:= Format(MsgDesc[WFLMAJR1], [Flash.Param]);
    end;
    4: begin
      Flash.Param:= 1;
      Msg:= Format(MsgDesc[WFLCSTDW], [Flash.Param]);
    end;
    5: begin
      Flash.Param:= 1;
      Msg:= Format(MsgDesc[WFLPRDUP], [Flash.Param]);
    end;
    6: begin
      Flash.Param:= (random(150) + 100) * 0.01;
      Msg:= Format(MsgDesc[WFLCSTUP], [Flash.Param]);
    end;
    7: begin
      Flash.Param:= random(15) + 10;
      Msg:= Format(MsgDesc[WFLEMPUP], [Flash.Param]);
    end;
    8: begin
      Flash.Param:= random(11) + 5;
      Msg:= Format(MsgDesc[WFLEMPDW], [Flash.Param]);
    end;
    9: begin
      Flash.Param:= random(11) + 20;
      Msg:= Format(MsgDesc[WFLSLLUP], [Flash.Param]);
    end;
    10: begin
      Flash.Param:= 1;
      Msg:= Format(MsgDesc[WFLMAJR2], [Flash.Param]);
    end;
    else begin
      Msg:= Format(MsgDesc[WFLNONE], [0.0]);
    end;
  end;
  if Assigned(fOnFlashReport) then OnFlashReport(Self, FA, Msg);
end;

(*  [ OPERATING RESULT ] *)
procedure TWidgetGame.CalcResult;
var
  f: integer;
  Hit: integer;
  SPrd: double;
  HPft: double;
  tmp: string;
  AdsEffect: double;
  PriceEffect: double;
  SL: double;
  MinPay: double;
begin
  OldEmpl:= Empl;
  OldIvty:= Ivty;
  OldUCst:= UCst;
  OldSale:= Sale;
  OldSlry:= Slry;
  if OldSale = 0 then OldSale:= 1;
  if OldIvty = 0 then OldIvty:= 1;
  if (dResDev < ReDeIdx[2].y) then UCst:= UCst * 1.30;
  if (dResDev >= ReDeIdx[2].y) and (dResDev < ReDeIdx[3].y) then UCst:= UCst * 1.15;
  if (dResDev >= ReDeIdx[4].y) and (dResDev < ReDeIdx[5].y) then UCst:= UCst * 0.85;
  if (dResDev >= ReDeIdx[5].y) then UCst:= UCst * 0.7;
  if Flash.Kind = 1 then begin
    dProduction:= INT(dProduction * 0.5);
    MCst:= MCst + trunc(Flash.Param); (*  Flash 1..add fire cost to mfg *)
  end;
  if Flash.Kind = 4 then UCst:= UCst - 1; (* Flash 4.. REDUCE UNIT COST *)
  if Flash.Kind = 6 then MCst:= MCst + trunc(dProduction * Flash.Param); (* Flash 6.. ADDED REWORK COST PER PRODUCTION *)
  if UCst < 9 then UCst:= 9;
  Ivty:= Ivty + trunc(dProduction);
  MCst:= MCst + trunc(dProduction * UCst); (* MFG -> INVENTORY and MFG COST *)
  if Flash.Kind = 7 then NewEmp:= trunc(Flash.Param); (* Flash 7.. ADDED EMPLOYEES *)
  if Flash.Kind = 8 then LftEmp:= trunc(Flash.Param); (* Flash 8.. LOST EMPLOYEES *)
  RCst:= trunc(dResDev) + RptC; (* add mkt report to r&d cost *)
  Hit:= 1;
  if dPrice < PriIdx[2].y then Hit:= 1
  else if dPrice >= PriIdx[7].y then Hit:= 7
  else begin
    for F:= 2 to 6 do begin
      if (dPrice >= PriIdx[F].y) and (dPrice < PriIdx[F + 1].y) then begin
        Hit:= F;
        break;
      end;
    end;
  end;
  PriceEffect:= PriIdx[Hit].q; (* price effect % *)
  Hit:= 1;
  if dAdvert < AdsIdx[2].y then Hit:= 1
  else if dAdvert >= AdsIdx[8].y then Hit:= 8
  else begin
    for F:= 2 to 7 do begin
      if (dAdvert >= AdsIdx[F].y) and (dAdvert < AdsIdx[F + 1].y) then begin
        Hit:= F;
        break;
      end;
    end;
  end;
  AdsEffect:= AdsIdx[Hit].q; (* advtsg effect % *)
  SL:= (PriceEffect * PA_D) + (AdsEffect * (1 - PA_D)); (* sale % of inventory *)
  if Flash.Kind = 3 then begin
    SL:= 1;
    dPrice:= Flash.Param; (* falsh 3.. SELL 100% OF INVENTORY *)
  end;
  if SL > 1 then SL:= 1;
  Sale:= trunc(Ivty * SL); (* basic sales volume *)
  if (dPrice >= 30) and (Flash.Kind <> 3) then Sale:= 0;
  if Flash.Kind = 2 then Sale:= trunc(Sale * ((100 - Flash.Param) * 0.01)); (* Flash 2... REDUCED SALES TRANSPORTATION SHUTDOWN *)
  if Flash.Kind = 9 then Sale:= Sale + trunc(Sale * Flash.Param * 0.01); (* Flash 9... ADDED SALES *)
  if Sale > Ivty then Sale:= Ivty;
  if Flash.Kind = 5 then begin
    Slry:= Slry * 1.25;
    Prdn:= Prdn + 1; (* Flash 5... BENEFITS PLAN EFFECT *)
  end;
  if SldFlg  then begin (* All products sold *)
    SldFlg:= false;
    Sale:= Ivty;
    dPrice:= 29.95;
  end;
  (* REVENUE CALCULATION *)
  Revenue:= trunc(Sale * dPrice);
  Ivty:= Ivty - Sale;
  if Flash.Kind = 10 then SldFlg:= true; (* Flash 10.. SELL OUT FLAG NEXT PERIOD *)
  MinPay:= Empl * Slry; (* min payroll *)
  if dPayroll >= MinPay then NewEmp:= NewEmp + round((dPayroll - MinPay) * 0.1) + random(10); (* added manufactures *)
  if dPayroll < MinPay then LftEmp:= LftEmp + round((MinPay - dPayroll) * 0.1) + random(4); (* lost manufactures *)
  if LftEmp > (Empl + NewEmp) then LftEmp:= Empl + NewEmp; (* avoid neg employees *)
  Empl:= Empl + NewEmp - LftEmp;
  Fltn:= random * 3 + 1; (* INFLATION 1-3% *)
  UCst:= UCst + (UCst * (Fltn * 0.01));
  Slry:= Slry + (Slry * (Fltn * 0.01)); (* INFLATION EFFECT *)
  HPft:= random(500) + 500; (* EXCESS PROFIT *)
  Profit:= Revenue - trunc(dPayroll) - MCst - trunc(dAdvert) - RCst; (* PROFIT:= Revn - PAYROLL - MFG - ADVTSG - R&D *)
  if (Profit > HPft) and (random < 0.5) then HPft:= Profit;
  if (Profit > HPft) then begin
    tmp:= Format(MsgDesc[WMSTRIKE], [Profit]);
    Profit:= Profit div 2;
    Slry:= Slry + 1;
    if Assigned(fOnGameEvent) then OnGameEvent(Self, WGM_STRIKE, tmp);
  end;
  Cash:= Cash + Profit;
  UCst:= INT(UCst * 100 + 0.5) * 0.01;
  Fltn:= INT(Fltn * 100 + 0.5) * 0.01;
  Slry:= INT(Slry * 100 + 0.5) * 0.01;
  if Cash <= 0 then begin
    SPrd:= 1;
    while (Cash <= 0) do begin
      Cash:= Cash + 500;
      Prdn:= INT((Prdn / 2) * 100 + 0.5) * 0.01;
      SPrd:= SPrd * 0.5;
    end;
    tmp:= Format(MsgDesc[WMNOCASH], [trunc((1 - SPrd) * 100)]);
    if Assigned(fOnGameEvent) then OnGameEvent(Self, WGM_NOCASH, tmp);
  end;
  if Empl <= 0 then begin
    Cash:= Cash div 2;
    Empl:= round(Cash / (Slry * 1.3));
    dPayroll:= dPayroll + Cash;
    NewEmp:= NewEmp + Empl;
    tmp:= Format(MsgDesc[WMNOEMP], [Cash]);
    if Assigned(fOnGameEvent) then OnGameEvent(Self, WGM_NOEMP, tmp);
  end;
  if Prdn < 0.5 then begin
    Bankrupt:= true;
    tmp:= Format(MsgDesc[WMBANKRP], [0]);
    if Assigned(fOnGameEvent) then OnGameEvent(Self, WGM_BANKRP, tmp);
  end;
  UCst:= INT(UCst * 100 + 0.5) * 0.01;
end;

procedure TWidgetGame.StartGame;
begin
  SldFlg:= false;
  Bankrupt:= false;
  Quarter := 1;
  MktRepCost:= 50;
  Empl:= 50;
  Ivty:= 50;
  Cash:= 750;
  UCst:= 12;
  Prdn:= 2;
  Fltn:= 1;
  Slry:= 8;
  CumPft:= 0;
  CumRev:= 0;
  if Assigned(fOnStartGame) then OnStartGame(Self);
  StartQuarter;
end;

procedure TWidgetGame.StartQuarter;
begin
  Revenue:= 0;
  Profit:= 0;
  MCst:= 0;
  RCst:= 0;
  LftEmp:= 0;
  NewEmp:= 0;
  RptC:= 0;
  BuildIndex;
  if Assigned(fOnStartQuarter) then OnStartQuarter(Self);
end;

function TWidgetGame.SetDecision(aPric, aProd, aPayr, aAdve, aReDe: double): boolean;
begin
  dPayroll:= aPayr;
  dPrice:= aPric;
  dAdvert:= aAdve;
  dProduction:= aProd;
  dResDev:= aReDe;
  if aProd > (Empl * Prdn) then begin
    Result:= false;
  end
  else if (aPayr + aAdve + aReDe + RptC) > Cash then begin
    Result:= false;
  end
  else begin
    Result:= true;
  end;
end;

procedure TWidgetGame.EndQuarter;
begin
  FlashReport; (*  Flash report *)
  CalcResult;  (*  CALC OPERATING RESULTS *)
  MktRepCost:= trunc(MktRepCost * 1.25);
  CumRev:= CumRev + Revenue;
  CumPft:= CumPft + Profit;
  CumLft:= CumLft + LftEmp;
  CumEmp:= CumEmp + Empl;
  if (not Bankrupt) and (Assigned(fOnEndQuarter)) then OnEndQuarter(Self);
  (* CHECK END OF TERM OR BANKRUPTCY *)
  Quarter := Quarter + 1;
  if (Bankrupt) or (Quarter > Turns) then begin
    EndGame;
  end;
end;

procedure TWidgetGame.EndGame;
begin
  if Assigned(fOnEndGame) then OnEndGame(Self);
end;

var
  i: EVENT;
initialization
  for i := low(MsgDesc) to high(MsgDesc) do begin
    MsgDesc[i]:= 'x';
  end;
end.

