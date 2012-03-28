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
unit FStampaStatistiche;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DTabaC,
  Forms, Dialogs, DBTables, DB, StdCtrls, Buttons, Mask,
  eReport, JvExMask, JvToolEdit;

type
  TfmStampaStatistiche = class(TForm)
    btCancel: TBitBtn;
    Report: TeLineReport;
    tbTaba: TTable;
    tbTabaCODI: TSmallintField;
    tbTabaCODS: TStringField;
    tbTabaTIPO: TSmallintField;
    tbTabaPROD: TSmallintField;
    tbTabaCRIT: TSmallintField;
    tbTabaDESC: TStringField;
    tbTabaATTV: TBooleanField;
    tbTabaMULI: TSmallintField;
    tbTabaQTAS: TSmallintField;
    tbTabaQTAC: TSmallintField;
    tbTabaQTAM: TSmallintField;
    tbTabaDIFR: TSmallintField;
    Label2: TLabel;
    cbOrder: TComboBox;
    btExport: TBitBtn;
    btPrint: TBitBtn;
    btPreview: TBitBtn;
    cbSoloAttivi: TCheckBox;
    Label1: TLabel;
    Label3: TLabel;
    iDataI: TJvDateEdit;
    iDataF: TJvDateEdit;
    procedure FormCreate(Sender: TObject);
    procedure ReportPageHeader(Rep: TeLineReport);
    procedure ReportSetupDevice(Rep: TeLineReport; Dev: TOutputDevice);
    procedure cbOrderChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PrintReport(Sender: TObject);
    procedure ReportHeader(Rep: TeLineReport);
  private
    { Private declarations }
    DataI: TDateTime;
    DataF: TDateTime;
    GiacI: TGiacSearchRec;
    GiacF: TGiacSearchRec;
    Cari: TCariSearchRec;
    Cons: TPatCSearchRec;
    Ordi: TOrdiSearchRec;
    POrd: TPatOSearchRec;
    procedure WriteRow(Report: TeLineReport);
    procedure PrintData;
  public
    { Public declarations }
  end;

procedure StampaStatistiche;

implementation

{$R *.DFM}

uses
  eLibCore, UOpzioni;

procedure StampaStatistiche;
var
  fmStampaStatistiche: TfmStampaStatistiche;
begin
  fmStampaStatistiche:= TfmStampaStatistiche.Create(nil);
  try
    fmStampaStatistiche.ShowModal;
  finally
    fmStampaStatistiche.Free;
  end;
end;

procedure TfmStampaStatistiche.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
end;

procedure TfmStampaStatistiche.WriteRow(Report: TeLineReport);
  function getAttiv: string;
  begin
    if tbTabaAttv.Value then begin
      Result:= ' ';
    end
    else begin
      Result:= '*';
    end;
  end;
var
  Row: string;
  CodI: integer;
  Mul: longint;
  GiaI, GiaF, Car, Con, Ven, Ord, POr: double;
begin
  CodI:= tbTabaCodI.Value;
  Mul:= tbTabaQtaC.Value;
  GiaI:= dmTaba.GetGiacenza(GiacI, CodI) / Mul;
  GiaF:= dmTaba.GetGiacenza(GiacF, CodI) / Mul;
  Car := dmTaba.GetCarichi(Cari, CodI) / Mul;
  Con := dmTaba.GetPatCons(Cons, CodI) / Mul;
  Ven := ((GiaI + Car) - (GiaF + Con));
  Ord := dmTaba.GetOrdinato(Ordi, CodI) / Mul;
  POr := dmTaba.GetPatOrdi(POrd, CodI) / Mul;
  Row:= Format('%5d %4s %1s%-30s %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f',
   [CodI, tbTabaCodS.Value, getAttiv, tbTabaDesc.Value,
     GiaI, Car, Con, GiaF, Ven, Ord, POr]);
  Report.WriteLine(Row);
end;

procedure TfmStampaStatistiche.PrintData;
var
  temp: TDateTime;
begin
  try
    DataI:= iDataI.Date;
    if (DataI=0) then DataI:= NoDate;
    DataF:= iDataF.Date;
    if (DataF=0) then DataF:= NoDate;
    GiacI:= dmTaba.FindGiacenza(DataI, false); DataI:= GiacI.Data;
    GiacF:= dmTaba.FindGiacenza(DataF, false); DataF:= GiacF.Data;
    if (DataI=NoDate) or (DataF=NoDate) or (DataI=DataF) then begin
      ShowMessage('Nessun dato da stampare');
      exit;
    end;
    if (DataI>DataF) then begin
      temp:= DataI;
      DataI:= DataF;
      DataF:= temp;
    end;
    Cari:= dmTaba.FindCarichi(DataI, DataF);
    Cons:= dmTaba.FindPatCons(DataI, DataF);
    Ordi:= dmTaba.FindOrdini(DataI, DataF, false);
    POrd:= dmTaba.FindPatOrdi(DataI, DataF, false);
    Report.BeginReport;
    tbTaba.Open;
    try
      tbTaba.First;
      while not tbTaba.EOF do begin
        if (not cbSoloAttivi.Checked) or (tbTabaAttv.Value) then begin
          WriteRow(Report);
        end;
        tbTaba.Next;
      end;
      Report.EndReport;
    except
      Report.AbortReport;
    end;
    tbTaba.Close;
    ModalResult:= mrOk;
  finally
    Cari.Free;
    Cons.Free;
    Ordi.Free;
    POrd.Free;
  end;
end;

procedure TfmStampaStatistiche.ReportPageHeader(Rep: TeLineReport);
begin
  with Rep do begin
    WriteLine('RIEPILOGO STATISTICHE TABACCHI - PAG.'+IntToStr(CurPag));
    WritePattern('-');
    LineFeed;
  end;
end;

procedure TfmStampaStatistiche.ReportSetupDevice(Rep: TeLineReport;
  Dev: TOutputDevice);
begin
  dmTaba.SetupReportDevice(Rep, Dev);
end;

procedure TfmStampaStatistiche.cbOrderChange(Sender: TObject);
begin
  tbTaba.IndexName:= dmTaba.DecodeOrder(cbOrder.ItemIndex);
end;

procedure TfmStampaStatistiche.FormShow(Sender: TObject);
var
  yy, mm, dd: word;
begin
  cbOrder.ItemIndex:= dmTaba.EncodeOrder('');
  cbOrder.OnChange(nil);
  iDataF.Date:= Date;
  DecodeDate(Date, yy, mm, dd);
  iDataI.Date:= EncodeDate(yy, 1, 1);
end;

procedure TfmStampaStatistiche.PrintReport(Sender: TObject);
begin
       if Sender = btExport then Report.DeviceKind:= 'TextFile'
  else if Sender = btPrint  then Report.DeviceKind:= 'Printer'
  else Report.DeviceKind:= 'Preview';
  PrintData;
end;

procedure TfmStampaStatistiche.ReportHeader(Rep: TeLineReport);
var
  PreKgC, CurKgC: double;
  PreVal, CurVal: double;
  VenKgC, VenVal: double;
  tmp: string;
begin
  Rep.LineFeed;
  if DataI <> NoDate then begin
    tmp:= Format('dal %s al %s', [DateUtil.myDateToStr(DataI), DateUtil.myDateToStr(DataF)]);
  end
  else begin
    tmp:= Format('fino al %s', [DateUtil.myDateToStr(DataF)]);
  end;
  Rep.WriteLine('Dati Riepilogativi del periodo '+tmp);
  Rep.WritePattern('-=');
  dmTaba.InfoGiacenza(GiacI, PreKgC, PreVal, CurKgC, CurVal);
  VenVal:= CurVal; VenKgC:= CurKgC;
  Rep.WriteLine(Format('Giacenza Iniziale          : %16.2f KgC %16m prezzi del %s', [CurKgC, CurVal, DateToStr(GiacI.DataPrezzi)]));
  dmTaba.InfoCarichi(Cari, CurKgC, CurVal);
  VenVal:= VenVal+CurVal; VenKgC:= VenKgC+CurKgC;
  Rep.WriteLine(Format('Totale carichi             : %16.2f KgC %16m', [CurKgC, CurVal]));
  dmTaba.InfoPatCons(Cons, CurKgC, CurVal);
  VenVal:= VenVal-CurVal; VenKgC:= VenKgC-CurKgC;
  Rep.WriteLine(Format('Totale consegne a patentini: %16.2f KgC %16m', [CurKgC, CurVal]));
  dmTaba.InfoGiacenza(GiacF, PreKgC, PreVal, CurKgC, CurVal);
  VenVal:= VenVal-CurVal; VenKgC:= VenKgC-CurKgC;
  Rep.WriteLine(Format('Giacenza Finale            : %16.2f KgC %16m prezzi del %s', [CurKgC, CurVal, DateToStr(GiacF.DataPrezzi)]));
  Rep.WriteLine(Format('Totale vendite             : %16.2f KgC %16m', [VenKgC, VenVal]));
  Rep.LineFeed;
  Rep.LineFeed;
  Rep.WriteLine('_Cod_ Cod. _Descrizione Tabacco___________ Gia.Ini. _Carico_ _Conse._ Gia.Fin. _Venduto Ordinato Ord.Pat.');
end;

end.

