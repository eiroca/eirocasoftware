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
unit Makedb;
{Table Scanner V1.05 [by demian@unix.horizontes.com.br]}
{Code generated on Thursday, August 13, 1998 at 09:06 AM}

Interface

Uses SysUtils, Forms, Controls, DB, dbiprocs, dbitypes, dbierrs, dbtables;

procedure MakeAllTables (dbDatabase: TDatabase);

Implementation

Type
  StoredTables = (Tbcodmis,Tbcodiva,Settori,Articoli,Fatforls,Fatformv,
                  Fatforsp,Fornisce,Fornit);

Var
  szDirectory : DBIPATH;
  TableDesc   : CRTblDesc;
  FieldsDesc  : array[0..24] of FLDDesc;
  RefIntegOp  : array[0..2] of CROpType; RefInteg    : array[0..2] of RINTDesc;
  ValCheckOp  : array[0..19] of CROpType; ValCheckDesc: array[0..19] of VCHKDesc;
  IndexesOp   : array[0..2] of CROpType; IndexesDesc : array[0..2] of IDXDesc;

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
procedure StoredTbcodmis;
begin
  DefField('CodMis',fldINT16,0,0,1,0);
  DefField('Desc',fldZSTRING,0,1,10,0);
  DefIndex('','','','','',[1],
           0,0,1,2,0,4096,1,true,true,false,true,false,false,false,false);
  DefIndex('IdxDesc','','','','',[2],
           1,256,1,10,0,4096,2,false,false,false,true,false,false,false,true);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefTable('TBCODMIS.DB','PARADOX','Lupin3',2,2,1,0);
end;

{____________________________________________________________________________}
procedure StoredTbcodiva;
begin
  DefField('CodIVA',fldINT16,0,0,1,0);
  DefField('Alq',fldFLOAT,0,1,1,0);
  DefField('Desc',fldZSTRING,0,2,40,0);
  DefIndex('','','','','',[1],
           0,0,1,2,0,4096,1,true,true,false,true,false,false,false,false);
  DefIndex('IdxMain','','','','',[2,3],
           1,256,2,48,0,4096,2,false,false,false,true,false,false,false,true);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefTable('TBCODIVA.DB','PARADOX','Lupin3',3,2,1,0);
end;

{____________________________________________________________________________}
procedure StoredSettori;
begin
  DefField('CodAlf',fldZSTRING,0,0,3,0);
  DefField('SetMer',fldZSTRING,0,1,13,0);
  DefField('PreDes',fldZSTRING,0,2,10,0);
  DefField('RicMin',fldFLOAT,0,3,1,0);
  DefField('RicMax',fldFLOAT,0,4,1,0);
  DefIndex('','','','','',[1],
           0,0,1,3,0,4096,1,true,true,false,true,false,false,false,false);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,4,[0],[0],[0],
              false,true,false,true,'','',lkupNONE);
  DefValCheck(2,5,[0],[0],[0],
              false,true,false,true,'','',lkupNONE);
  DefTable('SETTORI.DB','PARADOX','Lupin3',5,1,3,0);
end;

{____________________________________________________________________________}
procedure StoredArticoli;
begin
  DefField('CodAlf',fldZSTRING,0,0,3,0);
  DefField('CodNum',fldINT16,0,1,1,0);
  DefField('Desc',fldZSTRING,0,2,30,0);
  DefField('Attv',fldBOOL,0,3,1,0);
  DefField('CodIVA',fldINT16,0,4,1,0);
  DefField('CodMis',fldINT16,0,5,1,0);
  DefField('Qta',fldFLOAT,0,6,1,0);
  DefField('QtaInv',fldFLOAT,0,7,1,0);
  DefField('QtaDelta',fldFLOAT,0,8,1,0);
  DefField('QtaAcq',fldFLOAT,0,9,1,0);
  DefField('QtaOrd',fldFLOAT,0,10,1,0);
  DefField('QtaVen',fldFLOAT,0,11,1,0);
  DefField('QtaPre',fldFLOAT,0,12,1,0);
  DefField('QtaSco',fldFLOAT,0,13,1,0);
  DefField('PrzLis',fldFLOAT,fldstMONEY,14,1,0);
  DefField('PrzNor',fldFLOAT,fldstMONEY,15,1,0);
  DefField('PrzSpe',fldFLOAT,fldstMONEY,16,1,0);
  DefField('RicNor',fldINT16,0,17,1,0);
  DefField('RicSpe',fldINT16,0,18,1,0);
  DefField('PrePriAcq',fldFLOAT,fldstMONEY,19,1,0);
  DefField('PreUltAcq',fldFLOAT,fldstMONEY,20,1,0);
  DefField('DatPriAcq',fldDATE,0,21,1,0);
  DefField('DatUltAcq',fldDATE,0,22,1,0);
  DefField('CumuloAcq',fldFLOAT,0,23,1,0);
  DefField('CumuloOrd',fldFLOAT,0,24,1,0);
  DefIndex('','','','','',[1,2],
           0,0,2,5,0,4096,1,true,true,false,true,false,false,false,false);
  DefIndex('CodMis','','','','',[6],
           1,6,1,2,0,4096,2,false,false,false,true,false,false,false,false);
  DefIndex('CodIVA','','','','',[5],
           2,5,1,2,0,4096,3,false,false,false,true,false,false,false,false);
  DefValCheck(0,4,[0],[0],[1],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(1,5,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(2,6,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(3,7,[0],[0],[0],
              true,false,false,true,'','',lkupNONE);
  DefValCheck(4,8,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(5,9,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(6,10,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(7,11,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(8,12,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(9,13,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(10,14,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(11,15,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(12,16,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(13,17,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(14,18,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(15,19,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(16,20,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(17,21,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(18,24,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(19,25,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefRefInt(0,1,1,[6],[1],'RRCodMis','TBCODMIS.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefRefInt(1,2,1,[5],[1],'RRCodIVA','TBCODIVA.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefRefInt(2,3,1,[1],[1],'RRCodAlf','SETTORI.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('ARTICOLI.DB','PARADOX','Lupin3',25,3,20,3);
end;

{____________________________________________________________________________}
procedure StoredFatforls;
begin
  DefField('CodFatFor',fldINT32,0,0,1,0);
  DefField('CodFor',fldINT32,0,1,1,0);
  DefField('NumFatt',fldZSTRING,0,2,15,0);
  DefField('DataFatt',fldDATE,0,3,1,0);
  DefField('TotaleImp',fldFLOAT,fldstMONEY,4,1,0);
  DefField('TotaleIVA',fldFLOAT,fldstMONEY,5,1,0);
  DefField('TotaleFat',fldFLOAT,fldstMONEY,6,1,0);
  DefField('Preventivo',fldBOOL,0,7,1,0);
  DefField('Modificato',fldBOOL,0,8,1,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,4096,1,true,true,false,true,false,false,false,false);
  DefValCheck(0,5,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(1,6,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(2,7,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(3,8,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(4,9,[0],[0],[1],
              false,false,false,true,'','',lkupNONE);
  DefTable('FATFORLS.DB','PARADOX','Lupin3',9,1,5,0);
end;

{____________________________________________________________________________}
procedure StoredFatformv;
begin
  DefField('CodMov',fldINT32,fldstAUTOINC,0,1,0);
  DefField('CodFatFor',fldINT32,0,1,1,0);
  DefField('CodAlf',fldZSTRING,0,2,3,0);
  DefField('CodNum',fldINT32,0,3,1,0);
  DefField('Qta',fldFLOAT,0,4,1,0);
  DefField('Imp',fldFLOAT,fldstMONEY,5,1,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,4096,1,true,true,false,true,false,false,false,false);
  DefIndex('CodFatFor','','','','',[2],
           1,2,1,4,0,4096,2,false,false,false,true,false,false,false,false);
  DefRefInt(0,1,1,[2],[1],'RRCodFatFor','FATFORLS.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('FATFORMV.DB','PARADOX','Lupin3',6,2,0,1);
end;

{____________________________________________________________________________}
procedure StoredFatforsp;
begin
  DefField('CodSpe',fldINT32,fldstAUTOINC,0,1,0);
  DefField('CodFatFor',fldINT32,0,1,1,0);
  DefField('Imp',fldFLOAT,fldstMONEY,2,1,0);
  DefField('IVA',fldFLOAT,fldstMONEY,3,1,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,4096,1,true,true,false,true,false,false,false,false);
  DefIndex('CodFatFor','','','','',[2],
           1,2,1,4,0,4096,2,false,false,false,true,false,false,false,false);
  DefRefInt(0,1,1,[2],[1],'RRCodFatFor','FATFORLS.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('FATFORSP.DB','PARADOX','Lupin3',4,2,0,1);
end;

{____________________________________________________________________________}
procedure StoredFornisce;
begin
  DefField('CodAlf',fldZSTRING,0,0,3,0);
  DefField('CodNum',fldINT16,0,1,1,0);
  DefField('CodFor',fldINT32,0,2,1,0);
  DefIndex('','','','','',[1,2,3],
           0,0,3,9,0,4096,1,true,true,false,true,false,false,false,false);
  DefTable('FORNISCE.DB','PARADOX','Lupin3',3,1,0,0);
end;

{____________________________________________________________________________}
procedure StoredFornit;
begin
  DefField('CodFor',fldINT32,0,0,1,0);
  DefField('Nome',fldZSTRING,0,1,30,0);
  DefField('Potenziale',fldBOOL,0,2,1,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,4096,1,true,true,false,true,false,false,false,false);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,3,[0],[0],[1],
              false,false,false,true,'','',lkupNONE);
  DefTable('FORNIT.DB','PARADOX','Lupin3',3,1,2,0);
end;

{____________________________________________________________________________}
procedure ReadStoredTable (iTable: StoredTables);
begin
  case StoredTables(iTable) of
    Tbcodmis: StoredTbcodmis;
    Tbcodiva: StoredTbcodiva;
    Settori : StoredSettori;
    Articoli: StoredArticoli;
    Fatforls: StoredFatforls;
    Fatformv: StoredFatformv;
    Fatforsp: StoredFatforsp;
    Fornisce: StoredFornisce;
    Fornit  : StoredFornit;
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
