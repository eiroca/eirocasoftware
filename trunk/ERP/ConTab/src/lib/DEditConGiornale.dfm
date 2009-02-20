object dmEditConGiornale: TdmEditConGiornale
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 335
  Width = 353
  object tbConGiornale: TADOTable
    Connection = dmContabilita.dbContabilita
    TableName = 'ConGiornale'
    Left = 40
    Top = 5
    object tbConGiornaleCodScr: TAutoIncField
      FieldName = 'CodScr'
    end
    object tbConGiornaleDataScr: TDateTimeField
      FieldName = 'DataScr'
      Required = True
    end
    object tbConGiornaleDataOpe: TDateTimeField
      FieldName = 'DataOpe'
      Required = True
    end
    object tbConGiornaleDesc: TStringField
      FieldName = 'Desc'
      Required = True
      Size = 40
    end
    object tbConGiornaleUfficiale: TBooleanField
      FieldName = 'Ufficiale'
      Required = True
    end
  end
  object tbConGiornaleDett: TADOTable
    Connection = dmContabilita.dbContabilita
    IndexFieldNames = 'CodScr'
    MasterFields = 'CodScr'
    MasterSource = dsConGiornale
    TableName = 'ConGiornaleDett'
    Left = 41
    Top = 55
    object tbConGiornaleDettCodScr: TIntegerField
      FieldName = 'CodScr'
      Required = True
      Visible = False
    end
    object tbConGiornaleDettCodCon: TIntegerField
      FieldName = 'CodCon'
      Required = True
      Visible = False
    end
    object tbConGiornaleDettCodConDett: TStringField
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
  object tbConConti: TADOTable
    Connection = dmContabilita.dbContabilita
    TableName = 'ConConti'
    Left = 40
    Top = 115
  end
end
