(* GPL > 3.0
Copyright (C) 1997-2008 eIrOcA Enrico Croce & Simona Burzio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)
(*
 @author(Enrico Croce)
*)
unit FMain;

interface

uses
  WidgetGame, SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, JvTimerList, ExtCtrls, JvCtrls, JvExControls, JvLabel;

type
  TfmMain = class(TForm)
    imMain: TImage;
    btPlay: TBitBtn;
    btExit: TBitBtn;
    btHelp: TBitBtn;
    lbMain: TJvLabel;
    imAnim1b: TImage;
    imAnim1a: TImage;
    tlTimers: TJvTimerList;
    imAnim2a: TImage;
    imAnim2b: TImage;
    imAnim3a: TImage;
    imAnim3b: TImage;
    lbCopyright: TLabel;
    lbMain2: TLabel;
    procedure teAnim1Timer(Sender: TObject);
    procedure btExitClick(Sender: TObject);
    procedure teAnim2Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure teAnim3Timer(Sender: TObject);
    procedure btPlayClick(Sender: TObject);
    procedure btHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure showAbout(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    WG: TWidgetGame;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}
uses
  FGame, FLetter, FMarketReport, FResult, MessageStr, FHelp, FAboutGPL;

procedure TfmMain.FormShow(Sender: TObject);
begin
  imAnim1a.Visible:= true;
  imAnim1b.Visible:= false;
  imAnim2a.Visible:= true;
  imAnim2b.Visible:= false;
  imAnim3a.Visible:= true;
  imAnim3b.Visible:= false;
  tlTimers.Active:= true;
  fmGame.WG:= WG;
  fmLetter.WG:= WG;
  fmMarketReport.WG:= WG;
  fmResult.WG:= WG;
  Randomize;
end;

procedure TfmMain.showAbout(Sender: TObject);
begin
  AboutGPL(Application.Title);
end;

procedure TfmMain.teAnim1Timer(Sender: TObject);
begin
  if Random(2) = 1 then begin
    imAnim1a.Visible:= true;
    imAnim1b.Visible:= false;
  end
  else begin
    imAnim1a.Visible:= false;
    imAnim1b.Visible:= true;
  end;
end;

procedure TfmMain.btExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.teAnim2Timer(Sender: TObject);
begin
  if Random(2) = 1 then begin
    imAnim2a.Visible:= true;
    imAnim2b.Visible:= false;
  end
  else begin
    imAnim2a.Visible:= false;
    imAnim2b.Visible:= true;
  end;
end;

procedure TfmMain.teAnim3Timer(Sender: TObject);
begin
  if Random(2) = 1 then begin
    imAnim3a.Visible:= true;
    imAnim3b.Visible:= false;
  end
  else begin
    imAnim3a.Visible:= false;
    imAnim3b.Visible:= true;
  end;
end;

procedure TfmMain.btPlayClick(Sender: TObject);
begin
  Hide;
  fmGame.Show;
end;

procedure TfmMain.btHelpClick(Sender: TObject);
begin
  fmHelp.ShowModal;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  randomize;
  lbMain2.Caption:= IDS_LBMAIN2;
  btPlay.Caption := IDS_PLAY;
  btExit.Caption := IDS_EXIT;
  btHelp.Caption := IDS_HELP;
  WG:= TWidGetGame.Create(12);
  WidgetGame.MsgDesc[WFLNONE] := IDS_WFLNONE;
  WidgetGame.MsgDesc[WFLFIRE] := IDS_WFLFIRE;
  WidgetGame.MsgDesc[WFLTRAN] := IDS_WFLTRAN;
  WidgetGame.MsgDesc[WFLMAJR1]:= IDS_WFLMAJR1;
  WidgetGame.MsgDesc[WFLCSTDW]:= IDS_WFLCSTDW;
  WidgetGame.MsgDesc[WFLPRDUP]:= IDS_WFLPRDUP;
  WidgetGame.MsgDesc[WFLCSTUP]:= IDS_WFLCSTUP;
  WidgetGame.MsgDesc[WFLEMPUP]:= IDS_WFLEMPUP;
  WidgetGame.MsgDesc[WFLEMPDW]:= IDS_WFLEMPDW;
  WidgetGame.MsgDesc[WFLSLLUP]:= IDS_WFLSLLUP;
  WidgetGame.MsgDesc[WFLMAJR2]:= IDS_WFLMAJR2;
  WidgetGame.MsgDesc[WMSTRIKE]:= IDS_WMSTRIKE;
  WidgetGame.MsgDesc[WMNOCASH]:= IDS_WMNOCASH;
  WidgetGame.MsgDesc[WMNOEMP] := IDS_WMNOEMP;
  WidgetGame.MsgDesc[WMBANKRP]:= IDS_WMBANKRP;
end;

procedure TfmMain.Button1Click(Sender: TObject);
begin
  fmResult.ShowModal;
end;

procedure TfmMain.FormHide(Sender: TObject);
begin
  tlTimers.Active:= false;
end;

end.

