object EicShellMenu: TEicShellMenu
  Left = 244
  Top = 146
  Caption = 'eicShell'
  ClientHeight = 246
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PrevInstance: TMgPrevInstance
    AllowedInstances = 1
    FoundAction = mgfaRestoreAndQuit
    Left = 45
    Top = 5
  end
  object MainMenu1: TMainMenu
    Left = 10
    Top = 5
    object mnFile: TMenuItem
      Caption = '&Sistema'
      object miLogOn: TMenuItem
        Caption = 'Cambia &utente'
        OnClick = miLogOnClick
      end
      object miChangePwd: TMenuItem
        Caption = '&Cambia password'
        OnClick = miChangePwdClick
      end
      object miLock: TMenuItem
        Caption = '&Blocca il programma'
        OnClick = miLockClick
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object miEditUser: TMenuItem
        Caption = '&Gestione utenti'
        OnClick = miEditUserClick
      end
      object miPackDB: TMenuItem
        Caption = 'Compattazione Database'
        OnClick = miPackDBClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miExit: TMenuItem
        Caption = '&Esce dal programma'
        OnClick = miExitClick
      end
    end
    object Programmi1: TMenuItem
      Caption = '&Programmi'
    end
    object Aiuto1: TMenuItem
      Caption = '&Aiuto'
      object Informazionisu1: TMenuItem
        Caption = 'Informazioni su...'
      end
    end
  end
  object DBSec: TJvDBSecurity
    LoginNameField = 'Nome'
    UsersTableName = 'USERS.DB'
    AppStorage = apStorage
    MaxPasswordLen = 16
    OnCheckUser = DBSecCheckUser
    OnChangePassword = DBSecChangePassword
    AfterLogin = DBSecAfterLogin
    OnUnlock = DBSecUnlock
    Left = 232
    Top = 10
  end
  object tbUsers: TTable
    DatabaseName = 'DB'
    TableName = 'USERS.DB'
    Left = 299
    Top = 10
    object tbUsersCodUsr: TIntegerField
      FieldName = 'CodUsr'
    end
    object tbUsersNome: TStringField
      FieldName = 'Nome'
      Required = True
    end
    object tbUsersPassword: TStringField
      FieldName = 'Password'
      Size = 16
    end
    object tbUsersSystem: TBooleanField
      FieldName = 'System'
    end
  end
  object DB: TeDataBase
    DatabaseName = 'DB'
    DriverName = 'STANDARD'
    Params.Strings = (
      
        'PATH=G:\develop\projects\delphi\projects\Converted\EicShell2007\' +
        'bin\data')
    SessionName = 'Default'
    Signature = 'EicShellDB 1.0a'
    OnValidate = DBValidate
    Left = 96
    Top = 10
  end
  object DBConnection: TDBConnectionLink
    Active = False
    DataBase = DB
    OnConnect = DBConnectionConnect
    OnDisconnect = DBConnectionConnect
    Left = 157
    Top = 10
  end
  object apStorage: TJvAppIniFileStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    DefaultSection = 'main'
    SubStorages = <>
    Left = 232
    Top = 64
  end
end
