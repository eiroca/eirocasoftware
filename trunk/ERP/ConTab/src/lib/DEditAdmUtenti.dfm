object dmEditAdmUtenti: TdmEditAdmUtenti
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 201
  Width = 232
  object tbAdmUtenti: TADOTable
    Connection = dmContabilita.dbContabilita
    CursorType = ctStatic
    TableName = 'AdmUtenti'
    Left = 27
    Top = 15
    object tbAdmUtentiCodUsr: TAutoIncField
      DisplayLabel = 'Codice Utente'
      FieldName = 'CodUsr'
    end
    object tbAdmUtentiUserName: TStringField
      FieldName = 'UserName'
      Required = True
      Size = 12
    end
    object tbAdmUtentiPassword: TStringField
      FieldName = 'Password'
      Size = 12
    end
    object tbAdmUtentiSuperUser: TBooleanField
      DisplayLabel = 'Super user?'
      FieldName = 'SuperUser'
    end
  end
  object dsAdmUtenti: TDataSource
    DataSet = tbAdmUtenti
    Left = 103
    Top = 13
  end
end
