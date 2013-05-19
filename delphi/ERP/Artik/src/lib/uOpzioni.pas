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
unit UOpzioni;

interface

uses
  SysUtils, Classes, INIFiles;

type
  TOpzioni = class
    private
     FBasePath: string;
     FProgName: string;
     FLocalINI: string;
     FDefaultDB: string;
     FPrinterIndex: integer;
     FPrinterFontName: string;
     FPrinterFontSize: integer;

     FNomeDitta: string;
     FDataOggi: TDateTime;
     FDataTranStampate: TDateTime;
     FDataCorrTrasf: TDateTime;
     FDataFatFTrasf: TDateTime;
     FDataFatCTrasf: TDateTime;
     FDataCorrStamp: TDateTime;
     FDataFatFStamp: TDateTime;
     FDataFatCStamp: TDateTime;

     FCodCassa: longint;
     FCodForni: longint;
     FCodClien: longint;
     FCodIVADe: longint;
     FCodIVACr: longint;
     FCodIVAND: longint;
    public
     property BasePath: string read FBasePath;
     property ProgName: string read FProgName;
     property PrinterIndex: integer read FPrinterIndex write FPrinterIndex;
     property PrinterFontName: string read FPrinterFontName write FPrinterFontName;
     property PrinterFontSize: integer read FPrinterFontSize write FPrinterFontSize;
     property NomeDitta: string read FNomeDitta write FNomeDitta;

     property DefaultDB: string read FDefaultDB write FDefaultDB;
     property DataOggi: TDateTime read FDataOggi write FDataOggi;
     property DataTranStampate: TDateTime read FDataTranStampate write FDataTranStampate;
     property DataCorrTrasf: TDateTime read FDataCorrTrasf write FDataCorrTrasf;
     property DataFatFTrasf: TDateTime read FDataFatFTrasf write FDataFatFTrasf;
     property DataFatCTrasf: TDateTime read FDataFatCTrasf write FDataFatCTrasf;
     property DataCorrStamp: TDateTime read FDataCorrStamp write FDataCorrStamp;
     property DataFatFStamp: TDateTime read FDataFatFStamp write FDataFatFStamp;
     property DataFatCStamp: TDateTime read FDataFatCStamp write FDataFatCStamp;

     property CodCassa: longint read FCodCassa write FCodCassa;
     property CodForni: longint read FCodForni write FCodForni;
     property CodClien: longint read FCodClien write FCodClien;
     property CodIVADe: longint read FCodIVADe write FCodIVADe;
     property CodIVACr: longint read FCodIVACr write FCodIVACr;
     property CodIVAND: longint read FCodIVAND write FCodIVAND;
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
  FLocalINI:= BasePath+'conf\settings.ini';
  LoadParam;
end;

procedure TOpzioni.LoadParam;
var
  INI: TINIFile;
begin
  INI:= TINIFile.Create(FLocalINI);
  FDefaultDB:= INI.ReadString(sezDB, keyDefaultDB, defDefaultDB);
  FPrinterIndex:= INI.ReadInteger(sezOpzioni, keyPrinterIndex, defPrinterIndex);
  FPrinterFontName:= INI.ReadString(sezOpzioni, keyPrinterFontName, defPrinterFontName);
  FPrinterFontSize:= INI.ReadInteger(sezOpzioni, keyPrinterFontSize, defPrinterFontSize);
  INI.Free;
end;

procedure TOpzioni.SaveParam;
var
  INI: TINIFile;
begin
  INI:= TINIFile.Create(FLocalINI);
  INI.WriteString(sezDB, keyDefaultDB, FDefaultDB);
  INI.WriteInteger(sezOpzioni, keyPrinterIndex, FPrinterIndex);
  INI.WriteString(sezOpzioni, keyPrinterFontName, FPrinterFontName);
  INI.WriteInteger(sezOpzioni, keyPrinterFontSize, FPrinterFontSize);
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

initialization
  InitOpzioni;
finalization
  Opzioni.Free;
end.

