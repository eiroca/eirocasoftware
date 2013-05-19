(* GPL > 3.0
Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio

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
unit FRepIndi;

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, uOpzioni, DB, DBTables, Dialogs, eReport;

type
  TrepElencoIndirizzi = class(TForm)
    tbIndir: TTable;
    tbContat: TTable;
    dsContat: TDataSource;
    tbIndirCodInd: TIntegerField;
    tbIndirCodCon: TIntegerField;
    tbIndirTipo: TIntegerField;
    tbIndirIndirizzo: TMemoField;
    tbIndirNote: TStringField;
    Rep: TEicLineReport;
    LFIndir: TEicLineFields;
    LFContat: TEicLineFields;
    procedure RepPageHeader(Rep: TEicLineReport);
    procedure RepPageFooter(Rep: TEicLineReport);
    procedure RepSetupDevice(Rep: TEicLineReport;
      Dev: TOutputDevice);
  private
    { Private declarations }
    Prog: integer;
    procedure ShowContat;
    procedure ShowIndir;
  public
    { Public declarations }
    Print: boolean;
    Order: string;
    function  MakeReport(const Device: string): boolean;
  end;

function ReportElencoIndirizzi(const Order: string; const Device: string): boolean;

implementation

{$R *.DFM}

uses
  eCore, SysUtils, ContComm, eDates, Costanti, DContat;

function ReportElencoIndirizzi(const Order: string; const Device: string): boolean;
var
  repElencoIndirizzi: TrepElencoIndirizzi;
begin
  repElencoIndirizzi:= nil;
  try
    repElencoIndirizzi:= TrepElencoIndirizzi.Create(nil);
    repElencoIndirizzi.Order:= Order;
    Result:= repElencoIndirizzi.MakeReport(Device);
  finally
    repElencoIndirizzi.Free;
  end;
end;

procedure TrepElencoIndirizzi.ShowContat;
(*
  Fld[0]:= Rep.AddField(  1,  5, raRight);
  Fld[1]:= Rep.AddField(  7, 60, raLeft);
*)
begin
  inc(Prog);
  with LFContat do begin
    Field[0].Value:= IntToStr(Prog);
    Field[1].Value:= _DecodeNome(tbContat);
    Print;
  end;
end;

procedure TrepElencoIndirizzi.ShowIndir;
(*
  Fld[0]:= Rep.AddField(  7, 60, raLeft);
  Fld[1]:= Rep.AddField( 68, 30, raLeft);
*)
begin                           
  with LFIndir do begin
    Field[0].Value:= _DecodeIndirizzo(tbIndir);
    Field[1].Value:= tbIndirNote.Value;
    Print;
  end;
end;

function TrepElencoIndirizzi.MakeReport(const Device: string): boolean;
var
  OldCursor: integer;
begin
  Rep.DeviceKind:= Device;
  Rep.ReportName:= 'Elenco Telefonico';
  Rep.PageHeight:= Opzioni.RigheRep;
  OldCursor:= Screen.Cursor;
  Screen.Cursor:= crHourglass;
  Result:= true;
  try
    tbIndir.Open;
    tbContat.IndexName:= Order;
    tbContat.Open;
    Prog:= 0;
    try
      Rep.BeginReport;
      tbContat.First;
      while not tbContat.EOF do begin
        tbIndir.First;
        if not tbIndir.EOF then begin
          Rep.Reserve(tbIndir.RecordCount+1);
          ShowContat;
          while not tbIndir.EOF do begin
            ShowIndir;
            tbIndir.Next;
          end;
        end;
        tbContat.Next;
      end;
      Screen.Cursor:= OldCursor;
      Rep.EndReport;
    except
      on EDeviceAbortedError do ;
      on EDeviceError do begin
        Result:= false;
        Rep.AbortReport;
      end;
    end;
  finally
    Screen.Cursor:= OldCursor;
    tbIndir.Close;
    tbContat.Close;
  end;
end;

procedure TrepElencoIndirizzi.RepPageHeader(
  Rep: TEicLineReport);
var
  P: TReportLine;
begin
  with Rep do begin
    with PrepareLine do begin
      Tab(  1); Write('');
      Tab( 40); WriteC('***   ELENCO  INDIRIZZI   ***');
      Tab( 80); Write('Pag. '+IntToStr(CurPag));
      Print;
    end;
    WritePattern('-');
    LineFeed;
    P:= PrepareLine;
    with LFContat[0] do begin Value:= 'Prog.'; Align:= taCenter; end;
    with LFContat[1] do begin Value:= 'Contatto e suoi indirizzi'; Align:= taCenter; end;
    with LFIndir[0]  do begin Value:= 'Contatto e suoi indirizzi'; Align:= taCenter; end;
    with LFIndir[1]  do begin Value:= 'Note'; Align:= taCenter; end;
    LFIndir.Write(P);  LFIndir.Prepare;
    LFContat.Write(P); LFContat.Prepare;
    P.Print;
    P:= PrepareLine;
    LFIndir[0].Fill:= '=';
    LFIndir[1].Fill:= '=';
    LFContat[0].Fill:= '=';
    LFContat[1].Fill:= '=';
    LFIndir.Write(P);
    LFContat.Write(P);
    P.Print;
  end;
end;

procedure TrepElencoIndirizzi.RepPageFooter(
  Rep: TEicLineReport);
begin
  with Rep do begin
    LineFeed;
    WritePattern('-');
  end;
end;

procedure TrepElencoIndirizzi.RepSetupDevice(
  Rep: TEicLineReport; Dev: TOutputDevice);
begin
  dmContatti.SetupOutputDevice(Dev);
end;

end.

