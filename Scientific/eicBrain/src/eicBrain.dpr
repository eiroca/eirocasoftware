program eicBrain;

uses
  Forms,
  FMain in 'gui\FMain.pas' {fmMain},
  uEconomia in 'lib\uEconomia.pas',
  FValRec in 'gui\Economia\FValRec.pas' {fmValRec},
  FDepositoMinimo in 'gui\Economia\FDepositoMinimo.pas' {fmDepositoMinimo},
  FDepReg in 'gui\Economia\FDepReg.pas' {fmDepReg},
  FDeprezza in 'gui\Economia\FDeprezza.pas' {fmDeprezza},
  FDurPre in 'gui\Economia\FDurPre.pas' {fmDurPre},
  FIRR in 'gui\Economia\FIRR.pas' {fmIRR},
  FPagReg in 'gui\Economia\FPagReg.pas' {fmPagReg},
  FPreReg in 'gui\Economia\FPreReg.pas' {fmPreReg},
  FAnnuity in 'gui\Economia\FAnnuity.pas' {fmAnnuity},
  FScoTra in 'gui\Economia\FScoTra.pas' {fmScoTra},
  FSomPre in 'gui\Economia\FSomPre.pas' {fmSomPre},
  FTasRen in 'gui\Economia\FTasRen.pas' {fmTasRen},
  FTassoRendimento in 'gui\Economia\FTassoRendimento.pas' {fmTassoRendimento},
  FUltRat in 'gui\Economia\FUltRat.pas' {fmUltRat},
  FValDep in 'gui\Economia\FValDep.pas' {fmValDep},
  FValoreIniziale in 'gui\Economia\FValoreIniziale.pas' {fmValoreIniziale};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmValRec, fmValRec);
  Application.CreateForm(TfmDepositoMinimo, fmDepositoMinimo);
  Application.CreateForm(TfmDepReg, fmDepReg);
  Application.CreateForm(TfmDeprezza, fmDeprezza);
  Application.CreateForm(TfmDurPre, fmDurPre);
  Application.CreateForm(TfmIRR, fmIRR);
  Application.CreateForm(TfmPagReg, fmPagReg);
  Application.CreateForm(TfmPreReg, fmPreReg);
  Application.CreateForm(TfmAnnuity, fmAnnuity);
  Application.CreateForm(TfmScoTra, fmScoTra);
  Application.CreateForm(TfmSomPre, fmSomPre);
  Application.CreateForm(TfmTasRen, fmTasRen);
  Application.CreateForm(TfmTassoRendimento, fmTassoRendimento);
  Application.CreateForm(TfmUltRat, fmUltRat);
  Application.CreateForm(TfmValDep, fmValDep);
  Application.CreateForm(TfmValoreIniziale, fmValoreIniziale);
  Application.Run;
end.
