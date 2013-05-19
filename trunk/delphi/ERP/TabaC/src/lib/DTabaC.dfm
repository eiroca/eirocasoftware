object dmTaba: TdmTaba
  OldCreateOrder = True
  OnCreate = DataModule1Create
  OnDestroy = DataModule1Destroy
  Height = 340
  Width = 462
  object tbTaba: TTable
    DatabaseName = 'DB'
    TableName = 'TABACCHI.DB'
    Left = 20
    Top = 5
    object tbTabaCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbTabaCODS: TStringField
      FieldName = 'CODS'
      Required = True
      Size = 4
    end
    object tbTabaTIPO: TSmallintField
      FieldName = 'TIPO'
    end
    object tbTabaPROD: TSmallintField
      FieldName = 'PROD'
    end
    object tbTabaCRIT: TSmallintField
      FieldName = 'CRIT'
    end
    object tbTabaDESC: TStringField
      FieldName = 'DESC'
      Required = True
      Size = 30
    end
    object tbTabaATTV: TBooleanField
      FieldName = 'ATTV'
    end
    object tbTabaMULI: TSmallintField
      FieldName = 'MULI'
    end
    object tbTabaQTAS: TSmallintField
      FieldName = 'QTAS'
    end
    object tbTabaQTAC: TSmallintField
      FieldName = 'QTAC'
    end
    object tbTabaQTAM: TSmallintField
      FieldName = 'QTAM'
    end
    object tbTabaDIFR: TSmallintField
      FieldName = 'DIFR'
    end
  end
  object tbDateGiac: TTable
    DatabaseName = 'DB'
    TableName = 'GIACLIST.DB'
    Left = 155
    Top = 95
    object tbDateGiacPGIA: TIntegerField
      FieldName = 'PGIA'
    end
    object tbDateGiacDATA: TDateField
      FieldName = 'DATA'
      Required = True
    end
  end
  object tbDatePrez: TTable
    DatabaseName = 'DB'
    TableName = 'PREZLIST.DB'
    Left = 155
    Top = 5
    object tbDatePrezPPRE: TIntegerField
      FieldName = 'PPRE'
    end
    object tbDatePrezDATA: TDateField
      FieldName = 'DATA'
      Required = True
    end
    object tbDatePrezDESC: TStringField
      FieldName = 'DESC'
      Size = 40
    end
  end
  object tbPrez: TTable
    DatabaseName = 'DB'
    TableName = 'PREZMOVS.DB'
    Left = 20
    Top = 55
    object tbPrezPPRE: TIntegerField
      FieldName = 'PPRE'
      Required = True
    end
    object tbPrezCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbPrezPREZ: TCurrencyField
      FieldName = 'PREZ'
      Required = True
    end
  end
  object tbDateCari: TTable
    DatabaseName = 'DB'
    TableName = 'CARILIST.DB'
    Left = 155
    Top = 50
    object tbDateCariPCAR: TIntegerField
      FieldName = 'PCAR'
    end
    object tbDateCariDATA: TDateField
      FieldName = 'DATA'
    end
    object tbDateCariDATAORDI: TDateField
      FieldName = 'DATAORDI'
      Required = True
    end
  end
  object tbDatePatC: TTable
    DatabaseName = 'DB'
    TableName = 'PACOLIST.DB'
    Left = 155
    Top = 140
    object tbDatePatCPPCO: TIntegerField
      FieldName = 'PPCO'
    end
    object tbDatePatCDATA: TDateField
      FieldName = 'DATA'
    end
    object tbDatePatCDATAORDI: TDateField
      FieldName = 'DATAORDI'
      Required = True
    end
  end
  object tbMedie: TTable
    DatabaseName = 'DB'
    TableName = 'TABASTAT.DB'
    Left = 20
    Top = 105
    object tbMedieCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbMedieMEDA: TFloatField
      FieldName = 'MEDA'
    end
    object tbMedieMAXA: TFloatField
      FieldName = 'MAXA'
    end
    object tbMedieMED5: TFloatField
      FieldName = 'MED5'
    end
    object tbMedieMAX5: TFloatField
      FieldName = 'MAX5'
    end
    object tbMedieMED0: TFloatField
      FieldName = 'MED0'
    end
    object tbMedieMAX0: TFloatField
      FieldName = 'MAX0'
    end
  end
  object tbCariDate: TTable
    DatabaseName = 'DB'
    TableName = 'CARILIST.DB'
    Left = 250
    Top = 65
    object tbCariDatePCAR: TIntegerField
      FieldName = 'PCAR'
    end
    object tbCariDateDATA: TDateField
      FieldName = 'DATA'
    end
    object tbCariDateDATAORDI: TDateField
      FieldName = 'DATAORDI'
      Required = True
    end
    object tbCariDateDATAPREZ: TDateField
      FieldName = 'DATAPREZ'
      Required = True
    end
    object tbCariDateKGC: TFloatField
      FieldName = 'KGC'
    end
    object tbCariDateVAL: TCurrencyField
      FieldName = 'VAL'
    end
  end
  object tbCariMov: TTable
    DatabaseName = 'DB'
    TableName = 'CARIMOVS.DB'
    Left = 310
    Top = 65
    object tbCariMovPCAR: TIntegerField
      FieldName = 'PCAR'
      Required = True
    end
    object tbCariMovCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbCariMovCARI: TIntegerField
      FieldName = 'CARI'
      Required = True
    end
  end
  object tbGiacDate: TTable
    DatabaseName = 'DB'
    TableName = 'GIACLIST.DB'
    Left = 250
    Top = 10
    object tbGiacDatePGIA: TIntegerField
      FieldName = 'PGIA'
    end
    object tbGiacDateDATA: TDateField
      FieldName = 'DATA'
      Required = True
    end
    object tbGiacDateDATAPREZ: TDateField
      FieldName = 'DATAPREZ'
      Required = True
    end
    object tbGiacDateKGC: TFloatField
      FieldName = 'KGC'
    end
    object tbGiacDateVAL: TCurrencyField
      FieldName = 'VAL'
    end
  end
  object tbGiacMov: TTable
    DatabaseName = 'DB'
    TableName = 'GIACMOVS.DB'
    Left = 310
    Top = 10
    object tbGiacMovPGIA: TIntegerField
      FieldName = 'PGIA'
      Required = True
    end
    object tbGiacMovCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbGiacMovGIAC: TIntegerField
      FieldName = 'GIAC'
      Required = True
    end
  end
  object tbOrdiDate: TTable
    DatabaseName = 'DB'
    TableName = 'CARILIST.DB'
    Left = 250
    Top = 125
    object tbOrdiDatePCAR: TIntegerField
      FieldName = 'PCAR'
    end
    object tbOrdiDateDATA: TDateField
      FieldName = 'DATA'
    end
    object tbOrdiDateDATAORDI: TDateField
      FieldName = 'DATAORDI'
      Required = True
    end
    object tbOrdiDateDATAPREZ: TDateField
      FieldName = 'DATAPREZ'
      Required = True
    end
    object tbOrdiDateKGC: TFloatField
      FieldName = 'KGC'
    end
    object tbOrdiDateVAL: TCurrencyField
      FieldName = 'VAL'
    end
  end
  object tbOrdiMov: TTable
    DatabaseName = 'DB'
    TableName = 'CARIMOVS.DB'
    Left = 310
    Top = 125
    object tbOrdiMovPCAR: TIntegerField
      FieldName = 'PCAR'
      Required = True
    end
    object tbOrdiMovCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbOrdiMovCARI: TIntegerField
      FieldName = 'CARI'
      Required = True
    end
  end
  object tbPatOMov: TTable
    DatabaseName = 'DB'
    TableName = 'PACOMOVS.DB'
    Left = 310
    Top = 185
    object tbPatOMovPPCO: TIntegerField
      FieldName = 'PPCO'
      Required = True
    end
    object tbPatOMovCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbPatOMovCONS: TIntegerField
      FieldName = 'CONS'
      Required = True
    end
  end
  object tbPatODate: TTable
    DatabaseName = 'DB'
    TableName = 'PACOLIST.DB'
    Left = 250
    Top = 185
    object tbPatODatePPCO: TIntegerField
      FieldName = 'PPCO'
    end
    object tbPatODateCODP: TIntegerField
      FieldName = 'CODP'
      Required = True
    end
    object tbPatODateDATA: TDateField
      FieldName = 'DATA'
    end
    object tbPatODateDATAORDI: TDateField
      FieldName = 'DATAORDI'
      Required = True
    end
    object tbPatODateDATAPREZ: TDateField
      FieldName = 'DATAPREZ'
      Required = True
    end
    object tbPatODateKGC: TFloatField
      FieldName = 'KGC'
    end
    object tbPatODateVAL: TCurrencyField
      FieldName = 'VAL'
      Required = True
    end
  end
  object tbPatCMov: TTable
    DatabaseName = 'DB'
    TableName = 'PACOMOVS.DB'
    Left = 310
    Top = 230
    object tbPatCMovPPCO: TIntegerField
      FieldName = 'PPCO'
      Required = True
    end
    object tbPatCMovCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbPatCMovCONS: TIntegerField
      FieldName = 'CONS'
      Required = True
    end
  end
  object tbPatCDate: TTable
    DatabaseName = 'DB'
    TableName = 'PACOLIST.DB'
    Left = 250
    Top = 230
    object tbPatCDatePPCO: TIntegerField
      FieldName = 'PPCO'
    end
    object tbPatCDateCODP: TIntegerField
      FieldName = 'CODP'
      Required = True
    end
    object tbPatCDateDATA: TDateField
      FieldName = 'DATA'
    end
    object tbPatCDateDATAORDI: TDateField
      FieldName = 'DATAORDI'
      Required = True
    end
    object tbPatCDateDATAPREZ: TDateField
      FieldName = 'DATAPREZ'
      Required = True
    end
    object tbPatCDateKGC: TFloatField
      FieldName = 'KGC'
    end
    object tbPatCDateVAL: TCurrencyField
      FieldName = 'VAL'
      Required = True
    end
  end
  object tbTipo: TTable
    DatabaseName = 'DB'
    TableName = 'TABATIPO.DB'
    Left = 85
    Top = 5
    object tbTipoTIPO: TSmallintField
      FieldName = 'TIPO'
      Required = True
    end
    object tbTipoDESC: TStringField
      FieldName = 'DESC'
      Required = True
      Size = 40
    end
  end
  object tbProd: TTable
    DatabaseName = 'DB'
    TableName = 'TABAPROD.DB'
    Left = 85
    Top = 55
    object tbProdPROD: TSmallintField
      FieldName = 'PROD'
      Required = True
    end
    object tbProdDESC: TStringField
      FieldName = 'DESC'
      Required = True
      Size = 40
    end
  end
  object tbCrit: TTable
    DatabaseName = 'DB'
    TableName = 'TABACRIT.DB'
    Left = 85
    Top = 105
    object tbCritCRIT: TSmallintField
      FieldName = 'CRIT'
      Required = True
    end
    object tbCritDESC: TStringField
      FieldName = 'DESC'
      Required = True
      Size = 40
    end
  end
  object sdOutFile: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'File di testo|*.txt|Tutti i file|*.*'
    Options = [ofOverwritePrompt, ofExtensionDifferent, ofPathMustExist]
    Title = 'Nome del file che conterr'#224' i dati'
    Left = 400
    Top = 10
  end
  object DB: TeDataBase
    Connected = True
    DatabaseName = 'DB'
    DriverName = 'STANDARD'
    Params.Strings = (
      'PATH=d:\sviluppo\projects\tabac\data')
    SessionName = 'Default'
    Signature = 'Tabacchi 1.0'
    OnValidate = DBValidate
    Left = 50
    Top = 205
  end
end
