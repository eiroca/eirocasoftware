object fmMain: TfmMain
  Left = 221
  Top = 134
  Caption = 'Gestione Articoli'
  ClientHeight = 313
  ClientWidth = 489
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Button1: TButton
    Left = 225
    Top = 20
    Width = 89
    Height = 33
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object MainMenu1: TMainMenu
    Left = 125
    Top = 60
    object Sistema1: TMenuItem
      Caption = '&Sistema'
      object Tabelle1: TMenuItem
        Caption = '&Tabelle'
        object PianodiCodifica1: TMenuItem
          Caption = 'Piano di Codifica'
          OnClick = PianodiCodifica1Click
        end
        object N3: TMenuItem
          Caption = '-'
        end
        object TabellaaliquoteIVA1: TMenuItem
          Caption = 'Tabella aliquote IVA'
          OnClick = TabellaaliquoteIVA1Click
        end
        object Tabellaunitadimisura1: TMenuItem
          Caption = 'Tabella unita'#39' di misura'
          OnClick = Tabellaunitadimisura1Click
        end
      end
      object Opzioni1: TMenuItem
        Caption = '&Opzioni'
        OnClick = Opzioni1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object CompattazioneDataBase1: TMenuItem
        Caption = 'Compattazione DataBase'
        OnClick = CompattazioneDataBase1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Esci1: TMenuItem
        Caption = '&Esci'
        OnClick = Esci1Click
      end
    end
    object Articoli1: TMenuItem
      Caption = '&Articoli'
      object Cercaarticoli1: TMenuItem
        Caption = 'Cerca articoli'
        OnClick = Cercaarticoli1Click
      end
      object DatiArticoli1: TMenuItem
        Caption = 'Dati Articoli'
        OnClick = DatiArticoli1Click
      end
    end
    object FattureFornitori1: TMenuItem
      Caption = '&Fornitori'
      object Fornitori1: TMenuItem
        Caption = 'Fornitori'
        OnClick = Fornitori1Click
      end
      object Inserimentofattura1: TMenuItem
        Caption = 'Fatture/Preventivi'
        OnClick = Inserimentofattura1Click
      end
    end
    object Finestre1: TMenuItem
      Caption = 'F&inestre'
      object Cascade1: TMenuItem
        Caption = 'Sovrapponi'
        OnClick = Cascade1Click
      end
      object Affianca1: TMenuItem
        Caption = 'Affianca'
        OnClick = Affianca1Click
      end
    end
    object Aiuto1: TMenuItem
      Caption = '&Aiuto'
      object Informazionisu1: TMenuItem
        Caption = 'Informazioni su...'
        OnClick = Informazionisu1Click
      end
    end
  end
end
