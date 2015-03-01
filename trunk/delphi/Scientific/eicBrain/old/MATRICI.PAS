unit Matrici;

interface

type
  PREC  = real;
  DPREC = real;

type 
  TMatrix = array[0..3,0..3] of PREC;

procedure MatMulSca(var A: TMatrix; M, N: integer; val: PREC);
procedure MatZero(var A: TMatrix; M, N: integer);
procedure MatAdd(var A, B: TMatrix; M, N: integer);
procedure MatDetTri(var A: TMatrix; N: integer);
procedure MatInvTriInf(var A, B: TMatrix; N: integer);
procedure MatInvTriSup(var A, B: TMatrix; N: integer);
procedure MatMul(var A, B, C: TMatrix; m, n, p: integer);

implementation

procedure MatMulSca(var A: TMatrix; M, N: integer; val: PREC);
var
  r, c: integer;
begin
  for r:= 0 to pred(M) do begin
    for c:= 0 to pred(N) do begin
      A[r,c]:= A[r, c] * val;
    end;
  end;
end;

procedure MatZero(var A: TMatrix; M, N: integer);
var
  r, c: integer;
begin
  for r:= 0 to pred(M) do begin
    for c:= 0 to pred(N) do begin
      A[r,c]:= 0;
    end;
  end;
end;

procedure MatAdd(var A, B: TMatrix; M, N: integer);
var
  r, c: integer;
begin
  for r:= 0 to pred(M) do begin
    for c:= 0 to pred(N) do begin
      A[r,c]:= A[r, c] + B[r, c];
    end;
  end;
end;

procedure MatDetTri(var A: TMatrix; N: integer);
var
  i: integer;
  det: PREC;
begin
  det:= 1;
  for i:= 0 to pred(N) do begin
    det:= det * A[i,i];
  end;
end;

(* Inverte una matrice triangolare inferiore *)
procedure MatInvTriInf(var A, B: TMatrix; N: integer);
var
  KCol, KRow, k: integer;
  sum: DPREC;
begin
  B[0,0]:= 1 / A[0,0];
  if N = 1 then exit;
  for KRow:= 1 to pred(N) do begin
    B[KRow, KRow]:= 1 / A[KRow, KRow];
    for KCol:= 0 to pred(KRow) do begin
      sum:= 0;
      for k:= KCol to pred(KRow) do begin
        sum:= sum + A[KRow, K] * B[K, KCol];
      end;
      B[KRow, KCol]:= -sum / A[KRow, KRow];
    end;
  end;
end;

(* Inverte una matrice triangolare superiore *)
procedure MatInvTriSUp(var A, B: TMatrix; N: integer);
var
  KCol, KRow, k: integer;
  sum: DPREC;
begin
  for k:= 0 to pred(N) do B[k,k]:= 1 / A[k,k];
  if N < 2 then exit;
  for KRow:= N-2 downto 0 do begin
    for KCol:= succ(KRow) to pred(N) do begin
      sum:= 0;
      for k:= KRow to pred(KCol) do begin
        sum:= sum + A[K, KCol] * B[KRow, K];
      end;
      B[KRow, KCol]:= -sum / A[KCol, KCol];
    end;
  end;
end;

procedure MatMul(var A, B, C: TMatrix; m, n, p: integer);
var
  i, j, k: integer;
  sum: DPREC;
begin
  for i:= 0 to pred(m) do begin
    for j:= 0 to pred(p) do begin
      sum:= 0;
      for k:= 0 to pred(n) do begin
        sum:= sum + A[i, k] * B[k, j];
      end;
      C[i, j]:= sum;
    end;
  end;
end;

end.
