(* Adattamento di una variabile statistica a valori campionari *)
unit HpStat;

{$I switches.inc}

(*
Consente la stima dei parametri di scala e di locazione per alcune var. stat.,
alcuni controlli di adeguamento (goodnes of fit, empirici e non) della var. stat.
Il calcolo dei parametri avviene con metodo "best line fitting" modificato x
accettare con dati strutturati in coppie (X, frequenza).
Note:
- con L = LogNormale, Paretro, Weibull, Frechet, del valori X[] si calcolano i ln(X[])
- Nel grafico sono riportati gli intervalli di confidenza al 5% del test di
  Kolomoroff relativi alla stima della funzioe di ripartizioe in corrispondenza
  ai NumClassi valori dell a variabile X[], uniti assieme formano funzione
  max/min.
  E' inoltre riportata la funzione di ripartizione L[]. Per accertare l'ipotesi
  di adeguamento della variabile scelta, la funzione L[] deve intersecare tutti
  gli intervalli della figura. Se cio' non accade non e' probabile al 5% che il
  campione X[] sia effettivamente tratto dalla variabile statistica ipotizzata.
- Nel secondo grafico riporta i valori X[], F[] in scala di probablita' della
  variabile statistica scelta, per un accostamento perfetto i punti devono
  disporsi lungo la retta.
*)

{$DEFINE STAT}
{$I switches.inc}

interface

uses DataMngr;

{$IFDEF STAT}
  procedure HpStatMain(var Spread: TSpread);
{$ELSE}
  procedure HpStatMain;
{$ENDIF}

implementation

uses MathTool, MathStat, DistCObj, HpGraf, Graph, Crt;

type
  Array1 = array[1..100] of PREC;
  Array2 = array[1..100] of TInt;

var
  X,  (* X[] valori campionari rilevati *)
  T,  (* Qauntita' var. stat. calcolata in corrispondenza alle frequenze campionarie *)
  Wa, (* Pesi x il calcolo dei parametri della retta di regressione *)
  La  (* Funz. di ripartizione della var. stat. calcolata in corrispondenza di X[] con parametri stimati dal campione *)
  : Array1;
  F,  (* Frequenze assolute corrispondeti ai valori campionari X[] *)
  Ma  (* Frequenze assolute cumulate *)
  : Array2;
  NumRil: TInt;  (* numerosita' campionaria *)
  NumCla: TInt; (* Numero di classi *)
  L: TInt; (* var. stat. scelta *)

  ch: char;
  NStr  : string;
  PStr  : string;
  P2Str : char;
  LStr  : char;

function DistName(i: TInt): string;
begin
  case i of
     1: DistName:= 'Gumbel Massimi';
     2: DistName:= 'Logistica';
     3: DistName:= 'Esponenziale';
     4: DistName:= 'Normale';
     5: DistName:= 'LogNormale';
     6: DistName:= 'Cauchy';
     7: DistName:= 'Gumbel Minimi';
     8: DistName:= 'Weibull';
     9: DistName:= 'Pareto';
    10: DistName:= 'Frechät';
    else DistName:= 'Errore input';
  end;
end;

procedure NormXVal(P, M, S: PREC; var X: PREC);
var
  T2, T, D: PREC;
begin
  if P < 0 then begin Writeln('PROB. NEGATIVA'); exit; end;
  if P = 0 then begin X:= -(1000*S)+M; exit; end; (* -infinito *)
  if P > 1 then begin Writeln('PROB. > 1'); exit; end;
  if P = 1 then begin X:= (1000*S)+M; exit; end; (* infinito *)
  D:= P;
  if D > 0.5 then D:= 1 - D;
  T2:= ln(1/(sqr(D)));
  T:= sqrt(T2);
  X:= T - (2.515517 + 0.802853*T + 0.010328*T2)/(1+1.432788*T+0.189269*T2+0.001308*T*T2);
  if P <= 0.5 then X:= -(X * S) + M else X:= X * S + M;
end;

procedure CalcXTeor(Z: PREC; var F0: PREC; L: TInt);
(* Calcola i valori "tipo" o quantili tratti dalla variabile statistica scelta *)
begin
  case L of
    1: F0:= -ln(-ln(z));
    2: F0:= -ln((1-z)/z);
    3: F0:= -ln(1-z);
    4,5: NormXVal(Z, 0, 1, F0);
    6: F0:= tan(PI * Z - PI * 0.5);
    7: F0:= ln(-ln(1-Z));
    8: F0:= ln(-ln(Z));
  end;
end;

procedure FNA(N, K0, L: TInt; var W, T: Array1; var M: Array2);
(* Calcola il vettore W[] relativo ai pesi da attribuire all'interpolazione
per la stima dei parametri per campioni censurati *)
var
  i: TInt;
  W0, W1, W2, R9: PREC;
begin
  for i:= 1 to K0 do begin
    case l of
      1: begin
        W1:= (N+2)*M[i]*sqr(ln(M[i])-ln(N+1));
        W2:= (N+1-M[i])*(N+1);
        R9:= W1/W2;
      end;
      2: begin
        W1:= (N+2)*M[i]*(N+1-M[i]);
        W2:= (N+1)*(N+1)*(N+1);
        R9:= W1/W2;
      end;
      3: begin
        W1:= (N+2)*(N+1-M[i]);
        W2:= (N+1)*M[i];
        R9:= W1/W2;
      end;
      4,5: begin
        W1:= (N+2)*(N+1)*exp(-sqr(T[i]));
        W2:= M[i]*(N+1-M[i])*PI*2;
        R9:= W1/W2;
      end;
      6: begin
        W0:= (N+2)*(N+1)*sqr(sqr(cos(M[i]*PI / (N+1)- PI*0.5)));
        W1:= M[i]*(N+1-M[i]);
        R9:= W0/W1;
        R9:= R9/sqr(PI);
      end;
      7: begin
        W1:= (N+2)*(N+1-M[i]) * sqr(ln(N+1)-ln(N+1-M[i]));
        W2:= M[i]*(N+1);
        R9:= W1/W2;
      end;
      8: begin
        W1:= (N+2)*M[i]*sqr(ln(M[i])-ln(N+1));
        W2:= (N+1-M[i])*(N+1);
        R9:= W1/W2;
      end;
    end;
    W[i]:= R9;
  end;
end;

procedure Freq2Prob(K0: TInt; N: TInt);
var i: TInt;
begin
  for i:= 1 to K0 do begin
    Wa[i]:= F[i]/N;
  end;
end;

procedure Regressione(N, K0: TInt; var Y, W, T: Array1; var A1, B1, P5, P6: PREC);
(* Calcola i parametri A1, B1 della rette di regressione con il metodo dei
minimi quadrati *)
var
  P1, P2, P3, P4: PREC;
  i: TInt;
  D: PREC;
begin
  P1:= 0;
  P2:= 0;
  P3:= 0;
  P4:= 0;
  P5:= 0;
  P6:= 0;
  for i:= 1 to K0 do begin
    P1:= P1 + X[i] * X[i] * W[i];
    P2:= P2 + X[i] * W[i];
    P3:= P3 + T[i] * X[i] * W[i];
    P5:= P5 + W[i];
    P6:= P6 + W[i] * T[i];
  end;
  P4:= P2;
  D:= P1*P5 - P4*P2;
  A1:= (P3*P5 - P6*P2) / D;
  B1:= (P1*P6 - P4*P3) / D;
end;

procedure CalcR(N, K0: TInt; var F0: PREC; var X, W, T: Array1);
(* Calcola il coefficiente di correlazione lineare *)
var
  X1, X2, V, Y1, Y2, W0: PREC;
  i: TInt;
begin
  X1:= 0;
  X2:= 0;
   V:= 0;
  Y1:= 0;
  Y2:= 0;
  W0:= 0;
  for i:= 1 to K0 do begin
    X1:= X1 + X[i] * Wa[i];
    X2:= X2 + sqr(X[i]) * Wa[i];
     V:= V + X[i] * T[i] * Wa[i];
    Y1:= Y1 + T[i] * W[i];
    Y2:= Y2 + sqr(T[i]) * W[i];
    W0:= W0 + W[i];
  end;
  X1:= X1 / W0;
  X2:= X2 / W0;
  Y1:= Y1 / W0;
  Y2:= Y2 / W0;
   V:= V  / W0;
  X2:= X2 - sqr(X1);
  Y2:= Y2 - sqr(Y1);
  F0:= (V - X1*Y1) / SQRT(X2*Y2);
end;

procedure NDTR(X, M, S: PREC; var P: PREC);
var A, T, D: PREC;
begin
  A:= ABS((X-M)/S);
  T:= 1 / (1 + 0.2316419 * A);
  D:= 0.3989423 * EXP(-(sqr(X-M)/sqr(S)*0.5));
  P:= 1 - D * T *((((1.330274 * T  - 1.821256)*T + 1.781478) * T - 0.3565638) * T + 0.3193815);
  if X < M then P:= 1-P;
end;

procedure CalcFCum(W, A1, B1: PREC; L: TInt; var F0: PREC);
(* Calcola la funzione cumulativa (ripartizione) della variabile statistica
scelta *)
var
  W1, S, M: PREC;
begin
  case L of
    1: begin
      W1:= A1 * W + B1;
      F0:= exp(-exp(-W1))
    end;
    2: begin
      W1:= A1 * W + B1;
      F0:= 1 / (1+exp(-W1));
    end;
    3: begin
      W1:= A1 * W + B1;
      if W1 < 0 then begin
        F0:= 0;
      end
      else begin
        F0:= 1 - exp(-W1);
      end;
    end;
    4, 5: begin
      S:= 1 / A1;
      M:= -(S*B1);
      NDTR(W, M, S, F0);
    end;
    6: F0:= (ArcTan(A1*W+B1)+PI*0.5)/PI;
    7: F0:= 1 - exp(-exp(A1*W+B1));
    8: F0:= exp(-exp(A1*W+B1));
  end;
end;

function FNL(j: TInt; K0: TInt; N: TInt): PREC;
begin
  FNL:= 0;
  if j <= K0 then FNL:= N * La[j];
  if j = NumCla then FNL:= N;
end;

procedure ImmisDati(var NumCla: TInt);
var y, i: TInt;
begin
  repeat
    NumCla:= 2;
    InputInt('Numero delle classi: ', NumCla,2,100);
    if (NumCla < 2) or (NumCla > 100) then begin
      writeln('Numero di Classi non valido!');
      writeln;
    end
    else break;
  until false;
  for i:= 1 to NumCla do begin
    y:= WhereY;
    X[i]:= 0; F[i]:= 1;
    write('Centro classe ', i:3,' X= '); InputPrec('',X[i],-inf,inf);
    GotoXY(40, y); InputInt('Freq= ',F[i],0,maxint);
  end;
end;

procedure SortDati;
  procedure QuickSort2(sinistra,destra: integer);
  var
    a, b : integer;
    ele1x, ele2x: PREC;
    ele1f, ele2f: TInt;
  begin
    a:= sinistra;
    b:= destra;
    ele1x:= X[(sinistra+destra) shr 1];
    ele1f:= F[(sinistra+destra) shr 1];
    repeat
      while X[a] < ele1x do inc(a);
      while ele1x < X[b] do dec(b);
      if a <= b then begin
        ele2x:= X[a];
        ele2f:= F[a];
        X[a]:= X[b];
        F[a]:= F[b];
        X[b]:= ele2x;
        F[b]:= ele2f;
        inc(a);
        dec(b);
      end;
    until a > b;
    if sinistra < b then QuickSort2(sinistra, b);
    if a < destra then QuickSort2(a, destra);
  end;
begin
  QuickSort2(1, NumCla);
end;

procedure PackDati(var NumCla: TInt);
var
  I, j, k, n: TInt;
begin
  if NumCla < 2 then exit;
  n:= NumCla;
  i:= 1;
  while (i < NumCla) do begin
    (* Compatta le frequenza *)
    if X[i]= X[succ(i)] then begin
      j:= succ(i);
      while (j< n) and (X[j] = X[succ(j)]) do inc(j);
      (* somma frequenze dati ripetuti *)
      for k:= succ(i) to j do begin
        F[i]:= F[i] + F[k];
        dec(NumCla);
      end;
      (* elimina dati ripetuti *)
      for k:= succ(j) to n do begin
        X[i+k-j]:= X[k];
        F[i+k-j]:= F[k];
      end;
      n:= NumCla;
    end;
    inc(i);
  end;
end;

procedure HpStatMain;
var
  V0, X1, X2, F0: PREC;
  A1, B1, P5, P6: PREC;
  A0, W0, Z1, Z, V : PREC;
  X8, X9 : PREC;
  K0, L0: TInt;
  alpha, ValChi: PREC;
  Chi: TChiQuad;
  i: TInt;
  ch: char;
begin
  ClrScr;
  L0:= 0;
  V0:= 1.63; (* Valore al 1% del test di Kologorov *)
  V0:= 1.36; (* Valore al 5% del test di Kologorov *)
  Writeln('Adattamento di una variabile statistica a valori campionari');
  writeln;
{$IFDEF STAT}
  repeat
    GetChar('Immissione diretta o uso dati Memorizzati (I/M)? ',ch);
  until ch in ['I','M'];
  writeln;
  if ch = 'I' then begin
    ImmisDati(NumCla);
  end
  else begin
     repeat
       Spread.GetSerie(ch);
       if ch = #0 then exit;
       if Spread.Cols[ch]^.Count > 100 then begin
         write('Spiacente la serie deve contenere al massimo 100 rilevazioni!');
         WaitReturn;
       end
       else if Spread.Cols[ch]^.Count < 1 then begin
         write('Spiacente, ma la serie deve contenere almeno 2 classi');
         WaitReturn;
       end
       else break;
     until false;
     NumCla:= Spread.Cols[ch]^.Count;
     for i:= 1 to NumCla do begin
       X[i]:= Spread.Cols[ch]^.At(i)^;
       F[i]:= 1;
     end;
  end;
{$ELSE}
  ImmisDati(NumCla);
{$ENDIF}
  F0:= 0;
  SortDati;
  PackDati(NumCla);
  for I:= 1 to NumCla do begin
    F0:= F0 + F[i];
    Ma[i]:= round(F0);
  end;
  NumRil:= Ma[NumCla];
  if NumRil < 2 then begin
    writeln;
    writeln('Numero delle rilevazioni insufficienete!!!!');
    WaitReturn;
    exit;
  end;
  Writeln('NumerositÖ campionaria:  ', NumRil);
  for i:= 1 to 10 do begin
    write(DistName(i)); GotoXY(25, WhereY); writeln(i:2);
  end;
  l:= 1;
  InputInt('Quale? ', L,1,10);
  GetChar('Valori Censurati (S/N)? ', ch); ch:= UpCase(ch);
  if ch <> 'S' then K0:= NumCla else K0:= NumCla - 1;
  if L IN [5, 8, 9, 10] then begin
    for i:= 1 to K0 do begin
      if X[i]> 0 then X[i]:= ln(X[i])
      else begin
        writeln('Bad value #',i:4,' ',X[i]:10:3,' 0 assumed');
        X[i]:= -1000000000.0; (* ln(0) = -Ï *)
      end;
    end;
  end;
  case L of
    5: L0:= 4;
    8: L0:= 7;
    9: L0:= 3;
   10: L0:= 8;
  end;
  if L0 > 0 then L:= L0;
  for i:= 1 to K0 do begin
    Wa[i]:= 0;
    X1:= Ma[i]/(NumRil+1);
    CalcXTeor(X1, F0, L);
    T[i]:= F0;
    writeln('X= ', X[i]:8:3, ' VC TIPO= ', T[i]:8:3);
    if (i mod 20) = 0 then WaitReturn;
  end;
  GetChar('Pesi Wi=Fi (S/N)? ', P2Str);
  if upcase(P2Str) <> 'S' then
    FNA(NumRil, K0, L, Wa, T, Ma)
  else
    Freq2Prob(k0, NumRil);
  Regressione(NumRil, K0, X, Wa, T, A1, B1, P5, P6);
  Writeln('A1 = ', A1:7:3, ' B1 = ', B1:7:3);
  A0:= 0;
  for i:= 1 to K0 do begin
    A0:= A0+ sqr(A1*X[i] + B1 - T[i]) * Wa[i];
  end;
  A0:= A0*(NumRil+1)/(Ma[K0]-2);
  Writeln('Var.res = ', A0:15:10);
  CalcR(NumRil, K0, F0, X, Wa, T);
  Writeln('Corr.Lin= ', abs(F0):15:10);
  writeln;
  writeln(' --------------------');
  writeln;
  writeln('Valori della f. di ripartizione');
  writeln;
  for i:= 1 to K0 do begin
    W0:= X[i];
    CalcFCum(W0, A1, B1, L, Z1);
    La[i]:= Z1;
    writeln('Pr[X<=',X[i]:7:2,'] = ',Z1:7:4);
    if (i mod 20) = 0 then WaitReturn;
  end;
  writeln;
  writeln('  *** FREQUENZE *** ');
  writeln('OSSERVATE   TEORICHE');
  X1:= 0;
  X2:= FNL(1, K0, NumRil);
  writeln(F[1]:5, '     ', X2:8:3);
  if (X2 > 0) and (NumCla<NumRil) then X1:= X1 + sqr(F[1]-X2)/X2;
  for i:= 2 to NumCla do begin
    X2:= FNL(i, K0, NumRil) - FNL(i-1, K0, NumRil);
    writeln(F[i]:5, '     ', X2:8:3);
    if (X2 > 0) and (NumCla < NumRil) then X1:= X1 + sqr(F[i]-X2)/X2;
    if (i mod 20) = 0 then WaitReturn;
  end;
  if NumCla < NumRil  then begin
    writeln('ChiQuad.= ',X1:15:7);
    writeln(' valore del rischio (<= 0 x finire) ');
    Chi.ChiQuad(K0-1);
    repeat
      InputPrec('‡ = ',alpha,-inf,1);
      if (alpha >0) and (alpha<1) then begin
        alpha:= 1- alpha;
        ValChi:= Chi.XVal(alpha);
        GotoXY(1, WhereY-1);
        write('‡ = ',(1-alpha):6:4,' X = ',ValChi:15:7,' ');
        if X1 <= ValChi then writeln('') else writeln('');
      end
      else break;
    until false;
    Chi.Done;
  end;
  X1:= -(B1/A1);
  X2:= 1/A1;
  writeln('LOCAZ=',X1:7:2,'  SCALA=',X2:7:2);
  (* Quantili e periodi di ritorno *)
  Writeln('Calcolo dei Quantili: 0.5 per la mediana');
  Writeln('Valori 0<X<1: <= 0 per finire');
  if L IN [5, 8, 9, 10] then GetChar('Opzione logaritmica (S/N)?', LStr)
  else LStr := 'N';
  LStr:= Upcase(LStr);
  Writeln(' quartile    prob.  p.ritorno');
  z:= 0;
  repeat
    InputPrec('',Z,-inf,inf);
    if (Z<=0) or (Z>=1) then break;
    GotoXY(1, WHEREY-1);
    CalcXTeor(Z, F0, L);
    V:= X2 * F0 + X1;
    if LStr = 'S' then V:= exp(V);
    writeln(' ',V:7:2,'    ',Z:6:3,'   ',1/(1-Z):8:2);
  until false;

  (* GRAFICO *)
  GInit;
  GClear;
  SCALE(X[1], X[K0], 0, 1);
  XASIS(0, (X[K0]-X[1])*0.1);
  YASIS(0, 0.1);
  for i:= 1 to K0 do begin
    Plot(X[i],Ma[i]/(NumRil+1));
  end;
  Move(X[1],La[1]);
  for i:= 1 to K0 do begin
    Draw(X[i], La[i]);
  end;
  for i:= 1 to K0 do begin
    Move(X[i], MAX(0, Ma[i]/NumRil-V0/sqrt(NumRil)));
    Draw(X[i], MIN(1, V0/sqrt(NumRil)+(Ma[i]-1)/NumRil));
  end;
  Move(X[1],MIN(1,(Ma[1]-1)/NumRil+V0/sqrt(NumRil)));
  for i:= 1 to K0 do begin
    Draw(X[i],MIN(1,(Ma[i]-1)/NumRil+V0/sqrt(NumRil)));
  end;
  Move(X[1],MAX(0, (Ma[1])/NumRil-V0/sqrt(NumRil)));
  for i:= 1 to K0 do begin
    Draw(X[i],MAX(0, (Ma[i])/NumRil-V0/sqrt(NumRil)));
  end;
  readkey;
  GClear;
  X8:= MIN(T[1], T[K0]);
  X9:= MAX(T[1], T[K0]);
  Scale(X[1],X[K0], X8, X9);
  XAsis(X8, (X[K0]-X[1]) * 0.1);
  YAsis(0, 0.1);
  for i:= 1 to K0 do begin
    Plot(X[i],T[i]);
  end;
  Move(X[1], T[1]);
  for i:= 1 to k0 do begin
    Draw(X[i], A1*X[i] + B1);
  end;
  for i:= 1 to K0 do begin
    Move(X[1],T[i]);
    MoveTo(GetX, GetY);
    LineTo(GetX+sx, GetY);
    Draw((X[K0]-X[1]) * 0.01,0);
  end;
  readkey;
  GDone;
end;

end.
