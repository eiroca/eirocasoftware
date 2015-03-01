unit PCA;

{$I switches.inc}

interface

uses DataMngr;

procedure DoPCA(var Spread: TSpread);

implementation

uses Charting, Matrix, MatrMath, MathTool, MathStt1, Crt;

procedure DoPCA(var Spread: TSpread);
var
  DataX, DataY: TSerie;
  R : TSMatrix;
  VT: TSMatrix;
  S : TSMAtrix;
  VL: TSVector;
  A : TSMatrix;
  Med, Sca: TSVector;
  SmX, SmX2: DPREC;
  tmp: PREC;
  X, X1, U0, A0, A1, A2, A3: PREC;
  RR, T1, T2, Z, Z1, T, C, SS, C2, S2, S1: PREC;
  i, j, k, l: integer;
  m, i1, n1, r1, k1, nc, nr: integer;
  ch: char;
  (* x grafica *)
  pt, ca, cb: integer;
  tmps1,tmps2: string;
  Cht: PScatChart;
begin
  ClrScr;
  Writeln('PCA Analisi Coponenti Principali');
  writeln;
  nr:= 1;
  nc:= 1;
  InputInt('Quante componenti? ',nc,1,maxint);
  if Spread.CountSerie < nc then begin
    writeln;
    writeln('Immettere piu'' colonne di dati!');
    writeln;
    WaitReturn;
    exit;
  end;
  (* Input dei dati *)
  writeln;
  for i:= 1 to nc do begin
    writeln('Colonna #',i, ' Scegliere la serie da collegare');
    Spread.GetSerie(ch);
    if ch = #0 then exit;
    if i = 1 then begin
      nr:= Spread.Cols[ch]^.Count;
      A.Init(1,nr, nc);
    end
    else if Spread.Cols[ch]^.Count <> nr then begin
      writeln('Waring dati non uguali, risultati non garantiti!');
    end;
    for j:= 1 to nr do begin
      A.At(j, i)^:= Spread.Cols[ch]^.At(j)^;
    end;
  end;
  writeln;
  Med.Init(1,nc);
  Sca.Init(1,nc);
  for i:= 1 to nc do begin
    SmX:= 0;
    SmX2:= 0;
    for j:= 1 to nr do begin
      tmp:= A.At(j, i)^;
      SmX:= SmX + tmp;
      SmX2:= SmX2 + sqr(tmp);
    end;
    Med.At(i)^:= SmX / nr;
    Sca.At(i)^:= sqrt((SmX2 - sqr(SmX)/nr) / (nr-1));
  end;
  for i:= 1 to nr do begin
    for j:= 1 to nc do begin
      A.At(i,j)^:= (A.At(i,j)^ - Med.At(j)^) / Sca.At(j)^;
    end;
  end;
  Med.Done;
  Sca.Done;
  R.Init(1,nc, nc);
  (* R = A * A' *)
  for j:= 1 to nc do begin
    for i:= j to nc do begin
      SmX:= 0;
      for k:= 1 to nr do begin
        SmX:= SmX + A.At(k,j)^ * A.At(k,i)^;
      end;
      SmX:= SmX / (nr-1);
      R.At(j, i)^:= SmX;
      R.At(i, j)^:= SmX;
    end
  end;
  writeln;
  writeln('Matrice delle covarianze');
  R.Print('',0,0,0,0,0);
  WaitReturn;
  VL.Init(1,nc);
  VT.Init(1,nc,nc);
  (* calcola VT e VL *)
  for i:= 1 to nc do begin
    for j:= 1 to nc do begin
      if i = j then begin
        VL.At(i)^:= 1;
        VT.At(i,i)^:= 1;
      end
      else VT.At(i, j)^:= 0;
    end;
  end;
  S1:= 8;
  Z:= 2 * S1;
  T1:= exp(-(Z * ln(10)));
  RR:= 5 * sqr(nc);
  R1:= 0;
  T2:= 0.1;
  n1:= nc-1;
  (* rotazione, autovalori e autovettori R (R simmetrica reale)
    Metodo ciclico di Jacobi *)
  repeat
    X1:= 0;
    for k:= 1 to n1 do begin
      k1:= k + 1;
      for l:= k1 to nc do begin
        A1:= R.At(k, k)^;
        A2:= R.At(k, l)^;
        A3:= R.At(l, l)^;
        X:= sqr(A2) / (A1 * A3);
        if X > X1 then X1:= X;
        if X >= T2 then begin
          R1:= R1 + 1;
          if A1 <> A3 then begin
            Z:= 0.5 * (A1-A3)/A2;
            Z1:= 1 + 1 / sqr(Z);
            T:= -Z*(1+sqrt(Z1));
          end
          else T:= 1;
          C:= 1 / sqrt(1 + sqr(T));
          SS:= C * T;
          S2:= sqr(SS);
          C2:= sqr(C);
          R.At(k, l)^:= 0;
          A0:= 2 * A2 * C * SS;
          R.At(k, k)^:= A1 * C2 + A0 + A3 * S2;
          R.At(l, l)^:= A1 * S2 - A0 + A3 * C2;
          for i:= 1 to nc do begin
            if i < k then begin
              A0:= R.At(i,k)^;
              R.At(i,k)^:= C * A0 + SS * R.At(i,l)^;
              R.At(i,l)^:= C*R.At(i,l)^ - (SS * A0);
            end
            else if i > k then begin
              if i < l then begin
                A0:= R.At(k, i)^;
                R.At(k, i)^:= C * A0 + SS * R.At(i,l)^;
                R.At(i, l)^:= C * R.At(i,l)^ - (SS * A0)
              end
              else if i > l then begin
                A0:= R.At(k, i)^;
                R.At(k, i)^:= C * A0 + SS * R.At(l,i)^;
                R.At(l, i)^:= C * R.At(l, i)^ - (SS * A0);
              end;
            end;
          end;
          for i:= 1 to nc do begin
            U0:= VT.At(i, k)^;
            VT.At(i, k)^:= C * U0 + SS * VT.At(i, l)^;
            VT.At(i, l)^:= C * VT.AT(i, l)^ - SS * U0;
          end;
        end;
      end;
    end;
    if X < T1 then break;
    if R1 > RR then begin
      writeln;
      writeln(^G'Non si e'' riuscito a convergere agli autovalori/vettori');
      writeln;
      WaitReturn;
      exit;
    end;
    T2:= 0.1 * X1;
  until false;
  (* normalizza *)
  for i:= 1 to nc do begin
    for j:= 1 to nc do begin
      VT.At(i,j)^:= VT.At(i,j)^ * VL.At(i)^;
    end;
  end;
  for i:= 1 to nc do begin
    VL.At(i)^:= R.At(i,i)^;
  end;
  for i:= 1 to n1 do begin
    i1:= i + 1;
    z:= VL.At(i)^;
    M:= I;
    for j:= I1 to nc do begin
      if z > VL.At(j)^ then begin
        Z:= VL.At(j)^;
        m:= j;
      end;
    end;
    VL.At(m)^:= VL.At(i)^;
    Vl.At(I)^:= Z;
    for j:= 1 to nc do begin
      Z:= VT.At(j,i)^;
      VT.At(j, i)^:= VT.At(j, m)^;
      VT.At(j, m)^:= Z;
    end;
  end;
  i:= 0;
  writeln;
  writeln('Num.....Autovalore....Autovalore%....Cumulata.......');
  SmX:= 0;
  for j:= nc downto 1 do begin
    i:= i+1;
    tmp:= VL.At(j)^ / nc;
    SmX:= SmX + tmp;
    Writeln(i:5,'   ',VL.At(j)^:12:8,'   ',tmp:12:8,'   ',SmX:12:8,'   ');
  end;
  writeln;
  WaitReturn;
  (* calcola S *)
  S.Init(1,nc,nc);
  for i:= 1 to nc do begin
    tmp:= sqrt(VL.At(i)^);
    for j:= 1 to nc do begin
      S.At(j, i)^:= tmp * VT.At(j,i)^;
    end;
  end;
  writeln;
  Writeln('Matrice correlazi variabili originarie / componeti principali');
  S.Print('',0,0,0,0,0);
  writeln;
  WaitReturn;
  S.Done;
  writeln;
  GetChar('Voui "plottare" i campioni (S/N)?', ch);
  ch:= UpCase(ch);
  if ch <> 'N' then begin
    pt:= nc + 1;
    writeln('Scelta componenti principali sul cui spazion plottare i campioni');
    ca:= 1;
    cb:= 2;
    InputInt('Componente 1 (Asse X) = ', ca, 1, nc); ca:= pt - ca;
    InputInt('Componente 2 (Asse Y) = ', cb, 1, nc); cb:= pt - cb;
    DataX.Init(MaxData); DataY.Init(MaxData);
    for i:= 1 to nr do begin
      SmX:= 0; SmX2:= 0;
      for j:= 1 to nc do begin
        tmp:= A.At(i, j)^;
        SmX := SmX  + VT.At(j, ca)^ * tmp;
        SmX2:= SmX2 + VT.At(j, cb)^ * tmp;
      end;
      DataX.Append(SmX);
      DataY.Append(SmX2);
    end;
    Cht:= New(PScatChart, init);
    with PScatChart(Cht)^ do begin
      Title1:= 'Grafico dati';
      str(pt-ca, tmps1); str(pt-cb, tmps2);
      Title2:= '';
      TitleX:= 'Componente #'+tmps1;
      TitleY:= 'Componente #'+tmps2;
      Options:= BigDot + ShowXAx + ShowYAx + ShowAve;
      NumSer:= 1;
      NumDat:= nr;
      SerieX:= @DataX;
      SerieY[1]:= @DataY;
      Analyze;
      ValMinY:= aveY-3*sigY;
      ValMaxY:= aveY+3*sigY;
      Cht^.Run(nil);
    end;
  end;
  A.Done;
  R.Done;
  VT.Done;
  VL.Done;
end;

end.
