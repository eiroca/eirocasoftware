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
unit FStampaPrezzi;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DBTables, DB, StdCtrls, Buttons, eReport;

type
  TfmStampaListino = class(TForm)
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
    cbSoloAttivi: TCheckBox;
    btExport: TBitBtn;
    btPrint: TBitBtn;
    btPreview: TBitBtn;
    lbData: TLabel;
    cbFormat: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure ReportPageHeader(Rep: TeLineReport);
    procedure ReportSetupDevice(Rep: TeLineReport; Dev: TOutputDevice);
    procedure cbOrderChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PrintReport(Sender: TObject);
  private
    { Private declarations }
    Data: TDateTime;
    procedure WriteRow(Report: TeLineReport);
    procedure PrintData;
  public
    { Public declarations }
  end;

procedure StampaListinoTabacchi(Data: TDateTime);

implementation

{$R *.DFM}

uses
  eLibCore, uOpzioni, DTabaC;

procedure StampaListinoTabacchi(Data: TDateTime);
var
  fmStampaListino: TfmStampaListino;
begin
  if (Data = NoDate) or (Data = 0) then begin
    Data:= dmTaba.DataPrezzi;
  end;
  fmStampaListino:= TfmStampaListino.Create(nil);
  fmStampaListino.Data:= Data;
  try
    fmStampaListino.ShowModal;
  finally
    fmStampaListino.Free;
  end;
end;

procedure TfmStampaListino.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
end;

procedure TfmStampaListino.WriteRow(Report: TeLineReport);
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
  if (cbFormat.ItemIndex=0) then begin
    Row:= Format('%12m %1s%-70s ',
     [0.0+dmTaba.Prezzo[tbTabaCodI.Value], getAttiv, tbTabaDesc.Value + ' ['+tbTabaCodS.Value+']']);
  end
  else begin
    Row:= Format('%5d %4s %1s%-60s %12m',
     [tbTabaCodI.Value, tbTabaCodS.Value, getAttiv, tbTabaDesc.Value, 0.0+dmTaba.Prezzo[tbTabaCodI.Value]]);
  end;
  Report.WriteLine(Row);
end;

procedure TfmStampaListino.PrintData;
var
  OldData: TDateTime;
begin
  OldData:= dmTaba.DataPrezzi;
  dmTaba.DataPrezzi:= Data;
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

procedure TfmStampaListino.ReportPageHeader(Rep: TeLineReport);
begin
  with Rep do begin
    WriteLine('LISTINO PREZZI DEL '+DateUtil.myDateToStr(Data)+' - PAG.'+IntToStr(CurPag));
    WritePattern('-');
    LineFeed;
    if (cbFormat.ItemIndex=0) then begin
      WriteLine('___Prezzo___ _Descrizione tabacco [codice sigaretta]________________________________ ');
    end
    else begin
      WriteLine('__Codici__ _Descrizione tabacco_________________________________________ ___Prezzo___');
    end;
  end;
end;

procedure TfmStampaListino.ReportSetupDevice(Rep: TeLineReport;
  Dev: TOutputDevice);
begin
  dmTaba.SetupReportDevice(Rep, Dev);
end;

procedure TfmStampaListino.cbOrderChange(Sender: TObject);
begin
  tbTaba.IndexName:= dmTaba.DecodeOrder(cbOrder.ItemIndex);
end;

procedure TfmStampaListino.FormShow(Sender: TObject);
begin
  lbData.Caption:= 'Listino del '+DateUtil.myDateToStr(Data);
  cbOrder.ItemIndex:= dmTaba.EncodeOrder('');
  cbOrder.OnChange(nil);
  cbFormat.ItemIndex:= 0;
end;

procedure TfmStampaListino.PrintReport(Sender: TObject);
begin
       if Sender = btExport then Report.DeviceKind:= 'TextFile'
  else if Sender = btPrint  then Report.DeviceKind:= 'Printer'
  else Report.DeviceKind:= 'Preview';
  PrintData;
end;

end.

