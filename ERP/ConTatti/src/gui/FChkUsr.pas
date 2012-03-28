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
unit FChkUsr;

interface

uses
  Windows, Classes, SysUtils, Graphics, Forms, Controls, Buttons,
  StdCtrls, INIFiles, Dialogs, IceLock;

type                            
  TfmCheckUser = class(TForm)
    btOk: TBitBtn;
    btCancel: TBitBtn;
    Label1: TLabel;
    iPassword: TEdit;
    btAbout: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btAboutClick(Sender: TObject);
  private
    { Private declarations }
    RemTry: integer;
    IL: TIceLock;
    Magic: word;
  public
    { Public declarations }
  end;

type
  CheckUserResult = (cuOk, cuManomesso, cuAbort);

function  CheckUser(aIL: TIceLock; aMagic: word): CheckUserResult;
function  CheckPassword(pwd: string): boolean;
function  GetPassword(var pwd: string): boolean;
procedure SetPassword(pwd: string);

implementation

{$R *.DFM}

uses
  Costanti, eLibCore, uOpzioni, DContat, FAboutBox;

procedure GetMagic(var Magic: longint; var Old, New: string);
var
  OldRan: longint;
begin
  OldRan:= RandSeed;
  RandSeed:= Magic;
  Magic:= Random(9000)+1000;
  Old:= IntToStr(Random(9000)+1000);
  New:= IntToStr(Magic);
  RandSeed:= OldRan;
end;

function GetPassword(var pwd: string): boolean;
var
  Magic: longint;
  Pass : string;
  Old: string;
  New: string;
begin
  Magic:= dmContatti.GetInfoInt(namMagicNum, defMagicNum);
  Pass := Encoding.HexDecode(dmContatti.GetInfoStr(namPassword, defPassword));
  GetMagic(Magic, Old, New);
  Pass:= Crypt.SimpleDecrypt(Pass, Old);
  Result:= Copy(Pass,1,8)='Eic_'+New;
  pwd:= copy(Pass,9,length(pass)-8);
end;

procedure SetPassword(pwd: string);
var
  Magic: longint;
  Old,New: string;
begin
  Magic:= dmContatti.GetInfoInt(namMagicNum, defMagicNum);
  GetMagic(Magic, Old, New);
  dmContatti.SetInfoStr(namMagicNum, IntToStr(Magic));
  GetMagic(Magic, Old, New);
  pwd:= Crypt.SimpleCrypt(Pwd,Pwd);
  pwd:= Crypt.SimpleCrypt('Eic_'+New+pwd, Old);
  dmContatti.SetInfoStr(namPassword, Encoding.HexEncode(pwd));
end;

function CheckPassword(pwd: string): boolean;
var
  txt: string;
begin
  GetPassword(txt);
  Result:= (txt='') or (txt=Crypt.SimpleCrypt(pwd, pwd));
end;

function CheckUser(aIL: TIceLock; aMagic: word): CheckUserResult;
var
  fmCheckUser: TfmCheckUser;
  txt: string;
begin
  if not GetPassword(txt) then begin
    (* manomissione password *)
    Result:= cuManomesso;
    exit;
  end;
  Result:= cuOk;
  if txt = '' then exit;
  fmCheckUser:= nil;
  try
    fmCheckUser:= TfmCheckUser.Create(nil);
    fmCheckUser.IL:= aIL;
    fmCheckUser.Magic:= aMagic;
    case fmCheckUser.ShowModal of
      mrOk: Result:= cuOk;
      else Result:= cuAbort;
    end;
  finally
    fmCheckUser.Free;
  end;
end;

procedure TfmCheckUser.FormShow(Sender: TObject);
begin
  iPassword.Text:= '';
  RemTry:= 3;
end;

procedure TfmCheckUser.btOkClick(Sender: TObject);
begin
  if CheckPassword(Trim(iPassword.Text)) then begin
    ModalResult:= mrOk;
  end
  else begin
    dec(RemTry);
    if RemTry = 0 then begin
      ModalResult:= mrCancel;
    end
    else begin
      MessageDlg('La password non è corretta!', mtError, [mbOk], 0);
    end;
  end;
end;

procedure TfmCheckUser.btAboutClick(Sender: TObject);
begin
  About(IL, Magic, true);
end;

end.

