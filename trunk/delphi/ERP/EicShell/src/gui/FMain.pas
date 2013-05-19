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
unit FMain;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Dialogs,
  Forms, Menus, DB, DBTables,
  StdCtrls, ShellServ, eDB, PrevInstance, JvBaseDlg, JvLoginForm,
  JvBDESecurity, JvComponentBase, JvAppStorage, JvAppIniStorage;

type
  TEicShellMenu = class(TForm)
    PrevInstance: TMgPrevInstance;
    MainMenu1: TMainMenu;
    mnFile: TMenuItem;
    miLogOn: TMenuItem;
    miChangePwd: TMenuItem;
    miLock: TMenuItem;
    N14: TMenuItem;
    miPackDB: TMenuItem;
    N1: TMenuItem;
    miExit: TMenuItem;
    Aiuto1: TMenuItem;
    Informazionisu1: TMenuItem;
    DBSec: TJvDBSecurity;
    tbUsers: TTable;
    DB: TeDataBase;
    tbUsersCodUsr: TIntegerField;
    tbUsersNome: TStringField;
    tbUsersPassword: TStringField;
    tbUsersSystem: TBooleanField;
    DBConnection: TDBConnectionLink;
    Programmi1: TMenuItem;
    miEditUser: TMenuItem;
    apStorage: TJvAppIniFileStorage;
    procedure FormCreate(Sender: TObject);
    function DBSecChangePassword(UsersTable: TTable; const OldPassword,
      NewPassword: String): Boolean;
    function DBSecCheckUser(UsersTable: TTable;
      const Password: String): Boolean;
    function DBSecUnlock(const Password: String): Boolean;
    procedure miLogOnClick(Sender: TObject);
    procedure miChangePwdClick(Sender: TObject);
    procedure miLockClick(Sender: TObject);
    procedure miPackDBClick(Sender: TObject);
    function DBValidate(const Signature, Magic: String): Boolean;
    procedure DBConnectionConnect(Sender: TeDataBase; Connect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure DBSecAfterLogin(Sender: TObject);
    procedure miEditUserClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
  private
    { Private declarations }
    User: string;
    Wnds: TList;
    Mesg: TList;
    function CheckPassword(const User, Pwd: string): boolean;
    function SetPassword(const User, OldPwd, NewPwd: string): boolean;
    procedure Notify(WParam, LParam: longint);
    procedure OnMakeDB(Sender: TObject);

    procedure WMAddRef(var Msg: TMessage); message WM_ADDREF;
    procedure WMRelease(var Msg: TMessage); message WM_RELEASE;
    procedure WMGetUserName(var Msg: TMessage); message WM_GETUSERNAME;
    procedure WMCheckPassword(var Msg: TMessage); message WM_CHECKPASSWORD;
    procedure WMSetPassword(var Msg: TMessage); message WM_SETPASSWORD;
  public
    { Public declarations }
  end;

var
  EicShellMenu: TEicShellMenu;

implementation

{$R *.DFM}

uses
  MakeDB, eLibCore, Costanti, uOpzioni, FDBPack, FEditUser;

(* ---------------- Messaggi ------------------------ *)
procedure TEicShellMenu.WMGetUserName(var Msg: TMessage);
begin
  Msg.Result:= length(User)+1;
  if Msg.WParam >= Msg.Result then begin
    StrPLCopy(PChar(Msg.LParam), User, Msg.WParam);
  end;
end;

procedure TEicShellMenu.WMAddRef(var Msg: TMessage);
var
  Hnd: longint;
begin
  try
    Hnd:= Msg.WParam;
    Msg.Result:= Wnds.Add(pointer(Hnd))+1;
    Mesg.Add(pointer(Msg.LParam));
  except
    Msg.Result:= 0;
  end;
end;

procedure TEicShellMenu.WMRelease(var Msg: TMessage);
var
  ID: longint;
begin
  ID:= Msg.LParam-1;
  try
    if longint(Wnds[ID]) = Msg.WParam then begin
      Msg.Result:= 1;
      Wnds.Delete(ID);
      Mesg.Delete(ID);
    end
    else Msg.Result:= 0;
  except
    Msg.Result:= 0;
  end;
end;

procedure TEicShellMenu.WMCheckPassword(var Msg: TMessage);
var
  PwdRec: PCheckPasswordRec;
begin
  case Msg.WParam of
    0: begin
      if CheckPassword(User, StrPas(PAnsiChar(Msg.LParam))) then begin
        Msg.Result:= 1;
      end
      else begin
        Msg.Result:= 0;
      end;
    end;
    1: begin
      PwdRec:= PCheckPasswordRec(pointer(Msg.LParam));
      if CheckPassword(StrPas(PwdRec^.User), StrPas(PwdRec^.Pwd)) then begin
        Msg.Result:= 1;
      end
      else begin
        Msg.Result:= 0;
      end;
    end;
    else Msg.Result:= 0;
  end;
end;

procedure TEicShellMenu.WMSetPassword(var Msg: TMessage);
var
  PwdRec: PSetPasswordRec;
begin
  PwdRec:= PSetPasswordRec(pointer(Msg.LParam));
  if SetPassword(StrPas(PwdRec^.User), StrPas(PwdRec^.OldPwd), StrPas(PwdRec^.NewPwd)) then begin
    Msg.Result:= 1;
  end
  else begin
    Msg.Result:= 0;
  end;
end;

(* -------------------------------------------------- *)

procedure TEicShellMenu.FormCreate(Sender: TObject);
begin
  Caption:= ShellName;
  Wnds:= TList.Create;
  Mesg:= TList.Create;
(*
  SetLongYear;
  FourDigitYear:= true;
*)
  DBConnection.Active:= true;
  apStorage.FileName:= Opzioni.LocalINI;
  Session.AddPassword('Shell');
end;

procedure TEicShellMenu.Notify(WParam, LParam: longint);
var
  Hnd: THandle;
  Msg: longint;
  i: integer;
begin
  for i:= 0 to Wnds.Count-1 do begin
    Hnd:= longint(Wnds[i]);
    if Hnd <> 0 then begin
      Msg:= longint(Mesg[i]);
      if Msg <> 0 then begin
        SendMessage(Hnd, Msg, WParam, LParam);
      end;
    end;
  end;
end;

function TEicShellMenu.DBSecCheckUser(UsersTable: TTable;
  const Password: String): Boolean;
var
  tmp: string;
begin
  tmp:= UsersTable.FieldByName('Nome').AsString;
  Result:= CheckPassword(tmp, Password);
  if Result then User:= tmp; 
end;

function TEicShellMenu.DBSecChangePassword(UsersTable: TTable;
  const OldPassword, NewPassword: String): Boolean;
begin
  Result:= SetPassword(UsersTable.FieldByName('Nome').AsString, OldPassword, NewPassword);
end;

function TEicShellMenu.DBSecUnlock(const Password: string): Boolean;
begin
  Result:= CheckPassword(DBSec.LoggedUser, Password);
  if Result then Notify(SN_UNLOCK, 0);
end;

procedure TEicShellMenu.miLogOnClick(Sender: TObject);
begin
  DBSec.Login;
end;

procedure TEicShellMenu.miChangePwdClick(Sender: TObject);
begin
  if DBSec.ChangePassword then begin
    Notify(SN_PASSWORDCHANGED, 0);
  end;
end;

procedure TEicShellMenu.miLockClick(Sender: TObject);
begin
  DBSec.Lock;
  Notify(SN_LOCK, 0);
end;

procedure TEicShellMenu.miPackDBClick(Sender: TObject);
begin
  PackDataBase(MakeAllTables, DB);
  Notify(SN_PACKDATABASE, 0);
end;

function TEicShellMenu.CheckPassword(const User, Pwd: string): boolean;
var
  tmp: string;
begin
  tbUsers.Active:= true;
  if tbUsers.Locate('Nome', User, []) then begin
    tmp:= tbUsersPassword.Value;
    Result:= (tmp='') or (tmp = Trim(Pwd));
  end
  else begin
    Result:= false;
  end;
end;

function TEicShellMenu.SetPassword(const User, OldPwd, NewPwd: string): boolean;
begin
  Result:= CheckPassword(User, OldPwd);
  if Result then begin
    tbUsers.Edit;
    tbUsersPassword.Value:= Trim(NewPwd);
    tbUsers.Post;
  end;
end;

function TEicShellMenu.DBValidate(const Signature, Magic: String): Boolean;
begin
  Result:= Magic = Crypt.SimpleCrypt(Signature, Signature);
end;

procedure TEicShellMenu.DBConnectionConnect(Sender: TeDataBase; Connect: Boolean);
begin
  if Connect then begin
    tbUsers.Open;
  end
  else begin
    tbUsers.Close;
  end;
end;

procedure TEicShellMenu.OnMakeDB(Sender: TObject);
begin
  tbUsers.Active:= true;
  tbUsers.Append;
  tbUsersNome.Value:='SYSDBA';
  tbUsersSystem.Value:=true;
  tbUsers.Post;
end;

procedure TEicShellMenu.FormShow(Sender: TObject);
begin
  if not ConnectDataBase(MakeAllTables, DB, Opzioni.ProgPath+Opzioni.DefaultDB,
     Crypt.SimpleCrypt(DB.Signature,DB.Signature), OnMakeDB) then Application.Terminate
  else begin
    DBSec.DataBase:= DB;
    if not DBSec.Login then begin
      Application.Terminate;
    end;
  end;
end;

procedure TEicShellMenu.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Wnds.Count > 0 then begin
    if MessageDlg('Terminare questo programma può provocare dei malfunzionamenti in quanto ci sono altri programmi che lo '+
      'stanno usando. Sei sicuro di voler terminare?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Abort;
  end;
  Notify(SN_SHELLCLOSE, 0);
end;

procedure TEicShellMenu.FormDestroy(Sender: TObject);
begin
  Wnds.Free;
  Mesg.Free;
end;

procedure TEicShellMenu.DBSecAfterLogin(Sender: TObject);
begin
  Notify(SN_USERLOGIN, 0);
  if tbUsersSystem.Value then begin
    miEditUser.Enabled:= true;
    miPackDB.Enabled:= true;
  end
  else begin
    miEditUser.Enabled:= false;
    miPackDB.Enabled:= false;
  end;
(*
  CheckProgAccess(tbUsersCodUsr.Value);
*)
end;

procedure TEicShellMenu.miEditUserClick(Sender: TObject);
begin
  EditUser;
end;

procedure TEicShellMenu.miExitClick(Sender: TObject);
begin
  Close;
end;

end.

