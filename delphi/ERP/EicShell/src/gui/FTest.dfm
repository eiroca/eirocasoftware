object Form1: TForm1
  Left = 200
  Top = 99
  Caption = 'Form1'
  ClientHeight = 162
  ClientWidth = 373
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 10
    Top = 5
    Width = 89
    Height = 25
    Caption = 'GetUserName'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 10
    Top = 35
    Width = 89
    Height = 25
    Caption = 'addRef'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 10
    Top = 65
    Width = 89
    Height = 25
    Caption = 'release'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 10
    Top = 95
    Width = 89
    Height = 25
    Caption = 'Check Pwd'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 10
    Top = 125
    Width = 89
    Height = 25
    Caption = 'set Pwd'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Memo1: TMemo
    Left = 105
    Top = 5
    Width = 251
    Height = 151
    Lines.Strings = (
      'Memo1')
    TabOrder = 5
  end
end
