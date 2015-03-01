unit Charting;

{$I switches.inc}

interface

uses Crt, Objects, UniGraf, Graph, DataMngr, MathStat, MathTool, MathTls1;

const MaxSerie = 10;

const
  ScaLogX = 1 shl  1;
  ScaLogY = 1 shl  2;
  JoinDot = 1 shl  3;
  BigDot  = 1 shl  4;
  ShowAve = 1 shl  5;
  ShowXAx = 1 shl  6;
  ShowYAx = 1 shl  7;
  ShwGrdX = 1 shl  8;
  ShwGrdY = 1 shl  9;
  Multiple= 1 shl 10;

type

  PChart = ^TChart;
  TChart = object
    Title1: string;
    Title2: string;
    TitleX: string;
    TitleY: string;
    NumDat, NumSer: integer;
    SerieY: array[1..MaxSerie] of PSerie;
    minY,maxY: PREC;
    aveY,sigY: PREC;
    ValMinX,ValMaxX: PREC;
    ValMinY,ValMaxY: PREC;
    Options: longint;
    MainPort,
    ChartPort,
    TitlePort,
    XAxisPort,
    YAxisPort,
    LabelPort: TGrafPort;
    TaccheX, TaccheY: integer;
    Xp, Yp: PREC;
    constructor Init;
    procedure   Run(Spread: PSpread);
    procedure   GetSerie(var Spread: TSpread); virtual;
    procedure   Analyze; virtual;
    procedure   GetScale; virtual;
    procedure   GetOption; virtual;
    procedure   GetTitle; virtual;
    procedure   Draw; virtual;
    procedure   DrawDone; virtual;
    destructor  Done; virtual;
   private (* protected *)
    LabelSize,
    XAxisSize,
    YAxisSize,
    TitleSize: integer;
    sx, sy: PREC;
    tt, tl, tx, ty: integer;
    procedure   InitGraf; virtual;
    procedure   InitPort; virtual;
    procedure   DrawXAxis; virtual;
    procedure   DrawYAxis; virtual;
    procedure   DrawChart; virtual;
    procedure   DrawGrid; virtual;
    procedure   DrawTitle; virtual;
    procedure   DoneGraf; virtual;
  end;

  PChartXY = ^TChartXY;
  TChartXY = object(TChart)
    SerieX: PSerie;
    minX,maxX: PREC;
    aveX,sigX: PREC;
    constructor Init;
    procedure   GetScale; virtual;
    procedure   Analyze; virtual;
    procedure   GetSerie(var Spread: TSpread); virtual;
    destructor  Done; virtual;
  end;

  PCartChart = ^TCartChart;
  TCartChart = object(TChart)
    procedure   DrawChart; virtual;
  end;

  PScatChart = ^TScatChart;
  TScatChart = object(TChartXY)
    procedure   DrawChart; virtual;
    procedure   InitGraf; virtual;
  end;

  PF_xChart = ^TF_xChart;
  TF_xChart = object(TScatChart)
    procedure Run(f: F_x; xi, xf: PREC; step: integer);
  end;

  PParamChart = ^TParamChart;
  TParamChart = object(TScatChart)
    procedure Run(fx, fy: F_x; xi, xf: PREC; step: integer);
  end;

implementation

const
  Tacche_Y = 20;
  Tacche_X = 25;
  X_p = 0.5;
  Y_p = 0.5;

procedure AnalyzeSerie(NumSer,NumDat: integer; Serie: array of PSerie; var min,max,ave,sig: PREC);
var
  i,j,lw: integer;
  SumN, SumX, SumX2: DPREC;
  tmp: PREC;
begin
  lw:= low(serie);
  if (NumSer < 1) or (NumDat<1) then begin
    min:= 0;
    max:= 0;
    ave:= 0;
    sig:= 0;
    exit;
  end;
  min:= Serie[lw]^.At(1)^;
  max:= Serie[lw]^.At(1)^;
  SumX:= 0;
  SumX2:= 0;
  SumN:= 0;
  for i:= lw to lw+NumSer-1 do begin
    for j:= 1 to NumDat do begin
      tmp:= Serie[i]^.At(j)^;
      SumX:= SumX + tmp;
      SumX2:= SumX2 + sqr(tmp);
      if tmp > max then max:= tmp
      else if tmp < min then min:= tmp;
    end;
    SumN:= SumN + NumDat;
  end;
  ave:= SumX / SumN;
  sig:= sqrt((SumX2-sqr(SumX)/SumN)/SumN);
end;

constructor TChart.Init;
var i: integer;
begin
  Title1:= '';
  Title2:= '';
  TitleX:= '';
  TitleY:= '';
  NumDat:=  0;
  NumSer:=  0;
  for i:=1 to maxSerie do SerieY[i]:= nil;
  minY:= 0;
  maxY:= 0;
  aveY:= 0;
  sigY:= 0;
  ValMinY:= 0;
  ValMaxY:= 0;
  Options:= 0;
  FillChar(MainPort,sizeof(TGrafPort),0);
  FillChar(ChartPort,sizeof(TGrafPort),0);
  FillChar(TitlePort,sizeof(TGrafPort),0);
  FillChar(XAxisPort,sizeof(TGrafPort),0);
  FillChar(YAxisPort,sizeof(TGrafPort),0);
  FillChar(LabelPort,sizeof(TGrafPort),0);
  TaccheX:= Tacche_x;
  TaccheY:= Tacche_y;
  Xp:= X_p;
  Yp:= Y_p;
end;

procedure TChart.Run(Spread: PSpread);
var
  YesFlag: integer;
begin
  if Spread <> nil then GetSerie(Spread^);
  if NumSer <> 0 then begin
    Analyze;
    repeat
      GetScale;
      GetTitle;
      GetOption;
      Draw;
      DrawDone;
      ClrScr;
      GetSiNo('Vuoi ridisegnare il grafico cambiando i parametri? ', YesFlag);
    until YesFlag=0;
  end;
end;

procedure TChart.GetSerie(var Spread: TSpread);
var
  i, YN, cnt: integer;
  ch: char;
label ReLoop;
begin
  NumSer:= 0;
  writeln('Quale serie vuoi diagrammare?');
  cnt:= 1;
  Spread.GetSerie(ch);
  if ch = #0 then exit;
  SerieY[cnt]:= Spread.Cols[ch];
  NumDat:= SerieY[cnt]^.Count;
  if (Options and multiple) <> 0 then begin
    repeat
    ReLoop:
      writeln;
      YN:= 0;
      GetSiNo('Vuoi sovrapporre con un''altra serie (S/N)? ', YN);
      if YN=1 then begin
        writeln;
        Writeln('Quale serie vuoi diagrammare?');
        Spread.GetSerie(ch);
        if (ch <> #0) then begin
         for i:= 1 to cnt do begin
           if Spread.Cols[ch] = SerieY[i] then begin
              writeln('La serie viene gia'' diagrammata!');
              goto ReLoop;
            end;
          end;
          if Spread.Cols[ch]^.Count <> NumDat then begin
            writeln('Le serie devono avere lo stesso numero di dati!');
            goto ReLoop;
          end;
          if cnt > MaxSerie then begin
            writeln('Al massimo ',MaxSerie,' serie in contemporanea!');
            goto ReLoop;
          end;
          inc(cnt);
          SerieY[cnt]:= Spread.Cols[ch];
        end;
      end;
    until YN=0;
  end;
  NumSer:= cnt;
end;

procedure TChart.Analyze;
begin
  AnalyzeSerie(NumSer, NumDat, SerieY, minY, maxY, aveY, sigY);
  ValMinY:= minY;
  ValMaxY:= maxY;
end;

procedure TChart.GetScale;
var
  p, k: PREC;
  i, YesFlag: integer;
begin
  repeat
    ClrScr;
    writeln('Immissione dei valori della scala del grafico');
    writeln;
    writeln('I dati da diagrammare sono caratterizzati da:');
    writeln;
    writeln('Media = ', aveY:12:3, '     e.q.m. (å) = ',sigY:12:3);
    writeln;
    p:= 0.0001;
    while abs(p-1)>Zero do begin
      k:= sqrt(1/p);
      writeln('al ',((1-p)*100):6:2,'% i dati "teorici" sono compresi in [',
        (aveY-k*sigY):12:3,' ö ',(aveY+k*sigY):12:3,']');
      p:= p * 10;
    end;
    p:= 0.5;
    k:= sqrt(1/p);
    writeln('al ',((1-p)*100):6:2,'% i dati "teorici" sono compresi in [',
      (aveY-k*sigY):12:3,' ö ',(aveY+k*sigY):12:3,']');
    writeln;
    write  ('Valore Minimo= ', MinY:12:3); writeln('    Valore Max   = ', MaxY:12:3);
    writeln;
    writeln('Valore Minimo della scala  = ', ValMinY:12:3);
    writeln('Valore Massimo della scala = ', ValMaxY:12:3);
    if (MaxY>ValMaxY) or (MinY<ValMinY) then writeln('Attenzione alcuno dati non verranno visualizzati!');
    writeln;
    YesFlag:= 0;
    GetSiNo('Vuoi cambiare questi valori ? ', YesFlag);
    if YesFlag = 0 then break;
    writeln;
    if MinY >= 0 then begin
      YesFlag:= 0;
      GetSiNo('Scala a esponenti di 10 ? ', YesFlag);
      if YesFlag = 1 then begin
        I:= 1;
        while IntPow(10,I) < MaxY do inc(i);
        ValMinY:= 0;
        ValMaxY:= IntPow(10,I);
        continue;
      end;
    end;
    writeln;
    InputPrec('Nuovo valore Minimo : ', ValMinY, -inf, inf);
    InputPrec('Nuovo valore Massimo: ', ValMaxY, -inf, inf);
  until false;
end;

procedure TChart.GetOption;
  procedure GetOpt(msg: string; vl: longint);
  var YesFlag: integer;
  begin
    if (Options and vl) <> 0 then YesFlag:= 1 else YesFlag:= 0;
    GetSiNo(Msg, YesFlag);
    Options:= (Options and (not vl)) or (vl * YesFlag);
  end;
begin
  ClrScr;
  writeln('Scelta opzioni tracciamento grafico');
  writeln;
{
  GetOpt('Uso scdala logaritmica lungo X? ', ScaLogX);
  GetOpt('Uno scala logaritmica lungo Y? ', ScaLogY);
  writeln;
}
  GetOpt('Vuoi i punti uniti da una linea? ', JoinDot);
  GetOpt('Vuoi ingrossare i punti? ', BigDot);
  writeln;
  GetOpt('Vuoi l''indicazione del asse X? ', ShowXAx);
  GetOpt('Vuoi l''indicazione del asse Y? ', ShowYAx);
  writeln;
  GetOpt('Vuoi la griglia sul asse X? ', ShwGrdX);
  GetOpt('Vuoi la griglia sul asse Y? ', ShwGrdY);
  writeln;
  GetOpt('Vuoi visualizzati media e sigma? ', ShowAve);
end;

procedure TChart.GetTitle;
begin
  ClrScr;
  Writeln('Titolo del grafico');
  InputStr(': ', Title1);
  writeln;
  Writeln('Sottotitolo del grafico');
  InputStr(': ', Title2);
  writeln;
  Writeln('Nome dell''asse X');
  InputStr(': ', TitleX);
  writeln;
  Writeln('Nome dell''asse Y');
  InputStr(': ', TitleY);
end;

procedure TChart.Draw;
begin
  InitGraf;
  InitPort;
  DrawXAxis;
  DrawYAxis;
  DrawChart;
  DrawGrid;
  DrawTitle;
end;

procedure TChart.DrawDone;
begin
  repeat until keypressed; while readkey <> #13 do ;
  DoneGraf;
end;

procedure TChart.InitGraf;
begin
  GrafInit(MainPort);
  GClear;
  ValMinX:= 1; ValMaxX:= NumDat;
  TaccheX:= NumDat-1;
  sy:= (ValMaxY-ValMinY) / TaccheY;
  sx:= 1;
end;

procedure TChart.InitPort;
begin
  TitleSize:= 0; tt:= 1;
  LabelSize:= 0; tl:= 1;
  XAxisSize:= 0; tx:= 1;
  YAxisSize:= 0; ty:= 1;
  if Title1 <> '' then inc(TitleSize, 17);
  if Title2 <> '' then begin inc(TitleSize,  9); tt:= 3; end;
  if (Options and ShowXAx) <> 0 then inc(XAxisSize, MainPort.sy);
  if (Options and ShowYAx) <> 0 then inc(YAxisSize, MainPort.sx);
  if TitleX <> '' then begin
    tx:= (9 div MainPort.sy)+2;
    XAxisSize:= tx*MainPort.sy;
  end;
  if TitleY <> '' then begin
    ty:= (9 div MainPort.sx)+2;
    YAxisSize:= ty*MainPort.sx;
  end;
  ChartPort:= MainPort;
  LabelPort:= MainPort;
  XAxisPort:= MainPort;
  YAxisPort:= MainPort;
  TitlePort:= MainPort;
  GSetPort(ChartPort);
  GFrame(YAxisSize,MainPort.SizeX-LabelSize,TitleSize,MainPort.SizeY-XAxisSize);
  GScale(ValMinX-sx*Xp,ValMaxX+sx*Xp,ValMinY-sy*Yp,ValMaxY+sy*Yp);
  GSetPort(XAxisPort);
  GFrame(YAxisSize,MainPort.SizeX-LabelSize,MainPort.SizeY-XAxisSize,MainPort.SizeY);
  GScale(ValMinX-sx*Xp,ValMaxX+sx*Xp,0,tx);
  GSetPort(YAxisPort);
  GFrame(0,YAxisSize,TitleSize,MainPort.SizeY-XAxisSize);
  GScale(0,ty,ValMinY-sy*Yp,ValMaxY+sy*Yp);
  GSetPort(LabelPort);
  GFrame(MainPort.SizeX-LabelSize,MainPort.SizeX,TitleSize,MainPort.SizeY-XAxisSize);
  GSetPort(TitlePort);
  GFrame(0,MainPort.SizeX,0,TitleSize);
  GScale(0,1,0,tt);
end;

procedure TChart.DrawXAxis;
begin
  GSetPort(XAxisPort);
  if (Options and ShowXAx) <> 0 then GXAxis(XAxisPort.gfx1,XAxisPort.gfx2,tx-1,ValMinX,sx);
  if TitleX <> '' then begin
    SetTextJustify(CenterText, CenterText);
    SetTextStyle(DefaultFont, HorizDir, 1);
    GMove((XAxisPort.gfx1+XAxisPort.gfx2)/2, (tx-1.5)*0.5);
    OutText(TitleX);
  end;
end;

procedure TChart.DrawYAxis;
begin
  GSetPort(YAxisPort);
  if (Options and ShowYAx) <> 0 then GYAxis(YAxisPort.gfy1,YAxisPort.gfy2,ty-1,ValMinY,sy);
  if TitleY <> '' then begin
    SetTextJustify(CenterText,CenterText);
    SetTextStyle(DefaultFont, VertDir, 1);
    GMove((ty-1)*0.5,(YAxisPort.gfy1+YAxisPort.gfy2)/2);
    OutText(TitleY);
  end;
end;

procedure TChart.DrawChart;
begin
  GSetPort(ChartPort);
  GClear;
end;

procedure TChart.DrawGrid;
var
  temp: TGrafPort;
  j: integer;
  tmp: PREC;
begin
  if (Options and ShwGrdX) <> 0 then begin
    tmp:= ValMinX;
    for j:= 0 to TaccheX do begin
      if (Options and ShowXAx) <> 0 then GMove(tmp,ValMinY-sy*Yp) else GMove(tmp,ValMinY);
      GDraw(tmp,ValMaxY);
      tmp:= tmp + sx;
    end;
  end;
  if (Options and ShwGrdY) <> 0 then begin
    tmp:= ValMinY;
    for j:= 0 to TaccheY do begin
      if (Options and ShowYAx) <> 0 then GMove(ValMinX-sx*Xp,tmp)
      else GMove(ValMinX,tmp);
      GDraw(ValMaxX,tmp);
      tmp:= tmp + sy;
    end;
  end;
  if (Options and ShowAve) <> 0 then begin
    GMove(ValMinX,aveY);
    GDraw(ValMaxX,aveY);
    GPlot(ValMinX-sx*Xp,aveY);
    GPlot(ValMaxX+sx*Xp,aveY);
    for j:= 0 to 5 do begin
      GMove(ValMinX,aveY+j*sigY);
      GDraw(ValMaxX,aveY+j*sigY);
      GPlot(ValMinX-sx*Xp,aveY+j*sigY);
      GMove(ValMinX,aveY-j*sigY);
      GDraw(ValMaxX,aveY-j*sigY);
      GPlot(ValMinX-sx*Xp,aveY-j*sigY);
    end;
  end;
  if ((Options and ShowXAx) <> 0) and ((Options and ShowYAx) <> 0) then begin
    Temp:= MainPort;
    GSetPort(Temp);
    GFrame(0,YAxisSize,MainPort.SizeY-XAxisSize,MainPort.SizeY);
    GScale(0,ty,0,tx);
    GMove(ty-1,tx); GDraw(ty-1,tx-1); GDraw(ty,tx-1);
    (* GPlot(tx-1,ty-1); *)
  end;
end;

procedure TChart.DrawTitle;
begin
  GSetPort(TitlePort);
  SetTextJustify(CenterText, TopText);
  if Title1 <> '' then begin
    SetTextStyle(DefaultFont, HorizDir, 2);
    GMove(0.5,0.1); OutTextXY(TitlePort.xp,TitlePort.yp,Title1);
  end;
  if Title2 <> '' then begin
    if Title1='' then tt:= 1;
    SetTextStyle(DefaultFont, HorizDir, 1);
    GMove(0.5,(tt-1)+0.1); OutTextXY(TitlePort.xp,TitlePort.yp,Title2);
  end;
end;

procedure TChart.DoneGraf;
begin
  GrafDone(MainPort);
end;

destructor TChart.Done;
begin
end;

constructor TChartXY.Init;
begin
  inherited Init;
  minX:= 0;
  maxX:= 0;
  aveX:= 0;
  sigX:= 0;
  ValMinX:= 0;
  ValMaxX:= 0;
end;

procedure TChartXY.GetSerie(var Spread: TSpread);
var
  i, YN, cnt: integer;
  ch: char;
label ReLoop;
begin
  NumSer:= 0;
  writeln('Quale serie vuoi usere come X?');
  Spread.GetSerie(ch);
  if ch = #0 then exit;
  SerieX:= Spread.Cols[ch];
  NumDat:= SerieX^.Count;
  cnt:= 1;
  repeat
    writeln;
    writeln('Quale serie vuoi usere come Y?');
    Spread.GetSerie(ch);
    if ch = #0 then exit;
    if Spread.Cols[ch]^.Count <> NumDat then begin
      writeln('Le serie devono avere lo stesso numero di dati!');
      continue;
    end;
  until true;
  SerieY[cnt]:= Spread.Cols[ch];
  if (Options and multiple) <> 0 then begin
    repeat
    ReLoop:
      writeln;
      YN:= 0;
      GetSiNo('Vuoi sovrapporre con un''altra serie Y (S/N)? ', YN);
      if YN=1 then begin
        writeln;
        writeln('Quale serie vuoi usere come Y?');
        Spread.GetSerie(ch);
        if (ch <> #0) then begin
          for i:= 1 to cnt do begin
            if Spread.Cols[ch] = SerieY[i] then begin
              writeln('La serie viene gia'' diagrammata!');
              goto ReLoop;
            end;
          end;
          if Spread.Cols[ch]^.Count <> SerieY[1]^.Count then begin
            writeln('Le serie devono avere lo stesso numero di dati!');
            goto ReLoop;
          end;
          if cnt > MaxSerie then begin
            writeln('Al massimo ',MaxSerie,' serie in contemporanea!');
            goto ReLoop;
          end;
          inc(cnt);
          SerieY[cnt]:= Spread.Cols[ch];
        end;
      end;
    until YN=0;
  end;
  NumSer:= cnt;
end;

procedure TChartXY.Analyze;
begin
  AnalyzeSerie(     1, NumDat, SerieX, minX, maxX, aveX, sigX);
  AnalyzeSerie(NumSer, NumDat, SerieY, minY, maxY, aveY, sigY);
  ValMinY:= minY;
  ValMaxY:= maxY;
  ValMinX:= minX;
  ValMaxX:= maxX;
end;

procedure TChartXY.GetScale;
var
  p, k: PREC;
  i, YesFlag: integer;
begin
  repeat
    ClrScr;
    writeln('Immissione dei valori della scala del grafico');
    writeln;
    writeln('I dati da diagrammare sono caratterizzati da:');
    writeln('Media X= ', aveX:12:3, '     e.q.m. (å) X= ',sigX:12:3);
    writeln('Media Y= ', aveY:12:3, '     e.q.m. (å) Y= ',sigY:12:3);
    p:= 0.01;
    while abs(p-1)>Zero do begin
      k:= sqrt(1/p);
      writeln('al ',((1-p)*100):6:2,'% i dati "teorici" Y sono compresi in [',
        (aveY-k*sigY):12:3,' ö ',(aveY+k*sigY):12:3,']');
      p:= p * 10;
    end;
    p:= 0.5;
    k:= sqrt(1/p);
      writeln('al ',((1-p)*100):6:2,'% i dati "teorici" Y sono compresi in [',
        (aveY-k*sigY):12:3,' ö ',(aveY+k*sigY):12:3,']');
    writeln;
    write('Valore Minimo X = ', MinX:12:3); writeln('   Valore Max    X = ', MaxX:12:3);
    write('Valore Minimo Y = ', MinY:12:3); writeln('   Valore Max    Y = ', MaxY:12:3);
    writeln;
    writeln('Valore Minimo della scala  X = ', ValMinX:12:3);
    writeln('Valore Massimo della scala X = ', ValMaxX:12:3);
    writeln('Valore Minimo della scala  Y = ', ValMinY:12:3);
    writeln('Valore Massimo della scala Y = ', ValMaxY:12:3);
    if (MaxX>ValMaxX) or (MinX<ValMinX) or (MaxX>ValMaxX) or (MinX<ValMinX) then
      writeln('Attenzione alcuno dati non verranno visualizzati!');
    writeln;
    YesFlag:= 0;
    GetSiNo('Vuoi cambiare questi valori ? ', YesFlag);
    if YesFlag = 0 then break;
    writeln;
    if MinX >= 0 then begin
      YesFlag:= 0;
      GetSiNo('Scala X a esponenti di 10 ? ', YesFlag);
      if YesFlag = 1 then begin
        I:= 1;
        while IntPow(10,I) < MaxX do inc(i);
        ValMinX:= 0;
        ValMaxX:= IntPow(10,I);
        continue;
      end;
    end;
    if MinY >= 0 then begin
      YesFlag:= 0;
      GetSiNo('Scala Y a esponenti di 10 ? ', YesFlag);
      if YesFlag = 1 then begin
        I:= 1;
        while IntPow(10,I) < MaxY do inc(i);
        ValMinY:= 0;
        ValMaxY:= IntPow(10,I);
        continue;
      end;
    end;
    writeln;
    InputPrec('Nuovo valore Minimo  scala X: ', ValMinX, -inf, inf);
    InputPrec('Nuovo valore Massimo scala X: ', ValMaxX, -inf, inf);
    InputPrec('Nuovo valore Minimo  scala Y: ', ValMinY, -inf, inf);
    InputPrec('Nuovo valore Massimo scala Y: ', ValMaxY, -inf, inf);
  until false;
end;

destructor TChartXY.Done;
begin
  inherited Done;
end;

procedure TCartChart.DrawChart;
var
  i,j: integer;
begin
  GSetPort(ChartPort);
  for I:= 1 to NumSer do begin
    with SerieY[i]^ do begin
      GMove(1,At(1)^);
      if (Options and BigDot) = 0 then GDraw(1,At(1)^) else GPlot(1,At(1)^);
      for J:= 1 to NumDat do begin
        if (Options and JoinDot) <> 0 then GDraw(j,At(j)^);
        GMove(j,At(j)^);
        if (Options and BigDot) = 0 then GDraw(j,At(j)^) else GPlot(j,At(j)^);
      end;
    end;
  end;
end;

procedure TScatChart.InitGraf;
begin
  GrafInit(MainPort);
  GClear;
  sy:= (ValMaxY-ValMinY) / TaccheY;
  sx:= (ValMaxX-ValMinX) / TaccheX;
end;

procedure TScatChart.DrawChart;
var i,j: integer;
begin
  GSetPort(ChartPort);
  for I:= 1 to NumSer do begin
    with SerieY[i]^ do begin
      GMove(SerieX^.At(1)^,At(1)^);
      if (Options and BigDot) = 0 then GDraw(SerieX^.At(1)^,At(1)^)
      else GPlot(SerieX^.At(1)^,At(1)^);
      for J:= 2 to NumDat do begin
        if (Options and JoinDot) <> 0 then GDraw(SerieX^.At(j)^,At(j)^);
        GMove(SerieX^.At(j)^,At(j)^);
        if (Options and BigDot) = 0 then GDraw(SerieX^.At(j)^,At(j)^)
        else GPlot(SerieX^.At(j)^,At(j)^);
      end;
    end;
  end;
end;

procedure TF_xChart.Run;
var
  tmp, dlt: PREC;
  i: integer;
begin
  if Step <= 1 then Step:= MaxData-1;
  if Step >= MAxData then Step:= MaxData-1;
  NumDat:= Step;
  NumSer:= 1;
  SerieX:= New(PSerie, Init(MaxData));
  SerieY[1]:= New(PSerie, Init(MaxData));
  if xf<xi then begin
    dlt:= xf;
    xf:= xi;
    xi:= dlt;
  end;
  dlt:= (xf-xi) / (Step-1);
  tmp:= xi;
  for i:= 1 to Step do begin
    SerieX^.Append(tmp);
    SerieY[1]^.Append(f(tmp));
    tmp:= tmp + dlt;
  end;
  inherited Run(nil);
end;

procedure TParamChart.Run;
var
  tmp, dlt: PREC;
  i: integer;
begin
  if Step <= 1 then Step:= MaxData-1;
  if Step >= MAxData then Step:= MaxData-1;
  NumDat:= Step;
  NumSer:= 1;
  SerieX:= New(PSerie, Init(MaxData));
  SerieY[1]:= New(PSerie, Init(MaxData));
  if xf<xi then begin
    dlt:= xf;
    xf:= xi;
    xi:= dlt;
  end;
  dlt:= (xf-xi) / (Step-1);
  tmp:= xi;
  for i:= 1 to Step do begin
    SerieX^.Append(fx(tmp));
    SerieY[1]^.Append(fy(tmp));
    tmp:= tmp + dlt;
  end;
  inherited Run(nil);
end;

end.
