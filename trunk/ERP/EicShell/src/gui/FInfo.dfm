object fmInfo: TfmInfo
  Left = 238
  Top = 105
  BorderStyle = bsDialog
  Caption = 'Informazioni'
  ClientHeight = 93
  ClientWidth = 284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 20
    Width = 86
    Height = 13
    Caption = 'Archivio di Default'
  end
  object BitBtn1: TBitBtn
    Left = 140
    Top = 50
    Width = 90
    Height = 27
    Hint = 'Annulla gli eventuali cambiamenti effettuati'
    Caption = 'Annulla'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 0
  end
  object btOk: TBitBtn
    Left = 45
    Top = 50
    Width = 90
    Height = 27
    Hint = 'Memorizza le preferenze'
    Caption = '&Ok'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
    OnClick = btOkClick
  end
  object iDefaultDB: TEdit
    Left = 115
    Top = 15
    Width = 161
    Height = 21
    ReadOnly = True
    TabOrder = 2
    Text = 'iDefaultDB'
  end
end
