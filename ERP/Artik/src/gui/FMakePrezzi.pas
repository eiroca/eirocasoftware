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
unit FMakePrezzi;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DBTables, DB, Grids, DBGrids, ExtCtrls, RgNav,
  RgNavDB, StdCtrls, JvComponentBase, JvBDEFilter;

type
  TfmMakePrezzi = class(TForm)
    tbFatForMv: TTable;
    dsFatForMv: TDataSource;
    flFatForMv: TJvDBFilter;
    tbFatForMvCodMov: TIntegerField;
    tbFatForMvCodFatFor: TIntegerField;
    tbFatForMvCodAlf: TStringField;
    tbFatForMvCodNum: TIntegerField;
    tbFatForMvQta: TFloatField;
    tbFatForMvImp: TCurrencyField;
    tbFatForMvElab: TBooleanField;
    RGNavigator1: TRGNavigator;
    Label1: TLabel;
    Label2: TLabel;
    lbSetMer: TLabel;
    lbArtDesc: TLabel;
    procedure FormShow(Sender: TObject);
    procedure dsFatForMvDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
    procedure SetupData;
  public
    { Public declarations }
  end;

var
  fmMakePrezzi: TfmMakePrezzi;

implementation

{$R *.DFM}

uses
  DArtik, DMovim;

procedure TfmMakePrezzi.FormShow(Sender: TObject);
begin
  tbFatForMv.Active:= true;
end;

procedure TfmMakePrezzi.SetupData;
var
  CodAlf: string;
  CodNum: integer;
  SetMer: TSettoreMerc;
begin
  CodAlf:= tbFatForMvCodAlf.Value;
  CodNum:= tbFatForMvCodNum.Value;
  SetMer:= ISettoriMerc.Get(CodAlf);
  try
    lbSetMer.Caption:= SetMer.Desc;
  finally
    SetMer.Free;
  end;
end;

procedure TfmMakePrezzi.dsFatForMvDataChange(Sender: TObject;
  Field: TField);
begin
  if Field = nil then SetupData;
end;

end.

