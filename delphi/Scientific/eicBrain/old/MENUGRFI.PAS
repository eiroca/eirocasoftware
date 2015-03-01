{$I switches.inc}
{$M 32000,64000,256000}
{ UNDEF UNIT}

{$IFDEF UNIT}
unit MenuGrfi;

interface

procedure MenuGrafi;

implementation
{$ENDIF}

uses DataMngr, Matrix, Crt, Dos, Grafi;

procedure ViewGrafo;
var
  G: TGraph;
  fn:PathStr;
begin
  ClrScr;
  writeln('Matrice incidenza del grafo/albero');
  fn:= GetFileName;
  if fn ='' then exit;
  G.Load(fn);
  writeln;
  write('Grafo ',fn,' '); 
  if G.Orient = true then writeln('orientato') else writeln('non orientato');
  G.Archi.Print('',0,0,0,0);
  readln;
  G.Normalize;
  G.DetectOriented;
  G.Archi.Print('',0,0,0,0);
  readln;
  G.Done;
end;

procedure CheckGrafo;
var
  G: TGraph;
  fn:PathStr;
  yn: char;
  i, j: integer;
  a, b: integer;
  Path: TIVector;
begin
  ClrScr;
  writeln('Matrice incidenza del grafo/albero');
  fn:= GetFileName;
  if fn ='' then exit;
  G.Load(fn);
  writeln;
  write('Grafo ',fn,' '); if G.Orient = true then writeln('orientato') else writeln('non orientato');
  G.Archi.Print('',0,0,0,0);
  writeln;
  writeln('CheckLoop = ', G.CheckLoop);
  readln;
  for i:= 0 to G.NumNodi do begin
    for j:= 0 to G.NumNodi do begin
      if not(G.Orient) and (i = j) then continue;
      Writeln('Nodo (',i:2,'-',j:2,') Linked=',G.IsLinked(i,j):4,' Connected=',G.IsConnected(i,j):4);
    end;
    readln;
  end;
  G.Done;
end;

procedure MinMaxTree;
var
  G, TMin, TMax: TTree;
  i: integer;
  fn:PathStr;
  yn: char;
begin
  ClrScr;
  writeln('Matrice incidenza del grafo/albero');
  fn:= GetFileName;
  if fn ='' then exit;
  G.Load(fn);
  if G.Orient = false then begin
    writeln('Il grafo non deve essere orientato!');
    writeln;
    write('Lo rendo non orientato? '); readln(yn); yn:= UpCase(yn);
    if yn in ['S','Y'] then G.SetOriented(false) else exit;
  end;
  writeln;
  write('Grafo ',fn,' '); if G.Orient = true then writeln('orientato') else writeln('non orientato');
  G.Archi.Print('',0,0,0,0);
  readln;
  for i:= 0 to G.NumNodi do G.Archi.At(i,i)^:= 0;
  writeln('Creo albero minimo con Kruskal len_min=',G.MinTreeK(TMin));
  TMin.Archi.Print('',0,0,0,0);
  readln;
  writeln('Creo albero massimo con Kruskal len_max=',G.MaxTreeK(TMax));
  TMax.Archi.Print('',0,0,0,0);
  readln;
  G.Done;
  TMin.Done;
  TMax.Done;
end;

procedure MinMaxTree2;
var
  G, TMin, TMax: TTree;
  i: integer;
  fn:PathStr;
  yn: char;
begin
  ClrScr;
  writeln('Matrice incidenza del grafo/albero');
  fn:= GetFileName;
  if fn ='' then exit;
  G.Load(fn);
  if G.Orient = false then begin
    writeln('Il grafo non deve essere orientato!');
    writeln;
    write('Lo rendo non orientato? '); readln(yn); yn:= UpCase(yn);
    if yn in ['S','Y'] then G.SetOriented(false) else exit;
  end;
  writeln;
  write('Grafo ',fn,' '); if G.Orient = true then writeln('orientato') else writeln('non orientato');
  G.Archi.Print('',0,0,0,0);
  readln;
  for i:= 0 to G.NumNodi do G.Archi.At(i,i)^:= 0;
  writeln('Creo albero minimo con Sollin len_min=',G.MinTree(TMin));
  TMin.Archi.Print('',0,0,0,0);
  readln;
  writeln('Creo albero massimo con Sollin len_max=',G.MaxTree(TMax));
  TMax.Archi.Print('',0,0,0,0);
  readln;
  G.Done;
  TMin.Done;
  TMax.Done;
end;

procedure MinPath;
var
  G: TTree;
  fn:PathStr;
  i, j: integer;
  a, b: integer;
  Path: TIVector;
  tmp: integer;
begin
  ClrScr;
  writeln('Matrice incidenza del grafo/albero');
  fn:= GetFileName;
  if fn ='' then exit;
  G.Load(fn);
  writeln;
  write('Grafo ',fn,' '); if G.Orient = true then writeln('orientato') else writeln('non orientato');
  G.Archi.Print('',0,0,0,0);
  for i:= 0 to G.NumNodi do G.Archi.At(i,i)^:= 0;
  writeln('Ricerca cammino minimo.');
  write('Da: '); readln(a);
  write('A : '); readln(b);
  tmp:= G.MinPath(Path,a,b);
  writeln('lunghezza minima = ',tmp);
  if tmp >= 0 then begin
    write('Path = {');
    for i:= 0 to G.NumNodi do begin
      if Path.At(i)^ <> -1 then write(Path.At(i)^,',');
    end;
    writeln(#8'}');
  end;
  readln;
  G.Done;
  Path.Done;
end;

procedure MaxPath;
var
  G: TTree;
  fn:PathStr;
  i, j: integer;
  a, b: integer;
  Path: TIVector;
  tmp: integer;
begin
  ClrScr;
  writeln('Matrice incidenza del grafo/albero');
  fn:= GetFileName;
  if fn ='' then exit;
  G.Load(fn);
  writeln;
  write('Grafo ',fn,' '); if G.Orient = true then writeln('orientato') else writeln('non orientato');
  G.Archi.Print('',0,0,0,0);
  for i:= 0 to G.NumNodi do G.Archi.At(i,i)^:= 0;
  writeln('Ricerca cammino minimo.');
  write('Da: '); readln(a);
  write('A : '); readln(b);
  tmp:= G.MaxPath(Path,a,b);
  writeln('lunghezza massima = ',tmp);
  if tmp >= 0 then begin
    write('Path = {');
    for i:= 0 to G.NumNodi do begin
      if Path.At(i)^ <> -1 then write(Path.At(i)^,',');
    end;
    writeln(#8'}');
  end;
  readln;
  G.Done;
  Path.Done;
end;

procedure MaxFlow;
var
  F, G: TTree;
  fn:PathStr;
  i, j: integer;
  a, b: integer;
  Path: TIVector;
  tmp: integer;
begin
  ClrScr;
  writeln('Matrice incidenza del grafo/albero');
  fn:= GetFileName;
  if fn ='' then exit;
  G.Load(fn);
  writeln;
  write('Grafo ',fn,' '); if G.Orient = true then writeln('orientato') else writeln('non orientato');
  G.Archi.Print('',0,0,0,0);
  for i:= 0 to G.NumNodi do G.Archi.At(i,i)^:= 0;
  writeln('Ricerca cammino minimo.');
  write('Da: '); readln(a);
  write('A : '); readln(b);
  tmp:= G.MaxFLow(a,b,F);
  writeln('Flusso Massimo (',a,'->',b,') = ', tmp);
  if tmp <> -1 then begin
    F.Archi.Print('',0,0,0,0);
  end;
  readln;
  G.Done;
  F.Done;
end;

procedure DeOrientGrafo;
var
  G: TGraph;
  fn1,fn2:PathStr;
begin
  ClrScr;
  writeln('Deorineta un grafo. Matrice incidenza iniziale');
  fn1:= GetFileName;
  if fn1 ='' then exit;
  G.Archi.Print('',0,0,0,0);
  writeln;
  writeln('Deorineta un grafo. Matrice incidenza finale');
  fn2:= GetFileName;
  if fn2 ='' then exit;
  G.Load(fn1);
  G.SetOriented(false);
  G.Store(fn2);
  G.Done;
end;

procedure MenuGrafi;
var ch : char;
begin
  repeat
    ClrScr;
    Write('  Grafi       Package Ver. 1.à - Copyright 1995 by Enrico Croce - ');
    {$IFDEF USE87}
      writeln(' 80x87 ON');
    {$ELSE}
      writeln(' 80x87 OFF');
    {$ENDIF}
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Torna al menu principale          |                                      |');
    writeln('| E. Editor file di testo              | S. Shell Dos                         |');
    writeln('|                                      |                                      |');
    writeln('| V. Vedere un grafo                   | C. Connessioni / Controllo Loop      |');
    writeln('| M. Min/Max Tree. Algoritmo Kruskal   | N. Min/Max Tree. Algortimo Sollin    |');
    writeln('| F. MaxFlow/MinCut (Alg. Ford & F.)   |                                      |');
    writeln('| 1. Cammino minimo (Alg. Dantzing)    | 2. Cammino massimo (Alg. Ford)       |');
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
    writeln('| Z. Rende un grafo non orientato      |                                      |');
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

      'V': ViewGrafo;
      'C': CheckGrafo;
      'M': MinMaxTree;
      'N': MinMaxTree2;

      '1': MinPath;
      '2': MaxPath;
      'F': MaxFlow;

      'Z': DeOrientGrafo;
    end;
  until ch = '0';
  ClrScr;
end;

{$IFNDEF UNIT}
begin
  MenuGrafi;
{$ENDIF}
end.
