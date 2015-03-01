(* Programmazione Lineare - definizione di un programma lineare *)
unit PLProg;

{$I switches.inc}
{$V-}

interface

uses MsgBox, Drivers, Objects, MathTool, Matrix, DataMngr, Dos, Crt;

const
  MaxCol = 50;
  MaxRow = 50;
  MaxNamLen = 30;

  KINDMIN =   1;
  KINDMAX =  -1;
  KINDLE  =   1;
  KINDGE  =   2;
  KINDNRS =   3;
  KINDBOL =   4;
  KINDINT = 512;

type

  PErrMngr = ^TErrMngr;
  TErrMngr = object(TObject)
    constructor Init;
    procedure   Error(ErrNo: integer); virtual;
    procedure   Warning(Msg: string); virtual;
    procedure   Reset; virtual;
    destructor  Done; virtual;
  end;

  PTVErrMngr = ^TTVErrMngr;
  TTVErrMngr = object(TErrMngr)
    Err: boolean;
    procedure   Error(ErrNo: integer); virtual;
    procedure   Warning(Msg: string); virtual;
    procedure   Reset; virtual;
  end;

  Nome= String[MaxNamLen];

  PRow = ^TRow;
  TRow = array[0..MaxRow] of PREC;

  PIRow = ^TIRow;
  TIRow = array[0..MaxCol] of integer;

  PCol = ^TCol;
  TCol = array[0..MaxCol] of PREC;
  
  PPL = ^TPL;
  TPL = object(TObject)
    Err: PErrMngr;
    PLPathName: PathStr;
    (* riga 0 : obiettivo
       colonna 0: temini noti
       riga i : coefficienti tecnologici vincolo i
    *)
    NumVar, NumVin: integer;
    A: TSMatrix;
    (* Nomi variabili *)
    (* 0: Nome della funzione da ottimizzare *)
    (* i: nome della variabile i *)
    VarNam: array[0..MaxCol] of Nome;
    (* Tipi variabili *)
    (* 0: tipo ottimizzare   : 1 minimo, -1 massimo *)
    (* i: tipo di variabile i: 
        = 0  x ò 0,
        = 1  x ó 0, 
        = 2  x non ristretta in segno
        = 3  x booleana (0, 1)
        Flag :
          bit 9: 1 se varibile intera, 0 altrimenti
    *)
    VarKin: array[0..MaxCol] of integer;
    (* 0: tipo ottimizzazione ó minimo ò  massimo *)
    (* i: tipo di vincolo  ó, ò, = *)
    VinKin: array[1..MaxRow] of char;
    Title: string;                   (* Nome esteso programma lineare *)
    VarLenMax: integer;
    constructor Init(ErrMng: PErrMngr);
    destructor  Done; virtual;
    procedure   Load(const FName: PathStr); virtual;
    procedure   ReLoad; virtual;
    procedure   Store(const FName: PathStr); virtual;
    procedure   Duale(var DPL: TPl); virtual;
    procedure   Normalize; virtual;
    procedure   Print; virtual;
    procedure   SetErrMngr(NewErr: PErrMngr);
  end;

const
  ErrUnknow = 0;
  ErrOutMem = 1;
  ErrOutVar = 2;
  ErrOutVin = 3;
  ErrVinIna = 4;
  ErrOptErr = 5;
  ErrStr : array[0..5] of string = (
   (* 000 *)  'Errore sconosciuto.',
   (* 001 *)  'Errore di allocazione memoria generica.',
   (* 002 *)  'Troppe variabili!',
   (* 003 *)  'Troppi vincoli!',
   (* 004 *)  'Vincoli inammissibili!!!',
   (* 005 *)  'Non riesco ad ottimizzare!!'
  );
   

implementation

constructor TPL.Init(ErrMng: PErrMngr);
begin
  if ErrMng = nil then Err:= New(PErrMngr, Init) else Err:= ErrMng;
  if MaxRow * MaxCol * Sizeof(PREC) + 20*1024 > MemAvail then Err^.Error(ErrOutMem)
  else begin
    A.Init(0,MaxRow, MaxCol);
    PLPathName:= '';
  end;
end;

destructor TPL.Done;
begin
  A.Done;
  if Err <> nil then Err^.Done;
end;

procedure TPL.Load(const FName: PathStr);
var
  ch: char;
  fIN: text;
  tmp: PREC;
  l, k: integer;
  tmps: string;
  tmpl: longint;
  procedure StPoint;
  begin
    ch:= #0;
    repeat
      if eof(fIn) then exit;
      Read(fIn, ch);
    until (ch=':');
  end;
  procedure StLoad(var strg: Nome);
  var tmp: string;
  begin
    tmp:= '';
    repeat
      if eof(fIn) then exit;
      Readln(fIn, tmp);
      Trim(tmp);
    until tmp <> '';
    strg:= tmp;
  end;
begin
  PLPathName:= FSearch(FName, GetEnv('APPEND')+';'+GetEnv('PATH'));
  Assign(fIn, PLPathName);
  Reset(fIn);
  (* Leggi il titolo del programma lineare *)
  repeat Readln(fIn, Title); until Title <> '';
  Trim(Title);
  (* cerca il primo : *)
  StPoint;
  Readln(fIN, NumVar);
  if NumVar > MaxCol then begin
    Err^.Error(ErrOutVar);
    exit;
  end;
  VarLenMax:= 0;
  for k:= 1 to NumVar do begin
    StLoad(VarNam[k]);
    l:= length(VarNam[k]);
    if l > VarLenMax then VarLenMax:= l;
    VarKin[k]:= 0; (* supponi tutte variabili >=0 eventualmente ridef. dopo *)
  end;
  (* Legge il nome della funzione *)
  StPoint; repeat Readln(fIn, VarNam[0]); until VarNam[0] <> '';
  Trim(VarNam[0]);
  (* Legge il tipo di ottimizzazione MIN/MAX *)
  StPoint; repeat Readln(fIn, tmps); until tmps <> '';
  Trim(tmps);
  if length(tmps) > 3 then tmps[0]:= #3;
  for k:= 1 to length(tmps) do tmps[k]:= UpCase(tmps[k]);
  if (tmps = 'MIN') then VarKin[0]:= 1 else VarKin[0]:= -1;
  StPoint; Readln(fIn, tmp);
  A.At(0,0)^:= -tmp;
  StPoint;
  for k:= 1 to NumVar do begin
    Read(fIn, A.At(0,k)^);
  end;
  StPoint; Readln(fIN, NumVin);
  if NumVin > MaxRow then begin
    Err^.Error(ErrOutVin);
    exit;
  end;
  for k:= 1 to NumVin do begin
    for l:= 1 to NumVar do begin
      Read(fIN, A.At(k, l)^);
    end;
    repeat Read(fIN, ch) until ch <>' ';
    if (ch = '<') or (ch='≤')  then ch:= '≤'
    else if (ch = '>') or (ch='ò')  then ch:= 'ò'
    else if ch = '=' then ch:= '='
    else begin
      Err^.Error(ErrVinIna);
      exit;
    end;
    VinKin[k]:= ch;
    repeat Read(fIn, ch) until (ch =' ');
    Readln(fIN, A.At(k, 0)^);
  end;
  StPoint;
  if not eof(fIn) then begin
    while not(eof(fIn)) do begin
      Readln(fIn, l, tmps);
      Trim(tmps);
      if (l < 1) or (l>NumVar) then begin
        tmpl:= l;
        FormatStr(tmps, 'Warning: Variabile %d non ammessa saltata!', tmpl);
        Err^.Warning(tmps);
      end
      else begin
        case upcase(tmps[1]) of
          '+', '≥', '>': VarKin[l]:= 0;
          '-', '≤', '<': VarKin[l]:= 1;
          '?', '*', '=', 'N', '.':  VarKin[l]:= 2;
          '0', '1', 'B': VarKin[l]:= 3;
        end;
        if (upcase(tmps[length(tmps)]) ='I') or (upcase(tmps[length(tmps)]) ='D') then 
          VarKin[l]:= VarKin[l] or $100;
      end;
    end;
  end;
  close(fIN);
end;

procedure TPL.ReLoad;
begin
  Load(PlPathName);
end;

procedure TPL.Store(const FName: PathStr);
var
  ch: char;
  FOut: text;
  tmp: PREC;
  l, k: integer;
begin
  Assign(FOut, FName);
  ReWrite(FOut);
  Writeln(FOut, Title); 
  writeln(FOut,'Numero di Variabili: ', NumVar);
  for k:= 1 to NumVar do begin
    writeln(FOut,VarNam[k]);
  end;
  (* Scrive il nome della funzione *)
  Writeln(FOut,'Nome della funzione: ', VarNam[0]);
  (* Scrive il tipo di ottimizzazione MIN/MAX *)
  Write(FOut,'Ricerco il: ');
  case VarKin[0] of
    1: writeln(FOut,'MIN');
    else writeln(FOut,'MAX');
  end;
  writeln(FOut,'Temine costante obiettivo: ', DynaOut(A.At(0,0)^));
  write  (FOut,'Costi: ');
  for k:= 1 to NumVar do begin
    Write(FOut, DynaOut(A.At(0,k)^),' ');
  end;
  writeln(FOut);
  Writeln(FOut,'Numero di vincoli: ', NumVin);
  for k:= 1 to NumVin do begin
    for l:= 1 to NumVar do begin
      write(FOut, DynaOut(A.At(k, l)^),' ');
    end;
    write(FOut, VInKin[k],' ');
    writeln(FOut, DynaOut(A.At(k, 0)^));
  end;
  writeln(fOut, 'Dominio variabili:');
  for l:= 1 to NumVar do begin
    write(FOut,l,' ');
    case (VarKin[l] and $7F) of
      0: write(FOut,'+');
      1: write(FOut,'-');
      2: write(FOut,'?');
      3: write(FOut,'B');
    end;
    if (VarKin[l] and $100) = $100 then writeln(FOut, 'I')
    else writeln(FOut,'R');
  end;
  close(FOut);
end;

procedure TPL.Duale(var DPL: TPL);
var 
  r,c: integer;
  l: longint;
begin
  DPL.NumVar:= NumVin;
  DPL.NumVin:= NumVar;
  DPL.Title:= Title;
  DPL.VarNam[0]:= VarNam[0];
  for l:= 1 to DPL.NumVar do begin
    FormatStr(DPL.VarNam[l],  'ã%04d', l);
  end;
  (* Traspone coef tecnologici, costi, risorse *)
  for r:= 0 to NumVin do begin
    for c:= 0 to NumVar do begin
      DPL.A.At(c, r)^:= A.At(r, c)^;
    end;
  end;
  if VarKin[0] = 1 then begin (* Primario e' un min *)
    DPL.VarKin[0]:= -1;
    for c:= 1 to NumVar do begin
      case VarKin[c] of
        0: (* x ≥ 0 *) DPL.VinKin[c]:= '≤';
        1: (* x ≤ 0 *) DPL.VinKin[c]:= '≥';
        2: (* x ≠ R *) DPL.VinKin[c]:= '=';
        else DPL.VinKin[c]:='?';
      end;
    end;
    for c:= 1 to NumVin do begin
      case VinKin[c] of
        '≥': DPL.VarKin[c]:= 0; (* x ≥ 0 *)
        '≤': DPL.VarKin[c]:= 1; (* x ≤ 0 *)
        '=': DPL.VarKin[c]:= 2; (* x ≠ R *)
      end;
    end;
  end
  else begin (* Primario e' un max *)
    DPL.VarKin[0]:= 1;
    for c:= 1 to NumVar do begin
      case VarKin[c] of
        0: (* x ≥ 0 *) DPL.VinKin[c]:= '≥';
        1: (* x ≤ 0 *) DPL.VinKin[c]:= '≤';
        2: (* x ≠ R *) DPL.VinKin[c]:= '=';
        else DPL.VinKin[c]:='?';
      end;
    end;
    for c:= 1 to NumVin do begin
      case VinKin[c] of
        '≤': DPL.VarKin[c]:= 0; (* x ≥ 0 *)
        '≥': DPL.VarKin[c]:= 1; (* x ≤ 0 *)
        '=': DPL.VarKin[c]:= 2; (* x ≠ R *)
      end;
    end;
  end;
end;

procedure TPL.Normalize;
begin
  Abstract;
end;

procedure TPL.Print;
var k, j: integer;
begin
  GotoXY(40 - length(Title) div 2, WhereY); writeln(Title);
  writeln('------------------------------------------------------------------------');
  writeln;
  writeln(NumVar,' variabili');
  for k:= 1 to NumVar do begin
    writeln(VarNam[k]);
  end;
  Readln;
  write('funzione: ',VarNam[0],' di cui si ricerca il ');
  case VarKin[0] of 
     1: writeln('minimo.');
    -1: writeln('massimo.');
    else writeln(' <non lo so>!');
  end;
  writeln;
  writeln('Termine costante: ', A.At(0,0)^:10:3);
  write('Costi: ');
  for k:= 1 to NumVar do write(A.At(0, k)^:10:3);
  Readln;
  writeln(NumVin,' vicoli');
  for k:= 1 to NumVin do begin
    for j:= 1 to NumVar do begin
      write(A.At(k, j)^:10:3,' ');
    end;
    writeln(VinKin[k],' ',A.At(k, 0)^:10:3);
  end;
  Readln;
end;

procedure TPL.SetErrMngr(NewErr: PErrMngr);
begin
  if Err <> nil then Dispose(Err, Done);
  if NewErr = nil then Err:= New(PErrMngr, Init) else Err:= NewErr;
  Err^.Reset;
end;

constructor TErrMngr.Init;
begin
  Reset;
end;

procedure TErrMngr.Error(ErrNo: integer); 
var
  tmp: string;
  tmpl: array[0..1] of longint;
begin
  ClrScr;
  writeln('Errore verificatori in un''istanza di TPL.');
  writeln;
  tmpl[0]:= ErrNo;
  tmpl[1]:= longint(@ErrStr[ErrNo]);
  FormatStr(tmp,'Errore #%4x: %40s', tmpl);
  writeln(tmp);
  writeln;
  Halt(1);
end;

procedure TErrMngr.Warning(Msg: string); 
begin
  writeln;
  writeln(Msg);
end;

procedure TErrMngr.Reset;
begin
end;

destructor TErrMngr.Done;
begin
  inherited Done;
end;

procedure TTVErrMngr.Error(ErrNo: integer); 
var
  tmp: string;
  tmpl: array[0..1] of longint;
begin
  tmpl[0]:= ErrNo;
  tmpl[1]:= longint(@ErrStr[ErrNo]);
  FormatStr(tmp,'Errore #%4x:'#13'%s', tmpl);
  Err:= true;
  MessageBox(tmp, nil, mfError or mfOkButton);
end;

procedure TTVErrMngr.Warning(Msg: string); 
begin
  MessageBox(Msg, nil, mfWarning or mfOkButton);
end;

procedure TTVErrMngr.Reset;
begin
  Err:= false;
end;

end.
