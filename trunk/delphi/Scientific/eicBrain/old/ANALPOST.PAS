unit AnalPost;  (* Analisi postottimale *)

{$I switches.inc}

interface

uses
  PLProg, RSimplex, eLibMath, uMath;

type
   
  PAnalisiB = ^TAnalisiB;
  TAnalisiB = object
     PL: TRSimplex;
     constructor Init(ErrMng: PErrMngr);
     function    TestVar(var beta: TSVector): integer;
     function    GetVar(var delta: PREC): integer;
     function    GetDelta(var delmin, delmax: PREC): integer;
  end;

implementation

constructor TAnalisiB.Init(ErrMng: PErrMngr);
begin
  PL.Init(ErrMng);
end;

function TAnalisiB.TestVar(var beta: TSVector): integer;
var
  x: TRow;
  res, i, k: integer;
  t: TSVector;
  tmp: PREC;
  flg: boolean;
begin
  with PL do begin
    res:= Solv(x);
    TestVar:= res;
    if res <> 0 then exit;
    t.Init(0,NumVin);
    flg:= false;
    for i:= 1 to NumVin do begin
      t.At(i)^:= 1;
    end;
    for i:= 1 to NumVin do begin
      tmp:= 0;
      for k:= 1 to NumVin do begin
        tmp:= tmp + B.At(i, k)^ * (A.At(k,0)^ + beta.At(k)^);
      end;
      t.At(i)^:= tmp;
      if tmp < 0 then flg:= true;
    end;
  end;
  if flg then TestVar:= 1000 else TestVar:= 0;
end;

function TAnalisiB.GetVar(var delta: PREC): integer;
begin
end;

function TAnalisiB.GetDelta(var delmin, delmax: PREC): integer;
begin
end;

end.