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
unit FEditUser;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, Mask, ExtCtrls;

type
  TfmEditUser = class(TForm)
    ScrollBox: TScrollBox;
    Label1: TLabel;
    EditNome: TDBEdit;
    DBNavigator: TDBNavigator;
    Panel1: TPanel;
    dsUser: TDataSource;
    Panel2: TPanel;
    DBCheckBox1: TDBCheckBox;
    tbUser: TTable;
    btDelPwd: TButton;
    tbUserCodUsr: TIntegerField;
    tbUserNome: TStringField;
    tbUserPassword: TStringField;
    tbUserSystem: TBooleanField;
    procedure FormCreate(Sender: TObject);
    procedure dsUserDataChange(Sender: TObject; Field: TField);
    procedure btDelPwdClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

procedure EditUser;

implementation

{$R *.DFM}

procedure TfmEditUser.FormCreate(Sender: TObject);
begin
  tbUser.Open;
end;

procedure TfmEditUser.dsUserDataChange(Sender: TObject; Field: TField);
begin
  btDelPwd.Enabled:= tbUserPassword.Value <> '';
end;

procedure TfmEditUser.btDelPwdClick(Sender: TObject);
begin
  if not (dsUser.State in [dsInsert, dsEdit]) then tbUser.Edit;
  tbUserPassword.Value:= ''; 
end;

procedure TfmEditUser.FormDestroy(Sender: TObject);
begin
  tbUser.Close;
end;

procedure EditUser;
var
  fmEditUser: TfmEditUser;
begin
  fmEditUser:= nil;
  try
    fmEditUser:= TfmEditUser.Create(nil);
    fmEditUser.ShowModal;
  finally
    fmEditUser.Free;
  end;
end;

end.

