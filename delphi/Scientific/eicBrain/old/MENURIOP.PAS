{$I switches.inc}
{$M 32000,64000,256000}
{$UNDEF UNIT}

{$IFDEF UNIT}
unit MenuRiOp;

interface

procedure MenuRiOpPack;

implementation
{$ENDIF}

uses Dos, Crt, Matrix, DataMngr, MathTool,
  PlProg,
  PIBalas,
  SSimplex, RSimplex, SDuaSimp,
  Elect1, Elect2, Elect3,
  MenuGrfi;

procedure ViewSimplesso;
var 
  x: TPL;
  fn: PathStr;
begin
  ClrScr;
  writeln('Simplesso standard');
  fn:= GetFileName;
  if fn <> '' then begin
    x.Init(nil);
    x.Load(fn);
    x.Print;
    x.Done;
  end;
end;  

procedure PlSimplesso;
var 
  ires: integer;
  PL: TSSimplex;
  x: TRow;
  fn: PathStr;
begin
  ClrScr;
  fn:= GetFileName; 
  if fn = '' then exit;
  PL.Init(nil);
  PL.Load(fn);
  PL.Print;
  FillChar(x, sizeof(x), 0);
  ires:= PL.Solv(x);
  PRisult(PL, ires);
  PL.Done;
end;

procedure SolvPIBalas;
var 
  ires: integer;
  PL: TPIBalas;
  x: TIRow;
  FN: PathStr;
begin
  ClrScr;
  fn:= GetFileName;
  if fn = '' then exit;
  PL.Init(nil);
  PL.Load(FN);
  PL.Print;
  FillChar(x, sizeof(x), 0);
  ires:= PL.Solv(x);
  writeln;
  Pl.WriteSol(x);
  WaitReturn;
  Pl.Done;
end;

procedure SolvRSimplex;
var
  i,j,ires: integer;
  PL: TRSimplex;
  x: TRow;
  FN: PathStr;
begin
  ClrScr;
  fn:= GetFileName;
  if fn = '' then exit;
  PL.Init(nil);
  PL.Load(fn);
  PL.Print;
  FillChar(x, sizeof(x), 0);
  ires:= PL.Solv(x);
  writeln;
  writeln('Risultato = ', ires);
  for i:= 1 to PL.NumVin do begin
    j:=Pl.Inbase[i];
    if j <= PL.NumVar then write(Pl.VarNam[j])
    else write('Fitt.#',j);
    writeln(' := ',X[j]:10:4);
  end;
  writeln;
  writeln('z = ', x[0]:10:4);
  WaitReturn;
  writeln('Analisi parametrica o quasi!');
  pl.AnalParmb;
  pl.AnalParmc;
  pl.AnalParmlb;
  pl.AnalParmlc;
  WaitReturn;
end;

procedure SolvSDua;
var
  ires: integer;
  PL: TSDuaSimp;
  x: TRow;
  FName: string;
begin
  PL.Init(nil);
  FNAME:= '';
  InputStr('FileName del P.L. da ottimizzare: ',FNAME);
  PL.Load(FName);
  PL.Print;
  FillChar(x, sizeof(x), 0);
  ires:= PL.Solv(x);
  PRisultD(PL, ires);
  writeln(Pl.Calc(x));
end;

procedure MakeGraph;
var 
  A,B: TSMatrix;
  sd: Prec;
  i, j: integer;
  fn, fo: PathStr;
begin
  ClrScr;
  writeln('Matrice surclassamento sfumata: ');
  writeln;
  fn:= GetFileName; 
  if fn = '' then exit;
  fo:= '';
  InputStr('Filname matrice grafo uscita: ',fo);
  writeln;
  sd:= 0;
  InputPrec('Soglia discriminazione (>0): ',sd,0,inf);
  A.Load(fn);
  B.Init(0,A.Rows,A.Cols);
  for i:= 0 to A.Rows-1 do begin
    for j:= 0 to A.Cols-1 do begin
      if A.At(i,j)^ > sd then B.At(i,j)^:= 1 else B.At(i,j)^:= 0;
    end;
  end;
  B.Print(fo,0,0,0,0,0);
  A.Done;
  B.Done;
end;

procedure MakeDuale;
var
  PL, DPL: TPL;
  fn: PathStr;
begin
  ClrScr;
  fn:= GetFileName; 
  if fn = '' then exit;
  PL.Init(nil);
  DPL.Init(nil);
  PL.Load(fn);
  PL.Duale(DPL);
  fn:= '';
  InputStr('FileName del P.L. duale di output: ',fn);
  DPL.Store(fn);
  PL.Done;
  DPL.Done;
end;
  
procedure MenuRiOpPack;
var ch : char;
begin
  repeat
    ClrScr;
    Write('  Oper. Res.  Package Ver. 1.à - Copyright 1994 by Enrico Croce - ');
    {$IFDEF USE87}
      writeln(' 80x87 ON');
    {$ELSE}
      writeln(' 80x87 OFF');
    {$ENDIF}
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Finisce programma                 | S. Shell Dos                         |');
    writeln('|                                      |                                      |');
    writeln('| E. Editor file di testo              | V. Mostra programma lineare          |');
    writeln('|                                      |                                      |');
    writeln('| A. Simplesso Standard                | B. P.I. Balas                        |');
    writeln('| C. Simplesso Revisionato + Analisi   | D. Simplesso con metodo duale        |');
    writeln('|                                      |                                      |');
    writeln('| Z. Progamma Lineare Duale            |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Electra I   - Fase 1              | !. Electra I   - Fase 2 - Ric.nucleo |');
    writeln('| 2. Electra II  - Fase 1              | ".                                   |');
    writeln('| 3. Electra III - Fase 1              | œ. Electra III - Fase 2              |');
    writeln('|                                      |                                      |');
    writeln('|                                      | $. Electra   I - Fase 2 bis          |');
    writeln('|                                      |                                      |');
    writeln('| X. Surclassamento sfumato->non sfum. | Y. Calcolo ë(a,b) da c(a,b) e D(a,b) |');
    writeln('|                                      |                                      |');
    writeln('| G. Gestione Algoritmi su Grafi       |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('+-----------------------------------------------------------------------------+');
    writeln('| Quale e'' la tua scelta?                                                     |');
    write  ('+-----------------------------------------------------------------------------+');
    GotoXY(27, WhereY - 1);
    ch:= readkey; if ch = #0 then readkey;
    ch:= UpCase(ch);
    case ch of
      'S': Shell;
      'E': EditFile;
      'V': ViewSimplesso;
      'A': PlSimplesso;
      'B': SolvPIBalas;
      'C': SolvRSimplex;
      'D': SolvSDua;
      'Z': MakeDuale;
      '1': Electra1Fase1;
      '!': Electra1Fase2;
      '2': Electra2Fase1;
      '"': ;
      '3': Electra3Fase1;
      'œ': Electra3Fase2;

      '$': Electra1Fase2bis;

      'X': MakeGraph;
      'Y': MakeScD;

      'G': MenuGrafi;
    end;
  until ch = '0';
  ClrScr;
end;

{$IFNDEF UNIT}
begin
  MenuRiOpPack;
{$ENDIF}
end.
