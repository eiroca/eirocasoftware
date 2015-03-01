{$I switches.inc}
{ UNDEF UNIT}

{$IFDEF UNIT}
unit ModSim;

interface

procedure MenuModSim;

implementation
{$ELSE}

{$ENDIF}

uses Dos, DataMngr, MathTool, Crt, HPGraf, Graph;
{$V-}

const
  OldModSimDataName = 'ModSimDataFile';
  ModSimDataName = ord(^e)+256*ord(^z);

const
  NullStr = '*';

type

  TNome = string[15];

  AttRec = record
    Kind    : integer;
    Nome    : TNome;
    X, Y, R : integer;
    NumUsc  : integer;
    TemLav  : integer;
    CstUnt  : PREC;
    OutTime : longint;
    Pezzi   : integer;
    PezziTot: longint;
    PerUsc  : array[1..2] of PREC;
    NamUsc  : array[1..2] of TNome;
    AttUsc  : array[1..2] of integer;
    PezUsc  : array[1..2] of integer;
    InCor   : integer;
    InTot   : longint;
    InMax   : integer;
    TempAtte: longint;
    occupata: boolean;
  end;

  TModello = record
    Nome: PathStr;
    FlagModello: boolean;
    FlagCheckModello: boolean;
    NumAtt: integer;
    Attiv : array[0..119] of AttRec;
    Tempo: longint;
    TempoTot: longint;
    AttFocused: integer;
  end;

var
  Model: TModello;

procedure ImportFile(var Modello: TModello);
var
  fil: text;
  tmp: string;
  i, l: integer;
begin
  with Modello do begin
    Assign(fil, Nome);
    Reset(fil);
    readln(fil, tmp);
    if tmp <> OldModSimDataName then begin
      writeln;
      writeln('Spiacente, ma il file non contiene dati validi.');
      writeln;
      WaitReturn;
      exit;
    end;
    NumAtt:= 0;
    for i:= 1 to 119 do begin
      Readln(Fil, tmp);
      if tmp <> NullStr then begin
        inc(NumAtt);
        with Attiv[NumAtt] do begin
          case tmp[1] of
            '0': begin Kind:= 2; delete(tmp,1,1); end;
            '>': begin Kind:= 1; delete(tmp,1,1); end;
            else Kind:= 0;
          end;
          Nome:= tmp;
          R:= 20;
          X:= ((i-1) div 7 + 1) * 30;
          Y:= ((i-1) mod 7 + 1) * 30;
          NumUsc:=2;
          Readln(Fil, tmp); Pezzi:= IVal(tmp);
          Readln(Fil, tmp); TemLav:= IVal(tmp);
          Readln(Fil, tmp); PerUsc[1]:= IVal(tmp) * 0.01;
          Readln(Fil, tmp); PerUsc[2]:= IVal(tmp) * 0.01;
          Readln(Fil, tmp); CstUnt:= RVal(tmp);
          Readln(Fil, tmp); NamUsc[1]:= tmp;
          Readln(Fil, tmp); NamUsc[2]:= tmp;
        end;
      end
      else begin
        for l:= 1 to 7 do Readln(Fil, tmp);
      end;
    end;
    Close(Fil);
  end;
end;

procedure LeggiFile(var Modello: TModello);
var
  Id: longint;
  i, rd: word;
  fil: file;
begin
  with Modello do begin
    Assign(fil, Nome);
    Reset(fil,1);
    blockRead(fil, id, sizeof(ID), rd); if rd <> sizeof(ID) then ID:= 0;
    if ID <> ModSimDataName then begin
      close(fil);
      ImportFile(Modello);
      exit;
    end
    else begin
      blockread(fil, NumAtt, sizeof(NumAtt));
      for i:= 1 to NumAtt do begin
        blockread(fil, Attiv[i], sizeof(AttRec));
      end
    end;
    Close(Fil);
  end;
end;

procedure ScriviFile(var Modello: TModello);
var
  fil: file;
  id: longint;
  ch: char;
  i: integer;
begin
  with Modello do begin
    Assign(fil, Nome);
    Rewrite(fil, 1);
    ID:= ModSimDataName;
    blockwrite(fil, ID, sizeof(ID));
    blockwrite(fil, NumAtt, Sizeof(NumAtt));
    for i:= 1 to NumAtt do begin
      blockwrite(fil, Attiv[i], sizeof(Attiv[i]));
    end;
    Close(Fil);
  end;
end;

function FindAtt(var Modello: TModello; Name: string): integer;
var
  found: boolean;
  i: integer;
  whr: integer;
begin
  with Modello do begin
    found:= false;
    whr:= 0;
    Name:= UCASE(Name);
    for i:= 1 to NumAtt do begin
      if UCASE(Attiv[i].Nome) = Name then begin
        whr:= i;
        found:= true;
        break;
      end;
    end;
    if not found then begin
      whr:= IVal(Name);
      if (whr < 1) or (whr > NumAtt) or (Attiv[whr].Kind < 0) then whr:= 0;
    end;
    FindAtt:= whr;
  end;
end;

procedure EditModello(var Modello: TModello);
var
  ch: char;
  i: integer;
  procedure Refresh(Att: integer);
  var
    x, y: integer;
  begin
    GotoXY( 1,  4); writeln('Attivita'' #',Att:3,':'); ClrEOL;
    GotoXY( 1,  5); writeln('Tipo:'); ClrEOL;
    GotoXY( 1,  6); write('coord.x:'); ClrEOL;
    GotoXY( 1,  7); write('coord.y:'); ClrEOL;
    GotoXY( 1,  8); write('raggio :'); ClrEOL;
    GotoXY( 1, 10); write('dim.gruppo lavoraz:'); ClrEOL;
    GotoXY( 1, 11); write('tempo lavorazione :'); ClrEOL;
    GotoXY( 1, 12); write('costo/unit… lavor.:'); ClrEOL;
    GotoXY( 1, 14); write('% unit… verso 1^u :'); ClrEOL;
    GotoXY(30, 14); write('Attivit…: '); ClrEOL;
    GotoXY( 1, 15); write('% unita'' verso 2^u:'); ClrEOL;
    GotoXY(30, 15); write('Attivit…: '); ClrEOL;
    if (Att >=1) and (Att <= Modello.NumAtt) then begin
      with Modello.Attiv[Att] do begin
        GotoXY(18,  4); writeln(Nome);
        GotoXY(10,  5);
        case Kind of
          1: writeln('sorgente');
          2: writeln('fittizia');
          else writeln('normale');
        end;
        GotoXY(10,  6); writeln(X);
        GotoXY(10,  7); writeln(Y);
        GotoXY(10,  8); writeln(R);
        GotoXY(20, 10); writeln(Pezzi);
        GotoXY(20, 11); writeln(TemLav);
        GotoXY(20, 12); writeln(CstUnt:10:3);
        GotoXY(20, 14); writeln(PerUsc[1]*100:5:1);
        GotoXY(20, 15); writeln(PerUsc[2]*100:5:1);
        GotoXY(42, 14); writeln(NamUsc[1]);
        GotoXY(42, 15); writeln(NamUsc[2]);
      end;
    end;
  end;
  procedure AlVideo(Att: integer);
  begin
    ClrScr;
    writeln('Descrizione Attivita'' modello simulatore');
    writeln('Modello: ',Modello.Nome);
    Refresh(Att);
  end;
  procedure EditAtt(Att: integer);
  var
    ch: char;
    tmp: PREC;
  begin
    with Modello.Attiv[Att] do begin
      NumUsc:= 2;
      GotoXY(18,  4); InputStr('',Nome);
      if Nome='*' then begin
        Kind:= -1;
        Nome:= '(deleted)';
        Refresh(Att);
        exit;
      end;
      GotoXY(10,  5); ClrEol; GetChar('N)ormale, S)org, F)itt', ch);
      case Upcase(ch) of
        'S': Kind:= 1;
        'F': Kind:= 2;
        else Kind:= 0;
      end;
      Refresh(Att);
      GotoXY(10,  6); InputInt('',X,0,maxint);
      GotoXY(10,  7); InputInt('',Y,0,maxint);
      GotoXY(10,  8); InputInt('',R,0,maxint);
      GotoXY(20, 10); InputInt('',Pezzi,0,maxint);
      GotoXY(20, 11); InputInt('',TemLav,0,maxint);
      GotoXY(20, 12); InputPrec('',CstUnt,0,Inf);
      Refresh(Att);
      GotoXY(20, 14); InputPrec('',tmp,0,100);
      PerUsc[1]:= tmp * 0.01;
      Refresh(Att);
      GotoXY(42, 14); InputStr('',NamUsc[1]);
      Refresh(Att);
      GotoXY(20, 15); InputPrec('',tmp,0,100-tmp);
      PerUsc[2]:= tmp * 0.01;
      Refresh(Att);
      GotoXY(42, 15); InputStr('',NamUsc[2]);
      Refresh(Att);
    end;
  end;
  procedure NuoveAttivita;
  var
    i: integer;
    x, y: integer;
    ch: char;
  begin
    i:= Modello.NumAtt+1;
    FillChar(Modello.Attiv[i], sizeof(Modello.Attiv[i]),0);
    repeat
      AlVideo(i);
      writeln;
      GetChar('Altra attivit… (S/N)? ', ch);
      if ch = 'N' then break;
      Modello.NumAtt:= i;
      EditAtt(i);
    until false;
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
  with Modello do begin
    NumAtt:= 0;
    ClrScr;
    writeln('Preparazione del modello');
    writeln;
    writeln('indica con nil le usite non definite');
    writeln('indica con * le attivita'' che vuoi eliminare');
    writeln;
    write('modello: '); readln(Nome);
    if Nome = '' then exit;
    if FileExist(Nome) then LeggiFile(Modello)
    else NumAtt:= 0;
    writeln;
    if NumAtt > 0 then begin
      GetChar('Modifiche? ', ch);
      if ch <> 'N' then begin
        i:= 1;
        while (i>=1) and (i<= NumAtt) do begin
          AlVideo(i);
          ch:= Modifiche;
          case ch of
            'I': begin dec(i); if i = 0 then i:= 1; end;
            'F': i:= 0;
            else inc(i);
          end;
        end;
      end;
    end;
    NuoveAttivita;
    ScriviFile(Modello);
    FlagModello:= true;
  end;
end;

procedure CheckModello(var Modello: TModello);
  procedure Disegna;
  var
    i, j: integer;
    xb, yb, xe, ye, fs, ys: integer;
    off: integer;
    xc, yc, x2c, y2c: integer;
    xmi,xma,ymi,yma: integer;
    ox,oy,sx,sy: PREC;
    tmp: string;
  begin
    GInit;
    GClear;
    ys:= succ(GetMaxY) div 10;
    xb:= 0; xe:= GetMaxX;
    yb:= ys; ye:= GetMaxY;
    SetLineStyle(SolidLn, 0, NormWidth);
    Rectangle(pred(xb), pred(yb), succ(xe), succ(ye));
    SetTextJustify(CenterText, CenterText);
    if ((ys-8) div 2) div 8 > 1 then fs:= 2 else fs:= 1;
    SetTextStyle(0, HorizDir, fs);
    OutTextXY(GetMaxX div 2, yb div 4, 'Grafo del Modello da Simulare');
    OutTextXY(GetMaxX div 2, yb div 4 * 3, 'Premere RETURN');
    SetTextStyle(0, HorizDir, 1);
    SetViewPort(xb,yb,xe,ye,true);
    xmi:= Modello.Attiv[1].X; xma:= xmi;
    ymi:= Modello.Attiv[1].Y; yma:= ymi;
    for i:= 1 to Modello.NumAtt do begin
      with Modello.Attiv[i] do begin
        if x < xmi then xmi:= x else if x > xma then xma:= x;
        if y < ymi then ymi:= y else if y > yma then yma:= y;
      end;
    end;
    dec(xmi, 20); dec(ymi, 20);
    inc(xma, 20); inc(yma, 20);
    ox:= xmi; oy:= ymi;
    sx:= (xma-xmi); if sx < 0.1 then sx:= 0.1; sx:= (GetMaxX-10)/sx;
    sy:= (yma-ymi); if sy < 0.1 then sy:= 0.1; sy:= (GetMaxY-ys-10)/sy;
    for i:= 1 to Modello.NumAtt do begin
      with Modello.Attiv[i] do begin
        case Kind of
          0: SetLineStyle(SolidLn, 0, NormWidth);
          1: SetLineStyle(SolidLn, 0, ThickWidth);
          2: SetLineStyle(DottedLn, 0, NormWidth);
        end;
        xc:= round(sx * (X - ox));
        yc:= round(sy * (Y - oy));
        Ellipse(xc, yc, 0, 360, R, R);
        SetLineStyle(SolidLn, 0, NormWidth);
        Str(i, tmp);
        OutTextXY(xc, yc, tmp);
        for j:= 1 to NumUsc do begin
          if AttUsc[j] <> 0 then begin
            x2c:= round(sx * (Modello.Attiv[AttUsc[j]].X - ox));
            y2c:= round(sy * (Modello.Attiv[AttUsc[j]].Y - oy));
            off:= Modello.Attiv[AttUsc[j]].R;
            if y2c > yc then off:= -off;
            line(xc+R, yc, x2c, y2c+off);
          end
        end;
      end;
    end;
    readln;
    GDone;
  end;
var
  i, l, k, x, y, z, xx, yy : integer;
  ch: char;
begin
  with Modello do begin
    ClrScr;
    if not FlagModello then begin
      writeln;
      writeln('Prepara prima il modello da descrivere!!');
      writeln;
      WaitReturn;
      exit;
    end;
    writeln('Grafo del modello simulatore: ', Nome);
    writeln;
    i:= 1;
    while (i <= NumAtt) do begin
      if Attiv[i].Kind = -1 then begin
        Attiv[i]:= Attiv[NumAtt];
        dec(NumAtt);
      end
      else inc(i);
    end;
    for i:= 1 to NumAtt do begin
      with Attiv[i] do begin
        write('Nodo #',i:2,' (x:',x:4,', y:',y:4,', r:',r:2,')  connessioni:');
        for z:= 1 to NumUsc do begin
          NamUsc[z]:= UCASE(NamUsc[z]);
          if (NamUsc[z]='NIL') or (NamUsc[z]='NULL') or (NamUsc[z] = '*') then begin
            NamUsc[z]:= '';
          end;
          AttUsc[z]:= FindAtt(Modello, NamUsc[z]);
          if (NamUsc[z] <> '') and (AttUsc[z] = 0) then begin
            writeln;
            writeln('Uscita ',NamUsc[z],' non trovata, impossibile proseguire!');
            writeln;
            WaitReturn;
            exit;
         end;
           if AttUsc[z] <> 0 then begin
            if z <> 1 then write(',');
            NamUsc[z]:= Attiv[AttUsc[z]].Nome;
            write(' #', AttUsc[z], ' ',NamUsc[z]);
          end;
        end;
        writeln;
        if (i mod 20) = 0 then WaitReturn;
      end;
    end;
    writeln;
    GetChar('Faccio un grafico [S)i, N)o]? ', ch);
    if ch = 'S' then Disegna;
    FlagCheckModello:= true;
  end;
end;

procedure Attivita(var Modello: TModello; Att: integer);
  procedure AttLibera(var Modello: TModello; Att: integer);
  begin
    with Modello, Attiv[Att] do begin
      if InCor < Pezzi then begin
        inc(TempAtte);
      end
      else begin
        dec(InCor, Pezzi);
        inc(PezziTot, Pezzi);
        occupata:= true;
        OutTime:= tempo + TemLav;
      end;
    end;
  end;
  procedure AttOccupata(var Modello: TModello; Att: integer);
  begin
    with Modello, Attiv[Att] do begin
      if tempo < OutTime then exit;
      inc(Attiv[AttUsc[1]].InCor, PezUsc[1]);
      inc(Attiv[AttUsc[2]].InCor, PezUsc[2]);
      inc(Attiv[AttUsc[1]].InTot, PezUsc[1]);
      inc(Attiv[AttUsc[2]].InTot, PezUsc[2]);
      occupata:= false;
    end;
  end;
begin
  with Modello, Attiv[Att] do begin
    if occupata then AttOccupata(Modello, Att)
    else AttLibera(Modello, Att);
  end;
end;

procedure Sorgente(var Modello: TModello; Att: integer);
begin
  with Modello, Attiv[Att] do begin
    if tempo < OutTime then exit;
    inc(PezziTot, Pezzi);
    inc(Attiv[AttUsc[1]].InCor, PezUsc[1]);
    inc(Attiv[AttUsc[2]].InCor, PezUsc[2]);
    inc(Attiv[AttUsc[1]].InTot, PezUsc[1]);
    inc(Attiv[AttUsc[2]].InTot, PezUsc[2]);
    OutTime:= tempo+TemLav;
  end;
end;

procedure Fittizio(var Modello: TModello; Att: integer);
begin
  with Modello, Attiv[Att] do begin
    PezUsc[1]:= round(InCor * PerUsc[1]);
    PezUsc[2]:= round(InCor * PerUsc[2]);
    InCor:= 0;
    inc(Attiv[AttUsc[1]].InCor, PezUsc[1]);
    inc(Attiv[AttUsc[1]].InTot, PezUsc[1]);
    inc(Attiv[AttUsc[2]].InCor, PezUsc[2]);
    inc(Attiv[AttUsc[2]].InTot, PezUsc[2]);
  end;
end;

procedure AggiornAttivita(var Modello: TModello; Att: integer);
begin
  with Modello, Attiv[Att] do begin
    PezUsc[1]:= round(Pezzi * PerUsc[1]);
    PezUsc[2]:= round(Pezzi * PerUsc[2]);
    case Kind of
      1: Sorgente(Modello, Att);
      2: Fittizio(Modello, Att);
      else Attivita(Modello, Att);
    end;
  end;
end;

procedure Risultati(var Modello: TModello);
var
  temp: PREC;
  i: integer;
begin
  with Modello do begin
    ClrScr;
    writeln('Tabella riassuntiva dei risultati della simlazione');
    writeln('--------------------------------------------------');
    writeln('tempo di simulazione: ', tempo:5, ' di ',TempoTot:5);
    writeln;
    writeln('  Descrizione    t.input   f.input  mx.input  t.produz  t.costi   attesa inp');
    writeln('---------------+---------+---------+---------+---------+---------+----------+');
    for i:= 1 to NumAtt do begin
      with Attiv[i] do begin
        temp:= CstUnt;
        writeln(Format(Nome, 15),' ', InTot:9,' ',InCor:9,' ',InMax:9,' ',
          PezziTot:9,' ', (PezziTot * temp):9:0,' ',TempAtte:10);
      end;
      if (i mod 20) = 0 then WaitReturn;
    end;
    writeln;
    if (i mod 20) <> 0 then WaitReturn;
  end;
end;

procedure Simulazione(var Modello: TModello);
  procedure InpAtt;
  var
    attStr: string;
    found: boolean;
    i, att, err: integer;
  begin
    writeln;
    attStr:= '';
    InputStr('Attivita'' da seguire (nome o numero): ', attStr);
    att:= FindAtt(Modello, attStr);
    if att <> 0 then Modello.AttFocused:= att;
  end;
  procedure AttivitaDaSeguire;
  var
    t: integer;
    temp: PREC;
  begin
    with Modello, Attiv[AttFocused] do begin
      ClrScr;
      writeln;
      writeln('Attivita'': ', Nome);
      writeln;
      writeln('tempo: ', tempo:5);
      writeln;
      writeln;
      writeln('   grandezza        attuale     totale   ');
      writeln('------------------ ---------- -----------');
      writeln('Pezzi ingresso   : ', InCor:10, ' (', InTot:10, ')');
      temp:= CstUnt;
      writeln('Produzione totale: ', PezziTot:10);
      writeln('Costo            : ', (PezziTot * temp):10:0);
      writeln('Tempo attesa     : ', TempAtte:10);
      writeln;
      t:= round(PezziTot * PerUsc[1]);
      writeln('Uscita verso #1  : ', Attiv[AttUsc[1]].InCor:10, ' (', t:10, ')');
      t:= round(PerUsc[2] * PezziTot);
      writeln('Uscita verso #2  : ', Attiv[AttUsc[2]].InCor:10, ' (', t:10, ')');
    end;
  end;
var
  Fast: boolean;
  CurAtt, i: integer;
  ch: char;
begin
  with Modello do begin
    ClrScr;
    if not FlagCheckModello then begin
      writeln;
      writeln('Bisogna controllare il modello prima di simularlo!!');
      writeln;
      WaitReturn;
      exit;
    end;
    ClrScr;
    writeln;
    writeln('Programma simulatore a blocchi');
    writeln;
    writeln('Modello simulato: ',Nome);
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
    InputLong('Tempo totale della simulazione: ', TempoTot,1,maxint);
    FIllChar(Attiv[0], sizeof(Attiv[0]), 0);
    for i:= 1 to NumAtt do begin
      with Attiv[i] do begin
        occupata:= false;
        InCor:=0;
        InTot:= 0;
        PezziTot:= 0;
        TempAtte:= 0;
        InMax:= 0;
        OutTime:= TemLav;
      end;
    end;
    AttFocused:= 1;
    InpAtt;
    ClrScr;
    writeln('Simulazione modello : ', Nome, ' in corso');
    writeln;
    Fast:= false;
    Tempo:= 1;
    while (Tempo <= TempoTot) do begin
      if keypressed then begin
        writeln;
        ch:= readkey; ch:= UpCase(ch);
        case ch of
          '1': Risultati(Modello);
          '2': InpAtt;
          'F': break;
          'V': Fast:= not Fast;
        end;
      end;
      for CurAtt:= 1 to NumAtt do begin
        AggiornAttivita(Modello, CurAtt);
        with Attiv[CurAtt] do begin
          if InCor > InMax then InMax:= InCor;
        end;
      end;
      AttivitaDaSeguire;
      writeln;
      write('1) Risultati parziali, 2) cambia attivita'', F)ine, altri tasti prosegue ');
      if not Fast then repeat until keypressed;
      inc(Tempo);
    end;
    writeln;
    writeln;
    WaitReturn;
  end;
end;

procedure DescrAtt(var Modello: TModello);
var
  i, k, x, y: integer;
begin
  with Modello do begin
    ClrScr;
    if not FlagModello then begin
      writeln;
      writeln('Prepara prima il modello da descrivere!!');
      writeln;
      WaitReturn;
      exit;
    end;
    writeln(' #    Descrizione    x   y  d.grp t.lavor cost/un % out Attiv. uscita');
    writeln('---+---------------+---+---+-----+-------+-------+-----+---------------');
    k:= 0;
    for i:= 1 to NumAtt do begin
      with Attiv[i] do begin
        writeln(i:3,' ',
           Format(Nome,15),' ',
           x:3,' ',
           y:3,' ',
           Pezzi:5, ' ',
           TemLav:7, ' ',
           CstUnt:7:2, ' ',
           PerUsc[1]*100:5:1, ' ',
           Format(NamUsc[1], 15));
        writeln('                                                  ',
           PerUsc[2]*100:5:1, ' ',
           Format(NamUsc[2], 15));
        writeln('---------------------------------------------------------------------------');
        if (i mod 7)= 0 then WaitReturn;
      end;
    end;
    if (i mod 7) <> 0 then WaitReturn;
  end;
end;

procedure MenuModSim;
var ch: char;
begin
  Model.FlagModello:= false;
  Model.FlagCheckModello:= false;
  repeat
    ClrScr;
    Writeln('  Teoria dei Sistemi  Ver. 1.à - Modelli Simulatori Discreti - ');
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Finisce programma                 |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Preparazione modello simulatore   |                                      |');
    writeln('| 2. Controllo validit… del modello    |                                      |');
    writeln('| 3. Simulazione                       |                                      |');
    writeln('| 4. Risultati della simulazione       |                                      |');
    writeln('| 5. Descrizione attivit…              |                                      |');
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
    writeln('|                                      |                                      |');
    writeln('|                                      |                                      |');
    writeln('+-----------------------------------------------------------------------------+');
    writeln('| Quale e'' la tua scelta?                                                     |');
    write  ('+-----------------------------------------------------------------------------+');
    GotoXY(27, WhereY - 1);
    ch:= readkey; if ch = #0 then readkey;
    ch:= UpCase(ch);
    case ch of
      '1': EditModello(Model);
      '2': CheckModello(Model);
      '3': Simulazione(Model);
      '4': Risultati(Model);
      '5': DescrAtt(Model);
    end;
  until ch = '0';
  ClrScr;
end;

{$IFNDEF UNIT}
begin
  MenuModSim;
{$ENDIF}
end.
