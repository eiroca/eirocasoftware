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
{Code generated on Tuesday, July 14, 1998 at 08:34 AM}

Interface

uses
  Windows, SysUtils, Forms, Controls, DB, dbtables, dbiprocs, dbitypes, dbierrs;

procedure MakeAllTables (dbDatabase: TDatabase);

Implementation

Type
  StoredTables = (Carilist,Tabacrit,Tabaprod,Tabatipo,Tabacchi,
                  Carimovs,Giaclist,Giacmovs,Patename,Pacolist,
                  Pacomovs,Prezlist,Prezmovs,Tabastat);

Var
  szDirectory : DBIPATH;
  TableDesc   : CRTblDesc;
  FieldsDesc  : array[0..11] of FLDDesc;
  RefIntegOp  : array[0..2] of CROpType; RefInteg    : array[0..2] of RINTDesc;
  ValCheckOp  : array[0..11] of CROpType; ValCheckDesc: array[0..11] of VCHKDesc;
  IndexesOp   : array[0..5] of CROpType; IndexesDesc : array[0..5] of IDXDesc;

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
procedure StoredCarilist;
begin
  DefField('PCAR',fldINT32,fldstAUTOINC,0,1,0);
  DefField('DATA',fldDATE,0,1,1,0);
  DefField('DATAORDI',fldDATE,0,2,1,0);
  DefField('DATAPREZ',fldDATE,0,3,1,0);
  DefField('KGC',fldFLOAT,0,4,1,0);
  DefField('VAL',fldFLOAT,fldstMONEY,5,1,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('IdxDATAORDI','','','','',[3],
           1,257,1,4,0,2048,2,false,false,false,true,false,false,false,true);
  DefIndex('IdxDATA','','','','',[2],
           2,256,1,4,0,2048,3,false,false,false,true,false,false,false,true);
  DefValCheck(0,3,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,4,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(2,5,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(3,6,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefTable('CARILIST.DB','PARADOX','Jigen',6,3,4,0);
end;

{____________________________________________________________________________}
procedure StoredTabacrit;
begin
  DefField('CRIT',fldINT16,0,0,1,0);
  DefField('DESC',fldZSTRING,0,1,40,0);
  DefIndex('','','','','',[1],
           0,0,1,2,0,2048,1,true,true,false,true,false,false,false,false);
  DefValCheck(0,1,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefTable('TABACRIT.DB','PARADOX','Jigen',2,1,2,0);
end;

{____________________________________________________________________________}
procedure StoredTabaprod;
begin
  DefField('PROD',fldINT16,0,0,1,0);
  DefField('DESC',fldZSTRING,0,1,40,0);
  DefIndex('','','','','',[1],
           0,0,1,2,0,2048,1,true,true,false,true,false,false,false,false);
  DefValCheck(0,1,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefTable('TABAPROD.DB','PARADOX','Jigen',2,1,2,0);
end;

{____________________________________________________________________________}
procedure StoredTabatipo;
begin
  DefField('TIPO',fldINT16,0,0,1,0);
  DefField('DESC',fldZSTRING,0,1,40,0);
  DefIndex('','','','','',[1],
           0,0,1,2,0,2048,1,true,true,false,true,false,false,false,false);
  DefValCheck(0,1,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefTable('TABATIPO.DB','PARADOX','Jigen',2,1,2,0);
end;

{____________________________________________________________________________}
procedure StoredTabacchi;
begin
  DefField('CODI',fldINT16,0,0,1,0);
  DefField('CODS',fldZSTRING,0,1,4,0);
  DefField('TIPO',fldINT16,0,2,1,0);
  DefField('PROD',fldINT16,0,3,1,0);
  DefField('CRIT',fldINT16,0,4,1,0);
  DefField('DESC',fldZSTRING,0,5,30,0);
  DefField('ATTV',fldBOOL,0,6,1,0);
  DefField('MULI',fldINT16,0,7,1,0);
  DefField('QTAS',fldINT16,0,8,1,0);
  DefField('QTAC',fldINT16,0,9,1,0);
  DefField('QTAM',fldINT16,0,10,1,0);
  DefField('DIFR',fldINT16,0,11,1,0);
  DefIndex('','','','','',[1],
           0,0,1,2,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('IdxCODS','','','','',[2],
           1,257,1,4,0,2048,2,false,false,false,true,false,false,false,true);
  DefIndex('IdxDESC','','','','',[6],
           2,256,1,30,0,2048,3,false,false,false,true,false,false,false,true);
  DefIndex('CRIT','','','','',[5],
           3,5,1,2,0,2048,4,false,false,false,true,false,false,false,false);
  DefIndex('PROD','','','','',[4],
           4,4,1,2,0,2048,5,false,false,false,true,false,false,false,false);
  DefIndex('TIPO','','','','',[3],
           5,3,1,2,0,2048,6,false,false,false,true,false,false,false,false);
  DefValCheck(0,1,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(2,3,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(3,4,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(4,5,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(5,6,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(6,7,[0],[0],[1],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(7,8,[0],[232,3],[10],
              false,true,true,true,'','',lkupNONE);
  DefValCheck(8,9,[0],[232,3],[10],
              false,true,true,true,'','',lkupNONE);
  DefValCheck(9,10,[0],[232,3],[50],
              false,true,true,true,'','',lkupNONE);
  DefValCheck(10,11,[0],[232,3],[10],
              false,true,true,true,'','',lkupNONE);
  DefValCheck(11,12,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefRefInt(0,1,1,[5],[1],'RRCrit','TABACRIT.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefRefInt(1,2,1,[4],[1],'RRProd','TABAPROD.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefRefInt(2,3,1,[3],[1],'RRTipo','TABATIPO.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('TABACCHI.DB','PARADOX','Jigen',12,6,12,3);
end;

{____________________________________________________________________________}
procedure StoredCarimovs;
begin
  DefField('PCAR',fldINT32,0,0,1,0);
  DefField('CODI',fldINT16,0,1,1,0);
  DefField('CARI',fldINT32,0,2,1,0);
  DefIndex('','','','','',[1,2],
           0,0,2,6,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('CODI','','','','',[2],
           1,2,1,2,0,2048,2,false,false,false,true,false,false,false,false);
  DefValCheck(0,1,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(2,3,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefRefInt(0,1,1,[2],[1],'RRCODI','TABACCHI.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefRefInt(1,2,1,[1],[1],'RRPCAR','CARILIST.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('CARIMOVS.DB','PARADOX','Jigen',3,2,3,2);
end;

{____________________________________________________________________________}
procedure StoredGiaclist;
begin
  DefField('PGIA',fldINT32,fldstAUTOINC,0,1,0);
  DefField('DATA',fldDATE,0,1,1,0);
  DefField('DATAPREZ',fldDATE,0,2,1,0);
  DefField('KGC',fldFLOAT,0,3,1,0);
  DefField('VAL',fldFLOAT,fldstMONEY,4,1,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('IdxData','','','','',[2],
           1,256,1,4,0,2048,2,false,false,false,true,false,false,false,true);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,3,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(2,4,[0],[0],[0],
              false,true,false,true,'','',lkupNONE);
  DefValCheck(3,5,[0],[0],[0],
              false,true,false,true,'','',lkupNONE);
  DefTable('GIACLIST.DB','PARADOX','Jigen',5,2,4,0);
end;

{____________________________________________________________________________}
procedure StoredGiacmovs;
begin
  DefField('PGIA',fldINT32,0,0,1,0);
  DefField('CODI',fldINT16,0,1,1,0);
  DefField('GIAC',fldINT32,0,2,1,0);
  DefIndex('','','','','',[1,2],
           0,0,2,6,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('CODI','','','','',[2],
           1,2,1,2,0,2048,2,false,false,false,true,false,false,false,false);
  DefValCheck(0,1,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(2,3,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefRefInt(0,1,1,[2],[1],'RRCODI','TABACCHI.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefRefInt(1,2,1,[1],[1],'RRPGIA','GIACLIST.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('GIACMOVS.DB','PARADOX','Jigen',3,2,3,2);
end;

{____________________________________________________________________________}
procedure StoredPatename;
begin
  DefField('CODP',fldINT32,fldstAUTOINC,0,1,0);
  DefField('NOME',fldZSTRING,0,1,30,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('IdxName','','','','',[2],
           1,256,1,30,0,2048,2,false,false,false,true,false,false,false,true);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefTable('PATENAME.DB','PARADOX','Jigen',2,2,1,0);
end;

{____________________________________________________________________________}
procedure StoredPacolist;
begin
  DefField('PPCO',fldINT32,fldstAUTOINC,0,1,0);
  DefField('CODP',fldINT32,0,1,1,0);
  DefField('DATA',fldDATE,0,2,1,0);
  DefField('DATAORDI',fldDATE,0,3,1,0);
  DefField('DATAPREZ',fldDATE,0,4,1,0);
  DefField('KGC',fldFLOAT,0,5,1,0);
  DefField('VAL',fldFLOAT,fldstMONEY,6,1,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('IdxDATA','','','','',[3],
           1,257,1,4,0,2048,2,false,false,false,true,false,false,false,true);
  DefIndex('IdxDATAORDI','','','','',[4],
           2,256,1,4,0,2048,3,false,false,false,true,false,false,false,true);
  DefIndex('CODP','','','','',[2],
           3,2,1,4,0,2048,4,false,false,false,true,false,false,false,false);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,4,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(2,5,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(3,6,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(4,7,[0],[0],[0],
              true,false,false,true,'','',lkupNONE);
  DefRefInt(0,1,1,[2],[1],'RRCODP','PATENAME.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('PACOLIST.DB','PARADOX','Jigen',7,4,5,1);
end;

{____________________________________________________________________________}
procedure StoredPacomovs;
begin
  DefField('PPCO',fldINT32,0,0,1,0);
  DefField('CODI',fldINT16,0,1,1,0);
  DefField('CONS',fldINT32,0,2,1,0);
  DefIndex('','','','','',[1,2],
           0,0,2,6,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('CODI','','','','',[2],
           1,2,1,2,0,2048,2,false,false,false,true,false,false,false,false);
  DefValCheck(0,1,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(2,3,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefRefInt(0,1,1,[2],[1],'RRCODI','TABACCHI.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefRefInt(1,2,1,[1],[1],'RRPPCO','PACOLIST.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('PACOMOVS.DB','PARADOX','Jigen',3,2,3,2);
end;

{____________________________________________________________________________}
procedure StoredPrezlist;
begin
  DefField('PPRE',fldINT32,fldstAUTOINC,0,1,0);
  DefField('DATA',fldDATE,0,1,1,0);
  DefField('DESC',fldZSTRING,0,2,40,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('IdxDATA','','','','',[2],
           1,256,1,4,0,2048,2,false,false,false,true,false,false,false,true);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefTable('PREZLIST.DB','PARADOX','Jigen',3,2,1,0);
end;

{____________________________________________________________________________}
procedure StoredPrezmovs;
begin
  DefField('PPRE',fldINT32,0,0,1,0);
  DefField('CODI',fldINT16,0,1,1,0);
  DefField('PREZ',fldFLOAT,fldstMONEY,2,1,0);
  DefIndex('','','','','',[1,2],
           0,0,2,6,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('CODI','','','','',[2],
           1,2,1,2,0,2048,2,false,false,false,true,false,false,false,false);
  DefValCheck(0,1,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(2,3,[0],[0],[0],
              true,true,false,false,'','',lkupNONE);
  DefRefInt(0,1,1,[2],[1],'RRCODI','TABACCHI.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefRefInt(1,2,1,[1],[1],'RRPPRE','PREZLIST.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('PREZMOVS.DB','PARADOX','Jigen',3,2,3,2);
end;

{____________________________________________________________________________}
procedure StoredTabastat;
begin
  DefField('CODI',fldINT16,0,0,1,0);
  DefField('MEDA',fldFLOAT,0,1,1,0);
  DefField('MAXA',fldFLOAT,0,2,1,0);
  DefField('MED5',fldFLOAT,0,3,1,0);
  DefField('MAX5',fldFLOAT,0,4,1,0);
  DefField('MED0',fldFLOAT,0,5,1,0);
  DefField('MAX0',fldFLOAT,0,6,1,0);
  DefIndex('','','','','',[1],
           0,0,1,2,0,2048,1,true,true,false,true,false,false,false,false);
  DefValCheck(0,1,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,2,[0],[0],[0],
              false,true,false,true,'','',lkupNONE);
  DefValCheck(2,3,[0],[0],[0],
              false,true,false,true,'','',lkupNONE);
  DefValCheck(3,4,[0],[0],[0],
              false,true,false,true,'','',lkupNONE);
  DefValCheck(4,5,[0],[0],[0],
              false,true,false,true,'','',lkupNONE);
  DefValCheck(5,6,[0],[0],[0],
              false,true,false,true,'','',lkupNONE);
  DefValCheck(6,7,[0],[0],[0],
              false,true,false,true,'','',lkupNONE);
  DefRefInt(0,1,1,[1],[1],'RRCodI','TABACCHI.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('TABASTAT.DB','PARADOX','Jigen',7,1,7,1);
end;

{____________________________________________________________________________}
procedure ReadStoredTable (iTable: StoredTables);
begin
  case StoredTables(iTable) of
    Carilist: StoredCarilist;
    Tabacrit: StoredTabacrit;
    Tabaprod: StoredTabaprod;
    Tabatipo: StoredTabatipo;
    Tabacchi: StoredTabacchi;
    Carimovs: StoredCarimovs;
    Giaclist: StoredGiaclist;
    Giacmovs: StoredGiacmovs;
    Patename: StoredPatename;
    Pacolist: StoredPacolist;
    Pacomovs: StoredPacomovs;
    Prezlist: StoredPrezlist;
    Prezmovs: StoredPrezmovs;
    Tabastat: StoredTabastat;
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
