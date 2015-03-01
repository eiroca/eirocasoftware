unit SSimplex;
(* Programmazione Lineare - Algoritmo del simplesso standard *)

{$I switches.inc}

interface

uses MathTool, Matrix, PLProg, Dos, DataMngr;

type

  PSSimplex = ^TSSimplex;
  TSSimplex = object(TPL)
     InBase, IndFit: array[1..MaxCol] of integer;
     NumFit, NumCol: integer;
     constructor Init(ErrMng: PErrMngr);
     procedure Normalize; virtual;
     procedure Load(const FName: PathStr); virtual;
     function  Calc(var x: TRow): integer; virtual;
     function  Solv(var x: TRow): integer; virtual;
    private
     procedure ZeroMat;
     procedure FindIn(var M: TSMatrix; ob: integer; var co: integer);
     procedure FindOut(var M: TSMatrix; co: integer; var ri: integer);
     procedure Pivot(var M: TSMatrix; ob, co, ri: integer);
     function  SolvSimp(ob: integer): integer;
     function  Simplesso: integer;
  end;

procedure PRisult(var x: TSSimplex; kind: integer);

implementation

constructor TSSimplex.Init(ErrMng: PErrMngr);
begin
  inherited Init(ErrMng);
  NumFit:= 0;
  NumCol:= 0;
end;

procedure TSSimplex.Load(const FName: PathStr); 
begin
  NumFit:= 0;
  NumCol:= 0;
  inherited Load(FName);
end;

procedure TSSimplex.Normalize;
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
    if abs(A.At(k, 0)^) < Zero then A.At(k, 0)^:= 0;
    Est:= VinKin[k];
    if A.At(k, 0)^ < 0 then begin
      Err^.Warning('Warning: A.At()^ < 0, riaggiusto il vincolo!');
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
  for k:= 1 to NumVar do begin
    if VarKin[k] <> 0 then begin (* Attualmente gestisce variabili solo in R+ *)
      Err^.Error(ErrOptErr);
      exit;
    end;
  end;
end;

function TSSimplex.Calc(var x: TRow): integer;
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

function TSSimplex.Solv(var x: TRow): integer;
(* Trova l'ottimo del programma lineare, modifica PL originario in uno 
equivalente, ritorna 0 se tutto Ok, 1 se soluzione illimitata, 2 se nessuna
soluzione e' ammissibile *)
var 
  ires: integer;
  k: integer;
begin
  Normalize;
  ires:= Simplesso;
  FillChar(x, sizeof(x), 0);
  if ires = 0 then begin
    for k:= 1 to NumVin do begin
      X[InBase[k]]:= A.At(K, 0)^;
    end;
    X[0]:= -VarKin[0] * A.At(0, 0)^;
  end;
  Solv:= ires;
end;

procedure TSSimplex.ZeroMat;
var k, j: integer;
begin
  for k:= 0 to NumVin do begin
    for j:= 0 to NumCol do begin
      if abs(A.At(k, j)^) < Zero then A.At(k, j)^:= 0;
    end;
  end;
end;

procedure TSSimplex.Pivot(var M: TSMatrix; ob, co, ri: integer);
var
  am, piv: PREC;
  j, k: integer;
begin
  am:= 1 / A.At(ri, co)^;
  for j:= 0 to NumCol do begin
    A.At(ri, j)^:= A.At(ri, j)^ * am;
  end;
  for k:= 0 to NumVin do begin
    if (k<> ri) then begin
      am:= -A.At(k, co)^;
      if am <> 0 then begin
        for j:= 0 to NumCol do begin
          A.At(k, j)^:= A.At(k, j)^ + am * A.At(ri, j)^;
        end;
      end;
    end;
  end;
  if ob > NumVin then begin
    piv:= -A.At(ob, co)^;
    for j:= 0 to NumCol do begin
      A.At(ob, j)^:= A.At(ob, j)^ + piv * A.At(ri, j)^;
    end;
  end;
  InBase[ri]:= co;
end;

procedure TSSimplex.FindIn(var M: TSMatrix; ob: integer; var co: integer);
var
  vl: PREC;
  i: integer;
begin
  co:= 0;
  for i:= 1 to NumCol do begin
    if M.At(ob, i)^ < 0 then begin
      if co = 0 then begin
        co:= i;
        vl:= M.At(ob, i)^;
      end
      else if M.At(ob, i)^ < vl then begin
        vl:= M.At(ob, i)^;
        co:= i;
      end;
    end;
  end;
  if abs(vl) < Zero then co:= 0;
end;

procedure TSSimplex.FindOut(var M: TSMatrix; co: integer; var ri: integer);
var
  rin, rap: PREC;
  k: integer;
begin
  ri:= 0;
  if co = 0 then exit;
  rin:= Inf;
  for k:= 1 to NumVin do begin
    if A.At(k, co)^ > 0 then begin
      rap:= A.At(k, 0)^ / A.At(k, co)^;
      if (rap < rin) then begin
        rin:= rap;
        ri:= k;
      end;
    end;
  end;
end;

function TSSimplex.SolvSimp(ob: integer): integer;
(* Simplesso, C: # riga obiettivo *)
(* ritorna 1 se c'e' IN, ma non OUT *)
var
  ri, co: integer;
begin
  repeat
    ZeroMat;
    FindIn(A, ob, co);
    FindOut(A, co, ri);
    if (co > 0) then begin
      Pivot(A, ob, co, ri);
    end;
  until (ri = 0);
  if (co<>0) then SolvSimp:= 1 else SolvSimp:= 0;
end;

function TSSimplex.Simplesso: integer;
var 
  j, k, l: integer;
  s: PREC;
begin
  if (NumFit > 0) then begin
    for j:= 0 to pred(NumFit) do A.At(NumVin+1, NumCol-j)^:= 0;
    for j:= 0 to NumCol-NumFit do begin
      s:= 0;
      for k:= 1 to NumFit do begin
        l:= IndFit[k];
        s:=s+A.At(l,j)^;
      end;
      A.At(NumVin+1, j)^:= -s;
    end;
    SolvSimp(NumVin+1);
    NumCol:= NumCol - NumFit;
    for k:=1 to NumVin do begin
      (* fittizzia in base con valore <> 0 ? *)
      if (InBase[k] > NumCol) then begin
        if (abs(A.At(NumVin+1, 0)^) < Zero) or (abs(A.At(k, 0)^) < Zero) then begin
          (* E' degenere ma e' ancora soluzione buona, quello che segue
          serve solo per evitare errori numerici *)
          for j:= 0 to NumCol+NumFit do begin
            A.At(k,j)^:= 0;
          end;
          A.At(k, InBase[k])^:= 1;
        end
        else begin (* non c'e' soluzione ammissibile *)
          Simplesso:= 2;
          exit;
        end;
      end;
    end;
  end;
  Simplesso:= SolvSimp(0);
end;

procedure PRisult(var x: TSSimplex; kind: integer);
var
  Unica, Flag: boolean;
  z, tmp: PREC;
  ch: char;
  i, l, j, k: integer;
  function ISIND(M: integer): integer;
  begin
    i:= 0; l:= 0;
    repeat
      inc(i);
      if (X.InBase[i] = M) then l:= i;
    until (l>0) or (i=X.NumVin);
    ISIND:= l;
  end;
begin
  writeln;
  writeln('Risultati ottimizzazione');
  writeln;
  if kind = 2 then begin
    writeln('Soluzioni ammissibili inesistenti');
  end
  else if kind = 1 then begin
    writeln('Soluzione ottima infinita');
  end
  else begin
    unica:= true;
    for j:= 1 to X.NumCol do begin
      if (X.A.At(0, j)^ = 0) and (ISIND(j)=0) then begin
        flag:= true;
        for k:= 1 to X.NumVin do begin
          if (X.A.At(k, j)^>0) and (X.A.At(k, 0)^=0) then flag:= false;
        end;
        if flag then unica:= false;
      end;
    end;
    if unica then begin
      writeln('Soluzione ottima unica');
    end
    else begin
      writeln('Infinite soluzioni ottime');
    end;
    writeln;
    z:= -X.A.At(0, 0)^ * X.VarKin[0];
    for k:= 1 to X.NumVar do begin
      tmp:= 0;
      l:= ISIND(k);
      if l > 0 then begin
        tmp:= x.A.At(l, 0)^;
        ch:='#';
      end
      else ch:= ' ';
      writeln(X.VarNam[k]:X.VarLenMax,' = ', tmp:15:5,' ',ch);
    end;
    writeln;
    writeln('# = in base');
    writeln;
    write('Valore ');
    case X.VarKin[0] of 
      1: write('minimo');
      -1: write('massimo');
      else write('?????');
    end;
    writeln(' di ', X.VarNam[0],' = ', z:15:5);
  end;
  writeln;
  WaitReturn;
end;

end.
