object fmGame: TfmGame
  Left = 247
  Top = 156
  BorderStyle = bsDialog
  Caption = 'x'
  ClientHeight = 247
  ClientWidth = 493
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object gbOpPe: TGroupBox
    Left = 0
    Top = 0
    Width = 493
    Height = 56
    Align = alTop
    Caption = 'x'
    TabOrder = 0
    object lbHSal: TLabel
      Left = 385
      Top = 15
      Width = 50
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'x'
    end
    object lbHPro: TLabel
      Left = 435
      Top = 15
      Width = 50
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'x'
    end
    object lbHInf: TLabel
      Left = 335
      Top = 15
      Width = 50
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'x'
    end
    object lbHPrd: TLabel
      Left = 265
      Top = 15
      Width = 70
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'x'
    end
    object lbHCst: TLabel
      Left = 215
      Top = 15
      Width = 50
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'x'
    end
    object lbHCAS: TLabel
      Left = 155
      Top = 15
      Width = 60
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'x'
    end
    object lbHEmp: TLabel
      Left = 45
      Top = 15
      Width = 45
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'x'
    end
    object lbHQtr: TLabel
      Left = 5
      Top = 15
      Width = 40
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'x'
    end
    object lbQtr: TLabel
      Left = 5
      Top = 30
      Width = 40
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbQtr'
    end
    object lbEmpl: TLabel
      Left = 45
      Top = 30
      Width = 45
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbEmpl'
    end
    object lbHInv: TLabel
      Left = 90
      Top = 15
      Width = 60
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'x'
    end
    object lbIvty: TLabel
      Left = 90
      Top = 30
      Width = 60
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbIvty'
    end
    object lbCash: TLabel
      Left = 155
      Top = 30
      Width = 60
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbCash'
    end
    object lbUCst: TLabel
      Left = 215
      Top = 30
      Width = 50
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbUCst'
    end
    object lbSlry: TLabel
      Left = 385
      Top = 30
      Width = 50
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbSlry'
    end
    object lbCPft: TLabel
      Left = 435
      Top = 30
      Width = 50
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbCPft'
    end
    object lbPrdn: TLabel
      Left = 265
      Top = 30
      Width = 70
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbPrdn'
    end
    object lbFltn: TLabel
      Left = 335
      Top = 30
      Width = 50
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbFltn'
    end
  end
  object gbDECI: TGroupBox
    Left = 0
    Top = 56
    Width = 266
    Height = 191
    Align = alLeft
    Caption = 'x'
    TabOrder = 1
    object lbRes: TLabel
      Left = 180
      Top = 63
      Width = 5
      Height = 15
      Caption = 'x'
    end
    object lbPro: TLabel
      Left = 95
      Top = 18
      Width = 5
      Height = 15
      Caption = 'x'
    end
    object lbAdv: TLabel
      Left = 95
      Top = 63
      Width = 5
      Height = 15
      Caption = 'x'
    end
    object lbPri: TLabel
      Left = 10
      Top = 18
      Width = 5
      Height = 15
      Caption = 'x'
    end
    object lbPay: TLabel
      Left = 10
      Top = 63
      Width = 5
      Height = 15
      Caption = 'x'
    end
    object lbMarRep: TLabel
      Left = 5
      Top = 118
      Width = 5
      Height = 15
      Caption = 'x'
    end
    object lbMarRepCst: TLabel
      Left = 95
      Top = 118
      Width = 71
      Height = 15
      Caption = 'lbMarRepCst'
    end
    object lbErrMsg: TLabel
      Left = 5
      Top = 140
      Width = 161
      Height = 46
      AutoSize = False
      Caption = 'lbErrMsg'
      WordWrap = True
    end
    object btMarRep: TBitBtn
      Left = 170
      Top = 108
      Width = 90
      Height = 30
      Caption = 'x'
      TabOrder = 0
      OnClick = btMarRepClick
    end
    object ilPric: TJvSpinEdit
      Left = 10
      Top = 35
      Width = 76
      Height = 23
      Increment = 0.500000000000000000
      MaxValue = 30.000000000000000000
      MinValue = 0.500000000000000000
      ValueType = vtFloat
      Value = 0.500000000000000000
      TabOrder = 1
    end
    object ilProd: TJvSpinEdit
      Left = 95
      Top = 35
      Width = 76
      Height = 23
      Decimal = 0
      Increment = 10.000000000000000000
      MaxValue = 10000.000000000000000000
      TabOrder = 2
    end
    object ilPayr: TJvSpinEdit
      Left = 6
      Top = 80
      Width = 76
      Height = 23
      Decimal = 0
      Increment = 25.000000000000000000
      MaxValue = 100000.000000000000000000
      TabOrder = 3
    end
    object ilAdve: TJvSpinEdit
      Left = 88
      Top = 80
      Width = 76
      Height = 23
      Decimal = 0
      Increment = 25.000000000000000000
      MaxValue = 100000.000000000000000000
      TabOrder = 4
    end
    object ilReDe: TJvSpinEdit
      Left = 180
      Top = 80
      Width = 76
      Height = 23
      Decimal = 0
      Increment = 25.000000000000000000
      MaxValue = 100000.000000000000000000
      TabOrder = 5
    end
    object btExecute: TBitBtn
      Left = 170
      Top = 140
      Width = 90
      Height = 46
      Caption = 'x'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555FFFFF555555555544C4C5555555555F777775FF5555554C444C444
        5555555775FF55775F55554C4334444445555575577F55557FF554C4C334C4C4
        335557F5577FF55577F554CCC3334444335557555777F555775FCCCCC333CCC4
        C4457F55F777F555557F4CC33333CCC444C57F577777F5F5557FC4333333C3C4
        CCC57F777777F7FF557F4CC33333333C4C457F577777777F557FCCC33CC4333C
        C4C575F7755F777FF5755CCCCC3333334C5557F5FF777777F7F554C333333333
        CC55575777777777F755553333CC3C33C555557777557577755555533CC4C4CC
        5555555775FFFF77555555555C4CCC5555555555577777555555}
      Layout = blGlyphTop
      NumGlyphs = 2
      TabOrder = 6
      OnClick = btExecuteClick
    end
  end
  object gbOpRe: TGroupBox
    Left = 266
    Top = 56
    Width = 227
    Height = 191
    Align = alClient
    Caption = 'x'
    TabOrder = 2
    object lbRCas: TLabel
      Left = 10
      Top = 160
      Width = 7
      Height = 19
      Caption = 'x'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object lbRPro: TLabel
      Left = 10
      Top = 135
      Width = 7
      Height = 19
      Caption = 'x'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object lbRRes: TLabel
      Left = 10
      Top = 95
      Width = 5
      Height = 15
      Caption = 'x'
    end
    object lbRAdv: TLabel
      Left = 10
      Top = 75
      Width = 5
      Height = 15
      Caption = 'x'
    end
    object lbRPay: TLabel
      Left = 10
      Top = 55
      Width = 5
      Height = 15
      Caption = 'x'
    end
    object lbRCst: TLabel
      Left = 10
      Top = 35
      Width = 5
      Height = 15
      Caption = 'x'
    end
    object lbRRev: TLabel
      Left = 10
      Top = 15
      Width = 5
      Height = 15
      Caption = 'x'
    end
    object Bevel1: TBevel
      Left = 115
      Top = 120
      Width = 105
      Height = 11
      Shape = bsTopLine
    end
    object lbMCst: TLabel
      Left = 125
      Top = 35
      Width = 85
      Height = 15
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lbMCst'
    end
    object lbPayr: TLabel
      Left = 125
      Top = 55
      Width = 85
      Height = 15
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lbPayr'
    end
    object lbRevn: TLabel
      Left = 125
      Top = 15
      Width = 85
      Height = 15
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lbRevn'
    end
    object lbAdvr: TLabel
      Left = 125
      Top = 75
      Width = 85
      Height = 15
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lbAdvr'
    end
    object lbReDe: TLabel
      Left = 125
      Top = 95
      Width = 85
      Height = 15
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lbReDe'
    end
    object lbPrft: TLabel
      Left = 125
      Top = 135
      Width = 85
      Height = 19
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lbPrft'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object lbCsh2: TLabel
      Left = 125
      Top = 160
      Width = 85
      Height = 19
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lbCsh2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 275
    Top = 170
  end
end
