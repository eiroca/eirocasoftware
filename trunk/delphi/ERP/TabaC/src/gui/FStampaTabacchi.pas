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
unit FStampaTabacchi;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DBTables, DB, StdCtrls, Buttons, eReport;

type
  TfmStampaTabacchi = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure ReportPageHeader(Rep: TeLineReport);
    procedure ReportSetupDevice(Rep: TeLineReport; Dev: TOutputDevice);
    procedure cbOrderChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PrintReport(Sender: TObject);
  private
    { Private declarations }
    procedure WriteRow(Report: TeLineReport);
    procedure PrintData;
  public
    { Public declarations }
  end;

procedure StampaTabacchi;

implementation

{$R *.DFM}

uses
  eLibCore, uOpzioni, DTabaC;

procedure StampaTabacchi;
var
  fmStampaTabacchi: TfmStampaTabacchi;
begin
  fmStampaTabacchi:= TfmStampaTabacchi.Create(nil);
  try
    fmStampaTabacchi.ShowModal;
  finally
    fmStampaTabacchi.Free;
  end;
end;

procedure TfmStampaTabacchi.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
end;

procedure TfmStampaTabacchi.WriteRow(Report: TeLineReport);
  function getKind: string;
  var
    tmp: string;
  begin
    Result:= '';
    tmp:= dmTaba.GetDescTipo(tbTabaTipo.Value);
    if (tmp<>'') then Result:= Result + tmp + ',';
    tmp:= dmTaba.GetDescProd(tbTabaProd.Value);
    if (tmp<>'') then Result:= Result + tmp + ',';
    tmp:= dmTaba.GetDescCrit(tbTabaCrit.Value);
    if (tmp<>'') then Result:= Result + tmp + ',';
    if (length(Result)>0) and (Result[length(Result)]=',') then begin
      setLength(Result, length(result)-1);
    end;
    if (Result<>'') then Result:= ' ['+Result+']';
  end;
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
  Row:= Format('%5d %4s %1s%-74s %8d %8d %8d %8d %8d',
   [tbTabaCodI.Value, tbTabaCodS.Value, getAttiv, copy(tbTabaDesc.Value+getKind, 1, 74),
    tbTabaMulI.Value, tbTabaQtaC.Value, tbTabaQtaS.Value, tbTabaQtaM.Value, tbTabaDifr.Value]);
  Report.WriteLine(Row);
end;

procedure TfmStampaTabacchi.PrintData;
begin
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
end;

procedure TfmStampaTabacchi.ReportPageHeader(Rep: TeLineReport);
begin
  with Rep do begin
    WriteLine('DATI RIEPILOGATIVI ARCHIVIO TABACCHI - PAG.'+IntToStr(CurPag));
    WritePattern('-');
    LineFeed;
    WriteLine('__Codici__ Descrizione tabacco________________________________________________________ Mol. In. Q. Conv. Q. Stec. Q. Rich. __Diffr.');
  end;
end;

procedure TfmStampaTabacchi.ReportSetupDevice(Rep: TeLineReport;
  Dev: TOutputDevice);
begin
  dmTaba.SetupReportDevice(Rep, Dev);
end;

procedure TfmStampaTabacchi.cbOrderChange(Sender: TObject);
begin
  tbTaba.IndexName:= dmTaba.DecodeOrder(cbOrder.ItemIndex);
end;

procedure TfmStampaTabacchi.FormShow(Sender: TObject);
begin
  cbOrder.ItemIndex:= dmTaba.EncodeOrder('');
  cbOrder.OnChange(nil);
end;

procedure TfmStampaTabacchi.PrintReport(Sender: TObject);
begin
       if Sender = btExport then Report.DeviceKind:= 'TextFile'
  else if Sender = btPrint  then Report.DeviceKind:= 'Printer'
  else Report.DeviceKind:= 'Preview';
  PrintData;
end;

end.

