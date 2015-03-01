unit PIBalas;
(* Programmazione Lineare Intera - metodo di Balas *)

{$I switches.inc}

interface

uses MathTool, PlProg, Stack, Dos, DataMngr;

type

  PPIBalas = ^TPIBalas;
  TPIBalas = object(TPL)
     procedure Normalize; virtual;
     procedure Load(const FName: PathStr); virtual;
     function  Calc(var x: TIRow): integer; virtual;
     function  Solv(var x: TIRow): integer; virtual;
     procedure WriteSol(var Sol: TIRow);
    private
     function  CalcI(var x: TIRow): integer; virtual;
     procedure FindAmmis(var Sol: TIRow);
     function GetIn(var Cur: TIRow): integer;
     function Completa(TN: PREC; Cur: PIRow; var x: TIRow): boolean;
  end;

implementation

procedure TPIBalas.Load(const FName: PathStr);
var i: integer;
begin
  inherited Load(FName);
  (* Controllo booleanicita' variabili *)
  for i:= 1 to NumVar do begin
    if VarKin[i] <> 3 then begin
      writeln('Warning: ',VarNam[i],' assumed boolean');
      VarKin[i] := 3;
    end;
  end;
end;

procedure TPIBalas.Normalize;
var 
  Est: char;
  j, k: integer;
begin
  (* Ricerca un minimo *)
  for k:= 0 to NumVar do begin
    A.At(0, k)^:= VarKin[0] * A.At(0, k)^;
  end;
  for k:= 1 to NumVin do begin
    Est:= VinKin[k];
    (* se puoi cambia i >= in <= *)
    if est = 'ò' then begin
      if (A.At(k, 0)^ = 0) then begin
        for j:= 0 to NumVar do begin
          A.At(k, j)^:= -A.At(k, j)^;
        end;
        est:= 'ó';
      end
      else begin
        for k:= 0 to NumVar do begin
          A.At(j, k)^:= -A.At(j, k)^;
        end;
        est:= 'ó';
      end;
    end
    else if est = '=' then begin
      inc(NumVin);
      for k:= 0 to NumVar do begin
        A.At(NumVar, k)^:= -A.At(j, k)^;
        VinKin[NumVar]:= 'ó';
      end;
    end;
  end;
end;

function TPIBalas.Calc(var x: TIRow): integer;
(* Calcola c*x, restituisce 0 se tutto ok, 
    1 se i vaolori di x non sono ammissibili
    2 se i valori di x non rispettano i vincoli *)
var 
  i, j: integer;
  z, tmp: PREC;
begin
  (* Calcolo valore *)
  z:= A.At(0,0)^;
  for i:= 1 to NumVar do begin
    z:= z + x[i] * A.At(0, i)^;
  end;
  z:= -VarKin[0] * z;
  x[0]:= trunc(z);
  (* Controllo ammissibilita' variabili *)
  j:= 0;
  for i:= 1 to numVar do begin
    (* Solo variabili booleane ammissibili *)
    if (x[i] <> 0) and (x[i] <> 1) then begin
      Calc:= j;
      exit;
    end;
  end;
  for i:= 1 to NumVin do begin
    tmp:= -A.At(i, 0)^;
    for j:= 1 to NumVar do begin
      tmp:= tmp + A.At(i,j)^ * x[j];
    end;
    j:= 0;
    case VinKin[i] of
      'ó': if tmp > Zero then j:= 2;
      'ò': if tmp < Zero then j:= 2;
      '=': if abs(tmp) > Zero then j:= 2;
    end;
    if j > 0 then begin
      Calc:= j;
      exit;
    end;
  end;
  Calc:= 0;
end;

function TPIBalas.CalcI(var x: TIRow): integer;
(* Calcola c*x, restituisce 0 se tutto ok, 
    1 se i vaolori di x non sono ammissibili
    2 se i valori di x non rispettano i vincoli *)
var 
  i, j: integer;
  z, tmp: PREC;
begin
  (* Calcolo valore *)
  z:= A.At(0,0)^;
  for i:= 1 to NumVar do begin
    z:= z + x[i] * A.At(0, i)^;
  end;
  z:= -VarKin[0] * z;
  x[0]:= trunc(z);
  (* Controllo ammissibilita' variabili *)
  j:= 0;
  for i:= 1 to NumVin do begin
    tmp:= -A.At(i, 0)^;
    for j:= 1 to NumVar do begin
      tmp:= tmp + A.At(i,j)^ * x[j];
    end;
    if tmp > Zero then begin
      CalcI:= j;
      exit;
    end;
  end;
  CalcI:= 0;
end;

procedure TPIBalas.FindAmmis(var Sol: TIRow);
var 
  i, ires: integer;
  ch: char;
begin
  repeat
    GetChar('Immissione diretta soluzione ammissibile iniziale? ',ch);
  until ch in ['S','N'];
  if ch = 'S' then begin
    for i:= 1 to NumVar do begin
      Sol[i]:= 0;
      write('Valore componente #',i:2,' = '); InputInt('',Sol[i],-maxint,maxint);
    end;
    writeln('controllo 0 = ', CalcI(Sol));
  end
  else begin
    FillChar(Sol, sizeof(sol), 0);
    ires:= CalcI(Sol);
    while ires <> 0 do begin
      for i:= 1 to NumVar do begin
        Sol[i]:= trunc(random(2)); (* restiturisce o 0 o 1 *)
      end;
      ires:= CalcI(Sol);
    end;
  end;
end;

procedure TPIBalas.WriteSol(var Sol: TIRow);
var i: integer;
begin
  for i:= 1 to NumVar do begin
    if Sol[i] >= 0 then write(Sol[i]:5,' ') else write(Sol[i]+100:4,'# ') 
  end;
  writeln(' z = ',VarKin[0]*Sol[0]:10);
end;

function TPIBalas.GetIn(var Cur: TIRow): integer;
var 
  min: PREC;
  j, i: integer;
begin
  min:= Inf; j:= 0;
  for i:= 1 to NumVar do begin
    if Cur[i] < 0 then begin
      if j = 0 then begin
        j:= i;
        min:= A.At(0, i)^;
      end
      else if A.At(0, i)^ < Min then begin
        min:= A.At(0, i)^;
        j:= i;
      end;
    end;
  end;
  GetIn:= j;
end;

function TPIBalas.Completa(TN: PREC; Cur: PIRow; var x: TIRow): boolean;
var 
  i: integer;
  libere: integer;
  tmp: PREC;
begin
  libere:= 0;
  for i:= 1 to NumVar do begin
    if Cur^[i] < 0 then inc(libere);
  end;
  if libere = 0 then begin
    tmp:= A.At(0, 0)^;
    A.At(0, 0)^:= TN;
    if (CalcI(Cur^) = 0) and (Cur^[0] < tmp) then begin
      tmp:= Cur^[0]-1;
      x:= Cur^;
    end;
    Dispose(Cur);
  end;
  Completa:= (libere = 0);
end;

function TPIBalas.Solv(var x: TIRow): integer;
var
  Sol, Cur: PIRow;
  Stack: PStack;
  libere, i, j: integer;
  sum: TCol;
  tmp, TN: PREC;
label Continua, Esci;
begin
  Normalize;
  tn:= A.At(0,0)^;
  New(Sol);
  FindAmmis(x);
  for i:= 1 to NumVar do x[i]:= x[i] -100; (* >= 0 assegnate *)
  (* Attenzione deve esistere -0 < 0!!!!*)
  Stack:= New(PStack, Init(Sizeof(TIRow), 20, 5, false));
  (* uso come termine noto il valore di z di una soluzione ammissibile *)  
  A.At(0,0)^:= x[0]-1;
  Sol^:= x;
  (* Immette le prime soluzioni da provare *)
  j:= GetIn(Sol^);
  Sol^[j]:= 0;
  Stack^.Push(Sol);
  New(Cur);
  Cur^:= Sol^;
  Cur^[j]:= 1;
  Stack^.Push(Cur);
  (* Inizia il ciclo *)
  repeat
  Esci:
    Cur:= Stack^.Pop;
    if Cur = nil then begin
      Stack^.Done;
      exit;
    end;
  Continua:
    (* Test 1 - Ammissibilita' soluzione *)
    writeln('Effettuo test 1 con soluzione: '); writeSol(Cur^);
    for i:= 0 to NumVin do begin
      sum[i]:= -A.At(i, 0)^;
      for j:= 1 to NumVar do begin
        if Cur^[j] >= 0 then Sum[i]:= Sum[i] + A.At(i, j)^ * Cur^[j]
        else if (A.At(i, j)^ < 0) then sum[i]:= sum[i] + A.At(i, j)^;
      end;
      if sum[i] >= 0 then begin
        Dispose(Cur);
        Cur:= nil;
        Writeln('Soluzione inammissibile. Killata');
        Goto Esci;
      end;
    end;
    (* Test 2 - provo a completare la soluzione *)
    for i:= 0 to NumVin do begin
      for j:= 1 to NumVar do begin
        if Cur^[j] >= 0 then continue; (* Variabile gia' assegnata *)
        if (Sum[i] + abs(A.At(i,j)^)) > 0 then begin
          if A.At(i, j)^ > 0 then Cur^[j]:= 0
          else Cur^[j]:= 1;
          i:= 1;
          while (Cur^[i] >= 0) and (i<= NumVar) do inc(i);
          if i > NumVar then begin
            A.At(0, 0)^:= TN;
            if (CalcI(Cur^) = 0) then begin
              A.At(0,0)^:= Cur^[0]-1;
              x:= Cur^;
            end;
            Goto Esci;
          end
          else Goto Continua;
        end;
      end;
    end;
    (* Introduce nuove soluzioni possibili *)
    j:= GetIn(Cur^);
    if j = 0 then Goto Esci; (* No posso espandere *)
    (* Aggiunge due nuovi rami *)
    New(Sol);
    Sol^:= Cur^;
    Sol^[j]:= 1;
    if not Completa(tn, Sol, x) then Stack^.Push(Sol);
    Cur^[j]:= 0;
    if not Completa(tn, Cur, x) then Stack^.Push(Cur);
  until false;
  A.At(0,0)^:= TN;
end;

end.
