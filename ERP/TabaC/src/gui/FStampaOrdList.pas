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
unit FStampaOrdList;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DTabaC,
  Forms, Dialogs, DBTables, DB, StdCtrls, Buttons, eReport;

type
  TfmStampaOrdine = class(TForm)
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
    btExport: TBitBtn;
    btPrint: TBitBtn;
    btPreview: TBitBtn;
    lbData: TLabel;
    tbOrdiMov: TTable;
    tbOrdiMovPCAR: TIntegerField;
    tbOrdiMovCODI: TSmallintField;
    tbOrdiMovCodS: TStringField;
    tbOrdiMovDesc: TStringField;
    tbOrdiMovCARI: TIntegerField;
    tbOrdiMovCariKG: TFloatField;
    tbOrdiLst: TTable;
    tbOrdiLstPCAR: TIntegerField;
    tbOrdiLstDATAORDI: TDateField;
    tbOrdiLstDATA: TDateField;
    tbOrdiLstDATAPREZ: TDateField;
    tbOrdiLstKGC: TFloatField;
    tbOrdiLstVAL: TCurrencyField;
    dsOrdiLst: TDataSource;
    procedure ReportPageHeader(Rep: TeLineReport);
    procedure ReportSetupDevice(Rep: TeLineReport; Dev: TOutputDevice);
    procedure FormShow(Sender: TObject);
    procedure PrintReport(Sender: TObject);
    procedure ReportFooter(Rep: TeLineReport);
    procedure tbOrdiMovCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    Data: TDateTime;
    procedure WriteRow(Report: TeLineReport);
    procedure PrintData;
  public
    { Public declarations }
  end;

procedure StampaOrdine(Data: TDateTime);

implementation

{$R *.DFM}

uses
  eLibCore, uOpzioni;

procedure StampaOrdine(Data: TDateTime);
var
  fmStampaOrdine: TfmStampaOrdine;
begin
  fmStampaOrdine:= TfmStampaOrdine.Create(nil);
  fmStampaOrdine.Data:= Data;
  try
    fmStampaOrdine.ShowModal;
  finally
    fmStampaOrdine.Free;
  end;
end;

procedure TfmStampaOrdine.WriteRow(Report: TeLineReport);
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
  Cari: longint;
  Val : double;
begin
  CodI:= tbOrdiMovCODI.Value;
  Cari:= tbOrdiMovCARI.Value;
  Val := Cari * dmTaba.Prezzo[CodI];
  Row:= Format('%5d %4s %-60s %8d %8.2f  %14m',
   [CodI, tbOrdiMovCodS.Value, tbOrdiMovDesc.Value, Cari, tbOrdiMovCariKG.Value, Val]);
  Report.WriteLine(Row);
end;

procedure TfmStampaOrdine.PrintData;
var
  OldData: TDateTime;
begin
  OldData:= dmTaba.DataPrezzi;
  try
    tbTaba.Open;
    tbOrdiLst.Open;
    tbOrdiMov.Open;
    if tbOrdiLst.FindKey([Data]) then begin
      Report.BeginReport;
      try
        tbOrdiMov.First;
        while not tbOrdiMov.EOF do begin
          WriteRow(Report);
          tbOrdiMov.Next;
        end;
        Report.EndReport;
      except
        Report.AbortReport;
      end;
    end;
    tbOrdiMov.Close;
    tbOrdiLst.Close;
    tbTaba.Close;
    ModalResult:= mrOk;
  finally
    dmTaba.DataPrezzi:= OldData;
  end;
end;

procedure TfmStampaOrdine.ReportPageHeader(Rep: TeLineReport);
var
  tmp: string;
begin
  with Rep do begin
    tmp:= '';
    if (not tbOrdiLstDATA.IsNull) then begin
       tmp:= ' CONSEGNATO IL '+tbOrdiLstDATA.AsString;
    end;
    WriteLine('ORDINE DEL '+DateUtil.MyDateToStr(Data)+tmp+' VALORIZZATO AI PREZZI DEL '+DateUtil.myDateToStr(tbOrdiLstDATAPREZ.Value)+' - PAG.'+IntToStr(CurPag));
    WritePattern('-');
    LineFeed;
    WriteLine('__Codici__ Descrizione tabacco_________________________________________ Quantità (Kg con.) ___Parziale___');
  end;
end;

procedure TfmStampaOrdine.ReportSetupDevice(Rep: TeLineReport;
  Dev: TOutputDevice);
begin
  dmTaba.SetupReportDevice(Rep, Dev);
end;

procedure TfmStampaOrdine.FormShow(Sender: TObject);
begin
  lbData.Caption:= 'Ordine del '+DateUtil.myDateToStr(Data);
end;

procedure TfmStampaOrdine.PrintReport(Sender: TObject);
begin
       if Sender = btExport then Report.DeviceKind:= 'TextFile'
  else if Sender = btPrint  then Report.DeviceKind:= 'Printer'
  else Report.DeviceKind:= 'Preview';
  PrintData;
end;

procedure TfmStampaOrdine.ReportFooter(Rep: TeLineReport);
begin
  Rep.LineFeed;
  Rep.WriteLine(Format('Totale: %16.2f KgC (%16m)', [tbOrdiLstKgC.Value, tbOrdiLstVal.Value]));
end;

procedure TfmStampaOrdine.tbOrdiMovCalcFields(DataSet: TDataSet);
begin
  if tbTaba.FindKey([tbOrdiMovCodI.Value]) then begin
    tbOrdiMovDesc.Value:= tbTabaDesc.Value;
    tbOrdiMovCodS.Value:= tbTabaCodS.Value;
    tbOrdiMovCariKG.Value:= tbOrdiMovCari.Value / tbTabaQtaC.Value
  end
  else begin
    tbOrdiMovDesc.Value:= '<<sconosciuto>>';
    tbOrdiMovCodS.Value:= '';
  end;
end;

end.

