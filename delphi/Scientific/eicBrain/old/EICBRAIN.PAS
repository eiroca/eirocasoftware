program EicBrain;
{$I switches.inc}
{$UNDEF UNIT}
{$M 4000,0,0}

uses DataMngr, Crt, Dos;

procedure Menu;
var ch : char;
begin
  repeat
    ClrScr;
    Writeln('         EIC BRAIN   Ver. 1.à    - CopyRight 1994 by Enrico Croce - ');
    writeln('+-----------------------------------------------------------------------------+');
    writeln('| 0. Finisce programma                                                        |');
    writeln('|                                                                             |');
    writeln('|                                                                             |');
    writeln('|                                                                             |');
    writeln('|                                                                             |');
    writeln('|                                                                             |');
    writeln('|                                                                             |');
    writeln('|                                                                             |');
    writeln('|                                                                             |');
    writeln('|                                                                             |');
    writeln('|                                                                             |');
    writeln('|                                                                             |');
    writeln('|                                                                             |');
    writeln('|                                                                             |');
    writeln('|                                                                             |');
    writeln('+-----------------------------------------------------------------------------+');
    writeln('| Quale e'' la tua scelta?                                                     |');
    write  ('+-----------------------------------------------------------------------------+');
    GotoXY(27, WhereY - 1);
    ch:= readkey; if ch = #0 then readkey;
    ch:= UpCase(ch);
    case ch of
      '1': Run('MenuStat.exe', '');
      '2': Run('MenuSist.exe', '');
      '3': Run('MenuRiOp.exe', '');
      '4': Run('MenuEcon.exe', '');
      '4': Run('MenuFina.exe', '');
    end;
  until ch = '0';
  ClrScr;
end;

begin
  Menu;
end.
