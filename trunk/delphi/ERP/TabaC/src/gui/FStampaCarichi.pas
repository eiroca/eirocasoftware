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
unit FStampaCarichi;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DTabaC,
  Forms, Dialogs, DBTables, DB, StdCtrls, Buttons, Grids,
  DBGrids, Mask, eReport, JvExMask, JvToolEdit;

type
  TfmStampaCarichi = class(TForm)
    btCancel: TBitBtn;
    Report: TeLineReport;
    Label2: TLabel;
    cbOrder: TComboBox;
    btExport: TBitBtn;
    btPrint: TBitBtn;
    btPreview: TBitBtn;
    qryDettagli: TQuery;
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
    qryDettagliDataPrez: TDateField;
    qryDettagliPrez: TCurrencyField;
    qryDettagliSumCar: TFloatField;
    iDataI: TJvDateEdit;
    Label1: TLabel;
    iDataF: TJvDateEdit;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ReportPageHeader(Rep: TeLineReport);
    procedure ReportSetupDevice(Rep: TeLineReport; Dev: TOutputDevice);
    procedure cbOrderChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PrintReport(Sender: TObject);
  private
    { Private declarations }
    DataI: TDateTime;
    DataF: TDateTime;
    procedure WriteRow(Report: TeLineReport);
    procedure PrintData;
  public
    { Public declarations }
  end;

procedure StampaCarichi;

implementation

{$R *.DFM}

uses
  eLibCore, eLibVCL,
  uOpzioni;

procedure StampaCarichi;
var
  fmStampaCarichi: TfmStampaCarichi;
begin
  fmStampaCarichi:= TfmStampaCarichi.Create(nil);
  try
    fmStampaCarichi.ShowModal;
  finally
    fmStampaCarichi.Free;
  end;
end;

procedure TfmStampaCarichi.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
end;

procedure TfmStampaCarichi.WriteRow(Report: TeLineReport);
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
  Prez: double;
  Qta: integer;
begin
  CodI:= tbTabaCodI.Value;
  qryDettagli.ParamByName('CodI').AsInteger:= CodI;
  qryDettagli.Open;
  try
    while (not qryDettagli.EOF) do begin
      Prez:= qryDettagliPrez.Value;
      Qta := qryDettagliSumCar.AsInteger;
      if (Qta>0) then begin
        Row:= Format('%5d %4s %1s%-60s %10s %10m %8d %18m',
         [CodI, tbTabaCodS.Value, getAttiv, tbTabaDesc.Value,
          qryDettagliDataPrez.AsString,
          Prez,
          Qta,
          Prez * Qta]);
        Report.WriteLine(Row);
      end;
      qryDettagli.Next;
    end;
  finally
    qryDettagli.Close;
  end;
end;

procedure TfmStampaCarichi.PrintData;
var
  Prog: TProgress;
begin
  tbTaba.Open;
  Prog:= TProgress.Create(1, tbTaba.RecordCount);
  try
    DataI:= iDataI.Date;
    DataF:= iDataF.Date;
    qryDettagli.ParamByName('DataI').AsDate:= DataI;
    qryDettagli.ParamByName('DataF').AsDate:= DataF;
    Report.BeginReport;
    try
      tbTaba.First;
      while not tbTaba.EOF do begin
        WriteRow(Report);
        tbTaba.Next;
        Prog.Step;
        if (Prog.Aborted) then begin
          break;
        end;
      end;
      Report.EndReport;
    except
      Report.AbortReport;
    end;
    tbTaba.Close;
    ModalResult:= mrOk;
  finally
    Prog.Free;
  end;
end;

procedure TfmStampaCarichi.ReportPageHeader(Rep: TeLineReport);
begin
  with Rep do begin
    WriteLine('ELENCO CARICHI TABACCHI DAL '+DateUtil.MyDateToStr(DataI)+' AL '+DateUtil.MyDateToStr(DataF)+' - PAG.'+IntToStr(CurPag));
    WritePattern('-');
    LineFeed;
    WriteLine('__Codici__ _Descrizione tabacco_________________________________________ Data Prez. __Prezzo__ _Carico_ ___Valore carico__');
  end;
end;

procedure TfmStampaCarichi.ReportSetupDevice(Rep: TeLineReport;
  Dev: TOutputDevice);
begin
  dmTaba.SetupReportDevice(Rep, Dev);
end;

procedure TfmStampaCarichi.cbOrderChange(Sender: TObject);
begin
  tbTaba.IndexName:= dmTaba.DecodeOrder(cbOrder.ItemIndex);
end;

procedure TfmStampaCarichi.FormShow(Sender: TObject);
begin
  cbOrder.ItemIndex:= dmTaba.EncodeOrder('');
  cbOrder.OnChange(nil);
  iDataI.Date:= DateUtil.ChangeDay(Date, 0, 1, 1);
  iDataF.Date:= DateUtil.ChangeDay(Date, 0, 12, 31);
end;

procedure TfmStampaCarichi.PrintReport(Sender: TObject);
begin
       if Sender = btExport then Report.DeviceKind:= 'TextFile'
  else if Sender = btPrint  then Report.DeviceKind:= 'Printer'
  else Report.DeviceKind:= 'Preview';
  PrintData;
end;


end.

