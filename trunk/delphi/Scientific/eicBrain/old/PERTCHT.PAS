unit PertCht;

{$I switches.inc}

(*
  PROGRAM; ENHANCED PERT          SOURCE; BYTE, MAY, 1982, PG. 469ff.
  FUNCTION; PERT-CHARTING         DATE;   5/1/82
  VERSION;  1.1                   AUTHOR; T. V. BONOMA
*)
interface

procedure Pert;

implementation

uses DataMngr, MathTool, Crt;

var
  Desc: array[1..500,1..2] of string[20];
  Data: array[1..500,1..11] of PREC;
  ee: PREC;
  NumAtt: integer;

procedure ReadFromKeyb;
var
  i: integer;
  x: integer;
begin
  ClrScr;
  GotoXY(5,5);
  NumAtt:= 1;
  InputInt('How many different tasks do you have  ', NumAtt, 1, maxint);
  EE:=0;
  writeln;
  writeln('OK...let''s enter them one at a time.  for each, we''ll want');
  writeln('an activity code, a description,  a beginning and ending ''event');
  writeln('number'', and optimistic and pessimistic completion estimates.');
  writeln;
  write('Hit any key to enter data'); readln;
  ClrScr;
  GotoXY(35, 1); writeln('DATA ENTRY ROUTINE');
  GotoXY( 5, 3); write('Code');
  GotoXY(10, 3); write('Descript.');
  GotoXY(25, 3); write('Begin?');
  GotoXY(35, 3); write('End?');
  GotoXY(42, 3); write('Optimistic');
  GotoXY(55, 3); write('Likely');
  GotoXY(64, 3); write('Pessimistic');
  X:=4;
  for I:=1 to NumAtt do begin
    GotoXY( 7, X); InputStr('',Desc[I,1]);
    GotoXY(11, X); InputStr('',Desc[I,2]);
    GotoXY(27, X); InputReal('',Data[I,1],-inf,inf);
    GotoXY(36, X); InputReal('',Data[I,2],-inf,inf);
    GotoXY(47, X); InputReal('',Data[I,3],-inf,inf);
    GotoXY(57, X); InputReal('',Data[I,4],-inf,inf);
    GotoXY(69, X); InputReal('',Data[I,5],-inf,inf);
    X:=X+1
  end;
end;

procedure ReadFromDisk;
var
  fn: string;
  fin: text;
  i: integer;
begin
  ClrScr;
  GotoXY(30,5); writeln('DISK INPUT ROUTINE');
  writeln;
  fn:= '';
  InputStr('Name of disk file, e.g., B:xxxxxxx.yyy = ', fn);
  Assign(fin, fn); Reset(fin);
  readln(fin, NumAtt, EE);
  for I:= 1 to NumAtt do begin
    readln(fin, Desc[I,1]);
    readln(fin, Desc[I,2]);
    readln(fin, Data[I,1], Data[I,2], Data[I,3], Data[I,4], Data[I,5]);
    if Desc[I,1] = 'END' then break;
  end;
  close(fin);
end;

procedure CriticalPath;
var
  z, si, co, st, aa, b, c, d, e, p: PREC;
  Path: string;
  flg: boolean;
  i: integer;
begin
  (* Identification of critical path and costs *)
  CO:=0;
  PATH:=' ';
  SI:=0;
  for I:=1 to NumAtt do begin
    if Data[I,11] <= 0.000001 then begin
      CO:=CO+Data[I,6];
      PATH:= PATH + ' ' + Desc[I,1];
      SI:=SI+sqr((Data[I,3] - Data[I,5])/6);
    end;
  end;
  SI:= sqrt(SI);
  ClrScr;
  GotoXY(30,5); writeln('CRITICAL PATH');
  writeln(PATH);
  writeln;
  write('Time of Critical Path  ');
  writeln(CO:12:2);
  writeln;
  InputReal('Scheduled Project Time (use same time units as data)   ',ST,-inf,inf);
  Z:=(ST-CO)/SI;
  flg:= true;
  if Z<0 then begin
    flg:= false;
    Z:=-Z;
  end;
  aA:= 0.4361836;
  B:= -0.1201676;
  C:= 0.937298;
  D:= Power(2.7182818,-sqr(Z)/2) * Power(2*3.1415926,-0.5);
  E:= Power((1+0.3326*Z),-1);
  P:= 1-D*(AA*E+B*Power(E,2)+C*Power(E,3));
  if flg then begin
    write(Z:6:2,'  ');
    write('Probability of being completed on time ');
    writeln(P:5:3);
  end
  else begin
    write(-Z:6:3,' ');
    write('Probability of being completed on time ');
    writeln((1-P):5:3);
  end;
  writeln;
  WaitReturn;
end;

procedure SaveToDisk;
var
  fn: string;
  fout: text;
  i: integer;
begin
  InputStr('Name of disk file ', fn);
  Assign(fout, fn);
  Rewrite(fout);
  write(fout,NumAtt,EE);
  for I:=1 to NumAtt do begin
    writeln(fout, Desc[I,1]);
    writeln(fout, Desc[I,2]);
    writeln(fout, Data[I,1]);
    writeln(fout, Data[I,2]);
    writeln(fout, Data[I,3]);
    writeln(fout, Data[I,4]);
    writeln(fout, Data[I,5]);
  end;
  close(fout);
end;

var
  i, j, k, l: integer;
  tmp: string;
  ch: char;
  srv: PREC;
  XCHECK: integer;
  xm: PREC;
  min, max: PREC;
  tp: PREC;

procedure Pert;
label
  530;
begin
  ClrScr;
  GotoXY(23,1);
  write('PERT/CRITICAL PATH SCHEDULING');
  GotoXY(23, 3); write('ORIGINAL BY S.M. ZIMMERMAN/L.M. CONRAD');
  GotoXY(23, 5); write('MODIFIED/ADAPTED for IBM PC BY');
  GotoXY(23, 7); write('THOMAS V. BONOMA   MAY, 1982');
  writeln;
  write('Note:  Beginning Events will be sorted numerically');
  GotoXY(1,12);
  repeat
    ClrScr;
    GotoXY(25, 5); writeln('MENU FOR INPUT CHOICES');
    GotoXY(20, 7); writeln('K - Keyboard');
    GotoXY(20, 8); writeln('D - Disk File');
    GotoXY(40,14); GetChar('What is your selection  ', ch); ch:= UpCase(ch);
  until (ch in ['K','D']);
  case ch of
    'D': ReadFromDisk;
    'K': ReadFromKeyb;
  end;
530:
  (* Verify the data which was entered. *)
  TP:=0;
  for I := 1 to NumAtt do begin
    if Data[I,2]>TP then TP:=Data[I,2];
  end;
  EE:= TP;
  for I:=1 to NumAtt - 1 do begin
    for J:=I+1 to NumAtt do begin
      if Data[I,1] > Data[J,1] then begin
        for K:=1 to 11 do begin
          srv:= Data[I,K];
          Data[I,K]:= Data[J,K];
          Data[J,K]:= srv;
        end;
        for K:=1 to 2 do begin
          tmp:= Desc[I,K];
          Desc[I,K]:= Desc[J,K];
          Desc[J,K]:= tmp;
        end;
      end;
    end;
  end;
  repeat
    ClrScr;
    writeln('VERIFICATION OF INPUT');
    writeln;
    writeln('No. Code      Description          Begin    End    Optimist  Likely  Pessimist');
    writeln('                                   Event   Event     Time     Time      Time  ');
    K:= 0;
    for I:=1 to NumAtt do begin
      write(i:3,' ');
      write(Desc[I,1]:14,' ',Desc[I,2]:14);
      for J:=1 to 2 do write('  ',Data[I,J]:4:0,'  ');
      for J:=3 to 5 do write(' ',Data[I,J]:7:2,' ');
      K:=K+1;
      if K>=20 then begin
        write('Enter to Page '); readln;
      end;
      writeln;
    end;
    write('Please input(a -2 to add more,-1 to continue, or number (E.G., 03) to change ');
    InputInt('',L,-2,NumAtt);
    if L = -1 then break;
    if L = -2 then begin
      L:=NumAtt+1;
      NumAtt:=L;
      XCHECK:=1;
    end;
    if L <= NumAtt then begin
      writeln;
      InputStr('New Code Name/Letter or END to ABORT  ', Desc[L,1]);
      if Desc[L,1] <> 'END' then begin
        InputStr('New Description           : ', Desc[L,2]);
        InputReal('New Beginning Event Number: ', Data[L,1],-inf,inf);
        InputReal('New Ending Event Number   : ', Data[L,2],-inf,inf);
        InputReal('New Optimistic End        : ', Data[L,3],-inf,inf);
        InputReal('New Likely End            : ', Data[L,4],-inf,inf);
        InputReal('New Pess. End             : ', Data[L,5],-inf,inf);
      end;
    end;
  until false;
  write('HIT ANY KEY TO COMPUTE RESULTS'); readln;
  GotoXY(2,25); write('WAIT.....');
  for I:=1 to NumAtt do begin
    Data[I,6]:= (Data[I,3]+4*Data[I,4]+Data[I,5])/6;
    if Data[I,1] = 1 then begin
      Data[I,7]:=0;
      Data[I,8]:=Data[I,6];
    end
    else begin
      MAX := 0;
      for J:= 1 to NumAtt do begin
        if Data[J,2] = Data[I,1] then begin
          if Data[J,8] > MAX then MAX := Data[J,8];
          Data[I,7]:= MAX;
        end;
      end;
      Data[I,8]:= Data[I,7] + Data[I,6];
    end;
  end;
  (* Backward pass? *)
  XM := 0;
  for I:= NumAtt downto 1 do begin
    if Data[I,2] = EE then begin
      if XM<Data[I,8] then XM := Data[I,8];
    end;
  end;
  for I:=NumAtt downto 1 do begin
    if Data[I,2] = EE then begin
      Data[I,10]:= XM;
    end
    else begin
      MIn :=999999;
      for J:= NumAtt downto 1 do begin
        if Data[I,2] = Data[J,1] then begin
          if Data[J,9] < min then min:= Data[J,9];
          Data[I,10]:= min;
        end;
      end;
    end;
    Data[I,9]:=Data[I,10]-Data[I,6]
  end;
  (* Slack Variable Calculations *)
  for I:=1 to NumAtt do begin
    Data[I,11]:= Data[I,10] - Data[I,8];
  end;
  ClrScr;
  K:=0;
  writeln('                                      RESULTS');
  writeln;
  writeln('Code       Description        Expected  Early   Early   Last   Last  Slack');
  writeln('                               Time     Start   Fin.    Start  Fin.   Time');
  for I:=1 to NumAtt do begin
    if Data[I,11] = 0 then Textcolor(white) else TextColor(yellow);
    write(Desc[I,1]:14,' ',Desc[I,2]:14);
    for J:=6 to 11 do begin
      write(' ',Data[I,J]:6:2,' ');
    end;
    writeln;
    K:=K+1;
    if K =20 then begin
      write('Enter to Page  '); readln;
      K:=0;
    end;
  end;
  repeat
    ClrScr;
    GotoXY(30, 5); writeln('OUTPUT MENU');
    GotoXY(20, 7); writeln('C - Critical Path and Time');
    GotoXY(20, 8); writeln('D - Disk');
    GotoXY(20, 9); writeln('E - END ');
    GotoXY(20,10); writeln('R - Recycle');
    GotoXY(35,20); GetChar('Choice, please...  ', ch); ch:= UpCase(ch);
    case ch of
      'R': goto 530;
      'C': CriticalPath;
      'D': SaveToDisk;
    end;
  until ch = 'E';
end;

end.
