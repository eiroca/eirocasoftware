unit TrasfU2D;

{$I switches.inc}

interface

procedure Trasfor2DUnif;

implementation

uses MathTool, MathTls2, DataMngr, Crt;

type
  MatTra = array[0..1,0..1] of PREC;

procedure ComputeMarginal(Vg, Vp: char; Ag, Ap: char; var Pnt: PntArr; const k: PREC; MarginalY: boolean);
var
  m1, q1, m2, q2: PREC;
  swp: integer;
begin
  writeln('Calcolo della marginale in ',Vg);
  writeln('         ô');
  writeln(' F (',Vg,') = ³    F   (',Ag,',',Vg,')  d',Ap,' = ');
  writeln('  ',Vg,'      õR    ',Ag,',',Vg);      
  writeln;
  if Equal(Pnt[0].y, Pnt[1].y) then begin
    if not Equal(Pnt[2].y, Pnt[3].y) then begin (* in un rettangolo DEVE esserlo *)
      writeln('Spiacente non e'' un rettangoloide, attualmente, pero'' serve che lo sia');
      WaitReturn;
      exit;
    end;
    if Pnt[0].x > Pnt[1].x then SwapPoint(Pnt[0], Pnt[1]);  (*  P[0] .   .  P[1]  *)
    if Pnt[2].x > Pnt[3].x then SwapPoint(Pnt[2], Pnt[3]);  (*  P[2]  .   . P[3]  *)
    writeln('   {  ô ',WriteLineX(Ap, Vp, Pnt[1], Pnt[3]));
    writeln('   {  ³                            k  d',Ap,'     se ',Pnt[0].y:6:2,' ó ',Vp,' ó ', Pnt[2].y:6:2);  
    writeln(' = {  õ ',WriteLineX(Ap, Vp, Pnt[0], Pnt[2]));
    writeln('   {');
    writeln('   {  0    altrove');
    writeln;
    MakeLineX(Pnt[0], Pnt[2], m1, q1);
    MakeLineX(Pnt[1], Pnt[3], m2, q2);
    m1:= (m2 - m1) * k;  q1:= (q2 - q1) * k;
    writeln(' = { ',WriteLine(' ', Vp, m1, q1),Tab(45),'se ',Pnt[0].y:6:2,' ó ',Vp,' ó ', Pnt[2].y:6:2);  
    writeln(' = {');
    writeln('   {  ',0.0:12:5,'    altrove');
    WaitReturn;
  end
  else if Equal(Pnt[1].y, Pnt[2].y) then begin
    if Pnt[1].x > Pnt[2].x then SwapPoint(Pnt[1], Pnt[2]);  (*  P[1] .   .  P[2]  *)
    writeln('   {  ô ',WriteLineX(Ap, Vp, Pnt[0], Pnt[2]));
    writeln('   {  ³                            k  d',Ap,'     se ',Pnt[0].y:6:2,' ó ',Vp,' ó ', Pnt[2].y:6:2);  
    writeln('   {  õ ',WriteLineX(Ap, Vp, Pnt[0], Pnt[1]));
    writeln('   {');
    writeln(' = {  ô ',WriteLineX(Ap, Vp, Pnt[3], Pnt[2]));
    writeln('   {  ³                            k  d',Ap,'     se ',Pnt[2].y:6:2,' ó ',Vp,' ó ', Pnt[3].y:6:2);  
    writeln('   {  õ ',WriteLineX(Ap, Vp, Pnt[3], Pnt[1]));
    writeln('   {');
    writeln('   {  0    altrove');
    writeln;
    MakeLineX(Pnt[0], Pnt[1], m1, q1);
    MakeLineX(Pnt[0], Pnt[2], m2, q2);
    m1:= (m2 - m1) * k;  q1:= (q2 - q1) * k;
    writeln('   { ',WriteLine(' ', Vp, m1, q1),Tab(45),'se ',Pnt[0].y:6:2,' ó ',Vp,' ó ', Pnt[2].y:6:2);  
    MakeLineX(Pnt[3], Pnt[1], m1, q1);
    MakeLineX(Pnt[3], Pnt[2], m2, q2);
    m1:= (m2 - m1) * k;  q1:= (q2 - q1) * k;
    writeln(' = { ',WriteLine(' ', Vp, m1, q1),Tab(45),'se ',Pnt[2].y:6:2,' ó ',Vp,' ó ', Pnt[3].y:6:2);  
    writeln('   {    0                  altrove');
    WaitReturn;
  end
  else begin
    (*       P[0]   .
             P[1] .   .  P[2]
                      .  P[3] *)
    if Pnt[1].x < Pnt[2].x then begin
      writeln('   {  ô ',WriteLineX(Ap, Vp, Pnt[0], Pnt[2]));
      writeln('   {  ³                            k  d',Ap,'     se ',Pnt[0].y:6:2,' ó ',Vp,' ó ', Pnt[1].y:6:2);  
      writeln('   {  õ ',WriteLineX(Ap, Vp, Pnt[0], Pnt[1]));
      writeln('   {');
      writeln('   {  ô ',WriteLineX(Ap, Vp, Pnt[0], Pnt[2]));
      writeln('   {  ³                            k  d',Ap,'     se ',Pnt[1].y:6:2,' ó ',Vp,' ó ', Pnt[2].y:6:2);  
      writeln('   {  õ ',WriteLineX(Ap, Vp, Pnt[3], Pnt[1]));
      writeln(' = {');
      writeln('   {  ô ',WriteLineX(Ap, Vp, Pnt[3], Pnt[2]));
      writeln('   {  ³                            k  d',Ap,'     se ',Pnt[2].y:6:2,' ó ',Vp,' ó ', Pnt[3].y:6:2);  
      writeln('   {  õ ',WriteLineX(Ap, Vp, Pnt[3], Pnt[1]));
      writeln('   {');
      writeln('   {  0    altrove');
      swp:= 1;
    end
    else begin
      writeln('   {  ô ',WriteLineX(Ap, Vp, Pnt[0], Pnt[1]));
      writeln('   {  ³                            k  d',Ap,'     se ',Pnt[0].y:6:2,' ó ',Vp,' ó ', Pnt[1].y:6:2);  
      writeln('   {  õ ',WriteLineX(Ap, Vp, Pnt[0], Pnt[2]));
      writeln('   {');
      writeln('   {  ô ',WriteLineX(Ap, Vp, Pnt[3], Pnt[1]));
      writeln('   {  ³                            k  d',Ap,'     se ',Pnt[1].y:6:2,' ó ',Vp,' ó ', Pnt[2].y:6:2);  
      writeln('   {  õ ',WriteLineX(Ap, Vp, Pnt[0], Pnt[2]));
      writeln(' = {');
      writeln('   {  ô ',WriteLineX(Ap, Vp, Pnt[3], Pnt[1]));
      writeln('   {  ³                            k  d',Ap,'     se ',Pnt[2].y:6:2,' ó ',Vp,' ó ', Pnt[3].y:6:2);  
      writeln('   {  õ ',WriteLineX(Ap, Vp, Pnt[3], Pnt[2]));
      writeln('   {');
      writeln('   {  0    altrove');
      swp:= -1;
    end;
    writeln;
    MakeLineX(Pnt[0], Pnt[1], m1, q1);
    MakeLineX(Pnt[0], Pnt[2], m2, q2);
    m1:= (m2 - m1) * k * swp;  q1:= (q2 - q1) * k * swp;
    writeln('   { ',WriteLine(' ', Vp, m1, q1),Tab(45),'se ',Pnt[0].y:6:2,' ó ',Vp,' ó ', Pnt[1].y:6:2);  
    MakeLineX(Pnt[3], Pnt[1], m1, q1);
    MakeLineX(Pnt[0], Pnt[2], m2, q2);
    m1:= (m2 - m1) * k * swp;  q1:= (q2 - q1) * k * swp;
    writeln('   { ',WriteLine(' ', Vp, m1, q1),Tab(45),'se ',Pnt[1].y:6:2,' ó ',Vp,' ó ', Pnt[2].y:6:2);  
    MakeLineX(Pnt[3], Pnt[1], m1, q1);
    MakeLineX(Pnt[3], Pnt[2], m2, q2);
    m1:= (m2 - m1) * k * swp;  q1:= (q2 - q1) * k * swp;
    writeln(' = { ',WriteLine(' ', Vp, m1, q1),Tab(45),'se ',Pnt[2].y:6:2,' ó ',Vp,' ó ', Pnt[3].y:6:2);  
    write('   {    0                          altrove');
    writeln;
    WaitReturn;
  end;
end;

procedure ComputeConstant(kos: char; const Pnt: PntArr; var k: PREC);
var
  l1, l2, l3, la, ll, ld: PREC;
  Area1, Area2: PREC;
begin
  la:= len(Pnt[0], Pnt[3]); ll:= len(Pnt[0], Pnt[1]); ld:= len(Pnt[0], Pnt[2]);
  l1:= len(Pnt[2], Pnt[3]); l2:= len(Pnt[2], Pnt[1]); l3:= len(Pnt[3], Pnt[1]);
  if not(Equal(l2,la)) or not(Equal(l1, ll)) then begin
    writeln('Spiacente le lunghezze dei lati non sono uguali a coppie, accertarsi');
    writeln('che i dati siano stati immessi in orgine orario o antiorario.');
    WaitReturn;
    exit;
  end;
  if not(Equal(l3, ld)) then begin
    writeln('Attenzione non e'' un rettangolo, le diagonali hanno lunghezze');
    writeln('diverse. I risultati non sono garantiti!!!!!!!!!!!!');
    WaitReturn;
  end;
  writeln;
  writeln('F    (X, Y)   =    {   ',kos,'    nel rettangolo ABCD');
  writeln(' X,Y               {   0    altrove');
  writeln;
  writeln('Calcolo il valore di ',kos);
  writeln(' ôô');
  writeln(' ³³    F   (X,Y)  dx dy  = 1     =>   Area(ABCD) * ',kos,' = 1');
  writeln(' õõRý   X,Y');
  Area1:= la * ll;
  k:= 1 / Area1;   
  writeln;
  writeln('F    (X, Y)   =    {   ',  k:12:5,'   nel rettangolo ABCD');
  writeln(' X,Y               {   ',0.0:12:5,'   altrove');
end;

procedure Trasfor2DUnif;
var
  A,  B,  C,  D,
  Ap, Bp, Cp, Dp : Point;
  Pnt: PntArr;
  k, k2: PREC;
  tmp: PREC;
  i,j: integer;
  JM: MatTra;
  JD: PREC;
begin
  ClrScr;
  writeln('Questa procedure calcola la trasformazione di una distribuzione (X,Y) di');
  writeln('probabilita'' uniforme su un rettangolo ABCD, attraverso una traformazione');
  writeln(' U = c11 X + c12 Y,   V = c21 X + c22 Y.');
  writeln('di entrambe le distribuzioni vengono fornite le distribuzioni marginali,');
  writeln('e i valori attesi dei momenti. ');
  writeln;
  writeln('Inserire i vertici del rettangolo della distribuzione (X,Y).');
  writeln('in coordinate cartesiane, nella forma x y, in senso orario o antiorario.');
  write('Punto A: '); readln (A.x, A.y);
  write('Punto B: '); readln (B.x, B.y);
  write('Punto C: '); readln (C.x, C.y);
  write('Punto D: '); readln (D.x, D.y);
  writeln;
  (* Test allineamento punti, fondamentale, dopo non viene piu' testato! *)
  if AllinedPoint(A, B, C) or AllinedPoint (A, B, D) or
     AllinedPoint(A, D, B) or AllinedPoint (A, D, C) or
     AllinedPoint(A, C, B) or AllinedPoint (A, C, D) or
     AllinedPoint(B, C, A) or AllinedPoint (B, C, D) or
     AllinedPoint(B, D, A) or AllinedPoint (B, D, C) or
     AllinedPoint(C, D, A) or AllinedPoint (C, D, B) then begin
       writeln('Alcuni punti sono allineati!!!, non posso proseguire!!');
       WaitReturn;
       exit;
  end;
  (* A questo punto non si puo' essere certi che sia un rettangolo, potrebbe
  ancora essere una qualunque forma bidimensionale delimitata da 4 punti non
  allineati, per testare che sia un rettangoloide bisogna calcolare i 6
  vettori direzione ottenibili delle combinazioni dei 4 punti, a questo punto
  dovrebbero asserci due coppie di direrzioni uguali, e una coppia uguale in
  modulo, ma di segno opposto.
  Il test viene fatto solo sulle lunghezze dei lati.*)
  Pnt[0]:= A; Pnt[1]:= B; Pnt[2]:= C; Pnt[3]:= D;
  writeln;
  writeln('Sia:       ` = trasposto');
  writeln('A = ',WritePoint(A));
  writeln('B = ',WritePoint(B));
  writeln('C = ',WritePoint(C));
  writeln('D = ',WritePoint(D));
  ComputeConstant('k', Pnt, k);
  SortPoint(Pnt, true);
  WaitReturn;
  ComputeMarginal('Y', 'y', 'X', 'x', Pnt, k, true);
  SortPoint(Pnt, false);
  for i:= 0 to 3 do begin
    tmp:= Pnt[i].x; Pnt[i].x:= Pnt[i].y; Pnt[i].y:= tmp;
  end;
  ComputeMarginal('X', 'x', 'Y', 'y', Pnt, k, true);
  writeln;
  writeln('Trasformazione');
  writeln(' U = a11 X + a12 Y');
  writeln(' V = a21 X + a22 Y');
  writeln;
  writeln('Inserire i coefficenti:');
  for i:= 0 to 1 do begin
    for j:= 0 to 1 do begin
      write('a',succ(i),succ(j),' = '); readln(JM[i, j]);
    end;
  end;
  Ap.x:=  JM[0,0] * A.x + JM[0, 1] * A.y;
  Ap.y:=  JM[1,0] * A.x + JM[1, 1] * A.y;
  Bp.x:=  JM[0,0] * B.x + JM[0, 1] * B.y;
  Bp.y:=  JM[1,0] * B.x + JM[1, 1] * B.y;
  Cp.x:=  JM[0,0] * C.x + JM[0, 1] * C.y;
  Cp.y:=  JM[1,0] * C.x + JM[1, 1] * C.y;
  Dp.x:=  JM[0,0] * D.x + JM[0, 1] * D.y;
  Dp.y:=  JM[1,0] * D.x + JM[1, 1] * D.y;
  writeln;
  writeln;
  writeln('Sia J la seguente matrice: ');
  for i:= 0 to 1 do begin
    write(' [ ');
    for j:= 0 to 1 do begin
      write(JM[i, j]:10:3,' ');
    end;
    writeln(']');
  end;
  writeln;
  writeln('I vertici del nuovo dominio indotto dalla trasformazione sono:');
  writeln('A'' = J * A = ',WritePoint(Ap));
  writeln('B'' = J * B = ',WritePoint(Bp));
  writeln('C'' = J * C = ',WritePoint(Cp));
  writeln('D'' = J * D = ',WritePoint(Dp));
  writeln;
  WaitReturn;
  writeln('F    (U, V)   =    {   c = k/|J|   nel rettangolo A''B''C''D''');
  writeln(' U,V               {   0           altrove');
  writeln(' con  |.| si intende il modulo del determinante');
  writeln;
  JD := abs(JM[0,0] * JM[1,1] - JM[0,1] * JM[1,0]);
  if JD < Zero then begin
    writeln('Spiacente trasformazione non biunivoca!!');
    WaitReturn;
    exit;
  end;
  k2:= k / JD;
  writeln(' c = ', k2:12:5);
  Pnt[0]:= Ap; Pnt[1]:= Bp; Pnt[2]:= Cp; Pnt[3]:= Dp;
  writeln(' oppure x altra via:');
  ComputeConstant('c', Pnt, k2);
  WaitReturn;
  SortPoint(Pnt, true);
  ComputeMarginal('V', 'v', 'U', 'u', Pnt, k2, true);
  SortPoint(Pnt, false);
  for i:= 0 to 3 do begin
    tmp:= Pnt[i].x; Pnt[i].x:= Pnt[i].y; Pnt[i].y:= tmp;
  end;
  ComputeMarginal('U', 'u', 'V', 'v', Pnt, k2, true);
  writeln;
  writeln('Terminato.');
  WaitReturn;
end;

end.
