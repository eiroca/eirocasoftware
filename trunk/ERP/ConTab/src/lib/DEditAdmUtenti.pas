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
unit DEditAdmUtenti;

interface

uses
  SysUtils, Windows, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, DContabilita, ADODB,
  ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset;

type
  TdmEditAdmUtenti = class(TDataModule)
    dsAdmUtenti: TDataSource;
    tbAdmUtenti: TZTable;
    tbAdmUtentiCodUsr: TIntegerField;
    tbAdmUtentiUserName: TWideStringField;
    tbAdmUtentiPassword: TWideStringField;
    tbAdmUtentiSuperUser: TBooleanField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  dmEditAdmUtenti: TdmEditAdmUtenti;

implementation

{$R *.DFM}

procedure TdmEditAdmUtenti.DataModuleCreate(Sender: TObject);
begin
  tbAdmUtenti.Active:= true;
end;

procedure TdmEditAdmUtenti.DataModuleDestroy(Sender: TObject);
begin
  tbAdmUtenti.Active:= false;
end;

end.
