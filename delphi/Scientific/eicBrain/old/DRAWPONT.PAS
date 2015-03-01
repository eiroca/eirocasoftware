uses Crt, MathTool, Matrix, DataMngr;
var
  tmp: PREC;
  a1, a2, a3: PREC;
  b1, b2, b3: PREC;
  a, b, c, d: PREC;
  X, Y: TS1DynArr;
  z, l, s, t, p, i, j, k, n: integer;
  istr: string;
label l540, l570, l590, l870, l910, l920, l1010, l1040;
begin
  ClrScr;
  Writeln('  DISEGNO DI PUNTI SUGLI ASSI COORDINATI');
  Writeln;
  repeat
    Writeln('ASSE-X: PUNTO INIZIALE, PUNTO FINALE,  & INCREMENTO ');
    InputPrec('INIZ = ', a1, -inf, inf);
    InputPrec('FINE = ', a2, -inf, inf);
    InputPrec('INC  = ', a3, -inf, inf);
    IF ((A2 - A1) / A3) <= 23 THEN break;
    Writeln('ESTENSIONE DELL''ASSE Y TROPPO GRANDE');
  until false;
  repeat
    Writeln('ASSE-Y: PUNTO INIZIALE, PUNTO FINALE,  & INCREMENTO ');
    InputPrec('INIZ = ', b1, -inf, inf);
    InputPrec('FINE = ', b2, -inf, inf);
    InputPrec('INC  = ', b3, -inf, inf);
    B2:= (B2 - B1) / B3;
    (* ASSE Y TROPPO LUNGO PER L'USCITA? SE SI, MODIFICA IL PUNTO FINALE O DIMUISCI L'INCREMENTO *)
    IF B2<= 80 THEN break;
    Writeln('ESTENSIONE DELL''ASSE Y TROPPO GRANDE');
  until false;
  Writeln('NUMERO DI PUNTI DA DISEGNARE');
  InputInt('(0 PER FINIRE): ', N, 0, maxint);
  IF N = 0 THEN ;
  X.Init(N + 1);
  Y.Init(N + 1);
  Writeln;
  FOR I:= 1 TO N do begin
    IF I = 1 THEN Writeln('COORDINATE DI ');
    Write('                 PUNTO ', I:3,'.X= '); InputPrec('',X.At(i)^,-inf,inf);
    Write('                 PUNTO ', I:3,'.Y= '); InputPrec('',Y.At(i)^,-inf,inf);
    (* ARROTONDA OGNI COPPIA X,Y ALL'INCREMENTO PIU' VICINO SUGLI ASSI *)
    X.At(I)^:= int((X.At(I)^ - A1) / A3 + 0.5);
    Y.At(I)^:= int((Y.At(I)^ - B1) / B3 + 0.5);
  end;
  (* CALCOLA LE COORDINATE ADDIZIONALI X & Y *)
  Y.At(N + 1)^:= int(B2 + 0.5) + 1;
  X.At(N + 1)^:= int((A2 - A1) / A3 + 0.5) + 1;
  (* ANNOTA DOVE GLI ASSI SI INCROCIANO *)
  Istr:= 'INTERSEZIONE DEGLI ASSI IN (' + DynaOut(a1) + ',' +  DynaOut(b1) + ')';
  (* ORGANIZZA LE COORDINATE ORDINANDO LE X DALLA PIU' PICCOLA ALLA PIU' GRANDE *)
  FOR J:= 1 TO N do begin
    FOR I:= 1 TO N - J do begin
      A:= X.At(I)^;
      B:= Y.At(I)^;
      C:= X.At(I + 1)^;
      D:= Y.At(I + 1)^;
      IF A>=C THEN begin
        X.At(I)^:= C;
        Y.At(I)^:= D;
        X.At(I + 1)^:= A;
        Y.At(I + 1)^:= B;
      end;
    end;
  end;
  ClrScr;
  (* IL PUNTO SUCCESSIVO DA DISEGNARE E' MEMORIZZATO IN T *)
  T:= 1;
  (* OMETTE I PUNTI CHE ESCONO DALLE X POSITIVE *)
  FOR i:= 0 TO N - 1 do begin
    IF X.At(i + 1)^ >= 0 THEN begin
      p:= i;
      break;
    end;
  end;
  (* CICLO PER RICHIAMARE OGNI INCREMENTO DELLA X PER LINEA DI SCRITTURA *)
  FOR I:= 0 TO trunc((A2 - A1) / A3 + 0.5) do begin
    T:= T + P;
    (* CONTA IL NUMERO DI PUNTI DA DISEGNARE SU OGNI LINEA IN P *)
    P:= 0;
    (* TUTTI I PUNTI SONO STATI DISEGNATI? *)
    IF T>N THEN goto l540;
    (* SE IL VALORE DELLA X DA DISEGNARE CORRISPONDE AL NUMERO DELLA LINEA ALLORA CONTROLLA LA Y *)
    IF X.At(T)^ = I THEN goto l590;
    (* E' LA PRIMA LINEA? SE SI ALLORA DISEGNA L'ASSE Y *)
  l540:
    IF I = 0 THEN goto l570;
    (* DISEGNA L'ASSE X *)
    Write('*');
    GOTO l1040;
  l570:
    S:= N + 1;
    GOTO l920;
  l590:
    FOR L:= T TO N do begin
      (* IL PROSSIMO PUNTO E' DISEGNATO SULLA STESSA LINEA? *)
      IF X.At(L)^ > X.At(T)^ THEN begin
        L:= N;
        break;
      end
      else begin
        (* CONTA I PUNTI DA DISEGNARE SULLA STESSA LINEA *)
        P:= P + 1;
      end;
    end;
    (* DISEGNA UN PUNTO *)
    IF P <> 1 THEN begin
      (* CICLO PER RIORDINARE LE COORDINATE Y CON LE STESSE COORDINATE X *)
      (* RIORDINA DALLA PIU' PICCOLA ALLA PIU' GRANDE *)
      FOR J:= 1 TO P do begin
        FOR L:= 1 TO P - J do begin
          D:= Y.At(T + L - 1)^;
          B:= Y.At(T + L)^;
          IF D > B THEN begin
            Y.At(T + L - 1)^:= B;
            Y.At(T + L)^:= D;
          end;
        end;
      end;
    end;
    FOR L:= 0 TO P - 1 do begin
      Z:= trunc(Y.At(T + L)^);
      (* RICERCA LE COORDINATE CHE ESCONO DAI LIMITI *)
      IF Z >= 0 THEN break;
    end;
    (* BISOGNA DISEGNARE UN PUNTO SULL'ASSE X? *)
    IF I = 0 THEN goto l910;
    (* BISOGNA DISEGNARE UN PUNTO SULL'ASSE Y? *)
    IF Z <> 0 THEN begin
      (* DISEGNA L'ASSE X *)
      Write('*');
    end;
    IF L = P - 1 THEN goto l870;
    FOR J:= L TO P - 1 do begin
      (* RICERCA LE COORDINATE Y CHE ESCONO DAI LIMITI *)
      IF Z>B2 THEN goto l1040;
      (* EVITA LE COORDINATE DOPPIE *)
      IF Y.At(T + J)^ <> Z THEN begin
        (* DISEGNA IL PUNTO *)
        GotoXY(Z+1, WhereY); Write('+');
        Z:= trunc(Y.At(T + J)^);
      end;
    end;
    (* RICERCA LE COORDINATE Y CHE ESCONO DAI LIMITI *)
  l870:
    IF Z<0 THEN goto l1040;
    IF Z>B2 THEN goto l1040;
    (* DISEGNA IL PUNTO *)
    GotoXY(Z+1, WhereY); Write('+');
    GOTO l1040;
  l910:
    S:= T + L;
    (* CICLO PER STABILIRE LA STAMPA PER LA PRIMA LINEA *)
  l920:
    FOR J:= 0 TO trunc(B2) do begin
      (* PUNTO DA DISEGNARE? *)
      IF Y.At(S)^ <> J THEN begin
        (* DISEGNA L'ASSE Y *)
        Write('*');
      end
      else begin
        (* DISEGNA IL PUNTO *)
        Write('+');
        (* EVITA LE COORDINATE DOPPIE *)
        FOR K:= S TO T + P - 1 do begin
          IF Y.At(K)^ <> Y.At(S)^ THEN begin
            S:= K;
            break;
          end;
        end;
      end;
    end;
    (* DENOMINA L'ASEE Y *)
    Write('Y');
    (* AVANZA ALLA LINEA SUCCESSIVA *)
  l1040:
    Writeln;
  end;
  (* DENOMINA L'ASSE X *)
  Writeln('X');
  Writeln;
  (* STAMPA L'INTERSEZIONE *)
  Writeln(Istr);
end.
