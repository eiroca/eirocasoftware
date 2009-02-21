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
 Program: ProDisk -
 C.L.I., shows Prodos HD, does file(s) import/exeport
*)
program ProDisk;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this },
  Crt, Dos, ProDos;

var
  ExitFlag: boolean;
  Disk: TProDosDisk;
  DiskOpen: boolean;

type
  TCmd = record
    Tokn: integer;
    Name: string[10];
    Parm: string[20];
  end;

const
  NumCmds = 18;

const

  DoNothing = 0;
  DoUpCase  = 1;
  DoLoCase  = 2;

  cmNone =  0;
  cmExit =  1;
  cmHelp =  2;
  cmOpen =  3;
  cmClos =  4;
  cmDire =  5;
  cmPref =  6;
  cmStat =  7;
  cmClea =  8;
  cmExpF =  9;
  cmExpD = 10;
  cmImpo = 11;

  Cmds : array[1..NumCmds] of TCmd = (
    (Tokn: cmExit; Name: 'exit';    Parm: ''),
    (Tokn: cmExit; Name: 'quit';    Parm: ''),
    (Tokn: cmHelp; Name: 'help';    Parm: ''),
    (Tokn: cmOpen; Name: 'open';    Parm: '$m'),
    (Tokn: cmClos; Name: 'close';   Parm: ''),
    (Tokn: cmDire; Name: 'dir';     Parm: '-l'),
    (Tokn: cmDire; Name: 'cat';     Parm: '-l'),
    (Tokn: cmDire; Name: 'ls';      Parm: '-l'),
    (Tokn: cmDire; Name: 'catalog'; Parm: '-l'),
    (Tokn: cmPref; Name: 'cd';      Parm: '[$p|..|/]'),
    (Tokn: cmPref; Name: 'prefix';  Parm: '$p'),
    (Tokn: cmStat; Name: 'stat';    Parm: ''),
    (Tokn: cmClea; Name: 'clrscr';  Parm: ''),
    (Tokn: cmClea; Name: 'cls';     Parm: ''),
    (Tokn: cmClea; Name: 'home';    Parm: ''),
    (Tokn: cmExpF; Name: 'export';  Parm: '$p $m'),
    (Tokn: cmExpD; Name: 'exportdir'; Parm: '$m'),
    (Tokn: cmImpo; Name: 'import';  Parm: '$m*.*')
  );

function ForceExt(tmp: PathStr; Exte: ExtStr): PathStr;
var
  Dir: DirStr;
  Nam: NameStr;
  Ext: ExtStr;
begin
  FSplit(tmp, Dir, Nam, Ext);
  if Ext='' then Ext:=Exte;
  ForceExt:= Dir+Nam+Ext;
end;


procedure LoCase(var ch: char);
begin
  if ch in ['A'..'Z'] then ch:= Chr(ord(ch)+32);
end;

function GetToken(var CmdStr: string): integer;
var
  tkn, i, len: integer;
begin
  for i:= 1 to Length(CmdStr) do LoCase(CmdStr[i]);
  tkn:= cmNone;
  if CmdStr = '' then exit;
  for i:= 1 to NumCmds do begin
    if CmdStr = Cmds[i].Name then begin
      tkn:= Cmds[i].Tokn;
      break;
    end;
  end;
  if tkn = cmNone then begin
    len:= Length(CmdStr);
    for i:= 1 to NumCmds do begin
      if CmdStr = Copy(Cmds[i].Name,1,len) then begin
        tkn:= Cmds[i].Tokn;
        break;
      end;
    end;
  end;
  GetToken:= tkn;
end;

procedure Trim(var str: string);
var
  l: integer;
begin
  l:= Length(str);
  while (l>0) and (str[l]=' ') do begin
    dec(l);
    SetLength(str,l);
  end;
  while (l>0) and (str[1]=' ') do Delete(str,1,1);
end;

procedure SplitStr(var Raw, Cmd, prm: string);
var i: integer;
begin
  Trim(Raw);
  i:= Pos(' ', Raw);
  if i = 0 then begin
    Cmd:= Raw; prm:= '';
  end
  else begin
    Cmd:= Copy(Raw, 1, i-1);
    prm:= Copy(Raw, i+1,255);
    Trim(prm);
  end;
end;

function GetParm(var prm: string; opr: integer): string;
var
  tmp, New: string;
  i: integer;
begin
  SplitStr(prm, tmp, New);
  prm:= New;
  if tmp <> '' then begin
    case opr of
      DoUpCase: for i:= 1 to Length(tmp) do tmp[i]:= UpCase(tmp[i]);
      DoLoCase: for i:= 1 to Length(tmp) do LoCase(tmp[i]);
    end;
  end;
  GetParm:= tmp;
end;

procedure Error(msg: string);
begin
  Writeln('Error: ', msg);
  Writeln;
end;

procedure Execute(Tokn: integer; var Cmd, prm: string);
  procedure DoHelp;
  var i, j: integer;
  begin
    for i:= 1 to NumCmds div 4 do begin
      for j:= 1 to 4 do begin
        GotoXY((j-1)*20+1, WhereY);
        with Cmds[4*(i-1)+j] do Write(Name,' ',Parm);
      end;
      Writeln;
    end;
    i:= (NumCmds mod 4);
    if i > 0 then begin
      for j:= 1 to i do begin
        GotoXY((j-1)*20+1, WhereY);
        with Cmds[(NumCmds div 4)*4+j] do Write(Name,' ',Parm);
      end;
      Writeln;
    end;
    Writeln('$p = Prodos filename, $m = MsDos filename');
    Writeln;
  end;
  procedure DoOpen;
  var
    FN: PathStr;
  begin
    FN:= ForceExt(GetParm(prm, DoNothing),'.hdv');
    if FN = '' then begin
      Write('Prodos Disk file = '); Readln(FN);
    end;
    if not FileExist(FN) then begin
      Error('file do not exit.');
      exit;
    end;
    OpenDisk(Disk, FN);
    OpenDir(Disk, Disk.VolBlk);
    Writeln;
    PrintVolItem(@Disk.Vol, false);
    Writeln;
    DiskOpen:= true;
  end;
  procedure DoClose;
  begin
    CloseDisk(Disk);
    Writeln(Disk.FilNam,' closed.');
    Writeln;
    DiskOpen:= false;
  end;
  procedure DoDir;
  begin
    Writeln;
    if prm <> '' then PrintDir(Disk, true) else PrintDir(Disk, false);
    Writeln;
  end;
  procedure DoPrefix;
  var
    Name: TNameStr;
    Item: TFileItem;
  begin
    Name:= GetParm(prm, DoUpCase);
    with Disk do begin
      if Name = '' then begin
        PrintSubItem(@Dir, false);
      end
      else if Name ='/' then begin
        while (Disk.Dir.KndLen and $F0) <> $F0 do CloseDir(Disk);
        exit;
      end
      else if Name = '..' then begin
        if (DirBlk = VolBlk) then begin
          Error('Root level!');
          exit;
        end
        else begin
          CloseDir(Disk);
        end;
      end
      else if GetFileName(Disk, Name, Item) then begin
        if (Item.KndLen and $F0) = $D0 then begin
          OpenDir(Disk, Item.PosBlk);
        end
        else Error('Not a directory!')
      end
      else Error('Directory not found');
    end;
  end;
  procedure DoStat;
  begin
    with Disk,VBM^ do begin
      Writeln;
      Writeln('VBM Pos. : ', Strt);
      Writeln('VBM Size : ', Size);
      Writeln('Num Block: ', NumBlk);
      Writeln('FreeBlock: ', BlkFree);
      Writeln('UsedBlock: ', NumBlk-BlkFree);
      Writeln('Changed  : ', Changed);
      Writeln;
    end;
  end;
  procedure DoClear;
  begin
    ClrScr;
  end;
  procedure DoExportFile;
  var
    Name: TNameStr;
    tmp: PathStr;
    Item: TFileItem;
  begin
    Name:= GetParm(prm, DoUpCase);
    if GetFileName(Disk, Name, Item) then begin
      tmp := GetParm(prm, DoNothing);
      if tmp = '' then tmp:= MsDosName(Name, Item.Kind);
      ExportFile(Disk, Item, tmp);
    end
    else Error('File not found');
  end;
  procedure DoExportDir;
  begin
    ExportDir(Disk);
  end;
  procedure DoImportFiles;
  begin
    ImportFiles(Disk);
  end;
var
  Name: TNameStr;
  Item: TFileItem;
begin
  case Tokn of
    cmExit: begin
      if DiskOpen then DoClose;
      ExitFlag:= true;
    end;
    cmHelp: DoHelp;
    cmOpen: if DiskOpen then Error('disk open. Close it!') else DoOpen;
    cmClos: if not DiskOpen then Error('disk not open!') else DoClose;
    cmDire: if not DiskOpen then Error('disk not open!') else DoDir;
    cmPref: if not DiskOpen then Error('disk not open!') else DoPrefix;
    cmStat: if not DiskOpen then Error('disk not open!') else DoStat;
    cmExpF: if not DiskOpen then Error('disk not open!') else DoExportFile;
    cmExpD: if not DiskOpen then Error('disk not open!') else DoExportDir;
    cmImpo: if not DiskOpen then Error('disk not open!') else DoImportFiles;
    cmClea: DoClear;
    else begin
      if DiskOpen then begin
        prm:= Cmd+prm;
        Name:= GetParm(prm, DoUpCase);
        if GetFileName(Disk, Name, Item) then begin
          if (Item.KndLen and $F0) = $D0 then begin
            prm:= Name+' '+prm;
            DoPrefix;
          end
          else if (Item.KndLen and $30) <> 0 then begin
            prm:= Name+ ' '+prm;
            DoExportFile;
          end;
        end
        else Error('Unknown command.');
      end
      else Error('Unknown command.');
    end;
  end;
end;

var
  Raw, Cmd, prm: string;
  Tokn: integer;
begin
  ClrScr;
  Writeln('Prodos disk mini command line interpeter v1.0. Type help for help.');
  Writeln;
  ExitFlag:= false;
  DiskOpen:= false;
  if ParamCount >= 1 then begin
    Cmd:= 'open';
    prm:= ParamStr(1);
    Execute(cmOpen, Cmd, prm);
  end;
  repeat
    Write('Command: '); Readln(Raw);
    SplitStr(Raw, Cmd, prm);
    Tokn:= GetToken(Cmd);
    Execute(Tokn, Cmd, prm);
  until ExitFlag;
end.

