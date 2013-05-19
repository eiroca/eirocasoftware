object fmMain: TfmMain
  Left = 239
  Top = 129
  Caption = 'Contabilit'#224
  ClientHeight = 246
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 50
    Top = 10
    object mnFile: TMenuItem
      Caption = '&Sistema'
      object N1: TMenuItem
        Caption = '-'
      end
      object miExit: TMenuItem
        Caption = '&Esci dal Programma'
        OnClick = miExitClick
      end
    end
    object ContGenerale1: TMenuItem
      Caption = '&Amministrazione'
      object Utenti1: TMenuItem
        Caption = 'Utenti'
        OnClick = Utenti1Click
      end
      object Pianodeiconti1: TMenuItem
        Caption = 'Piano dei &conti'
        OnClick = Pianodeiconti1Click
      end
      object Schemidibilancio1: TMenuItem
        Caption = '&Schemi di bilancio'
        OnClick = Schemidibilancio1Click
      end
      object Bilanci1: TMenuItem
        Caption = 'Bilanci'
        OnClick = Bilanci1Click
      end
      object Scritture1: TMenuItem
        Caption = 'Scritture'
        OnClick = Scritture1Click
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
