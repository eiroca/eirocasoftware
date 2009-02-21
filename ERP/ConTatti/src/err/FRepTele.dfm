object repElencoTelefono: TrepElencoTelefono
  Left = 267
  Top = 176
  Caption = 'repElencoTelefono'
  ClientHeight = 96
  ClientWidth = 209
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object tbTelef: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'TELEF.DB'
    Left = 110
    Top = 10
    object tbTelefCodTel: TIntegerField
      FieldName = 'CodTel'
    end
    object tbTelefCodCon: TIntegerField
      FieldName = 'CodCon'
    end
    object tbTelefTipo: TIntegerField
      FieldName = 'Tipo'
    end
    object tbTelefTel_Pre1: TStringField
      FieldName = 'Tel_Pre1'
      Size = 6
    end
    object tbTelefTel_Pre2: TStringField
      FieldName = 'Tel_Pre2'
      Size = 6
    end
    object tbTelefTelefono: TStringField
      FieldName = 'Telefono'
      Size = 18
    end
    object tbTelefNote: TStringField
      FieldName = 'Note'
      Size = 40
    end
  end
  object tbContat: TTable
    DatabaseName = 'DB'
    TableName = 'CONTAT.DB'
    Left = 75
    Top = 10
  end
  object dsContat: TDataSource
    DataSet = tbContat
    Left = 145
    Top = 10
  end
  object Rep: TeLineReport
    AutoCR = False
    PageHeight = 66
    PageWidth = 132
    HeaderSize = 5
    FooterSize = 2
    DeviceKind = '<<no device>>'
    OnPageHeader = RepPageHeader
    OnPageFooter = RepPageFooter
    Left = 5
    Top = 15
  end
  object LF: TeLineFields
    Report = Rep
    Left = 15
    Top = 25
    FieldDefs = 288
     = (
      5
      1
      7
      40
      0
      48
      20
      1
      69
      30
      0)
  end
end
