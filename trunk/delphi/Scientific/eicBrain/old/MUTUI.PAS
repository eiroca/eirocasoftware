{$I switches.inc}
{ UNDEF UNIT}

{$IFDEF UNIT}
unit Mutui;

interface

uses DataMngr, MathTool, Crt;

procedure MenuMutui;

implementation

{$ELSE}

uses DataMngr, MathTool, Crt;

{$ENDIF}

var
  RIStr: array[0..4] of string;
  r, rt, vl, it, pe, me: PREC;

procedure Titola(Titolo: string);
var i: integer;
begin
  ClrScr;
  GotoXY(40 - length(Titolo) div 2, 1); writeln(Titolo);
  for i:= 1 to 80 do write('-');
end;

procedure Schermo;
var i: integer;
begin
  Titola(' CALCOLO DEI MUTUI ');
  GotoXY( 7, 4); Writeln('Importo del mutuo lire');
  GotoXY( 9, 5); Writeln('Interesse annuo percentuale');
  GotoXY(10, 6); Writeln('Numero di rate del mutuo');
  GotoXY( 1, 7); Writeln('Intervallo tra due rate (in mesi)');
  GotoXY( 1,14); FOR i:= 1 TO 80 do Write('_');
  GotoXY( 1,16); Writeln('TASTI SPECIALI');
  GotoXY( 1,18); Writeln('CTLR-T cancella i caratteri.');
  GotoXY( 1,19); Writeln('RTN passa alla riga successiva.');
  GotoXY( 1,20); Writeln('N   nuovi dati.');
  GotoXY( 1,21); Writeln('M   per uscire.');
end;

procedure Input;
begin
  GotoXY(40, 4); InputPrec('', VL, 0, inf);
  GotoXY(40, 5); InputPrec('', IT, 0, inf);
  GotoXY(40, 6); InputPrec('', PE, 0, inf);
  GotoXY(40, 7); InputPrec('', ME, 0, inf);
end;

procedure Importi;
var
  nu: integer;
  qi, qc, inn, br, be: PREC;
  procedure Header;
  var i: integer;
  begin
    Titola('CALCOLO DEI MUTUI');
    GotoXY(4, 3);
    Writeln('Rata   Quota capitale  Quota interessi  Debito estinto  Debito  Residuo');
    FOR i:= 0 TO 79 do Write('_');
    INn:= Nu;
  end;
begin
  INn:= 1;
  Nu:= 1;
  BR:= VL;
  BE:= 0;
  Header;
  repeat
    IF (Nu > PE) OR (Nu > INn + 15) THEN begin
      WaitReturn;
      Header;
      if Nu >= pe then break;
    end;
    QI:= BR * r;
    QC:= RT - QI;
    BE:= BE + QC;
    BR:= VL - BE;
    writeln('    ',nu:3, '     ', qc:12:0, '     ', qi:12:0, '    ', be:12:0, '     ',br:12:0);
    inc(nu);
  until false;
end;

procedure CalcoloRata;
var ch: char;
begin
  r:= Power((1 + IT),(ME / 12)) - 1; if r= 0 then r:= 0.001;
  RT:= VL * Power((1 + r),PE) * r / (Power((1 + r),PE) - 1);
  GotoXY(1,10); Writeln('Importo delle rate = ', DynaOut(int(rt+0.5)));
  GotoXY(1,12);
  Writeln('<V> per visualizzare i pagamenti.');
  Writeln('<N> per inserire nuovi dati.');
  repeat
    ch:= upcase(readkey); if ch = #0 then readkey;
  until ch in ['V','N'];
  if ch = 'V' then begin
    Importi;
    Schermo;
  end;
end;

procedure MenuMutui;
var fine: integer;
begin
  for fine:= 0 to 4 do RiStr[fine]:= '0';
  repeat
    Schermo;
    Input;
    CalcoloRata;
    GotoXY(1, 24);
    GetSiNo('Vuoi proseguire? ', fine);
  until fine=0;
  ClrScr;
end;

{$IFNDEF UNIT}
begin
  MenuMutui;
{$ENDIF}
end.
