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
program TabaC;

uses
  Forms,
  uOpzioni in 'lib\uOpzioni.pas',
  Costanti in 'lib\Costanti.pas',
  DTabaC in 'lib\DTabaC.pas' {dmTaba: TDataModule},
  MakeDB in 'util\MakeDB.pas',
  FValorizzazione in 'gui\FValorizzazione.pas' {fmValorizzazione},
  FGiacEdit in 'gui\FGiacEdit.pas' {fmGiacEdit},
  FGiacIns in 'gui\FGiacIns.pas' {fmGiacInsert},
  FInfo in 'gui\FInfo.pas' {fmInfo},
  FMain in 'gui\FMain.pas' {fmMain},
  FOrdiCon in 'gui\FOrdiCon.pas' {fmOrdiCons},
  FOrdiEdit in 'gui\FOrdiEdit.pas' {fmOrdiEdit},
  FOrdiIns in 'gui\FOrdiIns.pas' {fmOrdiInsert},
  FPatName in 'gui\FPatName.pas' {fmPateName},
  FPatOrdCon in 'gui\FPatOrdCon.pas' {fmPatOCons},
  FPatOrdEdit in 'gui\FPatOrdEdit.pas' {fmPatOEdit},
  FPatOrdIns in 'gui\FPatOrdIns.pas' {fmPatOInsert},
  FPrezziEdit in 'gui\FPrezziEdit.pas' {fmPrezziEdit},
  FPrezziIns in 'gui\FPrezziIns.pas' {fmPrezziInsert},
  FPrezziSel in 'gui\FPrezziSel.pas' {fmPrezziSelect},
  FPrinterSetup in 'gui\FPrinterSetup.pas' {fmPrinterSetup},
  FSplash in 'gui\FSplash.pas' {fmSplash},
  FStampaCarichi in 'gui\FStampaCarichi.pas' {fmStampaCarichi},
  FStampaGiacenze in 'gui\FStampaGiacenze.pas' {fmStampaGiacenza},
  FStampaModulo in 'gui\FStampaModulo.pas' {fmStampaModuli},
  FStampaOrdini in 'gui\FStampaOrdini.pas' {fmStampaOrdinato},
  FStampaOrdList in 'gui\FStampaOrdList.pas' {fmStampaOrdine},
  FStampaPatOrd in 'gui\FStampaPatOrd.pas' {fmStampaRichiesto},
  FStampaPatOrdLs in 'gui\FStampaPatOrdLs.pas' {fmStampaRichiestaPatentino},
  FStampaPrezzi in 'gui\FStampaPrezzi.pas' {fmStampaListino},
  FStampaStatistiche in 'gui\FStampaStatistiche.pas' {fmStampaStatistiche},
  FStampaTabacchi in 'gui\FStampaTabacchi.pas' {fmStampaTabacchi},
  FStampaTrend in 'gui\FStampaTrend.pas' {fmStampaTendenze},
  FStatCalc in 'gui\FStatCalc.pas' {fmStatCalc},
  FTabaEdit in 'gui\FTabaEdit.pas' {fmTabaEdit},
  FTabaFind in 'gui\FTabaFind.pas' {fmTabaFind};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'TabaC';
  Application.CreateForm(TdmTaba, dmTaba);
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
