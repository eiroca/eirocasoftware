object dmArticoli: TdmArticoli
  OldCreateOrder = True
  OnCreate = dmArticoliCreate
  Height = 277
  Width = 396
  object DBConnect: TDBConnectionLink
    Active = False
    OnConnect = DBConnectConnect
    OnDisconnect = DBConnectConnect
    Left = 20
    Top = 5
  end
  object tbSettori: TTable
    DatabaseName = 'DB'
    TableName = 'SETTORI.DB'
    Left = 80
    Top = 5
    object tbSettoriCodAlf: TStringField
      FieldName = 'CodAlf'
      Size = 3
    end
    object tbSettoriSetMer: TStringField
      FieldName = 'SetMer'
      Required = True
      Size = 13
    end
    object tbSettoriPreDes: TStringField
      FieldName = 'PreDes'
      Size = 10
    end
    object tbSettoriRicMin: TFloatField
      FieldName = 'RicMin'
    end
    object tbSettoriRicMax: TFloatField
      FieldName = 'RicMax'
    end
  end
  object qryCountArticoli: TQuery
    DatabaseName = 'DB'
    SQL.Strings = (
      'select count(CodAlf)'
      '  from "Articoli.db"'
      ' where'
      '   CodAlf  like :aCodAlf')
    Left = 100
    Top = 115
    ParamData = <
      item
        DataType = ftString
        Name = 'aCodAlf'
        ParamType = ptUnknown
        Value = 'BBB'
      end>
    object qryCountArticoliResult: TFloatField
      FieldName = 'COUNT of CodAlf'
    end
  end
  object tbSettoriLst: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'CodAlf'
    TableName = 'SETTORI.DB'
    Left = 80
    Top = 60
    object tbSettoriLstCodAlf: TStringField
      FieldName = 'CodAlf'
      Size = 3
    end
  end
  object tbArticoli: TTable
    DatabaseName = 'DB'
    TableName = 'ARTICOLI.DB'
    Left = 130
    Top = 5
    object tbArticoliCodAlf: TStringField
      FieldName = 'CodAlf'
      Size = 3
    end
    object tbArticoliCodNum: TSmallintField
      FieldName = 'CodNum'
    end
    object tbArticoliDesc: TStringField
      FieldName = 'Desc'
      Size = 30
    end
    object tbArticoliAttv: TBooleanField
      FieldName = 'Attv'
    end
    object tbArticoliCodIVA: TSmallintField
      FieldName = 'CodIVA'
      Required = True
    end
    object tbArticoliCodMis: TSmallintField
      FieldName = 'CodMis'
      Required = True
    end
    object tbArticoliQta: TFloatField
      FieldName = 'Qta'
      Required = True
    end
    object tbArticoliQtaInv: TFloatField
      FieldName = 'QtaInv'
    end
    object tbArticoliQtaDelta: TFloatField
      FieldName = 'QtaDelta'
    end
    object tbArticoliQtaAcq: TFloatField
      FieldName = 'QtaAcq'
    end
    object tbArticoliQtaOrd: TFloatField
      FieldName = 'QtaOrd'
    end
    object tbArticoliQtaVen: TFloatField
      FieldName = 'QtaVen'
    end
    object tbArticoliQtaPre: TFloatField
      FieldName = 'QtaPre'
    end
    object tbArticoliQtaSco: TFloatField
      FieldName = 'QtaSco'
    end
    object tbArticoliPrzLis: TCurrencyField
      FieldName = 'PrzLis'
    end
    object tbArticoliPrzNor: TCurrencyField
      FieldName = 'PrzNor'
    end
    object tbArticoliPrzSpe: TCurrencyField
      FieldName = 'PrzSpe'
    end
    object tbArticoliRicNor: TSmallintField
      FieldName = 'RicNor'
    end
    object tbArticoliRicSpe: TSmallintField
      FieldName = 'RicSpe'
    end
    object tbArticoliPrePriAcq: TCurrencyField
      FieldName = 'PrePriAcq'
    end
    object tbArticoliPreUltAcq: TCurrencyField
      FieldName = 'PreUltAcq'
    end
    object tbArticoliDatPriAcq: TDateField
      FieldName = 'DatPriAcq'
    end
    object tbArticoliDatUltAcq: TDateField
      FieldName = 'DatUltAcq'
    end
    object tbArticoliCumuloAcq: TFloatField
      FieldName = 'CumuloAcq'
    end
    object tbArticoliCumuloOrd: TFloatField
      FieldName = 'CumuloOrd'
    end
  end
  object DB: TeDataBase
    Connected = True
    DatabaseName = 'DB'
    DriverName = 'STANDARD'
    Params.Strings = (
      'PATH=d:\Sviluppo\Projects\Artik\bin\DB')
    SessionName = 'Default'
    Signature = 'Articoli 1.0a'
    Left = 338
    Top = 10
  end
end
