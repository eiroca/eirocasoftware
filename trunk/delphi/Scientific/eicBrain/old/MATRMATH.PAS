unit MatrMath;

{$I switches.inc}

interface

uses MathTool, Matrix;

const
  ERR_NOTCOMP = -1;
  ERR_SINGULA = -2;

function SMat(var A: TSMatrix): integer;
function SMakMat(var A: TSMatrix): PMatrix;
function SMatInv(var MO, MI: TSMatrix): integer;
function SMatInvFast(var MO, M: TSMatrix): integer;
function SMakInv(var MI: TSMatrix): PSMatrix;
function SMatMul(var MO, MA, MB: TSMatrix): integer;
function SMatMulXtY(var MO, MA, MB: TSMatrix): integer;
function SMakMul(var MA, MB: TSMatrix): PMatrix;
function SMatMulXtX(var MO, MI: TSMatrix): integer;
function SMatMulXXt(var MO, MI: TSMatrix): integer;
function SMatVec(var r: TSVector; var A: TSMatrix; var x: TSVector): integer;
function SMatTra(var MO, MI: TSMatrix): integer;
function SMatInvTriSup(var MO, MI: TSMatrix): integer;
function SMatInvTriInf(var MO, MI: TSMatrix): integer;
function SMatDetTri(var A: TSMatrix; var det: PREC): integer;
function SMatZero(var A: TSMatrix): integer;
function SMatAdd(var MO, MI: TSMatrix): integer;
function SMatMulSca(var A: TSMatrix; val: PREC): integer;

function SMatSortRow(var MA: TSMatrix; Col: integer): integer;
function SMatSortCol(var MA: TSMatrix; Row: integer): integer;
function SMatSortRows(var MA: TSMatrix): integer;

function FactorGAU(var Coef: TSMatrix; var Pivot: PIVector; var Determ: PREC): integer;
function SolveGAU(var Coef: TSMatrix; var Pivot: PIVector; var TermNoti, Soluzione: TSVector): integer;

function SolvSing(var Coef: TSMatrix; var TN, Sol: TSVector): integer;

function IMatMul(var MO, MA, MB: TIMatrix): integer;

implementation

function SMat(var A: TSMatrix): integer;
var
  r, c: integer;
begin
  for r:= 0 to pred(A.Rows) do begin
    for c:= 0 to pred(A.Cols) do begin
      if abs(A.At0(r, c)^) < Zero then A.At0(r,c)^:= 0;
    end;
  end;
  SMat:= 0;
end;

function SMakMat(var A: TSMatrix): PMatrix;
var
  r, c: integer;
  M: PSMatrix;
begin
  New(M, Init(A.Base, A.Rows, A.Cols));
  SMakMat:= M;
  if M = nil then exit;
  for r:= 0 to pred(A.Rows) do begin
    for c:= 0 to pred(A.Cols) do begin
      if abs(A.At0(r, c)^) < Zero then M^.At0(r,c)^:= 0 else M^.At0(r,c)^:= A.At0(r,c)^;
    end;
  end;
end;

function SMatInv(var MO, MI: TSMatrix): integer;
var
  i, j, k, l: integer;
  r : integer;
  p: integer;
  mx: PREC;
  t: PREC;
  M: TSMatrix;
begin
  r:= MI.Rows;
  if (r <> MI.Cols) or (r <> MO.Cols) or (r <> MO.Rows) then begin
    SMatInv:= ERR_NOTCOMP;
    exit;
  end;
  M.Init(0, r,r);
  dec(r);
  MatrixCopyTo(MI, M);
  for i:= 0 to r do begin
    for j:= 0 to r do begin
      if i = j then t:= 1.0 else t:= 0.0;
      MO.At0(i, j)^:= t;
    end;
  end;
  for J:= 0 to R do begin
    p:= -1; mx:= 0;
    for I:= J to R do begin
      if abs(M.At0(i, j)^) > mx then begin p:= I; mx:= abs(M.At0(i, j)^); end;
    end;
    if mx < 10e-20 then begin
      SMatInv:= ERR_SINGULA;
      M.Done;
      exit;
    end;
    I:= p;
    if I <> J then begin
      for K:= 0 to R do begin
        t:= M.At0(J, K)^;
        M.At0(J, K)^:= M.At0(I, K)^;
        M.At0(I, K)^:= t;
        t:= MO.At0(J, K)^;
        MO.At0(J, K)^:= MO.At0(I, K)^;
        MO.At0(I, K)^:= t;
      end;
    end;
    t:= 1 / M.At0(J, J)^;
    for K:= 0 to R do begin
      M.At0(J, K)^:= t * M.At0(J, K)^;
      MO.At0(J, K)^:= t * MO.At0(J, K)^;
    end;
    for L:= 0 to R do begin
      if L <> J then begin
        T:= -M.At0(L, J)^;
        for K:= 0 to R do begin
          M.At0(L, K)^:= M.At0(L, K)^ + T * M.At0(J, K)^;
          MO.At0(L, K)^:= MO.At0(L, K)^ + T * MO.At0(J, K)^;
        end;
      end;
    end;
  end;
  SMatInv:= 0;
  M.Done;
end;

function SMatInvFast(var MO, M: TSMatrix): integer;
var
  i, j, k, l: integer;
  r : integer;
  p: integer;
  mx: PREC;
  t: PREC;
begin
  r:= M.Rows;
  if (r <> M.Cols) or (r <> MO.Cols) or (r <> MO.Rows) then begin
    SMatInvFast:= ERR_NOTCOMP;
    exit;
  end;
  dec(r);
  for i:= 0 to r do begin
    for j:= 0 to r do begin
      if i = j then t:= 1.0 else t:= 0.0;
      MO.At0(i, j)^:= t;
    end;
  end;
  for J:= 0 to R do begin
    p:= -1; mx:= 0;
    for I:= J to R do begin
      if abs(M.At0(i, j)^) > mx then begin p:= I; mx:= abs(M.At0(i, j)^); end;
    end;
    if mx < 10e-20 then begin
      SMatInvFast:= ERR_SINGULA;
      exit;
    end;
    I:= p;
    if I <> J then begin
      for K:= 0 to R do begin
        t:= M.At0(J, K)^;
        M.At0(J, K)^:= M.At0(I, K)^;
        M.At0(I, K)^:= t;
        t:= MO.At0(J, K)^;
        MO.At0(J, K)^:= MO.At0(I, K)^;
        MO.At0(I, K)^:= t;
      end;
    end;
    t:= 1 / M.At0(J, J)^;
    for K:= 0 to R do begin
      M.At0(J, K)^:= t * M.At0(J, K)^;
      MO.At0(J, K)^:= t * MO.At0(J, K)^;
    end;
    for L:= 0 to R do begin
      if L <> J then begin
        T:= -M.At0(L, J)^;
        for K:= 0 to R do begin
          M.At0(L, K)^:= M.At0(L, K)^ + T * M.At0(J, K)^;
          MO.At0(L, K)^:= MO.At0(L, K)^ + T * MO.At0(J, K)^;
        end;
      end;
    end;
  end;
  SMatInvFast:= 0;
end;

function SMakInv(var MI: TSMatrix): PSMatrix;
var
  i, j, k, l: integer;
  r : integer;
  p: integer;
  mx: PREC;
  t: PREC;
  M: TSMatrix;
  MO: PSMatrix;
begin
  r:= MI.Rows;
  if (r <> MI.Cols) then begin
    SMakInv:= nil;
    exit;
  end;
  M.Init(0,r,r);
  New(MO, Init(MI.Base,r,r));
  SMakInv:= MO;
  if MO = nil then exit;
  dec(r);
  MatrixCopyTo(MI, M);
  for i:= 0 to r do begin
    for j:= 0 to r do begin
      if i = j then t:= 1.0 else t:= 0.0;
      MO^.At0(i, j)^:= t;    end;
  end;
  for J:= 0 to R do begin
    p:= -1; mx:= 0;
    for I:= J to R do begin
      if abs(M.At0(j, i)^) > mx then begin p:= I; mx:= abs(M.At0(j,i)^); end;
    end;
    if mx < Zero then begin
      Dispose(MO, Done);
      M.Done;
      SMakInv:= nil;
      exit;
    end;
    I:= p;
    if I <> J then begin
      for K:= 0 to R do begin
        t:= M.At0(J, K)^;
        M.At0(J, K)^:= M.At0(I, K)^;
        M.At0(I, K)^:= t;
        t:= MO^.At0(J, K)^;
        MO^.At0(J, K)^:= MO^.At0(I, K)^;
        MO^.At0(I, K)^:= t;
      end;
    end;
    t:= 1 / M.At0(J, J)^;
    for K:= 0 to R do begin
      M.At0(J, K)^:= t * M.At0(J, K)^;
      MO^.At0(J, K)^:= t * MO^.At0(J, K)^;
    end;
    for L:= 0 to R do begin
      if L <> J then begin
        T:= -M.At0(L, J)^;
        for K:= 0 to R do begin
          M.At0(L, K)^:= M.At0(L, K)^ + T * M.At0(J, K)^;
          MO^.At0(L, K)^:= MO^.At0(L, K)^ + T * MO^.At0(J, K)^;
        end;
      end;
    end;
  end;
  M.Done;
end;

function SMatMul(var MO, MA, MB: TSMatrix): integer;
var
  i, j , k : integer;
  r1, c1, c2 : integer;
  sum : DPREC;
begin
  r1:= MA.Rows-1;
  c1:= MA.Cols-1;
  c2:= MB.Cols-1;
  if (c1 <> MB.Rows-1) or (r1 <> MO.Rows-1) or (c2 <> MO.Cols-1) then begin
    SMatMul:= ERR_NOTCOMP;
    exit;
  end;
  for I:= 0 to R1 do begin
    for J:= 0 to C2 do begin
      sum:= 0;
      for K:= 0 to C1 do begin
        sum:= sum + MA.At0(I, K)^ * MB.At0(K, J)^;
      end;
      MO.At0(i, j)^:= sum;
    end;
  end;
  SMatMul:= 0;
end;

function SMatMulXtY(var MO, MA, MB: TSMatrix): integer;
var
  i, j , k : integer;
  r1, c1, c2 : integer;
  sum : DPREC;
begin
  c1:= MA.Rows-1;
  r1:= MA.Cols-1;
  c2:= MB.Cols-1;
  if (c1 <> MB.Rows-1) or (r1 <> MO.Rows-1) or (c2 <> MO.Cols-1) then begin
    SMatMulXtY:= ERR_NOTCOMP;
    exit;
  end;
  for I:= 0 to R1 do begin
    for J:= 0 to C2 do begin
      sum:= 0;
      for K:= 0 to C1 do begin
        sum:= sum + MA.At0(K, I)^ * MB.At0(K, J)^;
      end;
      MO.At0(i, j)^:= sum;
    end;
  end;
  SMatMulXtY:= 0;
end;

function SMakMul(var MA, MB: TSMatrix): PMatrix;
var
  i, j , k : integer;
  r1, c1, c2 : integer;
  sum : DPREC;
  MO: PSMatrix;
begin
  r1:= MA.Rows-1;
  c1:= MA.Cols-1;
  c2:= MB.Cols-1;
  if (c1 <> MB.Rows-1) then begin
    SMakMul:= nil;
    exit;
  end;
  New(MO, Init(MA.Base,r1, c2));
  SMakMul:= MO;
  if MO = nil then exit;
  for I:= 0 to R1 do begin
    for J:= 0 to C2 do begin
      sum:= 0;
      for K:= 0 to C1 do begin
        sum:= sum + MA.At0(I, K)^ * MB.At0(K, J)^;
      end;
      MO^.At0(i, j)^:= sum;
    end;
  end;
end;

function SMatMulXXt(var MO, MI: TSMatrix): integer;
var
  i, j , k : integer;
  sum: DPREC;
  r,c: integer;
begin
  r:= MI.Rows;
  c:= MI.Cols-1;
  if (MO.Rows <> r) or (MO.Cols <> r) then begin
    SMatMulXXt:= ERR_NOTCOMP;
    exit;
  end;
  dec(r);
  for I:= 0 to r do begin
    for J:= 0 to r do begin
      sum:= 0;
      for K:= 0 to c do begin
        sum:= sum + MI.At0(K, I)^ * MI.At0(K, J)^;
      end;
      MO.At0(i, j)^:= sum;
    end;
  end;
  SMatMulXXt:= 0;
end;

function SMatMulXtX(var MO, MI: TSMatrix): integer;
var
  i, j , k : integer;
  sum: DPREC;
  r, c: integer;
begin
  r:= MI.Rows-1;
  c:= MI.Cols;
  if (MO.Rows <> c) or (MO.Cols <> c) then begin
    SMatMulXtX:= ERR_NOTCOMP;
    exit;
  end;
  dec(c);
  for I:= 0 to c do begin
    for J:= I to c do begin
      sum:= 0;
      for K:= 0 to r do begin
        sum:= sum + MI.At0(K, I)^ * MI.At0(K, J)^;
      end;
      MO.At0(i, j)^:= sum;
      MO.At0(j, i)^:= sum;
    end;
  end;
  SMatMulXtX:= 0;
end;

function SMatVec(var r: TSVector; var A: TSMatrix; var x: TSVector): integer;
var
  c1, r1: integer;
  j , k : integer;
  sum: DPREC;
begin
  c1:= x.Rows;
  r1:= r.Rows;
  if (c1 <> A.Cols) or (r1 <> A.Rows) then begin
    SMatVec:= ERR_NOTCOMP;
    exit;
  end;
  dec(r1); dec(c1);
  for J:= 0 to r1 do begin
    sum:= 0;
    for K:= 0 to C1 do begin
      sum:= sum + A.At0(j, K)^ * x.At0(K)^;
    end;
    r.At0(J)^:= sum;
  end;
  SMatVec:= 0;
end;

function SMatTra(var MO, MI: TSMatrix): integer;
var i, j: integer;
begin
  if (MO.Rows <> MI.Cols) or (MO.Cols <> MI.Rows) then begin
    SMatTra:= ERR_NOTCOMP;
    exit;
  end;
  for j:= 0 to MI.Rows-1 do begin
    for i:= 0 to MI.Cols-1 do begin
      MO.At0(i, j)^:= MI.At0(j, i)^;
    end;
  end;
  SMatTra:= 0;
end;

function SMatMulSca(var A: TSMatrix; val: PREC): integer;
var
  r, c: integer;
begin
  for r:= 0 to pred(A.Rows) do begin
    for c:= 0 to pred(A.Cols) do begin
      A.At0(r, c)^:= A.At0(r, c)^ * val;
    end;
  end;
  SMatMulSca:= 0;
end;

function SMatZero(var A: TSMatrix): integer;
var
  r, c: integer;
begin
  for r:= 0 to pred(A.Rows) do begin
    for c:= 0 to pred(A.Cols) do begin
      A.At0(r, c)^:= 0;
    end;
  end;
  SMatZero:= 0;
end;

function SMatAdd(var MO, MI: TSMatrix): integer;
var
  r, c: integer;
begin
  if (MI.Rows <> MO.Rows) or (MI.Cols <> MO.Cols) then begin
    SMatAdd:= ERR_NOTCOMP;
    exit;
  end;
  SMatAdd:= 0;
  for r:= 0 to pred(MI.Rows) do begin
    for c:= 0 to pred(MI.Cols) do begin
      MO.At0(r, c)^:= MO.At0(r, c)^ + MI.At0(r, c)^;
    end;
  end;
end;

function SMatDetTri(var A: TSMatrix; var det: PREC): integer;
var i: integer;
begin
  if (A.Rows <> A.Cols) then begin
    SMatDetTri:= ERR_NOTCOMP;
    exit;
  end;
  SMatDetTri:= 0;
  det:= 1;
  for i:= 0 to pred(A.Rows) do begin
    det:= det * A.At0(i, i)^;
  end;
end;

(* Inverte una matrice triangolare inferiore *)
function SMatInvTriInf(var MO, MI: TSMatrix): integer;
var
  KCol, KRow, k: integer;
  sum: DPREC;
begin
  if (MO.Rows <> MO.Cols) or (MO.Rows <> MI.Cols) or (MI.Cols <> MI.Rows) then begin
    SMatInvTriInf:= ERR_NOTCOMP;
    exit;
  end;
  SMatInvTriInf:= 0;
  MO.At0(0, 0)^:= 1 / MI.At0(0, 0)^;
  if MI.Rows = 1 then exit;
  for KRow:= 1 to pred(MI.Rows) do begin
    MO.At0(KRow, KRow)^:= 1 / MI.At0(KRow, KRow)^;
    for KCol:= 0 to pred(KRow) do begin
      sum:= 0;
      for k:= KCol to pred(KRow) do begin
        sum:= sum + MI.At0(KRow, K)^ * MO.At0(K, KCol)^;
      end;
      MO.At0(KRow, KCol)^:= -sum / MI.At0(KRow, KRow)^;
    end;
  end;
end;

(* Inverte una matrice triangolare superiore *)
function SMatInvTriSup(var MO, MI: TSMatrix): integer;
var
  KCol, KRow, k: integer;
  sum: DPREC;
begin
  if (MO.Rows <> MO.Cols) or (MO.Rows <> MI.Cols) or (MI.Cols <> MI.Rows) then begin
    SMatInvTriSup:= ERR_NOTCOMP;
    exit;
  end;
  SMatInvTriSup:= 0;
  for k:= 0 to pred(MI.Rows) do MO.At0(k, k)^:= 1 / MI.At0(k, k)^;
  if MI.Rows = 1 then exit;
  for KRow:= MI.Rows-2 downto 0 do begin
    for KCol:= succ(KRow) to pred(MI.Rows) do begin
      sum:= 0;
      for k:= KRow to pred(KCol) do begin
        sum:= sum + MI.At0(K, KCol)^ * MO.At0(KRow, K)^;
      end;
      MO.At0(KRow, KCol)^:= -sum / MI.At0(KCol, KCol)^;
    end;
  end;
end;

(* FactorGAU,
Costrusice la matrici G e U soddisfanti la relazione G * A = U, permettendo
poi la risoluzione del sistema con il metodo di gauss (U * x = G * b)
Elem = ordine +1 della matrice dei coefficenti
Coef(MAXMAT)(MAXMAT) = matrice dei coefficenti del sistema lineare
Pivot(ELEM-1) = vettore contenente le permutazioni di riga
Determ = conterra' il valore del determinante
MAXMAT = dimensione matrice (massima)
ritorna un'indicazione d'errore:
  MATH_NOERR    = Tutto Ok,
  MATH_SINGMATR = MATRICE SINGOLARE
*)
function FactorGAU(var Coef: TSMatrix; var Pivot: PIVector; var Determ: PREC): integer;
var
  temp,  MaxVal: PREC;
  Elem, Riga, i, j, k: integer;
begin
  Elem:= Coef.Rows-1;
  if Elem+1 <> Coef.Cols then begin
    FactorGAU:= ERR_NOTCOMP;
    exit;
  end;
  Determ:= 1.0;
  if Pivot <> nil then Dispose(Pivot, Done);
  New(Pivot, Init(Coef.Base, Elem));
  for k:= 0 to Elem-1 do begin
    MaxVal:= abs(Coef.At0(k,k)^);
    RIGA:= k;
    (* Ricerca pivot, pivoting parziale *)
    for i:= k+1 to Elem do begin
      if (abs(Coef.At0(i,k)^) - MaxVal > Zero) then begin
        MaxVal:= abs(Coef.At0(i,k)^);
        RIGA:= i;
      end;
    end;
    Pivot^.At0(k)^:= RIGA;
    (* Controllo singolarita' matrice *)
    if (MaxVal < Zero) then begin
      Determ:= 0.0;
      FactorGAU:= ERR_SINGULA;
      exit;
    end;
    if (RIGA <> k) then begin
      (* scambio la riga K con la riga RIGA, a partire dall'elemento K *)
      for j:= k to Elem do begin
        Temp:= Coef.At0(k,j)^;
        Coef.At0(k,j)^:= Coef.At0(RIGA,j)^;
        Coef.At0(RIGA,j)^:= Temp;
      end;
      Determ:= -Determ;
    end;
    for i:= k+1 to Elem do begin
      Temp:= -(Coef.At0(i,k)^ / Coef.At0(k,k)^);
      Coef.At0(i,k)^:= Temp;
      for j:= k+1 to Elem do begin
        Coef.At0(i,j)^:= Coef.At0(i,j)^ + Temp * Coef.At0(k,j)^;
      end;
    end;
    Determ:= Determ* Coef.At0(k,k)^;
  end;
  Determ:= Determ*Coef.At0(Elem,Elem)^;
  (* Controllo singolarita' matrice *)
  if (abs(Determ) < Zero) then FactorGAU:= ERR_SINGULA else FactorGAU:= 0;
end;

(* SolveGAU,
Dopo la fattorizzazione GA=U, procede alla soluzione del sistema triangolare
cosi' ottenuto
Elem = ordine della matrice + 1
Coef(MAXMAT)(MAXMAT) = matrice elaborata da FactorGAU
Pivot(ELEM-1) = vettore contenente le permutazioni di Coef
TermNoti(ELEM) = Termini noti, conterra' all'uscita la soluzione del sistema
Soluzione(ELEM) = vettore dei risultati, non ci sono problemi se Soluzione e
  i termini noti usano la stessa RAM (&Soluzione = &TermNoti)
MAXMAT = dimensione max della matrice
*)
function SolveGAU(var Coef: TSMatrix; var Pivot: PIVector; var TermNoti, Soluzione: TSVector): integer;
var
  temp, sum: PREC;
  i,j,k,Elem: integer;
begin
  Elem:= Coef.Rows-1;
  if @Soluzione = nil then Soluzione.Init(Coef.Base, Elem+1);
  if (Elem+1 <> Coef.Cols) or (Elem <> Pivot^.Rows) or (Elem+1 <> TermNoti.Rows) then begin
    SolveGAU:= ERR_NOTCOMP;
    exit;
  end;
  if (@Soluzione <> @TermNoti) then VectorCopyTo(TermNoti, Soluzione);
  for k:= 0 to Elem-1 do begin
    j:= Pivot^.At0(k)^;
    if (j <> k) then begin
      Temp:= Soluzione.At0(j)^;
      Soluzione.At0(j)^ := Soluzione.At0(k)^;
      Soluzione.At0(k)^ := Temp;
     end;
    for i:= k+1 to Elem do begin
      Soluzione.At0(i)^:= Soluzione.At0(i)^ + Coef.At0(i,k)^ * Soluzione.At0(k)^;
    end;
  end;
  Soluzione.At0(Elem)^:= Soluzione.At0(Elem)^ / Coef.At0(Elem,Elem)^;
  for i:= Elem-1 downto 0 do begin
    sum:= 0;
    for j:= i + 1 to Elem do begin
      sum:= sum + Coef.At0(i,j)^ * Soluzione.At0(j)^;
    end;
    Soluzione.At0(i)^ := (Soluzione.At0(i)^ - SUM) / Coef.At0(i,i)^;
  end;
  SolveGAU:= 0;
end;

(* risolve sistemi indeterminati, valori liberi a 0 nelle ultime soluzioni *)
function SolvSing(var Coef: TSMatrix; var TN, Sol: TSVector): integer;
var
  tmp, Sum, MaxVal: PREC;
  Elem, Riga, i, j, k: integer;
  procedure Swap(a,b: PPREC);
  var tmp: PREC;
  begin
    tmp:= a^;
    a^:= b^;
    b^:= tmp;
  end;
begin
  Elem:= Coef.Rows-1;
  if Elem+1 <> Coef.Cols then begin
    SolvSing:= ERR_NOTCOMP;
    exit;
  end;
  for i:= 0 to Elem do begin
    Sol.At0(i)^:= TN.At0(i)^;
  end;
  for k:= 0 to Elem-1 do begin
    MaxVal:= abs(Coef.At0(k,k)^);
    RIGA:= k;
    (* Ricerca pivot, pivoting parziale *)
    for i:= k+1 to Elem do begin
      if (abs(Coef.At0(i,k)^) - MaxVal) > Zero then begin
        MaxVal:= abs(Coef.At0(i,k)^);
        RIGA:= i;
      end;
    end;
    if (RIGA <> k) then begin
      (* scambio la riga K con la riga RIGA, a partire dall'elemento K *)
      for j:= k to Elem do begin
        Swap(Coef.At0(k,j), Coef.At0(RIGA,j));
      end;
      Swap(Sol.At0(k), Sol.At0(RIGA));
    end;
    (* Controllo singolarita' matrice *)
    if (MaxVal < Zero) then begin
      continue;
    end;
    for i:= k+1 to Elem do begin
      tmp:= -(Coef.At0(i,k)^ / Coef.At0(k,k)^);
      Coef.At0(i,k)^:= 0;
      for j:= k+1 to Elem do begin
        Coef.At0(i,j)^:= Coef.At0(i,j)^ + tmp * Coef.At0(k,j)^;
      end;
      Sol.At0(i)^:= Sol.At0(i)^ + Sol.At0(k)^*tmp;
    end;
  end;
  tmp:= Coef.At0(Elem,Elem)^;
  if abs(tmp)<Zero then Sol.At0(Elem)^:= 0
  else Sol.At0(Elem)^:= Sol.At0(Elem)^ / tmp;
  for i:= Elem-1 downto 0 do begin
    sum:= 0;
    for j:= i + 1 to Elem do begin
      sum:= sum + Coef.At0(i,j)^ * Sol.At0(j)^;
    end;
    tmp:= Coef.At0(i,i)^;
    if abs(tmp)<Zero then Sol.At0(i)^:= 0
    else Sol.At0(i)^:= (Sol.At0(i)^ - SUM) / tmp;
  end;
  SolvSing:= 0;
end;

function IMatMul(var MO, MA, MB: TIMatrix): integer;
var
  i, j , k : integer;
  r1, c1, c2 : integer;
  sum: TDInt;
begin
  r1:= MA.Rows-1;
  c1:= MA.Cols-1;
  c2:= MB.Cols-1;
  if (c1 <> MB.Rows-1) or (r1 <> MO.Rows-1) or (c2 <> MO.Cols-1) then begin
    IMatMul:= ERR_NOTCOMP;
    exit;
  end;
  for I:= 0 to R1 do begin
    for J:= 0 to C2 do begin
      sum:= 0;
      for K:= 0 to C1 do begin
        inc(sum, MA.At0(I, K)^ * MB.At0(K, J)^);
      end;
      MO.At0(i, j)^:= sum;
    end;
  end;
  IMatMul:= 0;
end;

function SMatSortRow(var MA: TSMatrix; Col: integer): integer;
var rw,cl: integer;
  procedure QuickSort2(sinistra,destra: integer);
  var
    a, b, j: integer;
    ele1, ele2: PREC;
  begin
    a:= sinistra;
    b:= destra;
    ele1:= MA.At0((sinistra+destra) shr 1, Col)^;
    repeat
      while MA.At0(a, Col)^ < ele1 do inc(a);
      while ele1 < MA.At0(b, Col)^ do dec(b);
      if a <= b then begin
        for j:= 0 to cl do begin
          ele2:= MA.At0(a,j)^;
          MA.At0(a,j)^:= MA.At0(b,j)^;
          MA.At0(b,j)^:= ele2;
        end;
        inc(a);
        dec(b);
      end;
    until a > b;
    if sinistra < b then QuickSort2(sinistra, b);
    if a < destra then QuickSort2(a, destra);
  end;
begin
  SMatSortRow:= ERR_NOTCOMP;
  rw:= MA.Rows-1;
  cl:= MA.Cols-1;
  if col > cl then exit;
  QuickSort2(0,rw);
  SMatSortRow:= 0;
end;

function SMatSortCol(var MA: TSMatrix; Row: integer): integer;
var rw,cl: integer;
  procedure QuickSort2(sinistra,destra: integer);
  var
    a, b, j: integer;
    ele1, ele2: PREC;
  begin
    a:= sinistra;
    b:= destra;
    ele1:= MA.At0(Row, (sinistra+destra) shr 1)^;
    repeat
      while MA.At0(Row, a)^ < ele1 do inc(a);
      while ele1 < MA.At0(Row, b)^ do dec(b);
      if a <= b then begin
        for j:= 0 to rw do begin
          ele2:= MA.At0(j, a)^;
          MA.At0(j, a)^:= MA.At0(j, b)^;
          MA.At0(j, b)^:= ele2;
        end;
        inc(a);
        dec(b);
      end;
    until a > b;
    if sinistra < b then QuickSort2(sinistra, b);
    if a < destra then QuickSort2(a, destra);
  end;
begin
  SMatSortCol:= ERR_NOTCOMP;
  rw:= MA.Rows-1;
  cl:= MA.Cols-1;
  if Row > rw then exit;
  QuickSort2(0,rw);
  SMatSortCol:= 0;
end;

function SMatSortRows(var MA: TSMatrix): integer;
var rw,cl: integer;
  procedure QuickSort2(sinistra,destra: integer);
  var
    a, b, j: integer;
    ele1: PSVector;
    ele2: PREC;
    function Less1: boolean;
    var i: integer;
    begin
      Less1:= true;
      i:= 0;
      while i <= cl do begin
         if MA.At0(a, i)^ < ele1^.At0(i)^ then exit;
         if MA.At0(a, i)^ > ele1^.At0(i)^ then break;
         inc(i);
      end;
      Less1:= false;
    end;
    function Less2: boolean;
    var i: integer;
    begin
      Less2:= true;
      i:= 0;
      while i <= cl do begin
        if ele1^.At0(i)^ < MA.At0(b, i)^ then exit;
        if ele1^.At0(i)^ > MA.At0(b, i)^ then break;
        inc(i);
      end;
      Less2:= false;
    end;
  begin
    New(ele1, Init(0, cl+1));
    a:= sinistra;
    b:= destra;
    for j:= 0 to cl do ele1^.At0(j)^:= MA.At0((sinistra+destra) shr 1, j)^;
    repeat
      while Less1 do inc(a);
      while Less2 do dec(b);
      if a <= b then begin
        for j:= 0 to cl do begin
          ele2:= MA.At0(a,j)^;
          MA.At0(a,j)^:= MA.At0(b,j)^;
          MA.At0(b,j)^:= ele2;
        end;
        inc(a);
        dec(b);
      end;
    until a > b;
    if sinistra < b then QuickSort2(sinistra, b);
    if a < destra then QuickSort2(a, destra);
    Dispose(ele1, Done);
  end;
begin
  SMatSortRows:= ERR_NOTCOMP;
  rw:= MA.Rows-1;
  cl:= MA.Cols-1;
  QuickSort2(0,rw);
  SMatSortRows:= 0;
end;

(*-----------------------------------------------------------------------------
*	funct:	mat_lu
*	desct:	in-place LU decomposition with partial pivoting
*	given:	!! A = square matrix (n x n) !ATTENTION! see commen
*		P = permutation vector (n x 1)
*	retrn:	number of permutation performed
*		-1 means suspected singular matrix
*	comen:	A will be overwritten to be a LU-composite matrix
*
*	note:	the LU decomposed may NOT be equal to the LU of
*		the orignal matrix a. But equal to the LU of the
*		rows interchanged matrix.
*-----------------------------------------------------------------------------
*)
function mat_lu(var A: TSMatrix; var P: TIVector): integer;
var
  i, j, k, n: integer;
  maxi, tmp: integer;
  c, c1: double;
  t: double;
  pp: integer;
begin
  mat_lu:= -1;
  n:= A.Cols-1;
  pp:= 0;
  for i:= 0 to n do begin
    P.At0(i)^:= i;
  end;
  for k:= 0 to n do begin
    (* --- partial pivoting --- *)
    maxi:= k;
    c:= 0.0;
    for i:= k to n do begin
      c1:= abs(A.At0(P.At0(i)^, k)^);
      if (c1 > c) then begin
        c:= c1;
	maxi:= i;
      end;
    end;
    (* row exchange, update permutation vector *)
    if (k <> maxi) then begin
      inc(pp);
      tmp:= P.At0(k)^;
      P.At0(k)^:= P.At0(maxi)^;
      P.At0(maxi)^:= tmp;
    end;
    (* suspected singular matrix *)
    if abs(A.At0(P.At0(k)^, k)^) < 10e-50 then exit;
    for i:= k+1 to n do begin
      (* --- calculate m(i,j) --- *)
      A.At0(P.At0(i)^, k)^:= A.At0(P.At0(i)^,k)^ / A.At0(P.At0(k)^,k)^;
      (* --- elimination --- *)
      t:= -A.At0(P.At0(i)^,k)^;
      for j:= k+1 to n do begin
        A.At0(P.At0(i)^,j)^:= A.At0(P.At0(i)^,j)^ + t * A.At0(P.At0(k)^,j)^;
      end;
    end;
  end;
  mat_lu:= pp;
end;

(*-----------------------------------------------------------------------------
*	funct:	mat_backsubs1
*	desct:	back substitution
*	given:	A = square matrix A (LU composite)
*		!! B = column matrix B (attention!, see comen)
*		!! X = place to put the result of X
*		P = Permutation vector (after calling mat_lu)
*		xcol = column of x to put the result
*	retrn:	column matrix X (of AX = B)
*	comen:	B will be overwritten
*-----------------------------------------------------------------------------*)
procedure mat_backsubs1(var A: TSMatrix; var B, X: TSMatrix; var P: TIVector; xcol: integer);
var
  i, j, k, n: integer;
  sum: double;
begin
  n:= A.Cols-1;
  for k:= 0 to n do begin
    for i:= k+1 to n do begin
      B.At0(P.At0(i)^, xcol)^:= B.At0(P.At0(i)^, xcol)^ -
      A.At0(P.At0(i)^,k)^ * B.At0(P.At0(k)^, 0)^;
    end;
  end;
  X.At0(n-1,xcol)^:= B.At0(P.At0(n-1)^,0)^ / A.At0(P.At0(n-1)^, n-1)^;
  for k:= n-1 downto 0 do begin
    sum:= 0.0;
    for j:= k+1 to n do begin
      sum:= sum + A.At(P.At0(k)^,j)^ * X.At(j, xcol)^;
    end;
    X.At(k,xcol)^:= (B.At(P.At0(k)^,0)^ - sum) / A.At0(P.At0(k)^, k)^;
  end;
end;

(*-----------------------------------------------------------------------------
*	funct:	mat_inv
*	desct:	find inverse of a matrix
*	given:	a = square matrix a
*	retrn:	square matrix Inverse(A)
*		NULL = fails, singular matrix, or malloc() fails
*-----------------------------------------------------------------------------*)
procedure mat_inv(var a: TSMatrix);
var
  B, C: TSMatrix;
  P: TIVector;
  i, j, n: integer;
begin
  n:= A.Cols;
  B.Init(0, n, n);
  C.Init(0, n, n);
  P.Init(0, n);
  (* - LU-decomposition - also check for singular matrix *)
  mat_lu(A, P);
  for i:= 0 to n-1 do begin
    for j := 0 to n-1 do begin
      if i=j then B.At0(i,j)^:= 1 else B.At(i,j)^:= 0;
    end;
  end;
  for i:= 0 to n-1 do begin
    mat_backsubs1(A, B, C, P, i);
  end;
  B.Done;
  C.Done;
  P.Done;
end;

end.
