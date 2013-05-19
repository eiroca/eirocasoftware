object fmTabaEdit: TfmTabaEdit
  Left = 228
  Top = 126
  ActiveControl = Panel1
  BorderStyle = bsDialog
  Caption = 'Modifica dati tabacchi '
  ClientHeight = 257
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 434
    Height = 66
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 45
      Width = 98
      Height = 13
      Caption = 'Ordina i tabacchi per'
    end
    object lbDataPrezzi: TLabel
      Left = 240
      Top = 45
      Width = 82
      Height = 13
      Caption = 'Prezzi del &&/&&/&&&&'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object cbOrder: TComboBox
      Left = 120
      Top = 40
      Width = 110
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbOrderChange
    end
    object navTaba: TRGNavigator
      Left = 10
      Top = 10
      Width = 301
      Height = 25
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbSearch, nbPrint, nbRefresh, nbInsert, nbDelete, nbEdit]
      TabOrder = 1
      OnClick = navTabaClick
      ColorScroll = ncBlack
      ColorFunc = ncBlack
      ColorCtrl = ncBlack
      ColorTool = ncBlack
      SizeOfKey = X4
      CaptionExtra1 = 'Extra1'
      CaptionExtra2 = 'Extra2'
      CaptionExtra3 = 'Extra3'
      DataSource = dsTaba
    end
    object BitBtn1: TBitBtn
      Left = 320
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Rinumera'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333FF33333333333330003FF3FFFFF3333777003000003333
        300077F777773F333777E00BFBFB033333337773333F7F33333FE0BFBF000333
        330077F3337773F33377E0FBFBFBF033330077F3333FF7FFF377E0BFBF000000
        333377F3337777773F3FE0FBFBFBFBFB039977F33FFFFFFF7377E0BF00000000
        339977FF777777773377000BFB03333333337773FF733333333F333000333333
        3300333777333333337733333333333333003333333333333377333333333333
        333333333333333333FF33333333333330003333333333333777333333333333
        3000333333333333377733333333333333333333333333333333}
      NumGlyphs = 2
      TabOrder = 2
      OnClick = BitBtn1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 66
    Width = 434
    Height = 191
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'Panel2'
    TabOrder = 1
    object ScrollBox: TScrollBox
      Left = 6
      Top = 6
      Width = 422
      Height = 179
      HorzScrollBar.Margin = 6
      HorzScrollBar.Range = 330
      VertScrollBar.Margin = 6
      VertScrollBar.Range = 122
      Align = alClient
      AutoScroll = False
      BorderStyle = bsNone
      TabOrder = 0
      object lbCodI: TLabel
        Left = 6
        Top = 5
        Width = 33
        Height = 13
        Caption = 'Codice'
        FocusControl = iCodI
      end
      object Label2: TLabel
        Left = 62
        Top = 5
        Width = 43
        Height = 13
        Caption = 'Cod. Sig.'
        FocusControl = iCodS
      end
      object Label3: TLabel
        Left = 5
        Top = 50
        Width = 63
        Height = 13
        Caption = 'Tipo tabacco'
      end
      object Label4: TLabel
        Left = 145
        Top = 50
        Width = 49
        Height = 13
        Caption = 'Produttore'
      end
      object Label5: TLabel
        Left = 285
        Top = 50
        Width = 34
        Height = 13
        Caption = 'Criticit'#224
      end
      object Label6: TLabel
        Left = 116
        Top = 5
        Width = 55
        Height = 13
        Caption = 'Descrizione'
        FocusControl = iDesc
      end
      object Label8: TLabel
        Left = 210
        Top = 135
        Width = 111
        Height = 13
        Caption = 'Moltiplicatore inventario'
        FocusControl = iMulI
      end
      object Label9: TLabel
        Left = 5
        Top = 105
        Width = 93
        Height = 13
        Caption = 'Quantit'#224' per stecca'
        FocusControl = iQTAS
      end
      object Label10: TLabel
        Left = 5
        Top = 130
        Width = 114
        Height = 13
        Caption = 'Quantit'#224'  in un kg conv.'
        FocusControl = iQTAC
      end
      object Label11: TLabel
        Left = 210
        Top = 105
        Width = 117
        Height = 13
        Caption = 'Quantit'#224' minima richiesta'
        FocusControl = iQTAM
      end
      object Label12: TLabel
        Left = 5
        Top = 160
        Width = 58
        Height = 13
        Caption = 'Differenziale'
        FocusControl = iDIFR
      end
      object sbQtaS: TJvSpinButton
        Tag = 10000
        Left = 185
        Top = 100
        OnBottomClick = sbQtaSBottomClick
        OnTopClick = sbQtaSTopClick
      end
      object sbQtaC: TJvSpinButton
        Tag = 1000
        Left = 185
        Top = 125
        OnBottomClick = sbQtaCBottomClick
        OnTopClick = sbQtaCTopClick
      end
      object sbDifr: TJvSpinButton
        Tag = 1000
        Left = 185
        Top = 150
        OnBottomClick = sbDifrBottomClick
        OnTopClick = sbDifrTopClick
      end
      object sbQtaM: TJvSpinButton
        Tag = 10000
        Left = 397
        Top = 100
        OnBottomClick = sbQtaMBottomClick
        OnTopClick = sbQtaMTopClick
      end
      object sbMulI: TJvSpinButton
        Tag = 100
        Left = 397
        Top = 130
        OnBottomClick = sbMulIBottomClick
        OnTopClick = sbMulITopClick
      end
      object lbPrezzo: TLabel
        Left = 210
        Top = 155
        Width = 40
        Height = 13
        Caption = 'lbPrezzo'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object iCodI: TDBEdit
        Left = 6
        Top = 20
        Width = 50
        Height = 21
        DataField = 'CODI'
        DataSource = dsTaba
        TabOrder = 0
      end
      object iCodS: TDBEdit
        Left = 62
        Top = 20
        Width = 49
        Height = 21
        DataField = 'CODS'
        DataSource = dsTaba
        TabOrder = 1
      end
      object iDesc: TDBEdit
        Left = 116
        Top = 20
        Width = 240
        Height = 21
        DataField = 'DESC'
        DataSource = dsTaba
        TabOrder = 2
      end
      object iMulI: TDBEdit
        Left = 337
        Top = 130
        Width = 60
        Height = 21
        DataField = 'MULI'
        DataSource = dsTaba
        TabOrder = 11
      end
      object iQTAS: TDBEdit
        Left = 125
        Top = 100
        Width = 60
        Height = 21
        DataField = 'QTAS'
        DataSource = dsTaba
        TabOrder = 7
      end
      object iQTAC: TDBEdit
        Left = 125
        Top = 125
        Width = 60
        Height = 21
        DataField = 'QTAC'
        DataSource = dsTaba
        TabOrder = 8
      end
      object iQTAM: TDBEdit
        Left = 337
        Top = 100
        Width = 60
        Height = 21
        DataField = 'QTAM'
        DataSource = dsTaba
        TabOrder = 10
      end
      object iDIFR: TDBEdit
        Left = 125
        Top = 150
        Width = 60
        Height = 21
        DataField = 'DIFR'
        DataSource = dsTaba
        TabOrder = 9
      end
      object DBCheckBox1: TDBCheckBox
        Left = 360
        Top = 20
        Width = 97
        Height = 17
        Caption = 'Attivo'
        DataField = 'ATTV'
        DataSource = dsTaba
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBLookupCombo1: TDBLookupCombo
        Left = 5
        Top = 65
        Width = 131
        Height = 24
        DataField = 'TIPO'
        DataSource = dsTaba
        LookupSource = dsTabaTipo
        LookupDisplay = 'DESC'
        LookupField = 'TIPO'
        TabOrder = 4
      end
      object DBLookupCombo2: TDBLookupCombo
        Left = 145
        Top = 65
        Width = 131
        Height = 24
        DataField = 'PROD'
        DataSource = dsTaba
        LookupSource = dsTabaProd
        LookupDisplay = 'DESC'
        LookupField = 'PROD'
        TabOrder = 5
      end
      object DBLookupCombo3: TDBLookupCombo
        Left = 285
        Top = 65
        Width = 131
        Height = 24
        DataField = 'CRIT'
        DataSource = dsTaba
        LookupSource = dsTabaCrit
        LookupDisplay = 'DESC'
        LookupField = 'CRIT'
        TabOrder = 6
      end
    end
  end
  object tbTaba: TTable
    AfterPost = tbTabaAfterPost
    DatabaseName = 'DB'
    TableName = 'TABACCHI.DB'
    Left = 195
    Top = 75
    object tbTabaCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbTabaCODS: TStringField
      FieldName = 'CODS'
      Required = True
      Size = 4
    end
    object tbTabaTIPO2: TSmallintField
      FieldName = 'TIPO'
    end
    object tbTabaPROD2: TSmallintField
      FieldName = 'PROD'
    end
    object tbTabaCRIT2: TSmallintField
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
  object dsTabaTipo: TDataSource
    DataSet = tbTabaTipo
    Left = 225
    Top = 90
  end
  object dsTabaProd: TDataSource
    DataSet = tbTabaProd
    Left = 255
    Top = 90
  end
  object tbTabaCrit: TTable
    DatabaseName = 'DB'
    TableName = 'TABACRIT.DB'
    Left = 285
    Top = 75
  end
  object dsTabaCrit: TDataSource
    DataSet = tbTabaCrit
    Left = 285
    Top = 90
  end
  object tbTabaTipo: TTable
    DatabaseName = 'DB'
    TableName = 'TABATIPO.DB'
    Left = 225
    Top = 75
  end
  object tbTabaProd: TTable
    DatabaseName = 'DB'
    TableName = 'TABAPROD.DB'
    Left = 255
    Top = 75
  end
  object dsTaba: TDataSource
    DataSet = tbTaba
    OnDataChange = dsTabaDataChange
    Left = 195
    Top = 90
  end
end
