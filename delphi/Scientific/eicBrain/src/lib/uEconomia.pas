(* GPL > 3.0
Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)
(*
 @author(Enrico Croce)
*)
unit uEconomia;

interface

uses
  eLibMath;

const
  SMALL = 0.000001;

type

(* KNOW-HOW utilizzato:

¦ Abbreviazioni usate

 r (ratio) = tasso di interesse effettivo di un periodo
 m (ammount) = montante
 c (capital) = capitale iniziale
 n (annuity) = numero dei periodi
 p (payment) = +prelievo, -deposito
 I (interest) = ammontare interessi
 t = flag,
   t:= 0 => pagamenti posticipati
   t:= 1 => pagamenti anticipati

¦ Definizione di interesse

 I = m - c

¦ Interessi Semplici

 m = c + I
 I = c ^ r ^ n

¦ Interessi Composti

 Equazione annualita' di equilibrio

                          (1+r)^n - 1
 m -  c*(1+r)^n + p*(1+r^t)^----------  = 0
                               r
     ---------   --------------------
         ¦                +------------   capitalizzazione pagamenti
         +-----------------------------   capitalizzazione del capitale

¦ Calcolo dei tassi equivalenti effettivi

 i' , n'  =  1º tasso di interesse e relativi periodi
 i° , n°  =  2º tasso di interesse e relativi periodi

 relazione di equivalenza tassi effettivi:
 (1 + i')^n' = (1 + i°)^n°

 relazione di equivalenza tassi nominali:
 i'^n' = i°^n°

*)

  TAttRec = record
    m: double;
    c: double;
    r: double;
    n: double;
    p: double;
    t: integer;
    I: double;
  end;

  TAnnuity = class
    m: double;
    c: double;
    r: double;
    n: double;
    p: double;
    t: integer;
    constructor TAnnuity;
    procedure CalcM;
    procedure CalcC;
    procedure CalcR;
    procedure CalcN;
    procedure CalcP;
    procedure CalcT;
  end;

  TIntComp = class(TAnnuity)
    I: double;
    constructor TIntComp;
    procedure CalcMI;
    procedure CalcCI;
    procedure CalcRI;
    procedure CalcNI;
    procedure CalcPI;
    procedure CalcTI;
    procedure CalcMR;
    procedure CalcMN;
    procedure CalcMP;
    procedure CalcMT;
    procedure CalcCR;
    procedure CalcCN;
    procedure CalcCP;
    procedure CalcCT;
    procedure CalcMC;
  end;

  TTasso = class
    i0: double;
    n0: double;
    i1: double;
    n1: double;
    constructor TTasso;
    procedure   CalcI0;
    procedure   CalcN0;
    procedure   CalcI1;
    procedure   CalcN1;
  end;

  TIntSemp = class
    m: double;
    c: double;
    I: double;
    r: double;
    n: double;
    constructor TIntSemp;
    procedure CalcMI;
    procedure CalcCI;
    procedure CalcRI;
    procedure CalcNI;
    procedure CalcMC;
    procedure CalcMR;
    procedure CalcMN;
    procedure CalcCR;
    procedure CalcCN;
  end;

implementation

uses
  Math;

constructor TAnnuity.TAnnuity;
begin
  r:= 1;
  m:= 0;
  c:= 0;
  n:= 0;
  p:= 0;
  t:= 0;
end;

procedure TAnnuity.CalcM;
var tmp: double;
begin
  if (r < cZero) then begin
    m:= c + n * p;
  end
  else begin
    tmp:= Power(1+r, n);
    m := c * tmp;
    if p <> 0 then m:= m + p * (1 + r * t) * ((tmp - 1) / r);
  end;
end;

procedure TAnnuity.CalcC;
var tmp: double;
begin
  if p <> 0 then begin
    if (r < cZero) then begin
      c:= m - n * p;
    end
    else begin
      tmp:= p * (r * t + 1) / r;
      c := (m + tmp) * Power(r+1,-n) - tmp;
    end;
  end
  else c := m * Power(r+1,-n);
end;

procedure TAnnuity.CalcR;
var
  x0, x1, x: double;
  y0, y1, y: double;
  function f(x: double): double;
  var tmp: double;
  begin
    tmp:= Power(1+x, n);
    f:= m - c * tmp - p * (1 + x * t) * ((tmp - 1) / x);
  end;
begin
  (* Ricerca 0 con metodo bisezione *)
  x0:= SMALL; y0:= f(x0);
  X1:=  100; y1:= f(x1);
  if (Sign(y0) * Sign(y1) > 0) then begin
    x0:= -SMALL; y0:= f(x0);
    X1:= -1   ; y1:= f(x1);
    if (Sign(y0) * Sign(y1) > 0) then begin
      R:= 0;
      exit;
    end;
  end;
  repeat
    x := (x1 + x0) * 0.5;
    y := f(x);
    if Sign(y1) * Sign(y) > 0 then begin
      y1:= y;
      x1:= x;
    end
    else begin
      x0:= x;
    end;
  until abs(x1 - x0) <= SMALL;
  R:= (x1 + x0) * 0.5;
end;

procedure TAnnuity.CalcN;
var tmp: double;
begin
  if (r < cZero) then begin
    n:= (m-c) / p;
  end
  else begin
    tmp:= p * (r * t + 1);
    n := LN((m * r + tmp) / (c * r + tmp)) / LN(r+1);
  end;
end;

procedure TAnnuity.CalcP;
var tmp: double;
begin
  if (r<cZero) then begin
    p := (m - c) / n;
  end
  else begin
    tmp:= Power(r+1,n);
    p := r * (m - c * tmp) / ((tmp - 1) * (r * t + 1));
  end;
end;

procedure TAnnuity.CalcT;
var tmp: double;
begin
  tmp:= Power(1+r, n);
  T:= trunc(((((c * tmp - m) * r) / (p * (tmp - 1))) - 1) / r);
end;

constructor TIntComp.TIntComp;
begin
  r:= 1;
  m:= 0;
  c:= 0;
  n:= 0;
  p:= 0;
  t:= 0;
  I:= 0;
end;

procedure TIntComp.CalcMI;
begin
  CalcM;
  I:= m - c;
end;

procedure TIntComp.CalcCI;
begin
  CalcC;
  I:= m - c;
end;

procedure TIntComp.CalcRI;
begin
  CalcR;
  I:= m - c;
end;

procedure TIntComp.CalcNI;
begin
  CalcN;
  I:= m - c;
end;

procedure TIntComp.CalcPI;
begin
  CalcP;
  I:= m - c;
end;

procedure TIntComp.CalcTI;
begin
  CalcT;
  I:= m - c;
end;

procedure TIntComp.CalcMR;
begin
  m:= c + I;
  CalcR;
end;

procedure TIntComp.CalcMN;
begin
  m:= c + I;
  CalcN;
end;

procedure TIntComp.CalcMP;
begin
  m:= c + I;
  CalcP;
end;

procedure TIntComp.CalcMT;
begin
  m:= c + I;
  CalcT;
end;

procedure TIntComp.CalcCR;
begin
  c:= m - I;
  CalcR;
end;

procedure TIntComp.CalcCN;
begin
  c:= m - I;
  CalcN;
end;

procedure TIntComp.CalcCP;
begin
  c:= m - I;
  CalcP;
end;

procedure TIntComp.CalcCT;
begin
  c:= m - I;
  CalcT;
end;

procedure TIntComp.CalcMC;
var tmp: double;
begin
  tmp:= Power(1+r, n);
  m:= (p * (1 + r * t) * ((tmp - 1) / r) - I * tmp) / (1 - tmp);
  c:= m - I;
end;

constructor TTasso.TTasso;
begin
  i0:= 1;
  i1:= 1;
  n0:= 1;
  n1:= 1;
end;

procedure TTasso.CalcI0;
begin
  I0:= exp(n1 * ln(1+i1) / n0) - 1;
end;

procedure TTasso.CalcI1;
begin
  I1:= exp(n0 * ln(1+i0) / n1) - 1;
end;

procedure TTasso.CalcN0;
begin
  N0:= n1 * ln(1+i1) / ln(1 + i0);
end;

procedure TTasso.CalcN1;
begin
  N1:= n0 * ln(1+i0) / ln(1 + i1);
end;

constructor TIntSemp.TIntSemp;
begin
  m:= 0;
  c:= 0;
  I:= 0;
  n:= 0;
  r:= 1;
end;

procedure TIntSemp.CalcMI;
begin
  I:= c * r * n;
  m:= c + I;
end;

procedure TIntSemp.CalcCI;
begin
  if (r>cZERO) then begin
    c:= m / (1 + r * n);
  end
  else begin
    c:= m;
  end;

  I:= m - c;
end;

procedure TIntSemp.CalcRI;
begin
  I:= m - c;
  r:= I / (c * n);
end;

procedure TIntSemp.CalcNI;
begin
  I:= m - c;
  n:= I / c * r;
end;

procedure TIntSemp.CalcMC;
begin
  c:= I / (n * r);
  m:= c + I;
end;

procedure TIntSemp.CalcMR;
begin
  m:= c + I;
  r:= I / (c * n);
end;

procedure TIntSemp.CalcMN;
begin
  m:= c + I;
  n:= I / (c * r);
end;

procedure TIntSemp.CalcCR;
begin
  c:= m - I;
  r:= I / (r * n);
end;

procedure TIntSemp.CalcCN;
begin
  c:= m - I;
  n:= I / (c * r);
end;

end.
