object fmChangePassword: TfmChangePassword
  Left = 309
  Top = 149
  ActiveControl = OldPswd
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Cambiamento password'
  ClientHeight = 115
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object OldPswdLabel: TLabel
    Left = 14
    Top = 20
    Width = 120
    Height = 13
    AutoSize = False
    Caption = 'Password precedente'
  end
  object NewPswdLabel: TLabel
    Left = 14
    Top = 52
    Width = 120
    Height = 13
    AutoSize = False
    Caption = 'Nuova password'
  end
  object ConfirmLabel: TLabel
    Left = 14
    Top = 84
    Width = 120
    Height = 13
    AutoSize = False
    Caption = 'Password di conferma'
  end
  object OldPswd: TEdit
    Left = 136
    Top = 16
    Width = 100
    Height = 21
    Hint = 'Inserire la password '#13#10'precedentemente  utilizzata'
    PasswordChar = '*'
    TabOrder = 0
    OnChange = PswdChange
  end
  object NewPswd: TEdit
    Left = 136
    Top = 48
    Width = 100
    Height = 21
    Hint = 'Inserire la nuova password'#13#10'che si intende utilizzare'
    PasswordChar = '*'
    TabOrder = 1
    OnChange = PswdChange
  end
  object ConfirmNewPswd: TEdit
    Left = 136
    Top = 80
    Width = 100
    Height = 21
    Hint = 
      'Inserire nuovamente la password'#13#10'che si intende utilizzare per c' +
      'onfermarla'
    PasswordChar = '*'
    TabOrder = 2
    OnChange = PswdChange
  end
  object OkBtn: TButton
    Left = 254
    Top = 16
    Width = 77
    Height = 25
    Hint = 'Conferma la password'
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = OkBtnClick
  end
  object CancelBtn: TButton
    Left = 254
    Top = 48
    Width = 77
    Height = 25
    Hint = 'Annulla il cambiamento di password'
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
