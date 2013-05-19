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
unit ProDos;

interface

type
  PProDosDate = ^TProDosDate;
  TProDosDate   = packed array[0..1] of word;

  PProDosChain = ^TProDosChain;
  TProDosChain = packed record
    PrvBlk: word;
    NxtBlk: word;
  end;

  PProDosName = ^TProDosName;
  TProDosName = packed array[1..15] of AnsiChar;

  PProDosItem = ^TProDosItem;
  TProDosItem = packed record
    KndLen: byte;
    Name  : TProDosName;
    UnUsed: packed array[0..22] of byte;
  end;

  PProDosVolItem = ^TProDosVolItem;
  TProDosVolItem = packed record
    KndLen  : byte;
    VolName : TProDosName;
    UnUsed  : packed array[0..7] of byte;
    CreaDate: TProDosDate;
    VerPro  : byte;
    MinPro  : byte;
    Access  : byte;
    ItmLen  : byte;
    ItmInBlk: byte;
    NumItem : word;
    VBMBlk  : word;
    NumBlk  : word;
  end;

  PProDosDirItem = ^TProDosDirItem;
  TProDosDirItem = packed record
    KndLen  : byte;
    SubName : TProDosName;
    UnUsed  : packed array[0..7] of byte;
    CreaDate: TProDosDate;
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

  PProDosFileItem = ^TProDosFileItem;
  TProDosFileItem = packed record
    KndLen  : byte;
    FileName: TProDosName;
    Kind    : byte;
    PosBlk  : word;
    SizBlk  : word;
    Size    : packed array[0..2] of byte;
    CreaDate: TProDosDate;
    VerPro  : byte;
    MinPro  : byte;
    Access  : byte;
    AuxBit  : word;
    ModiDate: TProDosDate;
    NumBlk  : word;
  end;

const
  af_Delete = 128;
  af_Rename =  64;
  af_Modify =  32;
  af_Write  =   2;
  af_Read   =   1;

const
  ProDosExt: array[0..255] of string[3] = (
    '$$$', 'BAD', '$02', '$03', 'TXT', '$05', 'BIN', '$07',
    '$08', '$09', '$0A', '$0B', '$0C', '$0D', '$0E', 'DIR',
    '$10', '$11', '$12', '$13', '$14', '$15', '$16', '$17',
    '$18', 'ADB', 'AWP', 'ASP', '$1C', '$1D', '$1E', '$1F',
    '$20', '$21', '$22', '$23', '$24', '$25', '$26', '$27',
    '$28', '$29', '$2A', '$2B', '$2C', '$2D', '$2E', '$2F',
    '$30', '$31', '$32', '$33', '$34', '$35', '$36', '$37',
    '$38', '$39', '$3A', '$3B', '$3C', '$3D', '$3E', '$3F',
    '$40', '$41', '$42', '$43', '$44', '$45', '$46', '$47',
    '$48', '$49', '$4A', '$4B', '$4C', '$4D', '$4E', '$4F',
    '$50', '$51', '$52', '$53', '$54', '$55', '$56', '$57',
    '$58', '$59', '$5A', '$5B', '$5C', '$5D', '$5E', '$5F',
    '$60', '$61', '$62', '$63', '$64', '$65', '$66', '$67',
    '$68', '$69', '$6A', '$6B', '$6C', '$6D', '$6E', '$6F',
    '$70', '$71', '$72', '$73', '$74', '$75', '$76', '$77',
    '$78', '$79', '$7A', '$7B', '$7C', '$7D', '$7E', '$7F',
    '$80', '$81', '$82', '$83', '$84', '$85', '$86', '$87',
    '$88', '$89', '$8A', '$8B', '$8C', '$8D', '$8E', '$8F',
    '$90', '$91', '$92', '$93', '$94', '$95', '$96', '$97',
    '$98', '$99', '$9A', '$9B', '$9C', '$9D', '$9E', '$9F',
    '$A0', '$A1', '$A2', '$A3', '$A4', '$A5', '$A6', '$A7',
    '$A8', '$A9', '$AA', '$AB', '$AC', '$AD', '$AE', '$AF',
    '$B0', '$B1', '$B2', '$B3', '$B4', '$B5', '$B6', '$B7',
    '$B8', '$B9', '$BA', '$BB', '$BC', '$BD', '$BE', '$BF',
    '$C0', '$C1', '$C2', '$C3', '$C4', '$C5', '$C6', '$C7',
    '$C8', '$C9', '$CA', '$CB', '$CC', '$CD', '$CE', '$CF',
    '$D0', '$D1', '$D2', '$D3', '$D4', '$D5', '$D6', '$D7',
    '$D8', '$D9', '$DA', '$DB', '$DC', '$DD', '$DE', '$DF',
    'SHK', '$E1', '$E2', '$E3', '$E4', '$E5', '$E6', '$E7',
    '$E8', '$E9', '$EA', '$EB', '$EC', '$ED', '$EE', 'PAS',
    'CMD', '$F1', '$F2', '$F3', '$F4', '$F5', '$F6', '$F7',
    '$F8', '$F9', 'INT', 'IVR', 'BAS', 'VAR', 'REL', 'SYS');

function  GetName(Itm: PProDosItem): string;
procedure SetName(Itm: PProDosItem; aName: string);

function Ext2Knd(Ext: string): byte;
function Knd2Ext(Kind: byte): string;

function  MsDosName(Itm: PProDosFileItem): string;

implementation

uses
  SysUtils;

function GetName(Itm: PProDosItem): string;
var
  Len: integer;
begin
  with Itm^ do begin
    Len:= KndLen and $0F;
    SetLength(Result, Len);
    Move(Name, Result[1], Len);
  end;
end;

procedure SetName(Itm: PProDosItem; aName: string);
var
  Len: integer;
begin
  Len:= length(aName);
  if Len > 15 then Len:= 15;
  with Itm^ do begin
    KndLen:= (KndLen and $F0) or Len;
    FillChar(Name, SizeOf(Name), ' ');
    Move(aName[1], Name, Len);
  end;
end;

function Ext2Knd(Ext: string): byte;
var
  i: integer;
begin
  Result:= $06; (* dafault Binary *)
  if Ext <> '' then begin
    if Ext[1] = '.' then Delete(Ext,1,1);
    for i:= 1 to length(Ext) do Ext[i]:= UpCase(Ext[i]);
    for i:= 0 to 255 do if ProDosExt[i] = Ext then begin
      Result:= i;
      break;
    end;
  end;
end;

function Knd2Ext(Kind: byte): string;
begin
  Result:= ProDosExt[Kind];
end;

function MsDosName(Itm: PProDosFileItem): string;
var
  tmp: string;
  ps: integer;
  Len: integer;
begin
  with Itm^ do begin
    Len:= KndLen and $0F;
    SetLength(Result, Len);
    Move(FileName, Result[1], Len);
    for ps:= 1 to Length(Result) do if Result[ps]='.' then Delete(Result,ps,1);
    if Length(Result)>8 then SetLength(Result, 8);
    tmp:= Result+'.'+Knd2Ext(Itm^.Kind);
    if FileExists(tmp) then begin
      ps:= Length(Result)+1; if ps > 8 then ps:= 8;
      SetLength(Result, ps);
      Result[ps]:= '0';
      tmp:= Result+'.'+Knd2Ext(Kind);
      while FileExists(tmp) do Inc(tmp[ps]);
    end;
  end;
  Result:= tmp;
end;

end.

