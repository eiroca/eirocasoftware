object fmViewMutuo: TfmViewMutuo
  Left = 233
  Top = 157
  Caption = 'Mostra dati mutuo'
  ClientHeight = 178
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object dgDati: TRxDrawGrid
    Left = 0
    Top = 38
    Width = 450
    Height = 140
    Align = alBottom
    ColCount = 7
    DefaultColWidth = 80
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing]
    TabOrder = 0
    OnDrawCell = dgDatiDrawCell
    OnGetEditText = dgDatiGetEditText
    OnSetEditText = dgDatiSetEditText
    OnShowEditor = dgDatiShowEditor
    OnGetEditAlign = dgDatiGetEditAlign
    ColWidths = (
      54
      80
      80
      80
      80
      80
      80)
  end
end