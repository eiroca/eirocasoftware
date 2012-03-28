object fmStatCalc: TfmStatCalc
  Left = 212
  Top = 144
  ActiveControl = OKBtn
  BorderStyle = bsDialog
  Caption = 'Calcola statistiche sui tabacchi'
  ClientHeight = 214
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TBitBtn
    Left = 130
    Top = 180
    Width = 77
    Height = 27
    Caption = '&Calcola'
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
    Margin = 4
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 0
    OnClick = OKBtnClick
    IsControl = True
  end
  object btCancel: TBitBtn
    Left = 259
    Top = 180
    Width = 77
    Height = 27
    Caption = '&Annulla'
    Kind = bkCancel
    Margin = 4
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 1
    IsControl = True
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 5
    Width = 456
    Height = 166
    Caption = 'Calcoli statistici'
    TabOrder = 2
    object gProgBar: TGauge
      Left = 95
      Top = 20
      Width = 350
      Height = 25
      ForeColor = clBlue
      Progress = 0
    end
    object Label1: TLabel
      Left = 10
      Top = 25
      Width = 71
      Height = 13
      Caption = 'Barra Progressi'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object meMsg: TMemo
      Left = 2
      Top = 48
      Width = 452
      Height = 116
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'meMsg')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object tbTaba: TTable
    DatabaseName = 'DB'
    TableName = 'TABACCHI.DB'
    Left = 15
    Top = 75
    object tbTabaCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbTabaDESC: TStringField
      FieldName = 'DESC'
      Required = True
      Size = 30
    end
    object tbTabaMULI: TSmallintField
      FieldName = 'MULI'
    end
    object tbTabaATTV: TBooleanField
      FieldName = 'ATTV'
      Required = True
    end
  end
  object tbMTaba: TTable
    DatabaseName = 'DB'
    TableName = 'TABASTAT.DB'
    Left = 50
    Top = 75
    object tbMTabaCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbMTabaMEDA: TFloatField
      FieldName = 'MEDA'
    end
    object tbMTabaMAXA: TFloatField
      FieldName = 'MAXA'
    end
    object tbMTabaMED5: TFloatField
      FieldName = 'MED5'
    end
    object tbMTabaMAX5: TFloatField
      FieldName = 'MAX5'
    end
    object tbMTabaMED0: TFloatField
      FieldName = 'MED0'
    end
    object tbMTabaMAX0: TFloatField
      FieldName = 'MAX0'
    end
  end
end
