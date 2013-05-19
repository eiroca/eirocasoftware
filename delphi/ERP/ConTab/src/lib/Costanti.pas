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
unit Costanti;

interface

const
  DirSep = '\';

  sezDB = 'Default';
    keyDefaultDB = 'DefaultDB';  defDefaultDB = 'data';
  sezPrinter = 'Printer';
    keyPrinterIndex = 'PrinterIndex';        defPrinterIndex    = -1;
    keyPrinterFontName = 'PrinterFontName';  defPrinterFontName = 'Draft 17cpi';
    keyPrinterFontSize = 'PrinterFontSize';  defPrinterFontSize = 0;
    keyRigheRep        = 'PrinterRigheRep';  defRigheRep        = 66;
  sezConTab = 'ConTab';
    keyNomeDitta        = 'NomeDitta';              defNomeDitta        = 'NomeDitta';
    keyDataOggi         = 'DataOggi';               defDataOggi         = '19900101';
    keyDataTranStampate = 'DataMovimentiStampati';  defDataTranStampate = '19900101';
    keyDataCorrTrasf    = 'DataCorrTrasf';          defDataCorrTrasf    = '19900101';
    keyDataFatFTrasf    = 'DataFatFTrasf';          defDataFatFTrasf    = '19900101';
    keyDataFatCTrasf    = 'DataFatCTrasf';          defDataFatCTrasf    = '19900101';
    keyDataCorrStamp    = 'DataCorrStamp';          defDataCorrStamp    = '19900101';
    keyDataFatFStamp    = 'DataFatFStamp';          defDataFatFStamp    = '19900101';
    keyDataFatCStamp    = 'DataFatCStamp';          defDataFatCStamp    = '19900101';
    keyCodCassa         = 'CodCassa';               defCodCassa         = 0;
    keyCodForni         = 'CodForni';               defCodForni         = 0;
    keyCodClien         = 'CodClien';               defCodClien         = 0;
    keyCodIVADe         = 'CodIVADe';               defCodIVADe         = 0;
    keyCodIVACr         = 'CodIVACr';               defCodIVACr         = 0;
    keyCodIVAND         = 'CodIVAND';               defCodIVAND         = 0;

  fmtSoldi = '%m';

const
  conDeleteM    = 'Sei sicuro di volerlo cancellare?';
  conDeleteF    = 'Sei sicuro di volerla cancellare?';
  conTranDataOp = 'Operazione antecedente alla data dell''ultima stampa. Proseguo?';

  errNonScrtNonCancM = 'Non è possibile cancellarlo';
  errNonScrtNonCancF = 'Non è possibile cancellarla';
  errTranDataSc      = 'Non è possibile inserire un scrittura prima della data dell''ultima stampa';
  errTranDesc        = 'Deve essere presente una descrizione';
  errTranImpo        = 'Deve essere presente un importo valido';

implementation

end.
 