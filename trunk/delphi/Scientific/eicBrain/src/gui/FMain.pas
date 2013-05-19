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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, AppEvnts, ComCtrls;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Statistica1: TMenuItem;
    eoriadeisistemi1: TMenuItem;
    RicercaOperativa1: TMenuItem;
    Economia1: TMenuItem;
    Finanziari1: TMenuItem;
    DepositoMinimoxserieprelievi1: TMenuItem;
    Valoreattualediuninvestimento1: TMenuItem;
    assodiinteressediunprestito1: TMenuItem;
    assodiinteresseinvestimento1: TMenuItem;
    sbStatus: TStatusBar;
    ApplicationEvents1: TApplicationEvents;
    Prelieviregolaridadeposito1: TMenuItem;
    Sommaprestata1: TMenuItem;
    Depositoperaccumularecifra1: TMenuItem;
    Deprezzamentodiunbene1: TMenuItem;
    Duratadiunprestito1: TMenuItem;
    z1: TMenuItem;
    Valoredirecuperoscontocomposto1: TMenuItem;
    assodirendimentoquotadideprezzamento1: TMenuItem;
    Ultimopagamentodiunprestito1: TMenuItem;
    Valoreinvestimento1: TMenuItem;
    ScoTra1: TMenuItem;
    Wizard1: TMenuItem;
    Gestioneequazioneannuity1: TMenuItem;
    Distribuzioniteorichediscrete1: TMenuItem;
    Distribuzioniteorichecontinue1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure DepositoMinimoxserieprelievi1Click(Sender: TObject);
    procedure Valoreattualediuninvestimento1Click(Sender: TObject);
    procedure assodiinteressediunprestito1Click(Sender: TObject);
    procedure assodiinteresseinvestimento1Click(Sender: TObject);
    procedure ApplicationEvents1Hint(Sender: TObject);
    procedure Prelieviregolaridadeposito1Click(Sender: TObject);
    procedure Sommaprestata1Click(Sender: TObject);
    procedure Depositoperaccumularecifra1Click(Sender: TObject);
    procedure Deprezzamentodiunbene1Click(Sender: TObject);
    procedure Duratadiunprestito1Click(Sender: TObject);
    procedure z1Click(Sender: TObject);
    procedure Valoredirecuperoscontocomposto1Click(Sender: TObject);
    procedure assodirendimentoquotadideprezzamento1Click(Sender: TObject);
    procedure Ultimopagamentodiunprestito1Click(Sender: TObject);
    procedure Valoreinvestimento1Click(Sender: TObject);
    procedure ScoTra1Click(Sender: TObject);
    procedure Gestioneequazioneannuity1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

uses
  uEconomia, FDepositoMinimo, FValoreIniziale, FTassoRendimento, FIRR, FPreReg,
  FSomPre, FDepReg, FDeprezza, FDurPre, FPagReg, FValRec, FTasRen, FUltRat,
  FValDep, FScoTra, FAnnuity;

procedure TfmMain.ApplicationEvents1Hint(Sender: TObject);
begin
  if (Application.Hint <> '') then begin
    sbStatus.SimpleText:= Application.Hint;
  end;
end;

procedure TfmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.Gestioneequazioneannuity1Click(Sender: TObject);
begin
  fmAnnuity.ShowModal;
end;

procedure TfmMain.assodiinteressediunprestito1Click(Sender: TObject);
begin
  fmTassoRendimento.ShowModal;
end;

procedure TfmMain.assodiinteresseinvestimento1Click(Sender: TObject);
begin
  fmIRR.ShowModal;
end;

procedure TfmMain.assodirendimentoquotadideprezzamento1Click(Sender: TObject);
begin
  fmTasRen.ShowModal;
end;

procedure TfmMain.DepositoMinimoxserieprelievi1Click(Sender: TObject);
begin
  fmDepositoMinimo.ShowModal;
end;

procedure TfmMain.Depositoperaccumularecifra1Click(Sender: TObject);
begin
  fmDepReg.ShowModal;
end;

procedure TfmMain.Deprezzamentodiunbene1Click(Sender: TObject);
begin
  fmDeprezza.ShowModal;
end;

procedure TfmMain.Duratadiunprestito1Click(Sender: TObject);
begin
  fmDurPre.ShowModal;
end;

procedure TfmMain.Prelieviregolaridadeposito1Click(Sender: TObject);
begin
  fmPreReg.ShowModal;
end;

procedure TfmMain.ScoTra1Click(Sender: TObject);
begin
  FMScoTrA.ShowModal;
end;

procedure TfmMain.Sommaprestata1Click(Sender: TObject);
begin
  fmSomPre.ShowModal;
end;

procedure TfmMain.Ultimopagamentodiunprestito1Click(Sender: TObject);
begin
  fmUltRat.ShowModal;
end;

procedure TfmMain.Valoreattualediuninvestimento1Click(Sender: TObject);
begin
  fmValoreIniziale.ShowModal;
end;

procedure TfmMain.Valoredirecuperoscontocomposto1Click(Sender: TObject);
begin
  fmValRec.ShowModal;
end;

procedure TfmMain.Valoreinvestimento1Click(Sender: TObject);
begin
  fmValDep.ShowModal;
end;

procedure TfmMain.z1Click(Sender: TObject);
begin
  fmPagReg.ShowModal;
end;

end.

