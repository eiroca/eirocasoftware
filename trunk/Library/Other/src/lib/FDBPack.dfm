object fmDBPack: TfmDBPack
  Left = 278
  Top = 192
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = '(a run-time)'
  ClientHeight = 55
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -21
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 23
  object RxLabel1: TJvLabel
    Left = 0
    Top = 0
    Width = 300
    Height = 42
    Align = alTop
    Alignment = taCenter
    Caption = 'Attendere...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -37
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -37
    HotTrackFont.Name = 'Times New Roman'
    HotTrackFont.Style = []
    ExplicitWidth = 171
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 25
    Top = 15
  end
end
