{$I switches.inc}
{ UNDEF UNIT}

{$IFDEF UNIT}
unit MenuMath;

interface

uses DataMngr;

procedure MenuMathMisc(var Spread: TSpread);

implementation

uses Crt, Matrix, MatrMath, VectMath, MathTool, MathTls1, MathTls2, MathTls3, MathStat;
{$ELSE}

uses Crt, Matrix, MatrMath, VectMath, MathTool, MathTls1, MathTls2, MathTls3, MathStat, DataMngr;

{$ENDIF}

procedure Fattoriali;
var
  n, tmp: PREC;
  ch: char;
begin
  ClrScr;
  writeln('Fattoriale');
  writeln;
  n:= 1;
  repeat
    InputPrec('Numero di cui trovare il fattoriale (n) : ',n, 0,inf);
    writeln;
    tmp:= Fattoriale(n);
    if n > 33 then writeln('Valore : exp(', tmp:15:5,')')
    else begin
      if tmp > 10000000 then writeln('Valore : ', tmp)
      else writeln('Valore : ', Fattoriale(n):15:5);
    end;
    writeln;
    write(' RETURN continua con altri valori, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
end;

procedure Dispos;
var
  x, n : integer;
  ch: char;
begin
  ClrScr;
  writeln('Disposizioni (importanza elemento e ordine)');
  n:= 1;
  x:= 1;
  repeat
    writeln;
    InputInt('Numero di elementi       (n) : ',n,1,maxint);
    InputInt('Numero di raggruppamenti (x) : ',x,1,n);
    writeln;
    writeln('Senza Ripetizioni : ', Disposizioni(n, x):15:5);
    writeln('Con   Ripetizioni : ', DisposizioniRip(n, x):15:5);
    writeln;
    write(' RETURN continua con altri valori, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
end;

procedure Combin;
var
  x, n: integer;
  ch: char;
begin
  ClrScr;
  writeln('Combinazioni (importanza solo elemento)');
  writeln;
  n:= 1; x:= 1;
  repeat
    InputInt('Numero di elementi       (n) : ',n,1,maxint);
    InputInt('Numero di raggruppamenti (x) : ',x,1,n);
    writeln;
    writeln('Senza Ripetizioni : ', Combinazioni(n, x):15:5);
    writeln('Con   Ripetizioni : ', CombinazioniRip(n, x):15:5);
    writeln;
    write(' RETURN continua con altri valori, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
end;

procedure NumPermut;
var
  x, n: integer;
  ch: char;
begin
  ClrScr;
  writeln('Permutazioni (disposizioni di n elementi in n classi)');
  writeln;
  n:= 1;
  repeat
    InputInt('Numero di elementi       (n) : ',n,1,maxint);
    writeln;
    writeln('Senza Ripetizioni : ', Disposizioni(n, n):15:5);
    writeln('Con   Ripetizioni : ', DisposizioniRip(n, n):15:5);
    writeln;
    write(' RETURN continua con altri valori, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
end;

procedure MakeLine;
var
  A, B: Point;
  ch: char;
begin
  ClrScr;
  writeln('Retta passante tra due punti');
  repeat
    writeln;
    write('Inserire 1^ punto (x y) = '); readln(A.x, A.y);
    write('Inserire 2^ punto (x y) = '); readln(B.x, B.y);
    writeln;
    writeln('Lunghezza segmento = ', Len(A,B):15:5);
    writeln('Retta lungo x:   ',writeLineX('x', 'y', A, B));
    writeln('Retta lungo y:   ',writeLineY('y', 'x', A, B));
    writeln;
    write(' RETURN continua con altri valori, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
end;

procedure Normalize;
var
  x, mu, si: PREC;
  ch: char;
begin
  ClrScr;
  writeln('Effettua la trasformazione z = (x-æ)/å');
  writeln;
  repeat
    mu:= 0;
    si:= 1;
    InputPrec('æ = ',mu,-inf,inf);
    InputPrec('å = ',si,-inf,inf);
    writeln;
    x:= 0;
    repeat
      InputPrec('x = ',x,-inf,inf);
      writeln('z = ', DynaOut((x-mu)/si));
      writeln;
      write(' RETURN continua con altri valori x, altro esce: ');
      ch:= readkey; if ch = #0 then readkey;
      GotoXY(1, WHEREY); clreol;
    until ch <> #13;
    writeln;
    write(' RETURN continua con altri valori, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
end;

procedure CombinLin;
var
  x, mu, si: PREC;
  ch: char;
begin
  ClrScr;
  writeln('Effettua la trasformazione y = a ù x + b');
  writeln;
  repeat
    si:= 1; mu:= 0;
    InputPrec('a = ',si,-inf,inf);
    InputPrec('b = ',mu,-inf,inf);
    writeln;
    x:= 0;
    repeat
      InputPrec('x = ',x,-inf,inf);
      writeln('y = ', DynaOut(si * x + mu));
      writeln;
      write(' RETURN continua con altri valori x, altro esce: ');
      ch:= readkey; if ch = #0 then readkey;
      GotoXY(1, WHEREY); clreol;
    until ch <> #13;
    writeln;
    write(' RETURN continua con altri valori, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
end;

procedure Sistemi;
var
  tmp,i,j,n: integer;
  aa: TSMatrix;
  bb,xx: TSVector;
  pvt: PIVector;
  Determ: PREC;
begin
  ClrScr;
  writeln('Risuluzione sitemi lineari   A * x = b');
  writeln;
  n:= 2;
  InputInt('Quante variabili? ',n, 1, maxint);
  dec(n);
  Pvt:= nil;
  aa.Init(0,n+1,n+1); bb.Init(0,n+1); xx.Init(0,n+1);
  for i:= 0 to n do begin
    for j:= 0 to n do begin
      aa.At(i,j)^:= 0;
      write('A[',i,',',j,'] = '); InputPrec('', aa.At(i,j)^,-inf,inf);
    end;
  end;
  for i:= 0 to n do begin
    bb.At(i)^:= 0;
    write('b[',i,'] = '); InputPrec('',bb.At(i)^,-inf,inf);
  end;
  writeln;
  tmp:= FactorGAU(aa, pvt, Determ);
  if tmp <> 0 then begin
    writeln('Errore #',tmp);
  end
  else begin
    writeln('Determinante = ',Determ:12:4);
    tmp:= SolveGAU(aa, Pvt, bb, xx);
    if tmp = 0 then begin
      writeln('Soluzione');
      for i:= 0 to n do begin
        writeln('x[',i,'] = ', xx.At(i)^:12:4);
      end;
    end;
  end;
  aa.Done;
  bb.Done;
  xx.Done;
  if pvt <> nil then Dispose(pvt, done);
  WaitReturn;
end;

procedure Determinante;
var
  tmp,i,j,n: integer;
  aa: TSMatrix;
  pvt: PIVector;
  Determ: PREC;
begin
  ClrScr;
  writeln('Calcolo del determinante di una matrice');
  writeln;
  n:= 1;
  InputInt('Quante righe/colonne? ',n,1,maxint);
  dec(n);
  Pvt:= nil;
  aa.Init(0,n+1,n+1);
  for i:= 0 to n do begin
    for j:= 0 to n do begin
      aa.At(i,j)^:= 0;
      write('A[',i,',',j,'] = '); InputPrec('', aa.At(i,j)^,-inf,inf);
    end;
  end;
  writeln;
  tmp:= FactorGAU(aa, pvt, Determ);
  if tmp <> 0 then Determ:= 0;
  writeln('Determinante = ',Determ:12:4);
  aa.Done;
  if pvt <> nil then Dispose(pvt, done);
  WaitReturn;
end;

procedure Inversa;
var
  tmp,i,j,n: integer;
  aa,ai: TSMatrix;
  pvt: PIVector;
  Determ: PREC;
begin
  ClrScr;
  writeln('Calcolo dell''inversa di una matrice');
  writeln;
  n:= 1;
  InputInt('Quante righe/colonne? ',n,1,maxint);
  dec(n);
  Pvt:= nil;
  aa.Init(0,n+1,n+1);
  ai.Init(0,n+1,n+1);
  for i:= 0 to n do begin
    for j:= 0 to n do begin
      aa.At(i,j)^:= 0;
      write('A[',i,',',j,'] = '); InputPrec('',aa.At(i,j)^,-inf,inf);
    end;
  end;
  tmp:= SMatInv(ai, aa);
  if tmp <> 0 then begin
    writeln('Non Invertibile');
  end
  else begin
    ai.Print('',0,0,0,0,0);
  end;
  aa.Done;
  ai.Done;
  WaitReturn;
end;

procedure AnalisiVettori;
var
  tmp: PREC;
  X, Y, AngX,AngY: TSVector;
  LenX, LenY: PREC;
  fine, n, i: integer;
begin
  repeat
    fine:= 0;
    ClrScr;
    writeln('Analisi di due vettori');
    writeln;
    n:= 3;
    InputInt('Quanti elementi? ', n,1, 99);
    X.Init(0,n); Y.Init(0,n);
    AngX.Init(0,n); AngY.Init(0,n);
    for i:= 1 to n do begin
      tmp:= 0;
      write('X[',i:2,'] = '); InputPrec('', tmp, -inf, inf);
      X.At(i-1)^:= tmp;
    end;
    writeln;
    for i:= 1 to n do begin
      tmp:= 0;
      write('Y[',i:2,'] = '); InputPrec('', tmp, -inf, inf);
      Y.At(i-1)^:= tmp;
    end;
    LenX:= SVecProSca(X); SVecNormalize(X);
    LenY:= SVecProSca(Y); SVecNormalize(Y);
    writeln('Lunghezza X = ', DynaOut(LenX));
    writeln('Lunghezza Y = ', DynaOut(LenY));
    writeln;
    if lenX <= Zero then for i:= 0 to n do AngX.At(i)^:= 0
    else for i:= 0 to n-1 do AngX.At(i)^:= ACos(X.At(i)^) * Rad2Deg;
    if lenY <= Zero then for i:= 0 to n-1 do AngY.At(i)^:= 0
    else for i:= 0 to n-1 do AngY.At(i)^:= ACos(Y.At(i)^) * Rad2Deg;
    writeln('Angolo (deg) rispetto   Vettore X    Vettore Y  ');
    for i:= 0 to n-1 do begin
      writeln('Asse ',(i+1):2,'                ',AngX.At(i)^:10:3,'   ',AngY.At(i)^:10:3);
    end;
    writeln;
    if (LenX > Zero) and (LenY > Zero) then begin
      tmp:= Acos(SVekMulXtY(X,Y))*Rad2Deg;
      writeln('Angolo tra i due vattori: ',DynaOut(tmp),' gradi');
    end;
    writeln;
    X.Done; AngX.Done;
    Y.Done; AngY.Done;
    GetSiNo('Vuoi proseguire? ', fine);
  until fine=0;
end;

procedure AreaPoligono;
var
  X, Y: TSVector;
  tmp: PREC;
  n, i: integer;
begin
  ClrScr;
  writeln('Area di un poligono');
  repeat
    writeln;
    n:= 0;
    InputInt('Numero di vertici (0 per finire): ', N, 0, 500);
    if n = 0 then exit;
    X.Init(0,n+1); Y.Init(0,n+1);
    for i:= 1 to n do begin
      writeln('Coordinate del vertice ',i:3);
      InputPrec('X = ', X.At(i)^,-inf, inf);
      InputPrec('Y = ', Y.At(i)^,-inf, inf);
      GotoXY(1, WhereY-3);
    end;
    writeln;
    writeln;
    writeln;
    writeln;
    writeln('Area = ',DynaOut(PolyArea(X, Y)));
    writeln;
    X.Done; Y.Done;
    WaitReturn
  until false;
end;

procedure ScompNumPri;
var
  z: PREC;
  i: longint;
  s: integer;
begin
  z:= 0;
  ClrScr;
  Writeln('Fattori primi di interi');
  Writeln;
  Writeln('Inserire 0 per finire');
  repeat
    Writeln;
    InputPrec('Numero: ', Z, -inf, inf);
    z:= int(z);
    if z = 0 then break;
    Write(sgn(z):6,'^ 1 '); (* il segno e' sempre un fattore *)
    z:= abs(z);
    i:= 2;
    while (z > 1) do begin
      (* CICLO PER VERIFICARE SE GLI INTERI DA 2 A Z SONO FATTORI PRIMI *)
      (* GLI INTERI DA Z/2 A Z NON VERRANNO ULTERIORMENTE FATTORIZZATI *)
      S:= 0;
      while (Z / I) = int(Z / I) do begin
        Z:= Z / I;
        inc(s);
      end;
      if S <> 0 then begin
        Write(I:6, '^', S:2,' '); (* STAMPA FATTORI CON L'ESPONENTE *)
      end;
      inc(i); (* in realta serve il prossimo numero primo *)
      if not odd(i) then inc(i);
    end;
    writeln;
    WaitReturn;
  until false;
end;

procedure CalcMCD;
var
  a, b: TDInt;
begin
  ClrScr;
  writeln('Massimo cumene divisonre');
  writeln;
  writeln('INSERIRE DUE NUMERI (0,0 PER FINIRE)');
  a:= 0; b:= 0;
  repeat
    writeln;
    InputLong('A = ', a, -maxLongint, MaxLongInt);
    if a = 0 then break;
    InputLong('B = ', b, -maxLongint, MaxLongInt);
    if b = 0 then break;
    writeln('M.C.D. = ', MCD(a,b));
  until false;
end;

procedure RunBaseToBase;
var
  j, b1, b2: integer;
  i, o: string;
begin
  b1:= 10; b2:= 10;
  ClrScr;
  Writeln('Trasforma da base a base');
  Writeln;
  Writeln('Vuoto finire');
  repeat
    i:= '';
    Writeln;
    InputStr('Numero = ', i);
    if i = '' then break;
    for j:= 1 to length(i) do i[j]:= UpCase(i[j]);
    InputInt('In base ', b1, 1, 35);
    InputInt('A base ', b2, 1, 35);
    BaseToBase(i,b1, o, b2);
    writeln(o,' (',b2,')');
  until false;
end;

procedure ZeroPoli;
var
  a: TSVector;
  f0, f1, tmp: PREC;
  x: PREC;
  fine, n, i: integer;
begin
  ClrScr;
  writeln('RADICI REALI DI POLINOMI: NEWTON');
  repeat
    n:= 2;
    writeln;
    InputInt('GRADO DELL''EQUAZIONE: ',N,1,99);
    a.Init(0,n+1);
    FOR I:= 0 TO N do begin
      tmp:= 0;
      write('COEFFICIENTE x^(',i:2,')= '); InputPrec('', tmp,-inf,inf);
      A.At(i)^:= tmp;
    end;
    repeat
      writeln;
      x:= 0;
      InputPrec('VALORE SUPPOSTO: ', x, -inf, inf);
      case ZeroPoly(a, x, f0, f1) of
        WarnNone : begin
          writeln('RADICE   = ',DynaOut(X));
          writeln('ERRORE   = ',DynaOut(F0));
          writeln('DERIVATA = ',DynaOut(F1));
        end;
        WarnDerivaNulla: begin
          writeln('DERIVATA = 0 IN X = ',DynaOut(X));
          writeln('ERRORE = ',DynaOut(F0));
        end;
        WarnNonConverge: begin
          writeln('Convergenza non ragiunta. Ultimo valore: ');
          writeln('RADICE   = ',DynaOut(X));
          writeln('ERRORE   = ',DynaOut(F0));
          writeln('DERIVATA = ',DynaOut(F1));
        end
        else begin
          writeln('Internal error');
        end;
      end;
      writeln;
      GetSiNo('Vuoi trovare un altro zero del polinomio? ', fine);
    until fine=0;
    A.Done;
    writeln;
    GetSiNo('Vuoi zeri di un altro polinomio? ', fine);
  until fine=0;
end;

procedure OperVett;
var
  a, b, c: TSVector;
  tmp: PREC;
  fine, n, i: integer;
begin
  ClrScr;
  writeln('OPERAZIONI CON I VETTORI');
  repeat
    n:= 2;
    writeln;
    InputInt('Numero di elementi: ',N,1,99);
    a.Init(1,n); b.Init(1,n); c.Init(1,n);
    FOR I:= 1 TO N do begin
      tmp:= 0;
      write('A[',i:2,']= '); InputPrec('', tmp,-inf,inf);
      A.At(i)^:= tmp;
      C.At(i)^:= tmp;
    end;
    writeln;
    FOR I:= 1 TO N do begin
      tmp:= 0;
      write('B[',i:2,']= '); InputPrec('', tmp,-inf,inf);
      B.At(i)^:= tmp;
    end;
    writeln;
    writeln('Somma dei due vettori');
    SVecAdd(C,B);
    for i:= 1 to n do begin
      writeln(C.At(i)^:9:3,' ');
    end;
    writeln;
    writeln('Prodotto scalare = ',DynaOut(SVekMulXtY(A,B)));
    writeln;
    GetSiNo('Vuoi proseguire? ', fine);
    A.Done; B.Done; C.Done;
  until fine=0;
end;

procedure GiorSett;
var
  fine, nn, a,m,g: integer;
begin
  ClrScr;
  writeln('GIORNO DELLA SETTIMA (Zeller)');
  repeat
    writeln;
    g:= 0; m:= 0; a:= 0;
    InputInt('Giorno (0 x finire): ', g, 0, 31);
    if g = 0 then exit;
    InputInt('Mese   (0 x finire): ', m, 0, 12);
    if m = 0 then exit;
    InputInt('Anno   (0 x finire): ', a, 0, 9999);
    NN:= DayOfWeek(a, m, g);
    writeln;
    writeln('Il giorno e'': ',Giorni[nn]);
    writeln;
    GetSiNo('Vuoi proseguire? ', fine);
  until fine=0;
end;

procedure GiorniTraDate;
var
  fine: integer;
  a1, m1, g1: integer;
  a2, m2, g2: integer;
  d1, d2: longint;
begin
  ClrScr;
  writeln('NUMERO DI GIORNI TRA DUE DATE');
  repeat
    writeln;
    g1:= 0; m1:= 0; a1:= 0;
    writeln('Prima data');
    InputInt('Giorno (0 x finire): ', g1, 0, 31);
    if g1 = 0 then exit;
    InputInt('Mese   (0 x finire): ', m1, 0, 12);
    if m1 = 0 then exit;
    InputInt('Anno   (0 x finire): ', a1, 0, 9999);
    if a1 = 0 then exit;
    g2:= 0; m2:= 0; a2:= 0;
    writeln('Prima data');
    InputInt('Giorno (0 x finire): ', g2, 0, 31);
    if g2 = 0 then exit;
    InputInt('Mese   (0 x finire): ', m2, 0, 12);
    if m2 = 0 then exit;
    InputInt('Anno   (0 x finire): ', a2, 0, 9999);
    if a2 = 0 then exit;
    d1:= days(a1, m1, g1);
    d2:= days(a2, m2, g2);
    writeln('Ci sono ',(d2-d1),' giorni tra le due date');
    writeln;
    GetSiNo('Vuoi proseguire? ', fine);
  until fine=0;
end;

procedure InterpCurv;
var
  fine: integer;
  X, Y: TSVector;
  i, j, n: integer;
  A, T, tmp: PREC;
begin
  ClrScr;
  writeln('INTERPOLAZIONE CURVILINEA');
  repeat
    writeln;
    n:= 0;
    InputInt('NUMERO DI PUNTI NOTI (0= TERMINA): ', n,0,99);
    if n=0 then exit;
    X.Init(1,n); Y.Init(1,n);
    writeln;
    for i:= 1 to n do begin
      tmp:= 0;
      Write('Punto[',i:2,'].X:= '); InputPrec('', tmp, -inf, inf);
      X.At(i)^:= tmp;
      tmp:= 0;
      Write('Punto[',i:2,'].Y:= '); InputPrec('', tmp, -inf, inf);
      Y.At(i)^:= tmp;
    end;
    A:= 0;
    repeat
      writeln;
      InputPrec('INTERPOLAZIONE:  X = ', A, -inf, inf);
      tmp:= 0;
      (* CALCOLA L'ORDINATA CON IL METODO DI INTERPOLAZIONE DI LAGRANGE *)
      FOR J:= 1 TO n do begin
        T:= 1;
        FOR I:= 1 TO n do begin
          IF I <> J THEN T:= T * (A - X.At(I)^) / (X.At(J)^ - X.At(I)^);
        end;
        tmp:= tmp + T * Y.At(J)^;
      end;
      writeln('              :  Y = ', DynaOut(tmp));
      writeln;
      GetSiNo('Vuoi proseguire con lo stesso polinomio? ', fine);
    until fine=0;
    X.Done; Y.Done;
    writeln;
    GetSiNo('Vuoi proseguire con un altro polinomio? ', fine);
  until fine=0;
end;

procedure EqSecGra;
var
  s, r, a, b, c: PREC;
  fine: integer;
begin
  ClrScr;
  writeln('RISOLUZIONE EQUAZIONE SECONDO GRADO A*X^2+B*X+C = 0');
  a:= 0; b:= 0; c:= 0;
  repeat
    writeln;
    InputPrec('COEFFICIENTE A = ', a, -inf, inf);
    InputPrec('COEFFICIENTE B = ', b, -inf, inf);
    InputPrec('COEFFICIENTE C = ', c, -inf, inf);
    S:= sqr(B) - 4 * A * C;
    R:= sqrt(ABS(S));
    IF S >= 0 then begin
      writeln('RADICI (REALI): ', DynaOut((-B-R)/(2*A)), ', ', DynaOut((-B+R)/(2*A)));
    end
    else begin
      writeln('RADICI (COMPLESSE): ',DynaOut(-B/(2*A)), ' ñ ', DynaOut(R/(2*A)),'i');
    end;
    writeln;
    GetSiNo('Vuoi proseguire? ', fine);
  until fine=0;
end;

procedure CurvInte;
const
  MX = 75;
var
  X, Y: TSVector;
  R, V, P: TSVector;
  A: TSMatrix;
  XV, YV, M, T, G, tmp: PREC;
  n, D, D2: integer;
  k, j, np, Q, MD: integer;
  fine: integer;
label ReDo;
  procedure Gosub650;
  var
    l, j, k, i: integer;
    Q: PREC;
  begin
    IF N = 1 THEN begin
      V.At(1)^:= R.At(1)^ / A.At(1, 1)^;
      exit;
    end;
    FOR K:= 1 TO N - 1 do begin
      L:= K;
      for i:= k+1 to n do begin
        IF ABS(A.At(I, K)^) > ABS(A.At(L, K)^) THEN L:= I;
      end;
      IF L <> K THEN begin
        FOR J:= K TO N do begin
          Q:= A.At(K, J)^;
          A.At(K, J)^:= A.At(L, J)^;
          A.At(L, J)^:= Q;
        end;
        Q:= R.At(K)^;
        R.At(K)^:= R.At(L)^;
        R.At(L)^:= Q;
      end;
      I:= K + 1;
      for i:= k+1 to n do begin
        Q:= A.At(I, K)^ / A.At(K, K)^;
        A.At(I, K)^:= 0;
        FOR J:= K + 1 TO N do begin
           A.At(I, J)^:= A.At(I, J)^ - Q * A.At(K, J)^;
        end;
        R.At(I)^:= R.At(I)^ - Q * R.At(K)^;
      end;
    end;
    V.At(N)^:= R.At(N)^ / A.At(N, N)^;
    FOR I:= N - 1 downto 1 do begin
      Q:= 0;
      FOR J:= I + 1 TO N do begin
        Q:= Q + A.At(I, J)^ * V.At(J)^;
        V.At(I)^:= (R.At(I)^ - Q) / A.At(I, I)^;
      end;
    end;
  end;
begin
  (* CURVE DI INTERPOLAZIONE *)
  ClrScr;
  X.Init(1,MX); Y.Init(1,MX);
  MD:= 7;
  Q:= MD + 1;
  A.Init(0,Q, Q); R.Init(0,Q); V.Init(0,Q);
  Q:= MD * 2;
  P.Init(0,Q);
  writeln('  - INTERPOLAZIONE AI MINIMI QUADRATI -');
  repeat
    writeln;
    np:= 0;
    InputInt('Quante coppie di dati (0=fine)? ', np, 0, MX);
    if np = 0 then exit;
    writeln;
    for j:= 1 to np do begin
      writeln('Punto #',j);
      tmp:= 0;
      InputPrec('X = ',  tmp, -inf, inf);
      X.At(j)^:= tmp;
      tmp:= 0;
      InputPrec('Y = ',  tmp, -inf, inf);
      Y.At(j)^:= tmp;
    end;
    writeln;
  ReDo:
    j:= np; if j > MD then j:= MD;
    write('GRADO DEL POLINOMIO APPROSSIMANTE (0=fine, max=',j);
    InputInt(')? ', D, 0, np);
    writeln;
    D2:= 2 * D;
    N:= D + 1;
    FOR J:= 1 TO D2 do begin
      P.At(J)^:= 0;
      FOR K:= 1 TO NP do begin
        P.At(J)^:= P.At(J)^ + Pow(X.At(K)^, J);
      end;
    end;
    P.At(0)^:= NP;
    R.At(1)^:= 0;
    FOR J:= 1 TO NP do R.At(1)^:= R.At(1)^ + Y.At(J)^;
    IF N <> 1 THEN begin
      FOR J:= 2 TO N do begin
        R.At(J)^:= 0;
        FOR K:= 1 TO NP do begin
          R.At(J)^:= R.At(J)^ + Y.At(K)^ * Pow(X.At(K)^,(J - 1));
        end;
      end;
    end;
    FOR J:= 1 TO N do begin
      FOR K:= 1 TO N do begin
        A.At(J, K)^:= P.At(J + K - 2)^;
      end;
    end;
    GOSUB650;
    writeln;
    writeln(' POTENZA COEFFICIENTE');
    writeln(' ------- ------------');
    FOR J:= 1 TO N do begin
      writeln('   ', J - 1:3,' ', V.At(J)^:12:3);
    end;
    writeln;
    tmp:= 0;
    FOR J:= 1 TO NP do begin
      tmp:= tmp + Y.At(J)^;
    end;
    M:= tmp / NP;
    T:= 0;
    G:= 0;
    FOR J:= 1 TO NP do begin
      tmp:= 0;
      FOR K:= 1 TO N do begin
        tmp:= tmp + V.At(K)^ * Pow(X.At(J)^,(K - 1));
      end;
      T:= T + sqr(Y.At(J)^ - tmp);
      G:= G + sqr(Y.At(J)^ - M);
    end;
    IF abs(G) < Zero THEN T:= 100 else T:= 100 * sqrt(1 - T / G);
    writeln('BONTA'' DEL FIT IN PERCENTO= ',T:6:2,'%');
    writeln;
    writeln('--OPZIONI DI CONTINUAZIONE--');
    writeln;
    writeln('  0 - FINE');
    writeln('  1 - DETERMINA PUNTI SPECIFICI');
    writeln('  2 - APPROSSIMA GLI STESSI DATI CON UN ALTRO GRADO');
    Q:= 1;
    InputInt('COSA VUOI FARE? ', Q, 0, 2);
    if q = 0 then exit;
    IF Q = 2 THEN goto Redo;
    writeln;
    repeat
      InputPrec('X= ', XV, -inf, inf);
      YV:= 0;
      FOR K:= 1 TO N do begin
        YV:= YV + V.At(K)^ * Pow(XV, (K - 1));
      end;
      writeln('Y= ', YV:12:3);
      writeln;
      GetSiNo('Vuoi proseguire a interpolare? ', fine);
    until fine=0;
    writeln;
    GetSiNo('Vuoi proseguire con altri dati? ', fine);
  until fine=0;
end;

procedure MenuMathMisc(var Spread: TSpread);
var ch : char;
begin
  repeat
    ClrScr;
    Writeln('       Mattomatical Package Ver. 1.à - CopyRight 1994 by Enrico Croce -        ');
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Torna al menu principale          |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Disposizioni con e senza ripet.   | A. Mostra anagrammi parola           |');
    writeln('| 2. Combinazioni con e senza ripet.   | B. Mostra permutazioni. Algor. #1    |');
    writeln('| 3. Numero di permutazioni            | C. Mostra permutazioni. Algor. #2    |');
    writeln('| 4. Fattoriale                        |                                      |');
    writeln('| 5. Crea retta tra due punti          | V. Analisi vettori                   |');
    writeln('| 6. Normalizzazioni  x = (y - b) / a  | P. Area di un poligono               |');
    writeln('| 7. Combinazione lineare y = aùx+b    | F. Scomposizione in fattori          |');
    writeln('|                                      | M. MCD                               |');
    writeln('| R. Risoluzione sistemi lineari       | E. Conversioni tra basi numeriche    |');
    writeln('| D. Calcolo del determinate           | G. Zero di polinomi (Newton)         |');
    writeln('| I. Calcolo inversa di una matrice    | H. Operazioni con vettori            |');
    writeln('| Q. Equazioni di secondo grado        | J. Giorno della settimana            |');
    writeln('| T. Curve Interp. min. quad vs. poly  | K. Giorni tra due date               |');
    writeln('|                                      | O. Interpolazione curvilinea         |');
    writeln('|                                      |                                      |');
    writeln('| L. Caricamento dati da disco         | S. Salvataggio dati sul disco        |');
    writeln('| Z. Inserimento serie di dati         | X. Modifica Serie di Dati            |');
    writeln('|                                      |                                      |');
    writeln('+-----------------------------------------------------------------------------+');
    writeln('| Quale e'' la tua scelta?                                                     |');
    write  ('+-----------------------------------------------------------------------------+');
    GotoXY(27, WhereY - 1);
    ch:= readkey; if ch = #0 then readkey;
    ch:= UpCase(ch);
    case ch of
      '1': Dispos;
      '2': Combin;
      '3': NumPermut;
      '4': Fattoriali;
      '5': MakeLine;
      '6': Normalize;
      '7': CombinLin;
      'A': Anagramma;
      'B': Perm1;
      'C': Perm2;
      'D': Determinante;
      'E': RunBaseToBase;
      'F': ScompNumPri;
      'G': ZeroPoli;
      'H': OperVett;
      'I': Inversa;
      'J': GiorSett;
      'K': GiorniTraDate;
      'L': Spread.LoadData;
      'M': CalcMCD;
      'O': InterpCurv;
      'P': AreaPoligono;
      'Q': EqSecGra;
      'R': Sistemi;
      'S': Spread.SaveData;
      'T': CurvInte;
      'V': AnalisiVettori;
      'X': Spread.Show(ord('A'), ord('Z'), 0, 0);
      'Z': Spread.GetData;
    end;
  until ch = '0';
  ClrScr;
end;

{$IFNDEF UNIT}
var
  Spread: PSpread;
begin
  New(Spread, Init);
  MenuMathMisc(Spread^);
{$ENDIF}
end.
