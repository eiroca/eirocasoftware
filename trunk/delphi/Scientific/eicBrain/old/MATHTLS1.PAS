unit MathTls1;

{$I switches.inc}

interface

uses MathTool, Matrix;

type

  f_x = function(x: PREC): PREC;
  Integrator = function(f: f_x; xi, xf: PREC; n: integer): PREC;

  Pf_x        = ^f_x;
  PIntegrator = ^Integrator;

const
  WarnNone        = 0;
  WarnDerivaNulla = 1;
  WarnNonConverge = 2;

(* Combinazione lineare *)
function CL(x, a, b: PREC): PREC;

function PolyArea(var X, Y: TSVector): PREC;

function IntegTrap(f: f_x; xi, xf: PREC; n: integer): PREC; far;
function IntegSimp(f: f_x; xi, xf: PREC; n: integer): PREC; far;
function IntegSimp2(f: f_x; xi, xf: PREC; n: integer): PREC; far;
function IntegGauss(f: f_x; xi, xf: PREC; n: integer): PREC; far;
function AutoIntegrate(f: f_x; xi, xf: PREC; Integrate: Integrator): PREC;

function ZeroBisezione(f: f_x; p, x0, x1: PREC): PREC;
function ZeroNewton(f: f_x; p, x: PREC): PREC;

function ZeroPoly(var a: TSVector; var x: PREC; var f0, f1: PREC): integer;

implementation

uses HDError;

function CL(x, a, b: PREC): PREC;
begin
  CL:= a * x + b;
end;

function PolyArea(var X, Y: TSVector): PREC;
var
  i, n: TInt;
  tmp: DPREC;
begin
  N:= X.Rows-1;
  (* IL PRIMO VERTICE SERVE QUALE ULTIMO VERTICE *)
  X.At(0)^:= X.At(N)^;
  Y.At(0)^:= Y.At(N)^;
  (* CALCOLA L'AREA *)
  tmp:= 0;
  for I:= 0 to N-1 do tmp:= tmp + (X.At(I)^ + X.At(I+1)^) * (Y.At(I)^ - Y.At(I+1)^);
  PolyArea:= ABS(tmp) * 0.5;
end;

(* Integrali *)
type
  NodiPesi= record
    X, W: PREC;
  end;

const
  GaussWP: array[1..10] of NodiPesi = (
  (X: 0.076526521; W: 0.152753390),
  (X: 0.227785850; W: 0.149172990),
  (X: 0.373706090; W: 0.142096110),
  (X: 0.510867000; W: 0.131688640),
  (X: 0.636053680; W: 0.118194530),
  (X: 0.746331910; W: 0.101930120),
  (X: 0.839116970; W: 0.083276742),
  (X: 0.912234430; W: 0.062672048),
  (X: 0.963971930; W: 0.040601430),
  (X: 0.993128600; W: 0.017614007));

function IntegTrap(f: f_x; xi, xf: PREC; n: integer): PREC;
var
  d, v: PREC;
  i: integer;
begin
  D:= (xf - xi) / N;
  v:= 0;
  for i:= 0 to n do begin
    v:= v + f(xi);
    xi:= xi + d;
  end;
  IntegTrap:= (v - (f(xi) + f(xf)) * 0.5) * D;
end;

function IntegSimp(f: f_x; xi, xf: PREC; n: integer): PREC;
var
  y: PREC;
  c, d, dlt: PREC;
  i: integer;
begin
  dlt:= (xf-xi)/(2*n);
  C:= 0; D:= 0;
  for I:= 1 to (2*n)-1 do begin
    y:= f(xi + dlt*i);
    if odd(i) then d:= d + y
    else c:= c + y;
  end;
  IntegSimp:= dlt * (f(xi) + 4 * C + 2 * D + f(xf)) / 3;
end;

function IntegSimp2(f: f_x; xi, xf: PREC; n: integer): PREC;
var
  s, p: PREC;
  k: integer;
begin
  if odd(n) then inc(n);
  P:= (xf - xi) / n;
  S:= 0;
  K:= 0;
  while (k <= n-2) do begin
     S:= S + (F(xi+k*p) + 4 * F(xi+(K+1)*p) + F(xi+(K+2)*p)) * P / 3;
    inc(k,2);
  end;
  IntegSimp2:= S;
end;

function IntegGauss(f: f_x; xi, xf: PREC; n: integer): PREC;
var
  P,S,R,T: PREC;
  i,j: integer;
begin
  S:= 0.5 * (xf - xi) / N;
  T:= xi + S;
  R:= 0;
  for I:= 1 to N do begin
    P:= 0;
    for J:= 1 to 10 do begin
      P:= P + GaussWP[j].W * (f(S * GaussWP[j].x + T) + f(T - S * GaussWP[j].x));
    end;
    R:= R + P * S;
    T:= T + 2 * S;
  end;
  IntegGauss:= R;
end;

function AutoIntegrate(f: f_x; xi, xf: PREC; Integrate: Integrator): PREC;
var
  s, tmp: PREC;
  i0, i1: PREC;
  n: integer;
begin
  if xi>xf then begin
    tmp:= xi; xi:= xf; xf:= tmp;
    s:= -1;
  end
  else s:= 1;
  n:= 2;
  i0:= Integrate(f, xi, xf, n);
  inc(n);
  i1:= Integrate(f, xi, xf, n);
  while abs(i1-i0) > abs(i0)*Zero do begin
    i0:= i1;
    inc(n,5);
    i1:= Integrate(f, xi, xf, n);
  end;
  AutoIntegrate:= s*i1;
end;

(* Ricerca di zero di una funzione *)
function ZeroBisezione(f: f_x; p, x0, x1: PREC): PREC;
var
  x: PREC;
  y0, y1, y: PREC;
  n: integer;
begin
  (* Ricerca 0 con metodo bisezione *)
  y0:= f(x0) - p; y1:= f(x1) - p;
  if abs(y0) < Zero then begin
    ZeroBisezione:= x0;
    exit;
  end;
  if abs(y1) < Zero then begin
    ZeroBisezione:= x1;
    exit;
  end;
  if (y0 * y1 > 0) then begin
    ErrorHandler('Biserzione', ERR_BADINPUT);
    ZeroBisezione:= 0;
    exit;
  end;
  repeat
    x := (x1 + x0) * 0.5;
    y := f(x) - p;
    if y0*y < 0 then begin
      x1:= x;
    end
    else begin
      y0:= y;
      x0:= x;
    end;
  until (abs(y) <= ZERO);
  ZeroBisezione:= x;
end;

function ZeroNewton(f: f_x; p, x: PREC): PREC;
var
  i: integer;
  nx,yv,yp: PREC;
const Z = 0.00001;
begin
  nx:= x;
  i:= 1;
  repeat
    x:= nx;
    yv:= f(x); if abs(yv) < Zero then break;
    yp:= f(x+Z);
    NX:= X - (Z * YV) / (YP - YV);
    I:= I + 1;
  until false;
  ZeroNewton:= x;
end;

function ZeroPoly(var a: TSVector; var x: PREC; var f0, f1: PREC): integer;
var
  der: TSVector;
  NewX: PREC;
  itr, n, i: integer;
begin
  n:= A.Rows-1;
  der.Init(0,n+1);
  FOR I:= 0 TO N-1 do begin
    (* CALCOLA I COEFFICIENTI DELLA DERIVATA DEL POLINOMIO *)
    der.At(I)^:= A.At(I + 1)^ * (I+1);
  end;
  der.At(n)^:= 0;
  itr:= 0;
  ZeroPoly:= WarnNone;
  repeat
    (* CONTA LE ITERAZIONI *)
    inc(itr);
    (* CALCOLA IL VALORE DELLA FUNZIONE E DELLA DERIVATA *)
    F1:= 0;
    F0:= 0;
    FOR I:= N downto 0 do begin
      F0:= F0 * x + A.At(i)^;
      F1:= F1 * x + der.At(I)^;
    end;
    (* CONTROLLA SE LA DERIVATA E' UGUALE A ZERO; SE LO E' TERMINA LA RICERCA E STAMPA *)
    IF abs(F1) < Zero then begin
      ZeroPoly:= WarnDerivaNulla;
      break;
    end;
    (* CALCOLA IL NUOVO VALORE PROBABILE UTILIZZANDO IL PRECEDENTE *)
    NewX:= X - F0 / F1;
    IF ((abs(X-NewX) < Zero) and (abs(F0)<Zero)) or (itr>ITMAX) THEN begin
      if (itr>ITMAX) and (abs(f0)>Zero) then ZeroPoly:= WarnNonConverge;
      break;
    end;
    X:= NewX;
  until false;
  der.Done;
end;

end.
