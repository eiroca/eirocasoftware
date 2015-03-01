{$I switches.inc}
{$UNDEF UNIT}

{$IFDEF UNIT}
unit MenuFina;

interface

uses MathStat, DataMngr, MathTool, Finanza, Crt;

procedure MenuFinanza(var Spread: TSpread);

implementation

{$ELSE}

uses MathStat, DataMngr, MathTool, Finanza, Crt;

{$ENDIF}

procedure CalcCashFlow(var Spread: TSpread);
const MaxPmt = 100;
var
  Pmt: array[1..MaxPmt] of Payment;
  cf, r, t: PREC;
  fine, i, nc, n: integer;
  pm, tm, ch: char;
begin
  ClrScr;
  fine:= 1;
  Writeln('Calcolo di un cash flow');
  nc:= Spread.CountSerie;
  if (nc < 2) then begin
    writeln;
    writeln('Spiacente! devi immettere almeno 2 colonne di dati');
    writeln('col il formato  pagamento tempo');
    writeln;
    WaitReturn;
    exit;
  end;
  repeat
    writeln;
    write('Colonna dei pagamenti. ');
    Spread.GetSerie(pm);
    if pm = #0 then exit;
    writeln;
    write('Colonna degli istanti di tempo. ');
    Spread.GetSerie(tm);
    if tm = #0 then exit;
    n:= Spread.Cols[pm]^.Count;
    if n <> Spread.Cols[tm]^.Count then begin
      writeln('Spiacente la numerosit… dei dati deve essere uguale!');
      WaitReturn;
      exit;
    end;
    for i:= 1 to n do begin
      Pmt[i].V:= Spread.Cols[pm]^.At(i)^;
      Pmt[i].T:= Spread.Cols[tm]^.At(i)^;
    end;
    writeln;
    r:= 5; t:= 0;
    repeat
      InputPrec('Tasso di interesse del periodo   (%) : ', r, 0, 10000); r:= r * 0.01;
      InputPrec('Periodo in cui valutare il cash flow : ', t, -inf, inf);
      ch:= 'C';
      GetChar('Composizione interessi S)emplici, C)omposti, altro per composti nel continuo? ', ch);
      case UpCase(ch) of
        'S': cf:= CashFlow(Pmt, n, intsem, r, t);
        'C': cf:= CashFlow(Pmt, n, intcom, r, t);
        else cf:= CashFlow(Pmt, n, intcon, r, t);
      end;
      writeln;
      writeln('Valore cash flow = ', cf:15:2);
      writeln;
      GetSiNo('Vuoi proseguire con altri tassi o tempi di attualizzazione? ', fine);
    until fine=0;
    writeln;
    GetSiNo('Vuoi proseguire con altri flussi? ', fine);
  until fine=0;
end;

procedure MenuFinanza(var Spread: TSpread);
var ch : char;
begin
  repeat
    ClrScr;
    writeln('       Calcoli Finanziari    Ver. 1.à  - CopyRight 1994 by Enrico Croce - ');
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Torna al menu principale          |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Valore di un cash flow            |                                      |');
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
      '1': CalcCashFlow(Spread);
      'L': Spread.LoadData;
      'S': Spread.SaveData;
      'Z': Spread.GetData;
      'X': Spread.Show(ord('A'), ord('Z'), 0, 0);
    end;
  until ch = '0';
  ClrScr;
end;

{$IFNDEF UNIT}
var
  Spread: PSpread;
begin
  New(Spread, Init);
  MenuFinanza(Spread^);
{$ENDIF}
end.
