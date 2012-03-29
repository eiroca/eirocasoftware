object fmEditConGiornale: TfmEditConGiornale
  Left = 262
  Top = 147
  ActiveControl = Panel1
  Caption = 'Modifica dati Scritture'
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
    Top = 161
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
      DataSource = dmEditConGiornale.dsConGiornale
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 366
    Height = 120
    Align = alTop
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'Panel2'
    TabOrder = 1
    object ScrollBox: TScrollBox
      Left = 6
      Top = 6
      Width = 354
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
        FocusControl = EditCodSch
      end
      object Label3: TLabel
        Left = 6
        Top = 33
        Width = 80
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Descrizione'
        FocusControl = EditDesc
      end
      object Label2: TLabel
        Left = 6
        Top = 57
        Width = 80
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Data Scrittura'
        FocusControl = EditDesc
      end
      object Label4: TLabel
        Left = 6
        Top = 81
        Width = 80
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Data Operazione'
        FocusControl = EditDesc
      end
      object EditCodSch: TDBEdit
        Left = 97
        Top = 6
        Width = 55
        Height = 21
        DataField = 'CodScr'
        DataSource = dmEditConGiornale.dsConGiornale
        TabOrder = 0
      end
      object EditDesc: TDBEdit
        Left = 97
        Top = 30
        Width = 165
        Height = 21
        DataField = 'Desc'
        DataSource = dmEditConGiornale.dsConGiornale
        TabOrder = 1
      end
      object DBCheckBox1: TDBCheckBox
        Left = 160
        Top = 9
        Width = 97
        Height = 17
        Caption = 'Ufficiale?'
        DataField = 'Ufficiale'
        DataSource = dmEditConGiornale.dsConGiornale
        TabOrder = 4
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object DBDateEdit1: TJvDBDateEdit
        Left = 97
        Top = 55
        Width = 121
        Height = 21
        DataField = 'DataScr'
        DataSource = dmEditConGiornale.dsConGiornale
        NumGlyphs = 2
        TabOrder = 2
      end
      object DBDateEdit2: TJvDBDateEdit
        Left = 97
        Top = 80
        Width = 121
        Height = 21
        DataField = 'DataOpe'
        DataSource = dmEditConGiornale.dsConGiornale
        NumGlyphs = 2
        TabOrder = 3
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 164
    Width = 366
    Height = 205
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'Panel3'
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 6
      Top = 6
      Width = 354
      Height = 193
      Align = alClient
      BorderStyle = bsNone
      DataSource = dmEditConGiornale.dsConGiornaleDett
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
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Importo'
          Title.Alignment = taCenter
          Visible = True
        end>
    end
  end
end
