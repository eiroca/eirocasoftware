object fmPatOCons: TfmPatOCons
  Left = 255
  Top = 174
  ActiveControl = Panel1
  Caption = 'Inserimento consegne a Patentino'
  ClientHeight = 131
  ClientWidth = 506
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
    Width = 506
    Height = 37
    Align = alTop
    TabOrder = 0
    object iDataCons: TDateEdit
      Left = 145
      Top = 7
      Width = 91
      Height = 21
      NumGlyphs = 2
      TabOrder = 0
    end
    object btConsegna: TBitBtn
      Left = 10
      Top = 5
      Width = 131
      Height = 25
      Caption = 'Consegnato il'
      TabOrder = 1
      OnClick = btConsegnaClick
      Glyph.Data = {
        06020000424D0602000000000000760000002800000028000000140000000100
        0400000000009001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33333333333333333333333333333333333333333333333333FFFFFFFFFFFFFF
        FFFF370000000000000000733777777777777777777F30911F11111111111103
        37F7737777777777777F3099F0F999999999910337F337FF33333333377F309F
        000F99999999910337F3777FF3333333377F30F00F00F9999999910337F77377
        FF333333377F309FF9F00F999999910337F333377FF33333377F30999F9F00F9
        9999910337FFF3F3773FFFFFF77F3011F0F1FF1111111103377737F733777777
        777F309F000F99999999910337F3777FF3FFFFFFF77F30F00F00F11111111103
        37F77377F7777777777F309FF9F00F999999910337FFFFF77FF3FFFFF77F3011
        111F00F1111111033777777377377777777F30999999FF999999990337FFFFFF
        FFFFFFFFFF7F3700000000000000007337777777777777777773333330033333
        300333333333377FFFFFF77F3333333337000000007333333333377777777773
        3333333333333333333333333333333333333333333333333333333333333333
        33333333333333333333}
      Margin = 5
      NumGlyphs = 2
      Spacing = -1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 37
    Width = 506
    Height = 94
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'Panel2'
    TabOrder = 1
    object dgPatO: TDBGrid
      Left = 6
      Top = 6
      Width = 494
      Height = 82
      Align = alClient
      BorderStyle = bsNone
      DataSource = dsPatOLst
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = dgPatODblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'PatName'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DATAORDI'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DATAPREZ'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'KGC'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VAL'
          Title.Alignment = taCenter
          Visible = True
        end>
    end
  end
  object dsPatOLst: TDataSource
    DataSet = tbPatOLst
    Left = 162
    Top = 60
  end
  object tbPatOLst: TTable
    BeforeInsert = AbortOperation
    BeforeDelete = AbortOperation
    OnCalcFields = tbPatOLstCalcFields
    DatabaseName = 'DB'
    TableName = 'PACOLIST.DB'
    Left = 130
    Top = 60
    object tbPatOLstPPCO: TIntegerField
      FieldName = 'PPCO'
      Visible = False
    end
    object tbPatOLstPatName: TStringField
      DisplayLabel = 'Nome Patentino'
      DisplayWidth = 20
      FieldKind = fkCalculated
      FieldName = 'PatName'
      Size = 30
      Calculated = True
    end
    object tbPatOLstCODP: TIntegerField
      FieldName = 'CODP'
      Required = True
      Visible = False
    end
    object tbPatOLstDATA: TDateField
      FieldName = 'DATA'
      Visible = False
    end
    object tbPatOLstDATAORDI: TDateField
      Alignment = taRightJustify
      DisplayLabel = 'Data Richiesta'
      FieldName = 'DATAORDI'
      Required = True
    end
    object tbPatOLstDATAPREZ: TDateField
      Alignment = taRightJustify
      DisplayLabel = 'Data Prezzi'
      FieldName = 'DATAPREZ'
      Required = True
    end
    object tbPatOLstKGC: TFloatField
      DisplayLabel = 'Totale Richiesta (KgC)'
      FieldName = 'KGC'
      DisplayFormat = '0.00'
    end
    object tbPatOLstVAL: TCurrencyField
      DisplayLabel = 'Importo Richiesta'
      FieldName = 'VAL'
      Required = True
    end
  end
  object ftPatOLst: TRxDBFilter
    DataSource = dsPatOLst
    Filter.Strings = (
      'DATA = null')
    Left = 190
    Top = 61
  end
  object tbPatName: TTable
    DatabaseName = 'DB'
    TableName = 'PATENAME.DB'
    Left = 130
    Top = 92
    object tbPatNameCODP: TIntegerField
      FieldName = 'CODP'
    end
    object tbPatNameNOME: TStringField
      FieldName = 'NOME'
      Required = True
      Size = 30
    end
  end
end