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
unit uError;

interface

const

  ERR_OUTOFRANGE =  1000;
  ERR_NOTIMPLEME =  1001;
  ERR_NOCONVERGE =  1002;
  ERR_GAMMPPARAM =  1003;
  ERR_GAMMQPARAM =  1004;
  ERR_BETAIPARAM =  1005;
  ERR_ERROR00001 =  1006;
  ERR_BADINPUT   =  1007;
  ERR_BADGRAPH   =  1008;
  ERR_OUTOFMEM   =  1009;
  ERR_SampleOverFlow = 204;

type
  ExitError = procedure(Msg: string; Err: integer);

procedure ExitErrorProc(Msg: String; err: integer); far;

const
  ErrorHandler: ExitError = ExitErrorProc;

implementation

(* Gestore Errori *)
function GetErrName(err: integer): string;
begin
  case err of
    ERR_OUTOFRANGE: GetErrName:= 'Valore fuori dei limiti consentiti';
    ERR_NOTIMPLEME: GetErrName:= 'Operazione richiamata non ancora implementata';
    ERR_NOCONVERGE: GetErrName:= 'Non si e'' riusciti a raggiungere una convergenza necessaria.';
    ERR_GAMMPPARAM: GetErrName:= 'Gammap parametri incorretti';
    ERR_GAMMQPARAM: GetErrName:= 'Gammaq parametri incorretti';
    ERR_BETAIPARAM: GetErrName:= 'bad argument x in betai';
    ERR_ERROR00001: GetErrName:= 'no skew or kurtosis when zero variance';
    ERR_BADINPUT  : GetErrName:= 'errore dei dati di input';
    ERR_BADGRAPH  : GetErrName:= 'il grafo non e'' valido';
    ERR_SampleOverFlow: GetErrName:= 'Sample Overflow';
    ERR_OUTOFMEM  : GetErrName:= 'Too much memory or 64k limit violated';
    else            GetErrName:= 'Errore sconosciuto!!!';
  end;
end;

procedure ExitErrorProc(Msg: String; err: integer);
begin
  writeln;
  if Msg = '' then writeln('Errore nella libreria #', err) else writeln(Msg);
  writeln('Errore: ', GetErrName(err));
  halt(0);
end;

end.
