{
This is part of Vortex Tracker II project

(c)2000-2009 S.V.Bulba
Author: Sergey Bulba, vorobey@mail.khstu.ru
Support page: http://bulba.untergrund.net/

Version 2.0 and later
(c)2017-2019 Ivan Pirog, ivan.pirog@gmail.com
}

program VT;

uses
  //FastMM4,
  Forms,
  Dialogs,
  Windows,
  Main in 'main.pas' {MainForm},
  Childwin in 'CHILDWIN.pas' {MDIChild},
  About in 'about.pas' {AboutBox},
  trfuncs in 'trfuncs.pas',
  AY in 'AY.pas',
  WaveOutAPI in 'WaveOutAPI.pas',
  options in 'options.pas' {Form1},
  TrkMng in 'TrkMng.pas' {TrMng},
  GlbTrn in 'GlbTrn.pas' {GlbTrans},
  ExportZX in 'ExportZX.pas' {ExpDlg},
  FXMImport in 'FXMImport.pas' {FXMParams},
  selectts in 'selectts.pas' {TSSel},
  TglSams in 'TglSams.pas' {ToglSams},
  HotKeys in 'HotKeys.pas',
  ColorThemes in 'ColorThemes.pas',
  ExportWav in 'ExportWav.pas' {Export},
  ExportWavOpts in 'ExportWavOpts.pas' {ExportOptions},
  InstrumentsPack in 'InstrumentsPack.pas',
  ntfs in 'ntfs.pas',
  ayumi in 'ayumi.pas',
  UnloopDlg in 'UnloopDlg.pas' {UnloopDlg},
  TrackInf in 'TrackInf.pas' {TrackInfoForm},
  Logger in 'Logger.pas',
  PatternPacker in 'PatternPacker.pas';

{$R *.RES}
{$R SNDH\SNDH.RES}
{$R ZXAYHOBETA\ZX.RES}
{$R Fonts\MonoFonts.RES}
{$R Samples\samples.RES}
{$R Ornaments\Ornaments.RES}
{$R Demosongs\Demosongs.RES}
{$R Icons\Icons.RES}

begin
  Application.Initialize;
  Application.Title := 'Vortex Tracker';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TTrMng, TrMng);
  Application.CreateForm(TGlbTrans, GlbTrans);
  Application.CreateForm(TExpDlg, ExpDlg);
  Application.CreateForm(TFXMParams, FXMParams);
  Application.CreateForm(TTSSel, TSSel);
  Application.CreateForm(TToglSams, ToglSams);
  Application.CreateForm(TExport, Export);
  Application.CreateForm(TExportOptions, ExportOptions);
  Application.CreateForm(TUnloopDlg, UnloopDialog);
  Application.CreateForm(TTrackInfoForm, TrackInfoForm);
  MainForm.CheckCommandLine;
  Application.Run;
end.
