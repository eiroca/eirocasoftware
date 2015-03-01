{$I switches.inc}
{ UNDEF UNIT}

{$IFDEF UNIT}
unit ExModSim;

interface

procedure MenuExtModSim;

implementation
{$ELSE}

{$ENDIF}

uses Dos, DataMngr, MathTool, Crt, HPGraf, Graph, Objects;
{$V-}

const
  IDModello = 'ExtendedModel';
  ModSimDataFile = 'ModSimDataFile';
  NullStr = '*';

  KndNone = 0;
  KndDeleted = -1;
  KndSorg = 1;
  KndLavo = 2;

  MaxUsc  = 5;
type

  TNome = string[15];

  PAttivita = ^TAttivita;
  TAttivita = object
    Kind    : integer;
    ID      : integer;
    Nome    : TNome;
    X, Y, R : integer;
    NumUsc  : integer;
    AttUsc  : array[1..MaxUsc] of PAttivita;
    NamUsc  : array[1..MaxUsc] of TNome;
    constructor Init(Knd, PID: integer);
    constructor Get(var f: text; Knd, PID: integer);
    procedure   Put(var f: text); virtual;
    procedure   Reset; virtual;
    procedure   Show(row: boolean); virtual;
    procedure   Edit; virtual;
    procedure   Action(tempo: longint); virtual;
    destructor  Done; virtual;
  end;

  PLavorazione = ^TLavorazione;
  TLavorazione = object(TAttivita)
    TemLav  : integer;
    CstUnt  : PREC;
    Pezzi   : integer;
    PerUsc  : array[1..MaxUsc] of PREC;
   private
    OutTime : longint;
    PezziTot: longint;
    InCor   : integer;
    InTot   : longint;
    InMax   : integer;
    TempAtte: longint;
    occupata: boolean;
   public
    constructor Init(Knd, PID: integer);
    constructor Get(var f: text; Knd, PID: integer);
    procedure   Put(var f: text); virtual;
    procedure   Reset; virtual;
    procedure   Show(row: boolean); virtual;
    procedure   Edit; virtual;
    procedure   Action(tempo: longint); virtual;
    destructor  Done; virtual;
  end;

  PSorgente = ^TSorgente;
  TSorgente = object(TAttivita)
    TemLav  : integer;
    Pezzi   : integer;
    PerUsc  : array[1..MaxUsc] of PREC;
   private
    PezziTot: longint;
    OutTime : longint;
   public
    constructor Init(Knd, PID: integer);
    constructor Get(var f: text; Knd, PID: integer);
    procedure   Put(var f: text); virtual;
    procedure   Reset; virtual;
    procedure   Show(row: boolean); virtual;
    procedure   Edit; virtual;
    function    HowMany(tempo: longint): integer; virtual;
    function    Generate(tempo: longint): boolean; virtual;
    procedure   Action(tempo: longint); virtual;
    destructor  Done; virtual;
  end;

  PModello = ^TModello;
  TModello = object
    Nome: PathStr;
    FlagModello: boolean;
    FlagCheckModello: boolean;
    NumAtt: integer;
    Attiv : array[1..119] of PAttivita;
    Tempo: longint;
    TempoTot: longint;
    AttFocused: PAttivita;
    constructor Init;
    constructor Load(fn: PathStr);
    procedure   Save;
    procedure   Edit;
    procedure   Check;
    procedure   Risultati;
    procedure   Simulazione;
    function    FindAtt(Name: TNome): PAttivita;
    destructor  Done; virtual;
  end;

var
  Model: TModello;

constructor TAttivita.Init;
begin
  Kind:= Knd;
  ID  := PID;
  Nome:= '';
  X:= 0;
  Y:= 0;
  R:= 0;
end;

constructor TAttivita.Get;
begin
  Kind:= Knd;
  ID:= PID;
  readln(f, Nome);
  readln(f, X);
  readln(f, Y);
  readln(f, R);
end;

procedure   TAttivita.Put;
begin
  writeln(f, Nome);
  writeln(f, X);
  writeln(f, Y);
  writeln(f, R);
end;

procedure TAttivita.Reset;
begin
end;

procedure TAttivita.Show(row: boolean);
begin
  writeln(Nome);
end;

procedure TAttivita.Edit;
begin
end;

procedure   TAttivita.Action;
begin
end;

destructor  TAttivita.Done;
begin
end;

constructor TSorgente.Init;
begin
  inherited Init(Knd, PID);
  NumUsc:= 0;
  TemLav:= 0;
  Pezzi:= 0;
  Reset;
end;

procedure TSorgente.Reset;
begin
  OutTime:= 0;
  PezziTot:= 0;
end;

constructor TSorgente.Get;
var i: integer;
begin
  inherited Get(f, Knd, PID);
  readln(f, NumUsc);
  readln(f, TemLav);
  readln(f, Pezzi);
  for i:= 1 to NumUsc do begin
    readln(f, PerUsc[i]);
    readln(f, NamUsc[i]);
  end;
end;

procedure   TSorgente.Put;
var i: integer;
begin
  inherited Put(f);
  writeln(f, NumUsc);
  writeln(f, TemLav);
  writeln(f, Pezzi);
  for i:= 1 to NumUsc do begin
    writeln(f, PerUsc[i]);
    writeln(f, NamUsc[i]);
  end;
end;

procedure TSorgente.Show(row: boolean);
var i: integer;
begin
  if not row then begin
    GotoXY( 1,  4); write('Attivita'' #',ID:3,': ', Nome); ClrEOL;
    GotoXY( 1,  5); write('Tipo: Sorgente deterministica'); ClrEOL;
    GotoXY( 1,  6); write('coord.x: ',X); ClrEOL;
    GotoXY( 1,  7); write('coord.y: ',Y); ClrEOL;
    GotoXY( 1,  8); write('raggio : ',R); ClrEOL;
    GotoXY( 1, 10); write('unit… generate      : ',Pezzi); ClrEOL;
    GotoXY( 1, 11); write('tempo di generazione: ',TemLav); ClrEOL;
    GotoXY( 1, 12); write('Numero delle uscite : ', NumUsc); ClrEOL;
    for i:= 1 to NumUsc do begin
      GotoXY(1, 12+i); write(i:2,' ', PerUsc[i]*100:5:1,'% verso ',NamUsc[i]); ClrEOL;
    end;
  end
  else begin
    writeln(Format(Nome, 15),'                               ', PezziTot:9);
  end;
end;

procedure TSorgente.Edit;
var
  i: integer;
  tmp: PREC;
begin
  GotoXY( 1,  4); write('Attivita'' #',ID:3,': '); InputStr('',Nome); Show(false);
  GotoXY( 1,  5); write('Tipo: Sorgente deterministica'); Show(false);
  GotoXY( 1,  6); write('coord.x: '); InputInt('',X,0,maxint); Show(false);
  GotoXY( 1,  7); write('coord.y: '); InputInt('',Y,0,maxint); Show(false);
  GotoXY( 1,  8); write('raggio : '); InputInt('',R,0,maxint); Show(false);
  GotoXY( 1, 10); write('unit… generate      : '); InputInt('',Pezzi,0,maxint); Show(false);
  GotoXY( 1, 11); write('tempo di generazione: '); InputInt('',TemLav,0,maxint); Show(false);
  GotoXY( 1, 12); write('Numero delle uscite : '); InputInt('',NumUsc,0,MaxUsc); Show(false);
  for i:= 1 to NumUsc do begin
    tmp:= round(100/NumUsc);
    GotoXY(1, 12+i); write(i:2,' '); InputPrec('',tmp,0,100);
    PerUsc[i]:= tmp * 0.01; Show(false);
    GotoXY(9, 12+i); write('% verso '); InputStr('', NamUsc[i]); Show(false);
  end;
  writeln;
end;

function TSorgente.HowMany;
begin
  HowMany:= Pezzi;
end;

function TSorgente.Generate;
begin
  Generate:= (tempo >= OutTime);
end;

procedure TSorgente.Action;
var
  i: integer;
  Pez: integer;
begin
  if Generate(tempo) then begin
    Pez:= HowMany(tempo);
    inc(PezziTot, Pez);
    for i:= 1 to NumUsc do begin
      inc(PLavorazione(AttUsc[i])^.InCor, round(Pez * PerUsc[i]));
      inc(PLavorazione(AttUsc[i])^.InTot, round(Pez * PerUsc[i]));
    end;
    OutTime:= tempo+TemLav;
  end;
end;

destructor  TSorgente.Done;
begin
end;

constructor TLavorazione.Init;
begin
  inherited Init(Knd, PID);
  NumUsc:= 0;
  TemLav:= 0;
  CstUnt:= 0;
  Pezzi:= 0;
  Reset;
end;

procedure TLavorazione.Reset;
begin
  PezziTot:= 0;
  InCor:= 0;
  InTot:= 0;
  InMax:= 0;
  TempAtte:= 0;
  OutTime:= 0;
  occupata:= false;
end;

constructor TLavorazione.Get;
var i: integer;
begin
  inherited Get(f, Knd, PID);
  readln(f, NumUsc);
  readln(f, TemLav);
  readln(f, CstUnt);
  readln(f, Pezzi);
  for i:= 1 to NumUsc do begin
    readln(f, PerUsc[i]);
    readln(f, NamUsc[i]);
  end;
end;

procedure   TLavorazione.Put;
var i: integer;
begin
  inherited Put(f);
  writeln(f, NumUsc);
  writeln(f, TemLav);
  writeln(f, CstUnt);
  writeln(f, Pezzi);
  for i:= 1 to NumUsc do begin
    writeln(f, PerUsc[i]);
    writeln(f, NamUsc[i]);
  end;
end;

procedure TLavorazione.Show(row: boolean);
var i: integer;
begin
  if not row then begin
    GotoXY( 1,  4); write('Attivita'' #',ID:3,': ', Nome); ClrEOL;
    GotoXY( 1,  5); write('Tipo: Lavorazione deterministica'); ClrEOL;
    GotoXY( 1,  6); write('coord.x: ',X); ClrEOL;
    GotoXY( 1,  7); write('coord.y: ',Y); ClrEOL;
    GotoXY( 1,  8); write('raggio : ',R); ClrEOL;
    GotoXY( 1, 10); write('dim. gruppo lavoraz.: ',Pezzi); ClrEOL;
    GotoXY( 1, 11); write('tempo di generazione: ',TemLav); ClrEOL;
    GotoXY( 1, 12); write('Costo unitario      : ',CstUnt:7:2); ClrEOL;
    GotoXY( 1, 13); write('Numero delle uscite : ', NumUsc); ClrEOL;
    for i:= 1 to NumUsc do begin
      GotoXY(1, 13+i); write(i:2,' ', PerUsc[i]*100:5:1,'% verso ',NamUsc[i]); ClrEOL;
    end;
  end
  else begin
    writeln(Format(Nome, 15),' ', InTot:9,' ',InCor:9,' ',InMax:9,' ',
          PezziTot:9,' ', (PezziTot * CstUnt):9:0,' ',TempAtte:10);
  end;
end;

procedure TLavorazione.Edit;
var
  i: integer;
  tmp: PREC;
begin
  GotoXY( 1,  4); write('Attivita'' #',ID:3,': '); InputStr('',Nome); Show(false);
  GotoXY( 1,  5); write('Tipo: Lavorazione deterministica'); Show(false);
  GotoXY( 1,  6); write('coord.x: '); InputInt('',X,0,maxint); Show(false);
  GotoXY( 1,  7); write('coord.y: '); InputInt('',Y,0,maxint); Show(false);
  GotoXY( 1,  8); write('raggio : '); InputInt('',R,0,maxint); Show(false);
  GotoXY( 1, 10); write('dim. gruppo lavoraz.: '); InputInt('',Pezzi,0,maxint); Show(false);
  GotoXY( 1, 11); write('tempo di generazione: '); InputInt('',TemLav,0,maxint); Show(false);
  GotoXY( 1, 12); write('Costo unitario      : '); InputPrec('',CstUnt, 0, inf); Show(false);
  GotoXY( 1, 13); write('Numero delle uscite : '); InputInt('',NumUsc,0,MaxUsc); Show(false);
  for i:= 1 to NumUsc do begin
    tmp:= round(100/NumUsc);
    GotoXY(1, 13+i); write(i:2,' '); InputPrec('',tmp,0,100);
    PerUsc[i]:= tmp * 0.01; Show(false);
    GotoXY(9, 13+i); write('% verso '); InputStr('', NamUsc[i]); Show(false);
  end;
  writeln;
end;

procedure   TLavorazione.Action;
  procedure DoLibera;
  begin
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
  procedure DoOccupata;
  var i: integer;
  begin
    if tempo < OutTime then exit;
    for i:= 1 to NumUsc do begin
      inc(PLavorazione(AttUsc[i])^.InCor, round(Pezzi * PerUsc[i]));
      inc(PLavorazione(AttUsc[i])^.InTot, round(Pezzi * PerUsc[i]));
    end;
    occupata:= false;
  end;
begin
  if occupata then DoOccupata else DoLibera;
  if InCor > InMax then InMax:= InCor;
end;

destructor  TLavorazione.Done;
begin
end;

constructor TModello.Init;
begin
  Nome:= '';
  NumAtt:= 0;
  FlagModello:= false;
  FlagCheckModello:= false;
  Tempo:= 0;
  TempoTot:= 0;
  AttFocused:= nil;
end;

destructor TModello.Done;
var i: integer;
begin
  if NumAtt <> 0 then begin
    for i:= 1 to NumAtt do begin
      Dispose(Attiv[i], Done);
    end;
  end;
  NumAtt:= 0;
  FlagModello:= false;
end;

constructor TModello.Load;
var
  ID: string;
  i, Knd: word;
  fil: text;
begin
  Nome:= fn;
  Assign(fil, Nome);
  Reset(fil);
  readln(fil, ID);
  if ID <> IDModello then begin
    Writeln('file non valido.');
    WaitReturn;
    exit;
  end;
  readln(fil, NumAtt);
  for i:= 1 to NumAtt do begin
    readln(fil, Knd);
    case Knd of
      KndSorg: Attiv[i]:= New(PSorgente, Get(fil, Knd, i));
      KndLavo: Attiv[i]:= New(PLavorazione, Get(fil, Knd, i));
      else Attiv[i]:= New(PAttivita, Get(fil, Knd, i));
    end;
  end;
  Close(Fil);
end;

procedure TModello.Save;
var
  i, Knd: word;
  fil: text;
begin
  Assign(fil, Nome);
  Rewrite(fil);
  writeln(fil, IDModello);
  writeln(fil, NumAtt);
  for i:= 1 to NumAtt do begin
    writeln(fil, Attiv[i]^.Kind);
    Attiv[i]^.Put(fil);
  end;
  Close(Fil);
end;

function TModello.FindAtt;
var
  found: boolean;
  i: integer;
  whr: PAttivita;
begin
  found:= false;
  whr:= nil;
  Name:= UCASE(Name);
  for i:= 1 to NumAtt do begin
    if UCASE(Attiv[i]^.Nome) = Name then begin
    whr:= Attiv[i];
    found:= true;
    break;
    end;
  end;
  if not found then begin
    i:= IVal(Name);
    if (i >= 1) and (i <= NumAtt) and (Attiv[i]^.Nome <> '') then whr:= Attiv[i];
  end;
  FindAtt:= whr;
end;

procedure TModello.Edit;
var
  ch: char;
  i: integer;
  procedure AlVideo(Att: integer);
  begin
    ClrScr;
    writeln('Descrizione Attivita'' modello simulatore');
    writeln('Modello: ', Nome);
    Attiv[Att]^.Show(false);
  end;
  procedure NuoveAttivita;
  var
    ch: char;
  begin
    ClrScr;
    repeat
      GetChar('Altra attivit… (S/N)? ', ch);
      ch:= UpCase(ch);
      if ch = 'S' then begin
        inc(NumAtt);
        GetChar('Tipo attivit…: S)orgente, N)ormale: ', ch);
        ch:= UpCase(ch);
        case ch of
          'S': Attiv[NumAtt]:= New(PSorgente, Init(KndSorg, NumAtt));
          else Attiv[NumAtt]:= New(PLavorazione, Init(KndLavo, NumAtt));
        end;
        AlVideo(NumAtt);
        Attiv[NumAtt]^.Edit;
      end
      else break;
    until false;
  end;
  function Modifiche: char;
  var
    ch: char;
  begin
    GotoXY(1,24);
    GetChar('Cosa vuoi fare [M)odifica, C)ancella, I)ndietro, A)vanti, F)ine]? ', ch);
    Modifiche:= ch;
  end;
begin
  ClrScr;
  if NumAtt > 0 then begin
    i:= 1;
    while (i>=1) and (i<= NumAtt) do begin
      AlVideo(i);
      ch:= Modifiche;
      case ch of
        'M': Attiv[i]^.Edit;
        'C': begin
          GotoXY(1,23); GetChar('Sei sicuro (S/N)? ', ch);
          if Upcase(ch)='S' then begin
            Attiv[i]^.Nome:= '';
            Attiv[i]^.Kind:= KndDeleted;
          end;
        end;
        'I': begin dec(i); if i = 0 then i:= 1; end;
        'F': i:= 0;
        else inc(i);
      end;
    end;
  end;
  NuoveAttivita;
  Save;
  FlagModello:= true;
end;

procedure TModello.Check;
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
    xmi:= Attiv[1]^.X; xma:= xmi;
    ymi:= Attiv[1]^.Y; yma:= ymi;
    for i:= 1 to NumAtt do begin
      with Attiv[i]^ do begin
        if x < xmi then xmi:= x else if x > xma then xma:= x;
        if y < ymi then ymi:= y else if y > yma then yma:= y;
      end;
    end;
    dec(xmi, 20); dec(ymi, 20);
    inc(xma, 20); inc(yma, 20);
    ox:= xmi; oy:= ymi;
    sx:= (xma-xmi); if sx < 0.1 then sx:= 0.1; sx:= (GetMaxX-10)/sx;
    sy:= (yma-ymi); if sy < 0.1 then sy:= 0.1; sy:= (GetMaxY-ys-10)/sy;
    for i:= 1 to NumAtt do begin
      with Attiv[i]^ do begin
        case Kind of
          kndLavo: SetLineStyle(SolidLn, 0, NormWidth);
          kndSorg: SetLineStyle(SolidLn, 0, ThickWidth);
          else     SetLineStyle(DottedLn, 0, NormWidth);
        end;
        xc:= round(sx * (X - ox));
        yc:= round(sy * (Y - oy));
        Ellipse(xc, yc, 0, 360, R, R);
        SetLineStyle(SolidLn, 0, NormWidth);
        Str(i, tmp);
        OutTextXY(xc, yc, tmp);
        for j:= 1 to NumUsc do begin
          if AttUsc[j] <> nil then begin
            x2c:= round(sx * (AttUsc[j]^.X - ox));
            y2c:= round(sy * (AttUsc[j]^.Y - oy));
            off:= AttUsc[j]^.R;
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
  i, j, l, k, x, y, z, xx, yy : integer;
  ch: char;
begin
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
    if Attiv[i]^.Kind = kndDeleted then begin
      for j:= i+1 to NumAtt do begin
        Attiv[j-1]:= Attiv[j];
      end;
      dec(NumAtt);
    end
    else inc(i);
  end;
  for i:= 1 to NumAtt do begin
    with Attiv[i]^ do begin
      write(Nome,' (x:',x:4,', y:',y:4,', r:',r:2,') -> ');
      for z:= 1 to NumUsc do begin
        NamUsc[z]:= UCASE(NamUsc[z]);
        if (NamUsc[z]='NIL') or (NamUsc[z]='NULL') or (NamUsc[z] = '*') then begin
          NamUsc[z]:= '';
        end;
        AttUsc[z]:= FindAtt(NamUsc[z]);
        if (NamUsc[z] <> '') and (AttUsc[z] = nil) then begin
          writeln;
          writeln('Uscita ',NamUsc[z],' non trovata, impossibile proseguire!');
          writeln;
          WaitReturn;
          exit;
        end;
        if AttUsc[z] <> nil then begin
          if z <> 1 then write(',');
          NamUsc[z]:= AttUsc[z]^.Nome;
          write(' ', NamUsc[z]);
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

procedure TModello.Risultati;
var
  temp: PREC;
  i: integer;
begin
  ClrScr;
  writeln('Tabella riassuntiva dei risultati della simlazione');
  writeln('--------------------------------------------------');
  writeln('tempo di simulazione: ', tempo:5, ' di ',TempoTot:5);
  writeln;
  writeln('  Descrizione    t.input   f.input  mx.input  t.produz  t.costi   attesa inp');
  writeln('---------------+---------+---------+---------+---------+---------+----------+');
  for i:= 1 to NumAtt do begin
    Attiv[i]^.Show(true);
    if (i mod 20) = 0 then WaitReturn;
  end;
  writeln;
  if (i mod 20) <> 0 then WaitReturn;
end;

procedure TModello.Simulazione;
  procedure InpAtt;
  var
    attStr: TNome;
    found: boolean;
    i, err: integer;
    att: PAttivita;
  begin
    writeln;
    attStr:= '';
    InputStr('Attivita'' da seguire (nome o numero): ', attStr);
    att:= FindAtt(attStr);
    if att <> nil then AttFocused:= att;
  end;
  procedure AttivitaDaSeguire;
  var
    i, t: integer;
    temp: PREC;
  begin
    with AttFocused^ do begin
      ClrScr;
      writeln;
      writeln('Attivita'': ', Nome);
      writeln;
      writeln('tempo: ', tempo:10);
      writeln;
      writeln;
      writeln('   grandezza        attuale      totale   ');
      writeln('------------------ ---------- -------------');
      case Kind of
        kndLavo: begin
          with PLavorazione(AttFocused)^ do begin
            writeln('Pezzi ingresso   : ', InCor:10, ' (', InTot:10, ')');
            writeln('Produzione totale: ', PezziTot:10);
            writeln('Costo            : ', (PezziTot * CstUnt):10:0);
            writeln('Tempo attesa     : ', TempAtte:10);
            for i:= 1 to NumUsc do begin
              writeln('Uscita verso #',i:3,': ', PLavorazione(AttUsc[i])^.InCor:10, ' (', round(Pezzi*PerUsc[i]):10, ')');
            end;
          end;
        end;
        kndSorg: begin
          with PSorgente(AttFocused)^ do begin
            writeln('Tempo x generare : ', (OutTime-tempo):10,' (',TemLav:10,')');
            writeln('Produzione       : ', Pezzi:10, ' (', PezziTot:10,')');
            for i:= 1 to NumUsc do begin
              writeln('Uscita verso #',i:3,': ', PLavorazione(AttUsc[i])^.InCor:10, ' (', round(Pezzi*PerUsc[i]):10, ')');
            end;
          end;
        end;
      end;
    end;
  end;
var
  Fast: boolean;
  CurAtt, i: integer;
  ch: char;
begin
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
  for i:= 1 to NumAtt do begin
    Attiv[i]^.Reset;
  end;
  AttFocused:= nil;
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
        '1': Risultati;
        '2': InpAtt;
        'F': break;
        'V': Fast:= not Fast;
      end;
    end;
    for CurAtt:= 1 to NumAtt do Attiv[CurAtt]^.Action(tempo);
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

procedure ImportModel(var Model: TModello);
var
  fil: text;
  tmp: string;
  i, l: integer;
begin
  ClrScr;
  tmp:= '';
  Model.Init;
  Model.FlagModello:= false;
  Model.FlagCheckModello:= false;
  InputStr('Nome modello da importare: ', tmp);
  if not FileExist(tmp) then exit;
  Assign(fil, tmp);
  Reset(fil);
  readln(fil, tmp);
  if tmp <> ModSimDataFile then begin
    writeln;
    writeln('Spiacente, ma il file non contiene dati validi.');
    writeln;
    WaitReturn;
    exit;
  end;
  tmp:='output.dat';
  InputStr('Nuovo nome modello: ', tmp);
  with Model do begin
    Nome:= tmp;
    NumAtt:= 0;
    for i:= 1 to 119 do begin
      Readln(Fil, tmp);
      if tmp <> NullStr then begin
        inc(NumAtt);
        case tmp[1] of
          '>': begin
            Attiv[NumAtt]:= New(PSorgente, Init(kndSorg, NumAtt));
            delete(tmp,1,1);
          end;
          '0': begin
            writeln('Waring! attivit… fittizia non convertita!');
            WaitReturn;
          end;
          else begin
            Attiv[NumAtt]:= New(PLavorazione, Init(kndLavo, NumAtt));
          end;
        end;
        with Attiv[NumAtt]^ do begin
          Nome:= tmp;
          R:= 20;
          X:= ((i-1) div 7 + 1) * 30;
          Y:= ((i-1) mod 7 + 1) * 30;
          NumUsc:=0;
          case Kind of
            kndSorg: with PSorgente(Attiv[NumAtt])^ do begin
              Readln(Fil, tmp); Pezzi:= IVal(tmp);
              Readln(Fil, tmp); TemLav:= IVal(tmp);
              Readln(Fil, tmp); PerUsc[1]:= IVal(tmp) * 0.01;
              Readln(Fil, tmp); PerUsc[2]:= IVal(tmp) * 0.01;
              Readln(Fil, tmp);
              Readln(Fil, tmp);
              if (UCASE(tmp) <> NullStr) and (UCASE(tmp) <> 'NIL') then begin
                NamUsc[1]:= tmp;
                inc(NumUsc);
              end;
              Readln(Fil, tmp);
              if (UCASE(tmp) <> NullStr) and (UCASE(tmp) <> 'NIL') then begin
                NamUsc[2]:= tmp;
                inc(NumUsc);
              end;
            end;
            kndLavo: with PLavorazione(Attiv[NumAtt])^ do begin
              Readln(Fil, tmp); Pezzi:= IVal(tmp);
              Readln(Fil, tmp); TemLav:= IVal(tmp);
              Readln(Fil, tmp); PerUsc[1]:= IVal(tmp) * 0.01;
              Readln(Fil, tmp); PerUsc[2]:= IVal(tmp) * 0.01;
              Readln(Fil, tmp); CstUnt:= RVal(tmp);
              Readln(Fil, tmp);
              if (UCASE(tmp) <> NullStr) and (UCASE(tmp) <> 'NIL') then begin
                NamUsc[1]:= tmp;
                inc(NumUsc);
              end;
              Readln(Fil, tmp);
              if (UCASE(tmp) <> NullStr) and (UCASE(tmp) <> 'NIL') then begin
                NamUsc[2]:= tmp;
                inc(NumUsc);
              end;
            end;
            else begin
              for l:= 1 to 7 do Readln(Fil, tmp);
            end;
          end;
        end;
      end
      else begin
        for l:= 1 to 7 do Readln(Fil, tmp);
      end;
    end;
    FlagModello:= true;
  end;
  Close(Fil);
end;

procedure MenuExtModSim;
var
  ch: char;
  Nome: PathStr;
begin
  Model.Init;
  Model.FlagModello:= false;
  Model.FlagCheckModello:= false;
  repeat
    ClrScr;
    Writeln('  Teoria dei Sistemi  Ver. 1.à - Modelli Simulatori Discreti - ');
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Finisce programma                 |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Preparazione modello simulatore   |                                      |');
    writeln('| 2. Edit delle attivit…               |                                      |');
    writeln('| 3. Controllo validit… del modello    |                                      |');
    writeln('| 4. Simulazione                       |                                      |');
    writeln('| 5. Risultati della simulazione       |                                      |');
    writeln('|                                      |                                      |');
    writeln('| I. Importa modello ModSImDataFile    |                                      |');
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
      '1': begin
        ClrScr;
        writeln('Preparazione del modello');
        writeln;
        write('modello: '); readln(Nome);
        if (Nome <> '') then begin
          Model.Done;
          if FileExist(Nome) then begin
            Model.Load(Nome);
            Model.FlagModello:= true;
            Model.FlagCheckModello:= false;
          end
          else begin
            Model.Init;
            Model.Nome:= Nome;
            Model.FlagModello:= false;
            Model.FlagCheckModello:= false;
          end;
        end;
      end;
      '2': Model.Edit;
      '3': Model.Check;
      '4': Model.Simulazione;
      '5': Model.Risultati;
      'I': begin
        Model.Done;
        ImportModel(Model);
      end;
    end;
  until ch = '0';
end;

{$IFNDEF UNIT}
begin
  MenuExtModSim;
{$ENDIF}
end.
