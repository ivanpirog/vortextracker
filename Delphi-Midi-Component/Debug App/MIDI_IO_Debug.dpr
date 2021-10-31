program MIDI_IO_Debug;

uses
  Forms,
  frmMain in 'frmMain.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'MIDI I/O Debugger';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
