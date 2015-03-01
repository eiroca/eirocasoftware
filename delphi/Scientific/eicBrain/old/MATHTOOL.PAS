(****************************************************************************)
unit MathTool;
(****************************************************************************)
(* This source code is copyrighted by Enrico Croce. This source code as a   *)
(* whole, or parts thereof, cannot be included or used in any kind of       *)
(* computer programs without the permission granted by the author.          *)
(* See LICENSE.TXT (or the other documentation) for the complete license    *)
(* agreement. All comments concerning the program may be sent to the author *)
(****************************************************************************)
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



type
  PPREC  = ^PREC;
  PDPREC = ^DPREC;
  PTInt  = ^TInt;
  PTDInt = ^TDInt;

  PAInteger = ^AInteger;
  AInteger = array[0..0] of TInt;

  PAPrec = ^APREC;
  APrec = array[0..0] of PREC;

  PADPrec = ^ADPREC;
  AdPrec = array[0..0] of DPREC;

(*
//@type PREC   | ? | Tipo precisione singola (real o double a seconda $N
//@type DPREC  | ? | Tipo precisione doppiaa (real o extended a seconda $N
//@type TInt   | integer | Tipo intero normale
//@type TDInt  | longint | Tipo intero lungo
//@type PPREC  | ^PREC  | Puntatore a precicione singola
//@type PDPREC | ^DPREC | Puntatore a precisione doppia
//@type PTInt  | ^TInt  | Puntatore a intero normale
//@type PTDInt | ^TDInt | Puntatore a intero lungo
*)

const
  ITMAX : TInt = 100;
  SMALL : PREC = 1E-6;
  BIG   : PREC = 1E+6;
  ZERO  : PREC = 1E-20;
  INF   : PREC = 1E+20;

  Rad2Deg   = 360 / (2*PI);
  Deg2Rad   = (2 * PI) / 360;
  Grad2Rad  = (PI / 200);
  Rad2Grad  = (200 / PI);
  Cycle2Rad = (2 * PI);
  Rad2Cycle = 1/(2 * PI);

(*
//@pconst ITMAX | TInt | 100   | Numero di iterazioni massime nei processi iterativi
//@pconst SMALL | PREC | 1E-6  | Numero assunto come piccolo
//@pconst BIG   | PREC | 1E+6  | Numero assunto come grande
//@pconst ZERO  | PREC | 1E-20 | Numero assumibile come Zero
//@pconst INF   | PREC | 1E+20 | Numero assumibile come Infinito
//@const  Rad2Deg | 180 / PI | Fattore di conversione Radianti -> Gradi
//@const  Deg2Rad | PI / 180 | Fattore di conversione Gradi -> Radianti
*)

function Equal(a, b: PREC): boolean; (*
//@func Equal | boolean | Ritorna true se abs(a-b) Š minore di abs(b)*Zero
// @parm | a | PREC | Primo elemento da confrontare
// @parm | b | PREC | Secondo elemento da confrontare (preso come riferimento)
//@comm ritorna vero se l'errore relativo di a rispetto a b e' minore di zero
//@ToDo Bisognerebbe portarla in assembler inline
*)
procedure SwapPrec(var x, y: PREC); (*
//@proc SwapPrec | Scambia x con y
// @parm var | x | PREC | Primo valore
// @parm var | y | PREC | Secondo valore
//@ToDo Sarebbe pi— opportuna una versione inline in assembler
*)
function MCD(a, b: TDInt): TDInt; (*
//@func MCD | TDInt | Minimo Comune Denominatore
// @parm | a | TDInt | Primo fattore
// @parm | b | TDInt | Secondo fattore
//@comm M.C.D. con il l'algoritmo di euclide. A, e B vengono presi in valore assoluto
*)
function RefrIndex(WaveNum: PREC): PREC; (*
//@func RefrIndex | PREC | Calculates refractive index of air according to Eblens formula
// @parm | WaveNum | PREC | Vacuum wavenumber
// @rdesc Refractive index in air
*)
function AmstToCm(WaveLength: PREC): PREC; (*
//@func AmstToCm | PREC | Converts wavelength in Angstroms in air to vacuum wavenumbers
// @parm | WaveLength | PREC | Wavelength in Angstroms (air).
// @rdesc Wavenumber in cm-1 (vacuum).
*)
function CmToAmst(WaveNum: PREC): PREC; (*
//@func CmToAmst | PREC | Converts wavenumbers to wavelength
// @parm | WaveNum | PREC | Vacuum wavenumber in cm^-1
// @rdesc Air wavelength in Angstroms.
*)
function CalcIncr(Incr: PREC): PREC; (*
//@func CalcIncr | PREC | Potenza 1, 2 o 5 piu' vicina
// @parm  | Incr | PREC | Incremento da approssimare (positivo)
// @comm Questa funzione restituisce la potenza di 1, 2, o 5 che sia
//minore o uguale a Incr, puo' essere usata per calcolare il numero
//arrotondato da dare agli intervalli delle etichette di un grafico.<nl>
//Incr deve essere un numero positivo.
*)
procedure EngNot(Number: PREC; var Mantissa: PREC; var Exponent: TDInt); (*
//@proc EngNot | Crea numero in notazione ingegneristica
// @parm     | Number   | PREC | Numero da trasformare
// @parm var | Mantissa | PREC | Valore calcolato della mantissa
// @parm var | Exponent | TDInt | Valore calcolato dell'esponente
// @comm Questa procedure calcola la notazione ingegneristica (Mantissa * 10^Exponent) del numero fornito
*)
function NumDec(Num: PREC): TInt; (*
//@func NumDec | TInt | Calcola quante sono le cifre di decimali significativi
// @parm | Num | PREC | Numero contenente le cifre decimali
//@comm la precisione e' fissata a SMALL
//@ex Pone 2 in A | A:= NumDec(0.01);
//@ex Pone 0 in A | A:= NumDec(1+SMALL);
*)


function Max(a, b: PREC): PREC;
function Min(a, b: PREC): PREC;

function Sgn(x: PREC): TInt;
function ASIN(ratio: DPREC): DPREC;
function ACOS(ratio: DPREC): DPREC;
function TAN(angle: DPREC): DPREC;
function ATAN(ratio: DPREC): DPREC;
function COT(angle: DPREC): DPREC;

function LnXP1(X: DPREC): DPREC;
function Log10(Arg: DPREC): DPREC;
function Pow10(Base: DPREC): DPREC;
function Log2(Arg: DPREC): DPREC;
function Pow2(Base: DPREC): DPREC;

function Sign(R: PREC): PREC;
function WithSign(x, y : DPREC): DPREC;

function HEX(B: byte): string;

function ArcCos(X: DPREC): DPREC;
function ArcSin(X: DPREC): DPREC;


type
  TPoly = record
    Neg, Pos, DNeg, DPos: DPREC;
  end;


procedure PolyX(const A: array of PREC; X: DPREC; var Poly: TPoly);
function  RelSmall(X, Y: DPREC): Boolean;
function  Ceil(X: DPREC): TDInt;
function  Floor(X: DPREC): TDInt;
function  Poly(X: DPREC; const Coefficients: array of PREC): DPREC;

implementation

uses
  Math;

function Equal(a,b: PREC): boolean; (**)
begin
  if abs(a - b) > abs(b) * Zero then Equal:= false else Equal:= true;
end;

procedure SwapPrec(var x, y: PREC); (**)
var z: PREC;
begin
  z:= x; x:= y; y:= z;
end;

function MCD(a, b: TDInt): TDInt; (**)
var
  R: TDInt;
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

function RefrIndex(WaveNum: PREC): PREC; (**)
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
var CM: PREC;
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

function CalcIncr(Incr: PREC): PREC; (**)
var
  Power: TDInt;
  Fraction: PREC;
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

procedure EngNot(Number: PREC; var Mantissa: PREC; var Exponent: TDInt); (**)
var
  tmp: PREC;
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

function NumDec(Num: PREC): TInt; (**)
var
  Extra: PREC;
  Decimals: TDInt;
begin
  Decimals:= 0;
  Extra:= Num*Pow10(Decimals);
  while (Extra-trunc(Extra+Extra*(SMALL))) > (SMALL)*Extra do begin
    Decimals:= Decimals+1;
    Extra:= Num*Pow10(Decimals);
  end;
  NumDec:= Decimals;
end;

function Min(a, b: PREC): PREC;
begin
  if a < b then Min:= a else Min:= b;
end;

function Max(a, b: PREC): PREC;
begin
  if a > b then Max:= a else Max:= b;
end;

function Sgn(x: PREC): TInt;
begin
  if x < 0 then Sgn:= -1
  else if x > 0 then Sgn:= 1
  else Sgn:= 0;
end;

function ASIN(ratio: DPREC): DPREC;
{Returns the principal inverse sine in radians.}
begin
  ASIN := arctan(ratio / sqrt((1.0 - ratio) * (1.0 + ratio)));
end;

function ACOS(ratio: DPREC): DPREC;
{Returns the principal inverse cosine in radians.}
begin
  if ratio < -1 then ratio:= -1;
  if ratio >  1 then ratio:=  1;
  if abs(ratio) >= ZERO then ACOS := arctan(sqrt((1.0 - ratio) * (1.0 + ratio)) / ratio)
  else ACOS:= 0.5 * PI;
end;

function ATAN(ratio: DPREC): DPREC;
{Returns the principal arctangent of ratio in radians.}
begin
  ATAN := ARCTAN(ratio);
end;

{Returns the tangent of angle, which is measured in radians.}
{$IFDEF USE387}
  {$IFDEF WINDOWS}
  function Tan (Angle: DPREC): DPREC; assembler;
  asm
    FLD   TBYTE PTR [Angle]
    CALL  __F87_TANGENT
  end;
  {$ELSE}
    function Tan (Angle: DPREC): DPREC; assembler;
    asm
      FLD   TBYTE PTR [Angle]
      INT   3Eh              { call shortcut interrupt }
      DW    90F0h            { signal Tan wanted to shortcut handler }
    end;
  {$ENDIF}
{$ELSE}
  function TAN(angle: DPREC): DPREC;
  begin
    TAN:= SIN(angle) / COS(angle);
  end;
{$ENDIF}

function MyTan(X: DPREC): DPREC; assembler;
{  Tan := Sin(X) / Cos(X) }
asm
  FLD    X
  FPTAN
  FSTP   ST(0)      { FPTAN pushes 1.0 after result }
  FWAIT
end;


function COT(angle: DPREC): DPREC;
{Returns the cotangent of angle, which is measured in radians.}
begin
  COT := COS(angle) / SIN(angle);
end;

{$IFDEF USE387}
  {$IFDEF WINDOWS}
  function Log10(Arg: DPREC): DPREC; assembler;
  asm
    FLD   TBYTE PTR [Arg]
    CALL  __F87_LOG10;
  end;
  {$ELSE}
  function Log10(Arg: DPREC): DPREC; assembler;
  asm
    FLD   TBYTE PTR [Arg]
    INT   3Eh              { call shortcut interrupt }
    DW    90F8h            { signal Log10 wanted to shortcut handler }
  end;
  {$ENDIF}
{$ELSE}
  function Log10(Arg: DPREC): DPREC;
  begin
    Log10:= ln(Arg)/ln(10);
  end;
{$ENDIF}

{$IFDEF USE387}
  {$IFDEF WINDOWS}
  function Log2(Arg: DPREC): DPREC; assembler;
  asm
    FLD   TBYTE PTR [Arg]
    CALL  __F87_Log2;
  end;
  {$ELSE}
  function Log2(Arg: DPREC): DPREC; assembler;
  asm
    FLD   TBYTE PTR [Arg]
    INT   3Eh              { call shortcut interrupt }
    DW    90F6h            { signal Log2 wanted to shortcut handler }
  end;
  {$ENDIF}
{$ELSE}
  function Log2(Arg: DPREC): DPREC;
  begin
    Log2:= ln(Arg)/ln(10);
  end;
{$ENDIF}

{$IFDEF USE387}
  {$IFDEF WINDOWS}
  function Pow10(base: DPREC): DPREC; assembler;
  asm
    FLD   TBYTE PTR [base]
    CALL  __F87_EXP10;
  end;
  {$ELSE}
  function Pow10(base: DPREC): DPREC; assembler;
  asm
     FLD   TBYTE PTR [base]
     INT   3Eh              { call shortcut interrupt }
     DW    90FEh            { signal Power of 10 wanted to shortcut handler}
  end;
  {$ENDIF}
{$ELSE}
function Pow10(base: DPREC): DPREC;
begin
  Pow10:= exp(ln(10)*Base);
end;
{$ENDIF}

{$IFDEF USE387}
  {$IFDEF WINDOWS}
  function Pow2(base: DPREC): DPREC; assembler;
  asm
    FLD   TBYTE PTR [base]
    CALL  __F87_EXP2;
  end;
  {$ELSE}
  function Pow2(base: DPREC): DPREC; assembler;
  asm
    FLD   TBYTE PTR [base]
    INT   3Eh              { call shortcut interrupt }
    DW    90FCh            { signal Power of 2 wanted to shortcut handler }
  end;
  {$ENDIF}
{$ELSE}
  function Pow2(base: DPREC): DPREC;
  begin
    Pow2:= exp(ln(2)*Base);
  end;
{$ENDIF}

function SIGN(R: PREC): PREC;
{returns -1 if R<0, 0 if R=0, or 1 if R>0.}
begin
  if R > 0.0 then SIGN := 1.0
  else if R < 0.0 then SIGN := -1.0
  else SIGN := 0.0;
end;

function WithSign(x, y : DPREC): DPREC;
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






function LnXP1(X: DPREC): DPREC;
begin
  LnXP1:= ln(1+X);
end;

function ArcCos(X: DPREC): DPREC;
begin
  ArcCos:= ArcTan2(Sqrt(1 - X*X), X);
end;

function ArcSin(X: DPREC): DPREC;
begin
  ArcSin:= ArcTan2(X, Sqrt(1 - X*X))
end;

function CoTan(X: DPREC): DPREC; assembler;
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

function Ceil(X: DPREC): TDInt;
var tmp: TDInt;
begin
  tmp:= Trunc(X);
  if tmp <> X then Inc(tmp);
  Ceil:= tmp;
end;

function Floor(X: DPREC): TDInt;
var tmp: TDInt;
begin
  tmp:= Trunc(X);
  if Frac(X) <> tmp then Dec(tmp);
  Floor:= tmp;
end;

{$IFDEF USE87}
function Hypot(X, Y: DPREC): DPREC;
{ formula: Sqrt(X*X + Y*Y)
  implemented as:  |Y|*Sqrt(1+Sqr(X/Y)), |X| < |Y| for greater precision }
var
  Temp: DPREC;
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
{$ELSE}
function Hypot(X, Y: DPREC): DPREC; assembler;
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
{$ENDIF}

function  Poly(X: DPREC; const Coefficients: array of PREC): DPREC;
{ Horner's method }
var
  I: Integer;
begin
  Result := Coefficients[High(Coefficients)];
  for I := High(Coefficients)-1 downto Low(Coefficients) do begin
    Result := Result * X + Coefficients[I];
  end;
end;

end.
