uses MathTool, DataMngr, Crt, Graph;
var
  Dati: array[0..9,0..40] of real;
  DidasStr: array[0..12] of string;
  TitoloStr: array[0..9] of string;
  BStr: array[0..1] of string;
  MStr: array[0..9] of string;

var
  ValidData, YesFlag, DotFlag, GridFlag, BigDot, DidasFlag, Flag3D,
  FillFlag, SlashFlag,
  hcolor, fs: integer;
  NumDat, NumSer: integer;
  l, l1, l2, h, a, i, j, ym, ht, vt, mm, mi: integer;
  h1, h2, m1, m2: integer;

  aa, a1, S, sm, st,
  Minim, Maxim, Range: real;

  ch: char;

  AStr: string;

procedure GetNum;
begin
  YM:= MI;
  TextColor(15); GotoXY(1,VT + 2 * YM); write(' ',YM, ' '); TextColor(7);
  repeat
    GotoXY(3, 24);
    ch:= readkey;
    if ch = #0 then readkey else ch:= UpCase(ch);
    A:= ord(ch);
    GotoXY(1, VT + 2 * YM); write(' ',YM, ' ');
    IF ch in ['I','J'] THEN begin
      YM:= YM + 1;
      IF YM > MM THEN YM:= MM;
    end;
    IF ch in ['M','K'] THEN begin
      YM:= YM - 1;
      IF YM < MI THEN YM:= MI;
    end;
    IF(A = 13) THEN exit;
    A:= A - 48;
    IF(A >= MI) and(A <= MM) THEN begin YM:= A; exit; end;
    TextColor(15);
    GotoXY(1, VT + 2 * YM); write(' ',YM,' '); TextColor(7);
  until false;
end;

procedure NewInput;
begin
  ClrScr;
  GetSiNo('Inserisci nuovo formato degli input o nuovi input ? ', YesFlag);
end;

procedure WriteData;
begin
  ClrScr;
  write(TitoloStr[I]);
  FOR J:= 1 TO NumDat do begin
    IF(J < 21) THEN GotoXY(1, J + 2) else GotoXY(20, J - 18);
    write('Dato ', j:2, '= ', Dati[I, J]:10:3);
  end;
end;

procedure ClrEOS;
begin
  GotoXY(1,23); ClrEol;
  GotoXY(1,24); ClrEol;
end;

procedure Correzioni;
begin
  repeat
    ClrEOS;
    GotoXY(1,24);
    GetSiNo('Dati da correggere? ', YesFlag);
    if YesFlag = 0 THEN begin ClrEOS; exit; end;
    repeat
      ClrEOS;
      GotoXY(1, 23);
      write('Numero del dato da correggere '); readln(J);
    until(J >=1) and(J <= NumDat);
    write(#7);
    ClrEOS;
    GotoXY(1, 23);
    write('Inserisci il dato corretto '); readln(Dati[I, J]);
    WriteData;
  until false;
end;

procedure GetTitolo(l1020: boolean);
begin
  repeat
    if l1020= false then begin
      GotoXY(1,23);
      writeln('TITOLO '); readln(TitoloStr[I]);
      IF length(TitoloStr[I]) > 40 THEN begin
        TitoloStr[I]:= Copy(TitoloStr[I], 1, 40);
      end;
      write(#7);
      WriteData;
    end;
    GotoXY(1, 24);
    GetSiNo('Vuoi combiare il titolo ? ', YesFlag);
  until YesFlag = 0;
end;

procedure CalcMinMax;
var ValMax, ValMin: real;
label 1140, 1070;
begin
  ValMax:= Dati[1,1];
  ValMin:= Dati[1,1];
  FOR I:= 1 TO NumSer do begin
    FOR J:= 1 TO NumDat do begin
      IF Dati[I, J] < ValMin THEN ValMin:= Dati[I, J];
      IF Dati[I, J] > ValMax THEN ValMax:= Dati[I, J];
    end;
  end;
1070:
  ClrScr;
  writeln('Valore Minimo= ', ValMin:12:3);
  writeln;
  writeln;
  writeln('Valore Max   = ', ValMax:12:3);
  GotoXY(1,8);
  GetSiNo('Vuoi cambiare questi valori? ', YesFlag);
  IF YesFlag = 0 THEN begin
    Minim:= ValMin;
    Maxim:= ValMax;
    Range:= Maxim - Minim;
    exit;
  end;
  if ValMin >= 0 then begin
    GotoXY(1, 12); GetSiNo('Scala a esponenti di 10? ', YesFlag);
    if YesFlag = 1 THEN begin
      FOR I:= 1 TO 9 do begin
        IF IPow(10,I) >= ValMax THEN break;
      end;
      Minim:= 0;
      Maxim:= IPow(10,I);
      goto 1140;
    end;
  end;
  writeln; writeln;
  write('Valore Minimo: '); readln(Minim);
  write('Valore Max   : '); readln(Maxim);
1140:
  ValMin:= Minim;
  ValMax:= Maxim;
  GOTO 1070;
end;

procedure Didascalie;
begin
  IF DidasFlag = 0 THEN exit;
  ClrScr;
  write('DIDASCALIE');
  FOR I:= 1 TO NumDat do begin
    GotoXY(1, I + 2);
    write(I:2,' ', DidasStr[I]);
  end;
end;

procedure CorrDidas;
begin
  repeat
    IF DidasFlag = 0 THEN exit;
    ClrEOS;
    GotoXY(1,23);
    GetSiNo('Didascalie da correggere? ', YesFlag);
    IF YesFlag = 1 THEN begin
      repeat
        ClrEOS;
        GotoXY(1, 23);
        write('Numero della didascalia da correggere '); readln(J);
      until(J >= 1) and(J <= NumDat);
      write(#7); ClrEOS;
      GotoXY(1,23);
      write('Inserisci didascalia corretta: '); readln(DidasStr[J]);
      IF length(DidasStr[J]) > 4 THEN DidasStr[J]:= Copy(DidasStr[J],1, 4);
      write(#7); Didascalie;
    end
    else begin
      ClrEOS;
      break;
    end;
  until false;
end;

procedure GetData;
label 900, 930, 970;
begin
  write('Inserisci il numero delle serie di dati(max ', M1, ')');
  VT:= 6; MI:= 1; MM:= M1;
  FOR I:= 1 TO M1 do begin
    GotoXY(2, VT + 2 * I); write(I);
  end;
  GetNum;
  NumSer:= YM;
900:
  repeat
    ClrScr;
    writeln('Inserisci il nuemro di dati per');
    write('ciscuna serie(max ', M2, '): '); readln(NumDat);
  until(NumDat <= M2) and(NumDat >= 2);
  write(#7);
  IF ValidData= 0 THEN begin
    ValidData:= 1;
    GOTO 930;
  end;
  ClrScr;
  GotoXY(1,2); writeln('utilizzati gli input gia'' esistenti');
  GetSiNo('o vuoi nuovi input? ', YesFlag);
  IF YesFlag =0 THEN exit;
930:
  FOR I:= 1 TO NumSer do begin
    ClrScr;
    write('SERIE DI DATI N. ', I);
    FOR J:= 1 TO NumDat do begin
      IF(J <= 20) THEN GotoXY(1, J + 2) else GotoXY(20, J - 18);
      write('Dato n. ', j:2, '='); readln(Dati[I, J]);
      write(#7);
    end;
    WriteData;
    Correzioni;
    GetTitolo(false);
  end;
  CalcMinMax;
  IF NumDat > 12 THEN exit;
970:
  ClrScr;
  GotoXY(1,1);
  GetSiNo('Vuoi inserire didascalie? ', YesFlag);
  DidasFlag:= YesFlag;
  IF DidasFlag = 0 THEN begin
    FOR I:= 1 TO 12 do begin
      DidasStr[I]:= '';
    end;
  end
  else begin
    ClrScr;
    write('Didascalie(max 4 caratteri)');
    FOR I:= 1 TO NumDat do begin
      GotoXY(1, I + 2); write(I:2,'> '); readln(DidasStr[I]);
      IF length(DidasStr[I]) > 4 THEN begin
        DidasStr[I]:= Copy(DidasStr[I],1, 4);
      end;
    end;
    Didascalie;
    CorrDidas;
  end;
end;

procedure WriteLimiti;
begin
  ClrScr;
  writeln(MStr[YM]);
  writeln('E'' possibile visualizzare sino a ', M1);
  write('serie di dati, ciascuna contenete sino a ',M2, ' dati.');
end;

procedure WhatGrid;
begin
  ClrScr;
  GridFlag:= 0;
  GetSiNo('Vuoi la griglia? ', YesFlag);
  GridFlag:= YesFlag;
end;

function FNA(J: integer): integer;
begin
  FNA:= trunc(FS -((Dati[I, J] - Minim) *(GetMaxY-12) / Range));
end;

procedure GridY;
var
  x: real;
  AStr: string;
begin
  ClearDevice;
  x:= 8;
  while (x<=pred(GetMaxX)) do begin(* step S *)
    line(round(x), FS, round(x), 18);
    x:= x + s;
  end;
  x:= 5;
  while (x<=FS) do begin
    line(4,round(x),6,round(x));
    x:= x +s;
  end;
  X:= 0;
  while (x<=162) do begin
    Str(x / 17.5:2:0, AStr);
    OutTextXY(0,(GetMaxY - 2) - trunc(x),AStr);
    x:= x + 17.5;
  end;
  OutTextXY(0,5,'0');
  IF DidasFlag =1 THEN begin
    FOR J:= 1 TO NumDat do begin
      AStr:= DidasStr[J];
      OutTextXY(trunc(S *(J - 1) * 0.98), 187, AStr);
    end;
  end;
  IF NumDat <= 30 THEN begin
    FOR J:= 1 TO NumDat do begin
      str(j:2, AStr);
      OutTextXY(trunc(3 + S *(J - 1)), 187, AStr);
    end;
  end;
end;

procedure GridX;
var x,y: real;
begin
  x:= 8;
  while (x<=pred(GetMaxX)) do begin
    y:= 5;
    while (y<=FS) do begin
      PutPixel(trunc(x), trunc(y), hcolor);
      y:= y+18;
    end;
    x:= x+ 3;
  end;
  y:= 179;
  while (y<=5) do begin
    x:= 8;
    while (x<=pred(GetMaxX)) do begin
      PutPixel(trunc(x), trunc(y),hcolor);
      x:= x +S;
    end;
    y:= y-3;
  end;
end;

procedure Graf3D;
begin
  ClrScr;
  write('Tipo di istogrammi');
  GotoXY(1,6); write(' 1   A barre');
  GotoXY(1,8); write(' 2   Tridimensionali');
  VT:= 4; MI:= 1; MM:= 2; GetNum;
  Flag3D:= YM - 1;
end;

procedure WhatPatt;
begin
  ClrScr;
  write('Puntinatura interna');
  GotoXY(1, 6); write(' 1   Figura vuota');
  GotoXY(1, 8); write(' 2   Figura piena');
  GotoXY(1,10); write(' 3   Puntinatura');
  GotoXY(1,12); write(' 4   Barrettatura');
  VT:= 4; MI:= 1; MM:= 4; GetNum;
  if ym = 2 then FillFlag:= 1 else FIllFlag:= 0;
  if ym = 3 then DotFlag:= 1 else DotFlag:= 0;
  if ym = 4 then SlashFlag:= 1 else SlashFlag:= 0;
end;

(* Cartesiano *)
procedure GrfCar;
label 150, 160;
begin
   IF ValidData = 0 then GOTO 150
   else begin
     NewInput;
     IF YesFlag = 0 then GOTO 160;
   end;
150:
   M1:= 9; M2:= 40; WriteLimiti;
   GetData;
160:
  ClrScr;
  DotFlag:= 0;
  IF NumSer > 1 THEN begin
    GetSiNo('Vuoi sovrapporre i grafici? ', DotFlag);
  end;
  ClrScr;
  BigDot:= 0;
  GetSiNo('Vuoi ingrossare i punti ? ', BigDot);
  WhatGrid;
  S:= 270 /(NumDat - 1);
  FOR I:= 1 TO NumSer do begin
    IF(I = 1) or((I > 1) and(DotFlag=0)) then GridY;
    hcolor:= 0;
    FOR J:= 0 TO 4 do begin
      line(0, J,pred(GetMaxX), J);
    end;
    hcolor:= 3;
    OutTextXY(10,0,TitoloStr[I]);
    J:= 1;
    PutPixel(8, FNA(J), hcolor);
    FOR J:= 2 TO NumDat do begin
      LineTo(trunc(8 + S *(J - 1)), FNA(J));
    end;
    IF BigDot =1  THEN begin
      J:= 1;
      OutTextXY(7, FNA(J) - 2, '*');
      FOR J:= 2 TO NumDat do begin
        OutTextXY(trunc(7 + S *(J - 1)), FNA(J) - 2,'*');
      end;
    end;
    if(GridFlag=1) and((DotFlag=0) or(DotFlag=1) and(I= NumSer)) then GridX;
  end;
end;

(* Istogramma verticale *)
procedure GrfVer;
var x, y: integer;
label 280,290;
begin
  Graf3D;
  IF (ValidData=0) or (NumDat > 12) then GOTO 280;
  NewInput;
  IF YesFlag=0 then GOTO 290;
280:
  M1:= 9; M2:= 12;
  WriteLimiti;
  GetData;
290:
  WhatPatt;
  WhatGrid;
  S:= pred(GetMaxX) / NumDat;
  L:= trunc(S / 2);
  IF L > 60 THEN L:= 60;
  L1:= L div 2;
  L2:= L * 3 div 2;
  IF Flag3D=0 THEN L:= trunc(L2);
  FOR I:= 1 TO NumSer do begin
    ClearDevice;
    OutTextXY(0,0,TitoloStr[I]);
    FOR x:= 0 TO 10 do begin
      str(x:2, AStr);
      OutTextXY((GetMaxX-3) - 4 *(x div 10),(GetMaxY-12) - 16 * x,AStr);
    end;
    FOR J:= 1 TO NumDat do begin
      H:= trunc(FS - INT(((Dati[I, J] - Minim) / Range) *((GetMaxY-20) - L1)));
      A:= trunc(S *(J - 1));
      IF DidasFlag =1 THEN OutTextXY(A, 187, DidasStr[J])
      else begin
        str(j:2, AStr);
        OutTextXY(A, 187, Astr);
      end;
      line(A, H,A, FS); LineTo(A + L, FS);
      LineTo(A + L, H); LineTo(A, H);
      IF Flag3D =1 THEN begin
        LineTo(A + L1, H - L1); LineTo(A + L2, H - L1);
        LineTo(A + L2, FS - L1); LineTo(A + L, FS);
        line(A + L, H,A + L2, H - L1);
      end;
      IF DotFlag =1 THEN begin
        y:= FS;
        while y<=H do begin
          x:= A;
          while (x<=A + L) do begin
            PutPixel(x, y, hcolor);
            x:= x+3;
          end;
          y:= y-3;
        end;
      end;
      IF (SlashFlag=1) or (FillFlag=1) THEN begin
        y:= FS;
        while (y<=H + 2) do begin
          line(A + 2, y,A + L - 2, y);
          y:= y- 1 - 2* SlashFlag;
        end;
        IF Flag3D=1 THEN begin
          y:= FS;
          while (y<= H + 5) do begin
            line(A + L, y - 2,A + L2 - 2, y - L1);
            y:= y-1-2*SlashFlag;
          end;
        end;
      end;
      Str(Dati[i,j]:4:1, AStr);
      OutTextXY(A, H - 6 - L1 * Flag3D, AStr);
    end;
    IF GridFlag=1 THEN begin
      x:= 0;
      while (x<=270) do begin
        y:= 13 + L1;
        while (y<=186) do begin
          PutPixel(x, y, hcolor);
          y:= y+((GetMaxY-20) - L1) div 10;
        end;
        x:= x+3;
      end;
    end;
  end;
end;

(* Istogrammi orizzontali *)
procedure GrfOrz;
label 400,410,520,540;
var x,y: integer;
begin
  IF (ValidData=0) or (NumDat > 12) then GOTO 400
  else begin
    NewInput;
    IF YesFlag=0 then GOTO 410;
  end;
400:
  M1:= 9;
  M2:= 12;
  WriteLimiti;
  GetData;
410:
  WhatPatt;
  ClearDevice;
  S:= pred(GetMaxX) / NumDat;
  L:= trunc(3 * S / 4);
  IF L > 60 THEN L:= 60;
  SM:= 0;
  FOR J:= 1 TO NumDat do begin
    ST:= 0;
    FOR I:= 1 TO NumSer do begin
      ST:= ST + Dati[I, J];
    end;
    IF ST > SM THEN SM:= ST;
  end;
  FOR I:= 1 TO NumSer do begin
    str(i, AStr); Astr:= Astr + '  ' + TitoloStr[I];
    OutTextXY(0, 7 *(I - 1), astr);
  end;
  line(0, FS,pred(GetMaxX), FS);
  FOR J:= 1 TO NumDat do begin
    H1:= FS;
    FOR I:= 1 TO NumSer do begin
      H2:= trunc(Dati[I, J] / SM * 155);
      A:= trunc(S *(J - 1));
      IF DidasFlag = 1 THEN begin
        OutTextXY(A, 187, DidasStr[J]);
      end
      else begin
        str(j:2,AStr); OutTextXY(A, 187, AStr);
      end;
      line(A, H1,A, H1 - H2);
      LineTo(A + L, H1 - H2);
      LineTo(A + L, H1);
      IF DotFlag= 0 then GOTO 520;
      FOR y:= H1 - H2 TO H1 do begin
        x:= (y - 4 * (y div 4));
        if I mod 2 = 1 then begin
          repeat
            IF x <= L THEN begin
              PutPixel(A + x, y, hcolor);
              x:= x + 4;
            end
            else break;
          until false;
        end
        else begin
          repeat
            IF x <= L THEN begin
              PutPixel(A + L - x, y, hcolor);
              x:= x + 4;
            end
            else break;
          until false;
        end;
      520:
        IF SlashFlag=0 then GOTO 540;
        IF I mod 2 = 0 THEN begin
          y:= H1 - H2;
          while (y<= H1) do begin
            line(A, y,A + L, y);
            y:= y+3;
          end;
        end
        else begin
          x:= A;
          while (x<=A + L) do begin
            line(x, H1 - H2,x, H1);
            x:= x+3;
          end;
        end;
      540:
        IF FillFlag =1 THEN begin
          FOR y:= H1 downTO H1 - H2 + 2 do begin
            line(A + 2, y,A + L - 2, y);
          end;
        end;
        H1:= H1 - H2;
      end;
    end;
  end;
end;

(* istogrammi sormontati *)
procedure GrfSor;
label 570, 580;
var x, y: integer;
begin
  IF (ValidData=0) or (NumDat > 12) then GOTO 570;
  NewInput;
  IF YesFlag=0 then GOTO 580;
570:
  M1:= 4;
  M2:= 12;
  WriteLimiti;
  GetData;
580:
  WhatPatt;
  WhatGrid;
  ClearDevice;
  S:= pred(GetMaxX) / NumDat;
  L:= trunc(S / 3);
  IF L > 60 THEN L:= 60;
  FOR I:= NumSer downTO 1 do begin
    str(i, AStr);
    astr:= astr + '  ' + TitoloStr[I];
    OutTextXY(0, 7 *(I - 1),astr);
    L1:= L div 2 * (I - 1);
    FOR x:= 0 TO 10 do begin
      str(x:2, AStr);
      OutTextXY((GetMaxX-3), (GetMaxY-12) - 15 * x, astr);
    end;
    FOR J:= 1 TO NumDat do begin
      A:= trunc(S *(J - 1));
      H:= trunc(FS -((Dati[I, J] - Minim) / Range) * 155);
      L2:= A + L1;
      IF DidasFlag=1 THEN begin
        OutTextXY(A, 187, DidasStr[J]);
      end
      else begin
        str(j, AStr);
        OutTextXY(A, 187, astr);
      end;
      hcolor:= 0;
      FOR x:= L2 TO L + L2 do begin
        line(x, FS,x, H);
      end;
      hcolor:= 3;
      line(L2, FS,L2, H);
      LineTo(L2 + L, H);
      LineTo(L2 + L, FS);
      LineTo(L2, FS);
      IF DotFlag=1 THEN begin
        FOR y:= H TO FS do begin
          FOR x:= L2 TO L2 + L do begin
            if (y mod 3 =0) and (x mod 3 = 0) then PutPixel(x, y, hcolor);
          end;
        end;
      end;
      IF (SlashFlag=1) or (FillFlag=1) THEN begin
        y:= FS;
        while (y>=H + 2) do begin
          line(L2 + L + 2, y, L2 + L - 2, y);
          y:= y -1 - 2 * SlashFlag;
        end;
      end;
    end;
  end;
  IF GridFlag=1 THEN begin
    x:= 0;
    while (x<=270) do begin
      y:= 30;
      while (y<=FS) do begin
        PutPixel(x, y, hcolor);
        y:= y+15;
      end;
      x:= x+3;
    end;
  end;
end;

(* istogrammi sovrapposti *)
procedure GrfSov;
label 680, 690;
var x,y: integer;
begin
 IF (ValidData = 0) or (NumDat > 12) THEN GOTO 680;
 NewInput;
 IF YesFlag = 0 THEN GOTO 690;
680:
   M1:= 9;
   M2:= 12;
   WriteLimiti;
   GetData;
690:
  Graf3D;
  WhatPatt;
  WhatGrid;
  S:=(GetMaxY-12) / NumDat;
  L:= trunc(S / 2);
  IF L > 60 THEN L:= 60;
  L1:= L div 2;
  L2:= 3 * L div 2;
  IF Flag3D=1 THEN L:= L2;
  FOR I:= 1 TO NumSer do begin
    ClearDevice;
    OutTextXY(0, 0, TitoloStr[I]);
    FOR x:= 0 TO 10 do begin
      str(x, AStr);
      OutTextXY(18 + 23 * x, 187, astr);
    end;
    FOR J:= 1 TO NumDat do begin
      H:= trunc(((Dati[I, J] - Minim) / Range) *(235 - L1));
      A:= trunc(S *(J - 1) + 9);
      line(20 + H, A, 20, A);
      LineTo(20, A + L);
      LineTo(20 + H, A + L);
      LineTo(20 + H, A);
      IF Flag3D=1 THEN begin
        LineTo(20 + H + L1, A + L1);
        LineTo(20 + H + L1, A + L2);
        LineTo(20 + L1, A + L2);
        LineTo(20, A + L);
        line(20 + H, A + L, 20 + H + L1, A + L2);
      end;
      IF DotFlag=1 THEN begin
        FOR x:= 20 TO 20 + H do begin
          FOR y:= A TO A + L do begin
            PutPixel(x, y, hcolor);
            inc(y,2);
          end;
          inc(x,2);
        end;
      end;
      IF (SlashFlag=1) or (FillFlag=1) THEN begin
        FOR x:= 20 TO 18 + H do begin
          line(x, A + 2, x, A + L - 2);
          inc(x,2*SlashFlag);
        end;
        IF Flag3D=1 THEN begin
          FOR x:= 19 TO 15 + H do begin
            line(x + 2, A + L, x + L1, A + L2 - 2);
            inc(x, 2 * SlashFlag);
          end;
        end;
      end;
      IF DidasFlag =1 THEN begin
        OutTextXY(0, A + L1, DidasStr[J]);
      end
      else begin
        str(j,AStr);
        OutTextXY(0, A + L1, astr);
      end;
      str(Dati[i,j]:5:0, astr);
      OutTextXY(24 + H + L1*Flag3D, A + L1, astr);
    end;
    IF GridFlag=1 THEN begin
      y:= 8;
      while (y<=186) do begin
        x:= 20;
        while (x<=255) do begin
          PutPixel(x, y, hcolor);
          x:= x+ (235-l1) div 10;
        end;
        y:= y+3;
      end;
    end;
  end;
end;

(* diagramma a torte *)
procedure GrfTor;
label 820, 830;
var
  k, cx, cy, r: integer;
  x,y : real;
begin
  CX:= 88;
  CY:= 100;
  R:= 88;
  IF (ValidData=0) or (NumDat > 12) then GOTO 820;
  NewInput;
  IF YesFlag=0 then GOTO 830;
820:
  M1:= 9;
  M2:= 12;
  WriteLimiti;
  GetData;
830:
  FOR I:= 1 TO NumSer do begin
    ClearDevice;
    OutTextXY(0, 0, TitoloStr[I]);
    PutPixel(cx, CY- R, hcolor);
    J:= 0;
    while (j<= round(2 * PI * 360)) do begin
      LineTo(round(CX + R * SIN(J/360)), round(CY - R * cos(J/360)));
      j:= j + 1;
    end;
    line(179, 10, pred(GetMaxX) ,10);
    Lineto(pred(GetMaxX), 10 + NumDat);
    LineTo(179, 10 + 15 * NumDat);
    LineTo(179,10);
    S:= 0;
    FOR J:= 1 TO NumDat do begin
      S:= S + Dati[I, J];
    end;
    A:= 0;
    FOR J:= 1 TO NumDat do begin
      A1:= 2 * PI * Dati[I, J] / S;
      aA:= aA + trunc(A1);
      line(CX, CY, round(CX + R * SIN(Aa)), round(CY - R * COS(aA)));
      y:= CY -(R - 10) * COS(aA - A1 / 2) - 2;
      x:= CX +(R - 10) * SIN(aA - A1 / 2);
      FOR K:= trunc(y - 1) TO trunc(y + 5) do begin
        line(round(x - 1), K, round(x + 3 + 4 *(J div 10)), K);
      end;
      str(j, AStr);
      OutText(astr);
      FOR K:= trunc(y - 1) TO trunc(y + 5) do begin
        line(182,K, 4 *(J div 10),K);
        OutText(AStr);
      end;
    end;
  end;
end;

begin
  hcolor:= 3;
  FS:= GetMaxY - 7;
  BStr[0]:= ' NO ';
  BStr[1]:= ' YES ';
  MStr[0]:= 'Grafico cartesiano lineare';
  MStr[1]:= 'Istogrammi verticali';
  MStr[2]:= 'Istogrammi orizzontali';
  MStr[3]:= 'Istogrammi sovrapposti';
  MStr[4]:= 'Istogrammi sormontati';
  MStr[5]:= 'Diagramma a settori circolari';
  TextColor(7);
  TextBackGround(0);
  repeat
    ClrScr;
    VT:= 4;
    MI:= 0;
    MM:= 9;
    TextColor(15);
    write('   GRAFICI,   DIAGRAMMI,   ISTOGRAMMI   ');
    TextColor(7);
    FOR I:= 0 TO 9 do begin
      GotoXY(1, 4 + 2 * I); write(' ',I,'  ',MStr[I]);
    end;
    GetNum;
    case YM + 1 of
      1: GrfCar;
      2: GrfVer;
      3: GrfSov;
      4: GrfOrz;
      5: GrfSor;
      6: GrfTor;
    end;
  until false;
end.
