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
unit FTest;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
    ID: longint;
    User: string;
  public
    { Public declarations }
    procedure WMUser(var Msg: TMessage); message WM_USER;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  eLibCore, ShellServ;

procedure TForm1.FormCreate(Sender: TObject);
begin
  User:= 'SYSDBA';
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  User: string;
begin
  if GetUserName(User) then Memo1.Lines.Add(User)
  else Memo1.Lines.Add('GetUserName fails');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ID:= AddRef(Handle, WM_USER);
  Memo1.Lines.Add('ID = '+IntToStr(ID));
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Ok: boolean;
begin
  Ok:= RelRef(ID, Handle);
  if Ok then Memo1.Lines.Add('Ok')
  else Memo1.Lines.Add('Not ok');
end;

procedure TForm1.Button4Click(Sender: TObject);
const
  A: array[false..true] of string = ('Not Ok', 'Ok');
begin
  Memo1.Lines.add('CheckPassword Ok = '+A[CheckUserPassword('')]);
  Memo1.Lines.add('CheckPassword Ok = '+A[CheckPassword(User, '')]);
  Memo1.Lines.add('CheckPassword Not Ok = '+A[CheckPassword('pippo', 'pluto')]);
end;

procedure TForm1.Button5Click(Sender: TObject);
const
  A: array[false..true] of string = ('Not Ok', 'Ok');
begin
  Memo1.Lines.add('CheckPassword Not Ok = '+A[SetPassword('pippo','','')]);
  Memo1.Lines.add('CheckPassword Ok = '+A[SetPassword(User, '', 'ciao')]);
  Memo1.Lines.add('CheckPassword Ok = '+A[SetPassword(User, 'ciao', '')]);
end;

procedure TForm1.WMUser(var Msg: TMessage);
var
  User: string;
begin
  case Msg.WParam of
    SN_USERLOGIN: begin
      GetUserName(User);
      Memo1.Lines.add(User+' login');
    end;
    SN_LOCK: begin
      Memo1.Lines.add('Lock');
    end;
    SN_UNLOCK: begin
      Memo1.Lines.add('Unlock');
    end;
    SN_PASSWORDCHANGED: begin
      Memo1.Lines.add('PasswordChanged');
    end;
    SN_SHELLCLOSE: begin
      Memo1.Lines.add('ShellClose');
    end;
  end;
end;

end.

