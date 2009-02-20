object fmEditConBilanci: TfmEditConBilanci
  Left = 262
  Top = 147
  ActiveControl = Panel1
  Caption = 'Modifica dati di Bilancio'
  ClientHeight = 369
  ClientWidth = 366
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 206
    Width = 366
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 366
    Height = 41
    Align = alTop
    TabOrder = 0
    object navSchema: TRGNavigator
      Left = 10
      Top = 10
      Width = 345
      Height = 25
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbKey, nbRefresh, nbInsert, nbDelete, nbEdit]
      TabOrder = 0
      ColorScroll = ncBlack
      ColorFunc = ncBlack
      ColorCtrl = ncBlack
      ColorTool = ncBlack
      SizeOfKey = X4
      CaptionExtra1 = 'Extra1'
      CaptionExtra2 = 'Extra2'
      CaptionExtra3 = 'Extra3'
      DataSource = dmEditConBilanci.dsConBilanci
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 366
    Height = 165
    Align = alTop
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'Panel2'
    TabOrder = 1
    object ScrollBox: TScrollBox
      Left = 6
      Top = 6
      Width = 354
      Height = 153
      HorzScrollBar.Margin = 6
      VertScrollBar.Margin = 6
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 0
      object Label1: TLabel
        Left = 6
        Top = 9
        Width = 80
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Codice'
        FocusControl = EditCodSch
      end
      object Label2: TLabel
        Left = 6
        Top = 31
        Width = 80
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Codice schema'
        FocusControl = EditAlias
      end
      object Label3: TLabel
        Left = 6
        Top = 53
        Width = 80
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Descrizione'
        FocusControl = EditDesc
      end
      object Label4: TLabel
        Left = 6
        Top = 102
        Width = 80
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Annotazioni'
        FocusControl = MemoNote
      end
      object Label5: TLabel
        Left = 6
        Top = 79
        Width = 80
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Schema bilancio'
        FocusControl = EditCodSch
      end
      object EditCodSch: TDBEdit
        Left = 97
        Top = 6
        Width = 55
        Height = 21
        DataField = 'CodBil'
        DataSource = dmEditConBilanci.dsConBilanci
        TabOrder = 0
      end
      object EditAlias: TDBEdit
        Left = 97
        Top = 28
        Width = 75
        Height = 21
        DataField = 'Alias'
        DataSource = dmEditConBilanci.dsConBilanci
        TabOrder = 1
      end
      object EditDesc: TDBEdit
        Left = 97
        Top = 50
        Width = 165
        Height = 21
        DataField = 'Desc'
        DataSource = dmEditConBilanci.dsConBilanci
        TabOrder = 2
      end
      object MemoNote: TDBMemo
        Left = 97
        Top = 100
        Width = 239
        Height = 46
        DataField = 'Note'
        DataSource = dmEditConBilanci.dsConBilanci
        TabOrder = 3
      end
      object DBCheckBox1: TDBCheckBox
        Left = 185
        Top = 30
        Width = 97
        Height = 17
        Caption = 'Ufficiale?'
        DataField = 'Ufficiale'
        DataSource = dmEditConBilanci.dsConBilanci
        TabOrder = 4
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBLookupComboBox1: TDBLookupComboBox
        Left = 97
        Top = 75
        Width = 145
        Height = 21
        DataField = 'CodSchDett'
        DataSource = dmEditConBilanci.dsConBilanci
        TabOrder = 5
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 209
    Width = 366
    Height = 160
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'Panel3'
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 6
      Top = 6
      Width = 354
      Height = 148
      Align = alClient
      BorderStyle = bsNone
      DataSource = dmEditConBilanci.dsConBilanciDett
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnEnter = DBGrid1Enter
      OnExit = DBGrid1Exit
      Columns = <
        item
          Expanded = False
          FieldName = 'CodConDett'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Saldo'
          Visible = True
        end>
    end
  end
end
