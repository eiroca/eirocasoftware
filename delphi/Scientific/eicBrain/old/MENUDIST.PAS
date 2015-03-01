{$I switches.inc}
{ UNDEF UNIT}

{$IFDEF UNIT}
unit MenuDist;

interface

procedure MenuDistC;
procedure MenuDistD;
procedure MenuDistr;

implementation
{$ENDIF}

uses Crt, DistMngr;

procedure MenuDistC;
var ch : char;
begin
  repeat
    ClrScr;
    Writeln(' Distribuzioni continue teoriche Ver. 1.à  - CopyRight 1994 by Enrico Croce - ');
    writeln('+-----------------------------------------------------------------------------+');
    writeln('| 0. Torna al menu principale          |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Distribuzione Uniforme continua   | !. Distribuzione Inversa Uniforme    |');
    writeln('| 2. Distribuzione Normale             | ". Distribuzione Inversa Normale     |');
    writeln('| 3. Distribuzione Log-Normale         | œ. Distribuzione Inversa Log-Normale |');
    writeln('| 4. Distribuzione Esponenziale        | $. Distribuzione Inversa Esponenz.   |');
    writeln('| 5. Distribuzione Gamma               | %. Distribuzione Inversa Gamma       |');
    writeln('| 6. Distribuzione Weibull             | &. Distribuzione Inversa Weibull     |');
    writeln('| 7. Distribuzione T-Student           | /. Distribuzione Inversa TStudent    |');
    writeln('| 8. Distribuzione Chi Quadro          | (. Distribuzione Inversa Chi Quadro  |');
    writeln('| 9. Distribuzione Fischer             | ). Distribuzione Inversa Fisher      |');
    writeln('| A. Distribuzione Beta                | B. Distribuzione Inversa Beta        |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('+-----------------------------------------------------------------------------+');
    writeln('| Quale e'' la tua scelta?                                                     |');
    write  ('+-----------------------------------------------------------------------------+');
    GotoXY(27, WhereY - 1);
    ch:= readkey; if ch = #0 then readkey;
    ch:= UpCase(ch);
    case ch of
      '1': DistCUni(false);
      '!': DistCUni(true);
      '2': DistNorm(false);
      '"': DistNorm(true);
      '3': DistLogN(false);
      'œ': DistLogN(true);
      '4': DistExpo(false);
      '$': DistExpo(true);
      '5': DistGamm(false);
      '%': DistGamm(true);
      '6': DistWeib(false);
      '&': DistWeib(true);
      '7': DistTStu(false);
      '/': DistTStu(true);
      '8': DistChiQ(false);
      '(': DistChiQ(true);
      '9': DistFish(false);
      ')': DistFish(true);
      'A': DistBeta(false);
      'B': DistBeta(true);
    end;
  until ch = '0';
  ClrScr;
end;

procedure MenuDistD;
var ch : char;
begin
  repeat
    ClrScr;
    Writeln('  Distribuzioni discrete teoriche Ver. 1.à - CopyRight 1994 by Enrico Croce - ');
    writeln('+-----------------------------------------------------------------------------+');
    writeln('| 0. Torna al menu principale          |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Distribuzione Uniforme Discreta   | !. Distribuzione Inversa Uniforme    |');
    writeln('| 2. Distribuzione Bernulli            | ". Distribuzione Inversa Bernulli    |');
    writeln('| 3. Distribuzione Binomiale           | œ. Distribuzione Inversa Binomiale   |');
    writeln('| 4. Distribuzione IperGeometrica      | $. Distribuzione Inversa IperGeomet. |');
    writeln('| 5. Distribuzione Poison              | %. Distribuzione Inversa Poisson     |');
    writeln('| 6. Distribuzione Geometrica          | &. Distribuzione Inversa Geometrica  |');
    writeln('| 7. Distribuzione Binomiale Negativa  | /. Distribuzione Inversa Bin. Negat. |');
    writeln('| 8. Distribuzione Somma di Dadi       | (. Distribuzione Inversa Somma Dadi  |');
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
    writeln('+-----------------------------------------------------------------------------+');
    writeln('| Quale e'' la tua scelta?                                                     |');
    write  ('+-----------------------------------------------------------------------------+');
    GotoXY(27, WhereY - 1);
    ch:= readkey; if ch = #0 then readkey;
    ch:= UpCase(ch);
    case ch of
      '1': DistDUni(false);
      '!': DistDUni(true);
      '2': DistBern(false);
      '"': DistBern(true);
      '3': DistBino(false);
      'œ': DistBino(true);
      '4': DistIper(false);
      '$': DistIper(true);
      '5': DistPois(false);
      '%': DistPois(true);
      '6': DistGeom(false);
      '&': DistGeom(true);
      '7': DistBinN(false);
      '/': DistBinN(true);
      '8': DistDice(false);
      '(': DistDice(true);
    end;
  until ch = '0';
  ClrScr;
end;

procedure MenuDistr;
var ch : char;
begin
  repeat
    ClrScr;
    writeln('   Calcoli sulle Distribuzioni Ver. 1.à  - CopyRight 1994 by Enrico Croce - ');
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Torna al menu principale          |                                      |');
    writeln('|                                      |                                      |');
    writeln('| D. Distribuzione Discrete            |                                      |');
    writeln('| C. Distribuzione Continue            |                                      |');
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
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('+-----------------------------------------------------------------------------+');
    writeln('| Quale e'' la tua scelta?                                                     |');
    write  ('+-----------------------------------------------------------------------------+');
    GotoXY(27, WhereY - 1);
    ch:= readkey; if ch = #0 then readkey;
    ch:= UpCase(ch);
    case ch of
      'C': MenuDistC;
      'D': MenuDistD;
    end;
  until ch = '0';
  ClrScr;
end;

{$IFNDEF UNIT}
begin
  MenuDistr;
{$ENDIF}
end.
