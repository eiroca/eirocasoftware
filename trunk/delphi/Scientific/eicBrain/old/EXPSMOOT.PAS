unit ExpSmoot;

interface

uses MathTool, DataMngr;

const
  NumData = 12;

type
  PExpSmooth = ^TExpSmooth;
  TExpSmooth = object
    NomSer: string;
    Data: array[1..NumData] of PREC;
    SerVal: boolean;
    qt, x, Y, j: PREC;
    t, Alpha: PREC;
    m1, m2, m3, mt,
    mt1, mt2, mt3,
    e, e1, xt1,
    xtp, vap, d: PREC;
    constructor Init;
    procedure   CalcInit;
    procedure   CalcNext(R: integer);
    procedure   ShowDati;
    procedure   ShowResult;
    procedure   CalcAlpha;
    procedure   StartSerie(var Spread: TSpread);
    procedure   CicloDin;
    procedure   AlphaFisso;
    destructor  Done; virtual;
  end;

procedure MenuExpSmooth(var Spread: TSpread);

implementation

uses MathStat, Crt;

(*
  Previsione serie temporale con Exponential smoothing
  X^(t)  = ащX(t) + (1-а)щX(t-1)       con
  X^(t)  = valore della serie storica all'istante t
  X(t)   = valore medio della serie storica all'istante t
  X(t-1) = valore medio della serie storica all'istante t-1
  а      = coefficiente di smussamento (compreso tra 0 e 1)
*)

constructor TExpSmooth.Init;
begin
  CalcInit;
end;

destructor TExpSmooth.Done;
begin
end;

procedure TExpSmooth.CalcInit;
begin
  M1:= Data[1];
  M2:= M1;
  M3:= M1;
  XTP:= M1;
  VAP:= 0;
  D:= 0;
  SerVal:= false;
end;

procedure TExpSmooth.CalcNext(R: integer);
begin
  x:= Data[R];
  MT1:= Alpha*X   + (1-Alpha)*M1;
  MT2:= Alpha*MT1 + (1-Alpha)*M2;
  MT3:= Alpha*MT2 + (1-Alpha)*M3;
  MT:= 3*(MT1-MT2) + MT3;
  T:= Alpha/(2*sqr(1-Alpha))*((6-5*Alpha)*MT1-2*(5-4*Alpha)*MT2+(4-3*Alpha)*MT3);
  QT:= sqr(Alpha)/(2*sqr(1-Alpha))*(MT1-2*MT2+MT3)*2;
  T:= int(T*100)/100;
  qt:= int(qt*100)/100;
  e:=xtp-x;
  xt1:= mt+t+qt;

  e1:= sqr(e);
  d:= d + e1;
  vap:= vap + x;
  m1:= mt1;
  m2:= mt2;
  m3:= mt3;
  xtp:= xt1;
end;

procedure TExpSmooth.ShowDati;
var i: integer;
begin
  for i:= 1 to NumData do begin
    writeln('Dato ',i:2, Data[i]:15:5);
  end;
end;

procedure TExpSmooth.ShowResult;
var i: integer;
begin
  CalcInit;
  for i:= 1 to NumData do begin
    CalcNext(i);
  end;
  writeln('Nome della serie ',NomSer);
  ShowDati;
  (* Totale delle vendite дV[] *)
  writeln('Tot=',vap:10:0);
  (* Media delle vendite *)
  writeln('Media=',(vap/NumData):10:2);
  (* Valore ottimo di а *)
  writeln('alpha а ottimo = ', Alpha:4:2);
  (* scarto quadratico medio della serie *)
  writeln('delta/min=',(d/NumData):10:2);
  (* media storica del periodo in esame *)
  writeln('mt=',mt:10:0);
  (* medie smussate, 1 semplice, 2 doppia, 3 tripla *)
  writeln('mt1=',mt1:10:0,' mt2=',mt2:10:0,' mt3=',mt3:10:0);
  (* valore trend e scartico quadratico medio *)
  writeln('trend/t=',t:10:2, '  qt=',qt:10:2);
  writeln;
  (* previsione prossimo valore *)
  writeln('previsione successivo =',xtp:10:2);
  WaitReturn;
end;

procedure TExpSmooth.CalcAlpha;
label 500, 600;
var i: integer;
begin
  Clrscr;
  Writeln('Attendere calcolo а ottimo');
  Y:= 999999999.0;
  Alpha:= 0;
  j:= 0;
  repeat
    Alpha:= Alpha + 0.01;
    CalcInit;
    for i:= 1 to NumData do CalcNext(i);
    if Alpha >= 0.99 then break;
    j:= int(d/NumData);
    if j> y then break;
    y:= j;
  until false;
  Alpha:= Alpha-0.01;
  ClrScr;
  ShowResult;
end;

procedure TExpSmooth.StartSerie(var Spread: TSpread);
var
  ch: char;
  i: integer;
begin
  SerVal:= true;
  ClrScr;
  NomSer:= '';
  InputStr('Nome della serie = ',NomSer);
  writeln;
  writeln('Inserimento dei dati');
  writeln;
  write('Immissione diretta o Memorizzate (I/M)? ');
  repeat
    ch:= Upcase(readkey); if ch =#0 then readkey;
  until ch in ['I','M'];
  writeln(ch);
  writeln;
  if ch = 'I' then begin
    for i:= 1 to NumData do begin
      write('Dati Mese ',i:2,' = '); InputPrec('',Data[i],-inf,inf);
    end;
  end
  else begin
    repeat
      Spread.GetSerie(ch);
      if ch = #0 then begin
        SerVal:= false;
        exit;
      end;
      if Spread.Cols[ch]^.Count < NumData then begin
        ch:= #0;
        writeln('Serie troppo breve!');
      end;
    until ch <> #0;
    for i:= 1 to NumData do begin
      Data[i]:= Spread.Cols[ch]^.At(i)^;
    end;
  end;
  CalcAlpha;
end;

procedure TExpSmooth.CicloDin;
var i: integer;
begin
  Clrscr;
  if SerVal = false then begin
    writeln('Immettere prima una serie iniziale');
    exit;
  end;
  for i:= 2 to NumData do begin
    Data[i-1]:= Data[i]
  end;
  writeln('digitare dato vendita mese precedente:');
  writeln;
  write('Nome della serie ',NomSer,', valore serie = ');
  Data[NumData]:= xtp; (* previsione *)
  InputPrec('',Data[NumData],-inf,inf);
  ShowDati;
  CalcAlpha;
end;

procedure TExpSmooth.AlphaFisso;
begin
  ClrScr;
  if SerVal = false then begin
    writeln('Immettere prima una serie iniziale');
    exit;
  end;
  InputPrec('Valore di а = ',Alpha,0,1);
  ShowResult;
end;

procedure MenuExpSmooth(var Spread: TSpread);
var
  ch : char;
  ES: TExpSmooth;
begin
  ES.Init;
  repeat
    normal;
    ClrScr;
    Write('  Statistical Package Ver. 1.а - CopyRight 1994 by Enrico Croce - ');
    {$IFDEF USE87}
      writeln(' 80x87 ON');
    {$ELSE}
      writeln(' 80x87 OFF');
    {$ENDIF}
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Ritorna al menu principale        |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Immissione/analisi serie          |                                      |');
    writeln('| 2. Ciclo dinamico                    |                                      |');
    writeln('| 3. Calcolo con alpha fisso           |                                      |');
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
    writeln('| L. Caricamento dati da disco         | S. Salvataggio dati sul disco        |');
    writeln('| Z. Inserimento serie di dati         | X. Modifica Serie di Dati            |');
    writeln('|                                      |                                      |');
    writeln('+-----------------------------------------------------------------------------+');
    writeln('| Quale e'' la tua scelta?                                                     |');
    write  ('+-----------------------------------------------------------------------------+');
    GotoXY(27, WhereY - 1);
    ch:= readkey; if ch = #0 then readkey;
    ch:= UpCase(ch);
    case ch of
      '1': ES.StartSerie(Spread);
      '2': ES.CicloDin;
      '3': ES.AlphaFisso;
      'L': Spread.LoadData;
      'S': Spread.SaveData;
      'Z': Spread.GetData;
      'X': Spread.Show(ord('A'), ord('Z'), 0, 0);
    end;
  until ch = '0';
  ES.Done;
end;

end.
