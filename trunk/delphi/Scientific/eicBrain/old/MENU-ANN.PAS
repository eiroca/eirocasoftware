{$I switches.inc}
{$UNDEF UNIT}

{$IFDEF UNIT}
unit MenuANN;

interface

uses Matrix, DataMngr, MathTool, PLN, Dos, Crt;

procedure MenuNeuNet(var Spread: TSpread);

implementation
{$ELSE}

uses Matrix, DataMngr, MathTool, PLN, Dos, Crt;

{$ENDIF}

procedure RunPLN(var Spread: TSpread);
var
  i, j, m, n: integer;
  Num, Usd: integer;
  P: integer;
  ch: char;
  X,Y: TSVector;
  xs,ys: array[1..MaxSamSize] of char;
  PLN: TPLN;
  tmp, ri,ro,et,lm,ep: PREC;
  f: text;
  same: boolean;
  kind: integer;
label Redo1, Redo2, Redo3;
procedure Output(s: string);
begin
  if s='' then begin
    writeln(f);
    writeln;
  end
  else begin
    write(f, s);
    write(s);
  end;
end;
begin
  ClrScr;
  writeln('Progressive Learning NetWork');
  writeln;
  m:= 1; n:= 1;
  InputInt('Dimensione vettore input : ',n,1,MaxSamSize);
  InputInt('Dimensione vettore output: ',m,1,MaxSamSize);
  X.Init(1,n);
  Y.Init(1,m);
  writeln('Immissione colonne dei dati di input');
  for i:= 1 to n do begin
  Redo1:
    Spread.GetSerie(ch);
    if ch = #0 then exit;
    xs[i]:= ch;
    if i = 1 then Num:= Spread.Cols[ch]^.Count
    else begin
      if Num <> Spread.Cols[ch]^.Count then begin
        writeln('Errore: la serie non e'' valida');
        WaitReturn;
        goto Redo1;
      end;
    end;
  end;
  writeln('Immissione colonne dei dati di input');
  for i:= 1 to m do begin
  Redo2:
    Spread.GetSerie(ch);
    if ch = #0 then exit;
    ys[i]:= ch;
    if Num <> Spread.Cols[ch]^.Count then begin
      writeln('Errore: la serie non e'' valida');
      WaitReturn;
      goto Redo2;
    end;
  end;
  ch:= 'T';
  Usd:= Num;
  GetChar('Uso tutti i dati oppure solo una parte (T/P)? ', ch);
  if UpCase(ch)='P' then begin
    InputInt('Quanti dati vuoi usare? ',Usd,1,Num);
  end;
  et:= 0;
  ep:= 0;
  ri:= 0;
  ro:= 0;
  lm:= 5;
  InputPrec('RoX, risoluzione input : ', ri, 0, 1000);
  InputPrec('RoY, risoluzione output: ', ro, 0, 1000);
  InputPrec('eta, fattore di dimenticanza (0=nesuna): ', et, 0, 1000);
  InputPrec('eps, soglia di eliminazione: ', ep, 0, 1000);
  InputPrec('lmd, lmd*RoO livello per merge: ', lm, 0, 1000);
  PLN.Init(n, m, ri, ro, et, ep, lm);
  for i:= 1 to usd do begin
    for j:= 1 to n do begin
      X.At(j)^:= Spread.Cols[xs[j]]^.At(i)^;
    end;
    for j:= 1 to m do begin
      Y.At(j)^:= Spread.Cols[ys[j]]^.At(i)^;
    end;
    PLN.Learn(X, Y);
  end;
  writeln('Fase di richiamo');
  same:= false;
  kind:= 0;
  if Usd = Num then begin
    usd:= 1;
    writeln('Immissione colonne dei dati di input da richiamare');
    same:= true;
    for i:= 1 to n do begin
    Redo3:
      Spread.GetSerie(ch);
      if ch = #0 then exit;
      if xs[i] <> ch then begin
        xs[i]:= ch;
        same:= false;
      end;
      if Num <> Spread.Cols[ch]^.Count then begin
        writeln('Errore: la serie non e'' valida');
        WaitReturn;
        goto Redo3;
      end;
    end;
    if same then begin
      ch:= 'S';
      GetChar('Immetto i dati nelle colonne di output degli input (S/N)? ', ch);
      ch:= UpCase(ch);
      if ch ='S' then begin
        ch:= 'E';
        GetChar('Inserisco i valori Previsti o l''errore Assoluto o Relativo (P/A/R)? ', ch);
        ch:= Upcase(ch);
        case ch of
          'P': Kind:= 1;
          'A': Kind:= 2;
          'R': Kind:= 3;
          else KInd:= 1;
        end;
      end;
    end;
  end
  else inc(usd);
  InputInt('Numero PE da considerare x l''output (0=tutti): ', P, 0, Num);
  assign(f, 'output.dat');
  rewrite(f);
  write(f,'Descrizione della rete W, V, S');
  close(f);
  PLN.W^.Print('output.dat',0,0,0,PLN.K,n);
  PLN.V^.Print('output.dat',0,0,0,PLN.K,m);
  PLN.S^.Print('output.dat',0,0,0,PLN.K);
  append(f);
  ClrScr;
  Output('Richiamo di dati da PLN');
  Output('');
  for i:= Usd to Num do begin
    Output('I: ');
    for j:= 1 to n do begin
      tmp:= Spread.Cols[xs[j]]^.At(i)^;
      X.At(j)^:= tmp;
      Output(DynaOut(tmp));
    end;
    Output('');
    PLN.Recall(X, Y, P);
    Output('O: ');
    for j:= 1 to m do begin
      tmp:= Y.At(j)^;
      Output(DynaOut(tmp));
      case Kind of
       1: Spread.Cols[ys[j]]^.At(i)^:= tmp;
       2: Spread.Cols[ys[j]]^.At(i)^:= abs(Spread.Cols[ys[j]]^.At(i)^ - tmp);
       3: Spread.Cols[ys[j]]^.At(i)^:= abs((Spread.Cols[ys[j]]^.At(i)^ - tmp)/Spread.Cols[ys[j]]^.At(i)^);
      end;
    end;
    Output('');
  end;
  close(f);
  writeln('done.');
  WaitReturn;
end;

procedure MenuNeuNet(var Spread: TSpread);
var ch: char;
begin
  repeat
    normal;
    ClrScr;
    Write('Neural Network Package  V.1.à  - CopyRight 1996 by Enrico Croce - ');
    {$IFDEF USE87}
      writeln(' 80x87 ON');
    {$ELSE}
      writeln(' 80x87 OFF');
    {$ENDIF}
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Torna al menu principale          |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Progressive Learning Network      |                                      |');
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
      '1': RunPLN(Spread);
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
  MenuNeuNet(Spread^);
{$ENDIF}
end.
