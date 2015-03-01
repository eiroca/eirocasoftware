{$I switches.inc}
{ UNDEF UNIT}

{$IFDEF UNIT}
unit MenuVari;

interface

uses MathTool, Complx, MathStat, DataMngr, Charting, Crt;

procedure MenuVario(var Spread: TSpread);

implementation
{$ELSE}

uses MathTool, Complex, MathStat, DataMngr, Charting, Crt;

{$ENDIF}

procedure Base;
var
  fine: integer;
begin
  ClrScr;
  Writeln('BASE');
  repeat
    writeln;
    writeln;
    GetSiNo('Vuoi proseguire? ', fine);
  until fine=0;
end;

(* Plot function *)
function f(x: PREC): PREC; far;
begin
  f:= x*exp(-x);
end;

procedure FChart;
var
  Chart: TF_XChart;
begin
  ClrScr;
  Writeln('Grafico f(X)');
  writeln;
  with Chart do begin
    Init;
    Title1:= 'Grafico f(x):= x*exp(-x)';
    Title2:= '';
    TitleX:= '';
    TitleY:= '';
    Options:= JoinDot + ShowXAx + ShowYAx + ShwGrdX+ ShwGrdY;
    Run(f, 0,10,0);
  end;
end;

(* TRACCIA DI CARDIOIDE *)
function fx(a: PREC): PREC; far;
begin
  fx:= (1 - COS(A)) * COS(A);
end;
function fy(a: PREC): PREC; far;
begin
  FY:= (1 - COS(A)) * SIN(A);
end;
procedure Card;
var
  Chart: TParamChart;
begin
  ClrScr;
  Writeln('Grafico Cardoide');
  writeln;
  with Chart do begin
    Init;
    Title1:= '';
    Title2:= '';
    TitleX:= '';
    TitleY:= '';
    Options:= JoinDot;
    Run(fx, fy, 0,2*pi,0);
  end;
end;

procedure CostoRicetta;
var
  i, N: integer;
  S, C, U, F, R, P: PREC;
  fine: integer;
begin
  fine:= 1;
  repeat
    ClrScr;
    Writeln('COSTO DI UNA RICETTA');
    writeln;
    N:= 0;
    InputInt('NUMERO DI INGREDIENTI (0=FINE): ', N, 0, 100);
    if n = 0 then exit;
    c:= 0; u:= 0; f:= 0; r:= 0;
    FOR I:= 1 TO N do begin
      Writeln('INGREDIENTE ', I:3, ':');
      InputPrec('PREZZO D''ACQUISTO: ', C, 0, inf);
      InputPrec('QUANTITA'' ACQUISTATA: ', U, 0, inf);
      InputPrec('NUMERO DI UNITA'' DELLA RICETTA PER UNITA'' D''ACQUISTO: ', F, 0, inf);
      InputPrec('QUANTITA'' UTILIZZATA NELLA RICETTA: ', R, 0, inf);
      P:= P + C / U / F * R;
    end;
    ClrScr;
    S:= 1;
    repeat
      InputPrec('NUMERO DI PORZIONI: ', S, 0, inf);
      Writeln;
      Writeln('SPESA TOTALE PER PREPARARE 1 RICETTA     : ', p:12:0);
      Writeln('COSTO DI UNA PORZIONE                    : ', (P / S):12:0);
      Writeln;
      writeln;
      GetSiNo('Vuoi cambiare numero di porzioni? ', fine);
    until fine=0;
    writeln;
    GetSiNo('Vuoi proseguire con un''altra ricetta? ', fine);
  until fine=0;
end;

procedure ConvRadDeg;
var
  fine: integer;
  A, D1, D, R: PREC;
  AnM, AnP, AnS: PREC;
begin
  ClrScr;
  Writeln('CONVERSIONE DI ANGOLI: DA RADIANTI IN GRADI');
  r:= 0;
  repeat
    writeln;
    InputPrec('ANGOLO IN RADIANTI (0 PER FINIRE): ', R, -inf, inf);
    IF R = 0 THEN EXIT;
    A:= Rad2Deg * R * 3600;
    D:= INT(A / 3600);
    D1:= INT(D / 360);
    AnM:= D - 360 * D1; if abs(AnM) < Zero then AnM:= 0;
    AnP:= INT((A - D * 3600) / 60);
    AnS:= INT(100 * (A - D * 3600 - (INT((A - D * 3600) / 60)) * 60)) / 100;
    writeln(' ',AnM:4:0,'ø ',AnP:2:0,''' ',AnS:5:2,'"');
    writeln;
    GetSiNo('Vuoi proseguire? ', fine);
  until fine=0;
end;

procedure ConvDegRad;
var
  fine: integer;
  a, r, g, m, s: PREC;
begin
  ClrScr;
  Writeln('CONVERSIONE DI ANGOLI: GRADI IN RADIANTI');
  g:= 0; m:= 0; s:= 0;
  repeat
    writeln;
    InputPrec('GRADI (0 PER FINIRE): ', G, -inf, inf);
    IF G = 0 then exit;
    InputPrec('MINUTI              : ', M, 0, 60);
    InputPrec('SECONDI             : ', S, 0, 60);
    A:= G + M / 60 + S / 3600;
    R:= INT(A / 360);
    Writeln('RADIANTI = ', (A * Deg2Rad - R * (2*PI)):9:6);
    writeln;
    GetSiNo('Vuoi proseguire? ', fine);
  until fine=0;
end;

procedure ProTri;
var
  X, i, dg: integer;
  A, L: array[1..3] of PREC;
  c: PREC;
  procedure pr_ala;
  begin
    InputPrec('INSERIRE ANGOLO: ', A[1], 0, inf);
    InputPrec('INSERIRE LATO  : ', L[3], 0, inf);
    InputPrec('INSERIRE ANGOLO: ', A[2], 0, inf);
    A[1]:= A[1] * C;
    A[2]:= A[2] * C;
    A[3]:= PI - A[1] - A[2];
    L[1]:= L[3] * sin(A[1]) / sin(A[3]);
    L[2]:= L[3] * sin(A[2]) / sin(A[3]);
  end;
  procedure pr_lal;
  begin
    InputPrec('INSERIRE LATO  : ', L[3], 0, inf);
    InputPrec('INSERIRE ANGOLO: ', A[1], 0, inf);
    InputPrec('INSERIRE LATO  : ', L[2], 0, inf);
    A[1]:= A[1] * C;
    L[1]:= sqrt(sqr(L[3]) + sqr(L[2]) - 2 * L[3] * L[2] * cos(A[1]));
    A[2]:= sin(A[1]) / L[1] * L[2];
    A[2]:= ArcTan(A[2] / sqrt(1 - A[2] * A[2]));
    A[3]:= PI - A[1] - A[2];
  end;
  procedure pr_aal;
  begin
    InputPrec('INSERIRE ANGOLO: ', A[3], 0, inf);
    InputPrec('INSERIRE ANGOLO: ', A[2], 0, inf);
    InputPrec('INSERIRE LATO  : ', A[2], 0, inf);
    A[3]:= A[3] * C;
    A[2]:= A[2] * C;
    A[1]:= PI - A[2] - A[3];
    L[1]:= L[3] * sin(A[1]) / sin(A[3]);
    L[2]:= L[3] * sin(A[2]) / sin(A[3]);
  end;
  procedure pr_lla;
  var y, t: PREC;
  begin
    InputPrec('INSERIRE LATO  : ', L[1], 0, inf);
    InputPrec('INSERIRE LATO  : ', L[2], 0, inf);
    InputPrec('INSERIRE ANGOLO: ', A[1], 0, inf);
    A[1]:= A[1] * C;
    T:= L[2] * sin(A[1]);
    IF L[1] < T THEN begin
      A[1]:= -1;
    end
    else begin
      L[3]:= sqrt(sqr(L[2]) - sqr(T));
      IF L[1] > T THEN begin
        Y:= sqrt(sqr(L[1]) - sqr(T));
        L[3]:= L[3] + Y;
      end;
      A[2]:= sin(A[1]) / L[1] * L[2];
      A[2]:= ArcTan(A[2] / sqrt(1 - A[2] * A[2]));
      A[3]:= PI - A[1] - A[2];
    end;
  end;
  procedure pr_lll;
  begin
    InputPrec('INSERIRE LATO: ', L[1], 0, inf);
    InputPrec('INSERIRE LATO: ', L[2], 0, inf);
    InputPrec('INSERIRE LATO: ', L[3], 0, inf);
    A[1]:= (sqr(L[2]) + sqr(L[3]) - sqr(L[1])) * 0.5 / L[2] / L[3];
    A[1]:= -ArcTan(A[1] / sqrt(1 - A[1] * A[1])) + 0.5*PI;
    A[2]:= sin(A[1]) / L[1] * L[2];
    A[2]:= ArcTan(A[2] / sqrt(1 - A[2] * A[2]));
    A[3]:= PI - A[1] - A[2];
  end;
  procedure Show;
  var
    flg, i: integer;
  begin
    writeln;
    flg:= 0;
    for i:= 1 to 3 do if A[i]<0 then flg:= 1;
    if flg = 0 then begin
      FOR I:= 1 TO 3 do begin
        writeln('LATO ', I, '         = ', L[I]:12:4);
        write('ANGOLO OPPOSTO = ', (A[I] / C):12:4);
        if dg = 1 then writeln(' GRADI') else writeln(' RADIANTI');
      end;
    end
    else begin
      writeln;
      writeln('SOLUZIONE IMPOSSIBILE');
    end;
  end;
begin
  ClrScr;
  Writeln('PARTI DI UN TRIANGOLO');
  dg:= 1; GetSiNo('Angoli in gradi (S/N)? ', Dg);
  if dg = 1 then C:= 0.0174532927 else c:= 1;
  x:= 0;
  repeat
    for i:= 1 to 3 do begin
      A[i]:= 0; L[i]:= 0;
    end;
    writeln;
    writeln('DI UN TRIANGOLO DOVE A= ANGOLO, L= LUNGHEZZA DEL LATO');
    writeln('TIPI DI PROBLEMI: 0= fine, 1=ALA, 2=LAL, 3=AAL,  4=LLA, 5=LLL');
    writeln;
    InputInt('TIPO DI PROBLEMA: ', X, 0, 5);
    case x of
      0: break;
      1: begin pr_ala; Show; end;
      2: begin pr_lal; Show; end;
      3: begin pr_aal; Show; end;
      4: begin pr_lla; Show; end;
      5: begin pr_lll; Show; end;
    end;
  until false;
end;

procedure ConvCoor;
var
  x: integer;
  procedure PolCar;
  (* CONVERTE COORDINATE POLARI IN COORDINATE CARTESIANE *)
  var
    r, a: PREC;
    c: TComplex;
  begin
    r:= 0; a:= 0;
    InputPrec('RAGGIO        : ', R, 0, inf);
    InputPrec('ANGOLO (GRADI): ', A, 0, inf); a:= a * Deg2Rad;
    CompMF(c, r, a);
    writeln('X = ', C.Re:12:4);
    writeln('Y = ', C.Im:12:4);
  end;
  procedure CarPol;
  (* CONVERTE COORDINATE CARTESIANE IN COORDINATE POLARI *)
  var
    c: TComplex;
  begin
    C.Re:= 0; C.Im:= 0;
    InputPrec('ASCISSA : ', C.Re, -inf, inf);
    InputPrec('ORDINATA: ', C.Im, -inf, inf);
    writeln('Raggio = ', CompMod(C):12:5);
    writeln('Angolo = ', CompFas(C)*Rad2Deg:12:5);
  end;
begin
  ClrScr;
  Writeln('CONVERSIONE DI COORDINATE');
  x:= 0;
  repeat
    writeln;
    writeln(' 1 = CARTESIANE IN POLARI');
    writeln(' 2 = POLARI IN CARTESIANE');
    writeln(' 0 = FINE ');
    writeln;
    InputInt('Quale? ', x, 0, 2);
    writeln;
    case x of
      0: break;
      1: CarPol;
      2: PolCar;
    end;
  until false;
end;

procedure MenuVario(var Spread: TSpread);
var ch: char;
begin
  normal;
  repeat
    ClrScr;
    Write('  Vari-Import Package Ver. 1.à - CopyRight 1994 by Enrico Croce - ');
    {$IFDEF USE87}
      writeln(' 80x87 ON');
    {$ELSE}
      writeln(' 80x87 OFF');
    {$ENDIF}
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Torna al menu principale          |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Fchart                            |                                      |');
    writeln('| 2. Cardoide                          |                                      |');
    writeln('| 3. Costo di una ricettta             |                                      |');
    writeln('| 4. Da radianti a gradi               |                                      |');
    writeln('| 5. Da gradi a radianti               |                                      |');
    writeln('| 6. Problemi su triangoli             |                                      |');
    writeln('| 7. Conversioni Polare<->Cartesiano   |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
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
      '1': FChart;
      '2': Card;
      '3': CostoRicetta;
      '4': ConvRadDeg;
      '5': ConvDegRad;
      '6': ProTri;
      '7': ConvCoor;
      'L': Spread.LoadData;
      'S': Spread.SaveData;
      'Z': Spread.GetData;
      'X': Spread.Show(ord('A'), ord('Z'), 0, 0);
    end;
  until ch = '0';
  ClrScr;
end;

{$IFNDEF UNIT}
var
  Spread: PSpread;
begin
  New(Spread, Init);
  MenuVario(Spread^);
{$ENDIF}
end.
