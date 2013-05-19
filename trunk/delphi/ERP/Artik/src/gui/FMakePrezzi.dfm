object fmMakePrezzi: TfmMakePrezzi
  Left = 253
  Top = 175
  Caption = 'fmMakePrezzi'
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 40
    Width = 101
    Height = 13
    Caption = 'Settore Merceologico'
  end
  object Label2: TLabel
    Left = 15
    Top = 55
    Width = 35
    Height = 13
    Caption = 'Articolo'
  end
  object lbSetMer: TLabel
    Left = 125
    Top = 40
    Width = 42
    Height = 13
    Caption = 'lbSetMer'
  end
  object lbArtDesc: TLabel
    Left = 125
    Top = 55
    Width = 46
    Height = 13
    Caption = 'lbArtDesc'
  end
  object RGNavigator1: TRGNavigator
    Left = 10
    Top = 5
    Width = 346
    Height = 25
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbSearch, nbRefresh, nbInsert, nbDelete, nbEdit]
    TabOrder = 0
    ColorScroll = ncBlack
    ColorFunc = ncBlack
    ColorCtrl = ncBlack
    ColorTool = ncBlack
    SizeOfKey = X4
    CaptionExtra1 = 'Extra1'
    CaptionExtra2 = 'Extra2'
    CaptionExtra3 = 'Extra3'
  end
  object tbFatForMv: TTable
    DatabaseName = 'DB'
    TableName = 'FATFORMV.DB'
    Left = 325
    Top = 65
    object tbFatForMvCodMov: TIntegerField
      FieldName = 'CodMov'
    end
    object tbFatForMvCodFatFor: TIntegerField
      FieldName = 'CodFatFor'
    end
    object tbFatForMvCodAlf: TStringField
      FieldName = 'CodAlf'
      Size = 3
    end
    object tbFatForMvCodNum: TIntegerField
      FieldName = 'CodNum'
    end
    object tbFatForMvQta: TFloatField
      FieldName = 'Qta'
    end
    object tbFatForMvImp: TCurrencyField
      FieldName = 'Imp'
    end
    object tbFatForMvElab: TBooleanField
      FieldName = 'Elab'
    end
  end
  object dsFatForMv: TDataSource
    DataSet = tbFatForMv
    OnDataChange = dsFatForMvDataChange
    Left = 330
    Top = 75
  end
  object flFatForMv: TJvDBFilter
    Active = True
    DataSource = dsFatForMv
    Filter.Strings = (
      'Elab='#39'false'#39)
    Left = 335
    Top = 85
  end
end
