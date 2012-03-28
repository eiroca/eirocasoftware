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
unit FGetUnCod;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type
  TfmGetUnusedCode = class(TForm)
    Label1: TLabel;
    iCode: TEdit;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    lbErr: TLabel;
    procedure FormShow(Sender: TObject);
    procedure iCodeKeyPress(Sender: TObject; var Key: Char);
    procedure iCodeChange(Sender: TObject);
    procedure btOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Used: string;
    CodAlf: string;
    Code: char;
  end;


function GetUnusedCode(const aCodAlf: string; var Code: char): boolean;

implementation

{$R *.DFM}

uses
  DArtik, eLibCore;

function GetUnusedCode(const aCodAlf: string; var Code: char): boolean;
var
  fmGetUnusedCode: TfmGetUnusedCode;
begin
  fmGetUnusedCode:= TfmGetUnusedCode.Create(nil);
  try
    fmGetUnusedCode.CodAlf:= aCodAlf;
    Result:= fmGetUnusedCode.ShowModal=mrOk;
    if Result then Code:= fmGetUnusedCode.Code;
  finally
    fmGetUnusedCode.Free;
  end;
end;

procedure TfmGetUnusedCode.FormShow(Sender: TObject);
begin
  Used:= ISettoriMerc.Usati(CodAlf);
  iCode.Text:= '';
  lbErr.Caption:= '';
  btOk.Enabled:= false;
end;

procedure TfmGetUnusedCode.iCodeKeyPress(Sender: TObject; var Key: Char);
begin
  Key:= UpCase(Key);
  if Pos(Key, Used)<>0 then begin
    lbErr.Caption:= 'Lettera '+Key+' già usata';
    Key:= #0;
    MessageBeep(word(-1));
  end
  else begin
    iCode.Text:= '';
    lbErr.Caption:= '';
  end;
end;

procedure TfmGetUnusedCode.iCodeChange(Sender: TObject);
begin
  btOk.Enabled:= iCode.Text<>'';
end;

procedure TfmGetUnusedCode.btOkClick(Sender: TObject);
var
  tmp: string;
begin
  tmp:= iCode.Text;
  if length(tmp)>0 then Code:= tmp[1]
  else Code:= #0;
end;

end.
