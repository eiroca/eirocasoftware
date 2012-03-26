object fmResult: TfmResult
  Left = 143
  Top = 109
  BorderStyle = bsDialog
  Caption = 'x'
  ClientHeight = 219
  ClientWidth = 522
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
  object btOk: TBitBtn
    Left = 210
    Top = 185
    Width = 90
    Height = 30
    Caption = 'x'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      555555555555555555555555555555555555555555FF55555555555559055555
      55555555577FF5555555555599905555555555557777F5555555555599905555
      555555557777FF5555555559999905555555555777777F555555559999990555
      5555557777777FF5555557990599905555555777757777F55555790555599055
      55557775555777FF5555555555599905555555555557777F5555555555559905
      555555555555777FF5555555555559905555555555555777FF55555555555579
      05555555555555777FF5555555555557905555555555555777FF555555555555
      5990555555555555577755555555555555555555555555555555}
    ModalResult = 1
    NumGlyphs = 2
    TabOrder = 0
  end
  object gbOper: TGroupBox
    Left = 0
    Top = 61
    Width = 260
    Height = 115
    Caption = 'x'
    TabOrder = 1
    object meOper: TMemo
      Left = 7
      Top = 17
      Width = 245
      Height = 91
      BorderStyle = bsNone
      Color = clBtnFace
      Ctl3D = False
      Lines.Strings = (
        'x')
      ParentCtl3D = False
      TabOrder = 0
    end
  end
  object gbComp: TGroupBox
    Left = 262
    Top = 61
    Width = 260
    Height = 115
    Caption = 'x'
    TabOrder = 2
    object meComp: TMemo
      Left = 7
      Top = 17
      Width = 245
      Height = 91
      BorderStyle = bsNone
      Color = clBtnFace
      Ctl3D = False
      Lines.Strings = (
        'x')
      ParentCtl3D = False
      TabOrder = 0
    end
  end
  object gbFlash: TGroupBox
    Left = 0
    Top = 0
    Width = 522
    Height = 61
    Align = alTop
    Caption = 'x'
    TabOrder = 3
    object lbFlash: TLabel
      Left = 7
      Top = 17
      Width = 508
      Height = 39
      AutoSize = False
      Caption = 'x'
      WordWrap = True
    end
  end
end
