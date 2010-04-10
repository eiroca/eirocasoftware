(* GPL > 3.0
Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)
(*
 @author(Enrico Croce)
*)
unit uGrafi;

{$b-} (* fondamentale che in (a and b) se a e' falso b non venga valutato! *)

interface

uses
  eLibMath, uError;

type

  TPath = TIVector;

  TGraph = class(TObject)
    NumNodi: integer;
    Archi  : TIMatrix;
    orient : boolean;
    constructor Load(var Fil: string);
    procedure   Store(var Fil: string);
    constructor Create(NumOfNei: integer; Oriented: boolean);
    destructor  Destroy; override;
    procedure   SetOriented(state: boolean);
    procedure   DetectOriented;
    procedure   Normalize;
    procedure   Link(a,b: integer; Len: integer);
    procedure   UnLink(a,b: integer);
    function    IsLinked(a, b: integer): integer;
    function    IsConnected(a, b: integer): integer;
    function    CheckLoop: integer;
    function    MinPath(var Path: TPath; x0,xd: integer): integer;
    function    MaxPath(var Path: TPath; x0,xd: integer): integer;
    function    MaxFlow(x0, xd: integer; var Flow:TGraph): integer;
  end;

  TTree = class(TGraph)
    (* Albero a lunghezza minima *)
    (* Kruskal *)
    function MinTreeK(var T: TTree): integer;
    function MaxTreeK(var T: TTree): integer;
    function MinTree(var T: TTree): integer;
    function MaxTree(var T: TTree): integer;
  end;

implementation

constructor TGraph.Create(NumOfNei: integer; Oriented: boolean);
var i,j: integer;
begin
  NumNodi:= NumOfNei-1;
  Orient:= Oriented;
  Archi:= TIMatrix.Create(nil);
  Archi.Setup(0, NumOfNei,0, NumOfNei);
  for i:= 0 to NumNodi do begin
    for j:= 0 to NumNodi do begin
      Archi[i,j]:= 0;
    end;
  end;
end;

destructor TGraph.Destroy;
begin
  Archi.Free;
  Archi:= nil;
end;

procedure TGraph.SetOriented(state: boolean);
(* Non si limita a modificare lo stato del orientamento, ma rende anche la
matrice simmetrica se si setta l'orientamento a false*)
var
  i: integer;
  j: integer;
begin
  Orient:= state;
  if Orient = false then begin
    for i:= 0 to NumNodi do begin
      for j:= 0 to NumNodi do begin
        if i = j then continue;
        if (Archi[i,j] = 0) then if (Archi[j,i] <> 0) then Archi[i,j]:= Archi[j,i];
      end;
    end;
  end;
end;

procedure TGraph.DetectOriented;
var
  i, j: integer;
label Exit;
begin
  Orient:= true;
  for i:= 0 to NumNodi do begin
    for j:= 0 to NumNodi do begin
      if i = j then continue;
      if Archi[i,j] <> Archi[j,i] then begin
        Orient:= false;
        goto Exit;
      end;
    end;
  Exit:
  end;
end;

procedure TGraph.Normalize;
var
  i, j: integer;
begin
  for i:= 0 to NumNodi do begin
    for j:= 0 to NumNodi do begin
      if i = j then Archi[i, j]:= 0
      else if Archi[i, j] <> 0 then Archi[i, j]:= 1;
    end;
  end;
end;

procedure TGraph.Link(a, b: integer; Len: integer);
begin
  Archi[a,b]:= Len;
  if not Orient then Archi[b, a]:= Len;
end;

procedure TGraph.UnLink(a, b: integer);
begin
  Link(a,b, 0);
end;

function TGraph.IsLinked(a, b: integer): integer;
var tmp: integer;
begin
  tmp:= Archi[a, b];
  if (not Orient) and (tmp = 0) then tmp:= Archi[b,a];
  IsLinked:= tmp;
end;

function TGraph.IsConnected(a, b: integer): integer;
(*
  nn, nd servono ad evitare che si utilizzi due volte lo stesso nodo e
  quindi si crei un ciclo con dei sotticicli - senza va in loop infinito -
  la soluzione di cancellare l'archi utilizzati troppa RAM, bisogna duplicare
  Archi e non solo Nodi
*)
var
  nn: TIVector;
  i: integer;
  function Connected(var nn: TIVector; a,b: integer): integer;
  (*
    Connected(A,B):- Linked(A,B).
    Connected(A,B):- Linked(A,X),Connected(X,B).
  *)
  var
    i: integer;
    tmp, tmp2: longint;
    nd: TIVector; (* Nodi gi… visitati, evita di ripetere i cicli *)
  begin
    tmp:= IsLinked(a,b);
    if tmp <> 0 then begin
      Connected:= tmp;
      exit;
    end;
    ND:= TIVector.Create(nil);
    Nd.Setup(0,NumNodi+1);
    for i:= 0 to NumNodi do Nd[i]:= nn[i];
    Nd[a]:= 0;
    nd[b]:= 0;
    Connected:= 0;
    for i:= 0 to NumNodi do begin
      if nd[i] = 0 then continue;
      tmp:= IsLinked(a,i); if tmp = 0 then continue;
      tmp2:= Connected(nd, i, b); if tmp2 = 0 then continue;
      Connected:= tmp+ tmp2;
      exit;
    end;
    Nd.Free;
  end;
begin
  NN:= TIVector.Create(nil);
  nn.Setup(0,NumNodi+1);
  for i:= 0 to NumNodi do nn[i]:= 1;
  IsConnected:= Connected(nn, a, b);
end;

procedure TGraph.Store(var Fil: string);
begin
  Archi.SaveToText(Fil, 0, 0, 0, 0, 0);
end;

constructor TGraph.Load(var Fil: string);
begin
  Archi.LoadFromText(Fil);
  NumNodi:= Archi.RowCnt-1;
  if (NumNodi <= 0) or (NumNodi <> Archi.ColCnt-1) then ErrorHandler('TGraph.Load', ERR_BADGRAPH);
  DetectOriented;
end;

function TGraph.CheckLoop: integer;
var
  t: TIMatrix;
  i,j: integer;
begin
  for i:= 0 to NumNodi do Archi[i,i]:= 0;
  t:= TIMatrix.Create(nil);
  t.setup(0, NumNodi+1, 0, NumNodi+1);
  Matrix.IMatMul(t,Archi,Archi);
  CheckLoop:= 1;
  for j:= 0 to NumNodi do begin
    if t[j,j]>0 then exit;
  end;
  for i:= 2 to NumNodi+1 do begin
    CheckLoop:= i;
    Matrix.IMatMul(t,t,Archi);
    for j:= 0 to NumNodi do begin
      if t[j,j]>0 then exit;
    end;
  end;
  CheckLoop:= 0;
end;

function TGraph.MinPath(var Path: TPath; x0,xd: integer): integer;
(* Algoritmo di Dantzing *)
(* serve che lunghezze su archi siano positive *)
var
  Pot: TIVector;
  Mrk: TIVector;
  cnt: integer;
  i, j: integer;
  b: integer;
  min: integer;
  flg: integer; (* ottimizzazione evita di contralle nodi senza piu' connessioni *)
  Arc: TGraph;
begin
  (* controllo lunghezze archi maggiori di zero *)
  Path:= TIVector.Create(nil);
  Path.Setup(0,NumNodi+1);
  for i:= 0 to NumNodi do Path[i]:= -1;
  for i:= 0 to NumNodi do begin
    for j:= 0 to NumNodi do begin
      if Archi[i,j] < 0 then begin
        writeln('Lunghezze devono essere positive!!!!');
        MinPath:= -1;
        exit;
      end;
    end;
  end;
  (* Inizio vero e proprio *)
  Arc:= TGraph.Create(NumNodi+1,true);
  for i:= 0 to NumNodi do begin
    for j:= 0 to NumNodi do begin
      Arc.Archi[i,j]:= Archi[i,j];
    end;
  end;
  Pot:= TIVector.Create(nil);
  Pot.setup(0,NumNodi+1);
  mrk:= TIVector.Create(nil);
  mrk.setup(0,NumNodi+1);
  for i:= 0 to NumNodi do Pot[i]:= 0;
  for i:= 0 to NumNodi do Mrk[i]:= 0;
  Pot[x0]:= 0;
  Mrk[x0]:= 1;
  while Mrk[xd] = 0 do begin
    min:= -1;
    b:= -1;
    for i:= 0 to NumNodi do begin
      if Mrk[i] > 0 then begin
        flg:= 0;
        for j:= 0 to NumNodi do begin
          if i=j then continue;
          if Arc.Archi[i,j] = 0 then continue;
          flg:= 1;
          if min=-1 then begin
            b:= j;
            min:= Pot[i]+Arc.Archi[i,j];
          end
          else if (Pot[i]+Arc.Archi[i,j]) < min then begin
            b:= j;
            min:= (Pot[i]+Arc.Archi[i,j]);
          end;
        end;
        if (flg = 0) then Mrk[i]:= -1;
      end;
    end;
    if (min=-1) then begin
      writeln('Il nodo di partenza e'' sconnesso da quello di arrivo!!!');
      MinPath:=-2;
      exit;
    end;
    for i:= 0 to NumNodi do begin
      if i = b then continue;
      Arc.Link(i,b,0); (* cancella tutti i rami che portano a b *)
    end;
    Mrk[b]:= 1;
    Pot[b]:= min;
  end;
  cnt:= 0;
  Path[cnt]:= xd;
  inc(cnt);
  b:= xd;
  while b <> x0 do begin
    for i:= 0 to NumNodi do begin
      if i = b then continue;
      if (Mrk[i]<>0) and (Pot[b]-Archi[i,b] = Pot[i]) then begin
        Path[cnt]:= i;
        b:= i;
        break;
      end;
    end;
    inc(cnt);
  end;
  dec(cnt);
  for i:= 0 to cnt div 2 do begin
    min:= Path[i];
    Path[i]:= Path[cnt-i];
    Path[cnt-i]:= min;
  end;
  MinPath:= Pot[xd];
end;

function TGraph.MaxPath(var Path: TPath; x0,xd: integer): integer;
(* Algoritmo di Ford *)
var
  Pot: TIVector;
  Mrk: TIVector;
    (* 1 = analizzato definitivo *)
    (* 0 = vergine *)
    (*-1 = analizzato definitivo soppresso x ottimizzazione *)
  cnt: integer;
  i, j: integer;
  a, b: integer;
  max: integer;
  Arc: TGraph;
begin
  Path:= TIVector.Create(nil);
  Path.setup(0,NumNodi+1);
  for i:= 0 to NumNodi do Path[i]:= -1;
  if CheckLoop <> 0 then begin
    writeln('Non devono esserci cicli!!!!');
    MaxPath:= -1;
    exit;
  end;
  Arc:= TGraph.Create(NumNodi+1, false);
  for i:= 0 to NumNodi do begin
    for j:= 0 to NumNodi do begin
      Arc.Archi[i,j]:= Archi[i,j];
    end;
  end;
  Pot:= TIVector.Create(nil);
  Pot.Setup(0,NumNodi+1);
  mrk:= TIVector.Create(nil);
  mrk.Setup(0,NumNodi+1);
  for i:= 0 to NumNodi do Pot[i]:= 0;
  for i:= 0 to NumNodi do Mrk[i]:= 0;
  Pot[x0]:= 0;
  Mrk[x0]:= 1;
  while (Mrk[xd] = 0) do begin
    for i:= 0 to NumNodi do begin
      if Mrk[i] = 1 then begin
        for j:= 0 to NumNodi do begin
          if i=j then continue;
          if Arc.IsLinked(i,j) = 0 then continue;
          if Mrk[j] = 0 then begin
            if Pot[i] + Arc.Archi[i,j] <= Pot[j] then begin
              Arc.Link(i,j,0);
            end
            else begin
              Pot[j]:= Pot[i] + Arc.Archi[i,j];
              Arc.Link(i,j,0);
            end;
          end;
        end;
      end;
    end;
    for i:= 0 to NumNodi do begin
      if Mrk[i] = -1 then continue;
      if Mrk[i] = 1 then begin
        Mrk[i]:= -1;
        continue;
      end;
      a:= 0; (* = num archi entranti *)
      for j:= 0 to NumNodi do begin
        if Arc.Archi[j,i] <> 0 then inc(a);
      end;
      if a = 0 then Mrk[i]:= 1;
    end;
  end;
  cnt:= 0;
  Path[cnt]:= xd;
  inc(cnt);
  b:= xd;
  while b <> x0 do begin
    for i:= 0 to NumNodi do begin
      if i = b then continue;
      if (Pot[b] = Pot[i] + Archi[i,b]) then begin
        Path[cnt]:= i;
        b:= i;
        break;
      end;
    end;
    inc(cnt);
  end;
  dec(cnt);
  for i:= 0 to cnt div 2 do begin
    max:= Path[i];
    Path[i]:= Path[cnt-i];
    Path[cnt-i]:= max;
  end;
  MaxPath:= Pot[xd];
end;

function TGraph.MaxFlow(x0, xd: integer; var Flow: TGraph): integer;
(* Algoritmo di Ford & Fulkerson *)
var
  Mrk: TIVector;
  Frm: TIVector;
  Dlt: TIVector;
  i, j, xi: integer;
  tmp: integer;
  ext, flg: boolean;
label RoutineA;
begin
  if Orient = true then begin
    MaxFlow:= -1;
    exit;
  end;
  Mrk:= TIVector.Create(nil);
  Frm:= TIVector.Create(nil);
  Dlt:= TIVector.Create(nil);
  Mrk.Setup(0,NumNodi+1);
  Frm.Setup(0,NumNodi+1);
  Dlt.Setup(0,NumNodi+1);
  Flow:= TGraph.Create(NumNodi+1, true);
(* Routine A *)
RoutineA:
  for i:= 0 to NumNodi do begin
    Mrk[i]:= 0;
    Frm[i]:= 0;
    Dlt[i]:= 0;
  end;
  Mrk[x0]:= 1;
  Frm[x0]:=-1;
  Dlt[x0]:=maxint;
  ext:= false;
  while (Mrk[xd]<>1) and (ext=false) do begin
    ext:= true;
    for i:= 0 to NumNodi do begin
      if Mrk[i] = 1 then begin
        flg:= false;
        ext:= false;
        for j:= 0 to NumNodi do begin
          if i=j then continue;
          if (Archi[i,j] <> 0) and (Mrk[j]=0) then begin
            flg:= true;
            if Flow.Archi[i,j] < Archi[i,j] then begin
              Mrk[j]:= 1;
              Frm[j]:= i+1;
              tmp:= Archi[i,j] - Flow.Archi[i,j];
              if Dlt[i] < tmp then Dlt[j]:= Dlt[i]
              else Dlt[j]:= tmp;
            end
            else if Flow.Archi[j,i] > 0 then begin
              Mrk[j]:= 1;
              Frm[j]:= -(i+1);
              if Dlt[i] < Flow.Archi[j,i] then Dlt[j]:= Dlt[i]
              else Dlt[j]:=  Flow.Archi[j,i];
            end;
          end;
        end;
        Mrk[i]:= 2;
        if flg = false then Mrk[i]:= 4 else break;
      end;
    end;
  end;
  if not ext then begin
    (* routine B *)
    tmp:= Dlt[xd];
    xi:= xd;
    while xi <> x0 do begin
      j:= Frm[xi];
      if j > 0 then begin
        dec(j);
        Flow.Archi[j,xi]:= Flow.Archi[j,xi] + tmp;
      end
      else begin
        j:= (-j) -1;
        Flow.Archi[-j,xi]:= Flow.Archi[-j,xi] - tmp;
      end;
      xi:= j;
    end;
    Goto RoutineA;
  end;
  tmp:= 0;
  for i:= 0 to Numnodi do begin
    if Flow.Archi[i,xd] <> 0 then tmp:= tmp+Flow.Archi[i,xd];
  end;
  MaxFlow:= tmp;
end;

function TTree.MinTreeK(var T: TTree): integer;
(* Algoritmo di Kruskal *)
(* serve che il grafo NON sia orientato *)
var
  i, j, k: integer;
  min,a,b: integer;
  tmp: integer;
  len: longint;
  Arc: TGraph;
label FindMin;
begin
  T:= TTree.Create(NumNodi+1, Orient);
  MinTreeK:= -1;
  if Orient=true then exit;
  Arc:= TGraph.Create(NumNodi+1,Orient);
  for i:= 0 to NumNodi do for j:= 0 to NumNodi do Arc.Archi[i,j]:= Archi[i,j];
  len:= 0;
  for k:= 1 to NumNodi do begin
  FindMin:
    (* cerca arco a lunghezza minima *)
    a:= -1;
    b:= -1;
    min:= MaxInt;
    for i:= 0 to NumNodi do begin
      for j:= 0 to NumNodi do begin
        if i=j then continue;
        tmp:= Arc.IsLinked(i,j);
        if (tmp <> 0) then begin
          if (a=-1) then begin
            min:= tmp;
            a:= i;
            b:= j;
          end
          else if tmp < min then begin
            min:= tmp;
            a:= i;
            b:= j;
          end;
        end;
      end;
    end;
    if a = -1 then begin
     writeln('Grafo non connesso impossibile trovare albero minimo!');
       halt(1);
    end;
    (* cancellalo *)
    Arc.Link(a,b,0);
    (* controlla che non si formi un ciclo, per formare un ciclo aggiungendo
    l'arco (a,b) e' necessario che già ci fosse un percorso tra i due nodi *)
    if (k<>0) then if (T.IsConnected(a,b) <> 0) then Goto FindMin; (* Loop! *)
    T.Link(a,b, min);
    len:= len + min;
  end;
  MinTreeK:= len;
end;

function TTree.MaxTreeK(var T: TTree): integer;
(* Algoritmo di Kruskal *)
(* serve che il grafo NON sia orientato *)
var
  i,j,k: integer;
  max,a,b: integer;
  tmp: integer;
  len: longint;
  Arc: TGraph;
label FindMax;
begin
  T:= TTree.Create(NumNodi+1, Orient);
  MaxTreeK:= -1;
  if Orient=true then exit;
  Arc:= TGraph.Create(NumNodi+1,Orient);
  for i:= 0 to NumNodi do for j:= 0 to NumNodi do Arc.Archi[i,j]:= Archi[i,j];
  len:= 0;
  for k:= 1 to NumNodi do begin
  FindMax:
    (* cerca arco a lunghezza massima *)
    a:= -1;
    b:= -1;
    max:= -MaxInt;
    for i:= 0 to NumNodi do begin
      for j:= 0 to NumNodi do begin
        if i=j then continue;
        tmp:= Arc.IsLinked(i,j);
        if (tmp <> 0) then begin
          if (a=-1) then begin
            max:= tmp;
            a:= i;
            b:= j;
          end
          else if tmp > max then begin
            max:= tmp;
            a:= i;
            b:= j;
          end;
        end;
      end;
    end;
    if a = -1 then begin
     writeln('Grafo non connesso impossibile trovare albero minimo!');
       halt(1);
    end;
    (* cancellalo *)
    Arc.Link(a,b,0);
    (* controlla che non si formi un ciclo, per formare un ciclo aggiungendo
    l'arco (a,b) e' necessario che già ci fosse un percorso tra i due nodi *)
    if (k<>0) then if (T.IsConnected(a,b) <> 0) then Goto FindMax; (* Loop! *)
    T.Link(a,b, max);
    len:= len + max;
  end;
  MaxTreeK:= len;
end;

function TTree.MinTree(var T: TTree): integer;
(* Algoritmo di Sollin  *)
(* serve che il grafo NON sia orientato *)
var
  G: TGraph;
  N: TIVector;
  i,ii,j: integer;
  a,b: integer;
  len: integer;
  min: integer;
begin
  T:= TTree.Create(NumNodi+1, Orient);
  MinTree:= -1;
  if Orient=true then exit;
  G:= TGraph.Create(NumNodi+1, Orient);
  for i:= 0 to NumNodi do for j:= 0 to NumNodi do G.Archi[i,j]:= Archi[i,j];
  N:= TIVector.Create(nil);
  N.setup(0,NumNodi+1);
  for i:= 0 to NumNodi do N[i]:= i;
  len:= 0;
  for i:= NumNodi downto 1 do begin
    min:= 0; a:= -1; b:= -1;
    for ii:= i to NumNodi do begin
      for j:= 0 to i-1 do begin
      if ii=j then continue;
        if G.Archi[ii,j] <> 0 then begin
          if a=-1 then begin min:= G.Archi[ii,j]; a:= j; b:=ii; end
          else if G.Archi[ii,j] < min then begin min:= G.Archi[ii,j]; a:= j; b:= ii; end;
        end;
      end;
    end;
    if a=-1 then begin
      writeln('grafo sconnesso!');
      MinTree:= -1;
      exit;
    end;
    T.Link(N[a],N[b],min);
    len:= len + min;
    (* scambia i-1 con a *)
    N[i-1]:= a; N[a]:= i-1;
    for j:= 0 to NumNodi do begin
      if (j=a) or (j=i-1) then continue;
      min:= G.Archi[j,a];
      G.Archi[j,a]:= G.Archi[j,i-1];
      G.Archi[j,i-1]:= min;
    end;
    for j:= 0 to NumNodi do begin
      if (j=a) or (j=i-1) then continue;
      min:= G.Archi[a,j];
      G.Archi[a,j]:= G.Archi[i-1,j];
      G.Archi[i-1,j]:= min;
    end;
  end;
  MinTree:= len;
end;

function TTree.MaxTree(var T: TTree): integer;
(* Algoritmo di Sollin  *)
(* serve che il grafo NON sia orientato *)
var
  G: TGraph;
  N: TIVector;
  i,ii,j: integer;
  a,b: integer;
  len: integer;
  max: integer;
begin
  T:= TTree.Create(NumNodi+1, Orient);
  MaxTree:= -1;
  if Orient = true then exit;
  G:= TGraph.Create(NumNodi+1,Orient);
  for i:= 0 to NumNodi do begin
    for j:= 0 to NumNodi do begin
      G.Archi[i,j]:= Archi[i,j];
    end;
  end;
  N:= TIVector.Create(nil);
  N.Setup(0,NumNodi+1);
  for i:= 0 to NumNodi do N[i]:= i;
  len:= 0;
  for i:= NumNodi downto 1 do begin
    max:= 0; a:= -1; b:= -1;
    for ii:= i to NumNodi do begin
      for j:= 0 to i-1 do begin
      if ii=j then continue;
        if G.Archi[ii,j] <> 0 then begin
          if a=-1 then begin max:= G.Archi[ii,j]; a:= j; b:=ii; end
          else if G.Archi[ii,j] > max then begin max:= G.Archi[ii,j]; a:= j; b:= ii; end;
        end;
      end;
    end;
    if a=-1 then begin
      writeln('grafo sconnesso!');
      MaxTree:= -1;
      exit;
    end;
    T.Link(N[a],N[b],max);
    len:= len + max;
    (* scambia i-1 con a *)
    N[i-1]:= a; N[a]:= i-1;
    for j:= 0 to NumNodi do begin
      if (j=a) or (j=i-1) then continue;
      max:= G.Archi[j,a];
      G.Archi[j,a]:= G.Archi[j,i-1];
      G.Archi[j,i-1]:= max;
    end;
    for j:= 0 to NumNodi do begin
      if (j=a) or (j=i-1) then continue;
      max:= G.Archi[a,j];
      G.Archi[a,j]:= G.Archi[i-1,j];
      G.Archi[i-1,j]:= max;
    end;
  end;
  MaxTree:= len;
end;

end.
