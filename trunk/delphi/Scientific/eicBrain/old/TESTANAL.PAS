uses AnalPost, Dos, Crt;
var
  x: TAnalisiB;
  FName: PathStr;
begin
  x.Init(nil);
  write('FileName del P.L. da trovare il duale: '); readln(FNAME);
  x.Pl.Load(FName);
end.
