object fmGetUnusedCode: TfmGetUnusedCode
  Left = 245
  Top = 123
  Caption = 'Scegli codice'
  ClientHeight = 63
  ClientWidth = 190
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
  object Label1: TLabel
    Left = 5
    Top = 15
    Width = 33
    Height = 13
    Caption = 'Lettera'
  end
  object lbErr: TLabel
    Left = 5
    Top = 45
    Width = 21
    Height = 13
    Caption = 'lbErr'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object iCode: TEdit
    Left = 55
    Top = 10
    Width = 31
    Height = 21
    MaxLength = 1
    TabOrder = 0
    Text = 'iCode'
    OnChange = iCodeChange
    OnKeyPress = iCodeKeyPress
  end
  object btOk: TBitBtn
    Left = 105
    Top = 5
    Width = 75
    Height = 25
    Caption = 'Ok'
    Kind = bkOK
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 1
    OnClick = btOkClick
  end
  object btCancel: TBitBtn
    Left = 105
    Top = 35
    Width = 75
    Height = 25
    Caption = 'Annulla'
    Kind = bkCancel
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 2
  end
end
