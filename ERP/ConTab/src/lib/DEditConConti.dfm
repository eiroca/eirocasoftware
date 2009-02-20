object dmEditConConti: TdmEditConConti
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 202
  Width = 231
  object tbConConti: TADOTable
    Connection = dmContabilita.dbContabilita
    TableName = 'ConConti'
    Left = 35
    Top = 10
    object tbConContiCodCon: TAutoIncField
      DisplayLabel = 'Codice'
      FieldName = 'CodCon'
      ReadOnly = True
      Visible = False
    end
    object tbConContiAlias: TStringField
      DisplayLabel = 'Codice conto'
      FieldName = 'Alias'
      Required = True
      Size = 12
    end
    object tbConContiDesc: TStringField
      DisplayLabel = 'Descrizione Conto'
      FieldName = 'Desc'
      Required = True
      Size = 30
    end
    object tbConContiGruppo: TBooleanField
      DisplayLabel = 'Aggregato?'
      FieldName = 'Gruppo'
      Required = True
      DisplayValues = 'Si;No'
    end
    object tbConContiTipiMovi: TSmallintField
      DisplayLabel = 'Tipo Movimenti'
      FieldName = 'TipiMovi'
      Required = True
      Visible = False
    end
    object tbConContiLivDett: TSmallintField
      DisplayLabel = 'Livello dettaglio'
      FieldName = 'LivDett'
      Required = True
      Visible = False
    end
    object tbConContiTipiMoviDesc: TStringField
      DisplayLabel = 'Tipo movimenti'
      FieldKind = fkLookup
      FieldName = 'TipiMoviDesc'
      LookupDataSet = tbSysCon_TipiMovi
      LookupKeyFields = 'TipiMovi'
      LookupResultField = 'Descrizione'
      KeyFields = 'TipiMovi'
      Size = 30
      Lookup = True
    end
    object tbConContiLivDettDesc: TStringField
      DisplayLabel = 'Livello dettaglio'
      FieldKind = fkLookup
      FieldName = 'LivDettDesc'
      LookupDataSet = tbSysCon_LivDett
      LookupKeyFields = 'LivDett'
      LookupResultField = 'Descrizione'
      KeyFields = 'LivDett'
      Size = 30
      Lookup = True
    end
    object tbConContiNote: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
    end
  end
  object dsConConti: TDataSource
    DataSet = tbConConti
    Left = 151
    Top = 13
  end
  object tbSysCon_TipiMovi: TADOTable
    Connection = dmContabilita.dbContabilita
    TableName = 'SysCon_TipiMovi'
    Left = 35
    Top = 60
  end
  object tbSysCon_LivDett: TADOTable
    Connection = dmContabilita.dbContabilita
    TableName = 'SysCon_LivDett'
    Left = 35
    Top = 110
  end
end
