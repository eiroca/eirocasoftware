{$I switches.inc}

{ UNDEF UNIT}

{$IFDEF UNIT}
unit MenuIpot;

interface

uses DataMngr;

procedure MenuTestStatistici(var Spread: TSpread);

implementation

uses MathTool, MathStat, MathStt1, Matrix, Crt;
{$ELSE}

uses MathTool, MathStat, MathStt1, DataMngr, Matrix, Crt;

{$ENDIF}

procedure GetFiducia(var alpha: PREC; var kind: char);
begin
  alpha:= 5;
  repeat
    InputPrec('Livello di fiducia (א) in % = ',alpha,0,100);
    alpha:= alpha * 0.01;
  until (alpha >= ZERO) and (alpha <= 1 - ZERO);
  repeat
    writeln;
    writeln('Selezionare il tipo di test/intervallo voluto');
    writeln;
    writeln('1. Bilaterale,              ipotesi alternativa י^ <> י0');
    writeln('2. Monolaterale inferiore,  ipotesi alternativa י^  ע י0');
    writeln('3. Monolaterale superiore,  ipotesi alternativa י^  ף י0');
    writeln;
    GetChar('Quale? ',kind);
  until (kind in ['1'..'3']);
  if kind = '1' then alpha:= alpha * 0.5;
end;

procedure TestMedia(var Campione: TSerie; cheat: boolean);
var 
  ave, sig: PREC;
  alpha, alca: PREC;
  fat1, fat2: PREC;
  li, ls : PREC;
  mu0,xcalc : PREC;
  mua, beta: PREC;
  signota: boolean;
  n: integer;
  kind, car: char;
  tip, st, ns: string;
begin
  ClrScr;
  writeln('Intervallo della MEDIA e test attinenti');
  writeln('                                _  ');
  writeln('ATTENZIONE!!!  con ז^ si indica x, val. medio campione = stima media popol.');
  writeln;
  if cheat then begin
    ave:= 0; sig:= 1; n:= 1;
    InputPrec('Media            = ',ave,-inf,inf);
    InputPrec('scarto tipo      = ',sig,0,inf);
    InputInt ('numero campioni  = ',n,1,maxint);
    repeat
      GetChar('scarto noto (S/N)? ',car);
    until car in ['S','N'];
    signota:= car='S';
  end
  else begin
    CalcAveVar(Campione, ave, sig, true);
    n:= Campione.Count;
    writeln;
    GetChar('Conosci esattamente lo scarto della popolazione (S/N)? ',car);
    writeln;
    if upcase(car) = 'S' then begin
      writeln('Scarto tipo popolazione (dal campione = ',sig:0:4,')');
      InputPrec(' = ',sig,0,inf);
      writeln;
      signota:= true;
    end
    else signota:= false;
  end;
  writeln;
  writeln('numerosita'' campione = ', n);
  writeln('Media campione       = ', ave:15:5);
  if signota then write('scarto della popolaz.= ') 
  else write('scarto del campione  = ');
  writeln(sig:15:5);
  writeln;
  GetFiducia(alpha, kind);
  alpha:= 1 - alpha; (* da fiducia a probabilita' *)
  writeln;
  writeln('Inserire il valore della media da testare (ipotesi nulla)');
  mu0:= 0;
  InputPrec('ז0 = ',mu0,-inf,inf);
  writeln;
  ClrScr;
  case kind of
    '1': tip:='<';
    '2': tip:='ע';
    '3': tip:='ף';
  end;
  if signota then begin
    ns:='z';
    case kind of
      '1': begin st:= 'z(x:1-א/2)'; ns:= '|z|'; end;
      '2': st:= 'z(x:1-א)';
      '3': st:= '-z(x:1-א)';
    end;
  end
  else begin
    ns:='t';
    case kind of
      '1': begin st:= 't(x:1-א/2; df: n-1)'; ns:= '|t|'; end;
      '2': st:= 't(x:1-א; df: n-1)';
      '3': st:= '-t(x:1-א; df: n-1)';
    end;
  end;
  writeln('Riepilogo dei dati');
  writeln;
  writeln('numerosita'' campione  = ', n);
  writeln('Media campione        = ', ave:15:5);
  writeln('scarto campione/popol.= ', sig:15:5);
  writeln('Livello di probabil.  = ', alpha:15:5);
  write('Tipologia intervallo: ');
  case kind of
    '1': writeln(' P[ Li ף x ף Ls]  = 1 - א');
    '2': writeln(' P[ x ע Li]  = 1 - א');
    '3': writeln(' P[ x ף Ls]  = 1 - א');
  end;
  writeln;
  writeln('Test sulla media');
  writeln('Ipotesi nulla: ז = ז0 = ', mu0:15:5);
  if kind = '1' then writeln('Ipotesi alternativa ז <> ז0')
  else writeln('Ipotesi alternativa ז ',tip,' ז0');
  writeln('Statistica ',ns,' ',tip,' ',st);
  if signota then begin
    fat1:= NormalXVal(alpha);
  end
  else begin
    fat1:= TStudentXVal(alpha, n-1);
  end;
  if Kind='1'then fat1:= abs(fat1);
  writeln('Valore limite statistica ',ns,' = ', fat1:15:5);
  WaitReturn;
  writeln;
  writeln('Intervallo di fiducia della media campionaria');
  fat2:= fat1 * sig / sqrt(int(n));
  case Kind of
    '1': begin
      li:= ave - fat2; ls:= ave + fat2;
      writeln('[Li, Ls] =  ז ס ',st,'שו/ûn = [', li:15:5,', ',ls:15:5,']');
    end;
    '2': begin
      li:= ave - fat2; ls:= 999999.999;
      writeln('[Li, ל] = [ז -',st,'שו/ûn, ל] = [',li:15:5,', ל]');
    end;
    '3': begin
      li:= -999999.999; ls:= ave + fat2;
      writeln('[-ל, Ls] = [-ל, ז +',Copy(st,2,length(st)-1),'שו/ûn] = [-ל, ', ls:15:5,']');
    end;
  end;
  writeln;
  writeln('Intervallo di fiducia dell''ipotesi nulla');
  case Kind of
    '1': begin
      li:= mu0 - fat2; ls:= mu0 + fat2;
      writeln('[Li, Ls] =  ז ס ',st,'שו/ûn = [ ', li:15:5,', ',ls:15:5,' ]');
    end;
    '2': begin
      li:= -999999.999; ls:= mu0 + fat2;
      writeln('[-ל, Ls] = [-ל, ז +',st,'שו/ûn] = [-ל, ', ls:15:5,']');
    end;
    '3': begin
      li:= mu0 - fat2; ls:= 999999.999;
      writeln('[Li, ל] = [ז ',st,'שו/ûn, ל] = [',li:15:5,', ל]');
    end;
  end;
  xcalc:= (ave - mu0) * sqrt(n) / sig;
  writeln;
  writeln('Valore calcolato della statistica ',ns,' = ', xcalc:15:5);
  writeln;
  write('Probabilita'' א per questo valore = ');
  if signota then begin          
    alca:= NormalFCum(xcalc);
  end
  else begin
    alca:= TStudentFCum(xcalc, n-1);
  end;
  if kind = '2' then alca:= 1 - alca;
  if kind = '1' then alca:= (1 - alca) * 2;
  writeln(alca*100:7:3,' %');
  writeln;
  if (ave <= ls) and (ave >= li) then writeln('quindi NON si puo'' rifiutare l''ipotesi nulla')
  else writeln('quindi si deve rifiutare l''ipotesi nulla');
  WaitReturn;
  writeln;
  repeat
    GetChar('Calcolo errore seconda specie ב (S/N)? ',car);
    if car = 'N' then exit;
    writeln;
    mua:= mu0;
    InputPrec('Ipotesti alternativa da testare זA = ',mua,-inf,inf);
    if signota then begin
      case kind of
        '1': beta:= NormalFCum((ls-mua)*sqrt(n)/sig) - NormalFCum((li-mua)*sqrt(n)/sig);
        '2': beta:= NormalFCum((ls-mua)*sqrt(n)/sig);
        '3': beta:= 1 - NormalFCum((li-mua)*sqrt(n)/sig);
      end;
    end
    else begin
      case kind of
        '1': beta:= TStudentFCum((ls-mua)*sqrt(n)/sig, n-1) - TStudentFCum((li-mua)*sqrt(n)/sig, n-1);
        '2': beta:= TStudentFCum((ls-mua)*sqrt(n)/sig, n-1);
        '3': beta:= 1 - TStudentFCum((li-mua)*sqrt(n)/sig, n-1);
      end;
    end;
    writeln('Errore ב = ', beta:15:5);
  until false;
end;

procedure TestSigma(var Campione: TSerie; cheat: boolean);
var 
  ave, sig: PREC;
  alpha, alca: PREC;
  fat10, fat11, fat20, fat21: PREC;
  li, ls : PREC;
  si0,xcalc : PREC;
  sia, beta: PREC;
  n: integer;
  kind, car: char;
  tip, st, ns: string;
begin
  ClrScr;
  writeln('Intervalli Varianza e test sulla varianza');
  writeln('                                _  ');
  writeln('ATTENZIONE!!!  con ז^ si indica x, val. medio campione = stima media popol.');
  writeln;
  if cheat then begin
    sig:= 1; n:= 1;
    InputPrec('scarto tipo      = ',sig,0,inf);
    InputInt('numero campioni  = ',n,1,maxint);
  end
  else begin
    CalcAveVar(Campione, ave, sig, true);
    n:= Campione.Count;
  end;
  writeln;
  writeln('numerosita'' campione = ', n);
  writeln('Media campione       = ', ave:15:5);
  writeln('scarto campione      = ', sig:15:5);
  writeln;
  GetFiducia(alpha, kind);
  writeln;
  si0:= sig;
  InputPrec('Inserire il valore dello scarto da testare ו0 = ',si0,0,inf);
  writeln;
  ClrScr;
  case kind of
    '1': tip:='<';
    '2': tip:='ע';
    '3': tip:='ף';
  end;
  ns:='v';
  case kind of
    '1': begin st:= 'v(x:(1-א/2|א/2): df: n-1)'; end;
    '2': st:= 'v(x:1-א; df: n-1)';
    '3': st:= 'v(x:א; df: n-1)';
  end;
  writeln('Riepilogo dei dati');
  writeln;
  writeln('numerosita'' campione  = ', n);
  writeln('Media campione        = ', ave:15:5);
  writeln('scarto campione       = ', sig:15:5);
  writeln('Livello di probabil.  = ', (1-alpha):15:5);
  write('Tipologia intervallo: ');
  case kind of
    '1': writeln(' P[ Li ף x ף Ls]  = 1 - א');
    '2': writeln(' P[ x ע Li]  = 1 - א');
    '3': writeln(' P[ x ף Ls]  = 1 - א');
  end;
  writeln;
  writeln('Test sulla scarto quadratico medio');
  writeln('Ipotesi nulla ו = ', si0:15:5);
  if kind = '1' then writeln('Ipotesi alternativa ו <> ו0')
  else writeln('Ipotesi alternativa ו ',tip,' ו0');
  writeln('Statistica ',ns,' ',tip,' ',st);
  if n > 30 then begin
    fat10:= sqr((1 + NormalXVal(1-alpha) / sqrt(2*n))) * n-1;
    fat11:= sqr((1 - NormalXVal(1-alpha) / sqrt(2*n))) * n-1;
  end
  else begin
    fat10:= ChiQuadXVal(1-alpha, n-1);
    fat11:= ChiQuadXVal(alpha, n-1);
  end;
  if n > 30 then begin
    writeln('Valore limite statistica sup. = ', (sqrt(fat10)/n-1):15:5);
    writeln('Valore limite statistica inf. = ', (sqrt(fat11)/n-1):15:5);
  end
  else begin
    writeln('Valore limite statistica sup. = ', fat10:15:5);
    writeln('Valore limite statistica inf. = ', fat11:15:5);
  end;
  WaitReturn;
  writeln;
  writeln('Intervallo di fiducia dello scarto quadratico medio campionario');
  fat20:= sqrt(n-1 * sqr(sig) / fat10);
  fat21:= sqrt(n-1 * sqr(sig) / fat11);
  case kind of
    '1': begin
      li:= fat20; ls:= fat21;
      writeln('[Li, Ls] =  û(n-1)*s‎צ',st,' = [', li:15:5,', ',ls:15:5,']');
    end;
    '2': begin
      li:= fat20; ls:= 999999.999;
      writeln('[Li, ל] = û(n-1)*s‎צ',st,', ל] = [',li:15:5,', ל]');
    end;
    '3': begin
      li:= -999999.999; ls:= fat21;
      writeln('[-ל, Ls] = [-ל, û(n-1)*s‎צ',st,'] = [-ל, ', ls:15:5,']');
    end;
  end;
  fat20:= sqrt(n-1 * sqr(si0) / fat10);
  fat21:= sqrt(n-1 * sqr(si0) / fat11);
  writeln;
  writeln('Intervallo di fiducia dell''ipotesi nulla');
  case Kind of
    '1': begin
      li:= fat20; ls:= fat21;
      writeln('[Li, Ls] = [û(n-1)*s‎צ',st,'] = [ ', li:15:5,', ',ls:15:5,' ]');
    end;
    '2': begin
      li:= -999999.999; ls:= fat21;
      writeln('[-ל, Ls] = [-ל, û(n-1)*s‎צ',st,'] = [-ל, ', ls:15:5,']');
    end;
    '3': begin
      li:= fat20; ls:= 999999.999;
      writeln('[Li, ל] = [ û(n-1)*s‎צ',st,', ל] = [',li:15:5,', ל]');
    end;
  end;
  xcalc:= sqrt(n-1 * sqr(sig) / sqr(si0));
  writeln;
  writeln('Valore calcolato della statistica ',ns,' = ', xcalc:15:5);
  writeln;
  write('Probabilita'' א per questo valore = ');
  alca:= ChiQuadFCum(xcalc, n-1);
  if kind = '2' then alca:= 1 - alca;
  if kind = '1' then alca:= (1 - alca) * 2;
  writeln(alca*100:7:3,' %');
  writeln;
  if (ave <= ls) and (ave >= li) then writeln('quindi NON si puo'' rifiutare l''ipotesi nulla')
  else writeln('quindi si deve rifiutare l''ipotesi nulla');
  WaitReturn;
  writeln;
  repeat
    GetChar('Calcolo errore seconda specie ב (S/N)? ',car);
    if car = 'N' then exit;
    writeln;
    sia:= si0;
    InputPrec('Ipotesti alternativa da testare וA = ',sia,0,inf);
    case kind of
      '1': beta:=     ChiQuadFCum(sqrt(n-1 * sqr(ls) / sqr(sia)), n-1) -
                      ChiQuadFCum(sqrt(n-1 * sqr(li) / sqr(sia)), n-1);
      '2': beta:=     ChiQuadFCum(sqrt(n-1 * sqr(ls) / sqr(sia)), n-1);
      '3': beta:= 1 - ChiQuadFCum(sqrt(n-1 * sqr(li) / sqr(sia)), n-1);
    end;
    writeln('Errore ב = ', beta:15:5);
  until false;
end;

procedure TestDiffMedia(var Campione1: TSerie; var Campione2: TSerie; cheat: boolean);
var 
  ave1, sig1: PREC;
  n1: integer;
  ave2, sig2: PREC;
  n2: integer;
  alpha, alca: PREC;
  fat1, fat2: PREC;
  li, ls : PREC;
  mu0,xcalc : PREC;
  mua, beta: PREC;
  signota: boolean;
  kind, car: char;
  tip, st, ns: string;
label Entry;
begin
  ClrScr;
  writeln('Intervalli Differenza di Medie e test attinenti');
  writeln('                                _  ');
  writeln('ATTENZIONE!!!  con ז^ si indica x, val. medio campione = stima media popol.');
  if cheat then begin
    writeln('Primo campione');
    ave1:= 0; ave2:= 0;
    sig1:= 0; sig2:= 0;
    n1:= 1; n2:= 1;
    InputPrec('Media            = ',ave1,-inf,inf);
    InputPrec('scarto tipo      = ',sig1,0,inf);
    InputInt('numero campioni  = ',n1,1,maxint);
    writeln('Secondo campione');
    InputPrec('Media            = ',ave2,-inf,inf);
    InputPrec('scarto tipo      = ',sig2,0,inf);
    InputInt('numero campioni  = ',n2,1,maxint);
    repeat
      GetChar('scarto noto (S/N)? ',car);
    until car in ['S','N'];
    signota:= car='S';
  end
  else begin
    CalcAveVar(Campione1, ave1, sig1, true);
    CalcAveVar(Campione2, ave2, sig2, true);
    n1:= Campione1.Count;
    n2:= Campione2.Count;
  end;
  writeln;
  writeln('numerosita'' campioni = ', n1:15,' , ', n2:15);
  writeln('Medie campioni       = ', ave1:15:5,' , ', ave2:15:5);
  writeln('scarti campioni      = ', sig1:15:5,' , ', ave2:15:5);
  writeln;
  GetFiducia(alpha, kind);
  alpha:= 1 - alpha; (* da fiducia a probabilita' *)
  writeln;
  mu0:= ave1-ave2;
  InputPrec('Inserire il valore della media da testare ז0 = ',mu0,-inf,inf);
  writeln;
  ClrScr;
  case kind of
    '1': tip:='<';
    '2': tip:='ע';
    '3': tip:='ף';
  end;
  if signota then begin
    ns:='z';
    case kind of
      '1': begin st:= 'z(x:1-א/2)'; ns:= '|z|'; end;
      '2': st:= 'z(x:1-א)';
      '3': st:= '-z(x:1-א)';
    end;
  end
  else begin
    ns:='t';
    case kind of
      '1': begin st:= 't(x:1-א/2; df: n-1)'; ns:= '|t|'; end;
      '2': st:= 't(x:1-א; df: n-1)';
      '3': st:= '-t(x:1-א; df: n-1)';
    end;
  end;
  writeln('Riepilogo dei dati');
  writeln;
  writeln('numerosita'' campioni = ', n1:15,' , ', n2:15);
  writeln('Medie campioni       = ', ave1:15:5,' , ', ave2:15:5);
  writeln('scarti campioni      = ', sig1:15:5,' , ', sig2:15:5);
  writeln('Livello di probabil.  = ', alpha:15:5);
  write('Tipologia intervallo: ');
  case kind of
    '1': writeln(' P[ Li ף x ף Ls]  = 1 - א');
    '2': writeln(' P[ x ע Li]  = 1 - א');
    '3': writeln(' P[ x ף Ls]  = 1 - א');
  end;
  writeln;
  writeln('Test sulla differenza di due medie');
  writeln('Ipotesi nulla |ז1-ז2| = ', mu0:15:5);
  if kind = '1' then writeln('Ipotesi alternativa |ז1-ז2| <> ז0')
  else writeln('Ipotesi alternativa ז ',tip,' ז0');
  writeln('Statistica ',ns,' ',tip,' ',st);
  if signota then begin
    fat1:= NormalXVal(alpha);
  end
  else begin
    fat1:= TStudentXVal(alpha, pred(n1));
  end;
  writeln('Valore limite statistica ',ns,' = ', fat1:15:5);
  WaitReturn;
  writeln;
  writeln('Intervallo di fiducia della media campionaria');
  fat2:= fat1 * sig1 / sqrt(int(n1));
  case Kind of
    '1': begin
      li:= ave1 - fat2; ls:= ave1 + fat2;
      writeln('[Li, Ls] =  ז ס ',st,'שו/ûn = [', li:15:5,', ',ls:15:5,']');
    end;
    '2': begin
      li:= ave1 - fat2; ls:= 999999.999;
      writeln('[Li, ל] = [ז -',st,'שו/ûn, ל] = [',li:15:5,', ל]');
    end;
    '3': begin
      li:= -999999.999; ls:= ave1 + fat2;
      writeln('[-ל, Ls] = [-ל, ז +',Copy(st,2,length(st)-1),'שו/ûn] = [-ל, ', ls:15:5,']');
    end;
  end;
  writeln;
  writeln('Intervallo di fiducia dell''ipotesi nulla');
  case Kind of
    '1': begin
      li:= mu0 - fat2; ls:= mu0 + fat2;
      writeln('[Li, Ls] =  ז ס ',st,'שו/ûn = [ ', li:15:5,', ',ls:15:5,' ]');
    end;
    '2': begin
      li:= -999999.999; ls:= mu0 + fat2;
      writeln('[-ל, Ls] = [-ל, ז +',st,'שו/ûn] = [-ל, ', ls:15:5,']');
    end;
    '3': begin
      li:= mu0 - fat2; ls:= 999999.999;
      writeln('[Li, ל] = [ז ',st,'שו/ûn, ל] = [',li:15:5,', ל]');
    end;
  end;
  xcalc:= (ave1 - mu0) * sqrt(n1) / sig1;
  writeln;
  writeln('Valore calcolato della statistica ',ns,' = ', xcalc:15:5);
  writeln;
  write('Probabilita'' א per questo valore = ');
  if signota then begin          
    alca:= NormalFCum(xcalc);
  end
  else begin
    alca:= TStudentFCum(xcalc, pred(n1));
  end;
  if kind = '2' then alca:= 1 - alca;
  if kind = '1' then alca:= (1 - alca) * 2;
  writeln(alca*100:7:3,' %');
  writeln;
  if (ave1 <= ls) and (ave1 >= li) then writeln('quindi NON si puo'' rifiutare l''ipotesi nulla')
  else writeln('quindi si deve rifiutare l''ipotesi nulla');
  WaitReturn;
  writeln;
  repeat
    GetChar('Calcolo errore seconda specie ב (S/N)? ',car);
    if car = 'N' then exit;
    writeln;
    mua:= mu0;
    InputPrec('Ipotesti alternativa da testare זA = ',mua,-inf,inf);
    if signota then begin
      case kind of
        '1': beta:= NormalFCum((ls-mua)*sqrt(n1)/sig1) - NormalFCum((li-mua)*sqrt(n1)/sig1);
        '2': beta:= NormalFCum((ls-mua)*sqrt(n1)/sig1);
        '3': beta:= 1 - NormalFCum((li-mua)*sqrt(n1)/sig1);
      end;
    end
    else begin
      case kind of
        '1': beta:= TStudentFCum((ls-mua)*sqrt(n1)/sig1, pred(n1)) - TStudentFCum((li-mua)*sqrt(n1)/sig1, pred(n1));
        '2': beta:= TStudentFCum((ls-mua)*sqrt(n1)/sig1, pred(n1));
        '3': beta:= 1 - TStudentFCum((li-mua)*sqrt(n1)/sig1, pred(n1));
      end;
    end;
    writeln('Errore ב = ', beta:15:5);
  until false;
end;

procedure TestDiffSigma(var Campione1: TSerie; var Campione2: TSerie; cheat: boolean);
var 
  ave1, sig1: PREC; n1: integer;
  ave2, sig2: PREC; n2: integer;
  alpha, alca: PREC;
  fat10, fat11,
  fat20, fat21: PREC;
  li, ls : PREC;
  theta0,xcalc : PREC;
  thetaa, beta: PREC;
  kind, car: char;
  tip, st, ns: string;
label Entry;
begin
  ClrScr;
  writeln('Intervalli rapproto sigma e test attinenti');
  writeln('                                _  ');
  writeln('ATTENZIONE!!!  con ז^ si indica x, val. medio campione = stima media popol.');
  if cheat then begin
    writeln('Primo campione');
    sig1:= 1; n1:= 1;
    sig2:= 1; n2:= 1;
    InputPrec('scarto tipo      = ',sig1,0,inf);
    InputInt('numero campioni  = ',n1,1,maxint);
    writeln('Secondo campione');
    InputPrec('scarto tipo      = ',sig2,0,inf);
    InputInt('numero campioni  = ',n2,1,maxint);
    ave1:= 0;
    ave2:= 0;
  end
  else begin
    CalcAveVar(Campione1, ave1, sig1, true); n1:= Campione1.Count;
    CalcAveVar(Campione2, ave2, sig2, true); n2:= Campione2.Count;
  end;
  writeln;
  writeln('numerosita'' campioni = ', n1:15,' , ', n2:15);
  writeln('Medie campioni       = ', ave1:15:5,' , ', ave2:15:5);
  writeln('scarti campioni      = ', sig1:15:5,' , ', sig2:15:5);
  writeln;
  GetFiducia(alpha, kind);
  writeln;
  theta0:= sig1/sig2;
  InputPrec('Inserire il valore del rapporto da testare ו1/ו2 = י0 = ',theta0,Zero,inf);
  writeln;
  ClrScr;
  case kind of
    '1': tip:='IN';
    '2': tip:='ע';
    '3': tip:='ף';
  end;
  ns:='f';
  case kind of
    '1': begin st:= 'F(x:1-א/2|א/2; df1: n1-1; df2: n2-1)';end;
    '2': st:= 'F(x:1-א; df1: n1-1; df2: n2-1)';
    '3': st:= 'F(x:א; df1: n1-1; df2: n2-1)';
  end;
  writeln('Riepilogo dei dati');
  writeln;
  writeln('numerosita'' campioni = ', n1:15,' , ', n2:15);
  writeln('Medie campioni       = ', ave1:15:5,' , ', ave2:15:5);
  writeln('scarti campioni      = ', sig1:15:5,' , ', ave2:15:5);
  writeln('Livello di probabil.  = ', alpha:15:5);
  write('Tipologia intervallo: ');
  case kind of
    '1': writeln(' P[ Li ף x ף Ls]  = 1 - א');
    '2': writeln(' P[ x ע Li]  = 1 - א');
    '3': writeln(' P[ x ף Ls]  = 1 - א');
  end;
  writeln;
  writeln('Test sulla tapporto di due varianze');
  writeln('Ipotesi nulla י0 = ', theta0:15:5);
  if kind = '1' then writeln('Ipotesi alternativa ו1/ו2 <> י0')
  else writeln('Ipotesi alternativa ו1/ו2 ',tip,' י0');
  writeln('Statistica ',ns,' ',tip,' ',st);
  fat10:= FisherXVal(alpha, pred(n1), pred(n2));
  fat11:= FisherXVal(1-alpha, pred(n1), pred(n2));
  writeln('Valore limite statistica inf. = ', fat10:15:5);
  writeln('Valore limite statistica sup. = ', fat11:15:5);
  WaitReturn;
  writeln;
  writeln('Intervallo di fiducia della media campionaria');
  xcalc:= sqr(sig2)/sqr(sig1);
  fat21:= xcalc * fat11;
  fat20:= xcalc * fat10;
  case Kind of
    '1': begin
      li:= fat20; ls:= fat21;
      writeln('[Li, Ls] = [', li:15:5,', ',ls:15:5,']');
    end;
    '2': begin
      li:= fat20; ls:= 999999.999;
      writeln('[Li, ל] = [',li:15:5,', ל]');
    end;
    '3': begin
      li:= -999999.999; ls:= fat21;
      writeln('[-ל, Ls] = [-ל, ', ls:15:5,']');
    end;
  end;
  writeln;
  writeln('Intervallo di fiducia dell''ipotesi nulla');
  fat20:= theta0 * fat10;
  fat21:= theta0 * fat11;
  case Kind of
    '1': begin
      li:= fat10; ls:= fat21;
      writeln('[Li, Ls] =  [ ', li:15:5,', ',ls:15:5,' ]');
    end;
    '2': begin
      li:= -999999.999; ls:= fat21;
      writeln('[-ל, Ls] = [-ל, ', ls:15:5,']');
    end;
    '3': begin
      li:= fat20; ls:= 999999.999;
      writeln('[Li, ל] = [',li:15:5,', ל]');
    end;
  end;
  writeln;
  xcalc:= sqr(sig1) / sqr(sig2);
  writeln('Valore calcolato della statistica ',ns,' = ', xcalc:15:5);
  writeln;
  write('Probabilita'' א per questo valore = ');
  alca:= FisherFCum(xcalc, pred(n1), pred(n2));
  if kind = '2' then alca:= 1 - alca;
  if kind = '1' then alca:= (1 - alca) * 2;
  writeln(alca*100:7:3,' %');
  writeln;
  if (xcalc <= ls) and (xcalc >= li) then writeln('quindi NON si puo'' rifiutare l''ipotesi nulla')
  else writeln('quindi si deve rifiutare l''ipotesi nulla');
  WaitReturn;
  writeln;
  repeat
    GetChar('Calcolo errore seconda specie ב (S/N)? ',car);
    if car = 'N' then exit;
    writeln;
    thetaa:= theta0;
    InputPrec('Ipotesti alternativa da testare זA = ',thetaa,Zero,inf);
    case kind of
      '1': beta:=     FisherFCum(ls, pred(n1), pred(n2)) -
                      FisherFCum(li, pred(n1), pred(n2));
      '2': beta:=     FisherFCum(ls, pred(n1), pred(n2));
      '3': beta:= 1 - FisherFCum(li, pred(n1), pred(n2));
    end;
    writeln('Errore ב = ', beta:15:5);
  until false;
end;

procedure TestChiQua;
var
  x, i, j, m, n, r, c: integer;
  V1, V2, A: TSVector;
  Y, P, Z, L: PREC;
begin
  ClrScr;
  Writeln('TEST CHI-QUADRATO');
  writeln;
  r:= 0; c:= 0;
  InputInt('NUMERO DI RIGHE   (0 = fine): ', R, 0, 99); if r = 0 then exit;
  InputInt('NUMERO DI COLONNE (0 = fine): ', C, 0, 99); if c = 0 then exit;
  V1.Init(1,R*C); V2.Init(1,C); a.Init(1,R);
  Writeln('TABELLA DATI:');
  FOR I:= 1 TO R do begin
    FOR J:= 1 TO C do begin
      Write('ELEMENTO[',i:2,',',j:2,'] ');
      InputPrec('= ', V1.At((I - 1) * C + J)^, -inf, inf);
    end;
  end;
  writeln;
  (* SOMMA LA FREQUENZA MARGINALE PER OGNI RIGA *);
  L:= 0;
  M:= 1;
  FOR I:= 1 TO R do begin
    FOR J:= 1 TO C do begin
      A.At(I)^:= A.At(I)^ + V1.At(M)^;
      M:= M + 1;
    end;
    L:= L + A.At(I)^;
  end;
  N:= R * C;
  (* SOMMA LA FREQUENZA MARGINALE DI OGNI COLONNA *)
  FOR I:= 1 TO C do begin
    J:= I;
    while (j<=N) do begin
      V2.At(I)^:= V2.At(I)^ + V1.At(J)^;
      inc(j, c);
    end;
  end;
  Z:= 0;
  Writeln('VALORE       VALORE      CONTRIBUTO');
  Writeln('OSSERVATO    PREVISTO     CHI ^ 2  ');
  FOR I:= 1 TO C do begin
    Writeln('COLONNA ', I);
    FOR J:= 1 TO R do begin
      (* P=VALORE PREVISTO *);
      P:= A.At(J)^ * V2.At(I)^ / L;
      X:= I + (J - 1) * C;
      (* Y=CONTRIBUTO AL CHI-QUADRATO *)
      (* SI ADOPERA LA CORREZIONE DI YATES PER LA CONTINUITA'
         NEL TEST CHI-QUADRATO DI DIMENSIONI 2 X 2 *)
      IF (R = 2) and (C = 2) then Y:= sqr(ABS(V1.At(X)^ - P) - 0.5) / P
      else Y:= sqr(V1.At(X)^ - P) / P;
      (* Z=VALORE TOTALE DEL CHI-QUADRATO *)
      Z:= Z + Y;
      Writeln(V1.At(X)^:10:2,' ',P:10:2,' ', y:12:3);
    end;
  end;
  writeln;
  Writeln('CHI-QUADRATO = ', Z:12:4);
  Writeln('GRADI DI LIBERTA''= ', (C - 1) * (R - 1));
  WaitReturn;
  V1.Done;
  V2.Done;
  A.Done;
end;

procedure TestUMan;
var
  m, l, i, j, k: integer;
  N: TIVector;
  Y, X: TSVector;
  U1, U2: PREC;
  xx, yy: PREC;
  R1, R, C: PREC;
label l330, l440, l480, l510, l550, l580, l590, l620, l640, l660;
begin
  ClrScr;
  Writeln('TEST U DI MANN-WHITNEY');
  (* INSERZIONE DEI DUE CAMPIONI *)
  N.Init(1,2);
  FOR I:= 1 TO 2 do begin
    Writeln('CAMPIONE ', I);
    InputInt('  MISURA: ', N.At(I)^, 1, 99);
    (* DIMENSIONA IL VETTORE Y.At() CON LA MISURA DEL CAMPIONE *)
    IF I = 1 THEN Y.Init(1,N.At(I)^);
    FOR J:= 1 TO N.At(i)^ do begin
      Write('DATO ', J:4,' = '); InputPrec('', Y.At(J)^, -inf, inf);
    end;
    FOR J:= 1 TO N.At(i)^ do begin
      FOR K:= 1 TO N.At(i)^ - J do begin
        C:= Y.At(K)^;
        IF Y.At(K)^ >= Y.At(K + 1)^ THEN begin
          Y.At(K)^:= Y.At(K + 1)^;
          Y.At(K + 1)^:= C;
        end;
      end;
    end;
    writeln;
    (* TRASFERISCE IL PRIMO CAMPIONE NEL VETTORE X *)
    IF I <> 2 THEN begin
      (* DIMENSIONA IL VETTORE X() CON LA MISURA DEL CAMPIONE *)
      X.Init(1,N.At(i)^);
      FOR J:= 1 TO N.At(i)^ do begin
        X.At(J)^:= Y.At(J)^;
      end;
    end;
  end;
  (* SOMMA LE PRECEDENZE *)
  R:= 1;
  I:= 0;
  J:= 0;
  I:= I + 1;
  J:= J + 1;
  xx:= 0; yy:= 0;
l330:
  IF I > N.At(1)^ THEN goto l580;
  IF J > N.At(2)^ THEN goto l620;
  IF X.At(I)^ < Y.At(J)^ THEN goto l620;
  IF Y.At(J)^ < X.At(I)^ THEN goto l590;
  (* LE LINEE 370-570 TRATTANO I PUNTEGGI UGAUALI DEI DUE CAMPIONI *)
  K:=  2;
  M:= I;
  L:= J;
  R1:= 2 * R + 1;
  R:= R + 2;
  I:= I + 1;
  J:= J + 1;
l440:
  IF I > N.At(1)^ THEN goto l480;
  IF X.At(I)^ <> X.At(I - 1)^ THEN goto l480;
  I:= I + 1;
  GOTO l510;
l480:
  IF J > N.At(2)^ THEN goto l550;
  IF Y.At(J)^ <> Y.At(J - 1)^ THEN goto l550;
  J:= J + 1;
l510:
  R1:= R1 + R;
  R:= R + 1;
  K:= K + 1;
  GOTO l440;
l550:
  Xx:= Xx + (I - M) * R1 / K;
  Yy:= Yy + (J - L) * R1 / K;
  GOTO l330;
l580:
  IF J > N.At(2)^ THEN goto l660;
l590:
  YY:= YY + R;
  J:= J + 1;
  GOTO l640;
l620:
  XX:= XX + R;
  I:= I + 1;
l640:
  R:= R + 1;
  GOTO l330;
l660:
  (* U1=NUMERO DI VOLTE CHE I PUNTEGGI DEL PRIMO CAMPIONE PRECEDONO I PUNTEGGI DEL SECONDO CAMPIONE *)
  U1:= N.At(1)^ * N.At(2)^ + N.At(1)^ * (N.At(1)^ + 1) / 2 - XX;
  (* U2=NUMERO DI VOLTE CHE I PUNTEGGI DEL SECONDO CAMPIONE PRECEDONO I PUNTEGGI DEL PRIMO CAMPIONE *)
  U2:= N.At(1)^ * N.At(2)^ + N.At(2)^ * (N.At(2)^ + 1) / 2 - YY;
  ClrScr;
  Writeln('CAMPIONE 1         CAMPIONE 2');
  FOR J:= 1 TO N.At(1)^ do begin
    Writeln(X.At(J)^:12:3,'   ',Y.At(J)^:12:3);
  end;
  writeln;
  Writeln('SE IL PRIMO CAMPIONE PRECEDE, U = ', U2:12:3);
  Writeln('SE IL SECONDO CAMPIONE PRECEDE, U = ', U1:12:3);
  writeln;
  WaitReturn;
  X.Done; Y.Done; N.Done;
end;

procedure MenuTestStatistici(var Spread: TSpread);
var
  ch : char;
  Serie1, Serie2: char;
begin
  repeat
    ClrScr;
    Writeln('Test Statistici & Intervalli di fiducia');
    writeln;
    writeln('0. Torna al menu principale');
    writeln('1. Intervallo della media, e test attinenti');
    writeln('2. Intervallo scarto quadratico medio, e test attinenti');
    writeln('3. Intervallo differene due medie, e test attinenti');
    writeln('4. Intervallo rapporto due varianze, e test attinenti');
    writeln;
    writeln('A. TestChiQua');
    writeln('B. TestUMan');
    writeln;
    writeln('SHIFT-Numero attiva il cheat mode');
    writeln;
    GetChar('Quale? ',ch);
    if ch in ['1','2'] then begin
      writeln;
      Spread.GetSerie(Serie1);
      if Serie1 = #0 then ch:= #0; (* Annulla comando *)
    end;
    if ch in ['3','4'] then begin
      writeln;
      Spread.GetSerie(Serie1);
      if Serie1 = #0 then ch:= #0; (* Annulla comando *)
      Spread.GetSerie(Serie2);
      if Serie1 = #0 then ch:= #0; (* Annulla comando *)
    end;
    case ch of
      '1': TestMedia(Spread.Cols[Serie1]^, false);
      '!': TestMedia(Spread.Cols['A']^, true);
      '2': TestSigma(Spread.Cols[Serie1]^, false);
      '"': TestSigma(Spread.Cols['A']^, true);
      '3': TestDiffMedia(Spread.Cols[Serie1]^, Spread.Cols[Serie2]^, false);
      '': TestDiffMedia(Spread.Cols['A']^, Spread.Cols['A']^, true);
      '4': TestDiffSigma(Spread.Cols[Serie1]^, Spread.Cols[Serie2]^, false);
      '$': TestDiffSigma(Spread.Cols['A']^, Spread.Cols['A']^, true);
      'A': TestChiQua;
      'B': TestUMan;
    end;
  until ch = '0';
  ClrScr;
end;

{$IFNDEF UNIT}
var Spread: PSpread;
begin
  New(Spread, Init);
  MenuTestStatistici(Spread^);
{$ENDIF}
end.
