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
unit eMath;
(*
//@doc INTERNAL EXTERNAL MATHTOOL EIC
//@contents1 Unit MathTool | Documentazione tecnica <nl>
//@index unit funcm func procm proc type record const pconst | EIC

//@unit MathTool | MathTools - Routine matematiche varie e costanti matematiche
//@auth  Enrico Croce
//@vers  1.1
//@cdate unknowm
//@mdate 25/01/1997
//@comm Definisce la precisione e varie routine matematiche di
//supporto
//@todo    Funzioni iperboliche. <nl> Finire di commentare. <nl>
//@devnote
//  Funziona anche sotto Delphi (Nessun oggetto).<nl>
//  Tan, Log10, Log2, Pow2, Pow10 uses some undocumented, but fully functional
//  routines of the coprocessor/emulator floating point package available
//  to the user. These functions are accelerated only in $N+ mode and work
//  correctly with real mode, DOS protected mode, and Windows programs.
*)

interface

{$IFNDEF MATH}
uses
  Math;
{$ENDIF}

type
  PAInteger = ^AInteger;
  AInteger = array[0..0] of integer;

  PADouble = ^ADouble;
  ADouble = array[0..0] of double;

  PAExtended = ^AExtended;
  AExtended = array[0..0] of extended;

const   { Ranges of the IEEE floating point types, including denormals }
  MinReal     = 2.9e-39;
  MaxReal     =  1.7e38;
  MinSingle   = 1.5e-45;
  MaxSingle   = 3.4e+38;
  MinDouble   = 5.0e-324;
  MaxDouble   = 1.7e+308;
  MinExtended = 3.4e-4932;
  MaxExtended = 1.1e+4932;
  MinComp     = -9.223372036854775807e+18;
  MaxComp     = 9.223372036854775807e+18;

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
  ONE_RAD   = 57.295779513082320876798155;   { 1 rad in ø }
  ONE_DEG   =  0.017453292519943295769237;   { 1ø in rad }

  Rad2Deg   = 360 / (2*PI);   (* Fattore di conversione Radianti -> Gradi *)
  Deg2Rad   = (2 * PI) / 360; (* Fattore di conversione Gradi -> Radianti *)
  Grad2Rad  = (PI / 200);
  Rad2Grad  = (200 / PI);
  Cycle2Rad = (2 * PI);
  Rad2Cycle = 1/(2 * PI);

const
  ITMAX : integer = 100;  (* Numero di iterazioni massime nei processi iterativi *)
  SMALL : double = 1E-6;  (* Numero assunto come piccolo *)
  BIG   : double = 1E+6;  (* Numero assunto come grande *)
  ZERO  : double = 1E-20; (* Numero assumibile come Zero *)
  INF   : double = 1E+20; (* Numero assumibile come Infinito *)

function Equal(a, b: double): boolean; (*
//@func Equal | boolean | Ritorna true se abs(a-b) Š minore di abs(b)*Zero
// @parm | a | double | Primo elemento da confrontare
// @parm | b | double | Secondo elemento da confrontare (preso come riferimento)
//@comm ritorna vero se l'errore relativo di a rispetto a b e' minore di zero
//@ToDo Bisognerebbe portarla in assembler inline
*)
procedure Swapdouble(var x, y: double); (*
//@proc Swapdouble | Scambia x con y
// @parm var | x | double | Primo valore
// @parm var | y | double | Secondo valore
//@ToDo Sarebbe pi— opportuna una versione inline in assembler
*)
function MCD(a, b: longint): longint; (*
//@func MCD | longint | Minimo Comune Denominatore
// @parm | a | longint | Primo fattore
// @parm | b | longint | Secondo fattore
//@comm M.C.D. con il l'algoritmo di euclide. A, e B vengono presi in valore assoluto
*)
function RefrIndex(WaveNum: double): double; (*
//@func RefrIndex | double | Calculates refractive index of air according to Eblens formula
// @parm | WaveNum | double | Vacuum wavenumber
// @rdesc Refractive index in air
*)
function AmstToCm(WaveLength: double): double; (*
//@func AmstToCm | double | Converts wavelength in Angstroms in air to vacuum wavenumbers
// @parm | WaveLength | double | Wavelength in Angstroms (air).
// @rdesc Wavenumber in cm-1 (vacuum).
*)
function CmToAmst(WaveNum: double): double; (*
//@func CmToAmst | double | Converts wavenumbers to wavelength
// @parm | WaveNum | double | Vacuum wavenumber in cm^-1
// @rdesc Air wavelength in Angstroms.
*)
function CalcIncr(Incr: double): double; (*
//@func CalcIncr | double | Potenza 1, 2 o 5 piu' vicina
// @parm  | Incr | double | Incremento da approssimare (positivo)
// @comm Questa funzione restituisce la potenza di 1, 2, o 5 che sia
//minore o uguale a Incr, puo' essere usata per calcolare il numero
//arrotondato da dare agli intervalli delle etichette di un grafico.<nl>
//Incr deve essere un numero positivo.
*)
procedure EngNot(Number: double; var Mantissa: double; var Exponent: longint); (*
//@proc EngNot | Crea numero in notazione ingegneristica
// @parm     | Number   | double | Numero da trasformare
// @parm var | Mantissa | double | Valore calcolato della mantissa
// @parm var | Exponent | longint | Valore calcolato dell'esponente
// @comm Questa procedure calcola la notazione ingegneristica (Mantissa * 10^Exponent) del numero fornito
*)
function NumDec(Num: double): integer; (*
//@func NumDec | integer | Calcola quante sono le cifre di decimali significativi
// @parm | Num | double | Numero contenente le cifre decimali
//@comm la doubleisione e' fissata a SMALL
//@ex Pone 2 in A | A:= NumDec(0.01);
//@ex Pone 0 in A | A:= NumDec(1+SMALL);
*)

(* Fattoriale in tutte le salse *)
function Fattoriale(x: double): double;
function LGFattoriale(x: longint): longint;
function FSFattoriale(x: longint): double;
function ACFattoriale(x: longint): double;
function LNFattoriale(x: longint): double;
function FSFattFrom(x: longint; StartNum: longint; StartVal: double): double;
function ACFattFrom(x: longint; StartNum: longint; StartVal: double): double;
function FACT(n: integer): double;

function GammaLN(XX: double): double;
function Gamma(x: double): double;
function beta(z, w: double): double;
function Max(a, b: double): double;
function Min(a, b: double): double;

function IPow(Base, Exp: integer): longint;
function IntPow(Base: double; NonNegInt: integer): double;
function PowInt(X: double; t: integer): double;
function POW(Base, Exponent: double): double;

function Sgn(x: double): integer;
function ModestWholeNumber(X: extended): boolean;
function ASIN(ratio: extended): extended;
function ACOS(ratio: extended): extended;
function ATAN(ratio: extended): extended;
function COT(angle: extended): extended;

function Pow10(Base: extended): extended;
function Pow2(Base: extended): extended;

function WithSign(x, y : extended): extended;

function HEX(B: byte): string;

{$IFDEF MATH}

function Power(x, y: double): double;

function LnXP1(X: extended): extended;
function Log10(Arg: extended): extended;
function Log2(Arg: extended): extended;

function Tan(X: extended): extended; assembler;

function ArcCos(X: extended): extended;
function ArcSin(X: extended): extended;
function ArcTan2(Arg1, Arg2: extended): extended;

function Sinh(Arg: extended): extended;
function Cosh(Arg: extended): extended;
function Tanh(Arg: extended): extended;

function ArcSinh(Arg: extended): extended;
function ArcCosh(Arg: extended): extended;
function ArcTanh(Arg: extended): extended;

function Hypot(X, Y: extended): extended;

function Sign(R: double): double;
function Ceil(X: extended): longint;
function Floor(X: extended): longint;

function Poly(X: extended; const Coefficients: array of double): extended;

{$ENDIF}

type
  TPoly = record
    Neg, Pos, DNeg, DPos: extended;
  end;

procedure PolyX(const A: array of double; X: extended; var Poly: TPoly);
function  RelSmall(X, Y: extended): Boolean;

implementation

function Equal(a,b: double): boolean; (**)
begin
  if abs(a - b) > abs(b) * Zero then Equal:= false else Equal:= true;
end;

procedure Swapdouble(var x, y: double); (**)
var z: double;
begin
  z:= x; x:= y; y:= z;
end;

function MCD(a, b: longint): longint; (**)
var
  R: longint;
begin
  A:= ABS(A);
  B:= ABS(B);
  repeat
    R:= A mod B;
    if R = 0 then break;
    A:= B;
    B:= R;
  until false;
  MCD:= b;
end;

function RefrIndex(WaveNum: double): double; (**)
const
  A = 6432.8E-8;
  B = 2.949810E6;
  C = 1.46E10;
  D = 2.5540E4;
  E = 4.1E9;
begin
  RefrIndex:= 1.0 + A + B/(C-SQR(WaveNum)) + D/(E-SQR(WaveNum));
end;

function AmstToCm; (**)
var CM: double;
begin
  CM:=1.0E8/WaveLength;
  repeat
    CM:=1.0E8/(WaveLength*RefrIndex(CM));
  until abs(CmToAmst(CM)-WaveLength) < Zero;
  AmstToCm:=CM;
end;

function CmToAmst; begin (**)
  CmToAmst:=1.0E8/(WaveNum*RefrIndex(WaveNum));
end;

function CalcIncr(Incr: double): double; (**)
var
  Power: longint;
  Fraction: double;
begin
  Power:= trunc(Log10(Incr));
  Fraction:= Incr/Pow10(Power);
  while Fraction<1 do begin
    Power:= Power-1;
    Fraction:= Incr/Pow10(Power);
  end;
  if      Fraction< 2 then CalcIncr:=        Pow10(Power)
  else if Fraction< 5 then CalcIncr:=  2.0 * Pow10(Power)
  else if Fraction<10 then CalcIncr:=  5.0 * Pow10(Power)
  else                     CalcIncr:= 10.0 * Pow10(Power);
end;

procedure EngNot(Number: double; var Mantissa: double; var Exponent: longint); (**)
var
  tmp: double;
begin
  if Number=0.0 then begin
    Exponent:= 0;
    Mantissa:= 0.0;
  end
  else begin
    tmp:= Log10(abs(Number));
    Exponent:= trunc(tmp);
    if tmp < 0 then Exponent:= Exponent-1;
    while (Exponent mod 3)<>0 do Exponent:= Exponent-1;
    Mantissa:= Number/Pow10(Exponent);
  end;
end;

function NumDec(Num: double): integer; (**)
var
  Extra: double;
  Decimals: longint;
begin
  Decimals:= 0;
  Extra:= Num*Pow10(Decimals);
  while (Extra-trunc(Extra+Extra*(SMALL))) > (SMALL)*Extra do begin
    Decimals:= Decimals+1;
    Extra:= Num*Pow10(Decimals);
  end;
  NumDec:= Decimals;
end;

function Fattoriale(x: double): double;
var
  OldNum : double;
  OldVal : double;
  function InternalFattoriale(x: double): double;
  var
    temp : double;
    segno: integer;
    flg  : boolean;
  begin
    if x = OldNum then begin
      InternalFattoriale:= OldVal;
      exit;
    end;
    flg:= false;
    if x = 0 then begin
      temp:= 1;
    end
    else begin
      Segno:= Sgn(x);
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
    InternalFattoriale:= temp;
  end;
begin
  OldNum := 0;
  OldVal := 1;
  Fattoriale:= InternalFattoriale(x);
end;

function LGFattoriale(x: longint): longint;
var
  tmp: longint;
  i: longint;
begin
  tmp:= x;
  for i:= pred(x) downto 2 do tmp:= tmp * i;
  LGFattoriale:= tmp;
end;

function FSFattoriale(x: longint): double;
var
  i: longint;
  temp: extended;
begin
  temp := x;
  i:= pred(x);
  while (i > 1) do begin
    temp := temp * i;
    dec(i);
  end;
  FSFattoriale := temp;
end;

function ACFattoriale(x: longint): double;
var
  i: longint;
  temp: extended;
begin
  temp := ln(x);
  i:= pred(x);
  while (i > 1) do begin
    temp := temp + ln(i);
    dec(i);
  end;
  ACFattoriale := exp(temp);
end;

function LNFattoriale(x: longint): double;
var
  i: longint;
  temp: double;
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

function FSFattFrom(x: longint; StartNum: longint; StartVal: double): double;
var
  i: longint;
  temp: double;
begin
  temp := StartVal;
  i:= x;
  while (i > StartNum) do begin
    temp := temp * i;
    dec(i);
  end;
  FSFattFrom := temp;
end;

function ACFattFrom(x: longint; StartNum: longint; StartVal: double): double;
var
  i: longint;
  temp: double;
begin
  temp := ln(StartVal);
  i:= x;
  while (i > StartNum) do begin
    temp := temp + ln(i);
    dec(i);
  end;
  ACFattFrom := exp(temp);
end;

function FACT(n: integer): double;
{Returns n! for n >= 0.  Intentionally provokes zero-divide for n<0.}
var
  k: integer;
  ans: double;
begin
  if n < 0 then FACT := 0 / (n - n)
  else begin
    ans := 1.0;
    for k := 2 to n do ans := k * ans;
    FACT := ans;
  end;
end;

function GammaLN(xx: double): double;
const
  COF: array[1..6] of double =
      (76.18009173, -86.50532033, 24.01409822,
      -1.231739516, 0.120858003E-2, -0.536382E-5);
  STP : double = 2.50662827465;
var
  x, tmp, ser: double;
  j: integer;
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

function Gamma(x: double): double;
begin
  (* integrale(x^(r-1)*exp(-x), x, 0, inf) *)
  Gamma:= exp(GammaLN(x));
end;

function beta(z, w: double): double;
begin
  beta:= exp(GammaLN(z)+GammaLN(w)-GammaLN(z+w));
end;

function Min(a, b: double): double;
begin
  if a < b then Min:= a else Min:= b;
end;

function Max(a, b: double): double;
begin
  if a > b then Max:= a else Max:= b;
end;

function Sgn(x: double): integer;
begin
  if x < 0 then Sgn:= -1
  else if x > 0 then Sgn:= 1
  else Sgn:= 0;
end;

function ModestWholeNumber(X: extended): boolean;
{Returns true if X is a whole number in the range -maxint .. maxint.}
begin
  if abs(X) < maxint then ModestWholeNumber := X = trunc(X)
  else ModestWholeNumber := false
end;

function IPow(Base, Exp: integer): longint;
var
  i: integer;
  tmp: longint;
begin
  if base = 2 then begin IPow:= 1 shl Exp; exit; end;
  tmp:= 1; (* Att! se tmp:= base, for i:= 2 to ... con Exp = 0 da risulatot errato! *)
  for i:= 1 to Exp do tmp:= tmp * base;
  IPow:= tmp;
end;

function IntPow(Base: double;  NonNegInt: integer): double;
{Returns Base raised to the nonnegative integer power NonNegInt.}
begin
  if NonNegInt = 0 then IntPow := 1
  else if odd(NonNegInt) then IntPow := Base * IntPow(Base, NonNegInt - 1)
  else IntPow := sqr(IntPow(Base, NonNegInt div 2));
end;

function PowInt(X: double; t: integer): double;
var
  i, S: integer;
  tmp: double;
begin
  if t > 0 then s:= 1 else begin s:=-1; t:= -t; end;
  tmp:= 1;
  for i:= 1 to t do begin
    tmp:= tmp * X;
  end;
  if s=-1 then PowInt:= 1/tmp else PowInt:= tmp;
end;

function POW(Base, Exponent: double): double;
{Returns Base raised to the Exponent power.
  Prerequisite files: Evendouble.lib, IntPow.lib,}
begin
  if Exponent < 0.0 then POW := 1.0 / POW(Base, -Exponent)
  else if (Base = 1.0) or (Exponent = 0.0) then POW := 1.0
  {assuming POW(0.0, x) = 1.0}
  else if Base = 0.0 then POW := 0.0
  else if ModestWholeNumber(Exponent) and (abs(Exponent - int(Exponent)) <= Zero) then POW := IntPow(Base, trunc(Exponent))
  else POW := exp(Exponent * ln(Base));
end;

function ASIN(ratio: extended): extended;
{Returns the principal inverse sine in radians.}
begin
  ASIN := arctan(ratio / sqrt((1.0 - ratio) * (1.0 + ratio)));
end;

function ACOS(ratio: extended): extended;
{Returns the principal inverse cosine in radians.}
begin
  if ratio < -1 then ratio:= -1;
  if ratio >  1 then ratio:=  1;
  if abs(ratio) >= ZERO then ACOS := arctan(sqrt((1.0 - ratio) * (1.0 + ratio)) / ratio)
  else ACOS:= 0.5 * PI;
end;

function ATAN(ratio: extended): extended;
{Returns the principal arctangent of ratio in radians.}
begin
  ATAN := ARCTAN(ratio);
end;

function COT(angle: extended): extended;
{Returns the cotangent of angle, which is measured in radians.}
begin
  COT := COS(angle) / SIN(angle);
end;

{$IFDEF USE387}
  function Pow10(base: extended): extended; assembler;
  asm
     FLD   TBYTE PTR [base]
     INT   3Eh              { call shortcut interrupt }
     DW    90FEh            { signal Power of 10 wanted to shortcut handler}
  end;
{$ELSE}
function Pow10(base: extended): extended;
begin
  Pow10:= exp(ln(10)*Base);
end;
{$ENDIF}

{$IFDEF USE387}
  function Pow2(base: extended): extended; assembler;
  asm
    FLD   TBYTE PTR [base]
    INT   3Eh              { call shortcut interrupt }
    DW    90FCh            { signal Power of 2 wanted to shortcut handler }
  end;
{$ELSE}
  function Pow2(base: extended): extended;
  begin
    Pow2:= exp(ln(2)*Base);
  end;
{$ENDIF}

function WithSign(x, y : extended): extended;
(* ritorn x con il segno di y *)
begin
  if x > 0.0 then
    if y > 0.0 then WithSign:= x
    else WithSign:= -x
  else
    if y < 0.0 then WithSign:= x
    else WithSign:= -x;
end;

{ Converts a binary byte to hexidecimal format }
function HEX(B: byte): string;
var
  B1, B2: byte;
  C1, C2: char;
begin
  B1:=B and $F; B2:=(B and $F0) shr 4;
  if B1>9 then C1:=char(55+B1) else C1:=char(48+B1);
  if B2>9 then C2:=char(55+B2) else C2:=char(48+B2);
  HEX:= C2 + C1;
end;

function CoTan(X: extended): extended; assembler;
{ CoTan := Cos(X) / Sin(X) = 1 / Tan(X) }
asm
  FLD   X
  FPTAN
  FDIVRP
  FWAIT
end;

procedure PolyX(const A: array of Double; X: Extended; var Poly: TPoly);
{ Compute A[0] + A[1]*X + ... + A[N]*X**N and X * its derivative.
  Accumulate positive and negative terms separately. }
var
  I: Integer;
  Neg, Pos, DNeg, DPos: Extended;
begin
  Neg := 0.0;
  Pos := 0.0;
  DNeg := 0.0;
  DPos := 0.0;
  for I := Low(A) to High(A) do
  begin
    DNeg := X * DNeg + Neg;
    Neg := Neg * X;
    DPos := X * DPos + Pos;
    Pos := Pos * X;
    if A[I] >= 0.0 then Pos := Pos + A[I] else Neg := Neg + A[I]
  end;
  Poly.Neg := Neg;
  Poly.Pos := Pos;
  Poly.DNeg := DNeg * X;
  Poly.DPos := DPos * X;
end;

function RelSmall(X, Y: Extended): Boolean;
{ Returns True if X is small relative to Y }
const
  C1: Double = 1E-15;
  C2: Double = 1E-12;
begin
  RelSmall:= Abs(X) < (C1 + C2 * Abs(Y))
end;

{$IFDEF MATH}
function Power(x,y: double): double;
begin
  Power:= exp(ln(x)*y);
end;

{$IFDEF USE87}
function LnXP1(X: extended): extended; assembler;
{ Return ln(1 + X).  Accurate for X near 0. }
asm
  FLDLN2
  MOV     AX,WORD PTR X+8               { exponent }
  FLD     X
  CMP     AX,$3FFD                      { .4225 }
  JB      @@1
  FLD1
  FADD
  FYL2X
  JMP     @@2
@@1:
  FYL2XP1
@@2:
  FWAIT
end;
{$ELSE}
function LnXP1(X: extended): extended;
begin
  LnXP1:= ln(1+X);
end;
{$ENDIF}

{$IFDEF USE387}
  function Log10(Arg: extended): extended; assembler;
  asm
    FLD   TBYTE PTR [Arg]
    INT   3Eh              { call shortcut interrupt }
    DW    90F8h            { signal Log10 wanted to shortcut handler }
  end;
{$ELSE}
  function Log10(Arg: extended): extended;
  begin
    Log10:= ln(Arg)/ln(10);
  end;
{$ENDIF}

{$IFDEF USE387}
  function Log2(Arg: extended): extended; assembler;
  asm
    FLD   TBYTE PTR [Arg]
    INT   3Eh              { call shortcut interrupt }
    DW    90F6h            { signal Log2 wanted to shortcut handler }
  end;
{$ELSE}
  function Log2(Arg: extended): extended;
  begin
    Log2:= ln(Arg)/ln(10);
  end;
{$ENDIF}

{Returns the tangent of angle, which is measured in radians.}
function Tan(X: extended): extended; assembler;
{  Tan := Sin(X) / Cos(X) }
asm
  FLD    X
  FPTAN
  FSTP   ST(0)      { FPTAN pushes 1.0 after result }
  FWAIT
end;

function ArcCos(X: extended): extended;
begin
  ArcCos:= ArcTan2(Sqrt(1 - X*X), X);
end;

function ArcSin(X: extended): extended;
begin
  ArcSin:= ArcTan2(X, Sqrt(1 - X*X))
end;

{$IFDEF USE87}
function ArcTan2(Arg1, Arg2: extended): extended; assembler;
asm
  FLD     Arg1
  FLD     Arg2
  FPATAN
  FWAIT
end;
{$ELSE}
function ArcTan2(Arg1, Arg2: double): double;
begin
  ArcTan2:= ArcTan(Arg1/Arg2);
end;
{$ENDIF}

(* ritorna il seno iperbolico di Arg *)
(* sh(x) = [exp(x) - exp(-x)] / 2 *)
{$IFDEF USE387}
function Sinh(Arg: extended): extended; assembler;
(* metodo : z = exp(x), ch(x) = 1/2 (z - 1/z)
            z = 2^y, y = x.log2(e),
            z = 2^f.2^i, f = frac(y), i = int(y)
 2^f is computed with F2XM1, 2^i with FSCALE *)
const
  round_down : word = $177F;
  one_half : double = 0.5;
var
  control_ww : word;
asm                   { ST(0)     ST(1)     ST(2) }
  FLD Arg            {  x         -         -    }
  FLDL2E             { log2(e)    x         -    }
  FMULP ST(1), ST    { x.log2(e)  -         -    }
  FSTCW control_ww
  FLDCW round_down
  FLD ST(0)          {  y         y          -   }
  FRNDINT            { int(y)     y          -   }
  FLDCW control_ww
  FXCH               {  y         i          -   }
  FSUB ST, ST(1)     {  f         i          -   }
  F2XM1              { 2^f-1      i          -   }
  FLD1               {  1        2^f-1       i   }
  FADDP ST(1), ST    { 2^f        i          -   }
  FSCALE             { 2^f.2^i    i          -   }
  FST ST(1)          { e^x       e^x         -   }
  FLD1               {  1         z          z   }
  FDIVRP ST(1), ST   { 1/z        z          -   }
  FSUBP ST(1), ST    { z-1/z      -          -   }
  FLD one_half       { 0.5      z-1/z)       -   }
  FMULP ST(1), ST    { sh(x)      -          -   }
end;
{$ELSE}
function Sinh(Arg: double): double;
begin
  Arg := exp(Arg);
  SinH:= 0.5 * (Arg - (1.0 / Arg));
end;
{$ENDIF}

(* ritorna il coseno iperbolico di Arg *)
(* ch(x) = [exp(x) + exp(-x)] / 2 *)
{$IFDEF USE387}
function Cosh(Arg: extended): extended; assembler;
(* metodo : z = exp(x), ch(x) = 1/2 (z + 1/z)
          z = 2^y, y = x.log2(e),
          z = 2^f.2^i, f = frac(y), i = int(y)
2^f is computed with F2XM1, 2^i with FSCALE *)
const
  round_down : word = $177F;
  one_half : double = 0.5;
var
  control_ww : word;
asm                  { ST(0)     ST(1)     ST(2) }
  FLD Arg            {  x         -         -    }
  FLDL2E             { log2(e)    x         -    }
  FMULP ST(1), ST    { x.log2(e)  -         -    }
  FSTCW control_ww
  FLDCW round_down
  FLD ST(0)          {  z         z          -   }
  FRNDINT            { int(z)     z          -   }
  FLDCW control_ww
  FXCH               {  z         i          -   }
  FSUB ST, ST(1)     {  f         i          -   }
  F2XM1              { 2^f-1      i          -   }
  FLD1               {  1        2^f-1       i   }
  FADDP ST(1), ST    { 2^f        i          -   }
  FSCALE             { 2^f.2^i    i          -   }
  FST ST(1)          { e^x       e^x         -   }
  FLD1               {  1         z          z   }
  FDIVRP ST(1), ST   { 1/z        z          -   }
  FADDP ST(1), ST    { z+1/z      -          -   }
  FLD one_half       { 0.5       z+1/z       -   }
  FMULP ST(1), ST    { ch(x)      -          -   }
end;
{$ELSE}
function Cosh(Arg: double): double;
begin
  Arg := exp(Arg);
  CosH:= 0.5 * (Arg + 1.0 / Arg);
end;
{$ENDIF}

(* ritorna la tangente iperbolica di Arg *)
(* th(x) = sh(x) / ch(x) *)
(* th(x) = [exp(x) - exp(x)] / [exp(x) + exp(-x)] *)
{$IFDEF USE387}
(* metodo : z = exp(x), ch(x) = (z - 1/z) / (z + 1/z)
          z = 2^y, y = x.log2(e),
          z = 2^f.2^i, f = frac(y), i = int(y)
  2^f is computed with F2XM1, 2^i with FSCALE *)
function Tanh(Arg: extended): extended; assembler;
const
  round_down : word = $177F;
  one_half : double = 0.5;
var
  control_ww : word;
asm                  { ST(0)     ST(1)     ST(2) }
  FLD Arg            {  x         -         -    }
  FLDL2E             { log2(e)    x         -    }
  FMULP ST(1), ST    { x.log2(e)  -         -    }
  FSTCW control_ww
  FLDCW round_down
  FLD ST(0)          {  z         z          -   }
  FRNDINT            { int(z)     z          -   }
  FLDCW control_ww
  FXCH               {  z         i          -   }
  FSUB ST, ST(1)     {  f         i          -   }
  F2XM1              { 2^f-1      i          -   }
  FLD1               {  1        2^f-1       i   }
  FADDP ST(1), ST    { 2^f        i          -   }
  FSCALE             { 2^f.2^i    i          -   }
  FST ST(1)          { e^x       e^x         -   }
  FLD1               {  1         z          z   }
  FDIV  ST, ST(1)    { 1/z        z          z   }
  FSUB  ST(2), ST    { 1/z        z        z-1/z }
  FADDP ST(1), ST    { z+1/z    z-1/z        -   }
  FDIVP ST(1), ST    { th(x)      -          -   }
end;
{$ELSE}
function Tanh(Arg: double): double;
begin
  TanH := SinH(Arg) / CosH(Arg);
end;
{$ENDIF}

(* ritorna l'arcoseno iperbolico di Arg *)
(*                       _________   *)
(* arg sh(x) = ln ( x + V x.x + 1 )  *)
{$IFDEF USE387}
function ArcSinh(Arg: extended): extended; assembler;
asm                {  ST(0)         ST(1)          ST(2)  }
  FLDLN2           {  ln(2)          -              -     }
  FLD Arg            {   x            ln(2)           -     }
  FLD ST(0)        {   x             x             ln(2)  }
  FMUL ST(0), ST   {   x.x           x             ln(2)  }
  FLD1             {   1             x.x            x     }
  FADDP ST(1), ST  { x.x + 1         x             ln(2)  }
  FSQRT            { sqrt(x.x+1)     x             ln(2)  }
  FADDP ST(1), ST  { x + z          ln(2)           -     }
  FYL2X            { arg_sh(x)       -              -     }
end;
{$ELSE}
function ArcSinh(Arg: double): double;
begin
  ArcSinH:= ln(Arg + sqrt(sqr(Arg) - 1.0));
end;
{$ENDIF}

(* ritorna l'arcocoseno iperbolico di Arg *)
(*                       ________          *)
(* arg ch(x) = ln ( x + V x.x - 1 )  x >=1 *)
{$IFDEF USE387}
function ArcCosh(Arg: extended): extended; assembler;
asm                {  ST(0)         ST(1)          ST(2)  }
  FLDLN2           {  ln(2)          -              -     }
  FLD Arg          {   x            ln(2)           -     }
  FLD ST(0)        {   x             x             ln(2)  }
  FMUL ST(0), ST   {   x.x           x             ln(2)  }
  FLD1             {   1             x.x            x     }
  FSUBP ST(1), ST  { x.x - 1         x             ln(2)  }
  FSQRT            { sqrt(x2-1)      x             ln(2)  }
  FADDP ST(1), ST  { x + z          ln(2)           -     }
  FYL2X            { arg_ch(x)       -              -     }
end;
{$ELSE}
function ArcCosh(Arg: double): double;
begin
  ArcCosH:= ln(Arg + sqrt(sqr(Arg) + 1.0));
end;
{$ENDIF}

(* Ritorna l'arcotangente iperbolica di Arg *)
(* arg th(x) = 1/2 ln [ (1 + x) / (1 - x) *)
{$IFDEF USE387}
function ArcTanh(Arg: extended): extended; assembler;
asm                {  ST(0)         ST(1)          ST(2)  }
  FLDLN2           {  ln(2)          -              -     }
  FLD Arg          {   x            ln(2)           -     }
  FLD ST(0)        {   x             x             ln(2)  }
  FLD1             {   1             x              x     }
  FADDP ST(1), ST  { 1 + x           x             ln(2)  }
  FXCH             {   x            1 + x          ln(2)  }
  FLD1             {   1             x             1 + x  }
  FSUBRP ST(1), ST { 1 - x          1 + x          ln(2)  }
  FDIVP ST(1), ST  { 1+x/1-x        ln(2)           -     }
  FSQRT            {                ln(2)           -     }
  FYL2X            { ln(z)           -              -     }
end;
{$ELSE}
function ArcTanh(Arg: double): double;
begin
  ArcTanH:= WithSign(0.5 * ln((1.0 + Arg) / (1.0 - Arg)), Arg);
end;
{$ENDIF}

{$IFDEF USE87}
function Hypot(X, Y: extended): extended; assembler;
asm
  FLD     Y
  FABS
  FLD     X
  FABS
  FCOM
  FNSTSW  AX
  TEST    AH,$F
  JNZ      @@1       (* if ST > ST(1) then swap *)
  FXCH    ST(1)      (* put larger number in ST(1) *)
@@1:
  FLDZ
  FCOMP
  FNSTSW  AX
  TEST    AH,$4      (* if ST = 0, return ST(1) *)
  JZ      @@2
  FSTP    ST         (* eat ST(0) *)
  JMP     @@3
@@2:
  FDIV    ST,ST(1)   (* ST := ST / ST(1) *)
  FMUL    ST,ST      (* ST := ST * ST *)
  FLD1
  FADD               (* ST := ST + 1 *)
  FSQRT              (* ST := Sqrt(ST) *)
  FMUL               (* ST(1) := ST * ST(1); Pop ST *)
@@3:
  FWAIT
end;
{$ELSE}
function Hypot(X, Y: extended): extended;
{ formula: Sqrt(X*X + Y*Y)
  implemented as:  |Y|*Sqrt(1+Sqr(X/Y)), |X| < |Y| for greater doubleision }
var
  Temp: extended;
begin
  X := Abs(X);
  Y := Abs(Y);
  if X > Y then begin
    Temp := X;
    X := Y;
    Y := Temp;
  end;
  if X = 0 then Hypot:= Y
  else Hypot:= Y * Sqrt(1 + Sqr(X/Y)); (* Y > X, X <> 0, so Y > 0 *)
end;
{$ENDIF}

function Sign(R: double): double;
{returns -1 if R<0, 0 if R=0, or 1 if R>0.}
begin
  if R > 0.0 then SIGN := 1.0
  else if R < 0.0 then SIGN := -1.0
  else SIGN := 0.0;
end;

function Ceil(X: extended): longint;
var tmp: longint;
begin
  tmp:= Trunc(X);
  if tmp <> X then Inc(tmp);
  Ceil:= tmp;
end;

function Floor(X: extended): longint;
var tmp: longint;
begin
  tmp:= Trunc(X);
  if Frac(X) <> tmp then Dec(tmp);
  Floor:= tmp;
end;

function  Poly(X: extended; const Coefficients: array of double): extended;
{ Horner's method }
var
  I: Integer;
begin
  Result := Coefficients[High(Coefficients)];
  for I := High(Coefficients)-1 downto Low(Coefficients) do
    Result := Result * X + Coefficients[I];
end;

{$ENDIF}

end.

