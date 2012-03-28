object fmEleIndi: TfmEleIndi
  Left = 243
  Top = 135
  Caption = '(a run time)'
  ClientHeight = 266
  ClientWidth = 444
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedBar1: TJvSpeedBar
    Left = 0
    Top = 0
    Width = 444
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [sbAllowDrag, sbFlatBtns, sbGrayedBtns]
    BtnOffsetHorz = 3
    BtnOffsetVert = 3
    BtnWidth = 24
    BtnHeight = 23
    TabOrder = 0
    OnApplyAlign = SpeedBar1ApplyAlign
    InternalVer = 1
    object cbTipoInd: TComboBox
      Left = 295
      Top = 4
      Width = 131
      Height = 21
      Hint = 'Tipo di indirizzi da visualizzare'
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbTipoIndChange
    end
    object cbFiltCont: TCheckBox
      Left = 5
      Top = 7
      Width = 57
      Height = 17
      Hint = 'Visualizza gli indirizzi del '#13#10'solo contatto specificato'
      Caption = 'Solo di'
      TabOrder = 1
      OnClick = cbFiltContClick
    end
    object lcContatti: TJvDBLookupCombo
      Left = 65
      Top = 4
      Width = 135
      Height = 21
      Hint = 'Contatto di cui si vogliono '#13#10'visualizzare gli indirizzi'
      DisplayEmpty = '<< tutti >>'
      ListStyle = lsDelimited
      LookupField = 'CodCon'
      LookupDisplay = 'Nome_Main;Nome_Pre1'
      LookupSource = dsContat
      TabOrder = 2
      OnChange = lcContattiChange
    end
    object cbFiltTipo: TCheckBox
      Left = 210
      Top = 7
      Width = 82
      Height = 17
      Hint = 'Visualizza solo i tipi di '#13#10'indirizzo specificati'
      Caption = 'Solo del tipo'
      TabOrder = 3
      OnClick = cbFiltTipoClick
    end
  end
  object dgIndir: TJvDBGrid
    Left = 0
    Top = 29
    Width = 444
    Height = 237
    Align = alClient
    DataSource = dsIndir
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dgIndirDblClick
    TitleButtons = True
    OnCheckButton = dgIndirCheckButton
    OnGetCellParams = dgIndirGetCellParams
    SelectColumnsDialogStrings.Caption = 'Select columns'
    SelectColumnsDialogStrings.OK = '&OK'
    SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
    EditControls = <>
    RowsHeight = 17
    TitleRowHeight = 17
  end
  object dsIndir: TDataSource
    DataSet = qbeEleInd
    OnDataChange = dsIndirDataChange
    Left = 195
    Top = 155
  end
  object flIndir: TJvDBFilter
    DataSource = dsIndir
    OnFiltering = flIndirFiltering
    Left = 195
    Top = 185
  end
  object MainMenu1: TMainMenu
    Left = 265
    Top = 65
    object Operazioni1: TMenuItem
      Caption = '&Indirizzi'
      object miEleIndScrn: TMenuItem
        Caption = 'Mostra anteprima elenco'
        OnClick = miEleIndClick
      end
      object miEleIndPrnt: TMenuItem
        Caption = 'Stampa elenco indirizzi'
        OnClick = miEleIndClick
      end
      object miEleIndFile: TMenuItem
        Caption = 'Esporta elenco indirizzi'
        OnClick = miEleIndClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miConnect: TMenuItem
        Caption = 'Connettiti'
        OnClick = miConnectClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miClose: TMenuItem
        Caption = 'Chiud&e la finestra'
        OnClick = miCloseClick
      end
    end
  end
  object tbContat: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'Nome_Main;Nome_Pre1'
    TableName = 'CONTAT.DB'
    Left = 75
    Top = 90
  end
  object dsContat: TDataSource
    DataSet = tbContat
    Left = 120
    Top = 95
  end
  object qbeEleInd: TJvQBEQuery
    OnCalcFields = qbeEleIndCalcFields
    DatabaseName = 'DB'
    QBE.Strings = (
      'Query'
      'ANSWER: :PRIV:ANSWER.DB'
      ''
      
        'SORT: Contat.DB->"Nome_Main", Contat.DB->"Nome_Pre1", Contat.DB-' +
        '>"Nome_Pre2",'
      'Contat.DB->"Nome_Suf", Contat.DB->"CodCon"'
      ''
      'Indiriz.DB | CodCon | Tipo           | Note   | CodInd |'
      '           | _join1 | Check as Tipo  |  Check  | Check |'
      ''
      
        'Contat.DB | CodCon         | Tipo              | Nome_Tit | Nome' +
        '_Pre1 | Nome_Pre2 |'
      
        '          | Check _join1   | Check as TipoCont | Check    | Chec' +
        'k     | Check     |'
      ''
      'Contat.DB | Nome_Main | Nome_Suf | Classe | Settore |'
      '          | Check     | Check    | Check  | Check   |'
      ''
      'EndQuery'
      '')
    Left = 160
    Top = 185
    ParamData = <>
    object qbeEleIndContat: TStringField
      DisplayLabel = 'Nome del contatto'
      DisplayWidth = 32
      FieldKind = fkCalculated
      FieldName = 'Contat'
      Size = 40
      Calculated = True
    end
    object qbeEleIndInd: TStringField
      DisplayLabel = 'Indirizzo'
      DisplayWidth = 45
      FieldKind = fkCalculated
      FieldName = 'Ind'
      Size = 100
      Calculated = True
    end
    object qbeEleIndNote: TStringField
      DisplayWidth = 48
      FieldName = 'Note'
      Size = 40
    end
    object qbeEleIndTipo: TIntegerField
      FieldName = 'Tipo'
      Visible = False
    end
    object qbeEleIndCodCon: TIntegerField
      FieldName = 'CodCon'
      Visible = False
    end
    object qbeEleIndTipoCont: TIntegerField
      FieldName = 'TipoCont'
      Visible = False
    end
    object qbeEleIndNome_Tit: TStringField
      FieldName = 'Nome_Tit'
      Visible = False
      Size = 10
    end
    object qbeEleIndNome_Pre1: TStringField
      FieldName = 'Nome_Pre1'
      Visible = False
    end
    object qbeEleIndNome_Pre2: TStringField
      FieldName = 'Nome_Pre2'
      Visible = False
      Size = 40
    end
    object qbeEleIndNome_Main: TStringField
      FieldName = 'Nome_Main'
      Visible = False
      Size = 40
    end
    object qbeEleIndNome_Suf: TStringField
      FieldName = 'Nome_Suf'
      Visible = False
      Size = 10
    end
    object qbeEleIndClasse: TStringField
      FieldName = 'Classe'
      Visible = False
      Size = 15
    end
    object qbeEleIndSettore: TStringField
      FieldName = 'Settore'
      Visible = False
      Size = 35
    end
    object qbeEleIndCodInd: TIntegerField
      FieldName = 'CodInd'
      Visible = False
    end
  end
  object fpEleTel: TJvFormStorage
    AppStorage = fmMain.apStorage
    AppStoragePath = '%FORM_NAME%'
    StoredValues = <>
    Left = 50
    Top = 145
  end
  object tbIndir: TTable
    DatabaseName = 'DB'
    TableName = 'INDIRIZ.DB'
    Left = 170
    Top = 100
  end
end
