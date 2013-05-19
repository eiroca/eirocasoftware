object fmStampaModuli: TfmStampaModuli
  Left = 241
  Top = 218
  BorderStyle = bsDialog
  Caption = 'Modulo inventari'
  ClientHeight = 102
  ClientWidth = 195
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
  object Label1: TLabel
    Left = 10
    Top = 15
    Width = 77
    Height = 13
    Caption = 'Numero di copie'
  end
  object Label2: TLabel
    Left = 10
    Top = 40
    Width = 49
    Height = 13
    Caption = 'Ordina per'
  end
  object iCopie: TJvSpinEdit
    Left = 115
    Top = 10
    Width = 61
    Height = 21
    Alignment = taRightJustify
    MaxValue = 99.000000000000000000
    MinValue = 1.000000000000000000
    Value = 1.000000000000000000
    TabOrder = 0
  end
  object btCancel: TBitBtn
    Left = 100
    Top = 65
    Width = 89
    Height = 25
    Caption = 'Annulla'
    Kind = bkCancel
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 3
  end
  object cbOrder: TComboBox
    Left = 68
    Top = 35
    Width = 110
    Height = 21
    Style = csDropDownList
    TabOrder = 1
    OnChange = cbOrderChange
  end
  object btPrint: TBitBtn
    Left = 5
    Top = 65
    Width = 89
    Height = 25
    Caption = '&Stampa'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
      00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
      8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
      8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
      8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
      03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
      03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
      33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
      33333337FFFF7733333333300000033333333337777773333333}
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 2
    OnClick = btPrintClick
  end
  object Report: TeLineReport
    AutoCR = False
    PageHeight = 66
    PageWidth = 132
    HeaderSize = 0
    FooterSize = 0
    ReportName = 'Modulo Inventario'
    DeviceKind = 'Printer'
    OnPageHeader = ReportPageHeader
    OnSetupDevice = ReportSetupDevice
    Left = 82
    Top = 20
  end
  object tbTaba: TTable
    DatabaseName = 'DB'
    TableName = 'TABACCHI.DB'
    Left = 38
    Top = 20
    object tbTabaCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbTabaCODS: TStringField
      FieldName = 'CODS'
      Required = True
      Size = 4
    end
    object tbTabaTIPO: TSmallintField
      FieldName = 'TIPO'
    end
    object tbTabaPROD: TSmallintField
      FieldName = 'PROD'
    end
    object tbTabaCRIT: TSmallintField
      FieldName = 'CRIT'
    end
    object tbTabaDESC: TStringField
      FieldName = 'DESC'
      Required = True
      Size = 30
    end
    object tbTabaATTV: TBooleanField
      FieldName = 'ATTV'
    end
    object tbTabaMULI: TSmallintField
      FieldName = 'MULI'
    end
    object tbTabaQTAS: TSmallintField
      FieldName = 'QTAS'
    end
    object tbTabaQTAC: TSmallintField
      FieldName = 'QTAC'
    end
    object tbTabaQTAM: TSmallintField
      FieldName = 'QTAM'
    end
    object tbTabaDIFR: TSmallintField
      FieldName = 'DIFR'
    end
  end
end
