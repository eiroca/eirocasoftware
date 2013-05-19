{*******************************************************}
{                                                       }
{       Intelligent Base Navigator                      }
{                                                       }
{       Copyright (c) 1995, 1996 by Rohit Gupta         }
{                                                       }
{*******************************************************}

unit RgNav;

{ R-,S-,I-,O-,F-,A+,U+,K+,W-,V+,B-,X+,T-,P+,L+,Y+,D-}

interface

uses SysUtils, WinTypes, WinProcs, Messages, Classes, Controls, Graphics,
  Menus, ExtCtrls, Buttons, RgUseful;

const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  NormRepeatPause = 100;  { pause before hint window displays (ms)}
  BtnSpaceSize    =  5;   { size of space between special buttons }

  SHntOfs         = 60000;
  SCapOfs         = 60100;
  SKeyOfs         = 60200;
  SInsertQuestion = 60310;
  SDeleteQuestion = 60311;
  SEditQuestion   = 60312;
  SPostQuestion   = 60317;
  SCancelQuestion = 60318;

type
  TNavButton = class;

  TNavGlyph   = (ngEnabled, ngDisabled);
  TAllNavBtn  = (nbFirst,  nbPrior,  nbNext,  nbLast,   nbKey,
                 nbSearch, nbTable,  nbForm,  nbPrint,  nbRefresh,
                 nbInsert, nbDelete, nbEdit,  nbExtra1, nbExtra2,
                 nbExtra3, nbHint,   nbPost,  nbCancel);
  TNormNavBtn = nbFirst..nbExtra3;
  TEditNavBtn = nbHint..nbCancel;
  TNavColors  = (ncBlack, ncBlue, ncRed);
  TBtnSize    = (X1,X2,X3,X4,X5);

  TAllBtnSet   = set of TAllNavBtn;
  TNormBtnSet  = set of TNormNavBtn;
  TNavBtnStyle = set of (nsAllowTimer, nsFocusRect);

  ENavClick = procedure (Sender: TObject; Button: TAllNavBtn) of object;

{ TRGNavigator }

  TRGNavigatorX = class (TCustomPanel)
  private
    FVisibleButtons: TAllBtnSet;
    VisibleCopy:     TAllBtnSet;
    FVisibleHint   : Boolean;
    FHints         : TStrings;
    EditBtnWidth,
    ButtonWidth    : SmallInt;
    MinBtnSize     : TPoint;
    FocusedButton  : TAllNavBtn;
    FConfirmDelete,
    FConfirmInsert,
    FConfirmEdit,
    FConfirmPost,
    FConfirmCancel : Boolean;
    FMenu: TMenuITem;
    FScrlColor,
    FFuncColor,
    FCtrlColor,
    FToolColor     : TNavColors;
    FKeySize,
    FEx1Size,
    FEx2Size,
    FEx3Size       : TBtnSize;
    procedure SetButtonColor (I : TAllNavBtn);
    procedure SetScrlColor (Value : TNavColors);
    procedure SetFuncColor (Value : TNavColors);
    procedure SetCtrlColor (Value : TNavColors);
    procedure SetToolColor (Value : TNavColors);
    procedure SetBtnSize   (var Target, Value : TBtnSize);
    procedure SetKeySize   (Value : TBtnSize);
    procedure SetEx1Size   (Value : TBtnSize);
    procedure SetEx2Size   (Value : TBtnSize);
    procedure SetEx3Size   (Value : TBtnSize);
    function  GetCapt1 : string;
    function  GetCapt2 : string;
    function  GetCapt3 : string;
    procedure SetCaption (Idx : TAllNavBtn; Value : string);
    procedure SetCapt1 (Value : string);
    procedure SetCapt2 (Value : string);
    procedure SetCapt3 (Value : string);
    procedure SetMenu (Value : TMenuItem);
    procedure InitButtons;
    procedure InitHints;
    procedure BtnMouseDown (Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    function  GetVisible : TNormBtnSet;
    procedure SetVisible(Value: TNormBtnSet);
    procedure SetMenuVisible(Btn : SmallInt; Value: Boolean);
    procedure AdjustSize (var W, H : SmallInt);
    procedure SetHints(Value: TStrings);
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure Click(Sender: TObject);  
  protected
    FOnNavClick: ENavClick;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
(*
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
*)
  public
    Buttons: array[TAllNavBtn] of TNavButton;
    Confirmed : boolean;
    DLActive,
    DLEditing,
    DLCanModify,
    DLBOF,
    DLEOF  : Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure BtnClick(Index: TAllNavBtn; CallUserClick : Boolean); virtual;
    procedure DataChanged; virtual;     (*PATCH*)
    procedure EditingChanged; virtual;  (*PATCH*)
    procedure ActiveChanged; virtual;   (*PATCH*)
    procedure Loaded; override;
  published
    property VisibleButtons: TNormBtnSet read GetVisible write SetVisible
             default [nbFirst,  nbPrior,  nbNext,   nbLast,   nbKey,
                      nbSearch, nbTable,  {nbForm,} nbPrint,  nbRefresh,
                      nbInsert, nbDelete, nbEdit,   nbExtra1, nbExtra2, nbExtra3];
    property VisibleHint : Boolean read FVisibleHint write FVisibleHint default True;
    property Align;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Hints: TStrings read FHints write SetHints;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete default True;
    property ConfirmInsert: Boolean read FConfirmInsert write FConfirmInsert default True;
    property ConfirmEdit:   Boolean read FConfirmEdit   write FConfirmEdit   default True;
    property ConfirmPost:   Boolean read FConfirmPost   write FConfirmPost   default True;
    property ConfirmCancel: Boolean read FConfirmCancel write FConfirmCancel default True;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick: ENavClick read FOnNavClick write FOnNavClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnResize;
    property OnStartDrag;
    property ColorScroll:   TNavColors read FScrlColor write SetScrlColor;
    property ColorFunc:     TNavColors read FFuncColor write SetFuncColor;
    property ColorCtrl:     TNavColors read FCtrlColor write SetCtrlColor;
    property ColorTool:     TNavColors read FToolColor write SetToolColor;
    property SizeOfKey:     TBtnSize   read FKeySize   write SetKeySize default X3;
    property SizeOfExtra1:  TBtnSize   read FEx1Size   write SetEx1Size default X3;
    property SizeOfExtra2:  TBtnSize   read FEx2Size   write SetEx2Size default X3;
    property SizeOfExtra3:  TBtnSize   read FEx3Size   write SetEx3Size default X3;
    property Menu:          TMenuItem  read FMenu      write SetMenu;
    property CaptionExtra1: string     read GetCapt1   write SetCapt1;
    property CaptionExtra2: string     read GetCapt2   write SetCapt2;
    property CaptionExtra3: string     read GetCapt3   write SetCapt3;
  end;

{ TNavButton }

  TNavButton = class(TSpeedButton)
  private
    FIndex: TAllNavBtn;
    FNavStyle: TNavBtnStyle;
    FRepeatTimer: TTimer;
    procedure TimerExpired(Sender: TObject);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    destructor Destroy; override;
    property NavStyle: TNavBtnStyle read FNavStyle write FNavStyle;
    property Index : TAllNavBtn read FIndex write FIndex;
  end;

const
  BtnStateName : array[TNavGlyph] of PChar = ('EN', 'DI');

  BtnTypeName  : array[TAllNavBtn] of string[10]=
    ('First', 'Prior',  'Next',   'Last',    'Key',    'Search',
     'Table', 'Form',   'Print',  'Refresh', 'Insert', 'Delete',
     'Edit',  'Extra1', 'Extra2', 'Extra3',  'Hint',   'Post',
     'Cancel');

procedure Register;

implementation

uses Dialogs;

{$R RgNav.res}

{ TRGNavigatorX }

constructor TRGNavigatorX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
(*
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] + [csFramed, csOpaque];
*)
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] + [csOpaque];
  if not NewStyleControls then ControlStyle := ControlStyle + [csFramed];
  FVisibleButtons := [nbFirst,  nbPrior,  nbNext,   nbLast,    nbKey,
                      nbSearch, nbTable, {nbForm,}  nbPrint,  nbRefresh,
                      nbInsert, nbDelete, nbEdit,   nbExtra1, nbExtra2,
                      nbExtra3];
  FKeySize := X4;
  FEx1Size := X3;
  FEx2Size := X3;
  FEx3Size := X3;
  FHints   := TStringList.Create;
  InitButtons;
  BevelOuter := bvNone;
  BevelInner := bvNone;
  Width      := 241;
  Height     := 25;
  ButtonWidth    := 0;
  FocusedButton  := nbFirst;
  FConfirmDelete := True;
  FConfirmInsert := True;
  FConfirmEdit   := True;
  FConfirmPost   := True;
  FConfirmCancel := True;
  DLActive       := False;
  DLEditing      := False;
  DLCanModify    := False;
  DLBOF          := False;
  DLEOF          := False;
  FVisibleHint   := True;
end;

destructor TRGNavigatorX.Destroy;
begin
  FHints.Free;
  inherited Destroy;
end;

procedure TRGNavigatorX.SetButtonColor (I : TAllNavBtn);
  procedure SetIt (Col : TNavColors);
  begin
    with Buttons[I] do begin
       ParentFont := True;
       with Font do begin
         case Col of
           ncBlue : Color := clBlue;
           ncRed  : Color := clRed;
           else     Color := clBlack;
         end;
       end;
    end;
  end;
var
  Cl : char;
  ResName: array[0..40] of Char;
begin
  case I of
    nbFirst,nbPrior,nbNext,nbLast,nbKey: begin
      Cl := char(ord(FScrlColor)+$30);
      SetIt (FScrlColor);
    end;
    nbRefresh,nbSearch,nbTable,nbForm,nbPrint: begin
      Cl := char(ord(FFuncColor)+$30);
      SetIt (FFuncColor);
    end;
    nbInsert,nbDelete, nbEdit,nbCancel,nbPost: begin
      Cl := char(ord(FCtrlColor)+$30);
      SetIt (FCtrlColor);
    end;
    nbExtra1,nbExtra2, nbExtra3,nbHint: begin
      Cl := char(ord(FToolColor)+$30);
      SetIt (FToolColor);
    end;
    else Cl := '0';
  end;
  Buttons[I].Glyph.Handle := LoadBitmap(HInstance, StrFmt(ResName, '%srgn_%s', [Cl,BtnTypeName[I]]));
end;

procedure TRGNavigatorX.SetScrlColor (Value : TNavColors);
begin
  if Value = FScrlColor then exit;
  FScrlColor := Value;
  SetButtonColor (nbFirst);
  SetButtonColor (nbPrior);
  SetButtonColor (nbNext);
  SetButtonColor (nbLast);
  SetButtonColor (nbKey);
end;

procedure TRGNavigatorX.SetFuncColor (Value : TNavColors);
begin
  if Value = FFuncColor then exit;
  FFuncColor := Value;
  SetButtonColor (nbSearch);
  SetButtonColor (nbTable);
  SetButtonColor (nbForm);
  SetButtonColor (nbPrint);
  SetButtonColor (nbRefresh);
end;

procedure TRGNavigatorX.SetCtrlColor (Value : TNavColors);
begin
  if Value = FCtrlColor then exit;
  FCtrlColor := Value;
  SetButtonColor (nbInsert);
  SetButtonColor (nbDelete);
  SetButtonColor (nbEdit);
  SetButtonColor (nbCancel);
  SetButtonColor (nbPost);
end;

procedure TRGNavigatorX.SetToolColor (Value : TNavColors);
begin
  if Value = FToolColor then exit;
  FToolColor := Value;
  SetButtonColor (nbExtra1);
  SetButtonColor (nbExtra2);
  SetButtonColor (nbExtra3);
  SetButtonColor (nbHint);
end;

procedure TRGNavigatorX.SetBtnSize (var Target, Value : TBtnSize);
var
  W, H : SmallInt;
begin
  if Value = Target then exit;
  Target := Value;
  W := Width;
  H := Height;
  AdjustSize (W,H);
end;

procedure TRGNavigatorX.SetKeySize (Value : TBtnSize);
begin
  SetBtnSize (FKeySize,Value);
end;

procedure TRGNavigatorX.SetEx1Size (Value : TBtnSize);
begin
  SetBtnSize (FEx1Size,Value);
end;

procedure TRGNavigatorX.SetEx2Size (Value : TBtnSize);
begin
  SetBtnSize (FEx2Size,Value);
end;

procedure TRGNavigatorX.SetEx3Size (Value : TBtnSize);
begin
  SetBtnSize (FEx3Size,Value);
end;

function TRGNavigatorX.GetCapt1 : string;
begin
  GetCapt1 := Buttons [nbExtra1].Caption;
end;

function TRGNavigatorX.GetCapt2 : string;
begin
  GetCapt2 := Buttons [nbExtra2].Caption;
end;

function TRGNavigatorX.GetCapt3 : string;
begin
  GetCapt3 := Buttons [nbExtra3].Caption;
end;

procedure TRGNavigatorX.SetCaption (Idx : TAllNavBtn; Value : string);
var
  I : SmallInt;
begin
  if Buttons [Idx].Caption = Value then Exit;
  Buttons [Idx].Caption := Value;
  if FMenu = nil then exit;
  with FMenu do
    for I := 0 to Count-1 do
      if Items [I].Tag = ord(Idx) then begin
        Items [I].Caption := Value;
        exit;
      end;
end;

procedure TRGNavigatorX.SetCapt1 (Value : string);
begin
  SetCaption (nbExtra1,Value);
end;

procedure TRGNavigatorX.SetCapt2 (Value : string);
begin
  SetCaption (nbExtra2,Value);
end;

procedure TRGNavigatorX.SetCapt3 (Value : string);
begin
  SetCaption (nbExtra3,Value);
end;

procedure TRGNavigatorX.SetMenu (Value : TMenuItem);
  procedure InsertIt (const Nam, Cap, Key, Hnt : string; Tg : SmallInt);
  var
    Item : TMenuItem;
  begin
    Item := TMenuITem.Create (FMenu.Owner);
    if not Assigned (Item) then exit;
    with Item do begin
       Name     := Nam+'Menu';
       Caption  := Cap;
       ShortCut := TextToShortCut(Key);
       Hint     := Hnt;
       OnClick  := Self.Click;
       Tag      := Tg;
    end;
    FMenu.Add (Item);
  end;
  procedure SetOnClick;  { Delphi loses above Onclick }
  var
    I : SmallInt;
  begin
    with FMenu do
      for I := 0 to Count-1 do
        with Items [I] do
          if Caption <> '-' then OnClick := Self.Click;
  end;
var
  I      : TAllNavBtn;
  J      : SmallInt;
  S1, S2 : String;
begin
  if Value = FMenu then exit;
  FMenu := Value;
  if not assigned (FMenu) then exit;
  if not (csDesigning in ComponentState) then begin
    SetOnClick;
    Exit;
  end;
  with FMenu do if Count > 0 then begin
    { If FirstMenu or Insert exist, then abort }
    S1 := BtnTypeName [nbFirst] + 'Menu';
    S2 := BtnTypeName [nbInsert] + 'Menu';
    for J := 0 to Count-1 do
      with Items [J] do
        if (Name = S1) or (Name = S2) then exit;
  end;
  for I := Low(TAllNavBtn) to High(TAllNavBtn) do
    if Buttons [I].Enabled and (I <> nbHint) then begin
      case I of
        nbSearch,
        nbInsert,
        nbExtra1,
        nbPost : InsertIt (BtnTypeName[I]+'_','-','','',0);
      end;
      case I of
        nbExtra1,
        nbExtra2,
        nbExtra3 : S1 := Buttons [I].Caption;
        else       S1 := LoadStr (SCapOfs+ord(I));
      end;
      InsertIt (BtnTypeName[I],S1,LoadStr (SKeyOfs+ord(I)),Buttons[I].Hint,ord(I));
    end;
end;

procedure TRGNavigatorX.InitButtons;
var
  I: TAllNavBtn;
  Btn: TNavButton;
  X: SmallInt;
begin
  MinBtnSize := Point(24, 18); (* PATCH EIC *)
  X := 0;
  for I := Low(Buttons) to High(Buttons) do begin
    Btn := TNavButton.Create (Self);
    Btn.Index := I;
    Btn.Visible := I in FVisibleButtons;
    Btn.Enabled := True;
    Btn.SetBounds (X, 0, MinBtnSize.X, MinBtnSize.Y);
    Btn.NumGlyphs := 2;
    Btn.OnClick := Click;
    Btn.OnMouseDown := BtnMouseDown;
    Btn.Parent := Self;
    Buttons[I] := Btn;
    SetButtonColor (I);
    X := X + MinBtnSize.X;
    case I of
      nbHint   : Buttons [I].Margin := 0;
      nbKey,
      nbExtra1,
      nbExtra2,
      nbExtra3 : begin
        if I = nbKey then Buttons[I].Caption := 'Primary'
        else Buttons[I].Caption := BtnTypeName [I];
        Buttons[I].Margin  := 3;
      end;
    end;
  end;
  InitHints;
  Buttons[nbPrior].NavStyle := Buttons[nbPrior].NavStyle + [nsAllowTimer];
  Buttons[nbNext]. NavStyle := Buttons[nbNext]. NavStyle + [nsAllowTimer];
end;

procedure TRGNavigatorX.InitHints;
var
  I: SmallInt;
  J: TAllNavBtn;
begin
  for J := Low(Buttons) to High(Buttons)
  do Buttons[J].Hint := LoadStr (SHntOfs+ord(J));
  J := Low(Buttons);
  for I := 0 to (FHints.Count - 1) do begin
    if FHints.Strings[I] <> '' then Buttons[J].Hint := FHints.Strings[I];
    if J = High(Buttons) then Exit;
    Inc(J);
  end;
end;

procedure TRGNavigatorX.SetHints(Value: TStrings);
begin
  FHints.Assign(Value);
  InitHints;
end;

function TRGNavigatorX.GetVisible : TNormBtnSet;
begin
  Result := FVisibleButtons * [low(TNormNavBtn)..high(TNormNavBtn)];
end;

procedure TRGNavigatorX.SetVisible(Value: TNormBtnSet);
var
  I: TAllNavBtn;
  W, H: SmallInt;
begin
  W := Width;
  H := Height;
  if (nbTable in FVisibleButtons) and (nbForm in Value) then Value := Value - [nbTable];
  if (nbForm in FVisibleButtons) and (nbTable in Value) then Value := Value - [nbForm];
  FVisibleButtons := Value;
  for I := Low(Buttons) to High(Buttons) do begin
    Buttons[I].Visible := I in FVisibleButtons;
    if assigned (FMenu) then SetMenuVisible (ord(I),Buttons[I].Visible);
  end;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then inherited SetBounds (Left, Top, W, H);
  Invalidate;
end;

procedure TRGNavigatorX.SetMenuVisible(Btn : SmallInt; Value: Boolean);
var
  I: SmallInt;
begin
  if assigned (FMenu) then
    with FMenu do
      for I := 1 to Count-1 do
        if Items [I].Tag = Btn then Items [I].Enabled := Value;
end;

procedure TRGNavigatorX.AdjustSize (var W, H: SmallInt);
var
  HintSize : SmallInt;
  function GetButtonSIze (I : TAllNavBtn) : SmallInt;
  begin
    case I of
      nbKey    : Result := ord(FKeySize);
      nbExtra1 : Result := ord(FEx1Size);
      nbExtra2 : Result := ord(FEx2Size);
      nbExtra3 : Result := ord(FEx3Size);
      nbHint   : begin
        if DLEditing then begin
          if HintSize <> 0 then Result := HintSize
          else begin
            Result := ((W-EditBtnWidth*2) div EditBtnWidth)-2;
            if Result < 5 then Result := 5; { Goes negative sometimes } (* PATH BY EIC *)
            HintSize := Result;  { For Later }
          end;
        end
        else Result := 10; (* PATH BY EIC *)
      end;
      else Result := 0;
    end;
    Inc (Result);
  end;
var
  Count: SmallInt;
  MinW: SmallInt;
  I: TAllNavBtn;
  (* LastBtn: TAllNavBtn; *)
  BWidth,
  Space, Temp, Remain,
  X, VisibleBtns,
  Extra : SmallInt;
begin
  if (csLoading in ComponentState) then Exit;
  if Buttons[nbFirst] = nil then Exit;
  HintSize := 0;
  Count := 0;
  VisibleBtns := 0;
  (* LastBtn := High(Buttons); *)
  for I := Low(Buttons) to High(Buttons) do begin
    if Buttons[I].Visible then begin
      Inc (Count,GetButtonSize(I));
      Inc (VisibleBtns);
      (* LastBtn := I; *)
    end;
  end;
  if Count = 0 then Inc(Count);
  MinW := Count * (MinBtnSize.X - 1){ + 1}; 
  if W < MinW then W := MinW;
  if H < MinBtnSize.Y then H := MinBtnSize.Y;
  ButtonWidth := ((W - 1) div Count);
  Temp := (Count * ButtonWidth){ + 1};   { Space Required }
  Extra := 0;
  while W-Temp > VisibleBtns do begin          { If more than # butons }
    { Then distribute it }
    Inc (Extra);
    Inc (Temp,VisibleBtns);
  end;
(*
  if Align = alNone then W := Temp; { Align if Required }  not really needed
*)
  X := 0;
  Remain := W - Temp;
  (* Temp := Count div 2; *)
  for I := Low(Buttons) to High(Buttons) do begin
    if Buttons[I].Visible then begin
      Space := 0;
      if Remain <> 0 then begin
        Dec (Remain);
        Space := 1;
      end;
      BWidth := ButtonWidth * GetButtonSize (I) + Extra;
      Buttons[I].SetBounds (X, 0, BWidth + Space, Height);
      Inc (X, BWidth + Space);
      (* LastBtn := I; *)
    end
    else Buttons[I].SetBounds (Width + 1, 0, ButtonWidth, Height);
  end;
  if not DLEditing then EditBtnWidth := ButtonWidth;
end;

procedure TRGNavigatorX.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: SmallInt;
begin
  W := AWidth;
  H := AHeight;
  AdjustSize (W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TRGNavigatorX.WMSize(var Message: TWMSize);
var
  W, H: SmallInt;
begin
  inherited;
  { check for minimum size }
  W := Width;
  H := Height;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then inherited SetBounds(Left, Top, W, H);
  Message.Result := 0;
end;

procedure TRGNavigatorX.Click(Sender: TObject);
begin
  if Sender is TNavButton then BtnClick (TNavButton (Sender).Index,TRUE)
  else BtnClick (TAllNavBtn(TMenuItem(Sender).Tag),TRUE);
end;

procedure TRGNavigatorX.BtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldFocus: TAllNavBtn;
begin
  OldFocus := FocusedButton;
  FocusedButton := TNavButton (Sender).Index;
  if TabStop and (GetFocus <> Handle) and CanFocus then begin
    SetFocus;
    if (GetFocus <> Handle) then Exit;
  end
  else if TabStop and (GetFocus = Handle) and (OldFocus <> FocusedButton) then begin
    Buttons[OldFocus].Invalidate;
    Buttons[FocusedButton].Invalidate;
  end;
end;

procedure TRGNavigatorX.BtnClick(Index: TAllNavBtn; CallUserClick : Boolean);
begin
  Confirmed := False;
  case Index of
    nbInsert :
      if not FConfirmInsert or (MessageDlg (LoadStr(SInsertQuestion), mtConfirmation, mbOKCancel, 0) <> idCancel) then
        Confirmed := True;
    nbDelete :
      if not FConfirmDelete or (MessageDlg (LoadStr(SDeleteQuestion), mtConfirmation, mbOKCancel, 0) <> idCancel) then
        Confirmed := True;
    nbEdit   :
      if not FConfirmEdit or (MessageDlg (LoadStr(SEditQuestion), mtConfirmation, mbOKCancel, 0) <> idCancel) then
        Confirmed := True;
    nbCancel :
      if not FConfirmCancel or (MessageDlg (LoadStr(SCancelQuestion), mtConfirmation, [mbYes,mbNo], 0) = idYes) then
        Confirmed := True;
    nbPost   :
      if not FConfirmPost or (MessageDlg (LoadStr(SPostQuestion), mtConfirmation, mbOKCancel, 0) <> idCancel) then
        Confirmed := True;
  end;
  if CallUserClick then begin
    if (not (csDesigning in ComponentState)) then begin
      if Confirmed then
        case Index of
          nbInsert, nbEdit : begin
            DLEditing   := True;
            DLCanModify := True;
            EditingChanged;
          end;
          nbCancel, nbPost : begin
            DLEditing   := False;
            DLCanModify := True;
            EditingChanged;
            DataChanged;
          end;
          nbDelete         : begin
            DataChanged;
          end;
        end;
        if Assigned(FOnNavClick) then FOnNavClick(Self, Index);
    end;
  end;
end;

procedure TRGNavigatorX.WMSetFocus(var Message: TWMSetFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TRGNavigatorX.WMKillFocus(var Message: TWMKillFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TRGNavigatorX.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewFocus: TAllNavBtn;
  OldFocus: TAllNavBtn;
begin
  OldFocus := FocusedButton;
  case Key of
    VK_RIGHT: begin
      NewFocus := FocusedButton;
      repeat
        if NewFocus < High(Buttons) then NewFocus := Succ(NewFocus);
      until (NewFocus = High(Buttons)) or (Buttons[NewFocus].Visible);
      if NewFocus <> FocusedButton then begin
        FocusedButton := NewFocus;
        Buttons[OldFocus].Invalidate;
        Buttons[FocusedButton].Invalidate;
      end;
    end;
    VK_LEFT: begin
      NewFocus := FocusedButton;
      repeat
        if NewFocus > Low(Buttons) then NewFocus := Pred(NewFocus);
      until (NewFocus = Low(Buttons)) or (Buttons[NewFocus].Visible);
      if NewFocus <> FocusedButton then begin
        FocusedButton := NewFocus;
        Buttons[OldFocus].Invalidate;
        Buttons[FocusedButton].Invalidate;
      end;
    end;
    VK_SPACE: begin
      if Buttons[FocusedButton].Enabled then Buttons[FocusedButton].Click;
    end;
  end;
end;

procedure TRGNavigatorX.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TRGNavigatorX.DataChanged;
var
  UpEnable, DnEnable: Boolean;
begin
  UpEnable := Enabled and DLActive and not DLBOF;
  DnEnable := Enabled and DLActive and not DLEOF;
  Buttons[nbFirst].Enabled := UpEnable;
  Buttons[nbPrior].Enabled := UpEnable;
  Buttons[nbNext].Enabled := DnEnable;
  Buttons[nbLast].Enabled := DnEnable;
  Buttons[nbDelete].Enabled := Enabled and DLActive and DLCanModify and not (DLBOF and DLEOF);
end;

procedure TRGNavigatorX.EditingChanged;
var
  CanModify: Boolean;
  I        : TAllNavBtn;
  W, H     : SmallInt;
begin
  CanModify := Enabled and DLActive and DLCanModify;
  if CanModify then if DLEditing then begin
    VisibleCopy := FVisibleButtons;
    FVisibleButtons := [LOW(TEditNavBtn)..HIGH(TEditNavBtn)];
    if not FVisibleHint then Exclude (FVisibleButtons,nbHint);
    W := Width;
    H := Height;
    for I := LOW(TNormNavBtn) to HIGH(TNormNavBtn) do begin
      Buttons[I].Visible := false;
      if assigned (FMenu) then SetMenuVisible (ord(I), False);
    end;
    for I := LOW(TEditNavBtn) to HIGH(TEditNavBtn) do begin
      if (I <> nbHint) or (FVisibleHint) then Buttons[I].Visible := true;
      if assigned (FMenu) then SetMenuVisible (ord(I), True);
    end;
    AdjustSize (W, H);
    if (W <> Width) or (H <> Height) then inherited SetBounds (Left, Top, W, H);
    Invalidate;
  end
  else begin
    SetVisible (VisibleCopy);
  end;
end;

procedure TRGNavigatorX.ActiveChanged;
begin
(*
  if not (Enabled and DLActive) then
    for I := Low(Buttons) to High(Buttons) do Buttons[I].Enabled := False
  else begin
    DataChanged;
    EditingChanged;
  end;
*)
end;

procedure TRGNavigatorX.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then ActiveChanged;
end;

procedure TRGNavigatorX.Loaded;
var
  W, H: SmallInt;
begin
  inherited Loaded;
  W := Width;
  H := Height;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then inherited SetBounds (Left, Top, W, H);
  InitHints;
  if not (csLoading in ComponentState) then ActiveChanged;
end;

{TNavButton}

destructor TNavButton.Destroy;
begin
  if FRepeatTimer <> nil then FRepeatTimer.Free;
  inherited Destroy;
end;

procedure TNavButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown (Button, Shift, X, Y);
  if nsAllowTimer in FNavStyle then begin
    if FRepeatTimer = nil then FRepeatTimer := TTimer.Create(Self);
    FRepeatTimer.OnTimer := TimerExpired;
    FRepeatTimer.Interval := InitRepeatPause;
    FRepeatTimer.Enabled  := True;
  end;
end;

procedure TNavButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);
  if FRepeatTimer <> nil then FRepeatTimer.Enabled  := False;
end;

procedure TNavButton.TimerExpired(Sender: TObject);
begin
  FRepeatTimer.Interval := NormRepeatPause;
  if (FState = bsDown) and MouseCapture then begin
    try
      Click;
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;

procedure TNavButton.Paint;
var
  R: TRect;
begin
  inherited Paint;
  if (GetFocus = Parent.Handle) and (FIndex = TRGNavigatorX (Parent).FocusedButton) then begin
    R := Bounds(0, 0, Width, Height);
    InflateRect(R, -3, -3);
    if FState = bsDown then OffsetRect(R, 1, 1);
    DrawFocusRect(Canvas.Handle, R);
  end;
end;

procedure Register;
begin
  RegisterComponents('AddOn', [TRGNavigatorX]);
  RegisterComponents('AddOn', [TNavButton]);
end;

end.
