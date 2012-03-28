object fmContatti: TfmContatti
  Left = 207
  Top = 133
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Contatti'
  ClientHeight = 299
  ClientWidth = 491
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object tsContatti: TTabSet
    Left = 0
    Top = 278
    Width = 491
    Height = 21
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    StartMargin = 0
    Style = tsOwnerDraw
    TabHeight = 17
    Tabs.Strings = (
      'Contatti'
      'Indirizzi'
      'Telefoni'
      'Date Importanti'
      'Referenti'
      'Connessi'
      'Gruppi'
      'Dati Azienda')
    TabIndex = 0
    OnChange = tsContattiChange
    OnDrawTab = tsContattiDrawTab
  end
  object nbContatti: TNotebook
    Left = 0
    Top = 0
    Width = 491
    Height = 278
    Align = alClient
    TabOrder = 1
    object TPage
      Left = 0
      Top = 0
      Caption = 'Contatti'
      object pnContat: TPanel
        Left = 0
        Top = 0
        Width = 491
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label38: TLabel
          Left = 240
          Top = 10
          Width = 75
          Height = 13
          Caption = 'Mostra i contatti'
        end
        object NavContatti: TRGNavigator
          Left = 10
          Top = 3
          Width = 220
          Height = 25
          Hint = 'Pannello di navigazione nei dati'
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh, nbInsert, nbDelete, nbEdit]
          ParentShowHint = False
          ConfirmDelete = False
          ConfirmInsert = False
          ConfirmEdit = False
          ConfirmPost = False
          ConfirmCancel = False
          ShowHint = True
          TabOrder = 0
          ColorScroll = ncBlue
          ColorFunc = ncBlue
          ColorCtrl = ncBlack
          ColorTool = ncBlack
          SizeOfKey = X4
          CaptionExtra1 = 'Extra1'
          CaptionExtra2 = 'Extra2'
          CaptionExtra3 = 'Extra3'
          DataSource = dsContat
        end
        object cbOrder: TComboBox
          Left = 325
          Top = 5
          Width = 145
          Height = 21
          Style = csDropDownList
          TabOrder = 1
          OnChange = cbOrderChange
          Items.Strings = (
            'come inseriti'
            'ordinati per denominativo'
            'ordinati per settore'
            'ordinati per classe')
        end
      end
      object sbContat: TScrollBox
        Left = 0
        Top = 36
        Width = 491
        Height = 242
        HorzScrollBar.Margin = 6
        VertScrollBar.Margin = 6
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 1
        object Label1: TLabel
          Left = 12
          Top = 55
          Width = 21
          Height = 13
          Caption = 'Tipo'
        end
        object Label8: TLabel
          Left = 316
          Top = 55
          Width = 34
          Height = 13
          Caption = 'Settore'
          FocusControl = EditSettore
        end
        object Label9: TLabel
          Left = 166
          Top = 55
          Width = 31
          Height = 13
          Caption = 'Classe'
          FocusControl = EditSettore
        end
        object Label10: TLabel
          Left = 10
          Top = 105
          Width = 55
          Height = 13
          Caption = 'Annotazioni'
        end
        object Label36: TLabel
          Left = 345
          Top = 105
          Width = 56
          Height = 13
          Caption = 'Soprannomi'
        end
        object RxSpeedButton1: TJvSpeedButton
          Left = 305
          Top = 100
          Width = 27
          Height = 20
          DropDownMenu = pmNickName
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'MS Sans Serif'
          HotTrackFont.Style = []
          NumGlyphs = 2
          Transparent = True
        end
        object EditSettore: TDBEdit
          Left = 316
          Top = 70
          Width = 165
          Height = 21
          DataField = 'Settore'
          DataSource = dsContat
          TabOrder = 4
        end
        object DBMemo2: TDBMemo
          Left = 10
          Top = 120
          Width = 281
          Height = 110
          DataField = 'Note'
          DataSource = dsContat
          TabOrder = 5
        end
        object DBEdit2: TDBEdit
          Left = 166
          Top = 70
          Width = 125
          Height = 21
          DataField = 'Classe'
          DataSource = dsContat
          TabOrder = 3
        end
        object cbTipoCont: TJvDBComboBox
          Left = 10
          Top = 69
          Width = 131
          Height = 21
          DataField = 'Tipo'
          DataSource = dsContat
          ItemHeight = 13
          Items.Strings = (
            'Persona'
            'Azienda')
          TabOrder = 2
          Values.Strings = (
            '0'
            '1')
          ListSettings.OutfilteredValueFont.Charset = DEFAULT_CHARSET
          ListSettings.OutfilteredValueFont.Color = clRed
          ListSettings.OutfilteredValueFont.Height = -11
          ListSettings.OutfilteredValueFont.Name = 'Tahoma'
          ListSettings.OutfilteredValueFont.Style = []
          OnChange = cbTipoContChange
        end
        object pnContAzie: TPanel
          Left = 0
          Top = 0
          Width = 426
          Height = 51
          Caption = 'pnContAzie'
          TabOrder = 1
          object lbNome_Suf: TLabel
            Left = 312
            Top = 0
            Width = 58
            Height = 13
            Caption = 'Tipo societ'#224
          end
          object lbNome_Main: TLabel
            Left = 11
            Top = 0
            Width = 76
            Height = 13
            Caption = 'Ragione sociale'
            FocusControl = iNome_Main
          end
          object iNome_Suf: TDBComboBox
            Left = 311
            Top = 16
            Width = 80
            Height = 21
            DataField = 'Nome_Suf'
            DataSource = dsContat
            Items.Strings = (
              ''
              'D.I.'
              'S.r.l.'
              'S.p.A.'
              'S.a.s.'
              'S.a.p.A.'
              'S.d.f.')
            TabOrder = 1
          end
          object iNome_Main: TDBEdit
            Left = 10
            Top = 17
            Width = 290
            Height = 21
            DataField = 'Nome_Main'
            DataSource = dsContat
            TabOrder = 0
          end
        end
        object dgNickName: TJvDBGrid
          Left = 305
          Top = 120
          Width = 176
          Height = 110
          DataSource = dsNickName
          Options = [dgEditing, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgTitleClick, dgTitleHotTrack]
          PopupMenu = pmNickName
          TabOrder = 6
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlack
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnEnter = dgNickNameEnter
          SelectColumnsDialogStrings.Caption = 'Select columns'
          SelectColumnsDialogStrings.OK = '&OK'
          SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
          EditControls = <>
          RowsHeight = 17
          TitleRowHeight = 17
        end
        object pnContPers: TPanel
          Left = 5
          Top = 0
          Width = 476
          Height = 46
          TabOrder = 0
          object Label11: TLabel
            Left = 261
            Top = 0
            Width = 45
            Height = 13
            Caption = 'Cognome'
            FocusControl = iNome_Main
          end
          object Label12: TLabel
            Left = 57
            Top = 0
            Width = 28
            Height = 13
            Caption = 'Nome'
          end
          object Label13: TLabel
            Left = 3
            Top = 0
            Width = 22
            Height = 13
            Caption = 'Titoli'
          end
          object Label33: TLabel
            Left = 159
            Top = 0
            Width = 72
            Height = 13
            Caption = 'Secondo nome'
            FocusControl = iNome_Main
          end
          object DBEdit3: TDBEdit
            Left = 261
            Top = 17
            Width = 210
            Height = 21
            DataField = 'Nome_Main'
            DataSource = dsContat
            TabOrder = 3
          end
          object DBEdit8: TDBEdit
            Left = 57
            Top = 17
            Width = 100
            Height = 21
            DataField = 'Nome_Pre1'
            DataSource = dsContat
            TabOrder = 1
          end
          object DBEdit9: TDBEdit
            Left = 5
            Top = 17
            Width = 50
            Height = 21
            DataField = 'Nome_Tit'
            DataSource = dsContat
            TabOrder = 0
          end
          object DBEdit14: TDBEdit
            Left = 159
            Top = 17
            Width = 100
            Height = 21
            DataField = 'Nome_Pre2'
            DataSource = dsContat
            TabOrder = 2
          end
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Indirizzi'
      object pnIndir: TPanel
        Left = 0
        Top = 0
        Width = 491
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object txIndir: TDBText
          Left = 285
          Top = 10
          Width = 28
          Height = 13
          AutoSize = True
          DataField = 'Nome'
          DataSource = dsContat
        end
        object lbIndir: TLabel
          Left = 235
          Top = 10
          Width = 45
          Height = 13
          Caption = 'Indirizzi di'
        end
        object NavIndir: TRGNavigator
          Left = 10
          Top = 3
          Width = 210
          Height = 25
          Hint = 'Pannello di navigazione nei dati'
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh, nbInsert, nbDelete, nbEdit]
          ParentShowHint = False
          ConfirmInsert = False
          ConfirmEdit = False
          ConfirmPost = False
          ConfirmCancel = False
          ShowHint = True
          TabOrder = 0
          ColorScroll = ncBlue
          ColorFunc = ncBlue
          ColorCtrl = ncBlack
          ColorTool = ncBlack
          SizeOfKey = X4
          CaptionExtra1 = 'Extra1'
          CaptionExtra2 = 'Extra2'
          CaptionExtra3 = 'Extra3'
          DataSource = dsIndir
        end
      end
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 36
        Width = 491
        Height = 242
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 1
        object Label2: TLabel
          Left = 15
          Top = 125
          Width = 53
          Height = 13
          Caption = 'Altri indirizzi'
        end
        object Label15: TLabel
          Left = 105
          Top = 45
          Width = 165
          Height = 13
          Caption = 'Indirizzo correntemente selezionato'
        end
        object Label16: TLabel
          Left = 15
          Top = 15
          Width = 61
          Height = 13
          Caption = 'Tipo indirizzo'
        end
        object Label14: TLabel
          Left = 250
          Top = 15
          Width = 23
          Height = 13
          Caption = 'Note'
        end
        object pnIndiTrad: TPanel
          Left = 15
          Top = 60
          Width = 81
          Height = 56
          TabOrder = 4
          object Label3: TLabel
            Left = 60
            Top = 0
            Width = 15
            Height = 13
            Alignment = taRightJustify
            Caption = 'Via'
          end
          object Label4: TLabel
            Left = 10
            Top = 14
            Width = 64
            Height = 13
            Alignment = taRightJustify
            Caption = 'CAP Citt'#224' (Pr)'
          end
          object Label5: TLabel
            Left = 50
            Top = 28
            Width = 25
            Height = 13
            Alignment = taRightJustify
            Caption = 'Stato'
          end
        end
        object pnIndiElet: TPanel
          Left = 15
          Top = 60
          Width = 86
          Height = 51
          TabOrder = 5
          object Label6: TLabel
            Left = 50
            Top = 0
            Width = 22
            Height = 13
            Caption = 'URL'
          end
          object btConnect: TBitBtn
            Left = 5
            Top = 20
            Width = 75
            Height = 25
            Caption = 'Connetti'
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000120B0000120B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
              000037777777777777770FFFFFFFFFFFFFF07F3333FFF33333370FFFF777FFFF
              FFF07F333777333333370FFFFFFFFFFFFFF07F3333FFFFFF33370FFFF7777BBF
              FFF07F333777777F3FF70FFFFFFFB9BF1CC07F3FFF337F7377770F777FFFB99B
              C1C07F7773337F377F370FFFFFFFB9BBC1C07FFFFFFF7F337FF700000077B999
              B000777777777F33777733337377B9999B33333F733373F337FF3377377B99BB
              9BB33377F337F377377F3737377B9B79B9B737F73337F7F7F37F33733777BB7B
              BBB73373333377F37F3737333777BB777B9B3733333377F337F7333333777B77
              77BB3333333337333377333333333777337B3333333333333337}
            NumGlyphs = 2
            TabOrder = 0
            OnClick = btConnectClick
          end
        end
        object DBGrid4: TJvDBGrid
          Left = 15
          Top = 139
          Width = 461
          Height = 90
          DataSource = dsIndir
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 3
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlack
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = DBGrid4DblClick
          OnGetCellParams = DBGrid4GetCellParams
          SelectColumnsDialogStrings.Caption = 'Select columns'
          SelectColumnsDialogStrings.OK = '&OK'
          SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
          EditControls = <>
          RowsHeight = 17
          TitleRowHeight = 17
        end
        object DBMemo1: TDBMemo
          Left = 101
          Top = 60
          Width = 335
          Height = 61
          DataField = 'Indirizzo'
          DataSource = dsIndir
          TabOrder = 2
        end
        object cbTipoIndir: TJvDBComboBox
          Left = 90
          Top = 9
          Width = 131
          Height = 21
          DataField = 'Tipo'
          DataSource = dsIndir
          ItemHeight = 13
          Items.Strings = (
            'Tradizionale'
            'Elettronico')
          TabOrder = 0
          Values.Strings = (
            '0'
            '1')
          ListSettings.OutfilteredValueFont.Charset = DEFAULT_CHARSET
          ListSettings.OutfilteredValueFont.Color = clRed
          ListSettings.OutfilteredValueFont.Height = -11
          ListSettings.OutfilteredValueFont.Name = 'Tahoma'
          ListSettings.OutfilteredValueFont.Style = []
          OnChange = cbTipoIndirChange
        end
        object DBEdit1: TDBEdit
          Left = 285
          Top = 10
          Width = 186
          Height = 21
          DataField = 'Note'
          DataSource = dsIndir
          TabOrder = 1
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Telefoni'
      object pnTelef: TPanel
        Left = 0
        Top = 0
        Width = 491
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lbTelef: TLabel
          Left = 235
          Top = 10
          Width = 49
          Height = 13
          Caption = 'Telefoni di'
        end
        object txTelef: TDBText
          Left = 290
          Top = 10
          Width = 32
          Height = 13
          AutoSize = True
          DataField = 'Nome'
          DataSource = dsContat
        end
        object NavTelef: TRGNavigator
          Left = 10
          Top = 3
          Width = 210
          Height = 25
          Hint = 'Pannello di navigazione nei dati'
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh, nbInsert, nbDelete, nbEdit]
          ParentShowHint = False
          ConfirmInsert = False
          ConfirmEdit = False
          ConfirmPost = False
          ConfirmCancel = False
          ShowHint = True
          TabOrder = 0
          ColorScroll = ncBlue
          ColorFunc = ncBlue
          ColorCtrl = ncBlack
          ColorTool = ncBlack
          SizeOfKey = X4
          CaptionExtra1 = 'Extra1'
          CaptionExtra2 = 'Extra2'
          CaptionExtra3 = 'Extra3'
          DataSource = dsTelef
        end
      end
      object DBGrid2: TJvDBGrid
        Left = 0
        Top = 116
        Width = 491
        Height = 162
        Align = alClient
        DataSource = dsTelef
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
      end
      object Panel1: TPanel
        Left = 0
        Top = 36
        Width = 491
        Height = 80
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object Label26: TLabel
          Left = 270
          Top = 8
          Width = 62
          Height = 13
          Caption = 'Tipo telefono'
        end
        object Label27: TLabel
          Left = 270
          Top = 40
          Width = 23
          Height = 13
          Caption = 'Note'
        end
        object Label28: TLabel
          Left = 10
          Top = 8
          Width = 90
          Height = 13
          Caption = 'Pref. internazionale'
        end
        object Label29: TLabel
          Left = 10
          Top = 40
          Width = 77
          Height = 13
          Caption = 'Num. di telefono'
        end
        object Label30: TLabel
          Left = 160
          Top = 8
          Width = 37
          Height = 13
          Caption = 'Prefisso'
        end
        object Label31: TLabel
          Left = 10
          Top = 65
          Width = 96
          Height = 13
          Caption = 'Altri numeri telefonici'
        end
        object RxDBComboBox1: TJvDBComboBox
          Left = 340
          Top = 5
          Width = 140
          Height = 21
          DataField = 'Tipo'
          DataSource = dsTelef
          ItemHeight = 13
          Items.Strings = (
            'Normale'
            'Fax'
            'Voce+Fax'
            'Casella vocale')
          TabOrder = 3
          Values.Strings = (
            '0'
            '1'
            '2'
            '3')
          ListSettings.OutfilteredValueFont.Charset = DEFAULT_CHARSET
          ListSettings.OutfilteredValueFont.Color = clRed
          ListSettings.OutfilteredValueFont.Height = -11
          ListSettings.OutfilteredValueFont.Name = 'Tahoma'
          ListSettings.OutfilteredValueFont.Style = []
        end
        object DBEdit10: TDBEdit
          Left = 300
          Top = 35
          Width = 181
          Height = 21
          DataField = 'Note'
          DataSource = dsTelef
          TabOrder = 4
        end
        object iPre1: TDBEdit
          Left = 105
          Top = 5
          Width = 51
          Height = 21
          DataField = 'Tel_Pre1'
          DataSource = dsTelef
          TabOrder = 0
        end
        object iPre2: TDBEdit
          Left = 205
          Top = 5
          Width = 51
          Height = 21
          DataField = 'Tel_Pre2'
          DataSource = dsTelef
          TabOrder = 1
        end
        object iNum: TDBEdit
          Left = 105
          Top = 35
          Width = 151
          Height = 21
          DataField = 'Telefono'
          DataSource = dsTelef
          TabOrder = 2
          OnExit = iNumExit
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Date Importanti'
      object pnDateImpo: TPanel
        Left = 0
        Top = 0
        Width = 491
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lbDateImpo: TLabel
          Left = 205
          Top = 10
          Width = 64
          Height = 13
          Caption = 'Data legate a'
        end
        object txDateImpo: TDBText
          Left = 275
          Top = 10
          Width = 54
          Height = 13
          AutoSize = True
          DataField = 'Nome'
          DataSource = dsContat
        end
        object NavDateImpo: TRGNavigator
          Left = 5
          Top = 3
          Width = 190
          Height = 25
          Hint = 'Pannello di navigazione nei dati'
          VisibleButtons = [nbFirst, nbLast, nbRefresh, nbInsert, nbDelete]
          ParentShowHint = False
          ConfirmInsert = False
          ConfirmEdit = False
          ConfirmPost = False
          ConfirmCancel = False
          ShowHint = True
          TabOrder = 0
          ColorScroll = ncBlue
          ColorFunc = ncBlue
          ColorCtrl = ncBlack
          ColorTool = ncBlack
          SizeOfKey = X4
          CaptionExtra1 = 'Extra1'
          CaptionExtra2 = 'Extra2'
          CaptionExtra3 = 'Extra3'
          DataSource = dsDateImpo
        end
      end
      object DBGrid3: TJvDBGrid
        Left = 0
        Top = 36
        Width = 491
        Height = 242
        Align = alClient
        DataSource = dsDateImpo
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Referenti'
      object pnRefer: TPanel
        Left = 0
        Top = 0
        Width = 491
        Height = 71
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object txRefer: TDBText
          Left = 270
          Top = 10
          Width = 34
          Height = 13
          AutoSize = True
          DataField = 'Nome'
          DataSource = dsContat
        end
        object lbRefer: TLabel
          Left = 205
          Top = 10
          Width = 61
          Height = 13
          Caption = 'Referenti per'
        end
        object BitBtn1: TBitBtn
          Left = 10
          Top = 40
          Width = 166
          Height = 25
          Caption = 'Aggiungi il contatto'
          TabOrder = 0
          OnClick = BitBtn1Click
        end
        object lcNewRef: TJvDBLookupCombo
          Left = 185
          Top = 41
          Width = 191
          Height = 22
          LookupField = 'CodCon'
          LookupDisplay = 'Nome'
          LookupSource = dsContatti2
          TabOrder = 1
        end
        object NavRefer: TRGNavigator
          Left = 10
          Top = 3
          Width = 186
          Height = 25
          Hint = 'Pannello di navigazione nei dati'
          VisibleButtons = [nbFirst, nbLast, nbRefresh, nbDelete]
          ParentShowHint = False
          ConfirmInsert = False
          ConfirmEdit = False
          ConfirmPost = False
          ConfirmCancel = False
          ShowHint = True
          TabOrder = 2
          ColorScroll = ncBlue
          ColorFunc = ncBlue
          ColorCtrl = ncBlack
          ColorTool = ncBlack
          SizeOfKey = X4
          CaptionExtra1 = 'Extra1'
          CaptionExtra2 = 'Extra2'
          CaptionExtra3 = 'Extra3'
          DataSource = dsRefer
        end
      end
      object DBGrid1: TJvDBGrid
        Left = 0
        Top = 71
        Width = 491
        Height = 89
        Align = alClient
        DataSource = dsRefer
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
      end
      object Panel2: TPanel
        Left = 0
        Top = 160
        Width = 491
        Height = 118
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object Label32: TLabel
          Left = 10
          Top = 10
          Width = 127
          Height = 13
          Caption = 'Il contatto '#232' un referente di'
        end
        object DBGrid5: TJvDBGrid
          Left = 0
          Top = 35
          Width = 491
          Height = 83
          Align = alBottom
          DataSource = dsReferDi
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlack
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          SelectColumnsDialogStrings.Caption = 'Select columns'
          SelectColumnsDialogStrings.OK = '&OK'
          SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
          EditControls = <>
          RowsHeight = 17
          TitleRowHeight = 17
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Comunicazioni'
      object pnComunic: TPanel
        Left = 0
        Top = 0
        Width = 491
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object txComun: TDBText
          Left = 290
          Top = 10
          Width = 41
          Height = 13
          AutoSize = True
          DataField = 'Nome'
          DataSource = dsContat
        end
        object lbComun: TLabel
          Left = 230
          Top = 10
          Width = 52
          Height = 13
          Caption = 'Connessi a'
        end
        object NavConnessi: TRGNavigator
          Left = 10
          Top = 3
          Width = 210
          Height = 25
          Hint = 'Pannello di navigazione nei dati'
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh, nbInsert, nbDelete, nbEdit]
          Hints.Strings = (
            'First'
            'Prev'
            'Next'
            'Last'
            'Refresh'
            'Insert'
            'Delete'
            'Edit'
            'Post'
            'Cancel'
            'a'
            'b'
            'c'
            'd'
            'e')
          ParentShowHint = False
          ConfirmInsert = False
          ConfirmEdit = False
          ConfirmPost = False
          ConfirmCancel = False
          ShowHint = True
          TabOrder = 0
          ColorScroll = ncBlue
          ColorFunc = ncBlue
          ColorCtrl = ncBlack
          ColorTool = ncBlack
          SizeOfKey = X4
          CaptionExtra1 = 'Extra1'
          CaptionExtra2 = 'Extra2'
          CaptionExtra3 = 'Extra3'
          DataSource = dsConnessi
        end
      end
      object sbConnessi: TScrollBox
        Left = 0
        Top = 36
        Width = 491
        Height = 242
        Hint = 
          'E'#39' possibile aggiungere dei nuovi connessi semplicemente '#13#10'utili' +
          'zzando il drag&drop offerto dall'#39'Eplorer di Windows'
        Align = alClient
        BorderStyle = bsNone
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        object Label7: TLabel
          Left = 170
          Top = 5
          Width = 49
          Height = 13
          Caption = 'Contenuto'
        end
        object Label17: TLabel
          Left = 15
          Top = 25
          Width = 23
          Height = 13
          Caption = 'Note'
        end
        object Label18: TLabel
          Left = 15
          Top = 5
          Width = 23
          Height = 13
          Caption = 'Data'
        end
        object Label35: TLabel
          Left = 15
          Top = 115
          Width = 156
          Height = 13
          Caption = 'Altre risorse connesse al contatto'
        end
        object Label37: TLabel
          Left = 15
          Top = 90
          Width = 21
          Height = 13
          Caption = 'Tipo'
        end
        object DBEdit4: TDBEdit
          Left = 230
          Top = 0
          Width = 246
          Height = 21
          DataField = 'Contenuto'
          DataSource = dsConnessi
          TabOrder = 0
        end
        object DBMemo3: TDBMemo
          Left = 15
          Top = 40
          Width = 461
          Height = 36
          DataField = 'Note'
          DataSource = dsConnessi
          TabOrder = 1
        end
        object DBDateEdit1: TJvDBDateEdit
          Left = 50
          Top = 0
          Width = 111
          Height = 21
          DataField = 'Data'
          DataSource = dsConnessi
          DefaultToday = True
          NumGlyphs = 2
          TabOrder = 2
        end
        object RxDBGrid2: TJvDBGrid
          Left = 15
          Top = 135
          Width = 461
          Height = 96
          DataSource = dsConnessi
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 3
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlack
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          SelectColumnsDialogStrings.Caption = 'Select columns'
          SelectColumnsDialogStrings.OK = '&OK'
          SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
          EditControls = <>
          RowsHeight = 17
          TitleRowHeight = 17
        end
        object cbTipoConn: TJvDBComboBox
          Left = 40
          Top = 85
          Width = 111
          Height = 21
          DataField = 'Tipo'
          DataSource = dsConnessi
          ItemHeight = 13
          Items.Strings = (
            'Comunicazione'
            'Risorsa locale'
            'Risorsa generica')
          TabOrder = 4
          Values.Strings = (
            '0'
            '1'
            '2')
          ListSettings.OutfilteredValueFont.Charset = DEFAULT_CHARSET
          ListSettings.OutfilteredValueFont.Color = clRed
          ListSettings.OutfilteredValueFont.Height = -11
          ListSettings.OutfilteredValueFont.Name = 'Tahoma'
          ListSettings.OutfilteredValueFont.Style = []
          OnChange = cbTipoConnChange
        end
        object pnURL: TPanel
          Left = 155
          Top = 85
          Width = 325
          Height = 31
          Caption = 'pnURL'
          TabOrder = 5
          object btOpenURL: TJvSpeedButton
            Left = 296
            Top = 0
            Width = 25
            Height = 25
            Hint = 'Apri la risorsa'
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000120B0000120B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
              5555555555FFFFF555555555544C4C5555555555F777775FF5555554C444C444
              5555555775FF55775F55554C4334444445555575577F55557FF554C4C334C4C4
              335557F5577FF55577F554CCC3334444335557555777F555775FCCCCC333CCC4
              C4457F55F777F555557F4CC33333CCC444C57F577777F5F5557FC4333333C3C4
              CCC57F777777F7FF557F4CC33333333C4C457F577777777F557FCCC33CC4333C
              C4C575F7755F777FF5755CCCCC3333334C5557F5FF777777F7F554C333333333
              CC55575777777777F755553333CC3C33C555557777557577755555533CC4C4CC
              5555555775FFFF77555555555C4CCC5555555555577777555555}
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'MS Sans Serif'
            HotTrackFont.Style = []
            NumGlyphs = 2
            OnClick = btOpenURLClick
          end
          object btPreview: TJvSpeedButton
            Left = 271
            Top = 0
            Width = 25
            Height = 25
            Hint = 'Mostra la finestra con l'#39'anteprima del file'
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000120B0000120B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
              033333FFFF77777773F330000077777770333777773FFFFFF733077777000000
              03337F3F3F777777733F0797A770003333007F737337773F3377077777778803
              30807F333333337FF73707888887880007707F3FFFF333777F37070000878807
              07807F777733337F7F3707888887880808807F333333337F7F37077777778800
              08807F333FFF337773F7088800088803308073FF777FFF733737300008000033
              33003777737777333377333080333333333333F7373333333333300803333333
              33333773733333333333088033333333333373F7F33333333333308033333333
              3333373733333333333333033333333333333373333333333333}
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'MS Sans Serif'
            HotTrackFont.Style = []
            NumGlyphs = 2
            OnClick = btPreviewClick
          end
          object lbURL: TLabel
            Left = 5
            Top = 6
            Width = 22
            Height = 13
            Caption = 'URL'
          end
          object btLocate: TJvSpeedButton
            Left = 246
            Top = 0
            Width = 25
            Height = 25
            Hint = 'Localizza la risorsa'
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000120B0000120B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
              55555555FFFFFFFFFF55555000000000055555577777777775F55500B8B8B8B8
              B05555775F555555575F550F0B8B8B8B8B05557F75F555555575550BF0B8B8B8
              B8B0557F575FFFFFFFF7550FBF0000000000557F557777777777500BFBFBFBFB
              0555577F555555557F550B0FBFBFBFBF05557F7F555555FF75550F0BFBFBF000
              55557F75F555577755550BF0BFBF0B0555557F575FFF757F55550FB700007F05
              55557F557777557F55550BFBFBFBFB0555557F555555557F55550FBFBFBFBF05
              55557FFFFFFFFF7555550000000000555555777777777755555550FBFB055555
              5555575FFF755555555557000075555555555577775555555555}
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'MS Sans Serif'
            HotTrackFont.Style = []
            NumGlyphs = 2
            OnClick = btLocateClick
          end
          object iURL: TDBEdit
            Left = 35
            Top = 2
            Width = 206
            Height = 21
            DataField = 'URL'
            DataSource = dsConnessi
            TabOrder = 0
            OnChange = iURLChange
          end
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Gruppi'
      object pnGruppi: TPanel
        Left = 0
        Top = 0
        Width = 491
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label34: TLabel
          Left = 205
          Top = 10
          Width = 110
          Height = 13
          Caption = 'Gruppi a cui appartiene'
        end
        object txGruppi: TDBText
          Left = 323
          Top = 10
          Width = 39
          Height = 13
          AutoSize = True
          DataField = 'Nome'
          DataSource = dsContat
        end
        object NavGruppi: TRGNavigator
          Left = 10
          Top = 3
          Width = 190
          Height = 25
          Hint = 'Pannello di navigazione nei dati'
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh]
          ParentShowHint = False
          ConfirmInsert = False
          ConfirmEdit = False
          ConfirmPost = False
          ConfirmCancel = False
          ShowHint = True
          TabOrder = 0
          ColorScroll = ncBlue
          ColorFunc = ncBlue
          ColorCtrl = ncBlack
          ColorTool = ncBlack
          SizeOfKey = X4
          CaptionExtra1 = 'Extra1'
          CaptionExtra2 = 'Extra2'
          CaptionExtra3 = 'Extra3'
          DataSource = dsGruppi
        end
      end
      object dgGruppi: TJvDBGrid
        Left = 15
        Top = 40
        Width = 236
        Height = 231
        DataSource = dsGruppi
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDblClick = dgGruppiDblClick
        OnKeyPress = dgGruppiKeyPress
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Dati Azienda'
      object pnAziend: TPanel
        Left = 0
        Top = 0
        Width = 491
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object txAziend: TDBText
          Left = 303
          Top = 10
          Width = 40
          Height = 13
          AutoSize = True
          DataField = 'Nome'
          DataSource = dsContat
        end
        object lbAziend: TLabel
          Left = 230
          Top = 10
          Width = 63
          Height = 13
          Caption = 'Dati aziendali'
        end
        object NavAzienda: TRGNavigator
          Left = 10
          Top = 3
          Width = 210
          Height = 25
          Hint = 'Pannello di navigazione nei dati'
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh, nbInsert, nbDelete, nbEdit]
          ParentShowHint = False
          ConfirmInsert = False
          ConfirmEdit = False
          ConfirmPost = False
          ConfirmCancel = False
          ShowHint = True
          TabOrder = 0
          ColorScroll = ncBlue
          ColorFunc = ncBlue
          ColorCtrl = ncBlack
          ColorTool = ncBlack
          SizeOfKey = X4
          CaptionExtra1 = 'Extra1'
          CaptionExtra2 = 'Extra2'
          CaptionExtra3 = 'Extra3'
          DataSource = dsAziende
        end
      end
      object ScrollBox3: TScrollBox
        Left = 0
        Top = 36
        Width = 491
        Height = 242
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 1
        object Label19: TLabel
          Left = 15
          Top = 40
          Width = 69
          Height = 13
          Caption = 'Codice Fiscale'
        end
        object Label20: TLabel
          Left = 15
          Top = 90
          Width = 113
          Height = 13
          Caption = 'Ragione Sociale Estesa'
        end
        object Label21: TLabel
          Left = 250
          Top = 10
          Width = 93
          Height = 13
          Caption = 'Data primo contatto'
        end
        object Label22: TLabel
          Left = 250
          Top = 40
          Width = 50
          Height = 13
          Caption = 'Partita IVA'
        end
        object Label23: TLabel
          Left = 15
          Top = 170
          Width = 23
          Height = 13
          Caption = 'Note'
        end
        object Label24: TLabel
          Left = 15
          Top = 8
          Width = 72
          Height = 13
          Caption = 'Tipo di azienda'
        end
        object Label25: TLabel
          Left = 15
          Top = 68
          Width = 85
          Height = 13
          Caption = 'Codice Contabilit'#224
        end
        object DBEdit5: TDBEdit
          Left = 95
          Top = 35
          Width = 140
          Height = 21
          DataField = 'CodFis'
          DataSource = dsAziende
          TabOrder = 2
        end
        object DBMemo4: TDBMemo
          Left = 15
          Top = 110
          Width = 461
          Height = 51
          DataField = 'Nome'
          DataSource = dsAziende
          TabOrder = 5
        end
        object DBDateEdit2: TJvDBDateEdit
          Left = 350
          Top = 5
          Width = 121
          Height = 21
          DataField = 'FirstContact'
          DataSource = dsAziende
          NumGlyphs = 2
          TabOrder = 1
        end
        object DBEdit6: TDBEdit
          Left = 330
          Top = 35
          Width = 140
          Height = 21
          DataField = 'ParIVA'
          DataSource = dsAziende
          TabOrder = 3
        end
        object DBMemo5: TDBMemo
          Left = 15
          Top = 185
          Width = 461
          Height = 46
          DataField = 'Note'
          DataSource = dsAziende
          TabOrder = 6
        end
        object DBEdit7: TDBEdit
          Left = 150
          Top = 65
          Width = 86
          Height = 21
          DataField = 'CodAux'
          DataSource = dsAziende
          TabOrder = 4
        end
        object RxDBComboBox3: TJvDBComboBox
          Left = 95
          Top = 4
          Width = 141
          Height = 21
          DataField = 'Tipo'
          DataSource = dsAziende
          ItemHeight = 13
          Items.Strings = (
            'Contatto'
            'Fornitore'
            'Cliente'
            'Cliente/Fornitore')
          TabOrder = 0
          Values.Strings = (
            '0'
            '1'
            '2'
            '3')
          ListSettings.OutfilteredValueFont.Charset = DEFAULT_CHARSET
          ListSettings.OutfilteredValueFont.Color = clRed
          ListSettings.OutfilteredValueFont.Height = -11
          ListSettings.OutfilteredValueFont.Name = 'Tahoma'
          ListSettings.OutfilteredValueFont.Style = []
        end
      end
    end
  end
  object tbContat: TTable
    BeforePost = tbContatBeforePost
    AfterPost = tbContatAfterPost
    BeforeDelete = tbContatBeforeDelete
    OnCalcFields = tbContatCalcFields
    DatabaseName = 'DB'
    TableName = 'contat.db'
    Left = 15
    Top = 165
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
    object tbContatNome: TStringField
      FieldKind = fkCalculated
      FieldName = 'Nome'
      Size = 80
      Calculated = True
    end
  end
  object dsContat: TDataSource
    DataSet = tbContat
    OnDataChange = dsContatDataChange
    Left = 15
    Top = 180
  end
  object tbAziende: TTable
    DatabaseName = 'DB'
    IndexName = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'AZIENDE.DB'
    Left = 170
    Top = 245
    object tbAziendeCodInt: TIntegerField
      FieldName = 'CodInt'
      Required = True
    end
    object tbAziendeCodCon: TIntegerField
      FieldName = 'CodCon'
      Required = True
    end
    object tbAziendeCodFis: TStringField
      FieldName = 'CodFis'
      Required = True
      Size = 16
    end
    object tbAziendeParIVA: TStringField
      FieldName = 'ParIVA'
      Required = True
      Size = 11
    end
    object tbAziendeNome: TMemoField
      FieldName = 'Nome'
      BlobType = ftMemo
      Size = 100
    end
    object tbAziendeNote: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
      Size = 100
    end
    object tbAziendeFirstContact: TDateField
      FieldName = 'FirstContact'
    end
    object tbAziendeTipo: TIntegerField
      FieldName = 'Tipo'
    end
    object tbAziendeCodAux: TIntegerField
      FieldName = 'CodAux'
    end
  end
  object dsAziende: TDataSource
    DataSet = tbAziende
    Left = 170
    Top = 260
  end
  object tbIndir: TTable
    OnCalcFields = tbIndirCalcFields
    DatabaseName = 'DB'
    IndexName = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'indiriz.db'
    Left = 220
    Top = 230
    object tbIndirCodInd: TIntegerField
      FieldName = 'CodInd'
      Visible = False
    end
    object tbIndirCodCon: TIntegerField
      FieldName = 'CodCon'
      Visible = False
    end
    object tbIndirTipo: TIntegerField
      FieldName = 'Tipo'
      Visible = False
    end
    object tbIndirIndirizzo: TMemoField
      DisplayWidth = 10
      FieldName = 'Indirizzo'
      Visible = False
      BlobType = ftMemo
      Size = 200
    end
    object tbIndirNote: TStringField
      DisplayWidth = 26
      FieldName = 'Note'
      Visible = False
      Size = 40
    end
    object tbIndirIndir: TStringField
      DisplayLabel = 'Indirizzo'
      DisplayWidth = 100
      FieldKind = fkCalculated
      FieldName = 'Indir'
      Size = 100
      Calculated = True
    end
  end
  object dsIndir: TDataSource
    DataSet = tbIndir
    OnDataChange = dsIndirDataChange
    Left = 220
    Top = 250
  end
  object tbConnessi: TTable
    OnCalcFields = tbConnessiCalcFields
    DatabaseName = 'DB'
    IndexName = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'CONNESSI.DB'
    Left = 275
    Top = 240
    object tbConnessiData: TDateTimeField
      FieldName = 'Data'
      Required = True
    end
    object tbConnessiTipoDesc: TStringField
      DisplayLabel = 'Tipo'
      FieldKind = fkCalculated
      FieldName = 'TipoDesc'
      Size = 15
      Calculated = True
    end
    object tbConnessiContenuto: TStringField
      FieldName = 'Contenuto'
      Size = 50
    end
    object tbConnessiCodCos: TIntegerField
      FieldName = 'CodCos'
      Visible = False
    end
    object tbConnessiCodCon: TIntegerField
      FieldName = 'CodCon'
      Required = True
      Visible = False
    end
    object tbConnessiTipo: TIntegerField
      FieldName = 'Tipo'
      Visible = False
    end
    object tbConnessiNote: TMemoField
      FieldName = 'Note'
      Visible = False
      BlobType = ftMemo
      Size = 200
    end
    object tbConnessiURL: TStringField
      FieldName = 'URL'
      Visible = False
      Size = 255
    end
  end
  object dsConnessi: TDataSource
    DataSet = tbConnessi
    OnDataChange = dsConnessiDataChange
    Left = 270
    Top = 255
  end
  object tbTelef: TTable
    OnCalcFields = tbTelefCalcFields
    DatabaseName = 'DB'
    IndexName = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'TELEF.DB'
    Left = 320
    Top = 220
    object tbTelefCodTel: TIntegerField
      FieldName = 'CodTel'
      Visible = False
    end
    object tbTelefCodCon: TIntegerField
      FieldName = 'CodCon'
      Visible = False
    end
    object tbTelefTipo: TIntegerField
      FieldName = 'Tipo'
      Visible = False
    end
    object tbTelefTel_Pre1: TStringField
      DisplayLabel = 'Pre1.'
      DisplayWidth = 6
      FieldName = 'Tel_Pre1'
      Visible = False
      Size = 6
    end
    object tbTelefTel_Pre2: TStringField
      DisplayLabel = 'Pre.'
      DisplayWidth = 6
      FieldName = 'Tel_Pre2'
      Visible = False
      Size = 6
    end
    object tbTelefTelefono: TStringField
      DisplayWidth = 8
      FieldName = 'Telefono'
      Visible = False
      Size = 18
    end
    object tbTelefTelef: TStringField
      Alignment = taRightJustify
      DisplayLabel = 'Numero telefonico'
      DisplayWidth = 16
      FieldKind = fkCalculated
      FieldName = 'Telef'
      Size = 30
      Calculated = True
    end
    object tbTelefTelefTipo: TStringField
      DisplayLabel = 'Tipo telef.'
      FieldKind = fkCalculated
      FieldName = 'TelefTipo'
      Size = 10
      Calculated = True
    end
    object tbTelefNote: TStringField
      DisplayWidth = 45
      FieldName = 'Note'
      Size = 40
    end
  end
  object dsTelef: TDataSource
    DataSet = tbTelef
    Left = 320
    Top = 235
  end
  object tbContatti2: TTable
    OnCalcFields = tbContatti2CalcFields
    DatabaseName = 'DB'
    IndexName = 'IdxNome'
    TableName = 'contat.db'
    Left = 125
    Top = 195
    object tbContatti2CodCon: TIntegerField
      FieldName = 'CodCon'
    end
    object tbContatti2Tipo: TIntegerField
      FieldName = 'Tipo'
    end
    object tbContatti2Nome_Tit: TStringField
      FieldName = 'Nome_Tit'
      Size = 10
    end
    object tbContatti2Nome_Pre1: TStringField
      FieldName = 'Nome_Pre1'
    end
    object tbContatti2Nome_Pre2: TStringField
      FieldName = 'Nome_Pre2'
      Size = 40
    end
    object tbContatti2Nome_Main: TStringField
      FieldName = 'Nome_Main'
      Size = 40
    end
    object tbContatti2Nome_Suf: TStringField
      FieldName = 'Nome_Suf'
      Size = 10
    end
    object tbContatti2Classe: TStringField
      FieldName = 'Classe'
      Size = 15
    end
    object tbContatti2Settore: TStringField
      FieldName = 'Settore'
      Size = 35
    end
    object tbContatti2Note: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
      Size = 100
    end
    object tbContatti2Nome: TStringField
      FieldKind = fkCalculated
      FieldName = 'Nome'
      Size = 80
      Calculated = True
    end
  end
  object dsContatti2: TDataSource
    DataSet = tbContatti2
    Left = 125
    Top = 210
  end
  object tbRefer: TTable
    BeforeInsert = tbReferBeforeInsert
    OnCalcFields = tbReferCalcFields
    DatabaseName = 'DB'
    IndexName = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'REFERENT.DB'
    Left = 380
    Top = 220
    object tbReferProg: TIntegerField
      FieldName = 'Prog'
      Visible = False
    end
    object tbReferCodCon: TIntegerField
      FieldName = 'CodCon'
      Visible = False
    end
    object tbReferCodRef: TIntegerField
      FieldName = 'CodRef'
      Visible = False
    end
    object tbReferRefer: TStringField
      DisplayLabel = 'Referenti'
      DisplayWidth = 20
      FieldKind = fkCalculated
      FieldName = 'Refer'
      Size = 80
      Calculated = True
    end
    object tbReferNote: TStringField
      FieldKind = fkCalculated
      FieldName = 'Note'
      Size = 40
      Calculated = True
    end
  end
  object dsRefer: TDataSource
    DataSet = tbRefer
    Left = 380
    Top = 235
  end
  object tbDateImpo: TTable
    DatabaseName = 'DB'
    IndexName = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'DATEIMPO.DB'
    Left = 415
    Top = 220
    object tbDateImpoProg: TIntegerField
      FieldName = 'Prog'
      Visible = False
    end
    object tbDateImpoCodCon: TIntegerField
      FieldName = 'CodCon'
      Visible = False
    end
    object tbDateImpoTipo: TIntegerField
      FieldName = 'Tipo'
      Visible = False
    end
    object tbDateImpoData: TDateField
      FieldName = 'Data'
    end
    object tbDateImpoNota: TStringField
      FieldName = 'Nota'
      Size = 50
    end
  end
  object dsDateImpo: TDataSource
    DataSet = tbDateImpo
    Left = 415
    Top = 235
  end
  object tbIndir2: TTable
    OnCalcFields = tbIndirCalcFields
    DatabaseName = 'DB'
    TableName = 'indiriz.db'
    Left = 220
    Top = 265
    object tbIndir2CodInd: TIntegerField
      FieldName = 'CodInd'
    end
    object tbIndir2CodCon: TIntegerField
      FieldName = 'CodCon'
    end
    object tbIndir2Tipo: TIntegerField
      FieldName = 'Tipo'
    end
    object tbIndir2Indirizzo: TMemoField
      FieldName = 'Indirizzo'
      BlobType = ftMemo
      Size = 200
    end
    object tbIndir2Note: TStringField
      FieldName = 'Note'
      Size = 40
    end
  end
  object fpContat: TJvFormPlacement
    AppStorage = fmMain.apStorage
    AppStoragePath = '%FORM_NAME%'
    Left = 90
    Top = 51
  end
  object tbReferDi: TTable
    OnCalcFields = tbReferDiCalcFields
    DatabaseName = 'DB'
    IndexFieldNames = 'CodRef'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    ReadOnly = True
    TableName = 'REFERENT.DB'
    Left = 370
    Top = 170
    object tbReferDiProg: TIntegerField
      FieldName = 'Prog'
      Visible = False
    end
    object tbReferDiCodCon: TIntegerField
      FieldName = 'CodCon'
      Required = True
      Visible = False
    end
    object tbReferDiCodRef: TIntegerField
      FieldName = 'CodRef'
      Required = True
      Visible = False
    end
    object tbReferDiRefer: TStringField
      DisplayLabel = 'Nome contatto'
      DisplayWidth = 20
      FieldKind = fkCalculated
      FieldName = 'Refer'
      Size = 80
      Calculated = True
    end
    object tbReferDiNote: TStringField
      FieldKind = fkCalculated
      FieldName = 'Note'
      Size = 40
      Calculated = True
    end
  end
  object dsReferDi: TDataSource
    DataSet = tbReferDi
    Left = 370
    Top = 185
  end
  object tbGruppi: TTable
    BeforeInsert = tbGruppiBeforeInsert
    BeforeDelete = tbGruppiBeforeDelete
    OnCalcFields = tbGruppiCalcFields
    DatabaseName = 'DB'
    IndexName = 'IdxDesc'
    TableName = 'GRUPPI.DB'
    Left = 180
    Top = 165
    object tbGruppiCodGrp: TIntegerField
      FieldName = 'CodGrp'
      Visible = False
    end
    object tbGruppiDesc: TStringField
      DisplayLabel = 'Nomde del gruppo'
      DisplayWidth = 30
      FieldName = 'Desc'
      ReadOnly = True
      Size = 30
    end
    object tbGruppiIn: TStringField
      Alignment = taCenter
      DisplayWidth = 3
      FieldKind = fkCalculated
      FieldName = 'In'
      Size = 1
      Calculated = True
    end
  end
  object dsGruppi: TDataSource
    DataSet = tbGruppi
    Left = 175
    Top = 180
  end
  object tbInGruppo: TTable
    DatabaseName = 'DB'
    TableName = 'INGRUPPO.DB'
    Left = 215
    Top = 165
    object tbInGruppoProg: TIntegerField
      FieldName = 'Prog'
    end
    object tbInGruppoCodCon: TIntegerField
      FieldName = 'CodCon'
    end
    object tbInGruppoCodGrp: TIntegerField
      FieldName = 'CodGrp'
    end
  end
  object dsInGruppo: TDataSource
    DataSet = tbInGruppo
    Left = 215
    Top = 180
  end
  object flInGruppo: TJvDBFilter
    DataSource = dsInGruppo
    OnFiltering = flInGruppoFiltering
    Left = 391
    Top = 22
  end
  object tbNickName: TTable
    DatabaseName = 'DB'
    IndexName = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'NICKNAME.DB'
    Left = 300
    Top = 171
    object tbNickNameProg: TIntegerField
      FieldName = 'Prog'
      Visible = False
    end
    object tbNickNameCodCon: TIntegerField
      FieldName = 'CodCon'
      Visible = False
    end
    object tbNickNameNickName: TStringField
      FieldName = 'NickName'
      Size = 40
    end
  end
  object dsNickName: TDataSource
    DataSet = tbNickName
    Left = 300
    Top = 186
  end
  object DBConnection: TDBConnectionLink
    Active = False
    OnConnect = DBConnectionEvent
    OnDisconnect = DBConnectionEvent
    Left = 25
    Top = 226
  end
  object DBMessage: TDBMessageLink
    Active = False
    OnMessage = DBMessageMessage
    Left = 55
    Top = 226
  end
  object pmNickName: TPopupMenu
    Left = 420
    Top = 166
    object miNickAdd: TMenuItem
      Caption = 'Aggiungi'
      OnClick = miNickAddClick
    end
    object miNickEdit: TMenuItem
      Caption = 'Modifica'
      OnClick = miNickEditClick
    end
    object miNickDel: TMenuItem
      Caption = 'Cancella'
      OnClick = miNickDelClick
    end
  end
  object odURL: TOpenDialog
    Filter = 
      'File con anteprima|*.bmp;*.wmf;*.ico;*.txt;*.wav;*.avi|Altri fil' +
      'e|*.*'
    Options = [ofReadOnly, ofPathMustExist, ofFileMustExist]
    Left = 210
    Top = 131
  end
end
