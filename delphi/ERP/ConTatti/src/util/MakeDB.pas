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
{Code generated on Tuesday, March 17, 1998 at 07:22 PM}

Interface

uses
  Windows, SysUtils, Forms, Controls, DB, dbiprocs, dbitypes, dbierrs, dbtables;

procedure MakeAllTables (dbDatabase: TDatabase);

Implementation

uses
  Costanti;
Type
  StoredTables = (Contat,Aziende,Connessi,Dateimpo,Gruppi,Indiriz,
                  Ingruppo,Nickname,Referent,Telef);

Var
  szDirectory : DBIPATH;
  TableDesc   : CRTblDesc;
  FieldsDesc  : array[0..9] of FLDDesc;
  RefIntegOp  : array[0..1] of CROpType; RefInteg    : array[0..1] of RINTDesc;
  ValCheckOp  : array[0..5] of CROpType; ValCheckDesc: array[0..5] of VCHKDesc;
  IndexesOp   : array[0..3] of CROpType; IndexesDesc : array[0..3] of IDXDesc;

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
procedure StoredContat;
begin
  DefField('CodCon',fldINT32,fldstAUTOINC,0,1,0);
  DefField('Tipo',fldINT32,0,1,1,0);
  DefField('Nome_Tit',fldZSTRING,0,2,10,0);
  DefField('Nome_Pre1',fldZSTRING,0,3,20,0);
  DefField('Nome_Pre2',fldZSTRING,0,4,40,0);
  DefField('Nome_Main',fldZSTRING,0,5,40,0);
  DefField('Nome_Suf',fldZSTRING,0,6,10,0);
  DefField('Classe',fldZSTRING,0,7,15,0);
  DefField('Settore',fldZSTRING,0,8,35,0);
  DefField('Note',fldBLOB,fldstMEMO,9,100,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,4096,1,true,true,false,true,false,false,false,false);
  DefIndex('IdxClasse','','','','',[8,6,4],
           1,258,3,75,0,4096,2,false,false,false,true,false,false,false,true);
  DefIndex('IdxSettore','','','','',[9,6,4],
           2,257,3,95,0,4096,3,false,false,false,true,false,false,false,true);
  DefIndex('IdxNome','','','','',[6,4],
           3,256,2,60,0,4096,4,false,false,false,true,false,false,false,true);
  DefValCheck(0,2,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefTable('CONTAT.DB','PARADOX',DBPassword,10,4,1,0);
end;

{____________________________________________________________________________}
procedure StoredAziende;
begin
  DefField('CodInt',fldINT32,fldstAUTOINC,0,1,0);
  DefField('CodCon',fldINT32,0,1,1,0);
  DefField('Tipo',fldINT32,0,2,1,0);
  DefField('CodAux',fldINT32,0,3,1,0);
  DefField('CodFis',fldZSTRING,0,4,16,0);
  DefField('ParIVA',fldZSTRING,0,5,11,0);
  DefField('Nome',fldBLOB,fldstMEMO,6,100,0);
  DefField('Note',fldBLOB,fldstMEMO,7,100,0);
  DefField('FirstContact',fldDATE,0,8,1,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('CodCon','','','','',[2],
           1,2,1,4,0,2048,2,false,false,false,true,false,false,false,false);
  DefValCheck(0,1,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(2,3,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(3,4,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefValCheck(4,5,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(5,6,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefRefInt(0,1,1,[2],[1],'RRCodCon','CONTAT.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('AZIENDE.DB','PARADOX',DBPassword,9,2,6,1);
end;

{____________________________________________________________________________}
procedure StoredConnessi;
begin
  DefField('CodCos',fldINT32,fldstAUTOINC,0,1,0);
  DefField('CodCon',fldINT32,0,1,1,0);
  DefField('Tipo',fldINT32,0,2,1,0);
  DefField('Data',fldTIMESTAMP,0,3,1,0);
  DefField('Contenuto',fldZSTRING,0,4,50,0);
  DefField('Note',fldBLOB,fldstMEMO,5,200,0);
  DefField('URL',fldZSTRING,0,6,255,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('CodCon','','','','',[2],
           1,2,1,4,0,2048,2,false,false,false,true,false,false,false,false);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,3,[0],[0],[0],
              true,false,false,true,'','',lkupNONE);
  DefValCheck(2,4,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefRefInt(0,1,1,[2],[1],'RRCodCon','CONTAT.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('CONNESSI.DB','PARADOX',DBPassword,7,2,3,1);
end;

{____________________________________________________________________________}
procedure StoredDateimpo;
begin
  DefField('Prog',fldINT32,fldstAUTOINC,0,1,0);
  DefField('CodCon',fldINT32,0,1,1,0);
  DefField('Tipo',fldINT32,0,2,1,0);
  DefField('Data',fldDATE,0,3,1,0);
  DefField('Nota',fldZSTRING,0,4,50,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('IdxData','','','','',[2,4],
           1,256,2,8,0,2048,2,false,false,false,true,false,false,false,true);
  DefIndex('CodCon','','','','',[2],
           2,2,1,4,0,2048,3,false,false,false,true,false,false,false,false);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,3,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefRefInt(0,1,1,[2],[1],'RRCodCon','CONTAT.DB',
            rintDEPENDENT,rintRESTRICT,rintRESTRICT);
  DefTable('DATEIMPO.DB','PARADOX',DBPassword,5,3,2,1);
end;

{____________________________________________________________________________}
procedure StoredGruppi;
begin
  DefField('CodGrp',fldINT32,fldstAUTOINC,0,1,0);
  DefField('Desc',fldZSTRING,0,1,30,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,4096,1,true,true,false,true,false,false,false,false);
  DefIndex('IdxDesc','','','','',[2],
           1,256,1,30,0,4096,2,false,false,false,true,false,false,false,true);
  DefTable('GRUPPI.DB','PARADOX',DBPassword,2,2,0,0);
end;

{____________________________________________________________________________}
procedure StoredIndiriz;
begin
  DefField('CodInd',fldINT32,fldstAUTOINC,0,1,0);
  DefField('CodCon',fldINT32,0,1,1,0);
  DefField('Tipo',fldINT32,0,2,1,0);
  DefField('Indirizzo',fldBLOB,fldstMEMO,3,200,0);
  DefField('Note',fldZSTRING,0,4,40,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('CodCon','','','','',[2],
           1,2,1,4,0,2048,2,false,false,false,true,false,false,false,false);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,3,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefRefInt(0,1,1,[2],[1],'RRCodCon','CONTAT.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('INDIRIZ.DB','PARADOX',DBPassword,5,2,2,1);
end;

{____________________________________________________________________________}
procedure StoredIngruppo;
begin
  DefField('Prog',fldINT32,fldstAUTOINC,0,1,0);
  DefField('CodCon',fldINT32,0,1,1,0);
  DefField('CodGrp',fldINT32,0,2,1,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,4096,1,true,true,false,true,false,false,false,false);
  DefIndex('CodGrp','','','','',[3],
           1,3,1,4,0,4096,2,false,false,false,true,false,false,false,false);
  DefIndex('CodCon','','','','',[2],
           2,2,1,4,0,4096,3,false,false,false,true,false,false,false,false);
  DefRefInt(0,1,1,[2],[1],'RRCodCon','CONTAT.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefRefInt(1,2,1,[3],[1],'RRCodGrp','GRUPPI.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('INGRUPPO.DB','PARADOX',DBPassword,3,3,0,2);
end;

{____________________________________________________________________________}
procedure StoredNickname;
begin
  DefField('Prog',fldINT32,fldstAUTOINC,0,1,0);
  DefField('CodCon',fldINT32,0,1,1,0);
  DefField('NickName',fldZSTRING,0,2,40,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,4096,1,true,true,false,true,false,false,false,false);
  DefIndex('CodCon','','','','',[2],
           1,2,1,4,0,4096,2,false,false,false,true,false,false,false,false);
  DefIndex('IdxNickName','','','','',[3,2],
           2,256,2,44,0,4096,3,false,false,false,true,false,false,false,true);
  DefValCheck(0,3,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefRefInt(0,1,1,[2],[1],'RRCodCon','CONTAT.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('NICKNAME.DB','PARADOX',DBPassword,3,3,1,1);
end;

{____________________________________________________________________________}
procedure StoredReferent;
begin
  DefField('Prog',fldINT32,fldstAUTOINC,0,1,0);
  DefField('CodCon',fldINT32,0,1,1,0);
  DefField('CodRef',fldINT32,0,2,1,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('CodRef','','','','',[3],
           1,3,1,4,0,2048,2,false,false,false,true,false,false,false,false);
  DefIndex('CodCon','','','','',[2],
           2,2,1,4,0,2048,3,false,false,false,true,false,false,false,false);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,3,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefRefInt(0,1,1,[2],[1],'RRCodCon','CONTAT.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefRefInt(1,2,1,[3],[1],'RRCodRef','CONTAT.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('REFERENT.DB','PARADOX',DBPassword,3,3,2,2);
end;

{____________________________________________________________________________}
procedure StoredTelef;
begin
  DefField('CodTel',fldINT32,fldstAUTOINC,0,1,0);
  DefField('CodCon',fldINT32,0,1,1,0);
  DefField('Tipo',fldINT32,0,2,1,0);
  DefField('Tel_Pre1',fldZSTRING,0,3,6,0);
  DefField('Tel_Pre2',fldZSTRING,0,4,6,0);
  DefField('Telefono',fldZSTRING,0,5,18,0);
  DefField('Note',fldZSTRING,0,6,40,0);
  DefIndex('','','','','',[1],
           0,0,1,4,0,2048,1,true,true,false,true,false,false,false,false);
  DefIndex('CodCon','','','','',[2],
           1,2,1,4,0,2048,2,false,false,false,true,false,false,false,false);
  DefValCheck(0,2,[0],[0],[0],
              true,false,false,false,'','',lkupNONE);
  DefValCheck(1,3,[0],[0],[0],
              false,false,false,true,'','',lkupNONE);
  DefRefInt(0,1,1,[2],[1],'RRCodCon','CONTAT.DB',
            rintDEPENDENT,rintCASCADE,rintRESTRICT);
  DefTable('TELEF.DB','PARADOX',DBPassword,7,2,2,1);
end;

{____________________________________________________________________________}
procedure ReadStoredTable (iTable: StoredTables);
begin
  case StoredTables(iTable) of
    Contat  : StoredContat;
    Aziende : StoredAziende;
    Connessi: StoredConnessi;
    Dateimpo: StoredDateimpo;
    Gruppi  : StoredGruppi;
    Indiriz : StoredIndiriz;
    Ingruppo: StoredIngruppo;
    Nickname: StoredNickname;
    Referent: StoredReferent;
    Telef   : StoredTelef;
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
