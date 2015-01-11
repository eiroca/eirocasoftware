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
unit DTabelle;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, eLibDB, eBDE;

function _CalcIVA(Imp: double; IVA: double): double;

type
  ETabIVA = class(exception);
  ETabUM  = class(exception);

  ITabIVA = class
    protected
     class function  Seek(CodIVA: integer): boolean;
    public
     class function Aliquota(CodIVA: integer): double;
     class function Desc(CodIVA: integer): string;
     class function Aliq(CodIVA: integer): string;
     class function CalcIVA(Imp: double; CodIVA: integer): double;
  end;

  ITabUM = class
    protected
     class function  Seek(CodMis: integer): boolean;
    public
     class function Desc(CodMis: integer): string;
  end;

  TdmTabelle = class(TDataModule)
    tbTabIVA: TTable;
    tbTabIVACodIVA: TSmallintField;
    tbTabIVAAlq: TFloatField;
    tbTabIVADesc: TStringField;
    DBConnect: TDBConnectionLink;
    tbTabUM: TTable;
    tbTabUMCodMis: TSmallintField;
    tbTabUMDesc: TStringField;
    procedure DBConnectEvent(Sender: TeDataBase;
      Connect: Boolean);
    procedure FormCreate(Sender: TObject);
   private
    { Private declarations }
   public
    { Public declarations }
  end;

var
  dmTabelle: TdmTabelle;

implementation

{$R *.DFM}

uses
  Costanti, UOpzioni, DArtik;

function _CalcIVA(Imp: double; IVA: double): double;
var
  I: double;
begin
  I:= Imp * IVA;
  if frac(I)>0.00001 then I:= I+1;
  Result:= int(I);
end;

class function ITabIVA.Seek(CodIVA: integer): boolean;
begin
  Result:= dmTabelle.tbTabIVA.FindKey([CodIVA]);
end;

class function ITabIVA.Aliquota(CodIVA: integer): double;
begin
  if Seek(CodIVA) then begin
    Result:= dmTabelle.tbTabIVAAlq.Value;
  end
  else raise ETabIVA.CreateFmt('CodIVA %d not found', [CodIVA]);
end;

class function ITabIVA.Desc(CodIVA: integer): string;
begin
  if Seek(CodIVA) then begin
    Result:= dmTabelle.tbTabIVADesc.Value;
  end
  else raise ETabIVA.CreateFmt('CodIVA %d not found', [CodIVA]);
end;

class function ITabIVA.Aliq(CodIVA: integer): string;
begin
  if Seek(CodIVA) then begin
    Result:= dmTabelle.tbTabIVAAlq.AsString;
  end
  else raise ETabIVA.CreateFmt('CodIVA %d not found', [CodIVA]);
end;

class function ITabIVA.CalcIVA(Imp: double; CodIVA: integer): double;
begin
  Result:= _CalcIVA(Imp, Aliquota(CodIVA)*0.01);
end;

class function ITabUM.Seek(CodMis: integer): boolean;
begin
  Result:= dmTabelle.tbTabUM.FindKey([CodMis]);
end;

class function ITabUM.Desc(CodMis: integer): string;
begin
  if Seek(CodMis) then begin
    Result:= dmTabelle.tbTabUMDesc.Value;
  end
  else raise ETabUM.CreateFmt('CodMis %d not found', [CodMis]);
end;

procedure TdmTabelle.DBConnectEvent(Sender: TeDataBase;
  Connect: Boolean);
begin
  tbTabIVA.Active:= Connect;
  tbTabUM.Active:= Connect;
end;

procedure TdmTabelle.FormCreate(Sender: TObject);
begin
  DBConnect.DataBase:= dmArticoli.DB;
  DBConnect.Active:= true;
end;

end.

