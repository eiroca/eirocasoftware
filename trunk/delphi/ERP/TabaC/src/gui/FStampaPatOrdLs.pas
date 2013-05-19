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
unit FStampaPatOrdLs;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DTabaC,
  Forms, Dialogs, DBTables, DB, StdCtrls, Buttons, eReport;

type
  TfmStampaRichiestaPatentino = class(TForm)
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
    tbMovs: TTable;
    tbList: TTable;
    dsOrdiLst: TDataSource;
    tbPate: TTable;
    tbPateCODP: TAutoIncField;
    tbPateNOME: TStringField;
    tbListPPCO: TAutoIncField;
    tbListCODP: TIntegerField;
    tbListDATA: TDateField;
    tbListDATAORDI: TDateField;
    tbListDATAPREZ: TDateField;
    tbListKGC: TFloatField;
    tbListVAL: TCurrencyField;
    tbMovsPPCO: TIntegerField;
    tbMovsCODI: TSmallintField;
    tbMovsCONS: TIntegerField;
    tbMovsCodS: TStringField;
    tbMovsDesc: TStringField;
    tbMovsConsKG: TFloatField;
    procedure ReportPageHeader(Rep: TeLineReport);
    procedure ReportSetupDevice(Rep: TeLineReport; Dev: TOutputDevice);
    procedure PrintReport(Sender: TObject);
    procedure ReportFooter(Rep: TeLineReport);
    procedure tbMovsCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    Codice: longint;
    procedure WriteRow(Report: TeLineReport);
    procedure PrintData;
  public
    { Public declarations }
  end;

procedure StampaRichiestaPatentino(Codice: longint);

implementation

{$R *.DFM}

uses
  eLibCore, UOpzioni;

procedure StampaRichiestaPatentino(Codice: longint);
var
  fmStampaRichiestaPatentino: TfmStampaRichiestaPatentino;
begin
  fmStampaRichiestaPatentino:= TfmStampaRichiestaPatentino.Create(nil);
  fmStampaRichiestaPatentino.Codice:= Codice;
  try
    fmStampaRichiestaPatentino.ShowModal;
  finally
    fmStampaRichiestaPatentino.Free;
  end;
end;

procedure TfmStampaRichiestaPatentino.WriteRow(Report: TeLineReport);
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
begin
  Row:= Format('%5d %4s %-60s %8d %8.2f',
   [tbMovsCODI.Value, tbMovsCodS.Value, tbMovsDesc.Value, tbMovsCONS.Value, tbMovsConsKG.Value]);
  Report.WriteLine(Row);
end;

procedure TfmStampaRichiestaPatentino.PrintData;
var
  OldData: TDateTime;
begin
  OldData:= dmTaba.DataPrezzi;
  try
    tbTaba.Open;
    tbPate.Open;
    tbList.Open;
    tbMovs.Open;
    if tbList.FindKey([Codice]) then begin
      Report.BeginReport;
      try
        tbMovs.First;
        while not tbMovs.EOF do begin
          WriteRow(Report);
          tbMovs.Next;
        end;
        Report.EndReport;
      except
        Report.AbortReport;
      end;
    end;
    tbMovs.Close;
    tbList.Close;
    tbTaba.Close;
    tbPate.Close;
    ModalResult:= mrOk;
  finally
    dmTaba.DataPrezzi:= OldData;
  end;
end;

procedure TfmStampaRichiestaPatentino.ReportPageHeader(Rep: TeLineReport);
var
  tmp1, tmp2: string;
begin
  with Rep do begin
    tmp1:= '';
    tmp2:= '';
    if (tbPate.FindKey([tbListCODP.Value])) then begin
      tmp1:= ' DI '+tbPateNOME.Value;
    end;
    if (not tbListDATA.IsNull) then begin
       tmp2:= ' CONSEGNATA IL '+tbListDATA.AsString;
    end;
    WriteLine('RICHIESTA'+tmp1+' DEL '+DateUtil.myDateToStr(tbListDATAORDI.Value)+tmp2+' VALORIZZATA AI PREZZI DEL '+DateUtil.myDateToStr(tbListDATAPREZ.Value)+' - PAG.'+IntToStr(CurPag));
    WritePattern('-');
    LineFeed;
    WriteLine('__Codici__ Descrizione tabacco_________________________________________ Quantità (Kg con.)');
  end;
end;

procedure TfmStampaRichiestaPatentino.ReportSetupDevice(Rep: TeLineReport;
  Dev: TOutputDevice);
begin
  dmTaba.SetupReportDevice(Rep, Dev);
end;

procedure TfmStampaRichiestaPatentino.PrintReport(Sender: TObject);
begin
       if Sender = btExport then Report.DeviceKind:= 'TextFile'
  else if Sender = btPrint  then Report.DeviceKind:= 'Printer'
  else Report.DeviceKind:= 'Preview';
  PrintData;
end;

procedure TfmStampaRichiestaPatentino.ReportFooter(Rep: TeLineReport);
begin
  Rep.LineFeed;
  Rep.WriteLine(Format('Totale: %16.2f KgC (%16m)', [tbListKgC.Value, tbListVal.Value]));
end;

procedure TfmStampaRichiestaPatentino.tbMovsCalcFields(DataSet: TDataSet);
begin
  if tbTaba.FindKey([tbMovsCodI.Value]) then begin
    tbMovsDesc.Value:= tbTabaDesc.Value;
    tbMovsCodS.Value:= tbTabaCodS.Value;
    tbMovsConsKG.Value:= tbMovsCons.Value / tbTabaQtaC.Value;
  end
  else begin
    tbMovsDesc.Value:= '<<sconosciuto>>';
    tbMovsCodS.Value:= '';
  end;
end;

end.

