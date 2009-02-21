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
unit ShellServ;

interface

uses
  Costanti, Messages, SysUtils, Windows;

const
  ShellClassName = 'TEicShellMenu';

const
  WM_ADDREF        = WM_USER+1;
  WM_RELEASE       = WM_USER+2;
  WM_GETUSERNAME   = WM_USER+3;
  WM_CHECKPASSWORD = WM_USER+4;
  WM_SETPASSWORD   = WM_USER+5;

  SN_USERLOGIN       = 1;
  SN_PASSWORDCHANGED = 2;
  SN_LOCK            = 3;
  SN_UNLOCK          = 4;
  SN_PACKDATABASE    = 5;
  SN_SHELLCLOSE      = 6;

type
  PCheckPasswordRec = ^CheckPasswordRec;
  CheckPasswordRec = record
    User: PChar;
    Pwd : PChar;
  end;

  PSetPasswordRec = ^SetPasswordRec;
  SetPasswordRec = record
    User  : PChar;
    OldPwd: PChar;
    NewPwd: PChar;
  end;


function LookAtAllWindows(Handle: HWnd; Temp: Longint): BOOL; {$ifdef WIN32} stdcall {$ELSE} export {$ENDIF};
function MenuHandle(Find: boolean): THandle;

function AddRef(Handle: THandle; WM_MSG: longint): longint;
function RelRef(ID: longint; Handle: THandle): boolean;
function GetUserName(var User: string): boolean;
function CheckUserPassword(const Pwd: string): boolean;
function CheckPassword(const User, Pwd: string): boolean;
function SetPassword(const User, OldPwd, NewPwd: string): boolean;

implementation

var
  WinHndl: THandle;

function LookAtAllWindows(Handle: HWnd; Temp: Longint): BOOL;
var
  WindowName  : Array[0..255] of Char;
  ClassName : Array[0..255] of Char;
  tmp: string;
begin
  Result:= true;
  if GetClassName(Handle, ClassName, SizeOf(ClassName)) > 0 then begin
    tmp:= StrPas(ClassName);
    if tmp = ShellClassName then begin
      if GetWindowText(Handle, WindowName, SizeOf(WindowName)) > 0 then begin
        tmp:= StrPas(WindowName);
        if tmp = ShellName then begin
          Result:= false;
          WinHndl:= Handle;
        end
      end;
    end;
  end;
end;

function MenuHandle(Find: boolean): THandle;
begin
  if Find then begin
    WinHndl:= 0;
    EnumWindows(@LookAtAllWindows, 0);
  end;
  Result:= WinHndl;
end;

function AddRef(Handle: THandle; WM_MSG: longint): longint;
begin
  if MenuHandle(true) <> 0 then begin
    Result:= SendMessage(MenuHandle(false), WM_ADDREF, Handle, WM_MSG);
  end
  else Result:= 0;
end;

function RelRef(ID: longint; Handle: THandle): boolean;
begin
  if MenuHandle(true) <> 0 then begin
    Result:= SendMessage(MenuHandle(false), WM_RELEASE, Handle, ID) = 1;
  end
  else Result:= false;
end;

function GetUserName(var User: string): boolean;
var
  Sz: integer;
  tmp: PChar;
  Handle: THandle;
begin
  Handle:= MenuHandle(true);
  if Handle <> 0 then begin
    Sz:= SendMessage(Handle, WM_GETUSERNAME, 0, 0);
    tmp:= nil;
    Result:= true;
    User:= '';
    try
      GetMem(tmp, sz);
      SendMessage(Handle, WM_GETUSERNAME, sz, longint(tmp)); 
      User:= StrPas(tmp);
    finally
      FreeMem(tmp, sz);
    end;
  end
  else Result:= false;
end;

function CheckUserPassword(const Pwd: string): boolean;
var
  tmp: PChar;
  Handle: THandle;
  Sz: word;
begin
  Handle:= MenuHandle(true);
  if Handle <> 0 then begin
    tmp:= nil;
    sz:= length(Pwd)+1;
    try
      GetMem(tmp, sz);
      StrPCopy(tmp, Pwd);
      Result:= SendMessage(MenuHandle(false), WM_CHECKPASSWORD, 0, longint(tmp)) = 1;
    finally
      if tmp <> nil then FreeMem(tmp, sz);
    end;
  end
  else Result:= false;
end;

function CheckPassword(const User, Pwd: string): boolean;
var
  Handle: THandle;
  SzU: word;
  SzP: word;
  PwdRec: CheckPasswordRec;
begin
  Handle:= MenuHandle(true);
  if Handle <> 0 then begin
    PwdRec.User:= nil;
    PwdRec.Pwd:= nil;
    SzU:= length(User)+1;
    SzP:= length(Pwd)+1;
    try
      GetMem(PwdRec.User, SzU);
      GetMem(PwdRec.Pwd, SzP);
      StrPCopy(PwdRec.User, User);
      StrPCopy(PwdRec.Pwd, Pwd);
      Result:= SendMessage(MenuHandle(false), WM_CHECKPASSWORD, 1, longint(@PwdRec)) = 1;
    finally
      if PwdRec.User <> nil then FreeMem(PwdRec.User, SzU);
      if PwdRec.Pwd  <> nil then FreeMem(PwdRec.Pwd, SzP);
    end;
  end
  else Result:= false;
end;

function SetPassword(const User, OldPwd, NewPwd: string): boolean;
var
  Handle: THandle;
  SzU: word;
  SzOP: word;
  SzNP: word;
  PwdRec: SetPasswordRec;
begin
  Handle:= MenuHandle(true);
  if Handle <> 0 then begin
    PwdRec.User:= nil;
    PwdRec.OldPwd:= nil;
    PwdRec.NewPwd:= nil;
    SzU:= length(User)+1;
    SzOP:= length(OldPwd)+1;
    SzNP:= length(NewPwd)+1;
    try
      GetMem(PwdRec.User, SzU);
      GetMem(PwdRec.OldPwd, SzOP);
      GetMem(PwdRec.NEwPwd, SzNP);
      StrPCopy(PwdRec.User, User);
      StrPCopy(PwdRec.OldPwd, OldPwd);
      StrPCopy(PwdRec.NewPwd, NewPwd);
      Result:= SendMessage(MenuHandle(false), WM_SETPASSWORD, 1, longint(@PwdRec)) = 1;
    finally
      if PwdRec.User   <> nil then FreeMem(PwdRec.User, SzU);
      if PwdRec.OldPwd <> nil then FreeMem(PwdRec.OldPwd, SzOP);
      if PwdRec.NEwPwd <> nil then FreeMem(PwdRec.NewPwd, SzNP);
    end;
  end
  else Result:= false;
end;

end.
