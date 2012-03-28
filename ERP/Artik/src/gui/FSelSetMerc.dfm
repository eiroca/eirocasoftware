object fmSelSetMer: TfmSelSetMer
  Left = 200
  Top = 99
  Caption = 'Seleziona il settere merceologico'
  ClientHeight = 227
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbSetMer: TLabel
    Left = 59
    Top = 175
    Width = 42
    Height = 13
    Caption = 'lbSetMer'
  end
  object lbCodAlf: TLabel
    Left = 15
    Top = 175
    Width = 39
    Height = 13
    Caption = 'lbCodAlf'
  end
  object btOk: TBitBtn
    Left = 27
    Top = 195
    Width = 100
    Height = 25
    Caption = 'Seleziona'
    Kind = bkOK
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 0
  end
  object btCancel: TBitBtn
    Left = 147
    Top = 195
    Width = 100
    Height = 25
    Caption = 'Annulla'
    Kind = bkCancel
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 1
  end
  object olSettori: TOutline
    Left = 5
    Top = 5
    Width = 266
    Height = 166
    OutlineStyle = osPlusMinusText
    Options = [ooDrawTreeRoot, ooDrawFocusRect, ooStretchBitmaps]
    ItemHeight = 13
    TabOrder = 2
    OnClick = olSettoriClick
    OnEnter = olSettoriEnter
    OnDblClick = olSettoriDblClick
    OnKeyPress = olSettoriKeyPress
    ItemSeparator = '\'
  end
end
