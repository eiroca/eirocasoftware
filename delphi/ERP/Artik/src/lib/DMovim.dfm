object dmMovim: TdmMovim
  OldCreateOrder = True
  OnCreate = FormCreate
  Height = 172
  Width = 355
  object DBConnect: TDBConnectionLink
    Active = False
    Left = 18
    Top = 10
  end
  object qrCalcSpese: TQuery
    DatabaseName = 'DB'
    SQL.Strings = (
      'select '
      '  sum(Imp) as ImpSpe,  '
      '  sum(IVA) as IVASpe'
      'from '
      '  "FATFORSP.DB" '
      'where '
      '  (CodFatFor = :aCodFatFor)')
    Left = 93
    Top = 10
    ParamData = <
      item
        DataType = ftInteger
        Name = 'aCodFatFor'
        ParamType = ptUnknown
        Value = 1
      end>
    object qrCalcSpeseImpSpe: TCurrencyField
      FieldName = 'ImpSpe'
    end
    object qrCalcSpeseIVASpe: TCurrencyField
      FieldName = 'IVASpe'
    end
  end
  object qrCalcMovi: TQuery
    DatabaseName = 'DB'
    SQL.Strings = (
      'select '
      '  *'
      'from '
      '  "FATFORMV.DB" '
      'where '
      '  (CodFatFor = :aCodFatFor)')
    Left = 157
    Top = 13
    ParamData = <
      item
        DataType = ftInteger
        Name = 'aCodFatFor'
        ParamType = ptUnknown
        Value = 1
      end>
    object qrCalcMoviCodMov: TIntegerField
      FieldName = 'CodMov'
    end
    object qrCalcMoviCodFatFor: TIntegerField
      FieldName = 'CodFatFor'
    end
    object qrCalcMoviCodAlf: TStringField
      FieldName = 'CodAlf'
      Size = 3
    end
    object qrCalcMoviCodNum: TIntegerField
      FieldName = 'CodNum'
    end
    object qrCalcMoviQta: TFloatField
      FieldName = 'Qta'
    end
    object qrCalcMoviImp: TCurrencyField
      FieldName = 'Imp'
    end
    object qrCalcMoviElab: TBooleanField
      FieldName = 'Elab'
    end
  end
end
