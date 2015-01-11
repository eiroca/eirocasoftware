object fmNick4IRC: TfmNick4IRC
  Left = 250
  Top = 152
  BorderStyle = bsDialog
  Caption = 'Vista rapida per soprannomi'
  ClientHeight = 204
  ClientWidth = 451
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 166
    Height = 201
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 8
      Width = 90
      Height = 13
      Caption = 'Elenco soprannomi'
    end
    object iNickName: TEdit
      Left = 10
      Top = 171
      Width = 145
      Height = 21
      Hint = 
        'soprannome (o parte di esso) a '#13#10'cui limitare l'#39'elenco visualizz' +
        'ato'
      TabOrder = 2
      Text = 'iNickName'
      OnChange = iNickNameChange
    end
    object DBGrid1: TDBGrid
      Left = 10
      Top = 25
      Width = 145
      Height = 120
      Hint = 'Elenco dei soprannomi presenti'
      DataSource = dsNickName
      Options = [dgEditing, dgColumnResize, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnKeyPress = ProcessKey
    end
    object cbFilter: TCheckBox
      Left = 10
      Top = 150
      Width = 136
      Height = 17
      Hint = 'Abilita/disabilita un filtro sui soprannomi visualizzati'
      Caption = 'Solo i soprannomi simili a'
      TabOrder = 1
      OnClick = cbFilterClick
    end
  end
  object Panel2: TPanel
    Left = 163
    Top = 0
    Width = 288
    Height = 201
    Hint = 
      'Posizionarsi sui vari elementi per '#13#10'leggere le note relative al' +
      'l'#39'elemento stesso'
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object lTelef: TLabel
      Left = 10
      Top = 40
      Width = 42
      Height = 13
      Caption = 'Telefono'
    end
    object lNome: TLabel
      Left = 10
      Top = 18
      Width = 40
      Height = 13
      Caption = 'Contatto'
    end
    object lIndir: TLabel
      Left = 10
      Top = 60
      Width = 38
      Height = 13
      Caption = 'Indirizzo'
      Color = clBtnFace
      ParentColor = False
    end
    object Bevel1: TBevel
      Left = 2
      Top = 160
      Width = 285
      Height = 41
      Shape = bsTopLine
    end
    object DBText1: TDBText
      Left = 65
      Top = 40
      Width = 65
      Height = 17
      DataField = 'TelefTipo'
      DataSource = dsTelef
    end
    object RGNavigator1: TRGNavigator
      Left = 233
      Top = 11
      Width = 46
      Height = 20
      VisibleButtons = [nbPrior, nbNext]
      TabOrder = 6
      ColorScroll = ncBlack
      ColorFunc = ncBlack
      ColorCtrl = ncBlack
      ColorTool = ncBlack
      SizeOfKey = X4
      CaptionExtra1 = 'Extra1'
      CaptionExtra2 = 'Extra2'
      CaptionExtra3 = 'Extra3'
      DataSource = dsContat
    end
    object RGNavigator2: TRGNavigator
      Left = 233
      Top = 36
      Width = 46
      Height = 20
      VisibleButtons = [nbPrior, nbNext]
      TabOrder = 7
      ColorScroll = ncBlack
      ColorFunc = ncBlack
      ColorCtrl = ncBlack
      ColorTool = ncBlack
      SizeOfKey = X4
      CaptionExtra1 = 'Extra1'
      CaptionExtra2 = 'Extra2'
      CaptionExtra3 = 'Extra3'
      DataSource = dsTelef
    end
    object RGNavigator3: TRGNavigator
      Left = 233
      Top = 81
      Width = 46
      Height = 20
      VisibleButtons = [nbPrior, nbNext]
      TabOrder = 8
      ColorScroll = ncBlack
      ColorFunc = ncBlack
      ColorCtrl = ncBlack
      ColorTool = ncBlack
      SizeOfKey = X4
      CaptionExtra1 = 'Extra1'
      CaptionExtra2 = 'Extra2'
      CaptionExtra3 = 'Extra3'
      DataSource = dsIndir
    end
    object meIndir: TDBMemo
      Left = 10
      Top = 80
      Width = 216
      Height = 71
      TabStop = False
      DataField = 'Indirizzo'
      DataSource = dsIndir
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 2
      WordWrap = False
    end
    object iNome: TDBEdit
      Left = 60
      Top = 11
      Width = 166
      Height = 21
      TabStop = False
      DataField = 'Nome'
      DataSource = dsContat
      TabOrder = 0
    end
    object iTelef: TDBEdit
      Left = 135
      Top = 36
      Width = 90
      Height = 21
      TabStop = False
      DataField = 'Telef'
      DataSource = dsTelef
      TabOrder = 1
    end
    object BitBtn1: TBitBtn
      Left = 10
      Top = 168
      Width = 89
      Height = 26
      Hint = 'Chiude la finestra'
      Caption = 'Chiude '
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33333333333333333333EEEEEEEEEEEEEEE333FFFFFFFFFFFFF3E00000000000
        00E337777777777777F3E0F77777777770E337F33333333337F3E0F333333333
        70E337F33333333337F3E0F33333333370E337F333FFFFF337F3E0F330000033
        70E337F3377777F337F3E0F33000003370E337F3377777F337F3E0F330000033
        70E337F3377777F337F3E0F33000003370E337F3377777F337F3E0F330000033
        70E337F33777773337F3E0F33333333370E337F33333333337F3E0F333333333
        70E337F33333333337F3E0FFFFFFFFFFF0E337FFFFFFFFFFF7F3E00000000000
        00E33777777777777733EEEEEEEEEEEEEEE33333333333333333}
      Margin = 5
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 3
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 190
      Top = 168
      Width = 89
      Height = 26
      Caption = '&Aiuto'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333FFFFF3333333333F797F3333333333F737373FF333333BFB999BFB
        33333337737773773F3333BFBF797FBFB33333733337333373F33BFBFBFBFBFB
        FB3337F33333F33337F33FBFBFB9BFBFBF3337333337F333373FFBFBFBF97BFB
        FBF37F333337FF33337FBFBFBFB99FBFBFB37F3333377FF3337FFBFBFBFB99FB
        FBF37F33333377FF337FBFBF77BF799FBFB37F333FF3377F337FFBFB99FB799B
        FBF373F377F3377F33733FBF997F799FBF3337F377FFF77337F33BFBF99999FB
        FB33373F37777733373333BFBF999FBFB3333373FF77733F7333333BFBFBFBFB
        3333333773FFFF77333333333FBFBF3333333333377777333333}
      Margin = 5
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 4
    end
    object btConnect: TBitBtn
      Left = 233
      Top = 105
      Width = 46
      Height = 25
      Hint = 
        'Attiva il gestore associato all'#39'indirizzo'#13#10'(ad es. il programma ' +
        'per la posta elettronica)'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
        000037777777777777770FFFFFFFFFFFFFF07F3333FFF33333370FFFF777FFFF
        FFF07F333777333333370FFFFFFFFFFFFFF07F3333FFFFFF33370FFFF7777BBF
        FFF07F333777777F3FF70FFFFFFFB9BF1CC07F3FFF337F7377770F777FFFB99B
        C1C07F7773337F377F370FFFFFFFB9BBC1C07FFFFFFF7F337FF700000077B999
        B000777777777F33777733337377B9999B33333F733373F337FF3377377B99BB
        9BB33377F337F377377F3737377B9B79B9B737F73337F7F7F37F33733777BB7B
        BBB73373333377F37F3737333777BB777B9B3733333377F337F7333333777B77
        77BB3333333337333377333333333777337B3333333333333337}
      NumGlyphs = 2
      TabOrder = 5
      OnClick = btConnectClick
    end
  end
  object tbIndir: TTable
    OnCalcFields = tbIndirCalcFields
    DatabaseName = 'DB'
    IndexName = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    ReadOnly = True
    TableName = 'indiriz.db'
    Left = 110
    Top = 80
    object tbIndirCodInd: TIntegerField
      FieldName = 'CodInd'
      Visible = False
    end
    object tbIndirCodCon: TIntegerField
      FieldName = 'CodCon'
      Visible = False
    end
    object tbIndirTipo: TIntegerField
      FieldName = 'Tipo'
      Visible = False
    end
    object tbIndirIndirizzo: TMemoField
      DisplayWidth = 10
      FieldName = 'Indirizzo'
      Visible = False
      BlobType = ftMemo
      Size = 200
    end
    object tbIndirNote: TStringField
      DisplayWidth = 26
      FieldName = 'Note'
      Visible = False
      Size = 40
    end
    object tbIndirIndir: TStringField
      DisplayLabel = 'Indirizzo'
      DisplayWidth = 100
      FieldKind = fkCalculated
      FieldName = 'Indir'
      Size = 100
      Calculated = True
    end
  end
  object tbTelef: TTable
    OnCalcFields = tbTelefCalcFields
    DatabaseName = 'DB'
    IndexName = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    ReadOnly = True
    TableName = 'TELEF.DB'
    Left = 80
    Top = 80
    object tbTelefCodTel: TIntegerField
      FieldName = 'CodTel'
      Visible = False
    end
    object tbTelefCodCon: TIntegerField
      FieldName = 'CodCon'
      Visible = False
    end
    object tbTelefTipo: TIntegerField
      FieldName = 'Tipo'
      Visible = False
    end
    object tbTelefTel_Pre1: TStringField
      DisplayLabel = 'Pre1.'
      DisplayWidth = 6
      FieldName = 'Tel_Pre1'
      Visible = False
      Size = 6
    end
    object tbTelefTel_Pre2: TStringField
      DisplayLabel = 'Pre.'
      DisplayWidth = 6
      FieldName = 'Tel_Pre2'
      Visible = False
      Size = 6
    end
    object tbTelefTelefono: TStringField
      DisplayWidth = 8
      FieldName = 'Telefono'
      Visible = False
      Size = 18
    end
    object tbTelefTelef: TStringField
      Alignment = taRightJustify
      DisplayLabel = 'Numero telefonico'
      DisplayWidth = 16
      FieldKind = fkCalculated
      FieldName = 'Telef'
      Size = 30
      Calculated = True
    end
    object tbTelefTelefTipo: TStringField
      DisplayLabel = 'Tipo telef.'
      FieldKind = fkCalculated
      FieldName = 'TelefTipo'
      Size = 10
      Calculated = True
    end
    object tbTelefNote: TStringField
      DisplayWidth = 45
      FieldName = 'Note'
      Size = 40
    end
  end
  object tbContat: TTable
    OnCalcFields = tbContatCalcFields
    DatabaseName = 'DB'
    ReadOnly = True
    TableName = 'contat.db'
    Left = 50
    Top = 80
    object tbContatCodCon: TIntegerField
      FieldName = 'CodCon'
    end
    object tbContatTipo: TIntegerField
      FieldName = 'Tipo'
    end
    object tbContatNome_Tit: TStringField
      FieldName = 'Nome_Tit'
      Size = 10
    end
    object tbContatNome_Pre1: TStringField
      FieldName = 'Nome_Pre1'
    end
    object tbContatNome_Pre2: TStringField
      FieldName = 'Nome_Pre2'
      Size = 40
    end
    object tbContatNome_Main: TStringField
      FieldName = 'Nome_Main'
      Size = 40
    end
    object tbContatNome_Suf: TStringField
      FieldName = 'Nome_Suf'
      Size = 10
    end
    object tbContatClasse: TStringField
      FieldName = 'Classe'
      Size = 15
    end
    object tbContatSettore: TStringField
      FieldName = 'Settore'
      Size = 35
    end
    object tbContatNote: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
      Size = 100
    end
    object tbContatNome: TStringField
      FieldKind = fkCalculated
      FieldName = 'Nome'
      Size = 80
      Calculated = True
    end
  end
  object DBMessage: TDBMessageLink
    Active = False
    Left = 50
    Top = 50
  end
  object DBConnection: TDBConnectionLink
    Active = False
    OnConnect = DBConnectionConnect
    OnDisconnect = DBConnectionConnect
    Left = 20
    Top = 50
  end
  object dsContat: TDataSource
    DataSet = tbContat
    OnDataChange = dsContatDataChange
    Left = 50
    Top = 95
  end
  object dsIndir: TDataSource
    DataSet = tbIndir
    OnDataChange = dsIndirDataChange
    Left = 110
    Top = 95
  end
  object dsNickName: TDataSource
    DataSet = qryNickName
    OnDataChange = dsNickNameDataChange
    Left = 10
    Top = 95
  end
  object dsTelef: TDataSource
    DataSet = tbTelef
    OnDataChange = dsTelefDataChange
    Left = 80
    Top = 95
  end
  object tbIndir2: TTable
    OnCalcFields = tbIndirCalcFields
    DatabaseName = 'DB'
    TableName = 'indiriz.db'
    Left = 110
    Top = 110
    object tbIndir2CodInd: TIntegerField
      FieldName = 'CodInd'
    end
    object tbIndir2CodCon: TIntegerField
      FieldName = 'CodCon'
    end
    object tbIndir2Tipo: TIntegerField
      FieldName = 'Tipo'
    end
    object tbIndir2Indirizzo: TMemoField
      FieldName = 'Indirizzo'
      BlobType = ftMemo
      Size = 200
    end
    object tbIndir2Note: TStringField
      FieldName = 'Note'
      Size = 40
    end
  end
  object qryNickName: TQuery
    DatabaseName = 'DB'
    SQL.Strings = (
      
        'select CodCon, NickName from NickName where NickName like :aNick' +
        'Name')
    UniDirectional = True
    Left = 10
    Top = 80
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'aNickName'
        ParamType = ptUnknown
      end>
    object qryNickNameCodCon: TIntegerField
      FieldName = 'CodCon'
      Visible = False
    end
    object qryNickNameNickName: TStringField
      FieldName = 'NickName'
      Size = 40
    end
  end
end
