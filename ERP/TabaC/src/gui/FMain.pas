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
(* TabaC - Gestione Tabacchi
 * Ultima modifica: 06 nov 1999
 *)
unit FMain;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Forms,
  Dialogs, StdCtrls, Menus, Db, DBTables, JvAppEvent, JvComponentBase,
  JvFormPlacement, JvAppStorage, JvAppIniStorage;

type
  TfmMain = class(TForm)
    mnMain: TMainMenu;
    miTaba: TMenuItem;
    miTabaFind: TMenuItem;
    miTabaTaba: TMenuItem;
    miTabaTabaEdit: TMenuItem;
    miTabaTabaPrint: TMenuItem;
    miTabaPrez: TMenuItem;
    miTabaPrezEdit: TMenuItem;
    miTabaPrezInsert: TMenuItem;
    miTabaPrezStampa: TMenuItem;
    miTabaPrezSelect: TMenuItem;
    miTabaCalcStat: TMenuItem;
    miTabaModuInve: TMenuItem;
    miTabaUtil: TMenuItem;
    miTabaUtilSetup: TMenuItem;
    miTabaUtilInfo: TMenuItem;
    miTabaUtilPackDB: TMenuItem;
    miTabaExit: TMenuItem;
    miMoviGiacEdit: TMenuItem;
    miMoviOrdiEdit: TMenuItem;
    miMoviOrdiInsert: TMenuItem;
    miMoviValorizzazioni: TMenuItem;
    miMovi: TMenuItem;
    miMoviOrdiConsegna: TMenuItem;
    miMoviGiacInsert: TMenuItem;
    miMoviGiacPrint: TMenuItem;
    miMoviOrdiPrint: TMenuItem;
    miPate: TMenuItem;
    miPateRichPrint: TMenuItem;
    miPateEdit: TMenuItem;
    miPateRichConsegne: TMenuItem;
    miPateRichEdit: TMenuItem;
    miPateRichInsert: TMenuItem;
    miHelp: TMenuItem;
    miHelpAbout: TMenuItem;
    miHelpHelp: TMenuItem;
    AppEvents1: TJvAppEvents;
    fsForm: TJvFormStorage;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Stampastatistiche1: TMenuItem;
    StampaTendenze1: TMenuItem;
    StampaOrdinato1: TMenuItem;
    apStorage: TJvAppIniFileStorage;
    procedure miTabaExitClick(Sender: TObject);
    procedure miTabaPrezSelectClick(Sender: TObject);
    procedure miPateRichInsertClick(Sender: TObject);
    procedure miTabaCalcStatClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miTabaTabaEditClick(Sender: TObject);
    procedure miHelpAboutClick(Sender: TObject);
    procedure miHelpHelpClick(Sender: TObject);
    procedure miTabaPrezEditClick(Sender: TObject);
    procedure miTabaPrezInsertClick(Sender: TObject);
    procedure miTabaUtilInfoClick(Sender: TObject);
    procedure fsFormRestorePlacement(Sender: TObject);
    procedure miTabaUtilPackDBClick(Sender: TObject);
    procedure miTabaFindClick(Sender: TObject);
    procedure miMoviGiacInsertClick(Sender: TObject);
    procedure miMoviGiacEditClick(Sender: TObject);
    procedure miMoviOrdiEditClick(Sender: TObject);
    procedure miMoviOrdiInsertClick(Sender: TObject);
    procedure miMoviOrdiConsegnaClick(Sender: TObject);
    procedure miPateEditClick(Sender: TObject);
    procedure miPateRichEditClick(Sender: TObject);
    procedure miPateRichConsegneClick(Sender: TObject);
    procedure miMoviValorizzazioniClick(Sender: TObject);
    procedure miTabaModuInveClick(Sender: TObject);
    procedure miTabaTabaPrintClick(Sender: TObject);
    procedure miTabaPrezStampaClick(Sender: TObject);
    procedure AppEvents1SettingsChanged(Sender: TObject);
    procedure miMoviGiacPrintClick(Sender: TObject);
    procedure miMoviOrdiPrintClick(Sender: TObject);
    procedure miTabaUtilSetupClick(Sender: TObject);
    procedure miPateRichPrintClick(Sender: TObject);
    procedure Stampastatistiche1Click(Sender: TObject);
    procedure StampaTendenze1Click(Sender: TObject);
    procedure StampaOrdinato1Click(Sender: TObject);
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
  eLibCore, FAboutGPL, FDBPack, uOpzioni, MakeDB,
  DTabaC, FInfo, FValorizzazione,
  FStatCalc,
  FTabaEdit, FTabaFind,
  FPatName,
  FPatOrdEdit, FPatOrdCon, FPatOrdIns,
  FPrezziSel, FPrezziIns, FPrezziEdit,
  FGiacEdit, FGiacIns,
  FOrdiIns, FOrdiEdit, FOrdiCon,
  FStampaModulo,
  FStampaTabacchi, FStampaPrezzi, FStampaStatistiche, FStampaTrend,
  FStampaCarichi, FStampaGiacenze, FStampaOrdini,
  FStampaPatOrd,
  FPrinterSetup;

procedure TfmMain.miTabaExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.miTabaPrezSelectClick(Sender: TObject);
begin
  PrezziSelect;
end;

procedure TfmMain.miPateRichInsertClick(Sender: TObject);
begin
  PatOInsert(Date);
end;

procedure TfmMain.miTabaCalcStatClick(Sender: TObject);
begin
  StatCalc;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  DateUtil.SetLongYear;
(*
  FourDigitYear:= true;
*)
end;

procedure TfmMain.miTabaTabaEditClick(Sender: TObject);
begin
  TabaEdit;
end;

procedure TfmMain.miHelpAboutClick(Sender: TObject);
begin
  AboutGPL(Application.Title);
end;

procedure TfmMain.miHelpHelpClick(Sender: TObject);
begin
  WinHelp(Handle, nil, HELP_HELPONHELP, 0);
end;

procedure TfmMain.miTabaPrezEditClick(Sender: TObject);
begin
  PrezziEdit;
end;

procedure TfmMain.miTabaPrezInsertClick(Sender: TObject);
begin
  PrezziInsert;
end;

procedure TfmMain.miTabaUtilInfoClick(Sender: TObject);
begin
  ShowInfo;
end;

procedure TfmMain.fsFormRestorePlacement(Sender: TObject);
begin
  apStorage.FileName:= Opzioni.BasePath+'conf\layout.ini';
end;

procedure TfmMain.miTabaUtilPackDBClick(Sender: TObject);
begin
  PackDataBase(MakeAllTables, dmTaba.DB);
  dmTaba.UpdateTaba;
end;

procedure TfmMain.miTabaFindClick(Sender: TObject);
var
  CodI: integer;
begin
  CodI:= 1;
  FindTaba(CodI);
end;

procedure TfmMain.miMoviGiacInsertClick(Sender: TObject);
begin
  GiacInsert(Date);
end;

procedure TfmMain.miMoviGiacEditClick(Sender: TObject);
begin
  GiacEdit;
end;

procedure TfmMain.miMoviOrdiEditClick(Sender: TObject);
begin
  OrdiEdit(true);
end;

procedure TfmMain.miMoviOrdiInsertClick(Sender: TObject);
begin
  OrdiInsert(Date);
end;

procedure TfmMain.miMoviOrdiConsegnaClick(Sender: TObject);
begin
  OrdiCons;
end;

procedure TfmMain.miPateEditClick(Sender: TObject);
begin
  EditPateName;
end;

procedure TfmMain.miPateRichEditClick(Sender: TObject);
begin
  PatOEdit(true);
end;

procedure TfmMain.miPateRichConsegneClick(Sender: TObject);
begin
  PatOCons;
end;

procedure TfmMain.miMoviValorizzazioniClick(Sender: TObject);
begin
  Valorizza;
end;

procedure TfmMain.miTabaModuInveClick(Sender: TObject);
begin
  StampaModuloInventario;
end;

procedure TfmMain.miTabaTabaPrintClick(Sender: TObject);
begin
  StampaTabacchi;
end;

procedure TfmMain.miTabaPrezStampaClick(Sender: TObject);
begin
  StampaListinoTabacchi(NoDate);
end;

procedure TfmMain.AppEvents1SettingsChanged(Sender: TObject);
begin
  DateUtil.SetLongYear;
end;

procedure TfmMain.miMoviGiacPrintClick(Sender: TObject);
begin
  StampaGiacenza(NoDate);
end;

procedure TfmMain.miMoviOrdiPrintClick(Sender: TObject);
begin
   StampaOrdinato;
end;

procedure TfmMain.miTabaUtilSetupClick(Sender: TObject);
begin
  PrinterSetup;
end;

procedure TfmMain.miPateRichPrintClick(Sender: TObject);
begin
  StampaRichiesto;
end;

procedure TfmMain.Stampastatistiche1Click(Sender: TObject);
begin
  StampaStatistiche;
end;

procedure TfmMain.StampaTendenze1Click(Sender: TObject);
begin
  StampaTendenze;
end;

procedure TfmMain.StampaOrdinato1Click(Sender: TObject);
begin
  StampaCarichi;
end;

end.

