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
unit FRepTele;

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, uOpzioni, DB, DBTables, Dialogs,
  eReport;

type
  TrepElencoTelefono = class(TForm)
    tbTelef: TTable;
    tbContat: TTable;
    dsContat: TDataSource;
    tbTelefCodTel: TIntegerField;
    tbTelefCodCon: TIntegerField;
    tbTelefTipo: TIntegerField;
    tbTelefTel_Pre1: TStringField;
    tbTelefTel_Pre2: TStringField;
    tbTelefTelefono: TStringField;
    tbTelefNote: TStringField;
    Rep: TEicLineReport;
    LF: TEicLineFields;
    procedure RepPageFooter(Rep: TEicLineReport);
    procedure RepPageHeader(Rep: TEicLineReport);
  private
    { Private declarations }
    Prog: integer;
    procedure ShowRiga;
  public
    { Public declarations }
    Print: boolean;
    Order: string;
    function  MakeReport(const Device: string): boolean;
  end;

function ReportElencoTelefono(const Order: string; const Device: string): boolean;

implementation

{$R *.DFM}

uses
  eCore, SysUtils, ContComm, eDates, Costanti;

procedure TrepElencoTelefono.ShowRiga;
(*
  Fld[0]:= Rep.AddField(  1,  5, raRight);
  Fld[1]:= Rep.AddField(  7, 40, raLeft);
  Fld[2]:= Rep.AddField( 48, 20, raRight);
  Fld[3]:= Rep.AddField( 69, 30, raLeft);
*)
begin
  inc(Prog);
  with LF do begin
    Field[0].Value:= IntToStr(Prog);
    Field[1].Value:= _DecodeNome(tbContat);
    Field[2].Value:= _DecodeTelefono(tbTelef);
    Field[3].Value:= tbTelefNote.Value;
    Print;
  end;
end;

function TrepElencoTelefono.MakeReport(const Device: string): boolean;
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
    tbTelef.Open;
    tbContat.IndexName:= Order;
    tbContat.Open;
    Prog:= 0;
    try
      Rep.BeginReport;
      tbContat.First;
      while not tbContat.EOF do begin
        tbTelef.First;
        while not tbTelef.EOF do begin
          ShowRiga;
          tbTelef.Next;
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
    tbTelef.Close;
    tbContat.Close;
  end;
end;

function ReportElencoTelefono(const Order: string; const Device: string): boolean;
var
  repElencoTelefono: TrepElencoTelefono;
begin
  repElencoTelefono:= nil;
  try
    repElencoTelefono:= TrepElencoTelefono.Create(nil);
    repElencoTelefono.Order:= Order;
    Result:= repElencoTelefono.MakeReport(Device);
  finally
    repElencoTelefono.Free;
  end;
end;

procedure TrepElencoTelefono.RepPageHeader(Rep: TEicLineReport);
begin
  with Rep do begin
    with PrepareLine do begin
      Tab(  1); Write('');
      Tab( 40); WriteC('***   ELENCO TELEFONICO   ***');
      Tab( 80); Write('Pag. '+IntToStr(CurPag));
      Print;
    end;
    WritePattern('-');
    LineFeed;
    with LF do begin
      with Field[0] do begin Value:= 'Prog.';  Align:= taCenter; end;
      with Field[1] do begin Value:= 'Nome';  Align:= taCenter; end;
      with Field[2] do begin Value:= 'Telefono';  Align:= taCenter; end;
      with Field[3] do begin Value:= 'Note';  Align:= taCenter; end;
      Print;
    end;
    with LF do begin
      Field[0].Fill:= '=';
      Field[1].Fill:= '=';
      Field[2].Fill:= '=';
      Field[3].Fill:= '=';
      Print;
    end;
  end;
end;

procedure TrepElencoTelefono.RepPageFooter(Rep: TEicLineReport);
begin
  with Rep do begin
    LineFeed;
    WritePattern('-');
  end;
end;

end.

