object fmInfo: TfmInfo
  Left = 238
  Top = 105
  BorderStyle = bsDialog
  Caption = 'Informazioni'
  ClientHeight = 239
  ClientWidth = 446
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
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 120
    Top = 205
    Width = 90
    Height = 27
    Hint = 'Annulla gli eventuali cambiamenti effettuati'
    Cancel = True
    Caption = 'Annulla'
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
    ModalResult = 2
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 0
  end
  object btOk: TBitBtn
    Left = 25
    Top = 205
    Width = 90
    Height = 27
    Hint = 'Memorizza le preferenze'
    Caption = '&Ok'
    Default = True
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
    ModalResult = 1
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 1
    OnClick = btOkClick
  end
  object tbInfo: TTabbedNotebook
    Left = 10
    Top = 5
    Width = 426
    Height = 191
    PageIndex = 3
    TabsPerRow = 4
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clBtnText
    TabFont.Height = -11
    TabFont.Name = 'MS Sans Serif'
    TabFont.Style = []
    TabOrder = 2
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Personali'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 15
        Top = 130
        Width = 86
        Height = 13
        Caption = 'Archivio di Default'
      end
      object iDefaultDB: TEdit
        Left = 120
        Top = 125
        Width = 161
        Height = 21
        ReadOnly = True
        TabOrder = 0
        Text = 'iDefaultDB'
      end
      object GroupBox4: TGroupBox
        Left = 10
        Top = 5
        Width = 396
        Height = 106
        Caption = ' Dati personali '
        TabOrder = 1
        object Label3: TLabel
          Left = 15
          Top = 50
          Width = 184
          Height = 13
          Caption = 'Il mio prefisso di teleselezione defaullt '#232
        end
        object Label6: TLabel
          Left = 15
          Top = 80
          Width = 188
          Height = 13
          Caption = 'Il mio prefisso internazionale di defaullt '#232
        end
        object Label2: TLabel
          Left = 15
          Top = 20
          Width = 35
          Height = 13
          Caption = 'Io sono'
        end
        object lcYourSelf: TJvDBLookupCombo
          Left = 80
          Top = 15
          Width = 291
          Height = 22
          Hint = 'Nome del utente'
          ListStyle = lsDelimited
          LookupField = 'CodCon'
          LookupDisplay = 'Nome_Main;Nome_Pre1'
          LookupSource = dsContat
          TabOrder = 0
          OnCloseUp = lcYourSelfCloseUp
        end
        object iDefPrefix2: TEdit
          Left = 220
          Top = 45
          Width = 71
          Height = 21
          Hint = 'Inserire il prefisso internazionale.'#13#10'Per l'#39'Italia '#232' 039'
          TabOrder = 1
          Text = 'iDefPrefix2'
        end
        object iDefPrefix1: TEdit
          Left = 220
          Top = 75
          Width = 71
          Height = 21
          Hint = 'Prefisso di teleselezione'
          TabOrder = 2
          Text = 'iDefPrefix1'
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Visualizzazioni'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 10
        Top = 110
        Width = 396
        Height = 46
        Caption = ' Numeri Telefonici '
        TabOrder = 0
        object cbSelfPref: TCheckBox
          Left = 190
          Top = 20
          Width = 180
          Height = 17
          Caption = 'Non mostrare il mio prefisso'
          TabOrder = 0
        end
        object cbIntPref: TCheckBox
          Left = 10
          Top = 20
          Width = 180
          Height = 17
          Caption = 'Mostra i prefissi internazionali'
          TabOrder = 1
        end
      end
      object Indirizzi: TGroupBox
        Left = 10
        Top = 55
        Width = 396
        Height = 46
        Caption = ' Indirizzi '
        TabOrder = 1
        object rbIndMode1: TRadioButton
          Left = 10
          Top = 20
          Width = 141
          Height = 17
          Caption = 'Mostra indirizzo completo'
          TabOrder = 0
        end
        object rbIndMode2: TRadioButton
          Left = 190
          Top = 20
          Width = 196
          Height = 17
          Caption = 'Mostra solo le prime righe'
          TabOrder = 1
        end
        object iRigheInd: TJvSpinEdit
          Left = 305
          Top = 16
          Width = 41
          Height = 21
          MaxValue = 99.000000000000000000
          MinValue = 1.000000000000000000
          Value = 2.000000000000000000
          TabOrder = 2
        end
      end
      object GroupBox5: TGroupBox
        Left = 10
        Top = 0
        Width = 396
        Height = 46
        Caption = ' Contatti '
        TabOrder = 2
        object cbShowPre2: TCheckBox
          Left = 190
          Top = 20
          Width = 201
          Height = 17
          Caption = 'Mostra anche i secondi, terzi, ... nomi'
          TabOrder = 0
        end
        object cbShowTito: TCheckBox
          Left = 10
          Top = 20
          Width = 180
          Height = 17
          Caption = 'Mostra i titoli (ex. Dr., S.r.l., ...)'
          TabOrder = 1
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Stampante'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox6: TGroupBox
        Left = 10
        Top = 5
        Width = 396
        Height = 76
        Caption = ' Stampante da utilizzare'
        TabOrder = 0
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
        object SpeedButton1: TSpeedButton
          Left = 305
          Top = 13
          Width = 76
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
          NumGlyphs = 2
          OnClick = SpeedButton1Click
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
      object GroupBox7: TGroupBox
        Left = 10
        Top = 85
        Width = 396
        Height = 71
        Caption = 'Dimensione pagina'
        TabOrder = 1
        object Label16: TLabel
          Left = 10
          Top = 18
          Width = 185
          Height = 13
          Caption = 'Numero di righe  in una pagina di report'
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
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Preferenze'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox2: TGroupBox
        Left = 10
        Top = 5
        Width = 396
        Height = 86
        Hint = 
          'Azioni automatiche da effettuare quando '#13#10'si crea un nuovo conta' +
          'tto'
        Caption = 'Nuovi contatti'
        TabOrder = 0
        object cbAutoInsertDataImpo: TCheckBox
          Left = 10
          Top = 15
          Width = 166
          Height = 17
          Caption = 'Aggiungi una data importante'
          TabOrder = 0
        end
        object iDataImpoNota: TEdit
          Left = 175
          Top = 15
          Width = 131
          Height = 21
          TabOrder = 1
          Text = 'iDataImpoNota'
        end
        object cbAutoInsertTelef: TCheckBox
          Left = 10
          Top = 40
          Width = 246
          Height = 17
          Caption = 'Auto insert se non ci sono numeri telefonici'
          TabOrder = 2
        end
        object cbAutoInsertIndir: TCheckBox
          Left = 10
          Top = 60
          Width = 246
          Height = 17
          Caption = 'Auto insert se non ci sono indirizzi'
          TabOrder = 3
        end
      end
      object GroupBox3: TGroupBox
        Left = 10
        Top = 100
        Width = 396
        Height = 51
        Hint = 
          'Impostazione delle conferme/annullamenti'#13#10'da effettuare in modo ' +
          'automatico'
        Caption = 'Conferme'
        TabOrder = 1
        object cbPostEdit: TCheckBox
          Left = 10
          Top = 15
          Width = 301
          Height = 17
          Caption = 'Conferma automaticamente le modifiche dei dati'
          TabOrder = 0
        end
        object cbPostInsert: TCheckBox
          Left = 10
          Top = 30
          Width = 301
          Height = 17
          Caption = 'Conferma automaticamente gli inserimenti di dati'
          TabOrder = 1
        end
      end
    end
  end
  object sdPrinter: TPrinterSetupDialog
    Left = 225
    Top = 205
  end
  object tbContat: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'Nome_Main;Nome_Pre1'
    TableName = 'CONTAT.DB'
    Left = 270
    Top = 205
    object tbContatCodCon: TIntegerField
      FieldName = 'CodCon'
    end
    object tbContatTipo: TIntegerField
      FieldName = 'Tipo'
    end
    object tbContatNome_Tit: TStringField
      FieldName = 'Nome_Tit'
      Size = 10
    end
    object tbContatNome_Pre1: TStringField
      FieldName = 'Nome_Pre1'
    end
    object tbContatNome_Pre2: TStringField
      FieldName = 'Nome_Pre2'
      Size = 40
    end
    object tbContatNome_Main: TStringField
      FieldName = 'Nome_Main'
      Size = 40
    end
    object tbContatNome_Suf: TStringField
      FieldName = 'Nome_Suf'
      Size = 10
    end
    object tbContatClasse: TStringField
      FieldName = 'Classe'
      Size = 15
    end
    object tbContatSettore: TStringField
      FieldName = 'Settore'
      Size = 35
    end
    object tbContatNote: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
      Size = 100
    end
  end
  object dsContat: TDataSource
    DataSet = tbContat
    Left = 280
    Top = 205
  end
  object tbTelef: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'TELEF.DB'
    Left = 315
    Top = 206
    object tbTelefCodTel: TIntegerField
      FieldName = 'CodTel'
    end
    object tbTelefCodCon: TIntegerField
      FieldName = 'CodCon'
      Required = True
    end
    object tbTelefTipo: TIntegerField
      FieldName = 'Tipo'
    end
    object tbTelefTel_Pre1: TStringField
      FieldName = 'Tel_Pre1'
      Size = 6
    end
    object tbTelefTel_Pre2: TStringField
      FieldName = 'Tel_Pre2'
      Size = 6
    end
    object tbTelefTelefono: TStringField
      FieldName = 'Telefono'
      Size = 18
    end
    object tbTelefNote: TStringField
      FieldName = 'Note'
      Size = 40
    end
  end
end
