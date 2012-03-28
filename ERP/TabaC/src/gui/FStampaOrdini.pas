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
unit FStampaOrdini;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DTabaC,
  Forms, Dialogs, DBTables, DB, StdCtrls, Buttons, eReport;

type
  TfmStampaOrdinato = class(TForm)
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
    tbOrdiLst: TTable;
    tbOrdiLstPCAR: TAutoIncField;
    tbOrdiLstDATA: TDateField;
    tbOrdiLstDATAORDI: TDateField;
    tbOrdiLstDATAPREZ: TDateField;
    tbOrdiLstKGC: TFloatField;
    tbOrdiLstVAL: TCurrencyField;
    cbFullOrder: TCheckBox;
    cbFullSummary: TCheckBox;
    tbPOrdLst: TTable;
    tbPatNam: TTable;
    tbPatNamCODP: TAutoIncField;
    tbPatNamNOME: TStringField;
    tbPOrdLstPPCO: TAutoIncField;
    tbPOrdLstCODP: TIntegerField;
    tbPOrdLstDATA: TDateField;
    tbPOrdLstDATAORDI: TDateField;
    tbPOrdLstDATAPREZ: TDateField;
    tbPOrdLstKGC: TFloatField;
    tbPOrdLstVAL: TCurrencyField;
    tbPOrdLstPatNam: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure ReportPageHeader(Rep: TeLineReport);
    procedure ReportSetupDevice(Rep: TeLineReport; Dev: TOutputDevice);
    procedure cbOrderChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PrintReport(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReportFooter(Rep: TeLineReport);
  private
    { Private declarations }
    OSR : TOrdiSearchRec;
    POSR : TPatOSearchRec;
    procedure WriteRow(Report: TeLineReport);
    procedure PrintData;
  public
    { Public declarations }
  end;

procedure StampaOrdinato;

implementation

{$R *.DFM}

uses
  eLibCore, uOpzioni;

procedure StampaOrdinato;
var
  fmStampaOrdinato: TfmStampaOrdinato;
begin
  fmStampaOrdinato:= TfmStampaOrdinato.Create(nil);
  try
    fmStampaOrdinato.ShowModal;
  finally
    fmStampaOrdinato.Free;
  end;
end;

procedure TfmStampaOrdinato.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
end;

procedure TfmStampaOrdinato.WriteRow(Report: TeLineReport);
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
  CodI: longint;
  Ordi: longint;
  PRic: longint;
  Tota: longint;
begin
  CodI:= tbTabaCodI.Value;
  Ordi:= dmTaba.GetOrdinato(OSR, CodI);
  if (cbFullOrder.checked) then begin
    PRic:= dmTaba.GetPatOrdi(POSR, CodI);
    Tota:= PRic + Ordi;
  end
  else begin
    PRic:= 0;
    Tota:= Ordi;
  end;
  if (Ordi+PRic > 0) then begin
    if (cbFullOrder.checked) then begin
      Row:= Format('%5d %4s %1s%-60s %8d %8.2f %8d %8.2f %8d %8.2f',
       [CodI, tbTabaCodS.Value, getAttiv, tbTabaDesc.Value,
         Ordi, 0.0+Ordi/tbTabaQtaC.Value,
         PRic, 0.0+PRic/tbTabaQtaC.Value,
         Tota, 0.0+Tota/tbTabaQtaC.Value]);
    end
    else begin
      Row:= Format('%5d %4s %1s%-60s %8d %8.2f',
       [CodI, tbTabaCodS.Value, getAttiv, tbTabaDesc.Value,
         Ordi, 0.0+Ordi/tbTabaQtaC.Value]);
    end;
    Report.WriteLine(Row);
  end;
end;

procedure TfmStampaOrdinato.PrintData;
var
  OldData: TDateTime;
begin
  OSR:= dmTaba.FindOrdini(NoDate, NoDate, true);
  if (cbFullOrder.checked) then begin
    POSR:= dmTaba.FindPatOrdi(NoDate, NoDate, true);
  end;
  OldData:= dmTaba.DataPrezzi;
  try
    Report.BeginReport;
    tbTaba.Open;
    try
      tbTaba.First;
      while not tbTaba.EOF do begin
        WriteRow(Report);
        tbTaba.Next;
      end;
      Report.EndReport;
    except
      Report.AbortReport;
    end;
    tbTaba.Close;
    ModalResult:= mrOk;
  finally
    dmTaba.DataPrezzi:= OldData;
  end;
end;

procedure TfmStampaOrdinato.ReportPageHeader(Rep: TeLineReport);
begin
  with Rep do begin
    WriteLine('RICHESTA TABACCHI - PAG.'+IntToStr(CurPag));
    WritePattern('-');
    LineFeed;
    if (cbFullOrder.checked) then begin
      WriteLine('__Codici__ _Descrizione tabacco_________________________________________ _____Ordinato_____ _Richieste paten._ _Totale richiesta_ ');
    end
    else begin
      WriteLine('__Codici__ _Descrizione tabacco_________________________________________ Quantità (Kg con.)');
    end;
  end;
end;

procedure TfmStampaOrdinato.ReportSetupDevice(Rep: TeLineReport;
  Dev: TOutputDevice);
begin
  dmTaba.SetupReportDevice(Rep, Dev);
end;

procedure TfmStampaOrdinato.cbOrderChange(Sender: TObject);
begin
  tbTaba.IndexName:= dmTaba.DecodeOrder(cbOrder.ItemIndex);
end;

procedure TfmStampaOrdinato.FormShow(Sender: TObject);
begin
  cbOrder.ItemIndex:= dmTaba.EncodeOrder('');
  cbOrder.OnChange(nil);
end;

procedure TfmStampaOrdinato.PrintReport(Sender: TObject);
begin
       if Sender = btExport then Report.DeviceKind:= 'TextFile'
  else if Sender = btPrint  then Report.DeviceKind:= 'Printer'
  else Report.DeviceKind:= 'Preview';
  PrintData;
end;

procedure TfmStampaOrdinato.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  OSR.Free;
  OSR:= nil;
end;

procedure TfmStampaOrdinato.ReportFooter(Rep: TeLineReport);
var
  TotK, TotV: double;
  KgC, Val: double;
  i: integer;
begin
  if (OSR.Count>0) then begin
    Rep.Reserve(4);
    Rep.LineFeed;
    if cbFullSummary.Checked then begin
      Rep.WritePattern('-');
      Rep.WriteLine('Dati Riepilogativi');
      Rep.LineFeed;
      tbOrdiLst.Active:= true;
      for i:= 0 to OSR.Count-1 do begin
        if tbOrdiLst.FindKey([OSR.Cod[i]]) then begin
          Rep.WriteLine(Format('ordine del %s       %-30s %14.2f KgC %16m', [DateUtil.myDateToStr(tbOrdiLstDATAORDI.Value), '', tbOrdiLstKgC.Value, tbOrdiLstVal.Value]));
        end;
      end;
      tbOrdiLst.Active:= false;
      dmTaba.InfoOrdini(OSR, KgC, Val);
      tbOrdiLst.Active:= false;
      if (cbFullOrder.checked) then begin
        tbPatNam.Active:= true;
        tbPOrdLst.Active:= true;
        for i:= 0 to POSR.Count-1 do begin
          if tbPOrdLst.FindKey([POSR.Cod[i]]) then begin
            Rep.WriteLine(Format('richiesta del %s di %-30s %14.2f KgC %16m', [DateUtil.myDateToStr(tbPOrdLstDATAORDI.Value), tbPOrdLstPatNam.Value, tbPOrdLstKgC.Value, tbPOrdLstVal.Value]));
          end;
        end;
        tbPOrdLst.Active:= false;
        tbPatNam.Active:= false;
      end;
    end;
    Rep.WritePattern('-');
    dmTaba.InfoOrdini(OSR, KgC, Val);
    Rep.WriteLine(Format('Totale Ordini              : %14.2f KgC %16m', [KgC, Val]));
    if (cbFullOrder.checked) then begin
      TotK:= KgC;
      TotV:= Val;
      dmTaba.InfoPatOrdi(POSR, KgC, Val);
      TotK:= TotK + KgC;
      TotV:= TotV + Val;
      Rep.WriteLine(Format('Totale Richieste patentini : %14.2f KgC %16m', [KgC, Val]));
      Rep.WriteLine(Format('Totale Richiesta           : %14.2f KgC %16m', [TotK, TotV]));
    end;
  end;
end;

end.

