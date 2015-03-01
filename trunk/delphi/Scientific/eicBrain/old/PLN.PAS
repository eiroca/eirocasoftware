unit PLN;

interface

uses HDError, MathTool, Matrix, MatrMath, VectMath;

const
  MaxProElem = 50;
  MaxSamSize = 50;

type

  PPLN = ^TPLN;
  TPLN = object
    m: integer;   (* dimension of the input  layer *)
    n: integer;   (* dimension of the output layer *)
    k: integer;   (* dimension of the hidden layer *)
    W: PSMatrix; (* weight matrix connecting the input w/ hidded layer *)
    V: PSMatrix; (* weight matrix connecting the hidden w/ output layer *)
    S: PSVector; (* vector proportional to num. of samples in Process Elem. *)
    RoI: PREC;    (* input space vigilance threshold *)
    RoO: PREC;    (* output space vigilance threshold *)
    eta: PREC;    (* decay constant *)
    eps: PREC;    (* extinction threshold *)
    lmd: PREC;    (* merging factor *)
    constructor Init(InSampleSize, OutSampleSize: integer; ri,ro,et,ep,lm: REAL);
    procedure   Learn(var X, Y: TSVector);
    procedure   Recall(var X, Y: TSVector; P: integer);
    procedure   MergeStep(i, j: integer);
    function    Dist(var X: TSVector; var WM: TSMatrix; i: integer): PREC;
    function    DistRowrow(var W1: TSMatrix; i1: integer; var W2: TSMatrix; i2: integer): PREC;
   private
    procedure   DeletePE(i: integer);
  end;

implementation

constructor TPLN.Init;
begin
  if (InSampleSize > MaxSamSize) or (OutSampleSize > MaxSamSize)  then begin
    ErrorHandler('PLN library',ERR_SampleOverflow);
  end;
  n:= InSampleSize;
  m:= OutSampleSize;
  k:= 0;
  New(W, Init(1,MaxProElem, n));
  New(V, Init(1,MaxProElem, m));
  New(S, Init(1,MaxProElem));
  RoI:= ri;
  RoO:= ro;
  eta:= et;
  eps:= ep;
  lmd:= lm;
end;

procedure TPLN.Learn;
var
  Dst: PSMatrix;
  pe, i, j: integer;
  tmp: PREC;
  flg: boolean;
begin
  if k = 0 then begin
    k:= 1;
    VecToRow(X, W^, 1);
    VecToRow(Y, V^, 1);
    S^.At(1)^:= 1;
  end
  else begin
    New(Dst, Init(1,k,2));
    for i:= 1 to k do begin
      Dst^.At(i, 1)^:= Dist(X, W^, i);
      Dst^.At(i, 2)^:= i;
    end;
    SMatSortRow(Dst^, 0);
    flg:= true;
    for i:= 1 to K do begin
      if Dst^.At(i, 1)^ <= RoI then begin
        pe:= trunc(Dst^.At(i,2)^);
        if Dist(Y, V^, pe) <= RoO then begin
          tmp:= S^.At(pe)^;
          for j:= 1 to m do begin
            W^.At(pe, j)^:= (tmp * W^.At(pe, j)^ + X.At(j)^) / (tmp+1);
          end;
          for j:= 1 to n do begin
            V^.At(pe, j)^:= (tmp * V^.At(pe, j)^ + Y.At(j)^) / (tmp+1);
          end;
          S^.At(pe)^:= tmp+1+eta;
          flg:= false;
          break;
        end;
      end
      else break;
    end;
    if flg then begin
      inc(K);
      if (K > MaxProElem) then ErrorHandler('PLN library',ERR_SampleOverflow);
      VecToRow(X, W^, K);
      VecToRow(Y, V^, K);
      S^.At(K)^:= 1;
    end;
    Dispose(Dst, Done);
    i:= 1;
    while (i <= K) do begin
      tmp:= S^.At(i)^ - eta;
      if tmp < eps then DeletePE(i)
      else begin
        S^.At(i)^:= tmp;
        inc(i);
      end;
    end;
  end;
end;

procedure TPLN.Recall;
var
  Dst: PSMatrix;
  i, j, pe: integer;
  tmp: PREC;
  sum: DPREC;
begin
  if (p > K) or (p<1) then p:= k;
  New(Dst, Init(1,k,2));
  for i:= 1 to k do begin
    Dst^.At(i, 1)^:= Dist(X, W^, i);
    Dst^.At(i, 2)^:= i;
  end;
  SMatSortRow(Dst^, 0);
  if Dst^.At(1, 1)^ <= Zero then begin
    RowToVec(V^, trunc(Dst^.At(1, 2)^), Y);
    i:= 1;
    Sum:= 1;
    while (i<p) do begin
      if Dst^.At(i+1, 1)^ > Zero then break;
      pe:= trunc(Dst^.At(i+1, 2)^);
      for j:= 1 to n do begin
        Y.At(j)^:= Y.At(j)^ + V^.At(pe, j)^;
      end;
      Sum:= Sum +1;
      inc(i);
    end;
    if Sum <> 1 then begin
      Sum:= 1/Sum;
      for j:= 1 to n do begin
        Y.At(j)^:= Y.At(j)^ * Sum;
      end;
    end;
  end
  else begin
    for i:= 1 to n do begin
      Y.At(i)^:= 0;
    end;
    for i:= 1 to P do begin
      tmp:= 1/Dst^.At(i, 1)^;
      pe:= trunc(Dst^.At(i,2)^);
      for j:= 1 to n do begin
        Y.At(j)^:= Y.At(j)^ + V^.At(pe, j)^ * tmp;
      end;
      Sum:= Sum + tmp;
    end;
    for i:= 1 to n do begin
      Y.At(i)^:= Y.At(i)^ / Sum;
    end;
  end;
  Dispose(Dst, Done);
end;

procedure TPLN.MergeStep;
var
  Dst: PREC;
  si, sj, ss: PREC;
  old, z: integer;
begin
  Dst:= DistRowRow(W^, i, W^, j);
  if Dst <= lmd * RoI then begin
    Dst:= DistRowRow(V^, i, V^, j);
    if Dst <= lmd * RoO then begin
      sj:= S^.At(j)^;
      si:= S^.At(i)^;
      ss:= 1/(si + sj);
      for z:= 1 to m do begin
        W^.At(i,z)^:= (W^.At(i,z)^ * si + sj * W^.At(j,z)^) * ss;
      end;
      for z:= 1 to m do begin
        V^.At(i,z)^:= (V^.At(i,z)^ * si + sj * V^.At(j,z)^) * ss;
      end;
      S^.At(i)^:= si + sj;
      DeletePE(j);
    end;
  end;
end;

function  TPLN.Dist;
begin
  Dist:= VecRowDist(X, WM, i)
end;

function  TPLN.DistRowRow;
begin
  DistRowRow:= RowRowDist(W1, i1, W2, i2);
end;

procedure TPLN.DeletePE;
begin
  if i <> K then begin
    S^.At(i)^:= S^.At(K)^;
    RowToRow(W^, i, W^, K);
    RowToRow(V^, i, V^, K);
  end;
  dec(K);
end;

end.
