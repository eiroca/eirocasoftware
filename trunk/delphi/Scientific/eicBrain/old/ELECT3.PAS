unit Elect3;

{$I switches.inc}

interface

procedure Electra3Fase1;
procedure Electra3Fase2;

procedure MakeScd;

implementation

uses Crt, Dos, Drivers, Matrix, DataMngr, MathTool;

procedure MakeScd;
var 
  S: TSMatrix;
  c: array[0..9] of TSMatrix;
  D: array[1..9] of TSMatrix;
  nc, nd: integer;
  rr, cc: integer;
  i,j,k: integer;
  Peso: array[0..9] of PREC;
  fn: PathStr;
  flg: boolean;
  tmp: PREC;
begin
  ClrScr;
  Exec(GetEnv('COMSPEC'),'/C dir *.dat /w');
  writeln;
  nc:= 1;
  InputInt('Quante matrici di concordaza vuoi usare (1..9): ',nc,1,9);
  if (nc < 1) or (nc > 9) then begin
    writeln;
    writeln('Ops, o troppe o troppe poche matrici!');
    writeln;
    WaitReturn;
    exit;
  end;
  Peso[0]:= 0;
  for i:= 1 to nc do begin
    fn:= '';
    write('Nome matrice concordanza #',i,' (x= immissione diretta): ');
    InputStr('',fn);
    if fn ='' then exit;
    if (fn='x') or (fn='X') then fn:= '';
    c[i].Load(fn);
    write('Peso della matrice di concordanza #',i);
    Peso[i]:= 1;
    InputPrec('',Peso[i],-inf,inf);
    Peso[0]:= Peso[0] + Peso[i];
  end;
  rr:= c[1].Rows;
  cc:= c[1].Cols;
  if rr <> cc then begin
    writeln('le matrici devono essere quadrate!!');
    WaitReturn;
    exit;
  end;
  c[0].Init(0,rr,cc);
  for i:= 1 to nc do begin
    Peso[i]:= Peso[i] / Peso[0]; (* Normalizza i pesi *)
    if (c[i].Rows <> rr) or (c[i].Cols <> cc) then begin
      writeln('Le matrici di concordanza non sono compatibili!');
      WaitReturn;
      exit;
    end;
  end;
  for i:= 0 to rr-1 do begin
    for j:= 0 to cc-1 do begin
      c[0].At(i,j)^:= 0;
    end;
  end;
  for i:= 0 to rr-1 do begin
    for j:= 0 to cc-1 do begin
      for k:= 1 to nc do begin
        c[0].At(i,j)^:= c[0].At(i,j)^ + c[k].At(i,j)^ * Peso[k];
      end;
    end;
  end;
  writeln;
  nd:= 1;
  InputInt('Quante matrici di disconcordaza vuoi usare (1..9): ',nd,1,9);
  if (nd < 1) or (nd > 9) then begin
    writeln;
    writeln('Ops, o troppe o troppe poche matrici!');
    writeln;
    WaitReturn;
  end;
  for i:= 1 to nd do begin
    write('Nome matrice disconcordanza #',i,' (x= immissione diretta): ');
    fn:= '';
    InputStr('',fn);
    if fn ='' then exit;
    if (fn='x') or (fn='X') then fn:= '';
    D[i].Load(fn);
    if (D[i].Rows <> rr) or (D[i].Cols <> cc) then begin
      writeln('Matrici non compatibili');
      WaitReturn;
    end;
  end;
  S.Init(0,rr,cc);
  for i:= 0 to rr-1 do begin
    for j:= 0 to cc-1 do begin
      S.At(i,j)^:= 0;
    end;
  end;           
  for i:= 0 to rr-1 do begin
    for j:= 0 to cc-1 do begin
      flg:= false;
      tmp:= 1;
      for k:= 1 to nd do begin
        if D[k].At(i,j)^ >= c[0].At(i,j)^ then begin
          tmp:= tmp * (1-D[k].At(i,j)^);
          flg:= true;
        end;
      end;
      if flg then S.At(i,j)^:= c[0].At(i,j)^ * tmp / (1-c[0].At(i,j)^)
      else S.At(i,j)^:= c[0].At(i,j)^;
    end;
  end;
  writeln;
  fn:= '';
  InputStr('Filename della matrice di surclassamento di output: ',fn);
  S.Print(fn,0,0,0,0,0);
  S.Done;
  for i:= 0 to nc do c[i].Done;
  for i:= 1 to nd do D[i].Done;
end;

procedure Electra3Fase1;
var
  G, Z: TSMatrix;
  fn: PathStr;
  na: integer; (* numero azioni - 1 *)
  nc: integer; (* numero criteri - 1 *)
  i, j: integer;
  k: longint;
  P, tmp1,
  sss, ss, sq, sv: PREC;
  ass, as, aq, av: PREC;
  C,D: TSMatrix;
begin
  ClrScr;
  writeln('Creazione matrice concordaza e discordanza azioni. (Elettra 3 - Fase 1)');
  Exec(GetEnv('COMSPEC'),'/C dir *.dat /w');
  writeln;
  fn:= '';
  InputStr('Quale matrice di valutazioni (X= immissione diretta): ',fn);
  if fn ='' then exit;
  if (fn='x') or (fn='X') then fn:= '';
  Z.Load(fn);
  nc:= Z.Rows; na:= Z.Cols-2;
  G.Init(0,nc,na);
  if (na < 2) or (nc<1) then begin
    writeln;
    writeln('Almeno due azioni e un criterio!');
    writeln;
    WaitReturn;
    exit;
  end;
  (* modifica i criteri al fine di averli tutti crescenti *)
  (* Normalizza i pesi dei singoli criteri di valutazione *)
  P:= 0;
  for i:= 0 to nc-1 do begin
    P:= P + Z.At(i, 0)^;
    for j:= 1 to na do begin
      G.At(i,j-1)^:= Z.At(i,j)^ * Z.At(i, na+1)^;
    end;
  end;
  P:= 1/P;
  for i:= 0 to nc-1 do begin
    Z.At(i, 0)^:= Z.At(i, 0)^ * P;
  end;
  writeln('Le matrici di concordanza/dirscordanza verranno salvata con i nomi');
  write('Mat_c_??.dat   e    Mat_D_??.dat.  RETURN per proseguire altro interrompe: ');
  fn:= '';
  InputStr('',fn);
  if (fn <> '') then exit;
  C.Init(0,na,na);
  D.Init(0,na,na);
  for k:= 0 to nc-1 do begin
    writeln('Esamino il criterio #',k+1);
    writeln;
    sq:= 1; ss:= 1; sss:=1; sv:= 1;
    InputPrec('Soglia di indifferenza (% di g[i](a))  q: ',sq,-inf,inf); sq:= sq * 0.01;
    InputPrec('Soglia di preferenza   (% di g[i](a))  s: ',ss,-inf,inf); ss:= ss * 0.01;
    InputPrec('Soglia di preferenza 2 i nd   (% di g[i](a))  s: ',sss,-inf,inf); sss:= sss * 0.01;
    InputPrec('Soglia di veto         (% di g[i](a))  v: ',sv,-inf,inf); sv:= sv * 0.01;
    writeln;
    for i:= 0 to na-1 do begin
      writeln('Esamino l''azione #',i+1);
      as:= G.At(k, i)^ * (1-ss);
      ass:= G.At(k, i)^ * (1-sss);
      aq:= G.At(k, i)^ * (1-sq);
      av:= G.At(k, i)^ * (1-sv);
      for j:= 0 to na-1 do begin
        if i=j then begin
          C.At(i,i)^:= 0;
          D.At(i,i)^:= 0;
          continue; (* Non confrontarla con se stessa *)
        end;
        tmp1:= G.At(k,j)^;
        if G.At(k,j)^ >= aq then C.At(i,j)^:= 1          (* indifferente *)
        else if G.At(k,j)^ < as then C.At(i,j)^:= 0     (* peggiore     *)
        else C.At(i,j)^:= (G.At(k,j)^ - as) / (aq-as);  (* cosi'/cosi'  *)
        if G.At(k,j)^ < av then D.At(i,j)^:= 1          (* veto         *)
        else if G.At(k,j)^ > ass then D.At(i,j)^:= 0     (* va bene      *)
        else D.At(i,j)^:= (G.At(k,j)^ - av) / (ass-av);  (* cosi'/cosi'  *)
        writeln('Azione ',i+1,' contro ',j+1,' c() = ',C.At(i,j)^:8:5,' D() = ',D.At(i,j)^:8:5);
      end;
      WaitReturn;
    end;
    writeln('Scrivo risultati...');
    FormatStr(fn, 'Mat_c_%02d', k);
    c.Print(fn,0,0,0,0,0);
    FormatStr(fn, 'Mat_D_%02d', k);
    D.Print(fn,0,0,0,0,0);
  end;
  writeln;
  writeln('Tutto Ok si puo'' procedere a riunire le matrici con MakeScD');
  writeln;
  WaitReturn;
  Z.Done;
  G.Done;
end;

procedure CalcSol0(var S: TSMatrix; var Sol0, SolDis: PREC; var V: TIVector);
var n, i, j: integer;
begin
  n:= S.Rows-1;
  (* Calcolo di ë0, ë0'=ë0-SolDis, ë1 *)
  Sol0:= 0;
  for i:= 0 to n do begin
    if V.At(i)^ = 0 then continue; (* Azione gia' distillata *)
    for j:= 0 to n do begin
      if V.At(j)^ = 0 then continue; (* Azione gia' distillata *)
      if i=j then continue;
      if S.At(i,j)^> Sol0 then Sol0:= S.At(i,j)^;
    end;
  end;
end;

procedure CalcSol1(var S: TSMatrix; var Sol0, Sol1, SolDis: PREC; var V: TIVector);
var n, i, j: integer;
begin
  n:= S.Rows-1;
  (* Calcolo di ë0, ë0'=ë0-SolDis, ë1 *)
  Sol1:= 0;
  for i:= 0 to n do begin
    if V.At(i)^ = 0 then continue; (* Azione gia' distillata *)
    for j:= 0 to n do begin
      if V.At(j)^ = 0 then continue; (* Azione gia' distillata *)
      if i=j then continue;
      if (S.At(i,j)^ < Sol0-SolDis) and (S.At(i,j)^ > Sol1) then Sol1:= S.At(i,j)^;
    end;
  end;
end;

procedure CalcPD(var S: TSMatrix; var Sol0, Sol1, SolDis: PREC; var V, P, D: TIVector);
var n, i, j: integer;
begin
  n:= S.Rows-1;
  (* calcolo della potenza delle azioni *)
  for i:= 0 to n do begin
    if V.At(i)^ = 0 then continue; (* Azione gia' distillata *)
    p.At(i)^:= 0;
    for j:= 0 to n do begin
      if V.At(j)^ = 0 then continue; (* Azione gia' distillata *)
      if i=j then continue; (* diagonale *)
      if (S.At(i, j)^ > Sol1) and (abs(S.At(i,j)^-S.At(j,i)^) > SolDis) then begin
        inc(p.At(i)^);
      end;
    end;
  end;
  (* calcolo della debolezza delle azioni *)
  for j:= 0 to n do begin
    if V.At(j)^ = 0 then continue; (* Azione gia' distillata *)
    d.At(j)^:= 0;
    for i:= 0 to n do begin
      if V.At(i)^ = 0 then continue; (* Azione gia' distillata *)
      if i=j then continue; (* diagonale *)
      if (S.At(i, j)^ > Sol1) and (abs(S.At(i,j)^-S.At(j,i)^) > SolDis) then begin
        inc(d.At(j)^);
      end;
    end;
  end;
end;

procedure CalcQ(alto: boolean; var S: TSMatrix; var Sol0, Sol1, SolDis: PREC; var V, P, D, Q: TIVector; var qm: TInt);
var 
  flg: boolean;
  n, i, j: integer;
begin
  n:= S.Rows-1;
  (* calcolo della ë-qualificazione *)
  flg:= false;
  for i:= 0 to n do begin
    if V.At(i)^ = 0 then continue;
    q.At(i)^:= p.At(i)^-d.At(i)^;
    if flg then begin
      if alto then begin
        if q.At(i)^ > qm then qm:= q.At(i)^;
      end
      else begin
        if q.At(i)^ < qm then qm:= q.At(i)^;
      end;
    end
    else begin 
      qm:= q.At(i)^;
      flg:= true;
    end;
  end;
end;

procedure WriteR(var S: TSMatrix; var Sol0, Sol1, SolDis: PREC; var V, P, D, Q: TIVector; var qm, cnt: TInt);
var 
  n, i, j: integer;
begin
  n:= S.Rows-1;
  (* Stampa/conta le azioni *)
  writeln('AzioneXXX pot deb  ë-q ');
  cnt:= 0;
  for i:= 0 to n do begin
    if V.At(i)^ <> 0 then begin
      write('Azione',i+1:3,' ',P.At(i)^:3,' ',D.At(i)^:3,' ',Q.At(i)^:5);
      if Q.At(i)^= qm then begin
        writeln(' *');
        inc(cnt);
      end
      else writeln;
    end;
  end;
  writeln;
  WaitReturn;
end;

procedure Electra3Fase2;
var 
  S : TSMatrix; (* Matrice di surclassamento sfumato *)
  V, V2,         (* Elenco delle variabili ancora da distillare *)
  P,D,           (* potenza, debolezza dell'azione in esame *)
  Q,             (* ë-qualificazioni delle varie azioni *)
  Cp,Cm          (* preordien dall'alto e dal basso *)
  : TIVector;
  fn: PathStr;
  ni, nii : integer;   (* numero di distillazione *)
  na : integer;   (* numero di azioni ancora da discriminare *)
  i : integer;
  n : integer;   (* numero di azioni *)
  SolDis: PREC;
  Sol0, Sol1: PREC;
  SolA, SolB: PREC;
  qm: integer; (* ë-qualifizazione massima/minima *)
  cnt: integer;
begin
  ClrScr;
  Exec(GetEnv('COMSPEC'),'/C dir *.dat /w');
  writeln;
  writeln('Nome matrice di surclassamento (x= immissione diretta): ');
  fn:= '';
  InputStr('',fn);
  if fn ='' then exit;
  if (fn='x') or (fn='X') then fn:= '';
  S.Load(fn);
  if S.Rows<>S.Cols then begin
    writeln('Errore la matrice di surclassamento DEVE essere quadrata');
    WaitReturn;
    S.Done;
    exit;
  end;
  writeln;
  SolDis:= 0;
  InputPrec('Soglia di discriminazione (0.10 - 0.15): ',SolDis,0,inf);
  n:= S.Rows-1;
  V.Init(0,n+1);
  V2.Init(0,n+1);
  P.Init(0,n+1);
  D.Init(0,n+1);
  Q.Init(0,n+1);
  Cp.Init(0,n+1);
  Cm.Init(0,n+1);
  for i:= 0 to n do begin
    S.At(i,i)^:= 0; (* forza a zero la diagonale *)
    V.At(i)^:= 1;   (* tutte le azioni sono da distillare *)
    Cp.At(i)^:= 0;  (* non hai ancora fatto preordini *)
    Cm.At(i)^:= 0;
  end;

  writeln('preordine dall''alto');
  ni:= 0;
  na:= n+1;
  repeat
    inc(ni);
    CalcSol0(S, Sol0, SolDis, V);
    CalcSol1(S, Sol0, Sol1, SolDis, V);
    writeln('Iterazione #',ni:3,' ë0 = ',Sol0:0:2,' ë0''= ',(Sol0-SolDis):0:2,' ë1= ',Sol1:0:2);
    CalcPD(S, Sol0, Sol1, SolDis, V, P, D);
    CalcQ(true, S, Sol0, Sol1, SolDis, V, P, D, Q, qm);
    WriteR(S, Sol0, Sol1, SolDis, V, P, D, Q, qm, cnt);
    if (cnt = 1) then begin
      write('Insieme C+',ni,' = {');
      for i:= 0 to n do begin
        if (V.At(i)^ <> 0) and ((Q.At(i)^ = qm) or (Sol1 = 0)) then begin
          write('Azione',i+1,',');
          V.At(i)^:= 0;
          Cp.At(i)^:= ni;
          dec(na); (* un azione distillata *)
          break;
        end;
      end;
      writeln(#8,'}');
      writeln;
      WaitReturn;
    end
    else if (Sol1 = 0) then begin
      write('Insieme C+',ni,' = {');
      for i:= 0 to n do begin
        if (V.At(i)^ <> 0) then begin
          write('Azione',i+1,',');
          V.At(i)^:= 0;
          Cp.At(i)^:= ni;
          dec(na); (* un azione distillata *)
        end;
      end;
      writeln(#8,'}');
      writeln;
      WaitReturn;
    end
    else begin
      nii:= 0;
      writeln(cnt,' azioni da discriminare');
      for i:= 0 to n do begin
        if (V.At(i)^ <> 0) and (Q.At(i)^ = qm) then begin
          writeln('Azione',i+1,' da esaminare');
          V2.At(i)^:= 1;
        end
        else V2.At(i)^:= 0;
      end;
      SolB:= Sol1;
      repeat
        inc(nii);
        SolA:= SolB;
        CalcSol1(S, SolA, SolB, SolDis, V2);
        writeln('Iterazione #',ni:3,'-',nii,' ë0 = ',SolA:0:2,' ë0''= ',(SolA-SolDis):0:2,' ë1= ',SolB:0:2);
        CalcPD(S, SolA, SolB, SolDis, V2, P, D);
        CalcQ(true, S, SolA, SolB, SolDis, V2, P, D, Q, qm);
        WriteR(S, SolA, SolB, SolDis, V2, P, D, Q, qm, cnt);
        if (SolA = 0) or (cnt = 1) then begin
          write('Insieme C+',ni,' = {');
          for i:= 0 to n do begin
            if (V2.At(i)^ <> 0) and ((Q.At(i)^ = qm) or (SolA = 0)) then begin
              write('Azione',i+1,',');
              V.At(i)^:= 0;
              Cp.At(i)^:= ni;
              dec(na);
            end;
          end;
          writeln(#8,'}');
          writeln;
          WaitReturn;
          break;
        end
        else begin
          writeln(cnt,' azioni da discriminare');
          for i:= 0 to n do begin
            if (V2.At(i)^ <> 0) and (Q.At(i)^ = qm) then begin
              writeln('Azione',i+1,' da esaminare');
              V2.At(i)^:= 1;
            end
            else V2.At(i)^:= 0;
          end;
        end;
      until false;
    end;      
  until na < 1;
  writeln;
  writeln('Riepilogo preordine dall''alto');
  write('ranghi:');
  for i:= 0 to n do begin
    write(' ',Cp.At(i)^:2);
  end;
  writeln;
  WaitReturn;

  writeln;
  for i:= 0 to n do begin
    V.At(i)^:= 1;   (* tutte le azioni sono da distillare *)
  end;
  writeln('preordine dal basso');
  ni:= 0;
  na:= n+1;
  repeat
    inc(ni);
    CalcSol0(S, Sol0, SolDis, V);
    CalcSol1(S, Sol0, Sol1, SolDis, V);
    writeln('Iterazione #',ni:3,' ë0 = ',Sol0:0:2,' ë0''= ',(Sol0-SolDis):0:2,' ë1= ',Sol1:0:2);
    CalcPD(S, Sol0, Sol1, SolDis, V, P, D);
    CalcQ(false, S, Sol0, Sol1, SolDis, V, P, D, Q, qm);
    WriteR(S, Sol0, Sol1, SolDis, V, P, D, Q, qm, cnt);
    if (cnt = 1) then begin
      write('Insieme C-',ni,' = {');
      for i:= 0 to n do begin
        if (V.At(i)^ <> 0) and (Q.At(i)^ = qm) then begin
          write('Azione',i+1,',');
          V.At(i)^:= 0;
          Cm.At(i)^:= ni;
          dec(na); (* un azione distillata *)
          break;
        end;
      end;
      writeln(#8,'}');
      writeln;
      WaitReturn;
    end
    else if (Sol1 = 0) then begin
      write('Insieme C-',ni,' = {');
      for i:= 0 to n do begin
        if (V.At(i)^ <> 0) then begin
          write('Azione',i+1,',');
          V.At(i)^:= 0;
          Cm.At(i)^:= ni;
          dec(na); (* un azione distillata *)
        end;
      end;
      writeln(#8,'}');
      writeln;
      WaitReturn;
    end
    else begin
      nii:= 0;
      writeln(cnt,' azioni da discriminare');
      for i:= 0 to n do begin
        if (V.At(i)^ <> 0) and (Q.At(i)^ = qm) then begin
          writeln('Azione',i+1,' da esaminare');
          V2.At(i)^:= 1;
        end
        else V2.At(i)^:= 0;
      end;
      SolB:= Sol1;
      repeat
        inc(nii);
        SolA:= SolB;
        CalcSol1(S, SolA, SolB, SolDis, V2);
        writeln('Iterazione #',ni:3,'-',nii,' ë0 = ',SolA:0:2,' ë0''= ',(SolA-SolDis):0:2,' ë1= ',SolB:0:2);
        CalcPD(S, SolA, SolB, SolDis, V2, P, D);
        CalcQ(false, S, SolA, SolB, SolDis, V2, P, D, Q, qm);
        WriteR(S, SolA, SolB, SolDis, V2, P, D, Q, qm, cnt);
        if (SolA = 0) or (cnt = 1) then begin
          write('Insieme C-',ni,' = {');
          for i:= 0 to n do begin
            if (V2.At(i)^ <> 0) and ((Q.At(i)^ = qm) or (SolA = 0)) then begin
              write('Azione',i+1,',');
              V.At(i)^:= 0;
              Cm.At(i)^:= ni;
              dec(na);
            end;
          end;
          writeln(#8,'}');
          writeln;
          WaitReturn;
          break;
        end
        else begin
          writeln(cnt,' azioni da discriminare');
          for i:= 0 to n do begin
            if (V2.At(i)^ <> 0) and (Q.At(i)^ = qm) then begin
              writeln('Azione',i+1,' da esaminare');
              V2.At(i)^:= 1;
            end
            else V2.At(i)^:= 0;
          end;
        end;
      until false;
    end;     
  until na < 1;
  (* corregge i ranghi affinche l'azione migliore abbia il numero 1 *)
  for i:= 0 to n do begin
    Cm.At(i)^:= ni-Cm.At(i)^+1;
  end;
  writeln;
  writeln('Riepilogo preordine dal basso');
  write('ranghi:');
  for i:= 0 to n do begin
    write(' ',Cm.At(i)^:2);
  end;
  writeln;

  writeln;
  WaitReturn;

  S.Done;
  V.Done;
  V2.Done;
  P.Done;
  D.Done;
  Q.Done;
  Cp.Done;
  Cm.Done;
end;

end.
