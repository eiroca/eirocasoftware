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
unit UOpzioni;

interface

uses
  SysUtils, Classes, INIFiles;

type
  TOpzioni = class
    private
     FBasePath: string;
     FProgName: string;
     FDefaultDB: string;
     FRelPathStorico: string;
     FPrinterIndex: integer;
     FPrinterFontName: string;
     FPrinterFontSize: integer;
     FPrinterOffsetTop: integer;
     FPrinterOffsetBottom: integer;
     FPrinterOffsetLeft: integer;
     FPrinterOffsetRight: integer;
     FRighePag: integer;
     FRigheVid: integer;
    public
     property BasePath: string read FBasePath;
     property ProgName: string read FProgName;
     property DefaultDB: string read FDefaultDB write FDefaultDB;
     property RelPathStorico: string read FRelPathStorico write FRelPathStorico;
     property PrinterIndex: integer read FPrinterIndex write FPrinterIndex;
     property PrinterFontName: string read FPrinterFontName write FPrinterFontName;
     property PrinterFontSize: integer read FPrinterFontSize write FPrinterFontSize;
     property RighePag: integer read FRighePag write FRighePag;
     property RigheVid: integer read FRigheVid write FRigheVid;
     property PrinterOffsetTop: integer read FPrinterOffsetTop write FPrinterOffsetTop;
     property PrinterOffsetBottom: integer read FPrinterOffsetBottom write FPrinterOffsetBottom;
     property PrinterOffsetLeft: integer read FPrinterOffsetLeft write FPrinterOffsetLeft;
     property PrinterOffsetRight: integer read FPrinterOffsetRight write FPrinterOffsetRight;
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
  FBasePath:= ExtractFilePath(ParamStr(0));
  FProgName:= ExtractFileName(ParamStr(0));
  if Pos('.', FProgName) <> 0 then begin
    for i:= length(FProgName) downto 1 do begin
      if FProgName[i]='.' then begin
        Delete(FProgName, i, length(FProgName)-i+1);
        break;
      end;
    end;
  end;
  LoadParam;
end;

procedure TOpzioni.LoadParam;
var
  INI: TINIFile;
begin
  INI:= TINIFile.Create(BasePath+'conf\settings.ini');
  FDefaultDB:= INI.ReadString(sezDB, keyDefaultDB, defDefaultDB);
  FRelPathStorico:= INI.ReadString(sezDB, keyRelPathStorico, defRelPathStorico);
  FPrinterIndex:= INI.ReadInteger(sezPrinter, keyPrinterIndex, defPrinterIndex);
  FPrinterFontName:= INI.ReadString(sezPrinter, keyPrinterFontName, defPrinterFontName);
  FPrinterFontSize:= INI.ReadInteger(sezPrinter, keyPrinterFontSize, defPrinterFontSize);
  FRighePag:= INI.ReadInteger(sezPrinter, keyRighePag, defRighePag);
  FRigheVid:= INI.ReadInteger(sezPrinter, keyRigheVid, defRigheVid);
  FPrinterOffsetTop:= INI.ReadInteger(sezPrinter, keyPrinterOffsetTop, defPrinterOffsetTop);
  FPrinterOffsetBottom:= INI.ReadInteger(sezPrinter, keyPrinterOffsetBottom, defPrinterOffsetBottom);
  FPrinterOffsetLeft:= INI.ReadInteger(sezPrinter, keyPrinterOffsetLeft, defPrinterOffsetLeft);
  FPrinterOffsetRight:= INI.ReadInteger(sezPrinter, keyPrinterOffsetRight, defPrinterOffsetRight);
  INI.Free;
end;

procedure TOpzioni.SaveParam;
var
  INI: TINIFile;
begin
  INI:= TINIFile.Create(BasePath+'conf\settings.ini');
  INI.WriteString(sezDB, keyDefaultDB, FDefaultDB);
  INI.WriteString(sezDB, keyRelPathStorico, FRelPathStorico);
  INI.WriteInteger(sezPrinter, keyPrinterIndex, FPrinterIndex);
  INI.WriteString(sezPrinter, keyPrinterFontName, FPrinterFontName);
  INI.WriteInteger(sezPrinter, keyPrinterFontSize, FPrinterFontSize);
  INI.WriteInteger(sezPrinter, keyRighePag, FRighePag);
  INI.WriteInteger(sezPrinter, keyRigheVid, FRigheVid);
  INI.WriteInteger(sezPrinter, keyPrinterOffsetTop, FPrinterOffsetTop);
  INI.WriteInteger(sezPrinter, keyPrinterOffsetBottom, FPrinterOffsetBottom);
  INI.WriteInteger(sezPrinter, keyPrinterOffsetLeft, FPrinterOffsetLeft);
  INI.WriteInteger(sezPrinter, keyPrinterOffsetRight, FPrinterOffsetRight);
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

