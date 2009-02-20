unit RgUseful;

{$R-,S-,I-,O-,F-,A+,U+,K+,W-,V+,B-,X+,T-,P+,L+,Y+,D-}

interface

uses  SysUtils;

function WordCase (const S : string) : string;

implementation

function WordCase (const S : string) : string;
var
   I : Integer;
begin
  Result := LowerCase (S);
  Result[1] := UpCase(Result[1]);
  for I := 2 to length (Result) do
    if (Result [I] = ' ') and (I < length(Result)) then Result[I+1] := UpCase(Result[I+1]);
end;

end.
