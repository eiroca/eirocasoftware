object fmMain: TfmMain
  Left = 195
  Top = 110
  Caption = 'Gestione Mutui'
  ClientHeight = 287
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 40
    Top = 35
    object miMutui: TMenuItem
      Caption = 'Mutui'
      object miMutuiNew: TMenuItem
        Caption = 'Nuovo Mutuo'
        OnClick = miMutuiNewClick
      end
      object miMutuiLoad: TMenuItem
        Caption = 'Carica'
        OnClick = miMutuiLoadClick
      end
      object miMutuiSave: TMenuItem
        Caption = 'Salva'
        OnClick = miMutuiSaveClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Disponi1: TMenuItem
        Caption = 'Disponi'
        object Affiancati1: TMenuItem
          Caption = 'Affiancati'
          OnClick = Affiancati1Click
        end
        object Cascade1: TMenuItem
          Caption = 'In cascata'
          OnClick = Cascade1Click
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miMutuiExit: TMenuItem
        Caption = 'Esci'
        OnClick = miMutuiExitClick
      end
    end
    object Aiuto1: TMenuItem
      Caption = 'Aiuto'
      object About1: TMenuItem
        Caption = 'About...'
        OnClick = About1Click
      end
    end
  end
  object odMutuo: TOpenDialog
    DefaultExt = 'mut'
    Filter = 'Definizione mutui|*.mut|Tutti i file|*.*'
    Options = [ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofFileMustExist]
    Left = 75
    Top = 35
  end
  object sdMutuo: TSaveDialog
    DefaultExt = 'mut'
    Filter = 'Definizione mutui|*.mut|Tutti i file|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofNoReadOnlyReturn]
    Left = 110
    Top = 35
  end
end
