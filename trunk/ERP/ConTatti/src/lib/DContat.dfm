object dmContatti: TdmContatti
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 184
  Width = 298
  object DB: TeDataBase
    DatabaseName = 'DB'
    DriverName = 'STANDARD'
    Params.Strings = (
      
        'PATH=G:\develop\shared\delphi\projects\Converted\ConTatti2007\bi' +
        'n\data'
      '')
    SessionName = 'Default'
    Signature = 'ContattiDB 1.0a'
    OnValidate = DBValidate
    Left = 10
    Top = 13
  end
  object tbContat: TTable
    DatabaseName = 'DB'
    TableName = 'CONTAT.DB'
    Left = 128
    Top = 10
  end
  object DBConnection: TDBConnectionLink
    Active = False
    DataBase = DB
    OnConnect = DBConnectionConnect
    OnDisconnect = DBConnectionDisconnect
    Left = 61
    Top = 10
  end
  object tbInfo: TTable
    DatabaseName = '.\'
    TableName = 'PROGINFO.DB'
    Left = 187
    Top = 10
  end
  object IceLock: TIceLock
    OnLoadIceRecord = IceLockLoadIceRecord
    OnSaveIceRecord = IceLockSaveIceRecord
    IceString1 = 'TIceLock'
    IceString2 = 'IceLock installed'
    IceSeed1 = 65783454
    IceSeed2 = 23523624
    ProgramKey1 = 1401548078
    ProgramKey2 = -36345580
    KeyFile = 'REGISTER.KEY'
    TrialDays = 30
    DemoLicense = False
    Left = 67
    Top = 64
  end
  object sdOutFile: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'File di testo|*.txt|Tutti i file|*.*'
    Options = [ofOverwritePrompt, ofExtensionDifferent, ofPathMustExist]
    Title = 'Nome del file che conterra'#39' i dati'
    Left = 130
    Top = 62
  end
end
