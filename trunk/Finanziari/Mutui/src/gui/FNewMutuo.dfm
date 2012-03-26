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
  object iPrincipal: TJvValidateEdit
    Left = 105
    Top = 10
    Width = 121
    Height = 21
    Margins.Left = 1
    Margins.Top = 1
    AutoSize = False
    CriticalPoints.MaxValueIncluded = False
    CriticalPoints.MinValueIncluded = False
    EditText = '10000'
    TabOrder = 0
  end
  object iInterest: TJvSpinEdit
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
  object iPeriods: TJvSpinEdit
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
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 3
  end
  object BitBtn2: TBitBtn
    Left = 125
    Top = 135
    Width = 89
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 4
  end
  object iPerInYear: TJvSpinEdit
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
