object fmEditConSchemiBilancio: TfmEditConSchemiBilancio
  Left = 343
  Top = 191
  ActiveControl = Panel1
  Caption = 'Impostazione Schemi di Bilancio'
  ClientHeight = 280
  ClientWidth = 441
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 180
    Width = 441
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 373
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 441
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
      DataSource = dmEditConSchemiBilancio.dsConSchemiBilancio
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 441
    Height = 139
    Align = alTop
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'Panel2'
    TabOrder = 1
    object ScrollBox: TScrollBox
      Left = 6
      Top = 6
      Width = 429
      Height = 127
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
        Top = 77
        Width = 80
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Annotazioni'
        FocusControl = MemoNote
      end
      object EditCodSch: TDBEdit
        Left = 97
        Top = 6
        Width = 55
        Height = 21
        DataField = 'CodSch'
        DataSource = dmEditConSchemiBilancio.dsConSchemiBilancio
        TabOrder = 0
      end
      object EditAlias: TDBEdit
        Left = 97
        Top = 28
        Width = 75
        Height = 21
        DataField = 'Alias'
        DataSource = dmEditConSchemiBilancio.dsConSchemiBilancio
        TabOrder = 1
      end
      object EditDesc: TDBEdit
        Left = 97
        Top = 50
        Width = 165
        Height = 21
        DataField = 'Desc'
        DataSource = dmEditConSchemiBilancio.dsConSchemiBilancio
        TabOrder = 2
      end
      object MemoNote: TDBMemo
        Left = 97
        Top = 75
        Width = 239
        Height = 46
        DataField = 'Note'
        DataSource = dmEditConSchemiBilancio.dsConSchemiBilancio
        TabOrder = 3
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 183
    Width = 441
    Height = 97
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'Panel3'
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 6
      Top = 6
      Width = 429
      Height = 85
      Align = alClient
      BorderStyle = bsNone
      DataSource = dmEditConSchemiBilancio.dsConSchemiBilancioDett
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
          FieldName = 'ParentDett'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CodConDett'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Order'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PosizioneDett'
          Title.Alignment = taCenter
          Visible = True
        end>
    end
  end
end
