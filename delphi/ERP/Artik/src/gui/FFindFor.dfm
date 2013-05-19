object fmFindFor: TfmFindFor
  Left = 282
  Top = 128
  ActiveControl = DBGrid1
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Ricerca fornitore'
  ClientHeight = 303
  ClientWidth = 354
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
  object Label2: TLabel
    Left = 12
    Top = 8
    Width = 69
    Height = 13
    Caption = 'Nome fornitore'
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 70
    Width = 354
    Height = 233
    Align = alBottom
    DataSource = dsFornitori
    Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
  end
  object iSearch: TEdit
    Left = 85
    Top = 6
    Width = 176
    Height = 21
    TabOrder = 0
    OnChange = iSearchChange
    OnKeyPress = iSearchKeyPress
  end
  object btOk: TBitBtn
    Left = 270
    Top = 5
    Width = 75
    Height = 25
    Caption = '&Ok'
    Kind = bkOK
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 2
    OnClick = btOkClick
  end
  object btCancel: TBitBtn
    Left = 270
    Top = 35
    Width = 75
    Height = 25
    Caption = '&Annulla'
    Kind = bkCancel
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 3
  end
  object BitBtn1: TBitBtn
    Left = 10
    Top = 35
    Width = 89
    Height = 25
    Caption = 'Cerca meglio'
    TabOrder = 4
    OnClick = BitBtn1Click
  end
  object cbPotenziali: TCheckBox
    Left = 105
    Top = 40
    Width = 156
    Height = 17
    Caption = 'Cerca anche nei potenziali'
    TabOrder = 5
    OnClick = cbPotenzialiClick
  end
  object tbFornitori: TTable
    DatabaseName = 'DB'
    TableName = 'FORNIT.DB'
    Left = 75
    Top = 90
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
    Left = 85
    Top = 105
  end
  object rxFilter: TJvDBFilter
    DataSource = dsFornitori
    OnFiltering = rxFilterFiltering
    Left = 95
    Top = 115
  end
  object qrArtic: TQuery
    DatabaseName = 'DB'
    SQL.Strings = (
      'select CodFor, A."Nome"'
      '  from "Fornit.db" A'
      '  where A."Nome" like :ADesc')
    Left = 195
    Top = 140
    ParamData = <
      item
        DataType = ftString
        Name = 'ADesc'
        ParamType = ptUnknown
        Value = '%'
      end>
    object qrArticCodFor: TIntegerField
      FieldName = 'CodFor'
    end
    object qrArticNome: TStringField
      FieldName = 'Nome'
      Size = 30
    end
  end
end
