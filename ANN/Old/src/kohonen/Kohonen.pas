(* Reti neuronali di Kohonen *)
(* Tratto da MC107 pag.290 e MC108 pag.287 *)
unit Kohonen;

interface

procedure Main;

implementation

const
  delta = 0.0001;
  gamma = 10;

type
  TPesi = array[0..15,0..15] of array[0..15] of real;
  TIn = array[0..511,0..15] of real;
  Tfr = array[0..15,0..15] of real;
  TBias = array[0..15,0..15] of real;

  TMappa = object
    Pesi: ^TPesi;
    inp: ^TIn;
    Fr : ^TFr;
    Bias: ^TBias;
    inpattern, outpesi: text;
    maxitera: integer;
    maxriga, maxcolonna, maxnpeso: integer;
    maxpattern, maxattributi: integer;
    BestRiga, BestColonna: integer;
    BestR, BestC: integer;
    amp: real;
    amp1, amp2: integer;
    periodo1, periodo2: integer;
    xmin, xmax, ymin, ymax: integer;
    tipo: char;
    constructor Init;
    procedure   InitPesi;
    function    Distanza(pattern, riga, colonna: integer): real;
    procedure   BestM(pattern: integer);
    procedure   Aggiorna(pattern: integer; Alfa: real);
    procedure   InpDati;
    procedure   ApriPattern;
    procedure   LeggiPattern;
    function    Scegli: integer;
    function    NewAlfa(iterazione: integer): real;
    function    CalcIntorno(iterazione: integer): integer;
    procedure   CalcEstremi(xintorno: integer);
    procedure   AggF;
    procedure   AggBias;
    procedure   BestMBias(pattern: integer);
    procedure   ApriOutPesi;
    procedure   SalvaPesi;
    procedure   Impara;
    procedure   Impara2;
    destructor  Done; virtual;
  end;

function Open(var fil: text; Name: string): boolean;
begin
  assign(fil, Name);
  {$I-} Reset(fil); {$I+}
  Open:= IOResult=0;
end;

procedure preschermo;
begin
  writeln;
  writeln('0%                50%                 100%');
  write('|------------------+-------------------|'#13);
end;

function AggVisore(visore, percento, k: integer): integer;
begin
  if (k<40) then begin
    if (visore mod percento) = 0 then begin
      write(#219);
      inc(k);
    end;
  end;
  AggVisore:= k;
end;

procedure TMappa.InpDati;
begin
  write('Massimo numero di iterazioni: '); readln(MaxItera);
  writeln('Dimensioni della matrice dei neuroni');
  write('Numero di righe  : '); readln(MaxRiga);
  write('Numero di colonne: '); readln(MaxColonna);
  write('Ampiezza Alfa max (<=1):'); readln(amp);
  write('Ampiezza intorno min: '); readln(amp1);
  write('Ampiezza intorno max: '); readln(amp2);
  write('Periodo Alfa: '); readln(periodo1);
  write('Periodo beta: '); readln(periodo2);
  write('Pattern uniformi (S/N)? '); readln(tipo); tipo:= Upcase(tipo);
end;

procedure TMappa.ApriPattern;
var
  test: boolean;
  InFile: string;
begin
  test:= true;
  while test do begin
    write('Nome del file che contiene i pattern di ingresso: '); readln(InFile);
    if Open(inpattern, InFile) = false then begin
      writeln('Non posso aprire questo file');
    end
    else begin
      test:= false;
    end;
  end;
  readln(inpattern, maxpattern);
  readln(inpattern, maxattributi);
end;

procedure TMappa.LeggiPattern;
var xriga, xcolonna: integer;
begin
  for xriga:= 0 to maxpattern-1 do begin
    for xcolonna:= 0 to maxattributi-1 do begin
      readln(inpattern,inp^[xriga,xcolonna]);
    end;
  end;
  close(inpattern);
end;

(* inizializzazione dei pesi*)
procedure TMappa.InitPesi;
var xriga, xcolonna, xpeso: integer;
begin
  for xriga:= 0 to maxriga-1 do begin
    for xcolonna:= 0 to maxcolonna-1 do begin
      for xpeso:= 0 to maxnpeso-1 do begin
        pesi^[xriga,xcolonna][xpeso]:= random(100) / 1000;
      end;
    end;
  end;
end;

function TMappa.Scegli: integer;
(* scelta casuale dei pattern dell'insieme utilizzato per l'apprendimento,
per un funzionamento ottimale della rete la distribuzione del pattern di
ingresso deve avere una distribuzione uniforme *)
begin
  scegli:= random(maxpattern);
end;

(* calcolo del parametro Alfa *)
function TMappa.NewAlfa(iterazione: integer): real;
begin
  NewAlfa:= amp*exp(-iterazione/periodo1);
end;

(* calcolo dell'ampiezza dell'intorno *)
function TMappa.CalcIntorno(iterazione: integer): integer;
begin
  CalcIntorno:= round((amp1+amp2*exp(-iterazione/periodo2)));
end;

(* definizione degli estremi dell'intorno *)
procedure TMappa.CalcEstremi(xintorno: integer);
begin
  xmin:= BestRiga-xintorno;
  if (xmin<0) then xmin:= 0;
  xmax:= BestRiga+xintorno+1;
  if (xmax>maxriga) then xmax:= maxriga;
  ymin:= BestColonna-xintorno;
  if (ymin<0) then ymin:= 0;
  ymax:= BestColonna+xintorno+1;
  if (ymax>maxcolonna) then ymax:= maxcolonna;
end;

(* distanza peseudo-euclidea tra due vettori (per motivi di efficienza non
viene calcolata la radice) *)
function TMappa.distanza(pattern, riga, colonna: integer): real;
var
  xpeso: integer;
  dist: real;
begin
  dist:= 0;
  for xpeso:=0 to maxnpeso-1 do begin
    dist:= dist+sqr(inp^[pattern,xpeso]-pesi^[riga,colonna,xpeso]);
  end;
  distanza:= dist;
end;

(* calcolo del best match *)
procedure TMappa.BestM(pattern: integer);
var
  xriga, xcolonna: integer;
  dist, dmin: real;
begin
  dmin:= 1e38;
  for xriga:= 0 to maxriga-1 do begin
    for xcolonna := 0 to maxcolonna-1 do begin
      dist:=  distanza(pattern, xriga, xcolonna);
      if (dist <dmin) then begin
        dmin:= dist;
        BestRiga:= xriga;
        BestColonna:= xcolonna;
      end;
    end;
  end;
end;

(* Aggiornamento dei pesi *)
procedure TMappa.Aggiorna(pattern: integer; Alfa: real);
var
  xnpeso, xriga, xcolonna: integer;
  w: ^real;
begin
  for xriga:= xmin to xmax-1 do begin
    for xcolonna:= ymin to ymax-1 do begin
      for xnpeso:= 0 to maxnpeso-1 do begin
        w:= @pesi^[xriga,xcolonna][xnpeso];
        w^:= w^+ Alfa*(inp^[pattern, xnpeso] - w^);
      end;
    end;
  end;
end;

procedure TMappa.AggF;
var
  xriga, xcolonna: integer;
  f: ^real;
  z: real;
begin
  for xriga:= 0 to maxriga-1 do begin
    for xcolonna:= 0 to maxcolonna-1 do begin
      if (BestRiga=xriga) and (BestColonna=Xcolonna) then z:=1 else z:= 0;
      f:= @Fr^[xriga,xcolonna];
      f^:= f^ + delta*(z - f^);
    end;
  end;
end;

procedure TMappa.AggBias;
var
  xriga, xcolonna: integer;
begin
  for xriga:= 0 to maxriga-1 do begin
    for xcolonna:= 0 to maxcolonna-1 do begin
      Bias^[xriga,xcolonna]:= gamma*(1/(maxriga*maxcolonna)-Fr^[xriga,xcolonna]);
    end;
  end;
end;

(* calcolo del best match con bias *)
procedure TMappa.BestMBias(pattern: integer);
var
  xriga, xcolonna: integer;
  dist, dmin: real;
begin
  dmin:= 1e38;
  for xriga:= 0 to maxriga-1 do begin
    for xcolonna := 0 to maxcolonna-1 do begin
      dist:= distanza(pattern, xriga, xcolonna) - Bias^[xriga,xcolonna];
      if (dist <dmin) then begin
        dmin:= dist;
        BestR:= xriga;
        BestC:= xcolonna;
      end;
    end;
  end;
end;

procedure TMappa.ApriOutPesi;
var
  test: boolean;
  ch: char;
  OutFile: string;
begin
  test:= true;
  while test do begin
    write('Nome del file su cui salvare i pesi: '); readln(OutFile);
    if Open(outpesi, OutFile) = false then begin
      test:= false;
    end
    else begin
      write('Il file gia'' esiste, vuoi sovrascriverlo (s/n)? '); readln(ch);
      test:= UpCase(ch)<>'S';
    end;
  end;
end;

procedure TMappa.SalvaPesi;
var
  xriga, xcolonna, xnpeso: integer;
begin
  Rewrite(outpesi);
  writeln(outpesi, maxriga);
  writeln(outpesi, maxcolonna);
  writeln(outpesi, maxnpeso);
  for xriga:= 0 to maxriga-1 do begin
    for xcolonna:= 0 to maxcolonna-1 do begin
      for xnpeso:= 0 to maxnpeso-1 do begin
        write(outpesi, pesi^[xriga, xcolonna, xnpeso],' ');
      end;
      writeln(outpesi);
    end;
    writeln(outpesi);
  end;
  close(outpesi);
end;

procedure TMappa.Impara;
var
  k,t: integer;
  percento : integer;
  pattern: integer;
  Alfa: real;
begin
  k:= 0;
  percento:= maxitera div 40;
  for t:= 1 to maxitera do begin
    pattern:= scegli;
    Alfa:= NewAlfa(t);
    BestM(pattern);
    CalcEstremi(CalcIntorno(t));
    Aggiorna(pattern, Alfa);
    k:= AggVisore(t, percento, k);
  end;
end;

procedure TMappa.Impara2;
var
  k,t: integer;
  percento : integer;
  pattern: integer;
  Alfa: real;
begin
  k:= 0;
  percento:= maxitera div 40;
  for t:= 1 to maxitera do begin
    pattern:= scegli;
    Alfa:= NewAlfa(t);
    AggF;
    AggBias;
    BestM(pattern); BestMBias(pattern);
    if (BestR=BestRiga) and (BestC=BestColonna) then begin
      CalcEstremi(CalcIntorno(t));
      Aggiorna(pattern, Alfa);
    end;
    k:= AggVisore(t, percento, k);
  end;
end;

constructor TMappa.Init;
begin
  new(Pesi);
  new(inp);
  new(Fr);
  New(Bias);
end;

destructor TMappa.DOne;
begin
  dispose(inp);
  dispose(Pesi);
  dispose(Fr);
  dispose(Bias);
end;

procedure Main;
var
  SOM: TMappa;
begin
  with SOM do begin
    Init;
    randomize;
    InpDati;
    ApriPattern;
    maxnpeso:= maxattributi;
    LeggiPattern;
    ApriOutPesi;
    InitPesi;
    preschermo;
    if tipo ='S' then Impara else Impara2;
    SalvaPesi;
    Done;
  end;
end;

end.
