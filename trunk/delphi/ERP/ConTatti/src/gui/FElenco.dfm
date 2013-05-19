object fmElenco: TfmElenco
  Left = 223
  Top = 236
  BorderIcons = []
  ClientHeight = 265
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF009999
    99999999999999999999999999999CC00000000000000000000000000CC99CC0
    00000000B00000000B0000000CC99CC00000000040000800040008080CC99CC0
    0000000030000000030000000CC99CC008080000C00000000C0008080CC99CC0
    00000000C00008080C0000000CC99CC008080800C00000000C0000000CC99CC0
    00000000C0080C00CC0000000CC99CCCC00C0000C0000C00CC0000000CC99CCC
    C00C0000C0000C00CC00000CCCC99CCCC00C0000C0000CCCCC00000CCCC99CCC
    CCCC0000C0030CCCCC00000CCCC99CCCCCCC0300C0000CCCCC00000CCCC99CCC
    CC9C0000CC00CCCCCC00000CCCC99CCCCCCC0300CCCCCCCCCC00000CCCC99CCC
    CCCC0000CCCFCCCCCC00080CCCC99CCCFCCC0808CCCCCCCCCCCC000CCCC99CCC
    CCCC0000CCCCCCCCFCCC080CCCC99CCCCCCC0808CCCCCCCCCCCC000CCFC99CCC
    CCCC0000CCCCCCCCCCCCC0CCCCC99CCCCCCC0808CCCCCCCCCCCCC0CCCCC99CCC
    CCCC0000CCCCFCCCCCCCC0CCCCC99CCCCCCCC00CCCCCCCCCCCCCCCCCCCC99CCC
    FCCCC00CCCCCCCCCFCCCCCCCCCC99CCCCCCCCCCCCCCCCCCCCCCCCC9CCCC99CCC
    CCCCCCCCCCCCCFCCCCCCCCCCCCC99CCCCCCCCCCCCCCCCCCCCFCCCCCCCCC99CCC
    CCCC6FCCCCCCCCCCCCCCCCCCFCC99CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC99CCC
    CCCCCCCCCCCCCCCCCCCCCCCCCCC9999999999999999999999999999999990000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object dgContat: TJvDBGrid
    Left = 0
    Top = 86
    Width = 427
    Height = 179
    Hint = 
      'Elenco dei contatti'#13#10'Cliccare sul titolo per ordinare secondo qu' +
      'el criterio'
    Align = alBottom
    DataSource = dsContatti
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    PopupMenu = pmAction
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dgContatDblClick
    OnKeyPress = dgContatKeyPress
    TitleButtons = True
    OnCheckButton = dgContatCheckButton
    OnGetBtnParams = dgContatGetBtnParams
    OnTitleBtnClick = dgContatTitleBtnClick
    SelectColumnsDialogStrings.Caption = 'Select columns'
    SelectColumnsDialogStrings.OK = '&OK'
    SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
    EditControls = <>
    RowsHeight = 17
    TitleRowHeight = 17
  end
  object tbContatti: TTable
    OnCalcFields = tbContattiCalcFields
    DatabaseName = 'DB'
    IndexName = 'IdxNome'
    ReadOnly = True
    TableName = 'CONTAT.DB'
    Left = 120
    Top = 55
    object tbContattiCodCon: TIntegerField
      FieldName = 'CodCon'
      Visible = False
    end
    object tbContattiClasse: TStringField
      FieldName = 'Classe'
      Size = 15
    end
    object tbContattiNome: TStringField
      DisplayWidth = 40
      FieldKind = fkCalculated
      FieldName = 'Nome'
      Size = 80
      Calculated = True
    end
    object tbContattiNome_Tit: TStringField
      FieldName = 'Nome_Tit'
      Visible = False
      Size = 10
    end
    object tbContattiNome_Pre1: TStringField
      FieldName = 'Nome_Pre1'
      Visible = False
    end
    object tbContattiNome_Pre2: TStringField
      FieldName = 'Nome_Pre2'
      Visible = False
      Size = 40
    end
    object tbContattiNome_Main: TStringField
      FieldName = 'Nome_Main'
      Visible = False
      Size = 40
    end
    object tbContattiNome_Suf: TStringField
      FieldName = 'Nome_Suf'
      Visible = False
      Size = 10
    end
    object tbContattiSettore: TStringField
      FieldName = 'Settore'
      Size = 35
    end
    object tbContattiNote: TMemoField
      FieldName = 'Note'
      Visible = False
      BlobType = ftMemo
      Size = 100
    end
    object tbContattiTipo: TIntegerField
      FieldName = 'Tipo'
      Visible = False
    end
  end
  object dsContatti: TDataSource
    DataSet = tbContatti
    OnDataChange = dsContattiDataChange
    Left = 155
    Top = 55
  end
  object pmAction: TPopupMenu
    Left = 315
    Top = 55
    object mpContEdit: TMenuItem
      Caption = 'Gestisci &contatto'
      ShortCut = 16453
      OnClick = mpContEditClick
    end
    object mpContTel: TMenuItem
      Caption = 'Numeri telefonici'
      ShortCut = 16468
      OnClick = mpContTelClick
    end
    object mpContInd: TMenuItem
      Caption = 'Indirizzi'
      ShortCut = 16457
      OnClick = mpContIndClick
    end
  end
  object DBConnection: TDBConnectionLink
    Active = False
    OnConnect = DBConnectionEvent
    OnDisconnect = DBConnectionEvent
    Left = 115
    Top = 20
  end
  object DBMessage: TDBMessageLink
    Active = False
    OnMessage = DBMessageMessage
    Left = 150
    Top = 25
  end
end
