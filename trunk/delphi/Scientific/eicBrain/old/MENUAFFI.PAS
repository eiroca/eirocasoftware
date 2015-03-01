{$I switches.inc}
{ UNDEF UNIT}

{$IFDEF UNIT}
unit MenuAffi;

interface

uses MathTool, MathStat, DataMngr, DistrObj, DistMngr, Charting, Crt;

procedure MenuAffidabilita(var Spread: TSpread);

implementation
{$ELSE}

uses MathTool, MathStat, DataMngr, DistrObj, DistMngr, Charting, Crt;

{$ENDIF}

procedure Serie;
var
  ch: char;
  F: PSerieDistrib;
  t: PREC;
begin
  ClrScr;
  writeln('Affidabilit… di una serie di componenti indipendenti');
  writeln;
  F:= MakeSerie;
  writeln;
  t:= 1;
  repeat
    InputPrec('Valore di t: ', t, -Inf, Inf);
    writeln('Valore R(t) serie: ', 1-F^.FCum(t):12:4);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  Dispose(F, Done);
end;

procedure Parallelo;
var
  ch: char;
  F: PParalDistrib;
  t: PREC;
begin
  ClrScr;
  writeln('Affidabilit… di un parallelo di componenti indipendenti');
  writeln;
  F:= MakeParal;
  writeln;
  t:= 1;
  repeat
    InputPrec('Valore di t: ', t, -Inf, Inf);
    writeln('Valore R(t) serie: ', 1-F^.FCum(t):12:4);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  Dispose(F, Done);
end;

procedure Affidabilita;
var
  ch: char;
  F: PContDistrib;
  Step, i: integer;
  t: PREC;
  YesFlag: integer;
  X, Y: PSerie;
  MinX, MaxX, Dlt: PREC;
  Chart: PScatChart;
begin
  ClrScr;
  writeln('Affidabilit… di un componente');
  writeln;
  F:= MakeCDis;
  writeln;
  t:= 1;
  repeat
    InputPrec('Valore di t: ', t, -Inf, Inf);
    writeln('Valore R(t) serie: ', 1-F^.FCum(t):12:4);
    writeln;
    write(' RETURN continua con altri parametri, altro esce: ');
    ch:= readkey; if ch = #0 then readkey;
    GotoXY(1, WHEREY); clreol;
  until ch <> #13;
  writeln;
  YesFlag:= 1;
  GetSiNo('Vuoi un grafico? ', YesFlag);
  if YesFlag = 1 then begin
    MinX:= 0;
    MaxX:= 100;
    InputPrec('Minimo valore di t: ', MinX, -Inf, Inf);
    InputPrec('Massimo valore di t: ', MaxX, MinX, Inf);
    writeln('Working...');
    if MaxX = MinX then MaxX:= MaxX+1;
    X:= New(PSerie, Init(MaxData)); Y:= New(PSerie, Init(MaxData));
    Step:= MaxData;
    Dlt:= (MaxX - MinX) / (Step-1);
    t:= MinX;
    for i:= 1 to Step do begin
      X^.At(i)^:= t; Y^.At(i)^:= 1-F^.FCum(t);
      t:= t + Dlt;
    end;
    Chart:= New(PScatChart, Init);
    with Chart^ do begin
      Title1:= 'Affidabilit… del sistema';
      SerieX:= X;
      SerieY[1]:= Y;
      NumSer:= 1;
      NumDat:= Step;
      Options:= JoinDot + ShowXAx + ShowYAx + ShwGrdX + ShwGrdY;
      Run(nil);
    end;
    Dispose(Chart, Done);
    Dispose(X, Done);
    Dispose(Y, Done);
  end;
  Dispose(F, Done);
end;

procedure AffSisBo;
var
  fine: integer;
  i, n: integer;
  U, A, Z, T: PREC;
begin
  ClrScr;
  Writeln('AFFIDABILITA'' DI UN SISTEMA');
  repeat
    writeln;
    t:= 0;
    InputPrec('TEMPO DI FUNZIONAMENTO IN ORE (0 PER FINIRE): ', T, 0, inf);
    IF T = 0 THEN exit;
    n:= 1;
    InputInt('NUMERO DI COMPONENTI: ', N, 1, 100);
    Z:= 0;
    A:= 0; U:= 0;
    FOR I:= 1 TO N do begin
      writeln('COMPONENTE ', I);
      InputPrec('TEMPO MEDIO DI USURA : ', U, 0, inf);
      InputPrec('TASSO MEDIO DI AVARIE: ', A, 0, inf);
      (*  OGNI COMPONENTE INTERVIENE NEL CALCOLO DELL'AFFIDABILITA' *)
      Z:= Z + 1 / U + A;
    end;
    writeln;
    (*  CALCOLA L'AFFIDABILITA' E LA STAMPA *)
    Z:= EXP(-Z * T);
    writeln('AFFIDABILITA'' DEL SISTEMA = ', Z:12:4);
    writeln;
    GetSiNo('Vuoi proseguire? ', fine);
  until fine=0;
end;

procedure MenuAffidabilita(var Spread: TSpread);
var ch: char;
begin
  repeat
    normal;
    ClrScr;
    Write('  Statistical Package Ver. 1.à - CopyRight 1994 by Enrico Croce - ');
    {$IFDEF USE87}
      writeln(' 80x87 ON');
    {$ELSE}
      writeln(' 80x87 OFF');
    {$ENDIF}
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Torna al menu principale          |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Serie di componenti               | A. Affidabilit… serie Weibull?       |');
    writeln('| 2. Parallelo di componenti           |                                      |');
    writeln('| 3. Affidabilit… di un componente     |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
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
      '1': Serie;
      '2': Parallelo;
      '3': Affidabilita;
      'A': AffSisBo;
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
  MenuAffidabilita(Spread^);
{$ENDIF}
end.
