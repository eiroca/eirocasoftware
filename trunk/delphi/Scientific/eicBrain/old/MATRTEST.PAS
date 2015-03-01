uses XMs,Crt, Matrix;

var
  a: PS1Matrix;
  i, j: integer;
  sx, sy: integer;
begin
  randomize;
  ClrScr;
  writeln(XMSMaxAvail);
  writeln(Result);
repeat
  sx:= random(300)+1;
  sy:= random(300)+1;
  writeln('Testing ',sx,'x',sy);
  A:= nil;
  New(A, Init(sx, sy));
  if A= nil then begin
    writeln('Non alloccabile');
    continue;
  end;
  for i:= 1 to sx do begin
    for j:= 1 to sy do begin
      A^.At(i,j)^:= i*1000.0+j;
    end;
  end;
  for i:= 1 to sx do begin
    for j:= 1 to sy do begin
      if A^.At(i,j)^ <> (i*1000.0+j) then begin
        writeln('ERRORE a [',i,',',j,'] = ',A^.At(i,j)^:10:3);
      end;
    end;
  end;
  Dispose(A, Done);
until keypressed;
end.
