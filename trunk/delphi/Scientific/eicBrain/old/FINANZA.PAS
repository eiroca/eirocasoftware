unit Finanza;

{$I switches.inc}

interface

uses MathStt1, MathTool;

type

  CompInte = function(R, T: PREC): PREC;

  Payment  = record
    V: PREC;
    T: PREC;
  end;

function intsem(r, t: PREC): PREC; far;
function intcom(r, t: PREC): PREC; far;
function intcon(r, t: PREC): PREC; far;

function CalcValue(cap: CompInte; PV, FV, p: PREC; n: integer; r, t: PREC): PREC;
function FV(PV, p, r, t, z: PREC): PREC;
function PV(FV, p, r, t, z: PREC): PREC;

function F_forward(S, X, r, t: PREC): PREC;
function F_forward2(cap: CompInte; S, X, r, t: PREC): PREC;
function F_put(S, X, r, sig, t: PREC): PREC;
function F_call(S, X, r, sig, t: PREC): PREC;

function CashFlow(p: array of Payment; n: integer; f: CompInte; r, t: PREC): PREC;

implementation

function intsem(r, t: PREC): PREC;
begin
  intsem:= 1+r*t;
end;

function intcom(r, t: PREC): PREC;
begin
  intcom:= Pow((1+r),t);
end;

function intcon(r, t: PREC): PREC;
begin
  intcon:= exp(r*t);
end;

function CalcValue(cap: CompInte; PV, FV, p: PREC; n: integer; r, t: PREC): PREC;
var
  tmp: PREC;
  i: integer;
begin
  tmp:= cap(r, t) * PV;
  for i:= 1 to n do begin
    tmp:= tmp + cap(r, t-i) * p;
  end;
  tmp:= tmp + cap(r, t-n) * FV;
end;

function FV(PV, p, r, t, z: PREC): PREC;
begin
  FV:= PV * Pow((1+r),t) + p * (1 + r*z) * ((Pow((1+r),t) - 1) / r);
end;

function PV(FV, p, r, t, z: PREC): PREC;
begin
  PV:= FV / Pow((1+r),t) - p / (1 + r*z) * ((1 - Pow((1+r),-t)) / r);
end;

function F_forward(S, X, r, t: PREC): PREC;
begin
  F_forward:= S - X * exp(-r*t);
end;

function F_forward2(cap: CompInte; S, X, r, t: PREC): PREC;
begin
  F_forward2:= S - X * cap(r, -t);
end;

function d(S, X, r, sig, t, z: PREC): PREC;
begin
  d:= (ln(S/X)+(r+z*sqr(sig)*0.5)*t)/(sig*sqrt(t));
end;

function F_call(S, X, r, sig, t: PREC): PREC;
begin
  F_Call:= S * NormalFCum(d(S,X,r,sig,t,1)) -X*exp(-r*t)*NormalFCum(d(S,X,r,sig,t,-1));
end;

function F_put(S, X, r, sig, t: PREC): PREC;
begin
  F_put:= F_forward(S, X, r, t) - F_call(S, X, r, sig, t);
end;

function CashFlow(p: array of Payment; n: integer; f: CompInte; r, t: PREC): PREC;
var
  i, lo, hi: integer;
  va: PREC;
begin
  lo:= Low(p); hi:= High(p);
  va:= 0;
  i:= hi-lo;
  if (n < 1) or (n > i) then n:= i;
  for i:= lo to lo+n do begin
    va:= va + P[i].V * f(r, (t - P[i].T));
  end;
  CashFlow:= va;
end;

end.
