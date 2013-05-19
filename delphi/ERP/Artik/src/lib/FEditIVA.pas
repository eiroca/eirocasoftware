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
unit FEditIVA;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBGrids, RgNav, RgNavDB, DBTables, Grids,
  ExtCtrls;

type
  TfmEditCodIVA = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    dsCodIVA: TDataSource;
    Panel2: TPanel;
    tbCodIVA: TTable;
    tbCodIVADesc: TStringField;
    RGNavigator1: TRGNavigator;
    tbCodIVAAlq: TFloatField;
    tbCodIVACodIVA: TSmallintField;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { private declarations }
  public
    { public declarations }
  end;

procedure EditCodIVA;

implementation

{$R *.DFM}

procedure EditCodIVA;
var
  fmEditCodIVA: TfmEditCodIVA;
begin
  fmEditCodIVA:= TfmEditCodIVA.Create(nil);
  try
    fmEditCodIVA.ShowModal;
  finally
    fmEditCodIVA.Free;
  end;
end;

procedure TfmEditCodIVA.FormShow(Sender: TObject);
begin
  tbCodIVA.Open;
end;

procedure TfmEditCodIVA.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tbCodIVA.Close;
end;

end.
