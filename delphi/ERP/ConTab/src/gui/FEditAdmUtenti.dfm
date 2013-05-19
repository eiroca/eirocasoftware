object fmEditAdmUtenti: TfmEditAdmUtenti
  Left = 264
  Top = 163
  Caption = 'Anagrafica Utenti Programma'
  ClientHeight = 179
  ClientWidth = 389
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
    Width = 389
    Height = 179
    ActivePage = tsDettaglio
    Align = alClient
    TabOrder = 0
    object tsDettaglio: TTabSheet
      Caption = 'Dettaglio'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 381
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
          DataSource = dmEditAdmUtenti.dsAdmUtenti
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 41
        Width = 381
        Height = 110
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 1
        Caption = 'Panel2'
        TabOrder = 1
        object ScrollBox: TScrollBox
          Left = 1
          Top = 1
          Width = 379
          Height = 108
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
          object Label3: TLabel
            Left = 6
            Top = 58
            Width = 80
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Password'
            FocusControl = EditDesc
          end
          object Label4: TLabel
            Left = 6
            Top = 82
            Width = 80
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Super User?'
            FocusControl = CheckBoxGruppo
          end
          object Label2: TLabel
            Left = 6
            Top = 33
            Width = 80
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Utente'
            FocusControl = DBEdit1
          end
          object EditCodCon: TDBEdit
            Left = 94
            Top = 6
            Width = 55
            Height = 21
            DataField = 'CodUsr'
            DataSource = dmEditAdmUtenti.dsAdmUtenti
            TabOrder = 0
          end
          object EditDesc: TDBEdit
            Left = 94
            Top = 55
            Width = 165
            Height = 21
            DataField = 'Password'
            DataSource = dmEditAdmUtenti.dsAdmUtenti
            TabOrder = 1
          end
          object CheckBoxGruppo: TDBCheckBox
            Left = 94
            Top = 82
            Width = 97
            Height = 17
            Caption = ' '
            DataField = 'SuperUser'
            DataSource = dmEditAdmUtenti.dsAdmUtenti
            TabOrder = 2
            ValueChecked = 'True'
            ValueUnchecked = 'False'
          end
          object DBEdit1: TDBEdit
            Left = 94
            Top = 30
            Width = 165
            Height = 21
            DataField = 'UserName'
            DataSource = dmEditAdmUtenti.dsAdmUtenti
            TabOrder = 3
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
        DataSource = dmEditAdmUtenti.dsAdmUtenti
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'UserName'
            Title.Alignment = taCenter
            Width = 173
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Password'
            Title.Alignment = taCenter
            Width = 153
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SuperUser'
            Title.Alignment = taCenter
            Visible = True
          end>
      end
    end
  end
end
