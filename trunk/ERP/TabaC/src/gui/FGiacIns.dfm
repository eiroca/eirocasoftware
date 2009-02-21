object fmGiacInsert: TfmGiacInsert
  Left = 145
  Top = 165
  Caption = 'Inserimento Giacenze'
  ClientHeight = 304
  ClientWidth = 627
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
  object dgGiac: TRxDrawGrid
    Left = 0
    Top = 66
    Width = 627
    Height = 238
    Align = alClient
    ColCount = 8
    DefaultColWidth = 80
    FixedCols = 0
    RowCount = 100
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goAlwaysShowEditor]
    ScrollBars = ssVertical
    TabOrder = 0
    OnDrawCell = dgGiacDrawCell
    OnEnter = dgGiacEnter
    OnExit = dgGiacExit
    OnGetEditText = dgGiacGetEditText
    OnSelectCell = dgGiacSelectCell
    OnSetEditText = dgGiacSetEditText
    OnGetEditAlign = dgGiacGetEditAlign
    ColWidths = (
      41
      53
      168
      80
      15
      80
      80
      80)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 627
    Height = 66
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Label4: TLabel
      Left = 5
      Top = 43
      Width = 49
      Height = 13
      Caption = 'Ordina per'
    end
    object Label1: TLabel
      Left = 176
      Top = 12
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Caption = 'Data giacenza'
    end
    object Label2: TLabel
      Left = 194
      Top = 43
      Width = 51
      Height = 13
      Alignment = taRightJustify
      Caption = 'Quantit'#224' in'
    end
    object lbTot: TLabel
      Left = 365
      Top = 45
      Width = 89
      Height = 13
      Caption = 'KgC                    L.'
    end
    object lbDataPrezzi: TLabel
      Left = 525
      Top = 5
      Width = 58
      Height = 26
      Caption = 'Prezzi del '#13#10'99/99/9999'
    end
    object cbOrder: TComboBox
      Left = 60
      Top = 39
      Width = 106
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 2
      OnChange = DoSetupIndex
    end
    object cbAttivi: TCheckBox
      Left = 5
      Top = 10
      Width = 166
      Height = 16
      Caption = 'Mostra solo tabacchi attivi'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = DoSetupIndex
    end
    object iDataGiac: TDateEdit
      Left = 255
      Top = 8
      Width = 96
      Height = 21
      CheckOnExit = True
      DialogTitle = 'Seleziona una data'
      NumGlyphs = 2
      TabOrder = 1
      OnAcceptDate = iDataGiacAcceptDate
    end
    object btAdd: TBitBtn
      Left = 360
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Inserisci'
      TabOrder = 4
      OnClick = btAddClick
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
    end
    object btCancel: TBitBtn
      Left = 440
      Top = 5
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Annulla'
      TabOrder = 5
      OnClick = btCancelClick
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
    end
    object cbQta: TComboBox
      Left = 255
      Top = 39
      Width = 100
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 3
      OnChange = cbQtaChange
      Items.Strings = (
        'Qt'#224' inv.'
        'pacchetti'
        'stecche'
        'KgC')
    end
  end
  object tbTaba: TTable
    DatabaseName = 'DB'
    TableName = 'TABACCHI.DB'
    Left = 180
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
  object tbGiacMov: TTable
    DatabaseName = 'DB'
    TableName = 'GIACMOVS.DB'
    Left = 310
    Top = 195
    object tbGiacMovPGIA: TIntegerField
      FieldName = 'PGIA'
      Required = True
    end
    object tbGiacMovCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbGiacMovGIAC: TIntegerField
      FieldName = 'GIAC'
      Required = True
    end
  end
  object tbGiacLst: TTable
    DatabaseName = 'DB'
    TableName = 'GIACLIST.DB'
    Left = 280
    Top = 195
    object tbGiacLstPGIA: TIntegerField
      FieldName = 'PGIA'
    end
    object tbGiacLstDATA: TDateField
      FieldName = 'DATA'
      Required = True
    end
    object tbGiacLstDATAPREZ: TDateField
      FieldName = 'DATAPREZ'
    end
    object tbGiacLstKGC: TFloatField
      FieldName = 'KGC'
    end
    object tbGiacLstVAL: TCurrencyField
      FieldName = 'VAL'
    end
  end
  object tbMTaba: TTable
    DatabaseName = 'DB'
    TableName = 'TABASTAT.DB'
    Left = 245
    Top = 160
    object tbMTabaCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbMTabaMEDA: TFloatField
      FieldName = 'MEDA'
    end
    object tbMTabaMAXA: TFloatField
      FieldName = 'MAXA'
    end
    object tbMTabaMED5: TFloatField
      FieldName = 'MED5'
    end
    object tbMTabaMAX5: TFloatField
      FieldName = 'MAX5'
    end
    object tbMTabaMED0: TFloatField
      FieldName = 'MED0'
    end
    object tbMTabaMAX0: TFloatField
      FieldName = 'MAX0'
    end
  end
  object fsForm: TFormStorage
    UseRegistry = False
    OnRestorePlacement = fsFormRestorePlacement
    StoredValues = <>
    Left = 75
    Top = 115
  end
end