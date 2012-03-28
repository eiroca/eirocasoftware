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
unit FStampaModulo;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DBTables, DB, StdCtrls, Buttons, eReport, Mask, JvExMask,
  JvSpin;

type
  TfmStampaModuli = class(TForm)
    Label1: TLabel;
    iCopie: TJvSpinEdit;
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
    btPrint: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure ReportPageHeader(Rep: TeLineReport);
    procedure ReportSetupDevice(Rep: TeLineReport; Dev: TOutputDevice);
    procedure cbOrderChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure WriteSep(Report: TeLineReport);
    procedure WriteRow(Report: TeLineReport);
  public
    { Public declarations }
  end;

procedure StampaModuloInventario;

implementation

{$R *.DFM}

uses
  eLibCore, UOpzioni, DTabaC;

procedure StampaModuloInventario;
var
  fmStampaModuli: TfmStampaModuli;
begin
  fmStampaModuli:= TfmStampaModuli.Create(nil);
  try
    fmStampaModuli.ShowModal;
  finally
    fmStampaModuli.Free;
  end;
end;

procedure TfmStampaModuli.FormCreate(Sender: TObject);
begin
  dmTaba.GetOrder(cbOrder.Items);
end;

procedure TfmStampaModuli.WriteSep(Report: TeLineReport);
begin
  with Report.PrepareLine do begin
    WriteField( 10, 46, '+ - - - - - - - - - - - - - - - - - - - - - -+', taLeftJustify);
    WriteField( 56, 12, '-----------+', taLeftJustify);
    WriteField( 68, 12, '-----------+', taLeftJustify);
    WriteField( 80, 12, '-----------+', taLeftJustify);
    WriteField( 92, 12, '-----------+', taLeftJustify);
    WriteField(104, 12, '-----------+', taLeftJustify);
    WriteField(116, 12, '-----------+', taLeftJustify);
    Print;
  end;
end;

procedure TfmStampaModuli.WriteRow(Report: TeLineReport);
begin
  Report.Reserve(2);
  with Report.PrepareLine do begin
    WriteField( 10,  1, '|', taLeftJustify);
    WriteField( 12,  4, tbTabaCodS.AsString, taRightJustify);
    WriteField( 17, 30, tbTabaDesc.Value, taLeftJustify);
    WriteField( 48,  1, 'x', taCenter);
    WriteField( 50,  3, tbTabaMulI.AsString, taRightJustify);
    WriteField( 55,  1, '|', taLeftJustify);
    WriteField( 56, 12, '           |', taLeftJustify);
    WriteField( 68, 12, '           |', taLeftJustify);
    WriteField( 80, 12, '           |', taLeftJustify);
    WriteField( 92, 12, '           |', taLeftJustify);
    WriteField(104, 12, '           |', taLeftJustify);
    WriteField(116, 12, '           |', taLeftJustify);
    Print;
  end;
  WriteSep(Report);
end;

procedure TfmStampaModuli.btPrintClick(Sender: TObject);
var
  i: integer;
begin
  for i:= 1 to trunc(iCopie.Value) do begin
    Report.BeginReport;
    tbTaba.Open;
    try
      tbTaba.First;
      if not tbTaba.EOF then begin
        WriteSep(Report);
      end;
      while not tbTaba.EOF do begin
        if tbTabaAttv.Value then begin
          WriteRow(Report);
        end;
        tbTaba.Next;
      end;
      Report.EndReport;
    except
      Report.AbortReport;
    end;
    tbTaba.Close;
  end;
  ModalResult:= mrOk;
end;

procedure TfmStampaModuli.ReportPageHeader(Rep: TeLineReport);
begin
  with Rep do begin
    WriteLine('MODULO PER RILIEVI INVENTARIALI TABACCHI - PAG.'+IntToStr(CurPag));
    WritePattern('-');
  end;
end;

procedure TfmStampaModuli.ReportSetupDevice(Rep: TeLineReport;
  Dev: TOutputDevice);
begin
  dmTaba.SetupReportDevice(Rep, Dev);
end;

procedure TfmStampaModuli.cbOrderChange(Sender: TObject);
begin
  tbTaba.IndexName:= dmTaba.DecodeOrder(cbOrder.ItemIndex);
end;

procedure TfmStampaModuli.FormShow(Sender: TObject);
begin
  cbOrder.ItemIndex:= dmTaba.EncodeOrder('');
  cbOrder.OnChange(nil);
end;

end.

