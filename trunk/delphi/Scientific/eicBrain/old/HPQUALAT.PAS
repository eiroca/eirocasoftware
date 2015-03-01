{$I switches.inc}
{ UNDEF UNIT}

{$IFDEF UNIT}
unit HpQuaLat;

interface

procedure HpQuaLatMain;

implementation
{$ELSE}

{$ENDIF}

uses Crt, MathTool, DataMngr, HpGraf, Graph;

const
  Schemi: array[3..8] of string[80] =
    ('abcbcacab',
     'abcdbadccdbadcab',
     'abcdebaecdcdaebdebacecdba',
     'abcdefbfdcaecdefbadafecbecabfdfebadc',
     'abcdefgbcdefgacdefgabdefgabcefgabcdfgabcdegabcdef',
     'abcdefghbcdefghacdefghabdefghabcefghabcdfghabcdeghabcdefhabcdefg');

var
  ord: integer;
  Dati  : array[1..8,1..8] of PREC;
  SumRow: array[1..8] of PREC;
  SumCol: array[1..8] of PREC;
  SumLet: array[1..8] of PREC;
  RowName,
  ColName,
  LetName: string[80];
  flg: integer;

procedure SelSchema(var i: integer);
(* routine schema quadrato. ordine da 3 a 8.  *)
(* I = origine del quadrato                   *)
(* x1= lung. asse X                           *)
(* y1= lung. asse Y                           *)
var
  x1,y1: integer;
  c,x,y: integer;
begin
  ClrScr;
  repeat
    i:= 3;
    InputInt('Ordine del quadrato (3-8): ',i,3,8);
    if (i<3) or (i<8) then begin
      writeln('Max 8 e min 3');
    end;
  until (i>=3) and (i<=8);
  ClrScr;
  c:= 1;
  for y:= 1 to i do begin
    for x:= 1 to i do begin
      GotoXY(x*2,y*2); write(Schemi[i,c]);
      inc(c);
    end;
  end;
  GotoXY(40, 3); writeln('Q U A D R A T I');
  GotoXY(40, 5); writeln('L A T I N I');
  GotoXY(40, 7); writeln('===============');
  GotoXY(40,10); writeln('3 sorgenti di');
  GotoXY(40,12); writeln('variazione');
  RowName:= '';
  ColName:= '';
  LetName:= '';
  GotoXY( 1,21); InputStr('Nome per le Righe  : ',RowName);
  GotoXY( 1,22); InputStr('Nome per le Colonne: ',ColName);
  GotoXY( 1,23); InputStr('Nome per le Lettere: ',LetName);
  flg:= 1;
end;

procedure InputData(i: integer);
var
  x, y: integer;
  tmp: string;
  err: word;
  ch: char;
  procedure Displaydata(i: integer);
  var x,y: integer;
  begin
    for y:= 1 to i do begin
      GotoXY(1,y*2+6); ClrEOL;
      for x:= 1 to i do begin
        GotoXY(x*9-8,y*2+6); write(Dati[x,y]:0:3);
      end;
    end;
  end;
begin
  ClrScr;
  if flg < 1 then begin
    writeln('Immettere prima lo schema');
    WaitReturn;
    exit;
  end;
  writeln('Variabile righe     ',RowName);
  writeln('Variabile colonne   ', ColName);
  writeln('Variabile lettere   ', LetName);
  writeln('Ordine del quadrato ', i);
  FIllChar(Dati, sizeof(Dati), 0);
  repeat
    DisplayData(i);
    for y:= 1 to i do begin
      for x:= 1 to i do begin
        GotoXY(x*9-8,y*2+6); InputPrec('',Dati[x,y],-inf,inf);
        DisplayData(i);
      end;
    end;
    GotoXY(1,24); GetChar('Tutto Ok (S/N/ESC)? ', ch);
    if ch = #13 then ch:= 'S';
    if (ch=#27) then exit;
  until ch='S';
  flg:= 2;
end;

procedure CalcAnova(i: integer);
var
  jstr: string;
  g1,x,y,z: integer;
  f1,c1: PREC;
  s1, s2, s3, s4: PREC;
  t, tt: PREC;
  sstr: string;
  f: array[3..8] of PREC;
  procedure variabili;
  begin
    f[3]:= 19;
    f[4]:= 4.8;
    f[5]:= 3.2;
    f[6]:= 2.7;
    f[7]:= 2.4;
    f[8]:= 2.2;
  end;
begin
  Variabili;
  ClrScr;
  if i < 3 then begin
    writeln('Immettere i dati!');
    WaitReturn;
    exit;
  end;
  jstr:= 'abcdefgh';
  for x:= 1 to i do begin
    SumRow[x]:= 0;
    SumCol[x]:= 0;
    SumLet[x]:= 0;
  end;
  t:= 0;
  tt:= 0;
  for y:= 1 to i do begin
    for x:= 1 to i do begin
      t:= t + Dati[x,y];
      SumRow[y]:= SumRow[y]+Dati[x,y]; (* righe *)
      SumCol[x]:= SumCol[x]+Dati[x,y]; (* colonne *)
      tt:= tt+sqr(Dati[x,y]);
      g1:= (y-1)*i+x;
      for z:= 1 to i do begin
        if Schemi[i,g1] = jstr[z] then begin
          SumLet[z]:= SumLet[z]+Dati[x,y]; (* lettere *)
          break;
        end;
      end;
    end;
  end;
  s1:= 0;
  s2:= 0;
  s3:= 0;
  c1:= sqr(t)/sqr(i);
  for x:= 1 to i do begin
    s1:= s1 + sqr(SumRow[x]);
    s2:= s2 + sqr(SumCol[x]);
    s3:= s3 + sqr(SumLet[x]);
  end;
  s1:= s1/i-c1; (* ss righe *)
  s2:= s2/i-c1; (* ss colonne *)
  s3:= s3/i-c1; (* ss lettere *)
  s4:= tt- c1-s1-s2-s3; (* ss residuo *)
  if s4 < 0.0001 then s4:= 0.0001;
  ClrScr;
  writeln('SOURCE        S.S.   DF    M.S.   RATIO');
  writeln;
  f1:= S1/(i-1)/(s4/(sqr(i)-3*i+2)); if f1 < f[i] then sStr:= 'N' else Sstr:= 'S';
  writeln(Copy(RowName+'          ',1,10),'  ',s1:7:1,'  ',(i-1):2,'  ',(s1/(i-1)):7:1,'  ',f1:5:1,'  ',sstr);
  f1:= s2/(i-1)/(s4/(sqr(i)-3*i+2)); if f1 < f[i] then sStr:= 'N' else Sstr:= 'S';
  writeln(Copy(ColName+'          ',1,10),'  ',s2:7:1,'  ',(i-1):2,'  ',(s2/(i-1)):7:1,'  ',f1:5:1,'  ',sstr);
  f1:= s3/(i-1)/(s4/(sqr(i)-3*i+2)); if f1 < f[i] then sStr:= 'N' else Sstr:= 'S';
  writeln(Copy(LetName+'          ',1,10),'  ',s3:7:1,'  ',(i-1):2,'  ',(s3/(i-1)):7:1,'  ',f1:5:1,'  ',sstr);
  writeln(Copy('residuo        ',1,10),'  ',s4:7:1,'  ',(sqr(i)-3*i+2):2,'  ',(s4/(sqr(i)-3*i+2)):7:1);
  writeln;
  WaitReturn;
  flg:= 3;
end;

procedure DoGrafici(i: integer);
var
  x: integer;
  h: array[1..8] of PREC;
  procedure DoIt;
  var
    tmp: string;
    x,y: integer;
    ti: TextSettingsType;
    m1: PREC;
  begin
    GetTextSettings(ti);
    XXAsis(0,10,0,80);
    YYAsis(0,10,0,100);
    for y:= 0 to 10 do begin
      move(-10,y*10); str(y*10:3,tmp); OutText(tmp);
    end;
    x:= 5;
    while (x<=75) do begin
      move(x-5,-5); str(((x+5)/10):3:0,tmp); OutText(tmp);
      inc(x,10);
    end;
    Move(0,110); OutText('%');
    m1:= h[1];
    for x:= 2 to i do begin
      if h[x] > m1 then m1:= h[x];
    end;
    SetTextStyle(ti.font, 1,ti.Charsize);
    for x:=1 to i do begin
      move(x*10-5,0);
      y:= round(h[x]/m1*100);
      draw(x*10-5,y);
      if y < 35 then y:= 35;
      Move(x*10-5,y);
      str(h[x]:7:3,tmp);
      OutText(tmp);
    end;
    SetTextStyle(ti.font, 0, ti.Charsize);
    while readkey <> #13 do ;
  end;
begin
  ClrScr;
  if flg < 3 then begin
    writeln('Analizzare varianza prima!');
    WaitReturn;
    exit;
  end;
  GInit;
  Scale(-10,100,-20,120);
  GClear;
  Move(30,110); OutText(RowName);
  for x:=  1 to i do begin
    h[x]:= SumRow[x]/i;
  end;
  DoIt;
  GClear;
  Move(30,110); OutText(ColName);
  for x:=  1 to i do begin
    h[x]:= SumCol[x]/i;
  end;
  DoIt;
  GClear;
  Move(30,110); OutText(LetName);
  for x:=  1 to i do begin
    h[x]:= SumLet[x]/i;
  end;
  DoIt;
  GDone;
end;

procedure HpQuaLatMain;
var
  choice: char;
begin
  flg:= 0;
  repeat
    ClrScr;
    writeln('Quadrati latini');
    writeln;
    writeln;
    writeln('0) Fine programma');
    writeln;
    writeln('1) Schema');
    writeln('2) Input');
    writeln('3) Anva');
    writeln('4) Histog');
    writeln;
    GetChar('Quale? ', choice);
    case choice of
      '1': SelSchema(ord);
      '2': InputData(ord);
      '3': CalcAnova(ord);
      '4': DoGrafici(ord);
    end;
  until choice = '0';
end;

{$IFNDEF UNIT}
begin
  HpQuaLatMain;
{$ENDIF}
end.
