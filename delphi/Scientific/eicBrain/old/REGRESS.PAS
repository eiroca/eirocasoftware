unit Regress;

{$I switches.inc}

interface

uses DataMngr;

procedure RegLin(var Spread: TSpread);
procedure RegLinMul(var Spread: TSpread);
procedure CorLin(var Spread: TSpread);

implementation

uses MathTool, MathStat, MathStt1, Matrix, MatrMath, Charting, Crt;

procedure CalcData(Serie1, Serie2: PSerie; first, last: integer;
  var N: longint; var SumX, SumY, SumXY, SumX2, SumY2: DPREC; Print: boolean);
var
  i: integer;
  tmp1, tmp2: PREC;
begin
  n:= 0; SumX:= 0; SumY:= 0; SumXY:= 0; SumX2:= 0; SumY2:= 0;
  for i:= First to Last do begin
    tmp1 := Serie1^.At(i)^;
    tmp2 := Serie2^.At(i)^;
    N    := N + 1;
    SumX := SumX  + tmp1;
    SumY := SumY  + tmp2;
    SumX2:= SumX2 + sqr(tmp1);
    SumY2:= SumY2 + sqr(tmp2);
    SumXY:= SumXY + tmp1 * tmp2;
  end;
  if Print then begin
    writeln('Numero di punti    = ', n:9);
    writeln('Sommatoria Xi      = ', SumX :15:5);
    writeln('Sommatoria Yi      = ', SumY :15:5);
    writeln('Sommatoria Xi^2    = ', SumX2:15:5);
    writeln('Sommatoria Yi^2    = ', SumY2:15:5);
    writeln('Sommatoria Xi * Yi = ', SumXY:15:5);
  end;
end;

procedure CalcRegres(var X: TSMatrix; var Y: TSVector; var xtx, V: TSMatrix; var Xty, b: TSVector; PrintIt: boolean);
var
  tmp: TSMatrix;
  Xt: TSMatrix;
  i,j: integer;
begin
  tmp.Init(1,XtX.Rows, XtX.Cols);
  Xt.Init(1,X.Cols, X.Rows);
(* Esegue i calcoli *)
  SMatMulXtX(XtX, X);
  SMatTra(Xt, X);
  MatrixCopyTo(XtX, tmp);
  SMatVec(Xty, Xt, y);
  SMatInv(V, tmp);
  SMatVec(b, V, Xty);
  if PrintIt then begin
    (* stampa i valori intermedi *)
    writeln('X` X');
    for i:= 1 to X.Cols do begin
      for j:= 1 to X.Cols do begin
        write(XtX.At(i,j)^:8:3, ' ');
      end;
      writeln;
    end;
    WaitReturn;
    writeln('X` y');
    for i:= 1 to X.Cols do begin
      write(Xty.At(i)^:8:3, ' ');
    end;
    writeln;
    WaitReturn;
    writeln('(X` X)^-1');
    for i:= 1 to X.Cols do begin
      for j:= 1 to X.Cols do begin
       write(V.At(i,j)^:8:3, ' ');
       end;
      writeln;
    end;
    writeln('b');
    for i:= 1 to X.Cols do begin
      write(b.At(i)^:8:3, ' ');
    end;
    writeln;
    WaitReturn;
  end;
  Xt.Done;
  tmp.Done;
end;

procedure GraphRegression(var x, y1: TSerie; var b: TSVector; Kind: integer);
var
  YesFlag: integer;
  i,n: integer;
  yc: TSerie;
  re: TSerie;
  Cht,Cht2: PScatChart;
  procedure MakeGraph(mrg: boolean);
  begin
    YesFlag:= 0;
    with Cht^ do begin
      repeat
        GetScale;
        GetTitle;
        GetOption;
        Draw;
        if mrg then begin
          (* finche' non implemento grafici di tipo diverso ! *)
          cht2^.ValMinY:= ValMinY; (* sono quelli del primo! *)
          cht2^.ValMaxY:= ValMaxY;
          cht2^.ChartPort:= ChartPort;
          cht2^.DrawChart;
        end;
        DrawDone;
        ClrScr;
        GetSiNo('Vuoi ridisegnare il grafico cambiando i parametri? ', YesFlag);
      until YesFlag=0;
    end;
  end;
begin
  ClrScr;
  YesFlag:= 0;
  GetSiNo('Vuoi i grafici della regressione/residui? ', YesFlag);
  if YesFlag = 0 then exit;
  n:= X.Count;
  yc.Init(MaxData);
  re.Init(MaxData);
  for i:= 1 to n do begin
    yc.Append(b.At(1)^ + b.At(2)^ * X.At(i)^);
    re.Append(yc.At(i)^-y1.At(i)^);
  end;
  Cht:= New(PScatChart, init);
  Cht2:= New(PScatChart, init);
  with PScatChart(Cht)^ do begin
    Title1:= 'Grafico della regressione';
    Title2:= 'dati sperimentali = x, linea retta regressione';
    TitleX:= '';
    TitleY:= '';
    Options:= BigDot + ShowXAx + ShowYAx + ShowAve;
    NumSer:= 1;
    NumDat:= n;
    SerieX:= @X;
    SerieY[1]:= @y1;
    Analyze;
    ValMinY:= aveY-3*sigY;
    ValMaxY:= aveY+3*sigY;
    cht2^:=cht^; (* attenzione se in fututo ci saranno dati dinamici!*)
    cht2^.Options:= JoinDot + ShowXAx + ShowYAx + ShwGrdX + ShwGrdY;
    cht2^.SerieX:= @X;
    cht2^.SerieY[1]:= @yc;
    MakeGraph(true);
    Title1:= 'Grafico dei residui';
    Options:= BigDot + ShowXAx + ShowYAx + ShowAve;
    SerieX:= @X;
    SerieY[1]:= @re;
    Analyze;
    ValMinY:= aveY-3*sigY;
    ValMaxY:= aveY+3*sigY;
    MakeGraph(false);
  end;
  yc.Done;
  re.Done;
end;

procedure MoreAboutRegression(var x, y1: TSerie; LivFid: PREC; sx, sx2: PREC; s2e: PREC; var b: TSVector);
var
  i, nu: integer;
  n: integer;
  k, j, jj: integer;
  y: TSerie;
  s, s2, t, li, ls, tmp, a,
  Sser, SSlf, SSpe: PREC;
  px, py, xm, ym : PREC;
  ch: char;
label LExit;
begin
  n:= x.Count;
  y.Init(MaxData);
  if n < 3 then exit;
  for i:= 1 to n do begin
    y.At(i)^:= y1.At(i)^;
  end;
  SSpe:= 0;
  SSer:= s2e * (n-2);
  k:= 0;
  for i:= 2 to n do begin
    if i > n then break; (* Serve!!, senza va in cricca xche' modifico 'i'! *)
    if x.At(i-1)^ = x.At(i)^ then begin
      inc(k);
      j:= 1; jj:= i-1;
      s:=  y.At(i-1)^;
      s2:= sqr(y.At(i-1)^);
      while (x.At(i-1)^ = x.At(i)^) and (i <= n) do begin
        s:=  s  + y.At(i)^;
        s2:= s2 + sqr(y.At(i)^);
        inc(i);
        inc(j);
      end;
      ym:= s / j;
      SSpe:= SSpe + s2 - sqr(ym) * j;
    end;
  end;
  if k <> 0 then begin
    SSlf:= SSer - SSpe;
    s:= (SSlf/(k-2))/(SSpe/(n-k));
    writeln('Verifica attendibilita'' del modello lineare');
    writeln('SSpe = ', SSpe:15:5,'  MSpe = ',(SSlf/(k-2)):15:5);
    writeln('SSlf = ', SSlf:15:5,'  MSlf = ',(SSpe/(n-k)):15:5);
    writeln('Fcal = ', s:15:5, ' GL num=',k-2,' den=',n-k);
    writeln('Fteo = ', FisherXVal(LivFid, k-2, n-k):15:5);
    WaitReturn;
  end
  else begin
    writeln('Spiacente, ma non essendoci ripetizioni di dati non posso');
    writeln('verificare l''attendibilita'' del modello lineare.');
    WaitReturn;
    Goto LExit;
  end;
  nu:= n; xm:= sx / nu;
  s:= sqrt(s2e);
  t:= TStudentXVal(LivFid, n-2);
  a:= (sx2 - sqr(sx)/nu);
  writeln;
  writeln('Indicazione degli intervalli di fiducia');
  writeln;
  writeln('Intervallo di fiduca di á^0');
  li:= sqrt(1 / nu + sqr(xm) / (sx2 - sqr(sx)/nu)) * s * t;
  ls:= b.At(1)^ + li;
  li:= b.At(1)^ - li;
  writeln('[Li,Ls] = [ ', li:15:5,', ',ls:15:5,' ]');
  writeln;
  writeln('Intervallo di fiduca di á^1');
  li:= sqrt(1 / (sx2 - sqr(sx)/nu)) * s * t;
  ls:= b.At(2)^ + li;
  li:= b.At(2)^ - li;
  writeln('[Li,Ls] = [ ', li:15:5,', ',ls:15:5,' ]');
  WaitReturn;
  writeln;
  writeln('Sia:');
  writeln(' n = ', nu:15);
  writeln('      n          _');
  writeln(' a =  ä   (x  -  x)ý  = ', a:15:5);
  writeln('     i=1    i');
  writeln(' s = ', s:15:5);
  writeln('  t                =  ', t:15:5);
  writeln('   df:',nu-2,'; x:',LivFid*100:6:3);
  writeln;
  px:= 0;
  repeat
    InputPrec('Valore della x in cui valutare = ', px, -inf, inf);
    py:= b.At(1)^ + b.At(2)^ * px;
    tmp:= (1/nu + sqr(px - xm) / a);
    writeln;
    writeln('Intervallo singoli valori = ',py:15:5,' ñ ', sqrt(tmp)* s * t:15:5);
    writeln;
    writeln('Intervallo regressione    = ',py:15:5,' ñ ', sqrt(1+tmp)* s * t:15:5);
    writeln;
    write(' RETURN continua con altri valori x, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
LExit:
  GraphRegression(x, y1, b, 1);
  Y.Done;
end;

procedure RegLin(var Spread: TSpread);
var
  Serie1, Serie2: char;
  n: longint;
  SumX, SumY, SumY2, SumXY, SumX2, Sum2X: DPREC;
  SumYd: PREC;
  unosuN, xm, ym: PREC;
  b: TSVector;
  SStt, SSer, s: PREC;
  LivFid: PREC;
begin
  b.Init(1,2);
  ClrScr;
  writeln('Regressione lineare con formulette classiche');
  writeln;
  writeln('Scegli la serie da usare come variabile indipendente X');
  Spread.GetSerie(Serie1);
  if Serie1 = #0 then exit;
  writeln;
  writeln('Scegli la serie da usare come variabile dipendente Y');
  Spread.GetSerie(Serie2);
  if Serie2 = #0 then exit;
  if Serie1 = Serie2 then begin
    writeln('Spiacente, ma le due serie di dati devono essere diverse!');
    WaitReturn;
    exit;
  end;
  if Spread.Cols[Serie1]^.Count <> Spread.Cols[Serie2]^.Count then begin
    writeln('Spiacente, ma deve esserci la stessa quantita'' di dati nelle');
    writeln('serie di dati X e Y!');
    WaitReturn;
    exit;
  end;
  writeln;
  CalcData(Spread.Cols[Serie1],Spread.Cols[Serie2], Spread.Cols[Serie1]^.First, Spread.Cols[Serie1]^.Last,
    n, SumX, SumY, SumXY, SumX2, SumY2, true);
  Sum2X:= sqr(SumX);
  unosuN:= 1.0 / n;
  xm:= unosuN * SumX;
  ym:= unosuN * SumY;
  b.At(2)^:= (SumXY - SumX * SumY * unosuN) / (SumX2 - Sum2X * unosuN);
  b.At(1)^:= unosuN * (SumY - b.At(2)^ * SumX);
  writeln;
  writeln('valore medio di x  = ', xm:15:5);
  writeln('valore medio di y  = ', ym:15:5);
  writeln;
  writeln('b0                 = ', b.At(1)^:15:5);
  writeln('b1                 = ', b.At(2)^:15:5);
  writeln('y^ = ',b.At(1)^:15:5,' + (', b.At(2)^:15:5,' x)');
  writeln('oppure y^ = ',ym:15:5,' + (', b.At(2)^:15:5,' * (x - ', xm:15:5,' )');
  WaitReturn;
  writeln;
  LivFid:= GetLivFid;
  writeln;
  SumYd:= SumY2 - n * sqr(ym) - b.At(2)^*(SumXY - n * xm * ym);
  if n > 2 then s:= SumYd / (n-2) else s:= 0;
  MoreAboutRegression(Spread.Cols[Serie1]^, Spread.Cols[Serie2]^, LivFid, SumX, SumX2, s, b);
  b.Done;
end;

procedure RegLinMul;
var
  st: string;
  ch: char;
  m, n, err : integer;
  X, XtX, V, XtXb: TSMatrix;
  Y, yc, yd: TSVector;
  Xty: TSVector;
  b: TSVector;
  k, i, j, jj : integer;
  s: PREC;
  SSlf, SSpe, SSresidua, s2e : PREC;
  nn  : PREC;
  ym  : PREC;
  GLtt: PREC;
  GLb0: PREC;
  GLbn: PREC;
  GLer: PREC;
  SStt: PREC;
  SSb0: PREC;
  SSbn: PREC;
  SSer: PREC;
  MSb0: PREC;
  MSbn: PREC;
  MSer: PREC;
  r2, tmp1, tmp2: PREC;
  LivFid: PREC;
  tmp11, tmp12: PREC;
  q, w : TSerie;
  SumX, SumX2: PREC;
label
  Esci1, Esci2;
begin
  ClrScr;
  Writeln('Regressione Lineare Multipla');
  writeln;
  m:= 1;
  InputInt('Quante variabili? ',m,1,maxint);
  inc(m); (* Aggiunge il termine noto 'traslazione' *)
  n:= 1;
  InputInt('Quante rilevazioni? ',n,1,maxint);
  (* Crea le matrici necessarie *)
  X.Init(1,n,m);
  XtX.Init(1,m,m);
  V.Init(1,m,m);
  Xty.Init(1,m);
  b.Init(1,m);
  y.Init(1,n); yc.Init(1,n); yd.Init(1,n);
  (* Input dei dati *)
  for i:= 1 to n do begin X.At(i, 1)^:= 1.0; end;
  for i:= 2 to m do begin
    writeln;
    writeln('Variabile #',pred(i));
    for j:= 1 to n do begin
      st:= '';
      repeat
        write('Osservazione #',j:3,' valore = '); InputStr('', st);
        if upcase(st[1]) in ['A'..'Z'] then begin
          ch:= upcase(st[1]);
          if Spread.Cols[ch]^.Count >= n then begin
            writeln('Uso la serie ', ch);
            for k:= 1 to n do begin
              X.At(k, i)^:= Spread.Cols[ch]^.At(k)^;
            end;
            goto Esci1;
          end
          else begin
            writeln('Serie non valida');
          end;
        end;
        val(st, s, err);
      until err = 0;
      X.At(j, i)^:= S;
    end;
Esci1:
  end;
  writeln;
  writeln('Immettere valori osservati Y');
  for j:= 1 to n do begin
    st:= '';
    repeat
      write('Risultati #',j:3,' = '); InputStr('', st);
      if upcase(st[1]) in ['A'..'Z'] then begin
        ch:= upcase(st[1]);
        if Spread.Cols[ch]^.Count >= n then begin
          writeln('Uso la serie ', ch);
          for k:= 1 to n do begin
            y.At(k)^:= Spread.Cols[ch]^.At(k)^;
          end;
          goto Esci2;
        end
        else begin
          writeln('Serie non valida');
        end;
      end;
      val(st, s, err);
    until err = 0;
    y.At(j)^:= s;
  end;
Esci2:
  CalcRegres(X, Y, XtX, V, Xty, b, true);
  SMatVec(yc, X, b);
  nn   := XtX.At(1,1)^;
  SumX := XtX.At(1,2)^;
  SumX2:= XtX.At(2,2)^;
  SSresidua:= 0;
  for i:= 1 to n do begin
    yd.At(i)^:= y.At(i)^ - yc.At(i)^;
    SSresidua:= SSresidua + sqr(yd.At(i)^);
  end;
  s2e:= SSresidua / (n-m);
  writeln('SSresidua = ', SSresidua:8:3);
  writeln('s2e       = ', s2e:8:3);
  ym:= Xty.At(1)^ / nn;
  GLtt:= n;
  GLb0:= 1;
  GLbn:= m - 1;
  GLer:= GLtt - GLb0 - GLbn;
  SSb0:= nn * sqr(ym);
  S:= 0;
  for i:= 1 to m do begin
    S:= S + b.At(i)^ * Xty.At(i)^;
  end;
  SSbn:= S - SSb0;
  SStt:= 0;
  for i:= 1 to n do begin
    SStt:= SStt + sqr(y.At(i)^);
  end;
  SSer:= SStt - SSb0 - SSbn;
  MSb0:= SSb0 / GLb0;
  MSbn:= SSbn / GLBn;
  MSer:= SSer / GLer;
  if MSer < ZERO then begin
    tmp1:= 999999.999;
    tmp2:= 999999.999;
  end
  else begin
    tmp1:= MSb0 / MSer;
    tmp2:= MSbn / MSer;
  end;
  R2:= SSbn / (SStt-SSb0);
  writeln;
  LivFid:= GetLivFid;
  writeln;
  writeln('     Tavola della varianza   (Livello di Fiducia = ',LivFid*100:7:3,'%)');
  writeln('-------------------------------------------------------------------------------');
  writeln('| Origine/Fattore  | G.L. |     SS     |     MS     |   F calc   |  F teorica |');
  writeln('-------------------------------------------------------------------------------');
  writeln('| regressione      |      |            |            |            |            |');
  tmp11:= FisherXVal(LivFid, GLb0, Gler);
  tmp12:= FisherXVal(LivFid, Glbn, Gler);
  writeln('|   - dovuto a b0  | ',GLb0:4:0,' | ',SSb0:10:3,' | ',MSb0:10:3,' | ',tmp1:10:3,' | ',tmp11:10:3,' |');
  writeln('|   - dovuto a bn  | ',GLbn:4:0,' | ',SSbn:10:3,' | ',MSbn:10:3,' | ',tmp2:10:3,' | ',tmp12:10:3,' |');
  writeln('| errore sperimen. | ',GLer:4:0,' | ',SSer:10:3,' | ',MSer:10:3,' |            |            |');
  writeln('-------------------------------------------------------------------------------');
  writeln('| Totali           | ',GLtt:4:0,' | ',SStt:10:3,' |            |            |            |');
  writeln('-------------------------------------------------------------------------------');
  writeln;
  writeln('R^2 = ', R2:8:3);
  WaitReturn;
  (* Ulteriori analisi dell'affidabilita' della regressione lineare, ma a
     soli due fattori *)
  if (m = 2) and (n < 51) and (n > 2) then begin
    q.Init(MaxData);
    w.Init(MaxData);
    for i:= 1 to n do begin
      q.Append(X.At(i,2)^);
      w.Append(Y.At(i)^);
    end;
    MoreAboutRegression(q, w, LivFid, SumX, SumX2, s2e, b);
    q.Done;
    w.Done;
  end;
  X.Done;
  XtX.Done;
  V.Done;
  Xty.Done;
  b.Done;
  y.Done;
  yc.Done;
  yd.Done;
end;

procedure CorLin(var Spread: TSpread);
var
  Serie1, Serie2: char;
  n: longint;
  tmp1, tmp2: PREC;
  SumX, SumY, SumY2, SumX2, SumXY: DPREC;
  R: PREC;
begin
  ClrScr;
  writeln('Calcolo del coefficiente di correlazione tra due serie');
  writeln;
  writeln('Scegli la prima serie');
  Spread.GetSerie(Serie1);
  if Serie1 = #0 then exit;
  writeln;
  writeln('Scegli la seconda serie');
  Spread.GetSerie(Serie2);
  if Serie2 = #0 then exit;
  if Serie1 = Serie2 then begin
    writeln('Spiacente, ma le due serie di dati devono essere diverse!');
    WaitReturn;
    exit;
  end;
  if Spread.Cols[Serie1]^.Count <> Spread.Cols[Serie2]^.Count then begin
    writeln('Spiacente, ma deve esserci la stessa quantita'' di dati nelle');
    writeln('due serie di dati.');
    WaitReturn;
    exit;
  end;
  writeln;
  CalcData(Spread.Cols[Serie1],Spread.Cols[Serie2], Spread.Cols[Serie1]^.First, Spread.Cols[Serie1]^.Last,
    n, SumX, SumY, SumXY, SumX2, SumY2, true);
  R:= (N*SumXY - SumX*SumY) / sqrt((N*SumX2 - sqr(SumX)) * (N*SumY2 - sqr(SumY)));
  writeln;
  writeln('Coef. cor. lin.  R = ', R:15:5);
  writeln('Coef. cor. lin.ý Rý= ', sqr(R):15:5);
  writeln;
  WaitReturn;
end;

end.
