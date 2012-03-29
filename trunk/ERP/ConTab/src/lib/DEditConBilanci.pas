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
unit DEditConBilanci;

interface           

uses
  SysUtils, Windows, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, ADODB, ZAbstractRODataset, ZAbstractDataset,
  ZAbstractTable, ZDataset;

type
  TdmEditConBilanci = class(TDataModule)
    tbConBilanci: TZTable;
    tbConBilanciDett: TZTable;
    dsConBilanci: TDataSource;
    dsConBilanciDett: TDataSource;
    tbConConti: TZTable;
    tbConSchemiBilancio: TZTable;
    tbConBilanciCodBil: TIntegerField;
    tbConBilanciCodSch: TIntegerField;
    tbConBilanciAlias: TWideStringField;
    tbConBilanciDesc: TWideStringField;
    tbConBilanciData: TDateField;
    tbConBilanciNote: TWideMemoField;
    tbConBilanciUfficiale: TBooleanField;
    tbConBilanciDettCodBil: TIntegerField;
    tbConBilanciDettCodCon: TIntegerField;
    tbConBilanciDettSaldo: TFloatField;
    tbConBilanciCodSchDett: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  dmEditConBilanci: TdmEditConBilanci;

implementation

{$R *.DFM}

procedure TdmEditConBilanci.DataModuleCreate(Sender: TObject);
begin
  tbConSchemiBilancio.Active:= true;
  tbConConti.Active:= true;
  tbConBilanciDett.Active:= true;
  tbConBilanci.Active:= true;
end;

procedure TdmEditConBilanci.DataModuleDestroy(
  Sender: TObject);
begin
  tbConBilanci.Active:= false;
  tbConBilanciDett.Active:= false;
  tbConConti.Active:= false;
  tbConSchemiBilancio.Active:= false;
end;

end.
