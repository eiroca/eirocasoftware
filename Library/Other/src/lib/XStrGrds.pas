{ ========================================================================
  Unit:    XStrGrds
  VCL:     TXStrGrid
  Version: 1.2
  Copyright (C) 1996, Immo Wache
  ========================================================================}
unit XStrGrds;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids;

type
  TGridColorEvent =
    procedure (Sender: TObject; ARow, ACol: longint; AState: TGridDrawState; ABrush: TBrush; AFont: TFont) of object;

  TGridAlignEvent =
    procedure (Sender: TObject; ARow, ACol: longint; var AAlignment: TAlignment) of object;

  TValidateEvent  =
    procedure (Sender: TObject; ACol, ARow: longint; var Value: string; var Validate: boolean) of object;


  TXStrGrid = class(TStringGrid)
    private
     { Private declarations }
     FAlign: TAlignment;
     FGrid3D: boolean;
     FHCol: TStrings;
     FHRow: TStrings;
     FOnGetCellColor: TGridColorEvent;
     FOnGetAlignment: TGridAlignEvent;
     function  GetAlign:TAlignment;
     procedure SetAlign(const Value: TAlignment);
     procedure SetGrid3D(Value: boolean);
     procedure InitHCol;
     procedure InitHRow;
     procedure SetHCol(Value: TStrings);
     procedure SetHRow(Value: TStrings);
     procedure SetCells(ACol, ARow: Integer; const Value: string);
    private (* VGrid *)
     { Private declarations }
     ModifyFlag: boolean;
     OldCol,OldRow: longint;
     OldCellText, ValidateText: string;
     EnterFlag, ValidateFlag: boolean;
     FOnValidate: TValidateEvent;
     procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
     procedure CMExit(var Message: TCMExit); message CM_EXIT;
    protected
     { Protected declarations }
     procedure Loaded; override;
    protected (* VGrid *)
     procedure Click; override;
     procedure KeyPress(var Key: char); override;
    public
     { Public declarations }
     procedure DrawCell(ACol, ARow: longint; ARect: TRect; AState: TGridDrawState); override;
     constructor Create(AOwner: TComponent); override;
     procedure MoveTo(ACol, ARow: longint);
     procedure Deselect;
     property  Cells write SetCells;
    public (* VGrid *)
     procedure InitValidate; {Call this func to avoid OnInvalidate in beginning}
     function  DeleteRow(p_Row: integer): boolean;
     function  InsertRow(var p_Row: integer; p_GrowFlag: boolean): boolean;
    published
     { Published declarations }
     property  HCol: TStrings read FHCol write SetHCol;
     property  HRow: TStrings read FHRow write SetHRow;
     property  OnGetCellColor: TGridColorEvent read FOnGetCellColor write FOnGetCellColor;
     property  OnGetAlignment: TGridAlignEvent read FOnGetAlignment write FOnGetAlignment;
     property  Grid3D: boolean read FGrid3D write SetGrid3D;
     property  Alignment: TAlignment read GetAlign write SetAlign default taLeftJustify;
    published (* VGrid *)
     { Published declarations }
     property OnValidate: TValidateEvent read FOnValidate write FOnValidate;
  end;

procedure Register;

implementation

constructor TXStrGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHCol:= TStringList.Create;
  FHRow:= TStringList.Create;
  FAlign:= taLeftJustify;
  (* VGrid *)
  ModifyFlag:= false;
  EnterFlag:= false;
  OldCellText:= '';
  InitValidate;
end;

procedure TXStrGrid.MoveTo(ACol, ARow: longint);
begin
  MoveColRow(ACol, ARow, True, True);
end;

procedure TXStrGrid.InitHCol;
var
  I: Integer;
begin
  if (FHCol <> nil) then begin
    for I:= 0 to pred(ColCount) do begin
      if I <FHCol.Count then Cells[I, 0]:= FHCol[I] else Cells[I, 0]:= '';
    end;
  end;
end;

procedure TXStrGrid.InitHRow;
var
  I: Integer;
begin
  if (FHRow <> nil) then begin
    for I:= 0 to RowCount -2 do begin
      if I <FHRow.Count then Cells[0, I + 1]:= FHRow[I] else Cells[0, I + 1]:= '';
    end;
  end;
end;

procedure TXStrGrid.Loaded;
begin
  inherited Loaded;
  initHCol;
  initHRow;
end;

procedure TXStrGrid.SetHCol(Value: TStrings);
begin
  FHCol.Assign(Value);
  InitHCol;
  Refresh;
end;

procedure TXStrGrid.SetHRow(Value: TStrings);
begin
  FHRow.Assign(Value);
  InitHRow;
  Refresh;
end;

function TXStrGrid.GetAlign: TAlignment;
begin
  Result:= FAlign;
end;

procedure TXStrGrid.SetAlign(const Value: TAlignment);
begin
  if FAlign<>Value then begin
    FAlign:= Value;
    Invalidate;
  end;
end;

procedure TXStrGrid.DrawCell(ACol, ARow: longint; ARect: TRect; AState: TGridDrawState);
  procedure DrawCellText;
  var
    Text: array[0..255] of Char;
    AlignValue: TAlignment;
    FontHeight: Integer;
    Rect: TRect;
  const
    Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  begin
    {determine text alignment}
    AlignValue:= Alignment;
    if Assigned(FOnGetAlignment) then FOnGetAlignment(Self, ARow, ACol, AlignValue);
    {using of Brush for background color}
    Rect:= ARect;
    Canvas.FillRect(Rect);
    {centering text in cell}
    FontHeight:= Canvas.TextHeight('W');
    with Rect do begin
      Top:= ((Bottom + Top) - FontHeight) shr 1;
      Bottom:= Top + FontHeight;
      Dec(Right, 2);
      Inc(Left, 2);
    end;
    {drawing of text}
    StrPCopy(Text, Cells[ACol, ARow]);
    DrawText(Canvas.Handle, Text, StrLen(Text), Rect, (DT_EXPANDTABS or DT_VCENTER) or Alignments[AlignValue]);
  end;
begin
  {prepare color and font selection}
  if Assigned(FOnGetCellColor) then FOnGetCellColor(Self, ARow, ACol, AState, Canvas.Brush, Canvas.Font);
  {text draw with alignment}
  if DefaultDrawing then DrawCellText else inherited DrawCell(ACol, ARow, ARect, AState);
  {3D look cells}
  if FGrid3D and ([goHorzLine, goVertLine] *Options =[goHorzLine, goVertLine]) then begin
    with ARect do begin
      Canvas.Pen.Color:= clHighLightText;
      Canvas.PolyLine([Point(Left, Bottom - 1), Point(Left, Top), Point(Right, Top)]);
    end;
  end;
end;

procedure TXStrGrid.SetGrid3D(Value: Boolean);
begin
  if FGrid3D<>Value then begin
    FGrid3D:= Value;
    Invalidate;
  end;
end;

procedure TXStrGrid.SetCells(ACol, ARow: Integer; const Value: string);
begin
  if Value <> inherited Cells[ACol, ARow] then begin
    inherited Cells[ACol, ARow]:= Value;
  end;
end;

procedure TXStrGrid.Deselect;
var
  SRect: TGridRect;
begin
  with SRect do begin
    Top:= 0; Left:= ColCount; Bottom:= 0; Right:= Left;
  end;
  Selection:= SRect;
end;

(* VGrid *)
procedure TXStrGrid.Click;
begin
  inherited Click;
  if OldCellText <> Self.Cells[OldCol,OldRow] then ModifyFlag:= true;
  if ModifyFlag then begin
    ModifyFlag:= false;
    ValidateFlag:= true;
    try
      ValidateText:= Self.Cells[OldCol,OldRow];
      {invoke validate event}
      if Assigned(FOnValidate) then OnValidate(Self, OldCol, OldRow, ValidateText, ValidateFlag);
    except
    end;
    {if not Validate then recovery old-text}
    if not ValidateFlag then Self.Cells[OldCol,OldRow]:= OldCellText
  end;
  OldCol:= Self.Col;
  OldRow:= Self.Row;
  OldCellText:= Self.Cells[OldCol,OldRow];
end;

procedure TXStrGrid.KeyPress(var Key: char);
var
  OldKey: char;
begin
  OldKey:= Key; {*** prevent Key modified ***}
  inherited KeyPress(Key);
  if OldKey=Chr(13) then begin
    if OldCellText <> Self.Cells[OldCol,OldRow] then ModifyFlag:= true;
    if ModifyFlag then begin
      ModifyFlag:= false;
      ValidateFlag:= true;
      try
        ValidateText:= Self.Cells[OldCol,OldRow];
        {invoke validate event}
        if Assigned(FOnValidate) then OnValidate(Self, OldCol, OldRow, ValidateText, ValidateFlag);
      except
      end;
      {if not Validate then recovery old-text}
      if not ValidateFlag then Self.Cells[OldCol,OldRow]:= OldCellText;
    end;
    OldCol:= Self.Col;
    OldRow:= Self.Row;
    OldCellText:= Self.Cells[OldCol,OldRow];
  end;
end;

procedure TXStrGrid.CMEnter(var Message: TCMEnter);
begin
  inherited;
  ModifyFlag:= false;
  OldCol:= Self.Col;
  OldRow:= Self.Row;
  OldCellText:= Self.Cells[OldCol,OldRow];
  EnterFlag:= true;
end;

procedure TXStrGrid.CMExit(var Message: TCMExit);
begin
  inherited;
  try
    if not EnterFlag then exit;
    if OldCellText <> Self.Cells[OldCol,OldRow] then ModifyFlag:= true;
    if ModifyFlag then begin
      ModifyFlag:= false;
      ValidateFlag:= true;
      try
        ValidateText:= Self.Cells[OldCol,OldRow];
        {invoke validate event}
        if Assigned(FOnValidate) then OnValidate(Self, OldCol, OldRow, ValidateText, ValidateFlag);
      except
      end;
      {if not Validate then recovery old-text}
      if not ValidateFlag then Self.Cells[OldCol,OldRow]:= OldCellText;
    end;
  finally
    EnterFlag:= false;
    OldCol:= Self.Col;
    OldRow:= Self.Row;
    OldCellText:= Self.Cells[OldCol,OldRow];
    SetCursor(0);
    DoExit;
  end;
end;

function TXStrGrid.DeleteRow(p_Row: integer): boolean;
var
  i, j: integer;
begin
  Result:= false;
  try
    {validation}
    if (p_Row<0) or (p_Row >= RowCount) then exit;
    {more 1 row up to delete the empty row}
    for i:= p_Row to RowCount-2 do begin
      for j:=0 to  ColCount-1 do Cells[j,i]:= Cells[j,i+1];
    end;
    Result:= true;
  except
    raise;
  end;
end;

{return=new row}
function TXStrGrid.InsertRow(var p_Row: integer; p_GrowFlag: boolean): boolean;
var
  i, j: integer;
begin
  Result:= false;
  try
    {Append}
    if (p_Row<0) or (p_Row >= RowCount) then begin
      RowCount:= RowCount + 1;
      p_Row:= RowCount-1; {Append last row}
      exit;
    end;
    {One More Row}
    if p_GrowFlag then RowCount:= RowCount + 1;
    {more 1 row up to delete the empty row}
    for i:= RowCount-1 downto p_Row+1 do begin
      for j:= 0 to ColCount-1 do Cells[j,i]:= Cells[j,i-1];
    end;
    {p_Row no change}
    Result:= true;
  except
    raise;
  end;
end;

procedure TXStrGrid.InitValidate;
begin
  ModifyFlag:= false;
  OldCol:= Self.Col;
  OldRow:= Self.Row;
  OldCellText:= Self.Cells[OldCol, OldRow];
  EnterFlag:= true;
end;

procedure Register;
begin
  RegisterComponents('AddOn', [TXStrGrid]);
end;

end.
