(* GPL > 3.0
Copyright (C) 1986-2009 eIrOcA Elio & Enrico Croce, Simona Burzio

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
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, DB, StdCtrls;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    Sistema1: TMenuItem;
    Aiuto1: TMenuItem;
    Esci1: TMenuItem;
    N1: TMenuItem;
    Opzioni1: TMenuItem;
    Informazionisu1: TMenuItem;
    N2: TMenuItem;
    CompattazioneDataBase1: TMenuItem;
    Tabelle1: TMenuItem;
    TabellaaliquoteIVA1: TMenuItem;
    Tabellaunitadimisura1: TMenuItem;
    PianodiCodifica1: TMenuItem;
    DatiArticoli1: TMenuItem;
    Fornitori1: TMenuItem;
    Cercaarticoli1: TMenuItem;
    Articoli1: TMenuItem;
    FattureFornitori1: TMenuItem;
    N3: TMenuItem;
    Inserimentofattura1: TMenuItem;
    Finestre1: TMenuItem;
    Cascade1: TMenuItem;
    Affianca1: TMenuItem;
    Button1: TButton;
    procedure Esci1Click(Sender: TObject);
    procedure Opzioni1Click(Sender: TObject);
    procedure Informazionisu1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CompattazioneDataBase1Click(Sender: TObject);
    procedure TabellaaliquoteIVA1Click(Sender: TObject);
    procedure Tabellaunitadimisura1Click(Sender: TObject);
    procedure PianodiCodifica1Click(Sender: TObject);
    procedure DatiArticoli1Click(Sender: TObject);
    procedure Fornitori1Click(Sender: TObject);
    procedure Cercaarticoli1Click(Sender: TObject);
    procedure Inserimentofattura1Click(Sender: TObject);
    procedure Cascade1Click(Sender: TObject);
    procedure Affianca1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
  eLibDB, eLibCore, DArtik, MakeDB, FDBPack, FInfo, FAboutGPL, UOpzioni,
  FEditIVA, FEditMis, FEditPiaCod, FEditArticoli, FEditForn, FFindArt,
  FEditFattForn, FMakePrezzi;

procedure TfmMain.Esci1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.Opzioni1Click(Sender: TObject);
begin
  fmInfo.ShowModal;
end;

procedure TfmMain.Informazionisu1Click(Sender: TObject);
begin
  AboutGPL(Application.Title);
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  with dmArticoli do begin
    if not ConnectDataBase(MakeAllTables, DB, Opzioni.BasePath+Opzioni.DefaultDB,
      Crypt.SimpleCrypt(DB.Signature,DB.Signature), nil) then Application.Terminate;
  end;
end;

procedure TfmMain.CompattazioneDataBase1Click(Sender: TObject);
begin
  PackDataBase(MakeAllTables, dmArticoli.DB);
end;

procedure TfmMain.TabellaaliquoteIVA1Click(Sender: TObject);
begin
  EditCodIVA;
end;

procedure TfmMain.Tabellaunitadimisura1Click(Sender: TObject);
begin
  EditCodMis;
end;

procedure TfmMain.PianodiCodifica1Click(Sender: TObject);
begin
  EditPiaCod;
end;

procedure TfmMain.DatiArticoli1Click(Sender: TObject);
begin
  EditArticoli;
end;

procedure TfmMain.Fornitori1Click(Sender: TObject);
begin
  EditForn;
end;

procedure TfmMain.Cercaarticoli1Click(Sender: TObject);
var
  CodAlf: string;
  CodNum: integer;
begin
  CodAlf:= '';
  CodNum:= 0;
  FindArticolo(CodAlf, CodNum);
end;

procedure TfmMain.Inserimentofattura1Click(Sender: TObject);
begin
  EditFatFor;
end;

procedure TfmMain.Cascade1Click(Sender: TObject);
begin
  Cascade;
end;

procedure TfmMain.Affianca1Click(Sender: TObject);
begin
  Tile;
end;

procedure TfmMain.Button1Click(Sender: TObject);
begin
  fmMakePrezzi.SHowModal;
end;

end.

