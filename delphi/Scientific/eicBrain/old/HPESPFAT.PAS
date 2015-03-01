{$I switches.inc}
{ UNDEF UNIT}

{$IFDEF UNIT}
unit HpEspFat;

interface

procedure HpEspFatMain;

implementation
{$ELSE}

{$ENDIF}

uses Dos, Crt, MathTool, HpGraf, Graph, DataMngr;

const EspFatDataName = 'EspFatDataFile';

{$V-}

type

  PEspFatt = ^TEspFatt;
  TEspFatt = object
    DescStr: array[0..1,0..7] of string[30];
    Esperimento: string;
    EspStr: array[0..20,0..7] of string[50];
    ErrPure: integer;
    np, p: integer;
    media: PREC;
    pura : array[1..20] of integer;
    npura: array[1..20] of integer;
    alias: array[0..512] of string[10];
    Resp: array[1..512,1..5] of PREC;
    t: array[1..512] of PREC;
    la: array[1..512] of PREC;
    lb: array[1..512] of PREC;
    eff: array[1..512] of PREC;
    ss: array[1..512] of PREC;
    flagPrepa,
    flagMesco,
    flagRisu,
    flagStat: boolean;
    constructor Init;
    procedure   Variabili;
    function    SegnoPura(i, l: integer): integer;
    procedure   CondEsper;
    procedure   MescEffet;
    procedure   InputRisu;
    procedure   RisulStat;
    procedure   Assi(lim: PREC);
    procedure   GrafEffet;
    procedure   GrafInter;
    destructor  Done;
  end;

constructor TEspFatt.Init;
begin
end;

procedure TEspFatt.Variabili;
var
  i: integer;
  NoStr: string[30];
begin
  flagPrepa:= false;
  flagMesco:= false;
  flagRisu := false;
  flagStat := false;
  NoStr:='*        :';
  DescStr[0,0]:= 'Descrizione dell''esperimento';
  DescStr[0,1]:= 'Titolo   :';
  DescStr[0,2]:= 'cicli[<5]:';
  DescStr[0,3]:= 'periodo  :';
  for i:= 4 to 7 do DescStr[0,i]:= NoStr;
  DescStr[1,0]:= 'Descrizione delle variabili';
  DescStr[1,1]:= 'Nome     :';
  DescStr[1,2]:= 'Un.misura:';
  DescStr[1,3]:= 'Liv.basso:';
  DescStr[1,4]:= 'Liv.alto :';
  DescStr[1,5]:= 'Interazio:';
  DescStr[1,6]:= NoStr;
  DescStr[1,7]:= NoStr;
end;

function TEspFatt.SegnoPura(i, l: integer): integer;
var tt: PREC;
begin
  tt:= sin(PI*((2*i-1)/IPow(2, l) + 1));
  if tt > 0 then SegnoPura:= 1
  else if tt < 0 then SegnoPura:= -1
  else SegnoPura:= 0;
end;

procedure TEspFatt.CondEsper;
var
  YN: char;
  procedure NuovoFile(var fil: text);
  var
    i, l: integer;
  begin
    Rewrite(fil);
    writeln(fil, EspFatDataName);
    for i:= 0 to 20 do begin
      for l:= 0 to 7 do begin
        writeln(fil, '*');
      end;
    end;
    Close(fil);
  end;
  procedure LeggiFile(var fil: text);
  var
    i, l: integer;
    tmp: string;
  begin
    Reset(fil);
    readln(fil, tmp);
    if tmp <> EspFatDataName then begin
      writeln;
      writeln('Spiacente, ma il file non contiene dati validi.');
      for i:= 0 to 20 do begin
        for l:= 0 to 7 do begin
          EspStr[i, l]:= '*';
        end;
      end;
      WaitReturn;
      exit;
    end;
    for i:= 0 to 20 do begin
      for l:= 0 to 7 do begin
        readln(fil, EspStr[i, l]);
      end;
    end;
    Close(fil);
  end;
  procedure ScriviFile(var fil: text);
  var
    i, l: integer;
  begin
    Rewrite(fil);
    writeln(fil, EspFatDataName);
    for i:= 0 to 20 do begin
      for l:= 0 to 7 do begin
        writeln(fil, EspStr[i, l]);
      end;
    end;
    Close(fil);
  end;
  procedure AlVideo(pos: integer);
  var l, m: integer;
  begin
    ClrScr;
    if pos>0 then l:= 1 else l:= 0;
    Writeln(EspStr[0,1]);
    writeln;
    for m:= 0 to 7 do begin
      Write(DescStr[l, m], ' ');
      if m > 0 then writeln(EspStr[pos, m]) else writeln;
    end;
    writeln;
    if pos > 0 then writeln('Codifica: ', chr(pos+96));
  end;
  procedure Modifiche(pos: integer);
  var m: integer;
  begin
    writeln;
    GetChar('Modifiche [S)i, N)o, F)ine]? ', YN);
    if (YN = 'F') or (YN='N') then exit;
    GotoXY(1, 4);
    for m:= 1 to 7 do begin
      GotoXY(12, WhereY);
      EspStr[pos, m]:= '';
      InputStr('', EspStr[pos, m]);
    end;
  end;
  procedure PureNPure;
  var i: integer;
  begin
    for i:= 1 to 20 do begin
      if EspStr[i, 1] = '*' then continue;
      if EspStr[i, 5] = '*' then begin
        p:= p+1;
        Pura[p]:= i;
      end
      else begin
        np:= np+1;
        NPura[np]:= i;
      end;
    end;
  end;
  procedure ContrPure;
  var i, m, l: integer;
  begin
    for i:= 1 to np do begin
      for l:= 1 to length(EspStr[Npura[i],5]) do begin
        for m:= 1 to np do begin
          if EspStr[Npura[i], 5][l] = chr(96+NPura[m])  then begin
            ErrPure := i;
            exit;
          end;
        end;
      end;
    end;
  end;
  procedure MessMesco;
  begin
    writeln;
    writeln('Errore di mescolamento');
    writeln;
    writeln('variabile: ',EspStr[Npura[ErrPure], 1]);
    writeln;
    exit;
  end;
  procedure Schema;
  var
    i, l, n, z, z1,
    m, Segno: integer;
    VStr: string[50];
  begin
    ClrScr;
    writeln('Condizioni sperimentali');
    writeln;
    writeln('*: livello basso    lettera: livello alto');
    writeln;
    for i:= 1 to IPow(2, p) do begin
      VStr:= '';
      for l:= 1 to p do begin
        segno:= SegnoPura(i, l);
        if segno = -1 then VStr:= VStr + '*' else VStr:= VStr + chr(96+Pura[l]);
      end;
      for l:= 1 to p do begin
        segno:= 1;
        for m:= 1 to length(EspStr[NPura[l], 5]) do begin
          for n:= 1 to p do begin
            if EspStr[NPura[l], 5][m] = chr(96+Pura[n]) then break;
          end;
          if VStr[n] = '*' then segno:= -segno;
        end;
        if segno = -1 then VStr:= VStr + '*' else VStr:= VStr + chr(96 + NPura[l]);
      end;
      write(i:4,'  ');
      for z:= 1 to p + np do begin
        write(VStr[z]);
        for z1:= 1 to 15-p-np do write(' ');
      end;
      writeln;
      writeln;
    end;
  end;
var
  i: integer;
  f1: text;
begin
  np:= 0;
  p:= 0;
  ErrPure:= 0;
  ClrScr;
  writeln('Prepearazione dello schema sperimentale');
  writeln;
  Esperimento:= '';
  InputStr('Titolo dell''esperimento fattoriale: ', Esperimento);
  Assign(f1, Esperimento);
  if not FileExist(Esperimento) then NuovoFile(f1);
  LeggiFile(f1);
  for i:= 0 to 20 do begin
    AlVideo(i);
    Modifiche(i);
    if YN = 'F' then break;
  end;
  ScriviFile(f1);
  PureNPure;
  ContrPure;
  if ErrPure <> 0 then begin
    MessMesco;
    exit;
  end;
  Schema;
  WaitReturn;
  FlagPrepa:= true;
end;

procedure TEspFatt.MescEffet;
var
  z, l, l1, i, m, n: integer;
  cc: char;
  kStr, k1Str: string[80];
  procedure Mescolamento;
  var
    rStr: string;
    j, y, t: integer;
  begin
    kStr:= KStr + k1Str;
    rStr:= '';
    for j:= 1 to p do begin
      t:= 0;
      cc:= chr(Pura[j]+96);
      for y:= 1 to length(KStr) do if cc = KStr[y] then t:= t +1;
      if odd(t) then rStr:= rStr + cc;
    end;
    kStr:= rStr;
  end;
begin
  ClrScr;
  if not FlagPrepA then begin
    writeln('Inserire prima lo schema dell''esperimento!');
    WaitReturn;
    exit;
  end;
  Writeln('Tabella del mescolmento degli effetti');
  writeln;
  alias[0]:= '';
  l:= 0;
  l1:= 0;
  for i:= 1 to p do begin
    cc:= chr(Pura[i]+96);
    for m:= 0 to l1 do begin
      l:= l + 1;
      alias[l]:= alias[m] + cc;
    end;
    l1:= l;
  end;
  for i:= 1 to IPow(2, p) do begin
    Write(i:4,' ',alias[i]);
    for z:= 0 to 6-length(alias[i]) do write(' ');
    (* MeanTable *)
    for m:= 1 to np do begin
      kStr:= alias[i];
      k1Str:= EspStr[NPura[m], 5];
      Mescolamento;
      KStr:= KStr + chr(NPura[m]+96);
      write(KStr);
      if length(KStr) < 6 then begin
        for z:= 0 to 6-length(KStr) do write(' ');
      end;
    end;
    (* ConfTable *)
    for m:= 1 to np-1 do begin
      for n:= m+1 to np do begin
        kStr:= alias[i];
        K1Str:= EspStr[NPura[m], 5] + EspStr[NPura[n], 5];
        Mescolamento;
        kStr:= kStr + chr(NPura[m]+96) + chr(NPura[n]+96);
        write(KStr);
        if length(KStr) < 6 then begin
          for z:= 0 to 6-length(KStr) do write(' ');
        end;
      end;
    end;
    writeln;
    writeln;
  end;
  FlagMesco:= true;
  WaitReturn;
end;

procedure TEspFatt.InputRisu;
var
  y, i, m, err,
  cicli: integer;
  VStr: string[50];
  procedure Title;
  begin
    ClrScr;
    writeln('Input risultati sperimentali');
    y:= 3;
  end;
begin
  ClrScr;
  if not FlagMesco then begin
    writeln('Richiamare prima il mescolamento degli effetti!');
    WaitReturn;
    exit;
  end;
  val(EspStr[0,2], cicli, err);
  if err <> 0 then begin
    Writeln('Errore nel numero dei cicli! non posso proseguire, correggi!');
    WaitReturn;
    exit;
  end;
  y:= 100;
  for i:= 1 to IPow(2, p) do begin
    y:= y+1;
    if y > 22 then Title;
    str(i:3, vStr);
    vStr:= 'Cond.#: ' + vStr + ' ' + alias[i-1];
    GotoXY(1, y); writeln(vStr);
    for m:= 1 to cicli do begin
      Resp[i, m]:= 0;
      GotoXY( 25+ (m-1) * 8, y); InputPrec('? ', Resp[i, m],-inf,inf);
    end;
  end;
  FlagRisu:= true;
  WaitReturn;
end;

procedure TEspFatt.RisulStat;
var
  z, i, m, n, l, segn, segno, df, dfr,
  err, cicli: integer;
  res, tot, cf, sstot, somma: PREC;
  f1, f2, f3, f4, f5: PREC;
  fStr: string;
  procedure FTable;
  var f5c: PREC;
  begin
    f5c:= dfr / (0.11469*dfr - 0.15343);
    if f5 > f5c then begin fStr:=' 99%'; exit; end;
    f5c:= dfr / (0.16296*dfr - 0.20452);
    if f5 > f5c then begin fStr:=' 97%'; exit; end;
    f5c:= dfr / (0.22523*dfr - 0.26392);
    if f5 > f5c then begin fStr:=' 95%'; exit; end;
    f5c:= dfr / (0.3364 * dfr - 0.35549);
    if f5 > f5c then begin fStr:=' 90%'; exit; end;
    fStr:= '<90%';
  end;
begin
  ClrScr;
  if not FlagRisu then begin
    writeln('Inserire prima i risultati dell''esperimento!');
    WaitReturn;
    exit;
  end;
  val(EspStr[0,2], cicli, err);
  Writeln('Risultati statistici. Tabella degli effetti.');
  writeln;
  Writeln('Sorgente        Media alto Med. basso    Effetto   Sum of s df    F ratio Prb.');
  tot:= 0;
  cf:= 0;
  sstot:= 0;
  somma:= 0;
  fStr:= '';
  (* Somma risultati*)
  for i:= 1 to IPow(2, p) do begin
    t[i]:= 0;
    for m:= 1 to cicli do begin
      t[i]:= t[i] + Resp[i, m];
      sstot:= sstot + sqr(Resp[i, m]);
    end;
    cf:= cf+t[i];
  end;
  media:= cf / (cicli * IPow(2, p));
  (* Calc Effetti *)
  for n:= 1 to IPow(2, p) do begin
    la[n]:= 0;
    lb[n]:= 0;
    for i:= 1 to IPow(2, p) do begin
      segn:= 1;
      for m:= 1 to length(alias[n]) do begin
        for l:= 1 to p do begin
          if alias[n][m] = chr(96+Pura[l]) then break;
        end;
        segno:= SegnoPura(i, l);
        segn:= segn * segno;
      end;
      if segn = 1 then la[n]:= la[n] + t[i] else lb[n]:= lb[n] + t[i];
    end;
    eff[n]:= la[n] - lb[n];
    ss[n]:= sqr(eff[n]) / (cicli * IPow(2, p));
    tot:= tot + ss[n];
    eff[n]:= eff[n]/(cicli * Ipow(2,p) * 0.5);
    la[n]:= la[n]/(cicli * Ipow(2,p) * 0.5);
    lb[n]:= lb[n]/(cicli * Ipow(2,p) * 0.5);
  end;
  cf:= sqr(cf) / (cicli * IPow(2, p));
  sstot:= sstot - cf;
  res:= sstot - tot;
  df:= cicli * IPow(2, p) - 1;
  if res = 0 then res:= 0.0001;
  (* Stampa effetti *)
  for n:= 1 to IPow(2, p) do begin
    f1:= la[n];
    f2:= lb[n];
    f3:= eff[n];
    f4:= ss[n];
    dfr:= df - IPow(2, p) + 1;
    if cicli > 1 then begin
      f5:=ss[n]*dfr/res;
      FTable;
    end
    else begin
      f5:= 0;
    end;
    write(alias[n]);
    for z:= 0 to 15-length(alias[n]) do write(' ');
    writeln(f1:10:4,' ', f2:10:4,' ', f3:10:4,' ', f4:10:4,' ', '1  ',f5:10:4,' ', fStr);
  end;
  write('Residuo'); for z:= 1 to 42 do write(' ');
  writeln(res:10:4,' ',dfr:2);
  FlagStat:= true;
  writeln;
  WaitReturn;
end;

procedure TEspFatt.Assi(lim: PREC);
var
  tmp: string;
  m: integer;
begin
  for m:= 0 to 10 do begin
    Move(0, m*lim/10); str(m:2,tmp); MoveTo(0, GetY-4); OutText(tmp);
  end;
  Move(0.7, -(lim/10)); Moveto(GetX, GetMaxY-9); OutText('l.basso');
  Move(2.7, -(lim/10)); Moveto(GetX, GetMaxY-9); OutText('l. alto');
end;

procedure TEspFatt.GrafEffet;
var
  i: integer;
  lim: PREC;
  ch: char;
  tmp: string;
begin
  ClrScr;
  if not FlagStat then begin
    writeln('Analizzare prima i risultati statistici!');
    WaitReturn;
    exit;
  end;
  GInit;
  DirectVideo:= false;
  for i:= 1 to IPow(2, p) do begin
    GClear;
    OutTextXY(0,0,'Grafici degli effetti    '+alias[i]);
    str(Eff[i]:15:7, tmp);
    tmp:='Effetto: '+tmp;
    OutTextXY(0, 8, tmp);
    lim:= exp(int(ln(la[i])/ln(10)+1)*ln(10));
    Frame(40, GetMaxX - 40, 40, GetMaxY-11);
    Scale(0, 4, 0, lim);
    XAsis(0, 1);
    YAsis(0, lim * 0.1);
    Move(1,lb[i]); Draw(3, la[i]);
    Move(0.4, lb[i]); Str(lb[i]:9:4, tmp); OutText(tmp);
    Move(3.1, la[i]); Str(la[i]:9:4, tmp); OutText(tmp);
    Assi(lim);
    GotoXY(30, 2); GetChar('F)ine ', ch);
    if ch='F' then begin
      break;
    end;
  end;
  GDone;
  DirectVideo:= true;
end;

procedure TEspFatt.GrafInter;
var
  n, ax, q, i, l, err: integer;
  rStr: string;
  tmp, lim, tot: PREC;
  fstr, VStr: string[50];
  liv: array[1..10] of integer;
  xa: array[1..10] of PREC;
  procedure Polinomio;
  var
    m, z, y, segno, sign: integer;
  begin
    for m:= 1 to IPow(2, p) do begin
      sign:= 1;
      for z:= 1 to length(alias[m]) do begin
        for y:=1 to p do begin
          if alias[m][z] = chr(Pura[y]+96) then break;
        end;
        if (y <> q) and (y<>ax) then segno:= liv[y];
        if (y = ax) then segno:= l;
        if (y = q)  then segno:= i;
        sign:= sign * segno;
      end;
      tot:= tot + eff[m]*sign;
    end;
    xa[n]:= media + 0.5*tot;
    if xa[n]> lim then lim:= xa[n];
  end;
begin
  ClrScr;
  if not FlagStat then begin
    writeln('Analizzare prima i risultati statistici!');
    WaitReturn;
    exit;
  end;
  Writeln('Rappresentazione grafica delle interazioni');
  writeln;
  for i:= 1 to p do begin
    GotoXY(1, 2+i); writeln(chr(Pura[i]+96),':');
  end;
  writeln;
  writeln('Indica con x la variabile dell''asse x, con y quella da tracciare');
  writeln('le altre con 1 o -1');
  ax:= 0; q:= 0;
  for i:= 1 to p do begin
    repeat
      rStr:= '*';
      GotoXY(3, 2+i); InputStr('', rStr);
      if (rStr = 'x') or (rStr = 'X') then begin ax:= i; break; end;
      if (rStr = 'y') or (rStr = 'Y') then begin q:= i; break; end;
      val(rStr, liv[i], err);
      if (err = 0) and (abs(liv[i]) = 1) then break;
    until false;
  end;
  n:= 0;
  lim:= 0;
  i:= -1;
  while (i<=2) do begin
    l:= -1;
    while (l<= 2) do begin
      n:= n+1;
      xa[n]:= 0;
      tot:= 0;
      Polinomio;
      inc(l,2);
    end;
    inc(i, 2);
  end;
  lim:= exp(int(ln(lim)/ln(10)+1)*ln(10));
  Ginit;
  DirectVideo:= false;
  Frame(40, GetMaxX - 40, 40, GetMaxY-11);
  OutTextXY(0,0,'Iterazioni');
  vStr:='Linea continua: ' + chr(Pura[q]+96) + ' alto';
  OutTextXY(1, 9, vStr);
  vStr:='Linea tratteg.: ' + chr(Pura[q]+96) + ' alto';
  OutTextXY(1, 18, vStr);
  vStr:= chr(Pura[ax]+96);
  OutTextXY((GetMaxX-4) div 2, GetMaxY - 8, vStr);
  Scale(0, 4, 0, lim);
  XAsis(0, 1);
  YAsis(0, lim * 0.1);
  Assi(lim);
  Move(1, xa[1]); Draw(3, xa[2]);
  tmp:= xa[1]; Move(0.4, tmp); Str(tmp:9:4, fStr); OutText(fStr);
  tmp:= xa[2]; Move(3.1, tmp); Str(tmp:9:4, fStr); OutText(fStr);
  SetLineStyle(DashedLn, 0, NormWidth);
  Move(1, xa[3]); Draw(3, xa[4]);
  SetLineStyle(SolidLn, 0, NormWidth);
  tmp:= xa[3]; Move(0.4, tmp); Str(tmp:9:4, fStr); OutText(fStr);
  tmp:= xa[4]; Move(3.1, tmp); Str(tmp:9:4, fStr); OutText(fStr);
  GotoXY(30, 2); write('premere RETURN'); while readkey <> #13 do ;
  GDone;
  DirectVideo:= true;
end;

destructor TEspFatt.Done;
begin
end;

procedure HpEspFatMain;
var
  ch: char;
  Esp: PEspFatt;
begin
  New(Esp, Init); with Esp^ do begin
  Init;
  Variabili;
  repeat
    ClrScr;
    writeln('                                             (#variabili - #riduzioni)');
    writeln('Esperimenti fattoriali completi e/o ridotti 2');
    writeln;
    writeln('1: Preparazione dello schema sperimentale');
    writeln('2: Tabelle del mescolamento degli effetti');
    writeln('3: Input dei risulati sperimentali');
    writeln('4: Risultati statitsitici dell''esperimento');
    writeln('5: Rappresentazione grafica degli effetti ');
    writeln('6: Rappresentazione grafica delle interazioni');
    writeln;
    writeln('0: fine programma');
    writeln;
    writeln;
    GetChar('Quale? ',ch);
    case ch of
      '1': CondEsper;
      '2': MescEffet;
      '3': InputRisu;
      '4': RisulStat;
      '5': GrafEffet;
      '6': GrafInter;
    end;
  until ch = '0';
  Done;
  end; Dispose(Esp, Done);
end;

{$IFNDEF UNIT}
begin
  HpEspFatMain;
{$ENDIF}
end.
