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
unit uOpzioni;

interface

uses
  SysUtils, Classes, INIFiles;

type
  TOpzioni = class
    private
     FProgPath: string;
     FProgName: string;
     FLocalINI: string;
     FPrinterIndex: integer;
     FPrinterFontName: string;
     FPrinterFontSize: integer;
     FRigheRep: integer;
     FDefaultDB: string;
     FYourSelf: longint;
     FDefPrefix1: string;
     FDefPrefix2: string;
     FRigheInd  : integer;
     FIntPref: boolean;
     FAutoInsertDataImpo: boolean;
     FInsertDataImpoNota: string;
     FAutoInsertTelef: boolean;
     FAutoInsertIndir: boolean;
     FPostEdit: boolean;
     FPostInsert: boolean;
     FShowTito: boolean;
     FShowPre2: boolean;
     FSortCol : integer;
    public
     property ProgPath: string read FProgPath;
     property ProgName: string read FProgName;
     property LocalINI: string read FLocalINI;
     property PrinterIndex: integer read FPrinterIndex write FPrinterIndex;
     property PrinterFontName: string read FPrinterFontName write FPrinterFontName;
     property PrinterFontSize: integer read FPrinterFontSize write FPrinterFontSize;
     property RigheRep: integer read FRigheRep write FRigheRep;
     property DefaultDB: string read FDefaultDB write FDefaultDB;
     property YourSelf: longint read FYourSelf write FYourSelf;
     property DefPrefix1: string read FDefPrefix1 write FDefPrefix1;
     property DefPrefix2: string read FDefPrefix2 write FDefPrefix2;
     property RigheInd  : integer read FRigheInd  write FRigheInd;
     property IntPref: boolean read FIntPref write FIntPref;
     property SelfPref: boolean read FIntPref write FIntPref;
     property AutoInsertDataImpo: boolean read FAutoInsertDataImpo write FAutoInsertDataImpo;
     property InsertDataImpoNota: string  read FInsertDataImpoNota write FInsertDataImpoNota;
     property AutoInsertTelef: boolean read FAutoInsertTelef write FAutoInsertTelef;
     property AutoInsertIndir: boolean read FAutoInsertIndir write FAutoInsertIndir;
     property PostEdit: boolean read FPostEdit write FPostEdit;
     property PostInsert: boolean read FPostInsert write FPostInsert;
     property ShowTito: boolean read FShowTito write FShowTito;
     property ShowPre2: boolean read FShowPre2 write FShowPre2;
     property SortCol: integer read FSortCol write FSortCol;
    public
     constructor Create;
     procedure   LoadParam;
     procedure   SaveParam;
     destructor  Destroy; override;
  end;

var
  Opzioni: TOpzioni;

implementation

uses
  eLibCore, Costanti;

constructor TOpzioni.Create;
var
  i: integer;
begin
  FProgPath:= ExtractFilePath(ParamStr(0));
  FProgName:= ExtractFileName(ParamStr(0));
  if Pos('.', FProgName) <> 0 then begin
    for i:= length(FProgName) downto 1 do begin
      if FProgName[i]='.' then begin
        Delete(FProgName, i, length(FProgName)-i+1);
        break;
      end;
    end;
  end;
  FLocalINI:= FProgPath+FProgName+'.INI';
  LoadParam;
end;

procedure TOpzioni.LoadParam;
var
  INI: TINIFile;
begin
  INI:= TINIFile.Create(ProgPath+ProgName+'.INI');
  FPrinterIndex:= INI.ReadInteger(sezOpzioni, keyPrinterIndex, defPrinterIndex);
  FPrinterFontName:= INI.ReadString(sezOpzioni, keyPrinterFontName, defPrinterFontName);
  FPrinterFontSize:= INI.ReadInteger(sezOpzioni, keyPrinterFontSize, defPrinterFontSize);
  FRigheRep:= INI.ReadInteger(sezOpzioni, keyRigheRep, defRigheRep);
  FDefaultDB := INI.ReadString(sezDB, keyDefaultDB, defDefaultDB);
  FYourSelf  := INI.ReadInteger(sezContatti, keyYourSelf, defYourSelf);
  FIntPref   := INI.ReadInteger(sezContatti, keyIntPref, defIntPref) <> 0;
  FDefPrefix1:= INI.ReadString(sezContatti, keyDefPrfx1, defDefPrfx1);
  FDefPrefix2:= INI.ReadString(sezContatti, keyDefPrfx2, defDefPrfx2);
  FRigheInd  := INI.ReadInteger(sezContatti, keyRigheInd, defRigheInd);
  FAutoInsertDataImpo:= INI.ReadInteger(sezContatti, keyAutoInsertDataImpo, defAutoInsertDataImpo) <> 0;
  FInsertDataImpoNota:= INI.ReadString (sezContatti, keyInsertDataImpoNota, defInsertDataImpoNota);
  FAutoInsertTelef:= INI.ReadInteger(sezContatti, keyAutoInsertTelef, defAutoInsertTelef) <> 0;
  FAutoInsertIndir:= INI.ReadInteger(sezContatti, keyAutoInsertIndir, defAutoInsertIndir) <> 0;
  FPostEdit:= INI.ReadInteger(sezContatti, keyPostEdit, defPostEdit) <> 0;
  FPostInsert:= INI.ReadInteger(sezContatti, keyPostInsert, defPostInsert) <> 0;
  FShowTito:= INI.ReadInteger(sezContatti, keyShowTito, defShowTito) <> 0;
  FShowPre2:= INI.ReadInteger(sezContatti, keyShowPre2, defShowPre2) <> 0;
  FSortCol:= INI.ReadInteger(sezContatti, keySortCol, defSortCol);
  INI.Free;
end;

procedure TOpzioni.SaveParam;
const
  BoolToInt: array[false..true] of integer = (0, 1);
var
  INI: TINIFile;
begin
  INI:= TINIFile.Create(ProgPath+ProgName+'.INI');
  INI.WriteString (sezDB, keyDefaultDB, FDefaultDB);
  INI.WriteInteger(sezOpzioni,  keyPrinterIndex, FPrinterIndex);
  INI.WriteString (sezOpzioni,  keyPrinterFontName, FPrinterFontName);
  INI.WriteInteger(sezOpzioni,  keyPrinterFontSize, FPrinterFontSize);
  INI.WriteInteger(sezOpzioni,  keyRigheRep, FRigheRep);
  INI.WriteInteger(sezContatti, keyYourSelf, FYourSelf);
  INI.WriteInteger(sezContatti, keyIntPref, BoolToInt[FIntPref]);
  INI.WriteString (sezContatti, keyDefPrfx1, FDefPrefix1);
  INI.WriteString (sezContatti, keyDefPrfx2, FDefPrefix2);
  INI.WriteInteger(sezContatti, keyRigheInd, FRigheInd);
  INI.WriteString (sezContatti, keyInsertDataImpoNota, FInsertDataImpoNota);
  INI.WriteInteger(sezContatti, keyAutoInsertDataImpo, BoolToInt[FAutoInsertDataImpo]);
  INI.WriteInteger(sezContatti, keyAutoInsertTelef, BoolToInt[FAutoInsertTelef]);
  INI.WriteInteger(sezContatti, keyAutoInsertIndir, BoolToInt[FAutoInsertIndir]);
  INI.WriteInteger(sezContatti, keyPostEdit, BoolToInt[FPostEdit]);
  INI.WriteInteger(sezContatti, keyPostInsert, BoolToInt[FPostInsert]);
  INI.WriteInteger(sezContatti, keyShowTito, BoolToInt[FShowTito]);
  INI.WriteInteger(sezContatti, keyShowPre2, BoolToInt[FShowPre2]);
  INI.WriteInteger(sezContatti, keySortCol, FSortCol);
  INI.Free;
end;

destructor  TOpzioni.Destroy;
begin
  SaveParam;
end;

procedure InitOpzioni;
begin
  Opzioni:= TOpzioni.Create;
end;

procedure DestroyOpzioni; far;
begin
  Opzioni.Free;
end;

initialization
  InitOpzioni;
  AddExitProc(DestroyOpzioni);
end.

