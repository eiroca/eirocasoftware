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
unit DEditConConti;

interface

uses
  SysUtils, Windows, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, ADODB, ZAbstractRODataset, ZAbstractDataset,
  ZAbstractTable, ZDataset;

type
  TdmEditConConti = class(TDataModule)
    dsConConti: TDataSource;
    tbConConti: TZTable;
    tbSysCon_TipiMovi: TZTable;
    tbSysCon_LivDett: TZTable;
    tbConContiCodCon: TIntegerField;
    tbConContiAlias: TWideStringField;
    tbConContiDesc: TWideStringField;
    tbConContiGruppo: TBooleanField;
    tbConContiTipiMovi: TSmallintField;
    tbConContiLivDett: TSmallintField;
    tbConContiNote: TWideMemoField;
    tbConContiTipiMoviDesc: TStringField;
    tbConContiLivDettDesc: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  dmEditConConti: TdmEditConConti;

implementation

{$R *.DFM}

procedure TdmEditConConti.DataModuleCreate(Sender: TObject);
begin
  tbSysCon_TipiMovi.Active:= true;
  tbSysCon_LivDett.Active:= true;
  tbConConti.Active:= true;
end;

procedure TdmEditConConti.DataModuleDestroy(Sender: TObject);
begin
  tbConConti.Active:= false;
  tbSysCon_TipiMovi.Active:= false;
  tbSysCon_LivDett.Active:= false;
end;

end.
