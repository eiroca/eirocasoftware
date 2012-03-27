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
     FDefaultDB: string;
    public
     property ProgPath: string read FProgPath;
     property ProgName: string read FProgName;
     property LocalINI: string read FLocalINI;
     property DefaultDB: string read FDefaultDB write FDefaultDB;
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
  FDefaultDB := INI.ReadString(sezDB, keyDefaultDB, defDefaultDB);
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

