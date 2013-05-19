object fmHelp: TfmHelp
  Left = 143
  Top = 109
  BorderStyle = bsDialog
  Caption = 'x'
  ClientHeight = 268
  ClientWidth = 685
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object btOk: TBitBtn
    Left = 258
    Top = 230
    Width = 90
    Height = 30
    Caption = 'x'
    ModalResult = 1
    TabOrder = 0
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
    NumGlyphs = 2
  end
  object RichEdit1: TRichEdit
    Left = 8
    Top = 8
    Width = 665
    Height = 216
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'CONGRATULATIONS! '
      
        'You have been elected President of WinCorp. In this important jo' +
        'b, you'#39'll select'
      
        'a contract term for decision-making and then make a series of ma' +
        'nagement'
      'decisions each quarter:'
      ''
      'Payroll       -  $8(000) per employee per quarter'
      'Price         -  $9.95 to $29.95'
      'Advertising   -  $0 to $200(000)'
      
        'Production    -  Depends on the number of employees and their un' +
        'it productivity'
      'R&D           -  $0 to $200(000)'
      ''
      
        'WinCorp products are high-tech appliances found in class and off' +
        'ices. Although '
      
        'they have a low cost, they take expensive, skilled labor. If you' +
        ' pay less than '
      
        'the $8(000) PER EMPLOYEE per quarter, some employees will leave ' +
        'for other jobs. '
      
        'If you pay more, then new employees will join the company and be' +
        'gin producing in '
      'the following quarter.'
      ''
      
        'Each employee can initially produce 2(000) Trifles per quarter. ' +
        'However other '
      
        'industry factors such as technology advances, strikes, and damag' +
        'ed goods can '
      'affect manufacturing cost and productivity.'
      ''
      
        'When you start a new quarter, a variety of price, cost, advertis' +
        'ing, and R&D '
      
        'tables are automatically created. These tables are used with you' +
        'r decisions to '
      'produce the company performance results.'
      ''
      
        'For example: there are built-in advertising and pricing demand t' +
        'ables. The lower '
      
        'your price, the more you'#39'll sell. But be careful not to sell be ' +
        'low cost or '
      
        'you'#39'll lose money. And if you price above $29.95, you won'#39't sell' +
        ' a single '
      
        'Trifles. Similarly, your advertising expenditures affect the per' +
        'centage of your '
      'inventory that is sold each quarter.'
      ''
      
        'You can buy a special Executive Market Report to display the ind' +
        'ex tables for '
      
        'the current quarter. It costs $50(000) and the price rises by 25' +
        '% each quarter.'
      ''
      
        'Research and Development expense affects the unit cost impact cu' +
        'rve. If you '
      
        'spend more, your cost will go down. Spend less and the cost rise' +
        's. Your direct '
      'the unit cost (up or down) by up to 30% per quarter.'
      ''
      
        'There is also an inflation factor that affects the payroll expen' +
        'se between of 1% '
      
        'to 3% per quarter. If you don'#39't keep pace with inflation in your' +
        ' payroll then '
      'more employees will leave the company.'
      ''
      
        'Here'#39's an example of how the demand curves work using the Price ' +
        'Index:'
      ''
      'Price  Index    R&D Index    Price/Ad Mix'
      ' 9.95   100%      74  30%         60%  40%'
      '15.45    85%     118  15%'
      '18.20    70%     132   0%'
      '20.95    67%     145 -15%'
      '23.20    50%     162 -30%'
      '25.45    40%'
      '29.95     0%'
      ''
      
        'With this index, if you set the price at $18.20 to $20.94, you'#39'l' +
        'l sell 70% of '
      
        'the inventory that is affected by price. In addition, the Price/' +
        'Ad Index shows '
      
        'the relative influence of price and advertising for the quarter.' +
        ' In the quarter '
      
        'shown, pricing affects 60% of sales and advertising affects only' +
        ' 40%.'
      ''
      
        'With the R&D Index, if you spend $1 to $117(000) your unit cost ' +
        'will rise 30%. '
      
        'If you spend $145 to 161K, your unit manufacturing cost will be ' +
        'reduced by 15%.'
      ''
      
        'These indexes as well as an advertising index are shown when you' +
        ' purchase the '
      
        'special Market Report. The information can have a dramatic effec' +
        't on result'
      ''
      
        'You can also be affected by strikes if you have excessive profit' +
        's. When you have '
      
        'a strike, it costs 50% of the current quarter profits to settle ' +
        'it, plus double '
      'the normal inflation effect in salary increases.'
      ''
      
        'Trifles'#39' market has several advertising and pricing '#39'holes'#39' wher' +
        'e special '
      
        'promotions may sell out inventory at a relatively high price. Bu' +
        't you'#39'll have to '
      'experiment to find them.'
      ''
      
        'When you have entered your decisions for Payroll, Price, Adverti' +
        'sing, Research '
      
        'and Production, your results for the current quarter will be dis' +
        'played.'
      ''
      
        'Each quarter, your results will also be affected by FLASH news r' +
        'eports that can '
      
        'be windfall or setback with: major orders, fire, advertising awa' +
        'rds, etc.'
      ''
      
        'At the end of your term of office, you'#39'll receive a performance ' +
        'review by the '
      
        'Board of Directors based on your profitably, return on assets, a' +
        'nd employee '
      'management skills.'
      ''
      'Enjoy! And GOOD LUCK!')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
