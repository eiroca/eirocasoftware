object fmRegistrazione: TfmRegistrazione
  Left = 298
  Top = 107
  ActiveControl = iRegName
  BorderStyle = bsDialog
  Caption = 'Registrazione licenza'
  ClientHeight = 184
  ClientWidth = 315
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnDblClick = FormDblClick
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnValidate: TPanel
    Left = 8
    Top = 8
    Width = 298
    Height = 128
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 20
      Width = 61
      Height = 13
      Caption = 'Nome utente'
    end
    object Label2: TLabel
      Left = 10
      Top = 55
      Width = 73
      Height = 13
      Caption = 'Numero di serie'
    end
    object Label3: TLabel
      Left = 10
      Top = 95
      Width = 87
      Height = 13
      Caption = 'Codice di controllo'
    end
    object iRegName: TEdit
      Left = 105
      Top = 15
      Width = 180
      Height = 21
      TabOrder = 0
      Text = 'iRegName'
      OnChange = iRegNameChange
    end
    object pnLicenza: TPanel
      Left = 105
      Top = 50
      Width = 180
      Height = 21
      BevelOuter = bvLowered
      Caption = 'pnLicenza'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object iChckCode: TEdit
      Left = 105
      Top = 90
      Width = 180
      Height = 21
      TabOrder = 1
      Text = 'iChckCode'
    end
  end
  object btExit: TBitBtn
    Left = 119
    Top = 148
    Width = 77
    Height = 27
    Cancel = True
    Caption = 'Annulla'
    ModalResult = 2
    TabOrder = 2
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
      33333337777FF377FF3333993370739993333377FF373F377FF3399993000339
      993337777F777F3377F3393999707333993337F77737333337FF993399933333
      399377F3777FF333377F993339903333399377F33737FF33377F993333707333
      399377F333377FF3377F993333101933399377F333777FFF377F993333000993
      399377FF3377737FF7733993330009993933373FF3777377F7F3399933000399
      99333773FF777F777733339993707339933333773FF7FFF77333333999999999
      3333333777333777333333333999993333333333377777333333}
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    IsControl = True
  end
  object btOk: TBitBtn
    Left = 16
    Top = 148
    Width = 77
    Height = 27
    Caption = 'Ok'
    TabOrder = 1
    OnClick = btOkClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      555555555555555555555555555555555555555555FF55555555555559055555
      55555555577FF5555555555599905555555555557777F5555555555599905555
      555555557777FF5555555559999905555555555777777F555555559999990555
      5555557777777FF5555557990599905555555777757777F55555790555599055
      55557775555777FF5555555555599905555555555557777F5555555555559905
      555555555555777FF5555555555559905555555555555777FF55555555555579
      05555555555555777FF5555555555557905555555555555777FF555555555555
      5990555555555555577755555555555555555555555555555555}
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    IsControl = True
  end
end
