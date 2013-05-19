object fmEditConConti: TfmEditConConti
  Left = 264
  Top = 163
  Caption = 'Anagrafica Conti Contabilit'#224' Generale'
  ClientHeight = 289
  ClientWidth = 393
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pcConConti: TPageControl
    Left = 0
    Top = 0
    Width = 393
    Height = 289
    ActivePage = tsDettaglio
    Align = alClient
    TabOrder = 0
    object tsDettaglio: TTabSheet
      Caption = 'Dettaglio'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 385
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 0
        object RGNavigator1: TRGNavigator
          Left = 5
          Top = 5
          Width = 371
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
          DataSource = dmEditConConti.dsConConti
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 41
        Width = 385
        Height = 220
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 1
        Caption = 'Panel2'
        TabOrder = 1
        object ScrollBox: TScrollBox
          Left = 1
          Top = 1
          Width = 383
          Height = 218
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
            FocusControl = EditCodCon
          end
          object Label2: TLabel
            Left = 6
            Top = 31
            Width = 80
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Codice conto'
            FocusControl = EditAlias
          end
          object Label3: TLabel
            Left = 6
            Top = 53
            Width = 80
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Desc'
            FocusControl = EditDesc
          end
          object Label4: TLabel
            Left = 6
            Top = 72
            Width = 80
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Aggregato?'
            FocusControl = CheckBoxGruppo
          end
          object Label5: TLabel
            Left = 6
            Top = 95
            Width = 80
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Tipo movimenti'
          end
          object Label6: TLabel
            Left = 6
            Top = 117
            Width = 80
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Livello dettaglio'
          end
          object Label7: TLabel
            Left = 6
            Top = 142
            Width = 80
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Annotazioni'
          end
          object EditCodCon: TDBEdit
            Left = 94
            Top = 6
            Width = 55
            Height = 21
            DataField = 'CodCon'
            DataSource = dmEditConConti.dsConConti
            TabOrder = 0
          end
          object EditAlias: TDBEdit
            Left = 94
            Top = 28
            Width = 75
            Height = 21
            DataField = 'Alias'
            DataSource = dmEditConConti.dsConConti
            TabOrder = 1
          end
          object EditDesc: TDBEdit
            Left = 94
            Top = 50
            Width = 165
            Height = 21
            DataField = 'Desc'
            DataSource = dmEditConConti.dsConConti
            TabOrder = 2
          end
          object CheckBoxGruppo: TDBCheckBox
            Left = 94
            Top = 72
            Width = 97
            Height = 17
            Caption = ' '
            DataField = 'Gruppo'
            DataSource = dmEditConConti.dsConConti
            TabOrder = 3
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object DBLookupComboBox1: TDBLookupComboBox
            Left = 95
            Top = 92
            Width = 125
            Height = 21
            DataField = 'TipiMoviDesc'
            DataSource = dmEditConConti.dsConConti
            TabOrder = 4
          end
          object DBLookupComboBox2: TDBLookupComboBox
            Left = 95
            Top = 114
            Width = 125
            Height = 21
            DataField = 'LivDettDesc'
            DataSource = dmEditConConti.dsConConti
            TabOrder = 5
          end
          object DBMemo1: TDBMemo
            Left = 95
            Top = 140
            Width = 281
            Height = 71
            DataField = 'Note'
            DataSource = dmEditConConti.dsConConti
            TabOrder = 6
          end
        end
      end
    end
    object tsElenco: TTabSheet
      Caption = 'Elenco'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 385
        Height = 259
        Align = alClient
        DataSource = dmEditConConti.dsConConti
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'Alias'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Desc'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Gruppo'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TipiMoviDesc'
            Title.Alignment = taCenter
            Width = 114
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LivDettDesc'
            Title.Alignment = taCenter
            Width = 114
            Visible = True
          end>
      end
    end
  end
end
