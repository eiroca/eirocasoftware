object dmEditConGiornale: TdmEditConGiornale
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 335
  Width = 353
  object tbConGiornale: TZTable
    Connection = dmContabilita.dbContabilita
    Active = True
    TableName = 'ConGiornale'
    Left = 40
    Top = 5
    object tbConGiornaleCodScr: TIntegerField
      FieldName = 'CodScr'
      ReadOnly = True
    end
    object tbConGiornaleDataScr: TDateField
      FieldName = 'DataScr'
      Required = True
    end
    object tbConGiornaleDataOpe: TDateField
      FieldName = 'DataOpe'
      Required = True
    end
    object tbConGiornaleDesc: TWideStringField
      FieldName = 'Desc'
      Required = True
      Size = 40
    end
    object tbConGiornaleTipoScr: TSmallintField
      FieldName = 'TipoScr'
    end
    object tbConGiornaleUfficiale: TBooleanField
      FieldName = 'Ufficiale'
      Required = True
    end
  end
  object tbConGiornaleDett: TZTable
    Connection = dmContabilita.dbContabilita
    SortedFields = 'CodScr'
    Active = True
    TableName = 'ConGiornaleDett'
    MasterFields = 'CodScr'
    MasterSource = dsConGiornale
    IndexFieldNames = 'CodScr Asc'
    Left = 41
    Top = 55
    object tbConGiornaleDettCodScr: TIntegerField
      FieldName = 'CodScr'
      Required = True
    end
    object tbConGiornaleDettCodCon: TIntegerField
      FieldName = 'CodCon'
      Required = True
    end
    object tbConGiornaleDettImporto: TCurrencyField
      FieldName = 'Importo'
      Required = True
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
    Active = True
    TableName = 'ConConti'
    Left = 40
    Top = 115
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
  end
end
