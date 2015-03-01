{$I switches.inc}
{ UNDEF UNIT}

{$IFDEF UNIT}
unit HpModSim;

interface

procedure MenuHPModSim;

implementation
{$ELSE}

{$ENDIF}

uses SmlPrs, Dos, DataMngr, MathTool, Crt, HPGraf, Graph;
{$V-}

const
  ModSimDataName = 'ModSimDataFile';
  NullStr = '*';

type

  StrType = array[1..120, 1..7] of string[20];

  AttRec = record
    Kind    : integer;
    OutTime : integer;
    Pezzi   : integer;
    PezziTot: integer;
    usc     : array[0..2] of integer;
    InCor   : integer;
    InTot   : integer;
    InMax   : integer;
    TempAtt : integer;
    occupata: boolean;
  end;

var
  pStr: ^StrType;
  aStr: array[1..7] of string[20];
  NumAtt: integer;
  NomeAtt: array[0..119] of string[20];
  Attiv : array[0..119] of AttRec;
  AttInd: array[0..119] of integer;
  FlagPrepModello: boolean;
  FlagGrafModello: boolean;
  ModelName: PathStr;
  TempoTot, tempo: integer;
  AttFocused: integer;
  tlavor: integer;
  vers1, vers2 : integer;

procedure Variabili;
begin
  AStr[1]:= 'coord.x:';
  AStr[2]:= 'coord.y:';
  AStr[3]:= 'dim.gruppo lavoraz:';
  AStr[4]:= 'tempo lavorazione :';
  AStr[5]:= '% unita'' verso 1^u:';
  AStr[6]:= '% unita'' verso 2^u:';
  AStr[7]:= 'costo/unita'' lavor:';
  FlagPrepModello:= false;
  FlagGrafModello:= false;
end;

procedure ClearAtt;
var i, l: integer;
begin
  for i:= 1 to 119 do begin
    for l:= 1 to 7 do begin
      pStr^[i, l]:= NullStr;
    end;
  end;
  for l:= 1 to 7 do begin
    pStr^[120, l]:= '';
  end;
end;

procedure NuovoFile(var fil: text);
var i, l: integer;
begin
  Rewrite(Fil);
  writeln(fil, ModSimDataName);
  for i:= 1 to 119 do begin
    writeln(Fil, NullStr);
    for l:= 1 to 7 do begin
      writeln(Fil, NullStr);
    end;
  end;
  Close(Fil);
end;

procedure LeggiFile(var fil: text);
var
  tmp: string;
  i, l: integer;
begin
  Reset(fil);
  readln(fil, tmp);
  if tmp <> ModSimDataName then begin
    writeln;
    writeln('Spiacente, ma il file non contiene dati validi.');
    writeln;
    WaitReturn;
    ClearAtt;
  end
  else begin
    for i:= 1 to 119 do begin
      Readln(Fil, NomeAtt[i]);
      for l:= 1 to 7 do begin
        Readln(Fil, pStr^[i, l]);
      end;
    end;
  end;
  Close(Fil);
end;

procedure ScriviFile(var fil: text);
var i, l: integer;
begin
  Rewrite(Fil);
  writeln(fil, ModSimDataName);
  for i:= 1 to 119 do begin
    writeln(fil, NomeAtt[i]);
    for l:= 1 to 7 do begin
      writeln(Fil, pStr^[i, l]);
    end;
  end;
  Close(Fil);
end;

procedure Refresh(Att: integer);
var
  x, y: integer;
begin
  GotoXY(1,4);
  write('Attivita'' #',Att:3,': '); if Att = 120 then writeln else writeln(NomeAtt[Att]);
  x:= ((Att-1) div 7) + 1;
  y:= Att mod 7; if y = 0 then y:= 7;
  GotoXY(1, 6);
  write(AStr[1], ' '); if Att = 120 then writeln else writeln(x);
  write(AStr[2], ' '); if Att = 120 then writeln else writeln(y);
  GotoXY(1, 9);
  writeln(AStr[3], ' ', pStr^[Att, 1]);
  writeln(AStr[4], ' ', pStr^[Att, 2]);
  writeln(AStr[7], ' ', pStr^[Att, 5]);
  writeln;
  write(AStr[5], ' ', pStr^[Att, 3]); GotoXY(41, WhereY); writeln('Attivita'': ', pStr^[Att, 6]);
  write(AStr[6], ' ', pStr^[Att, 4]); GotoXY(41, WhereY); writeln('Attivita'': ', pStr^[Att, 7]);
end;

procedure AlVideo(Att: integer);
begin
  ClrScr;
  writeln('Descrizione Attivita'' modello simulatore');
  writeln('Modello: ',ModelName);
  Refresh(Att);
end;

procedure EditAtt(Att: integer);
var
  temp: string;
  procedure Take(xx, yy, zz: integer);
  begin
    GotoXY(xx, yy);
    InputStr('', pStr^[Att, zz]);
    Refresh(Att);
  end;
begin
  GotoXY(1,4);
  Str(Att:3, temp);
  InputStr('Attivita'' #'+temp+': ', NomeAtt[Att]);
  Take(21,  9, 1);
  Take(21, 10, 2);
  Take(21, 11, 5);
  Take(21, 13, 3);
  Take(52, 13, 6);
  Take(21, 14, 4);
  Take(52, 14, 7);
end;

procedure NuoveAttivita;
var
  i: integer;
  x, y: integer;
  ch: char;
begin
  i:= 120;
  repeat
    AlVideo(i);
    writeln;
    GetChar('Altra attivita'' (S/N)? ', ch);
    if ch = 'N' then exit;
    GotoXY(1, 6);
    x:= 1; y:= 1;
    InputInt(AStr[1]+' ', x,0,maxint);
    InputInt(AStr[2]+' ', y,0,maxint);
    i:= (x-1)*7+y;
    if (i < 1) or (i > 119) then i := 120
    else begin
      AlVideo(i);
      EditAtt(i);
    end;
  until false;
end;

procedure PrepModello;
var
  ModelloFil: text;
  ch: char;
  i: integer;
  function GetNext(i: integer): integer;
  begin
    inc(i);
    while (i<=120) and (NomeAtt[i] = NullStr) do inc(i);
    GetNext:= i;
  end;
  function GetPrev(i: integer): integer;
  begin
    dec(i);
    while (i>=1) and (NomeAtt[i] = NullStr) do dec(i);
    GetPrev:= i;
  end;
  function Modifiche: char;
  var
    ch: char;
  begin
    writeln;
    GetChar('Cosa vuoi fare [M)odifica, I)ndietro, A)vanti, F)ine]? ', ch);
    if ch= 'M' then EditAtt(i);
    Modifiche:= ch;
  end;
begin
  NumAtt:= 0;
  ClrScr;
  writeln('Preparazione del modello');
  writeln;
  writeln('indica con > come prima lettera le att.sorgenti');
  writeln('indica con 0 come prima lettera le att.fittizie');
  writeln('indica con nil le usite non definite');
  writeln('indica con * le attivita'' che vuoi eliminare');
  writeln;
  write('modello: '); readln(ModelName);
  if ModelName = '' then exit;
  Assign(ModelloFil, ModelName);
  if not FileExist(ModelName) then NuovoFile(ModelloFil);
  LeggiFile(ModelloFil);
  writeln;
  GetChar('Modifiche? ', ch);
  if ch <> 'N' then begin
    i:= GetNext(0);
    while (i>=1) and (i<=120) do begin
      AlVideo(i);
      ch:= Modifiche;
      case ch of
        'I': begin i:= GetPrev(i); if i = 0 then i:= GetNext(0); end;
        'F': i:= 0;
        else i:= GetNext(i);
      end;
    end;
  end;
  NuoveAttivita;
  ScriviFile(ModelloFil);
  FlagPrepModello:= true;
end;

procedure Disegna;
var
  i: integer;
  xb, yb, xe, ye, xs, ys: integer;
  k, z, x, y, xx, yy: integer;
  t: integer;
  tmp: string;
begin
  GInit;
  GClear;
  xs:= succ(GetMaxX) div 20;
  ys:= succ(GetMaxY) div 10;
  xb:= (GetMaxX - 17 * xs) div 2; xe:= xb + 17 * xs;
  yb:= (GetMaxY -  7 * ys) div 2; ye:= yb +  7 * ys;
  SetLineStyle(SolidLn, 0, ThickWidth);
  Rectangle(pred(xb), pred(yb), succ(xe), succ(ye));
  SetTextJustify(CenterText, CenterText);
  if (yb - 18) div 8 > 1 then t:= 2 else t:= 1;
  SetTextStyle(0, HorizDir, t);
  OutTextXY(GetMaxX div 2, (yb - 12) div 2, 'Grafo del Modello da Simulare');
  OutTextXY(GetMaxX div 2, GetMaxY - yb div 2 + 2, 'Premere RETURN');
  SetTextStyle(0, HorizDir, 1);
  for i:= 0 to 16 do begin
    str(succ(i):2, tmp);
    OutTextXY(xb + i * xs + xs div 2, yb - 6, tmp);
    OutTextXY(xb + i * xs + xs div 2, ye + 8, tmp);
  end;
  for i:= 0 to 6 do begin
    str(succ(i):1, tmp);
    OutTextXY(xb - 10, yb + i * ys + ys div 2, tmp);
    OutTextXY(xe + 11, yb + i * ys + ys div 2, tmp);
  end;
  k:= 0;
  for i:= 1 to 119 do begin
    x:= (i-1) div 7;
    y:= (i-1) mod 7;
    SetLineStyle(DottedLn, 0, NormWidth);
    Rectangle(xb + x*xs, yb + y*ys, xb + succ(x)*xs, yb + succ(y)*ys);
    if NomeAtt[i] <> NullStr then begin
      if NomeAtt[i][1] = '>' then
        SetLineStyle(SolidLn, 0, ThickWidth)
      else if NomeAtt[i][1] = '0' then
        SetLineStyle(DottedLn, 0, NormWidth)
      else 
        SetLineStyle(SolidLn, 0, NormWidth);
      Ellipse(xb + x*xs + xs div 2, yb + y*ys + ys div 2, 0, 360, xs div 2, ys div 2);
      inc(k);
    end;
    SetLineStyle(SolidLn, 0, NormWidth);
    x:= xb + succ(x) * xs;
    y:= yb + y*ys + ys div 2;
    if NomeAtt[i] <> NullStr then begin
      Str(k, tmp);
      OutTextXY(x - xs div 2, y, tmp);
    end;
    for z:= 1 to 2 do begin
      if Attiv[i].usc[z] <> 0 then begin
        xx:= (Attiv[i].usc[z] -1) div 7;
        yy:= (Attiv[i].usc[z] -1) mod 7;
        xx:= xb + xx * xs; yy:= yb + yy*ys + ys div 2;
        Line(x, y, xx, yy);
      end;
    end;
  end;
  readln;
  GDone;
end;

procedure GrafModello;
var
  i, l, k, x, y, z, xx, yy : integer;
  ch: char;
begin
  ClrScr;
  if not FlagPrepModello then begin
    writeln;
    writeln('Prepara prima il modello da descrivere!!');
    writeln;
    WaitReturn;
    exit;
  end;
  writeln('Grafo del modello simulatore: ', ModelName);
  writeln;
  k:= 0;
  for i:= 1 to 119 do begin
    if NomeAtt[i] <> NullStr then begin
      inc(k);
      x:= (i-1) div 7 +1;
      y:= i mod 7; if y = 0 then y:= 7;
      write('Nodo #',k:2,' (x:',x:2, ', y:',y:2,')  connessioni: ');
      for z:= 1 to 2 do begin
        Attiv[i].usc[z]:= 0;
        for l:= 1 to 119 do begin
          if pStr^[i, z+5] = NomeAtt[l] then begin
            xx:= (l-1) div 7 +1;
            yy:= l mod 7; if yy = 0 then yy:= 7;
            write(' (x: ',xx:2,', y:',yy:2,')');
            Attiv[i].usc[z]:= l;
          end;
        end;
      end;
      writeln;
      if (k mod 20) = 0 then WaitReturn;
    end;
  end;
  writeln;
  GetChar('Faccio un grafico [S)i, N)o]? ', ch);
  if ch = 'S' then Disegna;
  FlagGrafModello:= true;
end;

procedure InpAtt;
var
  attStr: string;
  found: boolean;
  i, att: integer;
begin
  writeln;
  attStr:= '';
  InputStr('Attivita'' da seguire (nome o numero): ', attStr);
  found:= false;
  for i:= 1 to NumAtt do begin
    if NomeAtt[AttInd[i]] = attStr then begin
      AttFocused:= AttInd[i];
      found:= true;
      break;
    end;
  end;
  if not found then begin
    Att:= IVal(attStr);
    if (Att>=1) and (Att<=NumAtt) then AttFocused:= AttInd[Att];
  end;
end;

procedure AttLibera(Att: integer);
begin
  tlavor:= IVal(pStr^[Att,2]);
  with Attiv[Att] do begin
    if InCor < Pezzi then begin
      inc(TempAtt);
    end
    else begin
      dec(InCor, Pezzi);
      inc(PezziTot, Pezzi);
      occupata:= true;
      OutTime:= tempo + tlavor;
    end;
  end;
end;

procedure AttOccupata(Att: integer);
begin
  with Attiv[Att] do begin
    if tempo < OutTime then exit;
    inc(Attiv[usc[1]].InCor, vers1);
    inc(Attiv[usc[2]].InCor, vers2);
    inc(Attiv[usc[1]].InTot, vers1);
    inc(Attiv[usc[2]].InTot, vers2);
    occupata:= false;
  end;
end;

procedure Fittizio(Att: integer);
var
  temp: PREC;
begin
  with Attiv[Att] do begin
    temp:= RVal(pStr^[Att, 3]) * 0.01; vers1:= round(Pezzi * temp);
    temp:= RVal(pStr^[Att, 4]) * 0.01; vers2:= round(Pezzi * temp);
    inc(Attiv[usc[1]].InCor, vers1);
    inc(Attiv[usc[2]].InCor, vers2);
    InCor:= 0;
    inc(Attiv[usc[1]].InTot, vers1);
    inc(Attiv[usc[2]].InTot, vers2);
  end;
end;

procedure Sorgente(Att: integer);
begin
  with Attiv[Att] do begin
    if tempo < OutTime then exit;
    inc(PezziTot, Pezzi);
    tlavor:= IVal(pStr^[Att, 2]);
    inc(Attiv[usc[1]].InCor, vers1);
    inc(Attiv[usc[2]].InCor, vers2);
    inc(Attiv[usc[1]].InTot, vers1);
    inc(Attiv[usc[2]].InTot, vers2);
    OutTime:= tempo+tlavor;
  end;
end;

procedure AggiornAttivita(Att: integer);
var
  temp: PREC;
begin
  with Attiv[Att] do begin
    Pezzi:= IVal(pStr^[Att, 1]);
    temp:= RVal(pStr^[Att, 3]) * 0.01; vers1:= round(Pezzi * temp);
    temp:= RVal(pStr^[Att, 4]) * 0.01; vers2:= round(Pezzi * temp);
    if NomeAtt[Att, 1] = '0' then begin Fittizio(Att); exit; end;
    if NomeAtt[Att, 1] = '>' then begin Sorgente(Att); exit; end;
    if occupata then AttOccupata(Att)
    else AttLibera(Att);
  end;
end;

procedure AttivitaDaSeguire;
var
  temp: PREC;
  t: integer;
begin
  ClrScr;
  writeln;
  writeln('Attivita'': ',NomeAtt[AttFocused]);
  writeln;
  writeln('tempo: ', tempo:5);
  writeln;
  writeln;
  writeln('   grandezza        attuale     totale   ');
  writeln('------------------ ---------- -----------');
  with Attiv[AttFocused] do begin
    writeln('Pezzi ingresso   : ', InCor:10, ' (', InTot:10, ')');
    temp:= RVal(pStr^[AttFocused, 5]);
    writeln('Produzione totale: ', PezziTot:10);
    writeln('Costo            : ', (PezziTot * temp):10:0);
    writeln('Tempo attesa     : ', TempAtt:10);
    writeln;
    temp:= RVal(pStr^[AttFocused, 3]) * 0.01; t:= round(PezziTot * temp);
    writeln('Uscita verso #1  : ', Attiv[usc[1]].InCor:10, ' (', t:10, ')');
    temp:= RVal(pStr^[AttFocused, 4]) * 0.01; t:= round(PezziTot * temp);
    writeln('Uscita verso #2  : ', Attiv[usc[2]].InCor:10, ' (', t:10, ')');
  end;
end;

procedure Risultati;
var
  temp: PREC;
  i: integer;
begin
  ClrScr;
  writeln('Tabella riassuntiva dei risultati della simlazione');
  writeln('--------------------------------------------------');
  writeln('tempo di simulazione: ', tempo:5);
  writeln;
  writeln('  Descrizione    t.input   f.input  mx.input  t.produz  t.costi   attesa inp');
  writeln('---------------+---------+---------+---------+---------+---------+----------+');
  for i:= 1 to NumAtt do begin
    with Attiv[AttInd[i]] do begin
      temp:= RVal(pStr^[AttInd[i], 5]);
      writeln(Format(NomeAtt[AttInd[i]], 15),' ', InTot:9,' ',InCor:9,' ',InMax:9,' ',
        PezziTot:9,' ', (PezziTot * temp):9:0,' ',TempAtt:10);
    end;
    if (i mod 20) = 0 then WaitReturn;
  end;
  writeln;
  if (i mod 20) <> 0 then WaitReturn;
end;

procedure Simulazione;
var
  Fast: boolean;
  CurAtt, i: integer;
  ch: char;
begin
  ClrScr;
  if not FlagGrafModello then begin
    writeln;
    writeln('Bisogna creare il grafo prima di simulare il modello!!');
    writeln;
    WaitReturn;
    exit;
  end;
  ClrScr;
  writeln;
  writeln('Programma simulatore a blocchi');
  writeln;
  writeln('Modello simulato: ',ModelName);
  writeln;
  writeln(':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::..');
  writeln('Durante la simulazione premere:');
  writeln(' 1   : risultati parziali');
  writeln(' 2   : input attivita'' da seguire');
  writeln(' F   : termina in anticipo la simulazione');
  writeln(' V   : modo veloce ON/OFF');
  writeln('       (nel modo veloce non e'' piu'' possibile cambiare attivita''');
  writeln;
  writeln;
  TempoTot:= 1;
  InputInt('Tempo totale della simulazione: ', TempoTot,1,maxint);
  NumAtt:= 0;
  NomeAtt[0]:= NullStr;
  for i:= 0 to 119 do begin
    with Attiv[i] do begin
      OutTime:= 0;
      occupata:= false;
      InCor:=0;
      InTot:= 0;
      Pezzi:= 0;
      PezziTot:= 0;
      TempAtt:= 0;
      InMax:= 0;
      if NomeAtt[i] <> NullStr then begin
        inc(NumAtt);
        AttInd[NumAtt]:= i;
        if NomeAtt[i,1] = '>' then OutTime:= IVal(pStr^[i,2]);
      end;
    end;
  end;
  AttFocused:= AttInd[1];
  InpAtt;
  ClrScr;
  writeln('Simulazione modello : ',ModelName,' in corso');
  writeln;
  Fast:= false;
  for tempo:=  1 to TempoTot do begin
    if keypressed then begin
      writeln;
      ch:= readkey; ch:= UpCase(ch);
      case ch of
        '1': risultati;
        '2': InpAtt;
        'F': break;
        'V': Fast:= not Fast;
      end;
    end;
    for i:= 1 to NumAtt do begin
      CurAtt:= AttInd[i];
      AggiornAttivita(CurAtt);
      with Attiv[CurAtt] do begin
        if InCor > InMax then InMax:= InCor;
      end;
    end;
    AttivitaDaSeguire;
    writeln;
    write('1) Risultati parziali, 2) cambia attivita'', F)ine, altri tasti prosegue ');
    if not Fast then repeat until keypressed;
  end;
  writeln;
  writeln;
  WaitReturn;
end;

procedure DescrAtt;
var
  i, k, x, y: integer;
begin
  ClrScr;
  if not FlagPrepModello then begin
    writeln;
    writeln('Prepara prima il modello da descrivere!!');
    writeln;
    WaitReturn;
    exit;
  end;
  writeln(' #    Descrizione    x   y  d.grp t.lavor cost/un % out Attiv. uscita');
  writeln('---+---------------+---+---+-----+-------+-------+-----+---------------');
  k:= 0;
  for i:= 1 to 119 do begin
    if NomeAtt[i] <> NullStr then begin
      inc(k);
      x:= (i-1) div 7 + 1;
      y:= i mod 7; if y = 0 then y:= 7;
      writeln(k:3,' ',
         Format(NomeAtt[i],15),' ',
         x:3,' ',
         y:3,' ',
         FormatR(pStr^[i, 1],  5), ' ',
         FormatR(pStr^[i, 2],  7), ' ',
         FormatR(pStr^[i, 5],  7), ' ',
         FormatR(pStr^[i, 3],  5), ' ',
         Format (pStr^[i, 6], 15));
      writeln('                                                  ',
         FormatR(pStr^[i, 4],  5),' ',
         Format (pStr^[i, 7], 15));
      writeln('---------------------------------------------------------------------------');
      if (k mod 7)= 0 then WaitReturn;
    end;
  end;
  if (k mod 7) <> 0 then WaitReturn;
end;

procedure MenuHPModSim;
var ch: char;
begin
  New(pStr);
  ClearAtt;
  Variabili;
  repeat
    ClrScr;
    Writeln('  - Modelli Simulatori Discreti Deterministici - ');
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Finisce programma                 |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Preparazione modello simulatore   |                                      |');
    writeln('| 2. Rappresentazione grafica modello  |                                      |');
    writeln('| 3. Simulazione                       |                                      |');
    writeln('| 4. Risultati della simulazione       |                                      |');
    writeln('| 5. Descrizione attivit…              |                                      |');
    writeln('|                                      |                                      |');
    writeln('| Z. Cancella i dati in memoria        |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('+-----------------------------------------------------------------------------+');
    writeln('| Quale e'' la tua scelta?                                                     |');
    write  ('+-----------------------------------------------------------------------------+');
    GotoXY(27, WhereY - 1);
    ch:= readkey; if ch = #0 then readkey;
    ch:= UpCase(ch);
    case ch of
      '1': PrepModello;
      '2': GrafModello;
      '3': Simulazione;
      '4': Risultati;
      '5': DescrAtt;
      'Z': ClearAtt;
    end;
  until ch = '0';
  Dispose(PStr);
end;

{$IFNDEF UNIT}
begin
  MenuHPModSim;
{$ENDIF}
end.
