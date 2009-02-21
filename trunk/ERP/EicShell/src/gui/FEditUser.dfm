object fmEditUser: TfmEditUser
  Left = 338
  Top = 145
  ActiveControl = Panel1
  BorderStyle = bsDialog
  Caption = 'Modifica dati utenti'
  ClientHeight = 112
  ClientWidth = 275
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 275
    Height = 41
    Align = alTop
    TabOrder = 0
    object DBNavigator: TDBNavigator
      Left = 13
      Top = 8
      Width = 240
      Height = 25
      DataSource = dsUser
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 275
    Height = 71
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'Panel2'
    TabOrder = 1
    object ScrollBox: TScrollBox
      Left = 6
      Top = 6
      Width = 263
      Height = 59
      HorzScrollBar.Margin = 6
      HorzScrollBar.Range = 168
      VertScrollBar.Margin = 6
      VertScrollBar.Range = 46
      Align = alClient
      AutoScroll = False
      BorderStyle = bsNone
      TabOrder = 0
      object Label1: TLabel
        Left = 6
        Top = 11
        Width = 28
        Height = 13
        Caption = 'Nome'
        FocusControl = EditNome
      end
      object EditNome: TDBEdit
        Left = 46
        Top = 6
        Width = 100
        Height = 21
        DataField = 'Nome'
        DataSource = dsUser
        TabOrder = 0
      end
      object DBCheckBox1: TDBCheckBox
        Left = 5
        Top = 35
        Width = 136
        Height = 17
        Caption = 'System administrator'
        DataField = 'System'
        DataSource = dsUser
        TabOrder = 1
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object btDelPwd: TButton
        Left = 155
        Top = 15
        Width = 100
        Height = 25
        Caption = 'Rimuovi password'
        TabOrder = 2
        OnClick = btDelPwdClick
      end
    end
  end
  object dsUser: TDataSource
    DataSet = tbUser
    OnDataChange = dsUserDataChange
    Left = 172
    Top = 5
  end
  object tbUser: TTable
    DatabaseName = 'DB'
    TableName = 'USERS.DB'
    Left = 145
    Top = 5
    object tbUserCodUsr: TIntegerField
      FieldName = 'CodUsr'
    end
    object tbUserNome: TStringField
      FieldName = 'Nome'
      Required = True
    end
    object tbUserPassword: TStringField
      FieldName = 'Password'
      Size = 16
    end
    object tbUserSystem: TBooleanField
      FieldName = 'System'
    end
  end
end
