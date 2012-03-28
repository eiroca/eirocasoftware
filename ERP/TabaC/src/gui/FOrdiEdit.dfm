object fmOrdiEdit: TfmOrdiEdit
  Left = 231
  Top = 178
  ActiveControl = pnOrdi
  Caption = 'Mostra/Modifica Ordini Tabacchi'
  ClientHeight = 308
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RxSplitter1: TJvSplitter
    Left = 0
    Top = 141
    Width = 442
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object pnOrdi: TPanel
    Left = 0
    Top = 0
    Width = 442
    Height = 41
    Align = alTop
    TabOrder = 0
    object btCompleta: TSpeedButton
      Left = 218
      Top = 8
      Width = 25
      Height = 25
      Hint = 'Aggiungi mancanti'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
        000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
        00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
        F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
        0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
        FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
        FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
        0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
        00333377737FFFFF773333303300000003333337337777777333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btCompletaClick
    end
    object btPack: TSpeedButton
      Left = 243
      Top = 8
      Width = 25
      Height = 25
      Hint = 'Compatta e ricalcola totali'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333FFF33F333FF3F330E0330FFFCCFCC33777FF7F3377F7730EEE030FFFC
        CFCC377777F7F33773770EEE0000FFFFFCCF777777773F33377FEEE0BFBF0FFF
        FCCF7777333373F337730E0BFBFBF0FFCCFF77733333373F77F330BFBFBFBF0F
        CCFF37F333333F7F773330FBFBFB0B0FFFFF37F3F33F737FFFFF30B0BF0FB000
        000037F73F73F777777730FB0BF0FB0FFFFF373F73F73F7F333F330030BF0F0F
        FF993F77373F737F3377CC33330BF00FFF9977FFF373F77F3F77CC993330009F
        99FF7777F337777F77F333993330F99F99FF3F77FF37F773773F993CC330FFF9
        9F9977F77F37F3377F77993CC330FFF99F997737733733377377}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btPackClick
    end
    object cbDaRice: TCheckBox
      Left = 275
      Top = 15
      Width = 141
      Height = 17
      Caption = 'Solo ordini da ricevere'
      TabOrder = 0
      OnClick = cbDaRiceClick
    end
    object navOrdi: TRGNavigator
      Left = 10
      Top = 8
      Width = 200
      Height = 25
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbPrint, nbRefresh, nbDelete, nbEdit]
      ConfirmDelete = False
      ConfirmEdit = False
      ConfirmPost = False
      ConfirmCancel = False
      TabOrder = 1
      OnClick = navOrdiClick
      ColorScroll = ncBlack
      ColorFunc = ncBlack
      ColorCtrl = ncBlack
      ColorTool = ncBlack
      SizeOfKey = X4
      CaptionExtra1 = 'Extra1'
      CaptionExtra2 = 'Extra2'
      CaptionExtra3 = 'Extra3'
      DataSource = dsOrdiLst
    end
  end
  object pnOrdiList: TPanel
    Left = 0
    Top = 41
    Width = 442
    Height = 100
    Align = alTop
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'pnOrdiList'
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 6
      Top = 6
      Width = 430
      Height = 88
      Align = alClient
      BorderStyle = bsNone
      DataSource = dsOrdiLst
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'DATAORDI'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DATA'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DATAPREZ'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'KGC'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VAL'
          Title.Alignment = taCenter
          Visible = True
        end>
    end
  end
  object pnOrdiMovi: TPanel
    Left = 0
    Top = 144
    Width = 442
    Height = 164
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    TabOrder = 2
    object DBGrid2: TDBGrid
      Left = 6
      Top = 6
      Width = 430
      Height = 152
      Align = alClient
      BorderStyle = bsNone
      DataSource = dsOrdiMov
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnEnter = DBGrid2Enter
      OnExit = DBGrid2Exit
      Columns = <
        item
          Expanded = False
          FieldName = 'CODI'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CodS'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Desc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CARI'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CariKG'
          Visible = True
        end>
    end
  end
  object dsOrdiLst: TDataSource
    DataSet = tbOrdiLst
    Left = 172
    Top = 200
  end
  object dsOrdiMov: TDataSource
    DataSet = tbOrdiMov
    Left = 226
    Top = 200
  end
  object tbOrdiLst: TTable
    BeforeInsert = AbortOperation
    BeforeDelete = tbOrdiLstBeforeDelete
    DatabaseName = 'DB'
    IndexName = 'IdxDATAORDI'
    TableName = 'CARILIST.DB'
    Left = 155
    Top = 215
    object tbOrdiLstPCAR: TIntegerField
      FieldName = 'PCAR'
      Visible = False
    end
    object tbOrdiLstDATAORDI: TDateField
      Alignment = taRightJustify
      DisplayLabel = 'Data Ordine'
      FieldName = 'DATAORDI'
      Required = True
    end
    object tbOrdiLstDATA: TDateField
      Alignment = taRightJustify
      DisplayLabel = 'Data Consegna'
      FieldName = 'DATA'
    end
    object tbOrdiLstDATAPREZ: TDateField
      Alignment = taRightJustify
      DisplayLabel = 'Data Prezzi'
      FieldName = 'DATAPREZ'
      Required = True
    end
    object tbOrdiLstKGC: TFloatField
      DisplayLabel = 'Ordine (KgC)'
      DisplayWidth = 7
      FieldName = 'KGC'
      DisplayFormat = '0.000'
    end
    object tbOrdiLstVAL: TCurrencyField
      DisplayLabel = 'Importo'
      DisplayWidth = 13
      FieldName = 'VAL'
    end
  end
  object tbOrdiMov: TTable
    BeforeInsert = AbortOperation
    BeforeDelete = tbOrdiMovBeforeDelete
    OnCalcFields = tbOrdiMovCalcFields
    DatabaseName = 'DB'
    IndexFieldNames = 'PCAR'
    MasterFields = 'PCAR'
    MasterSource = dsOrdiLst
    TableName = 'CARIMOVS.DB'
    Left = 219
    Top = 210
    object tbOrdiMovPCAR: TIntegerField
      FieldName = 'PCAR'
      Required = True
      Visible = False
    end
    object tbOrdiMovCODI: TSmallintField
      DisplayLabel = 'Cod.'
      DisplayWidth = 5
      FieldName = 'CODI'
      Required = True
    end
    object tbOrdiMovCodS: TStringField
      DisplayLabel = 'Cod. Sig.'
      FieldKind = fkCalculated
      FieldName = 'CodS'
      Size = 4
      Calculated = True
    end
    object tbOrdiMovDesc: TStringField
      DisplayLabel = 'Nome tabacco'
      FieldKind = fkCalculated
      FieldName = 'Desc'
      Size = 30
      Calculated = True
    end
    object tbOrdiMovCARI: TIntegerField
      DisplayLabel = 'Carico'
      FieldName = 'CARI'
      Required = True
    end
    object tbOrdiMovCariKG: TFloatField
      DisplayLabel = 'Carico (KgC)'
      FieldKind = fkCalculated
      FieldName = 'CariKG'
      DisplayFormat = '0.00'
      Calculated = True
    end
  end
  object tbTaba: TTable
    DatabaseName = 'DB'
    TableName = 'TABACCHI.DB'
    Left = 95
    Top = 215
    object tbTabaCODI: TSmallintField
      FieldName = 'CODI'
      Required = True
    end
    object tbTabaCODS: TStringField
      FieldName = 'CODS'
      Required = True
      Size = 4
    end
    object tbTabaDESC: TStringField
      FieldName = 'DESC'
      Required = True
      Size = 30
    end
    object tbTabaATTV: TBooleanField
      FieldName = 'ATTV'
    end
    object tbTabaQTAC: TSmallintField
      FieldName = 'QTAC'
    end
  end
  object ftOrdiLst: TJvDBFilter
    DataSource = dsOrdiLst
    Filter.Strings = (
      'DATA = null')
    Left = 185
    Top = 181
  end
end
