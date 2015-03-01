unit MenuGraf;

{$I switches.inc}

interface

procedure MenuGrafi;

implementation

uses Matrix, Crt, Dos, Grafi, DataMngr, MathTool;

procedure MenuGrafi;
var
  G,T: TTree;
  fn:PathStr;
  yn: char;
  i, j: integer;
  a, b: integer;
  Path: TIVector;
begin
  ClrScr;
  writeln('Creazione matrice incidenza del grafo/albero');
  Exec(GetEnv('COMSPEC'),'/C dir *.dat /w');
  writeln;
  fn:= '';
  InputStr('Quale matrice di incidenza (X= immissione diretta): ',fn);
  if fn ='' then exit;
  if (fn='x') or (fn='X') then fn:= '';
  G.Load(fn);
  GetChar('Orientato? ',yn);
  if yn = 'N' then G.SetOriented(false);
  G.Normalize;
  G.Archi.Print('',0,0,0,0);
  writeln('CheckLoop = ', G.CheckLoop);
  WaitReturn;
  for i:= 0 to G.NumNodi do begin
    for j:= 0 to G.NumNodi do begin
      if not(G.Orient) and (i = j) then continue;
      Writeln('Nodo (',i:2,'-',j:2,') Linked=',G.IsLinked(i,j):4,' Connected=',G.IsConnected(i,j):4);
    end;
    WaitReturn;
  end;
  G.Done;
  G.Load(fn);
  if yn = 'N' then G.SetOriented(false);
  for i:= 0 to G.NumNodi do G.Archi.At(i,i)^:= 0;
  writeln;
  writeln('Creo albero minimo con Kruskal len_min=',G.MinTreeK(T));
  T.Archi.Print('',0,0,0,0);
  WaitReturn;
  writeln('Ricerca cammino minimo/massimo.');
  InputInt('Da: ',a,1,maxint);
  InputInt('A : ',b,1,maxint);
  writeln('lunghezza minima = ',G.MinPath(Path,a,b));
  write('Path = {');
  for i:= 0 to G.NumNodi do begin
    write(Path.At(i)^,',');
  end;
  writeln(#8'}');
  WaitReturn;
(*
  writeln('lunghezza massima = ',G.MaxPath(Path,a,b));
  write('Path = {');
  for i:= 0 to G.NumNodi do begin
    write(Path.At(i)^,',');
  end;
  writeln(#8'}');
  WaitReturn;
*)

end;

end.