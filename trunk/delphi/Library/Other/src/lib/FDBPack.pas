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
unit FDBPack;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, eBDE, ExtCtrls, DBTables, JvExControls, JvLabel;

type
  MakeProcedure = procedure (dbDatabase: TDatabase);

type
  TfmDBPack = class(TForm)
    RxLabel1: TJvLabel;
    Timer: TTimer;
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure PackDB;
  public
    { Public declarations }
    DB: TeDataBase;
    Pack: boolean;
    Ok: boolean;
    make: MakeProcedure;
  end;

function PackDataBase(make: MakeProcedure; aDB: TeDataBase): boolean;
function ConnectDataBase(make: MakeProcedure; aDB: TeDataBase; const Path, DBSign: string; OnMakeDB: TNotifyEvent): boolean;

implementation

{$R *.DFM}

uses
  eLibCore;

procedure MakeDir(Dir: string);
var
  cd, ds, mk: string;
  i: integer;
begin
  GetDir(0, cd);
  for i:= 1 to length(Dir) do if Dir[i] ='/' then Dir[i]:= '\';
  if Dir[length(Dir)] <> '\' then Dir:= Dir+'\';
  ds:= ExtractFilePath(Dir);
  {$I-} ChDir(ds); {$I+}
  if IOResult <> 0 then begin
    if ds[2] = ':' then begin
      ChDir(copy(ds,1,2)+'\');
      delete(ds,1,2);
    end;
    repeat
      if ds[1] = '\' then delete(Ds,1,1);
      i:= pos('\', ds);
      if i = 0 then mk:= ds else mk:= copy(ds, 1, i-1);
      {$I-} ChDir(mk); {$I+}
      if IOResult <> 0 then begin
        MkDir(mk);
        ChDir(mk);
      end;
      delete(ds, 1, i);
    until (i = 0) or (ds='');
  end;
  ChDir(cd);
end;

procedure TfmDBPack.PackDB;
begin
  try
    make(DB);
    Ok:= true;
  except
    Ok:= false;
  end;
end;

procedure TfmDBPack.FormShow(Sender: TObject);
begin
  if Pack then Caption:= 'Compattazione database'
  else Caption:= 'Creazione database';
  Timer.Enabled:= true;
end;

procedure TfmDBPack.TimerTimer(Sender: TObject);
begin
  Timer.Enabled:= false;
  ModalResult:= mrOk;
end;

procedure TfmDBPack.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PackDB;
end;

function MakeDataBase(make: MakeProcedure; DB: TeDataBase; Pack: boolean): boolean;
var
  fmDBPack: TfmDBPack;
begin
  fmDBPack:= nil;
  try
    fmDBPack:= TfmDBPack.Create(nil);
    fmDBPack.DB:= DB;
    fmDBPack.Pack:= Pack;
    fmDBPack.make:= make;
    fmDBPack.ShowModal;
    Result:= fmDBPack.Ok;
  finally
    fmDBPack.Free;
  end;
end;

function PackDataBase(make: MakeProcedure; aDB: TeDataBase): boolean;
var
  WasConnected: boolean;
begin
  if aDB.Connected then begin
    WasConnected:= true;
    aDB.Disconnect;
  end
  else WasConnected:= false;
  Result:= MakeDataBase(make, aDB, true);
  if WasConnected then aDB.Reconnect;
end;

function ConnectDataBase(make: MakeProcedure; aDB: TeDataBase; const Path, DBSign: string; OnMakeDB: TNotifyEvent): boolean;
begin
  aDB.Disconnect;
  Result:= true;
  try
    if not aDB.SelectDB(Path) then begin
      aDB.Disconnect;
      MakeDir(Path);
      aDB.Params.Values['PATH']:= Path;
      Result:= MakeDataBase(make, aDB, false);
      if not Result then Abort;
      aDB.Convalidate(Path, DBSign);
      if Assigned(OnMakeDB) then OnMakeDB(aDB);
      Result:= aDB.SelectDB(Path)
    end;
  except
    on e: exception do begin
      Result:= false;
      if e is EInvalidDataBase then raise;
    end;
  end;
end;

end.

