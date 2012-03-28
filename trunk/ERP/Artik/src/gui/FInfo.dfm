object fmInfo: TfmInfo
  Left = 153
  Top = 105
  BorderStyle = bsDialog
  Caption = 'Informazioni'
  ClientHeight = 191
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 105
    Top = 155
    Width = 90
    Height = 27
    Caption = 'Annulla'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
  end
  object btOk: TBitBtn
    Left = 10
    Top = 155
    Width = 90
    Height = 27
    Caption = '&Ok'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 2
    OnClick = btOkClick
  end
  object nbInfo: TTabbedNotebook
    Left = 5
    Top = 5
    Width = 376
    Height = 141
    TabsPerRow = 5
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clBtnText
    TabFont.Height = -11
    TabFont.Name = 'MS Sans Serif'
    TabFont.Style = []
    TabOrder = 0
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Generali'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 10
        Top = 15
        Width = 89
        Height = 13
        Alignment = taRightJustify
        Caption = 'Archivio di Default:'
      end
      object iDefaultDB: TEdit
        Left = 105
        Top = 10
        Width = 241
        Height = 21
        TabOrder = 0
        Text = 'iDefaultDB'
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Stampante'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object btSetup: TSpeedButton
        Left = 235
        Top = 9
        Width = 25
        Height = 25
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
        NumGlyphs = 2
        OnClick = btSetupClick
      end
      object Label4: TLabel
        Left = 10
        Top = 16
        Width = 51
        Height = 13
        Alignment = taRightJustify
        Caption = 'Stampante'
      end
      object Label5: TLabel
        Left = 7
        Top = 51
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = 'Font utilizzato'
      end
      object eFontSize: TJvSpinEdit
        Left = 210
        Top = 48
        Width = 61
        Height = 21
        TabOrder = 0
      end
      object cbPrinter: TComboBox
        Left = 65
        Top = 13
        Width = 166
        Height = 21
        Style = csDropDownList
        TabOrder = 1
        OnChange = cbPrinterChange
      end
      object cbFonts: TComboBox
        Left = 75
        Top = 48
        Width = 131
        Height = 21
        Sorted = True
        TabOrder = 2
        Text = 'cbFonts'
        OnChange = cbFontsChange
      end
    end
  end
  object sdPrinter: TPrinterSetupDialog
    Left = 40
    Top = 150
  end
end
