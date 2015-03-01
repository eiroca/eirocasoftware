{$I switches.inc}
uses Matrix, MathTool, MatrMath, Crt;

const DIM = 3;

var
  A: TSMatrix;
  B, C, D: TSMatrix;
  aa: TSMatrix;
  cc, bb, xx: TSVector;
  Pvt: PIVector;
  Determ: PREC;
  tmp: integer;
  n, i, j: integer;
  k: longint;
label Quit, Quit2;
begin
  ClrScr;
  A.Init(0,DIM,DIM);
  B.Init(0,DIM,DIM);
  C.Init(0,DIM,DIM);
  D.Init(0,DIM,DIM);
  writeln('Testing SMatInv e SMatMul');
  k:= 0;
  repeat
    randomize;
    inc(k);
    for i:= 0 to DIM-1 do begin
      for j:= 0 to DIM-1 do begin
        A.At(i,j)^:= int(random * 20)-10;
      end;
    end;
    if SMatInv(B,A) <> 0 then begin
      A.Print('',0,0,0,0,0);
      writeln('non invertibile');
      continue;
    end;
    SMatMul(C,A,B);
    for i:= 0 to DIM-1 do begin
      for j:= 0 to DIM-1 do begin
        if ((i = j) and (abs(C.At(i,i)^-1) > 1e-6)) or
           ((i<>j)  and (abs(C.At(i,j)^) > 1e-6)) then begin
          A.Print('',0,0,0,0,0);
          B.Print('',0,0,0,0,0);
          C.Print('',0,0,0,0,0);
          readln;
          Goto Quit;
        end;
      end;
    end;
  Quit:
    write(k,#13);
  until keypressed;
  while readkey = #0 do readkey;
  writeln(k,' tests made.');
  writeln('Testing FactorGAU e SolveGAU');
  k:= 0;
  bb.Init(0,DIM);
  xx.Init(0,DIM);
  cc.Init(0,DIM);
  repeat
    randomize;
    inc(k);
    for i:= 0 to DIM-1 do begin
      for j:= 0 to DIM-1 do begin
        A.At(i,j)^:= random;
      end;
      bb.At(i)^:= random;
    end;
    pvt:= nil;
    MatrixCopyTo(A,B);
    tmp:= FactorGAU(A, pvt, Determ);
    if tmp = 0 then tmp:= SolveGAU(A, pvt, bb, xx);
    if tmp <> 0 then begin
      writeln('Problemi!');
      b.Print('',0,0,0,0,0);
      bb.Print('',0,0,0,0);
      readln;
      goto Quit2;
    end;
    SMatVec(cc, b, xx);
    for i:= 0 to DIM-1 do begin
      if abs(bb.At(i)^-cc.At(i)^) > Zero then begin
        writeln('Problemi!');
        b.Print('',0,0,0,0,0);
        xx.Print('',0,0,0,0);
        cc.Print('',0,0,0,0);
        readln;
        Goto quit2;
      end;
    end;
  Quit2:
    write(k,#13);
  until keypressed;
  while readkey = #0 do readkey;
  writeln(k,' tests made.');
end.
