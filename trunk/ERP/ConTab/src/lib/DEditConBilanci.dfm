object dmEditConBilanci: TdmEditConBilanci
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 335
  Width = 353
  object tbConBilanci: TADOTable
    Connection = dmContabilita.dbContabilita
    CursorType = ctStatic
    TableName = 'ConBilanci'
    Left = 40
    Top = 5
    object tbConBilanciCodBil: TAutoIncField
      FieldName = 'CodBil'
    end
    object tbConBilanciCodSch: TIntegerField
      FieldName = 'CodSch'
      Required = True
    end
    object tbConBilanciCodSchDett: TStringField
      FieldKind = fkLookup
      FieldName = 'CodSchDett'
      LookupDataSet = tbConSchemiBilancio
      LookupKeyFields = 'CodSch'
      LookupResultField = 'Desc'
      KeyFields = 'CodSch'
      Size = 30
      Lookup = True
    end
    object tbConBilanciAlias: TStringField
      FieldName = 'Alias'
      Required = True
      Size = 12
    end
    object tbConBilanciDesc: TStringField
      FieldName = 'Desc'
      Required = True
      Size = 30
    end
    object tbConBilanciData: TDateTimeField
      FieldName = 'Data'
      Required = True
    end
    object tbConBilanciNote: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
    end
    object tbConBilanciUfficiale: TBooleanField
      FieldName = 'Ufficiale'
    end
  end
  object tbConBilanciDett: TADOTable
    Connection = dmContabilita.dbContabilita
    CursorType = ctStatic
    IndexFieldNames = 'CodBil'
    MasterFields = 'CodBil'
    MasterSource = dsConBilanci
    TableName = 'ConBilanciDett'
    Left = 41
    Top = 55
    object tbConBilanciDettCodBil: TIntegerField
      FieldName = 'CodBil'
      Required = True
      Visible = False
    end
    object tbConBilanciDettCodCon: TIntegerField
      FieldName = 'CodCon'
      Required = True
      Visible = False
    end
    object tbConBilanciDettCodConDett: TStringField
      DisplayLabel = 'Codice Conto'
      FieldKind = fkLookup
      FieldName = 'CodConDett'
      LookupDataSet = tbConConti
      LookupKeyFields = 'CodCon'
      LookupResultField = 'Desc'
      KeyFields = 'CodCon'
      Size = 30
      Lookup = True
    end
    object tbConBilanciDettSaldo: TCurrencyField
      DisplayLabel = 'Saldo a bilancio'
      FieldName = 'Saldo'
      Required = True
    end
  end
  object dsConBilanci: TDataSource
    DataSet = tbConBilanci
    Left = 141
    Top = 3
  end
  object dsConBilanciDett: TDataSource
    DataSet = tbConBilanciDett
    Left = 143
    Top = 58
  end
  object tbConConti: TADOTable
    Connection = dmContabilita.dbContabilita
    CursorType = ctStatic
    TableName = 'ConConti'
    Left = 40
    Top = 115
  end
  object tbConSchemiBilancio: TADOTable
    Connection = dmContabilita.dbContabilita
    CursorType = ctStatic
    TableName = 'ConSchemiBilancio'
    Left = 40
    Top = 175
  end
end
