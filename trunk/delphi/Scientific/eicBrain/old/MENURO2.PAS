{$I switches.inc}
{$UNDEF UNIT}

{$IFDEF UNIT}
unit MenuRO2;

interface

procedure MenuMoreRiOp;

implementation
{$ELSE}
{$M 32000,64000,256000}
{$ENDIF}

uses Dos, Crt, DataMngr, Karex1, PertCht, HpRicOpe;

procedure Risolutore;
var
  Desc: array[1..100] of string[40];
  Scor: array[1..100] of integer;
  tmp: string;
  x, y, i, c: integer;
  ch: char;
begin
  ClrScr;
  writeln('R I S O L U T O R E');
  writeln;
  c:= 3;
  InputInt('Quante scelte hai (3-100)? ', c, 3, 100);
  for i:= 1 to c do begin
    tmp:= '';
    write('Scelta #',i); InputStr(' = ', tmp);
    Desc[i]:= tmp;
    Scor[i]:= 0;
  end;
  FOR X:= 1 TO C - 1 do begin
    FOR Y:= X + 1 TO C do begin
     repeat
       ClrScr;
       writeln('1. ',Desc[X]);
       writeln;
       writeln('2. ',Desc[Y]);
       writeln;
       GetChar('Quale e'' piu'' importante (1-2)? ', ch);
     until ch in ['1','2'];
     if ch = '1' then Scor[X]:= Scor[X] + 1 else Scor[Y]:= Scor[Y] + 1;
    end;
  end;
  ClrScr;
  FOR X:= C - 1 downto 1 do begin
    FOR Y:= 1 TO X do begin
      IF Scor[Y] < Scor[Y + 1] THEN begin
        i:= Scor[Y];
        Scor[Y]:= Scor[Y + 1];
        Scor[Y + 1]:= i;
        tmp:= Desc[Y];
        Desc[Y]:= Desc[Y + 1];
        Desc[Y + 1]:= tmp;
      end;
    end;
  end;
  writeln('ECCO L''ORDINE DI PRIORITA''');
  writeln;
  FOR X:= 1 TO C do begin
    writeln(copy(Desc[X]+'                                         ',1,40),' ',Scor[X]);
    if (x mod 20) = 0 then WaitReturn;
  end;
  writeln;
  WaitReturn;
end;

procedure MenuMoreRiOp;
var ch : char;
begin
  repeat
    ClrScr;
    Write('  Oper. Res.  Package Ver. 1.à - Copyright 1994 by Enrico Croce - ');
    {$IFDEF USE87}
      writeln(' 80x87 ON');
    {$ELSE}
      writeln(' 80x87 OFF');
    {$ENDIF}
    writeln('+--------------------------------------+--------------------------------------+');
    writeln('| 0. Torna al menu principale          |                                      |');
    writeln('|                                      |                                      |');
    writeln('| E. Editor file di testo              | S. Shell Dos                         |');
    writeln('|                                      |                                      |');
    writeln('| M. Minimizzazione z = f(x1, ...)     |                                      |');
    writeln('|                                      |                                      |');
    writeln('| K. Min. PL con metodo Karex One DEMO |                                      |');
    writeln('|                                      |                                      |');
    writeln('| P. Pert Charting System              |                                      |');
    writeln('|                                      |                                      |');
    writeln('| R. Risolutore                        |                                      |');
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
      'S': Shell;
      'E': EditFile;
      'M': HpRicOpeMain;
      'K': Karex1Demo;
      'P': Pert;
      'R': Risolutore;
    end;
  until ch = '0';
  ClrScr;
end;

{$IFNDEF UNIT}
begin
  MenuMoreRiOp;
{$ENDIF}
end.
