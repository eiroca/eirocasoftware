object dmEditConConti: TdmEditConConti
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 202
  Width = 231
  object tbConConti: TZTable
    Connection = dmContabilita.dbContabilita
    TableName = 'ConConti'
    Left = 35
    Top = 10
    object tbConContiAlias: TWideStringField
      FieldName = 'Alias'
      ReadOnly = True
      Size = 12
    end
    object tbConContiDesc: TWideStringField
      FieldName = 'Desc'
      ReadOnly = True
      Size = 30
    end
    object tbConContiGruppo: TBooleanField
      FieldName = 'Gruppo'
      ReadOnly = True
    end
    object tbConContiTipiMovi: TSmallintField
      FieldName = 'TipiMovi'
      ReadOnly = True
    end
    object tbConContiLivDett: TSmallintField
      FieldName = 'LivDett'
      ReadOnly = True
    end
    object tbConContiCodCon: TIntegerField
      FieldName = 'CodCon'
      ReadOnly = True
    end
    object tbConContiNote: TWideMemoField
      FieldName = 'Note'
      ReadOnly = True
      BlobType = ftWideMemo
    end
    object tbConContiTipiMoviDesc: TStringField
      FieldKind = fkLookup
      FieldName = 'TipiMoviDesc'
      LookupDataSet = tbSysCon_TipiMovi
      LookupKeyFields = 'TipiMovi'
      LookupResultField = 'Descrizione'
      KeyFields = 'TipiMovi'
      Size = 0
      Lookup = True
    end
    object tbConContiLivDettDesc: TStringField
      FieldKind = fkLookup
      FieldName = 'LivDettDesc'
      LookupDataSet = tbSysCon_LivDett
      LookupKeyFields = 'LivDett'
      LookupResultField = 'Descrizione'
      KeyFields = 'LivDett'
      Lookup = True
    end
  end
  object dsConConti: TDataSource
    DataSet = tbConConti
    Left = 151
    Top = 13
  end
  object tbSysCon_TipiMovi: TZTable
    Connection = dmContabilita.dbContabilita
    TableName = 'SysCon_TipiMovi'
    Left = 35
    Top = 60
  end
  object tbSysCon_LivDett: TZTable
    Connection = dmContabilita.dbContabilita
    TableName = 'SysCon_LivDett'
    Left = 35
    Top = 110
  end
end
