{$I switches.inc}
{ UNDEF UNIT}

{$IFDEF UNIT}
unit MenuGraf;

interface

uses DataMngr;

procedure MenuGrafici(var Spread: TSpread);

implementation

uses Crt, Charting, MathTool, MathStat;

{$ELSE}

uses MathTool, MathStat, Crt, DataMngr, Charting;

{$ENDIF}

(* Cartesiano *)
procedure CartChart(var Spread: TSpread);
var
  Chart: TCartChart;
  YesFlag: integer;
begin
  ClrScr;
  Writeln('Grafico cartesiano');
  writeln;
  with Chart do begin
    Init;
    Title1:= 'Grafico Cartesiano';
    Title2:= '';
    TitleX:= '';
    TitleY:= '';
    Options:= JoinDot + BigDot + ShowXAx + ShowYAx + ShwGrdX+ ShwGrdY + ShowAve + multiple;
    Run(@Spread);
  end;
end;

(* Scattered (X,Y) *)
procedure ScatChart(var Spread: TSpread);
var
  Chart: TScatChart;
begin
  ClrScr;
  Writeln('Grafico coppie (X,Y)');
  writeln;
  with Chart do begin
    Init;
    Title1:= 'Grafico cartesiano (X,Y)';
    Title2:= '';
    TitleX:= '';
    TitleY:= '';
    Options:= BigDot + ShowXAx + ShowYAx + ShwGrdX+ ShwGrdY + ShowAve + multiple;
    Run(@Spread);
  end;
end;

procedure MenuGrafici(var Spread: TSpread);
var ch : char;
begin
  repeat
    ClrScr;
    Writeln('       Mattomatical Package Ver. 1.à - CopyRight 1994 by Enrico Croce -        ');
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Torna al menu principale          |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Grafico cartesiano lineare        |                                      |');
    writeln('| 2. Grafico cartesiano (X,Y)          |                                      |');
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
      '1': CartChart(Spread);
      '2': ScatChart(Spread);
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
  MenuGrafici(Spread^);
{$ENDIF}
end.
