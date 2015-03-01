uses MathTool, MathTls1, DataMngr, Crt;

function f(x: PREC): PREC; far;
begin
  f:= sin(x);
  f:= x*x-9;
end;

var
  xi, xf, vf: PREC;
begin
  ClrScr;
  Writeln('INTEGRAZIONE: QUADRATURA GUASSIANA');
  Writeln;
  Writeln(' y(x) = 1');
  Writeln;
  Writeln('ESTREMI DI INTEGRAZIONE');
  InputPREC('INFERIORE = ', xi,-inf,inf);
  InputPREC('SUPERIORE = ', xf,-inf,inf);
  writeln;
  writeln('Zero (Bisez)  a ',DynaOut(ZeroBisezione(f, 0, xi, xf)));
  writeln('Zero (Newton) a ',DynaOut(ZeroNewton(f, 0, 0.5*(xi+xf))));
  writeln;
  vf:= AutoIntegrate(f, xi, xf, IntegGauss);
  writeln('AUTOINTEGRALE (Gauss10) = ', DynaOut(vf));
  vf:= IntegGauss(f, xi, xf, 20);
  writeln('INTEGRALE (Gaus) = ', DynaOut(vf));
  vf:= IntegSimp(f, xi, xf, 20);
  writeln('INTEGRALE (Simp) = ', DynaOut(vf));
  vf:= IntegSimp2(f, xi, xf, 20);
  writeln('INTEGRALE (Simp2) = ', DynaOut(vf));
  vf:= IntegTrap(f, xi, xf, 20);
  writeln('INTEGRALE (Trap) = ', DynaOut(vf));
end.
