uses Matrici;
var
  A, B, C: TMatrix;
begin
  A[0,0]:= 1; A[0,1]:= 0; A[0, 2]:= 0;
  A[1,0]:= 2; A[1,1]:= 10; A[1, 2]:= 0;
  A[2,0]:= 3; A[2,1]:= 4; A[2, 2]:= 1;
  MatInvTriInf(A, B, 3);
  MatMul(A, B, C, 3, 3, 3);
end.
