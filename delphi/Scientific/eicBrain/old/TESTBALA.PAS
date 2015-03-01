uses Plprog, PIBalas;

var 
  ires: integer;
  PL: TPIBalas;
  x: TIRow;
  FName: string;
begin
  PL.Init(nil);
  write('FileName del P.L.I. da ottimizzare con Balas: '); readln(FNAME);
  PL.Load(FName);
  PL.Print;
  FillChar(x, sizeof(x), 0);
  ires:= PL.Solv(x);
  writeln;
  Pl.WriteSol(x);
end.
