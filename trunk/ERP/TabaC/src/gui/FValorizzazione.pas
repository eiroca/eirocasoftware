(* GPL > 3.0
Copyright (C) 1986-2009 eIrOcA Elio & Enrico Croce, Simona Burzio

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
(* TabaC - Gestione Tabacchi
 * Ultima modifica: 06 nov 1999
 *)
unit FValorizzazione;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Db, DBTables, Grids, XStrGrds, StdCtrls, JvExControls, JvDBLookup;

type
  TfmValorizzazione = class(TForm)
    tbGiacDate: TTable;
    tbGiacDatePGIA: TIntegerField;
    tbGiacDateDATA: TDateField;
    tbGiacDateDATAPREZ: TDateField;
    tbGiacDateKGC: TFloatField;
    tbGiacDateVAL: TCurrencyField;
    dsGiacDate: TDataSource;
    lcDataGiac: TJvDBLookupCombo;
    sgValo: TXStrGrid;
    lbInfo: TLabel;
    lbTotOrdi: TLabel;
    lbTotOPar: TLabel;
    lbDataPrezF: TLabel;
    lbDataPrezI: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lcDataGiacChange(Sender: TObject);
    procedure sgValoGetAlignment(Sender: TObject; ARow, ACol: Longint;
      var AAlignment: TAlignment);
  private
    { Private declarations }
    procedure ClearGrid;
  public
    { Public declarations }
    procedure UpdateData(Data: TDateTime);
  end;

procedure Valorizza;

implementation

{$R *.DFM}

uses
  DTabaC, eLibCore;

procedure TfmValorizzazione.FormCreate(Sender: TObject);
begin
  tbGiacDate.IndexFieldNames:='DATA';
end;

procedure TfmValorizzazione.FormShow(Sender: TObject);
var
  Ordi: TOrdiSearchRec;
  POrd: TPatOSearchRec;
  OrdiKgC, OrdiVal: double;
  POrdKgC, POrdVal: double;
begin
  ClearGrid;
  tbGiacDate.Open;
  tbGiacDate.Last;
  lcDataGiac.Value:= tbGiacDateData.AsString;
  Ordi:= nil;
  POrd:= nil;
  try
    Ordi:= dmTaba.FindOrdini(NoDate, NoDate, true);
    POrd:= dmTaba.FindPatOrdi(NoDate, NoDate, true);
    dmTaba.InfoOrdini(Ordi, OrdiKgC, OrdiVal);
    dmTaba.InfoPatOrdi(POrd, POrdKgC, POrdVal);
    lbTotOrdi.Caption:= Format('Ordini da ricevere %8.2f (%m)', [OrdiKgC, OrdiVal]);
    lbTotOPar.Caption:= Format('Consegne patentini da evadere %8.2f (%m)', [POrdKgC, POrdVal]);
  finally
    Ordi.Free;
    POrd.Free;
  end;
end;

procedure TfmValorizzazione.ClearGrid;
  var
  i, j: integer;
begin
  for i:= 1 to 3 do begin
    for j:= 1 to 3 do begin
      sgValo.Cells[i,j]:= '';
    end;
  end;
end;

procedure TfmValorizzazione.UpdateData(Data: TDateTime);
var
  GiacPreDataPrez: TDateTime;
  GiacPreKgC, GiacPreVal: double;
  GiacCurDataPrez: TDateTime;
  GiacCurKgC, GiacCurVal: double;
  ConsKgC, ConsVal: double;
  CariKgC, CariVal: double;
  OrdiKgC, OrdiVal: double;
  POrdKgC, POrdVal: double;
  Giac: TGiacSearchRec;
  Cari: TCariSearchRec;
  Cons: TPatCSearchRec;
  Ordi: TOrdiSearchRec;
  POrd: TPatOSearchRec;
  DataI: TDateTime;
begin
  ClearGrid;
  Giac:= nil;
  try
    Giac:= dmTaba.FindGiacenza(Data, true);
    if Giac.Exact then begin
      DataI:= dmTaba.InfoGiacenzaExt(Giac, GiacPreKgC, GiacPreVal, GiacPreDataPrez, GiacCurKgC, GiacCurVal, GiacCurDataPrez);
      lbDataPrezI.Caption:= DateUtil.MyDateToStr(GiacPreDataPrez);
      lbDataPrezF.Caption:= DateUtil.MyDateToStr(GiacCurDataPrez);
      if DataI <> NoDate then begin
        lbInfo.Caption:= Format('Valori dal %s al', [DateUtil.myDateToStr(DataI), DateUtil.myDateToStr(Data)]);
      end
      else begin
        lbInfo.Caption:= Format('Valori fino al', [DateUtil.myDateToStr(Data)]);
      end;
      Cari:= nil;
      Cons:= nil;
      Ordi:= nil;
      POrd:= nil;
      try
        Cari:= dmTaba.FindCarichi(DataI, Data);
        Cons:= dmTaba.FindPatCons(DataI, Data);
        Ordi:= dmTaba.FindOrdini(DataI, Data, false);
        POrd:= dmTaba.FindPatOrdi(DataI, Data, false);
        dmTaba.InfoCarichi(Cari, CariKgC, CariVal);
        dmTaba.InfoPatCons(Cons, ConsKgC, ConsVal);
        dmTaba.InfoOrdini(Ordi, OrdiKgC, OrdiVal);
        dmTaba.InfoPatOrdi(POrd, POrdKgC, POrdVal);
      finally
        Cari.Free;
        Cons.Free;
        Ordi.Free;
        POrd.Free;
      end;
      sgValo.Cells[1,1]:= Format('%9.3f', [GiacCurKgC]);
      sgValo.Cells[2,1]:= Format('%m', [GiacCurVal]);
      sgValo.Cells[1,2]:= Format('%9.3f', [GiacPreKgC]);
      sgValo.Cells[2,2]:= Format('%m', [GiacPreVal]);
      sgValo.Cells[1,3]:= Format('%9.3f', [CariKgC]);
      sgValo.Cells[2,3]:= Format('%m', [CariVal]);
      sgValo.Cells[1,4]:= Format('%9.3f', [ConsKgC]);
      sgValo.Cells[2,4]:= Format('%m', [ConsVal]);
      sgValo.Cells[1,5]:= Format('%9.3f', [GiacPreKgC+CariKgC-ConsKgC-GiacCurKgC]);
      sgValo.Cells[2,5]:= Format('%m',    [GiacPreVal+CariVal-ConsVal-GiacCurVal]);
      sgValo.Cells[1,7]:= Format('%9.3f', [OrdiKgC]);
      sgValo.Cells[2,7]:= Format('%m', [OrdiVal]);
      sgValo.Cells[1,8]:= Format('%9.3f', [POrdKgC]);
      sgValo.Cells[2,8]:= Format('%m', [POrdVal]);
    end
    else begin
      lbInfo.Caption:= 'Valori non disponibili';
    end;
  finally
    Giac.Free;
  end;
end;

procedure TfmValorizzazione.lcDataGiacChange(Sender: TObject);
var
  Data: TDateTime;
begin
  try
    Data:= StrToDate(lcDataGiac.Value);
  except
    on EConvertError do Data:= NoDate;
  end;
  if Data <> NoDate then UpdateData(Data);
end;

procedure Valorizza;
var
  fmValorizzazione: TfmValorizzazione;
begin
  fmValorizzazione:= TfmValorizzazione.Create(nil);
  try
    fmValorizzazione.ShowModal;
  finally
    fmValorizzazione.Free;
  end;
end;

procedure TfmValorizzazione.sgValoGetAlignment(Sender: TObject; ARow,
  ACol: Longint; var AAlignment: TAlignment);
begin
  if ARow = 0 then AAlignment:= taCenter
  else if ACol = 0 then AAlignment:= taLeftJustify
  else AAlignment:= taRightJustify;
end;


end.

