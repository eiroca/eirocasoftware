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
unit FRepDati;

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, uOpzioni, DB, DBTables, Dialogs,
  eReport;

type
  TrepDatiContatto = class(TForm)
    tbIndir: TTable;
    tbContat: TTable;
    dsContat: TDataSource;
    tbIndirCodInd: TIntegerField;
    tbIndirCodCon: TIntegerField;
    tbIndirTipo: TIntegerField;
    tbIndirIndirizzo: TMemoField;
    tbIndirNote: TStringField;
    tbTelef: TTable;
    tbTelefCodTel: TIntegerField;
    tbTelefCodCon: TIntegerField;
    tbTelefTipo: TIntegerField;
    tbTelefTel_Pre1: TStringField;
    tbTelefTel_Pre2: TStringField;
    tbTelefTelefono: TStringField;
    tbTelefNote: TStringField;
    tbContatCodCon: TIntegerField;
    tbContatTipo: TIntegerField;
    tbContatNome_Tit: TStringField;
    tbContatNome_Pre1: TStringField;
    tbContatNome_Pre2: TStringField;
    tbContatNome_Main: TStringField;
    tbContatNome_Suf: TStringField;
    tbContatClasse: TStringField;
    tbContatSettore: TStringField;
    tbContatNote: TMemoField;
    tbNickName: TTable;
    tbNickNameProg: TIntegerField;
    tbNickNameCodCon: TIntegerField;
    tbNickNameNickName: TStringField;
    tbDateImp: TTable;
    tbDateImpProg: TIntegerField;
    tbDateImpCodCon: TIntegerField;
    tbDateImpTipo: TIntegerField;
    tbDateImpData: TDateField;
    tbDateImpNota: TStringField;
    tbRefer: TTable;
    tbContat2: TTable;
    IntegerField4: TIntegerField;
    IntegerField5: TIntegerField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    MemoField1: TMemoField;
    tbReferProg: TIntegerField;
    tbReferCodCon: TIntegerField;
    tbReferCodRef: TIntegerField;
    tbReferDi: TTable;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    IntegerField3: TIntegerField;
    tbConnessi: TTable;
    tbGruppi: TTable;
    tbGruppiCodGrp: TIntegerField;
    tbGruppiDesc: TStringField;
    tbInGruppi: TTable;
    tbInGruppiProg: TIntegerField;
    tbInGruppiCodCon: TIntegerField;
    tbInGruppiCodGrp: TIntegerField;
    tbConnessiCodCos: TIntegerField;
    tbConnessiCodCon: TIntegerField;
    tbConnessiTipo: TIntegerField;
    tbConnessiData: TDateTimeField;
    tbConnessiContenuto: TStringField;
    tbConnessiNote: TMemoField;
    tbConnessiURL: TStringField;
    Rep: TeLineReport;
    procedure RepPageFooter(Rep: TeLineReport);
    procedure RepPageHeader(Rep: TeLineReport);
    procedure RepSetupDevice(Rep: TeLineReport;
      Dev: TOutputDevice);
  private
    { Private declarations }
    Prog: integer;
    procedure ShowContat(Flag: boolean);
    procedure ShowIndir;
    procedure ShowTelef;
    procedure ShowNickName;
    procedure ShowDateImp;
    procedure ShowComunic;
    procedure ShowInGruppi;
    procedure ShowRefer(const Msg, FldName: string; tb: TTable);
  public
    { Public declarations }
    Print: boolean;
    Order: string;
    function  MakeReport(const Device: string; const Flag: array of boolean): boolean;
  end;

function ReportDatiContatto(const Order: string; const Flag: array of boolean; const Device: string): boolean;

implementation

{$R *.DFM}

uses
  eLibCore, SysUtils, ContComm, Costanti, DContat;

procedure TrepDatiContatto.ShowContat(Flag: boolean);
begin
  inc(Prog);
  with Rep do begin
    with PrepareLine do begin
      WriteField( 1,  4, IntToStr(Prog), taRightJustify);
      WriteField( 6, 40, _DecodeNome(tbContat), taLeftJustify);
      if Flag then begin
        WriteField(48, 50, DecodeMemo(tbContatNote, ' ', 0), taLeftJustify);
      end;
      Print;
    end;
  end;
end;

procedure TrepDatiContatto.ShowIndir;
begin
  with Rep do begin
    with PrepareLine do begin
      WriteField( 6, 50, _DecodeIndirizzo(tbIndir), taLeftJustify);
      WriteField(58, 40, tbIndirNote.Value, taLeftJustify);
      Print;
    end;
  end;
end;

procedure TrepDatiContatto.ShowNickName;
var
  tmp: string;
begin
  tmp:= '';
  while not tbNickName.EOF do begin
    if tmp <> '' then tmp:= tmp+', ';
    if length(tmp) + length(tbNickNameNickName.Value) > 75 then begin
      tmp:= tmp + '...';
      break;
    end
    else tmp:= tmp + tbNickNameNickName.Value;
    tbNickName.Next;
  end;
  with Rep do begin
    with PrepareLine do begin
      Tab(6); Write('Soprannomi: '+tmp);
      Print;
    end;
  end;
end;

procedure TrepDatiContatto.ShowDateImp;
begin
  with Rep do begin
    with PrepareLine do begin
      Tab(6); Write('Elenco date importanti:');
      Print;
    end;
  end;
  while not tbDateImp.EOF do begin
    with Rep do begin
      with PrepareLine do begin
        WriteField(  7, 11, FormatDateTime('dd mmm yyyy', tbDateImpData.Value), taLeftJustify);
        WriteField( 19, 60, ': '+tbDateImpNota.Value, taLeftJustify);
        Print;
      end;
    end;
    tbDateImp.Next;
  end;
end;

procedure TrepDatiContatto.ShowComunic;
var
  tmp: string;
  Tipo: integer;
begin
  Tipo:= tbConnessiTipo.Value;
  if (Tipo>=ctCnnPrimo) and (Tipo<=ctCnnUltimo) then begin
    tmp:= ConnDesc[Tipo];
  end
  else tmp:= '';
  with Rep do begin
    with PrepareLine do begin
      Tab(6); Write('Elenco oggetti connessi al contatto:');
      Print;
    end;
  end;
  while not tbConnessi.EOF do begin
    with Rep do begin
      with PrepareLine do begin
        WriteField(  7, 11, FormatDateTime('dd mmm yyyy', tbConnessiData.Value), taLeftJustify);
        WriteField( 19, 13, tmp, taLeftJustify);
        WriteField( 33, 35, tbConnessiContenuto.Value, taLeftJustify);
        WriteField( 69, 29, DecodeMemo(tbConnessiNote, ' ', 0), taLeftJustify);
        Print;
      end;
    end;
    tbConnessi.Next;
  end;
end;

procedure TrepDatiContatto.ShowTelef;
var
  tmp: string;
  Tipo: integer;
begin
  Tipo:= tbTelefTipo.Value;
  if (Tipo>=ctTelPrimo) and (Tipo<=ctTelUltimo) then begin
    tmp:= TeleDesc[Tipo];
  end
  else tmp:= '';
  with Rep do begin
    with PrepareLine do begin
      WriteField( 6,  4, 'Tel.', taRightJustify);
      WriteField(11, 15, tmp, taLeftJustify);
      WriteField(27, 20, _DecodeTelefono(tbTelef), taRightJustify);
      WriteField(48, 50, tbTelefNote.Value, taLeftJustify);
      Print;
    end;
  end;
end;

procedure TrepDatiContatto.ShowRefer(const Msg, FldName: string; tb: TTable);
var
  Cod: longint;
begin
  with Rep do begin
    with PrepareLine do begin
      Tab(6); Write(Msg);
      Print;
    end;
  end;
  while not tb.EOF do begin
    Cod:= tb.FieldByName(FldName).AsInteger;
    if tbContat2.FindKey([Cod]) then begin
      with Rep do begin
        with PrepareLine do begin
          WriteField(  6,  1, '-', taLeftJustify);
          WriteField(  8, 60, _DecodeNome(tbContat2), taLeftJustify);
          Print;
        end;
      end;
    end;
    tb.Next;
  end;
end;

procedure TrepDatiContatto.ShowInGruppi;
var
  tmp: string;
  flg: boolean;
  Offset: integer;
begin
  tmp:= 'Gruppi di appartenenza: ';
  flg:= false;
  OffSet:= 0;
  while not tbInGruppi.EOF do begin
    if tbGruppi.FindKey([tbInGruppiCodGrp.Value]) then begin
      if flg then tmp:= tmp+', ';
      flg:= true;
      if length(tmp) + length(tbNickNameNickName.Value) > 95-6 then begin
        with Rep do begin
          with PrepareLine do begin
            Tab(6+Offset); Write(tmp);
            Offset:= 1;
            Print;
          end;
        end;
        tmp:= '';
      end;
      tmp:= tmp + tbGruppiDesc.Value;
      tbInGruppi.Next;
    end;
    tbIngruppi.Next;
  end;
  if tmp <> '' then begin
    with Rep do begin
      with PrepareLine do begin
        Tab(6+OffSet); Write(tmp);
        Print;
      end;
    end;
  end;
end;

function TrepDatiContatto.MakeReport(const Device: string; const Flag: array of boolean): boolean;
var
  OldCursor: integer;
  Base: integer;
begin
  Rep.DeviceKind:= Device;
  Rep.ReportName:= 'Elenco Telefonico';
  Rep.PageHeight:= Opzioni.RigheRep;
  OldCursor:= Screen.Cursor;
  Screen.Cursor:= crHourglass;
  Base:= low(Flag)-1;
  Result:= true;
  try
    if Flag[Base + 2] then tbNickName.Open;
    if Flag[Base + 3] then tbTelef.Open;
    if Flag[Base + 4] then tbIndir.Open;
    if Flag[Base + 5] then tbDateImp.Open;
    if Flag[Base + 6] then begin tbRefer.Open; tbReferDi.Open; tbContat2.Open; end;
    if Flag[Base + 7] then tbConnessi.Open;
    if Flag[Base + 8] then begin tbInGruppi.Open; tbGruppi.Open; end;
    tbContat.IndexName:= Order;
    tbContat.Open;
    Prog:= 0;
    try
      Rep.BeginReport;
      tbContat.First;
      while not tbContat.EOF do begin
        Rep.Reserve(2);
        ShowContat(Flag[Base + 1]);
        (* Stampa soprannomi *)
        if Flag[Base + 2] then begin
          tbNickName.First;
          if not tbNickName.EOF then begin
            Rep.Reserve(2);
            ShowNickName;
          end;
        end;
        (* Stampa indirizzi *)
        if Flag[Base + 4] then begin
          tbIndir.First;
          Rep.Reserve(tbIndir.RecordCount+1);
          while not tbIndir.EOF do begin
            ShowIndir;
            tbIndir.Next;
          end;
        end;
        (* Stampa telefoni *)
        if Flag[Base + 3] then begin
          tbTelef.First;
          Rep.Reserve(tbTelef.RecordCount+1);
          while not tbTelef.EOF do begin
            ShowTelef;
            tbTelef.Next;
          end;
        end;
        (* Stampa date importanti *)
        if Flag[Base + 5] then begin
          tbDateImp.First;
          if not tbDateImp.EOF then begin
            Rep.Reserve(tbDateImp.RecordCount+2);
            ShowDateImp;
          end;
        end;
        (* Stampa referenti *)
        if Flag[Base + 6] then begin
          tbRefer.First;
          if not tbRefer.EOF then begin
            Rep.Reserve(tbRefer.RecordCount+2);
            ShowRefer('Referenti:', 'CodRef', tbRefer);
          end;
          tbReferDi.First;
          if not tbReferDi.EOF then begin
            Rep.Reserve(tbReferDi.RecordCount+2);
            ShowRefer('Referente per:', 'CodCon', tbReferDi);
          end;
        end;
        (* Stampa comunicazioni *)
        if Flag[Base + 7] then begin
          tbConnessi.First;
          if not tbConnessi.EOF then begin
            Rep.Reserve(tbConnessi.RecordCount+2);
            ShowComunic;
          end;
        end;
        (* Stampa comunicazioni *)
        if Flag[Base + 8] then begin
          tbInGruppi.First;
          if not tbInGruppi.EOF then begin
            Rep.Reserve(2);
            ShowInGruppi;
          end;
        end;
        tbContat.Next;
        Rep.LineFeed;
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
    tbIndir.Active:= false;
    tbTelef.Active:= false;
    tbNickName.Active:= false;
    tbDateImp.Active:= false;
    tbRefer.Active:= false;
    tbReferDi.Active:= false;
    tbContat2.Active:= false;
    tbConnessi.Active:= false;
    tbInGruppi.Active:= false;
    tbGruppi.Active:= false;
    tbContat.Close;
  end;
end;

procedure TrepDatiContatto.RepPageHeader(Rep: TeLineReport);
begin
  with Rep do begin
    with PrepareLine do begin
      Tab(  1); Write('');
      Tab( 40); WriteC('***   ELENCO  DATI  CONTATTI   ***');
      Tab( 80); Write('Pag. '+IntToStr(CurPag));
      Print;
    end;
    WritePattern('-');
    LineFeed;
  end;
end;

procedure TrepDatiContatto.RepPageFooter(Rep: TeLineReport);
begin
  with Rep do begin
    LineFeed;
    WritePattern('-');
  end;
end;

procedure TrepDatiContatto.RepSetupDevice(Rep: TeLineReport;
  Dev: TOutputDevice);
begin
  dmContatti.SetupOutputDevice(Dev);
end;

function ReportDatiContatto(const Order: string; const Flag: array of boolean; const Device: string): boolean;
var
  repDatiContatto: TrepDatiContatto;
begin
  repDatiContatto:= nil;
  try
    repDatiContatto:= TrepDatiContatto.Create(nil);
    repDatiContatto.Order:= Order;
    Result:= repDatiContatto.MakeReport(Device, Flag);
  finally
    repDatiContatto.Free;
  end;
end;

end.

