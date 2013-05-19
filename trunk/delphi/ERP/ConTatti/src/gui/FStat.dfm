object fmStatistiche: TfmStatistiche
  Left = 265
  Top = 132
  Caption = 'Informazioni statistiche contatti'
  ClientHeight = 266
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 427
    Height = 56
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 10
      Width = 110
      Height = 13
      Caption = 'Informazione sulle righe'
    end
    object Label2: TLabel
      Left = 10
      Top = 35
      Width = 121
      Height = 13
      Caption = 'Informazioni sulle colonne'
    end
    object cbRow: TComboBox
      Left = 140
      Top = 5
      Width = 120
      Height = 21
      Hint = 'Variabile da utilizzare come '#13#10'raggruppamento sulle righe'
      Style = csDropDownList
      TabOrder = 0
      Items.Strings = (
        'Denominazione'
        'Tipo'
        'Classe'
        'Settore'
        '')
    end
    object cbCol: TComboBox
      Left = 140
      Top = 30
      Width = 120
      Height = 21
      Hint = 'Variabile da utilizzare come '#13#10'raggruppamento sulle righe'
      Style = csDropDownList
      TabOrder = 1
    end
    object BitBtn1: TBitBtn
      Left = 270
      Top = 5
      Width = 150
      Height = 23
      Hint = 'Effettua l'#39'indagine statistica'
      Caption = 'Esegui indagine'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333FFFFFFFFFFFFF3344444444444443337777777777777F334CCCCCCCCCC
        C43337777777777777F33444881B188444333777F3737337773333308881FF70
        33333337F3373337F3333330888BF770333333373F33F337333333330881F703
        3333333373F73F7333333333308B703333333333373F77333333333333080333
        3333333333777FF333333333301F103333333333377777FF3333333301B1F103
        333333337737777FF3333330881BFB7033333337F3737F77F333333088881F70
        333333F7F3337777FFF334448888888444333777FFFFFFF777F334CCCCCCCCCC
        C43337777777777777F334444444444444333777777777777733}
      Margin = 10
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 2
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 270
      Top = 30
      Width = 150
      Height = 23
      Hint = 
        'Esposta i risulati ottenuti al fine '#13#10'di rielaborarli con altri ' +
        'programmi'
      Caption = 'Salva i risultati'
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
      Margin = 10
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 3
      OnClick = BitBtn2Click
    end
  end
  object ctContat: TcwXTab
    Left = 0
    Top = 56
    Width = 427
    Height = 210
    Hint = 'Risultati dell'#39'elaborazione'
    Align = alClient
    DefaultColWidth = 80
    DefaultRowHeight = 20
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSizing, goColSizing, goRowMoving, goColMoving]
    TabOrder = 1
    Crosstab.RowField = 'Classe'
    Crosstab.ColumnField = 'Settore'
    Crosstab.SummaryField1 = 'CodCon'
    Crosstab.SumField1MathOp = count
    Crosstab.SumField2MathOp = sum
    Crosstab.SumField3MathOp = sum
    Crosstab.SumField1Format = integer_format
    Crosstab.SumField2Format = currency_format
    Crosstab.SumField3Format = currency_format
    Crosstab.Table = tbContat
    Table = tbContat
    AggRowsCols = True
    AutoResize = True
    EmptyCellChar = ecBlank
    RowHeights = (
      20
      20
      20
      20
      20)
  end
  object tbContat: TTable
    DatabaseName = 'DB'
    TableName = 'CONTAT.DB'
    Left = 145
    Top = 125
    object tbContatCodCon: TIntegerField
      FieldName = 'CodCon'
    end
    object tbContatTipo: TIntegerField
      FieldName = 'Tipo'
    end
    object tbContatNome_Tit: TStringField
      FieldName = 'Nome_Tit'
      Size = 10
    end
    object tbContatNome_Pre1: TStringField
      FieldName = 'Nome_Pre1'
    end
    object tbContatNome_Pre2: TStringField
      FieldName = 'Nome_Pre2'
      Size = 40
    end
    object tbContatNome_Main: TStringField
      FieldName = 'Nome_Main'
      Size = 40
    end
    object tbContatNome_Suf: TStringField
      FieldName = 'Nome_Suf'
      Size = 10
    end
    object tbContatClasse: TStringField
      FieldName = 'Classe'
      Size = 15
    end
    object tbContatSettore: TStringField
      FieldName = 'Settore'
      Size = 35
    end
    object tbContatNote: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
      Size = 100
    end
  end
  object fsStat: TJvFormStorage
    AppStorage = fmMain.apStorage
    AppStoragePath = '%FORM_NAME%\'
    StoredValues = <>
    Left = 60
    Top = 125
  end
  object sdExport: TSaveDialog
    DefaultExt = 'TXT'
    Filter = 
      'File di testo|*.txt|Tabella Paradox|*.db|Tabella DBase|*.dbf|Tut' +
      'ti i file|*.*'
    Options = [ofOverwritePrompt, ofPathMustExist]
    Left = 230
    Top = 115
  end
end
