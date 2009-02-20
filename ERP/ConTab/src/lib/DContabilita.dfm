object dmContabilita: TdmContabilita
  OldCreateOrder = True
  Height = 150
  Width = 215
  object dbContabilita: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=G:\develop\shared\d' +
      'elphi\ERP\ConTab\bin\contabilita.mdb;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 17
    Top = 8
  end
end
