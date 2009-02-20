object dmEditConSchemiBilancio: TdmEditConSchemiBilancio
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 335
  Width = 353
  object tbConSchemiBilancio: TADOTable
    Connection = dmContabilita.dbContabilita
    TableName = 'ConSchemiBilancio'
    Left = 40
    Top = 5
    object tbConSchemiBilancioCodSch: TAutoIncField
      FieldName = 'CodSch'
      ReadOnly = True
    end
    object tbConSchemiBilancioAlias: TStringField
      FieldName = 'Alias'
      Required = True
      Size = 12
    end
    object tbConSchemiBilancioDesc: TStringField
      FieldName = 'Desc'
      Required = True
      Size = 30
    end
    object tbConSchemiBilancioNote: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
    end
  end
  object tbConSchemiBilancioDett: TADOTable
    Connection = dmContabilita.dbContabilita
    IndexFieldNames = 'CodSch'
    MasterFields = 'CodSch'
    MasterSource = dsConSchemiBilancio
    TableName = 'ConSchemiBilancioDett'
    Left = 41
    Top = 55
    object tbConSchemiBilancioDettCodSch: TIntegerField
      DisplayLabel = 'Codice Schema'
      FieldName = 'CodSch'
      Required = True
      Visible = False
    end
    object tbConSchemiBilancioDettCodCon: TIntegerField
      DisplayLabel = 'Codice Conto'
      FieldName = 'CodCon'
      Required = True
      Visible = False
    end
    object tbConSchemiBilancioDettParent: TIntegerField
      DisplayLabel = 'Conto di aggregazione'
      FieldName = 'Parent'
      Visible = False
    end
    object tbConSchemiBilancioDettParentDett: TStringField
      DisplayLabel = 'Aggrega a'
      DisplayWidth = 23
      FieldKind = fkLookup
      FieldName = 'ParentDett'
      LookupDataSet = tbConConti
      LookupKeyFields = 'CodCon'
      LookupResultField = 'Desc'
      KeyFields = 'Parent'
      Size = 30
      Lookup = True
    end
    object tbConSchemiBilancioDettCodConDett: TStringField
      DisplayLabel = 'Codice Conto'
      DisplayWidth = 17
      FieldKind = fkLookup
      FieldName = 'CodConDett'
      LookupDataSet = tbConConti
      LookupKeyFields = 'CodCon'
      LookupResultField = 'Desc'
      KeyFields = 'CodCon'
      Size = 30
      Lookup = True
    end
    object tbConSchemiBilancioDettOrder: TIntegerField
      DisplayLabel = 'Ordine'
      DisplayWidth = 7
      FieldName = 'Order'
    end
    object tbConSchemiBilancioDettPosizioneDett: TStringField
      DisplayLabel = 'Posizionamento'
      DisplayWidth = 17
      FieldKind = fkLookup
      FieldName = 'PosizioneDett'
      LookupDataSet = tbSysCon_Posizione
      LookupKeyFields = 'Posizione'
      LookupResultField = 'Descrizione'
      KeyFields = 'Posizione'
      Size = 30
      Lookup = True
    end
    object tbConSchemiBilancioDettPosizione: TIntegerField
      FieldName = 'Posizione'
      Visible = False
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
  object tbConConti: TADOTable
    Connection = dmContabilita.dbContabilita
    TableName = 'ConConti'
    Left = 40
    Top = 165
  end
  object tbSysCon_Posizione: TADOTable
    Connection = dmContabilita.dbContabilita
    TableName = 'SysCon_Posizione'
    Left = 40
    Top = 115
  end
end
