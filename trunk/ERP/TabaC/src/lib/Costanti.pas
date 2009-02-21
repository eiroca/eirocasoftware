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
unit Costanti;

interface

const
  DirSep = '\';

  fmtSoldi = '%m';

  sezDB = 'DataBase';
    keyDefaultDB = 'DefaultDB';  defDefaultDB = 'data';
    keyRelPathStorico = 'ArchivioStorici'; defRelPathStorico = 'data\storici'; 
  sezPrinter = 'Printer';
    keyPrinterIndex        = 'PrinterIndex';        defPrinterIndex        = -1;
    keyPrinterFontName     = 'PrinterFontName';     defPrinterFontName     = 'Draft 17cpi';
    keyPrinterFontSize     = 'PrinterFontSize';     defPrinterFontSize     = 0;
    keyRighePag            = 'PrinterRighePag';     defRighePag            = 66;
    keyRigheVid            = 'PrinterRigheVid';     defRigheVid            = 66;
    keyPrinterOffsetTop    = 'PrinterOffsetTop';    defPrinterOffsetTop    = 0;
    keyPrinterOffsetBottom = 'PrinterOffsetBottom'; defPrinterOffsetBottom = 0;
    keyPrinterOffsetLeft   = 'PrinterOffsetLeft';   defPrinterOffsetLeft   = 0;
    keyPrinterOffsetRight  = 'PrinterOffsetRight';  defPrinterOffsetRight  = 0;

implementation

end.
 