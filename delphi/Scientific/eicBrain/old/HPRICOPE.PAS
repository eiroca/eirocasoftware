unit HpRicOpe;

{$I switches.inc}

interface

procedure HpRicOpeMain;

implementation

uses MathTool, Crt;

type

  TArray = array[1..10] of PREC;
  TArray2 = array[1..11] of PREC;
  TMatrix = array[1..10,1..10] of PREC;
  TMatrix2 = array[1..10,1..2] of PREC;
  TMatrix3 = array[1..11,1..10] of PREC;

  TFx = function(m: integer; x:TArray):PREC;
  PFx = ^TFx;

function funz(m: integer; var x: TArray): PREC;
var tmp: PREC;
begin
  tmp:= 100*sqr(X[2]-sqr(X[1]))+sqr(1-X[1]);
  X[m+1]:= tmp;
  funz:= tmp;
end;


(*
 Procedura generica:
 1) T0[] vettore iniziale soluzione appartenente a dominio f() da minimizzare
 2) T2[] vettore casuale estratto da normale M-variata, con media = 0 e matrice covarianze V[,]
 3) si calcola T1[]=T0[]+T2[]
 4) se T1[] appartiene dominio f() e se f(T1[]) < f(T0[]) si pone T0[] = T1[]
 5) si ritorna al punto 2) a meno che non ci sia convergenza o si siano effettuate troppe iterazioni

 E' stato dimostrato che converge

 modifiche utilizzate

 si altera la matrice delle covarianze V[,] per ottenere convergenza piu'
 rapida al minimo cercato.
 1) si sceglie un punto iniziale T0[1..M], e si definiscono gli intervalli
    di variazione delle M variabili nella matrice V1[,1..2],  V1[,1]= min,
    V1[,2] = max. Cosigliato che T0[] -> (V[,1]+V[,2])/2
 2) si genera un vettore T[] a componenti indipendenti tratto da una V.C.
    normale con varinze unitare e covarianze nulle ä=matrice identita'
 3) dal vettore T[] si genera il vettore T2[] tratto da una variabile normale
    M-variata, con matrice di varcov V[,] d con vettore medio nullo.
    Inizialemnte la matrice di varcov V[,] e' di tipo diagonale, con
    elementi V[I,I] = 0.5*(V1[I,2]-V1[I,1])/sqr(12) I=1..M
 4) si definisce il vettore T1[] = T0[]+T2[]
    Se le componenti di T1[] sono interni a intervalli di definizione V1[,]
    si calcola f(T1[]) e se risulta < di f(T0[]) si pone T0[] =T1[]
 5) si costruisce la matrice P[,] i cui elementi riga sono le coordinate
    risultanti dai minimi trovati con N1 replicazioni (N1 dimensione minimi).
    Si memorizza f(T1[]) un P[,M+1]
 6) ogni N2 iterazioni, se cioe' e' definita l'N2-esima riga di P[,] si
    aggiorna la matrice di varcov V[,] relativa alla distribuzione delle
    coordinate di minimo (di dimensione N1) memorizzate in P[,]
 Se la la varianza dei valori della funzione, memorizzati in P[,M+1], risulta
 minore della tolleranza E1, si arresta il procedimento, altrimenti si
 replica al massimo per R volte dal punto 2)

 Note
 T1[] in ogni tentativo, risulta estratto da una variabile normale M-variata,
 con vettore medio centrato sul punto di minimo corrente T0[] e matrice di
 varcov V[,]
 La matrice V[,] e' calcolata in base a N2 punti memorizzati in P[,],
 relativi alle coordinate di minimo risultanti, ognuno, da N1 replicazioni.
 Per ottenere il vettore T[], tratto da una distribiuzione normale, a
 componenti indipendenti, con vettore medio nullo e matrice di varcov uguale
 alla matrice identita', si e' preferito, piuttosto che invertire la funzione
 di ripartizione normale standardizzata, generare due numeri casuali (X,Y)
 tra 0 e 1 e porre T[j]=sqr(-2*ln(X))*cos(2*PI*Y) j=1..M
 Per ottenere il vettore T2[], trattto da una normale con covarianza V[,] e
 medie nulle, si genera una matrice C[,] per C`[,] (` trasposto) sia pari a V[,]
 Il procedimento di triangolarizzazione si arresta, se la matrivce V[,] non e'
 triangolarizzabile. Cio' accade se si dispongolo le coordinate di minimo si
 allineano o se si dispongono su un piano. Il vettore cercato T2[] e'
 determinato dal prodotto di C[,] e T[]
 N1 >= 2*M, N2 >= 2*N1 sembrano offrire buone garanzie per convergenza al
 punto sperato.
*)

procedure Mul(m: integer; var C: TMatrix; var T, T2: TArray);
(* Calcola T2[] := C[,] * T[] *)
var i, j: integer;
begin
  for i:= 1 to M do begin
    T2[i]:= 0;
    for j:= 1 to I do begin
      T2[i]:= T2[i] + C[i, j] * T[j];
    end;
  end;
end;

procedure Tri(m: integer; V: TMatrix; C: TMatrix);
var
  i, j, k: integer;
  s0, s1, v1: PREC;
begin
  for j:= 1 to m do begin
    for i:= j to m do begin
      s0:= 0;
      s1:= 0;
      for k:= 1 to pred(j) do begin
        S1:= S1 + C[I, K] * C[J,K];
        S0:= S0 + sqr(C[J, K]);
      end;
      C[i, j]:= V[i, j] - S1;
      V1:= V[j, j] - S1;
      if V1 > 0 then V1:= sqr(V1)
      else begin
        V[M+1, M+1]:= -1;
        exit;
      end;
      C[i, j]:= C[i, j] / V1;
    end;
  end;
  for i:= 1 to M do begin
    for j:= 1 to M do begin
      write(V[i, j]:15:5,' ');
    end;
    writeln;
  end;
  writeln;
  writeln('Triangolare');
  for i:= 1 to M do begin
    for j:= 1 to I do begin
      Writeln(C[i, j]:15:5,' ');
    end;
    writeln;
  end;
  writeln;
end;

procedure VarCov(N, M: integer; var X, V: TMatrix; var S: TArray);
(*
  X[,] matrice n x m dei dati
  N numero dei campioni
  V[,] matrice di varianzze e covarianze
  S[] vettore medie
*)
var i, j, k: integer;
begin
  for i:= 1 to m do begin
    S[i]:= 0;
    for j:= 1 to m do begin
      V[i,j]:= 0;
    end;
  end;
  for k:= 1 to N do begin
    for i:= 1 to M do begin
      S[i]:= S[i] + X[k,i];
      for j:= 1 to M do begin
        V[i, j]:= V[i,j]+ sqr(X[k, i]);
      end;
    end;
  end;
  for i:= 1 to M do begin
    for j:= i to M do begin
      V[i, j]:= (V[i, j] - S[i] * S[j] / N)/(N-1);
      V[j, i]:= V[i, j];
    end;
  end;
  writeln('MEDIE');
  for i:= 1 to m do begin
    S[i]:= S[i] / N;
    Write(S[i]:9:4,' ');
  end;
  writeln;
end;


procedure Simul(fz: PFx; R, M, N1, N2: integer; var V, C, P: TMatrix; var T, T0, T1, S: TArray; V1: TMatrix2; E1: PREC);
(*
  M = numero di variabili
  R = replicazioni della procedura
  N1 = dimensione dei mimimi da memorizzare in P
  N2 = numero di punti con cui calcolare i parametri, medie, varcov
  V1[,] = intervalli di ricerca, dominio della funzione
  P[,] = matrice contenente i vettori di minimo
  T0[] = punto iniziale aggiornato con il minimo in ogni iterazione
  T2[] = vettore estratto da una normale con assegnata matrice di varcov e medie nulle
  T1[] = vettore somma: e' tratto da una normale con medie nelle coordinate di minimo corrente e varcov V
  V[,] = matrice di varcov, che si aggiorna ogni N2 * N1 iterazioni
  E1 = tolleranza sulla variante di N2 valori della funzione
*)
var
  i0, i, j, k: integer;
  t4, x, y, f: PREC;
  T2: TArray;
begin
  V[M+1, M+1]:= M;
  for i:= 1 to M do begin
    for j:= 1 to M do begin
      if i<> j then C[i, j] := 0 else C[i,j]:= 0.5* (V[i,2] - V1[I,1]) / sqr(12);
    end;
    S[i]:= T0[I];
  end;
  i0:= 0;
  for i:= 1 to R do begin
    T4:= INF;
    I0:= I0 +1;
    for k:= 1 to N1 do begin
    (* DIM MINIMI *)
      for j:= 1 to M do begin
        X:= random;
        Y:= random;
        T[j]:= sqr(-(2*ln(x)))*cos(2*PI*y)
      end;
      Mul(M, C, T, T2);
      for j:= 1 to M do begin
        T1[j]:= T0[j]+T2[j];
      end;
      for j:= 1 to M do begin
        if (T1[j] > V1[J, 2]) then T1[j]:= V1[J, 2]
        else if T1[j] < V1[j,1] then T1[j]:= V1[j, 1];
      end;
      F:= funz(M, T1);
      if t1[m+1] <= t4 then begin
        t4:= f;
        for j:= 1 to m+1 do begin
          P[i0,j]:= T1[j];
        end;
        if t1[m+1] <= t0[m+1] then begin
          for j:= 1 to m+1 do begin
            T0[j]:= T1[j];
          end;
        end;
      end;
    end;
    if i0 > n2 then begin
      VarCov(n2, m+1, P, V, S);
      Tri(m, V, C);
      i0:= 0;
    end;
    if (V[M+1, M+1] < E1) then begin
      writeln('Repl=',i);
      i:= r;
    end;
  end;
end;

procedure SimulMain;
var
  V, C, P: TMatrix;
  T, T0, T1, S: TArray;
  V1: TMatrix2;
  f, e1: PREC;
  r, n1, n2,i, m: integer;
begin
  ClrScr;
  write('# var        = '); readln(m);
  write('replicazioni = '); readln(r);
  write('dim. minimi  = '); readln(n1);
  write('dim. medie   = '); readln(n2);
  writeln;
  write('tolleranza   = '); readln(e1);
  writeln('valori iniziali e variaz.var');
  for i:= 1 to m do begin
    writeln('X0    x1-x2', i,'? ');
    readln (T0[i], V1[i,1], V1[i,2]);
  end;
  F:= funz(M, T0);
  Simul(@funz, R, M, N1, N2, V, C, P, T, T0, T1, S, V1, E1);
  for i:= 1 to m+1 do begin
    writeln('Var ',i,' ',T0[i]:15:5);
  end;
end;

(*
  Algoritmo del simplesso per funzioni non lineari.

Non richiede il calcolo delle derivate parziali della funzione da minimizzare.
Inoltre , con la struttura con cui e' implementato, oltre ad assicurare la
convergenza offre buone probabilita' di uscire da situazioni di stallo in
prossimita' di minimi relativi.
Per una agevole comprensione, senza tuttavia perdere in generalita', lo si si
descrive per funzioni continue in due variabili del tip z = f(x, y).
Il primo passo dell'algoritmo consiste nello scegliere tre punti, uno in piu'
rispetto al numero delle variabili, dove e' definita la funzione.
Tale insieme di punti, o vettori, e' detto "simplesso", ed e' da cio' che
l'algoritmo prende il nome. Questa terna di punti e' impostata come punto
centrale ed espansione.
Il calcolo delle due variabili avviene lungo le direz<ioni degli assi
coordinati e, per costruzione, non risultano allineati.
Il metodo si propone poi, ad ogni iterazione, di scartare tra questi punti
in cui il valore della f() e' massimo, per sostituirlo con un nuovo punto a
cui e' associato un valore della funzione piu' piccolo di almeno uno dei due
rimanenti.
Con questa nuova terna si ripete ciclicamente l'algoritmo, fino a che non
risultano soddisfatti alcuni criteri di convergenza. La ricerca del nuovo
punto viene eseguita lungo la direzione individuata dalla retta che passa per
il punto in cui la f() e' massima, per il simmetrico di questo, rispetto al
vettore medio (baricentro) del segmento congiungente gli altri due.
Questa ricerca non sempre conduce ad individuare un punto che risponde ai
requisiti richiesti. Se il nuovo punto non e' adatto a sostituire quello di
massimo costo, si costruisce una nuova terna ottenuta dimezzando le distanze
di tutti i punti dal punto di minimo corrente.
Il cirterio di convergenza, attraverso il quale di passa ogni 10 iterazioni,
calcola la distanza media tra tutti i punti e il punto associato al minimo
della funzione. Valuta inoltrela differenza fra le medie dei valori della
f() nelle ultime due terne controllate. Se per due volte consecutive la
distanza media risulta minore a un prefissato valore, e la differenza in
valore assoluto nell medie risulta anch'essa al di sotto di una soglia
prefissata, si esce con successo falla procedura di minimizzazione.
Prima di effettuare questa verifica di controlla se il punto di minimo attuale
e' uguale al punto di minimo precedente, nel qual caso si reinizializza
l'algoritmo con una nuova terna centrata in iuno dei punti precedenti ed
espanzione dimezzata e di segno opposto
*)

procedure Order(var P: TMatrix3; N: integer; var F1: TArray2);
var
  i, i1, l, k, j, m: integer;
  T: PREC;
label l40, l70;
begin
  m:= n;
l40:
  m:= m div 2;
  if m = 0 then exit;
  k:= n-m;
  j:= 1;
l70:
  i:= j;
  l:= i+m;
  while (F1[i] > F1[l]) do begin
    T:= F1[i];
    F1[i]:= F1[l];
    F1[l]:= T;
    for i1:= 1 to N-1 do begin
      T:= P[i, i1];
      P[i, i1]:= P[l, i1];
      P[l, i1]:= T;
    end;
    i:= i - m;
    if i < 1 then break;
  end;
  j:= j+1;
  if j > k then goto l40
  else goto l70;
end;

procedure Sked(fz: PFx; i: integer; var R: TArray; var V: PREC; N1: integer; var P: TMatrix3);
var
  T: TArray;
  V1, y: PREC;
  i1, i2: integer;
begin
  y:= random * i + i - 1;
  for i2:= 1 to n1 do begin
    T[i2]:= P[n1+1, i2] * (1-Y) + Y * R[i2];
  end;
  V1:= funz(N1, T);
  if v1 >= v then exit;
  for i1:= 1 to n1 do begin
    R[i1]:= T[i1];
  end;
  V:= V1;
end;

procedure Simplex(fz: PFx; var T: TArray; s: PREC; m: integer; e1, e2: PREC);
(*
 M = numero delle variabili della f()
 T[] = vettore del punto iniziale
 P[] = contiene gli m+1 punti della terna, aggiornati in ogni iterazione
 F1[] = contiene i valori della f() relativi ai vettori di P
 R[] = il punto simmetrico o il punto da inserire in P
 V = il valore della funzione V=f(R)
 S9, S = sono i passi usati per generare eventuali nuove terne
 E1, E2 = rappresentano i valori soglia per la distanza media tra i punti di
          P e per la differenza delle medie
 D1, D2 = contengono i valori attuali delle due grandezze precedenti
*)
var
 P: TMatrix3;
 F1: TArray2;
 R: TArray;
 i, j, k: integer;
 V, s1, s2, s9, d1, d2, d3, af1, f2: PREC;
label l60, l80, l90, l140;
begin
  (* Blocco inizializzazione:
  viene costruita la terna iniziale a partire dal punto T[]. Nel caso si
  torni in questo blocco dal blocco di controllo viene ricostruita una terna
  con nuova espansione e con diverso punto iniziale, a falore della f() in
  T[m+1]. *)
  S9:= s*2;
  D2:= 0;
  aF1:= 0;
  for j:= 1 to m do begin
    P[1, j]:= T[j];
  end;
  goto l80;
l60:
  s:= s * 0.5;
  if abs(s) > d2 then goto l90;
  for i:= 1 to m do begin
    P[1, i]:= P[m, i] - d2;
  end;
l80:
  s:= -(s9 * 0.5);
  s9:= s;
l90:
  for i:= 2 to m+1 do begin
    for j:= 1 to m do begin
      P[i, j]:= P[1, j];
    end;
    P[i, i-1]:= P[i, i-1] + s;
  end;
  for i:= 1 to m+1 do begin
    for j:= 1 to m do begin
      T[j]:= P[i,j];
    end;
    F2:= fz^(m, T);
    F1[i]:= f2;
  end;
  S1:= 0;
  s2:= 0;
  Order(P, m+1, F1);
l140:
  (* Blocco convergenza:
  *)
  for i:= 1 to m do begin
    write(P[1, i],', ');
  end;
  writeln(f1[1]);
  d2:= 0;
  d1:= 0;
  for i:= 1 to m+1 do begin
    d1:= d1 + f1[i];
  end;
  d1:= d1 / (m+1);
  for j:= 2 to m+1 do begin
    d3:= 0;
    for i:= 1 to m do begin
      D3:= d3 + sqr(P[j, i]-P[1,i]);
    end;
    d2:= d2+ sqrt(d3);
  end;
  d2:= d2/m;
  if d2>= e2 then s2:= 0
  else begin
    if (s2 <> 1) or (abs(s1-d1) > e1) then begin
      s2:= 1;
      s1:= s1;
    end
    else begin
      for i:= 1 to m do begin
        T[i]:= P[1,i];
      end;
      exit;
    end;
  end;
  (* Blocco dell'algoritmo
  viene calcolato il punto simmetrico di R[] e l'associato valore v=f(R[]).
  Dal confronto di v con F1[1] e con F1[m+1], rispettivamente minimo e massimo
  della f() doo l'ordinamento, si passa alla ricerca di un punto migliore,
  tramite Sked. Dal confronto di V con F1[M] si determina poi, all'uscita
  della Sked, se sostituire R[] con P[m+1,] o se effettuare una contrazione
  della terna. I punti della terna vengono poi ordinati rispetto ai
  corrispondenti valori della f() e si reitera l'algoritmo.
  Alla decima iterazione viene confrontato F1(1), minimo della terna attuale,
  con F1, minimo di f() nel controllo precedente. Se risultano uguali, si
  continua dal blocco di controllo. *)
  for k:= 1 to 10 do begin
    for i:= 1 to m do begin
      R[i]:= 0;
      for j:= 1 to m do begin
        R[i]:= R[i] + P[j, i];
      end;
      R[i]:= 2 * R[i]/M - P[M+1, i];
    end;
    V:= fz^(M, R);
    if V < F1[1] then Sked(fz, 2, R, V, M, P);
    if V < F1[M] then begin
      for i:= 1 to m do begin
        P[m+1, i]:= R[i];
      end;
      F1[m+1]:= V;
    end
    else begin
      for i:= 2 to m+1 do begin
        for j:= 1 to m do begin
          P[j, j]:= 0.5 * (P[i, j] + P[1, j]);
          T[j]:= P[i, j];
        end;
        F2:= fz^(M, T);
        F1[i]:= F2;
      end;
    end;
    Order(P, m+1, F1);
  end;
  if f1[1]=aF1 then goto l60
  else begin
    af1:= F1[1];
    goto l140;
  end;
end;

procedure SimplMain;
var
  X: TArray;
  m, i: integer;
  e1, e2, s: PREC;
begin
  ClrScr;
  write('# variabili = '); readln(M);
  for i:= 1 to M do begin
    write('Coord ',i:2,' = '); readln(X[i]);
  end;
  write('esp simplesso? '); readln(s);
  write('e1  e1:diff medie e dist punti'); readln(e1, e2);
  Simplex(@funz, X, S, M, E1, E2);
  writeln('Soluzioni');
  for i:= 1 to m+1 do begin
    write('Var',i:2,' = ',X[i]:15:5);
  end;
end;

procedure HpRicOpeMain;
begin
  SimulMain;
  SimplMain;
end;

end.
