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
unit FStampaGiacenze;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DTabaC,
  Forms, Dialogs, DBTables, DB,  StdCtrls, Buttons, eReport;

type
  TfmStampaGiacenza = class(TForm)
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
    lbData: TLabel;
    cbSoloAttivi: TCheckBox;
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
    Data: TDateTime;
    GSR : TGiacSearchRec;
    procedure WriteRow(Report: TeLineReport);
    procedure PrintData;
  public
    { Public declarations }
  end;

procedure StampaGiacenza(Data: TDateTime);

implementation

{$R *.DFM}

uses
  eLibCore, UOpzioni;

procedure StampaGiacenza(Data: TDateTime);
var
  fmStampaGiacenza: TfmStampaGiacenza;
begin
  fmStampaGiacenza:= TfmStampaGiacenza.Create(nil);
  fmStampaGiacenza.Data:= Data;
  try
    fmStampaGiacenza.ShowModal;
  finally
    fmStampaGiacenza.Free;
  end;
end;

procedure TfmStampaGiacenza.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
end;

procedure TfmStampaGiacenza.WriteRow(Report: TeLineReport);
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
  Prez, CodI, Giac: longint;
begin
  CodI:= tbTabaCodI.Value;
  Giac:= dmTaba.GetGiacenza(GSR, CodI);
  Prez:= dmTaba.Prezzo[CodI];
  Row:= Format('%5d %4s %1s%-60s %8d %8.2f %14m',
   [CodI, tbTabaCodS.Value, getAttiv, tbTabaDesc.Value,
     Giac, 0.0+Giac/tbTabaQtaC.Value, 0.0+Giac*Prez]);
  Report.WriteLine(Row);
end;

procedure TfmStampaGiacenza.PrintData;
var
  OldData: TDateTime;
begin
  OldData:= dmTaba.DataPrezzi;
  dmTaba.DataPrezzi:= GSR.DataPrezzi;
  try
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
    dmTaba.DataPrezzi:= OldData;
  end;
end;

procedure TfmStampaGiacenza.ReportPageHeader(Rep: TeLineReport);
begin
  with Rep do begin
    WriteLine('GIACENZA DEL '+DateUtil.myDateToStr(Data)+' VALORIZZATA AI PREZZI DEL '+DateUtil.myDateToStr(GSR.DataPrezzi)+' - PAG.'+IntToStr(CurPag));
    WritePattern('-');
    LineFeed;
    WriteLine('__Codici__ _Descrizione tabacco_________________________________________ Quantità (Kg con.) ____Prezzo____');
  end;
end;

procedure TfmStampaGiacenza.ReportSetupDevice(Rep: TeLineReport; Dev: TOutputDevice);
begin
  dmTaba.SetupReportDevice(Rep, Dev);
end;

procedure TfmStampaGiacenza.cbOrderChange(Sender: TObject);
begin
  tbTaba.IndexName:= dmTaba.DecodeOrder(cbOrder.ItemIndex);
end;

procedure TfmStampaGiacenza.FormShow(Sender: TObject);
begin
  GSR:= dmTaba.FindGiacenza(Data, false);
  Data:= GSR.Data;
  lbData.Caption:= 'Giacenza del '+DateUtil.myDateToStr(Data);
  cbOrder.ItemIndex:= dmTaba.EncodeOrder('');
  cbOrder.OnChange(nil);
end;

procedure TfmStampaGiacenza.PrintReport(Sender: TObject);
begin
       if Sender = btExport then Report.DeviceKind:= 'TextFile'
  else if Sender = btPrint  then Report.DeviceKind:= 'Printer'
  else Report.DeviceKind:= 'Preview';
  PrintData;
end;

procedure TfmStampaGiacenza.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  GSR.Free;
  GSR:= nil;
end;

procedure TfmStampaGiacenza.ReportFooter(Rep: TeLineReport);
var
  PreKgC, CurKgC: double;
  PreVal, CurVal: double;
begin
  Rep.LineFeed;
  Rep.Reserve(4);
  Rep.WriteLine('Dati Riepilogativi');
  Rep.WriteLine('------------------');
  dmTaba.InfoGiacenza(GSR, PreKgC, PreVal, CurKgC, CurVal);
  Rep.WriteLine(Format('Giacenza in KgC Attuale (precendete): %16.2f (%16.2f)', [CurKgC, PreKgC]));
  Rep.WriteLine(Format('Valore          Attuale (precendete): %16m (%16m)', [CurVal, PreVal]));
end;

end.

