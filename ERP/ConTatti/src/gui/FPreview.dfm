object fmPreview: TfmPreview
  Left = 200
  Top = 99
  Caption = 'fmPreview'
  ClientHeight = 266
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sbMain: TScrollBox
    Left = 0
    Top = 30
    Width = 427
    Height = 236
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
  end
  object pnMP: TPanel
    Left = 0
    Top = 0
    Width = 427
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object MP: TMediaPlayer
      Left = 0
      Top = 0
      Width = -7
      Height = 30
      ColoredButtons = [btPlay, btPause, btStop, btNext, btPrev, btStep, btBack, btEject]
      EnabledButtons = [btPlay, btPause, btStop, btNext, btPrev, btStep, btBack, btEject]
      VisibleButtons = [btPlay, btPause, btStop, btNext, btPrev, btStep, btBack, btEject]
      TabOrder = 0
    end
  end
end
