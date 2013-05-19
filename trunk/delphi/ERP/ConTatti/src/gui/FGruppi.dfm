object fmGruppi: TfmGruppi
  Left = 255
  Top = 155
  BorderStyle = bsDialog
  Caption = 'fmGruppi'
  ClientHeight = 256
  ClientWidth = 398
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 5
    Width = 84
    Height = 13
    Caption = 'Struttura presente'
  end
  object lbWhat: TLabel
    Left = 225
    Top = 5
    Width = 34
    Height = 13
    Caption = 'lbWhat'
  end
  object olSchema: TOutline
    Left = 10
    Top = 25
    Width = 200
    Height = 221
    Hint = 'Utilizza il Drag & Drop per ottenere le associazioni volute'
    OutlineStyle = osPlusMinusText
    Options = [ooDrawTreeRoot, ooDrawFocusRect, ooStretchBitmaps]
    ItemHeight = 13
    TabOrder = 0
    OnDragDrop = olSchemaDragDrop
    OnDragOver = olSchemaDragOver
    OnMouseDown = olSchemaMouseDown
    OnMouseUp = olSchemaMouseUp
    ItemSeparator = '\'
    Data = {10}
  end
  object lbChoice: TListBox
    Left = 220
    Top = 25
    Width = 166
    Height = 146
    Hint = 'Utilizza il Drag & Drop per ottenere le associazioni volute'
    DragMode = dmAutomatic
    ItemHeight = 13
    TabOrder = 1
    OnDragDrop = lbChoiceDragDrop
    OnDragOver = lbChoiceDragOver
  end
  object btContatti: TBitBtn
    Left = 305
    Top = 185
    Width = 80
    Height = 25
    Hint = 'Mostra i gruppi a cui i vari '#13#10'contatti appartengono '
    Caption = 'Contatti'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00303333333333
      333337F3333333333333303333333333333337F33FFFFF3FF3FF303300000300
      300337FF77777F77377330000BBB0333333337777F337F33333330330BB00333
      333337F373F773333333303330033333333337F3377333333333303333333333
      333337F33FFFFF3FF3FF303300000300300337FF77777F77377330000BBB0333
      333337777F337F33333330330BB00333333337F373F773333333303330033333
      333337F3377333333333303333333333333337FFFF3FF3FFF333000003003000
      333377777F77377733330BBB0333333333337F337F33333333330BB003333333
      333373F773333333333330033333333333333773333333333333}
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 2
    OnClick = btContattiClick
  end
  object btGruppi: TBitBtn
    Left = 220
    Top = 185
    Width = 80
    Height = 25
    Hint = 'Mostra i contatti che appartengono '#13#10'ai vari gruppi'
    Caption = 'Gruppi'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00303333333333
      333337F3333333333333303333333333333337F33FFFFF3FF3FF303300000300
      300337FF77777F77377330000BBB0333333337777F337F33333330330BB00333
      333337F373F773333333303330033333333337F3377333333333303333333333
      333337F33FFFFF3FF3FF303300000300300337FF77777F77377330000BBB0333
      333337777F337F33333330330BB00333333337F373F773333333303330033333
      333337F3377333333333303333333333333337FFFF3FF3FFF333000003003000
      333377777F77377733330BBB0333333333337F337F33333333330BB003333333
      333373F773333333333330033333333333333773333333333333}
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 3
    OnClick = btGruppiClick
  end
  object btSave: TBitBtn
    Left = 220
    Top = 215
    Width = 80
    Height = 25
    Hint = 'Salva le modifiche effettuate'
    Caption = 'Salva'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
      7700333333337777777733333333008088003333333377F73377333333330088
      88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
      000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
      FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
      99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
      99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
      99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
      93337FFFF7737777733300000033333333337777773333333333}
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 4
    OnClick = btSaveClick
  end
  object btClose: TBitBtn
    Left = 305
    Top = 215
    Width = 80
    Height = 25
    Hint = 'Chiude la finestra'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      555555555555555555555555555555555555555555FF55555555555559055555
      55555555577FF5555555555599905555555555557777F5555555555599905555
      555555557777FF5555555559999905555555555777777F555555559999990555
      5555557777777FF5555557990599905555555777757777F55555790555599055
      55557775555777FF5555555555599905555555555557777F5555555555559905
      555555555555777FF5555555555559905555555555555777FF55555555555579
      05555555555555777FF5555555555557905555555555555777FF555555555555
      5990555555555555577755555555555555555555555555555555}
    ModalResult = 1
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 5
  end
  object tbInGruppo: TTable
    DatabaseName = 'DB'
    TableName = 'INGRUPPO.DB'
    Left = 125
    Top = 140
    object tbInGruppoProg: TIntegerField
      FieldName = 'Prog'
    end
    object tbInGruppoCodCon: TIntegerField
      FieldName = 'CodCon'
    end
    object tbInGruppoCodGrp: TIntegerField
      FieldName = 'CodGrp'
    end
  end
  object dsInGruppo: TDataSource
    DataSet = tbInGruppo
    Left = 135
    Top = 140
  end
  object tbGruppi: TTable
    DatabaseName = 'DB'
    TableName = 'GRUPPI.DB'
    Left = 125
    Top = 110
    object tbGruppiCodGrp: TIntegerField
      FieldName = 'CodGrp'
    end
    object tbGruppiDesc: TStringField
      FieldName = 'Desc'
      Size = 30
    end
  end
  object dsGruppi: TDataSource
    DataSet = tbGruppi
    Left = 135
    Top = 110
  end
  object tbContat: TTable
    DatabaseName = 'DB'
    TableName = 'contat.db'
    Left = 125
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
  end
  object dsContat: TDataSource
    DataSet = tbContat
    Left = 135
    Top = 80
  end
  object fpGruppi: TJvFormPlacement
    AppStorage = fmMain.apStorage
    AppStoragePath = '%FORM_NAME%'
    Left = 55
    Top = 75
  end
end
