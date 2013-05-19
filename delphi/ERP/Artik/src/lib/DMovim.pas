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
unit DMovim;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, eDB;

type
  TdmMovim = class(TDataModule)
    DBConnect: TDBConnectionLink;
    qrCalcSpese: TQuery;
    qrCalcSpeseImpSpe: TCurrencyField;
    qrCalcSpeseIVASpe: TCurrencyField;
    qrCalcMovi: TQuery;
    qrCalcMoviCodMov: TIntegerField;
    qrCalcMoviCodFatFor: TIntegerField;
    qrCalcMoviCodAlf: TStringField;
    qrCalcMoviCodNum: TIntegerField;
    qrCalcMoviQta: TFloatField;
    qrCalcMoviImp: TCurrencyField;
    qrCalcMoviElab: TBooleanField;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CalcSpese(aCodFatFor: longint; var ImpSpe, IVASpe: double);
    procedure CalcMovi(aCodFatFor: longint; var Imp, IVA: double);
  end;

var
  dmMovim: TdmMovim;

implementation

{$R *.DFM}

uses
  DArtik, DTabelle;

procedure TdmMovim.FormCreate(Sender: TObject);
begin
  DBConnect.DataBase:= dmArticoli.DB;
  DBConnect.Active:= true;
end;

procedure TdmMovim.CalcSpese(aCodFatFor: longint; var ImpSpe, IVASpe: double);
begin
  qrCalcSpese.ParamByName('aCodFatFor').AsInteger:= aCodFatFor;
  qrCalcSpese.Open;
  ImpSpe:= qrCalcSpeseImpSpe.Value;
  IVASpe:= qrCalcSpeseIVASpe.Value;
  qrCalcSpese.Close;
end;

procedure TdmMovim.CalcMovi(aCodFatFor: longint; var Imp, IVA: double);
var
  CodIVA: integer;
  tmp: double;
begin
  Imp:= 0;
  IVA:= 0;
  qrCalcMovi.ParamByName('aCodFatFor').AsInteger:= aCodFatFor;
  qrCalcMovi.Open;
  while not qrCalcMovi.EOF do begin
    CodIVA:= dmArticoli.GetCodIVA(qrCalcMoviCodAlf.Value, qrCalcMoviCodNum.Value);
    tmp:= qrCalcMoviImp.Value;
    Imp:= Imp + tmp;
    IVA:= IVA + ITabIVA.CalcIVA(tmp, CodIVA);
    qrCalcMovi.Next;
  end;
  qrCalcMovi.Close;
end;

end.

