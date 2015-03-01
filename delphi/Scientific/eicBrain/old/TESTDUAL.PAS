uses PlProg;
var
  PL, DPL: TPL;
  FName: string;
begin
  PL.Init(nil);
  DPL.Init(nil);
  write('FileName del P.L. da trovare il duale: '); readln(FNAME);
  PL.Load(FName);
  Pl.Store('pippo1.bak');
  PL.Duale(DPL);
  DPL.Store('pippo2.bak');
end.
