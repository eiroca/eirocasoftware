object dmEditConBilanci: TdmEditConBilanci
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 335
  Width = 353
  object tbConBilanci: TZTable
    Connection = dmContabilita.dbContabilita
    Active = True
    TableName = 'ConBilanci'
    Left = 40
    Top = 5
    object tbConBilanciCodBil: TIntegerField
      FieldName = 'CodBil'
      ReadOnly = True
    end
    object tbConBilanciCodSch: TIntegerField
      FieldName = 'CodSch'
      Required = True
    end
    object tbConBilanciAlias: TWideStringField
      FieldName = 'Alias'
      Required = True
      Size = 12
    end
    object tbConBilanciDesc: TWideStringField
      FieldName = 'Desc'
      Required = True
      Size = 30
    end
    object tbConBilanciData: TDateField
      FieldName = 'Data'
      Required = True
    end
    object tbConBilanciNote: TWideMemoField
      FieldName = 'Note'
      BlobType = ftWideMemo
    end
    object tbConBilanciUfficiale: TBooleanField
      FieldName = 'Ufficiale'
      Required = True
    end
    object tbConBilanciCodSchDett: TStringField
      FieldKind = fkLookup
      FieldName = 'CodSchDett'
      LookupDataSet = tbConSchemiBilancio
      LookupKeyFields = 'CodSch'
      LookupResultField = 'Desc'
      KeyFields = 'CodSch'
      Lookup = True
    end
  end
  object tbConBilanciDett: TZTable
    Connection = dmContabilita.dbContabilita
    SortedFields = 'CodBil'
    Active = True
    TableName = 'ConBilanciDett'
    MasterFields = 'CodBil'
    MasterSource = dsConBilanci
    IndexFieldNames = 'CodBil Asc'
    Left = 41
    Top = 55
    object tbConBilanciDettCodBil: TIntegerField
      FieldName = 'CodBil'
      Required = True
    end
    object tbConBilanciDettCodCon: TIntegerField
      FieldName = 'CodCon'
      Required = True
    end
    object tbConBilanciDettSaldo: TCurrencyField
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
  object tbConConti: TZTable
    Connection = dmContabilita.dbContabilita
    Active = True
    TableName = 'ConConti'
    Left = 40
    Top = 115
  end
  object tbConSchemiBilancio: TZTable
    Connection = dmContabilita.dbContabilita
    Active = True
    TableName = 'ConSchemiBilancio'
    Left = 40
    Top = 175
  end
end
