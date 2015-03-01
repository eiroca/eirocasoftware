{$I switches.inc}
{$UNDEF UNIT}

{$IFDEF UNIT}
unit MenuStat;

interface

uses MathStat, MathTool, DataMngr,
     ExpSmoot, HpQuaLat, HpEspFat, HpStat,
     TrasfU2d,
     MenuDist, MenuMath, MenuGraf, MenuRgAn, MenuIpot, MenuPCA, MenuAffi,
     Crt;

procedure Bayessiane(var Spread: TSpread);
procedure PrintInfo(var Spread: TSpread);

procedure MenuStatPack(var Spread: TSpread);
procedure MenuMoreStat(var Spread: TSpread);

implementation
{$ELSE}
uses MathStat, MathTool, DataMngr,
     ExpSmoot, HpQuaLat, HpEspFat, HpStat,
     TrasfU2d,
     MenuDist, MenuMath, MenuGraf, MenuRgAn, MenuIpot, MenuPCA, MenuAffi,
     Crt;
{$ENDIF}

procedure PrintInfo(var Spread: TSpread);
var
  yn, ch: char;
  Risultati: TResult;
begin
  ClrScr;
  writeln('Visualizzazione dati salienti rilevazioni');
  writeln;
  if (Spread.CountSerie = 0) then begin
    writeln('Spiacente ma non ci sono serie valide da analizzare');
    writeln('Inseriscile con gli appositi comandi e poi analizzale pure.');
    WaitReturn;
    exit;
  end;
  Spread.GetSerie(ch);
  if ch = #0 then exit;
  writeln;
  ComputeMedVar(Spread.Cols[ch]^, Risultati);
  ClrScr;
  writeln('Analisi serie ',ch);
  writeln('Numero delle rilevazioni         : ', Spread.Cols[ch]^.Count:9);
  writeln('Media aritmetica                 : ', Risultati[media]:15:5);
  writeln('Scarto quadratico medio          : ', Risultati[scarto]:15:5);
  writeln('Varianza                         : ', Risultati[varianza]:15:5);
  writeln('Scarto quadratico medio corretto : ', Risultati[scartocorr]:15:5);
  writeln('Varianza corretta                : ', Risultati[varianzacorretta]:15:5);
  writeln('Coefficiente di varizione        : ', Risultati[coefvar]:15:5);
  writeln('Minimo                           : ', Risultati[minim]:15:5);
  writeln('Massimo                          : ', Risultati[maxim]:15:5);
  writeln('Escursione (range)               : ', Risultati[range]:15:5);
  writeln('Mediana                          : ', Risultati[mediana]:15:5);
  writeln('Moda                             : ', Risultati[moda]:15:5);
  writeln('Primo quartile                   : ', Risultati[quart1]:15:5);
  writeln('Terzo quartile                   : ', Risultati[quart3]:15:5);
  writeln('Range Interquartile IQR          : ', Risultati[IQR]:15:5);
  writeln('Media geometrica                 : ', Risultati[mediageo]:15:5);
  writeln('Deviazione geometrica            : ', Risultati[devgeo]:15:5);
  writeln('Media armonica                   : ', Risultati[mediarm]:15:5);
  writeln;
  WaitReturn;
end;

procedure Bayessiane(var Spread: TSpread);
var
  mu, si: PREC;
  mu2, si2: PREC;
  av, vr: PREC;
  n: TInt;
  cheat: boolean;
  serie : char;
  ch    : char;
begin
  ClrScr;
  writeln('Stime bayessiane');
  writeln;
  mu:= 0; si:= 1;
  InputPrec('Media presupposta = ',mu,-inf,inf);
  InputPrec('Scarto presupposto= ',si,0,inf);
  cheat:= false;
  if Spread.CountSerie = 0 then begin
    writeln;
    GetChar('Non ci sono dati inseriti, ne vuoi inserire (S/N)?', ch);
    if ch = 'S' then begin
      Spread.Show(ord('A'), ord('Z'), 0, 0);
      ClrScr;
    end;
    cheat:= (Spread.CountSerie = 0);
  end
  else begin
    GetChar('Vuoi immettere direttamenti i risultati campionari (S/N)? ', ch);
    cheat:= (ch='S');
  end;
  if cheat then begin
    writeln;
    av:= 0; vr:= 1; n:= 1;
    InputPrec('Media  campionaria = ',av,-inf,inf);
    InputPrec('Scarto campionario = ',vr,0,inf);
    InputInt('Numerosita'' camp.  = ',n,0,maxint);
  end
  else begin
    write('Scegli la serie campionaria. ');
    Spread.GetSerie(Serie);
    if Serie = #0 then exit;
    CalcAveVar(Spread.Cols[Serie]^, av, vr, true);
    n:= Spread.Cols[Serie]^.Count;
  end;
  StimaBayessiana(mu, si, av, vr, n, mu2, si2);
  ClrScr;
  writeln('Stime bayessiane');
  writeln;
  writeln('A priori si presupponeva che ');
  writeln('media = æ = ', mu:15:5);
  writeln('varia.= å = ', si:15:5);
  writeln;
  writeln('Il campione di ',n,' elementi ha fornito i seguenti dati');
  writeln('media     = ', av:15:5);
  writeln('varia.    = ', vr:15:5);
  writeln('numerosit…= ',  n:10  );
  writeln;
  writeln('A posteriori si puo'' dedurre che:');
  writeln('media = æ = ', mu2:15:5);
  writeln('varia.= å = ', si2:15:5);
  writeln;
  WaitReturn;
end;

procedure MenuMoreStat(var Spread: TSpread);
var ch : char;
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
    writeln('| Y. Stime Bayesiane                   | ?. Informazioni statistiche su serie |');
    writeln('|                                      |                                      |');
    writeln('| Q. Quadrati Latini                   | F. Esprerimenti fattoriali           |');
    writeln('|                                      |                                      |');
    writeln('| E. Exponential Smoothing             |                                      |');
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
      '?': PrintInfo(Spread);
      'Y': Bayessiane(Spread);
      'E': MenuExpSmooth(Spread);
      'Q': HpQuaLatMain;
      'F': HpEspFatMain;
      'L': Spread.LoadData;
      'S': Spread.SaveData;
      'Z': Spread.GetData;
      'X': Spread.Show(ord('A'), ord('Z'), 0, 0);
    end;
  until ch = '0';
  ClrScr;
end;

procedure MenuStatPack(var Spread: TSpread);
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
    writeln('| 0. Finisce programma                 |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('| A. Menu ANOVA - Analisi var. medie...| R. Menu Regressioni...               |');
    writeln('|                                      |                                      |');
    writeln('| H. Fit di dati a var. stat. teoriche | G. Grafici...                        |');
    writeln('|                                      |                                      |');
    writeln('| T. Trasformaz. Dist. Uniforme in 2D  | I. Interv. fiducia, test ipotesi...  |');
    writeln('|                                      |                                      |');
    writeln('| M. Operazioni matematico/matriciali..| N. Altre funzioni statistiche...     |');
    writeln('|                                      |                                      |');
    writeln('| F. Affidabilit…                      | P. P.C.A.                            |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      | MemAvail: ',MemAvail:10,'                 |');
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
      'A': MenuAnova(Spread);
      'R': MenuRegressioni(Spread);
      'M': MenuMathMisc(Spread);
      'H': HpStatMain(Spread);
      'G': MenuGrafici(Spread);
      'T': Trasfor2DUnif;
      'I': MenuTestStatistici(Spread);
      'N': MenuMoreStat(Spread);
      'F': MenuAffidabilita(Spread);
      'P': MenuDoPCA(Spread);
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
  MenuStatPack(Spread^);
{$ENDIF}
end.
