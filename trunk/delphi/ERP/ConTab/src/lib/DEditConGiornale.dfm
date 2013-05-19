object dmEditConGiornale: TdmEditConGiornale
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 335
  Width = 353
  object tbConGiornale: TZTable
    Connection = dmContabilita.dbContabilita
    TableName = 'ConGiornale'
    Left = 40
    Top = 5
    object tbConGiornaleCodScr: TIntegerField
      FieldName = 'CodScr'
      ReadOnly = True
    end
    object tbConGiornaleDataScr: TDateField
      FieldName = 'DataScr'
      ReadOnly = True
    end
    object tbConGiornaleDataOpe: TDateField
      FieldName = 'DataOpe'
      ReadOnly = True
    end
    object tbConGiornaleDesc: TWideStringField
      FieldName = 'Desc'
      ReadOnly = True
      Size = 40
    end
    object tbConGiornaleTipoScr: TSmallintField
      FieldName = 'TipoScr'
      ReadOnly = True
    end
    object tbConGiornaleUfficiale: TBooleanField
      FieldName = 'Ufficiale'
      ReadOnly = True
    end
  end
  object tbConGiornaleDett: TZTable
    Connection = dmContabilita.dbContabilita
    SortedFields = 'CodScr'
    TableName = 'ConGiornaleDett'
    MasterFields = 'CodScr'
    MasterSource = dsConGiornale
    IndexFieldNames = 'CodScr Asc'
    Left = 41
    Top = 55
    object tbConGiornaleDettCodScr: TIntegerField
      FieldName = 'CodScr'
      ReadOnly = True
    end
    object tbConGiornaleDettCodCon: TIntegerField
      FieldName = 'CodCon'
      ReadOnly = True
    end
    object tbConGiornaleDettImporto: TFloatField
      FieldName = 'Importo'
      ReadOnly = True
    end
  end
  object dsConGiornale: TDataSource
    DataSet = tbConGiornale
    Left = 141
    Top = 3
  end
  object dsConGiornaleDett: TDataSource
    DataSet = tbConGiornaleDett
    Left = 143
    Top = 58
  end
  object tbConConti: TZTable
    Connection = dmContabilita.dbContabilita
    TableName = 'ConConti'
    Left = 40
    Top = 115
    object tbConContiCodCon: TIntegerField
      FieldName = 'CodCon'
      ReadOnly = True
    end
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
    object tbConContiNote: TWideMemoField
      FieldName = 'Note'
      ReadOnly = True
      BlobType = ftWideMemo
    end
  end
end
