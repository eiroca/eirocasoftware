object dmEditConSchemiBilancio: TdmEditConSchemiBilancio
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 335
  Width = 353
  object tbConSchemiBilancio: TZTable
    Connection = dmContabilita.dbContabilita
    TableName = 'ConSchemiBilancio'
    Left = 40
    Top = 5
    object tbConSchemiBilancioCodSch: TIntegerField
      FieldName = 'CodSch'
      ReadOnly = True
    end
    object tbConSchemiBilancioAlias: TWideStringField
      FieldName = 'Alias'
      ReadOnly = True
      Size = 12
    end
    object tbConSchemiBilancioDesc: TWideStringField
      FieldName = 'Desc'
      ReadOnly = True
      Size = 30
    end
    object tbConSchemiBilancioNote: TWideMemoField
      FieldName = 'Note'
      ReadOnly = True
      BlobType = ftWideMemo
    end
  end
  object tbConSchemiBilancioDett: TZTable
    Connection = dmContabilita.dbContabilita
    SortedFields = 'CodSch'
    TableName = 'ConSchemiBilancioDett'
    MasterFields = 'CodSch'
    MasterSource = dsConSchemiBilancio
    IndexFieldNames = 'CodSch Asc'
    Left = 41
    Top = 55
    object tbConSchemiBilancioDettCodSch: TIntegerField
      FieldName = 'CodSch'
      ReadOnly = True
    end
    object tbConSchemiBilancioDettCodCon: TIntegerField
      FieldName = 'CodCon'
      ReadOnly = True
    end
    object tbConSchemiBilancioDettParent: TIntegerField
      FieldName = 'Parent'
      ReadOnly = True
    end
    object tbConSchemiBilancioDettOrder: TIntegerField
      FieldName = 'Order'
      ReadOnly = True
    end
    object tbConSchemiBilancioDettPosizione: TSmallintField
      FieldName = 'Posizione'
      ReadOnly = True
    end
  end
  object dsConSchemiBilancio: TDataSource
    DataSet = tbConSchemiBilancio
    Left = 166
    Top = 3
  end
  object dsConSchemiBilancioDett: TDataSource
    DataSet = tbConSchemiBilancioDett
    Left = 168
    Top = 53
  end
  object tbConConti: TZTable
    Connection = dmContabilita.dbContabilita
    TableName = 'ConConti'
    Left = 40
    Top = 165
  end
  object tbSysCon_Posizione: TZTable
    Connection = dmContabilita.dbContabilita
    TableName = 'SysCon_Posizione'
    Left = 40
    Top = 115
  end
end
