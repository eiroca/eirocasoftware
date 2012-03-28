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
unit FStampaTrend;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DTabaC,
  Forms, Dialogs, DBTables, DB, StdCtrls, Buttons, eReport, Mask, JvExMask,
  JvSpin;

type
  TfmStampaTendenze = class(TForm)
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
    iPeri: TJvSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure ReportPageHeader(Rep: TeLineReport);
    procedure ReportSetupDevice(Rep: TeLineReport; Dev: TOutputDevice);
    procedure cbOrderChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PrintReport(Sender: TObject);
  private
    { Private declarations }
    periodi: integer;
    procedure WriteRow(Report: TeLineReport);
    procedure PrintData;
  public
    { Public declarations }
  end;

procedure StampaTendenze;

implementation

{$R *.DFM}

uses
  eLibCore, uOpzioni;

procedure StampaTendenze;
var
  fmStampaTendenze: TfmStampaTendenze;
begin
  fmStampaTendenze:= TfmStampaTendenze.Create(nil);
  try
    fmStampaTendenze.ShowModal;
  finally
    fmStampaTendenze.Free;
  end;
end;

procedure TfmStampaTendenze.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
end;

procedure TfmStampaTendenze.cbOrderChange(Sender: TObject);
begin
  tbTaba.IndexName:= dmTaba.DecodeOrder(cbOrder.ItemIndex);
end;

procedure TfmStampaTendenze.FormShow(Sender: TObject);
begin
  cbOrder.ItemIndex:= dmTaba.EncodeOrder('');
  cbOrder.OnChange(nil);
end;

procedure TfmStampaTendenze.PrintReport(Sender: TObject);
begin
       if Sender = btExport then Report.DeviceKind:= 'TextFile'
  else if Sender = btPrint  then Report.DeviceKind:= 'Printer'
  else Report.DeviceKind:= 'Preview';
  PrintData;
end;

procedure TfmStampaTendenze.ReportSetupDevice(Rep: TeLineReport;
  Dev: TOutputDevice);
begin
  dmTaba.SetupReportDevice(Rep, Dev);
end;

procedure TfmStampaTendenze.ReportPageHeader(Rep: TeLineReport);
begin
  with Rep do begin
    WriteLine('TENDENZE PER '+IntToStr(periodi)+' PERIODI CON STATISTICHE AGGIORNATE AL '+DateUtil.myDateToStr(dmTaba.GetStatDate)+' - PAG.'+IntToStr(CurPag));
    WritePattern('-');
    LineFeed;
    WriteLine('__Codici__ _Descrizione tabacco_________________________________________ __Short_ ___Med__ __Long__ __Best__');
  end;
end;

procedure TfmStampaTendenze.PrintData;
begin
  periodi:= iPeri.AsInteger;
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
  end;
end;

procedure TfmStampaTendenze.WriteRow(Report: TeLineReport);
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
  p1,p2,p3,p4: double;
begin
  CodI:= tbTabaCodI.Value;
  p1:= dmTaba.PrediciVend(CodI, periodi, pmShort) / tbTabaQtaC.Value;
  p2:= dmTaba.PrediciVend(CodI, periodi, pmMed) / tbTabaQtaC.Value;
  p3:= dmTaba.PrediciVend(CodI, periodi, pmLong) / tbTabaQtaC.Value;
  p4:= dmTaba.PrediciVend(CodI, periodi, pmBest) / tbTabaQtaC.Value;
  Row:= Format('%5d %4s %1s%-60s %8.2f %8.2f %8.2f %8.2f',
   [CodI, tbTabaCodS.Value, getAttiv, tbTabaDesc.Value,
     p1,p2,p3,p4]);
  Report.WriteLine(Row);
end;

end.

