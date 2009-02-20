object fmEditForn: TfmEditForn
  Left = 303
  Top = 161
  ActiveControl = Panel1
  Caption = 'Modifica dati fornitori'
  ClientHeight = 112
  ClientWidth = 325
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
    Width = 325
    Height = 41
    Align = alTop
    TabOrder = 0
    object RGNavigator1: TRGNavigator
      Left = 5
      Top = 10
      Width = 311
      Height = 25
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbSearch, nbRefresh, nbInsert, nbDelete, nbEdit]
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
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 325
    Height = 71
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'Panel2'
    TabOrder = 1
    object ScrollBox: TScrollBox
      Left = 6
      Top = 6
      Width = 313
      Height = 59
      HorzScrollBar.Margin = 6
      VertScrollBar.Margin = 6
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 0
      object Label1: TLabel
        Left = 6
        Top = 9
        Width = 46
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'CodFor'
        FocusControl = EditCodFor
      end
      object Label2: TLabel
        Left = 6
        Top = 31
        Width = 46
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Nome'
        FocusControl = EditNome
      end
      object EditCodFor: TDBEdit
        Left = 58
        Top = 6
        Width = 50
        Height = 21
        DataField = 'CodFor'
        DataSource = dsForn
        TabOrder = 0
      end
      object EditNome: TDBEdit
        Left = 58
        Top = 28
        Width = 150
        Height = 21
        DataField = 'Nome'
        DataSource = dsForn
        TabOrder = 1
      end
      object DBCheckBox1: TDBCheckBox
        Left = 115
        Top = 5
        Width = 121
        Height = 17
        Caption = 'Fornitore potenziale'
        DataField = 'Potenziale'
        DataSource = dsForn
        TabOrder = 2
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
    end
  end
  object dsForn: TDataSource
    DataSet = tbFornitori
    Left = 277
    Top = 55
  end
  object tbFornitori: TTable
    DatabaseName = 'DB'
    TableName = 'fornit.db'
    Left = 250
    Top = 55
    object tbFornitoriCodFor: TIntegerField
      FieldName = 'CodFor'
    end
    object tbFornitoriNome: TStringField
      FieldName = 'Nome'
      Required = True
      Size = 30
    end
    object tbFornitoriPotenziale: TBooleanField
      FieldName = 'Potenziale'
    end
  end
end
