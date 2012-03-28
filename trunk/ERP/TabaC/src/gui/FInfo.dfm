object fmInfo: TfmInfo
  Left = 244
  Top = 129
  ActiveControl = btOk
  BorderStyle = bsDialog
  Caption = 'Informazioni'
  ClientHeight = 164
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btOk: TBitBtn
    Left = 195
    Top = 8
    Width = 77
    Height = 27
    Caption = '&Ok'
    Kind = bkOK
    Margin = 2
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 0
    IsControl = True
  end
  object pnInfo: TPanel
    Left = 5
    Top = 5
    Width = 181
    Height = 156
    TabOrder = 1
    object Label1: TLabel
      Left = 5
      Top = 10
      Width = 54
      Height = 13
      Caption = 'Data Prezzi'
    end
    object lbDataPrezzi: TLabel
      Left = 110
      Top = 10
      Width = 65
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '99/99/9999'
      Color = 14811135
      ParentColor = False
    end
    object Label2: TLabel
      Left = 5
      Top = 30
      Width = 85
      Height = 13
      Caption = 'Data ultimo carico'
    end
    object lbDataCarico: TLabel
      Left = 110
      Top = 30
      Width = 65
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '99/99/9999'
      Color = 14811135
      ParentColor = False
    end
    object lbDataGiacen: TLabel
      Left = 110
      Top = 45
      Width = 65
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '99/99/9999'
      Color = 14811135
      ParentColor = False
    end
    object Label4: TLabel
      Left = 5
      Top = 45
      Width = 99
      Height = 13
      Caption = 'Data ultima giacenza'
    end
    object Label3: TLabel
      Left = 5
      Top = 80
      Width = 73
      Height = 13
      Caption = 'Data statistiche'
    end
    object lbDataStati: TLabel
      Left = 110
      Top = 80
      Width = 65
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '99/99/9999'
      Color = 14811135
      ParentColor = False
    end
    object Label5: TLabel
      Left = 5
      Top = 120
      Width = 103
      Height = 13
      Caption = 'Data ultima consegna'
    end
    object lbDataPatC: TLabel
      Left = 110
      Top = 120
      Width = 65
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '99/99/9999'
      Color = 14811135
      ParentColor = False
    end
    object Label7: TLabel
      Left = 5
      Top = 135
      Width = 85
      Height = 13
      Caption = 'Data ultimo ordine'
    end
    object lbDataPatO: TLabel
      Left = 110
      Top = 135
      Width = 65
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '99/99/9999'
      Color = 14811135
      ParentColor = False
    end
    object Label9: TLabel
      Left = 5
      Top = 100
      Width = 51
      Height = 16
      Caption = 'Patentini'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lbDataOrdini: TLabel
      Left = 110
      Top = 60
      Width = 65
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '99/99/9999'
      Color = 14811135
      ParentColor = False
    end
    object Label8: TLabel
      Left = 5
      Top = 60
      Width = 85
      Height = 13
      Caption = 'Data ultimo ordine'
    end
  end
end
