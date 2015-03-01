unit Elect1;

{$I switches.inc}

interface

procedure Electra1Fase1;
procedure Electra1Fase2;

procedure Electra1Fase2bis;

implementation

uses Crt, Dos, Drivers, DataMngr, MathTool, Matrix, MatrMath;

procedure Electra1Fase1;
type 
  TVeto = record
    crit: integer;
    Min, MAX: PREC;
  end;
var
  Z, G, c, D: TSMatrix;
  dd: TSVector;
  fn: PathStr;
  na: integer; (* numero azioni - 1 *)
  nc: integer; (* numero criteri - 1 *)
  i, j, k: integer;
  P: PREC;
  sp,sq: PREC;
  tmp: string;
  dt: PREC;
  Jc,Jd: string;
  Pc,Pd: PREC;
  nv: integer;
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
    Z.At(i,0)^:= Z.At(i,0)^ * P;
  end;
  writeln;
  writeln('Valore dei pesi prima della normalizzazione: ', 1/P:0:4);
  writeln;
  sp:= 0; sq:= 0;
  InputPrec('Soglia di accettazione (c(a,aø) >= c)     p: ',sp,-inf,inf);
  InputPrec('Soglia di non/accettazione (d(a,aø) <= c) q: ',sq,-inf,inf);
  writeln;

  c.Init(0,na,na);
  D.Init(0,na,na);
  dd.Init(0,nc);
  for k:= 0 to nc-1 do begin
    dd.At(k)^:= 0;
    for i:= 0 to na-1 do begin
      for j:= 0 to na-1 do begin
        if abs(G.At(k,i)^-G.At(k,j)^) > dd.At(k)^ then dd.At(k)^:= abs(G.At(k,i)^-G.At(k,j)^);
      end;
    end;
    if dd.At(k)^ < Zero then dd.At(k)^:= 1;
  end;
  writeln;
  writeln('valori di d[j]');
  write('d = [');
  for k:= 0 to nc-1 do begin
    write(dd.At(k)^:9:3,' ');
  end;
  writeln(']');
  writeln;
  writeln('(a ,aø)|  JC(a ,aø)  |  JD(a ,aø)  |  c(a ,aø) | d(a ,aø) |S1,0 |Sp,q|');
  writeln('----------------------------------------------------------------------');
  for i:= 0 to na-1 do begin
    for j:= 0 to na-1 do begin
      Pc:= 0; Jc:= '';
      Pd:= 0; Jd:= '';
      if i= j then begin
        c.At(i,i)^:= 0;
        d.At(i,i)^:= 0;
        continue;
      end;
      write('(',i+1:2,',',j+1:2,')|');
      for k:= 0 to nc-1 do begin
        str(k+1:2,tmp);
        tmp:= tmp+' '; if tmp[1] = ' ' then tmp:= copy(tmp,2,4);
        if G.At(k,i)^ >= G.At(k, j)^ then begin
          Pc:= Pc + Z.At(k, 0)^;
          Jc:= Jc + tmp;
        end
        else begin
          Pd:= Pd + Z.At(k, 0)^;
          Jd:= Jd + tmp;
        end;
      end;
      if length(Jc) > 13 then Jc:= Copy(Jc,1,10) +' ..'
      else Jc:= Copy(Jc+'             ',1,13);
      if length(Jd) > 13 then Jd:= Copy(Jd,1,10) +' ..'
      else Jd:= Copy(Jd+'             ',1,13);
      c.At(i,j)^:= Pc;
      d.At(i,j)^:= 0;
      if Pd > Zero then begin
        for k:= 0 to nc-1 do begin
          dt:= G.At(k,i)^ - G.At(k,j)^; if dt >= 0 then dt:= 0 else dt:= -dt;
          if abs(dt/dd.At(k)^) > d.At(i,j)^ then d.At(i,j)^:= abs(dt/dd.At(k)^);
        end;
      end;
      write(Jc,'|',Jd,'|',c.At(i,j)^:10:5,'|',d.At(i,j)^:10:5,'|');
      if (c.At(i,j)^ >=  1) and (d.At(i,j)^ <=  0) then write('  1  |') else write('  0  |');
      if (c.At(i,j)^ >= sp) and (d.At(i,j)^ <= sq) then write('  1  |') else write('  0  |');
      writeln;
    end;
    WaitReturn;
  end;
  writeln;
  fn:= '';
  InputStr('FileName matrice di concordanza di output: ',fn);
  c.Print(fn,0,0,0,0,0);
  writeln;
  fn:= '';
  InputStr('FileName matrice di disconcordanza di output: ', fn);
  d.Print(fn,0,0,0,0,0);
  c.Done;
  d.Done;
  dd.Done;
  Z.Done;
  G.Done;
end;

function CheckCircuiti(var s: TSMatrix): integer;
var 
  t: TSMatrix;
  i,j: integer;
begin
  for i:= 0 to S.Rows-1 do S.At(i,i)^:= 0;
  t.Init(0,S.Rows,S.Cols);
  SMatMul(t,s,s);
  CheckCircuiti:= 1;
  for j:= 0 to S.Rows-1 do begin
    if t.At(j,j)^>0 then exit;
  end;
  for i:= 2 to S.Rows do begin
    CheckCircuiti:= i;
    SMatMul(t,t,s);
    for j:= 0 to S.Rows-1 do begin
      if t.At(j,j)^>0 then exit;
    end;
  end;
  CheckCircuiti:= 0;  
end;

procedure Electra1Fase2;
var
  S: TSMatrix;
  fn: PathStr;
  tmp: integer;
  i, j, k, n: integer;
  az: TIVector;
begin
  ClrScr;
  writeln('Creazione matrice concordaza e discordanza azioni. (Elettra 3 - Fase 1)');
  Exec(GetEnv('COMSPEC'),'/C dir *.dat /w');
  writeln;
  fn:= '';
  InputStr('Quale matrice di valutazioni (X= immissione diretta): ',fn);
  if fn ='' then exit;
  if (fn='x') or (fn='X') then fn:= '';
  S.Load(fn);
  if S.Rows <> S.Cols then begin
    writeln;
    writeln('Matrice non quadrata!!!!!!');
    writeln;
    WaitReturn;
    exit;
  end;
  tmp:= CheckCircuiti(s);
  if tmp <> 0then begin
    writeln;
    writeln('Ci sono circuiti di ordine ',tmp,' non posso proseguire');
    writeln;
    WaitReturn;
    exit;
  end;
  writeln;
{
  (* Rende la matrice simmetrica e di 0, 1*)
  for i:= 0 to s.row do begin
    for j:= 0 to s.row do begin
      if j < i then continue;
      if i = j then begin
        S.At(i,i)^:= 0;
        continue;
      end;
      if (abs(S.At(i,j)^)> 0) or (abs(S.At(j,i)^)> 0)  then begin
        S.At(i, j)^:= 1;
        S.At(j, i)^:= 1;
      end
      else begin
        S.At(i, j)^:= 0;
        S.At(j, i)^:= 0;
      end;
    end;
  end;
}
  write('Nucleo = {');
  Az.Init(0,S.Rows);
  for i:= 0 to S.Rows-1 do az.At(i)^:= 1;
  n:= 0;
  while n < S.Rows do begin
    for i:= 0 to S.Rows-1 do begin
      if az.At(i)^ = 0 then continue; (* Azione gia' esaminata *)
      tmp:= 0;
      for j:= 0 to S.Rows-1 do begin
        if i = j then continue;
        if S.At(j,i)^ <> 0 then tmp:= 1;
      end;
      if tmp = 0 then begin
        write(i+1,',');
        inc(n);
        az.At(i)^:= 0;
        for j:= 0 to S.Rows-1 do begin
          if i = j then continue;
          if S.At(i,j)^ <> 0 then begin   (* azioni dominate eliminate *)
            Az.At(j)^:= 0;
            S.At(i,j)^:= 0; (* toglie le azioni che dominava *)
            inc(n);
          end;
        end;
        break;
      end;
    end;
  end;
  writeln(#8'}');
  writeln;
  WaitReturn;
  Az.Done;
  S.Done;
end;

procedure Electra1Fase2bis;
var
  S: TSMatrix;
  fn: PathStr;
  flg, tmp: integer;
  ii, i, j, k, n: integer;
  az: TIVector;
begin
  ClrScr;
  writeln('Creazione matrice concordaza e discordanza azioni. (Elettra 3 - Fase 1)');
  Exec(GetEnv('COMSPEC'),'/C dir *.dat /w');
  writeln;
  fn:= '';
  InputStr('Quale matrice di valutazioni (X= immissione diretta): ',fn);
  if fn ='' then exit;
  if (fn='x') or (fn='X') then fn:= '';
  S.Load(fn);
  if S.Rows <> S.Cols then begin
    writeln;
    writeln('Matrice non quadrata!!!!!!');
    writeln;
    WaitReturn;
    exit;
  end;
  tmp:= CheckCircuiti(s);
  if tmp <> 0 then begin
    writeln;
    writeln('Ci sono circuiti di ordine ',tmp,' non posso proseguire');
    writeln;
    WaitReturn;
    exit;
  end;
  writeln;
{
  (* Rende la matrice simmetrica e di 0, 1*)
  for i:= 0 to s.row do begin
    for j:= 0 to s.row do begin
      if j < i then continue;
      if i = j then begin
        S.At(i,i)^:= 0;
        continue;
      end;
      if (abs(S.At(i,j)^)> 0) or (abs(S.At(j,i)^)> 0)  then begin
        S.At(i, j)^:= 1;
        S.At(j, i)^:= 1;
      end
      else begin
        S.At(i, j)^:= 0;
        S.At(j, i)^:= 0;
      end;
    end;
  end;
}
  write('Nucleo = {');
  Az.Init(0,S.Rows);
  for i:= 0 to S.Rows-1 do az.At(i)^:= 1;
  n:= 0;
  while n < S.Rows do begin
    for i:= 0 to S.Rows-1 do begin
      if az.At(i)^ = 0 then continue; (* Azione gia' esaminata *)
      tmp:= 0;
      for j:= 0 to S.Rows-1 do begin
        if i = j then continue;
        if S.At(j,i)^ <> 0 then tmp:= 1;
      end;
      if tmp = 0 then begin
        write(i+1,',');
        inc(n);
        az.At(i)^:= 0;
        for j:= 0 to S.Rows-1 do begin
          if i = j then continue;
          if S.At(i,j)^ <> 0 then begin   (* azioni dominate eliminate *)
            Az.At(j)^:= -1;
            S.At(i,j)^:= 0; (* toglie le azioni che dominava *)
            inc(n);
          end;
        end;
        flg:= 1;
        while flg = 1 do begin
          flg:= 0;        
          for ii:= 0 to  S.Rows-1 do begin
            if Az.At(i)^=-1 then begin
              flg:= 1;
              az.At(i)^:= 0;
              for j:= 0 to S.Rows-1 do begin
                if ii = j then continue;
                if S.At(ii, j)^ <> 0 then begin   (* azioni dominate eliminate *)
                  Az.At(j)^:= -1;
                  S.At(j,k)^:= 0; (* toglie le azioni che dominava *)
                  inc(n);
                end;
              end;
            end;
          end;
        end;
        break;
      end;
    end;
  end;
  writeln(#8'}');
  writeln;
  WaitReturn;
  Az.Done;
  S.Done;
end;
        
end.
