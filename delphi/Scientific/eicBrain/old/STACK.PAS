unit Stack;

interface

uses
  Classes;

type
  TStack = class(TList)
    sz: integer;
    flg: boolean;
    constructor Create(Size, ALimit, ADelta: Integer; Obj: boolean);
    procedure Push(Item: pointer); virtual;
    function  Pop: pointer; virtual;
    procedure FreeItem(Item: Pointer); virtual;
  end;

implementation

constructor TStack.Create(Size, ALimit, ADelta: Integer; Obj: boolean);
begin
  sz:= Size;
  flg:= Obj;
  inherited Init(ALimit, ADelta);
end;

procedure TStack.Push(Item: pointer);
begin
  inherited AtInsert(Count, Item);
end;

function TStack.Pop: pointer;
begin
  if Count > 0 then begin
    Pop:= At(pred(Count));
    AtDelete(pred(Count));
  end
  else Pop:= nil;
end;

procedure TStack.FreeItem(Item: pointer);
begin
  if Item <> nil then 
    if flg then Dispose(PObject(Item), Done)
    else FreeMem(Item, Sz);
end;

end.
