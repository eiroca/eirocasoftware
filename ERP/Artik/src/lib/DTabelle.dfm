object dmTabelle: TdmTabelle
  OldCreateOrder = True
  OnCreate = FormCreate
  Height = 206
  Width = 418
  object tbTabIVA: TTable
    DatabaseName = 'DB'
    TableName = 'TBCODIVA.DB'
    Left = 82
    Top = 13
    object tbTabIVACodIVA: TSmallintField
      FieldName = 'CodIVA'
    end
    object tbTabIVAAlq: TFloatField
      FieldName = 'Alq'
      Required = True
      DisplayFormat = '0.# %'
    end
    object tbTabIVADesc: TStringField
      FieldName = 'Desc'
      Size = 40
    end
  end
  object DBConnect: TDBConnectionLink
    Active = False
    OnConnect = DBConnectEvent
    OnDisconnect = DBConnectEvent
    Left = 18
    Top = 13
  end
  object tbTabUM: TTable
    DatabaseName = 'DB'
    TableName = 'TBCODMIS.DB'
    Left = 141
    Top = 13
    object tbTabUMCodMis: TSmallintField
      FieldName = 'CodMis'
    end
    object tbTabUMDesc: TStringField
      FieldName = 'Desc'
      Required = True
      Size = 10
    end
  end
end
