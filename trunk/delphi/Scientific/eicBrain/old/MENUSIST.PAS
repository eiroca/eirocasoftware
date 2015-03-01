{$I switches.inc}
{$UNDEF UNIT}

{$IFDEF UNIT}
unit SistMenu;

interface

procedure MenuSistPack;

implementation
{$ENDIF}

uses HpModSim, ModSim, ExModSim, Crt;

procedure MenuSistPack;
var ch : char;
begin
  repeat
    ClrScr;
    Writeln('  Teoria dei Sistemi  Ver. 1.à - CopyRight 1994 by Enrico Croce - ');
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Finisce programma                 |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 1. Sim. Modelli discreti certi (old) |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 2. Sim. Modelli Discreti certi (new) |                                      |');
    writeln('|                                      |                                      |');
    writeln('| 3. Sim. Modelli Discreti             |                                      |');
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
      '1': MenuHpModSim;
      '2': MenuModSim;
      '3': MenuExtModSim;
    end;
  until ch = '0';
  ClrScr;
end;

{$IFNDEF UNIT}
begin
  MenuSistPack;
{$ENDIF}
end.
