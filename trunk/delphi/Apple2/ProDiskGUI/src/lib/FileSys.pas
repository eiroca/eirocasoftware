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
unit FileSys;

interface

uses
  SysUtils;

type
  EFSError        = class(exception);

  EFSIOError      = class(EFSError);
  EFSIOReadError  = class(EFSIOError);
  EFSIOWriteError = class(EFSIOError);

  EFSFileError    = class(EFSError);
  EFSDirError     = class(EFSError);
  EFSVolError     = class(EFSError);

type
  TSeekMode = (smBegin, smCurrent, smEnd);


  TFSFile = class;
  TFSDirectory = class;
  TFSVolume = class;

  TFSEntry = class
    protected
     FVolume: TFSVolume;
    public
     property  Volume: TFSVolume read FVolume;
    protected
     function  GetName: string; virtual; abstract;
    public
     property Name: string read GetName;
     procedure Rename(const NewName: string); virtual; abstract;
     procedure Delete; virtual; abstract;
  end;

  TFSFile = class(TFSEntry)
    private
     FCurPos   : longint;
     FActive   : boolean;
     FDirectory: TFSDirectory;
    protected
     procedure SetFilePosition(APos: longint); virtual;
     procedure SetActive(NewActive: boolean);
     function  GetFileSize: longint; virtual; abstract;
    public
     property  Directory: TFSDirectory read FDirectory;
     property  Active: boolean read FActive write SetActive;
     property  FilePosition: longint read FCurPos write SetFilePosition;
     property  FileSize    : longint read GetFileSize;
    public
     constructor Create(ADirectory: TFSDirectory);
     procedure Open; virtual; abstract;
     procedure Seek (SeekMode: TSeekMode; Delta: longint); virtual;
     procedure Read (var Buf; Size: integer); virtual; abstract;
     procedure Write(var Buf; Size: integer); virtual; abstract;
     procedure Truncate; virtual; abstract;
     procedure Close; virtual; abstract;
  end;

  TFSDirectory = class(TFSEntry)
    public
     function  FindFirst(var SearchRec: TObject): TFSEntry; virtual; abstract;
     function  FindNext (var SearchRec: TObject): TFSEntry; virtual; abstract;
     procedure FindClose(var SearchRec: TObject); virtual; abstract;
    public
     constructor Create(AVolume: TFSVolume);
     procedure   CdUp; virtual; abstract;
     procedure   MkDir(const DirName: string); virtual; abstract;
     procedure   CdDir(const DirName: string); virtual; abstract;
     function    NewFile(const FileName: string): TFSFile; virtual; abstract;
  end;

  TFSVolume = class
    private
     FFileName: string;
     FActive  : boolean;
    protected
     procedure SetActive(NewActive: boolean);
     procedure SetFileName(const vl: string);
    public
     property Active  : boolean read FActive write SetActive;
     property FileName: string read FFileName write SetFileName;
    public
     (* disk functions *)
     procedure Open;  virtual; abstract;
     function  GetRoot: TFSDirectory; virtual;
     procedure Close; virtual; abstract;
     procedure CheckActive(AnActiveState: boolean);
  end;

implementation

constructor TFSFile.Create(ADirectory: TFSDirectory);
begin
  FDirectory:= ADirectory;
end;

procedure TFSFile.SetFilePosition(APos: longint);
begin
  FCurPos:= APos;
end;

procedure TFSFile.SetActive(NewActive: boolean);
begin
  if not Active and NewActive then Open
  else if not NewActive and Active then Close;
end;

procedure TFSFile.Seek (SeekMode: TSeekMode; Delta: longint);
begin
  case SeekMode of
    smBegin  : FilePosition:= Delta;
    smCurrent: FilePosition:= FilePosition + Delta;
    smEnd    : FilePosition:= FileSize - Delta;
  end;
end;

constructor TFSDirectory.Create(AVolume: TFSVolume);
begin
  FVolume:= AVolume;
end;

procedure TFSVolume.CheckActive(AnActiveState: boolean);
begin
  if Active<>AnActiveState then begin
    raise EFSError.Create('Volume is not ready');
  end;
end;

procedure TFSVolume.SetActive(NewActive: boolean);
begin
  if NewActive and not Active then Open;
  if Active and not NewActive then Close;
  FActive:= NewActive;
end;

procedure TFSVolume.SetFileName(const vl: string);
begin
  CheckActive(false);
  FFileName:= vl;
end;

function TFSVolume.GetRoot: TFSDirectory;
begin
  Result:= nil;
end;

end.

