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
program ConTatti;

uses
  Forms,
  MakeDB in 'util\MakeDB.pas',
  uOpzioni in 'lib\uOpzioni.pas',
  ContComm in 'lib\ContComm.pas',
  Costanti in 'lib\Costanti.pas',
  MakePrIn in 'lib\MakePrIn.pas',
  FStat in 'gui\FStat.pas' {fmStatistiche},
  FChgPwd in 'gui\FChgPwd.pas' {fmChangePassword},
  FChkUsr in 'gui\FChkUsr.pas' {fmCheckUser},
  FContat in 'gui\FContat.pas' {fmContatti},
  FEdtGrp in 'gui\FEdtGrp.pas' {fmEditGruppi},
  FEleDati in 'gui\FEleDati.pas' {fmEleDati},
  FEleIndi in 'gui\FEleIndi.pas' {fmEleIndi},
  FEleTele in 'gui\FEleTele.pas' {fmEleTelef},
  FGruppi in 'gui\FGruppi.pas' {fmGruppi},
  FInfo in 'gui\FInfo.pas' {fmInfo},
  FMain in 'gui\FMain.pas' {fmMain},
  FManom in 'gui\FManom.pas' {fmManomissione},
  FNewCont in 'gui\FNewCont.pas' {fmNewCont},
  FNickIRC in 'gui\FNickIRC.pas' {fmNick4IRC},
  FPreview in 'gui\FPreview.pas' {fmPreview},
  FRepDati in 'gui\FRepDati.pas' {repDatiContatto},
  FSplash in 'gui\FSplash.pas' {fmSplash},
  DContat in 'lib\DContat.pas' {dmContatti: TDataModule},
  FElenco in 'gui\FElenco.pas' {fmElenco};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Con Tatti 2007';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmContatti, dmContatti);
  Application.CreateForm(TfmElenco, fmElenco);
  Application.Run;
end.
