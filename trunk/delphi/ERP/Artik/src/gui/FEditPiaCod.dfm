object fmEditPiaCod: TfmEditPiaCod
  Left = 258
  Top = 120
  Caption = 'Modifica Piano Codifica'
  ClientHeight = 263
  ClientWidth = 383
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object olSettori: TOutline
    Left = 0
    Top = 26
    Width = 268
    Height = 237
    OutlineStyle = osPlusMinusText
    Options = [ooDrawTreeRoot, ooDrawFocusRect, ooStretchBitmaps]
    ItemHeight = 13
    Align = alClient
    TabOrder = 0
    OnClick = olSettoriClick
    OnEnter = olSettoriEnter
    OnKeyPress = olSettoriKeyPress
    ItemSeparator = '\'
    PopupMenu = pmAction
  end
  object Panel1: TPanel
    Left = 268
    Top = 26
    Width = 115
    Height = 237
    Align = alRight
    TabOrder = 1
    object Label1: TLabel
      Left = 10
      Top = 10
      Width = 22
      Height = 13
      Caption = 'Cod.'
    end
    object Label2: TLabel
      Left = 10
      Top = 35
      Width = 34
      Height = 13
      Caption = 'Settore'
    end
    object Label3: TLabel
      Left = 10
      Top = 80
      Width = 69
      Height = 13
      Caption = 'Predescrizione'
    end
    object Label4: TLabel
      Left = 11
      Top = 125
      Width = 39
      Height = 13
      Caption = 'Ric. Min'
    end
    object Label5: TLabel
      Left = 58
      Top = 125
      Width = 42
      Height = 13
      Caption = 'Ric. Max'
    end
    object iCodAlf: TEdit
      Left = 40
      Top = 5
      Width = 26
      Height = 21
      MaxLength = 1
      TabOrder = 0
      Text = '999'
      OnKeyPress = iCodAlfKeyPress
    end
    object iSetMer: TEdit
      Left = 9
      Top = 50
      Width = 86
      Height = 21
      TabOrder = 1
      Text = '1234567890123'
    end
    object iPreDes: TEdit
      Left = 9
      Top = 95
      Width = 86
      Height = 21
      TabOrder = 2
      Text = '1234567890'
    end
    object iRicMin: TJvSpinEdit
      Left = 10
      Top = 140
      Width = 45
      Height = 21
      Alignment = taRightJustify
      Decimal = 0
      MaxValue = 1000.000000000000000000
      ValueType = vtFloat
      TabOrder = 3
    end
    object iRicMax: TJvSpinEdit
      Left = 60
      Top = 140
      Width = 45
      Height = 21
      Alignment = taRightJustify
      Decimal = 0
      MaxValue = 1000.000000000000000000
      ValueType = vtFloat
      TabOrder = 4
    end
    object btDefault: TBitBtn
      Left = 11
      Top = 199
      Width = 89
      Height = 25
      Caption = 'Default'
      TabOrder = 5
      OnClick = btDefaultClick
    end
    object btAggiorna: TBitBtn
      Left = 11
      Top = 170
      Width = 89
      Height = 25
      Caption = 'Aggiorna'
      TabOrder = 6
      OnClick = btAggiornaClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 383
    Height = 26
    Align = alTop
    TabOrder = 2
    object lbSetMer: TLabel
      Left = 55
      Top = 5
      Width = 42
      Height = 13
      Caption = 'lbSetMer'
    end
    object lbCodAlf: TLabel
      Left = 15
      Top = 5
      Width = 39
      Height = 13
      Caption = 'lbCodAlf'
    end
  end
  object pmAction: TPopupMenu
    Left = 45
    Top = 50
    object miAdd: TMenuItem
      Caption = 'Aggiungi settore'
      OnClick = miAddClick
    end
    object miAddChild: TMenuItem
      Caption = 'Aggiungi sottosettore'
      OnClick = miAddChildClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miDelete: TMenuItem
      Caption = 'Cancella settore'
      OnClick = miDeleteClick
    end
  end
end
