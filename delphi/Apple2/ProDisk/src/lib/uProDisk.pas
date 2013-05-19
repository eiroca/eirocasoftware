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
unit uProDisk;

interface

procedure Main;

implementation

uses
  SysUtils, uProDos;

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
  NumCmds = 15;

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
  cmExpF =  8;
  cmExpD =  9;
  cmImpo = 10;

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
    (Tokn: cmExpF; Name: 'export';  Parm: '$p $m'),
    (Tokn: cmExpD; Name: 'exportdir'; Parm: '$m'),
    (Tokn: cmImpo; Name: 'import';  Parm: '$m*.*')
  );

function GetToken(var CmdStr: string): integer;
var
  i, len: integer;
begin
  Result:= cmNone;
  if CmdStr = '' then exit;
  CmdStr:= LowerCase(CmdStr);
  for i:= 1 to NumCmds do begin
    if CmdStr = Cmds[i].Name then begin
      Result:= Cmds[i].Tokn;
      break;
    end;
  end;
  if Result = cmNone then begin
    len:= Length(CmdStr);
    for i:= 1 to NumCmds do begin
      if CmdStr = Copy(Cmds[i].Name,1,len) then begin
        Result:= Cmds[i].Tokn;
        break;
      end;
    end;
  end;
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
begin
  SplitStr(prm, tmp, New);
  prm:= New;
  if tmp <> '' then begin
    case opr of
      DoUpCase: tmp:= UpperCase(tmp);
      DoLoCase: tmp:= LowerCase(tmp);
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
  var i: integer;
  begin
    for i:= 1 to NumCmds do begin
      with Cmds[i] do Writeln(Name,' ',Parm);
    end;
    Writeln;
    Writeln('$p = Prodos filename, $m = MsDos filename');
    Writeln;
  end;
  procedure DoOpen;
  var
    FN: PathStr;
  begin
    FN:= GetParm(prm, DoUpCase);
    if FN = '' then begin
      Write('Prodos Disk file = '); Readln(FN);
    end;
    if not FileExists(FN) then FN:= ChangeFileExt(FN, '.hdv');
    if not FileExists(FN) then begin
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
  var
    FN: PathStr;
  begin
    FN:= GetParm(prm, DoUpCase);
    if (FN='') then begin
      Write('Which file? ');
      Readln(FN);
    end;
    FN:= ExpandFileName(FN);
    if (DirectoryExists(FN)) then begin
      FN:= FN+'\*.*';
    end;
    ImportFiles(Disk, FN);
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

procedure Main;
var
  Raw, Cmd, prm: string;
  Tokn: integer;
begin
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
end;

end.

