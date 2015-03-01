uses Plprog, SDuaSimp;

var 
  ires: integer;
  PL: TSDuaSimp;
  x: TRow;
  FName: string;
begin
  PL.Init(nil);
  write('FileName del P.L. da ottimizzare: '); readln(FNAME);
  PL.Load(FName);
  PL.Print;
  FillChar(x, sizeof(x), 0);
  ires:= PL.Solv(x);
  PRisultD(PL, ires);
  writeln(Pl.Calc(x));
end.
