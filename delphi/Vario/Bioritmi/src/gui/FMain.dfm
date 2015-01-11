object fmMain: TfmMain
  Left = 195
  Top = 114
  BorderStyle = bsSingle
  Caption = 'Bioritmi e affinit'#224
  ClientHeight = 270
  ClientWidth = 573
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 10
    Width = 62
    Height = 13
    Caption = 'Previsioni del'
  end
  object RxSpinButton1: TJvSpinButton
    Left = 200
    Top = 9
    FocusControl = iOggi
    OnBottomClick = RxSpinButton1BottomClick
    OnTopClick = RxSpinButton1TopClick
  end
  object gbLui: TGroupBox
    Left = 5
    Top = 35
    Width = 251
    Height = 226
    Caption = ' Lui '
    TabOrder = 1
    object Label3: TLabel
      Left = 10
      Top = 85
      Width = 63
      Height = 13
      Caption = 'Ciclo emotivo'
    end
    object Label4: TLabel
      Left = 10
      Top = 130
      Width = 50
      Height = 13
      Caption = 'Ciclo fisico'
    end
    object Label5: TLabel
      Left = 10
      Top = 175
      Width = 73
      Height = 13
      Caption = 'Ciclo intellettivo'
    end
    object Label2: TLabel
      Left = 100
      Top = 50
      Width = 126
      Height = 13
      Caption = 'Male                          Bene'
    end
    object lbLui: TLabel
      Left = 10
      Top = 205
      Width = 22
      Height = 13
      Caption = 'lbLui'
    end
    object Label10: TLabel
      Left = 10
      Top = 25
      Width = 46
      Height = 13
      Caption = 'Sei nato il'
    end
    object lbLuiG: TLabel
      Left = 175
      Top = 25
      Width = 30
      Height = 13
      Caption = 'lbLuiG'
    end
    object iData1: TJvDateEdit
      Left = 65
      Top = 20
      Width = 101
      Height = 21
      NumGlyphs = 2
      ShowNullDate = False
      WeekendColor = clHighlight
      TabOrder = 0
      OnButtonClick = iOggiChange
      OnChange = iOggiChange
    end
    object tbEmotivo1: TTrackBar
      Left = 90
      Top = 69
      Width = 150
      Height = 45
      Enabled = False
      Max = 100
      Min = -100
      Frequency = 25
      TabOrder = 1
      TickMarks = tmBoth
    end
    object tbFisico1: TTrackBar
      Left = 90
      Top = 114
      Width = 150
      Height = 45
      Enabled = False
      Max = 100
      Min = -100
      Frequency = 25
      TabOrder = 2
      TickMarks = tmBoth
    end
    object tbIntellettivo1: TTrackBar
      Left = 90
      Top = 159
      Width = 150
      Height = 45
      Enabled = False
      Max = 100
      Min = -100
      Frequency = 25
      TabOrder = 3
      TickMarks = tmBoth
    end
  end
  object iOggi: TJvDateEdit
    Left = 73
    Top = 8
    Width = 121
    Height = 21
    DefaultToday = True
    NumGlyphs = 2
    ShowNullDate = False
    TabOrder = 0
    OnButtonClick = iOggiChange
    OnChange = iOggiChange
  end
  object GroupBox1: TGroupBox
    Left = 316
    Top = 35
    Width = 251
    Height = 226
    Caption = ' Lei '
    TabOrder = 2
    object Label6: TLabel
      Left = 20
      Top = 50
      Width = 126
      Height = 13
      Caption = 'Male                          Bene'
    end
    object Label7: TLabel
      Left = 160
      Top = 85
      Width = 63
      Height = 13
      Caption = 'Ciclo emotivo'
    end
    object Label8: TLabel
      Left = 160
      Top = 130
      Width = 50
      Height = 13
      Caption = 'Ciclo fisico'
    end
    object Label9: TLabel
      Left = 160
      Top = 175
      Width = 73
      Height = 13
      Caption = 'Ciclo intellettivo'
    end
    object lbLei: TLabel
      Left = 10
      Top = 205
      Width = 22
      Height = 13
      Caption = 'lbLei'
    end
    object lbLeiG: TLabel
      Left = 185
      Top = 25
      Width = 30
      Height = 13
      Caption = 'lbLeiG'
    end
    object Label11: TLabel
      Left = 10
      Top = 25
      Width = 46
      Height = 13
      Caption = 'Sei nata il'
    end
    object iData2: TJvDateEdit
      Left = 65
      Top = 20
      Width = 111
      Height = 21
      NumGlyphs = 2
      ShowNullDate = False
      TabOrder = 0
      OnButtonClick = iOggiChange
      OnChange = iOggiChange
    end
    object tbEmotivo2: TTrackBar
      Left = 10
      Top = 69
      Width = 150
      Height = 45
      Enabled = False
      Max = 100
      Min = -100
      Frequency = 25
      TabOrder = 1
      TickMarks = tmBoth
    end
    object tbFisico2: TTrackBar
      Left = 10
      Top = 114
      Width = 150
      Height = 45
      Enabled = False
      Max = 100
      Min = -100
      Frequency = 25
      TabOrder = 2
      TickMarks = tmBoth
    end
    object tbIntellettivo2: TTrackBar
      Left = 10
      Top = 159
      Width = 150
      Height = 45
      Enabled = False
      Max = 100
      Min = -100
      Frequency = 25
      TabOrder = 3
      TickMarks = tmBoth
    end
  end
  object GroupBox2: TGroupBox
    Left = 256
    Top = 35
    Width = 60
    Height = 226
    Caption = ' Affinit'#224' '
    TabOrder = 3
    object lbAff1: TLabel
      Left = 5
      Top = 15
      Width = 51
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbAff1'
    end
    object lbAff2: TLabel
      Left = 4
      Top = 205
      Width = 51
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbAff2'
    end
    object egAffinita: TeGauge
      Left = 4
      Top = 30
      Width = 51
      Height = 171
      BlockHeight = 10
      Min = 0
      Max = 100
      Value = 100
      Separator = 1
      Low = 33
      High = 66
      ForeColor = clYellow
      LowColor = clRed
      HighColor = clLime
      GridColor = clLime
      DrawGrid = False
      GridWidth = 10
      Color = clBtnFace
    end
  end
  object BitBtn1: TBitBtn
    Left = 490
    Top = 4
    Width = 75
    Height = 28
    Caption = 'About...'
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000010000000000000000000
      BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333300003333333333333333333300003333000333333333333300003333
      08803333333333330000333330F8033333333333000033333307803333333333
      00003333330F700333333333000033333330780380333333000033333300F700
      0803333300003333330F0F700780333300003333300F0FF70080333300003333
      30F0F0FF7078033300003333300F0F0F777703330000333330F0F07FF7770333
      00003333330F07FFFF770333000033333330FF7FFFF703330000333333330FFF
      FFF7033300003333333330F7FFFF703300003333333333000000003300003333
      33333333333333330000}
    Layout = blGlyphRight
    Margin = 5
    Spacing = -1
    TabOrder = 4
    OnClick = BitBtn1Click
  end
  object fsMain: TJvFormStorage
    AppStorage = apStorage
    AppStoragePath = '%FORM_NAME%\'
    StoredProps.Strings = (
      'iData1.Text'
      'iData2.Text')
    StoredValues = <
      item
      end>
    Left = 273
    Top = 133
  end
  object apStorage: TJvAppIniFileStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    SubStorages = <>
    Left = 272
    Top = 80
  end
end
