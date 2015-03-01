unit RSimplex;
(* Programmazione Lineare - Algoritmo del simplesso revisionato *)

{$I switches.inc}

interface

uses Matrix, PLProg, Dos, Crt, DataMngr, MathTool;

type

  PRSimplex = ^TRSimplex;
  TRSimplex = object(TPL)
     InBase, IndFit: array[1..MaxCol] of integer;
     NumFit, NumCol: integer;
     B: TSMatrix; (* matrice inversa ampliata *)
     constructor Init(ErrMng: PErrMngr);
     destructor  done; virtual;
     procedure Normalize; virtual;
     procedure Load(const FName: PathStr); virtual;
     procedure ReLoad; virtual;
     function  Calc(var x: TRow): integer; virtual;
     function  Solv(var x: TRow): integer; virtual;

     procedure AnalParmb;
     procedure AnalParmc;
     procedure AnalParmlb;
     procedure AnalParmlc;

     function  SolvDuale(aa: integer): integer;
     procedure FindInb(var bb: TSVector; var ri: integer);
     procedure FindOutb(var as, c: TSVector; var co: integer);

    private
     procedure ZeroMat(X: TSMatrix; NmVin, NmVar: integer);
     procedure FindIn(var C: TSVector; var co: integer);
     procedure FindOut(var ai, bb: TSVector; co: integer; var ri: integer);
     procedure Pivot(var M: TSMatrix; NmVin, NmVar, co, ri, olo: integer);
     function  Simplesso(var x: TRow): integer;
     procedure PrintBPi;
  end;

implementation

constructor TRSimplex.Init(ErrMng: PErrMngr);
begin
  NumFit:= 0;
  NumCol:= 0;
  B.Init(0,1,1);
  inherited Init(ErrMng);
end;

destructor TRSimplex.Done;
begin
  B.Done;
  inherited Done;
end;

procedure TRSimplex.Load(const FName: PathStr);
begin
  NumFit:= 0;
  NumCol:= 0;
  inherited Load(FName);
end;

procedure TRSimplex.ReLoad;
begin
  NumFit:= 0;
  NumCol:= 0;
  inherited ReLoad;
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

procedure TRSimplex.ZeroMat(X: TSMatrix; NmVin, NmVar: integer);
var k, j: integer;
begin
  for k:= 0 to NmVin do begin
    for j:= 0 to NmVar do begin
      if abs(X.At(k, j)^) < Zero then X.At(k, j)^:= 0;
    end;
  end;
end;

procedure TRSimplex.Pivot(var M: TSMatrix; NmVin, NmVar, co, ri, olo: integer);
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

procedure TRSimplex.FindIn(var C: TSVector; var co: integer);
var
  vl: PREC;
  i: integer;
begin
  co:= 0;
  for i:= 1 to NumVar do begin
    if C.At(i)^ < 0 then begin
      if co = 0 then begin
        co:= i;
        vl:= C.At(i)^;
      end
      else if C.At(i)^ < vl then begin
        vl:= C.At(i)^;
        co:= i;
      end;
    end;
  end;
  if abs(vl) < Zero then co:= 0;
end;

procedure TRSimplex.FindOut(var ai, bb: TSVector; co: integer; var ri: integer);
var
  rin, rap: PREC;
  k: integer;
begin
  ri:= 0;
  if co = 0 then exit;
  rin:= Inf;
  for k:= 1 to NumVin do begin
    if ai.At(k)^ > 0 then begin
      rap:= bb.At(k)^ / ai.At(k)^;
      if (rap < rin) then begin
        rin:= rap;
        ri:= k;
      end;
    end;
  end;
end;

function TRSimplex.Simplesso(var x: TRow): integer;
var
  C: TSVector;  (* costi, vettore riga!! *)
  bb: TSVector;
  ai: TSVector;
  i, j, k, ob, vin, vout: integer;
  tmp, tmp1, tmp2: PREC;
label qui, esci;
begin
  FillChar(x, sizeof(x), 0);
  B.Done;
  B.Init(0,NumVin+1, NumVin+1);
  C.Init(0,NumCol+1);
  bb.Init(0,NumVin+1);
  ai.Init(0,NumVin+1);
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
    C.At(i)^:= A.At(ob, i)^;
  end;
Qui:
  repeat
    ZeroMat(B, NumVin, NumVin);
    (* Ciclo di ottimizzazione *)
    FindIn(C, vin);  (* Trova variabile che entra *)
    vout:= 0;
    if vin = 0 then break;
    (* Aggiorna i termini noti e la colonna che si utilizzera' *)
    for i:= 1 to NumVin do begin
      tmp1:= 0; tmp2:= 0; tmp:= 0;
      for j:= 1 to NumVin do begin
        tmp:= B.At(i, j)^;
        tmp1:= tmp1 + tmp * A.At(j, vin)^;
        tmp2:= tmp2 + tmp * A.At(j, 0)^;
      end;
      ai.At(i)^:= tmp1;
      bb.At(i)^:= tmp2;
    end;
    FindOut(ai, bb, vin, vout); (* e quella che esce *)
    if vout = 0 then break;
    (* Aggiornamento matrice b *)
    for k:= 1 to NumVin do begin
      B.At(k, 0)^:= ai.At(k)^;
    end;
    B.At(0, 0)^:= C.At(vin)^;
    Pivot(B, NumVin, NumVin, 0, vout, vin);
    (* aggiornamento dei costi *)
    for j:= 0 to NumVar do begin
      tmp:= A.At(ob, j)^;
      for i:= 1 to NumVin do begin
        tmp:= tmp + B.At(0, i)^ * A.At(i, j)^;
      end;
      C.At(j)^:= tmp;
    end;
    for i:= 1 to NumVin do C.At(InBase[i])^:= 0; (* forza a 0 i costi in base *)
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
          if (abs(C.At(0)^) < Zero) or (abs(bb.At(k)^) < Zero) then begin
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
          C.At(j)^:= tmp;
        end;
        for i:= 1 to NumVin do C.At(InBase[i])^:= 0; (* forza a 0 i costi in base *)
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

procedure TRSimplex.PrintBPi;
var i, j: integer;
begin
  writeln;
  write('InBase[] = {');
  for i:= 1 to NumVin - 1 do write(InBase[i],',');
  writeln(InBase[NumVin],'}');
  WaitReturn;
  writeln;
  writeln('B*^-1');
  for i:= 1 to NumVin do begin
    write('[ ');
    for j:= 1 to NumVin do begin
      write(B.At(i,j)^:11:3,' ');
    end;
    writeln(']');
  end;
  WaitReturn;
  writeln;
  writeln('ã*');
  write('[ ');
  for j:= 1 to NumVin do begin
  write(B.At(0,j)^:11:3,' ');
  end;
  writeln(']');
  WaitReturn;
end;

procedure TRSimplex.AnalParmb;
var
  i, j, k, kk: integer;
  ires: integer;
  ba, bb: TSVector;
  tmp, tmp2, min1, min2: PREC;
  X: TRow;
begin
  ReLoad; Solv(x);
  PrintBPi;
  bb.Init(0,NumVin+1);
  ba.Init(0,NumVin+1);
  (* calcolo baggiornato *)
  for i:= 1 to NumVin do begin
    tmp := 0;
    for j:= 1 to NumVin do begin
      tmp:= tmp + B.At(i, j)^ * A.At(j, 0)^;
    end;
    if tmp < Zero then tmp:= 0;
    ba.At(i)^:= tmp;
  end;
  writeln;
  writeln('b aggiornato');
  write('[ ');
  for j:= 1 to NumVin do begin
    write(ba.At(j)^:11:3,' ');
  end;
  writeln(']');
  WaitReturn;
  (* Intervalli di b *)
  for i:= 1 to NumVin do begin
    write('Vincolo # ',i,'  ');
    if abs(B.At(0, i)^) < Zero then begin
      writeln('non economico ã[i] = 0');
      continue;
    end;
    (* copia colonna appropriata di B^-1 in bb *)
    for j:= 1 to NumVin do begin
      bb.At(j)^:= B.At(j, i)^;
    end;
    min1:= 10e10; min2:= 10e10;
    for j:= 1 to NumVin do begin
      if abs(bb.At(j)^) > Zero then tmp:= ba.At(j)^ / abs(bb.At(j)^);
      if bb.At(j)^ > 0 then if tmp < min2 then min2:= tmp else begin end
      else if tmp < min1 then min1:= tmp;
    end;
    writeln('limiti b [', (A.At(i, 0)^-min2):11:3,' - ', (A.At(i, 0)^+min1):11:3,']');
    write('sol inf [');
    tmp:= 0;
    for j:= 1 to NumVin do begin
      tmp2:= (ba.At(j)^-bb.At(j)^*min2);
      tmp:= tmp + tmp2 * A.At(0, j)^;
      write(tmp2:11:3,' ');
    end;
    writeln('] = ', VarKin[0]*tmp:11:3);
    write('sol sup [');
    tmp:= 0;
    for j:= 1 to NumVin do begin
      tmp2:= (ba.At(j)^+bb.At(j)^*min1);
      tmp:= tmp + tmp2 * A.At(0, j)^;
      write(tmp2:11:3,' ');
    end;
    writeln('] = ', VarKin[0]*tmp:11:3);
    WaitReturn;
  end;
  WaitReturn;
end;

procedure TRSimplex.AnalParmc;
var
  i, j, k, kk: integer;
  ires: integer;
  ba, bb: TSVector;
  tmp, tmp2, min1, min2: PREC;
  tlmd: PREC;
  X: TRow;
  yn: char;
begin
  ReLoad; Solv(x);
  PrintBPi;
  bb.Init(0,NumVin+1);
  ba.Init(0,NumVin+1);
  (* calcolo baggiornato *)
  for i:= 1 to NumVin do begin
    tmp := 0;
    for j:= 1 to NumVin do begin
      tmp:= tmp + B.At(i, j)^ * A.At(j, 0)^;
    end;
    if tmp < Zero then tmp:= 0;
    ba.At(i)^:= tmp;
  end;
  writeln;
  writeln('b aggiornato');
  write('[ ');
  for j:= 1 to NumVin do begin
    write(ba.At(j)^:11:3,' ');
  end;
  writeln(']');
  WaitReturn;
  writeln;
  writeln('Variazione costi non in base ');
  writeln;
  for i:= 1 to NumVar do begin
    k:= 0;
    for j:= 1 to NumVin do begin
      if InBase[j] = i then begin
        k:= j;
        break;
      end;
    end;
    if k <> 0 then writeln(VarNam[i],' in base ')
    else begin
      tmp:= 0;
      for j:= 1 to NumVin do begin
        tmp:= tmp + B.At(0, j)^ * A.At(j, i)^;
      end;
      write(VarNam[i],' costo ', VarKin[0]*A.At(0,i)^:11:3,' cost teor. ',tmp:11:3,' ');
      if A.At(0,i)^ > Zero then writeln(tmp/A.At(0,i)^*100:5:2,'%') else writeln;
    end;
  end;
  WaitReturn;
  writeln;
  write('CB* [ ');
  for j:= 1 to NumVin do begin
    write((VarKin[0] * A.At(0, InBase[j])^):11:3,' ');
  end;
  writeln(']');
  for i:= 1 to NumVin do begin
    j:= InBase[i];
    if j <= NumVar then begin
      write('Variazione costi di ',VarNam[j],' ',VarKin[0]*A.At(0, j)^:11:3,' î ');
      min1:= 10e10;
      min2:= 10e10;
      for k:= 1 to NumVin do begin
        if abs(B.At(i, k)^) > Zero then tmp:= B.At(0, k)^ / abs(B.At(i, k)^) else tmp:= 11e10;
        if B.At(i, k)^ > 0 then if tmp < min1 then min1:= tmp else begin end
        else if tmp < min2 then min2:= tmp;
      end;
      writeln(' [ ', VarKin[0]*(A.At(0, j)^ + min1):11:3, ' - ', VarKin[0]*(A.At(0, j)^ - min2):11:3,' ]');
    end
    else writeln('Variabile #',j,' fittizzia saltata');
  end;
  WaitReturn;
end;

procedure TRSimplex.AnalParmlb;
var
  i, j, k, kk: integer;
  ires: integer;
  beta, ba, bb: TSVector;
  tmp, tmp2, min1, min2: PREC;
  tlmd: PREC;
  X: TRow;
  yn: char;
begin
  ReLoad; Solv(x);
  PrintBPi;
  bb.Init(0,NumVin+1);
  ba.Init(0,NumVin+1);
  beta.Init(0,NumVin+1);
  (* calcolo baggiornato *)
  for i:= 1 to NumVin do begin
    tmp := 0;
    for j:= 1 to NumVin do begin
      tmp:= tmp + B.At(i, j)^ * A.At(j, 0)^;
    end;
    if tmp < Zero then tmp:= 0;
    ba.At(i)^:= tmp;
  end;
  writeln;
  writeln('b aggiornato');
  write('[ ');
  for j:= 1 to NumVin do begin
    write(ba.At(j)^:11:3,' ');
  end;
  writeln(']');
  WaitReturn;
  writeln;
  writeln('Analisi parametrica b ');
  for i:= 1 to NumVin do begin
    beta.At(i)^:= 0;
    write('Elemento #',i:2,' = '); InputPrec('',beta.At(i)^,-inf,inf);
  end;
  tlmd:= 0;
  repeat
    for i:= 1 to NumVin do begin
      tmp := 0;
      for j:= 1 to NumVin do begin
        tmp:= tmp + B.At(i, j)^ * beta.At(j)^;
      end;
      if abs(tmp) < Zero then tmp:= 0;
      bb.At(i)^:= tmp;
    end;
    min1:= 10e10;
    min2:= 10e10;
    for j:= 1 to NumVin do begin
      if abs(bb.At(j)^) > Zero then tmp:= ba.At(j)^ / abs(bb.At(j)^);
      if bb.At(j)^ > 0 then if tmp < min2 then min2:= tmp else begin end
      else if tmp < min1 then min1:= tmp;
    end;
    writeln;
    tlmd:= tlmd + min1;
    writeln('lmd (>0) totale = ',tlmd:9:3);
    writeln('limiti lmd = ',min1:9:3,' ; ',-min2:9:3,' [',(A.At(i, 0)^+ min1 * Beta.At(i)^):11:3,
      ' ; ', (A.At(i, 0)^-min2 * Beta.At(i)^):11:3,']');
    write('sol. l>0 [');
    tmp:= 0;
    for j:= 1 to NumVin do begin
      tmp2:= (ba.At(j)^+bb.At(j)^*min1);
      if abs(tmp2) < Zero then begin
        k:= j;
        tmp2:= 0;
      end;
      tmp:= tmp + tmp2 * A.At(0, j)^;
      write(tmp2:11:3,' ');
    end;
    writeln('] = ', VarKin[0]*tmp:11:3);
    write('sol. l<0 [');
    tmp:= 0;
    for j:= 1 to NumVin do begin
      tmp2:= (ba.At(j)^-bb.At(j)^*min2);
      if abs(tmp2) < Zero then begin
        kk:= j;
        tmp2:= 0;
      end;
      tmp:= tmp + tmp2 * A.At(0, j)^;
      write(tmp2:11:3,' ');
    end;
    writeln('] = ', VarKin[0]*tmp:11:3);
    WaitReturn;
    writeln;
    write('new b (lmd>0) [');
    for j:= 1 to NumVin do begin
      tmp:= A.At(j, 0)^ + min1 * beta.At(j)^;
      if abs(tmp) < Zero then tmp:= 0;
      A.At(j, 0)^:= tmp;
      write(tmp:11:3,' ');
    end;
    writeln(']');
    writeln;
    yn:= 'S';
    write('proseguo? '); yn:= UpCase(readkey); if yn = #0 then readkey;
    writeln;
    if yn ='N' then break;
    ires:= SolvDuale(0);
    if ires = 0 then begin
      PrintBPi;
      (* calcolo baggiornato *)
      for i:= 1 to NumVin do begin
        tmp := 0;
        for j:= 1 to NumVin do begin
          tmp:= tmp + B.At(i, j)^ * A.At(j, 0)^;
        end;
        if tmp < Zero then tmp:= 0;
        ba.At(i)^:= tmp;
      end;
    end;
    if abs(min1) < Zero then ires:= 1;
  until ires <> 0;
  if yn <> 'N' then begin
    writeln('Non ci sono pi— lmd ammissibili');
    WaitReturn;
  end;
end;

procedure TRSimplex.AnalParmlc;
var
  i, j, k, kk: integer;
  ires: integer;
  c, ugam, gamm: TSVector;
  ba, ak: TSVector;
  tmp, tmp1, min1, min2: PREC;
  tlmd: PREC;
  X: TRow;
  flg: boolean;
  yn: char;
begin
  ReLoad; Solv(x);
  PrintBPi;
  ak.Init(0,NumVin+1);
  ba.Init(0,NumVin+1);
  gamm.Init(0,NumCol+1);
  ugam.Init(0,NumCol+1);
  c.Init(0,NumCol+1);
  for i:= 0 to NumCol do begin
    gamm.At(i)^:= 0;
    ugam.At(i)^:= 0;
    c.At(i)^:=-1;
  end;
  (* calcolo c aggiornato *)
  for i:= 1 to NumVin do begin
    C.At(InBase[i])^:= 0;
  end;
  for i:= 1 to NumCol do begin
    if c.At(i)^ = 0 then continue; (* variabile in base *)
    for k:= 1 to NumVin do begin
      tmp:= 0; tmp1:= 0;
      for j:= 1 to NumVin do begin
        tmp:= B.At(k, j)^;
        tmp1:= tmp1 + tmp * A.At(j, i)^;
      end;
      if abs(tmp1) < Zero then tmp1:= 0;
      ak.At(k)^:= tmp1;
    end;
    tmp:= 0; tmp1:= 0;
    for j:= 1 to NumVin do begin
      tmp:= A.At(0, InBase[j])^;
      tmp1:= tmp1 + tmp * ak.At(j)^;
    end;
    if abs(tmp1) < Zero then tmp1:= 0;
    c.At(i)^:= VarKin[0]*(A.At(0,i)^ - tmp1);
  end;
  writeln;
  writeln('c aggiornato');
  write('[ ');
  for j:= 1 to NumCol do begin
    write(C.At(j)^:11:3,' ');
  end;
  writeln(']');
  WaitReturn;

  writeln;
  writeln('Analisi parametrica costi ');
  for i:= 1 to NumVar do begin
    gamm.At(i)^:= 0;
    write('Costo #',i:2,' = '); InputPrec('',gamm.At(i)^,-inf,inf);
  end;
  tlmd:= 0;
  for k:= 1 to NumCol do begin
    flg:= false;
    for j:= 1 to NumVin do begin
      if k = InBase[j] then begin
        flg:= true;
        break;
      end;
    end;
    if flg then continue;
    (* Aggiorna A[.,k] *)
    for i:= 1 to NumVin do begin
      tmp:= 0; tmp1:= 0;
      for j:= 1 to NumVin do begin
        tmp:= B.At(i, j)^;
        tmp1:= tmp1 + tmp * A.At(j, k)^;
      end;
      if abs(tmp1) < Zero then tmp1:= 0;
      ak.At(i)^:= tmp1;
    end;
    (* âB * Ag[.,k] *)
    tmp:= 0;
    for i:= 1 to NumVin do begin
      tmp:= tmp + gamm.At(i)^ * ak.At(i)^;
    end;
    if abs(tmp) < Zero then tmp:= 0;
    (* ugam = âNB - âB*NBagg *)
    ugam.At(k)^:= gamm.At(k)^-tmp;
  end;
  min1:= 10e10;
  min2:= 10e10;
  for k:= 1 to NumCol do begin
    tmp:= 10e10;
    (* costo in base? *)
    flg:= false;
    for j:= 1 to NumVin do begin
      if k = InBase[j] then begin
        flg:= true;
        break;
      end;
    end;
    if flg then continue;
    if abs(ugam.At(k)^) > Zero then tmp:= abs(C.At(k)^ / ugam.At(k)^);
    if VarKin[0]*ugam.At(k)^ > 0 then if tmp < min2 then min2:= tmp else begin end
    else if tmp < min1 then min1:= tmp;
  end;
  tlmd:= tlmd + min1;
  writeln('lmd (>0) totale = ',tlmd:9:3);
  writeln('limiti lmd = ',min1:9:3,' ; ',-min2:9:3);
  writeln;
  WaitReturn;
end;

function TRSimplex.SolvDuale(aa: integer): integer;
var
  C, as: TSVector;  (* vettori riga!!! *)
  bb, ai: TSVector;
  i, j, k, vin, vout: integer;
  tmp, tmp1, tmp2: PREC;
begin
  C.Init(0,NumCol+1);
  bb.Init(0,NumVin+1);
  ai.Init(0,NumVin+1);
  as.Init(0,NumCol+1);
  repeat
    ZeroMat(B, NumVin, NumVin);
    for j:= 0 to NumCol do begin
      tmp:= A.At(0, j)^;
      for i:= 1 to NumVin do begin
        tmp:= tmp + B.At(0, i)^ * A.At(i, j)^;
      end;
      if abs(tmp) < Zero then tmp:= 0;
      C.At(j)^:= tmp;
    end;
    (* Ciclo di ottimizzazione *)
    (* Aggiorna i termini noti *)
    for i:= 1 to NumVin do begin
      tmp1:= 0; tmp2:= 0;
      for j:= 1 to NumVin do begin
        tmp:= B.At(i, j)^;
        tmp2:= tmp2 + tmp * A.At(j, 0)^;
      end;
      if abs(tmp2) < Zero then tmp2:= 0;
      bb.At(i)^:= tmp2;
    end;
    if aa <>0 then begin
      vout:= aa;
      aa:= 0;
    end
    else
      FindInb(bb, vout);  (* Trova variabile che entra *)
    if vout = 0 then break;
    vin:= 0;
    (* Aggiorna la riga utilizzata x test entrata *)
    for i:= 1 to NumCol do begin
      tmp1:= 0; tmp:= 0;
      for j:= 1 to NumVin do begin
        tmp:= B.At(vout, j)^;
        tmp1:= tmp1 + tmp * A.At(j, i)^;
      end;
      if abs(tmp1)<Zero then tmp1:= 0;
      as.At(i)^:= tmp1;
    end;
    FindOutb(as, c, vin); (* e quella che esce *)
    if vin = 0 then break;
    (* Aggiorna la colonna che entra *)
    for i:= 1 to NumVin do begin
      tmp1:= 0; tmp:= 0;
      for j:= 1 to NumVin do begin
        tmp:= B.At(i, j)^;
        tmp1:= tmp1 + tmp * A.At(j, vin)^;
      end;
      ai.At(i)^:= tmp1;
    end;
    (* Aggiornamento matrice b *)
    for k:= 1 to NumVin do begin
      B.At(k, 0)^:= ai.At(k)^;
    end;
    B.At(0, 0)^:= C.At(vin)^;
    Pivot(B, NumVin, NumVin, 0, vout, vin);
    (* aggiornamento dei costi *)
    for j:= 0 to NumCol do begin
      tmp:= A.At(0, j)^;
      for i:= 1 to NumVin do begin
        tmp:= tmp + B.At(0, i)^ * A.At(i, j)^;
      end;
      C.At(j)^:= tmp;
    end;
    for i:= 1 to NumVin do C.At(InBase[i])^:= 0; (* forza a 0 i costi in base *)
  until false;
  (* aggiornamento dei costi *)
  for i:= 1 to NumVin do C.At(InBase[i])^:= 0; (* forza a 0 i costi in base *)
  if NumFit = 0 then begin
    if vin = 0 then SolvDuale:= 1
    else SolvDuale:= 0;
  end;
end;

procedure TRSimplex.FindInb(var bb: TSVector; var ri: integer);
var
  vl: PREC;
  i: integer;
begin
  ri:= 0;
  for i:= 1 to NumVin do begin
    if bb.At(i)^ < Zero then begin
      if ri = 0 then begin
        ri:= i;
        vl:= bb.At(i)^;
      end
      else if bb.At(i)^ < vl then begin
        vl:= bb.At(i)^;
        ri:= i;
      end;
    end;
  end;
end;

procedure TRSimplex.FindOutb(var as, c: TSVector; var co: integer);
var
  rin, rap: PREC;
  k: integer;
begin
  co:= 0;
  rin:= Inf;
  for k:= 1 to NumCol do begin
    if as.At(k)^ < -Zero then begin
      rap:= c.At(k)^ / -as.At(k)^;
      if (rap < rin) then begin
        rin:= rap;
        co:= k;
      end;
    end;
  end;
  WaitReturn;
end;

end.
