program Bioritmi2007;

uses
  Forms,
  uBioritmi in 'lib\uBioritmi.pas',
  FMain in 'gui\FMain.pas' {fmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
