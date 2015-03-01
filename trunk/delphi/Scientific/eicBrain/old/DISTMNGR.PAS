unit DistMngr; (* and more ! *)

{$I switches.inc}

interface

uses MathStat, DistrObj, DistDObj, DistCObj;

procedure DistDUni(XVal: boolean);
procedure DistBern(XVal: boolean);
procedure DistBino(XVal: boolean);
procedure DistIper(XVal: boolean);
procedure DistGeom(XVal: boolean);
procedure DistBinN(XVal: boolean);
procedure DistPois(XVal: boolean);
procedure DistDice(XVal: boolean);

procedure DistCUni(XVal: boolean);
procedure DistNorm(XVal: boolean);
procedure DistLogN(XVal: boolean);
procedure DistExpo(XVal: boolean);
procedure DistWeib(XVal: boolean);
procedure DistGamm(XVal: boolean);
procedure DistTStu(XVal: boolean);
procedure DistChiQ(XVal: boolean);
procedure DistFish(XVal: boolean);
procedure DistBeta(XVal: boolean);

function MakeCUni: PCUniform;
function MakeNorm: PNormale;
function MakeWeib: PWeibull;
function MakeExpo: PExp;
function MakeSerie: PSerieDistrib;
function MakeParal: PParalDistrib;
function MakeCDis: PContDistrib;

implementation

uses Crt, MathTool, DataMngr;

procedure RunDist(D: PDistrib; Disc: boolean; XVal: boolean);
var
  x, p, r: PREC;
  ch: char;
begin
  writeln;
  x:= 0;
  repeat
    if XVal then begin
      InputPrec('Valore à da ricercare (à = 1-p.c.): ', x, 0, 1);
      writeln;
      p:= 1-x;
      if Disc then r:= PDiscDistrib(D)^.XVal(p) else r:= PContDistrib(D)^.XVal(p);
      writeln('Valore x critico = ', DynaOut(r));
    end
    else begin
      InputPrec('Valore x in cui valutare: ',x,-inf,inf);
      writeln;
      if Disc then r:= PDiscDistrib(D)^.fDis(round(x)) else r:= PContDistrib(D)^.fDis(x);
      writeln('Valore densita'' probabilita''      = ', r:15:5);
      if Disc then r:= PDiscDistrib(D)^.FCum(round(x)) else r:= PContDistrib(D)^.FCum(x);
      writeln('Valore Coda (funzione cumulativa) = ', r:15:5);
      writeln('Valore 1-Coda                     = ', (1-r):15:5);
    end;
    writeln;
    write(' RETURN continua con altri valori, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
end;

procedure DistDUni(XVal: boolean);
var
  n: TInt;
  U: TDUniform;
  ch: char;
begin
  clrscr;
  write('Distribuzione Uniforme discreta');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  U.Uniform(1);
  n:= 1;
  repeat
    InputInt('Numero di eventi (n)  : ',n,1,maxint);
    writeln;
    U.SetN(n);
    RunDist(@U, true, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  U.Done;
end;

procedure DistBern(XVal: boolean);
var
  p: PREC;
  B: TBernulli;
  ch: char;
begin
  clrscr;
  write('Distribuzione Bernulli');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  B.Bernulli(0.5);
  p:= 0;
  repeat
    InputPrec('Probabilita'' successo (p): ',p,0,1);
    writeln;
    B.SetP(p);
    RunDist(@B, true, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  B.Done;
end;

procedure DistBino(XVal: boolean);
var
  n: TInt;
  p: PREC;
  B: TBinomial;
  ch: char;
begin
  clrscr;
  write('Distribuzione Binomiale');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  B.Binomial(1, 0.5);
  n:= 1;
  p:= 0;
  repeat
    InputInt('Numero di tentativi (n)  : ',n,0,maxint);
    InputPrec('Probabilita'' successo (p): ',p,0,1);
    writeln;
    B.SetP(p);
    B.SetN(n);
    RunDist(@B, true, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  B.Done;
end;

procedure DistIper(XVal: boolean);
var
  m, k, n : TInt;
  ch: char;
  I: TIperGeom;
begin
  clrscr;
  write('Distribuzione Iper Geometrica');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  I.IperGeom(1, 1, 1);
  m:= 1;
  k:= 0;
  n:= 0;
  repeat
    InputInt('Numero di pezzi nel lotto  (M) : ',M,0,maxint);
    InputInt('Numero di pezzi difettosi  (K) : ',K,0,M);
    InputInt('Dimensione del campione    (n) : ',n,0,M);
    writeln;
    I.SetM(M);
    I.SetK(K);
    I.SetN(n);
    RunDist(@I, true, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  I.Done;
end;

procedure DistPois(XVal: boolean);
var
  lambda: PREC;
  ch: char;
  P: TPoisson;
begin
  clrscr;
  write('Distribuzione Poisson');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  P.Poisson(1);
  lambda:= 1;
  repeat
    InputPrec('frequenza-media calcolata (lambda) : ',lambda,Zero,inf);
    P.SetLambda(lambda);
    RunDist(@P, true, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  P.Done;
end;

procedure DistGeom(XVal: boolean);
var
  p: PREC;
  G: TGeometric;
  ch: char;
begin
  clrscr;
  write('Distribuzione Geometrica');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  G.Geometric(0.5);
  p:= 0;
  repeat
    InputPrec('Probabilita'' successo (p): ',p,0,1);
    writeln;
    G.SetP(p);
    RunDist(@G, true, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  G.Done;
end;

procedure DistBinN(XVal: boolean);
var
  n: TInt;
  p: PREC;
  B: TBinNeg;
  ch: char;
begin
  clrscr;
  write('Distribuzione Binomiale Negativa');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  B.BinNeg(1, 0.5);
  n:= 1;
  p:= 0;
  repeat
    InputInt('Numero di tentativi (r)  : ',n,0,maxint);
    InputPrec('Probabilita'' successo (p): ',p,0,1);
    writeln;
    B.SetP(p);
    B.SetR(n);
    RunDist(@B, true, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  B.Done;
end;

procedure DistDice(XVal: boolean);
var
  n, f: TInt;
  D: TDiceDis;
  ch: char;
begin
  clrscr;
  write('Distribuzione Somma di Dadi');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  D.DiceDis(1, 1);
  n:= 1; f:= 1;
  repeat
    InputInt('Numero di dadi lanciati (n)   : ',n,1,maxint);
    InputInt('Numero di facce su un dado (f): ',f,1,maxint);
    writeln;
    D.SetNum(n);
    D.SetFac(f);
    RunDist(@D, true, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  D.Done;
end;

procedure DistCUni(XVal: boolean);
var
  ch: char;
  a, b: PREC;
  U: TCUniform;
begin
  ClrScr;
  write('Distribuzione continua uniforme');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  U.Uniform(0,1);
  a:= 0; b:= 0;
  repeat
    InputPrec('Limite inferiore intervallo (a) : ',a,-inf,inf);
    InputPrec('Limite superopre intervallo (b) : ',b,a,inf);
    writeln;
    U.SetA(a);
    U.SetB(b);
    RunDist(@U, false, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  U.Done;
end;

procedure DistNorm(XVal: boolean);
var
  ch: char;
  m, s: PREC;
  N: TNormale;
begin
  ClrScr;
  write('Distribuzione normale');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  N.Normale(0,1);
  m:= 0; s:= 1;
  repeat
    writeln('0 = variabili standardizzate, 1 = variabili da standardizzare');
    repeat
      GetChar('Quale? ',ch);
    until (ch = '0') or (ch='1');
    writeln;
    if ch = '0' then begin
      s:= 1;
      m:= 0;
      writeln('Media                      (mu) : 0.0');
      writeln('Scarto quadratico medio (sigma) : 1.0');
    end
    else begin
      InputPrec('Media                      (mu) : ',M,-inf,inf);
      InputPrec('Scarto quadratico medio (sigma) : ',S,0,inf);
    end;
    writeln;
    N.SetMedia(M);
    N.SetScarto(S);
    RunDist(@N, false, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  N.Done;
end;

procedure DistLogN(XVal: boolean);
var
  ch: char;
  a, b: PREC;
  L: TLogNor;
begin
  ClrScr;
  write('Distribuzione Log-Normale');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  L.LogNor(0,1);
  a:= 1; b:= 1;
  repeat
    InputPrec('Logartimo media (a) : ',a,-inf,inf);
    InputPrec('Logaritmo scarto (b) : ',b,0,inf);
    writeln;
    L.SetMedia(a);
    L.SetScarto(b);
    RunDist(@L, false, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  L.Done;
end;

procedure DistExpo(XVal: boolean);
var
  ch: char;
  a: PREC;
  E: TExp;
begin
  ClrScr;
  write('Distribuzione Esponenziale');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  E.ExpDis(1);
  a:= 1;
  repeat
    InputPrec('Valore di lambda (>0): ',a,Zero,inf);
    writeln;
    E.SetLambda(a);
    RunDist(@E, false, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  E.Done;
end;

procedure DistGamm(XVal: boolean);
var
  ch: char;
  a, b: PREC;
  G: TGamma;
begin
  ClrScr;
  write('Distribuzione Gamma');
  writeln;
  writeln('Risultati NON testati');
  writeln;
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  G.GammaDis(0,1);
  a:= 1; b:= 1;
  repeat
    InputPrec('Valore di lambda (>0): ',a,Zero,inf);
    InputPrec('Somma di R expon. (r): ',b,-inf,inf);
    writeln;
    G.SetR(b);
    G.SetLambda(a);
    RunDist(@G, false, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  G.Done;
end;

procedure DistWeib(XVal: boolean);
var
  ch: char;
  a, b: PREC;
  W: TWeibull;
begin
  ClrScr;
  write('Distribuzione Weibull');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  W.Weibull(0,1);
  a:= 1; b:= 1;
  repeat
    InputPrec('Valore di alpha (à): ', a, -inf,inf);
    InputPrec('Valore di beta  (á): ', b, -inf,inf);
    writeln;
    W.SetAlpha(a);
    W.SetBeta(b);
    RunDist(@W, false, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  W.Done;
end;

procedure DistBeta(XVal: boolean);
var
  ch: char;
  al, be: PREC;
  B: TBeta;
begin
  ClrScr;
  write('Distribuzione Beta');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  B.BetaDis(0,1);
  al:= 1; be:= 1;
  repeat
    InputPrec('Valore di alpha (à): ',al,-inf,inf);
    InputPrec('Valore di beta  (á): ',be,-inf,inf);
    writeln;
    B.SetAlpha(al);
    B.SetBeta(be);
    RunDist(@B, false, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  B.Done;
end;

procedure DistTStu(XVal: boolean);
var
  ch: char;
  d : PREC;
  T : TTStudent;
begin
  ClrScr;
  write('Distribuzione TStudent');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  T.TStudent(1);
  d:= 1;
  repeat
    InputPrec('Gradi di libeta''                : ',d,0,inf);
    T.SetDegOfFre(d);
    RunDist(@T, false, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  T.Done;
end;

procedure DistFish(XVal: boolean);
var
  ch: char;
  d1, d2 : PREC;
  F: TFisher;
begin
  ClrScr;
  write('Distribuzione Fischer');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  F.Fisher(1, 1);
  d1:= 1; d2:= 1;
  repeat
    InputPrec('Gradi di libeta'' numeratore     : ',d1,0,inf);
    InputPrec('Gradi di libeta'' denominatore   : ',d2,0,inf);
    F.SetDegOfFreN(d1);
    F.SetDegOfFreD(d2);
    RunDist(@F, false, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  F.Done;
end;

procedure DistChiQ(XVal: boolean);
var
  ch: char;
  d : integer;
  C: TChiQuad;
begin
  ClrScr;
  write('Distribuzione ChiQuadro');
  if XVal then writeln(' (Valori critici)') else writeln;
  writeln;
  C.ChiQuad(1);
  d:= 1;
  repeat
    InputInt('Gradi di libeta''                : ',d,0,maxint);
    writeln;
    C.SetDegOfFre(D);
    RunDist(@C, false, XVal);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  C.Done;
end;

function MakeExpo: PExp;
var
  a: PREC;
  E: PExp;
begin
  writeln('Distribuzione Esponenziale');
  New(E, ExpDis(1));
  a:= 1;
  InputPrec('Valore di lambda (>0): ',a,Zero,inf);
  E^.SetLambda(a);
  MakeExpo:= E;
end;

function MakeWeib: PWeibull;
var
  a, b: PREC;
  W: PWeibull;
begin
  writeln('Distribuzione Weibull');
  New(W, Weibull(0,1));
  a:= 1; b:= 1;
  InputPrec('Valore di alpha (à): ', a, -inf,inf);
  InputPrec('Valore di beta  (á): ', b, -inf,inf);
  W^.SetAlpha(a);
  W^.SetBeta(b);
  MakeWeib:= W;
end;

function MakeNorm: PNormale;
var
  m, s: PREC;
  N: PNormale;
begin
  writeln('Distribuzione normale');
  New(N, Normale(0,1));
  m:= 0; s:= 1;
  InputPrec('Media                      (mu) : ',M,-inf,inf);
  InputPrec('Scarto quadratico medio (sigma) : ',S,0,inf);
  N^.SetMedia(M);
  N^.SetScarto(S);
  MakeNorm:= N;
end;

function MakeCUni: PCUniform;
var
  a, b: PREC;
  U: PCUniform;
begin
  writeln('Distribuzione continua uniforme');
  New(U, Uniform(0,1));
  a:= 0; b:= 0;
  InputPrec('Limite inferiore intervallo (a) : ',a,-inf,inf);
  InputPrec('Limite superopre intervallo (b) : ',b,a,inf);
  U^.SetA(a);
  U^.SetB(b);
  MakeCUni:= U;
end;

function MakeSerie: PSerieDistrib;
var
  ch: Char;
  F1, F2: PContDistrib;
begin
  writeln('Primo componente'); F1:= MakeCDis;
  GetChar('Secondo componente identico al primo? ', ch);
  if ch <> 'S' then begin
    writeln('Secondo componente'); F2:= MakeCDis;
  end
  else begin
    F2:= F1;
  end;
  MakeSerie:= new(PSerieDistrib, SerieDistrib(F1, F2));
end;

function MakeParal: PParalDistrib;
var
  ch: Char;
  F1, F2: PContDistrib;
begin
  writeln('Primo componente'); F1:= MakeCDis;
  GetChar('Secondo componente identico al primo? ', ch);
  if ch <> 'S' then begin
    writeln('Secondo componente'); F2:= MakeCDis;
  end
  else begin
    F2:= F1;
  end;
  MakeParal:= new(PParalDistrib, ParalDistrib(F1, F2));
end;

function MakeCDis: PContDistrib;
var
  ch: char;
  py: integer;
begin
  writeln('Distribuzioni disponibili: ');
  writeln('U)niforme, N)ormale, E)sponeziale, W)eibull,');
  writeln('S)erie, P)arallelo');
  py:= WhereY;
  repeat
    GotoXY(1, py);
    GetChar('Quale? ', ch);
    GotoXY(1, py);
    case ch of
      'U': MakeCDis:= MakeCUni;
      'N': MakeCDis:= MakeNorm;
      'E': MakeCDis:= MakeExpo;
      'W': MakeCDis:= MakeWeib;
      'S': MakeCDis:= MakeSerie;
      'P': MakeCDis:= MakeParal;
      else continue;
    end;
  until true;
end;

end.
