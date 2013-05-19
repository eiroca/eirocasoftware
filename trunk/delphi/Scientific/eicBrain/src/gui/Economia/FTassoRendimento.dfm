object fmTassoRendimento: TfmTassoRendimento
  Left = 0
  Top = 0
  Caption = 'Tasso di interesse annuale di un prestito'
  ClientHeight = 144
  ClientWidth = 357
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 119
    Width = 176
    Height = 13
    Caption = 'Tasso di interesse del prestito (%) ='
  end
  object lOutput: TLabel
    Left = 190
    Top = 116
    Width = 6
    Height = 13
    Caption = '?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object iPV: TLabeledEdit
    Left = 192
    Top = 8
    Width = 57
    Height = 21
    EditLabel.Width = 83
    EditLabel.Height = 13
    EditLabel.Caption = 'Capitale prestato'
    LabelPosition = lpLeft
    TabOrder = 0
    Text = '100'
  end
  object iPeriodi: TLabeledEdit
    Left = 192
    Top = 35
    Width = 57
    Height = 21
    EditLabel.Width = 110
    EditLabel.Height = 13
    EditLabel.Caption = 'Numero dei pagamenti '
    LabelPosition = lpLeft
    TabOrder = 1
    Text = '10'
  end
  object iPayment: TLabeledEdit
    Left = 192
    Top = 62
    Width = 57
    Height = 21
    EditLabel.Width = 147
    EditLabel.Height = 13
    EditLabel.Caption = 'Ammontare pagamenti regolari'
    LabelPosition = lpLeft
    TabOrder = 2
    Text = '11'
  end
  object btCancel: TBitBtn
    Left = 268
    Top = 39
    Width = 75
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 5
  end
  object btCalc: TBitBtn
    Left = 268
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Calcola'
    Default = True
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
    TabOrder = 4
    OnClick = btCalcClick
  end
  object iFV: TLabeledEdit
    Left = 192
    Top = 89
    Width = 57
    Height = 21
    EditLabel.Width = 125
    EditLabel.Height = 13
    EditLabel.Caption = 'Valore residuo del prestito'
    LabelPosition = lpLeft
    TabOrder = 3
    Text = '0'
  end
end
