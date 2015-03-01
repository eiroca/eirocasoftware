unit VectMath;

{$I switches.inc}

interface

uses MathTool, Matrix;

const
  ERR_NOTCOMP = -1;
  ERR_SINGULA = -2;

function SVec(var V: TSVector): integer;
function SMakVec(var V: TSVector): PVector;
function SVecZero(var V: TSVector): integer;
function SVecAdd(var VO, VI: TSVector): integer;
function SVecMulXtY(var sum: PREC; var V1, V2: TSVector): integer;
function SVecMulXYt(var M: TSMatrix; var V1, V2: TSVector): integer;
function SVekMulXtY(var V1, V2: TSVector): PREC;
function SVekMulXYt(var V1, V2: TSVector): PMatrix;
function SVecMulSca(var V: TSVector; val: PREC): integer;
function SVecProSca(var V: TSVector): PREC;
function SVecNormalize(var V: TSVector): integer;

function  VecTVec(var v1, v2: TSVector): PREC;
function  VecNorm(var v1: TSVector): PREC;
function  VecDist(var v1, v2: TSVector): PREC;
procedure VecToCol(var v: TSVector; var m: TSMatrix; cl: integer);
procedure RowToVec(var m: TSMatrix; rw: integer; var v: TSVector);
procedure VecToRow(var v: TSVector; var m: TSMatrix; rw: integer);
procedure RowToRow(var m1: TSMatrix; rw1: integer; var m2: TSMatrix; rw2: integer);
function  VecRowDist(var v1: TSVector; var m: TSMatrix; rw: integer): PREC;
function  RowRowDist(var m1: TSMatrix; rw1: integer; var m2: TSMatrix; rw2: integer): PREC;

implementation

function SVec(var V: TSVector): integer;
var
  r: integer;
begin
  for r:= 0 to pred(V.Rows) do begin
    if abs(V.At0(r)^) < Zero then V.At0(r)^:= 0;
  end;
  SVec:= 0;
end;

function SMakVec(var V: TSVector): PVector;
var
  r: integer;
  M: PSVector;
begin
  New(M, Init(V.Base, V.Rows));
  SMakVec:= M;
  if M = nil then exit;
  for r:= 0 to pred(V.Rows) do begin
    if abs(V.At0(r)^) < Zero then M^.At0(r)^:= 0 else M^.At0(r)^:= V.At0(r)^;
  end;
end;

function SVecZero(var V: TSVector): integer;
var
  r: integer;
begin
  for r:= 0 to pred(V.Rows) do begin
    V.At0(r)^:= 0;
  end;
  SVecZero:= 0;
end;

function SVecAdd(var VO, VI: TSVector): integer;
var
  r: integer;
begin
  if (VI.Rows <> VO.Rows) then begin
    SVecAdd:= ERR_NOTCOMP;
    exit;
  end;
  SVecAdd:= 0;
  for r:= 0 to pred(VI.Rows) do begin
    VO.At0(r)^:= VO.At0(r)^ + VI.At0(r)^;
  end;
end;

function SVecMulXtY(var sum: PREC; var V1, V2: TSVector): integer;
var
  r: integer;
begin
  if (V1.Rows <> V2.Rows) then begin
    SVecMulXtY:= ERR_NOTCOMP;
    exit;
  end;
  SVecMulXtY:= 0;
  sum:= 0;
  for r:= 0 to pred(V1.Rows) do begin
    sum:= sum + V1.At0(r)^ * V2.At0(r)^;
  end;
end;

function SVecMulXYt(var M: TSMatrix; var V1, V2: TSVector): integer;
var r,c: integer;
begin
  if (M.Rows<>V1.Rows) or (M.Cols<>V2.Rows) then begin
    SVecMulXYt:= ERR_NOTCOMP;
    exit;
  end;
  for r:= 0 to pred(V1.Rows) do begin
    for c:= 0 to pred(V2.Rows) do begin
      M.At0(r,c)^:= V1.At0(r)^*V2.At0(c)^;
    end;
  end;
end;

function SVekMulXtY(var V1, V2: TSVector): PREC;
var
  c, r: integer;
  sum: DPREC;
begin
  c:= V1.Rows; if c > V2.Rows then c:= V2.Rows;
  sum:= 0;
  for r:= 0 to pred(c) do begin
    sum:= sum + V1.At0(r)^ * V2.At0(r)^;
  end;
  SVekMulXtY:= sum;
end;

function SVekMulXYt(var V1, V2: TSVector): PMatrix;
var
  r,c: integer;
  tmp: PSMatrix;
begin
  New(tmp, Init(V1.Base, V1.Rows,V2.Rows));
  SVekMulXYt:= tmp;
  if tmp = nil then exit;
  for r:= 0 to pred(V1.Rows) do begin
    for c:= 0 to pred(V2.Rows) do begin
      tmp^.At0(r,c)^:= V1.At0(r)^*V2.At0(c)^;
    end;
  end;
end;

function SVecMulSca(var V: TSVector; val: PREC): integer;
var
  r: integer;
begin
  for r:= 0 to pred(V.Rows) do begin
    V.At0(r)^:= V.At0(r)^ * val;
  end;
  SVecMulSca:= 0;
end;

function SVecProSca(var V: TSVector): PREC;
var
  r: integer;
  tmp: DPREC;
begin
  tmp:= 0;
  for r:= 0 to pred(V.Rows) do begin
    tmp:= tmp + sqr(V.At0(r)^);
  end;
  SVecProSca:= tmp;
end;

function SVecNormalize(var V: TSVector): integer;
var
  r: integer;
  tmp: DPREC;
begin
  tmp:= 0;
  for r:= 0 to pred(V.Rows) do begin
    tmp:= tmp + sqr(V.At0(r)^);
  end;
  SVecNormalize:= 0;
  if (abs(tmp)<Zero) or (abs(tmp-1)<Zero) then exit;
  tmp:= 1/sqrt(tmp);
  for r:= 0 to pred(V.Rows) do begin
    V.At0(r)^:= V.At0(r)^ * tmp;
  end;
end;

procedure VecToCol(var v: TSVector; var m: TSMatrix; cl: integer);
var i: integer;
begin
  if v.Rows <> m.Rows then begin
    RunError(1);
  end;
  for i:= 0 to v.Rows-1 do begin
    m.At0(i, cl-1)^:= v.At0(i)^;
  end;
end;

procedure VecToRow(var v: TSVector; var m: TSMatrix; rw: integer);
var i: integer;
begin
  if v.Rows <> m.Cols then begin
    RunError(1);
  end;
  for i:= 0 to v.Rows-1 do begin
    m.At0(rw-1, i)^:= v.At0(i)^;
  end;
end;

procedure RowToVec(var m: TSMatrix; rw: integer; var v: TSVector);
var i: integer;
begin
  if v.Rows <> m.Cols then begin
    RunError(1);
  end;
  for i:= 0 to v.Rows-1 do begin
    v.At0(i)^:= m.At0(rw-1, i)^;
  end;
end;

procedure RowToRow(var m1: TSMatrix; rw1: integer; var m2: TSMatrix; rw2: integer);
var i: integer;
begin
  if m1.Cols <> m2.Cols then begin
    RunError(1);
  end;
  for i:= 0 to m1.Rows-1 do begin
    m1.At0(rw1-1, i)^:= m2.At0(rw2-1, i)^;
  end;
end;

function VecTVec(var v1, v2: TSVector): PREC;
var
  i: integer;
  Sum: DPREC;
begin
  Sum:= 0;
  for i:= 0 to v1.Rows-1 do begin
    Sum:= Sum + v1.At0(i)^*v2.At0(i)^;
  end;
  VecTVec:= Sum;
end;

function VecNorm(var v1: TSVector): PREC;
var
  i: integer;
  Sum: DPREC;
begin
  Sum:= 0;
  for i:= 0 to v1.Rows-1 do begin
    Sum:= Sum + sqr(v1.At0(i)^);
  end;
  VecNorm:= Sum;
end;

function VecDist(var v1, v2: TSVector): PREC;
var
  i: integer;
  Sum: DPREC;
begin
  Sum:= 0;
  for i:= 0 to v1.Rows-1 do begin
    Sum:= Sum + sqr(v1.At0(i)^ - v2.At0(i)^);
  end;
  VecDist:= Sum;
end;

function VecRowDist(var v1: TSVector; var m: TSMatrix; rw: integer): PREC;
var
  i: integer;
  Sum: DPREC;
begin
  Sum:= 0;
  for i:= 0 to v1.Rows-1 do begin
    Sum:= Sum + sqr(v1.At0(i)^ - m.At0(rw-1, i)^);
  end;
  VecRowDist:= sqrt(Sum);
end;

function RowRowDist(var m1: TSMatrix; rw1: integer; var m2: TSMatrix; rw2: integer): PREC;
var
  i: integer;
  Sum: DPREC;
begin
  Sum:= 0;
  for i:= 0 to m1.Rows-1 do begin
    Sum:= Sum + sqr(m1.At0(rw1, i)^ - m2.At0(rw2, i)^);
  end;
  RowRowDist:= sqrt(Sum);
end;

end.
