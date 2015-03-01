unit UniGraf;

{$I switches.inc}

interface

uses Crt, Objects, MathTool, Graph;

type
  TGrafPort = record
    xp, yp: integer;
    gfx, gfy,
    gfx1, gfx2,
    gfy1, gfy2: PREC;
    sx, sy: integer;
    SizeX, SizeY: integer;
    Scrn: TRect;
    InvertY, InvertX: boolean;
  end;

var GrafPort: ^TGrafPort; (* Graf port corrente *)

procedure GrafInit(var ScrnPort: TGrafPort);
procedure GrafDone(var ScrnPort: TGrafPort);
procedure GSetPort(var Port: TGrafPort);
procedure GClear;
procedure GFrame(xmin,xmax,ymin,ymax: integer);
procedure GScale(xmin,xmax,ymin,ymax: PREC);
procedure GIMove(x,y: integer);
procedure GIDraw(x,y: integer);
procedure GIPlot(x,y: integer); (* Disegna una x *)
procedure GILine(x1,y1,x2,y2: integer);
procedure GMove(x,y: PREC);
procedure GDraw(x,y: PREC);
procedure GPlot(x,y: PREC); (* Disegna una x *)
procedure GLine(x1,y1,x2,y2: PREC);
procedure GXAxis(xst, xen, y, xmin, xstep: PREC);
procedure GYAxis(yst, yen, x, ymin, ystep: PREC);

implementation

const
  BGIPath: string = '';

procedure MoveTo(x,y: integer);
begin
  with GrafPort^ do begin
    if InvertX then x:= SizeX-x;
    if InvertY then y:= SizeY-y;
  end;
  Graph.MoveTo(x,y);
end;

procedure LineTo(x,y: integer);
begin
  with GrafPort^ do begin
    if InvertX then x:= SizeX-x;
    if InvertY then y:= SizeY-y;
  end;
  Graph.LineTo(x,y);
end;

procedure LineRel(x,y: integer);
begin
  with GrafPort^ do begin
    if InvertX then x:= -x;
    if InvertY then y:= -y;
  end;
  Graph.LineRel(x,y);
end;

procedure GrafInit;
var
  grD, grDriver: integer;
  grM, grMode: Integer;
  ErrCode: Integer;
  flg: char;
begin
  DetectGraph(grDriver,grMode);
  case grDriver of
    CGA: grMode:= CGAHi;
    else ;
  end;
  if grDriver = CGA then begin
    flg:= 'N';
    (* write('ATT? '); readln(flg); *)
    if upcase(flg) = 'S' then begin
      grDriver:= ATT400;
      grMode:= ATT400Hi;
    end;
  end;
  repeat
    grD:= grDriver;
    grM:= grMode;
    InitGraph(grD, grM, BGIPath);
    ErrCode := GraphResult;
    if ErrCode <> 0 then begin
      if ErrCode <> -3 then begin
        Writeln('Graphics error: ',GraphErrorMsg(ErrCode));
        Halt(1);
      end
      else begin
        writeln;
        write('BGI Path = '); readln(BGIPath);
      end;
    end;
  until ErrCode = grOk;
  FillChar(ScrnPort, sizeof(ScrnPort), 0);
  GrafPort:= @ScrnPort;
  GFrame(0,GetMaxX,0,GetMaxY);
  GrafPort^.sx:= (GetMaxX+1) div 100;
  GrafPort^.sy:= (GetMaxY+1) div 100;
  GrafPort^.InvertX:= false;
  GrafPort^.InvertY:= true;
  DirectVideo:= false;
end;

procedure GrafDone;
begin
  CloseGraph;
  DirectVideo:= true;
end;

procedure GSetPort;
begin
  GrafPort:= @Port;
  with GrafPort^ do begin
    GFrame(Scrn.A.X,Scrn.B.X,Scrn.A.Y,Scrn.B.Y);
  end;
end;

procedure GClear;
begin
  ClearViewPort;
  SetColor(255);
end;

procedure GFrame;
begin
  with GrafPort^ do begin
    Scrn.A.X:= XMin;
    Scrn.A.Y:= YMin;
    Scrn.B.X:= XMax;
    Scrn.B.Y:= YMax;
    SizeX:= (Scrn.B.X - Scrn.A.X);
    SizeY:= (Scrn.B.Y - Scrn.A.Y);
    SetViewPort(xmin,ymin,xmax,ymax, true);
  end;
end;

procedure GScale;
begin
  with GrafPort^ do begin
    gfx1:= XMin; gfx2:= XMax;
    gfy1:= YMin; gfy2:= YMax;
    if (XMax-XMin) <> 0 then gfx:= (SizeX) / (XMax-XMin) else gfx:= SizeX;
    if (YMax-YMin) <> 0 then gfy:= (SizeY) / (YMax-YMin) else gfy:= SizeY;
  end;
end;

procedure GIMove;
begin
  with GrafPort^ do begin
    xp:= x;
    yp:= y;
    MoveTo(xp, yp);
  end;
end;

procedure GIDraw;
begin
  with GrafPort^ do begin
    xp:= x;
    yp:= y;
    LineTo(xp, yp);
  end;
end;

procedure GIPlot;
begin
  with GrafPort^ do begin
    xp:= x;
    yp:= y;
    MoveTo(xp+sx, yp+sy); lineTo(xp-sx, yp-sy);
    MoveTo(xp-sx, yp+sy); lineTo(xp+sx, yp-sy);
    MoveTo(xp,yp);
  end;
end;

procedure GILine;
begin
  GIMove(x1,y1);
  GIPlot(x2,y2);
end;

procedure GMove;
begin
  with GrafPort^ do begin
    xp:= round((x-gfx1)*gfx);
    yp:= round((y-gfy1)*gfy);
    MoveTo(xp, yp);
  end;
end;

procedure GDraw;
begin
  with GrafPort^ do begin
    xp:= round((x-gfx1)*gfx);
    yp:= round((y-gfy1)*gfy);
    LineTo(xp, yp);
  end;
end;

procedure GPlot; (* Disegna una x *)
begin
  with GrafPort^ do begin
    xp:= round((x-gfx1)*gfx);
    yp:= round((y-gfy1)*gfy);
    MoveTo(xp+sx, yp+sy); lineTo(xp-sx, yp-sy);
    MoveTo(xp-sx, yp+sy); lineTo(xp+sx, yp-sy);
    MoveTo(xp,yp);
  end;
end;

procedure GLine; (* Disegna una x *)
begin
  GMove(x1,y1);
  GPlot(x2,y2);
end;

procedure GXAxis;
var
  x: PREC;
begin
  with GrafPort^ do begin
    GMove(xst, y);
    GDraw(xen, y);
    x:= xmin;
    while (x <= xen) do begin
      GMove(x, y);
      LineRel(0, sy);
      x:= x + xstep;
    end;
  end;
end;

procedure GYAxis;
var
  y: PREC;
begin
  with GrafPort^ do begin
    GMove(x, yst);
    GDraw(x, yen);
    y:= ymin;
    while (y <= yen) do begin
      GMove(x, y); LineRel(sx, 0);
      y:= y + ystep;
    end;
  end;
end;

end.
