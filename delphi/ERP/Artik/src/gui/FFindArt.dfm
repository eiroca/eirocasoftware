object fmFindArti: TfmFindArti
  Left = 282
  Top = 128
  ActiveControl = DBGrid1
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Ricerca articolo'
  ClientHeight = 303
  ClientWidth = 470
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
  object Label1: TLabel
    Left = 9
    Top = 10
    Width = 76
    Height = 13
    Caption = 'Solo nel settore:'
  end
  object Label2: TLabel
    Left = 7
    Top = 38
    Width = 55
    Height = 13
    Caption = 'Descrizione'
  end
  object lbSet: TLabel
    Left = 155
    Top = 10
    Width = 24
    Height = 13
    Caption = 'lbSet'
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 70
    Width = 470
    Height = 233
    Align = alBottom
    DataSource = dsTaba
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
    Left = 75
    Top = 36
    Width = 176
    Height = 21
    TabOrder = 0
    OnChange = iSearchChange
    OnKeyPress = iSearchKeyPress
  end
  object btOk: TBitBtn
    Left = 385
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
    Left = 385
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
    Left = 260
    Top = 35
    Width = 89
    Height = 25
    Caption = 'Cerca meglio'
    TabOrder = 4
    OnClick = BitBtn1Click
  end
  object iSet: TJvComboEdit
    Left = 95
    Top = 5
    Width = 51
    Height = 21
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
    MaxLength = 3
    TabOrder = 5
    Text = 'ZZZ'
    OnButtonClick = iSetButtonClick
    OnChange = iSetChange
    OnKeyPress = iSetKeyPress
  end
  object tbArtic: TTable
    DatabaseName = 'DB'
    TableName = 'ARTICOLI.DB'
    Left = 75
    Top = 90
    object tbArticCodAlf: TStringField
      DisplayLabel = 'Set.'
      DisplayWidth = 4
      FieldName = 'CodAlf'
      Size = 3
    end
    object tbArticCodNum: TSmallintField
      DisplayLabel = 'ID'
      DisplayWidth = 4
      FieldName = 'CodNum'
    end
    object tbArticDesc: TStringField
      DisplayLabel = 'Descrizione'
      DisplayWidth = 30
      FieldName = 'Desc'
      Size = 30
    end
    object tbArticAttv: TBooleanField
      FieldName = 'Attv'
      Visible = False
    end
    object tbArticPrzLis: TCurrencyField
      DisplayLabel = 'Listino'
      DisplayWidth = 10
      FieldName = 'PrzLis'
    end
    object tbArticPrzNor: TCurrencyField
      DisplayLabel = 'Prezzo'
      DisplayWidth = 10
      FieldName = 'PrzNor'
    end
    object tbArticPrzSpe: TCurrencyField
      DisplayLabel = 'Speciale'
      DisplayWidth = 10
      FieldName = 'PrzSpe'
    end
  end
  object dsTaba: TDataSource
    DataSet = tbArtic
    Left = 85
    Top = 105
  end
  object rxFilter: TJvDBFilter
    DataSource = dsTaba
    OnFiltering = rxFilterFiltering
    Left = 95
    Top = 115
  end
  object qrArtic: TQuery
    DatabaseName = 'DB'
    SQL.Strings = (
      'select CodAlf, CodNum, A."Desc"'
      '  from "articoli.db" A'
      '  where A."Desc" like :ADesc')
    Left = 195
    Top = 140
    ParamData = <
      item
        DataType = ftString
        Name = 'ADesc'
        ParamType = ptUnknown
        Value = '%'
      end>
    object qrArticCodAlf: TStringField
      FieldName = 'CodAlf'
      Size = 3
    end
    object qrArticCodNum: TSmallintField
      FieldName = 'CodNum'
    end
    object qrArticDesc: TStringField
      FieldName = 'Desc'
      Size = 30
    end
  end
end
