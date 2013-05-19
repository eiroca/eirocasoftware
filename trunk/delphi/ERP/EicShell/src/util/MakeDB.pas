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
unit Makedb;
{Table Scanner V1.05 [by demian@unix.horizontes.com.br]}
{Code generated on Sunday, March 1, 1998 at 07:16 PM}

Interface

Uses SysUtils, Forms, Controls, DB, DBtables, dbiprocs, dbitypes, dbierrs;

procedure MakeAllTables (dbDatabase: TDatabase);

Implementation

Type
  StoredTables = (Prog,Users,Grants);

Var
  szDirectory : DBIPATH;
  TableDesc   : CRTblDesc;
  FieldsDesc  : array[0..4] of FLDDesc;
  RefIntegOp  : array[0..1] of CROpType; RefInteg    : array[0..1] of RINTDesc;
  ValCheckOp  : array[0..1] of CROpType; ValCheckDesc: array[0..1] of VCHKDesc;
  IndexesOp   : array[0..1] of CROpType; IndexesDesc : array[0..1] of IDXDesc;

{____________________________________________________________________________}
procedure DeleteFiles (sMask: string);
var
  SearchRec: TSearchRec;
begin
  if FindFirst(sMask,faAnyFile,SearchRec) = 0 then begin
    sMask := ExtractFilePath(sMask);
    SysUtils.DeleteFile(sMask+SearchRec.Name);
    while FindNext(SearchRec) = 0 do
      SysUtils.DeleteFile(sMask+SearchRec.Name);
  end;
end;

{____________________________________________________________________________}
procedure DeleteAuxFiles;
var
  sFileName: string;
  f: file of byte;
  b: byte;
begin
  sFileName := StrPas(szDirectory)+StrPas(TableDesc.szTblName);
  if StrComp(TableDesc.szTblType,szParadox) = 0 then begin
    SysUtils.DeleteFile(ChangeFileExt(sFileName,'.PX'));
    SysUtils.DeleteFile(ChangeFileExt(sFileName,'.VAL'));
    DeleteFiles(ChangeFileExt(sFileName,'.X*'));
    DeleteFiles(ChangeFileExt(sFileName,'.Y*'));
    end
  else begin
    assignFile(f,ChangeFileExt(sFileName,'.DBF'));
    reset(f);
    try
      seek(f,28);
      b := 0;
      write(f,b);
      SysUtils.DeleteFile(ChangeFileExt(sFileName,'.MDX'));
    finally
      closefile(f);
    end;
  end;
end;

{____________________________________________________________________________}
procedure DefField (const sName: string;
                    const iAFldType,iASubType,iAFldNum,
                    iAUnits1,iAUnits2: integer);
begin
  with FieldsDesc[iAFldNum] do begin
    iFldNum  := iAFldNum;  StrPCopy(szName,sName);
    iFldType := iAFldType; iSubType := iASubType;
    iUnits1  := iAUnits1;  iUnits2 := iAUnits2;
  end;
end;

{____________________________________________________________________________}
procedure DefIndex (const sName,sTagName,sFormat,sKeyExp,sKeyCond: string;
                    const aFields: array of integer;
                    const iIndexPos,iAIndexID,iAFldsInKey,iAKeyLen,
                          iAKeyExptype,iABlockSize,iARestrNum: integer;
                    const bAPrimary,bAUnique,bADescending,bAMaintained,bASubSet,
                          bAExpIDX,bAOutOfDate,bACaseInsensitive: boolean);
var
  i: byte;
begin
  IndexesOp[iIndexPos] := crAdd;
  with IndexesDesc[iIndexPos] do begin
    StrPCopy(szName,sName); iIndexId := iAIndexId;
    StrPCopy(szFormat,sFormat); StrPCopy(szTagName,sTagName);
    StrPCopy(szKeyExp,sKeyExp); StrPCopy(szKeyCond,sKeyCond);
    iFldsInkey := iAFldsInkey; iKeyLen := iAKeyLen; iKeyExpType := iAKeyExpType;
    iBlocksize := iABlocksize; iRestrNum := iARestrNum;
    bPrimary := bAPrimary;  bUnique := bAUnique;  bDescending := bADescending;
    bMaintained := bAMaintained;  bSubset := bASubset; bExpIdx := bAExpIdx;
    bOutofDate := bAOutofDate; bCaseInsensitive := bACaseInsensitive;
    FillChar(aiKeyFld,SizeOf(aiKeyFld),#0);
    for i := Low(aFields) to High(aFields) do
      aiKeyFld[i] := aFields[i];
  end;
end;

{____________________________________________________________________________}
procedure DefValCheck (const iValPos,iAFldNum: integer;
                       const aAMinVal,aAMaxVal,aADefVal: array of Byte;
                       const bARequired,bAHasMinVal,bAHasMaxVal,bAHasDefVal: boolean;
                       const sPict,sLkupTblName: string;
                       const eALKUPType: LKUPType);
var
  i: byte;
begin
  ValCheckOp[IValPos] := crAdd;
  with ValCheckDesc[IValPos] do begin
    iFldNum := iAFldNum; StrPCopy(szPict,sPict);
    bRequired := bARequired; bHasMinVal := bAHasMinVal;
    bHasMaxVal := bAHasMaxVal; bHasDefVal := bAHasDefVal;
    eLKUPType := eALKUPType; StrPCopy(szLkupTblName,sLkupTblName);
    FillChar(aMinVal,SizeOf(aMinVal),#0);
    for i := Low(aAMinVal) to High(aAMinVal) do
      aMinVal[i] := aAMinVal[i];
    FillChar(aMaxVal,SizeOf(aMaxVal),#0);
    for i := Low(aAMaxVal) to High(aAMaxVal) do
      aMaxVal[i] := aAMaxVal[i];
    FillChar(aDefVal,SizeOf(aDefVal),#0);
    for i := Low(aADefVal) to High(aADefVal) do
      aDefVal[i] := aADefVal[i];
  end;
end;

{____________________________________________________________________________}
procedure DefRefInt (const iRintPos,iARintNum,iAFldCount: integer;
                     const aiAThisTabFld,aAiOthTabFld: array of integer;
                     const sRintName,sTblName: string; eAType: RINTType;
                     const eAModOP,eADelOP: RINTQual);
var
  i: byte;
begin
  RefIntegOp[iRintPos] := crAdd;
  with RefInteg[iRintPos] do begin
    iRintNum := iARintNum; StrPCopy(szRintName,sRintName);
    eType := eAType; StrPCopy(sztblName,StrPas(szDirectory)+stblName);
    eModOp := eAModOp; eDelOp := eADelOp; iFldCount := iAFldCount;
    FillChar(aiThisTabFld,SizeOf(aiThisTabFld),#0);
    for i := Low(aiAThisTabFld) to High(aiAThisTabFld) do
      aiThisTabFld[i] := aiAThisTabFld[i];
    FillChar(aiOthTabFld,SizeOf(aiOthTabFld),#0);
    for i := Low(aAiOthTabFld) to High(aAiOthTabFld) do
      aiOthTabFld[i] := aAiOthTabFld[i];
  end;
end;

{____________________________________________________________________________}
Procedure DefTable (const sName,sType,sPassword: string;
                    const iAFldCount,iAIDXCount,iAValChkCount,iARintCount: integer);
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
    iRintCount := iARintCount;
    pecrRintOp := @RefIntegOp; pRINTDesc := @RefInteg;
    iValChkCount := iAValChkCount;
    pecrValChkOp := @ValCheckOp; pvchkDesc := @ValCheckDesc;
    iIDXCount := iAIDXCount;
    pecrIDXOp := @IndexesOp; pIDXDesc := @IndexesDesc;
  end;
end;

{____________________________________________________________________________}
procedure StoredProg;
begin
  DefField('CodPrg',fldINT32,fldstAUTOINC,0,1,0);
  DefField('Nome',fldZSTRING,0,1,32,0);
  DefField('Path',fldZSTRING,0,2,200,0);
  DefField('Hint',fldBLOB,fldstMEMO,3,200,0);
  DefField('Icona',fldBLOB,fldstGRAPHIC,4,0,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,4096,1,true,true,false,true,false,false,false,false);
  DefTable('PROG.DB','PARADOX','Shell',5,1,0,0);
end;

{____________________________________________________________________________}
procedure StoredUsers;
begin
  DefField('CodUsr',fldINT32,fldstAUTOINC,0,1,0);
  DefField('Nome',fldZSTRING,0,1,20,0);
  DefField('Password',fldZSTRING,0,2,16,0);
  DefField('System',fldBOOL,0,3,1,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,4096,1,true,true,false,true,false,false,false,false);
  DefIndex('IdxNome','','','','',[2],
           1,256,1,20,0,4096,2,false,false,false,true,false,false,false,true);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,4,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefTable('USERS.DB','PARADOX','Shell',4,2,2,0);
end;

{____________________________________________________________________________}
procedure StoredGrants;
begin
  DefField('CodUsr',fldINT32,0,0,1,0);
  DefField('CodPrg',fldINT32,0,1,1,0);
  DefIndex('','','','','',[1,2],
           0,0,2,8,0,4096,1,true,true,false,true,false,false,false,false);
  DefIndex('CodPrg','','','','',[2],
           1,2,1,4,0,4096,2,false,false,false,true,false,false,false,false);
  DefRefInt(0,1,1,[2],[1],'RRCodPrg','PROG.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefRefInt(1,2,1,[1],[1],'RRCodUsr','USERS.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('GRANTS.DB','PARADOX','Shell',2,2,0,2);
end;

{____________________________________________________________________________}
procedure ReadStoredTable (iTable: StoredTables);
begin
  case StoredTables(iTable) of
    Prog    : StoredProg;
    Users   : StoredUsers;
    Grants  : StoredGrants;
  end;
end;

{____________________________________________________________________________}
procedure MakeAllTables (dbDatabase: TDatabase);
var
  iTables: StoredTables;
begin try
  Screen.Cursor := crHourGlass;
  if dbDatabase = nil then begin
    dbDatabase := TDatabase.Create(Application);
    with dbDatabase do begin
      DatabaseName := '__DBTEMP__';
      DriverName := 'STANDARD';
      Params.Add('PATH='+Session.NetFileDir);
    end;
  end;
  dbDatabase.Connected := true;
  Check(DbiGetDirectory(dbDatabase.Handle,False,szDirectory));
  if szDirectory[StrLen(szDirectory)-1] <> '\' then
    szDirectory[StrLen(szDirectory)] := '\';
  for iTables := Low(iTables) to High(iTables) do begin
    ReadStoredTable(iTables);
    if DBICreateTable(dbDatabase.Handle,false,TableDesc) = DBIERR_FILEEXISTS then begin
      TableDesc.iFldCount := 0;
      DeleteAuxFiles;
      Check(DBIDoRestructure(dbDatabase.Handle,1,@TableDesc,nil,nil,nil,false));
    end;
  end;
finally
  if dbDatabase.DatabaseName = '__DBTEMP__' then
    dbDatabase.Free;
    Screen.Cursor := crDefault;
end; end;

end.
