unit Elect2;

{$I switches.inc}

interface

uses MathTool;

type

  TVeto = record
    crit: integer;
    Min, MAX: PREC;
  end;

procedure Electra2Fase1;

implementation

uses Crt, Dos, Drivers, DataMngr, Matrix;

procedure Electra2Fase1;
var
  Z, G, S: TSMatrix;
  fn: PathStr;
  na: integer; (* numero azioni - 1 *)
  nc: integer; (* numero criteri - 1 *)
  i, j, k, v: integer;
  P: PREC;
  PpPu: PREC;
  PpPm: PREC;
  sc: PREC;
  ch: char;
  tmp: string;
  Jp,Ju,Jm: string;
  Pp,Pu,Pm: PREC;
  nv: integer;
  veto: integer;
  Veti: array[1..9] of TVeto;
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
  fn:= '';
  InputStr('FileName matrice di surclassamento di output: ',fn);
  writeln;
  writeln('Valore dei pesi prima della normalizzazione: ', 1/P:0:4);
  writeln;
  sc:= 0;
  InputPrec('Soglia di accettazione (P+ + P= >= c) c: ',sc,0,1);
  writeln;
  writeln('Modellizazione dei veti:');
  repeat
    InputInt('Quanti veti del tipo {criterio, {min,max} da escludere} (0..9): ',nv,0,9);
  until (nv >= 0) and (nv <= 9);
  if nv = 0 then begin
    GetChar('Immissione manuale dei veti (S,N)? ',ch);
    if (ch='S') then nv:= -1;
  end
  else begin
    for v:= 1 to nv do begin
      writeln;
      Writeln('Veto #',v);
      Veti[v].Crit:= 1; Veti[v].min:= 0; Veti[v].max:=0;
      InputInt('Criterio: ',Veti[v].Crit,1,nc); Veti[v].Crit:= Veti[v].Crit-1;
      InputPrec('Val.min : ',Veti[v].min,-inf,inf);
      InputPrec('Val.max : ',Veti[v].max,-inf,inf);
    end;
  end;
  S.Init(0,na,na);
  writeln;
  writeln('(a ,aø)|  J+(a ,aø)  |  J=(a ,aø)  |  J-(a ,aø)  |P+ +P=|P+/P- |Veto?|aSaø|');
  writeln('---------------------------------------------------------------------------');
  for i:= 0 to na-1 do begin
    for j:= 0 to na-1 do begin
      Pp:= 0; Jp:= '';
      Pu:= 0; Ju:= '';
      Pm:= 0; Jm:= '';
      if i= j then begin
        S.At(i,i)^:= 0;
        continue;
      end;
      write('(',i+1:2,',',j+1:2,')|');
      veto:= 0;
      for k:= 0 to nc-1 do begin
        str(k+1:2,tmp);
        tmp:= tmp+' '; if tmp[1] = ' ' then tmp:= copy(tmp,2,4);
        if G.At(k,i)^ > G.At(k, j)^ then begin
          Pp:= Pp + Z.At(k, 0)^;
          Jp:= Jp + tmp;
        end
        else if G.At(k,i)^ < G.At(k, j)^ then begin
          Pm:= Pm + Z.At(k, 0)^;
          Jm:= Jm + tmp;
          (* controlla se scatta il veto *)
          for v:= 1 to nv do begin
            with Veti[v] do begin
              if Crit = k then begin
                if (abs(G.At(k,i)^ - max) < Zero) and (abs(G.At(k,j)^ - min) < Zero) then veto:= 1;
                if (abs(G.At(k,i)^ - min) < Zero) and (abs(G.At(k,j)^ - max) < Zero) then veto:= 1;
              end;
            end;
          end;
        end
        else begin
          Pu:= Pu + Z.At(k, 0)^;
          Ju:= Ju + tmp;          
        end;
      end;
      if length(Jp) > 13 then Jp:= Copy(Jp,1,10) +' ..'
      else Jp:= Copy(Jp+'             ',1,13);
      if length(Ju) > 13 then Ju:= Copy(Ju,1,10) +' ..'
      else Ju:= Copy(Ju+'             ',1,13);
      if length(Jm) > 13 then Jm:= Copy(Jm,1,10) +' ..'
      else Jm:= Copy(Jm+'             ',1,13);
      PpPu:= Pp+Pu;
      if Pm < Zero then Pm:= Zero;
      PpPm:= Pp/Pm;
      write(Jp,'|',Ju,'|',Jm,'|',PpPu:6:4,'|',PpPm:6:3,'|');
      if nv = -1 then begin
        writeln;
        repeat
          GetChar('Veto (S/N)? ',ch);
          if ch = 'S' then veto:= 1
          else if ch = 'N' then veto:= 0
          else veto:= -1;
        until (veto=0) or (veto=1);
      end;
      write(veto:5,'|');
      if (PpPm > 1) and ((PpPm * (1-veto)) > sc) then S.At(i,j)^:= 1 else S.At(i,j)^:= 0;
      writeln(S.At(i,j)^:4:0,'|');
    end;
    WaitReturn;
  end;
  S.Print(fn,0,0,0,0,0);    
  Z.Done;
  G.Done;
  S.Done;
end;

end.
