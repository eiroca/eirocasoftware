uses Plprog, RSimplex;

var
  i,j,ires: integer;
  PL: TRSimplex;
  x: TRow;
  FName: string;
begin
  PL.Init(nil);
  Fname:='exam.dat';
  Fname:='es01-175.dat';
  write('FileName del P.L. da ottimizzare: '); readln(FNAME);
  PL.Load(FName);
  PL.Print;
  FillChar(x, sizeof(x), 0);
  ires:= PL.Solv(x);
  writeln;
  writeln('Risultato = ', ires);
  for i:= 1 to PL.NumVin do begin
    j:=Pl.Inbase[i];
    if j <= PL.NumVar then write(Pl.VarNam[j])
    else write('Fitt.#',j);
    writeln(' := ',X[j]:10:4);
  end;
  writeln;
  writeln('z = ', x[0]:10:4);
  readln;
  pl.AnalParmb;
  pl.AnalParmc;
  pl.AnalParmlb;
  pl.AnalParmlc;
end.
