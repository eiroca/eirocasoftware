unit MathTls3;

interface

uses MathTool, eLibMath;

procedure Perm1;
procedure Perm2;
procedure Anagramma;

implementation

var
  MAX: integer = 5;

var a: TIVector;

{ Display contents of global array a }
procedure ShowArray(var a: TIVector);
var i: Integer;
begin
  for i:= 1 to MAX do Write(a[i]:3);
  Writeln;
end;


procedure Perm1;
var
  i: Integer;
  { Arrange global array a in all possible ways }
  procedure Permute(n: Integer);
  var
    i, temp: Integer;
  begin
    if n = 1 then ShowArray(a)
    else begin
      Permute(n - 1);
      for i:= 1 to n - 1 do begin
        temp:= a[i];  { Swap a[i] and a[n] }
        a[i]:= a[n];
        a[n]:= temp;
        Permute(n - 1);
        temp:= a[i];  { Restore a[i] and a[n] }
        a[i]:= a[n];
        a[n]:= temp;
      end;
    end;
  end;
begin
  max:= 3;
//  InputInt('Quanti elementi da permutare? ',max, 1, maxint);
  a:= TIVector.Create(nil);
  a.Setup(1,MAX);
  for i:= 1 to MAX do a[i]:= i;
  Permute(MAX);
  a.Free;
//  WaitReturn;
end;

procedure Perm2;
var
  i: Integer;
  pos: integer;
  { Arrange global array a in all possible ways }
  procedure Permute(n: Integer);
  var i: Integer;
  begin
    pos:= pos + 1;
    a[n]:= pos;
    if pos = MAX then ShowArray(a);
    if pos <> MAX then  { Optional }
      for i:= 1 to MAX do if a[i] = 0 then Permute(i);
    pos:= pos - 1;
    a[n]:= 0
  end;
begin
  max:= 3;
//  InputInt('Quanti elementi da permutare? ',max,1,maxint);
  a:= TIVector.Create(nil);
  a.Setup(1,MAX);
  pos:= -1;
  for i:= 1 to MAX do a[i]:= 0;
  Permute(1);
  a.Free;
//  WaitReturn;
end;

procedure Anagramma;
var
  nome  : string;
  stack : integer;
  p,x   : word;
  procedure ana(mioset:string);
  var
    a,r     : byte;
    prichar : char;
  begin
    a:=length(mioset);
    if a=1 then begin
     write(nome,' ');
     inc(p);
     if p = x then begin
       writeln;
       p:=1;
     end;
    end
    else begin
      stack:=succ(stack);
      r:=0;
      repeat
        r:=succ(r);
        prichar:=mioset[1];
         nome:=copy(nome,1,stack)+mioset;
        mioset:=copy(mioset,2,a-1);
        ana(mioset);
        mioset:= mioset+prichar;
      until a=r;
      stack:=pred(stack);
    end;
  end;
begin
  nome:= '';
//  InputStr('Anagrammi della parola: ', nome);
  if nome = '' then exit;
  x:= TRUNC (80/(length(nome)+1));
  p:= 1;
  stack:=-1;
  ana(nome);
  writeln;
  writeln('All done.');
//  WaitReturn;
end;

end.
