object fmEditFatFor: TfmEditFatFor
  Left = 200
  Top = 99
  Caption = 'Inserimento fatture fornitori'
  ClientHeight = 396
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object tbFattura: TTabbedNotebook
    Left = 0
    Top = 25
    Width = 526
    Height = 371
    Align = alClient
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clBtnText
    TabFont.Height = -11
    TabFont.Name = 'MS Sans Serif'
    TabFont.Style = []
    TabOrder = 0
    OnChange = tbFatturaChange
    object TTabPage
      Left = 4
      Top = 24
      Caption = '&Dati fattura'
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 518
        Height = 343
        Align = alClient
        TabOrder = 0
        object Label2: TLabel
          Left = 5
          Top = 80
          Width = 58
          Height = 13
          Caption = 'Num. fattura'
        end
        object Label3: TLabel
          Left = 5
          Top = 55
          Width = 47
          Height = 13
          Caption = 'ID Fattura'
        end
        object Label1: TLabel
          Left = 5
          Top = 25
          Width = 49
          Height = 13
          Caption = 'Cod. Forn.'
        end
        object Label6: TLabel
          Left = 5
          Top = 105
          Width = 80
          Height = 13
          Caption = 'Totale Imponibile'
        end
        object Label4: TLabel
          Left = 155
          Top = 55
          Width = 56
          Height = 13
          Caption = 'Data fattura'
        end
        object Label7: TLabel
          Left = 195
          Top = 105
          Width = 50
          Height = 13
          Caption = 'Totale IVA'
        end
        object DBText1: TDBText
          Left = 155
          Top = 25
          Width = 42
          Height = 13
          AutoSize = True
          DataField = 'NomeForn'
          DataSource = dsFatForLs
        end
        object sgTotali: TXStrGrid
          Left = 5
          Top = 133
          Width = 301
          Height = 113
          ColCount = 3
          DefaultColWidth = 80
          DefaultRowHeight = 19
          RowCount = 4
          TabOrder = 6
          HCol.Strings = (
            ''
            'Imponibile'
            'IVA')
          HRow.Strings = (
            'Spese'
            'Articoli'
            'Sconto')
          OnGetAlignment = sgTotaliGetAlignment
          Grid3D = False
        end
        object RxDBCalcEdit2: TJvDBCalcEdit
          Left = 90
          Top = 100
          Width = 100
          Height = 21
          Margins.Left = 1
          Margins.Top = 1
          NumGlyphs = 2
          TabOrder = 4
          DecimalPlacesAlwaysShown = False
          DataField = 'TotaleImp'
          DataSource = dsFatForLs
        end
        object DBDateEdit1: TJvDBDateEdit
          Left = 235
          Top = 50
          Width = 121
          Height = 21
          DataField = 'DataFatt'
          DataSource = dsFatForLs
          NumGlyphs = 2
          TabOrder = 2
        end
        object DBEdit2: TDBEdit
          Left = 70
          Top = 75
          Width = 76
          Height = 21
          DataField = 'NumFatt'
          DataSource = dsFatForLs
          TabOrder = 3
        end
        object DBEdit1: TDBEdit
          Left = 60
          Top = 50
          Width = 86
          Height = 21
          DataField = 'CodFatFor'
          DataSource = dsFatForLs
          TabOrder = 1
        end
        object RxDBComboEdit1: TJvDBComboEdit
          Left = 60
          Top = 20
          Width = 86
          Height = 21
          DataField = 'CodFor'
          DataSource = dsFatForLs
          Glyph.Data = {
            42010000424D4201000000000000760000002800000011000000110000000100
            040000000000CC00000000000000000000001000000010000000000000000000
            BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
            DDDDD0000000DDDDD000DDDDD000D0000000DDDDD070DDDDD070D0000000DDDD
            D0008DDD8000D0000000DDDDD00000000000D0000000D444407000070000D000
            0000D4FFF07000070000D0000000D4F8800000000000D0000000D4FFFF000070
            000DD0000000D4F88F80088F00DDD0000000D4FFFFF00FFF00DDD0000000D4F8
            8F80088F00DDD0000000D4FFFFFFFFFF4DDDD0000000D444444444444DDDD000
            0000D474474474474DDDD0000000D444444444444DDDD0000000DDDDDDDDDDDD
            DDDDD0000000}
          TabOrder = 0
          OnButtonClick = RxDBComboEdit1ButtonClick
        end
        object RxDBCalcEdit3: TJvDBCalcEdit
          Left = 255
          Top = 100
          Width = 100
          Height = 21
          Margins.Left = 1
          Margins.Top = 1
          NumGlyphs = 2
          TabOrder = 5
          DecimalPlacesAlwaysShown = False
          DataField = 'TotaleIVA'
          DataSource = dsFatForLs
        end
        object DBCheckBox1: TDBCheckBox
          Left = 155
          Top = 80
          Width = 111
          Height = 17
          Caption = 'Preventivo/Ordine'
          DataField = 'Preventivo'
          DataSource = dsFatForLs
          TabOrder = 7
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Elenco &spese'
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 518
        Height = 343
        Align = alClient
        DataSource = dsFatForSp
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = '&Voci fattura'
      object dgDati: TJvDBGrid
        Left = 0
        Top = 0
        Width = 518
        Height = 343
        Align = alClient
        DataSource = dsFatForMv
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnColExit = dgDatiColExit
        OnKeyPress = dgDatiKeyPress
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
      end
    end
  end
  object Nav: TRGNavigator
    Left = 0
    Top = 0
    Width = 526
    Height = 25
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh, nbInsert, nbDelete, nbEdit]
    Align = alTop
    TabOrder = 1
    OnClick = NavClick
    ColorScroll = ncBlack
    ColorFunc = ncBlack
    ColorCtrl = ncBlack
    ColorTool = ncBlack
    SizeOfKey = X4
    CaptionExtra1 = 'Extra1'
    CaptionExtra2 = 'Extra2'
    CaptionExtra3 = 'Extra3'
    DataSource = dsFatForLs
  end
  object tbFatForLs: TTable
    AfterPost = tbFatForLsAfterPost
    OnCalcFields = tbFatForLsCalcFields
    DatabaseName = 'DB'
    TableName = 'FATFORLS.DB'
    Left = 50
    Top = 230
    object tbFatForLsCodFatFor: TIntegerField
      FieldName = 'CodFatFor'
    end
    object tbFatForLsCodFor: TIntegerField
      FieldName = 'CodFor'
    end
    object tbFatForLsNumFatt: TStringField
      FieldName = 'NumFatt'
      Size = 15
    end
    object tbFatForLsDataFatt: TDateField
      FieldName = 'DataFatt'
    end
    object tbFatForLsTotaleImp: TCurrencyField
      FieldName = 'TotaleImp'
    end
    object tbFatForLsTotaleIVA: TCurrencyField
      FieldName = 'TotaleIVA'
    end
    object tbFatForLsNomeForn: TStringField
      FieldKind = fkCalculated
      FieldName = 'NomeForn'
      Size = 30
      Calculated = True
    end
    object tbFatForLsPreventivo: TBooleanField
      FieldName = 'Preventivo'
    end
  end
  object tbFatForMv: TTable
    BeforePost = tbFatForMvBeforePost
    OnCalcFields = tbFatForMvCalcFields
    DatabaseName = 'DB'
    IndexFieldNames = 'CodFatFor'
    MasterFields = 'CodFatFor'
    MasterSource = dsFatForLs
    TableName = 'FATFORMV.DB'
    Left = 80
    Top = 230
    object tbFatForMvCodMov: TIntegerField
      FieldName = 'CodMov'
      Visible = False
    end
    object tbFatForMvCodFatFor: TIntegerField
      FieldName = 'CodFatFor'
      Visible = False
    end
    object tbFatForMvCodAlf: TStringField
      DisplayLabel = 'Set. '
      FieldName = 'CodAlf'
      Size = 3
    end
    object tbFatForMvCodNum: TIntegerField
      DisplayLabel = 'Cod.'
      DisplayWidth = 4
      FieldName = 'CodNum'
    end
    object tbFatForMvDesc: TStringField
      DisplayLabel = 'Descrizione articolo'
      FieldKind = fkCalculated
      FieldName = 'Desc'
      Size = 30
      Calculated = True
    end
    object tbFatForMvQta: TFloatField
      DisplayLabel = 'Quantit'#224
      FieldName = 'Qta'
    end
    object tbFatForMvUM: TStringField
      DisplayLabel = 'U.M.'
      FieldKind = fkCalculated
      FieldName = 'UM'
      Size = 10
      Calculated = True
    end
    object tbFatForMvImp: TCurrencyField
      FieldName = 'Imp'
    end
    object tbFatForMvIVA: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'IVA'
      Calculated = True
    end
    object tbFatForMvElab: TBooleanField
      FieldName = 'Elab'
    end
  end
  object dsArticoli: TDataSource
    DataSet = tbArticoli
    Left = 245
    Top = 265
  end
  object dsFatForMv: TDataSource
    DataSet = tbFatForMv
    Left = 75
    Top = 260
  end
  object tbArticoli: TTable
    DatabaseName = 'DB'
    TableName = 'ARTICOLI.DB'
    Left = 245
    Top = 235
    object tbArticoliCodAlf: TStringField
      FieldName = 'CodAlf'
      Size = 3
    end
    object tbArticoliCodNum: TSmallintField
      FieldName = 'CodNum'
    end
    object tbArticoliDesc: TStringField
      FieldName = 'Desc'
      Size = 30
    end
    object tbArticoliAttv: TBooleanField
      FieldName = 'Attv'
    end
    object tbArticoliCodIVA: TSmallintField
      FieldName = 'CodIVA'
      Required = True
    end
    object tbArticoliCodMis: TSmallintField
      FieldName = 'CodMis'
      Required = True
    end
    object tbArticoliQta: TFloatField
      FieldName = 'Qta'
      Required = True
    end
    object tbArticoliQtaInv: TFloatField
      FieldName = 'QtaInv'
    end
    object tbArticoliQtaDelta: TFloatField
      FieldName = 'QtaDelta'
    end
    object tbArticoliQtaAcq: TFloatField
      FieldName = 'QtaAcq'
    end
    object tbArticoliQtaOrd: TFloatField
      FieldName = 'QtaOrd'
    end
    object tbArticoliQtaVen: TFloatField
      FieldName = 'QtaVen'
    end
    object tbArticoliQtaPre: TFloatField
      FieldName = 'QtaPre'
    end
    object tbArticoliQtaSco: TFloatField
      FieldName = 'QtaSco'
    end
    object tbArticoliPrzLis: TCurrencyField
      FieldName = 'PrzLis'
    end
    object tbArticoliPrzNor: TCurrencyField
      FieldName = 'PrzNor'
    end
    object tbArticoliPrzSpe: TCurrencyField
      FieldName = 'PrzSpe'
    end
    object tbArticoliRicNor: TSmallintField
      FieldName = 'RicNor'
    end
    object tbArticoliRicSpe: TSmallintField
      FieldName = 'RicSpe'
    end
    object tbArticoliPrePriAcq: TCurrencyField
      FieldName = 'PrePriAcq'
    end
    object tbArticoliPreUltAcq: TCurrencyField
      FieldName = 'PreUltAcq'
    end
    object tbArticoliDatPriAcq: TDateField
      FieldName = 'DatPriAcq'
    end
    object tbArticoliDatUltAcq: TDateField
      FieldName = 'DatUltAcq'
    end
    object tbArticoliCumuloAcq: TFloatField
      FieldName = 'CumuloAcq'
    end
    object tbArticoliCumuloOrd: TFloatField
      FieldName = 'CumuloOrd'
    end
  end
  object dsFatForLs: TDataSource
    DataSet = tbFatForLs
    OnDataChange = dsFatForLsDataChange
    Left = 45
    Top = 260
  end
  object tbFornitori: TTable
    DatabaseName = 'DB'
    TableName = 'FORNIT.DB'
    Left = 275
    Top = 235
    object tbFornitoriCodFor: TIntegerField
      FieldName = 'CodFor'
    end
    object tbFornitoriNome: TStringField
      FieldName = 'Nome'
      Required = True
      Size = 30
    end
    object tbFornitoriPotenziale: TBooleanField
      FieldName = 'Potenziale'
    end
  end
  object dsFornitori: TDataSource
    DataSet = tbFornitori
    Left = 275
    Top = 265
  end
  object tbFatForSp: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'CodFatFor'
    MasterFields = 'CodFatFor'
    MasterSource = dsFatForLs
    TableName = 'FATFORSP.DB'
    Left = 105
    Top = 230
    object tbFatForSpCodSpe: TIntegerField
      FieldName = 'CodSpe'
      Visible = False
    end
    object tbFatForSpCodFatFor: TIntegerField
      FieldName = 'CodFatFor'
      Visible = False
    end
    object tbFatForSpImp: TCurrencyField
      FieldName = 'Imp'
    end
    object tbFatForSpIVA: TCurrencyField
      FieldName = 'IVA'
    end
  end
  object dsFatForSp: TDataSource
    DataSet = tbFatForSp
    Left = 105
    Top = 260
  end
end
