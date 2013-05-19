object fmEditGruppi: TfmEditGruppi
  Left = 238
  Top = 104
  ActiveControl = RxDBGrid1
  BorderStyle = bsDialog
  Caption = 'Modifica gruppi'
  ClientHeight = 278
  ClientWidth = 271
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RxDBGrid1: TJvDBGrid
    Left = 10
    Top = 30
    Width = 251
    Height = 201
    Hint = 'Gruppi presenti'
    DataSource = dsGruppi
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    SelectColumnsDialogStrings.Caption = 'Select columns'
    SelectColumnsDialogStrings.OK = '&OK'
    SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
    EditControls = <>
    RowsHeight = 17
    TitleRowHeight = 17
  end
  object btOk: TBitBtn
    Left = 6
    Top = 243
    Width = 77
    Height = 27
    Hint = 'Termina le modifiche dei gruppi'
    Caption = '&Ok'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      555555555555555555555555555555555555555555FF55555555555559055555
      55555555577FF5555555555599905555555555557777F5555555555599905555
      555555557777FF5555555559999905555555555777777F555555559999990555
      5555557777777FF5555557990599905555555777757777F55555790555599055
      55557775555777FF5555555555599905555555555557777F5555555555559905
      555555555555777FF5555555555559905555555555555777FF55555555555579
      05555555555555777FF5555555555557905555555555555777FF555555555555
      5990555555555555577755555555555555555555555555555555}
    Margin = 5
    ModalResult = 1
    NumGlyphs = 2
    ParentFont = False
    Spacing = -1
    TabOrder = 1
    IsControl = True
  end
  object DBNavigator1: TDBNavigator
    Left = 22
    Top = 5
    Width = 225
    Height = 25
    DataSource = dsGruppi
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
    Kind = dbnHorizontal
    ConfirmDelete = False
    TabOrder = 2
  end
  object fpEdtGrp: TJvFormPlacement
    AppStorage = fmMain.apStorage
    AppStoragePath = '%FORM_NAME%'
    Left = 30
    Top = 135
  end
  object tbGruppi: TTable
    BeforeDelete = tbGruppiBeforeDelete
    OnCalcFields = tbGruppiCalcFields
    DatabaseName = 'DB'
    TableName = 'GRUPPI.DB'
    Left = 85
    Top = 140
    object tbGruppiCodGrp: TIntegerField
      FieldName = 'CodGrp'
      Visible = False
    end
    object tbGruppiDesc: TStringField
      DisplayLabel = 'Nome del gruppo'
      DisplayWidth = 35
      FieldName = 'Desc'
      Size = 30
    end
    object tbGruppiCanc: TStringField
      Alignment = taCenter
      DisplayLabel = '*'
      DisplayWidth = 4
      FieldKind = fkCalculated
      FieldName = 'Canc'
      Visible = False
      Size = 1
      Calculated = True
    end
  end
  object dsGruppi: TDataSource
    DataSet = tbGruppi
    Left = 125
    Top = 140
  end
  object tbInGruppo: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'CodGrp'
    TableName = 'INGRUPPO.DB'
    Left = 190
    Top = 145
  end
end
