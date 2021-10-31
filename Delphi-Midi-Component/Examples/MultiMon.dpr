{ $Header:   G:/delphi/midi/vcs/multimon.dpr   1.1   30 Apr 1996 19:05:38   DAVEC  $ }

{ Written by David Churcher <dchurcher@cix.compulink.co.uk>,
  released to the public domain. }

program Multimon;

uses
  Forms,
  Multimnp in 'MultiMNP.pas' {Form1};

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
