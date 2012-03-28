object fmMain: TfmMain
  Left = 200
  Top = 110
  Caption = 'Gestione Tabacchi'
  ClientHeight = 68
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mnMain
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mnMain: TMainMenu
    Left = 47
    Top = 6
    object miTaba: TMenuItem
      Caption = '&Tabacchi'
      object miTabaFind: TMenuItem
        Caption = '&Ricerca Tabacchi'
        OnClick = miTabaFindClick
      end
      object miTabaTaba: TMenuItem
        Caption = 'Gestione &Tabacchi'
        object miTabaTabaEdit: TMenuItem
          Caption = '&Mostra/Modifica'
          OnClick = miTabaTabaEditClick
        end
        object miTabaTabaPrint: TMenuItem
          Caption = '&Stampa'
          OnClick = miTabaTabaPrintClick
        end
      end
      object miTabaPrez: TMenuItem
        Caption = 'Gestione &Listino Prezzi'
        object miTabaPrezStampa: TMenuItem
          Caption = 'Stampa &Listino'
          OnClick = miTabaPrezStampaClick
        end
        object miTabaPrezInsert: TMenuItem
          Caption = '&Cambio di Prezzo'
          OnClick = miTabaPrezInsertClick
        end
        object miTabaPrezEdit: TMenuItem
          Caption = '&Mostra/Modifica'
          OnClick = miTabaPrezEditClick
        end
        object miTabaPrezSelect: TMenuItem
          Caption = '&Selezione Prezzi'
          OnClick = miTabaPrezSelectClick
        end
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object miTabaModuInve: TMenuItem
        Caption = 'Stampa Moduli &Inventario'
        OnClick = miTabaModuInveClick
      end
      object miTabaCalcStat: TMenuItem
        Caption = 'Aggiorna &Statistiche'
        OnClick = miTabaCalcStatClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miTabaUtil: TMenuItem
        Caption = 'Funzioni &Utilit'#224
        object miTabaUtilInfo: TMenuItem
          Caption = '&Informazioni'
          OnClick = miTabaUtilInfoClick
        end
        object miTabaUtilSetup: TMenuItem
          Caption = 'Impostazioni &Stampante'
          OnClick = miTabaUtilSetupClick
        end
        object miTabaUtilPackDB: TMenuItem
          Caption = '&Compattazione Database'
          OnClick = miTabaUtilPackDBClick
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miTabaExit: TMenuItem
        Caption = '&Esci dal Programma'
        OnClick = miTabaExitClick
      end
    end
    object miMovi: TMenuItem
      Caption = '&Movimenti'
      object miMoviGiacInsert: TMenuItem
        Caption = 'Inserimento &Giacenze'
        OnClick = miMoviGiacInsertClick
      end
      object miMoviGiacEdit: TMenuItem
        Caption = 'Mostra/&Modifica Giacenze'
        OnClick = miMoviGiacEditClick
      end
      object miMoviGiacPrint: TMenuItem
        Caption = '&Stampa Ultima Giacenza'
        OnClick = miMoviGiacPrintClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object miMoviOrdiInsert: TMenuItem
        Caption = 'Inserimento &Ordini'
        OnClick = miMoviOrdiInsertClick
      end
      object miMoviOrdiEdit: TMenuItem
        Caption = 'Mostra/Mo&difica Ordini'
        OnClick = miMoviOrdiEditClick
      end
      object miMoviOrdiConsegna: TMenuItem
        Caption = 'Bolletta di &Carico'
        OnClick = miMoviOrdiConsegnaClick
      end
      object miMoviOrdiPrint: TMenuItem
        Caption = 'Stampa &Riepilogo Ordini'
        OnClick = miMoviOrdiPrintClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object miMoviValorizzazioni: TMenuItem
        Caption = '&Valorizzazioni'
        OnClick = miMoviValorizzazioniClick
      end
      object Stampastatistiche1: TMenuItem
        Caption = 'Stampa S&tatistiche'
        OnClick = Stampastatistiche1Click
      end
      object StampaTendenze1: TMenuItem
        Caption = 'Stampa Tendenze'
        OnClick = StampaTendenze1Click
      end
      object StampaOrdinato1: TMenuItem
        Caption = 'Stampa Carichi'
        OnClick = StampaOrdinato1Click
      end
    end
    object miPate: TMenuItem
      Caption = '&Patentini'
      object miPateRichInsert: TMenuItem
        Caption = 'Richiesta da &Petentino'
        OnClick = miPateRichInsertClick
      end
      object miPateRichEdit: TMenuItem
        Caption = '&Mostra/Modifica Richieste'
        OnClick = miPateRichEditClick
      end
      object miPateRichConsegne: TMenuItem
        Caption = '&Consegna a Patentino'
        OnClick = miPateRichConsegneClick
      end
      object miPateRichPrint: TMenuItem
        Caption = 'Stampa &Riepilogo Richieste'
        OnClick = miPateRichPrintClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object miPateEdit: TMenuItem
        Caption = 'Modifica &Dati Patentini'
        OnClick = miPateEditClick
      end
    end
    object miHelp: TMenuItem
      Caption = '&Aiuto'
      object miHelpAbout: TMenuItem
        Caption = 'Informazioni su...'
        OnClick = miHelpAboutClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object miHelpHelp: TMenuItem
        Caption = 'Aiuto sugli aiuti'
        OnClick = miHelpHelpClick
      end
    end
  end
  object fsForm: TJvFormStorage
    AppStoragePath = '%FORM_NAME%\'
    OnRestorePlacement = fsFormRestorePlacement
    StoredValues = <>
    Left = 10
    Top = 5
  end
  object AppEvents1: TJvAppEvents
    OnSettingsChanged = AppEvents1SettingsChanged
    Left = 80
    Top = 5
  end
  object apStorage: TJvAppIniFileStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    SubStorages = <>
    Left = 152
    Top = 8
  end
end
