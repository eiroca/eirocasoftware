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
unit uMath;

interface

uses
  eLibMath, Math;

const
  { Ranges of the IEEE floating point types, including denormals }
  MinReal     = 2.9e-39;
  MaxReal     = 1.7e+38;
  MinSingle   = 1.5e-45;
  MaxSingle   = 3.4e+38;
  MinDouble   = 5.0e-324;
  MaxDouble   = 1.7e+308;
  MinExtended = 3.4e-4932;
  MaxExtended = 1.1e+4932;
  MinComp     = -9.223372036854775807e+18;
  MaxComp     = +9.223372036854775807e+18;

const
  PI_2      =  1.570796326794896619231322;   { pi / 2 }
  PI_3      =  1.047197551196597746154214;   { pi / 3 }
  PI_4      =  0.7853981633974483096156608;  { pi / 4 }
  SQRT_PI   =  1.772453850905516027298167;   { sqrt(pi) }
  SQRT_2PI  =  2.506628274631000502415765;   { sqrt(2.pi) }
  TWO_PI    =  6.283185307179586476925287;   { 2.pi }
  LN_PI     =  1.144729885849400174143427;   { ln(pi) }
  LOG_PI    =  0.4971498726941338543512683;  { log(pi) }
  LOG_E     =  0.4342944819032518276511289;  { log(e) }
  LN_10     =  2.302585092994045684017991;   { ln(10) }
  E         =  2.718281828459045235360287;   { exp(1) }
  ONE_RAD   = 57.295779513082320876798155;   { 1 rad in ° }
  ONE_DEG   =  0.017453292519943295769237;   { 1° in rad }

type
  TReal = double;  (* >= 64 bits *)
  TBigReal = extended; (* > TReal *)
  TInteger = integer; (* >= 32 bits *)
  TBigInteger = Int64; (* > TInteger *)

const
  MinPrec  = MinDouble;
  MaxPrec  = MaxDouble;
  MinDPrec = MinExtended;
  MaxDPrec = MaxExtended;



function IPow(Base, Exp: TInteger): TBigInteger;
function IntPow(Base: TReal; NonNegInt: TInteger): TReal;
(*
function PowInt(X: PREC; t: TInt): PREC;
function POW(Base, Exponent: PREC): PREC;
function Power(x, y: PREC): PREC;
*)

function ModestWholeNumber(X: TReal): boolean;

(* Fattoriale in tutte le salse *)
function Fattoriale(x: TReal): TReal;
function LGFattoriale(x: TInteger): TBigInteger;
function FSFattoriale(x: TInteger): TReal;
function ACFattoriale(x: TInteger): TReal;
function LNFattoriale(x: TInteger): TReal;
function FSFattFrom(x: TInteger; StartNum: TInteger; StartVal: TReal): TReal;
function ACFattFrom(x: TInteger; StartNum: TInteger; StartVal: TReal): TReal;
function FACT(n: TInteger): TReal;

function GammaLN(XX: TReal): TReal;
function Gamma(x: TReal): TReal;
function beta(z, w: TReal): TReal;

(* funzioni del calcolo combinatorio *)
function Disposizioni(Elem: longint; Classi: longint): TReal;
function Combinazioni(Elem: longint; Classi: longint): TReal;
function DisposizioniRip(Elem: longint; Classi: longint): TReal;
function CombinazioniRip(Elem: longint; Classi: longint): TReal;

implementation

function IPow(Base, Exp: TInteger): TBigInteger;
var
  i: TInteger;
  tmp: TBigInteger;
begin
  if base = 2 then begin IPow:= 1 shl Exp; exit; end;
  tmp:= 1; (* Att! se tmp:= base, for i:= 2 to ... con Exp = 0 da risulatot errato! *)
  for i:= 1 to Exp do tmp:= tmp * base;
  IPow:= tmp;
end;

function IntPow(Base: TReal;  NonNegInt: TInteger): TReal;
{Returns Base raised to the nonnegative integer power NonNegInt.}
begin
  if NonNegInt = 0 then IntPow := 1
  else if odd(NonNegInt) then IntPow := Base * IntPow(Base, NonNegInt - 1)
  else IntPow := sqr(IntPow(Base, NonNegInt div 2));
end;

function PowInt(X: TReal; t: TInteger): TReal;
var
  i, S: TInteger;
  tmp: TReal;
begin
  if t > 0 then s:= 1 else begin s:=-1; t:= -t; end;
  tmp:= 1;
  for i:= 1 to t do begin
    tmp:= tmp * X;
  end;
  if s=-1 then PowInt:= 1/tmp else PowInt:= tmp;
end;

function POW(Base, Exponent: TReal): TReal;
{Returns Base raised to the Exponent power.
  Prerequisite files: EvenPREC.lib, IntPow.lib,}
begin
  if Exponent < 0.0 then POW := 1.0 / POW(Base, -Exponent)
  else if (Base = 1.0) or (Exponent = 0.0) then POW := 1.0
  {assuming POW(0.0, x) = 1.0}
  else if Base = 0.0 then POW := 0.0
  else if ModestWholeNumber(Exponent) and (abs(Exponent - int(Exponent)) <= cZero) then POW := IntPow(Base, trunc(Exponent))
  else POW := exp(Exponent * ln(Base));
end;

function Power(x, y: TReal): TReal;
begin
  Power:= exp(ln(x)*y);
end;

function ModestWholeNumber(X: TReal): boolean;
{Returns true if X is a whole number in the range -maxint .. maxint.}
begin
  if abs(X) < maxint then ModestWholeNumber := X = trunc(X)
  else ModestWholeNumber := false
end;

var
  OldNum : TReal = 0;
  OldVal : TReal = 1;

function Fattoriale(x: TReal): TReal;
var
  temp : TReal;
  segno: TInteger;
  flg  : boolean;
begin
  if x = OldNum then begin
    Fattoriale:= OldVal;
    exit;
  end;
  flg:= false;
  if x = 0 then begin
    temp:= 1;
  end
  else begin
    Segno:= Sign(x);
    x:= abs(x);
    if (x <> int(x)) then
      temp:= Gamma(x)
    else begin
      if x < OldNum then begin
        if x < 11 then
          temp:= LGFattoriale(trunc(x))
        else if x < 20 then
          temp:= FSFattoriale(trunc(x))
        else if x < 34 then
          temp:= ACFattoriale(trunc(x))
        else begin
          temp:= LNFattoriale(trunc(x));
          flg:= true;
        end;
      end
      else begin
        if x < 11 then
          temp:= LGFattoriale(trunc(x))
        else if x < 20 then
          temp:= FSFattFrom(trunc(x), trunc(OldNum), OldVal)
        else if x < 34 then
          temp:= ACFattFrom(trunc(x), trunc(OldNum), OldVal)
        else begin
          temp:= LNFattoriale(trunc(x));
          flg:= true;
        end;
      end;
    end;
    temp:= Segno * temp;
  end;
  if flg then begin
    OldNum:= 0;
    OldVal:= 1;
  end
  else begin
    OldNum:= x;
    OldVal:= temp;
  end;
  Fattoriale:= temp;
end;

function LGFattoriale(x: TInteger): TBigInteger;
var
  tmp: TBigInteger;
  i: TInteger;
begin
  tmp:= x;
  for i:= pred(x) downto 2 do begin
    tmp:= tmp * i;
  end;
  LGFattoriale:= tmp;
end;

function FSFattoriale(x: TInteger): TReal;
var
  i: TBigInteger;
  temp: TBigReal;
begin
  temp := x;
  i:= pred(x);
  while (i > 1) do begin
    temp := temp * i;
    dec(i);
  end;
  FSFattoriale := temp;
end;

function ACFattoriale(x: TInteger): TReal;
var
  i: TBigInteger;
  temp: TBigReal;
begin
  temp := ln(x);
  i:= pred(x);
  while (i > 1) do begin
    temp := temp + ln(i);
    dec(i);
  end;
  ACFattoriale := exp(temp);
end;

function LNFattoriale(x: TInteger): TReal;
var
  i: TInteger;
  temp: TReal;
begin
  if x = 0 then begin LNFattoriale:= 0; exit end;
  temp := ln(x);
  i:= pred(x);
  while (i > 1) do begin
    temp := temp + ln(i);
    dec(i);
  end;
  LNFattoriale := temp;
end;

function FSFattFrom(x: TInteger; StartNum: TInteger; StartVal: TReal): TReal;
var
  i: TInteger;
  temp: TReal;
begin
  temp := StartVal;
  i:= x;
  while (i > StartNum) do begin
    temp := temp * i;
    dec(i);
  end;
  FSFattFrom := temp;
end;

function ACFattFrom(x: TInteger; StartNum: TInteger; StartVal: TReal): TReal;
var
  i: TInteger;
  temp: TReal;
begin
  temp := ln(StartVal);
  i:= x;
  while (i > StartNum) do begin
    temp := temp + ln(i);
    dec(i);
  end;
  ACFattFrom := exp(temp);
end;

function FACT(n: TInteger): TReal;
{Returns n! for n >= 0.  Intentionally provokes zero-divide for n<0.}
var
  k: TInteger;
  ans: TReal;
begin
  if n < 0 then FACT := 0 / (n - n)
  else begin
    ans := 1.0;
    for k := 2 to n do ans := k * ans;
    FACT := ans;
  end;
end;

function GammaLN(xx: TReal): TReal;
const
  COF: array[1..6] of TReal =
      (76.18009173, -86.50532033, 24.01409822, -1.231739516, 0.120858003E-2, -0.536382E-5);
  STP : TReal = 2.50662827465;
var
  x, tmp, ser: TReal;
  j: TInteger;
begin
  x   := xx - 1.0;
  tmp := x + 5.5;
  tmp := (x + 0.5) * ln(tmp) - tmp;
  ser := 1.0;
  for J := 1 to 6 do begin
    x:= x + 1.0;
    ser:= ser + COF[J] / X;
  end;
  GammaLN:= tmp + ln(STP * ser);
end;

function Gamma(x: TReal): TReal;
begin
  (* integrale(x^(r-1)*exp(-x), x, 0, inf) *)
  Gamma:= exp(GammaLN(x));
end;

function beta(z, w: TReal): TReal;
begin
  beta:= exp(GammaLN(z)+GammaLN(w)-GammaLN(z+w));
end;

function Disposizioni(Elem: longint; Classi: longint): TReal;
var
  temp: TReal;
begin
  if (Classi > Elem) then
    temp := 0
  else begin
    temp:= 1;
    while (Classi <> 0) do begin
      temp:= temp * Elem;
      dec(Elem);
      dec(classi);
    end;
  end;
  Disposizioni:= temp;
end;

function DisposizioniRip(Elem: longint; Classi: longint): TReal;
var
  temp: TReal;
begin
  if (Classi > Elem) then
    temp := 0
  else
    temp:= exp(Classi * ln(Elem));
  DisposizioniRip:= temp;
end;

function Combinazioni(Elem: longint; Classi: longint): TReal;
var
  temp : TReal;
  max, min : longint;
begin
  min:= Elem-Classi;
  max:= Classi;
  if min > max then begin
    max:= min;
    min:= classi;
  end;
  if (Elem < 0) or (min < 0) or (max < 0 ) then
    temp:= 0
  else
    temp:= Disposizioni(Elem, min);
  if temp <> 0 then temp := temp / Fattoriale(min);
  Combinazioni := temp;
end;

function CombinazioniRip(Elem: longint; Classi: longint): TReal;
var
  num,den: TReal;
begin
  num:= DisposizioniRip(Elem, Classi);
  den:= ACFattoriale(Classi);
  if (num=0) or (den<cZero) then CombinazioniRip:= 0
  else CombinazioniRip:= num/den;
end;

end.
