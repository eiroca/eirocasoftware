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
unit Costanti;

interface

var
  DBPassword: string = '';

const
  DirSep = '\';

  namMagicNum = 'MagicNum';  defMagicNum = 2046;
  namPassword = 'Password';  defPassword = '8F572E978D8A8804';

  sezDB = 'Default';
    keyDefaultDB = 'DefaultDB';  defDefaultDB = 'data';
  sezOpzioni = 'Default';
    keyPrinterIndex = 'PrinterIndex';        defPrinterIndex    = -1;
    keyPrinterFontName = 'PrinterFontName';  defPrinterFontName = 'Draft 17cpi';
    keyPrinterFontSize = 'PrinterFontSize';  defPrinterFontSize = 0;
    keyRigheRep        = 'PrinterRigheRep';  defRigheRep        = 66;
  sezContatti = 'Contatti';
    keyYourSelf         = 'YourSelf';               defYourSelf         = 0;
    keyDefPrfx1         = 'DefPrefix1';             defDefPrfx1         = '039';
    keyDefPrfx2         = 'DefPrefix2';             defDefPrfx2         = '';
    keyRigheInd         = 'IndRows';                defRigheInd         = 2;
    keyAutoInsertDataImpo = 'AutoInsertDataImpo';   defAutoInsertDataImpo = 1;
    keyInsertDataImpoNota = 'InsertDataImpoNota';   defInsertDataImpoNota = 'Primo contatto';
    keyAutoInsertIndir  = 'AutoInsertIndir';        defAutoInsertIndir = 1;
    keyAutoInsertTelef  = 'AutoInsertTelef';        defAutoInsertTelef = 1;
    keyPostEdit         = 'PostEdit';               defPostEdit = 1;
    keyPostInsert       = 'PostInsert';             defPostInsert = 0;
    keyShowTito         = 'ShowTito';               defShowTito   = 1;
    keyIntPref          = 'ShowIntPrefix';          defIntPref    = 0;
    keyShowPre2         = 'ShowPre2';               defShowPre2   = 0;
    keySortCol          = 'SortCol';                defSortCol    = 0;

  fmtSoldi = '%m';

implementation

initialization
  DBPassword:= 'mazingaz';
  DBPassword[1]:= UpCase(DBPassword[1]);
  DBPassword[length(DBPassword)]:= UpCase(DBPassword[length(DBPassword)]);
end.
