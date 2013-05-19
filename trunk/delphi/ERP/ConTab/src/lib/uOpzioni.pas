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
     FRigheRep: integer;
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
     property LocalINI: string read FLocalINI;
     property NomeDitta: string read FNomeDitta write FNomeDitta;
     property PrinterIndex: integer read FPrinterIndex write FPrinterIndex;
     property PrinterFontName: string read FPrinterFontName write FPrinterFontName;
     property PrinterFontSize: integer read FPrinterFontSize write FPrinterFontSize;
     property RigheRep: integer read FRigheRep write FRigheRep;
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
  FLocalINI:= FBasePath+'conf\settings.ini';
  LoadParam;
end;

procedure TOpzioni.LoadParam;
var
  INI: TINIFile;
begin
  INI:= TINIFile.Create(BasePath+'conf\settings.ini');
  FDefaultDB:= INI.ReadString(sezDB, keyDefaultDB, defDefaultDB);
  FPrinterIndex:= INI.ReadInteger(sezPrinter, keyPrinterIndex, defPrinterIndex);
  FPrinterFontName:= INI.ReadString(sezPrinter, keyPrinterFontName, defPrinterFontName);
  FPrinterFontSize:= INI.ReadInteger(sezPrinter, keyPrinterFontSize, defPrinterFontSize);
  FRigheRep:= INI.ReadInteger(sezPrinter, keyRigheRep, defRigheRep);
  FNomeDitta:= INI.ReadString(sezConTab, keyNomeDitta, defNomeDitta);
  FDataOggi:= DateUtil.YMDToDate(INI.ReadString(sezConTab, keyDataOggi, defDataOggi), false);
  FDataTranStampate:= DateUtil.YMDToDate(INI.ReadString(sezConTab, keyDataTranStampate, defDataTranStampate), false);
  FDataCorrTrasf:= DateUtil.YMDToDate(INI.ReadString(sezConTab, keyDataCorrTrasf, defDataCorrTrasf), false);
  FDataFatFTrasf:= DateUtil.YMDToDate(INI.ReadString(sezConTab, keyDataFatFTrasf, defDataFatFTrasf), false);
  FDataFatCTrasf:= DateUtil.YMDToDate(INI.ReadString(sezConTab, keyDataFatCTrasf, defDataFatCTrasf), false);
  FDataCorrStamp:= DateUtil.YMDToDate(INI.ReadString(sezConTab, keyDataCorrStamp, defDataCorrStamp), false);
  FDataFatFStamp:= DateUtil.YMDToDate(INI.ReadString(sezConTab, keyDataFatFStamp, defDataFatFStamp), false);
  FDataFatCStamp:= DateUtil.YMDToDate(INI.ReadString(sezConTab, keyDataFatCStamp, defDataFatCStamp), false);
  FCodCassa:= INI.ReadInteger(sezConTab, keyCodCassa, defCodCassa);
  FCodForni:= INI.ReadInteger(sezConTab, keyCodForni, defCodForni);
  FCodClien:= INI.ReadInteger(sezConTab, keyCodClien, defCodClien);
  FCodIVADe:= INI.ReadInteger(sezConTab, keyCodIVADe, defCodIVADe);
  FCodIVACr:= INI.ReadInteger(sezConTab, keyCodIVACr, defCodIVACr);
  FCodIVAND:= INI.ReadInteger(sezConTab, keyCodIVAND, defCodIVAND);
  INI.Free;
end;

procedure TOpzioni.SaveParam;
var
  INI: TINIFile;
begin
  INI:= TINIFile.Create(BasePath+'conf\settings.ini');
  INI.WriteString(sezDB, keyDefaultDB, FDefaultDB);
  INI.WriteInteger(sezPrinter, keyPrinterIndex, FPrinterIndex);
  INI.WriteString(sezPrinter, keyPrinterFontName, FPrinterFontName);
  INI.WriteInteger(sezPrinter, keyPrinterFontSize, FPrinterFontSize);
  INI.WriteInteger(sezPrinter, keyRigheRep, FRigheRep);
  INI.WriteString(sezConTab, keyNomeDitta, FNomeDitta);
  INI.WriteString(sezConTab, keyDataOggi, DateUtil.DateToYMD(FDataOggi, false));
  INI.WriteString(sezConTab, keyDataTranStampate, DateUtil.DateToYMD(FDataTranStampate, false));
  INI.WriteString(sezConTab, keyDataCorrTrasf, DateUtil.DateToYMD(FDataCorrTrasf, false));
  INI.WriteString(sezConTab, keyDataFatFTrasf, DateUtil.DateToYMD(FDataFatFTrasf, false));
  INI.WriteString(sezConTab, keyDataFatCTrasf, DateUtil.DateToYMD(FDataFatCTrasf, false));
  INI.WriteString(sezConTab, keyDataCorrStamp, DateUtil.DateToYMD(FDataCorrStamp, false));
  INI.WriteString(sezConTab, keyDataFatFStamp, DateUtil.DateToYMD(FDataFatFStamp, false));
  INI.WriteString(sezConTab, keyDataFatCStamp, DateUtil.DateToYMD(FDataFatCStamp, false));
  INI.WriteInteger(sezConTab, keyCodCassa, FCodCassa);
  INI.WriteInteger(sezConTab, keyCodForni, FCodForni);
  INI.WriteInteger(sezConTab, keyCodClien, FCodClien);
  INI.WriteInteger(sezConTab, keyCodIVADe, FCodIVADe);
  INI.WriteInteger(sezConTab, keyCodIVACr, FCodIVACr);
  INI.WriteInteger(sezConTab, keyCodIVAND, FCodIVAND);
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

