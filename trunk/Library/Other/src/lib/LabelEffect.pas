unit LabelEffect;

{  This unit implements a label component with 3D effects.
   Written by Keith Wood - 27/05/95.

  The label has a highlight and a shadow.  The colours of these
  can be controlled through properties as can their distance
  from the label and their direction.  There are also preset
  combinations of direction/distance and colours.

  The label can be set to operate as a button, ie. initially
  raised it will depress when clicked.

  The label can be rotated to any angle.

  Thanks to Paradox Informant and their starter article on 3D labels.
  Thanks to Bill Murto and his RotateLabel.
  Thanks to Curtis Keisler and his TxtRotat example.
}

interface

uses
  SysUtils, WinTypes, WinProcs, Classes, Graphics, Controls, StdCtrls;

type
  { Range of offsets for the shadows }
  TEffectDepth = 0..10;

  { Directions in which the offsets can be positioned }
  TEffectDirection = (edNone, edUp, edUpRight, edRight, edDownRight, edDown,
      edDownLeft, edLeft, edUpLeft);

  { Constants for specifying direction component }
  TDirXY = (drX, drY);

  { The preset styles of label effects available }
  TEffectStyle = (esNone, esCustom, esRaised, esSunken, esShadow, esFlying);

  { The preset colour schemes available }
  TColourScheme = (csCustom, csText, csWindows, csEmbossed, csGold, csSteel);

  { Constants for specifying positions of colours }
  TColourPosition = (cpHighlight, cpShadow, cpFace);

  { Range for rotation }
  TAngleRange = 0..359;

const
  { Offsets for drawing in the nominated directions }
  IOffsets: array [TEffectDirection, TDirXY] of -1..1 =
      ((0,0),(0,-1),(+1,-1),(+1,0),(+1,+1),(0,+1),(-1,+1),(-1,0),(-1,-1));

type

  TLabelEffect = class(TCustomLabel)
  private
    { Private declarations }
    FDepthHighlight,
    FDepthShadow: TEffectDepth;
    FDirectionHighlight,
    FDirectionShadow: TEffectDirection;
    FColourHighlight,
    FColourShadow: TColor;
    FEffectStyle: TEffectStyle;
    FColourScheme: TColourScheme;
    FAsButton: Boolean;
    FAngle: TAngleRange;
    BChangingStyle,                { Is preset style being invoked ? }
    BChangingScheme: Boolean;      { Is preset colour scheme being invoked ? }
    ClrSchemes: array [TColourScheme,TColourPosition] of TColor;
    DDegToRad, DCosAngle, DSinAngle: Double;
    procedure SetDepthHighlight(IDepth: TEffectDepth);
    procedure SetDepthShadow(IDepth: TEffectDepth);
    procedure SetDirectionHighlight(EdDirection: TEffectDirection);
    procedure SetDirectionShadow(EdDirection: TEffectDirection);
    procedure SetColourHighlight(ClrHighlight: TColor);
    procedure SetColourShadow(ClrShadow: TColor);
    procedure SetEffectStyle(EsStyle: TEffectStyle);
    procedure SetColourScheme(CsScheme: TColourScheme);
    procedure SetAsButton(BBtn: Boolean);
    procedure SetAngle(AAngle: TAngleRange);
    procedure SetTextAngle(Cnv: TCanvas; AAngle: TAngleRange);
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure MouseDown(MbBtn: TMouseButton; SsShift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(SsShift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(MbBtn: TMouseButton; SsShift: TShiftState; X, Y: Integer); override;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
  published
    { Publish specialised properties }
    property DepthHighlight: TEffectDepth read FDepthHighlight write SetDepthHighlight default 1;
    property DepthShadow: TEffectDepth read FDepthShadow write SetDepthShadow default 1;
    property DirectionHighlight: TEffectDirection read FDirectionHighlight write SetDirectionHighlight default edUpLeft;
    property DirectionShadow: TEffectDirection read FDirectionShadow write SetDirectionShadow default edDownRight;
    property ColourHighlight: TColor read FColourHighlight write SetColourHighlight default clWhite;
    property ColourShadow: TColor read FColourShadow write SetColourShadow default clBlack;
    property EffectStyle: TEffectStyle read FEffectStyle write SetEffectStyle default esRaised;
    property ColourScheme: TColourScheme read FColourScheme write SetColourScheme default csWindows;
    property AsButton: Boolean read FAsButton write SetAsButton default False;
    property Angle: TAngleRange read FAngle write SetAngle default 0;
    { Publish inherited properties }
    property Align;
    property Alignment;
    property AutoSize default False;
    property Caption;
    property Color;
    property Cursor;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FocusControl;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ShowAccelChar;
    property ShowHint;
    property Transparent;
    property Visible;
    property WordWrap;

    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

procedure Register;

implementation

constructor TLabelEffect.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  { Colour schemes cannot be constant since Custom version varies }
  ClrSchemes[csText,cpHighlight] := clWhite;
  ClrSchemes[csText,cpFace] := clBlack;
  ClrSchemes[csText,cpShadow] := clGray;
  ClrSchemes[csWindows,cpHighlight] := clWhite;
  ClrSchemes[csWindows,cpFace] := clGray;
  ClrSchemes[csWindows,cpShadow] := clBlack;
  ClrSchemes[csEmbossed,cpHighlight] := clWhite;
  ClrSchemes[csEmbossed,cpFace] := clSilver;
  ClrSchemes[csEmbossed,cpShadow] := clBlack;
  ClrSchemes[csGold,cpHighlight] := clYellow;
  ClrSchemes[csGold,cpFace] := clOlive;
  ClrSchemes[csGold,cpShadow] := clBlack;
  ClrSchemes[csSteel,cpHighlight] := clAqua;
  ClrSchemes[csSteel,cpFace] := clTeal;
  ClrSchemes[csSteel,cpShadow] := clNavy;
  ClrSchemes[csCustom,cpHighlight] := ClrSchemes[csWindows,cpHighlight];
  ClrSchemes[csCustom,cpFace] := ClrSchemes[csWindows,cpFace];
  ClrSchemes[csCustom,cpShadow] := ClrSchemes[csWindows,cpShadow];
  { Initialise default values for internal fields }
  FDepthHighlight := 1;
  FDepthShadow := 1;
  FDirectionHighlight := edUpLeft;
  FDirectionShadow := edDownRight;
  FEffectStyle := esRaised;
  FColourScheme := csWindows;
  FColourHighlight := ClrSchemes[FColourScheme,cpHighlight];
  Font.Color := ClrSchemes[FColourScheme,cpFace];
  FColourShadow := ClrSchemes[FColourScheme,cpShadow];
  FAsButton := False;
  FAngle := 0;
  BChangingStyle := False;
  BChangingScheme := False;
  DDegToRad := PI / 180;
  DCosAngle := 1;         { Cos(FAngle * DDegToRad) }
  DSinAngle := 0;         { Sin(FAngle * DDegToRad) }
  AutoSize := False;
  Transparent := True;
  Font.Name := 'Times New Roman';
  Font.Size := 20;
end;

procedure TLabelEffect.SetDepthHighlight(IDepth: TEffectDepth);
begin
  if FDepthHighlight <> IDepth then
  begin
    FDepthHighlight := IDepth;
    if not BChangingStyle then  { Default to custom style when changed }
      SetEffectStyle(esCustom);
    Refresh;
  end;
end;

procedure TLabelEffect.SetDepthShadow(IDepth: TEffectDepth);
begin
  if FDepthShadow <> IDepth then begin
    FDepthShadow := IDepth;
    if not BChangingStyle then  { Default to custom style when changed }
      SetEffectStyle(esCustom);
    Refresh;
  end;
end;

procedure TLabelEffect.SetDirectionHighlight(EdDirection: TEffectDirection);
begin
  if FDirectionHighlight <> EdDirection then begin
    FDirectionHighlight := EdDirection;
    if not BChangingStyle then  { Default to custom style when changed }
      SetEffectStyle(esCustom);
    Refresh;
  end;
end;

procedure TLabelEffect.SetDirectionShadow(EdDirection: TEffectDirection);
begin
  if FDirectionShadow <> EdDirection then begin
    FDirectionShadow := EdDirection;
    if not BChangingStyle then  { Default to custom style when changed }
      SetEffectStyle(esCustom);
    Refresh;
  end;
end;

procedure TLabelEffect.SetColourHighlight(ClrHighlight: TColor);
begin
  if FColourHighlight <> ClrHighlight then begin
    FColourHighlight := ClrHighlight;
    ClrSchemes[csCustom,cpHighlight] := ClrHighlight;
    if not BChangingScheme then  { Default to custom colour scheme when changed }
      SetColourScheme(csCustom);
    Refresh;
  end;
end;

procedure TLabelEffect.SetColourShadow(ClrShadow: TColor);
begin
  if FColourShadow <> ClrShadow then begin
    FColourShadow := ClrShadow;
    ClrSchemes[csCustom,cpShadow] := ClrShadow;
    if not BChangingScheme then  { Default to custom colour scheme when changed }
      SetColourScheme(csCustom);
    Refresh;
  end;
end;

procedure TLabelEffect.SetEffectStyle(EsStyle: TEffectStyle);
begin
  if FEffectStyle <> EsStyle then begin
    BChangingStyle := True;   { So it doesn't reset to custom }
    BChangingScheme := True;  {          "                    }
    FEffectStyle := EsStyle;
    SetColourHighlight(ClrSchemes[ColourScheme,cpHighlight]);
    case FEffectStyle of
      esRaised: begin
        SetDirectionHighlight(edUpLeft);
        SetDirectionShadow(edDownRight);
        SetDepthHighlight(1);
        SetDepthShadow(1);
       end;
       esSunken: begin
         SetDirectionHighlight(edDownRight);
         SetDirectionShadow(edUpLeft);
         SetDepthHighlight(1);
         SetDepthShadow(1);
       end;
      esShadow: begin
        SetDirectionHighlight(edNone);
        SetDirectionShadow(edDownRight);
        SetDepthHighlight(0);
        SetDepthShadow(2);
        SetAsButton(False);
      end;
      esFlying: begin
        SetDirectionHighlight(edDownRight);
        SetDirectionShadow(edDownRight);
        SetDepthHighlight(1);
        SetDepthShadow(5);
        SetColourHighlight(ClrSchemes[ColourScheme,cpShadow]);  { Flying has two shadows }
        SetAsButton(False);
      end;
      esNone: begin
        SetDirectionHighlight(edNone);
        SetDirectionShadow(edNone);
        SetDepthHighlight(0);
        SetDepthShadow(0);
        SetAsButton(False);
      end;
      else SetAsButton(False);
    end;
    BChangingStyle := False;   { So further changes set style to custom }
    BChangingScheme := False;  { So further changes set colour scheme to custom }
  end;
end;

procedure TLabelEffect.SetColourScheme(CsScheme: TColourScheme);
begin
  if FColourScheme <> CsScheme then begin
    BChangingScheme := True;  { So it doesn't reset to custom }
    FColourScheme := CsScheme;
    SetColourHighlight(ClrSchemes[FColourScheme,cpHighlight]);
    Font.Color := ClrSchemes[FColourScheme,cpFace];
    SetColourShadow(ClrSchemes[FColourScheme,cpShadow]);
    if FColourScheme <> csCustom then begin { Save for future reference }
      ClrSchemes[csCustom,cpHighlight] := ClrSchemes[FColourScheme,cpHighlight];
      ClrSchemes[csCustom,cpFace] := ClrSchemes[FColourScheme,cpFace];
      ClrSchemes[csCustom,cpShadow] := ClrSchemes[FColourScheme,cpShadow];
    end;
    BChangingScheme := False;  { So further changes set colour scheme to custom }
  end;
end;

procedure TLabelEffect.SetAsButton(BBtn: Boolean);
begin
  if FAsButton <> BBtn then begin
    FAsButton := BBtn;
    if BBtn then    { If not already raised, raise it }
      SetEffectStyle(esRaised);
  end;
end;

procedure TLabelEffect.SetAngle(AAngle: TAngleRange);
begin
  if FAngle <> AAngle then begin
    FAngle := AAngle;
    DCosAngle := Cos(FAngle * DDegToRad);
    DSinAngle := Sin(FAngle * DDegToRad);
    if FAngle <> 0 then Alignment := taLeftJustify;  { Cannot align when rotated }
    Invalidate;
  end;
end;

function Min(I, J: Integer): Integer;
begin
  if I < J then Min := I else Min := J;
end;

procedure TLabelEffect.SetTextAngle(Cnv: TCanvas; AAngle: TAngleRange);
var
  FntLogRec: TLogFont;    { Storage area for font information }
begin
  { Get the current font information. We only want to modify the angle }
  GetObject(Cnv.Font.Handle, SizeOf(FntLogRec), Addr(FntLogRec));
  { Modify the angle. "The angle, in tenths of a degrees, between the base
     line of a character and the x-axis." (Windows API Help file.)}
  FntLogRec.lfEscapement := AAngle * 10;
  FntLogRec.lfOutPrecision := OUT_TT_ONLY_PRECIS;  { Request TrueType precision }
  { Delphi will handle the deallocation of the old font handle }
  Cnv.Font.Handle := CreateFontIndirect(FntLogRec);
end;

procedure TLabelEffect.Paint;
const
  WAlignments: array [TAlignment] of word = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  IMinOffset: Integer;
  RctTemp: TRect;
  StrText: array [0..255] of char;
  IMid, IH, IW, IX, IY: Integer;
  P1, P2, P3, P4: TPoint;
begin
  { Find minimum of all offsets (including font itself) }
  IMinOffset := Min(Min(Min(Min(IOffsets[DirectionHighlight,drX] * DepthHighlight,
                IOffsets[DirectionShadow,drX] * DepthShadow),
                IOffsets[DirectionHighlight,drY] * DepthHighlight),
                IOffsets[DirectionShadow,drY] * DepthShadow),0);
  Canvas.Font := Self.Font;              { Ensure canvas font is set }
  if Angle <> 0 then                     { Need to generate an angled font }
    SetTextAngle(Canvas, Angle);
  with Canvas do begin
    if Angle = 0 then begin
      IX := 0; IY := 0; IW:= 0; IH:= 0; IMid:= 0;
    end
    else begin
      IMid := TextWidth(Caption+'   ') div 2;
      IW := TextWidth(Caption);
      IH := TextHeight(Caption);
      IX := IMid - Trunc(IW/2*DCosAngle) - Trunc(IH/2*DSinAngle);
      IY := IMid + Trunc(IW/2*DSinAngle) - Trunc(IH/2*DCosAngle);
    end;
    if not Transparent then begin               { Fill in background }
      Brush.Color := Self.Color;
      Brush.Style := bsSolid;
      if Angle = 0 then FillRect(ClientRect)
      else begin
        IW := IW + 7; IH := IH + 5;
        P1 := Point(IMid - Trunc(IW/2*DCosAngle) - Trunc(IH/2*DSinAngle),
                    IMid + Trunc(IW/2*DSinAngle) - Trunc(IH/2*DCosAngle));
        P2 := Point(IMid + Trunc(IW/2*DCosAngle) - Trunc(IH/2*DSinAngle),
                    IMid - Trunc(IW/2*DSinAngle) - Trunc(IH/2*DCosAngle));
        P3 := Point(IMid + Trunc(IW/2*DCosAngle) + Trunc(IH/2*DSinAngle),
                    IMid - Trunc(IW/2*DSinAngle) + Trunc(IH/2*DCosAngle));
        P4 := Point(IMid - Trunc(IW/2*DCosAngle) + Trunc(IH/2*DSinAngle),
                    IMid + Trunc(IW/2*DSinAngle) + Trunc(IH/2*DCosAngle));
        Polygon([P1, P2, P3, P4]);
      end;
    end;
  end;
  Canvas.Brush.Style := bsClear;         { Don't overwrite background above }
  GetTextBuf(StrText, SizeOf(StrText));  { Get label's caption }
  Canvas.Font.Color := ColourShadow;
  if Angle = 0 then begin
    { Create a rect that is offset for the shadow }
    RctTemp:= Rect(
      ClientRect.Left - IMinOffset + IOffsets[DirectionShadow,drX] * DepthShadow,
      ClientRect.Top - IMinOffset + IOffsets[DirectionShadow,drY] * DepthShadow,
      ClientRect.Right - IMinOffset + IOffsets[DirectionShadow,drX] * DepthShadow,
      ClientRect.Bottom - IMinOffset + IOffsets[DirectionShadow,drY] * DepthShadow);
    { Draw shadow text with alignment }
    DrawText(Canvas.Handle, StrText, StrLen(StrText), RctTemp,
        DT_EXPANDTABS or DT_WORDBREAK or WAlignments[Alignment]);
  end
  else
    { Draw angled shadow text without alignment }
    Canvas.TextOut(IX - IMinOffset + IOffsets[DirectionShadow,drX] * DepthShadow,
                   IY - IMinOffset + IOffsets[DirectionShadow,drY] * DepthShadow, Caption);
  Canvas.Font.Color := ColourHighlight;
  if Angle = 0 then begin
    { Create a rect that is offset for the highlight }
    RctTemp:= Rect(
      ClientRect.Left - IMinOffset + IOffsets[DirectionHighlight,drX] * DepthHighlight,
      ClientRect.Top - IMinOffset + IOffsets[DirectionHighlight,drY] * DepthHighlight,
      ClientRect.Right - IMinOffset + IOffsets[DirectionHighlight,drX] * DepthHighlight,
      ClientRect.Bottom - IMinOffset + IOffsets[DirectionHighlight,drY] * DepthHighlight);
    { Draw highlight text with alignment }
    DrawText(Canvas.Handle, StrText, StrLen(StrText), RctTemp,
        DT_EXPANDTABS or DT_WORDBREAK or WAlignments[Alignment]);
  end
  else
    { Draw angled highlight text without alignment }
    Canvas.TextOut(IX - IMinOffset + IOffsets[DirectionHighlight,drX] * DepthHighlight,
                   IY - IMinOffset + IOffsets[DirectionHighlight,drY] * DepthHighlight, Caption);
  Canvas.Font.Color := Font.Color;  { Restore original font colour }
  if Angle = 0 then begin
    { Create a rect that is offset for the original text }
    RctTemp:= Rect(ClientRect.Left - IMinOffset, ClientRect.Top - IMinOffset,
                   ClientRect.Right - IMinOffset, ClientRect.Bottom - IMinOffset);
    { Draw original text with alignment }
    DrawText(Canvas.Handle, StrText, StrLen(StrText), RctTemp,
        DT_EXPANDTABS or DT_WORDBREAK or WAlignments[Alignment]);
  end
  else
    { Draw angled original text without alignment }
    Canvas.TextOut(IX - IMinOffset, IY - IMinOffset, Caption);
  if Angle <> 0 then                { Restore font to angle 0 }
    SetTextAngle(Canvas, 0);
end;

procedure TLabelEffect.MouseDown(MbBtn: TMouseButton; SsShift: TShiftState; X, Y: Integer);
begin
  if AsButton then begin    { If left button and label isn't sunken }
    if (MbBtn = mbLeft) and (EffectStyle <> esSunken) and Enabled then
      SetEffectStyle(esSunken);
  end
  else inherited MouseDown(MbBtn, SsShift, X, Y);
end;

procedure TLabelEffect.MouseMove(SsShift: TShiftState; X, Y: Integer);
begin
  if AsButton then begin
    if SsShift = [ssLeft] then begin { Left mouse button down }
      { If within label's client area }
      if  (X >= 0) and (X <= ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then SetEffectStyle(esSunken)
      else SetEffectStyle(esRaised);
    end;
  end
  else inherited MouseMove(SsShift, X, Y);
end;

procedure TLabelEffect.MouseUp(MbBtn: TMouseButton; SsShift: TShiftState; X, Y: Integer);
begin
  if AsButton then begin    { If within label's client area }
    if (X >= 0) and (X <= ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
      SetEffectStyle(esRaised);
  end
  else inherited MouseUp(MbBtn, SsShift, X, Y);
end;

procedure Register;
begin
  RegisterComponents('AddOn', [TLabelEffect]);
end;

end.
