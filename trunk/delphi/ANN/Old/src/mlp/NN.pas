unit NN;

interface

(*-----------------------------------------------------------------------*
 * This file contains constant definitions that define the parameters of *
 * a neural net with an input layer, an output layer, and zero or more   *
 * hidden layers.                                                        *
 *-----------------------------------------------------------------------*)

var
  INPUT_LAYER_SIZE : integer = 2;  (* number of nodes in input layer  *)
  OUTPUT_LAYER_SIZE: integer = 1;  (* number of nodes in output layer *)
  NUM_HIDDEN_LAYERS: integer = 1;  (* number of hidden layers; MAX=10 *)

  HL_SIZE_1 : integer = 2;         (*  These define the sizes of the  *)
  HL_SIZE_2 : integer = 0;         (* hidden layers.  Make sure there *)
  HL_SIZE_3 : integer = 0;         (* is a positive integer for each  *)
  HL_SIZE_4 : integer = 0;         (* hidden layer that exists, i.e.  *)
  HL_SIZE_5 : integer = 0;         (* make sure there are as many     *)
  HL_SIZE_6 : integer = 0;         (* positive integers as there are  *)
  HL_SIZE_7 : integer = 0;         (* hidden layers [as specified by  *)
  HL_SIZE_8 : integer = 0;         (* NUM_HIDDEN_LAYERS],  and make   *)
  HL_SIZE_9 : integer = 0;         (* sure the rest are set to 0.     *)
  HL_SIZE_10: integer = 0;

var
  EPSILON: real = 0.25;        (* constant incrementation for weight change *)
  COM_EPS: real = 0.01;        (* constant incrementation for weight change *)

(* Definitions for the numbers of clusters in each layer *)
var
  NUM_CLUSTERS_0: integer = 1;
  NUM_CLUSTERS_1: integer = 0;
  NUM_CLUSTERS_2: integer = 0;
  NUM_CLUSTERS_3: integer = 0;
  NUM_CLUSTERS_4: integer = 0;
  NUM_CLUSTERS_5: integer = 0;
  NUM_CLUSTERS_6: integer = 0;
  NUM_CLUSTERS_7: integer = 0;
  NUM_CLUSTERS_8: integer = 0;
  NUM_CLUSTERS_9: integer = 0;

  NUM_PATTERNS: integer = 16;   (*number input pat's*)

  NUMLAYERS   : integer = 0;
  MAXNODES    : integer = 0;

const
  MAXPAT = 20;
  MAXNOD = 20;
  MAXLAY = 10;

type

  PATTERNtype = record
    p: array [0..MAXPAT-1,0..MAXNOD-1] of real;
  end;

  node = record
    state: real;                  (* activation state value of node*)
    weights: array [0..MAXNOD-1] of real; (* input connection weights      *)
    thresh: real;                 (* threshhold input value        *)
    actfn: integer;               (* activation functn: 0=linear, 1=logistic *)
  end;

(* NOTE: for any connections that do not exist, the value of that weight is zero. *)

  NNetType = record
    unt: array[0..MAXLAY-1,0..MAXNOD-1] of node;
  end;

(* NOTE: a net need only declared as type NNETtype, and all information  *)
(*       can be accessed through the single field unt, thus, a call to   *)
(*       the activation state of the second unit in the third layer is:  *)
(*       nnet.unt[3,2].state                                             *)

(* type for holding error values for weight connections *)
  wERRORtype = record
    e: array[0..MAXLAY-1,0..MAXNOD-1,0..MAXNOD-1] of real;
  end;

(* type for holding error values for threshhold weights *)
  tERRORtype = record
    e: array[0..MAXLAY-1,0..MAXNOD-1] of real;
  end;

(* global variable declaration *)
var
  NUMNODES: array[0..MAXLAY-1] of integer;

procedure InitNN;

procedure InitInPatterns(Path: string; var patns: PATTERNtype);
procedure InitOutPatterns(Path: string; var patns: PATTERNtype);

procedure InitNet(var NMND: array of integer; var N: NNETtype);
procedure UpDateInputAct(ptn: PATTERNtype; P: integer; var n: NNETtype);
procedure UpDateLayerAct(oldn: NNETtype; L: integer; var n: NNETtype);
procedure DisplayLayer(var N: NNETtype; Layer: integer; W: integer);
procedure GetDerivs(const n: NNETtype; const GoalOut: PATTERNtype; pattern: integer; var Deriv2: tERRORtype);
procedure UpDateWeightandThresh(const nn: NNETtype; const goal: PATTERNtype; p: integer; var newnet: NNETtype);

procedure Com_UpDateWeightandThresh(const oldn: NNETtype; var n: NNETtype);
procedure AllOrNoneLayerActs(const oldn: NNETtype; l: integer; var n: NNETtype);

implementation

(*-----------------------------------------------------------------------*
 *  This file contains parameters for the input patterns to be used by a *
 * neural net.  This file specifies a type PATTERNtype which is a record *
 * which contains an array of number of patterns by number of elements   *
 * per pattern.  The number of elements per pattern is equal to          *
 * INPUT_LAYER_SIZE, and the number of input patterns is specified as a  *
 * constant at the beginning of this file and can be modified by the user*
 * as long as the data file nninputs.dat contains that number of input   *
 * blocks.  This file also specifies the function InitPatterns for       *
 * getting the patterns from the file and putting them into a variable of*
 * type PATTERNtype.                                                     *
 *-----------------------------------------------------------------------*)
procedure InitInPatterns(Path: string; var patns: PATTERNtype);
var
  InFile: text;
  val: real;          (*pattern value  *)
  P, U: integer;      (*loop variables *)
begin
  {$I-}
  Assign(InFile, Path);
  Reset(InFile);
  {$I+}
  if IOResult <> 0 then begin
    writeln('File nninputs.dat does not exist!\n'); (*error message  *)
  end;
  for P:= 0 to NUM_PATTERNS-1 do begin (* for each pattern.... *)
    for U:= 0 to INPUT_LAYER_SIZE-1 do begin (*  for each unit in it:*)
      read(InFile, val);
      patns.p[P,U]:= val;
    end;
  end;
  close(InFile);
end;

(*-----------------------------------------------------------------------*
 * This file contains the data structure declarations for a neural net,  *
 * as well as the declaration for the initialization procedure for it,   *
 * as well as defining the global variable NUMNODES, which is initialized*
 * in the net initialization procedure.                                  *
 *                                                                       *
 *  USE OF InitNet:                                                      *
 *                                                                       *
 * At the beginning of your program should appear a variable declaration *
 *                                                                       *
 *  N: NNETtype;  \* any variable name here *\                           *
 *                \* NUMNODES is already declared *\                     *
 *  InitNet(NUMNODES, N);                                                *
 *                                                                       *
 *-----------------------------------------------------------------------*)
procedure InitNet(var NMND: array of integer; var N: NNETtype);
var
  c, d, f: integer;
begin
  (* Initialize NUMNODES *)
  NMND[0]:= INPUT_LAYER_SIZE;
  for c:=1 to NUMLAYERS-2 do begin
    if (c=1)  then NMND[c]:= HL_SIZE_1;
    if (c=2)  then NMND[c]:= HL_SIZE_2;
    if (c=3)  then NMND[c]:= HL_SIZE_3;
    if (c=4)  then NMND[c]:= HL_SIZE_4;
    if (c=5)  then NMND[c]:= HL_SIZE_5;
    if (c=6)  then NMND[c]:= HL_SIZE_6;
    if (c=7)  then NMND[c]:= HL_SIZE_7;
    if (c=8)  then NMND[c]:= HL_SIZE_8;
    if (c=9)  then NMND[c]:= HL_SIZE_9;
    if (c=10) then NMND[c]:= HL_SIZE_10;
  end;
  NMND[NUMLAYERS-1]:= OUTPUT_LAYER_SIZE;
  (* Initialize N *)
  (* WEIGHTS: random weights between connected nodes, all others 0       *)
  (* STATES:  set to 1 if an actual node, set to -5 if not               *)
  (* THRESH:  set initially to a random value                            *)
  (* ACTFN:   all hidden unts set to logistic (1), outputs to linear (0) *)
  (*          and input unts and non-unts set to (-1)                    *)
  for c:= 0 to NUMLAYERS-1 do begin
    for d:= 0 to MAXNODES-1 do begin (* for each node in each layer...*)
      if (d<NMND[c]) then begin      (* IF it's an actual node...     *)
        (* ACTIVATION STATES *)
        N.unt[c,d].state:= 1;        (* set initial state:= 1  *)
        if (c=0) then begin          (* if its input layer...  *)
          N.unt[c,d].actfn:= -1;         (* no activation function *)
          for f:= 0 to MAXNODES-1 do begin
            N.unt[c, d].weights[f]:= 0;  (*no weights to 1st layer *)
          end;
          N.unt[c, d].thresh    := -5;   (*no threshhold for 1st   *)
        end
        else begin
          (* ACTIVATION FUNCTION *)
          if (c=NUMLAYERS-1) then begin   (* if  the output layer its linear unit   *)
            N.unt[c, d].actfn:= 0;
          end
          else begin                      (* otherwise, logistic    *)
            N.unt[c,d].actfn:= 1;
          end;
          (* THRESHHOLD (randomize)*)
          N.unt[c,d].thresh:= random;
          (* WEIGHTS *)
          for f:= 0 to MAXNODES-1 do begin (* for each node in the weight list            *)
            if (f<NMND[c-1]) then N.unt[c, d].weights[f]:= random
            else N.unt[c, d].weights[f]:= 0;          (* node, turn off *)
          end;   (* end if input layer *)
        end;
      end
      else begin                            (* If it isn't an actual node... *)
        N.unt[c,d].state:= -5;              (* set act state to -5   *)
        N.unt[c,d].thresh:= -5;             (* no threshhold         *)
        N.unt[c,d].actfn:= -1;              (* no activation func.   *)
        for f:= 0 to MAXNODES-1 do begin    (* turn off connex to it *)
          N.unt[c, d].weights[f]:= 0;
        end;
      end;
    end;
  end;
end;

(*-----------------------------------------------------------------------*
 * This file loads the inputs into the net and feeds the values forward. *
 *-----------------------------------------------------------------------*)
procedure UpDateInputAct(ptn: PATTERNtype; P: integer; var n: NNETtype);
var
  u: integer; (* unit counter (in each pattern)*)
begin
  for u:= 0 to INPUT_LAYER_SIZE-1 do begin (*for each node in input layer...*)
    (* loads each element of the input pattern into the input layer's activation state      *)
    n.unt[0,u].state := ptn.p[P,u];
  end;
end;

procedure UpDateLayerAct(oldn: NNETtype; L: integer; var n: NNETtype);
var
  u, v: integer;  (* unit looping counters         *)
  act: real;      (* for holding activation states *)
begin
  n := oldn;
  if (L<1) then begin
    writeln('YOU FUCKED UP!');
    exit;
  end;
  if (L>=NUMLAYERS) then begin
    writeln('YOU FUCKED UP!');
    exit;
  end;
  for u:= 0 to NUMNODES[L]-1 do begin (* for each node in the layer...  *)
    act:= n.unt[L,u].thresh;               (* set act to neg. thresh  *)
    for v:= 0 to NUMNODES[L-1]-1 do begin  (* then sum weighted inputs*)
      act:= act + n.unt[L-1,v].state * n.unt[L,u].weights[v];
    end;
    case n.unt[L,u].actfn of
      0: n.unt[L,u].state:= act; (* if its linear...        *)
      1: n.unt[L,u].state:= 1.0 / (1.0 + exp(-act)); (* if its logistic...  *)
    end;
  end;
end;

(*-----------------------------------------------------------------------*
 * This file contains a series of functions for displaying different     *
 * values for nodes and weights in the network on the screen.            *
 *                                                                       *
 *  This file assumes the following declared in nnstruct:                *
 *                               NUMNODES[]  number nodes in each layer  *
 *                                                                       *
 *-----------------------------------------------------------------------*)
(* Function Display Layer displays layer Layer of net N formatted to width *)
(* W, where W is a number of nodes.                                        *)
procedure DisplayLayer(var N: NNETtype; Layer: integer; W: integer);
var
  u: integer;   (* looping variable for units      *)
begin
   if (Layer = 0) then writeln(' I:') (* tags which layer is outputted   *)
   else if (Layer = (NUMLAYERS-1)) then write(' O:')
   else writeln('H', Layer:2,':');
   for u:= 0 to NUMNODES[Layer]-1 do begin  (* show activations   *)
     writeln(N.unt[Layer,u].state:6:2);
     if ( (((u+1) mod W)=0) and ((u+1) <> NUMNODES[Layer]) ) then writeln;
   end;
end;

(*-----------------------------------------------------------------------*
 * This file contains the functions for calculating the error and weight *
 * changes for the backpropagation algorithm for the network.  Defined   *
 * in this file are EPSILON, the weight change increment/coefficient,    *
 * and function that updates the weights [UpDateWeightandThresh()].  It  *
 * also contains code for a function called GetDerivs(), but this is to  *
 * be used in the function UpDateWeightsandDerivs(), not by a main       *
 * program.  It also contains a function InitOutPatterns, which is       *
 * similar to InitPatterns for the input patterns, but takes from a      *
 * different file that would contain the corresponding desired output    *
 * patterns for the set of input patterns.                               *
 *-----------------------------------------------------------------------*)
procedure InitOutPatterns(Path: string; var patns: PATTERNtype);
var
  InFile: text;    (* file w/ pattern *)
  val: real;       (* pattern value   *)
  P, U: integer;   (* loop variables  *)
begin
  {$I-}
  Assign(InFile,Path);
  reset(InFile);
  {$I+}
  if (IOResult <> 0) then begin
    writeln('File nnoutput.dat does not exist!');
    exit;
  end;
  for P:= 0 to NUM_PATTERNS-1 do begin (* for each pattern.... *)
    for U:= 0 to OUTPUT_LAYER_SIZE-1 do begin (*  for each unit in it:*)
      read(InFile, val);
      patns.p[P,U]:= val;
    end;
  end;
  close(InFile);
end;

procedure GetDerivs(const n: NNETtype; const GoalOut: PATTERNtype; pattern: integer; var Deriv2: tERRORtype);
var
  layer : integer;
  node  : integer;
  tonode: integer;
  Deriv1: tERRORtype;  (* for holding dE/dy *)
begin
  layer:= NUMLAYERS - 1;        (* set layer to output layer *)
  (* calculate dE/dy for output nodes *)
  for node:= 0 to NUMNODES[layer]-1 do begin (* for each output node *)
    Deriv1.e[layer,node]:= GoalOut.p[pattern,node] - n.unt[layer,node].state;
  end;
  (* calculate dE/ds for output nodes *)
  for node:= 0 to NUMNODES[layer]-1 do begin
    case n.unt[layer,node].actfn of
      0: Deriv2.e[layer,node]:= Deriv1.e[layer,node]; (* if it's a linear node...  *)
      1: Deriv2.e[layer,node]:=
        Deriv1.e[layer,node] * n.unt[layer,node].state * (1.0 - n.unt[layer,node].state); (* if it's a logistic node...*)
    end;
  end;
  (* calculate  dE/dy and dE/ds for hidden layers (backwards from output,*)
  (* not including input layer).                                         *)
  for layer:= NUMLAYERS-2 downto 1 do begin
    (* calculate dE/dy *)
    for node:= 0 to NUMNODES[layer]-1 do begin
      Deriv1.e[layer,node]:= 0;
      for tonode:= 0 to NUMNODES[layer+1]-1 do begin
        Deriv1.e[layer,node]:= Deriv1.e[layer,node] + Deriv2.e[layer+1,tonode] * n.unt[layer+1,tonode].weights[node];
      end;
    end;
    (* calculate dE/ds *)
    for node:= 0 to NUMNODES[layer]-1 do begin
      case n.unt[layer,node].actfn of
        0: Deriv2.e[layer,node]:= Deriv1.e[layer,node];
        1: Deriv2.e[layer,node]:=
          Deriv1.e[layer,node] * n.unt[layer,node].state * (1.0 - n.unt[layer,node].state);
      end;
    end;
  end;
end;

procedure UpDateWeightandThresh(const nn: NNETtype; const goal: PATTERNtype; p: integer; var newnet: NNETtype);
var
  WeightError: wERRORtype;
  ThreshError: tERRORtype;
  Derivs: tERRORtype;
  layer, uni, inunit: integer;
begin
  (* find WeightError and ThreshError *)
  GetDerivs(nn, goal, p, Derivs);
  for layer:= 1 to NUMLAYERS-1 do begin
    for uni:= 0 to NUMNODES[layer]-1 do begin
      ThreshError.e[layer,uni]:= Derivs.e[layer,uni];
      for inunit:= 0 to NUMNODES[layer-1]-1 do begin
        WeightError.e[layer,uni,inunit]:= Derivs.e[layer,uni] * nn.unt[layer-1,inunit].state;
      end;
    end;
  end;
  (* Change Weights *)
  newnet:= nn;
  for layer:= 1 to NUMLAYERS do begin
    for uni:= 0 to NUMNODES[layer]-1 do begin
      newnet.unt[layer,uni].thresh:= newnet.unt[layer,uni].thresh + EPSILON*ThreshError.e[layer,uni];
      for inunit:= 0 to NUMNODES[layer-1] do begin
        newnet.unt[layer,uni].weights[inunit]:=
          newnet.unt[layer,uni].weights[inunit] + EPSILON*WeightError.e[layer,uni,inunit];
      end;
    end;
  end;
end;

(*-----------------------------------------------------------------------*
 * This file contains the functions for calculating the error and weight *
 * changes for the Hebb rule for unsupervised learning.  Defined         *
 * in this file are COM_EPS, the weight change increment/coefficient,    *
 * and function that updates the weights [UpDateWeightandThresh()].  It  *
 * also contains code for a function called GetDerivs(), but this is to  *
 * be used in the function UpDateWeightsandDerivs(), not by a main       *
 * program.                                                              *
 *                                                                       *
 *-----------------------------------------------------------------------*)
(* Function Definition *)
procedure Com_UpDateWeightandThresh(const oldn: NNETtype; var n: NNETtype);
var
  u, v: integer;
  BIG: integer;
begin
  BIG:= 0;
  n:= oldn;
  for u:= 0 to OUTPUT_LAYER_SIZE do begin
    if (n.unt[1,u].state > 0.0) then begin
      (* increment weights of connex. btw. any co-active nodes *)
      for v:= 0 to INPUT_LAYER_SIZE do begin
        if (n.unt[0,v].state>0.0) then n.unt[1,u].weights[v]:= n.unt[1,u].weights[v] + COM_EPS;
        if (n.unt[1,u].weights[v]>10.0) then BIG:= 1;
      end;
    end;
  end;
  if (BIG=1) then begin
    (* if weights grew too much, scale all down *)
    for u:= 0 to OUTPUT_LAYER_SIZE do begin
      for v:= 0 to INPUT_LAYER_SIZE do begin
        n.unt[1,u].weights[v]:= n.unt[1,u].weights[v] * 0.5;
      end;
    end;
  end;
end;

(*-----------------------------------------------------------------------*
 * This file contains a function for updating activations in a layer in  *
 * an all-or-none format per groupings of nodes.  This file also defines *
 * constants for the number of clusters for each node.  The all-or-none  *
 * cluster function assumes that each cluster will be of the same size,  *
 * so it creates NUM_CLUSTERS_# for layer # each of size                 *
 * NUMNODES[#] / NUM_CLUSTERS_# -- SO IT MUST BE EVENLY DIVISIBLE!       *
 *  In the constant definitions, if a layer is not being used, the number*
 * ofclusters should be set to 0.                                        *
 *                                                                       *
 *  To implement competative learning, all you have to do is include this*
 * file in your main program instead of nnhebbln.c.                      *
 *                                                                       *
 *  For all the references to layers in this module, layers are numbered *
 * 0 - (NUM_LAYERS-1), so the input layer is layer 0.                    *
 *                                                                       *
 *-----------------------------------------------------------------------*)
procedure AllOrNoneLayerActs(const oldn: NNETtype; l: integer; var n: NNETtype);
var
  u: integer;            (* looping variable for nodes                  *)
  c: integer;            (* looping variable for clusters               *)
  Winner: integer;       (* index for winning node                      *)
  NUMCLUSTERS: integer;  (* stores the number of clusters in this layer *)
begin
  n:= oldn;
  (* initialize NUMCLUSTERS *)
  if (l=1) then NUMCLUSTERS:= NUM_CLUSTERS_0
  else if (l= 2) then NUMCLUSTERS:= NUM_CLUSTERS_1
  else if (l= 3) then NUMCLUSTERS:= NUM_CLUSTERS_2
  else if (l= 4) then NUMCLUSTERS:= NUM_CLUSTERS_3
  else if (l= 5) then NUMCLUSTERS:= NUM_CLUSTERS_4
  else if (l= 6) then NUMCLUSTERS:= NUM_CLUSTERS_5
  else if (l= 7) then NUMCLUSTERS:= NUM_CLUSTERS_6
  else if (l= 8) then NUMCLUSTERS:= NUM_CLUSTERS_7
  else if (l= 9) then NUMCLUSTERS:= NUM_CLUSTERS_8
  else if (l=10) then NUMCLUSTERS:= NUM_CLUSTERS_9;
  (* calculate winner of each cluster  *)
  u:= 0;
  for c:= 1 to NUMCLUSTERS do begin (* for each cluster... *)
    Winner:= u;     (* reset winner to 0   *)
    (* calculate winner *)
    for u:= u to (c * (NUMNODES[l] div NUMCLUSTERS))-1 do begin
      (* count units this cluster*)
      if (n.unt[l,u].state>n.unt[l,Winner].state) then Winner:= u;
    end;
    (* reset values for winner takes all  *)
    for u:= 0 to NUMNODES[l]-1 do begin
      if (u=Winner) then n.unt[l,u].state:= 1.0
      else n.unt[l,u].state:= 0.0;
    end;
  end;
end;

procedure InitNN;
begin
  NUMLAYERS:= (NUM_HIDDEN_LAYERS+2);
  MAXNODES := INPUT_LAYER_SIZE;
  if (OUTPUT_LAYER_SIZE>MAXNODES) then MAXNODES:= OUTPUT_LAYER_SIZE;
  if (HL_SIZE_1>MAXNODES)         then MAXNODES:= HL_SIZE_1;
  if (HL_SIZE_2>MAXNODES)         then MAXNODES:= HL_SIZE_2;
  if (HL_SIZE_3>MAXNODES)         then MAXNODES:= HL_SIZE_3;
  if (HL_SIZE_4>MAXNODES)         then MAXNODES:= HL_SIZE_4;
  if (HL_SIZE_5>MAXNODES)         then MAXNODES:= HL_SIZE_5;
  if (HL_SIZE_6>MAXNODES)         then MAXNODES:= HL_SIZE_6;
  if (HL_SIZE_7>MAXNODES)         then MAXNODES:= HL_SIZE_7;
  if (HL_SIZE_8>MAXNODES)         then MAXNODES:= HL_SIZE_8;
  if (HL_SIZE_9>MAXNODES)         then MAXNODES:= HL_SIZE_9;
  if (HL_SIZE_10>MAXNODES)        then MAXNODES:= HL_SIZE_10;
end;

end.
