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
unit uStat;

interface

uses
  eLibMath, uError, uMath, Math;

type

  TPopParam    =
    (media, varianza, scarto, scartocorr, varianzacorretta, coefvar,
     devmed, mediana, moda, range, quart1, quart3, IQR, minim, maxim,
     mediageo, devgeo, mediarm);
  TPopParamSet = set of TPopParam;
  TResult      = array[TPopParam] of TReal;

const

  CERT = 0.999999;
  IMPO = 1-CERT;
  TINY = 100 * IMPO;
  BIG  = 1/TINY;

  RADICEDUEPI      = 2.5066282746;
  UNOSURADICEDUEPI = 0.3989422804;
  ONEOVER12        = 1.0 / 12;
  ONE              = 1.0;
  HALF             = 0.5;

(*
  DISTRIBUZIONI DI PROBABILITA'
*)

type
  TDistrib = class
     function    Name: string; virtual; abstract;
     function    Mean: TReal; virtual; abstract;
     function    Variance: TReal; virtual; abstract;
     procedure   Error(ErrCode: integer); virtual;
     function    fDis(x: TReal): TReal; virtual; abstract;
     function    FCum(x: TReal): TReal; virtual; abstract;
     function    XVal(p: TReal): TReal; virtual; abstract;
     function    Random: TReal; virtual; abstract;
  end;

  TDiscDistrib = class(TDistrib)
     imin: TInteger;
     imax: TInteger;
     constructor DiscDistrib;
     function    Name: string; override;
     function    fDis(x: TInteger): TReal; reintroduce; virtual;
     function    FCum(x: TInteger): TReal; reintroduce; virtual;
     function    XVal(p: TReal): TInteger; reintroduce; virtual;
     function    Random: TInteger; reintroduce; virtual;
     procedure   NextfDis(var X: TInteger; var CalcfDis: TReal); virtual;
     procedure   NextFCum(var X: TInteger; var CalcFCum: TReal); virtual;
  end;

  TContDistrib = class(TDistrib)
     imin: TReal;
     imax: TReal;
     constructor ContDistrib;
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    XVal(p: TReal): TReal; override;
     function    Random: TReal; override;
  end;

  TMaxDistrib = class(TContDistrib)
     F1: TContDistrib;
     F2: TContDistrib;
     constructor MaxDistrib(AF1, AF2: TContDistrib);
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
     function    Name: string; override;
     destructor  Destroy; override;
  end;

  TMinDistrib = class(TMaxDistrib)
     constructor MinDistrib(AF1, AF2: TContDistrib);
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
  end;

  TParalDistrib = class(TMaxDistrib)
     constructor ParalDistrib(AF1, AF2: TContDistrib);
     function    Name: string; override;
  end;

  TSerieDistrib = class(TMinDistrib)
     constructor SerieDistrib(AF1, AF2: TContDistrib);
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
  end;

type

  TCUniform = class(TContDistrib)
     a, b: TReal;
     tmp: TReal;
     constructor Uniform(aa, bb: TReal);
     procedure   SetA(aa: TReal);
     function    GetA: TReal;
     procedure   SetB(bb: TReal);
     function    GetB: TReal;
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
     function    XVal(p: TReal): TReal; override;
     function    Random: TReal; override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TNormal = class(TContDistrib)
     OldZ: TReal;
     Vld: boolean;
     constructor Normal;
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
     function    XVal(p: TReal): TReal; override;
     function    Random: TReal; override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
    private
     function    CalcfDis(x: TReal): TReal;
     function    NorSmallNum(x: TReal): TReal;
     function    NorBigNum(x: TReal): TReal;
  end;

  TNormale = class(TNormal)
     media, scarto: TReal;
     constructor Normale(mu, si: TReal);
     procedure   SetMedia(mu: TReal);
     function    GetMedia: TReal;
     procedure   SetScarto(si: TReal);
     function    GetScarto: TReal;
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
     function    XVal(p: TReal): TReal; override;
     function    Random: TReal; override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TLogNor = class(TNormal)
     mu, sigma: TReal;
     constructor LogNor(alpha, beta: TReal);
     procedure   SetMedia(alpha: TReal);
     function    GetMedia: TReal;
     procedure   SetScarto(beta: TReal);
     function    GetScarto: TReal;
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
     function    XVal(p: TReal): TReal; override;
     function    Random: TReal; override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TExp = class(TContDistrib)
     lambda: TReal;
     constructor ExpDis(lam: TReal);
     procedure   SetLambda(lam: TReal);
     function    GetLambda: TReal;
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
     function    XVal(p: TReal): TReal; override;
     function    Random: TReal; override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TGamma = class(TContDistrib)
     r, lambda: TReal;
     constructor GammaDis(rr, lam: TReal);
     procedure   SetR(rr: TReal);
     function    GetR: TReal;
     procedure   SetLambda(lam: TReal);
     function    GetLambda: TReal;
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TWeibull = class(TContDistrib)
     alpha, beta: TReal;
     constructor Weibull(al, be: TReal);
     procedure   SetAlpha(al: TReal);
     function    GetAlpha: TReal;
     procedure   SetBeta(bt: TReal);
     function    GetBeta: TReal;
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
     function    XVal(p: TReal): TReal; override;
     function    Random: TReal; override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TBeta = class(TContDistrib)
     alpha, beta: TReal;
     flag: boolean;
     constructor BetaDis(al, be: TReal);
     procedure   SetAlpha(al: TReal);
     function    GetAlpha: TReal;
     procedure   SetBeta(bt: TReal);
     function    GetBeta: TReal;
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
     function    XVal(p: TReal): TReal; override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TTStudent = class(TNormal)
     d: TReal;
     constructor TStudent(dof: TReal);
     procedure   SetDegOfFre(dof: TReal);
     function    GetDegOfFre: TReal;
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TChiQuad = class(TNormal)
     (* also if a special case of Gamma Dist with r: n/2, lambda = 1/2, not used
        inherited from TNormal that gives a good approx when v -> ì         *)
     v: TReal;
     constructor ChiQuad(dof: TReal);
     procedure   SetDegOfFre(dof: TReal);
     function    GetDegOfFre: TReal;
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TFisher = class(TContDistrib)
     df1, df2: TReal;
     B1, B2: TBeta;
     constructor Fisher(dof1, dof2: TReal);
     procedure   SetDegOfFreN(dof1: TReal);
     function    GetDegOfFreN: TReal;
     procedure   SetDegOfFreD(dof2: TReal);
     function    GetDegOfFreD: TReal;
     function    Name: string; override;
     function    fDis(x: TReal): TReal; override;
     function    FCum(x: TReal): TReal; override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
     destructor  Destroy; override;
  end;

type

  TDUniform = class(TDiscDistrib)
     N: TInteger;
     tmp: TReal;
     constructor Uniform(nn: TInteger);
     procedure   SetN(nn: TInteger);
     function    GetN: TInteger;
     function    Name: string; override;
     function    fDis(x: TInteger): TReal; override;
     function    FCum(x: TInteger): TReal; override;
     function    XVal(p: TReal): TInteger; override;
     function    Random: TInteger; override;
     procedure   NextfDis(var X: TInteger; var CalcfDis: TReal); override;
     procedure   NextFCum(var X: TInteger; var CalcFCum: TReal); override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TBernulli = class(TDiscDistrib)
     pr: TReal;
     constructor Bernulli(p: TReal);
     procedure   SetP(p: TReal);
     function    GetP: TReal;
     function    Name: string; override;
     function    fDis(x: TInteger): TReal; override;
     function    FCum(x: TInteger): TReal; override;
     function    XVal(p: TReal): TInteger; override;
     function    Random: TInteger; override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TBinomial = class(TDiscDistrib)
     nn: TInteger;
     pr: TReal;
     tmp: TReal;
     constructor Binomial(N: TInteger; p: TReal);
     procedure   SetP(p: TReal);
     function    GetP: TReal;
     procedure   SetN(N: TInteger);
     function    GetN: TInteger;
     function    Name: string; override;
     function    fDis(x: TInteger): TReal; override;
     procedure   NextfDis(var X: TInteger; var CalcfDis: TReal); override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TIperGeom = class(TDiscDistrib)
     MM, kk, nn: TInteger;
     constructor IperGeom(M, K, n: TInteger);
     procedure   SetM(M: TInteger);
     function    GetM: TInteger;
     procedure   SetK(K: TInteger);
     function    GetK: TInteger;
     procedure   SetN(N: TInteger);
     function    GetN: TInteger;
     function    Name: string; override;
     function    fDis(x: TInteger): TReal; override;
     procedure   NextfDis(var X: TInteger; var CalcfDis: TReal); override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TPoisson = class(TDiscDistrib)
     lambda: TReal;
     constructor Poisson(lam: TReal);
     procedure   SetLambda(lam: TReal);
     function    GetLambda: TReal;
     function    Name: string; override;
     function    fDis(x: TInteger): TReal; override;
     procedure   NextfDis(var X: TInteger; var CalcfDis: TReal); override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TGeometric = class(TDiscDistrib)
     pr: TReal;
     constructor Geometric(p: TReal);
     procedure   SetP(p: TReal);
     function    GetP: TReal;
     function    Name: string; override;
     function    fDis(x: TInteger): TReal; override;
     procedure   NextfDis(var X: TInteger; var CalcfDis: TReal); override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TBinNeg = class(TDiscDistrib)
     rr: TInteger;
     pr: TReal;
     constructor BinNeg(r: TInteger; p: TReal);
     procedure   SetP(p: TReal);
     function    GetP: TReal;
     procedure   SetR(r: TInteger);
     function    GetR: TInteger;
     function    Name: string; override;
     function    fDis(x: TInteger): TReal; override;
     procedure   NextfDis(var X: TInteger; var CalcfDis: TReal); override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
  end;

  TDiceDis = class(TDiscDistrib)
     Num, Fac: TInteger;
     Cof: array of integer;
     tmp: TReal;
     constructor DiceDis(HowManyDice, NumberOfFaces: TInteger);
     procedure   SetNum(HowManyDice: TInteger);
     function    GetNum: TInteger;
     procedure   SetFac(NumberOfFaces: TInteger);
     function    GetFac: TInteger;
     function    Name: string; override;
     function    fDis(x: TInteger): TReal; override;
     function    Random: TInteger; override;
     function    Mean: TReal; override;
     function    Variance: TReal; override;
     destructor  Destroy; override;
    private
     procedure   MakeCof;
     procedure   DoneCof;
  end;

implementation

(*
  DISTRIBUZIONI DI PROBABILITA'
*)

procedure TDistrib.Error(ErrCode: integer);
var tmp: string;
begin
  Str(ErrCode, tmp);
  tmp:= 'Object(TDistrib:'+Name+') has caused an error #' + tmp;
  ErrorHandler(tmp, ErrCode);
end;

constructor TDiscDistrib.DiscDistrib;
begin
  imin:= -maxint;
  imax:= maxint;
end;

function TDiscDistrib.Name: string;
begin
  Name:= 'Unknow Probability Distribution';
end;

function TDiscDistrib.fDis(x: TInteger): TReal;
begin
  fDis:= 0;
end;

function TDiscDistrib.FCum(x: TInteger): TReal;
var
  temp: TReal;
  i: TInteger;
begin
  temp:= fDis(0);
  for i:= 1 to x do begin
    temp:= temp + fdis(i);
    if temp > CERT then begin
      temp:= 1;
      break;
    end;
  end;
  FCum:= temp;
end;

function TDiscDistrib.XVal(p: TReal): TInteger;
var
  x0, x1, x: TInteger;
  y0, y1, y: TReal;
begin
  (* Ricerca 0 con metodo bisezione *)
  if (p<0) or (p>1) then Error(ERR_OUTOFRANGE);
  x0:= imin; x1:= imax;
  y0:= FCum(x0) - p; y1:= FCum(x1) - p;
  if (y0 * y1 > 0) then Error(ERR_NOCONVERGE);
  repeat
    x := (succ(x1 + x0)) shr 1;
    y := FCum(x) - p;
    if y > 0 then begin
      y1:= y;
      x1:= x;
    end
    else begin
      y0:= y;
      x0:= x;
    end;
  until abs(x1 - x0) <= 1;
  if abs(y1) < abs(y0) then XVal:= x1 else XVal:= x0;
end;

function TDiscDistrib.Random: TInteger;
begin
  Random:= XVal(System.Random);
end;

procedure TDiscDistrib.NextfDis(var X: TInteger; var CalcfDis: TReal);
begin
  inc(X); CalcfDis:= fDis(X);
end;

procedure TDiscDistrib.NextFCum(var X: TInteger; var CalcFCum: TReal);
begin
  inc(X); CalcFCum:= CalcFCum + fDis(X);
end;

constructor TContDistrib.ContDistrib;
begin
  imin:= -1000.0; imax:= 1000.0;
end;

function TContDistrib.Name: string;
begin
  Name:= 'Unknow Probability Density';
end;

function TContDistrib.fDis(x: TReal): TReal;
begin
  fDis:= 0;
end;

function TContDistrib.XVal(p: TReal): TReal;
var
  x0, x1, x: TReal;
  y0, y1, y: TReal;
  n: integer;
begin
  (* Ricerca 0 con metodo bisezione *)
  if (p<0) or (p>1) then Error(ERR_OUTOFRANGE);
  x0:= imin;
  x1:= imax;
  y0:= FCum(x0) - p;
  y1:= FCum(x1) - p;
  if (y0 * y1 > 0) then Error(ERR_NOCONVERGE);
  repeat
    for n:= 1 to 16 do begin
      x := (x1 + x0) * 0.5;
      y := FCum(x) - p;
      if y > 0 then begin (* Non serve testare y0*y in quanto y0 < 0 sempre!!*)
        x1:= x;
      end
      else begin
        x0:= x;
      end;
    end;
  until (abs(x1-x0) <= x0 * cZERO) and (abs(y) <= cZERO);
  XVal:= (x1 + x0) * 0.5;
end;

function TContDistrib.Random: TReal;
begin
  Random:= XVal(System.Random);
end;

constructor TMaxDistrib.MaxDistrib;
begin
  F1:= AF1; F2:= AF2;
end;

function TMaxDistrib.Name: string;
begin
  Name:= 'Max of '+F1.Name+' and '+F2.Name;
end;

function TMaxDistrib.fDis(x: TReal): TReal;
begin
  fDis:= F1.fdis(x)*F2.FCum(x) + F2.fDis(x)*F1.FCum(x);
end;

function TMaxDistrib.FCum(x: TReal): TReal;
begin
  FCum:= F1.FCum(x) * F2.FCum(x);
end;

destructor TMaxDistrib.Destroy;
begin
  if (F2 <> F1) then begin
    F2.Free;
    F2:= nil;
  end;
  F1.Free;
  F1:= nil;
end;

constructor TMinDistrib.MinDistrib;
begin
  F1:= AF1; F2:= AF2;
end;

function TMinDistrib.Name: string;
begin
  Name:= 'Min of '+F1.Name+' and '+F2.Name;
end;

function TMinDistrib.fDis(x: TReal): TReal;
begin
  fDis:= F1.fdis(x)*F2.FCum(x) + F2.fDis(x)*F1.FCum(x) -
    F1.fDis(x) - F2.fDis(x);
end;

function TMinDistrib.FCum(x: TReal): TReal;
begin
  FCum:= (1-F1.FCum(x)) * (1-F2.FCum(x));
end;

constructor TParalDistrib.ParalDistrib;
begin
  F1:= AF1; F2:= AF2;
end;

function TParalDistrib.Name: string;
begin
  Name:= 'Parallel of '+F1.Name+' and '+F2.Name;
end;

constructor TSerieDistrib.SerieDistrib;
begin
  F1:= AF1; F2:= AF2;
end;

function TSerieDistrib.Name: string;
begin
  Name:= 'Serie of '+F1.Name+' and '+F2.Name;
end;

function TSerieDistrib.fDis(x: TReal): TReal;
begin
  fDis:= -inherited fDis(x);
end;

function TSerieDistrib.FCum(x: TReal): TReal;
begin
  FCum:= 1-inherited FCum(x);
end;


(* Distribuzione uniforme *)
constructor TCUniform.Uniform(aa, bb: TReal);
begin
  if aa > bb then begin
    a:= bb;
    b:= aa;
  end
  else begin
    a:= aa;
    b:= bb;
  end;
  tmp:= 1/(b-a);
end;

procedure TCUniform.SetA(aa: TReal);
begin
  if aa > b then begin
    a:= b;
    b:= aa;
  end
  else begin
    a:= aa;
  end;
  tmp:= 1 / (b-a)
end;

function TCUniform.GetA: TReal;
begin
  GetA:= a;
end;

procedure TCUniform.SetB(bb: TReal);
begin
  if bb < a then begin
    b:= a;
    a:= bb;
  end
  else begin
    b:= bb;
  end;
  tmp:= 1 / (b-a)
end;

function TCUniform.GetB: TReal;
begin
  GetB:= b;
end;

function TCUniform.Name: string;
begin
  Name:='Uniform Probability Density';
end;

function TCUniform.fDis(x: TReal): TReal;
begin
  if (x >= a) and (x <= b) then fDis:= tmp else fDis:= 0;
end;

function TCUniform.FCum(x: TReal): TReal;
begin
  if x <= a then FCum:= 0
  else if x < b then FCum := (x-a) * tmp
  else FCum:= 1;
end;

function TCUniform.XVal(p: TReal): TReal;
begin
  if (p<0) or (p>1) then Error(ERR_OUTOFRANGE);
  XVal:= a + p * (b-a);
end;

function TCUniform.Random: TReal;
begin
  Random:= a + System.Random * (b-a);
end;

function TCUniform.Mean: TReal;
begin
  Mean:= 0.5 * (a + b);
end;

function TCUniform.Variance: TReal;
begin
  Variance:= sqr(b - a) * ONEOVER12;
end;
(* funzione generatrice momenti  *)
(* E[exp(tx)] = (exp(bt) - exp(at)) / ((b-a) * t) *)

(* Distriuzione normale standardizzata *)
constructor TNormal.Normal;
begin
  OldZ:= 0;
  Vld:= false;
end;

function TNormal.Name: string;
begin
  Name:='Stndard Normal Probability Density';
end;

function TNormal.fDis(x: TReal): TReal;
begin
  fDis:= EXP(-(sqr(x) * 0.5)) * UNOSURADICEDUEPI;
end;

function TNormal.CalcfDis(x: TReal): TReal;
begin
  CalcfDis:= EXP(-(sqr(x) * 0.5)) * UNOSURADICEDUEPI;
end;

function TNormal.FCum(x: TReal): TReal;
(* Errore < ZERO *)
var
  xx: TReal;
  tmp: TReal;
begin
  xx:= abs(x);
  if xx > 10 then tmp:= 1
  else if xx < 1.8 then tmp:= NorSmallNum(xx)
  else tmp:= NorBigNum(xx);
  if x < 0 then FCum:= 1 - tmp else FCum:= tmp;
end;

function TNormal.XVal(p: TReal): TReal;
(* Trova il valore di x a cui e' associata la probailita' p della
   distribuzione normale standardizzata *)
var
  b, f: integer;
  x, xp, z, p0 : TReal;
begin
  if p <= IMPO then begin XVal:= -1E38; exit; end; (* Sarebbe -infinito *)
  if p >= CERT then begin XVal:= +1E38; exit; end; (* Sarebbe +infinito *)
  if p < 0.5 then begin f:= -1; p:= 1 - p; end else f:= 1;
  x := sqrt(PI/8) * ln(p/(1-p)); (* valore iniziale approssimativo *)
  for b:= 1 to 30 do begin
    z:= CalcfDis(x);
    if x < 1.8 then p0:= NorSmallNum(x) else p0:= NorBigNum(x);
    xp := x;
    x:= x - (p0-p) / (z + (p0-p) * 0.5);
    if abs(xp-x) <= (x * cZERO) then break;
  end;
  XVal:= f*x;
end;

function TNormal.Random: TReal;
(* Made with Box-Muller-Marsaglia method *)
var
  tmp: TReal;
  tmp2: TReal;
begin
  if Vld then begin
    Random:= OldZ;
    Vld:= false;
  end
  else begin
    Vld:= true;
    tmp:= sqrt(-ln(System.Random));
    tmp2:= System.Random;
    OldZ:= sin(2* PI * tmp2) * tmp;
    Random:= cos(2* PI * tmp2) * tmp;
  end;
end;

function TNormal.Mean: TReal;
begin
  Mean:= 0;
end;

function TNormal.Variance: TReal;
begin
  Variance:= 1;
end;

(* Calcoli relativi alla distribuzione normale *)
(* tratti da Personal Software #16 Marzo/1984 pagina 67 *)
function TNormal.NorBigNum(x: TReal): TReal; (* Calcola funzione normale x > 1.8 *)
var
  pn, pn_2, pn_1, qn, qn_2, qn_1: TReal;
  pp, p2, z: TReal;
  n : integer;
begin
  z:= fDis(x);
  pn_2:= 0;
  pn_1:= 1;
  qn_2:= 1;
  qn_1:= x;
  pp:= 1/x;
  for n:= 3 to 35 do begin
    pn:= x * pn_1 + (n-2) * pn_2;
    qn:= x * qn_1 + (n-2) * qn_2;
    p2 := pn / qn;
    if z*abs(pp-p2) < cZERO then break;
    pp:= p2;
    pn_2:= pn_1;
    qn_2:= qn_1;
    pn_1:= pn;
    qn_1:= qn;
  end;
  NorBigNum:= 1 - z * p2;
end;

function TNormal.NorSmallNum(x: TReal): TReal; (* Calcola funzione normale x <= 1.8 *)
var
  p, q: TReal;
  i : integer;
begin
  p:= 1;
  q:= 1;
  for i:= 1 to 30 do begin
    p:= -p*sqr(x)*0.5/i;
    q:= q + p/(2*i+1);
    if x*abs(p*UNOSURADICEDUEPI)/(2*i+1) <= cZERO then break;
  end;
  NorSmallNum:= 0.5+x*q*UNOSURADICEDUEPI;
end;
(* funzione generatrice dei momenti *)
(* m(t) = exp(mu * t + (sigma^2 * t^2) / 2)  *)

(* Distriuzione normale *)
constructor TNormale.Normale(mu, si: TReal);
begin
  inherited Normal;
  Media:= mu;
  Scarto:= si;
end;

procedure TNormale.SetMedia(mu: TReal);
begin
  Media:= mu;
end;

function TNormale.GetMedia: TReal;
begin
  GetMedia:= Media;
end;

procedure TNormale.SetScarto(si: TReal);
begin
  Scarto:= si;
end;

function TNormale.GetScarto: TReal;
begin
  GetScarto:= Scarto;
end;

function TNormale.Name: string;
begin
  Name:='Normal Probability Density';
end;

function TNormale.fDis(x: TReal): TReal;
begin
  fDis:= inherited fDis((x - Media) / Scarto);
end;

function TNormale.FCum(x: TReal): TReal;
begin
  FCum:= inherited FCum((x - Media) / Scarto);
end;

function TNormale.XVal(p: TReal): TReal;
begin
  XVal:= inherited XVal(p) * Scarto + Media;
end;

function TNormale.Random: TReal;
begin
  Random:= inherited Random * Scarto + Media;
end;

function TNormale.Mean: TReal;
begin
  Mean:= Media;
end;

function TNormale.Variance: TReal;
begin
  Variance:= sqr(Scarto);
end;

constructor TLogNor.LogNor(alpha, beta: TReal);
begin
  inherited Normal;
  mu:= alpha;
  sigma:= beta;
end;

procedure TLogNor.SetMedia(alpha: TReal);
begin
  mu:= alpha;
end;

function TLogNor.GetMedia: TReal;
begin
  GetMedia:= mu;
end;

procedure TLogNor.SetScarto(beta: TReal);
begin
  sigma:= beta;
end;

function TLogNor.GetScarto: TReal;
begin
  GetScarto:= sigma;
end;

function TLogNor.Name: string;
begin
  Name:='Log-Normal Probability Density';
end;

function TLogNor.fDis(x: TReal): TReal;
begin
  if x <= 0 then fDis:= 0
  else fDis:= 1/(x*RADICEDUEPI*sigma)*exp(-sqr(ln(x) - mu)/(2*sqr(sigma)));
end;

function TLogNor.FCum(x: TReal): TReal;
begin
  FCum:= inherited FCum((ln(x)-mu)/sigma);
end;

function TLogNor.XVal(p: TReal): TReal;
begin
  XVal:= exp(inherited XVal(p) * sigma + mu);
end;

function TLogNor.Random: TReal;
begin
  Random:= exp(inherited XVal(System.Random) * sigma + mu);
end;

function TLogNor.Mean: TReal;
begin
  Mean:= exp(mu + 0.5*sqr(sigma));
end;

function TLogNor.Variance: TReal;
begin
  Variance:= exp(2*mu + 2 * sqr(sigma)) - exp(2*mu+sqr(sigma));
end;

(* Distribuzione esponenziale nagativa *)
constructor TExp.ExpDis(lam: TReal);
begin
  lambda:= lam;
end;

function TExp.Name: string;
begin
  Name:='Exponential Probability Density';
end;

procedure TExp.SetLambda(lam: TReal);
begin
  Lambda:= lam;
end;

function TExp.GetLambda: TReal;
begin
  GetLambda:= lambda;
end;

function TExp.fDis(x: TReal): TReal;
begin
  if x > 0 then fDis:= lambda * exp(-lambda * x)
  else fDis:= 0;
end;

function TExp.FCum(x: TReal): TReal;
begin
  if x <= 0 then FCum:= 0
  else FCum:= 1 - exp(-lambda * x);
end;

function TExp.XVal(p: TReal): TReal;
begin
  if (p<0) or (p>1) then Error(ERR_OUTOFRANGE);
  if p < cZERO then XVal:= 0
  else XVal:= -ln(1-p) / lambda;
end;

function TExp.Random: TReal;
var p: TReal;
begin
  p:= System.Random;
  if p < cZERO then Random:= 0
  else Random:= -ln(1-p) / lambda;
end;

function TExp.Mean: TReal;
begin
  Mean:= 1 / lambda;
end;

function TExp.Variance: TReal;
begin
  Variance:=  1 / sqr(lambda);
end;
(* funzione generatrice momenti m(t) = lambda / (lambda - t), t < lambda *)

(* Distribuzione Gamma *)
constructor TGamma.GammaDis(rr, lam: TReal);
begin
  R:= rr;
  lambda:= lam;
  inherited ContDistrib;
end;

function TGamma.Name: string;
begin
  Name:='Gamma Probability Density';
end;

procedure TGamma.SetR(rr: TReal);
begin
  R:= rr;
end;

function TGamma.GetR: TReal;
begin
  GetR:= R;
end;

procedure TGamma.SetLambda(lam: TReal);
begin
  Lambda:= lam;
end;

function TGamma.GetLambda: TReal;
begin
  GetLambda:= Lambda;
end;

function TGamma.fDis(x: TReal): TReal;
begin
  if x <= 0 then fDis:= 0
  else fDis:= lambda / Gamma(r) * Power(lambda*x, r-1) * exp(-lambda*x);
end;

function TGamma.FCum(x: TReal): TReal;
const
  xp : array[1..5] of TReal = (0.1488743389, 0.4333953941, 0.6794095682, 0.8650633666, 0.9739065285);
  wp : array[1..5] of TReal = (0.2955242247, 0.2692667193, 0.2190863625, 0.1494513491, 0.0666713443);
var
  i,rr: longint;
  stp,tmp, f,rf: TReal;
  j: integer;
  t,a,b,dx, xr, xm: TReal;
begin
  if (x<=0) then begin
    FCum:= 0;
    exit;
  end;
  t:= lambda*x;
  tmp:= r;
  rr:= trunc(r)-1; r:= frac(r);
  f:= 0;
  if rr>=1 then begin
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
  if r>cZERO then begin
    rf:= 0;
    stp:= 0.25;
    a:= 0;
    b:= stp;
    xr:= 0.5*stp;
    while (b<=x) do begin
      xm:= 0.5*(a+b);
      for j:= 1 to 5 do begin
        dx:= xr*xp[j];
        rf:= rf+wp[j] * (fDis(xm+dx) + fDis(xm-dx));
      end;
      a:= b;
      b:= b+stp;
    end;
  end
  else begin rf:= 1; xr:= (1-exp(-t)); end;
  r:= tmp;
  FCum:= f+rf*xr;
end;

function TGamma.Mean: TReal;
begin
  Mean:= r / lambda;
end;

function TGamma.Variance: TReal;
begin
  Variance:= r / sqr(lambda);
end;
(* funzione generatrice momenti m(t) = (lambda / (lambda - t)^r , t < lambda *)

(* Distribuzione Weibull *)
constructor TWeibull.Weibull(al, be: TReal);
begin
  alpha:= al;
  beta := be;
end;

procedure TWeibull.SetAlpha(al: TReal);
begin
  Alpha:= al;
end;

function TWeibull.GetAlpha: TReal;
begin
  GetAlpha:= Alpha;
end;

procedure TWeibull.SetBeta(bt: TReal);
begin
  Beta:= bt;
end;

function TWeibull.GetBeta: TReal;
begin
  GetBeta:= Beta;
end;

function TWeibull.Name: string;
begin
  Name:='Weibull Probability Density';
end;

function TWeibull.fDis(x: TReal): TReal; (* alpha, beta >= 0 *)
begin
  if x > 0 then fDis:= alpha * beta * Power(x, beta-1) * exp(-alpha*Power(x, beta))
  else fDis:= 0;
end;

function TWeibull.FCum(x: TReal): TReal;
begin
  if x <= 0 then FCum := 0
  else FCum := 1 - exp(-alpha * Power(x, beta));
end;

function TWeibull.XVal(p: TReal): TReal;
begin
  if (p<0) or (p>1) then Error(ERR_OUTOFRANGE);
  if p < cZERO then XVal:= 0
  else XVal:= exp(ln(-ln(1 - p) / alpha) / beta);
end;

function TWeibull.Random: TReal;
var p: TReal;
begin
  p:= System.Random;
  if p < cZERO then Random:= 0
  else Random:= exp(ln(-ln(1 - System.Random) / alpha) / beta);
end;

function TWeibull.Mean: TReal;
begin
  Mean:= Power(alpha, -1/beta)* Gamma(1+1/beta);
end;

function TWeibull.Variance: TReal;
begin
  Variance:= Power(alpha, -2/beta) * (Gamma(1+2/beta) - sqr(Gamma(1+1/beta)));
end;

(* Distribuzione Beta *)
constructor TBeta.BetaDis(al, be: TReal);
begin
  alpha:= al;
  beta := be;
  if (abs(alpha - beta) < cZERO) and (abs(beta - 1) < cZERO) then flag:= true else flag:= false;
  inherited ContDistrib;
end;

function TBeta.Name: string;
begin
  Name:='Beta Probability Density';
end;

procedure TBeta.SetAlpha(al: TReal);
begin
  Alpha:= al;
  if (alpha = beta) and (beta = 1) then flag:= true else flag:= false;
end;

function TBeta.GetAlpha: TReal;
begin
  GetAlpha:= Alpha;
end;

procedure TBeta.SetBeta(bt: TReal);
begin
  Beta:= bt;
  if (abs(alpha - beta) < cZERO) and (abs(beta - 1) < cZERO) then flag:= true else flag:= false;
end;

function TBeta.GetBeta: TReal;
begin
  GetBeta:= Beta;
end;

function TBeta.fDis(x: TReal): TReal;
begin
  if (x > cZERO) and (x < CERT) then begin
    if flag then fDis:= 1
    else fDis:= Gamma(alpha+beta)/(Gamma(alpha)*Gamma(beta))*Power(x, alpha-1)*Power(1-x, beta-1)
  end
  else fDis:= 0;
end;

function TBeta.FCum(x: TReal): TReal;
const
  itmax = 100;
var 
  am, bm, az, qab, qap, qam, bz, d, ap, bp, app, bpp, aold: TReal;
  tem, m, em: integer;
begin
  Result:= 0;
  if x < cZERO then FCum := 0
  else if x > CERT then FCum:= 1
  else begin
    if (beta = 1) and (alpha = beta) then begin
      FCum:= x;
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
      if (abs(az-aold) < cZERO * abs(az)) then begin
        FCum:= az;
        exit;
      end;
    end;
    Error(ERR_NOCONVERGE);
  end;
end;

function TBeta.XVal(p: TReal): TReal;
var
  bt, tmp: TReal;
begin
  if (p < 0) or (p > 1) then Error(ERR_BETAIPARAM);
  if (beta = 1) and (alpha = beta) then begin
    XVal:= p;
    exit;
  end;
  if (p = 0) or (p = 1) then begin
    bt:= 0;
  end
  else begin
    bt:= exp(GammaLN(alpha+beta) - GammaLN(alpha) - GammaLN(beta) + alpha * ln(p) + beta * ln(1-p));
  end;
  if (p < (alpha+1)/(alpha+beta+2)) then begin
    XVal:= bt * FCum(p) / alpha;
  end
  else begin
    tmp:= alpha;
    alpha:= beta;
    beta:= tmp;
    XVal:= 1 - bt * FCum(1-p) / alpha;
    beta:= alpha;
    alpha:= tmp;
  end;
end;

function TBeta.Mean: TReal;
begin
  Mean:= alpha / (alpha + beta);
end;

function TBeta.Variance: TReal;
begin
  Variance:= alpha * beta / sqr(alpha+beta)*(alpha+beta+1);
end;

(* Distribuzione TStudent *)
constructor TTStudent.TStudent(dof: TReal);
begin
  d:= dof;
  imin:= -15; imax:= 15;
end;

function TTStudent.Name: string;
begin
  Name:='TStudent Probability Density';
end;

procedure TTStudent.SetDegOfFre(dof: TReal);
begin
  d:= dof;
end;

function TTStudent.GetDegOfFre: TReal;
begin
  GetDegOfFre:= d;
end;

function TTStudent.fDis(x: TReal): TReal;
begin
  fDis:= (Power(d, d*0.5) * Gamma((1+d)*0.5))/(sqrt(x)*Gamma(0.5)*Gamma(d*0.5)*Power(d+X, (1+d)*0.5));
end;

function TTStudent.FCum(x: TReal): TReal;
var
  i: integer;
  tt, vt, bt, t: TReal;
  nu: integer;
begin
  nu:= round(d);
  if nu > 50 then begin
    FCum:= inherited FCum(x);
    exit;
  end;
  X:= X / sqrt(NU);
  T:= ArcTan(X); (* T = theta *)
  if nu = 1 then begin
    FCum := T * 0.6366197724;
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
  FCum:= (1 + bt) * 0.5;
end;

function TTStudent.Mean: TReal;
begin
  Mean:= 0;
end;

function TTStudent.Variance: TReal;
begin
  if d <> 2 then Variance:= d/(d-2) else Variance:= 0;
end;

constructor TChiQuad.ChiQuad(dof: TReal);
begin
  v:= dof;
  imin:= 0.1;
  imax:= 75;
end;

function TChiQuad.Name: string;
begin
  Name:='Chi Square Probability Density';
end;

procedure TChiQuad.SetDegOfFre(dof: TReal);
begin
  v:= dof;
end;

function TChiQuad.GetDegOfFre: TReal;
begin
  GetDegOfFre:= v;
end;

function TChiQuad.fDis(x: TReal): TReal;
begin
  if x <= 0 then fDis:= 0
  else fDis:= 0.5 / Gamma(0.5*v) * Power(0.5*x, 0.5*v-1) * exp(-0.5*x);
end;

function TChiQuad.FCum(x: TReal): TReal;
var
  r: TReal; (* R=PRODOTTO AL DENOMINATORE *)
  k: TReal; (* K=PRODOTTO AL NUMERATORE   *)
  m, j: TReal;
  l: TReal; (* L=FATTORE DI SOMMATORIA    *)
  vv, i: longint;
begin
  vv:= round(v);
  if vv > 30 then begin
    FCum:= inherited FCum(x);
    exit;
  end;
  if x < cZERO then begin
    FCum:= 0;
    exit;
  end;
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
  until M < cZERO;
  FCum:= J * K * L
end;

function TChiQuad.Mean: TReal;
begin
  Mean:= v;
end;

function TChiQuad.Variance: TReal;
begin
  Variance:= 2*v;
end;

constructor TFisher.Fisher(dof1, dof2: TReal);
begin
  inherited ContDistrib;
  df1:= dof1;
  df2:= dof2;
  imin:= cZERO; imax:= 300;
  B1.BetaDis(0.5 * df1, 0.5 * df2); B2.BetaDis(0.5 * df2, 0.5 * df1);
end;

function TFisher.Name: string;
begin
  Name:='Fisher Probability Density';
end;

procedure TFisher.SetDegOfFreN(dof1: TReal);
begin
  df1:= dof1;
  B1.SetAlpha(0.5 * df1); B2.SetBeta(0.5 * df1);
end;

function TFisher.GetDegOfFreN: TReal;
begin
  GetDegOfFreN:= df1;
end;

procedure TFisher.SetDegOfFreD(dof2: TReal);
begin
  df2:= dof2;
  B1.SetBeta(0.5 * df2); B2.SetAlpha(0.5 * df2);
end;

function TFisher.GetDegOfFreD: TReal;
begin
  GetDegOfFreD:= df2;
end;

function TFisher.fDis(x: TReal): TReal;
begin
  fDis:= (Power(df1, df1 * 0.5) * Power(df2, df2*0.5) * Gamma((df1+df2)*0.5) * Power(x, df1 * 0.5 - 1)) /
   (Gamma(df1*0.5)*Gamma(df2*0.5)*Power(df2+df1*X, (df1+df2)*0.5));
end;

function TFisher.FCum(x: TReal): TReal;
begin
  FCum:= 0.5 - (B2.XVal(df2/(df2+df1*x)) - B1.XVal(df1/(df1+df2/x)))*0.5;
end;

function TFisher.Mean: TReal;
begin
  Mean:= df2/(df2-2);
end;

function TFisher.Variance: TReal;
begin
  Variance:= 2*sqr(df2)*(df1+df2-2)/(df1*sqr(df2-2)*(df2-4));
end;

destructor TFisher.Destroy;
begin
  B1.Free;
  B2.Free;
end;

(* Distribuzione Uniforme *)
constructor TDUniform.Uniform(nn: TInteger);
begin
  if nn <= 0 then Error(ERR_OUTOFRANGE);
  n:= nn;
  tmp:= 1/n;
end;

procedure TDUniform.SetN(nn: TInteger);
begin
  if nn <= 0 then Error(ERR_OUTOFRANGE);
  n:= nn;
  tmp:= 1/n;
end;

function TDuniform.GetN: TInteger;
begin
  GetN:= n;
end;

function TDuniform.Name: string;
begin
  Name:='Uniform Probability Distribution';
end;

function TDUniform.fDis(x: TInteger): TReal;
begin
  if (x > 0) and (x <= N) then fDis := tmp
  else fDis:= 0;
end;

function TDUniform.FCum(x: TInteger): TReal;
begin
  if (x < 1) then FCum:= 0
  else if (x <= N) then FCum:= x * tmp
  else FCum:= 1;
end;

function TDUniform.XVal(p: TReal): TInteger;
begin
  if (p<0) or (p>1) then Error(ERR_OUTOFRANGE);
  XVal:= trunc(n * p);
end;

function TDUniform.Random: TInteger;
begin
  Random:= succ(System.Random(n));
end;

procedure TDUniform.NextfDis(var X: TInteger; var CalcfDis: TReal);
begin
  inc(X);
  if (X > N) or (X < 1) then CalcfDis:= 0;
end;

procedure TDUniform.NextFCum(var X: TInteger; var CalcFCum: TReal);
begin
  inc(X);
  if CalcFCum < CERT then CalcFCum:= CalcFCum + tmp;
end;

function TDUniform.Mean: TReal;
begin
  Mean:= succ(N) shr 1;
end;

function TDUniform.Variance: TReal;
begin
  Variance := pred(sqr(N)) * ONEOVER12;
end;

(* funzione generatrice dei momenti *)
(* E[exp(tx)] = sum(exp(jt), j, 1, N) / N *)

(* Distribuzione di Bernulli *)
constructor TBernulli.Bernulli(p: TReal);
begin
  if (p < 0) or (p > 1) then Error(ERR_OUTOFRANGE);
  pr:= p;
end;

procedure TBernulli.SetP(p: TReal);
begin
  if (p < 0) or (p > 1) then Error(ERR_OUTOFRANGE);
  pr:= p;
end;

function TBernulli.GetP: TReal;
begin
  GetP:= pr;
end;

function TBernulli.Name: string;
begin
  Name:='Bernulli Probability Distribution';
end;

function TBernulli.fDis(x: TInteger): TReal;
begin
  case x of
    0: fDis:= 1-pr;
    1: fDis:= pr;
    else fDis:= 0;
  end;
end;

function TBernulli.FCum(x: TInteger): TReal;
begin
  if x < 0 then FCum := 0
  else if x < 1 then FCum := pr
  else FCum := 1;
end;

function TBernulli.XVal(p: TReal): TInteger;
begin
  if (p<0) or (p>1) then Error(ERR_OUTOFRANGE);
  if p >= pr then XVal:= 0
  else XVal:= 1;
end;

function TBernulli.Random: TInteger;
begin
  if random >= pr then Random:= 0 else Random:= 1;
end;

function TBernulli.Mean: TReal;
begin
  Mean:= pr;
end;

function TBernulli.Variance: TReal;
begin
  Variance:= pr*(1-pr);
end;

(* Funzione generatrice dei momenti *)
(* E[exp(tx)] = (1-p) + p*exp(t) *)

constructor TBinomial.Binomial(N: TInteger; p: TReal);
begin
  if (p < 0) or (p > 1) or (n < 0) then Error(ERR_OUTOFRANGE);
  pr:= p;
  nn:= n;
  if (1-pr) < cZero then tmp:= cInf
  else tmp := pr / (1-pr);
  imin:= -1; imax:= n;
end;

procedure TBinomial.SetP(p: TReal);
begin
  if (p < 0) or (p > 1) then Error(ERR_OUTOFRANGE);
  pr:= p;
  if (1-pr) < cZero then tmp:= cInf
  else tmp := pr / (1-pr);
end;

function TBinomial.GetP: TReal;
begin
  GetP:= pr;
end;

procedure TBinomial.SetN(N: TInteger);
begin
  if (n < 0) then Error(ERR_OUTOFRANGE);
  nn:= N;
  imax:= n;
end;

function TBinomial.GetN: TInteger;
begin
  GetN:= nn;
end;

function TBinomial.Name: string;
begin
  Name:='Binomial Probability Distribution';
end;

function TBinomial.fDis(x: TInteger): TReal;
begin
  fDis:= exp(ln(Combinazioni(nn, x)) + X * ln(pr) + (nn - X) * ln(1-pr));
end;

procedure TBinomial.NextfDis(var X: TInteger; var CalcfDis: TReal);
begin
  inc(X);
  if x < 0  then CalcfDis:= 0
  else if x = 0 then CalcfDis:= exp(nn * ln(1-pr))
  else if x <= nn then CalcfDis:= CalcfDis * (nn - pred(x)) / x * tmp
  else CalcfDis:= 0;
end;

function TBinomial.Mean: TReal;
begin
  Mean:= nn*pr;
end;

function TBinomial.Variance: TReal;
begin
  Variance:= nn*pr*(1-pr);
end;

(* Funzione generatrice dei momenti *)
(* E[exp(tx)] = (1-p) + p*exp(t) *)

(* Distribuzione ipergeometrica *)
(* Approssimabile con la binomiale se M/n >= 10, p:= K/M *)
constructor TIperGeom.IperGeom(M, K, n: TInteger);
begin
  if (M <= 0) or (n <= 0) or (K < 0) or (K > M) or (n > M) then Error(ERR_OUTOFRANGE);
  MM:= M;
  KK:= K;
  nn:= n;
  imin:= -1; imax:= n;
end;

procedure TIperGeom.SetM(M: TInteger);
begin
  if (M <= 0) then Error(ERR_OUTOFRANGE);
  if nn > MM then nn:= M;
  if KK > MM then KK:= M;
  MM:= M;
end;

function TIperGeom.GetM: TInteger;
begin
  GetM:= MM;
end;

procedure TIperGeom.SetK(K: TInteger);
begin
  if (K < 0) then Error(ERR_OUTOFRANGE);
  if K > MM then K:= MM;
  KK:= K;
end;

function TIperGeom.GetK: TInteger;
begin
  GetK:= KK;
end;

procedure TIperGeom.SetN(N: TInteger);
begin
  if (N <= 0) then Error(ERR_OUTOFRANGE);
  if N > MM then N:= MM;
  nn:= N;
  imax:= n;
end;

function TIperGeom.GetN: TInteger;
begin
  GetN:= nn;
end;

function TIperGeom.Name: string;
begin
  Name:='IperGeometric Probability Distribution';
end;

function TIperGeom.fDis(x: TInteger): TReal;
begin
  fDis:= exp(ln(Combinazioni(KK, x)) + ln(Combinazioni(MM-KK, nn-x)) - ln(Combinazioni(MM, nn)));
end;

procedure TIperGeom.NextfDis(var X: TInteger; var CalcfDis: TReal);
begin
  inc(X);
  if x < 0  then CalcfDis:= 0
  else if x = 0 then CalcfDis:= fDis(0)
  else if x <= nn then CalcfDis:= CalcfDis * (nn - pred(x)) * (MM - pred(x)) / (x * (MM-KK-nn+x))
  else CalcfDis:= 0;
end;

function TIperGeom.Mean: TReal;
begin
  Mean := nn * KK / MM;
end;

function TIperGeom.Variance: TReal;
begin
  Variance := nn * KK * (MM - KK) * (MM - nn) / (sqr(MM) * pred(MM));
end;

(* Distribuzione di Poisson *)
constructor TPoisson.Poisson(lam: TReal);
begin
  if (lambda < 0) then Error(ERR_OUTOFRANGE);
  lambda:= lam;
  imin:= -1; imax:= maxint;
end;

procedure TPoisson.SetLambda(lam: TReal);
begin
  if (lambda < 0) then Error(ERR_OUTOFRANGE);
  lambda:= lam;
end;

function TPoisson.GetLambda: TReal;
begin
  GetLambda:= Lambda;
end;

function TPoisson.Name: string;
begin
  Name:='Poisson Probability Distribution';
end;

function TPoisson.fDis(x: TInteger): TReal;
begin
  fDis:= exp(-lambda + X * ln(lambda) - LnFattoriale(x));
end;

procedure TPoisson.NextfDis(var X: TInteger; var CalcfDis: TReal);
begin
  inc(X);
  if x < 0  then CalcfDis:= 0
  else if x = 0 then CalcfDis:= exp(-lambda)
  else CalcfDis:= CalcfDis * lambda / x;
end;

function TPoisson.Mean: TReal;
begin
  Mean:= lambda;
end;

function TPoisson.Variance: TReal;
begin
  Variance:= lambda;
end;

constructor TGeometric.Geometric(p: TReal);
begin
  if (p < 0) or (p > 1) then Error(ERR_OUTOFRANGE);
  pr:= p;
  imin:= -1; imax:= maxint;
end;

procedure TGeometric.SetP(p: TReal);
begin
  if (p < 0) or (p > 1) then Error(ERR_OUTOFRANGE);
  pr:= p;
end;

function TGeometric.GetP: TReal;
begin
  GetP:= pr;
end;

function TGeometric.Name: string;
begin
  Name:='Geometric Probability Distribution';
end;

function TGeometric.fDis(x: TInteger): TReal;
begin
  fDis:= pr * IntPow(1-pr, x);
end;

procedure TGeometric.NextfDis(var X: TInteger; var CalcfDis: TReal);
begin
  inc(X);
  if x < 0  then CalcfDis:= 0
  else if x = 0 then CalcfDis:= pr
  else CalcfDis:= CalcfDis * (1-pr);
end;

function TGeometric.Mean: TReal;
begin
  Mean:= (1-pr) / pr;
end;

function TGeometric.Variance: TReal;
begin
  Variance:= (1-pr) / (sqr(pr));
end;

(* funzione generatrice dei momenti m(t) = p / (1- (1-p) * exp(t)) *)

(* Distribuzione binomiale negativa *)
constructor TBinNeg.BinNeg(r: TInteger; p: TReal);
begin
  if (p < 0) or (p > 1) or (r < 0) then Error(ERR_OUTOFRANGE);
  pr:= p;
  rr:= r;
  imin:= -1; imax:= maxint;
end;

procedure TBinNeg.SetP(p: TReal);
begin
  if (p < 0) or (p > 1) then Error(ERR_OUTOFRANGE);
  pr:= p;
end;

function TBinNeg.GetP: TReal;
begin
  GetP:= pr;
end;

procedure TBinNeg.SetR(r: TInteger);
begin
  if (r<0) then Error(ERR_OUTOFRANGE);
  rr:= r;
end;

function TBinNeg.GetR: TInteger;
begin
  GetR:= rr;
end;

function TBinNeg.Name: string;
begin
  Name:='Negative Binomial Probability Distribution';
end;

function TBinNeg.fDis(x: TInteger): TReal;
begin
  fDis:= Combinazioni(rr + pred(x) ,x) * IntPow(pr, rr) * IntPow(1-pr, x);
end;

procedure TBinNeg.NextfDis(var X: TInteger; var CalcfDis: TReal);
begin
  inc(X);
  if x < 0  then CalcfDis:= 0
  else if x = 0 then CalcfDis:= exp(rr * ln(pr))
  else CalcfDis:= CalcfDis * (1-pr) * (rr - pred(x) / x);
end;

function TBinNeg.Mean: TReal;
begin
  Mean:= rr * (1-pr) / pr;
end;

function TBinNeg.Variance: TReal;
begin
  Variance := rr * pr / (sqr(pr));
end;

(* funzione generatrice dei momenti m(t) = (p / (1 - (1-p) * exp(t)))^r *)

(* Distribuzione Dicee *)
constructor TDiceDis.DiceDis(HowManyDice, NumberOfFaces: TInteger);
begin
  if (NumberOfFaces < 1) or (HowManyDice < 1) then Error(ERR_OUTOFRANGE);
  Fac:= NumberOfFaces;
  Num:= HowManyDice;
  imin:= pred(HowManyDice);
  imax:= Fac * Num;
  tmp:= 1 / IntPow(Fac, Num);
  MakeCof;
end;

procedure TDiceDis.SetNum(HowManyDice: TInteger);
begin
  if HowManyDice < 1 then Error(ERR_OUTOFRANGE);
  DoneCof;
  Num:= HowManyDice;
  imax:= Fac * Num;
  imin:= pred(HowManyDice);
  tmp:= 1 / IntPow(Fac, Num);
  MakeCof;
end;

function TDiceDis.GetNum: TInteger;
begin
  GetNum:= Num;
end;

procedure TDiceDis.SetFac(NumberOfFaces: TInteger);
begin
  if NumberOfFaces < 1 then Error(ERR_OUTOFRANGE);
  DoneCof;
  Fac:= NumberOfFaces;
  imax:= Fac * Num;
  tmp:= 1 / IntPow(Fac, Num);
  MakeCof;
end;

function TDiceDis.GetFac: TInteger;
begin
  GetFac:= Fac;
end;

function TDiceDis.Name: string;
begin
  Name:='The Dice Probability Distribution';
end;

function TDiceDis.fDis(x: TInteger): TReal;
begin
  if (x < Num) or (x > Num*Fac) then fDis:= 0
  else fDis:= Cof[pred(x)] * tmp;
end;

function TDiceDis.Random: TInteger;
var
  i: TInteger;
  v: TInteger;
begin
  v:= 0;
  for i:= 1 to Num do begin
    inc(v, succ(System.Random(Fac)));
  end;
  Random:= v;
end;

function TDiceDis.Mean: TReal;
begin
  Mean:= Num*(succ(Fac) shr 1);
end;

function TDiceDis.Variance: TReal;
begin
  Variance := Num * pred(sqr(Fac)) * ONEOVER12;
end;

procedure TDiceDis.MakeCof;
var
  Siz: longint;
  l, i, j, k: TInteger;
  temp: array of integer;
begin
  Siz:= Fac * Num;
  SetLength(Cof, Siz);
  SetLength(temp, Siz);
  for l:= 0 to Siz- 1 do Cof[l]:= 0;
  for i:= 0 to pred(Fac) do begin
    Cof[i]:= 1;
  end;
  for i:= 1 to pred(Num) do begin
    for l:= 0 to Siz-1 do temp[l]:= 0;
    for k:= 1 to Fac do begin
      for j:= pred(i) to pred(i * Fac) do begin
        inc(temp[j+k], Cof[j]);
      end;
    end;
    for l:= 0 to Siz-1 do Cof[l]:= temp[l];
  end;
end;

procedure TDiceDis.DoneCof;
begin
  SetLength(Cof, 0);
end;

destructor TDiceDis.Destroy;
begin
  DoneCof;
end;

(* funzione generatrice dei momenti *)
(* E[exp(tx)] = (sum(exp(jt), j, 1, Face) / Face) ^ NumOfDice *)
(* E[z^-(x)] = (sum(z^-j, j, 1, Face) / Face) ^ NumOfDice *)

end.

