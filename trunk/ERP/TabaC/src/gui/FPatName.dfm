object fmPateName: TfmPateName
  Left = 324
  Top = 183
  Caption = 'Inserimento Dati Patentini'
  ClientHeight = 178
  ClientWidth = 228
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 36
    Width = 228
    Height = 142
    Align = alClient
    DataSource = dsPateName
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 228
    Height = 36
    Align = alTop
    TabOrder = 1
    object RGNavigator1: TRGNavigator
      Left = 10
      Top = 5
      Width = 200
      Height = 25
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh, nbInsert, nbDelete, nbEdit]
      ConfirmDelete = False
      ConfirmInsert = False
      ConfirmEdit = False
      ConfirmPost = False
      ConfirmCancel = False
      TabOrder = 0
      ColorScroll = ncBlack
      ColorFunc = ncBlack
      ColorCtrl = ncBlack
      ColorTool = ncBlack
      SizeOfKey = X4
      CaptionExtra1 = 'Extra1'
      CaptionExtra2 = 'Extra2'
      CaptionExtra3 = 'Extra3'
      DataSource = dsPateName
    end
  end
  object tbPateName: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'NOME'
    TableName = 'PATENAME.DB'
    Left = 25
    Top = 75
    object tbPateNameCODP: TIntegerField
      FieldName = 'CODP'
      Visible = False
    end
    object tbPateNameNOME: TStringField
      DisplayLabel = 'Identificativo Patentino'
      FieldName = 'NOME'
      Required = True
      Size = 30
    end
  end
  object dsPateName: TDataSource
    DataSet = tbPateName
    Left = 40
    Top = 85
  end
end
