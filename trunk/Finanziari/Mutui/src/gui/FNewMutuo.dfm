object fmNewMutuo: TfmNewMutuo
  Left = 200
  Top = 99
  Caption = 'Dati nuovo mutuo'
  ClientHeight = 166
  ClientWidth = 235
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 15
    Width = 82
    Height = 13
    Caption = 'Importo (Capitale)'
  end
  object Label2: TLabel
    Left = 10
    Top = 45
    Width = 85
    Height = 13
    Caption = 'Tasso di interesse'
  end
  object Label3: TLabel
    Left = 10
    Top = 75
    Width = 82
    Height = 13
    Caption = 'Numero di periodi'
  end
  object Label5: TLabel
    Left = 10
    Top = 105
    Width = 85
    Height = 13
    Caption = 'Periodi in un anno'
  end
  object iPrincipal: TCurrencyEdit
    Left = 105
    Top = 10
    Width = 121
    Height = 21
    Margins.Left = 1
    Margins.Top = 1
    AutoSize = False
    FormatOnEditing = True
    TabOrder = 0
    Value = 10000.000000000000000000
  end
  object iInterest: TRxSpinEdit
    Left = 105
    Top = 40
    Width = 121
    Height = 21
    Alignment = taRightJustify
    MaxValue = 999.990000000000000000
    ValueType = vtFloat
    Value = 5.000000000000000000
    TabOrder = 1
  end
  object iPeriods: TRxSpinEdit
    Left = 105
    Top = 70
    Width = 121
    Height = 21
    Alignment = taRightJustify
    MaxValue = 9999.000000000000000000
    MinValue = 1.000000000000000000
    Value = 10.000000000000000000
    TabOrder = 2
  end
  object BitBtn1: TBitBtn
    Left = 20
    Top = 135
    Width = 89
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 125
    Top = 135
    Width = 89
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object iPerInYear: TRxSpinEdit
    Left = 105
    Top = 100
    Width = 121
    Height = 21
    Alignment = taRightJustify
    MaxValue = 9999.000000000000000000
    MinValue = 1.000000000000000000
    Value = 1.000000000000000000
    TabOrder = 5
  end
end
