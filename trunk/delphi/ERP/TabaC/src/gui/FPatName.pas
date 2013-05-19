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
(* TabaC - Gestione Tabacchi
 * Ultima modifica: 06 nov 1999
 *)
unit FPatName;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, RgNav, RgNavDB, DBTables, DB, ExtCtrls, Grids, DBGrids;

type
  TfmPateName = class(TForm)
    tbPateName: TTable;
    dsPateName: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    tbPateNameCODP: TIntegerField;
    tbPateNameNOME: TStringField;
    RGNavigator1: TRGNavigator;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure EditPateName;

implementation

{$R *.DFM}

uses
  eLibCore;

procedure EditPateName;
var
  fmPateName: TfmPateName;
begin
  fmPateName:= TfmPateName.Create(nil);
  try
    fmPateName.ShowModal;
  finally
    fmPateName.Free;
  end;
end;

procedure TfmPateName.FormShow(Sender: TObject);
begin
  tbPateName.Active:= true;
end;

procedure TfmPateName.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tbPateName.Active:= false;
end;

end.

