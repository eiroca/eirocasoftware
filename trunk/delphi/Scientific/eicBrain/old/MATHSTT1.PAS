unit MathStt1;

interface

{$I switches.inc}

uses HDError, MathTool, MathTls3, MathStat;

{$IFOPT R+}
  {$DEFINE RP}
{$ENDIF}

(****************************************************************************)
(* DISTRIBUZIONI DI PROBABILITA' DISCRETE                                   *)
(****************************************************************************)

function  DUniformfDis(x: TInt; N: TInt): PREC;
function  DUniformFCum(x: TInt; N: TInt): PREC;
function  DUniformXVal(p: PREC; N: TInt): TInt;
function  DUniformRandom(N: TInt): TInt;
procedure DUniformNextFCum(var X: TInt; var CalcFCum: PREC; n: TInt);
procedure DUniformNextfDis(var X: TInt; var CalcfDis: PREC; n: TInt);
function  DUniformMean(N: TInt): PREC;
function  DUniformVariance(N: TInt): PREC;

function  BernullifDis(x: TInt; pr: PREC): PREC;
function  BernulliFCum(x: TInt; pr: PREC): PREC;
function  BernulliXVal(p: PREC; pr: PREC): TInt;
function  BernulliRandom(pr: PREC): TInt;
procedure BernulliNextfDis(var X: TInt; var CalcfDis: PREC; pr: PREC);
procedure BernulliNextFCum(var X: TInt; var CalcFCum: PREC; pr: PREC);
function  BernulliMean(pr: PREC): PREC;
function  BernulliVariance(pr: PREC): PREC;

function  BinomialfDis(x: TInt; n: TInt; pr: PREC): PREC;
function  BinomialFCum(x: TInt; n: TInt; pr: PREC): PREC;
function  BinomialXVal(p: PREC; nn: TInt; pr: PREC): TInt;
function  BinomialRandom(n: TInt; pr: PREC): TInt;
procedure BinomialNextfDis(var X: TInt; var CalcfDis: PREC; n: TInt; pr: PREC);
procedure BinomialNextFCum(var X: TInt; var CalcFCum: PREC; n: TInt; pr: PREC);
function  BinomialMean(n: TInt; pr: PREC): PREC;
function  BinomialVariance(n: TInt; pr: PREC): PREC;

function  IperGeomfDis(x: TInt; M, K, n: TInt): PREC;
function  IperGeomFCum(x: TInt; M, K, n: TInt): PREC;
function  IperGeomXVal(p: PREC; MM, KK, nn: TInt): TInt;
function  IperGeomRandom(M, K, n: TInt): TInt;
procedure IperGeomNextfDis(var X: TInt; var CalcfDis: PREC; M, K, n: TInt);
procedure IperGeomNextFCum(var X: TInt; var CalcFCum: PREC; M, K, n: TInt);
function  IperGeomMean(M, K, n: TInt): PREC;
function  IperGeomVariance(M, K, n: TInt): PREC;

function  PoissonfDis(x: TInt; lambda: PREC): PREC;
function  PoissonFCum(x: TInt; lambda: PREC): PREC;
function  PoissonXVal(p: PREC; lambda: PREC): TInt;
function  PoissonRandom(lambda: PREC): TInt;
procedure PoissonNextfDis(var X: TInt; var CalcfDis: PREC; lambda: PREC);
procedure PoissonNextFCum(var X: TInt; var CalcFCum: PREC; lambda: PREC);
function  PoissonMean(lambda: PREC): PREC;
function  PoissonVariance(lambda: PREC): PREC;

function  GeometricfDis(x: TInt; pr: PREC): PREC;
function  GeometricFCum(x: TInt; pr: PREC): PREC;
function  GeometricXVal(p: PREC; pr: PREC): TInt;
function  GeometricRandom(pr: PREC): TInt;
procedure GeometricNextfDis(var X: TInt; var CalcfDis: PREC; pr: PREC);
procedure GeometricNextFCum(var X: TInt; var CalcFCum: PREC; pr: PREC);
function  GeometricMean(pr: PREC): PREC;
function  GeometricVariance(pr: PREC): PREC;

function  BinNegfDis(x: TInt; r: TInt; pr: PREC): PREC;
function  BinNegFCum(x: TInt; r: TInt; pr: PREC): PREC;
function  BinNegXVal(p: PREC; r: TInt; pr: PREC): TInt;
function  BinNegRandom(r: TInt; pr: PREC): TInt;
procedure BinNegNextfDis(var X: TInt; var CalcfDis: PREC; r: TInt; pr: PREC);
procedure BinNegNextFCum(var X: TInt; var CalcFCum: PREC; r: TInt; pr: PREC);
function  BinNegMean(r: TInt; pr: PREC): PREC;
function  BinNegVariance(r: TInt; pr: PREC): PREC;

function  DicefDis(x: TInt; Fac, Num: TInt): PREC;
function  DiceFCum(x: TInt; Fac, Num: TInt): PREC;
function  DiceXVal(p: PREC; Fac, Num: TInt): TInt;
function  DiceRandom(Fac, Num: TInt): TInt;
procedure DiceNextfDis(var X: TInt; var CalcfDis: PREC; Fac, Num: TInt);
procedure DiceNextFCum(var X: TInt; var CalcFCum: PREC; Fac, Num: TInt);
function  DiceMean(Fac, Num: TInt): PREC;
function  DiceVariance(Fac, Num: TInt): PREC;

(****************************************************************************)
(* DISTRIBUZIONI DI PROBABILITA' CONTINUE                                   *)
(****************************************************************************)

function CUniformfDis(x, a, b: PREC): PREC;
function CUniformFCum(x, a, b: PREC): PREC;
function CUniformXVal(p, a, b: PREC): PREC;
function CUniformRandom(a, b: PREC): PREC;
function CUniformMean(a, b: PREC): PREC;
function CUniformVariance(a, b: PREC): PREC;

function NormalfDis(x: PREC): PREC;
function NormalFCum(x: PREC): PREC;
function NormalXVal(P: PREC): PREC;
function NormalRandom: PREC;
function NormalMean: PREC;
function NormalVariance: PREC;

function NormalefDis(x, Media, Scarto: PREC): PREC;
function NormaleFCum(x, Media, Scarto: PREC): PREC;
function NormaleXVal(p, Media, Scarto: PREC): PREC;
function NormaleRandom(Media, Scarto: PREC): PREC;
function NormaleMean(Media, Scarto: PREC): PREC;
function NormaleVariance(Media, Scarto: PREC): PREC;

function LogNorfDis(x, mu, sigma: PREC): PREC; (* alpha, beta >= 0 *)
function LogNorFCum(x, mu, sigma: PREC): PREC;
function LogNorXVal(p, mu, sigma: PREC): PREC;
function LogNorRandom(mu, sigma: PREC): PREC;
function LogNorMean(mu, sigma: PREC): PREC;
function LogNorVariance(mu, sigma: PREC): PREC;

function ExpfDis(x, lambda : PREC): PREC;
function ExpFCum(x, lambda : PREC): PREC;
function ExpXVal(p, lambda : PREC): PREC;
function ExpRandom(lambda : PREC): PREC;
function ExpMean(lambda: PREC): PREC;
function ExpVariance(lambda: PREC): PREC;

function GammafDis(x, r, lambda: PREC): PREC; (* r, lambda >= 0 *)
function GammaFCum(x, r, lambda: PREC): PREC;
function GammaXVal(p, r, lambda: PREC): PREC;
function GammaRandom(r, lambda: PREC): PREC;
function GammaMean(r, lambda: PREC): PREC;
function GammaVariance(r, lambda: PREC): PREC;

function WeibullfDis(x, alpha, beta: PREC): PREC; (* alpha, beta >= 0 *)
function WeibullFCum(x, alpha, beta: PREC): PREC; (* alpha, beta >= 0 *)
function WeibullXVal(p, alpha, beta: PREC): PREC;
function WeibullRandom(alpha, beta: PREC): PREC;
function WeibullMean(alpha, beta: PREC): PREC;
function WeibullVariance(alpha, beta: PREC): PREC;

function BetafDis(x, alpha, beta: PREC): PREC; (* alpha, beta >= 0 *)
function BetaFCum(x, alpha, beta: PREC): PREC;
function BetaXVal(p, alpha, beta: PREC): PREC;
function BetaRandom(alpha, beta: PREC): PREC;
function BetaMean(alpha, beta: PREC): PREC;
function BetaVariance(alpha, beta: PREC): PREC;

function TStudentfDis(x: PREC; d: PREC): PREC;
function TStudentFCum(x: PREC; d: PREC): PREC;
function TStudentXVal(p: PREC; d: PREC): PREC;
function TStudentRandom(d: PREC): PREC;
function TStudentMean(d: PREC): PREC;
function TStudentVariance(d: PREC): PREC;

function ChiQuadfDis(x: PREC; v: PREC): PREC;
function ChiQuadFCum(x: PREC; v: PREC): PREC;
function ChiQuadXVal(p: PREC; v: PREC): PREC;
function ChiQuadRandom(v: PREC): PREC;
function ChiQuadMean(v: PREC): PREC;
function ChiQuadVariance(v: PREC): PREC;

function FisherfDis(x: PREC; df1, df2: PREC): PREC;
function FisherFCum(x: PREC; df1, df2: PREC): PREC;
function FisherXVal(p: PREC; df1, df2: PREC): PREC;
function FisherRandom(df1, df2: PREC): PREC;
function FisherMean(df1, df2: PREC): PREC;
function FisherVariance(df1, df2: PREC): PREC;

implementation

(* Da PS *)
function NorBigNum(x: PREC): PREC; forward; (* Calcola funzione normale x > 1.8 *)
function NorSmallNum(x: PREC): PREC; forward; (* Calcola funzione normale x <= 1.8 *)

(****************************************************************************)
(* DISTRIBUZIONI DI PROBABILITA' DISCRETE                                   *)
(****************************************************************************)

(* Distribuzione Uniforme *)
function DUniformfDis(x: TInt; n: TInt): PREC;
begin
  if (x > 0) and (x <= N) then DUniformfDis:= 1 / n
  else DUniformfDis:= 0;
end;

function DUniformFCum(x: TInt; n: TInt): PREC;
begin
  if (x < 1) then DUniformFCum:= 0
  else if (x <= N) then DUniformFCum:= x / n
  else DUniformFCum:= 1;
end;

function DUniformXVal(p: PREC; N: TInt): TInt;
begin
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  DUniformXVal:= trunc(n * p);
end;

function DUniformRandom(N: TInt): Tint;
begin
  DUniformRandom:= succ(System.Random(n));
end;

procedure DUniformNextfDis(var X: TInt; var CalcfDis: PREC; n: TInt);
begin
  inc(X);
  if (X > N) or (X < 1) then CalcfDis:= 0;
end;

procedure DUniformNextFCum(var X: TInt; var CalcFCum: PREC; n: TInt);
begin
  inc(X);
  if CalcFCum < CERT then CalcFCum:= CalcFCum + 1/N;
end;

function DUniformMean(N: TInt): PREC;
begin
  DUniformMean:= 0.5 * succ(N);
end;

function DUniformVariance(N: TInt): PREC;
begin
  DUniformVariance:= pred(sqr(N))/12;
end;

(* funzione generatrice dei momenti *)
(* E[exp(tx)] = sum(exp(jt), j, 1, N) / N *)

(* Distribuzione di Bernulli *)
function BernullifDis(x: TInt; pr: PREC): PREC;
begin
  case x of
    0: BernullifDis:= (1-pr);
    1: BernullifDis:= pr;
    else BernullifDis:= 0;
  end;
end;

function BernulliFCum(x: TInt; pr: PREC): PREC;
begin
  if x < 0 then BernulliFCum := 0
  else if x < 1 then BernulliFCum := pr
  else BernulliFCum := 1;
end;

function BernulliXVal(p: PREC; pr: PREC): TInt;
begin
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  if p < (1-pr) then BernulliXVal:= 0
  else BernulliXVal:= 1;
end;

function BernulliRandom(pr: PREC): TInt;
begin
  if random >= pr then BernulliRandom:= 0 else BernulliRandom:= 1;
end;

procedure BernulliNextfDis(var X: TInt; var CalcfDis: PREC; pr: PREC);
begin
  inc(X);
  CalcfDis:= BernullifDis(x, pr);
end;

procedure BernulliNextFCum(var X: TInt; var CalcFCum: PREC; pr: PREC);
begin
  inc(X);
  CalcFCum:= BernulliFCum(x, pr);
end;

function BernulliMean(pr: PREC): PREC;
begin
  BernulliMean:= pr;
end;

function BernulliVariance(pr: PREC): PREC;
begin
  BernulliVariance:= pr*(1-pr);
end;

(* Funzione generatrice dei momenti *)
(* E[exp(tx)] = (1-p) + p*exp(t) *)

(* Distribuzione Binomiale *)
(* Approssimabile non la distribuzione di Poisson se (n >= 20 e p <= 0.05) o
   almeno (n >= 100 e np <= 10) in questi casi lambda:= n*p *)
(* Approssimabile con la distribuzione Normale con
    mu = n*p, sigma = sqrt(n*p*(1-p)) a patto che n sia grande (n > 30) e i
    valori interessati siano compressi in un intervallo sigma dal valor medio *)

function BinomialfDis(x: TInt; n: TInt; pr: PREC): PREC;
begin
  BinomialfDis:= exp(ln(Combinazioni(n,x)) + X * ln(pr) + (N - X) * ln(1 - pr));
end;

function BinomialFCum(x: TInt; n: TInt; pr: PREC): PREC;
var
  temp: PREC;
  i: longint;
begin
  temp:= 0;
  for i:= 0 to x do begin
    temp:= temp + BinomialfDis(i, n, pr);
    if temp > CERT then break;
  end;
  BinomialFCum:= temp;
end;

function BinomialXVal(p: PREC; nn: TInt; pr: PREC): TInt;
var
  x0, x1, x: TInt;
  y0, y1, y: PREC;
  n: integer;
begin
  (* Ricerca 0 con metodo bisezione *)
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  x0:= -1; x1:= nn;
  y0:= BinomialFCum(x0, nn, pr) - p; y1:= BinomialFCum(x1, nn, pr) - p;
  if (y0 * y1 > 0) then ErrorHandler('', ERR_NOCONVERGE);
  repeat
    x := (x1 + x0) shr 1;
    y := BinomialFCum(x, nn, pr) - p;
    if y > 0 then begin
      y1:= y;
      x1:= x;
    end
    else begin
      y0:= y;
      x0:= x;
    end;
  until abs(x1-x0) <= 1;
  if abs(y1) < abs (y0) then BinomialXVal:= x1 else BinomialXVal:= x0;
end;

function BinomialRandom(n: TInt; pr: PREC): TInt;
begin
  BinomialRandom:= BinomialXVal(Random, n, pr);
end;

procedure BinomialNextfDis(var X: TInt; var CalcfDis: PREC; n: TInt; pr: PREC);
begin
  inc(X);
  if x < 0  then CalcfDis:= 0
  else if x = 0 then CalcfDis:= exp(n * ln(1-pr))
  else if x <= n then CalcfDis:= CalcfDis * (n - pred(x)) * pr / (x*(1-pr))
  else CalcfDis:= 0;
end;

procedure BinomialNextFCum(var X: TInt; var CalcFCum: PREC; n: TInt; pr: PREC);
begin
  inc(x);
  CalcFCum:= CalcFCum + BinomialfDis(x, n, pr);
end;

function BinomialMean(n: TInt; pr: PREC): PREC;
begin
  BinomialMean:= n * pr;
end;

function BinomialVariance(n: TInt; pr: PREC): PREC;
begin
  BinomialVariance:= n * pr * (1-pr);
end;

(* funzione generatrice dei momenti  *)
(* E[exp(tx)] = ((1-pr) + pr*exp(t))^n *)

(* Distribuzione ipergeometrica *)
(* Approssimabile con la binomiale se M/n >= 10, p:= K/M *)
function IperGeomfDis(x: TInt; M, K, n: TInt): PREC;
begin
  IperGeomfDis:= exp(ln(Combinazioni(K, x)) + ln(Combinazioni(M-K, n-x)) - ln(Combinazioni(M, n)));
end;

function IperGeomFCum(x: TInt; M, K, n: TInt): PREC;
var
  temp: PREC;
  i: TInt;
begin
  temp:= 0;
  for i:= 0 to x do begin
    temp:= temp + IperGeomfDis(i, M, K, n);
    if temp > CERT then break;
  end;
  IperGeomFCum:= temp;
end;

function IperGeomXVal(p: PREC; MM, KK, nn: TInt): TInt;
var
  x0, x1, x: TInt;
  y0, y1, y: PREC;
  n: integer;
begin
  (* Ricerca 0 con metodo bisezione *)
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  x0:= -1; x1:= nn;
  y0:= IperGeomFCum(x0, MM, KK, nn) - p; y1:= IperGeomFCum(x1, MM, KK, nn) - p;
  if (y0 * y1 > 0) then ErrorHandler('', ERR_NOCONVERGE);
  repeat
    x := (x1 + x0) shr 1;
    y := IperGeomFCum(x, MM, KK, nn) - p;
    if y > 0 then begin
      y1:= y;
      x1:= x;
    end
    else begin
      y0:= y;
      x0:= x;
    end;
  until abs(x1 - x0) <= 1;
  if abs(y1) < abs(y0) then IperGeomXVal:= x1 else IperGeomXVal:= x0;
end;

function IperGeomRandom(M, K, n: TInt): TInt;
begin
  IperGeomRandom:= IperGeomXVal(Random, M, K, n);
end;

procedure IperGeomNextfDis(var X: TInt; var CalcfDis: PREC; M, K, n: TInt);
begin
  inc(X);
  if x < 0  then CalcfDis:= 0
  else if x = 0 then CalcfDis:= IperGeomfDis(0, M, K, n)
  else if x <= n then CalcfDis:= CalcfDis * (n - pred(x)) * (M - x) / (x * (M-K-n+x))
  else CalcfDis:= 0;
end;

procedure IperGeomNextFCum(var X: TInt; var CalcFCum: PREC; M, K, n: TInt);
begin
  inc(x);
  CalcFCum:= CalcFCum + IperGeomfDis(x, M, K, n);
end;

function IperGeomMean(M, K, n: TInt): PREC;
begin
  IperGeomMean := n * K / M;
end;

function IperGeomVariance(M, K, n: TInt): PREC;
begin
  IperGeomVariance:= n * K * (M - K) * (M - n) / (sqr(M) * pred(M));
end;

(* Distribuzione di Poisson *)
function PoissonfDis(x: TInt; lambda: PREC): PREC;
begin
  PoissonfDis:= exp(-lambda + X * ln(lambda) - LnFattoriale(x));
end;

function PoissonFCum(x: TInt; lambda: PREC): PREC;
var
  temp: PREC;
  i: TInt;
begin
  temp:= 0;
  for i:= 0 to x do begin
    temp:= temp + PoissonfDis(i, lambda);
    if temp > CERT then break;
  end;
  PoissonFCum:= temp;
end;

function PoissonXVal(p: PREC; lambda: PREC): TInt;
var
  x0, x1, x: TInt;
  y0, y1, y: PREC;
  n: integer;
begin
  (* Ricerca 0 con metodo bisezione *)
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  x0:= 0; x1:=MaxInt;
  y0:= PoissonFCum(x0, lambda) - p; y1:= PoissonFCum(x1, lambda) - p;
  if (y0 * y1 > 0) then ErrorHandler('', ERR_NOCONVERGE);
  repeat
    x := (x1 + x0) shr 1;
    y := PoissonFCum(x, lambda) - p;
    if y > 0 then begin
      y1:= y;
      x1:= x;
    end
    else begin
      y0:= y;
      x0:= x;
    end;
  until abs(x1 - x0) <= 1;
  if abs(y1) < abs(y0) then PoissonXVal:= x1 else PoissonXVal:= x0;
end;

function PoissonRandom(lambda: PREC): TInt;
begin
  PoissonRandom:= PoissonXVal(Random, lambda);
end;

procedure PoissonNextfDis(var X: TInt; var CalcfDis: PREC; lambda: PREC);
begin
  inc(X);
  if x < 0  then CalcfDis:= 0
  else if x = 0 then CalcfDis:= exp(-lambda)
  else CalcfDis:= CalcfDis * lambda / x;
end;

procedure PoissonNextFCum(var X: TInt; var CalcFCum: PREC; lambda: PREC);
begin
  inc(x);
  CalcFCum:= CalcFCum + PoissonfDis(x, lambda);
end;

function PoissonMean(lambda: PREC): PREC;
begin
  PoissonMean:= lambda;
end;

function PoissonVariance(lambda: PREC): PREC;
begin
  PoissonVariance:= lambda;
end;

(* Funzione generatrice dei momenti *)
(* m(t) = exp(lambda*(exp(t)-1)) *)

(* Distribuzioe Geometrica *)
function GeometricfDis(x: TInt; pr: PREC): PREC;
begin
  GeometricfDis:= pr * IntPow(1-pr, x);
end;

function GeometricFCum(x: TInt; pr: PREC): PREC;
var
  temp: PREC;
  i: TInt;
begin
  temp:= 0;
  for i:= 0 to x do begin
    temp:= temp + GeometricfDis(i, pr);
    if temp > CERT then break;
  end;
  GeometricFCum:= temp;
end;

function GeometricXVal(p: PREC; pr: PREC): TInt;
var
  x0, x1, x: TInt;
  y0, y1, y: PREC;
  n: integer;
begin
  (* Ricerca 0 con metodo bisezione *)
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  x0:= -1; x1:=MaxInt;
  y0:= GeometricFCum(x0, pr) - p; y1:= GeometricFCum(x1, pr) - p;
  if (y0 * y1 > 0) then ErrorHandler('', ERR_NOCONVERGE);
  repeat
    x := (x1 + x0) shr 1;
    y := GeometricFCum(x, pr) - p;
    if y > 0 then begin
      y1:= y;
      x1:= x;
    end
    else begin
      y0:= y;
      x0:= x;
    end;
  until abs(x1 - x0) <= 1;
  if abs(y1) < abs(y0) then GeometricXVal:= x1 else GeometricXVal:= x0;
end;

function GeometricRandom(pr: PREC): TInt;
begin
  GeometricRandom:= GeometricXVal(Random, pr);
end;

procedure GeometricNextfDis(var X: TInt; var CalcfDis: PREC; pr: PREC);
begin
  inc(X);
  if x < 0  then CalcfDis:= 0
  else if x = 0 then CalcfDis:= pr
  else CalcfDis:= CalcfDis * (1-pr);
end;

procedure GeometricNextFCum(var X: TInt; var CalcFCum: PREC; pr: PREC);
begin
  inc(x);
  CalcFCum:= CalcFCum + GeometricfDis(x, pr);
end;

function GeometricMean(pr: PREC): PREC;
begin
  GeometricMean:= (1-pr) / pr;
end;

function GeometricVariance(pr: PREC): PREC;
begin
  GeometricVariance:= (1-pr) / (sqr(pr));
end;

(* funzione generatrice dei momenti m(t) = pr / (1- (1-pr) * exp(t)) *)

(* Distribuzione binomiale negativa *)
function BinNegfDis(x: TInt; r: TInt; pr: PREC): PREC;
begin
  BinNegfDis:= Combinazioni(r+pred(x),x) * IntPow(pr, r) * IntPow(1-pr, x);
end;

function BinNegFCum(x: TInt; r: TInt; pr: PREC): PREC;
var
  temp: PREC;
  i: TInt;
begin
  temp:= 0;
  for i:= 0 to x do begin
    temp:= temp + BinNegfDis(i, r, pr);
    if temp > CERT then break;
  end;
  BinNegFCum:= temp;
end;

function BinNegXVal(p: PREC; r: TInt; pr: PREC): TInt;
var
  x0, x1, x: TInt;
  y0, y1, y: PREC;
  n: integer;
begin
  (* Ricerca 0 con metodo bisezione *)
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  x0:= -1; x1:=MaxInt;
  y0:= BinNegFCum(x0, r, pr) - p; y1:= BinNegFCum(x1, r, pr) - p;
  if (y0 * y1 > 0) then ErrorHandler('', ERR_NOCONVERGE);
  repeat
    x := (x1 + x0) shr 1;
    y := BinNegFCum(x, r, pr) - p;
    if y > 0 then begin
      y1:= y;
      x1:= x;
    end
    else begin
      y0:= y;
      x0:= x;
    end;
  until abs(x1 - x0) <= 1;
  if abs(y1) < abs(y0) then BinNegXVal:= x1 else BinNegXVal:= x0;
end;

function BinNegRandom(r: TInt; pr: PREC): TInt;
begin
  BinNegRandom:= BinNegXVal(Random, r, pr);
end;

procedure BinNegNextfDis(var X: TInt; var CalcfDis: PREC; r: TInt; pr: PREC);
begin
  inc(X);
  if x < 0  then CalcfDis:= 0
  else if x = 0 then CalcfDis:= exp(r * ln(pr))
  else CalcfDis:= CalcfDis * (1-pr) * (r - pred(x) / x);
end;

procedure BinNegNextFCum(var X: TInt; var CalcFCum: PREC; r: TInt; pr: PREC);
begin
  inc(x);
  CalcFCum:= CalcFCum + BinNegfDis(x, r, pr);
end;

function BinNegMean(r: TInt; pr: PREC): PREC;
begin
  BinNegMean:= r * (1-pr) / pr;
end;

function BinNegVariance(r: TInt; pr: PREC): PREC;
begin
  BinNegVariance := r * pr / (sqr(pr));
end;

(* funzione generatrice dei momenti m(t) = (p / (1 - (1-p) * exp(t)))^r *)

procedure DiceMakeCof(Fac, Num: TInt; var Cof: PAInteger);
var
  Siz: longint;
  i, j, k: TInt;
  temp: PAInteger;
begin
  {$R-}
  Siz:= (Fac * Num) shl 1;
  if Siz < 64520 then begin
    GetMem(Cof, Siz);
    GetMem(temp, Siz);
    FillChar(Cof^, Siz, 0);
    for i:= 0 to pred(Fac) do begin
      Cof^[i]:= 1;
    end;
    for i:= 1 to pred(Num) do begin
      FillChar(temp^, Siz, 0);
      for k:= 1 to Fac do begin
        for j:= pred(i) to pred(i * Fac) do begin
          inc(temp^[j+k], Cof^[j]);
        end;
      end;
      Move(Temp^, Cof^, Siz);
    end;
  end
  else begin
    Cof:= NIL;
  end;
  {$IFDEF RP}
    {$R+}
  {$ENDIF}
end;

procedure DiceDoneCof(Fac, Num: TInt; var Cof: PAInteger);
var
  Siz: longint;
begin
  if Cof <> NIL then begin
    Siz:= (Fac * Num) shl 1;
    FreeMem(Cof, Siz);
  end;
end;

function DicefDis(x: TInt; Fac, Num: TInt): PREC;
var
  Cof: PAInteger;
begin
  {$R-}
  DiceMakeCof(Fac, Num, Cof);
  if (x < Num) or (x > Num*Fac) then DicefDis:= 0
  else DicefDis:= Cof^[pred(x)] / IntPow(Fac, Num);
  DiceDoneCof(Fac, Num, Cof);
  {$IFDEF RP}
    {$R+}
  {$ENDIF}
end;

function DiceFCum(x: TInt; Fac, Num: TInt): PREC;
var
  Cof: PAInteger;
  i: TInt;
  Sum: PREC;
begin
  {$R-}
  DiceMakeCof(Fac, Num, Cof);
  if (x < Num) then DiceFCum:= 0
  else if (x >= Fac * Num) then DiceFCum:= 1
  else begin
    sum:= 0;
    for i:= Num to x do begin
      sum:= sum + Cof^[pred(x)];
    end;
    DiceFCum:= sum  / IntPow(Fac, Num);
  end;
  {$IFDEF RP}
    {$R+}
  {$ENDIF}
end;

function DiceXVal(p: PREC; Fac, Num: TInt): TInt;
var
  x0, x1, x: TInt;
  y0, y1, y: PREC;
  n: integer;
begin
  (* Ricerca 0 con metodo bisezione *)
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  x0:= Num; x1:= MaxInt;
  y0:= DiceFCum(x0, Fac, Num) - p; y1:= DiceFCum(x1, Fac, Num) - p;
  if (y0 * y1 > 0) then ErrorHandler('', ERR_NOCONVERGE);
  repeat
    x := (x1 + x0) shr 1;
    y := DiceFCum(x, Fac, Num) - p;
    if y > 0 then begin
      y1:= y;
      x1:= x;
    end
    else begin
      y0:= y;
      x0:= x;
    end;
  until abs(x1 - x0) <= 1;
  if abs(y1) < abs(y0) then DiceXVal:= x1 else DiceXVal:= x0;
end;

function DiceRandom(Fac, Num: TInt): Tint;
var
  i: TInt;
  v: TInt;
begin
  v:= 0;
  for i:= 1 to Num do begin
    inc(v, succ(System.Random(Fac)));
  end;
  DiceRandom:= v;
end;

procedure DiceNextfDis(var X: TInt; var CalcfDis: PREC; Fac, Num: TInt);
begin
  inc(X);
  CalcfDis:= DicefDis(X, Fac, Num);
end;

procedure DiceNextFCum(var X: TInt; var CalcFCum: PREC; Fac, Num: TInt);
begin
  inc(x);
  CalcFCum:= CalcFCum + DicefDis(x, Fac, Num);
end;

function DiceMean(Fac, Num: TInt): PREC;
begin
  DiceMean:= Num*(succ(Fac) shr 1);
end;

function DiceVariance(Fac, Num: TInt): PREC;
begin
  DiceVariance := Num*pred(sqr(Fac))/12;
end;

(****************************************************************************)
(* DISTRIBUZIONI DI PROBABILITA' CONTINUE                                   *)
(****************************************************************************)

(* Distribuzione uniforme *)
function CUniformfDis(x, a, b: PREC): PREC;
begin
  if (x >= a) and (x <= b) then CUniformfDis:= 1 / (b-a) else CUniformfDis:= 0;
end;

function CUniformFCum(x, a, b: PREC): PREC;
begin
  if x <= a then CUniformFCum:= 0
  else if x < b then CUniformFCum := (x-a)/(b-a)
  else CUniformFCum:= 1;
end;

function CUniformXVal(p, a, b: PREC): PREC;
begin
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  CUniformXVal:= a + p * (b-a);
end;

function CUniformRandom(a, b: PREC): PREC;
begin
  CUniformRandom:= a + System.Random * (b-a);
end;

function CUniformMean(a, b: PREC): PREC;
begin
  CUniformMean:= 0.5 * (a + b);
end;

function CUniformVariance(a, b: PREC): PREC;
begin
  CUniformVariance:= sqr(b - a) * ONEOVER12;
end;

(* funzione generatrice momenti  *)
(* E[exp(tx)] = (exp(bt) - exp(at)) / ((b-a) * t) *)

(* Distribuzione normale standardizzata *)
function NormalfDis(x: PREC): PREC;
begin
  NormalfDis:= EXP(-(sqr(x) * 0.5)) * UNOSURADICEDUEPI;
end;

function NormalFCum(x: PREC): PREC;
(* Errore < ZERO *)
var
  xx: PREC;
  tmp: PREC;
begin
  xx:= abs(x);
  if xx > 10 then tmp:= 1
  else if xx < 1.8 then tmp:= NorSmallNum(xx)
  else tmp:= NorBigNum(xx);
  if x < 0 then NormalFCum:= 1 - tmp else NormalFCum:= tmp;
end;

function NormalXVal(p: PREC): PREC;
(* Trova il valore di x a cui e' associata la probailita' p della
   distribuzione normale standardizzata *)
var
  b, f: integer;
  x, xp, z, p0 : PREC;
begin
  if p <= IMPO then begin NormalXVal:= -1E38; exit; end; (* Sarebbe -infinito *)
  if p >= CERT then begin NormalXVal:= +1E38; exit; end; (* Sarebbe +infinito *)
  if p < 0.5 then begin f:= -1; p:= 1 - p; end else f:= 1;
  x := sqrt(PI/8) * ln(p/(1-p)); (* valore iniziale approssimativo *)
  for b:= 1 to 30 do begin
    z:= NormalfDis(x);
    if x < 1.8 then p0:= NorSmallNum(x) else p0:= NorBigNum(x);
    xp := x;
    x:= x - (p0-p) / (z + (p0-p) * 0.5);
    if abs(xp-x) <= (x * ZERO) then break;
  end;
  NormalXVal:= f*x;
end;

function NormalRandom: PREC;
(* Made with Box-Muller-Marsaglia method *)
begin
  NormalRandom:= cos(2 * PI * System.Random) * sqrt(-ln(System.Random));
end;

function NormalMean: PREC;
begin
  NormalMean:= 0;
end;

function NormalVariance: PREC;
begin
  NormalVariance:= 1;
end;

(* Distriuzione normale *)
(* funzione generatrice dei momenti *)
(* m(t) = exp(mu * t + (sigma^2 * t^2) / 2)  *)

(* Calcoli relativi alla distribuzione normale *)
(* tratti da Personal Software #16 Marzo/1984 pagina 67 *)
function NorBigNum(x: PREC): PREC; (* Calcola funzione normale x > 1.8 *)
var
  pn, pn_2, pn_1, qn, qn_2, qn_1: PREC;
  pp, p2, z: PREC;
  n : integer;
begin
  z:= NormalfDis(x);
  pn_2:= 0;
  pn_1:= 1;
  qn_2:= 1;
  qn_1:= x;
  pp:= 1/x;
  for n:= 3 to 35 do begin
    pn:= x * pn_1 + (n-2) * pn_2;
    qn:= x * qn_1 + (n-2) * qn_2;
    p2 := pn / qn;
    if z*abs(pp-p2) < ZERO then break;
    pp:= p2;
    pn_2:= pn_1;
    qn_2:= qn_1;
    pn_1:= pn;
    qn_1:= qn;
  end;
  NorBigNum:= 1 - z * p2;
end;

function NorSmallNum(x: PREC): PREC; (* Calcola funzione normale x <= 1.8 *)
var
  p, q: PREC;
  i : integer;
begin
  p:= 1;
  q:= 1;
  for i:= 1 to 30 do begin
    p:= -p*sqr(x)*0.5/i;
    q:= q + p/(2*i+1);
    if x*abs(p*UNOSURADICEDUEPI)/(2*i+1) <= ZERO then break;
  end;
  NorSmallNum:= 0.5+x*q*UNOSURADICEDUEPI;
end;

function NormalefDis(x, Media, Scarto: PREC): PREC;
begin
  (* Normalizzazione variabili e calcolo funzione *)
  NormalefDis:= NormalfDis((x - Media) / Scarto);
end;

function NormaleFCum(x, Media, Scarto: PREC): PREC;
begin
  (* Normalizzazione variabili e calcolo funzione *)
  NormaleFCum:= NormalFCum((x - Media) / Scarto);
end;

function NormaleXVal(p, Media, Scarto: PREC): PREC;
begin
  NormaleXVal:= NormalXVal(p) * Scarto + Media;
end;

function NormaleRandom(Media, Scarto: PREC): PREC;
begin
  NormaleRandom:= NormalRandom * Scarto + Media;
end;

function NormaleMean(Media, Scarto: PREC): PREC;
begin
  NormaleMean:= Media;
end;

function NormaleVariance(Media, Scarto: PREC): PREC;
begin
  NormaleVariance:= sqr(Scarto);
end;

(* Distribuzione Log-Normale *)
function LogNorfDis(x, mu, sigma: PREC): PREC; (* alpha, beta >= 0 *)
begin
  if x <= 0 then LogNorfDis:= 0
  else LogNorfDis:= 1/(x*RADICEDUEPI*sigma)*exp(-sqr(ln(x) - mu)/(2*sqr(sigma)));
end;

function LogNorFCum(x, mu, sigma: PREC): PREC;
begin
  LogNorFCum:= NormalFCum((ln(x)-mu)/sigma);
end;

function LogNorXVal(p, mu, sigma: PREC): PREC;
begin
  LogNorXVal:= exp(NormalXVal(p) * sigma + mu);
end;

function LogNorRandom(mu, sigma: PREC): PREC;
begin
  LogNorRandom:= LogNorXVal(System.Random, mu, sigma);
end;

function LogNorMean(mu, sigma: PREC): PREC;
begin
  LogNorMean:= exp(mu + 0.5*sqr(sigma));
end;

function LogNorVariance(mu, sigma: PREC): PREC;
begin
  LogNorVariance:= exp(2*mu + 2 * sqr(sigma)) - exp(2*mu+sqr(sigma));
end;

(* Distribuzione esponenziale nagativa *)
function ExpfDis(x, lambda: PREC): PREC;
begin
  if x > 0 then ExpfDis:= lambda * exp(-lambda * x) else ExpfDis:= 0;
end;

function ExpFCum(x, lambda: PREC): PREC;
begin
  if x <= 0 then ExpFCum:= 0
  else ExpFCum:= 1 - exp(-lambda * x);
end;

function ExpXVal(p, lambda: PREC): PREC;
begin
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  if p < ZERO then ExpXVal:= 0
  else ExpXVal:= -ln(1-p) / lambda;
end;

function ExpRandom(lambda: PREC): PREC;
var p: PREC;
begin
  p:= System.Random;
  if p < ZERO then ExpRandom:= 0
  else ExpRandom:= -ln(1-p) / lambda;
end;

function ExpMean(lambda: PREC): PREC;
begin
  ExpMean:= 1 / lambda;
end;

function ExpVariance(lambda: PREC): PREC;
begin
  ExpVariance:=  1 / sqr(lambda);
end;

(* funzione generatrice momenti m(t) = lambda / (lambda - t), t < lambda *)

(* Distribuzione Gamma *)
function GammafDis(x, r, lambda: PREC): PREC;
begin
  if x <= 0 then GammafDis:= 0
  else GammafDis:= lambda / Gamma(r) * Pow(lambda*x, r-1) * exp(-lambda*x);
end;

function GammaFCum(x, r, lambda: PREC): PREC;
const
  xp : array[1..5] of PREC = (0.1488743389, 0.4333953941, 0.6794095682, 0.8650633666, 0.9739065285);
  wp : array[1..5] of PREC = (0.2955242247, 0.2692667193, 0.2190863625, 0.1494513491, 0.0666713443);
var
  i,rr: longint;
  stp,tmp, f,rf: PREC;
  j: integer;
  t,a,b,dx, xr, xm: PREC;
begin
  if (x<=0) then begin
    GammaFCum:= 0;
    exit;
  end;
  t:= lambda*x;
  tmp:= r;
  rr:= trunc(r); r:= frac(r);
  f:= 0;
  if rr>1 then begin
    rf:= 1;
    for i:= 2 to rr do rf:= rf*i;
    xm:= t;
    while (rr>=1) do begin
      f:= f+ xm*rf;
      rf:= rf/rr;
      xm:= xm * t;
      dec(rr);
    end;
    f:= -exp(-t)*f/Gamma(tmp);
  end;
  if r>ZERO then begin
    rf:= 0;
    stp:= 0.25;
    a:= 0;
    b:= stp;
    xr:= 0.5*stp;
    while (b<=x) do begin
      xm:= 0.5*(a+b);
      for j:= 1 to 5 do begin
        dx:= xr*xp[j];
        rf:= rf+wp[j] * (GammafDis(xm+dx,r,lambda) + GammafDis(xm-dx,r,lambda));
      end;
      a:= b;
      b:= b+stp;
    end;
  end
  else begin rf:= 1; xr:= 1; end;
  r:= tmp;
  GammaFCum:= f-xm*rf;
end;

function GammaXVal(p, r, lambda: PREC): PREC;
var
  x0, x1, x: PREC;
  y0, y1, y: PREC;
  n: integer;
  function f(x: PREC): PREC; far;
  begin
    f:= GammaFCum(x, r, lambda) - p;
  end;
begin
  (* Ricerca 0 con metodo bisezione *)
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  x0:= ZERO; x1:= 500;
  y0:= f(x0); y1:= f(x1);
  if ( y0 * y1 > 0) then ErrorHandler('', ERR_NOCONVERGE);
  repeat
    for n:= 1 to 8 do begin
      x := (x1 + x0) * 0.5;
      y := f(x);
      if y > 0 then begin
        y1:= y;
        x1:= x;
      end
      else begin
        y0:= y;
        x0:= x;
      end;
    end;
  until (abs(x1-x0) <= x0 * ZERO) and (abs(y) <= 10 * ZERO);
  GammaXVal:= (x1 + x0) * 0.5;
end;

function GammaRandom(r, lambda: PREC): PREC;
begin
  GammaRandom:= GammaXVal(System.random, r, lambda);
end;

function GammaMean(r, lambda: PREC): PREC;
begin
  GammaMean:= r / lambda;
end;

function GammaVariance(r, lambda: PREC): PREC;
begin
  GammaVariance:= r / sqr(lambda);
end;
(* funzione generatrice momenti m(t) = (lambda / (lambda - t)^r , t < lambda *)

(* Distribuzione Weibull *)
function WeibullfDis(x, alpha, beta: PREC): PREC; (* alpha, beta >= 0 *)
begin
  if x > 0 then WeibullfDis:= alpha * beta * Pow(x, beta-1) * exp(-alpha*Pow(x, beta))
  else WeibullfDis:= 0;
end;

function WeibullFCum(x, alpha, beta: PREC): PREC;
begin
  if x <= 0 then WeibullFCum := 0
  else WeibullFCum := 1 - exp(-alpha * Pow(x, beta));
end;

function WeibullXVal(p, alpha, beta: PREC): PREC;
begin
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  if p < ZERO then WeibullXVal:= 0
  else WeibullXVal:= exp(ln(-ln(1 - p) / alpha) / beta);
end;

function WeibullRandom(alpha, beta: PREC): PREC;
var p: PREC;
begin
  p:= System.Random;
  if p < ZERO then WeibullRandom:= 0
  else WeibullRandom:= exp(ln(-ln(1 - p) / alpha) / beta);
end;

function WeibullMean(alpha, beta: PREC): PREC;
begin
  WeibullMean:= Pow(alpha, -1/beta)* Gamma(1+1/beta);
end;

function WeibullVariance(alpha, beta: PREC): PREC;
begin
  WeibullVariance:= Pow(alpha, -2/beta) * (Gamma(1+2/beta) - sqr(Gamma(1+1/beta)));
end;

(* Distribuzione Beta *)
function BetafDis(x, alpha, beta: PREC): PREC;
begin
  if (x > ZERO) and (x < CERT) then begin
    if (beta = 1) and (alpha = beta) then BetafDis:= 1
    else BetafDis:= Gamma(alpha+beta)/(Gamma(alpha)*Gamma(beta))*Pow(x, alpha-1)*Pow(1-x, beta-1)
  end
  else BetafDis:= 0;
end;

function BetaFCum(x, alpha, beta: PREC): PREC;
const
  itmax = 100;
var 
  am, bm, az, qab, qap, qam, bz, d, ap, bp, app, bpp, aold: PREC;
  tem, m, em: integer;
begin
  if x < ZERO then BetaFCum := 0
  else if x > CERT then BetaFCum:= 1
  else begin
    if (beta = 1) and (alpha = beta) then begin
      BetaFCum:= x;
      exit;
    end;
    am:= 1;
    bm:= 1;
    az:= 1;
    qab:= alpha+beta;
    qap:= alpha+1;
    qam:= alpha-1;
    bz:= 1 - qab*x/qap;
    for m:= 1 to itmax do begin
      em:= m;
      tem:= em+em;
      d:= em * (beta-m) * x / ((qam+tem) * (alpha+tem));
      ap:= az+d*am;
      bp:= bz+d*bm;
      d:= -(alpha+em) *  (qab+em) * x / ((alpha+tem) * (qap+tem));
      app:= ap+d * az;
      bpp:= bp+d*bz;
      aold:= az;
      am:= ap/bpp;
      bm:= bp/bpp;
      az:= app/bpp;
      bz:= 1;
      if (abs(az-aold) < ZERO * abs(az)) then begin
        BetaFCum:= az;
        exit;
      end;
    end;
    ErrorHandler('', ERR_NOCONVERGE);
  end;
end;

function BetaXVal(p, alpha, beta: PREC): PREC;
var bt: PREC;
begin
  if (p < 0) or (p > 1) then ErrorHandler('', ERR_BETAIPARAM);
  if (beta = 1) and (alpha = beta) then begin
    BetaXVal:= p;
    exit;
  end;
  if (p = 0) or (p = 1) then begin
    bt:= 0;
  end
  else begin
    bt:= exp(GammaLN(alpha+beta) - GammaLN(alpha) - GammaLN(beta) + alpha * ln(p) + beta * ln(1-p));
  end;
  if (p < (alpha+1)/(alpha+beta+2)) then begin
    BetaXVal:= bt * BetaFCum(p, alpha, beta) / alpha;
  end
  else begin
    BetaXVal:= 1 - bt * BetaFCum(1-p, beta, alpha) / beta;
  end;
end;

function BetaRandom(alpha, beta: PREC): PREC;
begin
  BetaRandom:= BetaXVal(System.Random, alpha, beta);
end;

function BetaMean(alpha, beta: PREC): PREC;
begin
  BetaMean:= alpha / (alpha + beta);
end;

function BetaVariance(alpha, beta: PREC): PREC;
begin
  BetaVariance:= alpha * beta / sqr(alpha+beta)*(alpha+beta+1);
end;

(* Distribuzione TStudent *)
function TStudentfDis(x: PREC; d: PREC): PREC;
begin
  TStudentfDis:= (Pow(d, d*0.5) * Gamma((1+d)*0.5))/(sqrt(x)*Gamma(0.5)*Gamma(d*0.5)*Pow(d+X, (1+d)*0.5));
end;

function TStudentFCum(x: PREC; d: PREC): PREC;
var
  i: integer;
  tt, vt, bt, t: PREC;
  nu: integer;
begin
  nu:= round(d);
  X:= X / sqrt(NU);
  T:= ATAN(X); (* T = theta *)
  if nu = 1 then begin
    TStudentFCum := T * 0.6366197724;
    exit;
  end;
  if odd(nu) then begin
    (* calcolo dello sviluppo per nu dispari *)
    bt := cos(t);
    tt := sqr(bt);
    vt := bt;
    if nu <> 3 then begin
      i := 2;
      repeat
        vt:= vt * i * tt / (i+1);
        bt:= bt + vt;
        inc(i,2);
      until (i > (nu-3));
    end;
    bt:= bt * sin(t);
    bt:= (bt+t)* 0.6366197724;
  end
  else begin
    tt:= sqr(cos(t));
    bt:= 1;
    vt:= 1;
    if nu <> 2 then begin
      i:= 1;
      repeat
        vt:= vt * i * tt  / (i+1);
        bt:= bt + vt;
        inc(i,2);
      until i > (nu-3);
    end;
    bt:= bt * sin (t);
  end;
  TStudentFCum:= (1 + bt) * 0.5;
end;

function TStudentXVal(p: PREC; d: PREC): PREC;
var
  x0, x1, x: PREC;
  y0, y1, y: PREC;
  n: integer;
  function f(x: PREC): PREC; far;
  begin
    f:= TStudentFCum(x, round(d)) - p;
  end;
begin
  (* Ricerca 0 con metodo bisezione *)
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  x0:= -15; x1:= 15;
  y0:= f(x0); y1:= f(x1);
  if ( y0 * y1 > 0) then ErrorHandler('', ERR_NOCONVERGE);
  repeat
    for n:= 1 to 8 do begin
      x := (x1 + x0) * 0.5;
      y := f(x);
      if y > 0 then begin
        y1:= y;
        x1:= x;
      end
      else begin
        y0:= y;
        x0:= x;
      end;
    end;
  until (abs(x1-x0) <= x0 * ZERO) and (abs(y) <= ZERO);
  TStudentXVal:= (x1 + x0) * 0.5;
end;

function TStudentRandom(d: PREC): PREC;
begin
  TStudentRandom:= TStudentXVal(System.Random, d);
end;

function TStudentMean(d: PREC): PREC;
begin
  TStudentMean:= 0;
end;

function TStudentVariance(d: PREC): PREC;
begin
  if d <> 2 then TStudentVariance:= d/(d-2) else TStudentVariance:= 0;
end;

function ChiQuadfDis(x: PREC; v: PREC): PREC;
begin
  if x <= 0 then ChiQuadfDis:= 0
  else ChiQuadfDis:= 0.5 / Gamma(0.5*v) * Pow(0.5*x, 0.5*v-1) * exp(-0.5*x);
end;

function ChiQuadFCum(x: PREC; v: PREC): PREC;
var
  r: PREC; (* R=PRODOTTO AL DENOMINATORE *)
  k: PREC; (* K=PRODOTTO AL NUMERATORE   *)
  m, j: PREC;
  l: PREC; (* L=FATTORE DI SOMMATORIA    *)
  vv, i: longint;
begin
  vv:= round(v);
  if vv > 30 then begin ChiQuadFCum:= NormalFCum(x); exit; end;
  R:= 1;
  i:= vv;
  while (i >= 2) do begin
    R := R * I;
    dec(i, 2);
  end;
  K := IntPow(x, (vv+1) shr 1) * EXP(-x * 0.5) / R;
  (* Il PI GRECO e' usato solo quando i gradi di liberta' sono dispari *)
  if odd(vv) then
    J := sqrt(2 / (x * PI))
  else
    J := 1;
  L := 1;
  M := 1;
  repeat
    inc(vv, 2);
    M := M * x / vv;
    (* Verifica se bisogna troncare la sommatoria *)
    L := L + M;
  until M < ZERO;
  ChiQuadFCum:= J * K * L
end;

function ChiQuadXVal(p: PREC; v: PREC): PREC;
var
  x0, x1, x: PREC;
  y0, y1, y: PREC;
  n: integer;
  function f(x: PREC): PREC; far;
  begin
    f:= ChiQuadFCum(x, v) - p;
  end;
begin
  (* Ricerca 0 con metodo bisezione *)
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  x0:= 0.1; x1:= 75;
  y0:= f(x0);
  y1:= f(x1);
  if ( y0 * y1 > 0) then ErrorHandler('', ERR_NOCONVERGE);
  repeat
    for n:= 1 to 8 do begin
      x := (x1 + x0) * 0.5;
      y := f(x);
      if y > 0 then begin
        y1:= y;
        x1:= x;
      end
      else begin
        y0:= y;
        x0:= x;
      end;
    end;
  until (abs(x1-x0) <= x0 * ZERO) and (abs(y) <= ZERO);
  ChiQuadXVal:= (x1 + x0) * 0.5;
end;

function ChiQuadRandom(v: PREC): PREC;
begin
  ChiQuadRandom:= ChiQuadXVal(System.Random, v);
end;

function ChiQuadMean(v: PREC): PREC;
begin
  ChiQuadMean:= v;
end;

function ChiQuadVariance(v: PREC): PREC;
begin
  ChiQuadVariance:= 2 * v;
end;

function FisherfDis(x: PREC; df1, df2: PREC): PREC;
begin
  FisherfDis:= (Pow(df1, df1 * 0.5) * Pow(df2, df2*0.5) * Gamma((df1+df2)*0.5) * Pow(x, df1 * 0.5 - 1)) /
   (Gamma(df1*0.5)*Gamma(df2*0.5)*Pow(df2+df1*X, (df1+df2)*0.5));
end;

function FisherFCum(x: PREC; df1, df2: PREC): PREC;
var
  tmp1, tmp2: PREC;
begin
  tmp1:= 0.5 * df1;
  tmp2:= 0.5 * df2;
  FisherFCum:= 0.5 - (BetaXVal(df2/(df2+df1*x), tmp2, tmp1) - BetaXVal(df1/(df1+df2/x), tmp1, tmp2))*0.5;
end;

function FisherXVal(p: PREC; df1, df2: PREC): PREC;
var
  x0, x1, x: PREC;
  y0, y1, y: PREC;
  n: integer;
  function f(x: PREC): PREC; far;
  begin
    f:= FisherFCum(x, df1, df2) - p;
  end;
begin
  (* Ricerca 0 con metodo bisezione *)
  if (p<0) or (p>1) then ErrorHandler('', ERR_OUTOFRANGE);
  x0:= ZERO; x1:= 300;
  y0:= f(x0); y1:= f(x1);
  if ( y0 * y1 > 0) then ErrorHandler('', ERR_NOCONVERGE);
  repeat
    for n:= 1 to 8 do begin
      x := (x1 + x0) * 0.5;
      y := f(x);
      if y > 0 then begin
        y1:= y;
        x1:= x;
      end
      else begin
        y0:= y;
        x0:= x;
      end;
    end;
  until (abs(x1-x0) <= x0 * ZERO) and (abs(y) <= ZERO);
  FisherXVal:= (x1 + x0) * 0.5;
end;

function FisherRandom(df1, df2: PREC): PREC;
begin
  FisherRandom:= FisherXVal(System.Random, df1, df2);
end;

function FisherMean(df1, df2: PREC): PREC;
begin
  FisherMean:= df2/(df2-2);
end;

function FisherVariance(df1, df2: PREC): PREC;
begin
  FisherVariance:= 2*sqr(df2)*(df1+df2-2)/(df1*sqr(df2-2)*(df2-4));
end;

{$UNDEF RP}

end.

(* Vecchi retaggi lasciati perche' potrebbero tornare utili *)

(* Valutazione della distribuzione normale standardizzata *)
function NorBigNum(x: PREC): PREC; (* Calcola funzione normale x > 1.8 *)
var
  p, q: array[1..35] of PREC;
  pp, p2, z: PREC;
  n : integer;
begin
  z:= NormalfDis(x);
  p[1]:= 0;
  p[2]:= 1;
  q[1]:= 1;
  q[2]:= x;
  pp:= 1/x;
  for n:= 3 to 35 do begin
    p[n]:= x*p[n-1] + (n-2)*p[n-2];
    q[n]:= x*q[n-1] + (n-2)*q[n-2];
    p2 := p[n] / q[n];
    if z*abs(pp-p2) < ZERO then break;
    pp:= p2;
  end;
  NorBigNum:= 1 - z * p2;
end;

function FisherFCum(f: PREC; df1, df2: PREC): PREC;
(* errore < 2.5E-4  *)
var
  x, y, s, t, z, j, k : PREC;
begin
  X := 1;
  (* per piccoli valori di f esegue i calcoli usando l'inversa *)
  if F < 1 then begin
    S := df2;
    T := df1;
    Z := 1 / F;
  end
  else begin
    S := df1;
    T := df2;
    Z := F;
  end;
  J := 2 / 9 / S;
  K := 2 / 9 / T;
  (* Calcola con l'uso della formula approssimata *)
  Y := abs((1 - K) * POW(Z,(1 / 3)) - 1 + J) / sqrt(K * POW(Z,(2 / 3)) + J);
  if T < 4 then begin
    Y := Y * (1 + 0.08 * IntPow(Y,4) / IntPow(T,3));
  end;
  X := 0.5 / IntPow(1 + Y * (0.196854 + Y * (0.115194 + Y * (0.000344 + Y * 0.019527))),4);
  (* Se si era usato l'inverso modifica di conseguenza *)
  if F < 1 then FisherFCum:= X else FisherFCum:= 1 - X;
end;

function ChiQuadFCum(x: PREC; nu: longint): PREC;
var
  n2: PREC;
  n : longint;
  gn: PREC;
  i: longint;
  fx: PREC;
  aa, bb: PREC;
  fa, fm, px: PREC;
begin
  N2:= nu * 0.5;
  n:= round(n2);
  Gn:= 1;
  if Odd(nu) then begin
    if nu <> 1 then begin
      i:= 1;
      repeat
        gn := gn * i * 0.5;
        inc(i, 2);
      until i > (2 * N - 1);
    end;
    gn:= gn * 1.7724528509;
  end
  else begin
    if nu <> 2 then begin
      i:= 1;
      repeat
        gn := gn * i;
        inc(i, 2);
      until i > (N-1);
    end;
  end;
  fx:= Pow(x,  (N2-1));
  aa:= exp(-x/2);
  bb:= gn * Pow(2, N2);
  fx:= fx * aa / bb;
  fa:= Pow((x/2), N2);
  fa:= fa * aa / (N2 * gn);
  fm:= 1;
  px:= 1;
  i:= 2;
  repeat
    fm:= fm * x / (nu + I);
    px:= px + fm;
    inc(i, 2);
  until (fm * fa) < ZERO;
  ChiQuadFCum:= px * fa;
end;

function TStudentFCum(t: PREC; d: PREC): PREC;
(* t valore in cui calcolare la funzione di T-Student *)
(* d gradi di liberta'                                *)
(* restituisce il valore della coda della funzione    *)
(* errore < 2.5E-4                                    *)
var
  x, y, s, r, z, j, k, l: PREC;
begin
  X := 1;
  Y := 1;
  T := sqr(T);
  (* esegue i calcoli, se il valore di T e' piccolo, usando l'inverso *)
  if (T < 1) then begin
    S := D;
    R := Y;
    Z := 1 / T;
  end
  else begin
    S := Y;
    R := D;
    Z := T;
  end;
  J := 2 / 9 / S;
  K := 2 / 9 / R;
  (* esegue i calcoli della formula approssimata *)
  L := abs((1 - K) * POW(Z,(1 / 3)) - 1 + J) / sqrt(K * POW(Z,(2 / 3)) + J);
  if R < 4 then begin
    L := L * (1 + 0.08 * IntPow(L, 4) / IntPow(R,3));
  end;
  X := 0.5 / IntPow((1 + L * (0.196854 + L * (0.115194 + L * (0.000344 + L * 0.019527)))), 4);
  (* se era stato usato l'inverso modifica di conseguenza il risulatato *)
  if T < 1 then X := 1 - X;
  TStudentFCum:= X;
end;

function NormalFCum(x: PREC): PREC;
(* Errore < 10E-5 *)
var
  temp, r, z: PREC;
begin
  r:= NormalfDis(x);
  (* approssima la probabilita' (area sottesa dalla curva *)
  z := 1 / (1 + 0.33267 * abs(x));
  temp := 1 - r * z * (0.4361836 + z * (-0.1201676 + 0.937298 * z));
  (* regolizzazione per le variabili negative *)
  if x < 0 then temp := 1 - temp;
  NormalFCum:= temp;
end;
