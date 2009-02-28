object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'eicBrain 1.0'
  ClientHeight = 394
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object sbStatus: TStatusBar
    Left = 0
    Top = 375
    Width = 562
    Height = 19
    Panels = <>
  end
  object MainMenu1: TMainMenu
    Left = 144
    Top = 128
    object File1: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Statistica1: TMenuItem
      Caption = 'Statistica'
      Hint = 
        'Procedure Statistiche: Distribuzioni, ANOVA, regressioni, fit, .' +
        '.. '
      object Distribuzioniteorichediscrete1: TMenuItem
        Caption = 'Distribuzioni teoriche discrete'
      end
      object Distribuzioniteorichecontinue1: TMenuItem
        Caption = 'Distribuzioni teoriche continue'
      end
    end
    object eoriadeisistemi1: TMenuItem
      Caption = 'Teoria dei sistemi'
      Hint = 
        'Teoria Dei Sistemi: Modellazione Sistemi, pianificazione esperim' +
        'enti '
    end
    object RicercaOperativa1: TMenuItem
      Caption = 'Ricerca Operativa'
      Hint = 'Ricerca Operativa: Ricerca minimi, Grafi, ... '
    end
    object Economia1: TMenuItem
      Caption = 'Economia'
      Hint = 'Economici: Calcolo valori attuali, ...'
      object Gestioneequazioneannuity1: TMenuItem
        Caption = 'Gestione equazione annuity'
        OnClick = Gestioneequazioneannuity1Click
      end
      object ScoTra1: TMenuItem
        Caption = 'Sconto di una tratta   '
        OnClick = ScoTra1Click
      end
      object Wizard1: TMenuItem
        Caption = 'Wizard'
        object DepositoMinimoxserieprelievi1: TMenuItem
          Caption = 'Deposito minimo per prelievi'
          OnClick = DepositoMinimoxserieprelievi1Click
        end
        object Depositoperaccumularecifra1: TMenuItem
          Caption = 'Deposito per accumulare cifra'
          OnClick = Depositoperaccumularecifra1Click
        end
        object Deprezzamentodiunbene1: TMenuItem
          Caption = 'Deprezzamento di un bene'
          OnClick = Deprezzamentodiunbene1Click
        end
        object Duratadiunprestito1: TMenuItem
          Caption = 'Durata di un prestito '
          OnClick = Duratadiunprestito1Click
        end
        object z1: TMenuItem
          Caption = 'Pagamento regolare'
          OnClick = z1Click
        end
        object Prelieviregolaridadeposito1: TMenuItem
          Caption = 'Prelievi regolari da deposito'
          OnClick = Prelieviregolaridadeposito1Click
        end
        object Sommaprestata1: TMenuItem
          Caption = 'Somma prestata'
          OnClick = Sommaprestata1Click
        end
        object assodirendimentoquotadideprezzamento1: TMenuItem
          Caption = 'Tasso di rendimento, quota di deprezzamento'
          OnClick = assodirendimentoquotadideprezzamento1Click
        end
        object assodiinteressediunprestito1: TMenuItem
          Caption = 'Tasso di interesse di un prestito'
          OnClick = assodiinteressediunprestito1Click
        end
        object assodiinteresseinvestimento1: TMenuItem
          Caption = 'Tasso di interesse investimento '
          OnClick = assodiinteresseinvestimento1Click
        end
        object Ultimopagamentodiunprestito1: TMenuItem
          Caption = 'Ultimo pagamento di un prestito'
          OnClick = Ultimopagamentodiunprestito1Click
        end
        object Valoreattualediuninvestimento1: TMenuItem
          Caption = 'Valore attuale di un investimento'
          OnClick = Valoreattualediuninvestimento1Click
        end
        object Valoredirecuperoscontocomposto1: TMenuItem
          Caption = 'Valore di recupero, sconto composto'
          OnClick = Valoredirecuperoscontocomposto1Click
        end
        object Valoreinvestimento1: TMenuItem
          Caption = 'Valore investimento '
          OnClick = Valoreinvestimento1Click
        end
      end
    end
    object Finanziari1: TMenuItem
      Caption = 'Finanziari'
      Hint = 'Finanziari: Cash flow, ... '
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnHint = ApplicationEvents1Hint
    Left = 16
    Top = 152
  end
end
