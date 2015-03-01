unit SmlTlk2;

interface

uses Objects;

type

  POrdinalIterator  = ^TOrdinalIterator;
  TOrdinalIterator = object(TObject)
     function    More: boolean; virtual;
     function    Next: PObject; virtual;
     procedure   Reset; virtual;
     procedure   Break; virtual;
     destructor  Done; virtual;
  end;

  PIntegerIterator  = ^TIntegerIterator;
  TIntegerIterator = object(TObject)
     Index: integer;
     constructor Init(da, a, stp: integer);
     function    More: boolean; virtual;
     function    Next: PObject; virtual;
     procedure   Reset; virtual;
     procedure   Break; virtual;
     destructor  Done; virtual;
    private
     Inz, Fin: integer;
     step: integer;
     dir : integer;
  end;

implementation

function TOrdinalIterator.More;
begin
  Abstract;
end;

function TOrdinalIterator.Next;
begin
  Abstract;
end;

procedure TOrdinalIterator.Reset;
begin
end;

procedure TOrdinalIterator.Break;
begin
end;

destructor TOrdinalIterator.Done;
begin
end;

constructor TIntegerIterator.Init;
begin
  if stp < 0 then dir:= -1
  else if stp > 0 then dir:= 1
  else dir:= 0;
  Inz:= dir * da;
  Fin:=  dir * a;
  Step:= stp;
end;

function TIntegerIterator.More;
begin
  More:= ((dir*Index)<=Fin);
end;

function TIntegerIterator.Next;
begin
  inc(Index, step);
  Next:= @Index;
end;

procedure TIntegerIterator.Reset;
begin
  Index:= dir*Inz;
end;

procedure TIntegerIterator.Break;
begin
  Index:= dir*fin;
end;

destructor TIntegerIterator.Done;
begin
end;

end.
