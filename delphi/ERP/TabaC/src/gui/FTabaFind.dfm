object fmTabaFind: TfmTabaFind
  Left = 226
  Top = 118
  ActiveControl = DBGrid1
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Ricerca tabacco'
  ClientHeight = 394
  ClientWidth = 381
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
  object Label1: TLabel
    Left = 9
    Top = 11
    Width = 51
    Height = 13
    Caption = 'Ricerca in:'
  end
  object Label2: TLabel
    Left = 12
    Top = 38
    Width = 36
    Height = 13
    Caption = 'il valore'
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 65
    Width = 381
    Height = 329
    Align = alBottom
    DataSource = dsTaba
    Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
  end
  object iSearch: TEdit
    Left = 65
    Top = 36
    Width = 206
    Height = 21
    TabOrder = 1
    OnChange = iSearchChange
    OnKeyPress = iSearchKeyPress
  end
  object cbOrder: TComboBox
    Left = 65
    Top = 8
    Width = 207
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    OnChange = cbOrderChange
  end
  object btOk: TBitBtn
    Left = 280
    Top = 5
    Width = 89
    Height = 25
    Caption = '&Ok'
    Kind = bkOK
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 3
    OnClick = btOkClick
  end
  object btCancel: TBitBtn
    Left = 280
    Top = 35
    Width = 89
    Height = 25
    Caption = '&Annulla'
    Kind = bkCancel
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 4
  end
  object tbTaba: TTable
    OnCalcFields = tbTabaCalcFields
    DatabaseName = 'DB'
    TableName = 'TABACCHI.DB'
    Left = 75
    Top = 90
    object tbTabaCODI: TSmallintField
      DisplayLabel = 'Codice'
      DisplayWidth = 6
      FieldName = 'CODI'
      Required = True
    end
    object tbTabaCODS: TStringField
      Alignment = taRightJustify
      DisplayLabel = 'Cod. Sig.'
      FieldName = 'CODS'
      Required = True
      Size = 4
    end
    object tbTabaDESC: TStringField
      DisplayLabel = 'Nome sigaretta'
      FieldName = 'DESC'
      Required = True
      Size = 30
    end
    object tbTabaPREZ: TCurrencyField
      DisplayLabel = 'Prezzo'
      DisplayWidth = 12
      FieldKind = fkCalculated
      FieldName = 'PREZ'
      Calculated = True
    end
    object tbTabaATTV: TBooleanField
      FieldName = 'ATTV'
      Visible = False
    end
  end
  object dsTaba: TDataSource
    DataSet = tbTaba
    Left = 85
    Top = 105
  end
  object rxFilter: TJvDBFilter
    DataSource = dsTaba
    OnFiltering = rxFilterFiltering
    Left = 95
    Top = 115
  end
end
