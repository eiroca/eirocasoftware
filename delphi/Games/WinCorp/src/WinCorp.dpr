(* GPL > 3.0
Copyright (C) 1997-2008 eIrOcA Enrico Croce & Simona Burzio

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
program WinCorp;

uses
  Forms,
  WidgetGame in 'lib\WidgetGame.pas',
  MessageStr in 'lib\MessageStr.pas',
  FGame in 'gui\FGame.pas' {fmGame},
  FLetter in 'gui\FLetter.pas' {fmLetter},
  FMarketReport in 'gui\FMarketReport.pas' {fmMarketReport},
  FHelp in 'gui\FHelp.pas' {fmHelp},
  FMain in 'gui\FMain.pas' {fmMain},
  FResult in 'gui\FResult.pas' {fmResult};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'WinCorp';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmGame, fmGame);
  Application.CreateForm(TfmLetter, fmLetter);
  Application.CreateForm(TfmMarketReport, fmMarketReport);
  Application.CreateForm(TfmHelp, fmHelp);
  Application.CreateForm(TfmResult, fmResult);
  Application.Run;
end.
