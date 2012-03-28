object fmPrezziInsert: TfmPrezziInsert
  Left = 221
  Top = 174
  Caption = 'Inserimento nuovo listino prezzi'
  ClientHeight = 351
  ClientWidth = 373
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
  object Panel1: TPanel
    Left = 0
    Top = 91
    Width = 373
    Height = 260
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 1
    object dgPrez: TJvDrawGrid
      Left = 1
      Top = 1
      Width = 371
      Height = 258
      Align = alClient
      ColCount = 4
      DefaultColWidth = 80
      FixedCols = 0
      RowCount = 100
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goAlwaysShowEditor]
      ScrollBars = ssVertical
      TabOrder = 0
      OnDrawCell = dgPrezDrawCell
      OnEnter = dgPrezEnter
      OnExit = dgPrezExit
      OnGetEditText = dgPrezGetEditText
      OnSelectCell = dgPrezSelectCell
      OnSetEditText = dgPrezSetEditText
      DrawButtons = False
      OnAcceptEditKey = dgPrezAcceptEditKey
      ColWidths = (
        41
        53
        168
        80)
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 373
    Height = 91
    Align = alTop
    TabOrder = 0
    object Label4: TLabel
      Left = 5
      Top = 33
      Width = 49
      Height = 13
      Caption = 'Ordina per'
    end
    object Label1: TLabel
      Left = 5
      Top = 70
      Width = 53
      Height = 13
      Caption = 'Data prezzi'
    end
    object Label2: TLabel
      Left = 175
      Top = 70
      Width = 26
      Height = 13
      Caption = 'Nota:'
    end
    object cbOrder: TComboBox
      Left = 60
      Top = 30
      Width = 106
      Height = 19
      Style = csOwnerDrawFixed
      ItemHeight = 13
      TabOrder = 1
      OnChange = DoSetupIndex
    end
    object cbAttivi: TCheckBox
      Left = 5
      Top = 5
      Width = 166
      Height = 17
      Caption = 'Mostra solo tabacchi attivi'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = DoSetupIndex
    end
    object iDate: TJvDateEdit
      Left = 65
      Top = 65
      Width = 96
      Height = 21
      CheckOnExit = True
      DialogTitle = 'Seleziona una data'
      NumGlyphs = 2
      TabOrder = 2
      OnChange = iDateChange
    end
    object btAdd: TBitBtn
      Left = 175
      Top = 15
      Width = 89
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
      ModalResult = 1
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 4
      OnClick = btAddClick
    end
    object btCancel: TBitBtn
      Left = 270
      Top = 15
      Width = 89
      Height = 25
      Caption = '&Annulla'
      Kind = bkCancel
      Margin = 4
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 5
      OnClick = btCancelClick
    end
    object iNota: TEdit
      Left = 205
      Top = 65
      Width = 146
      Height = 21
      TabOrder = 3
      Text = 'iNota'
    end
  end
  object tbPrezLst: TTable
    DatabaseName = 'DB'
    TableName = 'PREZLIST.DB'
    Left = 150
    Top = 165
    object tbPrezLstPPRE: TIntegerField
      FieldName = 'PPRE'
    end
    object tbPrezLstDATA: TDateField
      FieldName = 'DATA'
      Required = True
    end
    object tbPrezLstDESC: TStringField
      FieldName = 'DESC'
      Size = 40
    end
  end
  object tbTaba: TTable
    AutoCalcFields = False
    DatabaseName = 'DB'
    TableName = 'TABACCHI.DB'
    Left = 85
    Top = 130
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
  end
  object tbPrezMov: TTable
    DatabaseName = 'DB'
    TableName = 'PREZMOVS.DB'
    Left = 180
    Top = 165
    object tbPrezMovPPRE: TIntegerField
      FieldName = 'PPRE'
      Required = True
    end
    object tbPrezMovCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbPrezMovPREZ: TCurrencyField
      FieldName = 'PREZ'
      Required = True
    end
  end
end
