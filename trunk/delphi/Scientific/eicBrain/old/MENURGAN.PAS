{$I switches.inc}
{ UNDEF UNIT}

{$IFDEF UNIT}
unit MenuRgAn;

interface

uses Matrix, MathTool, MathStat, DataMngr, Anova, Regress, Crt;

procedure MenuRegressioni(var Spread: TSpread);
procedure MenuAnova(var Spread: TSpread);

implementation
{$ELSE}

uses Matrix, MathTool, MathStat, DataMngr, Anova, Regress, Crt;

{$ENDIF}

procedure TassoMedio;
var
  g, a, a1, t, s0, s1, v, l, tmp: PREC;
  S: TSVector;
  fine, i, n: integer;
begin
  repeat
    ClrScr;
    Writeln('TASSO MEDIO DI CRESCITA E PROIEZIONI');
    Writeln;
    n:= 0;
    InputInt('NUMERO DI OSSERVAZIONI ANNUALI RACCOLTE (0=FINE): ', N, 0, 2000);
    if n = 0 then exit;
    S.Init(1,n);
    writeln;
    FOR I:= 1 TO N do begin
      tmp:= 1;
      Write('Dato[', I:3,'] = '); InputPrec('', tmp, 0, inf);
      S.At(i)^:= tmp;
    end;
    (* INIZIALIZZA LE VARIABILI PER IL PRIMO ANNO *)
    T:= ln(S.At(1)^);
    V:= 0;
    (* CICLO PER GLI ALTRI ANNI *)
    IF N > 1 THEN begin
      FOR I:= 2 TO N do begin
        L:= ln(S.At(I)^);
        T:= T + L;
        V:= V + (I - 1) * L;
      end;
    end;
    (* CALCOLA IL TASSO MEDIO DI CRESCITA *)
    A:= 6 * (2 * V / (N - 1) - T) / (N) / (N + 1);
    G:= EXP(A) - 1;
    ClrScr;
    Writeln;
    Writeln('TASSO MEDIO DI CRESCITA = ', (INT(G * 10000 + 0.5) / 100):6:2, ' %');
    writeln;
    (* CALCOLA LA CRESCITA ANNUALE MEDIA *)
    S0:= EXP(T / N - A * (N - 1) / 2);
    writeln;
    Writeln('INSERIRE 0 PER FINIRE');
    repeat
      writeln;
      A1:= 0;
      InputPrec('PROIEZIONE VENDITE PER L''ANNO ', A1, 0, inf);
      IF A1 = 0 THEN break;
      S1:= S0 * Pow((1 + G),(A1 - 1));
      Writeln('PROIEZIONE = ', S1:12:2);
    until false;
    writeln;
    GetSiNo('Vuoi proseguire con nuovi dati? ', fine);
    S.Done;
  until fine=0;
end;

procedure MenuAnova(var Spread: TSpread);
var ch : char;
begin
  normal;
  repeat
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
    writeln('| 1. ANOVA 1 solo fattore              | C. Calcolo coeff. correlazione lin.  |');
    writeln('| 2. ANOVA 2 fattori (riga/col)        | Q. Regressione Lineare (modo clas.)  |');
    writeln('| 3. ANOVA 3 fattori (riga/col/rep)    | R. Regressione Lineare Multipla      |');
    writeln('|                                      |                                      |');
    writeln('| 4. ANOVA++                           |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('| A. Tasso Medio                       |                                      |');
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
      '1': ANOVA1(Spread);
      '2': ANOVA2(Spread);
      '3': ANOVA3(Spread);
      '4': ANOVA4(Spread);
      'C': CorLin(Spread);
      'R': RegLinMul(Spread);
      'Q': RegLin(Spread);
      'A': TassoMedio;
      'L': Spread.LoadData;
      'S': Spread.SaveData;
      'Z': Spread.GetData;
      'X': Spread.Show(ord('A'), ord('Z'), 0, 0);
    end;
  until ch = '0';
  ClrScr;
end;

procedure MenuRegressioni(var Spread: TSpread);
begin
  MenuAnova(Spread);
end;

{$IFNDEF UNIT}
var
  Spread: PSpread;
begin
  New(Spread, Init);
  MenuAnova(Spread^);
{$ENDIF}
end.
