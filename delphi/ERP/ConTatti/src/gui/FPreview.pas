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
unit FPreview;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, MPlayer;

{$DEFINE TIMAGE}
{$DEFINE TMEMO}

type
  TfmPreview = class(TForm)
    sbMain: TScrollBox;
    pnMP: TPanel;
    MP: TMediaPlayer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure ShowFile;
    procedure CreateLabel(const Msg: string);
    procedure ShowImage(const aFile: string);
    procedure ShowMemo (const aFile: string);
    procedure ShowMP   (const aFile: string; Win: boolean);
    procedure SetSize(C: TControl);
  public
    { Public declarations }
    FileName: string;
  end;

procedure Preview(const aFile: string);

implementation

{$R *.DFM}

uses
  eLibCore;

const
  MoreWidth  =  60;
  MoreHeight =  45;

procedure Preview(const aFile: string);
var
  fmPreview: TfmPreview;
begin
  fmPreview:= TfmPreview.Create(Application);
  fmPreview.FileName:= aFile;
  fmPreview.Show;
end;

procedure TfmPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

function GetFileSize(const aFile: string): longint;
var
  F: file;
begin
  Assign(f, aFile);
  Reset(f);
  Result:= FileSize(f);
  CloseFile(f);
end;

procedure TfmPreview.FormShow(Sender: TObject);
begin
   Caption:= Format('Anteprima di %s', [FileName]);
   pnMP.Visible:= false;
   ShowFile;
end;

procedure TfmPreview.ShowFile;
var
  ext: string;
begin
  if FileExists(FileName) then begin
    ext:= lowercase(ExtractFileExt(FileName));
    try
           if (ext = '.bmp') then ShowImage(FileName)
      else if (ext = '.ico') then ShowImage(FileName)
      else if (ext = '.wmf') then ShowImage(FileName)
      else if (ext = '.wav') then ShowMP(FileName, false)
      else if (ext = '.avi') then ShowMP(FileName, true)
      else if (ext = '.txt') and (GetFileSize(FileName) < 32768) then ShowMemo(FileName)
      else CreateLabel('File non riconosciuto');
    except
      CreateLabel('Impossibile mostrare il file');
    end;
  end
  else begin
    CreateLabel('File non trovato');
  end;
end;

procedure TfmPreview.SetSize(C: TControl);
var
  W, H: integer;
const
  RisX = 120;
  RisY = 90;
begin
  W:= C.Width  + GetSystemMetrics(SM_CXFRAME)*2;
  H:= C.Height + GetSystemMetrics(SM_CYFRAME)*2+GetSystemMetrics(SM_CYCAPTION);
  if W > Screen.Width-RisX then W:= Screen.Width-RisX;
  if H > Screen.Height-RisY then H:= Screen.Height-RisY;
  Width:= W;
  Height:= H;
end;

procedure TfmPreview.CreateLabel(const Msg: string);
var
  lb: TLabel;
begin
  lb:= TLabel.Create(Self);
  lb.Caption:= Msg;
  lb.Font.Name:= 'Times New Roman';
  lb.Font.Size:= 20;
  sbMain.InsertControl(lb);
  SetSize(lb);
end;

procedure TfmPreview.ShowImage(const aFile: string);
{$IFDEF TIMAGE}
var
  Im: TImage;
begin
  Im:= TImage.Create(Self);
  Im.AutoSize:= true;
  Im.Picture.LoadFromFile(aFile);
  sbMain.InsertControl(Im);
  SetSize(Im);
end;
{$ELSE}
begin
end;
{$ENDIF}

procedure TfmPreview.ShowMemo(const aFile: string);
{$IFDEF TMEMO}
var
  Me: TMemo;
begin
  Me:= TMemo.Create(Self);
  Me.Width:= 400;
  Me.Height:= 300;
  Me.WordWrap:= false;
  Me.ScrollBars:= ssBoth;
  Me.Lines.LoadFromFile(aFile);
  sbMain.InsertControl(Me);
  SetSize(Me);
end;
{$ELSE}
begin
end;
{$ENDIF}

procedure TfmPreview.ShowMP(const aFile: string; Win: boolean);
begin
  SetSize(MP);
  pnMP.Visible:= true;
  MP.FileName:= aFile;
  MP.Open;
  MP.Play;
end;

end.

