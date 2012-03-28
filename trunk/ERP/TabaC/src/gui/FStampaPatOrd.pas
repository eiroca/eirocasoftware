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
unit FStampaPatOrd;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DTabaC,
  Forms, Dialogs, DBTables, DB, StdCtrls, Buttons, eReport;

type
  TfmStampaRichiesto = class(TForm)
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
    tbList: TTable;
    tbListPPCO: TAutoIncField;
    tbListCODP: TIntegerField;
    tbListDATA: TDateField;
    tbListDATAORDI: TDateField;
    tbListDATAPREZ: TDateField;
    tbListKGC: TFloatField;
    tbListVAL: TCurrencyField;
    tbPate: TTable;
    tbPateCODP: TAutoIncField;
    tbPateNOME: TStringField;
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
    POSR : TPatOSearchRec;
    procedure WriteRow(Report: TeLineReport);
    procedure PrintData;
  public
    { Public declarations }
  end;

procedure StampaRichiesto;

implementation

{$R *.DFM}

uses
  eLibCore, uOpzioni;

procedure StampaRichiesto;
var
  fmStampaRichiesto: TfmStampaRichiesto;
begin
  fmStampaRichiesto:= TfmStampaRichiesto.Create(nil);
  try
    fmStampaRichiesto.ShowModal;
  finally
    fmStampaRichiesto.Free;
  end;
end;

procedure TfmStampaRichiesto.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
end;

procedure TfmStampaRichiesto.WriteRow(Report: TeLineReport);
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
  CodI, Ordi: longint;
begin
  CodI:= tbTabaCodI.Value;
  Ordi:= dmTaba.GetPatOrdi(POSR, CodI);
  if (Ordi > 0) then begin
    Row:= Format('%5d %4s %1s%-60s %8d %8.2f',
     [CodI, tbTabaCodS.Value, getAttiv, tbTabaDesc.Value,
       Ordi, 0.0+Ordi/tbTabaQtaC.Value]);
    Report.WriteLine(Row);
  end;
end;

procedure TfmStampaRichiesto.PrintData;
var
  OldData: TDateTime;
begin
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

procedure TfmStampaRichiesto.ReportPageHeader(Rep: TeLineReport);
begin
  with Rep do begin
    WriteLine('RIEPILOGO RICHIESTE TABACCHI DA PARTE DEI PATENTINI - PAG.'+IntToStr(CurPag));
    WritePattern('-');
    LineFeed;
    WriteLine('__Codici__ _Descrizione tabacco_________________________________________ Quantità (Kg con.)');
  end;
end;

procedure TfmStampaRichiesto.ReportSetupDevice(Rep: TeLineReport;
  Dev: TOutputDevice);
begin
  dmTaba.SetupReportDevice(Rep, Dev);
end;

procedure TfmStampaRichiesto.cbOrderChange(Sender: TObject);
begin
  tbTaba.IndexName:= dmTaba.DecodeOrder(cbOrder.ItemIndex);
end;

procedure TfmStampaRichiesto.FormShow(Sender: TObject);
begin
  POSR:= dmTaba.FindPatOrdi(NoDate, NoDate, true);
  cbOrder.ItemIndex:= dmTaba.EncodeOrder('');
  cbOrder.OnChange(nil);
end;

procedure TfmStampaRichiesto.PrintReport(Sender: TObject);
begin
       if Sender = btExport then Report.DeviceKind:= 'TextFile'
  else if Sender = btPrint  then Report.DeviceKind:= 'Printer'
  else Report.DeviceKind:= 'Preview';
  PrintData;
end;

procedure TfmStampaRichiesto.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  POSR.Free;
  POSR:= nil;
end;

procedure TfmStampaRichiesto.ReportFooter(Rep: TeLineReport);
var
  KgC, Val: double;
  i: integer;
  function GetName(CodP: integer): String;
  begin
    Result:= '<<sconoscito>>';
    tbPate.Active:= true;
    if tbPate.FindKey([CodP]) then begin
      Result:= tbPateNOME.Value;
    end;
  end;
begin
  if (POSR.Count>0) then begin
    Rep.Reserve(4);
    Rep.LineFeed;
    Rep.WriteLine('Dati Riepilogativi Richieste da Patentini');
    Rep.WriteLine('----------------------------------------------------------------------------------------------');
    tbList.Active:= true;
    for i:= 0 to POSR.Count-1 do begin
      if tbList.FindKey([POSR.Cod[i]]) then begin
        Rep.WriteLine(Format('richiesta del %s di %-30s %14.2f KgC %16m', [DateUtil.MyDateToStr(tbListDATAORDI.Value), GetName(tbListCodP.Value), tbListKgC.Value, tbListVal.Value]));
      end;
    end;
    tbList.Active:= false;
    dmTaba.InfoPatOrdi(POSR, KgC, Val);
    Rep.WriteLine('                                                           --------------     ----------------');
    Rep.WriteLine(Format('                                                           %14.2f KgC %16m', [KgC, Val]));
  end;
end;

end.

