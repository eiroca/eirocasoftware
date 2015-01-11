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
unit DContat;

interface

uses
  SysUtils, Classes, Dialogs, IceLock, eLibDB, DB, DBTables, eReport, uOpzioni,
  Forms, eBDE;

const
  CC_REFRESH   = 0;
  CC_SELECTCON = 1;

  AK_NORMALE     = 0;
  AK_ELETTRONICO = 1;
  TK_NORMALE     = 0;
  TK_FAX         = 1;
  TK_FAXVOCE     = 2;
  TK_CASELLA     = 3;

type
  CheckProgResult=(psOk, psCondiviso, psManomesso, psScaduto);

var
  InfoPassword: string = 'st:ds9';

type
  TdmContatti = class(TDataModule)
    DB: TeDataBase;
    tbContat: TTable;
    DBConnection: TDBConnectionLink;
    tbInfo: TTable;
    IceLock: TIceLock;
    sdOutFile: TSaveDialog;
    procedure DataModuleCreate(Sender: TObject);
    function DBValidate(const Signature, Magic: string): Boolean;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DBConnectionConnect(Sender: TeDataBase; Connect: Boolean);
    procedure DBConnectionDisconnect(Sender: TeDataBase; Connect: Boolean);
    procedure IceLockLoadIceRecord(Sender: TIceLock; var Data: AIceArray);
    procedure IceLockSaveIceRecord(Sender: TIceLock; var Data: AIceArray);
  private
    { Private declarations }
  public
    { Public declarations }
    DBSignature: string;
    procedure Notify(Sender: TObject; Cmd: SmallInt; Data: TObject);
    function  GetCodConName(CodCon: integer): string;
    procedure OpenIndir(Who: longint; Kind: integer; const Ind: string);
    function  GetInfoStr(const Name: string; const DefVal: string): string;
    procedure SetInfoStr(const Name: string; const Val: string);
    function  GetInfoDbl(const Name: string; const DefVal: double): double;
    function  GetInfoInt(const Name: string; const DefVal: longint): longint;
    function  CheckProg: CheckProgResult;
    function  GetMagicKey: word;
    procedure SbloccaProg;
    procedure SetupOutputDevice(Dev: TOutputDevice);
  end;

var
  dmContatti: TdmContatti;

implementation

{$R *.dfm}

uses
  Costanti, eLibCore, ContComm, MakePrIn, eLibSystem,
  FChkUsr, FRegist;

procedure TdmContatti.DataModuleCreate(Sender: TObject);
var
  OldSeed: longint;
begin
  Session.AddPassword(DBPassword);
  Session.AddPassword(InfoPassword);
  DBSignature:= DB.Signature;
  tbInfo.DatabaseName:= Opzioni.ProgPath;
  CheckProgInfo(Opzioni.ProgPath, InfoPassword);
  tbInfo.Open;
  DBConnection.Active:= true;
  OldSeed:= RandSeed;
  IceLock.IceString1:= ClassName;
  IceLock.IceString1:= Application.Name;
  IceLock.IceSeed1:= 19724534;
  IceLock.IceSeed2:= 45240703;
  RandSeed:= OldSeed;
  IceLock.LoadKeyFile;
end;

procedure TdmContatti.DataModuleDestroy(Sender: TObject);
begin
  tbInfo.Close;
  DBConnection.Active:= false;
end;

procedure TdmContatti.DBConnectionConnect(Sender: TeDataBase;
  Connect: Boolean);
begin
  tbContat.Open;
end;

procedure TdmContatti.DBConnectionDisconnect(Sender: TeDataBase;
  Connect: Boolean);
begin
  tbContat.Close;
end;

function TdmContatti.DBValidate(const Signature, Magic: string): Boolean;
begin
  Result:= Magic = Crypt.SimpleCrypt(Signature, DBSignature);
end;

function TdmContatti.GetInfoStr(const Name: string; const DefVal: string): string;
begin
  if tbInfo.Locate('NAME', Name, []) then begin
    Result:= tbInfo.FieldByName('DATA').AsString;
  end
  else begin
    Result:= DefVal;
  end;
end;

procedure TdmContatti.SetInfoStr(const Name: string; const Val: string);
begin
  if tbInfo.Locate('NAME', Name, []) then begin
    tbInfo.Edit;
    tbInfo.FieldByName('DATA').AsString:= Val;
    tbInfo.Post;
  end
  else begin
    tbInfo.Append;
    tbInfo.FieldByName('NAME').AsString:= Name;
    tbInfo.FieldByName('DATA').AsString:= Val;
    tbInfo.Post;
  end
end;

function TdmContatti.GetInfoDbl(const Name: string; const DefVal: double): double;
begin
  Result:= Parser.DVal(GetInfoStr(Name, FloatToStr(DefVal)));
end;

function TdmContatti.GetInfoInt(const Name: string; const DefVal: longint): longint;
begin
  Result:= Parser.IVal(GetInfoStr(Name, IntToStr(DefVal)));
end;

function TdmContatti.GetCodConName(CodCon: integer): string;
begin
  if tbContat.FindKey([CodCon]) then begin
    Result:= _DecodeNome(tbContat);
  end
  else begin
    Result:= '';
  end;
end;

procedure TdmContatti.Notify(Sender: TObject; Cmd: SmallInt; Data: TObject);
begin
  DB.Notify(Sender, Cmd, Data);
end;

procedure TdmContatti.OpenIndir(Who: longint; Kind: integer; const Ind: string);
begin
  case Kind of
    AK_ELETTRONICO: begin
     Execute('open', Ind, '');
    end;
    AK_NORMALE: ;
  end;
end;

function  TdmContatti.CheckProg: CheckProgResult;
var
  MagicKey: longint;
  InstDate: TDateTime;
begin
  MagicKey:= GetMagicKey;
  InstDate:= GetInfoDbl('INSTDATE', 0);
  if (MagicKey = 0) and (InstDate = 0) then begin
    Randomize;
    SetInfoStr('MAGICKEY', IntToStr(random(65534)+1));
    SetInfoStr('INSTDATE', FloatToStr(Date));
    IceLock.PutKey(DefaultName, IceLock.BuildUserKey(DefaultName, true));
    IceLock.SaveKeyFile;
  end;
  DBSignature:= IntToStr(GetMagicKey);
  case IceLock.LoadKeyFile of
    ieOkay   : Result:= psOK;
    ieExpired: Result:= psScaduto;
    ieNotSameHD: Result:= psCondiviso;
    else Result:= psManomesso;
  end;
end;

function TdmContatti.GetMagicKey: word;
begin
  Result:= GetInfoInt('MAGICKEY', 0);
end;

procedure TdmContatti.IceLockLoadIceRecord(Sender: TIceLock;
  var Data: AIceArray);
var
  ps, i: integer;
  tmp: string;
begin
  tmp:= GetInfoStr('ICEDATA', '');
  tmp:= Encoding.HexDecode(tmp);
  for i:= low(data) to high(data) do begin
    ps:= i-low(data)+1;
    if i <= length(tmp) then Data[i]:= ord(tmp[ps])
    else Data[i]:= 0;
  end;
end;


procedure TdmContatti.IceLockSaveIceRecord(Sender: TIceLock;
  var Data: AIceArray);
var
  i: integer;
  tmp: string;
begin
  tmp:= '';
  for i:= low(data) to high(data) do begin
    tmp:= tmp+chr(Data[i]);
  end;
  tmp:= Encoding.HexEncode(tmp);
  SetInfoStr('ICEDATA', tmp);
end;

procedure TdmContatti.SbloccaProg;
begin
  DBSignature:= IntToStr(GetMagicKey);
  DB.Convalidate(DB.DBPath, Crypt.SimpleCrypt(DB.Signature, DBSignature));
  SetPassword('');
end;

procedure TdmContatti.SetupOutputDevice(Dev: TOutputDevice);
var
  Prn: TOutputPrinter;
begin
  if Dev is TOutputTextFile then begin
    if sdOutFile.Execute then begin
      TOutputTextFile(Dev).FileName:= sdOutFile.FileName;
      Dev.Report.PageHeight:= -1; (* nessun salto di pagina *)
    end
    else Abort;
  end
  else if Dev is TOutputPrinter then begin
    Prn:= TOutputPrinter(Dev);
    Prn.PrinterIndex:= Opzioni.PrinterIndex;
    Prn.Font.Name:= Opzioni.PrinterFontName;
    Prn.Font.Size:= Opzioni.PrinterFontSize;
  end;
end;

initialization
  InfoPassword:= uppercase(InfoPassword);
end.
