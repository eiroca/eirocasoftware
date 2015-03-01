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
unit FMain;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    miMutui: TMenuItem;
    miMutuiExit: TMenuItem;
    N1: TMenuItem;
    miMutuiNew: TMenuItem;
    miMutuiSave: TMenuItem;
    miMutuiLoad: TMenuItem;
    odMutuo: TOpenDialog;
    sdMutuo: TSaveDialog;
    Cascade1: TMenuItem;
    Aiuto1: TMenuItem;
    About1: TMenuItem;
    N2: TMenuItem;
    Disponi1: TMenuItem;
    Affiancati1: TMenuItem;
    procedure miMutuiNewClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Cascade1Click(Sender: TObject);
    procedure miMutuiExitClick(Sender: TObject);
    procedure miMutuiLoadClick(Sender: TObject);
    procedure miMutuiSaveClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Affiancati1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

uses
  System.UITypes,
  eLibVCL,
  uMortgage, FNewMutuo, FViewMutuo;

procedure TfmMain.miMutuiNewClick(Sender: TObject);
var
  M: TMortgage;
  fm: TfmViewMutuo;
begin
  M:= NewMutuo;
  if M <> nil then begin
    fm:= TfmViewMutuo.Create(Self);
    fm.M:= M;
  end;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  miMutuiSave.Enabled:= false;
end;

procedure TfmMain.Affiancati1Click(Sender: TObject);
begin
  Tile;
end;

procedure TfmMain.Cascade1Click(Sender: TObject);
begin
  Cascade;
end;

procedure TfmMain.miMutuiExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.miMutuiLoadClick(Sender: TObject);
var
  M: TMortgage;
  fm: TfmViewMutuo;
  Ok: boolean;
  f: textfile;
begin
  if odMutuo.Execute then begin
    M:= nil;
    Ok:= false;
    try
      M:= TMortgage.Create(10000000.0, 0.05, 10, 1);
      AssignFile(f, odMutuo.FileName);
      Reset(f);
      try
        M.Load(f);
        Ok:= true;
      except
        MessageDlg('Impossibile caricare i dati', mtError, [mbOk], 0);
      end;
      CloseFile(f);
    finally
      if Ok then begin
        fm:= TfmViewMutuo.Create(Self);
        fm.M:= M;
      end
      else begin
        M.Free;
      end;
    end;
  end;
end;

procedure TfmMain.miMutuiSaveClick(Sender: TObject);
begin
  if sdMutuo.Execute then begin
    if ActiveMDIChild is TfmViewMutuo then begin
      TfmViewMutuo(ActiveMDIChild).Save(sdMutuo.FileName);
    end;
  end;
end;

procedure TfmMain.About1Click(Sender: TObject);
begin
  AboutGPL(Application.Title);
end;

end.

