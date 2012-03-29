object dmContabilita: TdmContabilita
  OldCreateOrder = True
  Height = 150
  Width = 215
  object dbContabilita: TZConnection
    Connected = True
    Protocol = 'ado'
    Database = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=S:\Sviluppo\develop' +
      '\projects\DelphiXE2\shared\ERP\ConTab\bin\contabilita.mdb;Persis' +
      't Security Info=False'
    Left = 17
    Top = 8
  end
end
