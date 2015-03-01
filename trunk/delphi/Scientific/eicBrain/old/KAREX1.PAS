unit karex1;

{$I switches.inc}

interface

procedure Karex1Demo;

implementation

uses MathTool;

const
  N = 3; (* number of unknowns *)
  K = 1; (* number of equations *)
  k1= k+1;
  k2= 2*k1;

const
  A: array[1..K,1..N] of PREC = ((2,-3,1)); (* data for constraint matrix A *)
  CC: array[1..N] of PREC = (3,3,-1); (* data for the objective function CC *)
var
  A0, XOLD, XNEW, CP: array[0..N] of PREC;
  B : array[0..K1,0..N] of PREC;
  B1: array[0..K1,0..K2] of PREC;
  B2: array[0..N,0..K1] of PREC;
  B3: array[0..N,0..N] of PREC;
  (* CC is for the objective function
     B1, B2, Bœ are used fot the computation of CP
     R and C are "row" and "column" idices
     Ubitially, set XNew=A0, the center of simplex *)
  T: PREC; (* T is the tollerance *)
  alpha: PREC; (* usually set equal to 1/4 *)
  iteration: integer;
  v, vnew: PREC;
  i,r,c: integer;
  aa,z: PREC;

procedure Karex1Demo;
label l335,l338;
begin
  for c:= 1 to N do begin
    A0[c]:= 1/N;
    XNEW[C]:= A0[C];
  end;
  T:= 0.001;
  alpha:= 1/4;
  iteration:= 0;
  (* Set initial value to value at center of simplex *)
  v:= 0;
  for c:= 1 to N do v:= v + CC[C]*A0[C];
  VNEW:= v;
  (* main iteration process *)
  while vnew/v > t do begin
    write(iteration:4,' ');
    for c:= 1 to n do write(XNEW[c]:8:4,' ');
    writeln(vnew/v:10:6);
    iteration:= iteration +1;
    (* put xnew into xold *)
    for c:= 1 to N do XOLD[c]:= XNEW[c];
    (* construct the matrix B *)
    for r:= 1 to K do begin
      for c:= 1 to N do begin
        B[R,C]:= A[R,C]*XOLD[C];
      end;
    end;
    for c:= 1 to N do B[k1, c]:= 1;
    (* Zero matrices to be used in computations...*)
    for r:=1 to k1 do for c:=1 to k2 do B1[r,c]:= 0;
    for r:=1 to n  do for c:=1 to k1 do B2[r,c]:= 0;
    for r:=1 to n  do for c:=1 to n  do B3[r,c]:= 0;
    for c:= 1 to n do cp[C]:= 0;
    (* find BBT and put in B1 *)
    for r:= 1 to k1 do begin
      for c:= 1 to k1 do begin
        for i:= 1 to N do begin
          B1[R,C]:=B1[R,c]+B[r,i]*B[c,i];
        end;
      end;
    end;
    (* Adjoin an identity matrix to BBT *)
    for i:= 1 to k1 do B1[I, I+K1]:= 1;
    (* row reduce BBT|I *)
    for r:= 1 to k1 do begin
      if B1[r,r] <> 0 then goto l338;
      i:= r+1;
    l335:
      if i>k1 then begin
         writeln('Error! BBT is SINGULAR!');
         halt(1);
      end;
      if b1[i,r] = 0 then begin
        i:= i+1;
        goto l335;
      end;
      for c:= 1 to k2 do SwapPrec(b1[r,c],b1[i,c]);
   l338:
      for i:= r+1 to k1 do begin
        z:= b1[i,r]/b1[r,r];
        for c:= 1 to k2 do b1[i,c]:= B1[i,c]-z*b1[r,c];
      end;
    end;
    (* Now back substitute to finish it...*)
    for r:= k1 downto 2 do begin
      for i:= r-1 downto 1 do begin
        z:= b1[i,r]/b1[r,r];
        for c:= r to k2 do begin
          b1[i,c]:= b1[i,c]-z*b1[r,c];
        end;
      end;
    end;
    (* Remember to make diagonal entries 1s *)
    for r:= 1 to k1 do begin
      z:= b1[r,r];
      for c:= 1 to k2 do b1[r,c]:= b1[r,c]/Z;
    end;
    (* BBT inverse is now in B1 in columns k1+1 to k2 *)
    (* now multiply BBT inverse by BT and put in B2 *)
    for r:= 1 to n do begin
      for c:= 1 to k1 do begin
        for i:= 1 to k1 do begin
          b2[r,c]:= b2[r,c]+B[i,r]*b1[i,c+k1];
        end;
      end;
    end;
    (* take that and multiply by B and put in B3 *)
    for r:=1 to n do begin
      for c:= 1 to n do begin
        for i:= 1 to k1 do begin
          B3[r,c]:= b3[r,c] + b2[r,i]*b[i,c];
        end;
      end;
    end;
    (* find I-B3 by subtracting 1s on diagonal  and changing signs *)
    for r:= 1 to N do B3[r,r]:= B3[r,r]-1;
    for r:= 1 to n do for c:= 1 to n do B3[r,c]:= -B3[r,c];
    (* multiply by D *)
    for r:=1 to n do for c:=1 to n do b3[r,c]:=b3[r,c]*XOLD[C];
    (* find projection of CC and call it CP *)
    for r:=1 to N do for c:=1 to N do CP[R]:= CP[R] + b3[r,c]*CC[C];
    (* Find length of CP and the normalized CP *)
    AA:= 0;
    for c:=1 to N do AA:= AA + CP[C]*CP[C];
    AA:= sqrt(AA); for c:=1 to n do CP[C]:= CP[C]/AA;
    (* find a*, project back to get new X *)
    AA:= sqrt(N*(n-1))/alpha;
    for c:= 1 to N do XNEW[C]:= (A0[C]-CP[C]/AA)*XOLD[C];
    (* And remember to divide by "size" of new X to complete the projective
    transformation bak ro the original simplex *)
    AA:= 0;
    for c:=1 to n do AA:= AA + XNEW[C];
    for c:=1 to n do XNEW[C]:= XNEW[C]/AA;
    (* Find objective function value at NEW point X *)
    VNEW:= 0;
    for c:= 1 to n do vnew:= vnew + CC[C]*XNEW[C];
  end;
  writeln;
  writeln('Tollerance reached: Vnew/Vinitial = ',VNEW/V);
  writeln;
  for c:= 1 to n do XNEW[C]:= int(XNEW[c]/T+0.5)*T;
  for c:= 1 to n do write(XNEW[c]:8:4,' ');
  readln;
end;

end.
