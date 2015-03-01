unit MathTls2;

{$I switches.inc}

interface

uses MathTool;

type
  Point = record
    x, y: PREC;
  end;

  PntArr = array[0..3] of Point;

function  WritePoint(X: Point): char;
procedure SwapPoint(var A, B: Point);
procedure SortPoint(var Pnt: array of Point; SortY: boolean);
function  Len(A, B: Point): PREC;
function  AllinedPoint(const A, B, T: Point): boolean;

procedure MakeLineX(const A, B: Point; var m, p: PREC);
procedure MakeLineY(const A, B: Point; var m, p: PREC);
function  WriteLine(c1, c2: char; m: PREC; const p: PREC): char;
function  WriteLineX(vx, vy: char; const A, B: Point): char;
function  WriteLineY(vy, vx: char; const A, B: Point): char;

procedure DecToBase(i: PREC; var o: string; b: integer);
procedure BaseToDec(i: string; b: integer; var o: PREC);
procedure BaseToBase(i: string; b1: integer; var o: string; b2: integer);

const
  Giorni : array[0..6] of string[15] = (
    'Sabato', 'Domenica', 'Lunedi', 'Martedi', 'Mercoledi', 'Giovedi', 'Venerdi');

function Days(a: longint; m, g: integer): longint;
function DayOfWeek(a: longint; m, g: integer): longint;

implementation

function WritePoint(X: Point): char;
begin
  write('[x:',X.x:10:3,', y:',X.y:10:3,']`');
  WritePoint:= ' ';
end;

function Len(A, B: Point): PREC;
var t1, t2: PREC;
begin
  t1:= (A.x - B.x); t2:= (A.y - B.y);
  Len:= sqrt(sqr((A.x - B.x)) + sqr((A.y - B.y)));
end;

procedure SwapPoint(var A, B: Point);
var
  tmp  : Point;
begin
  tmp:= A;
  A  := B;
  B  := tmp;
end;

procedure SortPoint(var Pnt: array of Point; SortY: boolean);
var
  Ended: integer;
  Srted: boolean;
  Strt : integer;
  i    : integer;
begin
  Strt:= low(Pnt);
  Ended:= High(Pnt)-1;
  Srted:= true;
  repeat
    for i:= Strt to Ended do begin
      if SortY then begin
        if Pnt[i].Y > Pnt[succ(i)].Y then begin
          SwapPoint(Pnt[i], Pnt[succ(i)]);
          Srted:= false;
        end;
      end
      else begin
        if Pnt[i].X > Pnt[succ(i)].X then begin
          SwapPoint(Pnt[i], Pnt[succ(i)]);
          Srted:= false;
        end;
      end;
    end;
    dec(Ended);
  until (srted) or (Ended = 0);
end;

function AllinedPoint(const A,B,T: Point): boolean;
var c1, c2: PREC;
begin
  c1:= A.x - B.x; c2:= A.y - B.y;
  AllinedPoint:= false;
  (* Verifica casi particolare: retta verticale     *)
  if (abs(c1) < Zero) and not(Equal(T.x, A.x)) then exit;
  (* Verifica casi particolare: retta orizzontale   *)
  if (abs(c2) < Zero) and not(Equal(T.y, A.y)) then exit;
  if (abs(c1) > Zero) and not(Equal(T.y, A.y + c2 * (T.x - A.x) / c1)) then exit;
  AllinedPoint:= true;
end;

procedure MakeLineX(const A, B: Point; var m, p: PREC);
begin
  if Equal(B.y, A.y) then begin
    m:= 99999.999;
    p:= 0;
  end
  else begin
    m:= (B.x - A.x) / (B.y - A.y);
    p:= A.x - A.y * m;
  end;
end;

procedure MakeLineY(const A, B: Point; var m, p: PREC);
begin
  if Equal(B.x, A.x) then begin
    m:= 99999.999;
    p:= 0;
  end
  else begin
    m:= (B.y - A.y) / (B.x - A.x);
    p:= A.y - A.x * m;
  end;
end;

function WriteLine(c1,c2: char; m: PREC; const p: PREC): char;
begin
  write(c1); if c1 <> ' ' then write(' = ');
  if (abs(p) > Zero) then write(p:10:3);
  if (abs(p) > Zero) and (abs(m) > Zero) then
    if m > 0 then write(' + ') 
    else begin write(' - '); m:= abs(m); end;
  if (abs(m) > Zero) then begin
    if abs(abs(m)-1) > Zero then write(m:10:3,' ',c2)
    else if m > 0 then write(' ',c2,'        ') 
    else write(' -',c2,'        ');
  end;
  if (abs(p) < Zero) and (abs(m) < Zero) then write(0.0:10:3);
  WriteLine:= ' ';
end;

function WriteLineX(vx, vy: char; const A, B: Point): char;
var
  m, p : PREC;
begin
  MakeLineX(A, B, m, p);
  WriteLineX:= WriteLine(vx, vy, m, p);
end;

function WriteLineY(vy, vx: char; const A, B: Point): char;
var
  m, p : PREC;
begin
  MakeLineY(A, B, m, p);
  WriteLineY:= WriteLine(vy, vx, m, p);
end;

(* DEC TO BASE IN:I,B OUT:O$ *)
procedure DecToBase(i: PREC; var o: string; b: integer);
var
  s: boolean;
  r: integer;
  ch: char;
begin
  o:= '';
  S:= false;
  if (I < 0) then begin
    I:= -I;
    S:= true;
  end;
  repeat
    R:= trunc(I - INT(I / B) * B);
    if r > 9 then ch:= chr(55+r) else ch:= chr(48+r);
    O:= ch + o;
    I:= INT(I / B);
  until i < 1;
  if s then o:= '-'+o;
end;

procedure BaseToDec(i: string; b: integer; var o: PREC);
(* BASE TO DEC IN: I$, B OUT: O *)
var
  j, x, z, s: integer;
begin
  O:= 0;
  S:= 1;
  IF I[1] = '-' THEN begin
    S:= -1;
    delete(i,1,1);
  end;
  Z:= length(I);
  for j:= 1 to z do begin
    X:= ord(I[j]) - 48; IF X > 9 THEN dec(X,7);
    O:= O * B + X;
  end;
  O:= O * S;
end;

procedure BaseToBase(i: string; b1: integer; var o: string; b2: integer);
(* BASE TO BASE IN:I$,B1,B2 OUT: O$ *)
var
  tmp: PREC;
begin
   BaseToDec(i, b1, tmp);
   DecToBase(tmp, o, b2);
end;

function Days(a: longint; m, g: integer): longint;
const
  MD: array[1..12] of integer = (31,28,31,30,31,30,31,31,30,31,30,31);
  (* TABELLA DEI NUMERI DI GIORNI DAL PRIMO DELL'ANNO AL PRIMO DI OGNI MESE *)
  DA: array[1..12] of integer = (0,31,59,90,120,151,181,212,243,273,304,334);
var b: longint;
begin
  (* SOTTOPROGRAMMA PER CALCOLARE IL NUMERO DI GIORNI TRA 0,0,0 E G,M,A *)
  if (a mod 400) = 0 then MD[2]:= 29
  else if (a mod 100) = 0 then MD[2]:= 28
  else if (a mod   4) = 0 then MD[2]:= 29;
  if (a<0) or (m<1) or (m>12) or (g<1) or (g>MD[m]) then begin
    Days:= 0;
    exit;
  end;
  b:= G + DA[m] + A * 365 + A div 4 - A div 100 + A div 400+1;
  if (md[2]=29) and (m < 3) then dec(b);
  Days:= b;
end;

function DayOfWeek(a: longint; m, g: integer): longint;
var
  nn: integer;
  n: PREC;
begin
  if a = 0 then exit;
  IF M <= 2 THEN begin
    (* E' NECESSARIA UNA REGOLAZIONE DEI DATI? *)
    M:= M + 12;
    A:= A - 1
  end;
  N:= G + 2 * M + INT(0.6 * (M + 1)) + A + INT(A / 4) - INT(A / 100) + INT(A / 400) + 2;
  NN:= round((N / 7 - INT(N / 7)) * 7);
  DayOfWeek:= NN;
end;

end.
