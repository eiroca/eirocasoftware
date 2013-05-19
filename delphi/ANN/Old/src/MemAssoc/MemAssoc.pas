unit MemAssoc;

interface

procedure Main;

implementation

function MAX(a, b: single): single;
begin
  if (a > b) then MAX:= a else MAX:= b;
end;

function MIN(a, b: single): single;
begin
  if (a > b) then MIN:= b else MIN:= a;
end;

function VUOTA(x: PChar): boolean;
begin
  Vuota:= (x = nil) or (x^ = #0);
end;

function NONVUOTA(x: PChar): boolean;
begin
  NonVuota:= (x <> nil) and (x^ = #0);
end;

var
  (* memoria *)
  mem: array[0..2047] of single;
  (* chiavi *)
  k1, k2, k3, k4, k5, k6: array[0..2047] of single;
  (* informazioni *)
  i1, i2, i3, i4, i5, i6: array[0..7] of single;
  (* richiami *)
  r1, r2, r3, r4, r5, r6: array[0..7] of single;

type Psingle = ^ single;

(* Genera una chiave normalizzata *)
procedure genkey(var key: array of single; keydim: integer);
var
  i: integer;
  norm: single;
begin
  norm := 1 / sqrt(keydim);
  for i := 0 to keydim-1 do begin
    if (random(2) < 1) then key[i] := -norm else key[i] := norm;
  end;
end;

(* Trasforma una chiave normalizzata in un altra correlante
  per un fattore corr (0 <= corr <= 1) *)
procedure modkey(var key: array of single; keydim: integer; corr: single);
var
  i: integer;
  res: integer;
  soglia: integer;
  norm: single;
begin
  norm := 1 / sqrt(keydim);
  soglia := 0;
  if (corr * 32767 >= 32767) then soglia := 32767
  else soglia := round(corr * 32767);
  for i := 0 to keydim-1 do begin
    res := random(32768);
    if (res <= soglia) then continue;
    if (res < 16384) then key[i] := -norm else key[i] := norm;
  end;
end;

(* Azzera gli elementi di un vettore *)
procedure cancvett(var vett: array of single; vettdim: integer);
var i: integer;
begin
  for i := 0 to vettdim-1 do vett[i] := 0;
end;

(* Stampa gli elementi di un vettore *)
procedure printvett(var vett: array of single; vettdim: integer);
var i: integer;
begin
  for i := 0 to vettdim-1 do write(vett[i]:8:5, ' ');
  writeln;
end;

(* Stampa gli elementi di un vettoren formato 0/1 a seconda che superino o
  meno un valore di soglia. Ritorna anche il numero di 0 e 1 presenti ed
  il loro valor medio. *)
procedure printnormvett(var vett: array of single; vettdim: integer; soglia: single);
var
  i, n0, n1: integer;
  sum0, sum1, media0, media1: single;
begin
  n0 := 0; n1 := 0;
  sum0 := 0.0; sum1 := 0.0;
  media0 := 0.0; media1 := 0.0;
  for i := 0 to vettdim-1 do begin
    if (vett[i] < soglia) then begin
     write(0.0:8:5,' ');
     sum0 := sum0 + vett[i];
     inc(n0);
    end
    else begin
     write(1.0:8:5,' ');
     sum1 := sum1 + vett[i];
     inc(n1);
    end;
   end;
   if (n0 > 0) then media0 := sum0 / n0;
   if (n1 > 0) then media1 := sum1 / n1;
   writeln('tot 0 = ',n0,' media 0 = ',media0:8:5,' tot 1 = ',n1,' media 1 = ',media1:8:5);
end;

(* Effettua l'operazione di convoluzione tra inf e key e somma il risultato
  a mem *)
procedure conv(var inf, mem, key: array of single; infdim, memdim: integer);
var
  i, j, pos: integer;
  sum: single;
begin
  (* if (inf = nil) or (mem = nil) or (key = nil) then exit; *)
  for i := 0 to memdim-1 do begin
    sum := 0.0;
    for j := 0 to infdim-1 do begin
      pos := i - j;
      if (pos < 0) then inc(pos, memdim);
      sum := sum + inf[j] * key[pos];
    end;
    mem[i] := mem[i] + sum;
  end;
end;

(* Effettua l'operazione di correlazione tra mem e key e memorizza il
risultato in inf *)
procedure corr(var inf, mem, key: array of single; infdim, memdim: integer);
var
  i, j, pos: integer;
  sum: single;
begin
  (* if (inf = nil) or (mem = nil) or (key = nil) then exit; *)
  for i := 0 to infdim-1 do begin
    sum := 0.0;
    for j := 0 to memdim-1 do begin
     pos := - i + j;
     if (pos < 0) then inc(pos, memdim);
     sum := sum + mem[j] * key[pos];
   end;
   inf[i] := sum;
  end;
end;

(* Esempio di memorizzazione e richiamo con chiavi complete al 100% e al 75% e chiavi errate *)
procedure do_main;
begin
  (* genera i vettori di informazione con un solo bit settato *)
  cancvett(i1, 8);
  cancvett(i2, 8);
  cancvett(i3, 8);
  cancvett(i4, 8);
  cancvett(i5, 8);
  cancvett(i6, 8);
  i1[0] := 1.0;
  i2[1] := 1.0;
  i3[2] := 1.0;
  i4[3] := 1.0;
  i5[4] := 1.0;
  i6[5] := 1.0;
  i1[7] := 1.0;
  i2[6] := 1.0;
  i3[5] := 1.0;
  i4[4] := 1.0;
  i5[3] := 1.0;
  i6[2] := 1.0;
  (* genera le chiavi *)
  genkey(k1, 2048);
  genkey(k2, 2048);
  genkey(k3, 2048);
  genkey(k4, 2048);
  genkey(k5, 2048);
  genkey(k6, 2048);
  (* azzera la memoria *)
  cancvett(mem, 2048);
  (* crea la memoria effettuando la convoluzione *)
  conv(i1, mem, k1, 8, 2048);
  conv(i2, mem, k2, 8, 2048);
  conv(i3, mem, k3, 8, 2048);
  conv(i4, mem, k4, 8, 2048);
  conv(i5, mem, k5, 8, 2048);
  conv(i6, mem, k6, 8, 2048);
  (* effettua un richiamo con chiave completa tramite correlazione *)
  corr(r1, mem, k1, 8, 2048);
  corr(r2, mem, k2, 8, 2048);
  corr(r3, mem, k3, 8, 2048);
  corr(r4, mem, k4, 8, 2048);
  corr(r5, mem, k5, 8, 2048);
  corr(r6, mem, k6, 8, 2048);
  writeln;
  writeln('RISULTATI');
  (* visualizza il contenuto dei vettori di informazione *)
  writeln;
  writeln('informazione');
  printvett(i1, 8);
  printvett(i2, 8);
  printvett(i3, 8);
  printvett(i4, 8);
  printvett(i5, 8);
  printvett(i6, 8);
  (* visualizza il contenuto dei vettori di richiamo *)
  writeln;
  writeln('richiamo con chiave completa');
  printvett(r1, 8);
  printvett(r2, 8);
  printvett(r3, 8);
  printvett(r4, 8);
  printvett(r5, 8);
  printvett(r6, 8);
  (* visualizza il contenuto dei vettori di richiamo tramite soglia *)
  writeln;
  writeln('richiamo con chiave completa e soglia');
  printnormvett(r1, 8, 0.5);
  printnormvett(r2, 8, 0.5);
  printnormvett(r3, 8, 0.5);
  printnormvett(r4, 8, 0.5);
  printnormvett(r5, 8, 0.5);
  printnormvett(r6, 8, 0.5);
  (* crea delle chiavi correlanti al 75% con le originarie *)
  modkey(k1, 2048, 0.75);
  modkey(k2, 2048, 0.75);
  modkey(k3, 2048, 0.75);
  modkey(k4, 2048, 0.75);
  modkey(k5, 2048, 0.75);
  modkey(k6, 2048, 0.75);
  (* effettua un richiamo con chiave incompleta tramite correlazione *)
  corr(r1, mem, k1, 8, 2048);
  corr(r2, mem, k2, 8, 2048);
  corr(r3, mem, k3, 8, 2048);
  corr(r4, mem, k4, 8, 2048);
  corr(r5, mem, k5, 8, 2048);
  corr(r6, mem, k6, 8, 2048);
  (* visualizza il contenuto dei vettori di richiamo *)
  writeln;
  writeln('richiamo con chiave incompleta');
  printvett(r1, 8);
  printvett(r2, 8);
  printvett(r3, 8);
  printvett(r4, 8);
  printvett(r5, 8);
  printvett(r6, 8);
  (* visualizza il contenuto dei vettori di richiamo tramite soglia *)
  writeln;
  writeln('richiamo con chiave incompleta e soglia');
  printnormvett(r1, 8, 0.5);
  printnormvett(r2, 8, 0.5);
  printnormvett(r3, 8, 0.5);
  printnormvett(r4, 8, 0.5);
  printnormvett(r5, 8, 0.5);
  printnormvett(r6, 8, 0.5);
  (* genera delle nuove chiavi non correlanti *)
  genkey(k1, 2048);
  genkey(k2, 2048);
  genkey(k3, 2048);
  genkey(k4, 2048);
  genkey(k5, 2048);
  genkey(k6, 2048);
  (* effettua un richiamo con chiave diverse tramite correlazione *)
  corr(r1, mem, k1, 8, 2048);
  corr(r2, mem, k2, 8, 2048);
  corr(r3, mem, k3, 8, 2048);
  corr(r4, mem, k4, 8, 2048);
  corr(r5, mem, k5, 8, 2048);
  corr(r6, mem, k6, 8, 2048);
  (* visualizza il contenuto dei vettori di richiamo *)
  writeln;
  writeln('richiamo con chiave errata');
  printvett(r1, 8);
  printvett(r2, 8);
  printvett(r3, 8);
  printvett(r4, 8);
  printvett(r5, 8);
  printvett(r6, 8);
  (* visualizza il contenuto dei vettori di richiamo tramite soglia *)
  writeln;
  writeln('richiamo con chiave errata e soglia');
  printnormvett(r1, 8, 0.5);
  printnormvett(r2, 8, 0.5);
  printnormvett(r3, 8, 0.5);
  printnormvett(r4, 8, 0.5);
  printnormvett(r5, 8, 0.5);
  printnormvett(r6, 8, 0.5);
end;

procedure Main;
begin
  writeln;
  writeln('Questo programma simula il comportamento di una memoria associativa');
  writeln('a convoluzione/correlazione.');
  writeln('Esso ha il seguente funzionamento:');
  writeln(' - Crea 6 array di informazione.');
  writeln(' - Crea delle chiavi noise-like normalizzate');
  writeln(' - Tramite convoluzione delle informazioni con le chiavi crea la memoria');
  writeln(' - Effettua dei richiami tramite correlazioni della memoria');
  writeln('  con i seguenti insiemi di chiavi:');
  writeln('   i)  chiavi con fattore di correlazione 1   (complete)');
  writeln('   ii)  chiavi con fattore di correlazione 0.75  (incomplete)');
  writeln('   iii) chiavi con fattore di correlazione 0   (errate)');
  do_main;
end;

end.