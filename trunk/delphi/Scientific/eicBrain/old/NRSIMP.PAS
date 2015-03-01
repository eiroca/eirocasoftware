PROGRAM d10r12(input,output);

uses MathTool, Crt;

(* driver for routine SIMPLX *)
(* incorporates examples discussed in text *)
const
   NumVar=4;                             (* num variabili? *)
   NumVin=4;                             (* num vicoli?    *)
   MaxVar=4;                             (* num variabili + terminenoto ?*)
   MaxVin=4;                             (* num vincoli + obiettivo + ? *)
   VinMin=2;   (* VinMin+VinMag+VinEqu=NumVin *)         (* vincoli tipo 1 <= ? *)
   VinMag=1;                            (* vincoli tipo 2 >= ? *)
   VinEqu=1;                            (* vincoli tipo 3 =  ? *)
   nm1m2=7;   (* nm1m2=NumVar+VinMin+VinMag *)   (* totale num variabili + scarti *)
type
   twochar = string[2];
   glmpbynp = array[0..MaxVin+1,0..MaxVar] OF PREC;
   glnarray = array[1..NumVar] OF integer;
   glmarray = array[1..NumVin] OF integer;
   glnparray = array[1..MaxVar] OF integer;
   glmparray = array[1..MaxVin] OF integer;
var
   ierr, i,icase,j : integer;
   nonbase : glnarray;
   inbase : glmarray;
   a : glmpbynp;
   txt : array[1..nm1m2] OF twochar;

procedure xchg(var a, b: integer); assembler;
asm
  push ds
  lds si, a
  les di, b
  mov bx, es:[di]  
  mov ax, [si]
  mov [si], bx
  mov es:[di], ax
  pop ds
end;

(* ricerca la variabile che deve entrare b massimo, posizione VarIn, val bmax *)
procedure FindIn(a: glmpbynp; MaxVin,MaxVar,mm: integer;
      l1: glnparray; nll,iabf: integer;
      var VarIn: integer; var bmax: PREC);
var
  k: integer;
  test: PREC;
begin
  VarIn:= l1[1];
  bmax:= a[mm,VarIn];
  if (nll < 2) then exit;
  for k:= 2 to nll do begin
    if (iabf = 0) then begin
      test:= a[mm,l1[k]]-bmax;
    end else begin
      test:= abs(a[mm,l1[k]])-abs(bmax);
    end;
    if (test > 0.0) then begin
      bmax:= a[mm,l1[k]];
      VarIn:= l1[k];
    end
  end;
end;

(* ricerca la variabile che deve uscire, riga VarOut *)
procedure FindOut(a: glmpbynp; NumVin,NumVar,MaxVin,MaxVar: integer;
    IndVin: glmparray; NIVin: integer; var VarOut: integer;
    VarIn: integer; var q1: PREC);
label 2;
var
  k,ii,i: integer;
  qp,q0,q: PREC;
begin
  VarOut:= 0;
  if (NIVin < 1) then exit;
  for i:= 1 to NIVin do begin
    if (a[IndVin[i],VarIn] < 0.0) then goto 2;
  end;
  exit;
2:  
  q1:= -a[IndVin[i],0]/a[IndVin[i],VarIn];
  VarOut:= IndVin[i];
  if ((i+1) > NIVin) then exit;
  for i:= i+1 to NIVin do begin
    ii:= IndVin[i];
    if (a[ii,VarIn] < 0.0) then begin
      q:= -a[ii,0]/a[ii,VarIn];
      if (q < q1) then begin
        VarOut:= ii;
        q1:= q;
      end else if (q = q1) then begin
        for k:= 1 to NumVar do begin
          qp:= -a[VarOut,k]/a[VarOut,VarIn];
          q0:= -a[ii,k]/a[ii,VarIn];
          if (q0 <> qp) then break;
        end;
        if (q0 < qp) then VarOut:= ii;
      end;
    end;
  end;
end;

(* aggiorna il tableau *)
procedure Pivot(var a: glmpbynp; MaxVin,MaxVar,i1,k1,VarOut,VarIn: integer);
var
  kk,ii: integer;
  piv: PREC;
begin
  piv:= 1.0 / a[VarOut,VarIn];
  if (i1 >= 0) then begin
    for ii:= 0 to i1 do begin
      if (ii <> VarOut) then begin
        a[ii,VarIn]:= a[ii,VarIn]*piv;
        for kk:= 0 to k1 do begin
          if (kk <> VarIn) then begin
            a[ii,kk]:= a[ii,kk] - a[VarOut,kk]*a[ii,VarIn];
          end
        end
      end
    end
  end;
  for kk:= 0 to k1 do begin
    if (kk <> VarIn) then a[VarOut,kk]:= -a[VarOut,kk]*piv;
  end;
  a[VarOut,VarIn]:= piv;
end;

procedure simplx(var a: glmpbynp; NumVin,NumVar,MaxVin,MaxVar,VinMin,VinMag,VinEqu: integer;
       var icase: integer; var nonbase: glnarray;
       var inbase: glmarray; var ierr: integer);
label 1,10,20,30;
const eps=1.0e-6;
var
   NIVin,nl1,m12,VarIn,kh,k,is, VarOut,i: integer;
   q1,bmax: PREC;
   l1: glnparray;
   IndVin,l3: glmparray;
begin
  ierr:= 0;
  if (NumVin <> (VinMin+VinMag+VinEqu)) then begin
    ierr:= 1;
    exit;
  end;
  nl1:= NumVar;
  for k:= 1 to NumVar do begin
    l1[k]:= k;
    nonbase[k]:= k;
  end;
  NIVin:= NumVin;
  for i:= 1 to NumVin do begin   (* verifica condizione primaria *)
    if (a[i,0] < 0.0) then begin
      ierr:= 2;
      exit;
    end;
    IndVin[i]:= i;
    inbase[i]:= NumVar+i;
  end;
  for i:= 1 to VinMag do begin
    l3[i]:= 1;
  end;
  if ((VinMag+VinEqu) = 0) then goto 30;
  for k:= 0 to NumVar do begin
    q1:= 0.0;
    for i:= VinMin+1 to NumVin do begin
      q1:= q1+a[i,k];
    end;
    a[NumVin+1,k]:= -q1;
  end;
10:  
  FindIn(a,MaxVin,MaxVar,NumVin+1,l1,nl1,0,VarIn,bmax);
  if ((bmax <= eps) AND (a[NumVin+1,0] < -eps)) then begin
    icase:= -1; 
    exit;
  end
  else if ((bmax <= eps) AND (a[NumVin+1,0] <= eps)) then begin
    m12:= VinMin+VinMag+1;
    if (m12 <= NumVin) then begin
      for VarOut:= m12 to NumVin do begin
        if (inbase[VarOut] = (VarOut+NumVar)) then begin
          FindIn(a,MaxVin,MaxVar,VarOut,l1,nl1,1,VarIn,bmax);
          if (bmax > 0.0) then goto 1
        end
      end
    end;
    m12:= m12-1;
    if ((VinMin+1) > m12) then goto 30;
    for i:= VinMin+1 to m12 do begin
      if (l3[i-VinMin] = 1) then begin
        for k:= 0 to NumVar do begin
          a[i,k]:= -a[i,k]
        end
      end
    end;
    goto 30
  end;
  FindOut(a,NumVin,NumVar,MaxVin,MaxVar,IndVin,NIVin,VarOut,VarIn,q1);
  if (VarOut = 0) then begin
    icase:= -1; 
    exit;
  end;
1:  
  Pivot(a,MaxVin,MaxVar,NumVin+1,NumVar,VarOut,VarIn);
  if (inbase[VarOut] >= (NumVar+VinMin+VinMag+1)) then begin
    for k:= 1 to nl1 do begin
      if (l1[k] = VarIn) then break;
    end;
    nl1:= nl1-1;
    for is:= k to nl1 do begin
      l1[is]:= l1[is+1]
    end
  end else begin
    if (inbase[VarOut] < (NumVar+VinMin+1)) then goto 20;
    kh:= inbase[VarOut]-VinMin-NumVar;
    if (l3[kh] = 0) then goto 20;
    l3[kh]:= 0
  end;
  a[NumVin+1,VarIn]:= a[NumVin+1,VarIn]+1.0;
  for i:= 0 to NumVin+1 do begin
    a[i,VarIn]:= -a[i,VarIn]
  end;
20:  
  xchg(nonbase[VarIn], inbase[VarOut]);
  goto 10;
30:  
  FindIn(a,MaxVin,MaxVar,0,l1,nl1,0,VarIn,bmax);
  if (bmax <= 0.0) then begin
    icase:= 0; 
    exit;
  end;
  FindOut(a,NumVin,NumVar,MaxVin,MaxVar,IndVin,NIVin,VarOut,VarIn,q1);
  if (VarOut = 0) then begin
    icase:= 1; 
    exit;
  end;
  Pivot(a,MaxVin,MaxVar,NumVin,NumVar,VarOut,VarIn);
  xchg(nonbase[VarIn],inbase[VarOut]);
  goto 30;
end;


var x, b: integer;

begin
  txt[1] := 'x1'; txt[2] := 'x2'; txt[3] := 'x3'; txt[4] := 'x4'; 
  txt[5] := 'y1'; txt[6] := 'y2'; txt[7] := 'y3';
  (*           b                1               2              3                4          *)
(* obb.  *) a[0,0] :=   0.0; a[0,1] :=  1.0; a[0,2] :=  1.0; a[0,3] :=  3.0; a[0,4] := -0.5;
(* vin VinMin*) a[1,0] := 740.0; a[1,1] := -1.0; a[1,2] :=  0.0; a[1,3] := -2.0; a[1,4] :=  0.0;
(* vin VinMin*) a[2,0] :=   0.0; a[2,1] :=  0.0; a[2,2] := -2.0; a[2,3] :=  0.0; a[2,4] :=  7.0;
(* vin VinMag*) a[3,0] :=   0.5; a[3,1] :=  0.0; a[3,2] := -1.0; a[3,3] :=  1.0; a[3,4] := -2.0;
(* vin VinEqu*) a[4,0] :=   9.0; a[4,1] := -1.0; a[4,2] := -1.0; a[4,3] := -1.0; a[4,4] := -1.0;
  simplx(a, NumVin, NumVar, MaxVin, MaxVar, VinMin, VinMag, VinEqu, icase, nonbase, inbase, ierr);
  writeln;
  if ierr <> 0 then begin
    writeln('Errore interno del simplesso: ', ierr);
    case ierr of
      1: writeln('NumVin <> VinMin+VinMag+VinEqu, ovvero numero totale vincoli <> somma dei vincoli =, <=, >= !!!');
      2: writeln('Bad input tableau! primary condition not satisfied!'); 
    end;
    Halt(1);
  end;
  if (icase = 1) then begin
    writeln('unbounded objective function')
  end else if (icase = -1) then begin
    writeln('no solutions satisfy constraints given')
  end else begin
    write(' ':11);
    for i:= 1 to NumVar do begin
      if (nonbase[i] <= nm1m2) then begin
        write(txt[nonbase[i]]:10);
      end
    end;
    writeln;
    for i:= 0 to NumVin do begin
      if (i > 0) then begin
        write(txt[inbase[i]])
      end else begin
        write('  ')
      end;
      for j:= 0 to NumVar do begin
        if (j=0) then write(a[i,j]:10:2);
        if (j>0) then begin
          if (nonbase[j] <= nm1m2) then write(a[i,j]:10:2)
        end
      end;
      writeln;
    end;
  end;
end.

