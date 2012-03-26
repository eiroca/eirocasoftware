object fmLetter: TfmLetter
  Left = 204
  Top = 130
  BorderStyle = bsDialog
  Caption = 'x'
  ClientHeight = 354
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object lbSign: TLabel
    Left = 0
    Top = 116
    Width = 460
    Height = 15
    Align = alTop
    Alignment = taRightJustify
    Caption = 'x'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsItalic]
    ParentFont = False
    ExplicitLeft = 454
    ExplicitWidth = 6
  end
  object lbLetTit: TJvLabel
    Left = 0
    Top = 0
    Width = 460
    Height = 56
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'x'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -29
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    ShadowColor = 14811135
    Transparent = True
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -29
    HotTrackFont.Name = 'Times New Roman'
    HotTrackFont.Style = []
  end
  object lbLetter4: TLabel
    Left = 0
    Top = 101
    Width = 460
    Height = 15
    Align = alTop
    Caption = 'x'
    WordWrap = True
    ExplicitWidth = 5
  end
  object lbLetter1: TLabel
    Left = 0
    Top = 56
    Width = 460
    Height = 15
    Align = alTop
    Caption = 'x'
    WordWrap = True
    ExplicitWidth = 5
  end
  object lbLetter2: TLabel
    Left = 0
    Top = 71
    Width = 460
    Height = 15
    Align = alTop
    Caption = 'x'
    WordWrap = True
    ExplicitWidth = 5
  end
  object lbLetter3: TLabel
    Left = 0
    Top = 86
    Width = 460
    Height = 15
    Align = alTop
    Caption = 'x'
    WordWrap = True
    ExplicitWidth = 5
  end
  object btOk: TBitBtn
    Left = 5
    Top = 320
    Width = 446
    Height = 30
    Caption = 'x'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033BBBBBBBBBB
      BB33337777777777777F33BB00BBBBBBBB33337F77333333F37F33BB0BBBBBB0
      BB33337F73F33337FF7F33BBB0BBBB000B33337F37FF3377737F33BBB00BB00B
      BB33337F377F3773337F33BBBB0B00BBBB33337F337F7733337F33BBBB000BBB
      BB33337F33777F33337F33EEEE000EEEEE33337F3F777FFF337F33EE0E80000E
      EE33337F73F77773337F33EEE0800EEEEE33337F37377F33337F33EEEE000EEE
      EE33337F33777F33337F33EEEEE00EEEEE33337F33377FF3337F33EEEEEE00EE
      EE33337F333377F3337F33EEEEEE00EEEE33337F33337733337F33EEEEEEEEEE
      EE33337FFFFFFFFFFF7F33EEEEEEEEEEEE333377777777777773}
    NumGlyphs = 2
    TabOrder = 0
    OnClick = btOkClick
  end
end
