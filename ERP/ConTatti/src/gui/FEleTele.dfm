object fmEleTelef: TfmEleTelef
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
  object dgTelef: TJvDBGrid
    Left = 0
    Top = 29
    Width = 444
    Height = 237
    Hint = 'Elenco telefonico'#13#10'Clicca sul titolo per cambiare ordinamento'
    Align = alClient
    DataSource = dsTelef
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    TitleButtons = True
    OnCheckButton = dgTelefCheckButton
    OnGetBtnParams = dgTelefGetBtnParams
    OnTitleBtnClick = dgTelefTitleBtnClick
    SelectColumnsDialogStrings.Caption = 'Select columns'
    SelectColumnsDialogStrings.OK = '&OK'
    SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
    EditControls = <>
    RowsHeight = 17
    TitleRowHeight = 17
  end
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
    TabOrder = 1
    OnApplyAlign = SpeedBar1ApplyAlign
    InternalVer = 1
    object cbTipoTel: TComboBox
      Left = 295
      Top = 4
      Width = 131
      Height = 21
      Hint = 'Tipo di telefono che si '#13#10'desidera visualizzato'
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbTipoTelChange
    end
    object cbFiltCont: TCheckBox
      Left = 5
      Top = 7
      Width = 57
      Height = 17
      Hint = 'Visualizza i soli telefoni del '#13#10'contatto specificato'
      Caption = 'Solo di'
      TabOrder = 1
      OnClick = cbFiltContClick
    end
    object lcContatti: TJvDBLookupCombo
      Left = 65
      Top = 4
      Width = 135
      Height = 21
      Hint = 'Contatto di cui interessano'#13#10'i numeri telefonici'
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
      Hint = 'Visualizza soli i telefoni'#13#10'di un certo tipo'
      Caption = 'Solo del tipo'
      TabOrder = 3
      OnClick = cbFiltTipoClick
    end
  end
  object dsTelef: TDataSource
    DataSet = qbeEleTel1
    Left = 195
    Top = 155
  end
  object flTelef: TJvDBFilter
    DataSource = dsTelef
    OnFiltering = flTelefFiltering
    Left = 195
    Top = 185
  end
  object MainMenu1: TMainMenu
    Left = 255
    Top = 75
    object Operazioni1: TMenuItem
      Caption = '&Telefoni'
      object miEleTelScrn: TMenuItem
        Caption = 'Mostra anteprima elenco'
        OnClick = miEleTelClick
      end
      object miEleTelPrnt: TMenuItem
        Caption = 'Stampa elenco telefonico'
        OnClick = miEleTelClick
      end
      object miEleTelFile: TMenuItem
        Caption = 'Esporta elenco telefonico'
        OnClick = miEleTelClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miIntPref: TMenuItem
        Caption = 'Mostra i prefissi internazionali'
        OnClick = miSelfPrefClick
      end
      object miSelfPref: TMenuItem
        Caption = 'Non mostrare il mio prefisso'
        OnClick = miSelfPrefClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miExit: TMenuItem
        Caption = 'Chiud&e la finestra'
        OnClick = miExitClick
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
  object qbeEleTel1: TJvQBEQuery
    OnCalcFields = qbeEleTelCalcFields
    DatabaseName = 'DB'
    AuxiliaryTables = False
    QBE.Strings = (
      'Query'
      ''
      
        'SORT: CONTAT.DB->"Nome_Main", CONTAT.DB->"Nome_Pre1", CONTAT.DB-' +
        '>"Nome_Pre2",'
      'CONTAT.DB->"Nome_Suf", CONTAT.DB->"CodCon"'
      ''
      
        'CONTAT.DB | CodCon | Tipo              | Nome_Tit | Nome_Pre1 | ' +
        'Nome_Pre2 |'
      
        '          | Check _join1| Check as TipoCont | Check    | Check  ' +
        '   | Check     | '
      ''
      'CONTAT.DB | Nome_Main | Nome_Suf | Classe | Settore | '
      '          | Check     | Check    | Check  | Check   | '
      ''
      
        'TELEF.DB | CodCon | Tipo             | Tel_Pre1 | Tel_Pre2 | Tel' +
        'efono | '
      
        '         | _join1 | Check as Tipo | Check    | Check    | Check ' +
        '   | '
      ''
      'TELEF.DB | Note   | '
      '         | Check  | '
      ''
      'EndQuery')
    Left = 155
    Top = 185
    ParamData = <>
    object qbeEleTel1Nome_Tit: TStringField
      FieldName = 'Nome_Tit'
      Visible = False
      Size = 10
    end
    object qbeEleTel1Nome_Pre1: TStringField
      FieldName = 'Nome_Pre1'
      Visible = False
    end
    object qbeEleTel1Nome_Pre2: TStringField
      FieldName = 'Nome_Pre2'
      Visible = False
      Size = 40
    end
    object qbeEleTel1Nome_Main: TStringField
      FieldName = 'Nome_Main'
      Visible = False
      Size = 40
    end
    object qbeEleTel1Nome_Suf: TStringField
      FieldName = 'Nome_Suf'
      Visible = False
      Size = 10
    end
    object qbeEleTel1Classe: TStringField
      FieldName = 'Classe'
      Visible = False
      Size = 15
    end
    object qbeEleTel1Settore: TStringField
      FieldName = 'Settore'
      Visible = False
      Size = 35
    end
    object qbeEleTel1TipoCont: TIntegerField
      FieldName = 'TipoCont'
      Visible = False
    end
    object qbeEleTel1Tipo: TIntegerField
      FieldName = 'Tipo'
      Visible = False
    end
    object qbeEleTel1Tel_Pre1: TStringField
      FieldName = 'Tel_Pre1'
      Visible = False
      Size = 6
    end
    object qbeEleTel1Tel_Pre2: TStringField
      FieldName = 'Tel_Pre2'
      Visible = False
      Size = 6
    end
    object qbeEleTel1Telefono: TStringField
      FieldName = 'Telefono'
      Visible = False
      Size = 18
    end
    object qbeEleTel1CodCon: TIntegerField
      FieldName = 'CodCon'
      Visible = False
    end
    object qbeEleTel1Contat: TStringField
      DisplayLabel = 'Nome del contatto'
      DisplayWidth = 33
      FieldKind = fkCalculated
      FieldName = 'Contat'
      Size = 40
      Calculated = True
    end
    object qbeEleTel1Tel: TStringField
      Alignment = taRightJustify
      DisplayLabel = 'Numero di telefono'
      DisplayWidth = 20
      FieldKind = fkCalculated
      FieldName = 'Tel'
      Size = 40
      Calculated = True
    end
    object qbeEleTel1TelefTipo: TStringField
      DisplayLabel = 'Tipo di telefono'
      DisplayWidth = 15
      FieldKind = fkCalculated
      FieldName = 'TelefTipo'
      Size = 15
      Calculated = True
    end
    object qbeEleTel1Note: TStringField
      DisplayWidth = 40
      FieldName = 'Note'
      Size = 40
    end
  end
  object fpEleTel: TJvFormStorage
    AppStorage = fmMain.apStorage
    AppStoragePath = '%FORM_NAME%'
    StoredProps.Strings = (
      'dgTelef.Tag')
    StoredValues = <>
    Left = 50
    Top = 145
  end
  object qbeEleTel2: TJvQBEQuery
    OnCalcFields = qbeEleTelCalcFields
    DatabaseName = 'DB'
    AuxiliaryTables = False
    QBE.Strings = (
      'Query'
      'ANSWER: :PRIV:ANSWER.DB'
      ''
      
        'SORT: TELEF.DB->"Tel_Pre1", TELEF.DB->"Tel_Pre2", TELEF.DB->"Tel' +
        'efono", CONTAT.DB->"CodCon"'
      ''
      
        'CONTAT.DB | CodCon | Tipo              | Nome_Tit | Nome_Pre1 | ' +
        'Nome_Pre2 |'
      
        '          | Check _join1 | Check as TipoCont | Check    | Check ' +
        '    | Check     |'
      ''
      'CONTAT.DB | Nome_Main | Nome_Suf | Classe | Settore |'
      '          | Check     | Check    | Check  | Check   |'
      ''
      
        'TELEF.DB | CodCon | Tipo             | Tel_Pre1 | Tel_Pre2 | Tel' +
        'efono |'
      
        '         | _join1 | Check as Tipo | Check    | Check    | Check ' +
        '   | '
      ''
      'TELEF.DB | Note   | '
      '         | Check  | '
      ''
      'EndQuery')
    Left = 125
    Top = 185
    ParamData = <>
    object StringField1: TStringField
      FieldName = 'Nome_Tit'
      Visible = False
      Size = 10
    end
    object StringField2: TStringField
      FieldName = 'Nome_Pre1'
      Visible = False
    end
    object StringField3: TStringField
      FieldName = 'Nome_Pre2'
      Visible = False
      Size = 40
    end
    object StringField4: TStringField
      FieldName = 'Nome_Main'
      Visible = False
      Size = 40
    end
    object StringField5: TStringField
      FieldName = 'Nome_Suf'
      Visible = False
      Size = 10
    end
    object StringField6: TStringField
      FieldName = 'Classe'
      Visible = False
      Size = 15
    end
    object StringField7: TStringField
      FieldName = 'Settore'
      Visible = False
      Size = 35
    end
    object IntegerField1: TIntegerField
      FieldName = 'TipoCont'
      Visible = False
    end
    object IntegerField2: TIntegerField
      FieldName = 'Tipo'
      Visible = False
    end
    object StringField8: TStringField
      FieldName = 'Tel_Pre1'
      Visible = False
      Size = 6
    end
    object StringField9: TStringField
      FieldName = 'Tel_Pre2'
      Visible = False
      Size = 6
    end
    object StringField10: TStringField
      FieldName = 'Telefono'
      Visible = False
      Size = 18
    end
    object IntegerField3: TIntegerField
      FieldName = 'CodCon'
      Visible = False
    end
    object StringField11: TStringField
      DisplayLabel = 'Nome del contatto'
      DisplayWidth = 33
      FieldKind = fkCalculated
      FieldName = 'Contat'
      Size = 40
      Calculated = True
    end
    object StringField12: TStringField
      Alignment = taRightJustify
      DisplayLabel = 'Numero di telefono'
      DisplayWidth = 20
      FieldKind = fkCalculated
      FieldName = 'Tel'
      Size = 40
      Calculated = True
    end
    object StringField13: TStringField
      DisplayLabel = 'Tipo di telefono'
      DisplayWidth = 15
      FieldKind = fkCalculated
      FieldName = 'TelefTipo'
      Size = 15
      Calculated = True
    end
    object StringField14: TStringField
      DisplayWidth = 40
      FieldName = 'Note'
      Size = 40
    end
  end
end
