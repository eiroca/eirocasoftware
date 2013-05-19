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
unit FEditForn;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, Mask, ExtCtrls, RgNav, RgNavDB;

type
  TfmEditForn = class(TForm)
    ScrollBox: TScrollBox;
    Label1: TLabel;
    EditCodFor: TDBEdit;
    Label2: TLabel;
    EditNome: TDBEdit;
    Panel1: TPanel;
    dsForn: TDataSource;
    Panel2: TPanel;
    tbFornitori: TTable;
    DBCheckBox1: TDBCheckBox;
    RGNavigator1: TRGNavigator;
    tbFornitoriCodFor: TIntegerField;
    tbFornitoriNome: TStringField;
    tbFornitoriPotenziale: TBooleanField;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RGNavigator1Click(Sender: TObject; Button: TAllNavBtn);
    procedure FormActivate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

procedure EditForn;

implementation

{$R *.DFM}

uses
  FFindFor;

procedure EditForn;
var
  fmEditForn: TfmEditForn;
begin
  fmEditForn:= TfmEditForn.Create(Application);
  fmEditForn.Show;;
end;

procedure TfmEditForn.FormShow(Sender: TObject);
begin
  tbFornitori.Active:= true;
end;

procedure TfmEditForn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tbFornitori.Active:= false;
  Action:= caFree;
end;

procedure TfmEditForn.RGNavigator1Click(Sender: TObject;
  Button: TAllNavBtn);
var
  CodFor: longint;
begin
  if Button = nbSearch then begin
    CodFor:= tbFornitoriCodFor.Value;
    if FindFornitore(CodFor) then begin
      tbFornitori.FindKey([CodFor]);
    end;
  end;
end;

procedure TfmEditForn.FormActivate(Sender: TObject);
begin
  tbFornitori.Refresh;
end;

end.

