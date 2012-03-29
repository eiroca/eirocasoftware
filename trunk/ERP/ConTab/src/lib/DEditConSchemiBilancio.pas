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
unit DEditConSchemiBilancio;

interface           

uses
  SysUtils, Windows, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, ADODB, ZAbstractRODataset, ZAbstractDataset,
  ZAbstractTable, ZDataset;

type
  TdmEditConSchemiBilancio = class(TDataModule)
    tbConSchemiBilancio: TZTable;
    tbConSchemiBilancioDett: TZTable;
    dsConSchemiBilancio: TDataSource;
    dsConSchemiBilancioDett: TDataSource;
    tbConConti: TZTable;
    tbSysCon_Posizione: TZTable;
    tbConSchemiBilancioCodSch: TIntegerField;
    tbConSchemiBilancioAlias: TWideStringField;
    tbConSchemiBilancioDesc: TWideStringField;
    tbConSchemiBilancioNote: TWideMemoField;
    tbConSchemiBilancioDettCodSch: TIntegerField;
    tbConSchemiBilancioDettCodCon: TIntegerField;
    tbConSchemiBilancioDettParent: TIntegerField;
    tbConSchemiBilancioDettOrder: TIntegerField;
    tbConSchemiBilancioDettPosizione: TSmallintField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  dmEditConSchemiBilancio: TdmEditConSchemiBilancio;

implementation

{$R *.DFM}

procedure TdmEditConSchemiBilancio.DataModuleCreate(Sender: TObject);
begin
  tbSysCon_Posizione.Active:= true;
  tbConConti.Active:= true;
  tbConSchemiBilancioDett.Active:= true;
  tbConSchemiBilancio.Active:= true;
end;

procedure TdmEditConSchemiBilancio.DataModuleDestroy(
  Sender: TObject);
begin
  tbConSchemiBilancio.Active:= false;
  tbConSchemiBilancioDett.Active:= false;
  tbConConti.Active:= false;
  tbSysCon_Posizione.Active:= false;
end;

end.

