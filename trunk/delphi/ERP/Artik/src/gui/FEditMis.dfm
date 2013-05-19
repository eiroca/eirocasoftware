object fmEditCodMis: TfmEditCodMis
  Left = 291
  Top = 144
  ActiveControl = Panel1
  Caption = 'Tabella unita'#39' di misura'
  ClientHeight = 209
  ClientWidth = 213
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 213
    Height = 36
    Align = alTop
    TabOrder = 0
    object RGNavigator1: TRGNavigator
      Left = 5
      Top = 6
      Width = 186
      Height = 25
      VisibleButtons = [nbPrior, nbNext, nbRefresh, nbInsert, nbDelete, nbEdit]
      TabOrder = 0
      ColorScroll = ncBlack
      ColorFunc = ncBlack
      ColorCtrl = ncBlack
      ColorTool = ncBlack
      SizeOfKey = X4
      CaptionExtra1 = 'Extra1'
      CaptionExtra2 = 'Extra2'
      CaptionExtra3 = 'Extra3'
      DataSource = dsCodMis
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 36
    Width = 213
    Height = 173
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'Panel2'
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 6
      Top = 6
      Width = 201
      Height = 161
      Align = alClient
      BorderStyle = bsNone
      DataSource = dsCodMis
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
  end
  object dsCodMis: TDataSource
    DataSet = tbCodMis
    Left = 47
    Top = 65
  end
  object tbCodMis: TTable
    DatabaseName = 'DB'
    TableName = 'TBCODMIS.DB'
    Left = 20
    Top = 65
    object tbCodMisCodMis: TSmallintField
      FieldName = 'CodMis'
    end
    object tbCodMisDesc: TStringField
      DisplayLabel = 'Unita'#39' di misura'
      FieldName = 'Desc'
      Required = True
      Size = 10
    end
  end
end
