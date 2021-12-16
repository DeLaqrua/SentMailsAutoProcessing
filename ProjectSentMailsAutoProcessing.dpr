program ProjectSentMailsAutoProcessing;

uses
  Vcl.Forms,
  UnitSentMailsAutoProcessing in 'UnitSentMailsAutoProcessing.pas' {formMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
