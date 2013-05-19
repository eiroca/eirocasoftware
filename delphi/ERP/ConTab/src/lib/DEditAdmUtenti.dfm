object dmEditAdmUtenti: TdmEditAdmUtenti
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 201
  Width = 232
  object tbAdmUtenti: TZTable
    Connection = dmContabilita.dbContabilita
    TableName = 'AdmUtenti'
    Left = 27
    Top = 15
    object tbAdmUtentiCodUsr: TIntegerField
      FieldName = 'CodUsr'
      ReadOnly = True
    end
    object tbAdmUtentiUserName: TWideStringField
      FieldName = 'UserName'
      ReadOnly = True
      Size = 12
    end
    object tbAdmUtentiPassword: TWideStringField
      FieldName = 'Password'
      ReadOnly = True
      Size = 12
    end
    object tbAdmUtentiSuperUser: TBooleanField
      FieldName = 'SuperUser'
      ReadOnly = True
    end
  end
  object dsAdmUtenti: TDataSource
    DataSet = tbAdmUtenti
    Left = 103
    Top = 13
  end
end
