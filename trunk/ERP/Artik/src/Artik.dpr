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
program Artik;

uses
  Vcl.Forms,
  FEditArticoli in 'gui\FEditArticoli.pas' {fmEditArticoli},
  FEditFattForn in 'gui\FEditFattForn.pas' {fmEditFatFor},
  FEditForn in 'gui\FEditForn.pas' {fmEditForn},
  FEditIVA in 'lib\FEditIVA.pas' {fmEditCodIVA},
  FEditMis in 'gui\FEditMis.pas' {fmEditCodMis},
  FEditPiaCod in 'gui\FEditPiaCod.pas' {fmEditPiaCod},
  FFindArt in 'gui\FFindArt.pas' {fmFindArti},
  FFindFor in 'gui\FFindFor.pas' {fmFindFor},
  FGetUnCod in 'gui\FGetUnCod.pas' {fmGetUnusedCode},
  FInfo in 'gui\FInfo.pas' {fmInfo},
  FMain in 'gui\FMain.pas' {fmMain},
  FMakePrezzi in 'gui\FMakePrezzi.pas' {fmMakePrezzi},
  FSelSetMerc in 'gui\FSelSetMerc.pas' {fmSelSetMer},
  FSplash in 'gui\FSplash.pas' {fmSplash},
  MakeDB in 'util\MakeDB.pas',
  uOpzioni in 'lib\uOpzioni.pas',
  Costanti in 'lib\Costanti.pas',
  DArtik in 'lib\DArtik.pas' {dmArticoli: TDataModule},
  DMovim in 'lib\DMovim.pas' {dmMovim: TDataModule},
  DTabelle in 'lib\DTabelle.pas' {dmTabelle: TDataModule},
  uCodici in 'lib\uCodici.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Artik';
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmInfo, fmInfo);
  Application.CreateForm(TfmMakePrezzi, fmMakePrezzi);
  Application.CreateForm(TdmArticoli, dmArticoli);
  Application.CreateForm(TdmMovim, dmMovim);
  Application.CreateForm(TdmTabelle, dmTabelle);
  Application.Run;
end.
