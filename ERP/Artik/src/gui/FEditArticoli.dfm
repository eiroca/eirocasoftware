object fmEditArticoli: TfmEditArticoli
  Left = 258
  Top = 151
  ActiveControl = Panel1
  Caption = 'Modifica dati articoli'
  ClientHeight = 308
  ClientWidth = 373
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefault
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 373
    Height = 41
    Align = alTop
    TabOrder = 0
    object RGNavigator1: TRGNavigator
      Left = 6
      Top = 10
      Width = 355
      Height = 25
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbSearch, nbRefresh, nbInsert, nbDelete, nbEdit]
      ConfirmEdit = False
      TabOrder = 0
      OnClick = RGNavigator1Click
      ColorScroll = ncBlack
      ColorFunc = ncBlack
      ColorCtrl = ncBlack
      ColorTool = ncBlack
      SizeOfKey = X4
      CaptionExtra1 = 'Extra1'
      CaptionExtra2 = 'Extra2'
      CaptionExtra3 = 'Extra3'
      DataSource = dsArticoli
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 373
    Height = 267
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'Panel2'
    TabOrder = 1
    object ScrollBox: TScrollBox
      Left = 6
      Top = 6
      Width = 361
      Height = 255
      HorzScrollBar.Margin = 6
      HorzScrollBar.Range = 311
      VertScrollBar.Margin = 6
      VertScrollBar.Range = 198
      Align = alClient
      AutoScroll = False
      BorderStyle = bsNone
      TabOrder = 0
      object Label1: TLabel
        Left = 6
        Top = 6
        Width = 31
        Height = 13
        Caption = 'CodAlf'
      end
      object Label2: TLabel
        Left = 63
        Top = 6
        Width = 41
        Height = 13
        Caption = 'CodNum'
        FocusControl = EditCodNum
      end
      object Label3: TLabel
        Left = 9
        Top = 51
        Width = 25
        Height = 13
        Caption = 'Desc'
        FocusControl = iDesc
      end
      object Label4: TLabel
        Left = 5
        Top = 76
        Width = 36
        Height = 13
        Caption = 'CodIVA'
      end
      object Label5: TLabel
        Left = 161
        Top = 74
        Width = 35
        Height = 13
        Caption = 'CodMis'
      end
      object Label6: TLabel
        Left = 77
        Top = 99
        Width = 17
        Height = 13
        Caption = 'Qta'
        FocusControl = EditQta
      end
      object Label7: TLabel
        Left = 148
        Top = 99
        Width = 32
        Height = 13
        Caption = 'QtaInv'
        FocusControl = EditQtaInv
      end
      object Label8: TLabel
        Left = 219
        Top = 99
        Width = 42
        Height = 13
        Caption = 'QtaDelta'
        FocusControl = EditQtaDelta
      end
      object Label9: TLabel
        Left = 290
        Top = 99
        Width = 36
        Height = 13
        Caption = 'QtaAcq'
        FocusControl = EditQtaAcq
      end
      object Label10: TLabel
        Left = 6
        Top = 137
        Width = 34
        Height = 13
        Caption = 'QtaOrd'
        FocusControl = EditQtaOrd
      end
      object Label11: TLabel
        Left = 77
        Top = 137
        Width = 36
        Height = 13
        Caption = 'QtaVen'
        FocusControl = EditQtaVen
      end
      object Label12: TLabel
        Left = 148
        Top = 137
        Width = 33
        Height = 13
        Caption = 'QtaPre'
        FocusControl = EditQtaPre
      end
      object Label13: TLabel
        Left = 219
        Top = 137
        Width = 36
        Height = 13
        Caption = 'QtaSco'
        FocusControl = EditQtaSco
      end
      object Label14: TLabel
        Left = 290
        Top = 137
        Width = 28
        Height = 13
        Caption = 'PrzLis'
        FocusControl = EditPrzLis
      end
      object Label15: TLabel
        Left = 6
        Top = 175
        Width = 32
        Height = 13
        Caption = 'PrzNor'
        FocusControl = EditPrzNor
      end
      object Label16: TLabel
        Left = 77
        Top = 175
        Width = 34
        Height = 13
        Caption = 'PrzSpe'
        FocusControl = EditPrzSpe
      end
      object Label17: TLabel
        Left = 148
        Top = 175
        Width = 33
        Height = 13
        Caption = 'RicNor'
        FocusControl = EditRicNor
      end
      object Label18: TLabel
        Left = 219
        Top = 175
        Width = 35
        Height = 13
        Caption = 'RicSpe'
        FocusControl = EditRicSpe
      end
      object Label19: TLabel
        Left = 290
        Top = 175
        Width = 47
        Height = 13
        Caption = 'PrePriAcq'
        FocusControl = EditPrePriAcq
      end
      object Label20: TLabel
        Left = 6
        Top = 213
        Width = 48
        Height = 13
        Caption = 'PreUltAcq'
        FocusControl = EditPreUltAcq
      end
      object Label21: TLabel
        Left = 77
        Top = 213
        Width = 48
        Height = 13
        Caption = 'DatPriAcq'
        FocusControl = EditDatPriAcq
      end
      object Label22: TLabel
        Left = 148
        Top = 213
        Width = 49
        Height = 13
        Caption = 'DatUltAcq'
        FocusControl = EditDatUltAcq
      end
      object Label23: TLabel
        Left = 219
        Top = 213
        Width = 54
        Height = 13
        Caption = 'CumuloAcq'
        FocusControl = EditCumuloAcq
      end
      object Label24: TLabel
        Left = 290
        Top = 213
        Width = 52
        Height = 13
        Caption = 'CumuloOrd'
        FocusControl = EditCumuloOrd
      end
      object DBText1: TDBText
        Left = 120
        Top = 25
        Width = 42
        Height = 13
        AutoSize = True
        DataField = 'SetMer'
        DataSource = dsArticoli
      end
      object EditCodNum: TDBEdit
        Left = 63
        Top = 21
        Width = 50
        Height = 21
        DataField = 'CodNum'
        DataSource = dsArticoli
        TabOrder = 0
      end
      object iDesc: TDBEdit
        Left = 44
        Top = 46
        Width = 252
        Height = 21
        DataField = 'Desc'
        DataSource = dsArticoli
        TabOrder = 1
      end
      object EditQta: TDBEdit
        Left = 77
        Top = 114
        Width = 65
        Height = 21
        DataField = 'Qta'
        DataSource = dsArticoli
        TabOrder = 2
      end
      object EditQtaInv: TDBEdit
        Left = 148
        Top = 114
        Width = 65
        Height = 21
        DataField = 'QtaInv'
        DataSource = dsArticoli
        TabOrder = 3
      end
      object EditQtaDelta: TDBEdit
        Left = 219
        Top = 114
        Width = 65
        Height = 21
        DataField = 'QtaDelta'
        DataSource = dsArticoli
        TabOrder = 4
      end
      object EditQtaAcq: TDBEdit
        Left = 290
        Top = 114
        Width = 65
        Height = 21
        DataField = 'QtaAcq'
        DataSource = dsArticoli
        TabOrder = 5
      end
      object EditQtaOrd: TDBEdit
        Left = 6
        Top = 152
        Width = 65
        Height = 21
        DataField = 'QtaOrd'
        DataSource = dsArticoli
        TabOrder = 6
      end
      object EditQtaVen: TDBEdit
        Left = 77
        Top = 152
        Width = 65
        Height = 21
        DataField = 'QtaVen'
        DataSource = dsArticoli
        TabOrder = 7
      end
      object EditQtaPre: TDBEdit
        Left = 148
        Top = 152
        Width = 65
        Height = 21
        DataField = 'QtaPre'
        DataSource = dsArticoli
        TabOrder = 8
      end
      object EditQtaSco: TDBEdit
        Left = 219
        Top = 152
        Width = 65
        Height = 21
        DataField = 'QtaSco'
        DataSource = dsArticoli
        TabOrder = 9
      end
      object EditPrzLis: TDBEdit
        Left = 290
        Top = 152
        Width = 65
        Height = 21
        DataField = 'PrzLis'
        DataSource = dsArticoli
        TabOrder = 10
      end
      object EditPrzNor: TDBEdit
        Left = 6
        Top = 190
        Width = 65
        Height = 21
        DataField = 'PrzNor'
        DataSource = dsArticoli
        TabOrder = 11
      end
      object EditPrzSpe: TDBEdit
        Left = 77
        Top = 190
        Width = 65
        Height = 21
        DataField = 'PrzSpe'
        DataSource = dsArticoli
        TabOrder = 12
      end
      object EditRicNor: TDBEdit
        Left = 148
        Top = 190
        Width = 65
        Height = 21
        DataField = 'RicNor'
        DataSource = dsArticoli
        TabOrder = 13
      end
      object EditRicSpe: TDBEdit
        Left = 219
        Top = 190
        Width = 65
        Height = 21
        DataField = 'RicSpe'
        DataSource = dsArticoli
        TabOrder = 14
      end
      object EditPrePriAcq: TDBEdit
        Left = 290
        Top = 190
        Width = 65
        Height = 21
        DataField = 'PrePriAcq'
        DataSource = dsArticoli
        TabOrder = 15
      end
      object EditPreUltAcq: TDBEdit
        Left = 6
        Top = 228
        Width = 65
        Height = 21
        DataField = 'PreUltAcq'
        DataSource = dsArticoli
        TabOrder = 16
      end
      object EditDatPriAcq: TDBEdit
        Left = 77
        Top = 228
        Width = 65
        Height = 21
        DataField = 'DatPriAcq'
        DataSource = dsArticoli
        TabOrder = 17
      end
      object EditDatUltAcq: TDBEdit
        Left = 148
        Top = 228
        Width = 65
        Height = 21
        DataField = 'DatUltAcq'
        DataSource = dsArticoli
        TabOrder = 18
      end
      object EditCumuloAcq: TDBEdit
        Left = 219
        Top = 228
        Width = 65
        Height = 21
        DataField = 'CumuloAcq'
        DataSource = dsArticoli
        TabOrder = 19
      end
      object EditCumuloOrd: TDBEdit
        Left = 290
        Top = 228
        Width = 65
        Height = 21
        DataField = 'CumuloOrd'
        DataSource = dsArticoli
        TabOrder = 20
      end
      object RxDBLookupCombo1: TJvDBLookupCombo
        Left = 50
        Top = 70
        Width = 101
        Height = 21
        DataField = 'CodIVA'
        DataSource = dsArticoli
        ListStyle = lsDelimited
        LookupField = 'CodIVA'
        LookupDisplay = 'Alq;Desc'
        LookupSource = dsCodIVA
        TabOrder = 21
      end
      object RxDBLookupCombo2: TJvDBLookupCombo
        Left = 205
        Top = 70
        Width = 101
        Height = 21
        DataField = 'CodMis'
        DataSource = dsArticoli
        LookupField = 'CodMis'
        LookupDisplay = 'Desc'
        LookupSource = dsCodMis
        TabOrder = 22
      end
      object DBCheckBox1: TDBCheckBox
        Left = 305
        Top = 45
        Width = 46
        Height = 17
        Caption = 'Attivo'
        DataField = 'Attv'
        DataSource = dsArticoli
        TabOrder = 23
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object iCodAlf: TJvDBComboEdit
        Left = 5
        Top = 20
        Width = 51
        Height = 21
        DataField = 'CodAlf'
        DataSource = dsArticoli
        Glyph.Data = {
          42010000424D4201000000000000760000002800000011000000110000000100
          040000000000CC00000000000000000000001000000010000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          DDDDD0000000DDDDD000DDDDD000D0000000DDDDD070DDDDD070D0000000DDDD
          D0008DDD8000D0000000DDDDD00000000000D0000000D444407000070000D000
          0000D4FFF07000070000D0000000D4F8800000000000D0000000D4FFFF000070
          000DD0000000D4F88F80088F00DDD0000000D4FFFFF00FFF00DDD0000000D4F8
          8F80088F00DDD0000000D4FFFFFFFFFF4DDDD0000000D444444444444DDDD000
          0000D474474474474DDDD0000000D444444444444DDDD0000000DDDDDDDDDDDD
          DDDDD0000000}
        TabOrder = 24
        OnButtonClick = iCodAlfButtonClick
        OnChange = iCodAlfChange
        OnKeyPress = iCodAlfKeyPress
      end
    end
  end
  object dsArticoli: TDataSource
    DataSet = tbArticoli
    Left = 287
    Top = 5
  end
  object tbArticoli: TTable
    OnCalcFields = tbArticoliCalcFields
    DatabaseName = 'DB'
    TableName = 'articoli.db'
    Left = 265
    Top = 5
    object tbArticoliCodAlf: TStringField
      FieldName = 'CodAlf'
      Size = 3
    end
    object tbArticoliCodNum: TSmallintField
      FieldName = 'CodNum'
    end
    object tbArticoliDesc: TStringField
      FieldName = 'Desc'
      Size = 30
    end
    object tbArticoliCodIVA: TSmallintField
      FieldName = 'CodIVA'
      Required = True
    end
    object tbArticoliCodMis: TSmallintField
      FieldName = 'CodMis'
      Required = True
    end
    object tbArticoliQta: TFloatField
      FieldName = 'Qta'
      Required = True
    end
    object tbArticoliQtaInv: TFloatField
      FieldName = 'QtaInv'
    end
    object tbArticoliQtaDelta: TFloatField
      FieldName = 'QtaDelta'
    end
    object tbArticoliQtaAcq: TFloatField
      FieldName = 'QtaAcq'
    end
    object tbArticoliQtaOrd: TFloatField
      FieldName = 'QtaOrd'
    end
    object tbArticoliQtaVen: TFloatField
      FieldName = 'QtaVen'
    end
    object tbArticoliQtaPre: TFloatField
      FieldName = 'QtaPre'
    end
    object tbArticoliQtaSco: TFloatField
      FieldName = 'QtaSco'
    end
    object tbArticoliPrzLis: TCurrencyField
      FieldName = 'PrzLis'
    end
    object tbArticoliPrzNor: TCurrencyField
      FieldName = 'PrzNor'
    end
    object tbArticoliPrzSpe: TCurrencyField
      FieldName = 'PrzSpe'
    end
    object tbArticoliRicNor: TSmallintField
      FieldName = 'RicNor'
    end
    object tbArticoliRicSpe: TSmallintField
      FieldName = 'RicSpe'
    end
    object tbArticoliPrePriAcq: TCurrencyField
      FieldName = 'PrePriAcq'
    end
    object tbArticoliPreUltAcq: TCurrencyField
      FieldName = 'PreUltAcq'
    end
    object tbArticoliDatPriAcq: TDateField
      FieldName = 'DatPriAcq'
    end
    object tbArticoliDatUltAcq: TDateField
      FieldName = 'DatUltAcq'
    end
    object tbArticoliCumuloAcq: TFloatField
      FieldName = 'CumuloAcq'
    end
    object tbArticoliCumuloOrd: TFloatField
      FieldName = 'CumuloOrd'
    end
    object tbArticoliSetMer: TStringField
      FieldKind = fkCalculated
      FieldName = 'SetMer'
      Size = 40
      Calculated = True
    end
    object tbArticoliAttv: TBooleanField
      FieldName = 'Attv'
    end
  end
  object tbCodIVA: TTable
    DatabaseName = 'DB'
    TableName = 'TBCODIVA.DB'
    Left = 275
    Top = 35
    object tbCodIVACodIVA: TSmallintField
      FieldName = 'CodIVA'
    end
    object tbCodIVAAlq: TFloatField
      DisplayWidth = 5
      FieldName = 'Alq'
      Required = True
      DisplayFormat = '0 %'
    end
    object tbCodIVADesc: TStringField
      DisplayWidth = 20
      FieldName = 'Desc'
      Size = 40
    end
  end
  object tbCodMis: TTable
    DatabaseName = 'DB'
    TableName = 'TBCODMIS.DB'
    Left = 305
    Top = 35
  end
  object dsCodIVA: TDataSource
    DataSet = tbCodIVA
    Left = 280
    Top = 50
  end
  object dsCodMis: TDataSource
    DataSet = tbCodMis
    Left = 310
    Top = 50
  end
end
