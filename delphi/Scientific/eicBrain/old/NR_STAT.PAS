unit MathStt3;

{$R-,S-} (* Sono da Numerical Recepits, dovrebbero essere corrette?!?! *)

interface

uses MathStat, Matrix, MathStt1, MathTool;

const big = 100000000000.0;

procedure avevar(var data: TRMatrix; n: integer; var ave, vr: PREC); 
function  gammln(xx: PREC): PREC;
function  gammp(a, x: PREC): PREC;
function  gammq(a, x: PREC): PREC;
procedure gser(var gamser: PREC; a, x: PREC; var gln: PREC);
procedure gcf(var gammcf: PREC; a, x: PREC; var gln: PREC);
function  erf(x: PREC): PREC;
function  erfc(x: PREC): PREC;
function  erfcc(x: PREC): PREC;
procedure ttest(var data1: TRMatrix; n1: integer; var data2: TRMatrix; n2: integer; var t, prob:  PREC);
procedure ftest(var data1: TRMatrix; n1: integer; var data2: TRMatrix; n2: integer; var f, prob: PREC);
procedure tptest(var data1, data2: TRMatrix; n: integer; var t,prob: PREC);
procedure tutest(var data1: TRMatrix; n1: integer; data2: TRMatrix; n2: integer; var t, prob: PREC);
procedure pearsn(var x, y: TRMatrix; n: integer; var r, prob, z: PREC);
procedure spear(var data1, data2: TRMatrix; n: integer; 
              var wksp1, wksp2: TRMatrix; var d, zd, probd, rs, probrs: PREC);
procedure kendl1(var data1,data2: TRMatrix; n: integer; var tau, z, prob: PREC);
procedure medfit(var x, y: TRMatrix; ndata: integer; 
  var a, b, abdev: PREC; ndatat: integer; var xt, yt, arr: TRMatrix; var aa, abdevt: PREC);
procedure kstwo(var data1: TRMatrix; n1: integer; var data2: TRMatrix; n2: integer; var d, prob: PREC);
procedure ksone(var data: TRMatrix; n: integer; func: F_x; var d, prob: PREC);
procedure fit(var x,y: TRMatrix; ndata: integer; sig: TRMatrix; var mwt,a,b,siga,sigb,chi2,q: PREC);
procedure moment(var data: TRMatrix; n: integer; var ave,adev,sdev,vr,skew,curt: PREC);
function rofunc(b: PREC; ndata: integer; var x, y, arr: TRMatrix; var aa, abdev: PREC): PREC;
procedure mdian1(var x: TRMatrix; n: integer; var xmed: PREC);
(*
procedure mdian2(var x: TRMatrix; n: integer; var xmed: PREC);
*)

implementation

const itmax = 50;

procedure avevar(var data: TRMatrix; n: integer; var ave, vr: PREC);
var j: integer;
begin
  ave:= 0.0;
  vr:= 0.0;
  for j:= 1 to n do begin
    ave:= ave + data.G(j,1);
    vr:= vr + sqr(data.G(j,1));
  end;
  ave:= ave/n;
  vr:= (vr - sqr(ave)) / (n-1);
end;

function gammp(a, x: PREC): PREC;
var gamser, gammcf, gln: PREC;
begin      
  if (x < 0) or (a <= 0) then ErrorHandler(ERR_GAMMPPARAM);
  if (x < a+1) then begin
    gser(gamser, a, x, gln);
    gammp:= gamser;
  end
  else begin
    gcf(gammcf, a, x, gln);
    gammp:= 1 - gammcf;
  end;
end;

function gammq(a, x: PREC): PREC;
var gamser, gammcf, gln: PREC;
begin
  if (x < 0) or (a <= 0) then ErrorHandler(ERR_GAMMQPARAM);
  if (x < a+1) then begin
    gser(gamser, a, x, gln);
    gammq:= 1 - gamser;
  end
  else begin
    gcf(gammcf, a, x, gln);
    gammq:= gammcf;
  end;
end;

function erf(x: PREC): PREC;
begin
  if (x < 0) then begin
    erf:= -gammp(0.5, sqr(x));
  end
  else begin
    erf:= gammp(0.5, sqr(x));
  end;
end;

function erfc(x: PREC): PREC;
begin
  if (x < 0) then begin
    erfc:= 1+gammp(0.5, sqr(x));
  end
  else begin
    erfc:= gammq(0.5,sqr(x));
  end;
end;

function erfcc(x: PREC): PREC;
var z, t, tmp: PREC;
begin
  z:= abs(x);
  t:= 1/(1 + 0.5*z);
  tmp:= t*exp(-z*z -1.26551223 + t*(1.00002368 + t*(0.37409196 + 
   t*(0.09678418 + t*(-0.18628806 + t*(0.27886807 + t*(-1.13520398 + t*(1.48851587 + t*(-0.82215223 + t*0.17087277)))))))));
  if (x < 0) then erfcc:= 2 - tmp else erfcc:= tmp;
end;

procedure ttest(var data1: TRMatrix; n1: integer; var data2: TRMatrix; n2: integer; var t, prob:  PREC);
var
  ave1, var1 : PREC;
  ave2, var2 : PREC;
  vari: PREC;
  df : integer;
begin
  avevar(data1, n1, ave1, var1);
  avevar(data2, n2, ave2, var2);
  df:= n1 + n2 - 2;
  vari:= ((n1-1) * var1 + (n2-1) * var2) / df;
  t:= (ave1 - ave2) / sqrt(vari * (1/n1 + 1/n2));
  prob:= DistBetaXVal(df/(df+sqr(t)), 0.5*df, 0.5);
end;

procedure ftest(var data1: TRMatrix; n1: integer; var data2: TRMatrix; n2: integer; var f, prob: PREC);
var 
  ave1, var1: PREC;
  ave2, var2: PREC;
  df1, df2 : integer;
begin
  avevar(data1, n1, ave1, var1);
  avevar(data2, n2, ave2, var2);
  if (var1 > var2) then begin
    f:= var1 / var2;
    df1:= n1-1;
    df2:= n2-1;
  end
  else begin
    f:= var2 / var1;
    df1:= n2-1;
    df2:= n1-1;
  end;
  prob:= DistBetaXVal(df2/(df2+df1*f), 0.5*df2, 0.5*df1) + (1-DistBetaXVal(df1/(df1+df2/f), 0.5*df1, 0.5*df2));
end;

procedure gser(var gamser: PREC; a, x: PREC; var gln: PREC);
var 
  ap, sum, del: PREC;
  n : integer;
begin
  gln:= gammln(a);
  if (x <= 0) then begin
    if (x < 0) then ErrorHandler(ERR_OUTOFRANGE);
    gamser:= 0;
    exit;
  end;
  ap:= a;
  sum:= 1/a;
  del:= sum;
  for n:= 1 to itmax do begin
    ap:= ap+1;
    del:= del*x/ap;
    sum:= sum+del;
    if (abs(del) < abs(sum) * ZERO) then begin
      gamser:= sum*exp(-x + a * ln(x) - gln);
      exit;
    end;
  end;
  ErrorHandler(ERR_NOCONVERGE);
end;

procedure gcf(var gammcf: PREC; a, x: PREC; var gln: PREC);
var 
  g, an, ana, anf, a0, a1, b0, b1, fac, gold: PREC;
  n : integer;
begin
  gln:= gammln(a);
  gold:= 0;
  a0:= 1;
  a1:= x;
  b0:= 0;
  b1:= 1;
  fac:= 1;
  for n:= 1 to itmax do begin
    an:= n;
    ana:= an-a;
    a0:= (a1+a0*ana)*fac;
    b0:= (b1+b0*ana)*fac;
    anf:= an*fac;
    a1:= x*a0+anf*a1;
    b1:= x*b0+anf*b1;
    if (a1 <> 0) then begin
      fac:= 1/a1;
      g:= b1*fac;
      if (abs((g-gold)/g) < ZERO) then begin
        gammcf:= exp(-x + a * ln(x) - gln) * g;
        exit;
      end;
      gold:= g;
    end;
  end;
  ErrorHandler(ERR_NOCONVERGE);
end;

procedure tptest(var data1, data2: TRMatrix; n: integer; var t,prob: PREC);
var 
  ave1, var1, ave2, var2: PREC;
  sd, cov: PREC;
  df, j: integer;
begin
  avevar(data1, n, ave1, var1);
  avevar(data2,n,ave2,var2);
  cov:= 0;
  for j:= 1 to n do begin
    cov:= cov+(data1.G(j,1) - ave1)*(data2.G(j,1) - ave2);
  end;
  df:= n-1;
  cov:= cov/df;
  sd:= sqrt((var1+var2-2.*cov)/n);
  t:= (ave1-ave2)/sd;
  prob:= DistBetaXVal(df/(df+sqr(t)), 0.5*df, 0.5);
end;

procedure tutest(var data1: TRMatrix; n1: integer; data2: TRMatrix; n2: integer; var t, prob: PREC);
var 
  ave1, var1, ave2, var2, df: PREC;
begin
  avevar(data1,n1,ave1,var1);
  avevar(data2,n2,ave2,var2);
  t:= (ave1-ave2) / sqrt(var1/n1+var2/n2);
  df:= sqr(var1/n1+var2/n2) / (sqr(var1/n1)/(n1-1) + sqr(var2/n2)/(n2-1));
  prob:= DistBetaXVal(df/(df+sqr(t)), 0.5*df, 0.5);
end;

procedure pearsn(var x, y: TRMatrix; n: integer; var r, prob, z: PREC);
var
  t, xt, yt, ax, ay, sxx, syy, sxy: PREC;
  df, j : integer;
begin      
  ax:= 0;
  ay:= 0;
  for j:= 1 to n do begin
    ax:= ax+x.G(j,1);
    ay:= ay+y.G(j,1);
  end;
  ax:= ax/n;
  ay:= ay/n;
  sxx:= 0;
  syy:= 0;
  sxy:= 0;
  for j:= 1 to n do begin
    xt:= x.G(j,1)-ax;
    yt:= y.G(j,1)-ay;
    sxx:= sxx+sqr(xt);
    syy:= syy+sqr(yt);
    sxy:= sxy+xt*yt;
  end;
  r:= sxy/sqrt(sxx*syy);
  z:= 0.5 * ln(((1+r)+tiny) / ((1-r)+tiny));
  df:= n-2;
  t:= r * sqrt(df/(((1-r)+tiny) * ((1+r)+tiny)));
  prob:= DistBetaXVal(df/(df+sqr(t)), 0.5*df, 0.5);
  (* prob:= erfcc(abs(z*sqrt(n-1))/1.4142136); *)
end;

procedure crank(n: integer; w: TRMatrix; var s: PREC);
var 
  j, jt, ji: integer;
  rank, t: PREC;
label 1, 2;
begin      
  s:= 0;
  j:= 1;
1:     
  if (j < n) then begin
    if (w.G(j+1,1) <> w.G(j,1)) then begin
      w.P(j, 1, j);
      j:= j+1;
    end
    else begin
      for jt:= j+1 to n do begin
	if (w.G(jt,1) <> w.G(j,1)) then goto 2;
      end;
      jt:= n+1;
2:         
      rank:= 0.5*(j+jt-1);
      for ji:= j to jt-1 do begin
	w.P(ji, 1,rank);
      end;
      t:= jt-j;
      s:= s+sqr(t)*t-t;
      j:= jt;
    end;
    goto 1;
  end;
  if (j = n) then w.P(n, 1, n);
end;

procedure spear(var data1, data2: TRMatrix; n: integer; 
              var wksp1, wksp2: TRMatrix; var d, zd, probd, rs, probrs: PREC);
var 
  df, en, en3n, j: integer;
  t, fac, vard, aved, sf, sg: PREC;
begin
  for j:= 1 to n do begin
    wksp1.P(j, 1, data1.G(j,1));
    wksp2.P(j, 1, data2.G(j,1));
  end;
(*
  sort2(n, wksp1, wksp2);
*)
  crank(n, wksp1, sf);
(*
  sort2(n, wksp2, wksp1);
*)
  crank(n, wksp2, sg);
  d:= 0;
  for j:= 1 to n do begin
    d:= d + sqr(wksp1.G(j,1) - wksp2.G(j,1));
  end;
  en:= n;
  en3n:= en*sqr(en) - en;
  aved:= en3n/6 - (sf+sg)/12;
  fac:= (1-sf/en3n)*(1-sg/en3n);
  vard:= ((en-1) * sqr(en) * sqr(en+1) / 36) * fac;
  zd:= (d-aved)/sqrt(vard);
  probd:= erfcc(abs(zd)/1.4142136);
  rs:= (1-(6./en3n)*(d+0.5*(sf+sg)))/fac;
  t:= rs * sqrt((en-2) / ((1+rs) * (1-rs)));
  df:= en-2;
  probrs:= DistBetaXVal(df/(df+sqr(t)), 0.5*df,0.5);
end;

function probks(alam: PREC): PREC;
var 
  probk, termbf, term, fac, a2: PREC;
  j: integer;
begin
  a2:= -2* sqr(alam);
  fac:= 2;
  probk:= 0;
  termbf:= 0;
  for j:= 1 to 100 do begin
    term:= fac * exp(a2 * sqr(j));
    probk:= probk + term;
    if (abs(term) < ZERO*termbf) or (abs(term) < ZERO * probk) then begin
      probks:= probk;
      exit;
    end;
    fac:= -fac;
    termbf:= abs(term);
  end;
  probks:= 1;
end;

procedure kendl1(var data1,data2: TRMatrix; n: integer; var tau, z, prob: PREC);
var 
  k, n1, n2, is, j: integer;
  vr, a1, a2, aa: PREC;
begin
  n1:= 0;
  n2:= 0;
  is:= 0;
  for j:= 1 to n-1 do begin
    for k:= j+1 to n do begin
      a1:= data1.G(j,1) - data1.G(k,1);
      a2:= data2.G(j,1) - data2.G(k,1);
      aa:= a1*a2;
      if (aa <> 0) then begin
	n1:= n1+1;
	n2:= n2+1;
	if (aa > 0) then begin
	  is:= is+1;
	end
	else begin
	  is:= is-1;
	end;
      end
      else begin
	if (a1 <> 0) then n1:= n1+1;
	if (a2 <> 0) then n2:= n2+1;
      end;
    end;
  end;
  tau:= int(is) / sqrt(int(n1) * n2);
  vr := (4.0 * n + 10)/(9.0 * n * (n-1));
  z:= tau/sqrt(vr);
  prob:= erfcc(abs(z)/1.4142136);
end;

procedure kendl2(var tab: TRMatrix; i,j: integer; var tau,z,prob: PREC);
var
  vr, pairs, points, s, en1, en2: PREC;
  l, li, lj, k, ki, kj, nn: integer;
  m1, m2, mm: integer;
begin
  en1:= 0;
  en2:= 0;
  s:= 0;
  nn:= i*j;
  points:= tab.G(i,j);
  for k:= 0 to nn-2 do begin
    ki:= k div j;
    kj:= k-j*ki;
    points:= points+tab.G(ki+1,kj+1);
    for l:= k+1 to nn-1 do begin
      li:= l div j;
      lj:= l-j*li;
      m1:= li-ki;
      m2:= lj-kj;
      mm:= m1*m2;
      pairs:= tab.G(ki+1, kj+1) * tab.G(li+1, lj+1);
      if (mm <> 0) then begin
	en1:= en1+pairs;
	en2:= en2+pairs;
	if (mm > 0) then begin
	  s:= s+pairs;
	end
	else begin
	  s:= s-pairs;
	end;
      end
      else begin
	if (m1 <> 0) then en1:= en1+pairs;
	if (m2 <> 0) then en2:= en2+pairs;
      end;
    end;
  end;
  tau:= s/sqrt(en1*en2);
  vr:= (4 * points + 10) / (9* points * (points-1));
  z:= tau/sqrt(vr);
  prob:= erfcc(abs(z) / 1.4142136);
end;

procedure ksone(var data: TRMatrix; n: integer; func: F_x; var d, prob: PREC);
var 
  j, en: integer;
  fn, ff, dt, fo: PREC;
begin
(*
  sort(n, data);
*)
  en:= n;
  d:= 0;
  fo:= 0;
  for j:= 1 to n do begin
    fn:= j/en;
    ff:= func(data.G(j,1));    
    if abs(fo-ff) > abs(fn-ff) then dt:= abs(fo-ff) else dt:= abs(fn-ff);
    if (dt > d) then d:= dt;
    fo:= fn;
  end;
  prob:= probks(sqrt(en)*d);
end;

procedure kstwo(var data1: TRMatrix; n1: integer; var data2: TRMatrix; n2: integer; var d, prob: PREC);
var 
  j1, j2, en1, en2: integer;
  fn1, fn2, dt, fo1, fo2: PREC;
label 1;
begin
(*
  sort(n1,data1);
  sort(n2,data2);
*)
  en1:= n1;
  en2:= n2;
  j1:= 1;
  j2:= 1;
  fo1:= 0;
  fo2:= 0;
  d:= 0;
1:
  if (j1 <= n1) and (j2 <= n2) then begin
    if (data1.G(j1,1) < data2.G(j2,1)) then begin
      fn1:= j1/en1;
      dt:= max(abs(fn1-fo2),abs(fo1-fo2));
      if (dt > d) then d:= dt;
      fo1:= fn1;
      j1:= j1+1;
    end
    else begin
      fn2:= j2/en2;
      dt:= max(abs(fn2-fo1),abs(fo2-fo1));
      if (dt > d) then d:= dt;
      fo2:= fn2;
      j2:= j2+1;
    end;
    goto 1;
  end;
  prob:= probks(sqrt(en1*en2/(en1+en2))*d);
end;

procedure mdian1(var x: TRMatrix; n: integer; var xmed: PREC);
var 
  n2: integer;
begin
(*
  sort(n,x);
*)
  n2:= n div 2;
  if (2 * n2 = n) then begin
    xmed:= 0.5*(x.G(n2, 1) + x.G(n2+1, 1));
  end
  else begin
    xmed:= x.G(n2+1, 1);
  end;
end;

(*
procedure mdian2(var x: TRMatrix; n: integer; var xmed: PREC);
var
  dum, xx, xp, xm, aa, ap, am, sum, sumx, eps, a: PREC;
  j, np, nm: integer;
label 1;
begin
  a:= 0.5*(x.G(1, 1)+x.G(n, 1));
  eps:= abs(x.G(n, 1)-x.G(1, 1));
  ap:= big;
  am:= -big;
1:     
  sum:= 0;
  sumx:= 0;
  np:= 0;
  nm:= 0;
  xp:= big;
  xm:= -big;
  for j:= 1 to n do begin
    xx:= x.G(j, 1);
    if (xx <> a) then begin
      if (xx > a) then begin
	np:= np+1;
	if (xx < xp) then xp:= xx;
      end
      else if (xx < a) then begin
	nm:= nm+1;
	if (xx > xm) then xm:= xx;
      end;
      dum:= 1/(eps+abs(xx-a));
      sum:= sum+dum;
      sumx:= sumx+xx*dum;
    end;
  end;
  if (np-nm >= 2) then begin
    am:= a;
    aa:= xp+ max(0.0, sumx/sum-a) * am;
    if (aa > ap) then aa:= 0.5*(a+ap);
    eps:= afac*abs(aa-a);
    a:= aa;
    goto 1;
  end
  else if (nm-np >= 2) then begin
    ap:= a;
    aa:= xm+min(0,sumx/sum-a)*amp;
    if (aa < am) then aa:= 0.5*(a+am);
    eps:= afac*abs(aa-a);
    a:= aa;
    goto 1;
  end
  else begin
    if (n mod 2) = 0 then begin
      if (np = nm) then begin
	xmed:= 0.5*(xp+xm);
      end
      else if (np > nm) then begin
	xmed:= 0.5*(a+xp);
      end
      else begin
	xmed:= 0.5*(xm+a);
      end;
    end
    else begin
      if (np = nm) then begin
	xmed:= a;
      end
      else if (np > nm) then begin
	xmed:= xp;
      end
      else begin
	xmed:= xm;
      end;
    end;
  end;
end;
*)

function rofunc(b: PREC; ndata: integer; var x, y, arr: TRMatrix; var aa, abdev: PREC): PREC;
var 
   n1, nml, nmh, j: integer;
   d, sum: PREC;
begin      
  n1:= ndata+1;
  nml:= n1 div 2;
  nmh:= n1-nml;
  for j:= 1 to ndata do begin
    arr.P(j, 1, y.G(j, 1) - b*x.G(j, 1));
  end;
(*
  sort(ndata,arr);
*)
  aa:= 0.5*(arr.G(nml, 1)+arr.G(nmh, 1));
  sum:= 0;
  abdev:= 0;
  for j:= 1 to ndata do begin
    d:= y.G(j, 1)-(b*x.G(j, 1)+aa);
    abdev:= abdev+abs(d);
    sum:= sum+x.G(j, 1)* sgn(d);
  end;
  rofunc:= sum;
end;

procedure moment(var data: TRMatrix; n: integer; var ave,adev,sdev,vr,skew,curt: PREC);
var 
  p, s: PREC;
  j: integer;
begin
  if (n <= 1) then ErrorHandler(ERR_OUTOFRANGE);
  s:= 0;
  for j:= 1 to n do begin
    s:= s+data.G(j, 1);
  end;
  ave:= s/n;
  adev:= 0;
  vr:= 0;
  skew:= 0;
  curt:= 0;
  for j:= 1 to n do begin
    s:= data.G(j, 1)-ave;
    adev:= adev+abs(s);
    p:= s*s;
    vr:= vr+p;
    p:= p*s;
    skew:= skew+p;
    p:= p*s;
    curt:= curt+p;
  end;
  adev:= adev/n;
  vr:= vr/(n-1);
  sdev:= sqrt(vr);
  if (vr <> 0) then begin
    skew:= skew/(n*sqr(sdev)*sdev);
    curt:= curt/(n*sqr(vr))-3;
  end
  else begin
    ErrorHandler(ERR_ERROR00001);
  end;
end;

procedure medfit(var x, y: TRMatrix; ndata: integer; 
  var a, b, abdev: PREC; ndatat: integer; var xt, yt, arr: TRMatrix; var aa, abdevt: PREC);
var 
  f, b1, b2, f1, f2, sigb, chisq, bb, del, sx, sy, sxy, sxx: PREC;
  j: integer;
label 1, 2, 3;
begin
  sx:= 0;
  sy:= 0;
  sxy:= 0;
  sxx:= 0;
  for j:= 1 to ndata do begin
    xt.P(j, 1, x.G(j, 1));
    yt.P(j, 1, y.G(j, 1));
    sx:= sx+x.G(j, 1);
    sy:= sy+y.G(j, 1);
    sxy:= sxy+x.G(j, 1) * y.G(j, 1);
    sxx:= sxx+ sqr(x.G(j, 1));
  end;
  ndatat:= ndata;
  del:= ndata*sxx-sqr(sx);
  aa:= (sxx*sy-sx*sxy)/del;
  bb:= (ndata*sxy-sx*sy)/del;
  chisq:= 0;
  for j:= 1 to ndata do begin
    chisq:= chisq+sqr(y.G(j, 1) - (aa+bb*x.G(j, 1)));
  end;
  sigb:= sqrt(chisq/del);
  b1:= bb;
  f1:= rofunc(b1, ndatat,xt, yt, arr, aa, abdevt);
  b2:= bb+3*sigb* sgn(f1);
  f2:= rofunc(b2, ndatat,xt, yt, arr, aa, abdevt);
1:     
  if (f1*f2 > 0) then begin
    bb:= 2.*b2-b1;
    b1:= b2;
    f1:= f2;
    b2:= bb;
    f2:= rofunc(b2, ndatat,xt, yt, arr, aa, abdevt);
    goto 1;
  end;
  sigb:= 0.01*sigb;
2:     
  if (abs(b2-b1) > sigb) then begin
    bb:= 0.5*(b1+b2);
    if (bb = b1) or (bb = b2) then goto 3;
    f:= rofunc(bb, ndatat,xt, yt, arr, aa, abdevt);
    if (f*f1 >= 0) then begin
      f1:= f;
      b1:= bb;
    end
    else begin
      f2:= f;
      b2:= bb;
    end;
    goto 2;
  end;
3:     
  a:= aa;
  b:= bb;
  abdev:= abdevt/ndata;
end;

procedure fit(var x,y: TRMatrix; ndata: integer; sig: TRMatrix; var mwt,a,b,siga,sigb,chi2,q: PREC);
var
  sigdat, t, sxoss, wt, ss, sx, sy, st2: PREC; 
  i: integer;
begin
  sx:= 0;
  sy:= 0;
  st2:= 0;
  b:= 0;
  if (mwt <> 0) then begin
    ss:= 0;
    for i:= 1 to ndata do begin
      wt:= 1/(sqr(sig.G(i, 1)));
      ss:= ss+wt;
      sx:= sx+x.G(i, 1) * wt;
      sy:= sy+y.G(i, 1) * wt;
    end
  end
  else begin
    for i:= 1 to ndata do begin
      sx:= sx+x.G(i, 1);
      sy:= sy+y.G(i, 1);
    end;
    ss:= ndata;
  end;
  sxoss:= sx/ss;
  if (mwt <> 0) then begin
    for i:= 1 to ndata do begin
      t:= (x.G(i, 1) - sxoss) / sig.G(i, 1);
      st2:= st2+t*t;
      b:= b+t*y.G(i, 1) / sig.G(i, 1);
    end;
  end
  else begin
    for i:= 1 to ndata do begin
      t:= x.G(i, 1) - sxoss;
      st2:= st2+t*t;
      b:= b+t*y.G(i, 1);
    end;
  end;
  b:= b/st2;
  a:= (sy-sx*b)/ss;
  siga:= sqrt((1+sx*sx/(ss*st2))/ss);
  sigb:= sqrt(1/st2);
  chi2:= 0;
  if (mwt = 0) then begin
    for i:= 1 to ndata do begin
      chi2:= chi2+sqr(y.G(i, 1) - a - b*x.G(i, 1));
    end;
    q:= 1;
    sigdat:= sqrt(chi2/(ndata-2));
    siga:= siga*sigdat;
    sigb:= sigb*sigdat;
  end
  else begin
    for i:= 1 to ndata do begin
      chi2:= chi2+sqr((y.G(i, 1) - a-b*x.G(i, 1)) / sig.G(i, 1));
    end;
    q:= gammq(0.5*(ndata-2),0.5*chi2);
  end;
end;

procedure chsone(var bins, ebins: TRMatrix; nbins: integer; var knstrn, df, chsq, prob: PREC);
var 
  j: integer;
begin      
  df:= nbins-1-knstrn;
  chsq:= 0;
  for j:= 1 to nbins do begin
    if (ebins.G(j, 1) <= 0) then ErrorHandler(ERR_OUTOFRANGE);
    chsq:= chsq + sqr(bins.G(j, 1)-ebins.G(j, 1)) / ebins.G(j, 1);
  end;
  prob:= gammq(0.5*df,0.5*chsq);
end;

procedure chstwo(var bins1, bins2: TRMatrix; nbins: integer; var knstrn, df, chsq, prob: PREC);
var
  j: integer;
begin      
  df:= nbins-1-knstrn;
  chsq:= 0;
  for j:= 1 to nbins do begin
    if (bins1.G(j, 1) = 0) and (bins2.G(j, 1) = 0) then begin
      df:= df-1;
    end
    else begin
      chsq:= chsq + sqr(bins1.G(j, 1)-bins2.G(j, 1)) / (bins1.G(j, 1)+bins2.G(j, 1));
    end;
  end;
  prob:= gammq(0.5*df,0.5*chsq);
end;

procedure cntab1(var nn: TRMatrix; ni,nj: integer; var chisq, df, prob, cramrv, ccc: PREC);
const
  maxi = 100;
  maxj = 100;
  tiny = 1E-30;
var
  sumi, sumj: TRMatrix;
  expctd, sum: PREC;
  i, j, nni, nnj: integer;
begin      
  sumi.Init(maxi, 1);
  sumj.Init(maxj, 1);
  sum:= 0;
  nni:= ni;
  nnj:= nj;
  for i:= 1 to ni do begin
    sumi.P(i, 1, 0);
    for j:= 1 to nj do begin
      sumi.P(i, 1, sumi.G(i, 1) + nn.G(i,j));
      sum:= sum+nn.G(i, j);
    end;
    if (sumi.G(i, 1) = 0) then nni:= nni-1;
  end;
  for j:= 1 to nj do begin
    sumj.P(j, 1, 0);
    for i:= 1 to ni do begin
      sumj.P(j, 1, sumj.G(j, 1) + nn.G(i,j));
    end;
    if (sumj.G(j, 1) = 0) then nnj:= nnj-1;
  end;
  df:= nni*nnj-nni-nnj+1;
  chisq:= 0;
  for i:= 1 to ni do begin
    for j:= 1 to nj do begin
      expctd:= sumj.G(j, 1) * sumi.G(i, 1)/sum;
      chisq:= chisq + sqr(nn.G(i,j)-expctd) / (expctd+tiny);
    end;
  end;
  prob:= gammq(0.5*df,0.5*chisq);
  cramrv:= sqrt(chisq/(sum*min(nni-1,nnj-1)));
  ccc:= sqrt(chisq/(chisq+sum));
  sumi.Done;
  sumj.Done;
end;

procedure cntab2(var nn: TRMatrix; ni,nj: integer; var h,hx,hy,hygx,hxgy,uygx,uxgy,uxy: PREC);
const
  maxi = 100;
  maxj = 100;
  tiny = 1E-30;
var
  sumi, sumj: TRMatrix;
  p, sum: PREC;
  i, j: integer;
begin      
  sumi.Init(maxi, 1);
  sumj.Init(maxj, 1);
  sum:= 0;
  for i:= 1 to ni do begin
    sumi.P(i, 1, 0.0);
    for j:= 1 to nj do begin
      sumi.P(i, 1, sumi.G(i, 1) + nn.G(i,j));
      sum:= sum + nn.G(i,j);
    end;
  end;
  for j:= 1 to nj do begin
    sumj.P(j, 1, 0);
    for i:= 1 to ni do begin
      sumj.P(j, 1, sumj.G(j, 1) + nn.G(i,j));
    end;
  end;
  hx:= 0;
  for i:= 1 to ni do begin
    if (sumi.G(i, 1) <> 0) then begin
      p:= sumi.G(i, 1) / sum;
      hx:= hx-p * ln(p);
    end;
  end;
  hy:= 0;
  for j:= 1 to nj do begin
    if (sumj.G(j, 1) <> 0) then begin
      p:= sumj.G(j, 1)/sum;
      hy:= hy-p * ln(p);
    end;
  end;
  h:= 0;
  for i:= 1 to ni do begin
    for j:= 1 to nj do begin
      if (nn.G(i,j) <> 0) then begin
	p:= nn.G(i,j)/sum;
	h:= h-p * ln(p);
      end;
    end;
  end;
  hygx:= h-hx;
  hxgy:= h-hy;
  uygx:= (hy-hygx)/(hy+tiny);
  uxgy:= (hx-hxgy)/(hx+tiny);
  uxy := 2*(hx+hy-h)/(hx+hy+tiny);
  sumi.Done;
  sumj.Done;
end;

end.
