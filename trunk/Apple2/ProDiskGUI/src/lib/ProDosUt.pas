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
unit ProDosUt;

interface

uses
  Prodos, ProDosFS;

type
  TNameStr = string[15];
  TExtStr  = string[3];

procedure PrintVolItem(Item: PProDosVolItem; Ext: boolean);
procedure PrintSubItem(Item: PProDosDirItem; Ext: boolean);
procedure PrintFileItem(Item: PProDosFileItem; Ext: boolean);
procedure PrintSubFileItem(Item: PProDosFileItem; Ext: boolean);

implementation

uses
  SysUtils;

const
  HexStr: array[0..15] of char = '0123456789ABCDEF';


(* General printing/coversion functions *)
function Print2(a: word): string;
begin
 if a<10 then Write('0',a) else Write(a);
 Print2:= '';
end;

function PrintHex4(wr: word): string;
var tmp: string;
begin
  tmp:= HexStr[(wr shr 12) and $F]
       +HexStr[(wr shr  8) and $F]
       +HexStr[(wr shr  4) and $F]
       +HexStr[(wr       ) and $F];
  PrintHex4:= tmp;
end;

function PrintAccess(Access: byte): string;
begin
  if (Access and af_Delete) <> 0 then Write('+d') else Write('-d');
  if (Access and af_Rename) <> 0 then Write('+n') else Write('-n');
  if (Access and af_Modify) <> 0 then Write('+a') else Write('-a');
  if (Access and af_Write ) <> 0 then Write('+w') else Write('-w');
  if (Access and af_Read  ) <> 0 then Write('+r') else Write('-r');
  PrintAccess:= '';
end;

function PrintDate(Date: TProDosDate): string;
begin
  if (Date[0] = 0) and (Date[1] = 0) then begin
    Write('<NO DATE>        ');
  end
  else begin
    Write(Print2(Date[0] and $1F),'-',Print2((Date[0] shr 5) and $0F), '-',1900+Date[0] shr 9,' ');
    Write(Print2(Date[1] shr 8),':',Print2(Date[1] and $FF),' ');
  end;
  PrintDate:= '';
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

procedure PrintVolItem(Item: PProDosVolItem; Ext: boolean);
var Name: TExtStr;
begin
  with Item^ do begin
    Name:= GetName(PProDosItem(Item));
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
    end
    else begin
      Writeln('/',Name, ' Access:', PrintAccess(Access));
    end;
  end
end;

procedure PrintSubItem(Item: PProDosDirItem; Ext: boolean);
var Name: TExtStr;
begin
  with Item^ do begin
    Name:= GetName(PProDosItem(Item));
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
    end
    else begin
      Writeln('../',Name, ' Access:', PrintAccess(Access));
    end;
  end;
end;

procedure PrintFileItem(Item: PProDosFileItem; Ext: boolean);
var
  Name: TExtStr;
  Siz : longint;
begin
  with Item^ do begin
    Name:= GetName(PProDosItem(Item));
    Siz:= (longint(Size[2])*256+Size[1])*256+Size[0];
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
      Writeln('Aux. Bits    : $', PrintHex4(AuxBit));
      Writeln('Num. Block   : ', NumBlk);
    end
    else begin
      if (KndLen and $F0) = 0 then exit;
      if (Access and 2) = 0 then Write('*') else Write(' ');
      Writeln(Name,' ',Knd2Ext(Kind),SizBlk:5,' ',PrintDate(ModiDate),' ',
        PrintDate(CreaDate),' ',Siz:8,' $',PrintHex4(AuxBit));
    end;
  end;
end;

procedure PrintSubFileItem(Item: PProDosFileItem; Ext: boolean);
var
  Name: TExtStr;
  Siz : longint;
begin
  with Item^ do begin
    Name:= GetName(PProDosItem(Item));
    Siz:= (longint(Size[2])*256+Size[1])*256+Size[0];
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
      Writeln('Aux. Bits    : $', PrintHex4(AuxBit));
      Writeln('Num. Block   : ', NumBlk);
    end
    else begin
      if (KndLen and $F0) = 0 then exit;
      if (Access and 2) = 0 then Write('*') else Write(' ');
      Writeln(Name,' ',Knd2Ext(Kind),SizBlk:5,' ',PrintDate(ModiDate),' ',
        PrintDate(CreaDate), PrintAccess(Access));
    end;
  end;
end;

procedure PrintDir(Dir: TProDosDirectory; Ext: boolean);
var
  Buf: TBlock;
  Lnk: PProDosChain;
  Itm: pointer;
  Pos: word;
  i: word;
begin
  Pos:= 4;
  with Dir, TProDosVolume(Dir.Volume) do begin
    Lnk:= @Buf;
    ReadBlock(DirBlk, Buf);
    i:= 0;
    repeat
      Inc(i);
      if Pos >= (BlockSize-1) then begin
        Pos:= 4;
        ReadBlock(Lnk^.NxtBlk, Buf);
      end;
      Itm:= @Buf[Pos];
      case (PProDosItem(Itm)^.KndLen and $F0) shr 4 of
        $0F: PrintVolItem(Itm, Ext);
        $0E: PrintSubItem(Itm, Ext);
        $0D: PrintSubFileItem(Itm, Ext);
        1..3: PrintFileItem(Itm, Ext);
        0: begin
          PrintFileItem(Itm, Ext);
          Dec(i);
        end;
      end;
      Inc(Pos, Info.ItmLen);
    until i>Info.NumItem;
  end;
end;

end.

