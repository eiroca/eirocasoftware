object dmEditConConti: TdmEditConConti
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 202
  Width = 231
  object tbConConti: TZTable
    Connection = dmContabilita.dbContabilita
    Active = True
    TableName = 'ConConti'
    Left = 35
    Top = 10
    object tbConContiCodCon: TIntegerField
      FieldName = 'CodCon'
      ReadOnly = True
    end
    object tbConContiAlias: TWideStringField
      FieldName = 'Alias'
      Required = True
      Size = 12
    end
    object tbConContiDesc: TWideStringField
      FieldName = 'Desc'
      Required = True
      Size = 30
    end
    object tbConContiGruppo: TBooleanField
      FieldName = 'Gruppo'
      Required = True
    end
    object tbConContiTipiMovi: TSmallintField
      FieldName = 'TipiMovi'
      Required = True
    end
    object tbConContiLivDett: TSmallintField
      FieldName = 'LivDett'
      Required = True
    end
    object tbConContiNote: TWideMemoField
      FieldName = 'Note'
      BlobType = ftWideMemo
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
    object tbConContiTipiMoviDesc: TStringField
      FieldKind = fkLookup
      FieldName = 'TipiMoviDesc'
      LookupDataSet = tbSysCon_TipiMovi
      LookupKeyFields = 'TipiMovi'
      LookupResultField = 'Descrizione'
      KeyFields = 'TipiMovi'
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
    Active = True
    TableName = 'SysCon_TipiMovi'
    Left = 35
    Top = 60
  end
  object tbSysCon_LivDett: TZTable
    Connection = dmContabilita.dbContabilita
    Active = True
    TableName = 'SysCon_LivDett'
    Left = 35
    Top = 110
  end
end
