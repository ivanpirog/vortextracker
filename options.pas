{
This is part of Vortex Tracker II project

(c)2000-2009 S.V.Bulba
Author: Sergey Bulba, vorobey@mail.khstu.ru
Support page: http://bulba.untergrund.net/

Version 2.0 and later
(c)2017-2018 Ivan Pirog, ivan.pirog@gmail.com
}

unit options;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, Menus, HotKeys,
  trfuncs, ColorThemes, HSL_ColorPickerDlgUnit, ColorPickerDlgUnit;

type

  TTrackBar = class(ComCtrls.TTrackbar)
  protected
    property OnMouseUp;
  end;

  TForm1 = class(TForm)
    OpsPages: TPageControl;
    Button1: TButton;
    Button2: TButton;
    AYEmu: TTabSheet;
    ChipSel: TRadioGroup;
    IntSel: TRadioGroup;
    CurWinds: TTabSheet;
    ChanVisAlloc: TRadioGroup;
    OpMod: TTabSheet;
    RadioGroup1: TRadioGroup;
    SaveHead: TRadioGroup;
    WOAPITAB: TTabSheet;
    SR: TRadioGroup;
    BR: TRadioGroup;
    NCh: TRadioGroup;
    Buff: TGroupBox;
    TrackBar1: TTrackBar;
    LbLen: TLabel;
    TrackBar2: TTrackBar;
    LbNum: TLabel;
    Label4: TLabel;
    LBTot: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    Opt: TRadioGroup;
    Label7: TLabel;
    LBChg: TLabel;
    ChFreq: TRadioGroup;
    SelDev: TGroupBox;
    Edit3: TEdit;
    Button4: TButton;
    ComboBox1: TComboBox;
    FiltersGroup: TGroupBox;
    FiltChk: TCheckBox;
    FiltNK: TTrackBar;
    Label9: TLabel;
    Label10: TLabel;
    PriorGrp: TRadioGroup;
    EdChipFrq: TEdit;
    EdIntFrq: TEdit;
    grp1: TGroupBox;
    DecNumbersLines: TCheckBox;
    chkHS: TCheckBox;
    midibtn1: TButton;
    midibtn2: TButton;
    midibtn3: TButton;
    HotKeys: TTabSheet;
    GroupBox2: TGroupBox;
    HotKeyList: TListView;
    GroupBox3: TGroupBox;
    ColorThemesList: TListBox;
    DecNumbersNoise: TCheckBox;
    Label15: TLabel;
    DefaultTable: TEdit;
    UpDown2: TUpDown;
    DisablePatSeparators: TCheckBox;
    AutoSaveBackups: TCheckBox;
    Label16: TLabel;
    BackupsMinsVal: TEdit;
    BackupEveryMins: TUpDown;
    Label17: TLabel;
    Label18: TLabel;
    FontsList: TListBox;
    FontSize: TEdit;
    FontSizeInt: TUpDown;
    FontBold: TSpeedButton;
    BtnLoadTheme: TButton;
    BtnSaveTheme: TButton;
    SaveThemeDialog: TSaveDialog;
    LoadThemeDialog: TOpenDialog;
    BtnDelTheme: TButton;
    ColorThemesTab: TTabSheet;
    PatEditorOpts: TGroupBox;
    BackupOpts: TGroupBox;
    GroupBox4: TGroupBox;
    TableBottom: TShape;
    ColBackground: TShape;
    LDefinition: TLabel;
    LCurrPat: TLabel;
    LNextPrevPat: TLabel;
    TableHeader: TShape;
    LBackgr: TLabel;
    BG1: TShape;
    BG2: TShape;
    LText: TLabel;
    BG3: TShape;
    ColText: TShape;
    BG4: TShape;
    BG5: TShape;
    BG6: TShape;
    LLineNumbs: TLabel;
    LEnvelope: TLabel;
    LNoise: TLabel;
    LNote: TLabel;
    BG7: TShape;
    BG8: TShape;
    BG9: TShape;
    LNoteParams: TLabel;
    LNoteCommands: TLabel;
    ColSelLineBackground: TShape;
    ColHighlBackground: TShape;
    ColHighlText: TShape;
    ColLineNum: TShape;
    ColEnvelope: TShape;
    ColNoise: TShape;
    ColNote: TShape;
    ColNoteParams: TShape;
    ColNoteCommands: TShape;
    ColOutBackground: TShape;
    ColOutText: TShape;
    ColOutHlBackground: TShape;
    LSeparators: TLabel;
    ColSeparators: TShape;
    Sep1: TShape;
    Sep2: TShape;
    Sep3: TShape;
    Sep4: TShape;
    Sep5: TShape;
    Sep6: TShape;
    ColOutSeparators: TShape;
    ColSelLineText: TShape;
    ColSelLineNum: TShape;
    ColSelEnvelope: TShape;
    ColSelNoise: TShape;
    ColSelNote: TShape;
    ColSelNoteParams: TShape;
    ColSelNoteCommands: TShape;
    BtnCloneTheme: TButton;
    BtnRenameTheme: TButton;
    Sep7: TShape;
    Sep8: TShape;
    LSampleOrnament: TLabel;
    ColSamOrnBackground: TShape;
    ColSamOrnText: TShape;
    ColSamOrnLineNum: TShape;
    ColSamNoise: TShape;
    ColSamOrnSeparators: TShape;
    BG10: TShape;
    LToneShift: TLabel;
    ColSamOrnTone: TShape;
    LFullScrBackground: TLabel;
    ColFullScreenBackground: TShape;
    Shape1: TShape;
    Sep12: TShape;
    ColSamOrnSelBackground: TShape;
    ColSamOrnSelText: TShape;
    ColSamSelNoise: TShape;
    ColSamOrnSelTone: TShape;
    ColSamOrnSelLineNum: TShape;
    GroupBox1: TGroupBox;
    PanoramBox: TGroupBox;
    APan: TTrackBar;
    BPan: TTrackBar;
    CPan: TTrackBar;
    APanLabel: TLabel;
    BPanLabel: TLabel;
    CPanLabel: TLabel;
    DisableHintsOpt: TCheckBox;
    StartupBox: TGroupBox;
    start1: TLabel;
    StartsAction: TComboBox;
    TemplPathLab: TLabel;
    TemplateSong: TEdit;
    BrowseTemplate: TButton;
    TemplateDialog: TOpenDialog;
    FileAssocBox: TGroupBox;
    FreqTableBox: TGroupBox;
    WinColorsBox: TComboBox;
    Shape2: TShape;
    Label2: TLabel;
    Shape3: TShape;
    TableName: TLabel;
    FileAssocList: TListView;
    AllFileAssoc: TButton;
    NoneFileAssoc: TButton;
    DisableCtrlClickOpt: TCheckBox;
    MIDIDeviceName: TEdit;
    APanValue: TEdit;
    BPanValue: TEdit;
    CPanValue: TEdit;
    ColHighlLineNum: TShape;
    AyumiDCFiltBox: TGroupBox;
    DCCutOffBar: TTrackBar;
    DCOff: TRadioButton;
    DCAyumi: TRadioButton;
    DCWbcbz7: TRadioButton;
    DCCutOffLab: TLabel;
    DisableInfoWinOpt: TCheckBox;
    Label1: TLabel;
    DecPositionsSize: TButton;
    IncPositionsSize: TButton;
    procedure StopAndStart;
    procedure ChipSelClick(Sender: TObject);
    procedure IntSelClick(Sender: TObject);
    procedure ChanVisAllocClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure SRClick(Sender: TObject);
    procedure BRClick(Sender: TObject);
    procedure NChClick(Sender: TObject);
    procedure OptClick(Sender: TObject);
    procedure ChFreqClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SaveHeadClick(Sender: TObject);
    procedure LockAudioOptions;
    procedure UnlockAudioOptions;
    procedure SetDCType;
    procedure UpdateAudioSettings;
    procedure FormShow(Sender: TObject);
    procedure FiltChkClick(Sender: TObject);
    procedure FiltNKChange(Sender: TObject);
    procedure PriorGrpClick(Sender: TObject);
    function GetValue(const s: string): integer;
    function GetValueF(s: string): Double;    
    procedure OnColorChange (Sender: TColorPickerDlg);
    procedure SelectColor(ColorBox: TShape; var ColorVar: TRGBColor; Tab: Integer);
    procedure DecNumbersLinesClick(Sender: TObject);
    procedure chkHSClick(Sender: TObject);
    procedure midibtn1Click(Sender: TObject);
    procedure midibtn2Click(Sender: TObject);
    procedure midibtn3Click(Sender: TObject);
    procedure midibtn4Click(Sender: TObject);
    procedure HotKeyListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HotKeyListKeyPress(Sender: TObject; var Key: Char);

    procedure ColorThemesListClick(Sender: TObject);
    procedure DecNumbersNoiseClick(Sender: TObject);
    procedure DisablePatSeparatorsClick(Sender: TObject);
    procedure AutoSaveBackupsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DefaultTableChange(Sender: TObject);
    procedure BackupsMinsValChange(Sender: TObject);
    procedure InitFileAssociations;
    procedure ApplyFileAssociations;
    procedure InitFonts;
    procedure ChangeFont;
    procedure FontsListClick(Sender: TObject);
    procedure FontSizeChange(Sender: TObject);
    procedure FontBoldClick(Sender: TObject);
    function CurrentThemeName : String;
    procedure BtnSaveThemeClick(Sender: TObject);
    procedure BtnLoadThemeClick(Sender: TObject);
    procedure BtnRenameThemeClick(Sender: TObject);
    procedure BtnDelThemeClick(Sender: TObject);
    procedure BtnCloneThemeClick(Sender: TObject);
    procedure RepaintChilds(WindowSizeChanged: Boolean);
    procedure ColBackgroundMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSelLineBackgroundMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColHighlBackgroundMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColOutBackgroundMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColOutHlBackgroundMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColTextMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColHighlTextMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColOutTextMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColLineNumMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColEnvelopeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColNoiseMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColNoteMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColNoteParamsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColNoteCommandsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSeparatorsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColOutSeparatorsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSelLineTextMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure ColSelLineNumMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColHighlLineNumMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSelEnvelopeMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSelNoiseMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColSelNoteMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColSelNoteParamsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSelNoteCommandsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSamOrnBackgroundMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSamOrnTextMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColSamOrnLineNumMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSamNoiseMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColSamOrnSeparatorsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSamOrnToneMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSamOrnSelBackgroundMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSamOrnSelTextMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSamOrnSelLineNumMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSamSelNoiseMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColSamOrnSelToneMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColFullScreenBackgroundMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure APanChange(Sender: TObject);
    procedure BPanChange(Sender: TObject);
    procedure CPanChange(Sender: TObject);
    procedure APanMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BPanMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CPanMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DisableHintsOptClick(Sender: TObject);
    procedure StartsActionChange(Sender: TObject);
    procedure BrowseTemplateClick(Sender: TObject);
    procedure WinColorsBoxChange(Sender: TObject);
    procedure AllFileAssocClick(Sender: TObject);
    procedure NoneFileAssocClick(Sender: TObject);
    procedure DisableCtrlClickOptClick(Sender: TObject);
    procedure FileAssocListClick(Sender: TObject);
    procedure APanValueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BPanValueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CPanValueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdIntFrqKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdIntFrqKeyPress(Sender: TObject; var Key: Char);
    procedure EdChipFrqKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdChipFrqKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DCOffMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DCAyumiMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DCWbcbz7MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DCCutOffBarChange(Sender: TObject);
    procedure DisableInfoWinOptMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DecPositionsSizeClick(Sender: TObject);
    procedure IncPositionsSizeClick(Sender: TObject);



  private
    procedure CMDialogKey( var msg: TCMDialogKey );
    message CM_DIALOGKEY;
    { Private declarations }
  public
    { Public declarations }
    FirstInit: Boolean;
    ClicksCounter, ClicksCounter1: Integer;
  end;


var
  Form1: TForm1;
  ColorDlg: THSL_ColorPickerDlg;
  CurColorBox: TShape;
  ColorVar: TRGBColor;
  CurColorVar: PRGBColor;


implementation

uses AY, WaveOutAPI, Main, MMSystem, CHILDWIN, CommCtrl;

{$R *.DFM}

// Disable Tab key for the Options Window
procedure TForm1.CMDialogKey(var msg: TCMDialogKey);
begin
  if msg.CharCode <> VK_TAB then
    inherited;
end;

procedure TForm1.StopAndStart;
begin
  if IsPlaying then
  begin
    ResetPlaying;
    PlayingWindow[1].RerollToLine(1);
    UnresetPlaying;
  end;
end;

function TForm1.GetValue(const s: string): integer;
var
  Er: integer;
begin
  Val(Trim(s), Result, Er);
  if Er <> 0 then Result := -1
end;

function TForm1.GetValueF(s: string): Double;
var Er: Integer;
begin
  s := StringReplace(s, ',', '.', [rfReplaceAll]);
  Val(Trim(s), Result, Er);
  if Er <> 0 then Result := -1
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ColorDlg := THSL_ColorPickerDlg.Create(Owner);
  APan.TickStyle := tsManual;
  APan.Min := 0;
  APan.Max := 255;
  SendMessage(APan.Handle, TBM_SETTIC, 0, 0);
  SendMessage(APan.Handle, TBM_SETTIC, 0, 64);
  SendMessage(APan.Handle, TBM_SETTIC, 0, 128);
  SendMessage(APan.Handle, TBM_SETTIC, 0, 192);
  SendMessage(APan.Handle, TBM_SETTIC, 0, 255);
  APan.OnMouseUp := APanMouseUp;

  BPan.TickStyle := tsManual;
  BPan.Min := 0;
  BPan.Max := 255;
  SendMessage(BPan.Handle, TBM_SETTIC, 0, 0);
  SendMessage(BPan.Handle, TBM_SETTIC, 0, 64);
  SendMessage(BPan.Handle, TBM_SETTIC, 0, 128);
  SendMessage(BPan.Handle, TBM_SETTIC, 0, 192);
  SendMessage(BPan.Handle, TBM_SETTIC, 0, 255);
  BPan.OnMouseUp := BPanMouseUp;

  CPan.TickStyle := tsManual;
  CPan.Min := 0;
  CPan.Max := 255;
  SendMessage(CPan.Handle, TBM_SETTIC, 0, 0);
  SendMessage(CPan.Handle, TBM_SETTIC, 0, 64);
  SendMessage(CPan.Handle, TBM_SETTIC, 0, 128);
  SendMessage(CPan.Handle, TBM_SETTIC, 0, 192);
  SendMessage(CPan.Handle, TBM_SETTIC, 0, 255);
  CPan.OnMouseUp := CPanMouseUp;
  FirstInit := True;

  AyumiDCFiltBox.Left := FiltersGroup.Left;
  AyumiDCFiltBox.Top  := FiltersGroup.Top;

  OpsPages.ActivePageIndex := 0;  
end;



procedure TForm1.ChipSelClick(Sender: TObject);
begin
  if Emulating_Chip = ChTypes(ChipSel.ItemIndex + 1) then Exit;

  MainForm.SetEmulatingChip(ChTypes(ChipSel.ItemIndex + 1));
  // Ayumi render
  if (RenderEngine = 2) and (AyumiChip1 <> nil) and (AyumiChip2 <> nil) then begin
    AyumiChip1.SetChipType(Emulating_Chip = YM_Chip);
    AyumiChip2.SetChipType(Emulating_Chip = YM_Chip);
  end
  else
    StopAndStart;
end;



procedure TForm1.IntSelClick(Sender: TObject);
var i, f: Integer;
begin
  case IntSel.ItemIndex of
    0: DefaultIntFreq := 48828;
    1: DefaultIntFreq := 50000;
    2: DefaultIntFreq := 60000;
    3: DefaultIntFreq := 100000;
    4: DefaultIntFreq := 200000;
    5: DefaultIntFreq := 48000;
    6:
      begin
        f := GetValue(EdIntFrq.Text);
        if f < 0 then exit;
        DefaultIntFreq := f * 1000;
      end;
  else exit
  end;

  if MainForm.MDIChildCount = 0 then Exit;

  Inc(ClicksCounter1);
  if ClicksCounter1 = 3 then begin
    ClicksCounter1 := 0;
    with TMDIChild(MainForm.ActiveMDIChild) do begin
      PageControl1.ActivePageIndex := 3;
      ManualHz.Left := TrackChipFreq.Buttons[20].Left + 95;
      ManualIntFreq.Left := TrackIntSel.Buttons[6].Left + 95;
      HelpShape1.Left := TrackIntSel.Left - 4;
      HelpShape1.Top := TrackIntSel.Top - 4;
      HelpShape1.Width := TrackIntSel.Left + TrackIntSel.Width;
      HelpShape1.Height := TrackIntSel.Height + 8;
      HelpShape1.Visible := True;
      for i := 1 to 17 do begin
        if i mod 2 = 0 then begin
          HelpShape1.Brush.Color := clBtnFace;
          HelpShape1.Pen.Color := clBtnFace;
        end
        else begin
          HelpShape1.Brush.Color := clRed;
          HelpShape1.Pen.Color := clRed;
        end;
        HelpShape1.Repaint;
        HelpShape1.Refresh;
        Sleep(80);
      end;
      HelpShape1.Visible := False;

    end;
  end;


end;

procedure TForm1.ChanVisAllocClick(Sender: TObject);
begin
  if ChanAllocIndex = ChanVisAlloc.ItemIndex then Exit;
  MainForm.RedrawOff;
  MainForm.SetChannelsAllocation(ChanVisAlloc.ItemIndex);
  APan.Position := Panoram[0];
  BPan.Position := Panoram[1];
  CPan.Position := Panoram[2];
  MainForm.RedrawOn;
  if RenderEngine = 2 then
    UpdatePanoram
  else if IsPlaying then
    PlayingWindow[1].StopAndRestart
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  FeaturesLevel := RadioGroup1.ItemIndex;
  DetectFeaturesLevel := FeaturesLevel > 2;
  if DetectFeaturesLevel then FeaturesLevel := 1;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  SetBuffers(TrackBar1.Position, NumberOfBuffers);
  LBLen.Caption := IntToStr(BufLen_ms) + ' ms';
  LBTot.Caption := IntToStr(BufLen_ms * NumberOfBuffers) + ' ms';
  LBChg.Caption := LBTot.Caption
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
  SetBuffers(BufLen_ms, TrackBar2.Position);
  LBNum.Caption := IntToStr(NumberOfBuffers);
  LBTot.Caption := IntToStr(BufLen_ms * NumberOfBuffers) + ' ms';
  LBChg.Caption := LBTot.Caption
end;

procedure TForm1.SRClick(Sender: TObject);
begin
  case SR.ItemIndex of
    0: SetSampleRate(11025);
    1: SetSampleRate(22050);
    2: SetSampleRate(44100);
    3: SetSampleRate(48000);
    4: SetSampleRate(88200);
    5: SetSampleRate(96000);
    6: if RenderEngine = 2 then SetSampleRate(192000);
  end;
end;

procedure TForm1.BRClick(Sender: TObject);
begin
  case BR.ItemIndex of
    0: SetBitRate(8);
    1: SetBitRate(16);
    2: if RenderEngine = 2 then SetBitRate(24);
    3: if RenderEngine = 2 then SetBitRate(32);
  end
end;

procedure TForm1.NChClick(Sender: TObject);
begin
  SetNChans(NCh.ItemIndex + 1)
end;


procedure TForm1.OptClick(Sender: TObject);
begin
  if Opt.ItemIndex = RenderEngine then Exit;
  UpdateAudioSettings;
  Set_Engine(Opt.ItemIndex);
end;

procedure TForm1.ChFreqClick(Sender: TObject);
var
  i, f: integer;
begin
  case ChFreq.ItemIndex of
    0:  f := 894887;
    1:  f := 831303;
    2:  f := 1773400;
    3:  f := 1750000;
    4:  f := 1000000;
    5:  f := 1500000;
    6:  f := 2000000;
    7:  f := 3500000;

    8:  f := 1520640;
    9:  f := 1611062;
    10:  f := 1706861;
    11: f := 1808356;
    12: f := 1915886;
    13: f := 2029811;
    14: f := 2150510;
    15: f := 2278386;
    16: f := 2413866;
    17: f := 2557401;
    18: f := 2709472;
    19: f := 2870586;
    20: f := 3041280;

    21:
      begin
        if not EdChipFrq.Focused and EdChipFrq.CanFocus then
        begin
          EdChipFrq.SelectAll;
        //  EdChipFrq.SetFocus;
        end;
        f := GetValue(EdChipFrq.Text);
        if f < 0 then exit
      end;
  else exit
  end;
  DefaultChipFreq := f;

  if MainForm.MDIChildCount = 0 then Exit;

  Inc(ClicksCounter);
  if ClicksCounter = 3 then begin
    ClicksCounter := 0;
    with TMDIChild(MainForm.ActiveMDIChild) do begin
      PageControl1.ActivePageIndex := 3;
      ManualHz.Left := TrackChipFreq.Buttons[20].Left + 95;
      ManualIntFreq.Left := TrackIntSel.Buttons[6].Left + 95;
      HelpShape1.Left := TrackChipFreq.Left - 4;
      HelpShape1.Top := TrackChipFreq.Top - 4;
      HelpShape1.Width := TrackChipFreq.Left + TrackChipFreq.Width;
      HelpShape1.Height := TrackChipFreq.Height + 8;
      HelpShape1.Visible := True;
      for i := 1 to 17 do begin
        if i mod 2 = 0 then begin
          HelpShape1.Brush.Color := clBtnFace;
          HelpShape1.Pen.Color := clBtnFace;
        end
        else begin
          HelpShape1.Brush.Color := clRed;
          HelpShape1.Pen.Color := clRed;
        end;
        HelpShape1.Repaint;
        HelpShape1.Refresh;
        Sleep(80);
      end;
      HelpShape1.Visible := False;

    end;
  end;

end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i, n: integer;
  WOC: WAVEOUTCAPS;
begin
  ComboBox1.Visible := False;
  n := waveOutGetNumDevs;
  if n = 0 then
  begin
    WODevice := WAVE_MAPPER;
    Edit3.Text := 'Wave mapper';
    exit
  end;
  ComboBox1.Clear;
  ComboBox1.Items.Add('Wave mapper');
  for i := 0 to n - 1 do
  begin
    WOCheck(waveOutGetDevCaps(i, @WOC, SizeOf(WOC)));
    ComboBox1.Items.Add(WOC.szPname)
  end;
  if Integer(WODevice) > n - 1 then WODevice := WAVE_MAPPER;
  ComboBox1.ItemIndex := Integer(WODevice) + 1;
  ComboBox1Change(Sender);
  ComboBox1.Visible := True
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  WODevice := ComboBox1.ItemIndex - 1;
  Edit3.Text := ComboBox1.Items[WODevice + 1]
end;

procedure TForm1.SaveHeadClick(Sender: TObject);
begin
  VortexModuleHeader := SaveHead.ItemIndex <> 1;
  DetectModuleHeader := SaveHead.ItemIndex = 2
end;

procedure TForm1.LockAudioOptions;
begin
  SR.Enabled := False;
  BR.Enabled := False;
  NCh.Enabled := False;
  Buff.Enabled := False;
  Label7.Visible := True;
  LBChg.Visible := True;
  SelDev.Enabled := False;
end;

procedure TForm1.UnlockAudioOptions;
begin
  SR.Enabled := True;
  BR.Enabled := True;
  NCh.Enabled := True;
  Buff.Enabled := True;
  Label7.Visible := False;
  LBChg.Visible := False;
  SelDev.Enabled := True;
end;

procedure TForm1.SetDCType;
begin
  DCOff.Checked    := False;
  DCAyumi.Checked  := False;
  DCWbcbz7.Checked := False;
  case DCType of
    0: DCOff.Checked    := True;
    1: DCAyumi.Checked  := True;
    2: DCWbcbz7.Checked := True;
  end;
end;

procedure TForm1.UpdateAudioSettings;
begin
  FiltChk.Enabled := Opt.ItemIndex = 0;
  FiltNK.Enabled := Opt.ItemIndex = 0;
  if IsPlaying then
    LockAudioOptions
  else begin
    UnlockAudioOptions;
    BR.Buttons[0].Enabled := Opt.ItemIndex <> 2;
    BR.Buttons[2].Enabled := Opt.ItemIndex = 2;
    BR.Buttons[3].Enabled := Opt.ItemIndex = 2;
    SR.Buttons[6].Enabled := Opt.ItemIndex = 2;
  end;

  SetDCType;


  // Ayumi Engine
  if Opt.ItemIndex = 2 then begin

    AyumiDCFiltBox.Visible := True;
    FiltersGroup.Visible   := False;
    DCCutOffLab.Visible    := DCWbcbz7.Checked;
    DCCutOffBar.Visible    := DCWbcbz7.Checked;

    if SampleBit = 8 then begin
      SetBitRate(16);
      BR.ItemIndex := 1;
    end;

  end;


  // VT Engine
  if (Opt.ItemIndex < 2) then begin

    AyumiDCFiltBox.Visible := False;
    FiltersGroup.Visible   := True;

    if SampleRate > 96000 then begin
      SetSampleRate(96000);
      SR.ItemIndex := 5;
    end;

    if SampleBit > 16 then begin
      SetBitRate(16);
      BR.ItemIndex := 1;
    end;

  end;

end;

procedure TForm1.FormShow(Sender: TObject);
var NewLeft, NewTop: Integer;
begin
  ClicksCounter  := 0;
  ClicksCounter1 := 0;
  
  OpsPages.SetFocus;
  MIDIDeviceName.Text := MainForm.midiin1.ProductName;
  DisableUpdateChilds := False;

  UpdateAudioSettings;

  if not FirstInit then Exit;

  // Calculate useful position for the Options Form.
  NewLeft := MainForm.Left + MainForm.Width - (Width div 2) + (Width div 6);
  NewTop  := MainForm.Top  + (MainForm.Height div 2) - (Height div 2);
  if MainForm.Height <= Height then
    NewTop := MainForm.Top;

  if NewTop < Monitor.WorkareaRect.Top then
    NewTop := 100;

  if NewLeft < Monitor.WorkareaRect.Left then
    NewLeft := 100;

  if NewLeft + Width > Monitor.WorkareaRect.Right then
    NewLeft := Monitor.WorkareaRect.Right - Width - (Width div 6);

  if NewTop + Height > Monitor.WorkareaRect.Bottom then
    NewTop := Monitor.WorkareaRect.Bottom - Height;

  Left := NewLeft;
  Top  := NewTop;

  FirstInit := False;
end;

procedure TForm1.FiltChkClick(Sender: TObject);
begin
  SetFilter(FiltChk.Checked, Filt_M)
end;

procedure TForm1.FiltNKChange(Sender: TObject);
begin
  SetFilter(IsFilt, round(exp(FiltNK.Position * Ln(2))))
end;


procedure TForm1.PriorGrpClick(Sender: TObject);
begin
  if PriorGrp.ItemIndex = 0 then
    MainForm.SetPriority(NORMAL_PRIORITY_CLASS)
  else
    MainForm.SetPriority(HIGH_PRIORITY_CLASS)
end;

procedure TForm1.OnColorChange (Sender: TColorPickerDlg);
begin
  CurColorBox.Brush.Color := Sender.ColorPick;
  CurColorVar^ := TColorToRGB(Sender.ColorPick);
  MainForm.PrepareColors;
  RepaintChilds(False);
end;

procedure TForm1.SelectColor(ColorBox: TShape; var ColorVar: TRGBColor; Tab: Integer);
begin
  MainForm.SetChildsTab(Tab);
  CurColorBox := ColorBox;
  CurColorVar := @ColorVar;

  ColorDlg.Caption := 'Select color';
  ColorDlg.Left := Form1.Left + 5;
  ColorDlg.Top  := Form1.Top + 5;
  ColorDlg.Position := poDesigned;
  ColorDlg.OnColorChange := OnColorChange;
  ColorDlg.ColorPick := ColorBox.Brush.Color;
  
  if ColorDlg.Execute then
    UpdateCurrentTheme;
end;


procedure TForm1.ColorThemesListClick(Sender: TObject);
var
  i : Integer;
  Theme: TColorTheme;
begin
  Theme := GetCurrentColorTheme;
  if ColorThemeName = Theme.Name then Exit; 

  ChildsEventsBlocked := True;
  MainForm.RedrawOff;

  for i := 0 to ColorThemesList.Count-1 do
    if ColorThemesList.Selected[i] then
    begin
      SetColorTheme(VTColorThemes[i]);
      SetupColorBars(Theme);
      Break;
    end;

  MainForm.RedrawOn;
  ChildsEventsBlocked := False;

end;


procedure TForm1.DecNumbersLinesClick(Sender: TObject);
begin
  DecBaseLinesOn := DecNumbersLines.Checked;
  if DecNumbersLines.Checked then
  begin
    TracksCursorXLeft := 4;
    OrnXShift := 1;
    OrnNChars := 10;
  end
  else
  begin
    TracksCursorXLeft := 3;
    OrnXShift := 0;
    OrnNChars := 9;
  end;
  MainForm.UpdateDecHexValues;
  if not DisableUpdateChilds then
    RepaintChilds(True);
end;

procedure TForm1.DecNumbersNoiseClick(Sender: TObject);
begin
  DecBaseNoiseOn := DecNumbersNoise.Checked;
  if not DisableUpdateChilds then
    RepaintChilds(False);
end;


procedure TForm1.chkHSClick(Sender: TObject);
begin
  HighlightSpeedOn := chkHS.Checked;
  if not DisableUpdateChilds then
    RepaintChilds(False);
end;

procedure TForm1.midibtn1Click(Sender: TObject);
begin
  if MainForm.midiin1.DeviceID < MainForm.midiin1.DeviceCount-1 then
  begin
    try
      MainForm.midiin1.ChangeDevice(MainForm.midiin1.DeviceID + 1);
      MIDIDeviceName.Text := MainForm.midiin1.ProductName;
    except
      MainForm.midiin1.Close;
      MIDIDeviceName.Text := '(none)';
    end;
  end;
end;

procedure TForm1.midibtn2Click(Sender: TObject);
begin
  if MainForm.midiin1.DeviceID > 0 then
  begin
    try
      MainForm.midiin1.ChangeDevice(MainForm.midiin1.DeviceID - 1);
      MIDIDeviceName.Text := MainForm.midiin1.ProductName;
    except
      MainForm.midiin1.Close;
      MIDIDeviceName.Text := '(none)';
    end;
  end;
end;

procedure TForm1.midibtn3Click(Sender: TObject);
begin

 { if AnsiContainsText(midibtn3.Caption, 'Stop') then

  // STOP MIDI
  begin
    try
      MainForm.midiin1.StopAndClose;
    finally
      midibtn3.Caption := 'Start MIDI';
    end;
  end

  else

  // START MIDI
  begin
    try
      MainForm.midiin1.OpenAndStart;
    finally
      midibtn3.Caption := 'Stop MIDI';
    end;
  end; }

end;

procedure TForm1.midibtn4Click(Sender: TObject);
begin
  if MainForm.midiin1.DeviceCount > 0 then
  begin
    try
      MainForm.midiin1.OpenAndStart;
    except
      Application.MessageBox('Sorry, MIDI keyboard is busy or... something else happened :)',
        'Vortex Tracker II', MB_OK + MB_ICONWARNING + MB_TOPMOST);
    end;
  end;
end;



procedure TForm1.HotKeyListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ShortCutText : string;
begin
  // If hotkey is not selected - exit
  if HotKeyList.Selected = nil then Exit;

  // If user pressed only Ctrl, Alt, Shift without key - exit
  if Key in [16..18] then Exit;

  // If user pressed up/down keys - exit
  if Key in [38,40] then Exit;

  // If user press left/right without Ctrl or Alt
  if (Key in [37,39]) and not (ssAlt in Shift) and not (ssCtrl in Shift) then Exit;

  // Get text of pressed shortcut
  ShortCutText := ShortCutToText(ShortCut(Key, Shift));

  // If user pressed only A..Z - 0..9 - exit
  if Length(ShortCutText) = 1 then
  begin
   ShowMessage('Can''t assing the "'+ Chr(Key) +'" key.');
   Exit;
  end;

  ReAssignHotKey(HotKeyList.Selected.Index, ShortCutText);

  Shift := [];
  Key := 0;
end;

procedure TForm1.HotKeyListKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;



procedure TForm1.DisablePatSeparatorsClick(Sender: TObject);
begin
  if DisableSeparators = DisablePatSeparators.Checked then Exit;
  DisableSeparators := DisablePatSeparators.Checked;
  if not DisableUpdateChilds then
    RepaintChilds(True);
end;

procedure TForm1.AutoSaveBackupsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  BackupsMinsVal.Enabled   := AutoSaveBackups.Checked;
  BackupEveryMins.Enabled  := AutoSaveBackups.Checked;
  AutoBackupsOn   := AutoSaveBackups.Checked;
  AutoBackupsMins := BackupEveryMins.Position;
  MainForm.ChangeBackupTimer;
end;

procedure TForm1.DefaultTableChange(Sender: TObject);
begin
  MainForm.DefaultTable := UpDown2.Position;
  TableName.Caption := TableNames[UpDown2.Position];
end;

procedure TForm1.BackupsMinsValChange(Sender: TObject);
begin
  if AutoBackupsMins = BackupEveryMins.Position then Exit;
  AutoBackupsMins := BackupEveryMins.Position;
  MainForm.ChangeBackupTimer;
end;


procedure TForm1.InitFileAssociations;
var
  I: Integer;
  ListItem: TListItem;

begin

  with FileAssocList do
  begin
    Clear;
    for I := Low(FileAssociations) to High(FileAssociations) do
    begin
      ListItem := Items.Add;
      ListItem.Caption := FileAssociations[I][1];
      ListItem.SubItems.Add(FileAssociations[I][3]);
      ListItem.Checked := FileAssociations[I][0] = '1';
    end;
  end;


end;


procedure TForm1.ApplyFileAssociations;
var i: Integer;
begin
  for i := 0 to FileAssocList.Items.Count-1 do
    if FileAssocList.Items[i].Checked then
      FileAssociations[i][0] := '1'
    else
      FileAssociations[i][0] := '0';
  MainForm.SetFileAssociations;
end;



procedure TForm1.InitFonts;
const
  FontsBlackList: Array[0..4] of String =
    ('Courier', 'Default', 'Fixedsys', 'Terminal', 'Arrows');

var
  i: Integer;
  FontValid: Boolean;
  Fnt: String;

  function EnumFontsProc(var elf: TEnumLogFont; var tm: TNewTextMetric;
                       FontType: Integer; Data: LPARAM): Integer; stdcall;
  begin
    Result := Integer(FIXED_PITCH = (elf.elfLogFont.lfPitchAndFamily and FIXED_PITCH));
  end;

begin

  FontsList.Clear;

  // Add internal fonts
  for i := 0 to High(InternalFonts) do
  begin
    Fnt := InternalFonts[i][1];
    if (FontsList.Items.IndexOf(Fnt) = -1) and (AnsiIndexText(Fnt, FontsBlackList) = -1) and MainForm.IsFontValid(Fnt) then
      FontsList.Items.Append(Fnt);
  end;

  // Get only monospaced fonts
  for i := 0 to Screen.Fonts.Count - 1 do
  begin
    Fnt := Screen.Fonts[i];
    FontValid := EnumFontFamilies(Canvas.Handle, PChar(Fnt), @EnumFontsProc, 0) and
                (AnsiIndexText(Fnt, FontsBlackList) = -1) and
                (FontsList.Items.IndexOf(Fnt) = -1) and
                MainForm.IsFontValid(Fnt);
                
    if FontValid then
      FontsList.Items.Append(Fnt);
  end;

  for i := 0 to FontsList.Count - 1 do
    if FontsList.Items[i] = MainForm.EditorFont.Name then
      FontsList.Selected[i] := True;

  FontBold.Down := [fsBold] = MainForm.EditorFont.Style;
  FontSizeInt.Position := MainForm.EditorFont.Size;

end;


procedure TForm1.ChangeFont;
var
  i: Integer;
  CantChange: Boolean;
begin

  for i := 0 to FontsList.Count - 1 do
    if FontsList.Selected[i] then
    begin

      CantChange := (MainForm.EditorFont.Name = FontsList.Items[i])   and
                    (MainForm.EditorFont.Size = FontSizeInt.Position) and
                    (
                      (FontBold.Down and (MainForm.EditorFont.Style = [fsBold]))
                      or
                      (not FontBold.Down and (MainForm.EditorFont.Style = []))
                    );

      if CantChange then Break;

      MainForm.EditorFont.Name  := FontsList.Items[i];
      MainForm.EditorFont.Size  := FontSizeInt.Position;
      EditorFontChanged := True;
      if FontBold.Down then
        MainForm.EditorFont.Style := [fsBold]
      else
        MainForm.EditorFont.Style := [];
      if DisableUpdateChilds then
        Exit;
      RepaintChilds(True);
      Exit;
    end;

end;


procedure TForm1.FontsListClick(Sender: TObject);
begin
  ChangeFont;
end;

procedure TForm1.FontSizeChange(Sender: TObject);
var NewValue: Integer;
begin
  NewValue := GetValue(FontSize.Text);
  if (NewValue = -1) or (NewValue < 12) or (NewValue > 30) then Exit;
  ChangeFont;
end;

procedure TForm1.FontBoldClick(Sender: TObject);
begin
  ChangeFont;
end;

function TForm1.CurrentThemeName : String;
var i: Integer;
begin
  Result := 'VT Theme';
  for i := 0 to ColorThemesList.Count - 1 do
    if ColorThemesList.Selected[i] then
    begin
      Result := ColorThemesList.Items[i];
      break;
    end;
end;

procedure TForm1.BtnSaveThemeClick(Sender: TObject);
begin
  {repeat
    NewName := InputBox('Vortex Tracker II', 'Enter theme name', NewName) then
  until ValidColorThemeName(NewName);}
  SaveThemeDialog.Title := 'Save Color Theme';
  SaveThemeDialog.DefaultExt := 'vtt';
  SaveThemeDialog.FileName := SelectedThemeName;
  if SaveThemeDialog.Execute then
  begin
    SaveThemeDialog.InitialDir := ExtractFilePath(SaveThemeDialog.FileName);
    SaveColorTheme(SaveThemeDialog.FileName, SelectedThemeName);
  end;
end;

procedure TForm1.BtnLoadThemeClick(Sender: TObject);
begin
  LoadThemeDialog.Title := 'Load Color Theme';
  LoadThemeDialog.DefaultExt := 'vtt';
  if LoadThemeDialog.Execute then
  begin
    LoadThemeDialog.InitialDir := ExtractFilePath(LoadThemeDialog.FileName);
    LoadColorTheme(LoadThemeDialog.FileName);
  end;
end;

procedure TForm1.BtnRenameThemeClick(Sender: TObject);
begin
  RenameSelectedTheme;
end;

procedure TForm1.BtnDelThemeClick(Sender: TObject);
begin
  DeleteSelectedTheme;
end;

procedure TForm1.BtnCloneThemeClick(Sender: TObject);
begin
  CloneColorTheme;
end;

procedure TForm1.RepaintChilds(WindowSizeChanged: Boolean);
var
  NewSize: TSize;
begin

  with MainForm do
  begin
    RedrawOff;
    ChildsEventsBlocked := True;

    if WindowSizeChanged then
    begin
      RedrawChilds;
      AutoMetrixForChilds(WindowState);
      SetChildsPosition(WindowState);
      NewSize := GetSizeForChilds(WindowState, False);
      AutoCutChilds(NewSize);
      SetWindowSize(NewSize);
      AutoToolBarPosition(NewSize);
    end
    else
      RedrawChilds;

    ChildsEventsBlocked  := False;
    NumberOfLinesChanged := False;
    EditorFontChanged    := False;
    RedrawOn;
  end;

end;


procedure TForm1.ColBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColBackground, ColorTheme.Background, 1);
end;

procedure TForm1.ColSelLineBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSelLineBackground, ColorTheme.SelLineBackground, 1);
end;

procedure TForm1.ColHighlBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColHighlBackground, ColorTheme.HighlBackground, 1);
end;

procedure TForm1.ColOutBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColOutBackground, ColorTheme.OutBackground, 1);
end;

procedure TForm1.ColOutHlBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColOutHlBackground, ColorTheme.OutHlBackground, 1);
end;

procedure TForm1.ColTextMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColText, ColorTheme.Text, 1);
end;

procedure TForm1.ColHighlTextMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColHighlText, ColorTheme.HighlText, 1);
end;

procedure TForm1.ColOutTextMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColOutText, ColorTheme.OutText, 1);
end;

procedure TForm1.ColLineNumMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColLineNum, ColorTheme.LineNum, 1);
end;

procedure TForm1.ColEnvelopeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColEnvelope, ColorTheme.Envelope, 1);
end;

procedure TForm1.ColNoiseMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColNoise, ColorTheme.Noise, 1);
end;

procedure TForm1.ColNoteMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColNote, ColorTheme.Note, 1);
end;

procedure TForm1.ColNoteParamsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColNoteParams, ColorTheme.NoteParams, 1);
end;

procedure TForm1.ColNoteCommandsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColNoteCommands, ColorTheme.NoteCommands, 1);
end;

procedure TForm1.ColSeparatorsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSeparators, ColorTheme.Separators, 1);
end;

procedure TForm1.ColOutSeparatorsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColOutSeparators, ColorTheme.OutSeparators, 1);
end;

procedure TForm1.ColSelLineTextMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSelLineText, ColorTheme.SelLineText, 1);
end;


procedure TForm1.ColSelLineNumMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSelLineNum, ColorTheme.SelLineNum, 1);
end;

procedure TForm1.ColHighlLineNumMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColHighlLineNum, ColorTheme.HighlLineNum, 1);
end;

procedure TForm1.ColSelEnvelopeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSelEnvelope, ColorTheme.SelEnvelope, 1);
end;

procedure TForm1.ColSelNoiseMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSelNoise, ColorTheme.SelNoise, 1);
end;

procedure TForm1.ColSelNoteMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSelNote, ColorTheme.SelNote, 1);
end;

procedure TForm1.ColSelNoteParamsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSelNoteParams, ColorTheme.SelNoteParams, 1);
end;

procedure TForm1.ColSelNoteCommandsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSelNoteCommands, ColorTheme.SelNoteCommands, 1);
end;

procedure TForm1.ColSamOrnBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSamOrnBackground, ColorTheme.SamOrnBackground, 2);
end;

procedure TForm1.ColSamOrnTextMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSamOrnText, ColorTheme.SamOrnText, 2);
end;

procedure TForm1.ColSamOrnLineNumMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSamOrnLineNum, ColorTheme.SamOrnLineNum, 2);
end;

procedure TForm1.ColSamNoiseMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSamNoise, ColorTheme.SamNoise, 2);
end;

procedure TForm1.ColSamOrnSeparatorsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSamOrnSeparators, ColorTheme.SamOrnSeparators, 2);
end;

procedure TForm1.ColSamOrnToneMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSamOrnTone, ColorTheme.SamOrnTone, 2);
end;

procedure TForm1.ColSamOrnSelBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSamOrnSelBackground, ColorTheme.SamOrnSelBackground, 2);
end;

procedure TForm1.ColSamOrnSelTextMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSamOrnSelText, ColorTheme.SamOrnSelText, 2);
end;

procedure TForm1.ColSamOrnSelLineNumMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSamOrnSelLineNum, ColorTheme.SamOrnSelLineNum, 2);
end;

procedure TForm1.ColSamSelNoiseMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSamSelNoise, ColorTheme.SamSelNoise, 2);
end;

procedure TForm1.ColSamOrnSelToneMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColSamOrnSelTone, ColorTheme.SamOrnSelTone, 2);
end;

procedure TForm1.ColFullScreenBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectColor(ColFullScreenBackground, ColorTheme.FullScreenBackground, 1);
end;


procedure TForm1.APanChange(Sender: TObject);
begin
  APanValue.Text := IntToStr(APan.Position);
  if Panoram[0] = APan.Position then Exit;
  Index_AL := 255 - APan.Position;
  Index_AR := APan.Position;
  Panoram[0] := APan.Position;
  if RenderEngine = 2 then
    UpdatePanoram;
end;

procedure TForm1.BPanChange(Sender: TObject);
begin
  BPanValue.Text := IntToStr(BPan.Position);
  if Panoram[1] = BPan.Position then Exit;
  Index_BL := 255 - BPan.Position;
  Index_BR := BPan.Position;
  Panoram[1] := BPan.Position;
  if RenderEngine = 2 then
    UpdatePanoram;
end;

procedure TForm1.CPanChange(Sender: TObject);
begin
  CPanValue.Text := IntToStr(CPan.Position);
  if Panoram[2] = CPan.Position then Exit;
  Index_CL := 255 - CPan.Position;
  Index_CR := CPan.Position;
  Panoram[2] := CPan.Position;
  if RenderEngine = 2 then
    UpdatePanoram;
end;


procedure TForm1.APanMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if RenderEngine <> 2 then UpdatePanoram;
end;

procedure TForm1.BPanMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if RenderEngine <> 2 then UpdatePanoram;
end;

procedure TForm1.CPanMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if RenderEngine <> 2 then UpdatePanoram;
end;

procedure TForm1.DisableHintsOptClick(Sender: TObject);
begin
  DisableHints := DisableHintsOpt.Checked;
end;

procedure TForm1.StartsActionChange(Sender: TObject);
begin
  MainForm.StartupAction := StartsAction.ItemIndex;
end;

procedure TForm1.BrowseTemplateClick(Sender: TObject);
begin
  TemplateDialog.Title := 'Startup Template Song';
  TemplateDialog.DefaultExt := 'vt2';

  if DirectoryExists(ExtractFileDir(TemplateSong.Text)) then
    TemplateDialog.InitialDir := ExtractFileDir(TemplateSong.Text);

  if TemplateDialog.Execute then
  begin
    TemplateDialog.InitialDir := ExtractFilePath(TemplateDialog.FileName);
    TemplateSong.Text := TemplateDialog.FileName;
    MainForm.TemplateSongPath :=TemplateDialog.FileName;
  end;
end;


procedure TForm1.WinColorsBoxChange(Sender: TObject);
begin
  MainForm.WinThemeIndex := WinColorsBox.ItemIndex;
  SetWindowColors(WinColorsBox.ItemIndex);
  MainForm.TrackBar1.SliderVisible := False;
  MainForm.TrackBar1.SliderVisible := True;
end;

procedure TForm1.AllFileAssocClick(Sender: TObject);
var i: Integer;
begin

  for i := 0 to FileAssocList.Items.Count-1 do
    FileAssocList.Items[i].Checked := True;

end;

procedure TForm1.NoneFileAssocClick(Sender: TObject);
var i: Integer;
begin

  for i := 0 to FileAssocList.Items.Count-1 do
    FileAssocList.Items[i].Checked := False;

end;

procedure TForm1.DisableCtrlClickOptClick(Sender: TObject);
begin
  DisableCtrlClick := DisableCtrlClickOpt.Checked;
end;

procedure TForm1.FileAssocListClick(Sender: TObject);
begin
  FileAssocChanged := True;
end;

procedure TForm1.APanValueKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i: Integer;
begin
  i := GetValue(APanValue.Text);
  if i < 0 then Exit;
  APan.Position := i;
end;

procedure TForm1.BPanValueKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i: Integer;
begin
  i := GetValue(BPanValue.Text);
  if i < 0 then Exit;
  BPan.Position := i;
end;

procedure TForm1.CPanValueKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i: Integer;
begin
  i := GetValue(CPanValue.Text);
  if i < 0 then Exit;
  CPan.Position := i;
end;

procedure TForm1.EdIntFrqKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  PrevValue: String = '';
var
  NewValue, f: Double;
  Wrong: Boolean;
begin
  if IntSel.ItemIndex <> 6 then IntSel.ItemIndex := 6;

  NewValue := GetValueF(EdIntFrq.Text);
  if NewValue < 0 then Exit;

  if (PrevValue = '') and (Length(EdIntFrq.Text) > 1) then begin
    f := DefaultIntFreq / 1000;
    PrevValue := FloatToStr(f);
  end;

  f := Frac(StrToFloat(EdIntFrq.Text));
  Wrong := Length(FloatToStr(f)) > 5;
  NewValue := NewValue * 1000;
  Wrong := Wrong or ((NewValue < 1000) or (NewValue > 2000000));

  if Wrong then begin
    EdIntFrq.Text := PrevValue;
    EdIntFrq.SelStart := Length(PrevValue);
    Exit;
  end;

  PrevValue := EdIntFrq.Text;
  DefaultIntFreq := round(NewValue);
end;

procedure TForm1.EdIntFrqKeyPress(Sender: TObject; var Key: Char);
var Wrong: Boolean;
begin
  Wrong := not (Key in ['0'..'9','.',',']) and (Key <> #8);
  Wrong := Wrong or ( AnsiContainsText(EdIntFrq.Text, ',') and (Key in ['.', ',']) );
  Wrong := Wrong or ( (EdIntFrq.Text = '') and (Key in ['.', ',']) );

  if Wrong then begin
    Key := #0;
    Exit;
  end;

  if Key = '.' then begin
    Key := ',';
    Exit;
  end;
end;

procedure TForm1.EdChipFrqKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var NewValue: Integer;
begin
  if ChFreq.ItemIndex <> 21 then
    ChFreq.ItemIndex := 21;

  NewValue := GetValue(EdChipFrq.Text);
  if (NewValue < 0) or (NewValue < 700000) or (NewValue > 3546800) then exit;

  ManualChipFreq := NewValue;
end;


procedure TForm1.EdChipFrqKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9']) and (Key <> #8) then begin
    Key := #0;
    Exit;
  end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 27) and (OpsPages.ActivePage <> HotKeys) then
    Button2.Click;  
end;



procedure TForm1.DCOffMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DCType := 0;
  UpdateAudioSettings;
  if (AyumiChip1 = nil) and (AyumiChip2 = nil) then Exit;
  AyumiChip1.SetDCType(DCType);
  AyumiChip2.SetDCType(DCType);
end;

procedure TForm1.DCAyumiMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DCType := 1;
  UpdateAudioSettings;
  if (AyumiChip1 = nil) and (AyumiChip2 = nil) then Exit;
  AyumiChip1.SetDCType(DCType);
  AyumiChip2.SetDCType(DCType);
end;

procedure TForm1.DCWbcbz7MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DCType := 2;
  UpdateAudioSettings;
  if (AyumiChip1 = nil) and (AyumiChip2 = nil) then Exit;
  AyumiChip1.SetDCType(DCType);
  AyumiChip2.SetDCType(DCType);
end;

procedure TForm1.DCCutOffBarChange(Sender: TObject);
begin
  DCCutOff := DCCutOffBar.Position;
  if (AyumiChip1 = nil) and (AyumiChip2 = nil) then Exit; 
  AyumiChip1.SetDCCutoff(DCCutOff);
  AyumiChip2.SetDCCutoff(DCCutOff);
end;

procedure TForm1.DisableInfoWinOptMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DisableInfoWin := DisableInfoWinOpt.Checked;
end;

procedure TForm1.DecPositionsSizeClick(Sender: TObject);
begin
  if PositionSize = 0 then Exit;
  MainForm.SetChildsTab(1);
  EditorFontChanged := True;
  Dec(PositionSize);
  RepaintChilds(True);
end;

procedure TForm1.IncPositionsSizeClick(Sender: TObject);
begin
  if PositionSize = 5 then Exit;
  MainForm.SetChildsTab(1);
  EditorFontChanged := True;
  Inc(PositionSize);
  RepaintChilds(True);
end;

end.
