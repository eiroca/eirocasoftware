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
unit FChgPwd;

interface

uses
  SysUtils, Windows,
  Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons,
  DBTables, DB;

const
  AttemptNumber = 3;
  
type

  TfmChangePassword = class(TForm)
    OldPswdLabel: TLabel;
    OldPswd: TEdit;
    NewPswdLabel: TLabel;
    NewPswd: TEdit;
    ConfirmLabel: TLabel;
    ConfirmNewPswd: TEdit;
    OkBtn: TButton;
    CancelBtn: TButton;
    procedure OkBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PswdChange(Sender: TObject);
  private
    { Private declarations }
    FEnableEmpty: boolean;
    FAttempt: integer;
    procedure ClearEdits;
    procedure OkEnabled;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

function ChangePasswordDialog(MaxPwdLen: Integer; EnableEmptyPassword: Boolean): Boolean;

implementation

{$R *.DFM}

uses
  Consts, eLibCore, FChkUsr;

function ChangePasswordDialog(MaxPwdLen: Integer; EnableEmptyPassword: Boolean): Boolean;
var
  Form: TfmChangePassword;
  SaveCursor: TCursor;
begin
  SaveCursor := Screen.Cursor;
  Screen.Cursor := crDefault;
  try
    Form := TfmChangePassword.Create(Application);
    try
      Form.OldPswd.MaxLength := MaxPwdLen;
      Form.NewPswd.MaxLength := MaxPwdLen;
      Form.ConfirmNewPswd.MaxLength := MaxPwdLen;
      Form.FEnableEmpty := EnableEmptyPassword;
      Result := (Form.ShowModal = mrOk);
      if Result then begin
        SetPassword(Trim(Form.NewPswd.Text));
        MessageDlg('La password è stata cambiata', mtInformation, [mbOk], 0);
      end;
    finally
      Form.Free;
    end;
  finally
    Screen.Cursor := SaveCursor;
  end;
end;

{ TChangePassword }

procedure TfmChangePassword.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if Application.MainForm <> nil then
    Params.WndParent := Application.MainForm.Handle;
end;

procedure TfmChangePassword.ClearEdits;
begin
  OldPswd.Text := '';
  NewPswd.Text := '';
  ConfirmNewPswd.Text := '';
  OkBtn.Enabled := FEnableEmpty;
end;

procedure TfmChangePassword.OkEnabled;
begin
  OkBtn.Enabled := FEnableEmpty or ((OldPswd.Text <> '') and (NewPswd.Text <> '')
    and (ConfirmNewPswd.Text <> ''));
end;

procedure TfmChangePassword.OkBtnClick(Sender: TObject);
type
  TChangePasswordError = (peMismatch, peOther);
var
  Ok: Boolean;
begin
  Ok := False;
  Inc(FAttempt);
  if not (FAttempt > AttemptNumber) then begin
    if not CheckPassword(OldPswd.Text) then begin
      MessageDlg('La password precedente non è corretta', mtInformation, [mbOk], 0);
    end
    else if NewPswd.Text <> ConfirmNewPswd.Text then begin
      MessageDlg('La password e quella di conferma non coincidono', mtInformation, [mbOk], 0);
      exit;
    end
    else Ok:= true;
  end;
  if Ok then ModalResult := mrOk
  else begin
    if FAttempt > AttemptNumber then ModalResult := mrCancel
    else ModalResult := mrNone;
  end;
end;

procedure TfmChangePassword.FormShow(Sender: TObject);
begin
  ClearEdits;
end;

procedure TfmChangePassword.PswdChange(Sender: TObject);
begin
  OkEnabled;
end;

end.
