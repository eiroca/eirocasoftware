object fmPatOInsert: TfmPatOInsert
  Left = 196
  Top = 101
  BorderStyle = bsDialog
  Caption = 'Inserimento Giacenze'
  ClientHeight = 427
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dgCons: TJvDrawGrid
    Left = 0
    Top = 86
    Width = 447
    Height = 341
    Align = alClient
    ColCount = 4
    DefaultColWidth = 80
    FixedCols = 0
    RowCount = 100
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goAlwaysShowEditor]
    ScrollBars = ssVertical
    TabOrder = 0
    OnDrawCell = dgConsDrawCell
    OnEnter = dgConsEnter
    OnExit = dgConsExit
    OnGetEditText = dgConsGetEditText
    OnSelectCell = dgConsSelectCell
    OnSetEditText = dgConsSetEditText
    DrawButtons = False
    OnGetEditAlign = dgConsGetEditAlign
    ColWidths = (
      41
      53
      168
      80)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 447
    Height = 86
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Label4: TLabel
      Left = 10
      Top = 33
      Width = 49
      Height = 13
      Caption = 'Ordina per'
    end
    object Label1: TLabel
      Left = 175
      Top = 10
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = 'Data richiesta'
    end
    object Label2: TLabel
      Left = 9
      Top = 58
      Width = 51
      Height = 13
      Alignment = taRightJustify
      Caption = 'Quantit'#224' in'
    end
    object lbTot: TLabel
      Left = 175
      Top = 58
      Width = 89
      Height = 13
      Caption = 'KgC                    L.'
    end
    object Label3: TLabel
      Left = 175
      Top = 33
      Width = 55
      Height = 13
      Caption = 'Richiesta di'
    end
    object cbOrder: TComboBox
      Left = 65
      Top = 29
      Width = 106
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = DoSetupIndex
    end
    object cbAttivi: TCheckBox
      Left = 10
      Top = 8
      Width = 161
      Height = 17
      Caption = 'Mostra solo tabacchi attivi'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = DoSetupIndex
    end
    object iDataPatO: TJvDateEdit
      Left = 250
      Top = 6
      Width = 96
      Height = 21
      CheckOnExit = True
      DialogTitle = 'Seleziona una data'
      NumGlyphs = 2
      TabOrder = 2
      OnAcceptDate = iDataPatOAcceptDate
    end
    object btAdd: TBitBtn
      Left = 360
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Inserisci'
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      Margin = 4
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 4
      OnClick = btAddClick
    end
    object btCancel: TBitBtn
      Left = 360
      Top = 35
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Annulla'
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      Margin = 4
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 5
      OnClick = btCancelClick
    end
    object cbQta: TComboBox
      Left = 65
      Top = 54
      Width = 106
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      OnChange = cbQtaChange
      Items.Strings = (
        'Qt'#224' inv.'
        'pacchetti'
        'stecche'
        'KgC')
    end
    object cbCodPat: TJvDBLookupCombo
      Left = 250
      Top = 29
      Width = 96
      Height = 21
      LookupField = 'CODP'
      LookupDisplay = 'NOME'
      LookupSource = dsPate
      TabOrder = 3
    end
  end
  object tbTaba: TTable
    DatabaseName = 'DB'
    TableName = 'TABACCHI.DB'
    Left = 65
    Top = 160
    object tbTabaCODI: TSmallintField
      DisplayLabel = 'Cod.'
      DisplayWidth = 5
      FieldName = 'CODI'
      ReadOnly = True
      Required = True
    end
    object tbTabaCODS: TStringField
      Alignment = taRightJustify
      DisplayLabel = 'Cod. Sig.'
      FieldName = 'CODS'
      ReadOnly = True
      Required = True
      Size = 4
    end
    object tbTabaDESC: TStringField
      DisplayLabel = 'Nome tabacco'
      FieldName = 'DESC'
      Size = 30
    end
    object tbTabaATTV: TBooleanField
      FieldName = 'ATTV'
      Visible = False
    end
    object tbTabaTIPO: TSmallintField
      FieldName = 'TIPO'
    end
    object tbTabaPROD: TSmallintField
      FieldName = 'PROD'
    end
    object tbTabaCRIT: TSmallintField
      FieldName = 'CRIT'
    end
    object tbTabaMULI: TSmallintField
      FieldName = 'MULI'
    end
    object tbTabaQTAS: TSmallintField
      FieldName = 'QTAS'
    end
    object tbTabaQTAC: TSmallintField
      FieldName = 'QTAC'
    end
    object tbTabaQTAM: TSmallintField
      FieldName = 'QTAM'
    end
    object tbTabaDIFR: TSmallintField
      FieldName = 'DIFR'
    end
  end
  object tbMovs: TTable
    DatabaseName = 'DB'
    TableName = 'PACOMOVS.DB'
    Left = 145
    Top = 165
    object tbMovsPPCO: TIntegerField
      FieldName = 'PPCO'
      Required = True
    end
    object tbMovsCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbMovsCONS: TIntegerField
      FieldName = 'CONS'
      Required = True
    end
  end
  object tbList: TTable
    DatabaseName = 'DB'
    TableName = 'PACOLIST.DB'
    Left = 115
    Top = 165
    object tbListPPCO: TAutoIncField
      FieldName = 'PPCO'
    end
    object tbListCODP: TIntegerField
      FieldName = 'CODP'
      Required = True
    end
    object tbListDATA: TDateField
      FieldName = 'DATA'
    end
    object tbListDATAORDI: TDateField
      FieldName = 'DATAORDI'
      Required = True
    end
    object tbListDATAPREZ: TDateField
      FieldName = 'DATAPREZ'
      Required = True
    end
    object tbListKGC: TFloatField
      FieldName = 'KGC'
    end
    object tbListVAL: TCurrencyField
      FieldName = 'VAL'
      Required = True
    end
  end
  object tbPate: TTable
    DatabaseName = 'DB'
    TableName = 'PATENAME.DB'
    Left = 310
    Top = 110
    object tbPateCODP: TAutoIncField
      FieldName = 'CODP'
    end
    object tbPateNOME: TStringField
      FieldName = 'NOME'
      Required = True
      Size = 30
    end
  end
  object dsPate: TDataSource
    DataSet = tbPate
    Left = 280
    Top = 120
  end
end
