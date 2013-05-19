object dmEditConBilanci: TdmEditConBilanci
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 335
  Width = 353
  object tbConBilanci: TZTable
    Connection = dmContabilita.dbContabilita
    TableName = 'ConBilanci'
    Left = 40
    Top = 5
    object tbConBilanciCodBil: TIntegerField
      FieldName = 'CodBil'
      ReadOnly = True
    end
    object tbConBilanciCodSch: TIntegerField
      FieldName = 'CodSch'
      ReadOnly = True
    end
    object tbConBilanciAlias: TWideStringField
      FieldName = 'Alias'
      ReadOnly = True
      Size = 12
    end
    object tbConBilanciDesc: TWideStringField
      FieldName = 'Desc'
      ReadOnly = True
      Size = 30
    end
    object tbConBilanciData: TDateField
      FieldName = 'Data'
      ReadOnly = True
    end
    object tbConBilanciNote: TWideMemoField
      FieldName = 'Note'
      ReadOnly = True
      BlobType = ftWideMemo
    end
    object tbConBilanciUfficiale: TBooleanField
      FieldName = 'Ufficiale'
      ReadOnly = True
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
    TableName = 'ConBilanciDett'
    MasterFields = 'CodBil'
    MasterSource = dsConBilanci
    IndexFieldNames = 'CodBil Asc'
    Left = 41
    Top = 55
    object tbConBilanciDettCodBil: TIntegerField
      FieldName = 'CodBil'
      ReadOnly = True
    end
    object tbConBilanciDettCodCon: TIntegerField
      FieldName = 'CodCon'
      ReadOnly = True
    end
    object tbConBilanciDettSaldo: TFloatField
      FieldName = 'Saldo'
      ReadOnly = True
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
    TableName = 'ConConti'
    Left = 40
    Top = 115
  end
  object tbConSchemiBilancio: TZTable
    Connection = dmContabilita.dbContabilita
    TableName = 'ConSchemiBilancio'
    Left = 40
    Top = 175
  end
end
