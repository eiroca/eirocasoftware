object fmMarketReport: TfmMarketReport
  Left = 200
  Top = 99
  BorderStyle = bsDialog
  Caption = 'x'
  ClientHeight = 245
  ClientWidth = 373
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
  object lbMarRepTit: TJvLabel
    Left = 0
    Top = 0
    Width = 373
    Height = 23
    Align = alTop
    Alignment = taCenter
    Caption = 'x'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    ShadowColor = clAqua
    Transparent = True
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -21
    HotTrackFont.Name = 'Times New Roman'
    HotTrackFont.Style = []
    ExplicitWidth = 12
  end
  object Image1: TImage
    Left = 340
    Top = 5
    Width = 32
    Height = 32
    AutoSize = True
    Picture.Data = {
      055449636F6E0000010001002020100000000000E80200001600000028000000
      2000000040000000010004000000000080020000000000000000000000000000
      00000000000000000000BF0000BF000000BFBF00BF000000BF00BF00BFBF0000
      C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
      FFFFFF0000000000000000000000000000000000000777777777777777777777
      7777000000077777777777777777777777770000000000777777777777777777
      7000000000007777777777777777777777700000000077707777077770777707
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077707777077770777707
      7770000000007777777777777777777777700000000077777777777777777777
      77700000000000000000000000000000000000000000000000AA00000AA00000
      000000000000000000AA00000AA0000000000000000000000000000000000000
      0000000000000000000000000000000000000000008888888888888888888888
      8888800000888888888888888888888888888000000000000000000000000000
      00000000C0000007C0000007C0000007C0000007E000000FE000000FE000000F
      E000000FE000000FE000000FE000000FE000000FE000000FE000000FE000000F
      E000000FE000000FE000000FE000000FE000000FE000000FE000000FE000000F
      E000000FE000000FE000000FE000000FC0000007800000038000000380000003
      C0000007}
  end
  object lbQtr: TLabel
    Left = 45
    Top = 25
    Width = 5
    Height = 15
    Caption = 'x'
  end
  object Image2: TImage
    Left = 1
    Top = 5
    Width = 32
    Height = 32
    AutoSize = True
    Picture.Data = {
      055449636F6E0000010001002020100000000000E80200001600000028000000
      2000000040000000010004000000000080020000000000000000000000000000
      00000000000000000000BF0000BF000000BFBF00BF000000BF00BF00BFBF0000
      C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
      FFFFFF0000000000000000000000000000000000000777777777777777777777
      7777000000077777777777777777777777770000000000777777777777777777
      7000000000007777777777777777777777700000000077707777077770777707
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077770777707777077770
      7770000000007777077770777707777077700000000077707777077770777707
      7770000000007777777777777777777777700000000077777777777777777777
      77700000000000000000000000000000000000000000000000AA00000AA00000
      000000000000000000AA00000AA0000000000000000000000000000000000000
      0000000000000000000000000000000000000000008888888888888888888888
      8888800000888888888888888888888888888000000000000000000000000000
      00000000C0000007C0000007C0000007C0000007E000000FE000000FE000000F
      E000000FE000000FE000000FE000000FE000000FE000000FE000000FE000000F
      E000000FE000000FE000000FE000000FE000000FE000000FE000000FE000000F
      E000000FE000000FE000000FE000000FC0000007800000038000000380000003
      C0000007}
  end
  object gbPI: TGroupBox
    Left = 0
    Top = 40
    Width = 121
    Height = 161
    Caption = 'x'
    TabOrder = 0
    object lbPrice: TLabel
      Left = 10
      Top = 15
      Width = 50
      Height = 15
      AutoSize = False
      Caption = 'x'
    end
    object lbQty1: TLabel
      Left = 65
      Top = 15
      Width = 50
      Height = 15
      AutoSize = False
      Caption = 'x'
    end
    object lbPC: TLabel
      Left = 10
      Top = 35
      Width = 30
      Height = 111
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'x'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
    end
    object lbPI: TLabel
      Left = 70
      Top = 35
      Width = 30
      Height = 111
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'x'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
    end
  end
  object gbRI: TGroupBox
    Left = 250
    Top = 40
    Width = 121
    Height = 111
    Caption = 'x'
    TabOrder = 1
    object lbCst2: TLabel
      Left = 10
      Top = 15
      Width = 50
      Height = 15
      AutoSize = False
      Caption = 'x'
    end
    object lbChange: TLabel
      Left = 65
      Top = 15
      Width = 50
      Height = 15
      AutoSize = False
      Caption = 'x'
    end
    object lbRD: TLabel
      Left = 10
      Top = 35
      Width = 30
      Height = 71
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'x'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
    end
    object lbRI: TLabel
      Left = 65
      Top = 35
      Width = 40
      Height = 71
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'x'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
    end
  end
  object btOk: TBitBtn
    Left = 5
    Top = 210
    Width = 361
    Height = 30
    Caption = 'x'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333300000000
      0EEE333377777777777733330FF00FBFB0EE33337F37733F377733330F0BFB0B
      FB0E33337F73FF73337733330FF000BFBFB033337F377733333733330FFF0BFB
      FBF033337FFF733F333733300000BF0FBFB03FF77777F3733F37000FBFB0F0FB
      0BF077733FF7F7FF7337E0FB00000000BF0077F377777777F377E0BFBFBFBFB0
      F0F077F3333FFFF7F737E0FBFB0000000FF077F3337777777337E0BFBFBFBFB0
      FFF077F3333FFFF73FF7E0FBFB00000F000077FF337777737777E00FBFBFB0FF
      0FF07773FFFFF7337F37003000000FFF0F037737777773337F7333330FFFFFFF
      003333337FFFFFFF773333330000000003333333777777777333}
    ModalResult = 1
    NumGlyphs = 2
    TabOrder = 2
  end
  object gbAI: TGroupBox
    Left = 125
    Top = 40
    Width = 121
    Height = 161
    Caption = 'x'
    TabOrder = 3
    object lbQty2: TLabel
      Left = 65
      Top = 15
      Width = 50
      Height = 15
      AutoSize = False
      Caption = 'x'
    end
    object lbAD: TLabel
      Left = 10
      Top = 35
      Width = 30
      Height = 121
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'x'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
    end
    object lbAI: TLabel
      Left = 70
      Top = 35
      Width = 30
      Height = 121
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'x'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
    end
    object lbCst1: TLabel
      Left = 10
      Top = 15
      Width = 50
      Height = 15
      AutoSize = False
      Caption = 'x'
    end
  end
  object gbPAMix: TGroupBox
    Left = 250
    Top = 155
    Width = 121
    Height = 46
    Caption = 'x'
    TabOrder = 4
    object lbMix1: TLabel
      Left = 10
      Top = 20
      Width = 5
      Height = 15
      Caption = 'x'
    end
    object lbMIx2: TLabel
      Left = 105
      Top = 20
      Width = 5
      Height = 15
      Caption = 'x'
    end
    object slMix: TJvSlider
      Left = 20
      Top = 15
      Width = 85
      Enabled = False
      TabOrder = 0
    end
  end
end
