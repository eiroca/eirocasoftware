unit MathStat;

interface

uses
  eLib, eLibMath;

type
  TReal = double;  (* > 64 bits *)
  TBigReal = extended; (* > TReal *)
  TInteger = integer; (* > 32 bits *)

type

  TPopParam    =
    (media, varianza, scarto, scartocorr, varianzacorretta, coefvar,
     devmed, mediana, moda, range, quart1, quart3, IQR, minim, maxim,
     mediageo, devgeo, mediarm);
  TPopParamSet = set of TPopParam;
  TResult      = array[TPopParam] of TReal;

const

  CERT = 0.999999;
  IMPO = 1-CERT;
  TINY = 100 * IMPO;
  BIG  = 1/TINY;

  RADICEDUEPI      = 2.5066282746;
  UNOSURADICEDUEPI = 0.3989422804;
  ONEOVER12        = 1.0 / 12;
  ONE              = 1.0;
  HALF             = 0.5;

function GetLivFid: TReal;

(* Generiche *)
function Multinomial(Num: TInteger; Val: PIntegerArr): TReal;

procedure ComputeMedVar(var Dati: TSerie; var Result: TResult);
procedure CalcAveVar(var Dati: TSerie; var ave, sig: TReal; srt: boolean);
procedure CalcAveVarMinMax(var Dati: TSerie; var ave, sig, min, max: TReal; srt: boolean);
(* Stima bayessiana normale+campionatura da normale => nuova normale *)
procedure StimaBayessiana(mu, si: TReal; av, vr: TReal; n: TInteger; var mu2, si2: TReal);

implementation

function GetLivFid: TReal;
const
  Alpha: TReal = 0.05;
begin
  Alpha:= Alpha * 100;
  InputTReal('Livello del rischio (‡) del test in %: ',Alpha,0,100);
  Alpha:= Alpha * 0.01;
  if Alpha < IMPO then Alpha:= IMPO else if Alpha > CERT then Alpha:= CERT;
  GetLivFid:= 1 - Alpha;
end;

function Multinomial(Num: TInteger; Val: PIntegerArr): TReal;
(* calculates (‰Dat[i])! / (Ô(Dat[i]!) *)
var
  n: TInteger;
  i: TInteger;
  tmp: TBigReal;
begin
  {$R-} (* Richesto!!!!!! *)
  if Num < 1 then begin
    Multinomial:= 0;
    exit;
  end;
  n:= 0;
  for i:= 0 to pred(Num) do inc(n, Val^[i]);
  tmp:= Fattoriale(n);
  for i:= 0 to pred(Num) do tmp:= tmp / Fattoriale(Val^[i]);
  Multinomial:= tmp;
  {$IFDEF RP}
    {$R+}
  {$ENDIF}
end;

procedure ComputeMedVar(var Dati: TSerie; var Result: TResult);
var
  pp, qq, r, m : TReal;
  i: integer;
  q : longint;
  N : longint;
  flg: boolean;
  p0, p1 : integer;
begin
  with Dati do begin
    R := 0;
    M := 0;
    N:= Count;
    for I := First to Last do begin
      (* accumula i valori intermedi per la media *)
      R := R + At(i)^;
      (* accumula i valori intermadi per la varianza *)
      M := M + sqr(At(i)^);
    end;
    if N = 0 then exit;
    (* calcola la media e la varianza *)
    Result[media]    := R / N;
    Result[varianza] := (M - R * R / N) / N;
    Result[scarto]:= sqrt(Result[varianza]);
    if (N > 1) then begin
      Result[varianzacorretta] := (M - sqr(R) / N) / (N - 1);
      Result[scartocorr]:= sqrt(Result[varianzacorretta]);
    end
    else begin
      Result[varianzacorretta]:= -1; (* Invalida *)
      Result[scartocorr]:= -1; (* Invalida *)
    end;
    Result[coefvar]:= Result[scarto] / Result[media];
    R:= 0;
    for i:= First to Last do begin
      R:= R + abs(At(i)^ - Result[media]);
    end;
    Result[devmed]:= R / N;
    Result[moda]:= At(Last)^;
    p0:= Count shr 1; if odd(N) then p1:= p0 else p1:= succ(p0);
    QuickSortDato(Dati, 0, 0);
    Result[minim]:= At(First)^;
    Result[maxim]:= At(Last)^;
    Result[mediana]:= (At(p0)^ + At(p1)^) * 0.5;
    Result[range]:= At(Last)^ - At(First)^;
    Result[quart1]:= At(succ(Last) shr 2 + First)^;
    Result[quart3]:= At(succ((Last)*3) shr 2 + First)^;
    Result[IQR]:= Result[quart3] - Result[quart1];
    Result[mediageo]:= -1;
    Result[devgeo]:= -1;
    Result[mediarm]:= -1;
    (* Calcolo media geometrica *)
    if n > 0 then begin
      Pp := 1 / N;
      M := 1;
      flg:= true;
      for I := First TO Last do begin
        if At(i)^ <= Zero then begin
          flg:= false;
          break;
        end;
        M := M * Pow(At(i)^, pp);
        Qq := Qq + sqr(ln(At(i)^));
      end;
      if flg then begin
        Result[mediageo]:= M;
        Result[devgeo]:= EXP(sqrt(qq / (N - 1) - (N / (N - 1) * sqr(ln(M))))); (* calcola la deviazione *)
      end;
    end;
    R := 0;
    flg:= true;
    for I := First to Last do begin
      if At(i)^ <= 0 then begin
        flg:= false;
        break;
      end;
      (* accumula i valori intermedi per la media *)
      R := R + 1 / At(i)^;
    end;
    if flg then Result[mediarm]:= N / R;
  end;
end;

procedure CalcAveVar(var Dati: TSerie; var ave, sig: TReal; srt: boolean);
var
  a, b: TReal;
  i: TInt;
  tmp: TReal;
  sm, sm2: DTReal;
(* Il flag srt, fa si che vengano usati gli algoritmi piu' TRealisi a
   scapito di un piccolo rallentamento, ATTENZIONE, questi algoritmi
   ordinano l'array dei dati!! *)
begin
  with Dati do begin
    if Srt then begin
      QuickSortDato(Dati, 0, 0);
      a:= -At(1)^;
      b:= 1 / (At(Count)^ - a);
    end
    else begin
      a:= 0;
      b:= 1;
    end;
    sm:= 0;
    sm2:= 0;
    for i:= 1 to Count do begin
      tmp:= (At(i)^ + a) * b;
      sm:= sm + tmp;
      sm2:= sm2 + sqr(tmp);
    end;
    ave:= (sm / Count);
    if Count <= 1 then sig:= 0
    else sig:= sqrt((sm2 - sqr(sm)/Count) / pred(Count));
    ave:= ave / b - a;
    sig:= sig / b;
  end;
end;

procedure CalcAveVarMinMax(var Dati: TSerie; var ave, sig, min, max: TReal; srt: boolean);
var
  a, b: TReal;
  i: TInteger;
  tmp: TReal;
  sm, sm2: TBigReal;
(* Il flag srt, fa si che vengano usati gli algoritmi piu' TRealisi a
   scapito di un piccolo rallentamento, ATTENZIONE, questi algoritmi
   ordinano l'array dei dati!! *)
begin
  with Dati do begin
    if Srt then begin
      QuickSortDato(Dati, 0, 0);
      a:= -At(1)^;
      b:= 1 / (At(Count)^ - a);
    end
    else begin
      a:= 0;
      b:= 1;
    end;
    min:= (At(First)^+a)*b;
    max:= (At(Last)^+a)*b;
    sm:= 0;
    sm2:= 0;
    for i:= 1 to Count do begin
      tmp:= (At(i)^ + a) * b;
      sm:= sm + tmp;
      sm2:= sm2 + sqr(tmp);
      if tmp < min then Min:= tmp
      else if tmp > max then Max:= tmp;
    end;
    ave:= (sm / Count);
    if Count <= 1 then sig:= 0
    else sig:= sqrt((sm2 - sqr(sm)/Count) / pred(Count));
    ave:= ave / b - a;
    sig:= sig / b;
    min:= min / b - a;
    max:= max / b - a;
  end;
end;

procedure StimaBayessiana(mu, si: TReal; av, vr: TReal; n: TInteger; var mu2, si2: TReal);
begin
  mu2:= (n * av * sqr(si) + mu * sqr(vr)) / (n * sqr(si) + sqr(vr));
  si2:= sqrt( (sqr(si)*sqr(vr)) / (n*sqr(si)+sqr(vr)) );
end;

{$UNDEF RP}

end.
