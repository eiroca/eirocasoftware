object fmStampaTabacchi: TfmStampaTabacchi
  Left = 241
  Top = 218
  BorderStyle = bsDialog
  Caption = 'Stampa dati tabacchi'
  ClientHeight = 121
  ClientWidth = 200
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
  object Label2: TLabel
    Left = 5
    Top = 10
    Width = 49
    Height = 13
    Caption = 'Ordina per'
  end
  object btCancel: TBitBtn
    Left = 103
    Top = 60
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
    Left = 63
    Top = 5
    Width = 110
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    OnChange = cbOrderChange
  end
  object cbSoloAttivi: TCheckBox
    Left = 10
    Top = 35
    Width = 161
    Height = 17
    Caption = 'Stampa solo tabacchi attivi'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object btExport: TBitBtn
    Left = 103
    Top = 90
    Width = 89
    Height = 25
    Caption = '&Esporta'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333303
      333333333333337FF3333333333333903333333333333377FF33333333333399
      03333FFFFFFFFF777FF3000000999999903377777777777777FF0FFFF0999999
      99037F3337777777777F0FFFF099999999907F3FF777777777770F00F0999999
      99037F773777777777730FFFF099999990337F3FF777777777330F00FFFFF099
      03337F773333377773330FFFFFFFF09033337F3FF3FFF77733330F00F0000003
      33337F773777777333330FFFF0FF033333337F3FF7F3733333330F08F0F03333
      33337F7737F7333333330FFFF003333333337FFFF77333333333000000333333
      3333777777333333333333333333333333333333333333333333}
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 5
    OnClick = PrintReport
  end
  object btPrint: TBitBtn
    Left = 8
    Top = 60
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
    OnClick = PrintReport
  end
  object btPreview: TBitBtn
    Left = 8
    Top = 90
    Width = 89
    Height = 25
    Caption = '&Anteprima'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555FFFFFFFFFF5555550000000000555557777777777F5555550FFFFFFFF
      0555557F5FFFF557F5555550F0000FFF0555557F77775557F5555550FFFFFFFF
      0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
      0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
      0555557F5FFF5557F5555550F000FFFF0555557F77755FF7F5555550FFFFF000
      0555557F5FF5777755555550F00FF0F05555557F77557F7555555550FFFFF005
      5555557FFFFF7755555555500000005555555577777775555555555555555555
      5555555555555555555555555555555555555555555555555555}
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 4
    OnClick = PrintReport
  end
  object Report: TeLineReport
    AutoCR = False
    PageHeight = 66
    PageWidth = 132
    HeaderSize = 3
    FooterSize = 0
    ReportName = 'Riepilogo Dati Tabacchi'
    DeviceKind = 'Preview'
    OnPageHeader = ReportPageHeader
    OnSetupDevice = ReportSetupDevice
    Left = 75
    Top = 15
  end
  object tbTaba: TTable
    DatabaseName = 'DB'
    TableName = 'TABACCHI.DB'
    Left = 105
    Top = 15
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
