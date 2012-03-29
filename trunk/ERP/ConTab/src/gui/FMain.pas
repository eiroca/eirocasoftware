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
  eLibCore,
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  SysUtils, Classes,
  Menus, StdCtrls, ExtCtrls, Db, DBTables,
   JvComponentBase, JvAppEvent;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    mnFile: TMenuItem;
    miExit: TMenuItem;
    N1: TMenuItem;
    Aiuto1: TMenuItem;
    Informazionisu1: TMenuItem;
    ContGenerale1: TMenuItem;
    Pianodeiconti1: TMenuItem;
    Schemidibilancio1: TMenuItem;
    Bilanci1: TMenuItem;
    Scritture1: TMenuItem;
    Utenti1: TMenuItem;
    procedure miExitClick(Sender: TObject);
    procedure Informazionisu1Click(Sender: TObject);
    procedure Pianodeiconti1Click(Sender: TObject);
    procedure Schemidibilancio1Click(Sender: TObject);
    procedure Bilanci1Click(Sender: TObject);
    procedure Scritture1Click(Sender: TObject);
    procedure Utenti1Click(Sender: TObject);
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
  eLibDB, Costanti,
  DContabilita, uOpzioni,
  FEditConConti, FEditConSchemiBilancio, FEditConBilanci, FEditConGiornale,
  FAboutGPL, FEditAdmUtenti;

procedure TfmMain.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.Informazionisu1Click(Sender: TObject);
begin
  AboutGPL(Application.Title);
end;

procedure TfmMain.Pianodeiconti1Click(Sender: TObject);
begin
  EditConti;
end;

procedure TfmMain.Schemidibilancio1Click(Sender: TObject);
begin
  EditBilanciSchema;
end;

procedure TfmMain.Bilanci1Click(Sender: TObject);
begin
  EditBilanci;
end;

procedure TfmMain.Scritture1Click(Sender: TObject);
begin
  EditGiornale;
end;

procedure TfmMain.Utenti1Click(Sender: TObject);
begin
  EditUtenti;
end;

end.

