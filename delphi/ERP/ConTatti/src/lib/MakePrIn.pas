(* GPL > 3.0
Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio

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
unit MakePrIn;

Interface

Uses
  SysUtils, Forms, Controls, DB, BDE, dbtables;

procedure CheckProgInfo(const Path, Password: string);

Implementation

uses
  eLibBDE;

Var
  szDirectory : DBIPATH;
  TableDesc   : CRTblDesc;
  FieldsDesc  : array[0..1] of FLDDesc;

procedure DefField (const sName: string; const iAFldType,iASubType,iAFldNum, iAUnits1,iAUnits2: integer);
begin
  with FieldsDesc[iAFldNum] do begin
    iFldNum  := iAFldNum;  StrPCopy(szName,sName);
    iFldType := iAFldType; iSubType := iASubType;
    iUnits1  := iAUnits1;  iUnits2 := iAUnits2;
  end;
end;

Procedure DefTable (const sName,sType,sPassword: string; const iAFldCount,iAIDXCount,iAValChkCount,iARintCount: integer);
begin
  FillChar(TableDesc,SizeOf(CRTblDesc),#0);
  with TableDesc do begin
    StrPCopy(szTblName,sName); StrPCopy(szTblType,sType);
    bProtected := (sPassword <> '');
    if bProtected then begin
      StrPCopy(szPassword,sPassword);
      Session.AddPassword(sPassword);
    end;
    bPack := true;
    iFldCount := iAFldCount; pFldDesc := @FieldsDesc;
  end;
end;

procedure StoredProginfo(const Password: string);
begin
  DefField('NAME',fldZSTRING,0,0,8,0);
  DefField('DATA',fldZSTRING,0,1,240,0);
  DefTable('PROGINFO.DB','PARADOX',Password,2,0,0,0);
end;

procedure CheckProgInfo(const Path, Password: string);
var
  dbDatabase: TDataBase;
begin
  dbDatabase:= nil;
  try
    Screen.Cursor := crHourGlass;
    dbDatabase := TDatabase.Create(Application);
    with dbDatabase do begin
      DatabaseName := '__DBTEMP__';
      DriverName := 'STANDARD';
      Params.Add('PATH='+Path);
    end;
    dbDatabase.Connected := true;
    Check(DbiGetDirectory(dbDatabase.Handle,False,szDirectory));
    if szDirectory[StrLen(szDirectory)-1] <> '\' then szDirectory[StrLen(szDirectory)] := '\';
    StoredProginfo(Password);
    if DBICreateTable(dbDatabase.Handle,false,TableDesc) = DBIERR_FILEEXISTS then begin
      TableDesc.iFldCount := 0;
      DeleteAuxFiles(Path, 'PROGINFO.DB','PARADOX');
      Check(DBIDoRestructure(dbDatabase.Handle,1,@TableDesc,nil,nil,nil,false));
    end;
  finally
    dbDatabase.Free;
    Screen.Cursor := crDefault;
  end;
end;

end.

