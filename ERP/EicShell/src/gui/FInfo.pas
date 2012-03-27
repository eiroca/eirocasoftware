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
unit FInfo;

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Printers, Dialogs, DB, DBTables, Buttons, TabNotBk;

type
  TfmInfo = class(TForm)
    BitBtn1: TBitBtn;
    btOk: TBitBtn;
    Label1: TLabel;
    iDefaultDB: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function SetupInfo: TModalResult;

implementation

{$R *.DFM}

uses
  Costanti, eLibCore, SysUtils, UOpzioni;

function SetupInfo: TModalResult;
var
  fmInfo: TfmInfo;
begin
  fmInfo:= nil;
  try
    fmInfo:= TfmInfo.Create(nil);
    Result:= fmInfo.ShowModal;
  finally
    fmInfo.Free;
  end;
end;

procedure TfmInfo.FormShow(Sender: TObject);
begin
  iDefaultDB.Text:= Opzioni.DefaultDB;
end;

procedure TfmInfo.btOkClick(Sender: TObject);
begin
  Opzioni.DefaultDB:= iDefaultDB.Text;
end;

end.

