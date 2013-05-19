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
 Unit: ProDos
 Do general I/O with Prodos Harddisk images
*)
unit uProDos;

interface

const
  SizeOfBlock = 512;
  ErrIO          = 1;
  ErrInvalidFile = 2;
  ErrNoFreeBlk   = 3;
  ErrBadBlkMrk   = 4;

type

  PathStr = string;
  DirStr = string;
  NameStr = string;
  ExtStr = string;

  PProBlock = ^TProBlock;
  TProBlock = packed array[0..511] of byte;

  PBlockArr = ^TBlockArr;
  TBlockArr = packed record
    Lo: packed array[1..256] of byte;
    Hi: packed array[1..256] of byte;
  end;

  PProDate = ^TProDate;
  TProDate   = packed array[0..1] of word;

  PProName = ^TProName;
  TProName = packed array[1..15] of AnsiChar;

  PNameStr = ^TNameStr;
  TNameStr = string[15];

  PExtStr = ^TNameStr;
  TExtStr = string[3];

  PVolItem = ^TVolItem;
  TVolItem = packed record
    KndLen  : byte;
    VolName : TProName;
    UnUsed  : packed array[0..7] of byte;
    CreaDate: TProDate;
    VerPro  : byte;
    MinPro  : byte;
    Access  : byte;
    ItmLen  : byte;
    ItmInBlk: byte;
    NumItem : word;
    VBMBlk  : word;
    NumBlk  : word;
  end;

  PSubItem = ^TSubItem;
  TSubItem = packed record
    KndLen  : byte;
    SubName : TProName;
    UnUsed  : packed array[0..7] of byte;
    CreaDate: TProDate;
    VerPro  : byte;
    MinPro  : byte;
    Access  : byte;
    ItmLen  : byte;
    ItmInBlk: byte;
    NumItem : word;
    PrntBlk : word;
    PrntPos : byte;
    PrntItSz: byte;
  end;

  PFileItem = ^TFileItem;
  TFileItem = packed record
    KndLen  : byte;
    FileName: TProName;
    Kind    : byte;
    PosBlk  : word;
    SizBlk  : word;
    Size    : packed array[0..2] of byte;
    CreaDate: TProDate;
    VerPro  : byte;
    MinPro  : byte;
    Access  : byte;
    AuxBit  : word;
    ModiDate: TProDate;
    NumBlk  : word;
  end;

  PVBM = ^TVBM;
  TVBM = record
    Strt   : word;
    Size   : word;
    NumBlk : word;
    BlkFree: word;
    Last   : word;
    Map    : array[0..15] of TProBlock;
    Changed: boolean;
  end;

  PProDosDisk = ^TProDosDisk;
  TProDosDisk = record
    Dsk   : file;
    FilNam: PathStr;
    VBM   : PVBM;
    VolBlk: word;
    Vol   : TVolItem;
    DirBlk: word;
    Dir   : TSubItem;
  end;

const

  NumExt = 17;
  Exten: array[1..NumExt] of record Num: byte; Ext: TExtStr end = (
    (Num: $00; Ext: '$$$'),
    (Num: $01; Ext: 'BAD'),
    (Num: $04; Ext: 'TXT'),
    (Num: $06; Ext: 'BIN'),
    (Num: $0F; Ext: 'DIR'),
    (Num: $19; Ext: 'ADB'),
    (Num: $1A; Ext: 'AWP'),
    (Num: $1B; Ext: 'ASP'),
    (Num: $E0; Ext: 'SHK'),
    (Num: $EF; Ext: 'PAS'),
    (Num: $F0; Ext: 'CMD'),
    (Num: $FA; Ext: 'INT'),
    (Num: $FB; Ext: 'IVR'),
    (Num: $FC; Ext: 'BAS'),
    (Num: $FD; Ext: 'VAR'),
    (Num: $FE; Ext: 'REL'),
    (Num: $FF; Ext: 'SYS'));

  af_Delete = 128;
  af_Rename =  64;
  af_Modify =  32;
  af_Write  =   2;
  af_Read   =   1;

procedure SplitFileName(fileName: string; var dir, nam, ext: string);

procedure MakeDir(Dir: PathStr);
procedure GotoDir(Dir: PathStr);

procedure ReadBlock (var Dsk: file; Blk: word; var Buf);
procedure WriteBlock(var Dsk: file; Blk: word; var Buf);

procedure ReadVBM (var Disk: TProDosDisk);
procedure WriteVBM(var Disk: TProDosDisk);

function  SeekBitBlock(var Disk: TProDosDisk; Blk: word; var i,j: integer; var Msk: byte): boolean;
function  GetFreeBlock(var Disk: TProDosDisk): word;
procedure MarkBlock   (var Disk: TProDosDisk; Blk: word; Free: boolean);

procedure OpenDisk (var Disk: TProDosDisk; FN: PathStr);
procedure CloseDisk(var Disk: TProDosDisk);

procedure OpenDir (var Disk: TProDosDisk; Block: word);
procedure CloseDir(var Disk: TProDosDisk);
procedure PrintDir(var Disk: TProDosDisk; Ext: boolean);
function  GetFileName(var Disk: TProDosDisk; var Name: TNameStr; var Item: TFileItem): boolean;

procedure PrintVolItem(Item: PVolItem; Ext: boolean);
procedure PrintSubItem(Item: PSubItem; Ext: boolean);
procedure PrintFileItem(Item: PFileItem; Ext: boolean);
procedure PrintSubFileItem(Item: PFileItem; Ext: boolean);

function  MsDosName(Name: TNameStr; Kind: byte): PathStr;
procedure ExportFile (var Disk: TProDosDisk; var Item: TFileItem; var OutName: PathStr);
procedure ExportDir  (var Disk: TProDosDisk);
procedure ImportFile (var Disk: TProDosDisk; var InName: PathStr);
procedure ImportFiles(var Disk: TProDosDisk; FN: PathStr);

implementation

uses SysUtils;

const
  HexStr: array[0..15] of char = '0123456789ABCDEF';
  BitMask: array[0..7] of byte = (128,64,32,16,8,4,2,1);

procedure SplitFileName(fileName: string; var dir, nam, ext: string);
begin
  Dir:= ExtractFileDir(fileName);
  Nam:= ExtractFileName(fileName);
  Ext:= ExtractFileExt(fileName);
end;

(* General function *)
function LongMul(X, Y: integer): longint;
begin
  LongMul:= X * Y;
end;

procedure Error(ErrNo: integer);
begin
  case ErrNo of
    ErrIO          : Writeln('ERROR: IO error');
    ErrInvalidFile : Writeln('ERROR: invalid file');
    ErrNoFreeBlk   : Writeln('ERROR: no free block');
    ErrBadBlkMrk   : Writeln('ERROR: bad block mark');
    else Writeln('Error #',ErrNo);
  end;
  Halt(1);
end;

procedure WaitReturn;
begin
  readln;
end;

procedure MakeDir(Dir: PathStr);
var
  cd, ds, mk: DirStr;
  i: integer;
begin
  GetDir(0, cd);
  for i:= 1 to Length(Dir) do if Dir[i] ='/' then Dir[i]:= '\';
  if Dir[Length(Dir)] <> '\' then Dir:= Dir+'\';
  ds:= ExtractFileDir(Dir);
  {$I-} ChDir(ds); {$I+}
  if IOResult <> 0 then begin
    if ds[2] = ':' then begin
      ChDir(Copy(ds,1,2)+'\');
      Delete(ds,1,2);
    end;
    repeat
      if ds[1] = '\' then Delete(Ds,1,1);
      i:= Pos('\', ds);
      if i = 0 then mk:= ds else mk:= Copy(ds, 1, i-1);
      {$I-} ChDir(mk); {$I+}
      if IOResult <> 0 then begin
        MkDir(mk);
        ChDir(mk);
      end;
      Delete(ds, 1, i);
    until i = 0;
  end;
  ChDir(cd);
end;

procedure GotoDir(Dir: PathStr);
var
  i: integer;
begin
  if Dir[Length(Dir)] = '\' then SetLength(Dir, Length(Dir)-1);
  {$I-} ChDir(ExpandFileName (Dir)); {$I+}
  i:= IOResult;
  if i = 3 then begin
    (* se non hai trovato il path prova aggiungendo un '\',
    gestisce cosi' i cdx drive: quando si e' gia in drive: *)
    Dir:=Dir+'\';
    {$I-} ChDir(Dir); {$I+}
    i:= IOResult;
  end;
  Error(-i);
end;

(* General printing/coversion functions *)
function Print2(a: word): string;
begin
 if a<10 then Result:= '0'+IntToStr(a) else Result:= IntToStr(a);
end;

function PrintAccess(Access: byte): string;
begin
  if (Access and af_Delete) <> 0 then Result:= '+d' else Result:= '-d';
  if (Access and af_Rename) <> 0 then Result:= '+n' else Result:= '-n';
  if (Access and af_Modify) <> 0 then Result:= '+a' else Result:= '-a';
  if (Access and af_Write ) <> 0 then Result:= '+w' else Result:= '-w';
  if (Access and af_Read  ) <> 0 then Result:= '+r' else Result:= '-r';
end;

function PrintDate(Date: TProDate): string;
begin
  if (Date[0] = 0) and (Date[1] = 0) then begin
    Result:= '<NO DATE>        ';
  end
  else begin
    Result:= Print2(Date[0] and $1F)+'-'+Print2((Date[0] shr 5) and $0F)+'-'+IntToStr(1900+Date[0] shr 9)+' '+
       Print2(Date[1] shr 8)+':'+Print2(Date[1] and $FF)+' ';
  end;
end;

function PrintKnd(Knd: byte): string;
var tmp: string;
begin
  if Knd > 10 then tmp:= '$0'+Chr(55+Knd) else tmp:= '$0'+Chr(Knd+48);
  case Knd of
     0: tmp:= tmp+' deleted file';
     1: tmp:= tmp+' 1 block file';
     2: tmp:= tmp+' <128K file';
     3: tmp:= tmp+' big file';
    $D: tmp:= tmp+' subdirectory file';
    $E: tmp:= tmp+' subdirectory header';
    $F: tmp:= tmp+' volume header';
    else tmp:= tmp+' unknown';
  end;
  PrintKnd:= tmp;
end;

function Knd2Ext(Kind: byte): TExtStr;
var
  tmp: TExtStr;
  i: integer;
begin
  tmp:= '';
  for i:= 1 to NumExt do if Kind = Exten[i].Num then begin tmp:= Exten[i].Ext; break; end;
  if tmp = '' then tmp:= '$'+HexStr[Kind shr 4]+HexStr[Kind and $0F];
  Knd2Ext:= tmp;
end;

function Ext2Knd(Exte: ExtStr): byte;
var
  i: integer;
begin
  if Exte[1] = '.' then Delete(Exte,1,1);
  for i:= 1 to 3 do Exte[i]:= UpCase(Exte[i]);
  Ext2Knd:= $06; (* dafault Binary *)
  for i:= 1 to NumExt do if Exten[i].Ext = Exte then begin
    Ext2Knd:= Exten[i].Num;
    break;
  end;
end;

function GetName(Itm: PFileItem; Trim: boolean): TNameStr;
var
  Name: TNameStr;
begin
  with Itm^ do begin
    FillChar(Name, SizeOf(Name),' ');
    if Trim then begin
     SetLength(Name, KndLen and $0F)
    end else begin
      SetLength(Name, 15);
    end;
    Move(FileName, Name[1], KndLen and $0F);
  end;
  GetName:= Name;
end;

procedure PrintVolItem(Item: PVolItem; Ext: boolean);
var Name: TNameStr;
begin
  with Item^ do begin
    Name:= GetName(PFileItem(Item), false);
    if Ext then begin
      Writeln('Kind         : ', PrintKnd((KndLen and $F0) shr 4));
      Writeln('FileName Len : ', (KndLen and $0F));
      Writeln('FileName     : ', Name);
      Writeln('Creation Date: ', PrintDate(CreaDate));
      Writeln('Prodos Vers. : ', VerPro);
      Writeln('Min Prodos   : ', MinPro);
      Writeln('Access flag  : ', PrintAccess(Access));
      Writeln('Item length  : ', ItmLen);
      Writeln('Item in block: ', ItmInBlk);
      Writeln('Num of items : ', NumItem);
      Writeln('VBM position : ', VBMBlk);
      Writeln('Num of Bloks : ', NumBlk);
      WaitReturn;
    end
    else begin
      Writeln('/',Name, ' Access:', PrintAccess(Access));
    end;
  end
end;

procedure PrintSubItem(Item: PSubItem; Ext: boolean);
var Name: TNameStr;
begin
  with Item^ do begin
    Name:= GetName(PFileItem(Item), false);
    if Ext then begin
      Writeln('Kind         : ', PrintKnd((KndLen and $F0) shr 4));
      Writeln('FileName Len : ', (KndLen and $0F));
      Writeln('FileName     : ', Name);
      Writeln('Creation Date: ', PrintDate(CreaDate));
      Writeln('Prodos Vers. : ', VerPro);
      Writeln('Min Prodos   : ', MinPro);
      Writeln('Access flag  : ', PrintAccess(Access));
      Writeln('Item length  : ', ItmLen);
      Writeln('Item in block: ', ItmInBlk);
      Writeln('Num of items : ', NumItem);
      Writeln('Parent Pos.  : ', PrntPos);
      Writeln('Prnt Itm Size: ', PrntItSz);
      WaitReturn;
    end
    else begin
      Writeln('../',Name, ' Access:', PrintAccess(Access));
    end;
  end;
end;

procedure PrintFileItem(Item: PFileItem; Ext: boolean);
var
  Name: TNameStr;
  Siz : longint;
begin
  with Item^ do begin
    Name:= GetName(Item, false);
    Siz:= (LongMul(Size[2],256)+Size[1])*256+Size[0];
    if Ext then begin
      Writeln('Kind         : ', PrintKnd((KndLen and $F0) shr 4));
      Writeln('FileName Len : ', (KndLen and $0F));
      Writeln('FileName     : ', Name);
      Writeln('File Kind    : ', Knd2Ext(Kind));
      Writeln('File Pos     : ', PosBlk);
      Writeln('Blocks Size  : ', SizBlk);
      Writeln('Size         : ', Siz);
      Writeln('Creation Date: ', PrintDate(CreaDate));
      Writeln('Modifify Date: ', PrintDate(ModiDate));
      Writeln('Prodos Vers. : ', VerPro);
      Writeln('Min Prodos   : ', MinPro);
      Writeln('Access flag  : ', PrintAccess(Access));
      Writeln('Aux. Bits    : $', IntToHex(AuxBit, 4));
      Writeln('Num. Block   : ', NumBlk);
      WaitReturn;
    end
    else begin
      if (KndLen and $F0) = 0 then exit;
      if (Access and 2) = 0 then Write('*') else Write(' ');
      Writeln(Name,' ',Knd2Ext(Kind),SizBlk:5,' ',PrintDate(ModiDate),' ',
        PrintDate(CreaDate),' ',Siz:8,' $',IntToHex(AuxBit, 4));
    end;
  end;
end;

procedure PrintSubFileItem(Item: PFileItem; Ext: boolean);
var
  Name: TNameStr;
  Siz : longint;
begin
  with Item^ do begin
    Name:= GetName(Item, false);
    Siz:= (LongMul(Size[2],256)+Size[1])*256+Size[0];
    if Ext then begin
      Writeln('Kind         : ', PrintKnd((KndLen and $F0) shr 4));
      Writeln('FileName Len : ', (KndLen and $0F));
      Writeln('FileName     : ', Name);
      Writeln('File Kind    : ', Knd2Ext(Kind));
      Writeln('File Pos     : ', PosBlk);
      Writeln('Blocks Size  : ', SizBlk);
      Writeln('Size         : ', Siz);
      Writeln('Creation Date: ', PrintDate(CreaDate));
      Writeln('Modifify Date: ', PrintDate(ModiDate));
      Writeln('Prodos Vers. : ', VerPro);
      Writeln('Min Prodos   : ', MinPro);
      Writeln('Access flag  : ', PrintAccess(Access));
      Writeln('Aux. Bits    : $', IntToHex(AuxBit, 4));
      Writeln('Num. Block   : ', NumBlk);
      WaitReturn;
    end
    else begin
      if (KndLen and $F0) = 0 then exit;
      if (Access and 2) = 0 then Write('*') else Write(' ');
      Writeln(Name,' ',Knd2Ext(Kind),SizBlk:5,' ',PrintDate(ModiDate),' ',
        PrintDate(CreaDate), PrintAccess(Access));
    end;
  end;
end;

(* Low level disk function *)
procedure ReadBlock(var Dsk: file; Blk: word; var Buf);
var rd: integer;
begin
  Seek(Dsk, LongMul(Blk, SizeOfBlock));
  BlockRead(Dsk, Buf, SizeOfBlock, rd);
  if rd <> SizeOfBlock then Error(ErrIO);
end;

procedure WriteBlock(var Dsk: file; Blk: word; var Buf);
var wr: integer;
begin
  Seek(Dsk, LongMul(Blk, SizeOfBlock));
  BlockWrite(Dsk, Buf, SizeOfBlock, wr);
  if wr <> SizeOfBlock then Error(ErrIO);
end;

(* Volume BitMap functions *)
procedure ReadVBM(var Disk: TProDosDisk);
var
  i, j, k: integer;
  Blk: longint;
  Resto: integer;
label _Esci;
begin
  with Disk do begin
    New(VBM);
    with VBM^ do begin
      Strt   := Vol.VBMBlk;
      NumBlk := Vol.NumBlk;
      Resto  := NumBlk mod 8;
      BlkFree:= 0;
      Size   := (longint(NumBlk)+SizeOfBlock-1) div (512*8);
      Last   := 0;
      Changed:= false;
      for i:= 0 to Size-1 do begin
        ReadBlock(Dsk, Strt+i, Map[i]);
      end;
      Blk:= 0;
      for i:= 0 to Size-1 do begin
        for j:= 0 to 511 do begin
          for k:= 0 to 7 do begin
            Inc(Blk);
            if (Map[i][j] and BitMask[k]) <> 0 then Inc(BlkFree);
          end;
          if Blk >= NumBlk then goto _Esci;
        end;
      end;
    _Esci:
    end;
  end;
end;

procedure WriteVBM(var Disk: TProDosDisk);
var i: integer;
begin
  with Disk do begin
    with VBM^ do begin
      if Changed then begin
        for i:= 0 to Size-1 do begin
          WriteBlock(Dsk, Strt+i, Map[i]);
        end;
        Changed:= false;
      end;
    end;
  end;
end;

function SeekBitBlock(var Disk: TProDosDisk; Blk: word; var i,j: integer; var Msk: byte): boolean;
begin
  i:= Blk shr (3+9);
  j:= (Blk shr (3) and 511);
  Msk:= BitMask[Blk and $07];
  SeekBitBlock:= (Disk.VBM^.Map[i,j] and Msk) = Msk;
end;

function GetFreeBlock(var Disk: TProDosDisk): word;
var
  i: word;
  mp, Ofs: integer;
  Msk: byte;
begin
  with Disk.VBM^ do begin
    for i:= Last to NumBlk do begin
      if SeekBitBlock(Disk, i, mp, Ofs, Msk) then begin
        Last:= i;
        GetFreeBlock:= i;
        exit;
      end;
    end;
  end;
  Error(ErrNoFreeBlk);
end;

procedure MarkBlock(var Disk: TProDosDisk; Blk: word; Free: boolean);
var
  mp, Ofs: integer;
  Msk: byte;
begin
  with Disk.VBM^ do begin
    if Free then begin
      if not SeekBitBlock(Disk, Blk, mp, Ofs, Msk) then begin
        Changed:= true;
        Map[mp,Ofs]:= Map[mp,Ofs] or Msk;
        if Blk < Last then Last:= Blk;
        Inc(BlkFree);
      end
      else Error(ErrBadBlkMrk);
    end
    else begin
      if SeekBitBlock(Disk, Blk, mp, Ofs, Msk) then begin
        Changed:= true;
        Map[mp,Ofs]:= Map[mp,Ofs] and (not Msk);
        Dec(BlkFree);
      end
      else Error(ErrBadBlkMrk);
    end;
  end;
end;

(* disk functions *)
procedure OpenDisk(var Disk: TProDosDisk; FN: PathStr);
var
  Ext: ExtStr;
  Buf: TProBlock;
begin
  with Disk do begin
    FilNam:= ExpandFileName(FN);
    Ext:= ExtractFileExt(FilNam);
    if Ext = '.dsk' then VolBlk:= 4 else VolBlk:= 2;
    Assign(Dsk, FilNam);
    Reset(Dsk, 1);
    ReadBlock(Dsk, VolBlk, Buf);
    Move(Buf[4], Vol, SizeOf(Vol));
    ReadVBM(Disk);
  end;
end;

procedure CloseDisk(var Disk: TProDosDisk);
begin
  with Disk do begin
    WriteVBM(Disk);
    Dispose(VBM);
    Close(Dsk);
  end;
end;

(* dir functions *)
procedure OpenDir(var Disk: TProDosDisk; Block: word);
var
  Buf: TProBlock;
begin
  with Disk do begin
    DirBlk:= Block;
    ReadBlock(Dsk, Block, Buf);
    Move(Buf[4], Dir, SizeOf(Dir));
  end;
end;

procedure CloseDir(var Disk: TProDosDisk);
var
  Buf: TProBlock;
  Lnk: array[0..1] of word Absolute Buf;
begin
  with Disk do begin
    if ((Dir.KndLen and $F0) = $E0) then begin
      DirBlk:= Dir.PrntBlk;
      repeat
        ReadBlock(Dsk, DirBlk, Buf);
        if Lnk[0] <> 0 then DirBlk:= Lnk[0];
      until Lnk[0] = 0;
      Move(Buf[4], Dir, SizeOf(Dir));
    end;
  end;
end;

procedure PrintDir(var Disk: TProDosDisk; Ext: boolean);
var
  Buf: TProBlock;
  Lnk: array[0..1] of word Absolute Buf;
  Itm: pointer;
  Pos: word;
  i: word;
begin
  Pos:= 4;
  with Disk do begin
    ReadBlock(Dsk, DirBlk, Buf);
    Move(Buf[4], Dir, SizeOf(Dir));
    i:= 0;
    repeat
      Inc(i);
      if Pos >= 511 then begin
        Pos:= 4;
        ReadBlock(Dsk, Lnk[1], Buf);
      end;
      Itm:= @Buf[Pos];
      case (PVolItem(Itm)^.KndLen and $F0) shr 4 of
        $0F: PrintVolItem(Itm, Ext);
        $0E: PrintSubItem(Itm, Ext);
        $0D: PrintSubFileItem(Itm, Ext);
        1..3: PrintFileItem(Itm, Ext);
        0: begin
          PrintFileItem(Itm, Ext);
          Dec(i);
        end;
      end;
      if (i mod 20) = 0 then WaitReturn;
      Inc(Pos, Dir.ItmLen);
     until i>Dir.NumItem;
  end;
end;

function GetFileName(var Disk: TProDosDisk; var Name: TNameStr; var Item: TFileItem): boolean;
var
  Buf: TProBlock;
  Lnk: array[0..1] of word Absolute Buf;
  Itm: PFileItem;
  Pos: word;
  i: word;
  Nm: TNameStr;
begin
  Pos:= 4;
  with Disk do begin
    ReadBlock(Dsk, DirBlk, Buf);
    Move(Buf[4], Dir, SizeOf(Dir));
    i:= 0;
    repeat
      if Pos >= 511 then begin
        Pos:= 4;
        ReadBlock(Dsk, Lnk[1], Buf);
      end;
      Itm:= @Buf[Pos];
      if (Itm^.KndLen and $F0) <> 0 then begin
        Inc(i);
        Nm:= GetName(Itm, true);
        if Name = Nm then begin
          Item:= Itm^;
          GetFileName:= true;
          exit;
        end;
      end;
      Inc(Pos, Dir.ItmLen);
    until i>Dir.NumItem;
  end;
  GetFileName:= false;
end;

function MsDosName(Name: TNameStr; Kind: byte): PathStr;
var
  ps: integer;
begin
  Result:= Name+'.'+Knd2Ext(Kind);
  if FileExists(Result) then begin
    ps:= 0;
    repeat
      inc(ps);
      Result:=Name+'_'+IntToStr(ps)+'.'+Knd2Ext(Kind);
    until not FileExists(Result);
  end;
end;

procedure ExportFile(var Disk: TProDosDisk; var Item: TFileItem; var OutName: PathStr);
var
  MsDir: DirStr;
  Nam: NameStr;
  Siz : longint;
  i, j, Ps, Bs: integer;
  Err: integer;
  Buf : TProBlock;
  Ent, Ent1: TBlockArr;
  Out: file;
  ch: char;
begin
  OutName:= ExpandFileName(OutName);
  MsDir:= ExtractFileDir(OutName);
  Nam:= ExtractFileName(OutName);
  OutName:= MsDir+'\'+Nam;
  MakeDir(MsDir);
  if FileExists(OutName) then begin
    Write('File exists. Overwrite? '); Readln(ch);
    if not CharInSet(UpCase(ch), ['Y','S','J']) then exit;
  end;
  Assign(Out, OutName);
  Rewrite(Out, 1);
  with Item do begin
    Siz:= (LongMul(Size[2],256)+Size[1])*256+Size[0];
    case KndLen shr 4 of
      1: begin
        ReadBlock(Disk.Dsk, PosBlk, Buf);
        BlockWrite(Out, Buf, SizeOfBlock, Err);
        if Err <> SizeOfBlock then Error(ErrIO);
      end;
      2: begin
        ReadBlock(Disk.Dsk, PosBlk, Ent);
        for i:= 1 to SizBlk-1 do begin
          ReadBlock(Disk.Dsk, Ent.Lo[i]+256*Ent.Hi[i], Buf);
          BlockWrite(Out, Buf, SizeOfBlock, Err);
          if Err <> SizeOfBlock then Error(ErrIO);
        end;
      end;
      3: begin
        ReadBlock(Disk.Dsk, PosBlk, Ent1);
        bs:= 1 + (Siz+(256*512-1)) div (256*512);
        j:= 0;
        Ps:= 999;
        for i:= 1 to SizBlk-bs do begin
          if Ps > 256 then begin
            Ps:= 1;
            Inc(j);
            ReadBlock(Disk.Dsk, Ent1.Lo[j]+256*Ent1.Hi[j], Ent);
          end;
          ReadBlock(Disk.Dsk, Ent.Lo[Ps]+256*Ent.Hi[Ps], Buf);
          BlockWrite(Out, Buf, SizeOfBlock, Err);
          if Err <> SizeOfBlock then Error(ErrIO);
          Inc(Ps);
        end;
      end;
      else Error(ErrInvalidFile);
    end;
  end;
  Seek(Out, Siz);
  Truncate(Out);
  Close(Out);
end;

procedure ExportDir(var Disk: TProDosDisk);
var
  Buf: TProBlock;
  Lnk: array[0..1] of word Absolute Buf;
  Itm: PFileItem;
  Pos: word;
  i: word;
  Name: PathStr;
begin
  Pos:= 4;
  with Disk do begin
    ReadBlock(Dsk, DirBlk, Buf);
    Move(Buf[4], Dir, SizeOf(Dir));
    i:= 0;
    repeat
      Inc(i);
      if Pos >= 511 then begin
        Pos:= 4;
        ReadBlock(Dsk, Lnk[1], Buf);
      end;
      Itm:= @Buf[Pos];
      case (Itm^.KndLen and $F0) shr 4 of
        1..3: begin
          Name:= GetName(Itm, true);
          Name:= MsDosName(Name, Itm^.Kind);
          Writeln('Exporting... ', Name);
          ExportFile(Disk, Itm^, Name);
        end;
      end;
      Inc(Pos, Dir.ItmLen);
     until i>Dir.NumItem;
  end;
end;

procedure ImportFile(var Disk: TProDosDisk; var InName: PathStr);
var
  Inp: file;
  Item: TFileItem;
  Name: NameStr;
  Nam: string[12];
  Ext: ExtStr;
  Siz: longint;
  i,j: integer;
  Err: integer;
  Pos, Blk,
  NewBlk, Attr: word;
  Knd: byte;
  hh, mm, se, ms: word;
  Year, Month, Day, DayOfWeek: word;
  Ent, Ent1: TBlockArr;
  Buf: TProBlock;
  Lnk: array[0..1] of word Absolute Buf;
begin
  if not FileExists(InName) then exit;
  Name:= ExtractFileName(InName);
  Ext:= ExtractFileExt(InName);
  Nam:= Name;
  Assign(Inp, InName);
  Reset(Inp, 1);
  Siz:= FileSize(Inp);
  if Siz < 512 then Knd:= 1
  else if Siz < 256*512 then Knd:= 2
  else Knd:= 3;
  with Item, Disk do begin
    Kind:= Ext2Knd(Ext);
    if Length(Nam) >15 then SetLength(Nam, 15);
    KndLen  := Knd*16+Length(Nam);
    FillChar(FileName, 15, 0);
    for i:= 1 to Length(Nam) do begin
      Nam[i]:= UpCase(Nam[i]);
      if Nam[i] in ['A'..'Z','0'..'9','.'] then FileName[i]:= Nam[i]
      else FileName[i]:='.';
    end;
    PosBlk  := GetFreeBlock(Disk);
    MarkBlock(Disk, PosBlk, false);
    case Knd of
      1: SizBlk:= 1;
      2: SizBlk:= 1+(Siz+511) div 512;
      3: begin
        SizBlk:= (Siz+511) div 512;
        SizBlk:= 1 + SizBlk + (SizBlk+255) div 256;
      end;
    end;
    Size[0]:= Siz and $FF;
    Size[1]:= (Siz shr 8) and $FF;
    Size[2]:= Siz shr 16;
    VerPro  := 0;
    MinPro  := 0;
    Attr:= FileGetAttr(InName);
    Access  := af_Delete+af_Rename+af_Write+af_Read;
    if (Attr and faReadOnly) <> 0 then Access:= Access and (not (af_Delete+af_Write));
    if (Attr and faArchive ) <> 0 then Access:= Access or af_Modify;
    if Kind = $FF then AuxBit:= $2000 else AuxBit:= 0;
    DecodeDate(Date, Year, Month, Day);
    CreaDate[0]:= ((Year-1900) mod 127) shl 9 + Month shl 5 + Day;
    DecodeTime(Time, hh, mm, se, ms);
    CreaDate[1]:= hh shl 8 + mm;
    ModiDate:= CreaDate;
    ReadBlock(Dsk, DirBlk, Buf);
    Dir:= PSubItem(@Buf[4])^;
    Inc(PSubItem(@Buf[4])^.NumItem);
    Inc(Dir.NumItem);
    WriteBlock(Dsk, DirBlk, Buf);
    Pos:= 4; Blk:= DirBlk;
    repeat
      if Pos >= 511 then begin
        Pos:= 4;
        if Lnk[1] = 0 then begin (* make new dir blk *)
          NewBlk:= GetFreeBlock(Disk);
          MarkBlock(Disk, NewBlk, false);
          Lnk[1]:= NewBlk;
          WriteBlock(Dsk, Blk, Buf);
          FillChar(Buf, SizeOf(Buf), 0);
          Lnk[0]:= Blk; Lnk[1]:= 0;
          Blk:= NewBlk;
          Writeln('Parent dir info not update!');
        end
        else begin
          Blk:= Lnk[1];
          ReadBlock(Dsk, Blk, Buf);
        end;
      end;
      if (PFileItem(@Buf[Pos])^.KndLen and $F0) = 0 then begin
        NumBlk  := Blk;
        PFileItem(@Buf[Pos])^:= Item;
        WriteBlock(Dsk, Blk, Buf);
        break;
      end;
      Inc(Pos, Dir.ItmLen);
    until false;
    case KndLen shr 4 of
      1: begin
        FillChar(Buf, SizeOf(Buf), 0);
        BlockRead(Inp, Buf, Siz, Err);
        WriteBlock(Dsk, PosBlk, Buf);
      end;
      2: begin
        FillChar(Ent, SizeOf(Ent), 0);
        for i:= 1 to SizBlk-1 do begin
          Blk:= GetFreeBlock(Disk);
          MarkBlock(Disk, Blk, false);
          Ent.Lo[i]:= Lo(Blk);
          Ent.Hi[i]:= Hi(Blk);
          BlockRead(Inp, Buf, SizeOfBlock, Err);
          if Err <> SizeOfBlock then begin
            FillChar(Buf[Err],512-Err,0);
          end;
          WriteBlock(Dsk, Blk, Buf);
        end;
        WriteBlock(Dsk, PosBlk, Ent);
      end;
      3: begin
        FillChar(Ent, SizeOf(Ent1), 0);
        Pos:= 999; j:= 0; NewBlk:= 0;
        for i:= 1 to (Siz+511) div 512 do begin
          if Pos > 256 then begin
            if NewBlk <> 0 then WriteBlock(Dsk, NewBlk, Ent);
            Pos:= 1;
            Inc(j);
            NewBlk:= GetFreeBlock(Disk);
            MarkBlock(Disk, NewBlk, false);
            Ent1.Lo[j]:= Lo(NewBlk);
            Ent1.Hi[j]:= Hi(NewBlk);
            FillChar(Ent, SizeOf(Ent), 0);
          end;
          Blk:= GetFreeBlock(Disk); MarkBlock(Disk, Blk, false);
          Ent.Lo[Pos]:= Lo(Blk);
          Ent.Hi[Pos]:= Hi(Blk);
          BlockRead(Inp, Buf, SizeOfBlock, Err);
          if Err <> SizeOfBlock then begin
            FillChar(Buf[Err],512-Err,0);
          end;
          WriteBlock(Dsk, Blk, Buf);
          Inc(Pos);
        end;
        WriteBlock(Dsk, NewBlk, Ent);
        WriteBlock(Dsk, PosBlk, Ent1);
      end;
      else Error(ErrInvalidFile);
    end;
  end;
  Close(Inp);
end;

procedure ImportFiles(var Disk: TProDosDisk; FN: PathStr);
var
  MsDir: DirStr;
  DirInfo: TSearchRec;
  Err: integer;
begin
  MsDir:= ExtractFileDir(FN);
  Err:= FindFirst(FN, faAnyFile and (not (faSysFile or faDirectory or faVolumeID)), DirInfo);
  while Err = 0 do begin
    with DirInfo do begin
      Writeln('Importing... ', Name);
      FN:= MsDir+'\'+Name;
      ImportFile(Disk, FN);
    end;
    Err:= FindNext(DirInfo);
  end;
  FindClose(DirInfo);
  WriteVBM(Disk);
end;

end.
