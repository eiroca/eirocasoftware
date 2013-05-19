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
unit ProDosFS;

interface

uses
  FileSys, ProDos, SysUtils;

const
  BlockSize = 512;
  RootBlock =   2;

type

  EFSVBMError  = class(EFSError);
  EFSNoFreeBlk = class(EFSVBMError);
  EFSBadBlkMrk = class(EFSVBMError);

type

  TBlock = array[0..BlockSize-1] of byte;

  TProDosVolume = class;
  TProDosVolumeInfo = class;

  TVBM = class
    private
     Volume: TProDosVolume;
     VBMBlk : word;
     NumBlk : word;
     BlkFree: word;
     Last   : word;
     Map    : array[0..8191] of byte;
     Changed: boolean;
    protected
     function  SeekBitBlock(Blk: word; var Pos: integer; var Msk: byte): boolean;
    public
     (* Volume BitMap functions *)
     constructor Create(aVolume: TProDosVolume);
     procedure Read;
     procedure Write;
     procedure MarkBlock(Blk: word; Free: boolean);
     function  GetFreeBlock: word;
  end;

  TProDosVolume = class(TFSVolume)
    private
     FFile     : file;
     FRootBlock: word;
     FVBM      : TVBM;
     FInfo     : TProDosVolumeInfo;
    protected
     procedure SetRootBlock(aBlock: word);
    public
     property RootBlock: word read FRootBlock write SetRootBlock;
     property VBM      : TVBM read FVBM;
     property Header   : TProDosVolumeInfo read FInfo;
    public
     (* disk functions *)
     constructor Create;
     procedure   ReadBlock (BlkNum: word; var Block: TBlock);
     procedure   WriteBlock(BlkNum: word; var Block: TBlock);
     procedure   Open;  override;
     function    GetRoot: TFSDirectory; override;
     procedure   Close; override;
  end;

  TProDosVolumeInfo = class(TFSEntry)
    private
     FVolInfo  : TProDosVolItem;
    public
     property Info: TProDosVolItem read FVolInfo;
    protected
     function  GetName: string; override;
    public
     constructor Create(aVolume: TProDosVolume);
     procedure   Rename(const NewName: string); override;
     procedure   Delete; override;
     procedure   Load;
     procedure   Save;
  end;

  TProDosDirectory = class(TFSDirectory)
    protected
     FDirInfo: TProDosDirItem;
     FDirBlk : word;
    public
     property Info  : TProDosDirItem read FDirInfo;
     property DirBlk: word read FDirBlk;
    protected
     function  GetName: string; override;
    public
     (* dir functions *)
     constructor Create(AVolume: TProDosVolume; ABlock: word);
     procedure   Rename(const NewName: string); override;
     procedure   Delete; override;
     function    FindFirst(var SearchRec: TObject): TFSEntry; override;
     function    FindNext (var SearchRec: TObject): TFSEntry; override;
     procedure   FindClose(var SearchRec: TObject); override;
     procedure   CdUp; override;
     procedure   MkDir(const DirName: string); override;
     procedure   CdDir(const DirName: string); override;
     function    NewFile(const FileName: string): TFSFile; override;
    public
     function  FindItemByName(Name: string; var Item: TProDosItem): boolean;
     procedure ExportFile(var Item: TProDosItem; const OutName: string);
     procedure ExportDir;
     procedure ImportFile(const InName: string);
     procedure ImportFiles;
  end;

  TProDosFile = class(TFSFile)
    protected
     FFileInfo: TProDosFileItem;
    public
     property Info  : TProDosFileItem read FFileInfo;
    protected
     function  GetFileSize: longint; override;
     function  GetName: string; override;
    public
     procedure Open; override;
     procedure Rename(const NewName: string); override;
     procedure Delete; override;
     procedure Read (var Buf; Size: integer); override;
     procedure Write(var Buf; Size: integer); override;
     procedure Truncate; override;
     procedure Close; override;
  end;

implementation

const
  BitMask: array[0..7] of byte = (128,64,32,16,8,4,2,1);

constructor TVBM.Create(aVolume: TProDosVolume);
begin
  Volume:= aVolume;
  VBMBlk:= Volume.Header.Info.VBMBlk;
  NumBlk:= Volume.Header.Info.NumBlk;
  Read;
end;

procedure TVBM.Read;
var
  Block: TBlock;
  i, j, k: integer;
  Blk: longint;
  Pos: integer;
label _Esci;
begin
  FillChar(Map, SizeOf(Map), 0);
  BlkFree:= 0;
  Last   := 0;
  Changed:= false;
  for i:= 0 to NumBlk-1 do begin
    Volume.ReadBlock(VBMBlk+i, Block);
    Move(Map[i*BlockSize], Block, BlockSize);
  end;
  Blk:= 0;
  Pos:= 0;
  for i:= 0 to NumBlk-1 do begin
    for j:= 0 to (BlockSize-1) do begin
      for k:= 0 to 7 do begin
        Inc(Blk);
        if (Map[Pos] and BitMask[k]) <> 0 then Inc(BlkFree);
      end;
      if Blk >= NumBlk then goto _Esci;
      inc(Pos);
    end;
  end;
_Esci:
end;

procedure TVBM.Write;
var
  i: integer;
  Block: TBlock;
begin
  if Changed then begin
    for i:= 0 to NumBlk-1 do begin
      Move(Block, Map[i*BlockSize], BlockSize);
      Volume.WriteBlock(VBMBlk+i, Block);
    end;
    Changed:= false;
  end;
end;

procedure TVBM.MarkBlock(Blk: word; Free: boolean);
var
  mp: integer;
  Msk: byte;
begin
  if Free then begin
    if not SeekBitBlock(Blk, mp,  Msk) then begin
      Changed:= true;
      Map[mp]:= Map[mp] or Msk;
      if Blk < Last then Last:= Blk;
      Inc(BlkFree);
    end
    else raise EFSBadBlkMrk.Create('');
  end
  else begin
    if SeekBitBlock(Blk, mp, Msk) then begin
      Changed:= true;
      Map[mp]:= Map[mp] and (not Msk);
      Dec(BlkFree);
    end
    else raise EFSBadBlkMrk.Create('');
  end;
end;

function TVBM.SeekBitBlock(Blk: word; var Pos: integer; var Msk: byte): boolean;
begin
  Pos:= Blk div 8;
  Msk:= BitMask[Blk and $07];
  SeekBitBlock:= (Map[Pos] and Msk) = Msk;
end;

function TVBM.GetFreeBlock: word;
var
  i: word;
  mp: integer;
  Msk: byte;
begin
  for i:= Last to NumBlk do begin
    if SeekBitBlock(i, mp, Msk) then begin
      Last:= i;
      GetFreeBlock:= i;
      exit;
    end;
  end;
  raise EFSNoFreeBlk.Create('');
end;

constructor TProDosVolume.Create;
begin
  FRootBlock:= RootBlock;
  FVBM      := nil;
  FInfo     := nil;
end;

procedure TProDosVolume.SetRootBlock(ABlock: word);
begin
  CheckActive(false);
  FRootBlock:= ABlock;
end;

procedure TProDosVolume.Open;
begin
  Assign(FFile, FileName);
  try
    Reset(FFile, 1);
  except
    Rewrite(FFile, 1);
  end;
  FInfo:= TProDosVolumeInfo.Create(Self);
  FVBM:= TVBM.Create(Self);
  FInfo.Load;
end;

function TProDosVolume.GetRoot: TFSDirectory;
begin
  Result:= TProDosDirectory.Create(Self, RootBlock);
end;

procedure TProDosVolume.ReadBlock(BlkNum: word; var Block: TBlock);
var
  rd: integer;
begin
  Seek(FFile, longint(BlkNum)*BlockSize);
  BlockRead(FFile, Block, BlockSize, rd);
  if rd <> BlockSize then raise EFSIOReadError.Create('');
end;

procedure TProDosVolume.WriteBlock(BlkNum: word; var Block: TBlock);
var
  wr: integer;
begin
  Seek(FFile, longint(BlkNum)*BlockSize);
  BlockWrite(FFile, Block, BlockSize, wr);
  if wr <> BlockSize then raise EFSIOWriteError.Create('');
end;

procedure TProDosVolume.Close;
begin
  VBM.Write;
  VBM.Free;
  FVBM:= nil;
  FInfo.Free;
  FInfo:= nil;
  CloseFile(FFile);
end;

constructor TProDosVolumeInfo.Create(aVolume: TProDosVolume);
begin
  FVolume:= aVolume;
  FillChar(FVolInfo, SizeOf(FVolInfo), 0);
end;

function TProDosVolumeInfo.GetName: string;
begin
  Result:= ProDos.GetName(@FVolInfo);
end;

procedure TProDosVolumeInfo.Rename(const NewName: string);
begin
  ProDos.SetName(@FVolInfo, NewName);
  Save;
end;

procedure TProDosVolumeInfo.Delete; 
begin
  raise EFSVolError.Create('Impossible to delete Volume information');
end;

procedure TProDosVolumeInfo.Load;
var
  Block: TBlock;
begin
  with TProDosVolume(Volume) do begin
    ReadBlock(RootBlock, Block);
    Move(Block[4], FVolInfo, Sizeof(FVolInfo));
  end;
end;

procedure TProDosVolumeInfo.Save;
var
  Block: TBlock;
begin
  with TProDosVolume(Volume) do begin
    ReadBlock(RootBlock, Block);
    Move(FVolInfo, Block[4], Sizeof(FVolInfo));
    WriteBlock(RootBlock, Block);
  end;
end;

constructor TProDosDirectory.Create(AVolume: TProDosVolume; ABlock: word);
var
  Buf: TBlock;
begin
  inherited Create(AVolume);
  FDirBlk:= ABlock;
  with TProDosVolume(Volume) do begin
    ReadBlock(DirBlk, Buf);
    Move(Buf[4], FDirInfo, SizeOf(FDirInfo));
  end;
end;

function TProDosDirectory.GetName: string;
begin
  Result:= ProDos.GetName(@FDirInfo);
end;

procedure TProDosDirectory.Rename(const NewName: string);
begin
  raise EFSError.Create('N/A')
end;

procedure TProDosDirectory.Delete;
begin
  raise EFSError.Create('N/A')
end;

function  TProDosDirectory.FindFirst(var SearchRec: TObject): TFSEntry;
begin
  raise EFSError.Create('N/A')
end;

function  TProDosDirectory.FindNext (var SearchRec: TObject): TFSEntry;
begin
  raise EFSError.Create('N/A')
end;

procedure TProDosDirectory.FindClose(var SearchRec: TObject); 
begin
  raise EFSError.Create('N/A')
end;

procedure TProDosDirectory.MkDir(const DirName: string); 
begin
  raise EFSError.Create('N/A')
end;

procedure TProDosDirectory.CdDir(const DirName: string); 
begin
  raise EFSError.Create('N/A')
end;

function  TProDosDirectory.NewFile(const FileName: string): TFSFile; 
begin
  raise EFSError.Create('N/A')
end;

procedure TProDosDirectory.CdUp;
var
  Buf: TBlock;
  Lnk: PProDosChain;
begin
  if ((Info.KndLen and $F0) = $E0) then begin
    FDirBlk:= Info.PrntBlk;
    Lnk:= PProDosChain(@Buf);
    with TProDosVolume(Volume) do begin
      repeat
        ReadBlock(DirBlk, Buf);
        if Lnk^.PrvBlk <> 0 then FDirBlk:= Lnk^.PrvBlk;
      until Lnk^.PrvBlk = 0;
      Move(Buf[4], FDirInfo, SizeOf(FDirInfo));
    end;
  end;
end;

function TProDosDirectory.FindItemByName(Name: string; var Item: TProDosItem): boolean;
var
  Buf: TBlock;
  Lnk: PProDosChain;
  Itm: PProDosItem;
  Pos: word;
  i: word;
  Nm: string;
begin
  Name:= LowerCase(Name);
  with TProDosVolume(Volume) do begin
    Result:= false;
    i:= 0;
    Lnk:= PProDosChain(@Buf);
    Pos:= 4;
    ReadBlock(DirBlk, Buf);
    repeat
      if Pos >= (BlockSize-1) then begin
        Pos:= 4;
        ReadBlock(Lnk^.NxtBlk, Buf);
      end;
      Itm:= @Buf[Pos];
      if (Itm^.KndLen and $F0) <> 0 then begin
        Inc(i);
        Nm:= LowerCase(Prodos.GetName(Itm));
        if Name = Nm then begin
          Item:= Itm^;
          Result:= true;
          break;
        end;
      end;
      Inc(Pos, Info.ItmLen);
    until i>Info.NumItem;
  end;
end;

procedure TProDosDirectory.ExportFile(var Item: TProDosItem; const OutName: string);
var
  Siz : longint;
  i, j, Ps, Bs: integer;
  Err: integer;
  Dat, Ent, Ent1: TBlock;
  Out: file;
  FilKnd: integer;
begin
  FilKnd:= (Item.KndLen and $F0) shr 4;
  if (FilKnd < 1) or (FilKnd > 3) then begin
    raise EFSFileError.Create('Invalid file kind');
  end;
  Assign(Out, OutName);
  Rewrite(Out, 1);
  with TProDosVolume(Volume), PProDosFileItem(@Item)^ do begin
    Siz:= (longint(Size[2])*256+Size[1])*256+Size[0];
    case FilKnd of
      1: begin
        ReadBlock(PosBlk, Dat);
        BlockWrite(Out, Dat, BlockSize, Err);
        if Err <> BlockSize then raise EFSIOError.Create('');
      end;
      2: begin
        ReadBlock(PosBlk, Ent);
        for i:= 1 to SizBlk-1 do begin
          ReadBlock(Ent[i]+256*Ent[i+(BlockSize div 2)], Dat);
          BlockWrite(Out, Dat, BlockSize, Err);
          if Err <> BlockSize then raise EFSIOError.Create('');
        end;
      end;
      3: begin
        ReadBlock(PosBlk, Ent1);
        bs:= 1 + (Siz+(256*BlockSize-1)) div (256*BlockSize);
        j:= 0;
        Ps:= 999;
        for i:= 1 to SizBlk-bs do begin
          if Ps > 256 then begin
            Ps:= 1;
            Inc(j);
            ReadBlock(Ent1[j]+256*Ent1[j+(BlockSize div 2)], Ent);
          end;
          ReadBlock(Ent[Ps]+256*Ent[Ps+(BlockSize div 2)], Dat);
          BlockWrite(Out, Dat, BlockSize, Err);
          if Err <> BlockSize then raise EFSIOError.Create('');
          Inc(Ps);
        end;
      end;
    end;
  end;
  Seek(Out, Siz);
  Truncate(Out);
  System.Close(Out);
end;

procedure TProDosDirectory.ExportDir;
var
  Buf: TBlock;
  Lnk: array[0..1] of word Absolute Buf;
  Itm: PProDosItem;
  Pos: word;
  i: word;
  Name: string;
begin
  Pos:= 4;
  with TProDosVolume(Volume) do begin
    ReadBlock(DirBlk, Buf);
    Move(Buf[4], FDirInfo, SizeOf(FDirInfo));
    i:= 0;
    repeat
      Inc(i);
      if Pos >= (BlockSize-1) then begin
        Pos:= 4;
        ReadBlock(Lnk[1], Buf);
      end;
      Itm:= @Buf[Pos];
      case (Itm^.KndLen and $F0) shr 4 of
        1..3: begin
          Name:= MsDosName(PProDosFileItem(Itm));
          ExportFile(Itm^, Name);
        end;
      end;
      Inc(Pos, Info.ItmLen);
    until i>Info.NumItem;
  end;
end;

procedure TProDosDirectory.ImportFile(const InName: string);
var
  Inp: file;
  Item: TProDosFileItem;
  Nam: string[12];
  Ext: string;
  Siz: longint;
  i,j: integer;
  Err: integer;
  Pos, Blk,
  NewBlk: word;
  Knd: byte;
  Year, Month, Day: word;
  Ent, Ent1: TBlock;
  Buf: TBlock;
  Lnk: array[0..1] of word Absolute Buf;
begin
  Year:= 1999; Month:= 12; Day:= 31;

  if not FileExists(InName) then exit;
  Assign(Inp, InName);
  Reset(Inp, 1);
  Siz:= FileSize(Inp);
  with TProDosVolume(Volume) do begin
    if Siz < BlockSize then Knd:= 1
    else if Siz < 256*BlockSize then Knd:= 2
    else Knd:= 3;
    with Item do begin
      Kind:= Ext2Knd(Ext);
      if Length(Nam) >15 then Nam[0]:= #15; (* redundant *)
      KndLen  := Knd*16+Length(Nam);
      FillChar(FileName, 15, 0);
      for i:= 1 to Length(Nam) do begin
        Nam[i]:= UpCase(Nam[i]);
        if Nam[i] in ['A'..'Z','0'..'9','.'] then FileName[i]:= Nam[i]
        else FileName[i]:= '.';
      end;
      PosBlk  := VBM.GetFreeBlock;
      VBM.MarkBlock(PosBlk, false);
      case Knd of
        1: SizBlk:= 1;
        2: SizBlk:= 1+(Siz+(BlockSize-1)) div BlockSize;
        3: begin
          SizBlk:= (Siz+(BlockSize-1)) div BlockSize;
          SizBlk:= 1 + SizBlk + (SizBlk+255) div 256;
        end;
      end;
      Size[0]:= Siz and $FF;
      Size[1]:= (Siz shr 8) and $FF;
      Size[2]:= Siz shr 16;
      VerPro  := 0;
      MinPro  := 0;
      Access  := af_Delete+af_Rename+af_Write+af_Read;
      if Kind = $FF then AuxBit:= $2000 else AuxBit:= 0;
      CreaDate[0]:= ((Year-1900) mod 127) shl 9 + Month shl 5 + Day;
      CreaDate[1]:= Year shl 8 + Month;
      ModiDate:= CreaDate;
      ReadBlock(DirBlk, Buf);
      Inc(PProDosDirItem(@Buf[4])^.NumItem);
      Inc(FDirInfo.NumItem);
      WriteBlock(DirBlk, Buf);
      Pos:= 4; Blk:= DirBlk;
      repeat
        if Pos >= (BlockSize-1) then begin
          Pos:= 4;
          if Lnk[1] = 0 then begin (* make new dir blk *)
            NewBlk:= VBM.GetFreeBlock;
            VBM.MarkBlock(NewBlk, false);
            Lnk[1]:= NewBlk;
            WriteBlock(Blk, Buf);
            FillChar(Buf, SizeOf(Buf), 0);
            Lnk[0]:= Blk; Lnk[1]:= 0;
            Blk:= NewBlk;
          end
          else begin
            Blk:= Lnk[1];
            ReadBlock(Blk, Buf);
          end;
        end;
        if (PProDosFileItem(@Buf[Pos])^.KndLen and $F0) = 0 then begin
          NumBlk  := Blk;
          PProDosFileItem(@Buf[Pos])^:= Item;
          WriteBlock(Blk, Buf);
          break;
        end;
        Inc(Pos, Info.ItmLen);
      until false;
      case KndLen shr 4 of
        1: begin
          FillChar(Buf, BlockSize, 0);
          BlockRead(Inp, Buf, Siz, Err);
          WriteBlock(PosBlk, Buf);
        end;
        2: begin
          FillChar(Ent, SizeOf(Ent), 0);
          for i:= 1 to SizBlk-1 do begin
            Blk:= VBM.GetFreeBlock;
            VBM.MarkBlock(Blk, false);
            Ent[i]:= Lo(Blk);
            Ent[i+(BlockSize div 2)]:= Hi(Blk);
            BlockRead(Inp, Buf, BlockSize, Err);
            if Err <> BlockSize then begin
              FillChar(Buf[Err],BlockSize-Err,0);
            end;
            WriteBlock(Blk, Buf);
          end;
          Move(Buf, Ent, 512);
          WriteBlock(PosBlk, Buf);
        end;
        3: begin
          FillChar(Ent, SizeOf(Ent1), 0);
          Pos:= 999; j:= 0; NewBlk:= 0;
          for i:= 1 to (Siz+(BlockSize-1)) div BlockSize do begin
            if Pos > 256 then begin
              Move(Ent, Buf, 512);
              if NewBlk <> 0 then WriteBlock(NewBlk, Buf);
              Pos:= 1;
              Inc(j);
              NewBlk:= VBM.GetFreeBlock;
              VBM.MarkBlock(NewBlk, false);
              Ent1[j]:= Lo(NewBlk);
              Ent1[j+(BlockSize div 2)]:= Hi(NewBlk);
              FillChar(Ent, SizeOf(Ent), 0);
            end;
            Blk:= VBM.GetFreeBlock;
            VBM.MarkBlock(Blk, false);
            Ent[Pos]:= Lo(Blk);
            Ent[Pos+(BlockSize div 2)]:= Hi(Blk);
            BlockRead(Inp, Buf, BlockSize, Err);
            if Err <> BlockSize then begin
              FillChar(Buf[Err],BlockSize-Err,0);
            end;
            WriteBlock(Blk, Buf);
            Inc(Pos);
          end;
          Move(Buf, Ent, 512);
          WriteBlock(NewBlk, Buf);
          Move(Buf, Ent1, 512);
          WriteBlock(PosBlk, Buf);
        end;
        else raise EFSFileError.Create('');
      end;
    end;
    System.Close(Inp);
  end;
end;

procedure TProDosDirectory.ImportFiles;
var
  DirInfo: TSearchRec;
  DosError: integer;
begin
  DosError:= SysUtils.FindFirst('*.*', faAnyFile and (not (faSysFile or faDirectory or faVolumeID)), DirInfo);
  while DosError = 0 do begin
    with DirInfo do begin
      ImportFile(Name);
    end;
    SysUtils.FindNext(DirInfo);
  end;
  SysUtils.FindClose(DirInfo);
  TProDosVolume(Volume).VBM.Write;
end;

function  TProDosFile.GetFileSize: longint;
begin
  raise EFSError.Create('N/A')
end;

procedure TProDosFile.Open;
begin
  raise EFSError.Create('N/A')
end;

procedure TProDosFile.Rename(const NewName: string);
begin
  raise EFSError.Create('N/A')
end;

procedure TProDosFile.Delete;
begin
  raise EFSError.Create('N/A')
end;

procedure TProDosFile.Read (var Buf; Size: integer);
begin
  raise EFSError.Create('N/A')
end;

procedure TProDosFile.Write(var Buf; Size: integer);
begin
  raise EFSError.Create('N/A')
end;

procedure TProDosFile.Truncate;
begin
  raise EFSError.Create('N/A')
end;

procedure TProDosFile.Close;
begin
  raise EFSError.Create('N/A')
end;

function TProDosFile.GetName: string;
begin
  Result:= ProDos.GetName(@FFileInfo);
end;

end.

