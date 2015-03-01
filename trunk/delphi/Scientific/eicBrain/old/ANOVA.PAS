{$I switches.inc}

unit ANOVA;

interface

uses DataMngr;

procedure ANOVA1(var Spread: TSpread);
procedure ANOVA2(var Spread: TSpread);
procedure ANOVA3(var Spread: TSpread);
procedure ANOVA4(var Spread: TSpread);

implementation

uses Matrix, MatrMath, MathTool, MathStat, MathStt1, Crt, SmlPrs;

procedure ANOVA1(var Spread: TSpread);
const
  ORG_MED = 1;
  ORG_GRP = 2;
  ORG_ERR = 3;
  ORG_TOT = 4;
type
  comp = (GL, SS, MS, FC, FT);
var
  m, n : integer;
  X: TSMatrix;
  i, j : integer;
  s, t: PREC;
  AN : array[comp,1..10] of PREC;
  LivFid: PREC;
  YesNo: integer;
  sr: char;
begin
  ClrScr;
  Writeln('ANOVA');
  writeln('Analisi della Varianza di un insieme di osservazioni prelevate da una');
  writeln('popolazione che segue una distribuzione Normale con varianza costante.');
  writeln('Analisi delle sole colonne (gruppi)');
  writeln;
  m:= 1; n:= 1;
  InputInt('Quante righe? ',m,1,maxint);
  InputInt('Quante colonne? ',n,1,maxint);
  (* Crea le matrici necessarie *)
  X.Init(1, m, n);
  (* Input dei dati *)
  writeln;
  YesNo:= 0;
  GetSiNo('Immissione dati diretta (S/N)? ' ,YesNo);
  if YesNo <> 0 then begin
    for i:= 1 to n do begin
      writeln('Colonna #',i);
      for j:= 1 to m do begin
        s:= 0;
        write('Riga #',j:3,' valore = '); InputPrec('', S, -inf,inf);
        X.At(j, i)^:= S;
      end;
    end;
  end
  else begin
    for i:= 1 to n do begin
      writeln('Colonna #',i, ' Scegliere la serie da collegare');
      Spread.GetSerie(sr);
      if sr = #0 then exit;
      for j:= 1 to m do begin
        X.At(j, i)^:= Spread.Cols[sr]^.At(j)^;
      end;
    end;
  end;
  writeln;
  YesNo:= 0;
  GetSiNo('Vuoi l''indiazione delle medie (S/N)?', YesNo);
  if YesNo <> 0 then begin
    for j:= 1 to n do begin
      S:= 0;
      for i:= 1 to m do begin
        S:= S + X.At(i, j)^;
      end;
      Writeln('Colonna #',j,' media = ',(S/m):10:3);
    end;
    T:= 0;
    for j:= 1 to m do begin
      S:= 0;
      for i:= 1 to n do begin
        S:= S + X.At(j, i)^;
      end;
      T:= T + S;
      Writeln('Riga #',j,' media = ',(S/n):10:3);
    end;
    Writeln('Grande Media = ',(T/(n*m)):10:3);
    WaitReturn;
  end;
  (* Esegue i calcoli *)
  S:= 0;
  for j:= 1 to n do begin
    for i:= 1 to m do begin
      S:= S + X.At(i, j)^;
    end;
  end;
  AN[GL, ORG_MED]:= 1; AN[SS, ORG_MED]:= sqr(S) / (m*n);
  T:= 0;
  for j:= 1 to n do begin
    S:= 0;
    for i:= 1 to m do begin
      S:= S + X.At(i, j)^;
    end;
    T:= T + sqr(S);
  end;
  AN[GL, ORG_GRP]:= pred(n); AN[SS, ORG_GRP]:= (T / m) - AN[SS, ORG_MED];
  S:= 0;
  for j:= 1 to n do begin
    for i:= 1 to m do begin
      S:= S + sqr(X.At(i,j)^);
    end;
  end;
  AN[GL, ORG_TOT]:= n*m; AN[SS, ORG_TOT]:= S;
  AN[GL, ORG_ERR]:= AN[GL, ORG_TOT] - AN[GL, ORG_MED] - AN[GL, ORG_GRP];
  AN[SS, ORG_ERR]:= AN[SS, ORG_TOT] - AN[SS, ORG_MED] - AN[SS, ORG_GRP];
  for i:= ORG_MED to ORG_TOT do begin
    if AN[GL, i] < Zero then AN[MS, i]:= Zero
    else AN[MS, i]:= AN[SS, i] / AN[GL, i];
  end;
  LivFid:= GetLivFid;
  for i:= ORG_MED to pred(ORG_ERR) do begin
    if AN[MS, ORG_ERR] < ZERO then AN[FC, i]:= 999999.999 else AN[FC, i]:= AN[MS, i] / AN[MS, ORG_ERR];
    AN[FT, i]:= FisherXVal(LivFid, AN[GL, i], AN[GL, ORG_ERR]);
  end;
  writeln;
  writeln('     Tavola della varianza   (Livello di Fiducia = ',LivFid*100:6:3,'%)');
  writeln('------------------------------------------------------------------------------');
  writeln('| Origine/Fattore  | G.L. |     SS     |     MS     |   F calc.  | F teorica |');
  writeln('------------------------------------------------------------------------------');
  writeln('| Media            | ',AN[GL, ORG_MED]:4:0,' | ',AN[SS, ORG_MED]:10:3,' | ',
     AN[MS, ORG_MED]:10:3,' | ',AN[FC, ORG_MED]:10:3,' | ',AN[FT, ORG_MED]:9:3,' |');
  writeln('| Tra i gruppi (Cl)| ',AN[GL, ORG_GRP]:4:0,' | ',AN[SS, ORG_GRP]:10:3,' | ',
     AN[MS, ORG_GRP]:10:3,' | ',AN[FC, ORG_GRP]:10:3,' | ',AN[FT, ORG_GRP]:9:3,' |');
  writeln('| Errore sperim.   | ',AN[GL, ORG_ERR]:4:0,' | ',AN[SS, ORG_ERR]:10:3,' | ',
     AN[MS, ORG_ERR]:10:3,' |            |           |');
  writeln('------------------------------------------------------------------------------');
  writeln('| Totali           | ',AN[GL, ORG_TOT]:4:0,' | ',AN[SS, ORG_TOT]:10:3,' |            |            |           |');
  writeln('------------------------------------------------------------------------------');
  writeln;
  writeln('se F calc > F teorica NON si puo'' rifiutare la significativita'' del fattore');
  writeln('F teorica e'' cosi'' calcolata:');
  writeln('  gradi liberta'' numeratore   = gradi_liberta_fattore_in_esame');
  writeln('  gradi liberta'' denominatore = gradi_liberta_errore');
  writeln('  posizione                   = 1 - livello_di_fiducia');
  WaitReturn;
  X.Done;
end;

procedure ANOVA2(var Spread: TSpread);
const
  ORG_MED = 1;
  ORG_GRP = 2;
  ORG_BLK = 3;
  ORG_ERR = 4;
  ORG_TOT = 5;
type
  comp = (GL, SS, MS, FC, FT);
var
  m, n : integer;
  X: TSMatrix;
  i, j : integer;
  s, t: PREC;
  AN : array[comp,1..10] of PREC;
  LivFid: PREC;
  YesNo: integer;
  sr: char;
begin
  ClrScr;
  Writeln('ANOVA 2');
  writeln('Analisi della Varianza di un insieme di osservazioni prelevate da una');
  writeln('popolazione che segue una distribuzione Normale con varianza costante.');
  writeln('Analisi delle righe (trattamenti) e delle colonne (gruppi)');
  writeln;
  m:= 1; n:= 1;
  InputInt('Quante righe? ',m,1,maxint);
  InputInt('Quante colonne? ',n,1,maxint);
  (* Crea le matrici necessarie *)
  X.Init(1, m, n);
  (* Input dei dati *)
  writeln;
  YesNo:= 0;
  GetSiNo('Immissione dati diretta (S/N)? ',YesNo);
  if YesNo <> 0 then begin
    for i:= 1 to n do begin
      writeln('Colonna #',i);
      for j:= 1 to m do begin
        s:= 0;
        write('Riga #',j:3,' valore = '); InputPrec('',S,-inf,inf);
        X.At(j, i)^:= S;
      end;
    end;
  end
  else begin
    for i:= 1 to n do begin
      writeln('Colonna #',i, ' Scegliere la serie da collegare');
      Spread.GetSerie(sr);
      if sr = #0 then exit;
      for j:= 1 to m do begin
        X.At(j, i)^:= Spread.Cols[sr]^.At(j)^;
      end;
    end;
  end;
  writeln;
  YesNo:= 0;
  GetSiNo('Vuoi l''indicazione delle medie (S/N)?', YesNo);
  if YesNo <> 0 then begin
    for j:= 1 to n do begin
      S:= 0;
      for i:= 1 to m do begin
        S:= S + X.At(i, j)^;
      end;
      Writeln('Colonna #',j,' media = ',(S/m):10:3);
    end;
    T:= 0;
    for j:= 1 to m do begin
      S:= 0;
      for i:= 1 to n do begin
        S:= S + X.At(j, i)^;
      end;
      T:= T + S;
      Writeln('Riga #',j,' media = ',(S/n):10:3);
    end;
    Writeln('Grande Media = ',(T/(n*m)):10:3);
    WaitReturn;
  end;
  (* Esegue i calcoli *)
  S:= 0;
  for j:= 1 to n do begin
    for i:= 1 to m do begin
      S:= S + X.At(i, j)^;
    end;
  end;
  AN[GL, ORG_MED]:= 1; AN[SS, ORG_MED]:= sqr(S) / (m*n);
  T:= 0;
  for j:= 1 to n do begin
    S:= 0;
    for i:= 1 to m do begin
      S:= S + X.At(i, j)^;
    end;
    T:= T + sqr(S);
  end;
  AN[GL, ORG_GRP]:= pred(n); AN[SS, ORG_GRP]:= (T / m) - AN[SS, ORG_MED];
  T:= 0;
  for i:= 1 to m do begin
    S:= 0;
    for j:= 1 to n do begin
      S:= S + X.At(i, j)^;
    end;
    T:= T + sqr(S);
  end;
  AN[GL, ORG_BLK]:= pred(m); AN[SS, ORG_BLK]:= (T / n) - AN[SS, ORG_MED];
  S:= 0;
  for j:= 1 to n do begin
    for i:= 1 to m do begin
      S:= S + sqr(X.At(i,j)^);
    end;
  end;
  AN[GL, ORG_TOT]:= n*m; AN[SS, ORG_TOT]:= S;
  AN[GL, ORG_ERR]:= AN[GL, ORG_TOT] - AN[GL, ORG_MED] - AN[GL, ORG_GRP] - AN[GL, ORG_BLK];
  AN[SS, ORG_ERR]:= AN[SS, ORG_TOT] - AN[SS, ORG_MED] - AN[SS, ORG_GRP] - AN[SS, ORG_BLK];
  for i:= ORG_MED to ORG_TOT do begin
    if AN[GL, i] < Zero then AN[MS, i]:= Zero
    else AN[MS, i]:= AN[SS, i] / AN[GL, i];
  end;
  LivFid:= GetLivFid;
  for i:= ORG_MED to pred(ORG_ERR) do begin
    if AN[MS, ORG_ERR] < ZERO then AN[FC, i]:= 999999.999 else AN[FC, i]:= AN[MS, i] / AN[MS, ORG_ERR];
    AN[FT, i]:= FisherXVal(LivFid, AN[GL, i], AN[GL, ORG_ERR]);
  end;
  writeln;
  writeln('     Tavola della varianza   (Livello di fiducia = ',LivFid*100:7:3,'%)');
  writeln('------------------------------------------------------------------------------');
  writeln('| Origine/Fattore  | G.L. |     SS     |     MS     |   F calc.  | F teorica |');
  writeln('------------------------------------------------------------------------------');
  writeln('| Media            | ',AN[GL, ORG_MED]:4:0,' | ',AN[SS, ORG_MED]:10:3,' | ',
     AN[MS, ORG_MED]:10:3,' | ',AN[FC, ORG_MED]:10:3,' | ',AN[FT, ORG_MED]:9:3,' |');
  writeln('| Tra i gruppi (Cl)| ',AN[GL, ORG_GRP]:4:0,' | ',AN[SS, ORG_GRP]:10:3,' | ',
     AN[MS, ORG_GRP]:10:3,' | ',AN[FC, ORG_GRP]:10:3,' | ',AN[FT, ORG_GRP]:9:3,' |');
  writeln('| Tra i blokki (Rw)| ',AN[GL, ORG_BLK]:4:0,' | ',AN[SS, ORG_BLK]:10:3,' | ',
     AN[MS, ORG_BLK]:10:3,' | ',AN[FC, ORG_BLK]:10:3,' | ',AN[FT, ORG_BLK]:9:3,' |');
  writeln('| Errore sperim.   | ',AN[GL, ORG_ERR]:4:0,' | ',AN[SS, ORG_ERR]:10:3,' | ',
     AN[MS, ORG_ERR]:10:3,' |            |           |');
  writeln('------------------------------------------------------------------------------');
  writeln('| Totali           | ',AN[GL, ORG_TOT]:4:0,' | ',AN[SS, ORG_TOT]:10:3,' |            |            |           |');
  writeln('------------------------------------------------------------------------------');
  writeln;
  writeln('se F calc > F teorica NON si puo'' rifiutare la significativita'' del fattore');
  writeln('F teorica e'' cosi'' calcolata:');
  writeln('  gradi liberta'' numeratore   = gradi_liberta_fattore_in_esame');
  writeln('  gradi liberta'' denominatore = gradi_liberta_errore');
  writeln('  posizione                   = 1 - livello_di_fiducia');
  WaitReturn;
  X.Done;
end;

procedure ANOVA3(var Spread: TSpread);
const
  ORG_MED = 1;
  ORG_GRP = 2;
  ORG_BLK = 3;
  ORG_REP = 4;
  ORG_ERR = 5;
  ORG_TOT = 6;
type
  comp = (GL, SS, MS, FC, FT);
var
  m, n, z : integer;
  X: array[0..10] of TSMatrix; (* 0 e' media altri *)
  i, j, k : integer;
  s, t: PREC;
  AN : array[comp,1..10] of PREC;
  LivFid: PREC;
  YesNo: integer;
  sr: char;
begin
  ClrScr;
  Writeln('ANOVA 3');
  writeln('Analisi della Varianza di un insieme di osservazioni prelevate da una');
  writeln('popolazione che segue una distribuzione Normale con varianza costante.');
  writeln('- Analisi delle righe (trattamenti) e delle colonne (gruppi).');
  writeln('- Analisi ulteriore sulle replicazioni');
  writeln;
  writeln;
  m:= 1; n:= 1; z:= 1;
  InputInt('Quante righe? ',m,1,maxint);
  InputInt('Quante colonne? ',n,1,maxint);
  InputInt('Quante replicazioni? ',z,1,10);
  if (z > 10) and (z <2) then begin
    writeln('Spiacente le replicazioni devono essere >2, ma <= a 10');
    WaitReturn;
    exit;
  end;
  writeln;
  (* Crea le matrici necessarie *)
  YesNo:= 0;
  GetSiNo('Immissione dati diretta (S/N)? ', YesNo);
  X[0].Init(1, m, n);
  for i:= 1 to n do
    for j:= 1 to m do
      X[0].At(j, i)^:= 0;
  for k:= 1 to z do begin
    X[k].Init(1, m, n);
    (* Input dei dati *)
    writeln('Replicazione #',k:3);
    for i:= 1 to n do begin
      writeln('Colonna #',i);
      if YesNo <> 0 then begin
        for j:= 1 to m do begin
          S:= 0;
          write('Riga #',j:3,' valore = '); InputPrec('',S,-inf,inf);
          X[k].At(j, i)^:= S;
          X[0].At(j, i)^:= X[0].At(j, i)^ + S;
        end;
      end
      else begin
        Spread.GetSerie(sr);
        if sr = #0 then exit;
        for j:= 1 to m do begin
          s:= Spread.Cols[sr]^.At(j)^;
          X[k].At(j, i)^:= S;
          X[0].At(j, i)^:= X[0].At(j, i)^ + S;
        end;
      end;
    end;
  end;
  writeln;
  YesNo:= 0;
  GetSiNo('Vuoi l''indiazione delle medie (S/N)?', YesNo);
  if YesNo <> 0 then begin
    for k:= 0 to z do begin
      write('Medie ');
      if k = 0 then
        writeln('per medie replicazioni')
      else
        writeln('per la replicazione #',k:3);
      for j:= 1 to n do begin
        S:= 0;
        for i:= 1 to m do begin
          S:= S + X[k].At(i, j)^;
        end;
        Writeln('Colonna #',j,' media = ',(S/m):10:3);
      end;
      T:= 0;
      for j:= 1 to m do begin
        S:= 0;
        for i:= 1 to n do begin
          S:= S + X[k].At(j, i)^;
        end;
       T:= T + S;
         Writeln('Riga #',j,' media = ',(S/n):10:3);
      end;
      Writeln('Grande Media = ',(T/(n*m)):10:3);
      WaitReturn;
    end;
  end;
  (* Esegue i calcoli *)
  S:= 0;
  for k:= 1 to z do begin
    for j:= 1 to n do begin
      for i:= 1 to m do begin
        S:= S + X[k].At(i, j)^;
      end;
    end;
  end;
  AN[GL, ORG_MED]:= 1; AN[SS, ORG_MED]:= sqr(S) / (m*n*z);
  T:= 0;
  for j:= 1 to n do begin
    S:= 0;
    for i:= 1 to m do begin
      for k:= 1 to z do begin
        S:= S + X[k].At(i, j)^;
      end;
    end;
    T:= T + sqr(S);
  end;
  AN[GL, ORG_GRP]:= pred(n); AN[SS, ORG_GRP]:= (T / (m*z)) - AN[SS, ORG_MED];
  T:= 0;
  for i:= 1 to m do begin
    S:= 0;
    for j:= 1 to n do begin
      for k:= 1 to z do begin
        S:= S + X[k].At(i, j)^;
      end;
    end;
    T:= T + sqr(S);
  end;
  AN[GL, ORG_BLK]:= pred(m); AN[SS, ORG_BLK]:= (T / (n*z)) - AN[SS, ORG_MED];
  T:= 0;
  for i:= 1 to m do begin
    for j:= 1 to n do begin
      T:= T + sqr(X[0].At(i,j)^);
    end;
  end;
  AN[GL, ORG_REP]:= pred(n) * pred(m);
  AN[SS, ORG_REP]:= (T / (z)) - AN[SS, ORG_BLK] - AN[SS, ORG_GRP] - AN[SS, ORG_MED];
  S:= 0;
  for j:= 1 to n do begin
    for i:= 1 to m do begin
      for k:= 1 to z do begin
        S:= S + sqr(X[k].At(i,j)^);
      end;
    end;
  end;
  AN[GL, ORG_TOT]:= z*n*m; AN[SS, ORG_TOT]:= S;
  AN[GL, ORG_ERR]:= AN[GL, ORG_TOT] - AN[GL, ORG_MED] - AN[GL, ORG_GRP] - AN[GL, ORG_BLK] - AN[GL, ORG_REP];
  AN[SS, ORG_ERR]:= AN[SS, ORG_TOT] - AN[SS, ORG_MED] - AN[SS, ORG_GRP] - AN[SS, ORG_BLK] - AN[SS, ORG_REP];
  for i:= ORG_MED to ORG_TOT do begin
    if AN[GL, i] < Zero then AN[MS, i]:= Zero
    else AN[MS, i]:= AN[SS, i] / AN[GL, i];
  end;
  LivFid:= GetLivFid;
  for i:= ORG_MED to pred(ORG_ERR) do begin
    if AN[MS, ORG_ERR] < ZERO then AN[FC, i]:= 999999.999 else AN[FC, i]:= AN[MS, i] / AN[MS, ORG_ERR];
    AN[FT, i]:= FisherXVal(LivFid, AN[GL, i], AN[GL, ORG_ERR]);
  end;
  writeln;
  writeln;
  writeln('     Tavola della varianza   (Livello di fiducia = ',LivFid*100:7:3,'%)');
  writeln('------------------------------------------------------------------------------');
  writeln('| Origine/Fattore  | G.L. |     SS     |     MS     |   F calc.  | F teorica |');
  writeln('------------------------------------------------------------------------------');
  writeln('| Media            | ',AN[GL, ORG_MED]:4:0,' | ',AN[SS, ORG_MED]:10:3,' | ',
     AN[MS, ORG_MED]:10:3,' | ',AN[FC, ORG_MED]:10:3,' | ',AN[FT, ORG_MED]:9:3,' |');
  writeln('| Tra i gruppi (Cl)| ',AN[GL, ORG_GRP]:4:0,' | ',AN[SS, ORG_GRP]:10:3,' | ',
     AN[MS, ORG_GRP]:10:3,' | ',AN[FC, ORG_GRP]:10:3,' | ',AN[FT, ORG_GRP]:9:3,' |');
  writeln('| Tra i blokki (Rw)| ',AN[GL, ORG_BLK]:4:0,' | ',AN[SS, ORG_BLK]:10:3,' | ',
     AN[MS, ORG_BLK]:10:3,' | ',AN[FC, ORG_BLK]:10:3,' | ',AN[FT, ORG_BLK]:9:3,' |');
  writeln('| Interazioni (REP)| ',AN[GL, ORG_REP]:4:0,' | ',AN[SS, ORG_REP]:10:3,' | ',
     AN[MS, ORG_REP]:10:3,' | ',AN[FC, ORG_REP]:10:3,' | ',AN[FT, ORG_REP]:9:3,' |');
  writeln('| Errore sperim.   | ',AN[GL, ORG_ERR]:4:0,' | ',AN[SS, ORG_ERR]:10:3,' | ',
     AN[MS, ORG_ERR]:10:3,' |            |           |');
  writeln('------------------------------------------------------------------------------');
  writeln('| Totali           | ',AN[GL, ORG_TOT]:4:0,' | ',AN[SS, ORG_TOT]:10:3,' |            |            |           |');
  writeln('------------------------------------------------------------------------------');
  writeln;
  writeln('se F calc > F teorica NON si puo'' rifiutare la significativita'' del fattore');
  writeln('F teorica e'' cosi'' calcolata:');
  writeln('  gradi liberta'' numeratore   = gradi_liberta_fattore_in_esame');
  writeln('  gradi liberta'' denominatore = gradi_liberta_errore');
  writeln('  posizione                   = 1 - livello_di_fiducia');
  WaitReturn;
  (* Esegue i calcoli per un'analisi senza tenere conto delle ripetizioni *)
  S:= 0;
  for j:= 1 to n do begin
    for i:= 1 to m do begin
      X[0].At(i, j)^:= X[0].At(i, j)^ / z;
      (* In X[0] c'era la somma, ora c'e' la media delle ripetizioni *)
      S:= S + X[0].At(i, j)^;
    end;
  end;
  AN[GL, ORG_MED]:= 1; AN[SS, ORG_MED]:= sqr(S) / (m*n);
  T:= 0;
  for j:= 1 to n do begin
    S:= 0;
    for i:= 1 to m do begin
      S:= S + X[0].At(i, j)^;
    end;
    T:= T + sqr(S);
  end;
  AN[GL, ORG_GRP]:= pred(n); AN[SS, ORG_GRP]:= (T / m) - AN[SS, ORG_MED];
  T:= 0;
  for i:= 1 to m do begin
    S:= 0;
    for j:= 1 to n do begin
      S:= S + X[0].At(i, j)^;
    end;
    T:= T + sqr(S);
  end;
  AN[GL, ORG_BLK]:= pred(m); AN[SS, ORG_BLK]:= (T / n) - AN[SS, ORG_MED];
  S:= 0;
  for j:= 1 to n do begin
    for i:= 1 to m do begin
      S:= S + sqr(X[0].At(i,j)^);
    end;
  end;
  AN[GL, ORG_TOT]:= n*m; AN[SS, ORG_TOT]:= S;
  AN[GL, ORG_ERR]:= AN[GL, ORG_TOT] - AN[GL, ORG_MED] - AN[GL, ORG_GRP] - AN[GL, ORG_BLK];
  AN[SS, ORG_ERR]:= AN[SS, ORG_TOT] - AN[SS, ORG_MED] - AN[SS, ORG_GRP] - AN[SS, ORG_BLK];
  for i:= ORG_MED to ORG_TOT do begin
    AN[MS, i]:= AN[SS, i] / AN[GL, i];
  end;
  for i:= ORG_MED to pred(ORG_ERR) do begin
    if AN[MS, ORG_ERR] < ZERO then AN[FC, i]:= 999999.999 else AN[FC, i]:= AN[MS, i] / AN[MS, ORG_ERR];
    AN[FT, i]:= FisherXVal(LivFid, AN[GL, i], AN[GL, ORG_ERR]);
  end;
  writeln;
  writeln('     Tavola della varianza   (Livello di fiducia = ',LivFid*100:7:3,'%)');
  writeln('------------------------------------------------------------------------------');
  writeln('| Origine/Fattore  | G.L. |     SS     |     MS     |   F calc.  | F teorica |');
  writeln('------------------------------------------------------------------------------');
  writeln('| Media            | ',AN[GL, ORG_MED]:4:0,' | ',AN[SS, ORG_MED]:10:3,' | ',
     AN[MS, ORG_MED]:10:3,' | ',AN[FC, ORG_MED]:10:3,' | ',AN[FT, ORG_MED]:9:3,' |');
  writeln('| Tra i gruppi (Cl)| ',AN[GL, ORG_GRP]:4:0,' | ',AN[SS, ORG_GRP]:10:3,' | ',
     AN[MS, ORG_GRP]:10:3,' | ',AN[FC, ORG_GRP]:10:3,' | ',AN[FT, ORG_GRP]:9:3,' |');
  writeln('| Tra i blokki (Rw)| ',AN[GL, ORG_BLK]:4:0,' | ',AN[SS, ORG_BLK]:10:3,' | ',
     AN[MS, ORG_BLK]:10:3,' | ',AN[FC, ORG_BLK]:10:3,' | ',AN[FT, ORG_BLK]:9:3,' |');
  writeln('| Errore sperim.   | ',AN[GL, ORG_ERR]:4:0,' | ',AN[SS, ORG_ERR]:10:3,' | ',
     AN[MS, ORG_ERR]:10:3,' |            |           |');
  writeln('------------------------------------------------------------------------------');
  writeln('| Totali           | ',AN[GL, ORG_TOT]:4:0,' | ',AN[SS, ORG_TOT]:10:3,' |            |            |           |');
  writeln('------------------------------------------------------------------------------');
  writeln;
  WaitReturn;
  for i:= 0 to z do X[i].Done;
end;

procedure ANOVA4(var Spread: TSpread);
type
  FatRec  = record
    Ser: char;
    Cur: PREC;
    Liv: integer;
    SS : PREC;
    MS : PREC;
    Tot: PREC;
    Cnt: integer;
    Sum: PREC;
    Num: integer;
  end;
const MaxFat = 10;
var
  stmp: string[10];
  k, j, i, fat: integer;
  LivFat: array[0..MaxFat] of FatRec;
  LivFid: PREC;
  X: TSMatrix;
  A: TSMatrix;
  s, b: TSVector;
  APos: TIVector;
  Piv: PIVector;
  ch: char;
  min, max, tmp, AveTot: PREC;
  Sum, Cur: PREC;
  SSTot, SSAve, SSReg, SSAdd, SSInt, SSErr: PREC;
  dfTot,               dfAdd, dfInt, dfErr: integer;
                       MSAdd, MSInt, MSErr: PREC;
  Liv, Num: integer;
  flg: boolean;
  rw: integer;
  pr: PPREC;
  function CalcF(MS, MSErr: PREC): string;
  var tmp: string;
  begin
    if MSErr < Zero then tmp:='          ' else str(MS/MSErr:10:3, tmp);
    CalcF:= tmp;
  end;
  function CalcFt(x0,x1,x2: PREC): PREC;
  begin
    if (abs(x1)>Zero) and (abs(x2)>Zero) then CalcFT:= FisherXVal(x0,x1,x2)
    else CalcFt:= 0;
  end;
label Redo;
begin
  ClrScr;
  Writeln('ANOVA ++');
  writeln('Analisi della Varianza di un insieme di osservazioni prelevate da una');
  writeln('popolazione che segue una distribuzione Normale con varianza costante.');
  writeln('Analisi delle multi fattori, anche sbilanciate');
  writeln;
  fat:= 2;
  str(MaxFat, stmp);
  InputInt('Quanti fattori (da 2 a '+stmp+')? ',fat,2,MaxFat);
  (* Input dei dati *)
  writeln;
  dfTot:= Spread.CountSerie;
  if (fat > MaxFat) then begin
    writeln('Spiacente! al massimo ',MaxFat,' fattori.');
    writeln;
    WaitReturn;
    exit;
  end;
  if (dfTot < fat+1) then begin
    writeln('Spiacente! devi immettere almeno ',fat+1,' colonne di dati');
    writeln('col il formato  Liv_Fat1 Liv_Fat2 ... Liv_Fatn RisopstaSperim');
    writeln;
    WaitReturn;
    exit;
  end;
  for i:= 1 to fat do begin
  Redo:
    writeln;
    writeln('Fattore ',chr(64+i), ' Scegliere la serie da collegare');
    Spread.GetSerie(ch);
    if ch = #0 then exit;
    for j:= i-1 downto 1 do begin
      if LivFat[j].Ser = ch then begin
        writeln('Gi… usata');
        Goto ReDo;
      end;
    end;
    if i>1 then begin
      if Spread.Cols[LivFat[i-1].Ser]^.Count <> Spread.Cols[ch]^.Count then begin
        writeln('Le colonne devono avere la stessa numerosit…');
        Goto ReDo;
      end;
    end;
    LivFat[i].Ser:= ch;
  end;
  writeln;
  repeat
    writeln('Colonna del risultato sperimentale');
    Spread.GetSerie(ch);
    if ch = #0 then exit;
    LivFat[0].Ser:= ch;
    if Spread.Cols[LivFat[1].Ser]^.Count = Spread.Cols[ch]^.Count then break;
  until false;
  dfTot:= Spread.Cols[LivFat[0].Ser]^.Count;
  if dfTot < 2 then begin
    writeln('Spiacente servono alemeno 2 dati!');
    WaitReturn;
    exit;
  end;
  writeln('Making data...');
  X.Init(1,dfTot,fat+1);
  for i:= 1 to fat do begin
    LivFat[i].Cnt:= 0;
    Spread.SelectCol(LivFat[i].Ser);
    for j:= 1 to dfTot do begin
      X.At(j, i)^:= Spread.Get(j)^;
    end;
  end;
  Spread.SelectCol(LivFat[0].Ser);
  LivFat[0].Cnt:= 0;
  for j:= 1 to dfTot do begin
    X.At(j, fat+1)^:= Spread.Get(j)^;
  end;

  writeln('Computing average and SS...');
  SMatSortRow(X, fat);
  SSTot:= 0; Sum:= 0;
  min:= X.At(1, fat+1)^; max:= min;
  for j:= 1 to dfTot do begin
    tmp:= X.At(j, fat+1)^;
    SStot:= SSTot + sqr(tmp);
    Sum:= Sum + tmp;
    if tmp > max then max:= tmp
    else if tmp < min then min:= tmp;
  end;
  AveTot:= Sum / dfTot;
  SSAve:= AveTot * Sum;
  writeln('Computing SSreg data...');
  SMatSortRows(X);
  for i:= 1 to fat do begin
    with LivFat[i] do begin
      Cur:= X.At(1, i)^;
    end;
  end;
  Sum:= 0; SSReg:= 0; Num:= 0;
  for j:= 1 to dfTot do begin
    tmp:= X.At(j, fat+1)^;
    flg:= true; (* true if a replication with same factor *)
    for i:= 1 to fat do begin
      if X.At(j, i)^ <> LivFat[i].Cur then begin
        LivFat[i].Cur:= X.At(j, i)^;
        flg:= false;
      end;
    end;
    if flg then begin
      Sum:= Sum + tmp; inc(Num);
    end
    else begin
      SSReg:= SSReg + sqr(Sum) / Num;
      Num:= 1; Sum:= tmp;
    end;
  end;
  SSReg:= SSReg + sqr(Sum)/Num;
  writeln('Computing factor effect...');
  for i:= 1 to fat do begin
    with LivFat[i] do begin
      SMatSortRow(X, i-1);
      Cur:= X.At(1, i)^;
      Liv:= 1;
      SS := 0;
      Tot:= 0;
      Cnt:= 0;
      Sum:= 0;
      Num:= 0;
      for j:= 1 to dfTot do begin
        tmp:= X.At(j, fat+1)^;
        if X.At(j, i)^ = Cur then begin
          Sum:= Sum + tmp; inc(Num);
        end
        else begin
          SS:= SS + sqr(Sum) / Num;
          Tot:= Tot + Sum;
          inc(Cnt, Num);
          inc(Liv);
          Num:= 1; Sum:= tmp;
          Cur:= X.At(j,i)^;
        end;
        X.At(j, i)^:= Liv;
      end;
      SS:= SS + sqr(Sum) / Num;
      Tot:= Tot + Sum;
      inc(Cnt, Num);
    end;
  end;
  APos.Init(1,fat);
  writeln('Computing additive model...');
  Liv:= 0;
  for i:= 1 to fat do begin
    APos.At(i)^:= Liv;
    inc(Liv, LivFat[i].Liv);
  end;
  LivFat[0].Liv:= Liv;
  A.Init(1,Liv, Liv); b.Init(1,Liv); s.Init(1,Liv);
  for i:= 1 to Liv do begin
    for j:= 1 to Liv do begin
      A.At(i,j)^:= 0;
    end;
  end;
  for i:= 1 to fat do begin
    for j:= 1 to dfTot do begin
      rw:= APos.At(i)^ + trunc(X.At(j, i)^);
      pr:= b.At(rw); pr^:= pr^ + X.At(j, fat+1)^;
      for k:= 1 to fat do begin
        pr:= A.At(rw, APos.At(k)^+trunc(X.At(j, k)^));
        pr^:= pr^+1;
      end;
    end;
  end;
  Piv:= nil;
  SolvSing(A, b, s);
  SSAdd:= 0; dfAdd:= Liv-fat;
  dfInt:= 1;
  for i:= 1 to fat do begin
    dfInt:= dfInt * (LivFat[i].Liv-1);
  end;
  for i:= 1 to Liv do begin
    SSAdd:= SSAdd + b.At(i)^ * s.At(i)^;
  end;
  A.Done; b.Done; s.Done;

  SSErr:= SSTot - SSReg;
  dfErr:= dfTot-1-dfInt-dfAdd;
  if dfErr = 0 then MSErr:= 0 else MSErr:= SSErr / dfErr;
  if MSErr <= Zero then MSErr:= 0;
  if fat = 2 then begin (* better approx. *)
    tmp:= LivFat[1].SS;
    LivFat[1].SS:= SSAdd - LivFat[2].SS; (* A = (A+B+m)-(B+m) *)
    LivFat[2].SS:= SSAdd - tmp;
  end
  else begin
    for i:= 1 to fat do begin
      with LivFat[i] do begin
        SS:= SS - SSAve;
      end;
    end;
  end;
  for i:= 1 to fat do begin
    with LivFat[i] do begin
      MS:= SS/(Liv-1);
    end;
  end;
  LivFid:= GetLivFid;
  writeln;
  writeln('     Tavola della varianza   (Livello di fiducia = ',LivFid*100:7:3,'%)');
  writeln('------------------------------------------------------------------------------');
  writeln('| Origine/Fattore  | G.L. |     SS     |     MS     |   F calc.  | F teorica |');
  writeln('------------------------------------------------------------------------------');
  writeln('| Media            | ',1:4,' | ',SSAve:10:3,' | ', SSAve:10:3,' |            |           |');
  for i := 1 to fat do begin
    with LivFat[i] do begin
      writeln('| Fattore ',chr(64+i),'        | ',Liv-1:4,' | ',SS:10:3,' | ', MS:10:3,' | ',
        CalcF(MS,MSErr),' | ',CalcFt(LIvFid, Liv-1, dfErr):9:3,' |');
    end;
  end;
  SSInt:= SSReg-SSAdd;
  MSInt:= SSInt/dfInt;
  writeln('| Iterazioni       | ',dfInt:4,' | ',SSInt:10:3,' | ', MSInt:10:3,' | ',CalcF(MSInt, MSErr),' | ',
    CalcFt(LIvFid, dfInt, dfErr):9:3,' |');
  writeln('| Residuo          | ',dfErr:4,' | ',SSErr:10:3,' | ', MSErr:10:3,' |            |           |');
  writeln('------------------------------------------------------------------------------');
  writeln('| Totali           | ',dfTot:4,' | ',SSTot:10:3,' |            |            |           |');
  writeln('------------------------------------------------------------------------------');
  writeln;
  writeln('SS Modello completo = ', SSReg:12:0,' ',(dfTot-dfErr):5);
  writeln('SS Corretto         = ', (SSTot-SSAve):12:0, ' ',dfTot-1:5);
  writeln('SS modello additivo = ', (SSAdd):12:0, ' ',dfAdd:5);
  writeln;
  WaitReturn;
end;

end.
