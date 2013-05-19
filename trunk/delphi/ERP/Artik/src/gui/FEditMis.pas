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
unit FEditMis;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBGrids, RgNav, RgNavDB, DBTables, Grids,
  ExtCtrls;

type
  TfmEditCodMis = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    dsCodMis: TDataSource;
    Panel2: TPanel;
    tbCodMis: TTable;
    RGNavigator1: TRGNavigator;
    tbCodMisCodMis: TSmallintField;
    tbCodMisDesc: TStringField;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { private declarations }
  public
    { public declarations }
  end;

procedure EditCodMis;

implementation

{$R *.DFM}

procedure EditCodMis;
var
  fmEditCodMis: TfmEditCodMis;
begin
  fmEditCodMis:= TfmEditCodMis.Create(nil);
  try
    fmEditCodMis.ShowModal;
  finally
    fmEditCodMis.Free;
  end;
end;

procedure TfmEditCodMis.FormShow(Sender: TObject);
begin
  tbCodMis.Open;
end;

procedure TfmEditCodMis.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tbCodMis.Close;
end;

end.