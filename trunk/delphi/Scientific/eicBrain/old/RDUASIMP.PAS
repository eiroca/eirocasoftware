unit RSimplex;
(* Programmazione Lineare - Algoritmo del simplesso revisionato duale *)
(* Errori!! *)

{$I switches.inc}

interface

uses Matrix, PLProg, MathTool, Dos;

type

  PRSimplex = ^TRSimplex;
  TRSimplex = object(TPL)
     InBase, IndFit: array[1..MaxCol] of integer;
     NumFit, NumCol: integer;
     constructor Init(ErrMng: PErrMngr);
     procedure Normalize; virtual;
     procedure Load(const FName: PathStr); virtual;
     function  Calc(var x: TRow): integer; virtual;
     function  Solv(var x: TRow): integer; virtual;
    private
     procedure ZeroMat(X: TS0Matrix; NmVin, NmVar: integer);
     procedure FindIn(var bb: TS0Matrix; var ri: integer);
     procedure FindOut(var as, c: TS0Matrix; var co: integer);
     procedure Pivot(var M: TS0Matrix; NmVin, NmVar, co, ri, olo: integer);
     function  Simplesso(var x: TRow): integer;
  end;

implementation

constructor TRSimplex.Init(ErrMng: PErrMngr);
begin
  NumFit:= 0;
  NumCol:= 0;
  inherited Init(ErrMng);
end;

procedure TRSimplex.Load(const FName: PathStr);
begin
  NumFit:= 0;
  NumCol:= 0;
  inherited Load(FName);
end;

procedure TRSimplex.Normalize;
var 
  Est: char;
  k, j: integer;
begin
  NumCol:= NumVar;
  NumFit:= 0;
  (* Ricerca un minimo *)
  for k:= 0 to NumCol do begin
    A.At(0, k)^:= VarKin[0] * A.At(0, k)^;
  end;
  for k:= 1 to NumVin do begin
    Est:= VinKin[k];
    if A.At(k, 0)^ < 0 then begin
      writeln('Warning: A.At()^ < 0, riaggiusto il vincolo!');
      for j:= 0 to NumVar do begin
        A.At(k, j)^:= - A.At(k, j)^;
      end;
      case EST of
        'ó': EST:= 'ò';
        'ò': EST:= 'ó';
      end;
    end;
    (* se puoi cambia i >= in <= *)
    if (A.At(k, 0)^ = 0) and (EST='ò') then begin
      for j:= 0 to NumVar do begin
        A.At(k, j)^:= -A.At(k, j)^;
      end;
      est:= 'ó';
    end;
    if est = 'ò' then begin
      inc(NumCol);
      inc(NumFit);
      A.At(k, NumCol)^:= -1;
      IndFit[NumFit]:= k;
    end
    else if est = 'ó' then begin
      inc(NumCol);
      A.At(k, NumCol)^:= 1;
      InBase[k]:= NumCol;
    end
    else begin (* '=' *)
      inc(NumFit);
      IndFit[NumFit]:= k;
    end;
  end;
  if (NumFit > 0) then begin
    for j:= 1 to NumFit do begin
      k:= IndFit[j];
      inc(NumCol);
      InBase[k]:= NumCol;
      A.At(k, NumCol)^:= 1;
    end;
  end;
end;

function TRSimplex.Calc(var x: TRow): integer;
(* Calcola c*x, restituisce 0 se tutto ok, 
    1 se i vaolori di x non sono ammissibili
    2 se i valori di x non rispettano i vincoli *)
var 
  i, j: integer;
  z, tmp: PREC;
begin
  (* Calcolo valore *)
  z:= A.At(0,0)^;
  for i:= 1 to NumVar do begin
    z:= z + x[i] * A.At(0, i)^;
  end;
  z:= -VarKin[0] * z;
  x[0]:= z;
  (* Controllo ammissibilita' variabili *)
  j:= 0;
  for i:= 1 to numVar do begin
    case VarKin[i] and $FF of 
      0: if x[i] < 0 then j:= 1;
      1: if x[i] > 0 then j:= 1;
      3: if (x[i] <> 0) and (x[i] <> 1) then j:= 1;
    end;
    if (VarKin[i] and $100 <> 0) and (x[i] <> int(x[i])) then j:= 1;
    if j > 0 then begin
      Calc:= j;
      exit;
    end;
  end;
  for i:= 1 to NumVin do begin
    tmp:= -A.At(i, 0)^;
    for j:= 1 to NumVar do begin
      tmp:= tmp + A.At(i,j)^ * x[j];
    end;
    j:= 0;
    case VinKin[i] of
      'ó': if tmp > Zero then j:= 2;
      'ò': if tmp < Zero then j:= 2;
      '=': if abs(tmp) > Zero then j:= 2;
    end;
    if j > 0 then begin
      Calc:= j;
      exit;
    end;
  end;
  Calc:= 0;
end;

function TRSimplex.Solv(var x: TRow): integer;
(* Trova l'ottimo del programma lineare, modifica PL originario in uno 
equivalente, ritorna 0 se tutto Ok, 1 se soluzione illimitata, 2 se nessuna
soluzione e' ammissibile *)
begin
  Normalize;
  Solv:= Simplesso(x);
end;

procedure TRSimplex.ZeroMat(X: TS0Matrix; NmVin, NmVar: integer);
var k, j: integer;
begin
  for k:= 0 to NmVin do begin
    for j:= 0 to NmVar do begin
      if abs(X.At(k, j)^) < Zero then X.At(k, j)^:= 0;
    end;
  end;
end;

procedure TRSimplex.Pivot(var M: TS0Matrix; NmVin, NmVar, co, ri, olo: integer);
var
  am, piv: PREC;
  j, k: integer;
begin
  am:= 1 / M.At(ri, co)^;
  for j:= 0 to NmVar do begin
    M.At(ri, j)^:= M.At(ri, j)^ * am;
  end;
  for k:= 0 to NmVin do begin
    if (k<> ri) then begin
      am:= -M.At(k, co)^;
      if am <> 0 then begin
        for j:= 0 to Nmvar do begin
          M.At(k, j)^:= M.At(k, j)^ + am * M.At(ri, j)^;
        end;
      end;
    end;
  end;
  InBase[ri]:= olo;
end;

procedure TRSimplex.FindIn(var bb: TS0Matrix; var ri: integer);
var
  vl: PREC;
  i: integer;
begin
  ri:= 0;
  for i:= 1 to NumVin do begin
    if bb.At(i, 0)^ < 0 then begin
      if ri = 0 then begin
        ri:= i;
        vl:= bb.At(i, 0)^;
      end
      else if bb.At(i, 0)^ < vl then begin
        vl:= bb.At(i, 0)^;
        ri:= i;
      end;
    end;
  end;
  if abs(vl) < Zero then ri:= 0;
end;

procedure TRSimplex.FindOut(var as, c: TS0Matrix; var co: integer);
var
  rin, rap: PREC;
  k: integer;
begin
  co:= 0;
  rin:= Inf;
  for k:= 1 to NumCol do begin
    if as.At(0, k)^ < 0 then begin
      rap:= c.At(0, k)^ / -as.At(0, k)^;
      if (rap < rin) then begin
        rin:= rap;
        co:= k;
      end;
    end;
  end;
end;

function TRSimplex.Simplesso(var x: TRow): integer;
var
  B: TS0Matrix; (* matrice inversa ampliata *)
  C: TS0Matrix;  (* costi *)
  bb: TS0Matrix;
  ai, as: TS0Matrix;
  i, j, k, ob, vin, vout: integer;
  tmp, tmp1, tmp2: PREC;
label qui, esci;
begin
  FillChar(x, sizeof(x), 0);
  B.Init(NumVin+1, NumVin+1);
  C.Init(1, NumCol+1);
  bb.Init(NumVin+1, 1);
  ai.Init(NumVin+1, 1);
  as.Init(1, NumCol+1);
  (* Inizializzo B*^-1 *)
  (* Fase1: Copia le colonne di A che sono in base in B *)
  for i:= 1 to NumVin do begin
    for j:= 1 to NumVin do begin
      B.At(j, i)^:= A.At(j, InBase[i])^;
    end;
  end;
  (* Identifica la colonna dei costi da utilizzare *)
  if NumFit = 0 then ob:= 0 
  else begin
    for j:= 0 to pred(NumFit) do A.At(NumVin+1, NumCol-j)^:= 0;
    for j:= 0 to NumCol-NumFit do begin
      tmp:= 0;
      for k:= 1 to NumFit do begin
        i:= IndFit[k];
        tmp:= tmp+A.At(i,j)^;
      end;
      A.At(NumVin+1, j)^:= -tmp;
    end;
    ob:= NumVin+1;
    NumVar:= NumVar + NumFit;
  end;
  for i:= 1 to NumVin do begin
    B.At(0, i)^:= -A.At(ob, InBase[i])^; (* Moltiplicatori ã *)
  end;
  (* Costi iniziali *)
  for i:= 0 to NumVar do begin
    C.At(0, i)^:= A.At(ob, i)^;
  end;
Qui:
  repeat
    ZeroMat(B, NumVin, NumVin);
    (* Ciclo di ottimizzazione *)
    (* Aggiorna i termini noti *)
    for i:= 1 to NumVin do begin
      tmp1:= 0; tmp:= 0; tmp2:= 0;
      for j:= 1 to NumVin do begin
        tmp:= B.At(i, j)^;
        tmp2:= tmp2 + tmp * A.At(j, 0)^;
      end;
      bb.At(i, 0)^:= tmp2;
    end;
    FindIn(bb, vout);  (* Trova variabile che entra *)
(* !!!!
    vout:= 0;
    if vin = 0 then break;
*)
    if vout = 0 then break;
    (* Aggiorna la riga utilizzata x test entrata *)
    for i:= 1 to NumCol do begin
      tmp1:= 0; tmp:= 0;
      for j:= 1 to NumVin do begin
        tmp:= B.At(vout, j)^;
        tmp1:= tmp1 + tmp * A.At(j, i)^;
      end;
      as.At(0, i)^:= tmp1;
    end;
    FindOut(as, c, vin); (* e quella che esce *)
    if vin = 0 then break;
    (* Aggiorna la colonna che entra *)
    for i:= 1 to NumVin do begin
      tmp1:= 0; tmp:= 0;
      for j:= 1 to NumVin do begin
        tmp:= B.At(i, j)^;
        tmp1:= tmp1 + tmp * A.At(j, vin)^;
      end;
      ai.At(i, 0)^:= tmp1;
    end;
    (* Aggiornamento matrice b *)
    for k:= 1 to NumVin do begin
      B.At(k, 0)^:= ai.At(k, 0)^;
    end;
    B.At(0, 0)^:= C.At(0, vin)^;
    Pivot(B, NumVin, NumVin, 0, vout, vin);
    (* aggiornamento dei costi *)
    for j:= 0 to NumVar do begin 
      tmp:= A.At(ob, j)^;
      for i:= 1 to NumVin do begin
        tmp:= tmp + B.At(0, i)^ * A.At(i, j)^;
      end;
      C.At(0, j)^:= tmp;
    end;
    for i:= 1 to NumVin do C.At(0, InBase[i])^:= 0; (* forza a 0 i costi in base *)
  until false;
  if NumFit = 0 then begin
    if vin <> 0 then Simplesso:= 1
    else Simplesso:= 0;
  end
  else begin
    if vin <> 0 then Simplesso:= 1
    else begin
      Dec(NumVar, NumFit);
      for k:=1 to NumVin do begin
        (* fittizzia in base con valore <> 0 ? *)
        if (InBase[k] > NumVar) then begin
          if (abs(C.At(0, 0)^) < Zero) or (abs(bb.At(k, 0)^) < Zero) then begin
            break;
          end
          else begin (* non c'e' soluzione ammissibile *)
            Simplesso:= 2;
            exit;
          end;
        end;
        NumFit:= 0;
        ob:= 0;
        (* aggiorna i moltiplicatori e i costi *)
        for i:= 1 to NumVin do begin
          tmp:= 0;
          for j:= 1 to NumVin do begin
            tmp:= tmp + A.At(0, InBase[j])^ * B.At(j, i)^;
          end;
          B.At(0, i)^:= -tmp; 
        end;
        for j:= 0 to NumVar+NumFit do begin 
          tmp:= A.At(0, j)^;
          for i:= 1 to NumVin do begin
            tmp:= tmp + B.At(0, i)^ * A.At(i, j)^;
          end;
          C.At(0, j)^:= tmp;
        end;
        for i:= 1 to NumVin do C.At(0, InBase[i])^:= 0; (* forza a 0 i costi in base *)
        Goto Qui;
      end;
    end;
  end;
  for k:= 1 to NumVin do begin
    tmp:= 0; 
    for i:= 1 to NumVin do begin
      tmp:= tmp + B.At(k, i)^ * A.At(i, 0)^;
    end;
    X[InBase[k]]:= tmp;
  end;
  tmp:= 0;
  for i:= 1 to NumVin do begin
    tmp:= tmp + B.At(0, i)^ * A.At(i, 0)^;
  end;
  X[0]:= -VarKin[0] * tmp;
end;

end.
