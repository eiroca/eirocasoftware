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
program ConTab;

uses
  Forms,
  FSplash in 'gui\FSplash.pas' {fmSplash},
  FEditAdmUtenti in 'gui\FEditAdmUtenti.pas' {fmEditAdmUtenti},
  FEditConBilanci in 'gui\FEditConBilanci.pas' {fmEditConBilanci},
  FEditConConti in 'gui\FEditConConti.pas' {fmEditConConti},
  FEditConGiornale in 'gui\FEditConGiornale.pas' {fmEditConGiornale},
  FEditConSchemiBilancio in 'gui\FEditConSchemiBilancio.pas' {fmEditConSchemiBilancio},
  FMain in 'gui\FMain.pas' {fmMain},
  uOpzioni in 'lib\uOpzioni.pas',
  Costanti in 'lib\Costanti.pas',
  DContabilita in 'lib\DContabilita.pas' {dmContabilita: TDataModule},
  DEditAdmUtenti in 'lib\DEditAdmUtenti.pas' {dmEditAdmUtenti: TDataModule},
  DEditConBilanci in 'lib\DEditConBilanci.pas' {dmEditConBilanci: TDataModule},
  DEditConConti in 'lib\DEditConConti.pas' {dmEditConConti: TDataModule},
  DEditConGiornale in 'lib\DEditConGiornale.pas' {dmEditConGiornale: TDataModule},
  DEditConSchemiBilancio in 'lib\DEditConSchemiBilancio.pas' {dmEditConSchemiBilancio: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ConTab';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmContabilita, dmContabilita);
  Application.CreateForm(TdmEditAdmUtenti, dmEditAdmUtenti);
  Application.CreateForm(TdmEditConBilanci, dmEditConBilanci);
  Application.CreateForm(TdmEditConConti, dmEditConConti);
  Application.CreateForm(TdmEditConGiornale, dmEditConGiornale);
  Application.CreateForm(TdmEditConSchemiBilancio, dmEditConSchemiBilancio);
  Application.Run;
end.
