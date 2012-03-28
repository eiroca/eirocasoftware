object fmValorizzazione: TfmValorizzazione
  Left = 200
  Top = 99
  BorderStyle = bsDialog
  Caption = 'Valorizzazioni dati'
  ClientHeight = 247
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbInfo: TLabel
    Left = 11
    Top = 50
    Width = 190
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Valori dal 99/99/999 al '
  end
  object lbTotOrdi: TLabel
    Left = 10
    Top = 5
    Width = 43
    Height = 13
    Caption = 'lbTotOrdi'
  end
  object lbTotOPar: TLabel
    Left = 10
    Top = 25
    Width = 48
    Height = 13
    Caption = 'lbTotOPar'
  end
  object lbDataPrezF: TLabel
    Left = 325
    Top = 95
    Width = 58
    Height = 13
    Caption = '99/99/9999'
  end
  object lbDataPrezI: TLabel
    Left = 325
    Top = 115
    Width = 58
    Height = 13
    Caption = '99/99/9999'
  end
  object Label1: TLabel
    Left = 330
    Top = 75
    Width = 45
    Height = 13
    Caption = 'Prezzi del'
  end
  object lcDataGiac: TJvDBLookupCombo
    Left = 205
    Top = 46
    Width = 111
    Height = 21
    ListStyle = lsDelimited
    LookupField = 'DATA'
    LookupDisplay = 'DATA'
    LookupSource = dsGiacDate
    TabOrder = 0
    OnChange = lcDataGiacChange
    OnCloseUp = lcDataGiacChange
  end
  object sgValo: TXStrGrid
    Left = 10
    Top = 70
    Width = 311
    Height = 166
    ColCount = 3
    Ctl3D = True
    DefaultColWidth = 100
    DefaultRowHeight = 19
    RowCount = 9
    ParentCtl3D = False
    ScrollBars = ssNone
    TabOrder = 1
    HCol.Strings = (
      ''
      'KgC'
      'Valore')
    HRow.Strings = (
      'Giacenza attuale'
      'Giacenza precedente'
      'Totale carichi'
      'Totale consegne patentini'
      'Vendite'
      ''
      'Totale ordini'
      'Totale ordini patentini')
    OnGetAlignment = sgValoGetAlignment
    Grid3D = False
    ColWidths = (
      135
      65
      100)
    RowHeights = (
      19
      19
      19
      19
      19
      19
      1
      19
      19)
  end
  object tbGiacDate: TTable
    DatabaseName = 'DB'
    TableName = 'GIACLIST.DB'
    Left = 230
    Top = 165
    object tbGiacDatePGIA: TIntegerField
      FieldName = 'PGIA'
    end
    object tbGiacDateDATA: TDateField
      FieldName = 'DATA'
      Required = True
    end
    object tbGiacDateDATAPREZ: TDateField
      FieldName = 'DATAPREZ'
      Required = True
    end
    object tbGiacDateKGC: TFloatField
      FieldName = 'KGC'
      DisplayFormat = '0.00'
    end
    object tbGiacDateVAL: TCurrencyField
      FieldName = 'VAL'
    end
  end
  object dsGiacDate: TDataSource
    DataSet = tbGiacDate
    Left = 250
    Top = 165
  end
end
