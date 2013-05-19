object fmPrinterSetup: TfmPrinterSetup
  Left = 287
  Top = 184
  BorderStyle = bsDialog
  Caption = 'Impostazioni Stampante'
  ClientHeight = 248
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
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
  object BitBtn1: TBitBtn
    Left = 105
    Top = 210
    Width = 90
    Height = 27
    Hint = 'Annulla gli eventuali cambiamenti effettuati'
    Kind = bkCancel
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 0
  end
  object btOk: TBitBtn
    Left = 10
    Top = 210
    Width = 90
    Height = 27
    Hint = 'Memorizza le preferenze'
    Caption = '&Ok'
    Kind = bkOK
    Margin = 5
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 1
    OnClick = btOkClick
  end
  object GroupBox7: TGroupBox
    Left = 10
    Top = 90
    Width = 396
    Height = 111
    Caption = 'Dimensione pagina'
    TabOrder = 2
    object Label16: TLabel
      Left = 10
      Top = 18
      Width = 185
      Height = 13
      Caption = 'Numero di righe  in una pagina di report'
    end
    object Label1: TLabel
      Left = 10
      Top = 48
      Width = 101
      Height = 13
      Caption = 'Riserva margine TOP'
    end
    object Label2: TLabel
      Left = 10
      Top = 78
      Width = 105
      Height = 13
      Caption = 'Riserva margine LEFT'
    end
    object Label3: TLabel
      Left = 195
      Top = 78
      Width = 113
      Height = 13
      Caption = 'Riserva margine RIGHT'
    end
    object Label6: TLabel
      Left = 195
      Top = 48
      Width = 125
      Height = 13
      Caption = 'Riserva margine BOTTOM'
    end
    object iRigheRep: TJvSpinEdit
      Left = 230
      Top = 15
      Width = 61
      Height = 21
      MaxValue = 9999.000000000000000000
      MinValue = 10.000000000000000000
      Value = 9999.000000000000000000
      TabOrder = 0
    end
    object iOffTop: TJvSpinEdit
      Left = 125
      Top = 45
      Width = 61
      Height = 21
      MaxValue = 999999.000000000000000000
      MinValue = -999999.000000000000000000
      Value = 9999.000000000000000000
      TabOrder = 1
    end
    object iOffLeft: TJvSpinEdit
      Left = 125
      Top = 75
      Width = 61
      Height = 21
      MaxValue = 999999.000000000000000000
      MinValue = -999999.000000000000000000
      Value = 9999.000000000000000000
      TabOrder = 2
    end
    object iOffRight: TJvSpinEdit
      Left = 325
      Top = 75
      Width = 61
      Height = 21
      MaxValue = 999999.000000000000000000
      MinValue = -999999.000000000000000000
      Value = 9999.000000000000000000
      TabOrder = 3
    end
    object iOffBottom: TJvSpinEdit
      Left = 325
      Top = 45
      Width = 61
      Height = 21
      MaxValue = 999999.000000000000000000
      MinValue = -999999.000000000000000000
      Value = 9999.000000000000000000
      TabOrder = 4
    end
  end
  object GroupBox6: TGroupBox
    Left = 10
    Top = 10
    Width = 396
    Height = 76
    Caption = ' Stampante da utilizzare'
    TabOrder = 3
    object Label5: TLabel
      Left = 15
      Top = 51
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Caption = 'Utilizza il font'
    end
    object Label4: TLabel
      Left = 10
      Top = 20
      Width = 105
      Height = 13
      Caption = 'Nome della stampante'
    end
    object sbSetting: TSpeedButton
      Left = 295
      Top = 13
      Width = 89
      Height = 25
      Caption = '&Imposta'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555550FF0559
        1950555FF75F7557F7F757000FF055591903557775F75557F77570FFFF055559
        1933575FF57F5557F7FF0F00FF05555919337F775F7F5557F7F700550F055559
        193577557F7F55F7577F07550F0555999995755575755F7FFF7F5570F0755011
        11155557F755F777777555000755033305555577755F75F77F55555555503335
        0555555FF5F75F757F5555005503335505555577FF75F7557F55505050333555
        05555757F75F75557F5505000333555505557F777FF755557F55000000355557
        07557777777F55557F5555000005555707555577777FF5557F55553000075557
        0755557F7777FFF5755555335000005555555577577777555555}
      Margin = 5
      NumGlyphs = 2
      Spacing = -1
      OnClick = sbSettingClick
    end
    object Label7: TLabel
      Left = 243
      Top = 51
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'in corpo'
    end
    object eFontSize: TJvSpinEdit
      Left = 295
      Top = 48
      Width = 61
      Height = 21
      Hint = 'Dimensione da garantire almeno 90 caratteri per ogni riga'
      TabOrder = 0
    end
    object cbFonts: TComboBox
      Left = 90
      Top = 48
      Width = 136
      Height = 21
      Hint = 'Risultati migliori si ottengono con un font a spaziatura fissa'
      Sorted = True
      TabOrder = 1
      Text = 'cbFonts'
      OnChange = cbFontsChange
    end
    object cbPrinter: TComboBox
      Left = 125
      Top = 15
      Width = 161
      Height = 21
      Style = csDropDownList
      TabOrder = 2
      OnChange = cbPrinterChange
    end
  end
  object sdPrinter: TPrinterSetupDialog
    Left = 260
    Top = 80
  end
  object aa: TPrintDialog
    Left = 240
    Top = 220
  end
end
