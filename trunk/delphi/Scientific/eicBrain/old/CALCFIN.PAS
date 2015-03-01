uses DataMngr, MathTool, Crt;

var
  ch: char;
  LStr: string;
  pu: real;
  a: integer;
  top, btn: integer;
  PK, j, K, ga, g, i: integer;
  L, V1, v: integer;
  XPos, YPos: array[0..9] of integer;
  I3, T, p: real;
  Q, kArr: array[0..1] of real;
  TipoData: array[0..1] of string;
  TipoAnno: array[1..2] of string;
  TipoTasso: array[0..2] of string;
  TArr: array[0..20] of real;
  TipoInter, I0Str: string;
  MenuStr: array[0..20] of string;
  TStr, Menu2: array[0..20] of string;
  jArr: array[0..5,0..5] of real;
  jj, k1, k2: integer;

function MakeStr(x: real; n,d: integer): string;
var tmp: string;
begin
  Str(x:n:d, tmp);
  MakeStr:= tmp;
end;

function Value(var x: string): real;
var
  err: integer;
  tmp: real;
begin
  Val(x, tmp, err);
  if err = 0 then Value:= tmp else Value:= 0;
end;

procedure Gosub150;
begin
  MenuStr[ 0]:= 'MENU PRINCIPALE';
  MenuStr[ 1]:= 'INTERESSE SEMPLICE';
  MenuStr[ 2]:= 'SCONTO SEMPLICE';
  MenuStr[ 4]:= 'SCONTO RAZIONALE';
  MenuStr[ 3]:= 'INTERESSE COMPOSTO';
  MenuStr[ 5]:= 'SCONTO COMPOSTO';
  MenuStr[ 6]:= 'TASSI EQUIVALENTI';
  MenuStr[ 7]:= 'RENDITA';
  MenuStr[ 8]:= 'COSTITUZIONE CAPITALE';
  MenuStr[ 9]:= 'RATEIZZAZIONI';
  MenuStr[10]:= 'RICHIAMO DATI DA DISCO';
  I:= 10;
  V:= 0;
end;

procedure Centra(const X: string);
begin
  GotoXY(40-length(X) div 2, WhereY);
  writeln(X);
end;

procedure Gosub50;
begin
  Window(1,1,80,25);
  ClrScr;
  GotoXY(1,1);
  Centra(MenuStr[0]);;
  top:= 8;
  Window(1, top, 80, btn);
end;

procedure Gosub260;
begin
  Centra('I per tornare indietro');
  Centra('X per indicare l''incognita');
  Centra('** Devi indicare due incognite **');
  Centra('ESC per uscire');
  Centra('S per stampare i risultati');
  ClrScr;
  writeln('VUOI I CALCOLI EFFETTUATI CONSIDERANDO:');
  writeln;
  writeln('  1) L''ANNO CIVILE, DI 365 GIORNI');
  writeln('  2) L''ANNO COMMERCIALE, DI 360 GIORNI');
  writeln;
  writeln;
  InputInt('      FAI LA SCELTA ', G, 1, 2);
  if G= 2 then GA:= 360 else GA:= 365;
  Gosub580;
end;

procedure Gosub230;
begin
  MenuStr[4]:= 'TEMPO: ANNI ';
  MenuStr[5]:= '       MESI ';
  MenuStr[6]:= '       GIORNI ';
  I:= 6;
  Gosub260;
end;

procedure Gosub190;
begin
  MenuStr[0]:= 'MONTANTE ';
  MenuStr[1]:= 'CAPITALE ';
  MenuStr[3]:= 'TASSO ANNUO % ';
  MenuStr[2]:= 'INTERESSI ';
  Gosub230;
end;

procedure Gosub240;
begin
  MenuStr[0]:= 'INTERESSE COMPOSTO';
  Gosub50;
  Gosub190;
end;

procedure Gosub220;
begin
  MenuStr[0]:= 'CAPITALE ';
  MenuStr[1]:= 'Value. ATTUALE ';
  MenuStr[2]:= 'SCONTO ';
  MenuStr[3]:= 'SCONTO % ';
  Gosub240;
end;

procedure Gosub210;
begin
  MenuStr[0]:= 'SCONTO RAZIONALE';
  Gosub50;
  Gosub220;
end;

procedure Gosub200;
begin
  MenuStr[0]:= 'SCONTO SEMPLICE';
  Gosub50;
  Gosub220;
end;

procedure Gosub180;
begin
  MenuStr[0]:= 'INTERESSE  SEMPLICE';
  Gosub50;
  Gosub190;
end;

procedure Gosub250;
begin
  MenuStr[0]:= 'SCONTO COMPOSTO';
  Gosub50;
  Gosub220;
end;

procedure Gosub1690;
begin
  T:= (TArr[5] + TArr[8]) / 12 + (TArr[6] + TArr[9]) / 365;
  if TStr[4] <> 'X' then I3:= (TArr[3] + TArr[7] * T) / 100 else I3:= (Pow(1 + TArr[3] / 100, T) - 1);
  if K2 = 2 then K:= 1
  else if K2 = 1 then K:= -1;
  if K=1  then jArr[3, 1]:= I3 * 100;
  if K=-1 then jArr[3, 1]:= I3 * 100 / (1 + K * I3);
  if T <> 0 then begin
    jArr[1, 0]:= (Pow(1 + jArr[3, 0] * 0.01, 1 / T) - 1) * 100;
    jArr[2, 0]:= jArr[3, 0] / T;
    jArr[1, 1]:= (Pow(1 + jArr[3, 1] * 0.01, 1 / T) - 1) * 100;
    jArr[2, 1]:= jArr[3, 1] / T;
  end;
  top:= 17;
  Window(1, top, 80, btn);
  ClrScr;
  if K2 <= 0 then begin
    writeln('TASSO EFFETTIVO ANNUO ... ', jArr[1, 0]);
    writeln('TASSO NOMINALE .......... ', jArr[2, 0]);
    writeln('TASSO PER ', TArr[5] + TArr[8], ' MESI E ', TArr[6] + TArr[9], ' GIORNI ..', jArr[3, 0]);
  end
  else begin
    writeln('TASSI APPLICATI IN VIA: ');
    writeln('                  ANTICIPATA  POSTICIPATA');
    MenuStr[1]:= 'EFFETTIVO ';
    MenuStr[2]:= 'NOMINALE ';
    MenuStr[3]:= 'PER ' + MakeStr(TArr[5] + TArr[8], 5, 0) + 'M. E ' + MakeStr(TArr[6] + TArr[9], 5, 0) + 'G.';
    if T = 0 then begin
      write  ('TASSO ........'); GotoXY(17, WhereY); write(jArr[3, 0]); GotoXY(29, WhereY); writeln(jArr[3, 1]);
    end
    else begin
      for jj:= 1 to 3 do begin
        write(MenuStr[jj]);
        GotoXY(17, WhereY); write(jArr[jj, 0]);
        GotoXY(29, WhereY); writeln(jArr[jj, 1]);
      end;
    end;
  end;
end;

procedure Gosub310;
begin
  LStr:= '';
  PU:= 0;
  repeat
    ch:= readkey; if ch = #00 then a:= 256 + ord(readkey) else a:= ord(ch);
    if a = 13 then begin
      if Length(LStr) <> 0 then ClrEol;
      writeln;
      break;
    end;
    if a = 27 then begin
    (* POP *)
      exit;
    end;
    if not((V = 0) or (V <= 6) and (V1 = 0)) then begin
      if (Length(LStr) = 0) and (a = 67) and (V > 5) or (a = 88) or (a = 73) then exit;
      if (a = 46) and (PU = 0) then begin
        PU:= 1;
        LStr:= LStr + ch;
        write(ch);
      end;
    end;
    if a = 8 then begin
      L:= Length(LStr);
      if L < 2 then begin
        PU:= 0;
        LStr:= '';
        if V < 6 then Q[j]:= 0;
      end;
      if (L < 2) and (PK = 0) and (jj < 11) then TArr[jj]:= 0;
      if L > 1 then if LStr[length(LStr)] = '.' then PU:= 0;
      if L <> 0 then begin
        write(chr(8), ' ', chr(8));
        if L > 1 then LStr[0]:= chr(Length(LStr)-1);
      end;
      continue;
    end;
    if (a < 48) or (a > 57) then continue;
    LStr:= LStr + ch;
    write(ch);
  until false;
end;

procedure Gosub1510;
var
  j: integer;
label 1530, 1540;
begin
  MenuStr[0]:= 'TASSI EQUIVALENTI';
  Gosub50;
  Centra('X per l''opzione o l''incognita');
  Centra('C per cancellare l''opzione');
  Centra('I per tornare indietro');
  Centra('ESC per uscire');
  Centra('S per stampare i risultati');
  Menu2[1]:= 'INTERESSI CALCOLATI IN VIA:ANTICIPATA '; XPos[1]:=  1; YPos[1]:=  1;
  Menu2[2]:= 'POSTICIPATA ';                           XPos[2]:= 27; YPos[2]:=  2;
  Menu2[3]:= 'TASSO EFFETTIVO ';                       XPos[3]:=  1; YPos[3]:=  3;
  Menu2[4]:= 'RIFERITO A:1 ANNO ';                     XPos[4]:=  1; YPos[4]:=  4;
  Menu2[5]:= 'OPPURE A:MESI ';                         XPos[5]:=  1; YPos[5]:=  5;
  Menu2[6]:= 'GIORNI ';                                XPos[6]:= 28; YPos[6]:=  5;
  Menu2[7]:= 'TASSO NOMINALE  ';                       XPos[7]:=  1; YPos[7]:=  7;
  Menu2[8]:= 'CONVERTIBILE IN:MESI ';                  XPos[8]:=  1; YPos[8]:=  8;
  Menu2[9]:= 'GIORNI ';                                XPos[9]:= 28; YPos[9]:=  8;
  for j:= 1 to 9 do begin
    TStr[j]:= '=';
    TArr[j]:= 0;
    GotoXY(XPos[j], YPos[j]);
    writeln(Menu2[j], TStr[j]);
  end;
  K1:= 0;
  K2:= 0;
  jj:= 0;
  repeat
    1530:
    jj:= jj + 1;
    if jj = 10 then begin
      Gosub1690;
      exit;
    end;
  1540:
    GotoXY(XPos[jj], YPos[jj]);
    writeln(Menu2[jj], TStr[jj]);
    GotoXY(XPos[jj] + Length(Menu2[jj]), YPos[jj]);
    Gosub310;
    if LStr = '.' then GOto 1540;
    if a <> 88 then begin
      if a = 73 then begin
        jj:= jj - 1;
        if (jj = 1) then jj:= jj+1;
        if (jj = 8) and (TStr[4] = 'X') or (jj = 7) then jj:= jj - 3;
        GOto 1540;
      end;
      if a = 67 then begin
        if jj < 3 then K2:= 0;
        TStr[jj]:= '=';
        TArr[jj]:= 0;
        ClrEol;
        GOto 1540;
      end;
      if Length(LStr) = 0 then begin
        if (jj < 3) or (jj = 4) or (jj = 5) or (jj = 8) or (TStr[jj] = 'X') or (TArr[jj] <> 0) or (jj = 6)
           and (TArr[5] + K2 <>  0) or (jj = 9) and (TArr[8] <> 0) then begin
          if (jj= 6) then jj:= jj + 3;
          if (TStr[jj] = 'X') and ((jj = 3) or (jj = 4)) then jj:= jj- 3;
          GOto 1530;
        end;
        GOto 1540
      end;
      if (jj < 3) or (jj = 4) or (Value(LStr) = 0) and ((jj = 3) or (jj = 7)) then GOto 1540;
      TStr[jj]:= LStr;
      TArr[jj]:= Value(LStr);
      if jj = 3 then begin
        TStr[7]:= '=';
        TArr[7]:= 0;
        GotoXY(YPos[7], XPos[7] + Length(Menu2[7]));
        write('=');
        ClrEol;
      end;
      if (jj > 4) and (jj < 7) then begin
        for K:= 8 to 9 do begin
          TStr[K]:= '=';
          TArr[K]:= 0;
          GotoXY(YPos[K], XPos[K]);
          write(Menu2[K], '=');
          ClrEol;
        end;
      end;
      if jj = 6 then jj:= jj + 3 ;
      GOto 1530;
    end;
    if jj > 4 then GOto 1540;
    TStr[jj]:= ch;
    writeln(ch);
    if jj < 3 then begin
      K:= K2;
      K2:= jj;
      jj:= 2;
      if TStr[1] = TStr[2] then begin
        TStr[K]:= '=';
        GotoXY(XPos[K], YPos[K]);
        writeln(Menu2[K], '=');
      end;
    end;
    if jj = 3 then begin
      TArr[jj]:= 0;
      for jj:= 4 to 6 do begin
        TStr[jj]:= '=';
        TArr[jj]:= 0;
        GotoXY(XPos[jj], YPos[jj]);
        write(Menu2[jj], '=');
        ClrEol;
      end;
     GOto 1540;
    end;
    if jj = 4 then begin
      for jj:= 5 to 6 do begin
        TStr[jj]:= '=';
        TArr[jj]:= 0;
        GotoXY(XPos[jj], YPos[jj]);
        write(Menu2[jj], '=');
        ClrEol;
      end;
    end;
  until false;
end;

procedure Gosub2210;
begin
  Window(1,1,80,25);
  ClrScr;
  writeln('I per retrocedere    R per archiviare');
  writeln('C per cambiare il    S per stampare');
  writeln('modo di calcolo de-  ESC per quadro');
  writeln('gli interessi        precedente');
  top:= 5;
  Window(1,top,80,btn);
end;

procedure Gosub2220;
begin
  ClrScr;
  writeln;
  writeln(' Il programma ha come dati di default');
  writeln('il calcolo del VERSAMENTO posticipato');
  writeln('con tasso annuo posticipato nominale.');
  writeln('In qualsiasi momento vuoi cambiare le');
  writeln('condizioni di calcolo premi la lette-');
  writeln('ra "C".');
  writeln;
  writeln;
  writeln('Premere <RETURN> [ ]', chr(8), chr(8));
  readkey;
  YPos[0]:= 6;
  P:= 0;
  KArr[1]:= 0;
  KArr[0]:= 0;
end;

procedure Gosub70;
begin
  top:= 16;
  Window(1,1,80,25);
  ClrScr;
  writeln('TIPO DI VERSAMENTO');
  writeln;
  writeln('  1] VERSAMENTO POSTICIPATO');
  writeln('  2] VERSAMENTO ANTICIPATO');
  writeln;
  write('SCEGLI UN NUMERO ',P + 1);
  repeat
    ch:= readkey; if ch = #0 then readkey;
    if ch in ['1'..'2'] then begin
      p:= ord(ch)-ord('0');
      break;
    end;
    if ch = #13 then break;
    if ch = #27 then exit;
  until false;
  writeln;
  ClrScr;
  writeln('INTERESSI CALCOLATI IN VIA:');
  writeln;
  writeln('  1] POSTICIPATA');
  writeln('  2] ANTICIPATA');
  writeln;
  write('SCEGLI UN NUMERO ', KArr[0] + 1);
  repeat
    ch:= readkey; if ch = #0 then readkey;
    if ch in ['1'..'2'] then begin
      KArr[0]:= ord(ch)-ord('0');
      break;
    end;
    if ch = #27 then exit;
    if ch = #13 then break;
  until false;
  ClrScr;
  writeln('TASSO:');
  writeln;
  writeln('  1] NOMINALE CONVERTIBILE');
  writeln('  2] EFETTIVO ANNUO');
  writeln('  3] RIFERIto AL PERIODO');
  writeln;
  write('SCEGLI UN NUMERO ', KArr[1] + 1);
  repeat
    ch:= readkey; if ch = #0 then readkey;
    if ch in ['1'..'2'] then begin
      KArr[1]:= ord(ch)-ord('0');
      break;
    end;
    if ch = #27 then exit;
    if ch = #13 then break;
  until false;
end;

procedure Gosub1890;
var instr: string;
begin
  ClrScr;
  INStr:= '';
  for jj:= 0 to I do begin
    if jj > 0 then GotoXY(4, YPos[jj]) else GotoXY( 1, YPos[jj]);
    write(MenuStr[jj], ' ');
    if jj <> 0 then writeln(TArr[jj]);
    YPos[jj + 1]:= YPos[jj] + 1;
    if (jj = 0) then inc(YPos[jj+1]);
  end;
  for jj:= 1 to I do begin
    repeat
      GotoXY(29, YPos[jj]);
      Gosub310;
      if a = 67 then begin
        PK:= 1;
        Gosub70;
        ClrScr;
        PK:= 0;
        top:= 5;
        Window(1,top,80,btn);
      end
      else if a = 73 then begin
        jj:= jj - 1;
        if jj = 0 then jj:= 1;
      end
      else if Value(LStr) > 0 then break
      else if (Length(LStr) = 0) and (TArr[jj] <> 0) and (a = 13) then exit
      else if Length(LStr) <> 0 then break;
    until false;
    TArr[jj]:= Value(LStr);
  end;
end;

procedure Gosub1880;
begin
  for jj:= 0 to 8 do TArr[jj]:= 0;
  Gosub1890;
end;

procedure Gosub1860;
begin
  MenuStr[0]:= '  Value. ATTUALE R.';
  MenuStr[1]:= 'TASSO % ................';
  MenuStr[2]:= 'IMPORTO RATA ...........';
  MenuStr[3]:= 'PERIODICITA'' MESI ......';
  MenuStr[4]:= 'NUMERO DEI VERSAMENTI ..';
  MenuStr[5]:= 'DIFFERIMENTO MESI ......';
  I:= 5;
  Gosub1880;
end;

procedure Gosub1850;
begin
  MenuStr[0]:= '  MONTANTE DELLA R. ';
  MenuStr[1]:= 'TASSO % ................';
  MenuStr[2]:= 'IMPORTO RATA ...........';
  MenuStr[3]:= 'PERIODICITA'' MESI ......';
  MenuStr[4]:= 'NUMERO DEI VERSAMENTI ..';
  TArr[5]:= 0;
  I:= 4;
  GoSub1880;
end;

procedure Gosub1990;
begin
  MenuStr[0]:= '  IMPORTO RATA';
  MenuStr[1]:= 'TASSO % ................';
  MenuStr[2]:= 'VALORE ATTUALE .........';
  MenuStr[3]:= 'PERIODICITA'' MESI ......';
  MenuStr[4]:= 'NUMERO DEI VERSAMENTI ..';
  MenuStr[5]:= 'DIFFERIMENTO MESI ......';
  I:= 5;
  GOsub1880;
end;

procedure Gosub2010;
begin
  MenuStr[0]:= '  TASSO RENDITA';
  MenuStr[1]:= 'IMPORTO VERSAMENTO .....';
  MenuStr[2]:= 'VALORE ATTUALE .........';
  MenuStr[3]:= 'PERIODICITA'' MESI ......';
  MenuStr[4]:= 'NUMERO DEI VERSAMENTI ..';
  MenuStr[5]:= 'DIFFERIMENTO MESI ......';
  I:= 5;
  Gosub1880;
end;

procedure Gosub2070;
begin
  MenuStr[0]:= '  N.o VERSAMENTI R. ';
  MenuStr[1]:= 'TASSO ..................';
  MenuStr[2]:= 'VALORE ATTUALE .........';
  MenuStr[3]:= 'PERIODICITA'' MESI ......';
  MenuStr[4]:= 'IMPORTO DEL VERSAMENTO .';
  MenuStr[5]:= 'DIFFERIMENTO MESI ......';
  I:= 5;
  GOsub1880;
end;

procedure Rendita;
begin
  Gosub2210;
  Centra(' --------------RENDITA--------------- ');
  if V1 = 0 then Gosub2220;
  repeat
    ClrScr;
    writeln;
    writeln(' VUOI CALCOLARE:');
    writeln;
    writeln;
    writeln('  1] IL MONTANTE');
    writeln('  2] IL VALORE ATTUALE');
    writeln('  3] L''IMPORTO VERSAMENTO');
    writeln('  4] IL TASSO');
    writeln('  5] IL N. DI VERSAMENTI');
    writeln;
    GetChar('SCEGLI UN NUMERO ', ch);
    v1:= ord(ch) - 48;
    case V1 of
      1: Gosub1850;
      2: Gosub1860;
      3: Gosub1990;
      4: Gosub2010;
      5: Gosub2070;
    end;
  until false;
end;

procedure Gosub2290;
begin
  MenuStr[0]:= '  RATA ';
  MenuStr[1]:= 'TASSO % ................';
  MenuStr[2]:= 'CAPITALE ...............';
  MenuStr[3]:= 'PERIODICITA'' MESI ......';
  MenuStr[4]:= 'NUMERO DELLE RATE ......';
  Gosub1880;
end;

procedure Gosub2300;
begin
  MenuStr[0]:= '  TASSO ';
  MenuStr[1]:= 'CAPITALE ...............';
  MenuStr[2]:= 'IMPORTO RATA ...........';
  MenuStr[3]:= 'PERIODICITA'' MESI ......';
  MenuStr[4]:= 'NUMERO DELLE RATE ......';
  Gosub1880;
end;

procedure Gosub2310;
begin
  MenuStr[0]:= '  CAPITALE ';
  MenuStr[1]:= 'TASSO ..................';
  MenuStr[2]:= 'IMPORTO RATA ...........';
  MenuStr[3]:= 'PERIODICITA'' MESI ......';
  MenuStr[4]:= 'NUMERO DELLE RATE ......';
  Gosub1880;
end;

procedure Gosub2320;
begin
  MenuStr[0]:= '   No. RATE ';
  MenuStr[1]:= 'TASSO ..................';
  MenuStr[2]:= 'IMPORTO RATA ...........';
  MenuStr[3]:= 'PERIODICITA'' MESI ......';
  MenuStr[4]:= 'CAPITALE ...............';
  GOSub1880;
end;
procedure Gosub2250;
var i: integer;
begin
  Gosub2210;
  Centra(' ----------CAPITALIZZAZIONE---------- ');
  if V1 = 0 then Gosub2220;
  I:= 4;
  repeat
    ClrScr;
    writeln;
    writeln('VUOI CALCOLARE:');
    writeln;
    writeln;
    writeln('  1] LA RATA');
    writeln('  2] IL TASSO');
    writeln('  3] IL CAPITALE');
    writeln('  4] IL NUMERO DELLE RATE');
    writeln;
    GetChar('SCEGLI UN NUMERO ', ch);
    V1:= ord(ch) - 48;
    case V1 of
      1: Gosub2290;
      2: Gosub2300;
      3: Gosub2310;
      4: Gosub2320;
    end;
  until false;
end;

procedure Gosub1220;
begin
  MenuStr[0]:= '  RATA ';
  MenuStr[1]:= 'TASSO % ................';
  MenuStr[2]:= 'DEBITO L. ..............';
  MenuStr[3]:= 'PERIODICITA'' MESI ......';
  MenuStr[4]:= 'NUMERO DELLE RATE ......';
  MenuStr[5]:= 'DIFFERIMENTO MESI ......';
  MenuStr[6]:= 'ACCONTO L. .............';
  Gosub1880;
end;

procedure Gosub1250;
begin
  MenuStr[0]:= '  NUMERO RATE ';
  MenuStr[1]:= 'TASSO %.................';
  MenuStr[2]:= 'DEBITO L................';
  MenuStr[3]:= 'PERIODICITA'' MESI.......';
  MenuStr[4]:= 'IMPORTO RATA ...........';
  MenuStr[5]:= 'DIFFERIMENTO MESI ......';
  MenuStr[6]:= 'ACCONTO L. .............';
  Gosub1880;
end;

procedure Gosub1270;
begin
  MenuStr[0]:= '  ACCONTO ';
  MenuStr[1]:= 'TASSO % ................';
  MenuStr[2]:= 'DEBITO L. ..............';
  MenuStr[3]:= 'PERIODICITA'' MESI ......';
  MenuStr[4]:= 'IMPORTO RATA ...........';
  MenuStr[5]:= 'DIFFERIMENTO MESI ......';
  MenuStr[6]:= 'NUMERO RATE ............';
  Gosub1880;
end;

procedure Gosub1290;
begin
  MenuStr[0]:= '  TASSO R.';
  MenuStr[1]:= 'ACCONTO ................';
  MenuStr[2]:= 'DEBITO L. ..............';
  MenuStr[3]:= 'PERIODICITA'' MESI ......';
  MenuStr[4]:= 'IMPORTO RATA ...........';
  MenuStr[5]:= 'DIFFERIMENTO MESI ......';
  MenuStr[6]:= 'NUMERO RATE ............';
  Gosub1880;
end;

procedure Gosub1310;
begin
  writeln;
  I:= 5;
  MenuStr[0]:= 'PIANO DI AMMORTAMENTO ';
  MenuStr[1]:= 'TASSO ..................';
  MenuStr[2]:= 'DEBITO L. ..............';
  MenuStr[3]:= 'PERIODICITA'' MESI ......';
  MenuStr[4]:= 'NUMERO RATE ............';
  MenuStr[5]:= 'DIFFERIMENTO MESI ......';
  Gosub1880;
end;

procedure Gosub1170;
begin
  Gosub2210;
  Centra('-----------RATEIZZAZIONE------------ ');
  if V1 = 0 then Gosub2220;
  repeat
    ClrScr;
    writeln;
    I:= 6;
    writeln('VUOI CALCOLARE:');
    writeln;
    writeln;
    writeln('  1] LA RATA');
    writeln('  2] IL N. DI RATE');
    writeln('  3] L''ANTICIPO');
    writeln('  4] IL TASSO');
    writeln('  5] IL PIANO AMMORTAMENTO');
    GetChar('SCEGLI UN NUMERO: ', ch);
    V1:= ord(v)- 48;
    case v1 of
      1: Gosub1220;
      2: Gosub1250;
      3: Gosub1270;
      4: Gosub1290;
      5: Gosub1310;
    end;
    I:= 6
  until false;
end;

procedure Gosub2420;
var
  err, v, j, jj: integer;
  LStr: string;
begin
  repeat
    Gosub150;
    Gosub50;
    Centra('____ ESC per finire ____');;
    writeln;
    for j:= 1 to I do begin
      GotoXY(30, WhereY);
      writeln(j:2,') ', MenuStr[j]);
    end;
    j:= 0;
    jj:= 0;
    repeat
      GotoXY(1, 23);
      InputStr('SCEGLI UN NUMERO: ', LStr);
    until (LStr >= '0') and (LStr <= '9');
    V:= trunc(Value(LStr));
    if V = 0 then Gosub2750
    case V of
      1: Gosub180;
      2: Gosub200;
      3: Gosub210;
      4: Gosub240;
      5: Gosub250;
      6: Gosub1510;
      7: Rendita;
      8: Gosub2250;
      9: Gosub1170;
    end;
    V1:= 0;
  until false;
end;

begin
  top:= 1;
  btn:= 25;
  YPos[0]:= 6;
  P:= 0;
  KArr[1]:= 0;
  KArr[0]:= 0;
  TipoData[0]:= ' POST.';
  TipoData[1]:= ' ANT.';
  TipoTasso[0]:= 'NOMINALE';
  TipoTasso[1]:= 'EFFETTIVO';
  TipoTasso[2]:= 'DEL PERIODO';
  TipoInter:= 'TASSO ';
  I0Str:= 'INTERESSI IN VIA';
  TipoAnno[1]:= 'ANNO CIVILE';
  TipoAnno[2]:= 'ANNO COMMERCIALE';
  Gosub2420;
  Window(1,1,80,25);
  ClrScr;
end.

440
if TArr[1] * TArr[2] * TArr[3] * TArr[4]:= 0 then Gosub2710: GOto 1890
D:= TArr[2] * ID: R:= -Int(.5 - D * IN / [I1 ^ P * [1 - 1 / I1 ^ TArr[4]]]]: TI:= 0: TC:= 0: D1:= D
' writeln;er On
LOCATE , 30: writeln('PIANO DI AMMORTAMENTO': writeln;  writeln('DEBITO L. '; TArr[2]; '  * INTERESSI DIFFERIMENTO '; TArr[5]; ' MESI L. '; D - TArr[2]: writeln('RATA '; TipoData[P]; ' L. '; R
writeln('SCADENZA RATE OGNI '; TArr[3]; ' MESI   * SCADENZA PRIMA RATA DOPO '; TArr[5] + TArr[3] * [NOT P]; ' MESI'
writeln(TipoTasso; TipoTasso[KArr[1]]; ' '; TArr[1]; '%': writeln(I0Str; TipoData[KArr[0]]: writeln;  writeln;
LOCATE , 4: writeln('N. RATA';; LOCATE , 15: writeln('QUOTA CAPITALE';; LOCATE , 35: writeln('QUOTA INTERESSI'; SPC[5]; 'DEBITO RESIDUO': writeln;
for j:= 1 to TArr[4]: if j:= 1 and P then QI:= 0: GOto 520
QI:= D * IN
520
TI:= TI + QI: QC:= R - QI: TC:= TC + QC: D:= D - QC
LOCATE , 5: writeln(j;; LOCATE , 21 - Length(MakeStr[Int(QC * [QC < 1E+09]]]] - 11 * [QC >= 1E+09]: writeln(QC;
LOCATE , 41 - Length(MakeStr[Int(QI * [QI < 1E+09]]]] - 11 * [QI >= 1E+09]: writeln(QI;; LOCATE , 61 - Length(MakeStr[Int(D * [D < 1E+09]]]] - 11 * [D >= 1E+09]: writeln(D
NEXT: writeln;  LOCATE , 3:  writeln('toTALI';; LOCATE , 20: writeln(TC;; LOCATE , 40: writeln(TI: writeln('ARROtoNDAMENTI ';; LOCATE , 20: writeln(TC - D1;; LOCATE , 40: writeln(TArr[4] * R - D1 - TI
writeln(writeln;ER OFF: GOto 1890

580
  C:= -1;
  C1:= C;
  C2:= C;
  ClrScr;
  for j:= 0 to I do Q[j]:= 0;
590
  for j:= 0 to I do begin
    writeln(MenuStr[j];
    ClrEol;
    if (C1 = j) or (C2 = j) then writeln('X')
    else writeln(Q[j]);
  end;
  GotoXY(1, 9);
610
  for j:= 0 to I do begin
620
    writeln(MenuStr[j]);
    Gosub310;
    if a = 73 then begin
      GotoXY(1, WhereY - [j = 0]);
      j:= j - [j > 0];
      GOto 620;
    end;
    if j < I - 2 then GOto 650
    if j > I - 2 and a:= 88 then LOCATE , 1: GOto 620
    if Length(LStr] and LStr <> '.' then Q[j]:= Value(LStr]: GOto 690
650
    if a <> 88 then GOto 680
    writeln(aStr;; ClrEol: writeln;  Q[j]:= 0: if C1:= -1 then C1:= j: GOto 710
    if C2:= -1 then C2:= j
    if C1:= j or C2:= j then GOto 710
    C:= C1: C1:= C2: C2:= j: j:= C: LOCATE 9 + j: GOto 620
680
    if Length(LStr]:= 0 and [Q[j] or C1:= j or C2:= j] then GOto 710
    Q[j]:= Value(LStr]: if Q[j]:= 0 then LOCATE 9 + j: GOto 620
690
    if C1:= j then C1:= -1
    if C2:= j then C2:= -1
710
    if j:= I - 2 and [C2:= I - 2 or C1:= I - 2] and C1 > -1 and C2 > -1 then Q[I - 1]:= 0: Q[I]:= 0: j:= I
  NEXT;
  C:= 0;
  for j:= 0 to I - 3 do begin
    C:= C + [Q[j]:= 0];
  end;
  C:= C + [C1:= I - 2 or C2:= I - 2];
  if C <> 2 then begin
    LOCATE 23: writeln('MI DEVI DARE DUE INCOGNITE!!!';; GETA aStr: LOCATE , 1: ClrEol: LOCATE 9: GOto 610
  end;
  if C1 * C2:= [I - 2] * [I - 3] then LOCATE 23: writeln('IL PROBLEMA E' INDEFINIto ';; GETA aStr: LOCATE , 1: ClrEol: LOCATE 9: GOto 610
  if C1 > C2 then C:= C1: C1:= C2: C2:= C
  if C1 and [Q[0] <= Q[2] or Q[0] <= Q[1]] then Gosub2710: GOto 590
  T:= Q[I - 2] + Q[I - 1] / 12 + Q[I] / GA;
  ON V - 1 GOto 900, 780, 990, 990
780
  ON C1 GOto 830, 870
  ON C2 - 1 GOto 790, 800, 810
  Q[1]:= Q[2] * 100 / Q[3] / T: GOto 820
790
  Q[2]:= Q[1] * Q[3] * T / 100: GOto 820
800
  Q[3]:= Q[2] * 100 / Q[1] / T: GOto 820
810
  T:= Q[2] * 100 / Q[1] / Q[3]
820
  Q[0]:= Q[1] + Q[2]: GOto 1080
830
  ON C2 - 2 GOto 840, 850
  Q[2]:= Q[0] * Q[3] * T / [100 + Q[3] * T]: GOto 860
840
  Q[3]:= Q[2] * 100 / [Q[0] - Q[2]] / T: GOto 860
850
  T:= Q[2] * 100 / [Q[0] - Q[2]] / Q[3]
860
  Q[1]:= Q[0] - Q[2]: GOto 1080
870
  if [C2 - 3]:= 1 then GOto 880
  Q[3]:= [Q[0] - Q[1]] * 100 / Q[1] / T: GOto 890
880
  T:= [Q[0] - Q[1]] * 100 / Q[3] / Q[1]
890
  Q[2]:= Q[0] - Q[1]: GOto 1080
900
  ON C1 GOto 940, 970
  ON C2 - 1 GOto 910, 920, 930
  Q[1]:= Q[2] * [100 / Q[3] / T - 1]: GOto 820
910
  Q[2]:= Q[1] * 100 / [100 - Q[3] * T] - Q[1]: GOto 820
920
  Q[3]:= Q[2] * 100 / [Q[1] + Q[2]] / T: GOto 820
930
  T:= Q[2] * 100 / [Q[1] + Q[2]] / Q[3]: GOto 820
940
  ON C2 - 2 GOto 950, 960
  Q[2]:= Q[0] * Q[3] * T / 100: GOto 860
950
  Q[3]:= Q[2] * 100 / Q[0] / T: GOto 860
960
  T:= Q[2] * 100 / Q[0] / Q[3]: GOto 860
970
  ON C2 - 3 GOto 980
  Q[3]:= [Q[0] - Q[1]] * 100 / Q[0] / T: GOto 890
980
  T:= [Q[0] - Q[1]] * 100 / Q[0] / Q[3]: GOto 890
990
  ON C1 GOto 1030, 1060
  ON C2 - 1 GOto 1000, 1010, 1020: Q[1]:= Q[2] / [[[1 + Q[3] / 100] ^ T] - 1]: GOto 820
1000
  Q[2]:= Q[1] * [[1 + Q[3] / 100] ^ T - 1]: GOto 820
1010
  Q[3]:= [[Q[2] / Q[1] + 1] ^ [1 / T] - 1] * 100: GOto 820
1020
  T:= LOG[Q[2] / Q[1] + 1] / LOG[1 + Q[3] / 100]: GOto 820
1030
  ON C2 - 2 GOto 1040, 1050: Q[2]:= Q[0] * [1 - 1 / [Q[3] / 100 + 1] ^ T]: GOto 860
1040
  Q[3]:= [[Q[0] / [Q[0] - Q[2]]] ^ [1 / T] - 1] * 100: GOto 860
1050
  T:= LOG[Q[0] / [Q[0] - Q[2]]] / LOG[1 + Q[3] / 100]: GOto 860
1060
  ON C2 - 3 GOto 1070: Q[3]:= [[Q[0] / Q[1]] ^ [1 / T] - 1] * 100: GOto 890
1070
  T:= LOG[Q[0] / Q[1]] / LOG[1 + Q[3] / 100]: GOto 890
1080
  Q[C1]:= -Int(.5 - Q[C1]]: if C2 <> I - 2 then Q[C2]:= -Int(.5 - Q[C2] * [100 * [C2:= I - 3] + [C2 <> I - 3]]] / [100 * [C2:= I - 3] + [C2 <> I - 3]]
  if C2 <> I - 2 then 1110
  Q[4]:= Int(T]: T:= 12 * [T - Q[4]]: Q[5]:= Int(T]: Q[6]:= -Int([Q[5] - T] * GA / 12 + .5]
1110
  LOCATE 17
1120
  if ST:= 1 then ST:= 0: ' writeln;er on
  for j:= 0 to I: writeln(MIDStr['   X= ', [C1:= j or C2:= j] * 3 + 1, 3];
  writeln(MenuStr[j]; Q[j];; ClrEol: writeln;  NEXT: LOCATE 23, 24: writeln(TipoAnno[G]: GETA aStr: if aStr:= 'S' then ST:= 1: GOto 1120
  top:= 23;
  Window(1,1,80,25);(top to btn
  writeln(writeln;ER OFF
  LOCATE 9
  Q[C1]:= 0: Q[C2]:= 0
  if C2:= I - 2 then Q[I]:= 0: Q[I - 1]:= 0
  GOto 590

  writeln;
'NEXT
  writeln(TipoTasso; TipoTasso[KArr[1]]);
  write  (I0Str; TipoData[KArr[0]]; '.. '; INStr);
  ClrEol;
  writeln;

1330
  if V1 <> 4 then begin
    IN:= TArr[1] / 100;
    Gosub2110;
  end;
ON V1 - 1 GOto 1360, 1400, 1430, 440: if TArr[1] * TArr[2] * TArr[3] * TArr[4]:= 0 or TArr[6] >= TArr[2] then Gosub2710: GOto 1890
TArr[0]:= -Int(.5 - [TArr[2] - TArr[6]] * IN / I1 ^ P * ID / [1 - I1 ^ [-TArr[4]]]]: GOto 1390
1360
if TArr[1] * TArr[2] * TArr[3] * TArr[4]:= 0 or TArr[4] <= [[TArr[2] - TArr[6]] * IN] then Gosub2710: GOto 1890
R:= IN * [TArr[2] - TArr[6]] / TArr[4] / I1 ^ P * ID: if R >= 1 then Gosub2710: GOto 1890
TArr[0]:= -Int(.5 + LOG[1 - R] / LOG[I1] * 100] / 100: if TArr[0] < 0 then Gosub2710: GOto 1890
1390
INStr:= MakeStr[TArr[6] + TArr[0] * TArr[4] - TArr[2]]: Gosub2960: GOto 1890
1400
if TArr[1] * TArr[2] * TArr[3] * TArr[4]:= 0 then Gosub2710: GOto 1890
TArr[0]:= -Int(.5 - TArr[2] + TArr[4] * [1 - I1 ^ [-TArr[6]]] * I1 ^ P / ID / IN]: if TArr[0] < 0 then Gosub2710: GOto 1890
1420
INStr:= MakeStr[TArr[6] * TArr[4] + TArr[V1 - 3] - TArr[2]]: Gosub2960: GOto 1890
1430
if TArr[6] * TArr[2] * TArr[3] * TArr[4]:= 0 or TArr[2] <= TArr[1] then Gosub2710: GOto 1890
if TArr[4] <= [TArr[2] - TArr[1]] / TArr[6] then Gosub2710: GOto 1890
a:= 1: B:= .1: R:= TArr[4] / [TArr[2] - TArr[1]]: E:= R * .000001
1460
ID:= 1: for I1:= a + B to 4 STEP B: if TArr[5] <> 0 then Gosub2150
D:= R - [I1 - 1] / I1 ^ P * ID / [1 - I1 ^ [-TArr[6]]]: if ABS[D] < E then Gosub2170: TArr[0]:= -Int(.5 - IN * 10000] / 100: GOto 1420
if D < 0 then a:= I1 - B: B:= B / 10: GOto 1460
NEXT
1500
COLOR 12, 0: writeln(' IL TASSO E' SUPERIORE AL 300% ': writeln;  COLOR 7, 0: WaitReturn: GOto 1890: RETURN





1951
  ON V - 7 GOto 2330, 1330
  if TArr[1] * TArr[2] * TArr[3] * TArr[4]:= 0 then Gosub2710: GOto 1890
  if V1 <> 4 then IN:= TArr[1] / 100: Gosub2110
  ON V1 - 1 GOto 1980, 2000, 2020, 2080
1980
  K:= [V1:= 1] - [V1:= 2]: TArr[0]:= -Int(.5 - TArr[2] * K * [I1 ^ [K * TArr[4]] - 1] * I1 ^ P * ID ^ K / IN]: Gosub2960: GOto 1890

2000
  TArr[0]:= -Int(0.5 - TArr[2] * IN / I1 ^ P * ID / [1 - I1 ^ [-TArr[4]]]];
  Gosub2960;
  GOto 1890;

2020
  E:= TArr[2] / 1000000;
  a:= 1;
  B:= 0.1;
  if TArr[1] * TArr[4] <= TArr[2] then begin
    Gosub2710:
    GOto 1890;
  end;
2030
  for I1:= a + B to 4 STEP B do begin
    ID:= 1
    if TArr[5] > 0 then Gosub2150
    D:= TArr[1] * [I1 ^ TArr[4] - 1] / [I1 - 1] / I1 ^ [TArr[4] - P] / ID - TArr[2]: if ABS[D] < E then Gosub2170: TArr[0]:= -Int(.5 - IN * 10000] / 100: Gosub2960: GOto 1890
    if D < 0 then a:= I1 - B: B:= B / 10: GOto 2030
  end;
  GOto 1500;
2080
  R:= 1 - TArr[2] * IN / I1 ^ P * ID / TArr[4]: if ABS[R] < .0001 then btn:= I + 2: Window(1,1,80,25);(top to btn: ClrScr; writeln;  writeln;  writeln('LA RENDITA E' PERPETUA': writeln;  WaitReturn: GOto 1890
if R < 0 then Gosub2710: GOto 1890
TArr[0]:= -Int(.5 + LOG[R] / LOG[I1] * 100] / 100: Gosub2960: GOto 1890
2110
ON KArr[1] GOto 2120, 2130: IN:= IN * TArr[3] / 12: GOto 2130
2120
IN:= [IN + 1] ^ [TArr[3] / 12] - 1
2130
if KArr[0] then IN:= IN / [1 - IN]
I1:= 1 + IN: if TArr[5]:= 0 then ID:= 1: RETURN
2150
if KArr[1] then ID:= I1 ^ [TArr[5] / TArr[3]]: RETURN
ID:= [1 + [I1 - 1] * 12 / TArr[3]] ^ Int(TArr[5] / 12] * [1 + [I1 - 1] * [TArr[5] - Int(TArr[5] / 12] * 12]]: RETURN
2170
IN:= I1 - 1: if KArr[0] then IN:= IN / I1
ON KArr[1] GOto 2190, 2200: IN:= IN * 12 / TArr[3]: RETURN
2190
IN:= [IN + 1] ^ [12 / TArr[3]] - 1: RETURN
2200
RETURN

2330  '
  if TArr[1] * TArr[2] * TArr[3] * TArr[4] = 0 then begin
    Gosub2710;
    GOto 1890
  end;
  if V1 <> 2 then begin
    IN:= TArr[1] / 100;
    Gosub2110
  end;
  ON V1 - 1 GOto 2380, 2360, 2370;
  TArr[0]:= -Int(0.5 - TArr[2] * IN / [[I1 ^ TArr[4] - 1] * I1 ^ P]];
  Gosub2960;
  GOto 1890
2360
  TArr[0]:= -Int(0.5 - TArr[2] * [I1 ^ TArr[4] - 1] * I1 ^ P / IN];
  Gosub2960;
  GOto 1890;
2370
  TArr[0]:= -Int(0.5 - LOG[TArr[4] * IN / TArr[2] / I1 ^ P + 1] / LOG[I1] * 100] / 100;
  Gosub2960;
  GOto 1890;
2380
  E:= TArr[1] / 1000000: a:= 1: B:= .1: if TArr[1] <= TArr[2] * TArr[4] then Gosub2710: GOto 1890
2390
  for I1:= a + B to 4 STEP B do begin
    D:= TArr[1] - TArr[2] * [I1 ^ TArr[4] - 1] * I1 ^ P / [I1 - 1];
    if ABS[D] < E then IN:= I1 - 1: Gosub2170: TArr[0]:= -Int(.5 - IN * 10000] / 100: Gosub2960: GOto 1890
    if D < 0 then a:= I1 - B: B:= B / 10: GOto 2390
  end;
  GOto 1500

2460
  btn:= I + 2;
  Window(1,top,80,btn);
2470
  CLOSE;
  NStr:= '':
  L:= 0;
2480
  ClrScr;
  writeln('NOME DELLA REGISTRAZIONE': writeln;  writeln(SPC[10]; '--...............--';; LOCATE , 13: writeln(NOStr; NStr;; L:= Length(NStr]
2490
LOCATE , L + 13: GETA aStr: a:= ASC[aStr]: if a:= 27 then ClrScr; btn:= 24: Window(1,1,80,25);(top to btn
'POP
RETURN
if a:= 13 and Length(NOStr] then writeln( OPEN FILE; GOto 2650
if a:= 62 and NOT V then PK:= 1: Gosub2760: GOto 2480
if [L:= 0] and [[a < 65] or [a > 90]] then GOto 2490
if Length(NOStr] <> 0 then NOStr:= '': writeln('...............--';; LOCATE , 13
if a:= 13 then GOto 2580
if a <> 8 then GOto 2550
if L then writeln(aStr; '.';
if L < 2 then GOto 2470
L:= L - 1: NStr:= LEFTStr[NStr, L]: GOto 2490
2550
if L:= 15 then writeln(chr[7];; GOto 2490
if a:= 32 or a:= 46 then aStr:= '.': a:= 48
if a < 48 and a < 58 or a > 64 and a > 90 then GOto 2490
L:= L + 1: NStr:= NStr + aStr: writeln(aStr;; GOto 2490
2580
writeln;  if NStr:= N0Str then writeln;  COLOR 12, 0: writeln;  writeln('NOME NON VALIDO': writeln;  COLOR 7, 0: WaitReturn: GOto 2470
writeln( OPEN FILE; NOStr:= NStr: N1:= 0: writeln( READ FILE ; 0: INPUT aStr: N:= Value(aStr]
for NR:= 0 to N
  writeln( READ FILE ; NR
  INPUT aStr
  if RIGHTStr[aStr, Length(aStr] - 4]:= NOStr then EXIT for
NEXT
if NR <= N then N1:= Value(aStr]
if NOT V then RETURN
if NR > N then 2650
ClrScr
writeln('L'ARCHIVIO '; NOStr; ' ESISTE GIA'.': writeln;
writeln('AGGIUNGO QUESTI DATI AI PRECEDENTI?'
writeln;  writeln('  1] SI': writeln('  2] NO'
writeln;  writeln('SCEGLI ';
2640
GETA aStr: ClrScr
ON Value(aStr] GOto 2650, 2470: GOto 2640
2650
writeln( OPEN ; NOStr: writeln( CLOSE ; NOStr: writeln( APPEND ; NOStr: writeln( WRITE ; NOStr: writeln(chr[10]; MenuStr; chr[10]: for jj:= 0 to I: writeln(MenuStr[jj];; if NOT jj then writeln(TipoData[P]; ' ';
writeln(TArr[jj]: NEXT: writeln(TipoTasso; TipoTasso[KArr[1]]: writeln(I0Str; TipoData[KArr[0]]; '  '; INStr: N1:= N1 + I + 4: RStr:= MakeStr[N1]
2670
if Length(RStr] < 4 then RStr:= RStr + ' ': GOto 2670
writeln( WRITE FILE ; NR: writeln(RStr; NOStr: if N >= NR then writeln( CLOSE; RETURN
2690
RStr:= MakeStr[NR]: N:= NR: NR:= 0: NOStr:= 'Indiana Jones.': Gosub2670: if V < 10 then NOStr:= NStr: NR:= N
RETURN
2710
btn:= I + 2: Window(1,1,80,25);(top to btn: ClrScr; writeln;  writeln('I DATI NON SONO ACCETTABILI': writeln;

2750
MenuStr[0]:= 'RICHIAMO DATI DA DISCO': Gosub50: MenuStr[0]:= ' > Per cambiare il modo di stampa': Centra(MenuStr[0]);: MenuStr[0]:= 'ESC per uscire': Centra(MenuStr[0]);: top:= 5: Window(1,1,80,25);(top to btn
2760
ClrScr; writeln('VUOI I DATI:': writeln;  writeln('  1] SU STAMPANTE': writeln('  2] SU VIDEO': writeln;  writeln('SCEGLI UN NUMERO ';
2770
Gosub310: V1:= Value(LStr]: if V1 < 1 or V1 > 2 then LOCATE CSRLIN - [a <> 13]: LOCATE , 24: GOto 2770
if PK then PK:= 0: RETURN
2790
NOStr:= '': Gosub2470: if NOT N then writeln( CLOSE; writeln('NON ESIStoNO REGISTRAZIONI SUL DISCO': writeln;  WaitReturn: RETURN
if NR <= N then GOto 2860
ClrScr
writeln('L'ARCHIVIO '; NOStr; ' NON ESISTE.': writeln;  writeln('VUOI L'ELENCO DEGLI ARCHIVI?': writeln;  writeln('  1] NO': writeln('  2] SI, SU VIDEO': writeln('  3] SI, SU STAMPANTE': writeln;  writeln('SCEGLI UN NUMERO ';
2820
Gosub310: VV:= Value(LStr]: if VV < 1 or VV > 3 then LOCATE CSRLIN - [a <> 13]: LOCATE , 18: GOto 2820
ON VV GOto 2790, 2840: writeln(writeln;ER
2840
ClrScr; writeln;  writeln;  writeln;  for jj:= 1 to N: writeln( READ FILE ; jj: INPUT aStr: writeln(jj; '] '; RIGHTStr[aStr, Length(aStr] - 4]: if VV:= 2 and jj - Int(jj / 16] * 16:= 0 then WaitReturn
NEXT: writeln;  writeln(writeln;ER OFF: writeln( CLOSE
if VV:= 2 then WaitReturn
GOto 2790
2860
ClrScr; if V1:= 1 then writeln(writeln;ER
writeln( OPEN ; NOStr: writeln( READ ; NOStr: writeln(NOStr: writeln;  for jj:= 1 to N1: INPUT aStr: if aStr:= '' then aStr:= chr[0]
if V1:= 2 and jj > 1 and ASC[aStr]:= 10 then WaitReturn
writeln(aStr: NEXT: writeln;  writeln( CLOSE; writeln(writeln;ER OFF: if V1:= 2 then writeln;  writeln('HO FINIto .......';; LOCATE CSRLIN: WaitReturn
ClrScr; writeln('VUOI CANCELLARE I DATI '; NOStr; ' ?': writeln;  writeln('  1] NO': writeln('  2] SI': writeln;  writeln('SCEGLI UN NUMERO';
2900
GETA aStr: a:= Value(aStr]
ON a * [a < 3] + 1 GOto 2900, 2790
OPEN FILE
if N:= NR then GOto 2920
for jj:= NR to N - 1: writeln( READ FILE ; jj + 1: INPUT aStr: writeln( WRITE FILE ; jj: writeln(aStr: NEXT
2920
NR:= N - 1: Gosub2690: GOto 2790
2960
writeln;  for jj:= 0 to I: if NOT jj then writeln(MIDStr[MenuStr[0], 3]; TipoData[P];; GOto 2970
writeln(MenuStr[jj];
2970
LOCATE , 25: writeln(': '; TArr[jj];; ClrEol: writeln;  NEXT: writeln(TipoTasso; TipoTasso[KArr[1]]: writeln(I0Str; TipoData[KArr[0]];; LOCATE , 25: writeln(': '; INStr;; ClrEol: writeln;  writeln(writeln;ER OFF
GETA aStr: if aStr:= 'S' then writeln(writeln;ER; GOto 2960
if aStr:= 'R' then Gosub2460: ClrScr; btn:= 24: Window(1,1,80,25);(top TO btn
RETURN
