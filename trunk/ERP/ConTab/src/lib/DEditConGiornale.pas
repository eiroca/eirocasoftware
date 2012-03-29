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
unit DEditConGiornale;

interface           

uses
  SysUtils, Windows, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, ADODB, ZDataset, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractTable;

type
  TdmEditConGiornale = class(TDataModule)
    tbConGiornale: TZTable;
    tbConGiornaleDett: TZTable;
    dsConGiornale: TDataSource;
    dsConGiornaleDett: TDataSource;
    tbConConti: TZTable;
    tbConGiornaleCodScr: TIntegerField;
    tbConGiornaleDataScr: TDateField;
    tbConGiornaleDataOpe: TDateField;
    tbConGiornaleDesc: TWideStringField;
    tbConGiornaleTipoScr: TSmallintField;
    tbConGiornaleUfficiale: TBooleanField;
    tbConGiornaleDettCodScr: TIntegerField;
    tbConGiornaleDettCodCon: TIntegerField;
    tbConGiornaleDettImporto: TFloatField;
    tbConContiCodCon: TIntegerField;
    tbConContiAlias: TWideStringField;
    tbConContiDesc: TWideStringField;
    tbConContiGruppo: TBooleanField;
    tbConContiTipiMovi: TSmallintField;
    tbConContiLivDett: TSmallintField;
    tbConContiNote: TWideMemoField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  dmEditConGiornale: TdmEditConGiornale;

implementation

{$R *.DFM}

procedure TdmEditConGiornale.DataModuleCreate(Sender: TObject);
begin
  tbConConti.Active:= true;
  tbConGiornaleDett.Active:= true;
  tbConGiornale.Active:= true;
end;

procedure TdmEditConGiornale.DataModuleDestroy(
  Sender: TObject);
begin
  tbConGiornale.Active:= false;
  tbConGiornaleDett.Active:= false;
  tbConConti.Active:= false;
end;

end.
