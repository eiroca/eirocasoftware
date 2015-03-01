uses Plprog, SSimplex;

var 
  ires: integer;
  PL: TSSimplex;
  x: TRow;
  FName: string;
begin
  PL.Init(nil);
  write('FileName del P.L. da ottimizzare: '); readln(FNAME);
  PL.Load(FName);
  PL.Print;
  FillChar(x, sizeof(x), 0);
  x[1]:= 1; x[2]:= 1;
  writeln(Pl.Calc(x));
  FName:= 'pl.log';
  ires:= PL.Solv(x);
  PRisult(PL, ires);
  writeln(Pl.Calc(x));
end.
