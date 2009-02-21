object repDatiContatto: TrepDatiContatto
  Left = 243
  Top = 144
  Caption = 'repDatiContatto'
  ClientHeight = 123
  ClientWidth = 233
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object tbIndir: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'INDIRIZ.DB'
    Left = 75
    Top = 15
    object tbIndirCodInd: TIntegerField
      FieldName = 'CodInd'
    end
    object tbIndirCodCon: TIntegerField
      FieldName = 'CodCon'
      Required = True
    end
    object tbIndirTipo: TIntegerField
      FieldName = 'Tipo'
    end
    object tbIndirIndirizzo: TMemoField
      FieldName = 'Indirizzo'
      BlobType = ftMemo
      Size = 200
    end
    object tbIndirNote: TStringField
      FieldName = 'Note'
      Size = 40
    end
  end
  object tbContat: TTable
    DatabaseName = 'DB'
    TableName = 'CONTAT.DB'
    Left = 35
    Top = 15
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
    Left = 35
    Top = 25
  end
  object tbTelef: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'TELEF.DB'
    Left = 75
    Top = 45
    object tbTelefCodTel: TIntegerField
      FieldName = 'CodTel'
    end
    object tbTelefCodCon: TIntegerField
      FieldName = 'CodCon'
      Required = True
    end
    object tbTelefTipo: TIntegerField
      FieldName = 'Tipo'
    end
    object tbTelefTel_Pre1: TStringField
      FieldName = 'Tel_Pre1'
      Size = 6
    end
    object tbTelefTel_Pre2: TStringField
      FieldName = 'Tel_Pre2'
      Size = 6
    end
    object tbTelefTelefono: TStringField
      FieldName = 'Telefono'
      Size = 18
    end
    object tbTelefNote: TStringField
      FieldName = 'Note'
      Size = 40
    end
  end
  object tbNickName: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'NICKNAME.DB'
    Left = 105
    Top = 15
    object tbNickNameProg: TIntegerField
      FieldName = 'Prog'
    end
    object tbNickNameCodCon: TIntegerField
      FieldName = 'CodCon'
    end
    object tbNickNameNickName: TStringField
      FieldName = 'NickName'
      Size = 40
    end
  end
  object tbDateImp: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'DATEIMPO.DB'
    Left = 105
    Top = 45
    object tbDateImpProg: TIntegerField
      FieldName = 'Prog'
    end
    object tbDateImpCodCon: TIntegerField
      FieldName = 'CodCon'
      Required = True
    end
    object tbDateImpTipo: TIntegerField
      FieldName = 'Tipo'
    end
    object tbDateImpData: TDateField
      FieldName = 'Data'
    end
    object tbDateImpNota: TStringField
      FieldName = 'Nota'
      Size = 50
    end
  end
  object tbRefer: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'REFERENT.DB'
    Left = 75
    Top = 80
    object tbReferProg: TIntegerField
      FieldName = 'Prog'
    end
    object tbReferCodCon: TIntegerField
      FieldName = 'CodCon'
      Required = True
    end
    object tbReferCodRef: TIntegerField
      FieldName = 'CodRef'
      Required = True
    end
  end
  object tbContat2: TTable
    DatabaseName = 'DB'
    TableName = 'CONTAT.DB'
    Left = 90
    Top = 100
    object IntegerField4: TIntegerField
      FieldName = 'CodCon'
    end
    object IntegerField5: TIntegerField
      FieldName = 'Tipo'
    end
    object StringField2: TStringField
      FieldName = 'Nome_Tit'
      Size = 10
    end
    object StringField3: TStringField
      FieldName = 'Nome_Pre1'
    end
    object StringField4: TStringField
      FieldName = 'Nome_Pre2'
      Size = 40
    end
    object StringField5: TStringField
      FieldName = 'Nome_Main'
      Size = 40
    end
    object StringField6: TStringField
      FieldName = 'Nome_Suf'
      Size = 10
    end
    object StringField7: TStringField
      FieldName = 'Classe'
      Size = 15
    end
    object StringField8: TStringField
      FieldName = 'Settore'
      Size = 35
    end
    object MemoField1: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
      Size = 100
    end
  end
  object tbReferDi: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'CodRef'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'REFERENT.DB'
    Left = 110
    Top = 80
    object IntegerField1: TIntegerField
      FieldName = 'Prog'
    end
    object IntegerField2: TIntegerField
      FieldName = 'CodCon'
      Required = True
    end
    object IntegerField3: TIntegerField
      FieldName = 'CodRef'
      Required = True
    end
  end
  object tbConnessi: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'CONNESSI.DB'
    Left = 135
    Top = 15
    object tbConnessiCodCos: TIntegerField
      FieldName = 'CodCos'
    end
    object tbConnessiCodCon: TIntegerField
      FieldName = 'CodCon'
      Required = True
    end
    object tbConnessiTipo: TIntegerField
      FieldName = 'Tipo'
    end
    object tbConnessiData: TDateTimeField
      FieldName = 'Data'
      Required = True
    end
    object tbConnessiContenuto: TStringField
      FieldName = 'Contenuto'
      Size = 50
    end
    object tbConnessiNote: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
      Size = 200
    end
    object tbConnessiURL: TStringField
      FieldName = 'URL'
      Size = 255
    end
  end
  object tbGruppi: TTable
    DatabaseName = 'DB'
    TableName = 'GRUPPI.DB'
    Left = 165
    Top = 75
    object tbGruppiCodGrp: TIntegerField
      FieldName = 'CodGrp'
    end
    object tbGruppiDesc: TStringField
      FieldName = 'Desc'
      Size = 30
    end
  end
  object tbInGruppi: TTable
    DatabaseName = 'DB'
    IndexFieldNames = 'CodCon'
    MasterFields = 'CodCon'
    MasterSource = dsContat
    TableName = 'INGRUPPO.DB'
    Left = 165
    Top = 60
    object tbInGruppiProg: TIntegerField
      FieldName = 'Prog'
    end
    object tbInGruppiCodCon: TIntegerField
      FieldName = 'CodCon'
    end
    object tbInGruppiCodGrp: TIntegerField
      FieldName = 'CodGrp'
    end
  end
  object Rep: TeLineReport
    AutoCR = False
    PageHeight = 66
    PageWidth = 98
    HeaderSize = 3
    FooterSize = 2
    DeviceKind = '<<no device>>'
    OnPageHeader = RepPageHeader
    OnPageFooter = RepPageFooter
    OnSetupDevice = RepSetupDevice
    Left = 180
    Top = 10
  end
end
