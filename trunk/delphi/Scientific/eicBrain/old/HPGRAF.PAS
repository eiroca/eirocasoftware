unit HpGraf;

{$I switches.inc}

interface

uses Crt, Objects, Graph, MathTool;

var
  gfx, gfy,
  gfa, gfb,
  gfc, gfd: PREC;
  sx, sy: integer;
  SizeX, SizeY: integer;
  Scrn: TRect;

procedure GInit;
procedure GDone;
procedure GClear;
procedure Scale(xmin,xmax,ymin,ymax: PREC);
procedure XAsis(xmin, xstep: PREC);
procedure YAsis(ymin, ystep: PREC);
procedure Move(x,y: PREC);
procedure Draw(x,y: PREC);
procedure Plot(x,y: PREC); (* Disegna una x *)
procedure Line(x1,y1,x2,y2: PREC); (* Disegna una x *)
procedure frame(xmin,xmax,ymin,ymax: integer);
procedure YYAsis(x,ystep,st,ed: PREC);
procedure XXAsis(y, xstep, st,ed: PREC);

implementation

const
  BGIPath: string = '';

procedure GInit;
var
  grDriver: integer;
  grMode: Integer;
  ErrCode: Integer;
  flg: char;
begin
  repeat
    grDriver := Detect;
    case grDriver of
      CGA: grMode:= CGAHi;
      else grMode:= 0;
    end;
    if grDriver = CGA then begin
      write('ATT? '); readln(flg);
      if upcase(flg) = 'S' then begin
        grDriver:= ATT400;
        grMode:= ATT400Hi;
      end;
    end;
    InitGraph(grDriver, grMode, BGIPath);
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
  SizeX:= GetMaxX;
  SizeY:= GetMaxY;
  sx:= SizeX div 133+1;
  sy:= SizeY div 100+1;
  Scrn.A.X:= 0; Scrn.A.Y:= 0;
  Scrn.B.X:= pred(SizeX); Scrn.B.Y:= Pred(SizeY);
  DirectVideo:= false;
end;

procedure GDone;
begin
  CloseGraph;
  DirectVideo:= true;
end;

procedure GClear;
begin
  ClearDevice;
  SetColor(GetMaxColor);
end;

procedure frame(xmin,xmax,ymin,ymax: integer);
begin
  Scrn.A.X:= XMin;
  Scrn.A.Y:= YMin;
  Scrn.B.X:= XMax;
  Scrn.B.Y:= YMax;
  SizeX:= succ(Scrn.B.X - Scrn.A.X);
  SizeY:= succ(Scrn.B.Y - Scrn.A.Y);
end;

procedure Scale(xmin,xmax,ymin,ymax: PREC);
begin
  gfa:= XMin; gfc:= XMax;
  gfb:= YMin; gfd:= YMax;
  if (XMax-XMin) <> 0 then gfx:= SizeX / (XMax-XMin) else gfx:= SizeX;
  if (YMax-YMin) <> 0 then gfy:= SizeY / (YMax-YMin) else gfy:= SizeY;
end;

procedure XAsis(xmin, xstep: PREC);
var
  x: PREC;
begin
  Move(gfa, gfb);
  Draw(gfc, gfb);
  x:= gfa + xmin;
  while (x <= gfc) do begin
    Move(x, 0); LineRel(0, -sy);
    x:= x + xstep;
  end;
end;

procedure XXAsis(y, xstep, st,ed: PREC);
var
  x: PREC;
begin
  Move(st, y);
  Draw(ed, y);
  x:= st;
  while (x <= ed) do begin
    Move(x, y); LineRel(0, -sy);
    x:= x + xstep;
  end;
end;

procedure YAsis(ymin, ystep: PREC);
var
  y: PREC;
begin
  Move(gfa, gfb);
  Draw(gfa, gfd);
  y:= gfb + ymin;
  while (y <= gfd) do begin
    Move(0, y); LineRel(sx, 0);
    y:= y + ystep;
  end;
end;

procedure YYAsis(x,ystep,st,ed: PREC);
var
  y: PREC;
begin
  Move(x, st);
  Draw(x, ed);
  y:= st;
  while (y <= ed) do begin
    Move(x, y); LineRel(sx, 0);
    y:= y + ystep;
  end;
end;

procedure Move(x,y: PREC);
var xx, yy: integer;
begin
  xx:= Scrn.A.X + round((x-gfa)*gfx);
  yy:= Scrn.B.Y - round((y-gfb)*gfy);
  MoveTo(xx, yy);
end;

procedure Draw(x,y: PREC);
var xx, yy: integer;
begin
  xx:= Scrn.A.X + round((x-gfa)*gfx);
  yy:= Scrn.B.Y - round((y-gfb)*gfy);
  LineTo(xx, yy);
end;

procedure Plot(x,y: PREC); (* Disegna una x *)
var
  xx, yy: integer;
begin
  xx:= Scrn.A.X + round((x-gfa)*gfx);
  yy:= Scrn.B.Y - round((y-gfb)*gfy);
  MoveTo(xx+sx, yy+sy); lineTo(xx-sx, yy-sy);
  MoveTo(xx-sx, yy+sy); lineTo(xx+sx, yy-sy);
  MoveTo(xx,yy);
end;

procedure Line(x1,y1,x2,y2: PREC); (* Disegna una x *)
begin
  Move(x1,y1); Plot(x2,y2);
end;

end.
