{ $Header:   G:/delphi/midi/vcs/midimon.dpr   1.2   30 Apr 1996 19:05:38   DAVEC  $ }

{ Written by David Churcher <dchurcher@cix.compulink.co.uk>,
  released to the public domain. }

program Midimon;

uses
  Forms,
  Midimonp in 'MIDIMONP.PAS' {Form1},
  Monprocs in 'MONPROCS.PAS';

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
