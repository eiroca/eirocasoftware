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
(* Routine comuni contatti *)
unit ContComm;

{$IFDEF VER80} {$DEFINE SHORTSTRING} {$ENDIF}
{$IFDEF VER70} {$DEFINE SHORTSTRING} {$ENDIF}

interface

uses
  Classes, SysUtils, Forms, DB, DBCtrls, DBTables;

const
  (* Tipi di contatti *)
  ctConPersona = 0;  ctConPrimo  = 0;
  ctConAzienda = 1;  ctConUltimo = 1;

  ctIndTradiz  = 0;  ctIndPrimo  = 0;
  ctIndElettr  = 1;  ctIndUltimo = 1;

  ctTelNormal  = 0;  ctTelPrimo  = 0;
  ctTelFax     = 1;
  ctTelFaxVoc  = 2;
  ctTelSegret  = 3;  ctTelUltimo = 3;

  ctCnnComunic = 0;  ctCnnPrimo  = 0;
  ctCnnFile    = 1;
  ctCnnURL     = 2;  ctCnnUltimo = 2;

const
  ContDesc: array[ctConPrimo..ctConUltimo] of string[20] = ('Persona','Azienda');
  IndiDesc: array[ctIndPrimo..ctIndUltimo] of string[20] = ('Tradizionale','Elettronico');
  TeleDesc: array[ctTelPrimo..ctTelUltimo] of string[20] = ('Normale','Fax','Fax + Voce','Casella vocale');
  ConnDesc: array[ctCnnPrimo..ctCnnUltimo] of string[20] = ('Comunicazione','Risorsa file', 'Risorsa - URL');

function DecodeMemo(fld: TField; const Sep: string; Righe: integer): string;

function DecodeNome(DataSet: TDataSet; Tito, Pre2: boolean): string;
function DecodeTelefono(DataSet: TDataSet; Long, Self: boolean; const Pre1, Pre2: string): string;
function DecodeIndirizzo(fld: TField; Righe: integer): string;

function _DecodeNome(DataSet: TDataSet): string;
function _DecodeTelefono(DataSet: TDataSet): string;
function _DecodeIndirizzo(DataSet: TDataSet): string;

function SplitName(const Nome: string; var NomeMain, NomePre: string): boolean;
function SplitTel(Tel: string; var Pre1, Pre2, Num: string): boolean;
function SplitInd(Ind: string; S: TStrings): boolean;

implementation

uses
  uOpzioni, eLibCore, StdCtrls;

procedure Add(var s: string; const Frst, Pre, tmp, Suf: string);
begin
  if tmp <> '' then begin
    if s = '' then s:= Frst+tmp+Suf
    else s:= s+Pre+tmp+Suf;
  end;
end;

function DecodeNome(DataSet: TDataSet; Tito, Pre2: boolean): string;
begin
  Result:= '';
  if Tito then Add(Result, '', ' ', Trim(DataSet.FieldByName('Nome_Tit').AsString),  '');
               Add(Result, '', ' ', Trim(DataSet.FieldByName('Nome_Pre1').AsString),  '');
  if Pre2 then Add(Result, '', ' ', Trim(DataSet.FieldByName('Nome_Pre2').AsString),  '');
               Add(Result, '', ' ', Trim(DataSet.FieldByName('Nome_Main').AsString), '');
  if Tito then Add(Result, '', ' ', Trim(DataSet.FieldByName('Nome_Suf').AsString),  '');
end;

function DecodeTelefono(DataSet: TDataSet; Long, Self: boolean; const Pre1, Pre2: string): string;
var
  tmp: string;
  flg: boolean;
begin
  Result:= '';
  flg:= true;
  if Long then begin
    tmp:= Trim(DataSet.FieldByName('Tel_Pre1').AsString);
    if Self and (tmp=Pre1) then tmp:= ''
    else flg:= false;
    Add(Result, '+', '', tmp, ' ');
  end;
  tmp:= Trim(DataSet.FieldByName('Tel_Pre2').AsString);
  if Self and flg and (tmp=Pre2) then tmp:= '';
  Add(Result, '', '', tmp, '-');
  Add(Result, '', '', Trim(DataSet.FieldByName('Telefono').AsString), '');
end;

function DecodeMemo(fld: TField; const Sep: string; Righe: integer): string;
var
  SL: TStrings;
  s: string;
  i: integer;
begin
  Result:= '';
  SL:= TStringList.Create;
  SL.Assign(fld);
  if (Righe <= 0) then Righe:= SL.Count;
  for i:= 0 to SL.Count-1 do begin
    s:= Trim(SL[i]);
    if s = '' then continue;
    dec(Righe);
    if Righe >= 0 then begin
      if Result <> '' then Result:= Result + Sep + s
      else Result:= s;
    end
    else break;
  end;
  SL.Free;
end;

function DecodeIndirizzo(fld: TField; Righe: integer): string;
begin
  Result:= DecodeMemo(Fld, ' - ', Righe);
end;

function _DecodeNome(DataSet: TDataSet): string;
begin
  Result:= DecodeNome(DataSet, Opzioni.ShowTito, Opzioni.ShowPre2);
end;

function _DecodeTelefono(DataSet: TDataSet): string;
begin
  Result:= DecodeTelefono(DataSet, Opzioni.IntPref, Opzioni.SelfPref, Opzioni.DefPrefix1, Opzioni.DefPrefix2);   
end;

function _DecodeIndirizzo(DataSet: TDataSet): string;
begin
  Result:= DecodeIndirizzo(DataSet.FieldByName('Indirizzo'), Opzioni.RigheInd);
end;

function SplitName(const Nome: string; var NomeMain, NomePre: string): boolean;
var
  ps: integer;
begin
  Result:= true;
  NomeMain:= '';
  NomePre := '';
  try
    ps:= Pos(',', Nome);
    if ps > 0 then begin
      NomeMain:= Trim(Copy(Nome, 1, ps-1));
      NomePre := Trim(Copy(Nome, ps+1, length(Nome)));
    end
    else begin
      NomeMain:= Nome;
      NomePre:= '';
    end;
  except
    Result:= false;
  end;
end;

function SplitTel(Tel: string; var Pre1, Pre2, Num: string): boolean;
type
  Stati = (pref1, numero);
var
  Stato: Stati;
  ch: char;
  i: integer;
begin
  Result:= true;
  Pre1:= '';
  Pre2:= '';
  Num:= '';
  try
    Stato:= numero;
    Tel:= Trim(Tel);
    for i:= 1 to length(tel) do begin
      ch:= Tel[i];
      case Stato of
        numero: begin
          if ch = '+' then Stato:= pref1
          else if (ch in [' ', '-', '/', '\']) and (Pre2='') then begin
            Pre2:= Num;
            Num:= '';
          end
          else if (ch in [' ', '-', '/', '\']) and (Pre1='') then begin
            Pre1:= Pre2;
            Pre2:= Num;
            Num:= '';
          end
          else begin
            Num:= Num + ch;
          end;
        end;
        pref1: begin
          if (ch in [' ', '-', '/', '\']) then Stato:= numero;
          Pre1:= Pre1+ch;
        end;
      end;
    end;
  except
    Result:= false;
  end;
end;

function SplitInd(Ind: string; S: TStrings): boolean;
var
  tmp: string;
  ch: char;
  i: integer;
begin
  Result:= true;
  S.Clear;
  try
    Ind:= Trim(Ind);
    tmp:= '';
    for i:= 1 to length(Ind) do begin
      ch:= Ind[i];
      if ch = '-' then begin
        tmp:= Trim(tmp);
        if tmp <> '' then begin
          S.Add(tmp);
          tmp:= '';
        end;
      end
      else tmp:= tmp + ch;
    end;
    tmp:= Trim(tmp);
    if tmp <> '' then S.Add(tmp);
  except
    Result:= false;
  end;
end;

end.



