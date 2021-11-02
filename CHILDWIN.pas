{
This is part of Vortex Tracker II project

(c)2000-2009 S.V.Bulba
Author: Sergey Bulba, vorobey@mail.khstu.ru
Support page: http://bulba.untergrund.net/

(c)2017-2019 Version 2.0 and later
Ivan Pirog (Flexx/Enhancers), ivan.pirog@gmail.com
}

{.$DEFINE DEBUG}

unit Childwin;

interface

uses
  Windows, Messages, Types, Classes, Graphics, Forms, Controls, StdCtrls, Menus,
  SysUtils, trfuncs, ComCtrls, WaveOutAPI, Grids, AY, Buttons, ExtCtrls, Dialogs,
  Math, ColorThemes, ExportWavOpts, StrUtils, RegExpr, RichEdit, ShellApi;


const
  POS_MOVE   = 1;
  POS_COPY   = 2;
  POS_DELETE = 3;

type
  
  TScrollBox = class(Forms.TScrollBox)
    protected
      procedure AutoScrollInView(AControl:TControl); override;
  end;


  TRichEdit = class(ComCtrls.TRichEdit)
  private
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
  protected
    procedure CreateWnd; override;
  end;

  
  TChannelState = record
    Muted: Boolean;
  end;

  PDriveSelect = ^TDriveSelect;
  TFileBrowser = class(TListBox)
  public
    CurrentDir: String;
    FileExt: String;
    FilePath: TStringList;
    DirPath: TStringList;
    ParentWin: TForm;
    PreviewPlaying: Boolean;
    DriveSelectBox: PDriveSelect;
    DontOpenItem: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function  GetSelectedIndex: Integer;
    function  GetSelectedFileName: String;
    function  GetSelectedFullPath: String;
    function  InHomeDir: Boolean;
    function  InDir(DirPath: String): Boolean;
    function  GetIndex(Value: String): Integer;
    function  PathNotFound(FullPath: String; IsFile: Boolean): Boolean;
    procedure GetDriveLetters(AList: TStrings);
    procedure InitDir;
    procedure ReadDir;
    procedure MyDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure OpenItem(Key: Byte; Preview: Boolean=False);
    procedure MyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MyClick(Sender: TObject);
    procedure MyDblClick(Sender: TObject);
    procedure MyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MyMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
  end;


  TDriveSelect = class(TComboBox)
    public
      FileBrowser: TFileBrowser;
      constructor Create(AOwner: TComponent); override;
      procedure FillDiskDrives;
      procedure MyOnChange(Sender: TObject);
      procedure MyDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
                           State: TOwnerDrawState);
  end;

  TTracks = class(TWinControl)
  public
    fBitmap: TBitmap;
    CelW, CelH: Integer;
    CursorX, CursorY, SelX, SelY: Integer;
    ShownFrom, NOfLines, N1OfLines: Integer;
    ReturnAfterPlay: Boolean;
    ReturnCursorY, ReturnShownFrom, ReturnPosition: Integer;
    HLStep: Integer;
    ShownPattern: PPattern;
    BigCaret: Boolean;
    KeyPressed: Integer;
    Clicked: Boolean;
    CurrentMidiNote: Integer;
    LastNoteParams: TLastNoteParams;
    CaretVisible: Boolean;
    ParentWin: TForm;
    Sep1X, Sep2X, Sep3X, Sep4X, Sep5X, Shift: Smallint;
    PatNumChars, PatWidth: Smallint;
    ChannelState: array[0..2] of TChannelState;
    RedrawDisabled: Boolean;
    ManualBitBlt: Boolean;
    ShowSel: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DefaultHandler(var Message); override;
    procedure FitNumberOfLines;
    function CurrentPatLine: Integer;
    function CurrentChannel: Integer;
    function IsTrackPlaying: Boolean;
    function IsSelected: Boolean;
    procedure ShowSelection;
    procedure DrawSelection;
    procedure RemoveSelection;
    procedure ResetLastNoteParams(Pat, Line, Chan: byte);
    procedure RemSel;
    procedure JumpToPatStart(Shift: TShiftState);
    procedure JumpToPatEnd(Shift: TShiftState);
    procedure JumpToLineStart(Shift: TShiftState);
    procedure JumpToLineEnd(Shift: TShiftState);
    procedure SelectAll;
    procedure InitMetrix;
    procedure RedrawTracks(DC: HDC);
    procedure DoBitBlt;
    procedure Refresh;
    procedure CreateMyCaret;
    procedure RecreateCaret;
    procedure SetCaretPosition;
    procedure ShowMyCaret;
    procedure HideMyCaret;
    procedure CopyToClipboard;
    procedure CutToClipboard;
    procedure PasteFromClipboard(Merge: Boolean);
    procedure ClearSelection;
    procedure DoHint;
    private
      procedure WMEraseBkGnd(var Message:TMessage); message WM_ERASEBKGND;
      procedure WMSysChar(var Message: TWMSysChar); message WM_SYSCHAR;
  end;

  TTestLine = class(TWinControl)
  public
    CelW, CelH: Integer;
    CursorX: Integer;
    BigCaret: Boolean;
    KeyPressed: Integer;
    TestOct: Integer;
    TestSample: Boolean;
    ParWind: TForm;
    CurrentMidiNote: Integer;
    NoteCounter: Integer;
    Preview: Boolean;
    Arp: array[0..96] of Integer;
    constructor Create(AOwner: TComponent); override;
    procedure DefaultHandler(var Message); override;
    procedure RedrawTestLine(DC: HDC);
    procedure SetCaretPosition;
    procedure RecreateCaret;
    procedure CreateMyCaret;
    procedure OpenSample;
    procedure OpenOrnament;
    procedure TestLineMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TestLineMidiOn(note: Integer);
    procedure TestLineMidiOff(note: Integer);
    procedure PlayCurrentNote;
    procedure TestLineKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TestLineKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TestLineExit(Sender: TObject);
    private
      procedure WMSysChar(var Message: TWMSysChar); message WM_SYSCHAR;
  end;

  TSamples = class(TWinControl)
  public
    fBitmap: TBitmap;
    ArrowsFont: TFont;
    ArrowsFontW, ArrowsFontH: Integer;
    InputSNumber, CelW, CelH: Integer;
    CursorX, CursorY {,SelW,SelH}: Integer;
    ShownFrom, NOfLines: Integer;
    ShownSample: PSample;
    BigCaret: Integer;
    ToneShiftAsNote: Boolean;
    CaretVisible: Boolean;
    isSelecting, isColSelecting: Boolean;
    selStart, selEnd: Integer;
    isLineTesting: bool;
    CurrentMidiNote: Integer;
    SamplesDontScroll: Boolean;
    ParentWin: TForm;
    UndoSaved: Boolean;
    HintLastX, HintLastY: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DefaultHandler(var Message); override;
    procedure SetCaretPosition;
    procedure ShowMyCaret;
    procedure HideMyCaret;
    function CurrentLine: Integer;
    procedure RecalcBaseNote(NewBaseNote: Integer);
    procedure SetNote(Note: ShortInt; Line: Integer; Volume: ShortInt; Redraw, CalcOctave, SetTone: Boolean);
    procedure RedrawSamples(DC: HDC);
    procedure RecreateCaret;
    procedure CreateMyCaret;
    procedure DoHint(X, Y: Integer);
    private
      procedure WMEraseBkGnd(var Message:TMessage); message WM_ERASEBKGND;
      procedure WMSysChar(var Message: TWMSysChar); message WM_SYSCHAR;
  end;

  TOrnaments = class(TWinControl)
  public
    fBitmap: TBitmap;
    InputONumber, CelW, CelH: Integer;
    CursorX, CursorY {,SelW,SelH}: Integer;
    ShownFrom, NOfLines: Integer;
    ShownOrnament: POrnament;
    NRaw: Integer;
    ToneShiftAsNote: Boolean;
    isSelecting: Boolean;
    CaretVisible: Boolean;
    selStart, selEnd: Integer;
    isLineTesting: bool;
    KeyPressed: Integer;
    CurrentMidiNote: Integer;
    ClickStartLine: Smallint;
    ClickMouseCursorY: SmallInt;
    LeftMouseButton: Boolean;
    ClickEndLine: Smallint;
    RightMouseButton: Boolean;
    LoopStarted: Boolean;
    UndoSaved: Boolean;
    ParentWin: TForm;
    Browser: TFileBrowser;
    SavedSampleTestLine: TChannelLine;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DefaultHandler(var Message); override;
    procedure SetCaretPosition;
    procedure ShowMyCaret;
    procedure HideMyCaret;
    procedure InitMetrix;
    procedure ClearSelection;
    procedure CopyToClipBoard;
    procedure CutToClipBoard;
    function CurrentLine: Integer;
    procedure SetNote(Note: ShortInt; Line: Integer; CalcOctave, Redraw: Boolean);
    procedure RedrawOrnaments(DC: HDC);
    procedure DoHint;
    private
      procedure WMEraseBkGnd(var Message:TMessage); message WM_ERASEBKGND;
      procedure WMSysChar(var Message: TWMSysChar); message WM_SYSCHAR;
  end;


  TChangeAction = (CALoadPattern, CALoadSample, CALoadOrnament, CAOrGen,
                   CACopyOrnamentToOrnament, CACopySampleToSample,
                   CAInsertPatternFromClipboard, CAChangeNote, CAChangeNoteAndParams,
                   CAChangeEnvelopePeriod, CAChangeNoise, CAChangeSample,
                   CAChangeEnvelopeType, CAChangeOrnament, CAChangeVolume,
                   CAChangeSpecialCommandNumber, CAChangeSpecialCommandDelay,
                   CAChangeSpecialCommandParameter, CAChangeSpeed,
                   CAChangePatternSize, CAChangePatternsSize,
                   CAChangeSampleSize, CAChangeSampleLoop, CAChangeEntireSample,
                   CAChangeOrnamentSize, CAChangeOrnamentLoop, CAChangeEntireOrnament,
                   CAChangeOrnamentValue, CAChangeSampleValue, CAInsertPosition,
                   CADeletePosition, CAChangePositionListLoop,
                   CAChangePositionValue, CAChangeToneTable, CAChangeFeatures,
                   CAChangeHeader, CAChangeAuthor, CAChangeTitle,
                   CAPatternInsertLine, CAPatternDeleteLine, CAPatternClearLine,
                   CAPatternClearSelection, CATransposePattern,
                   CATracksManagerCopy, CAExpandCompressPattern,
                   CAChangePositionsAndPatterns, CAChangePatternContent);

  TChangeParams = record
    CurrentPattern, CurrentPosition, PatternShownFrom, PatternCursorX, PatternCursorY,
    SampleShownFrom, SampleCursorX, SampleCursorY, PositionListLen,
    OrnamentShownFrom, OrnamentCursor, PrevLoop: Integer;

    NoteParam: shortint;
    SampleParam: byte;
    OrnamentParam: byte;
    VolumeParam: shortint;
    EnvelopeParam: byte;

    case TChangeAction of
      CAChangeNote:
        (Note: Integer);
      CAChangeNoteAndParams:
        (NoteP: Integer);
      CAChangeEnvelopePeriod:
        (EnvelopePeriod: Integer);
      CAChangeNoise:
        (Noise: Integer);
      CAChangeSample:
        (SampleNum: Integer);
      CAChangeEnvelopeType:
        (EnvelopeType: Integer);
      CAChangeOrnament:
        (OrnamentNum: Integer);
      CAChangeVolume:
        (Volume: Integer);
      CAChangeSpecialCommandNumber:
        (SCNumber: Integer);
      CAChangeSpecialCommandDelay:
        (SCDelay: Integer);
      CAChangeSpecialCommandParameter:
        (SCParameter: Integer);
      CAChangeSpeed:
        (Speed: Integer);
      CAChangePatternSize, CAChangeSampleSize, CAChangeOrnamentSize:
        (Size: Integer);
      CAChangeSampleLoop, CAChangeOrnamentLoop, CAChangePositionListLoop:
        (Loop: Integer);
      CAChangeOrnamentValue, CAChangePositionValue:
        (Value: Integer);
      CAChangeToneTable:
        (Table: Integer);
      CAChangeFeatures:
        (NewFeatures: Integer);
      CAChangeHeader:
        (NewHeader: Integer);
  end;

  PChangeParameters = ^TChangeParameters;

  TChangeParameters = record
    case Boolean of
      True:
        (str: packed array[0..32] of char);
      False:
        (prm: TChangeParams);
  end;

  TChangePattern = record
    Number: Integer;
    Pattern: TPattern;
  end;

  PChangePatterns = ^TChangePatterns;
  TChangePatterns = array of array of TChangePattern;
  // Structure:
  //   [0] => OldPatterns - Array of TChangePattern
  //   [1] => NewPatterns - Array of TChangePattern

  PNilPatterns = ^TNilPatterns;
  TNilPatterns = array of Integer;

  PChangeOnePattern = ^TChangeOnePattern;
  TChangeOnePattern = record
    OldPattern: TPattern;
    NewPattern: TPattern;
  end;


  PChangeSample = ^TChangeSample;
  TChangeSample = record
    Number: Integer;
    OldSample: TSample;
    NewSample: TSample;
  end;

  PChangeSamples = ^TChangeSamples;
  TChangeSamples = array of TChangeSample;


  PChangeOrnament = ^TChangeOrnament;
  TChangeOrnament = record
    Number: Integer;
    OldOrnament: TOrnament;
    NewOrnament: TOrnament;
  end;

  PChangeOrnaments = ^TChangeOrnaments;
  TChangeOrnaments = array of TChangeOrnament;


  TChangeListItem = record
    Action: TChangeAction;
    Line, Channel: Integer;
    OldGridSelection: TGridRect;
    NewGridSelection: TGridRect;
    Pattern: PPattern;
    PositionList: PPosition;
    Ornament: POrnament;
    Sample: PSample;
    SampleLineValues: PSampleTick;
    ComParams: record
      case TChangeAction of
        CAChangeSampleLoop:
          (CurrentSample: Integer);
        CAChangeOrnamentLoop:
          (CurrentOrnament: Integer);
        CAChangePositionsAndPatterns:
          (Patterns: PChangePatterns;
           NilPatterns: PNilPatterns);
        CAChangePatternContent:
          (ChangedPattern: PChangeOnePattern);
        CAChangeEntireSample:
          (EntireSample: PChangeSample);
        CAChangeEntireOrnament:
          (EntireOrnament: PChangeOrnament);
    end;
    OldParams, NewParams: TChangeParameters;
  end;

  TIntegersArray = array of Integer;
  TPlayStopState  = (BPlay, BStop);


  TChannelMetrics = record
    BoxLeft: Integer;
    BoxWidth: Integer;
    ButtonWidth: Integer;
    ToneLeft: Integer;
    NoiseLeft: Integer;
    EnvelopeLeft: Integer;
    SoloLeft: Integer;
  end;


  TMDIChild = class(TForm)
    PatternsSheet: TTabSheet;
    Edit3: TEdit;
    Edit4: TEdit;
    StringGrid1: TStringGrid;
    SamplesSheet: TTabSheet;
    OrnamentsSheet: TTabSheet;
    AutoStepBox: TGroupBox;
    OctaveEdit: TEdit;
    Label1: TLabel;
    OctaveUpDown: TUpDown;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    OptTab: TTabSheet;
    VtmFeaturesGrp: TRadioGroup;
    SaveHead: TRadioGroup;
    SampleNumEdit: TEdit;
    SampleNumUpDown: TUpDown;
    Label9: TLabel;
    SampleLenEdit: TEdit;
    SampleLenUpDown: TUpDown;
    Label10: TLabel;
    Label11: TLabel;
    SampleLoopEdit: TEdit;
    SampleLoopUpDown: TUpDown;
    SampleBrowserBox: TGroupBox;
    OrnamentNumEdit: TEdit;
    OrnamentLoopEdit: TEdit;
    OrnamentNumUpDown: TUpDown;
    OrnamentLoopUpDown: TUpDown;
    OrnamentLenEdit: TEdit;
    OrnamentLenUpDown: TUpDown;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    OrnamentsBrowserBox: TGroupBox;
    AutoEnvBtn: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    AutoStepUpDown: TUpDown;
    AutoStepEdit: TEdit;
    LoadOrnamentBtn: TButton;
    SaveOrnamentBtn: TButton;
    SpeedButton21: TSpeedButton;
    SaveTextDlg: TSaveDialog;
    LoadTextDlg: TOpenDialog;
    AutoStepBtn: TSpeedButton;
    CopyOrnBut: TSpeedButton;
    CopySamBut: TSpeedButton;
    SaveSampleBtn: TButton;
    LoadSampleBtn: TButton;
    Label6: TLabel;
    PatOptions: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    PatternNumUpDown: TUpDown;
    PatternNumEdit: TEdit;
    PatternLenEdit: TEdit;
    PatternLenUpDown: TUpDown;
    SpeedButton26: TSpeedButton;
    SpeedButton27: TSpeedButton;
    AutoHL: TSpeedButton;
    Edit17: TEdit;
    UpDown15: TUpDown;
    Edit7: TEdit;
    UpDown4: TUpDown;
    SpeedBpmEdit: TEdit;
    SpeedBpmUpDown: TUpDown;
    Label3: TLabel;
    EnvelopeAsNoteOpt: TCheckBox;
    SpeedBox: TGroupBox;
    OctaveBox: TGroupBox;
    SampleBox: TGroupBox;
    SamplesTestFieldBox: TGroupBox;
    SampleEditBox: TGroupBox;
    TrackInfoBox: TGroupBox;
    DuplicateNoteParams: TCheckBox;
    InterfaceOpts: TGroupBox;
    BetweenPatterns: TCheckBox;
    OrnamentsTestFieldBox: TGroupBox;
    OrnamentEditBox: TGroupBox;
    OrnamentBox: TGroupBox;
    PatEmptyBox: TGroupBox;
    UnloopBtn: TButton;
    TopBackgroundBox: TShape;
    ShowHintTimer: TTimer;
    HideHintTimer: TTimer;
    ChangeBackupVersion: TTimer;
    ExportWavDialog: TSaveDialog;
    AutoHLBox: TGroupBox;
    Channel1Box: TGroupBox;
    Channel2Box: TGroupBox;
    Channel3Box: TGroupBox;
    AutoEnvBox: TGroupBox;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    ClearSample: TButton;
    ExportPSGDlg: TSaveDialog;
    NextPrevSampleBox: TGroupBox;
    PrevSampleBtn: TButton;
    NextSampleBtn: TButton;
    NextPrevOrnBox: TGroupBox;
    PrevOrnBtn: TButton;
    NextOrnBtn: TButton;
    PasteOrnBut: TSpeedButton;
    ClearOrnBut: TButton;
    PasteSamBut: TSpeedButton;
    HideSamBrowserBtn: TButton;
    ShowSamBrowserBtn: TButton;
    HideOrnBrowserBtn: TButton;
    ShowOrnBrowserBtn: TButton;
    JoinTracksBtn: TButton;
    PositionsScrollBox: TScrollBox;
    StopPlayTimer: TTimer;
    SampleOpts: TGroupBox;
    SamToneShiftAsNoteOpt: TCheckBox;
    SamOctaveNum: TUpDown;
    SamOctaveLabel: TLabel;
    SamOctaveTxt: TLabel;
    SamOptsSep: TShape;
    OrnamentOpts: TGroupBox;
    OrnOctaveLabel: TLabel;
    OrnOctaveTxt: TLabel;
    OrnOptsSep: TShape;
    OrnToneShiftAsNoteOpt: TCheckBox;
    OrnOctaveNum: TUpDown;
    TrackChipFreq: TRadioGroup;
    ManualHz: TEdit;
    TrackOptsScrollBox: TScrollBox;
    TrackIntSel: TRadioGroup;
    ManualIntFreq: TEdit;
    HelpShape1: TShape;
    PageControl1: TPageControl;
    RecalcTonesBtn: TSpeedButton;
    SamOptsSep1: TShape;
    InfoTab: TTabSheet;
    TrackInfoGB: TGroupBox;
    TrackInfo: TRichEdit;
    Bold: TSpeedButton;
    Italic: TSpeedButton;
    Underline: TSpeedButton;
    ShowInfoOnLoad: TCheckBox;
    TrackInfoTimer: TTimer;
    EditPanel: TPanel;
    ViewInfoBtn: TButton;
    FileBrowserPopup: TPopupMenu;
    FBDelete: TMenuItem;
    FBRename: TMenuItem;
    ToneTableBox: TGroupBox;
    ToneTableLab: TLabel;
    JoinTracksBox: TGroupBox;
    FBNewFolder: TMenuItem;
    FBSetQuickAccess: TMenuItem;
    FBSaveInstrument: TMenuItem;
    N1: TMenuItem;
    function IsMouseOverControl(const Ctrl: TControl): Boolean;
    function BorderSize: Integer;
    function OuterHeight: Integer;    
    procedure SetWidth(Value: Integer; Fixed: Boolean);
    function  GetCurrentFileBrowser: TFileBrowser;
    procedure FileBrowserRename(Sender: TObject);
    procedure FileBrowserDelete(Sender: TObject);
    procedure RefreshPositionsHScroll;
    procedure RememberChannelsPosition;
    function GetBackupVersionCounter: Integer;
    function ModuleInPlayingWindow: Boolean;
    procedure SetModuleFreq;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    function GetPositionNumber: Integer;
    procedure ResizeChannelsBox;
    procedure ResizeAutoStepEnvBox(x, b: Single; BtnsMargin: Byte; AStepWidth, AEnvWidth: Smallint; strict: Boolean);
    procedure FitSampleBox;
    procedure PrepareForm;
    procedure AutoResizeForm;
    procedure ResetChanAlloc;
    procedure CreateTracks;
    procedure CreateTestLines;
    procedure CreateOrnaments;
    procedure InitSamplesMetrix;
    procedure CreateSamples;
    procedure ChangeNote(Pat, Line, Chan, Note: Integer);
    procedure ChangeTracks(Pat, Line, Chan, CursorX, n: Integer; Keyboard: Boolean);
    procedure TLArpMidiOn(note: Integer);
    procedure TLArpMidiOff(note: Integer);
    procedure OrnamentsMidiNoteOn(note: Byte);
    procedure OrnamentsMidiNoteOff(note: Byte);
    procedure SamplesMidiNoteOn(note: Byte);
    procedure SamplesMidiNoteOff(note: Byte);
    procedure TracksMidiNoteOn(note: SmallInt);
    procedure TracksMidiNoteOff(note: SmallInt);
    function GetCurrentPatternLength: byte;
    procedure OpenSampleOrnament;
    procedure DoSwapChannels(RightDirect: Boolean);
    procedure BetweenPatternsUp;
    procedure BetweenPatternsDown;
    procedure TracksKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SamplesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SaveSyncSample;
    procedure copySampleToBuffer(All: Boolean);
    procedure PastePatternToSample;
    procedure PasteOrnamentToSample;
    procedure pasteSampleFromBuffer(All: Boolean);
    procedure GetSamParams(var l, i: Integer);
    procedure SamplesSelectionOff;
    procedure SamplesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OrnamentsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure copyOrnamentToBuffer(All: Boolean);
    procedure PastePatternToOrnament;
    procedure pasteOrnamentFromBuffer;
    procedure OrnamentSelectionOff;
    procedure GetOrnParams(var l, i, c: Integer);
    procedure IncreaseOrnamentValue(Line: Integer; Shift: TShiftState);
    procedure DecreaseOrnamentValue(Line: Integer; Shift: TShiftState);
    procedure OrnamentsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TracksMoveCursorMouse(X, Y: Integer; Sel, Mv, ButRight: Boolean);
    procedure TracksMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    function SamplesVolMouse(x, y: Integer): Boolean;
    procedure DrawOnSample(CurX, CurY, LineNum: Integer; Everywere: Boolean);
    function DetectSampleColumn(X: Integer): Byte;
    procedure SamplesMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SamplesMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TracksMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SamplesMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OrnamentsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OrnamentsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OrnamentsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OrnamentsMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure OrnamentsMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure DisposeUndo(All: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure SetFileName(Name: string);
    function LoadTrackerModule(Name: string; var VTMP2: PModule): Boolean;
    procedure TracksMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure TracksMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure ResetSampleVolumeBuf;
    procedure ClearSampleCols;
    procedure IncreaseSampleTone(SampleTick: PSampleTick; Shift: TShiftState);
    procedure IncreaseSampleNoise(SampleTick: PSampleTick);
    procedure IncreaseSampleAmplitude(SampleTick: PSampleTick; Line: Integer; Overflow: Boolean);
    procedure IncreaseSampleCols(Shift: TShiftState);
    procedure DecreaseSampleTone(SampleTick: PSampleTick; Shift: TShiftState);
    procedure DecreaseSampleNoise(SampleTick: PSampleTick);
    procedure DecreaseSampleAmplitude(SampleTick: PSampleTick; Line: Integer; Overflow: Boolean);
    procedure DecreaseSampleCols(Shift: TShiftState);

    procedure SamplesMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure SamplesMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure ValidatePattern2(pat: Integer);
    procedure TracksKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RestartPlayingPos(Pos: Integer);
    procedure RestartPlayingNote(Line: Integer);
    procedure RestartPlayingLine(Line: Integer);
    procedure RestartPlaying(PlayPat, Enter: Boolean);
    procedure RestartPlayingTS(PlayPat, PlayNote: Boolean);
    procedure StopAndRestart;
    procedure RerollToInt(Int_, Chip: Integer);
    procedure RerollToPos(Pos, Chip: Integer);
    procedure RerollToLineNum(Chip, Line: Integer; ZeroLine: Boolean; SrcVTMP: PModule = nil);
    procedure RerollToLine(Chip: Integer);
    procedure RerollToLine0(Chip: Integer);
    procedure RerollToPatternLine(Chip: Integer);
    procedure GoToTime(Time: Integer);
    procedure SinchronizeModules;
    procedure SetStringGrid1Scroll(ACol: Integer);
    procedure SelectPosition(Pos: Integer);
    procedure SelectPosition2(ps: Integer);
    procedure SelectPositions(SelGrid: TGridRect);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure ChangePositionValue(pos, value: Integer);
    procedure ChangePositionValueNoUndo(pos, value: Integer);
    procedure IncreaseTrackLength(NumNewPositions: Integer);
    procedure RedrawPatternPositions;
    procedure UnselectPositions;
    procedure ShiftLoopPosition(Operation, SourceCol, DestCol, NumChangedPositions: Integer);
    procedure SavePositionsUndo;
    procedure SavePositionsRedo;
    procedure SaveTrackUndo;
    procedure SaveTrackRedo;
    procedure SavePatternUndo;
    procedure SavePatternRedo;
    procedure SaveSampleUndo(Sample: PSample);
    procedure SaveSampleRedo;
    procedure SaveOrnamentUndo;
    procedure SaveOrnamentRedo;
    procedure ShiftPositionsToRight(FromPos, NumNewPositions: Integer);
    procedure ShiftPositionsToLeft(FromPos, ToPos: Integer);
    procedure InsertPosition(Duplicate, MakeUndo, ChangePosition: boolean);
    procedure ClonePositions;
    procedure DeletePositions;
    function GetNewPatternNumber: Integer;
    function GetNewPatternNumbers(NumNewPatterns: Integer): TIntegersArray;
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure PatternNumEditExit(Sender: TObject);
    procedure InitStringGridMetrix;
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PositionMakeSelection(FromPos, ToPost: byte);
    procedure CloneAndCopyPattern(SrcPatternNumber, NewPatternNumber: byte);
    procedure StringGrid1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure StringGrid1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure StringGrid1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure ChangePattern(n: Integer);
    procedure PatternNumUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
    procedure PatternNumEditChange(Sender: TObject);
    function GetSpeedBPMString(TrackSpeed: Smallint): string;
    procedure UpdateSpeedBPM;
    procedure SpeedBpmUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
    procedure UpDown4ChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
    procedure Edit7Exit(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure PatternLenEditExit(Sender: TObject);
    procedure PatternLenUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
    procedure CheckTracksAfterSizeChanged(NL: Integer);
    procedure ChangePatternLength(NL: Integer);
    procedure OctaveEditExit(Sender: TObject);
    procedure SetChannelAMutedState(Muted: Boolean);
    procedure SetChannelBMutedState(Muted: Boolean);
    procedure SetChannelCMutedState(Muted: Boolean);
    procedure UpdateChannelsMutedState;
    //procedure CheckSoloButtons;
    procedure CheckButtonStateChanA;
    procedure CheckButtonStateChanB;
    procedure CheckButtonStateChanC;
    procedure UpdateHintsForChannelButtons;
    procedure UpdateChannelsState;
    function AnotherSoloPressed: Boolean;
    procedure MuteChannelA(Force: Boolean);
    procedure MuteChannelB(Force: Boolean);
    procedure MuteChannelC(Force: Boolean);
    procedure DismuteChannelA;
    procedure DismuteChannelB;
    procedure DismuteChannelC;
    procedure DismuteAllChannels(Force: Boolean);
    procedure MuteSecondWidnowChannels;
    procedure SoloChannelA(Force: Boolean);
    procedure SoloChannelB(Force: Boolean);
    procedure SoloChannelC(Force: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure VtmFeaturesGrpClick(Sender: TObject);
    procedure SaveHeadClick(Sender: TObject);
    procedure SampleNumEditChange(Sender: TObject);
    procedure SampleNumEditExit(Sender: TObject);
    procedure SampleNumUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
    procedure SampleLenEditExit(Sender: TObject);
    procedure SampleLenUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
    procedure ChangeSample(n: Integer; UpdateUpDown: Boolean);
    procedure ClearShownOrnament;
    procedure ClearShownSample;
    procedure ChangeOrnament(n: Integer);
    procedure ChangeOrnamentLength(NL: Integer; UpdateUpDown: Boolean);
    procedure ChangeOrnamentLoop(NL: Integer; UpdateUpDown: Boolean);
    procedure ChangeSampleLength(NL: Integer; UpdateUpDown: Boolean);
    procedure ChangeSampleLoop(NL: Integer; UpdateUpDown: Boolean);
    procedure ValidateSample2(sam: Integer);
    procedure ValidateOrnament(orn: Integer);
    procedure SampleLoopEditExit(Sender: TObject);
    procedure SampleLoopUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
    procedure CalculatePos0;
    procedure CalculatePos(Line: Integer);
    procedure CheckStringGrid1Position;
    procedure ShowStat;
    procedure UpdateIntsInfo(PSBegin: Integer);
    procedure ShowAllTots;
    procedure CalcTotLen;
    procedure ReCalcTimes(PSBegin: Integer);
    procedure SetInitDelay(nd: Integer);
    procedure OrnamentNumUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
    procedure OrnamentNumEditChange(Sender: TObject);
    procedure OrnamentNumEditExit(Sender: TObject);
    procedure OrnamentLoopUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
    procedure OrnamentLoopEditExit(Sender: TObject);
    procedure OrnamentLenUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
    procedure OrnamentLenEditExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ToggleAutoEnv;
    procedure ToggleStdAutoEnv;
    procedure SpeedButton17Click(Sender: TObject);
    procedure AutoEnvBtnClick(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure SpeedButton18Click(Sender: TObject);
    procedure DoAutoEnv(i, j, k: Integer);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TracksExit(Sender: TObject);
    procedure AutoStepEditExit(Sender: TObject);
    function DoStep(i: Integer; StepForward, ForceAutoStep: Boolean): Boolean;
    procedure SaveOrnamentFile(FullPath: String);
    procedure SaveOrnamentBtnClick(Sender: TObject);
    procedure LoadOrnamentBtnClick(Sender: TObject);
    procedure LoadOrnament(FN: string; Index: Integer = -1);
    procedure SpeedButton21Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ToggleAutoStep;
    procedure AutoStepBtnClick(Sender: TObject);
    procedure OrnamentCopyToUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
    procedure CopyOrnButClick(Sender: TObject);
    procedure SampleCopyToUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
    procedure CopySamButClick(Sender: TObject);
    procedure SaveSampleFile(FullPath: String);
    procedure SaveSampleBtnClick(Sender: TObject);
    procedure LoadSampleBtnClick(Sender: TObject);
    procedure LoadSample(FN: String; Index: Integer = -1);
    procedure SpeedButton26Click(Sender: TObject);
    procedure LoadPattern(FN: string);
    procedure SpeedButton27Click(Sender: TObject);
    procedure CopyToFamiTracker;
    procedure CopyToModplug;
    procedure CopyToRenoise;
    procedure PasteFamiTrackerPattern;
    procedure PasteModPlugPattern(txt: String);
    procedure PasteRenoisePattern(txt: String);    
    procedure UpDown15ChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
    procedure AutoHLCheckClick(Sender: TObject);
    procedure CalcHLStep;
    procedure Edit17Exit(Sender: TObject);
    procedure ChangeHLStep(NewStep: Integer);
    procedure UpDown15Click(Sender: TObject; Button: TUDBtnType);
    procedure SetLoopPos(lp: Integer);
    procedure AddUndo(CA: TChangeAction; par1, par2: Integer);
    procedure DoUndo(Steps: Integer; Undo: Boolean);
    procedure SaveModuleAs;
    procedure SaveModule;
    procedure SaveModuleBackup;
    procedure FormActivate(Sender: TObject);
    function PrepareTSString(TSBut: TSpeedButton; s: string): string;
    procedure JoinChild(Child: TMDIChild);
    procedure SetToolsPattern;
    procedure PatternLenEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EnvelopeAsNoteOptMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AutoNumeratePatterns;
    //procedure SmartRedraw;
    procedure RedrawOff;
    procedure RedrawOn;
    procedure InvalidateChild;
    procedure FormResize(Sender: TObject);
    procedure UnloopBtnClick(Sender: TObject);
    procedure SampleCopyToEditContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure ChangePatternsLength(PatternsLength: Integer);
    procedure RenumberPatterns;
    procedure SplitPattern;
    procedure ExpandPattern;
    procedure CompressPattern;
    procedure PackPattern;
    procedure ShowHintTimerTimer(Sender: TObject);
    procedure HideHintTimerTimer(Sender: TObject);
    procedure ChangeBackupVersionTimer(Sender: TObject);
    procedure PrepareExportDialog(Dlg: TSaveDialog; Ext: String; InitDir: String = '');
    procedure ExportToWavFile;
    procedure FormPaint(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure ClearSampleClick(Sender: TObject);
    procedure UnsetFocus(var Key: Char; Control: TWinControl);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure PatternLenEditKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedBpmEditKeyPress(Sender: TObject; var Key: Char);
    procedure OctaveEditKeyPress(Sender: TObject; var Key: Char);
    procedure AutoStepEditKeyPress(Sender: TObject; var Key: Char);
    procedure Edit17KeyPress(Sender: TObject; var Key: Char);
    procedure PatternNumEditKeyPress(Sender: TObject; var Key: Char);
    procedure DuplicateNoteParamsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BetweenPatternsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SampleNumEditKeyPress(Sender: TObject; var Key: Char);
    procedure SampleLenEditKeyPress(Sender: TObject; var Key: Char);
    procedure SampleCopyToEditKeyPress(Sender: TObject; var Key: Char);
    procedure SampleLoopEditKeyPress(Sender: TObject; var Key: Char);
    procedure OrnamentNumEditKeyPress(Sender: TObject; var Key: Char);
    procedure OrnamentLenEditKeyPress(Sender: TObject; var Key: Char);
    procedure OrnamentCopyToEditKeyPress(Sender: TObject; var Key: Char);
    procedure OrnamentLoopEditKeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EnvelopeAsNoteOptClick(Sender: TObject);
    procedure SavePSGRegisterDump(FileName: string; VTMP: PModule; Chip: byte);
    procedure ExportPSG;
    procedure StopAndRestoreControls;
    procedure SamplePreview;
    procedure OrnamentPreview;
    procedure PrevSampleBtnClick(Sender: TObject);
    procedure NextSampleBtnClick(Sender: TObject);
    procedure PrevOrnBtnClick(Sender: TObject);
    procedure NextOrnBtnClick(Sender: TObject);
    procedure ClearOrnButClick(Sender: TObject);
    procedure PasteOrnButClick(Sender: TObject);
    procedure PasteSamButClick(Sender: TObject);
    procedure HideSamBrowserBtnClick(Sender: TObject);
    procedure ShowSamBrowserBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure HideOrnBrowserBtnClick(Sender: TObject);
    procedure ShowOrnBrowserBtnClick(Sender: TObject);
    procedure StopPlayTimerTimer(Sender: TObject);
    procedure UpdateSamToneShiftControls;
    procedure SamToneShiftAsNoteOptClick(Sender: TObject);
    procedure SamOctaveNumChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure UpdateOrnToneShiftControls;
    procedure OrnToneShiftAsNoteOptClick(Sender: TObject);
    procedure OrnOctaveNumChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    function  GetValue(const s: string): Integer;
    function  GetValueF(s: string): Double;    
    procedure UpdateChipFreq;
    procedure UpdateToneTableHints;
    procedure InitTrack;
    procedure SetTrackFreq(FreqValue: Integer);
    procedure TrackChipFreqClick(Sender: TObject);
    procedure UpdateIntFreq;
    procedure SetTrackIntFreq(IntFreqValue: Integer);
    procedure TrackIntSelClick(Sender: TObject);
    procedure ManualHzKeyPress(Sender: TObject; var Key: Char);
    procedure ManualHzKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ManualIntFreqKeyPress(Sender: TObject; var Key: Char);
    procedure ManualIntFreqKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UpdateTrackInfo;
    procedure BoldClick(Sender: TObject);
    procedure ItalicClick(Sender: TObject);
    procedure UnderlineClick(Sender: TObject);
    function GetRTFText(ARichEdit: TRichedit): string;
    procedure SetRTFText(ARichEdit: TRichedit; RTFText: String);
    procedure TrackInfoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TrackInfoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ShowInfoOnLoadMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackInfoTimerTimer(Sender: TObject);
    procedure ViewInfoBtnClick(Sender: TObject);
    procedure StringGrid1MouseWheelDown(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure StringGrid1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure SpeedBpmEditEnter(Sender: TObject);
    procedure SpeedBpmEditExit(Sender: TObject);
    procedure SpeedBpmEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedBpmUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure FileBrowserNewFolder(Sender: TObject);
    procedure FileBrowserSetFavorite(Sender: TObject);
    procedure FileBrowserSaveInstrument(Sender: TObject);



    {
    // Templates in samples editor disabled
    // Because people don't need in this feature

    procedure ListBox1Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure AddCurrentToSampTemplate;
    procedure SpeedButton14Click(Sender: TObject);
    procedure CopySampTemplateToCurrent;
    procedure SpeedButton23Click(Sender: TObject);
    }

  private
    { Private declarations }
    procedure CMDialogKey(var msg: TCMDialogKey); message CM_DIALOGKEY;
    procedure WMEnterSizeMove(var Message:TWMMove); message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove(var Message:TWMMove); message WM_EXITSIZEMOVE;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure WMEraseBkGnd(var Message:TMessage); message WM_ERASEBKGND;
    procedure WMSysChar(var Message: TWMSysChar); message WM_SYSCHAR;

  public
    { Public declarations }
    InitFinished: Boolean;
    Tracks: TTracks;
    LastWidth, LastHeight: Integer;
    WidthChanged, HeightChanged: Boolean;
    SampleTestLine, OrnamentTestLine: TTestLine;
    Samples: TSamples;
    Ornaments: TOrnaments;
    SamplesDriveSelect: TDriveSelect;
    SamplesBrowser: TFileBrowser;
    OrnamentsDriveSelect: TDriveSelect;
    OrnamentsBrowser: TFileBrowser;
    VTMP: PModule;
    PlayStopState: TPlayStopState;
    PatNum, SamNum, OrnNum: Integer;
    SongChanged: Boolean;
    BackupSongChanged: Boolean;
    BackupVersionCounter: Integer;
    ShowEnvelopeAsNote: Boolean;
    InputPNumber, PositionNumber, PosBegin, PosDelay, TotInts, LineInts: Integer;
    //InputPNumber, PosBegin, PosDelay, TotInts, LineInts: Integer;
    xc: array[0..2] of TChannelMetrics;
    AutoEnv, AutoStep: Boolean;
    AutoEnv0, AutoEnv1, StdAutoEnvIndex: Integer;
    OrGenRunning: Boolean;
    ChangeCount, ChangeTop: Integer;
    UndoWorking: Boolean;
    ChangeList: array of TChangeListItem;
    ChangePatternsList: array of TChangePatterns;
    ChangeOnePatternList: array of TChangeOnePattern;
    ChangeSamplesList: TChangeSamples;
    ChangeOrnamentsList: TChangeOrnaments;
    ChangeNilPatternsList: array of TNilPatterns;
    WinNumber: Integer;
    WinFileName: string;
    SavedAsText: Boolean;
    TSWindow: TMDIChild;
    LeftModule: Boolean;
    Closed: Boolean;
    IsSinchronizing: Boolean;
    BlockRecursion: Boolean;
    SamplesClickStartLine: Smallint;
    SamplesClickEndLine: Smallint;
    SamplesLastMouseCursorY: Smallint;
    SamplesLastCursorX, SamplesLastCursorY: SmallInt;
    SamplesRightMouseButton, SamplesLeftMouseButton: Boolean;
    DrawOnlyT, DrawOnlyN, DrawOnlyE, TNEValue: Boolean;
    PositiveSign, DrawOnlyToneSign, DrawOnlyNoiseSign: Boolean;
    StringGridCelW, StringGridCelH: Integer;
    StringGridTextVShift, StringGridTextHShift: Integer;
    StringGridAddHeight: Integer;
    PosArrowSize, PosArrowVShift, PosArrowHShift: Integer;
    IsTemplate: Boolean;
    IsDemosong: Boolean;
    VolumeLBuffer, VolumeRBuffer: array of Integer;
    // Precalculated values for controls
    ToolBoxesWidth: Integer;
    SamplesDir, OrnamentsDir: String;

  published
     //    destructor Destroy; override;
  end;



var
  PlayingWindow: array[1..MaxNumberOfSoundChips] of TMDIChild;
  CurrentMidiNote: Integer;
  NoteCounter: Integer;
  MaxNote: Integer;
  Arp: array[0..96] of Integer;
  PatternsOrderSelection: TGridRect;
  IsPatternsSelected: Boolean;
  DisableChangingEx: Boolean;


implementation

uses
  Main, options, selectts, TglSams, GlbTrn, TrkMng, ntfs, UnloopDlg, ClipBrd, TrackInf, PatternPacker;

{$R *.DFM}
{$J+} { Assignable Typed Constant }

const
 { OrnNCol = 4;
  OrnNRaw = 20;
  OrnNChars = 9;   }

  ShowHintDelay = 1100;
  HideHintDelay = 3000;


function ValidFileName(Str: String): Boolean;
const InvalidChars: array[0..11] of string =
    ('*', '?', '"', '''', '<', '>', ':', '/', '\', '|', '[', ']');
var i: Integer;
begin

  Result := True;

  if Trim(Str) = '' then begin
    Result := False;
    Application.MessageBox('Empty filename', 'Vortex Tracker', MB_OK
        + MB_ICONWARNING + MB_TOPMOST);
    Exit;
  end;

  for i := 1 to Length(Str) do
    if AnsiMatchStr(Str[i], InvalidChars) then begin
      Result := False;
      Application.MessageBox('Invalid filename', 'Vortex Tracker', MB_OK
        + MB_ICONWARNING + MB_TOPMOST);
      Exit;
    end;

end;


function GetDirName(FullDirPath: String): String;
begin
  if FullDirPath[Length(FullDirPath)] <> '\' then
    FullDirPath := FullDirPath + '\';
  Result := ExtractFileName(ExtractFileDir(FullDirPath));
end;


function IsDirectoryWriteable(const AName: string): Boolean; 
var 
  FileName: String; 
  H: THandle; 
begin 
  FileName := IncludeTrailingPathDelimiter(AName) + 'chk.tmp'; 
  H := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE, 0, nil, 
    CREATE_NEW, FILE_ATTRIBUTE_TEMPORARY or FILE_FLAG_DELETE_ON_CLOSE, 0); 
  Result := H <> INVALID_HANDLE_VALUE; 
  if Result then CloseHandle(H);
end;


procedure TRichEdit.CreateWnd;
var
  mask: LResult;
begin
  inherited;
  mask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
  SendMessage(Handle, EM_AUTOURLDETECT, 1, 0);
  SendMessage(Handle, EM_SETUNDOLIMIT, 100, 0);
end;

procedure TRichEdit.CNNotify(var Message: TWMNotify);
type
  PENLink = ^TENLink;
var
  p: PENLink;
  tr: TEXTRANGE;
  url: array of Char;
begin

  if (Message.NMHdr.code = EN_LINK) then begin
    p := PENLink(Message.NMHdr);
    if (p.Msg = WM_LBUTTONDOWN) then begin
      try
        SetLength(url, p.chrg.cpMax - p.chrg.cpMin + 1);
        tr.chrg := p.chrg;
        tr.lpstrText := PChar(url);
        SendMessage(Handle, EM_GETTEXTRANGE, 0, LPARAM(@tr));
        ShellExecute(Handle, nil, PChar(url), nil, nil, SW_SHOWNORMAL);
      except
        {ignore}
      end;
      Exit;
    end;
  end;

  inherited;
end;


procedure TScrollBox.AutoScrollInView(AControl:TControl);
begin
  // empty body
  // don't delete this code!
end;

function IsHexValid(HexValue: string): Boolean;
const
  ValidChars: array[0..21] of string = (
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    'A', 'B', 'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f'
  );
var i: Integer;
begin
  Result := True;
  for i := 1 to Length(HexValue) do
    if not AnsiMatchStr(HexValue[i], ValidChars) then
    begin
      Result := False;
      Break;
    end;
end;


function IsDecValid(DecValue: string): Boolean;
const
  ValidChars: array[0..9] of string = (
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
  );
var i: Integer;
begin
  Result := True;
  for i := 1 to Length(DecValue) do
    if not AnsiMatchStr(DecValue[i], ValidChars) then
    begin
      Result := False;
      Break;
    end;
end;

function Ns(n: Integer): shortint;
begin
  if n and $10 = 0 then
    Ns := n and $F
  else
    Ns := n or $F0
end;

function ExtractFileNameEX(const AFileName: String): String;
var
 I: integer;
begin
  I := LastDelimiter('.'+PathDelim+DriveDelim,AFileName);
  if (I = 0) or (AFileName[I] <> '.')
  then
    I := MaxInt;
  Result := ExtractFileName(Copy(AFileName, 1, I - 1));
end;

{destructor TMDIChild.Destroy;
begin
FreeVTMP(VTMP);
inherited;
end;}

function TMDIChild.GetCurrentFileBrowser: TFileBrowser;
begin
  Result := nil;
  if PageControl1.ActivePage = SamplesSheet   then Result := SamplesBrowser;
  if PageControl1.ActivePage = OrnamentsSheet then Result := OrnamentsBrowser;
end;

procedure TMDIChild.FileBrowserRename(Sender: TObject);
var
  i: Integer;
  FB: TFileBrowser;
  FileName, FullPath, NewName, NewFullPath: String;

begin
  FB := GetCurrentFileBrowser;
  if FB = nil then Exit;

  FileName := FB.GetSelectedFileName;
  FullPath := FB.GetSelectedFullPath;
  if (FileName = '') or (FullPath = '') then Exit;

  NewName := AnsiLeftStr(FileName, Length(FileName)-4);
  repeat
    if not InputQuery('Vortex Tracker', 'Enter a new file name', NewName) then
      Exit;
  until ValidFileName(NewName);

  // Cut too long filename
  if Length(NewName) > 100 then
    NewName := AnsiLeftStr(NewName, 100);

  if AnsiRightStr(NewName, 4) <> '.'+FB.FileExt then
    NewName := NewName + '.' + FB.FileExt;

  NewFullPath := ExtractFileDir(FullPath) + '\' + NewName;


  if FileExists(NewFullPath) then begin
    MessageDlg('File "'+ NewName +'" already exists.',  mtWarning, [mbOK], 0);
    Exit;
  end;

  RenameFile(FullPath, NewFullPath);
  FB.ReadDir;

  for i := 1 to FB.Items.Count-1 do
    if FB.Items[i] = NewName then begin
      FB.Selected[i] := True;
      Break;
    end;

end;

procedure TMDIChild.FileBrowserDelete(Sender: TObject);
var
  Index: Integer;
  FB: TFileBrowser;
  FileName, FullPath: String;
begin

  FB := GetCurrentFileBrowser;
  if FB = nil then Exit;

  FileName := FB.GetSelectedFileName;
  FullPath := FB.GetSelectedFullPath;
  if (FileName = '') or (FullPath = '') then Exit;

  if MessageDlg('Are you sure you want to delete "'+FileName+'"?',  mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;

  Index := FB.GetSelectedIndex;
  DeleteFile(FullPath);
  FB.ReadDir;

  if Index <= FB.Items.Count-1 then
    FB.Selected[Index] := True
  else
    FB.Selected[FB.Items.Count-1] := True;

end;


procedure TMDIChild.FileBrowserNewFolder(Sender: TObject);
var
  FB: TFileBrowser;
  Index: Integer;
  FullPath, NewName: String;

begin

  FB := GetCurrentFileBrowser;
  if FB = nil then Exit;
  if FB.CurrentDir = '' then Exit;

  NewName := '';
  repeat
    if not InputQuery('Vortex Tracker', 'Enter folder name', NewName) then
      Exit;
  until ValidFileName(NewName);
  FB.DontOpenItem := True;

  // Cut too long filename
  if Length(NewName) > 100 then
    NewName := AnsiLeftStr(NewName, 100);

  if FB.CurrentDir[Length(FB.CurrentDir)] <> '\' then
    FB.CurrentDir := FB.CurrentDir + '\';

  FullPath := ExpandFileName(FB.CurrentDir + NewName);
  if DirectoryExists(FullPath) then begin
    MessageDlg('Folder "'+ NewName +'" already exists.',  mtWarning, [mbOK], 0);
    Exit;
  end;


  if FB.PathNotFound(FB.CurrentDir, False) then Exit;

  if not IsDirectoryWriteable(FB.CurrentDir) then begin
    MessageDlg('Folder "'+ FB.CurrentDir +'" is not writeable.',  mtError, [mbOK], 0);
    Exit;
  end;

  if CreateDir(FullPath) then begin
    FB.ReadDir;
    Index := FB.GetIndex('['+ NewName +']');
    if Index <> -1 then
      FB.Selected[Index] := True
    else
      FB.Selected[0] := True;
  end
  else
    ShowMessage('Cannot create new folder. Error: '+ SysErrorMessage(GetLastError));

end;


procedure TMDIChild.FileBrowserSetFavorite(Sender: TObject);
var
  FB: TFileBrowser;
  PathName: String;
begin

  FB := GetCurrentFileBrowser;
  if FB = nil then Exit;
  if FB.CurrentDir = '' then Exit;

  PathName := FB.GetSelectedFullPath;
  if PathName = '' then Exit;
  if PathName[Length(PathName)] <> '\' then
    PathName := PathName + '\';

  if FB.PathNotFound(PathName, False) then Exit;

  if FB.FileExt = 'vts' then SamplesQuickDir   := PathName;
  if FB.FileExt = 'vto' then OrnamentsQuickDir := PathName;

  FB.DriveSelectBox.FillDiskDrives;

end;


procedure TMDIChild.FileBrowserSaveInstrument(Sender: TObject);
var
  FB: TFileBrowser;
  NewName, FullPath: String;
begin

  FB := GetCurrentFileBrowser;
  if FB = nil then Exit;
  if FB.CurrentDir = '' then Exit;
  
  if FB.PathNotFound(FB.CurrentDir, False) then Exit;
  if not IsDirectoryWriteable(FB.CurrentDir) then begin
    MessageDlg('Folder "'+ FB.CurrentDir +'" is not writeable.',  mtError, [mbOK], 0);
    Exit;
  end;

  NewName := '';
  repeat
    if not InputQuery('Vortex Tracker', 'Enter sample name', NewName) then
      Exit;
  until ValidFileName(NewName);

  if FB.PathNotFound(FB.CurrentDir, False) then Exit;


  // Cut too long filename
  if Length(NewName) > 100 then
    NewName := AnsiLeftStr(NewName, 100);

  if FB.CurrentDir[Length(FB.CurrentDir)] <> '\' then
    FB.CurrentDir := FB.CurrentDir + '\';

  FullPath := FB.CurrentDir + NewName +'.'+ FB.FileExt;
  if FB.FileExt = 'vts' then SaveSampleFile(FullPath);
  if FB.FileExt = 'vto' then SaveOrnamentFile(FullPath);

end;


constructor TDriveSelect.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  Style  := csOwnerDrawFixed;
  Color  := CSamOrnBackground;
  ControlStyle := ControlStyle + [csOpaque];
  Font.Style := [fsBold];
  DoubleBuffered := True;
end;


procedure TDriveSelect.FillDiskDrives;
var
  i, CurItemIndex, HomeIndex, QuickIndex: Integer;
  DrivesList: TStringList;
  CurrentDrive, QuickDir: String;

begin
  if FileBrowser.CurrentDir = '' then Exit;
  Clear;
  DrivesList := TStringList.Create;
  FileBrowser.GetDriveLetters(DrivesList);
  CurrentDrive := FileBrowser.CurrentDir[1];
  CurItemIndex := 0;
  HomeIndex    := 0;
  QuickIndex   := -1;
  QuickDir     := '';

  for i := 0 to DrivesList.Count-1 do
  begin
    Items.Append(DrivesList.Strings[i][1] + ':');
    if DrivesList.Strings[i][1] = CurrentDrive then
      CurItemIndex := i;
  end;
  DrivesList.Free;


  if FileBrowser.FileExt = 'vts' then begin

    if DirectoryExists(VortexDocumentsDir + SamplesDefaultDir) then begin
      Items.Append('*Samples');
      HomeIndex := Items.Count-1;
    end;

    if (SamplesQuickDir <> '') and DirectoryExists(SamplesQuickDir) then begin
      Items.Append(GetDirName(SamplesQuickDir));
      QuickDir   := SamplesQuickDir;
      QuickIndex := Items.Count-1;
    end;
  end;


  if FileBrowser.FileExt = 'vto' then begin

    if DirectoryExists(VortexDocumentsDir + OrnamentsDefaultDir) then begin
      Items.Append('*Ornaments');
      HomeIndex := Items.Count-1;
    end;

    if (OrnamentsQuickDir <> '') and DirectoryExists(OrnamentsQuickDir) then begin
      Items.Append(GetDirName(OrnamentsQuickDir));
      QuickDir := OrnamentsQuickDir;
      QuickIndex := Items.Count-1;
    end;
  end;


  if (QuickIndex <> -1) and (QuickDir <> '') and (FileBrowser.InDir(QuickDir)) then
    CurItemIndex := QuickIndex

  else if FileBrowser.InHomeDir then
    CurItemIndex := HomeIndex;

  ItemIndex := CurItemIndex;
end;


procedure TDriveSelect.MyOnChange(Sender: TObject);
begin

  if Text = '*Samples' then
    FileBrowser.CurrentDir := VortexDocumentsDir + SamplesDefaultDir

  else if Text = '*Ornaments' then
    FileBrowser.CurrentDir := VortexDocumentsDir + OrnamentsDefaultDir

  else if (Length(Text) = 2) and (Text[2] = ':') then
    FileBrowser.CurrentDir := Text + '\'

  else begin
    if FileBrowser.FileExt = 'vts' then FileBrowser.CurrentDir := SamplesQuickDir;
    if FileBrowser.FileExt = 'vto' then FileBrowser.CurrentDir := OrnamentsQuickDir;
  end;

  FileBrowser.InitDir;
end;


procedure TDriveSelect.MyDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  MenuText: String;
  Bitmap: TBitmap;

begin
  MenuText := Items[Index];
  Bitmap := TBitmap.Create;
  Bitmap.Transparent := True;

  try

    if MenuText = '' then
      // do nothing
    else if (MenuText = '*Samples') or (MenuText = '*Ornaments') then begin
      MainForm.ImageList1.GetBitmap(46, Bitmap);  // Home folder icon
      MenuText := RightStr(MenuText, Length(MenuText)-1);
    end
    else if MenuText[2] <> ':' then
      MainForm.ImageList1.GetBitmap(47, Bitmap)   // User quick access folder icon
    else
      MainForm.ImageList1.GetBitmap(45, Bitmap);  // Disk drive icon

    with Canvas do begin

      if odSelected in State then
      begin
        Brush.Color := CSamOrnSelBackground;
        Font.Color  := CSamOrnSelLineNum;
      end
      else
        Canvas.Font.Color := CSamOrnSelText;

      FillRect(Rect);
      if (Bitmap.Handle <> 0) and (MenuText <> '') then
        Draw(Rect.Left + 2, Rect.Top, Bitmap);

      Rect := Bounds(
        Rect.Left + ItemHeight + 6,
        Rect.Top,
        Rect.Right - Rect.Left,
        Rect.Bottom - Rect.Top
      );

      Canvas.Font.Color := CSamOrnSelText;
      DrawText(
        handle,
        PChar(MenuText),
        length(MenuText),
        Rect,
        DT_VCENTER + DT_SINGLELINE
      );

    end;

  finally
    Bitmap.Free;
  end;

end;


constructor TFileBrowser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  FilePath := TStringList.Create;
  DirPath := TStringList.Create;
  DontOpenItem := False;
  if Screen.Fonts.IndexOf('Arial') <> -1 then
    Font.Name := 'Arial'
  else if Screen.Fonts.IndexOf('Tahoma') <> -1 then
    Font.Name := 'Tahoma'
  else if Screen.Fonts.IndexOf('Verdana') <> -1 then
    Font.Name := 'Verdana'
  else if Screen.Fonts.IndexOf('Verdana') <> -1 then
    Font.Name := 'Consolas';
  Style := lbOwnerDrawFixed;
  Color := CSamOrnBackground;
  ControlStyle := ControlStyle + [csOpaque];
  DoubleBuffered := True;
  Hint     := '';
  ShowHint := True;
end;

destructor TFileBrowser.Destroy;
begin
  FilePath.Free;
  DirPath.Free;
  inherited;
end;

function TFileBrowser.GetSelectedIndex: Integer;
var i: Integer;
begin
  Result := -1;
  for i := 0 to Count-1 do
    if Selected[i] then
    begin
      Result := i;
      Break;
    end;
end;


function TFileBrowser.GetSelectedFileName: String;
var res: Integer;
begin
  Result := '';
  res := GetSelectedIndex;
  if res = -1 then Exit;
  Result := Items[res];
end;


function TFileBrowser.GetSelectedFullPath: String;
var
  i: Integer;
  FileName: String;
begin
  Result := '';
  FileName := GetSelectedFileName;

  if FileName[1] <> '[' then
    for i := 0 to FilePath.Count-1 do
      if FileName = ExtractFileName(FilePath[i]) then
      begin
        Result := FilePath[i];
        Exit;
      end;

  if FileName = '[..]' then begin
    if GetDirName(CurrentDir) <> '' then
      Result := CurrentDir;
    Exit;
  end;

  if FileName[1] = '[' then begin
    FileName := AnsiMidStr(FileName, 2, Length(FileName)-2);
    for i := 0 to DirPath.Count-1 do
      if FileName = GetDirName(DirPath[i]) then
      begin
        Result := DirPath[i];
        Exit;
      end;
  end;
end;


function TFileBrowser.InHomeDir: Boolean;
var Dir: String;
begin
  if FileExt = 'vts' then Dir := SamplesDefaultDir;
  if FileExt = 'vto' then Dir := OrnamentsDefaultDir;
  Result := AnsiContainsText(ExpandFileName(CurrentDir), ExpandFileName(VortexDocumentsDir + Dir));
end;


function TFileBrowser.InDir(DirPath: String): Boolean;
begin
  Result := AnsiContainsText(ExpandFileName(CurrentDir), ExpandFileName(DirPath));
end;

function TFileBrowser.GetIndex(Value: String): Integer;
var i: Integer;
begin
  Result := -1;
  for i := 0 to Items.Count-1 do
    if Items[i] = Value then begin
      Result := i;
      Break;
    end;
end;


function TFileBrowser.PathNotFound(FullPath: String; IsFile: Boolean): Boolean;
var NewDir: String;
begin
  Result := False;

  // File is not found
  if IsFile and not FileExists(FullPath) then begin
    Result := True;
    if PathNotFound(ExtractFileDir(FullPath), False) then
      Exit
    else begin
      Application.MessageBox(PChar('File "'+ FullPath +'" is not found.'), 'Vortex Tracker', MB_OK + MB_ICONSTOP + MB_TOPMOST);
      InitDir;
    end;
  end;

  // Directory is not found
  if not IsFile and not DirectoryExists(FullPath) then begin
    Result := True;
    Application.MessageBox(PChar('Directory "'+ FullPath +'" is not found.'), 'Vortex Tracker', MB_OK + MB_ICONSTOP + MB_TOPMOST);

    if FileExt = 'vts' then NewDir := VortexDocumentsDir + SamplesDefaultDir;
    if FileExt = 'vto' then NewDir := VortexDocumentsDir + OrnamentsDefaultDir;

    if DirectoryExists(NewDir) then begin
      CurrentDir := NewDir;
      InitDir;
      Exit;
    end;

    CurrentDir := 'C:\';
    InitDir;
  end;
end;

procedure TFileBrowser.GetDriveLetters(AList: TStrings);
var
  vDrivesSize: Cardinal;
  vDrives	: array[0..128] of Char;
  vDrive	 : PChar;
begin
  AList.BeginUpdate;
  try
    // clear the list from possible leftover from prior operations
    AList.Clear;
    vDrivesSize := GetLogicalDriveStrings(SizeOf(vDrives), vDrives);
    if vDrivesSize=0 then Exit; // no drive found, no further processing needed

    vDrive := vDrives;
    while vDrive^ <> #0 do
    begin
      AList.Add(StrPas(vDrive));
      Inc(vDrive, SizeOf(vDrive));
    end;
  finally
	AList.EndUpdate;
  end;
end;


procedure TFileBrowser.InitDir;
begin
  if (CurrentDir <> '') and PathNotFound(CurrentDir, False) then Exit;
  ReadDir;
  Selected[0] := True;
  DriveSelectBox.FillDiskDrives;
end;


procedure TFileBrowser.ReadDir;
const
  SysDirs: array[0..8] of String =
    (
      '$RECYCLE.BIN',
      'SYSTEM VOLUME INFORMATION',
      'WINDOWS',
      'PROGRAM FILES',
      'PROGRAM FILES (X86)',
      'RECOVERY',
      'PROGRAMDATA',
      '.TRASHES',
      '.TEMPORARYITEMS'
    );

var
  i: Integer;
  SR: TSearchRec;
  IsFound: Boolean;
  DrivesList: TStringList;

begin
  Clear;
  DirPath.Clear;
  FilePath.Clear;
  DirPath.Sorted := True;
  FilePath.Sorted := True;

  // Show drives
  if CurrentDir = '' then
  begin
    DirPath.Sorted := False;
    DrivesList := TStringList.Create;
    GetDriveLetters(DrivesList);
    for i := 0 to DrivesList.Count-1 do
    begin
      DirPath.Add(DrivesList.Strings[i]);
      Items.Append('['+ DrivesList.Strings[i][1] +':]');
    end;
    DrivesList.Free;

    if FileExt = 'vts' then begin

      if DirectoryExists(VortexDocumentsDir + SamplesDefaultDir) then begin
        DirPath.Add(VortexDocumentsDir + SamplesDefaultDir);
        Items.Append('[Samples]');
      end;

      if (SamplesQuickDir <> '') and DirectoryExists(SamplesQuickDir) then begin
        DirPath.Add(SamplesQuickDir);
        Items.Append('['+ GetDirName(SamplesQuickDir) +']');
      end;
    end
    else begin
      if DirectoryExists(VortexDocumentsDir + OrnamentsDefaultDir) then begin
        DirPath.Add(VortexDocumentsDir + OrnamentsDefaultDir);
        Items.Append('[Ornaments]');
      end;

      if (OrnamentsQuickDir <> '') and DirectoryExists(OrnamentsQuickDir) then begin
        DirPath.Add(OrnamentsQuickDir);
        Items.Append('['+ GetDirName(OrnamentsQuickDir) +']');
      end;
    end;

    Exit;
  end;

  CurrentDir := ExpandFileName(CurrentDir);
  if CurrentDir[length(CurrentDir)] <> '\' then
    CurrentDir := CurrentDir + '\';

  // Scan directories
  IsFound := FindFirst(CurrentDir + '*.*', faAnyFile, SR) = 0;
  while IsFound do
  begin
    if SR.Name = '..' then
    begin
      IsFound := FindNext(SR) = 0;
      Continue;
    end;

    if ((SR.Attr and faDirectory) <> 0)
       and (SR.Name <> '.')
       and (AnsiIndexText(AnsiUpperCase(SR.Name), SysDirs) = -1)
       and not NtfsIsFolderMountPoint(CurrentDir + SR.Name)
    then
      DirPath.Add(CurrentDir + SR.Name);

    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Scan files
  IsFound := FindFirst(CurrentDir + '*.' + FileExt, faAnyFile, SR) = 0;
  while IsFound do
  begin
    FilePath.Add(CurrentDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  Items.Append('[..]');

  // Fill directories
  for i := 0 to DirPath.Count-1 do
    Items.Append('['+ GetDirName(DirPath[i]) +']');

  // Fill files
  for i := 0 to FilePath.Count-1 do
    Items.Append(ExtractFileName(FilePath[i]));

    
  // Remember directory
  if (FileExt = 'vts') then begin
    if StrPos(PChar(CurrentDir), PChar(SamplesDefaultDir)) = nil then
      MainForm.SamplesDir := CurrentDir
    else
      MainForm.SamplesDir := VortexDocumentsDir + SamplesDefaultDir;
    TMDIChild(ParentWin).SamplesDir := MainForm.SamplesDir;
  end;

  if (FileExt = 'vto') then begin
    if StrPos(PChar(CurrentDir), PChar(OrnamentsDefaultDir)) = nil then
      MainForm.OrnamentsDir := CurrentDir
    else
      MainForm.OrnamentsDir := VortexDocumentsDir + OrnamentsDefaultDir;
    TMDIChild(ParentWin).OrnamentsDir := MainForm.OrnamentsDir;
  end;
end;


procedure TFileBrowser.MyDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var ClearRect: TRect;
begin
  // Draw directory
  if Items[Index][1] = '[' then
    Canvas.Font.Style := [fsBold]

  // Draw filename
  else
    Canvas.Font.Style := [];

  Color := CSamOrnBackground;

  // Fill background under last item
  if Index = Items.Count-1 then begin
    ClearRect := Rect;
    ClearRect.Bottom := Rect.Bottom + (Rect.Bottom - Rect.Top);
    Canvas.Brush.Color := CSamOrnBackground;
    Canvas.FillRect(ClearRect);
  end;

  Canvas.Brush.Style := bsSolid;
  if odSelected in State then
  begin
    Canvas.Brush.Color := CSamOrnSelBackground;
    Canvas.Font.Color  := CSamOrnSelLineNum;
  end
  else
    Canvas.Font.Color := CSamOrnSelText;

  Canvas.FillRect(Rect);
  Canvas.Brush.Style := bsClear;
  Canvas.TextOut(Rect.Left + 2, Rect.Top, Items[Index]);

end;

procedure TFileBrowser.OpenItem(Key: Byte; Preview: Boolean=False);
var
  i: Integer;
  Item, NewDir, FullPath: String;
begin

  if DontOpenItem then begin
    DontOpenItem := False;
    Exit;
  end;

  // Get selected item index
  Item := GetSelectedFileName;
  if Item = '' then Exit;

  if PreviewPlaying and Preview and (Item[1] <> '[') then
    TMDIChild(ParentWin).StopPlayTimer.Enabled := False;

  // Open folder
  if (Item[1] = '[') and (Item[Length(Item)] = ']') and (Key = 13) then begin
    if Preview then Exit;

    if Item = '[..]' then
    begin
      NewDir := ExpandFileName(CurrentDir + '..');

      // Drive letter 'C:\'
      if (Length(NewDir) = 3) and (NewDir[2] = ':') and (NewDir = CurrentDir) then
        CurrentDir := ''
      else
        CurrentDir := NewDir;
    end
    else
    begin
      NewDir := AnsiMidStr(Item, 2, Length(Item)-2);

      if (Length(NewDir) = 2) and (NewDir[2] = ':') then // C:
        CurrentDir := NewDir + '\'
      else
      for i := 0 to DirPath.Count-1 do
        if GetDirName(DirPath[i]) = NewDir then
        begin
          CurrentDir := DirPath[i];
          Break;
        end;

    end;

    InitDir;
  end

  
  // Open instrument
  else if ExtractFileExt(Item) = '.'+FileExt then begin
    FullPath := GetSelectedFullPath;
    if PathNotFound(FullPath, True) then begin
      TMDIChild(ParentWin).StopAndRestoreControls;
      Exit;
    end;

    if FileExt = 'vts' then begin
      if Preview then
        TMDIChild(ParentWin).LoadSample(FullPath, PreviewSamNum)
      else
        TMDIChild(ParentWin).LoadSample(FullPath);
    end
    else if FileExt = 'vto' then begin
      if Preview then
        TMDIChild(ParentWin).LoadOrnament(FullPath, PreviewOrnNum)
      else
        TMDIChild(ParentWin).LoadOrnament(FullPath);
    end
    else
      Exit;


    PreviewPlaying := Preview;
    if Preview then begin
      if FileExt = 'vts' then begin
        TMDIChild(ParentWin).SampleTestLine.Preview := True;
        TMDIChild(ParentWin).SampleTestLine.PlayCurrentNote;
      end
      else begin
        TMDIChild(ParentWin).OrnamentTestLine.Preview := True;
        TMDIChild(ParentWin).OrnamentTestLine.PlayCurrentNote;
      end;
      TMDIChild(ParentWin).StopPlayTimer.Enabled := True;
    end;

  end;

end;

procedure TFileBrowser.MyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  APoint: TPoint;
  Index: Integer;
  FirstChar: Char;
begin
  if Shift <> [ssRight] then Exit;
  if CurrentDir = '' then Exit;

  FirstChar := '[';
  APoint.X  := X;
  APoint.Y  := Y;

  Index := ItemAtPos(APoint, True);
  if Index <> -1 then begin
    Selected[Index] := True;
    FirstChar := Items[Index][1];
  end;

  with TMDIChild(ParentWin) do begin
    FBRename.Visible := FirstChar <> '[';
    FBDelete.Visible := FBRename.Visible;
    FBSetQuickAccess.Visible := (FirstChar = '[') and (Index <> -1);
    if FileExt = 'vts' then FBSaveInstrument.Caption := 'Save sample here';
    if FileExt = 'vto' then FBSaveInstrument.Caption := 'Save ornament here';    
  end;

  GetCursorPos(APoint);
  TMDIChild(ParentWin).FileBrowserPopup.Popup(APoint.X, APoint.Y);
end;

procedure TFileBrowser.MyClick(Sender: TObject);
begin
  OpenItem(13, True);
end;

procedure TFileBrowser.MyDblClick(Sender: TObject);
begin
  OpenItem(13);
end;

procedure TFileBrowser.MyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_LEFT then
    Selected[0] := True
  else
  if Key = VK_RIGHT then
  begin
    Selected[Count-1] := True;
    if Items[Count-1][1] <> '[' then
      OpenItem(13, True);
  end;
end;

procedure TFileBrowser.MyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    OpenItem(Key);
end;


procedure TFileBrowser.MyMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var
  Index: Integer;
  Point: TPoint;
begin

  Point.X := X;
  Point.Y := Y;
  Index := ItemAtPos(Point, True);
  if Index = -1 then begin
    Application.CancelHint;
    Exit;
  end;

  if Canvas.TextWidth(Items[Index]) > Width - VScrollbarSize then begin
    if Hint <> Items[Index] then Application.CancelHint;
    Hint := Items[Index];
  end
  else
    Application.CancelHint;

end;



procedure TMDIChild.CMDialogKey(var msg: TCMDialogKey);
begin
  if msg.Charcode <> VK_TAB then
    inherited;
end;

procedure TMDIChild.WMSysCommand;
begin

  if MainForm.SnapedToRight and (Msg.CmdType <> SC_CLOSE) then Exit;

  if (MainForm.MDIChildCount = 2) and (TMDIChild(MainForm.MDIChildren[0]).TSWindow <> nil) and (Msg.CmdType <> SC_CLOSE) then
    exit;

  if (msg.CmdType = SC_RESTORE) or (msg.CmdType = SC_MAXIMIZE) then
    exit;

  if (msg.CmdType = 61447) or (msg.CmdType = 61444) or (msg.CmdType = 61441) then
    exit;

  inherited;

end;





procedure TMDIChild.WMWindowPosChanged(var Message: TWMWindowPosChanged);
var
  NewSize: TSize;

begin

  if ChildsEventsBlocked or ((Left = Message.WindowPos.x) and (Top = Message.WindowPos.y)) then begin
    inherited;
    Exit;
  end;

  inherited;

  // Drag turbosound window too
  if TSWindow <> nil then begin
    ChildsEventsBlocked := True;

    TSWindow.Top  := Top;
    if TSWindow.Left > Left then
      TSWindow.Left := Left + Width
    else
      TSWindow.Left := Left - Width;

    ChildsEventsBlocked := False;
  end;


  if (MainForm.WindowState = wsNormal) then with MainForm do begin

    NewSize := GetSizeForChilds(WindowState, True);
    if (NewSize.Width <> ClientWidth) or (NewSize.Height <> ClientHeight) then begin

      RedrawOff;
      SetWindowSize(NewSize);
      AutoToolBarPosition(NewSize);
      RedrawOn;

    end;

  end

end;


procedure TMDIChild.WMEraseBkGnd(var Message:TMessage);
begin
  Message.Result := 0;
end;


procedure TMDIChild.WMSysChar(var Message: TWMSysChar);
begin
  if Message.CharCode = VK_MENU then
    OnClick(Self)
  else
    inherited;
end;

function TMDIChild.IsMouseOverControl(const Ctrl: TControl): Boolean;
var
  MyPoint: TPoint;
  MyRect: TRect;
begin

  MyPoint := Ctrl.ScreenToClient(Mouse.CursorPos);
  if (Ctrl is TScrollBox) then begin
    MyRect := Ctrl.ClientRect;
    MyRect.Bottom := MyRect.Bottom + HScrollbarSize;
    Result := PtInRect(MyRect, MyPoint);
  end
  else
    Result := PtInRect(Ctrl.ClientRect, MyPoint);
end;

function TMDIChild.BorderSize: Integer;
const Value: Integer = 0;
begin
  if Value = 0 then Value := Width - ClientWidth;
  Result := Value;
end;


function TMDIChild.OuterHeight: Integer;
const Value: Integer = 0;
begin
  if Value = 0 then Value := Height - ClientHeight;
  Result := Value;
end;


procedure TMDIChild.SetWidth(Value: Integer; Fixed: Boolean);
begin

  ClientWidth := Value;
  if not Fixed then Exit;

  Constraints.MaxWidth := Value + BorderSize;
  Constraints.MinWidth := Value + BorderSize;

end;


procedure TMDIChild.RefreshPositionsHScroll;
var
  ScrollPos: Integer;
begin
  ScrollPos := PositionsScrollBox.HorzScrollBar.Position;
  PositionsScrollBox.HorzScrollBar.Visible := False;
  PositionsScrollBox.HorzScrollBar.Visible := True;
  PositionsScrollBox.HorzScrollBar.Position := ScrollPos;
end;



procedure TMDIChild.RememberChannelsPosition;
begin

  with xc[0] do
  begin
    BoxLeft      := Channel1Box.Left;
    BoxWidth     := Channel1Box.Width;
    ButtonWidth  := SpeedButton1.Width;
    ToneLeft     := SpeedButton2.Left;
    NoiseLeft    := SpeedButton3.Left;
    EnvelopeLeft := SpeedButton4.Left;
    SoloLeft     := SpeedButton13.Left;
  end;

  with xc[1] do
  begin
    BoxLeft      := Channel2Box.Left;
    BoxWidth     := Channel2Box.Width;
    ButtonWidth  := SpeedButton5.Width;
    ToneLeft     := SpeedButton6.Left;
    NoiseLeft    := SpeedButton7.Left;
    EnvelopeLeft := SpeedButton8.Left;
    SoloLeft     := SpeedButton14.Left;
  end;

  with xc[2] do
  begin
    BoxLeft      := Channel3Box.Left;
    BoxWidth     := Channel3Box.Width;
    ButtonWidth  := SpeedButton9.Width;
    ToneLeft     := SpeedButton10.Left;
    NoiseLeft    := SpeedButton11.Left;
    EnvelopeLeft := SpeedButton12.Left;
    SoloLeft     := SpeedButton15.Left;
  end;

end;


procedure TMDIChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //?
  if IsPlaying and ((PlayingWindow[1] = Self) or ((NumberOfSoundChips > 1) and (PlayingWindow[2] = Self))) then
  begin
    StopPlaying;
    MainForm.RestoreControls;
  end;
  //MainForm.DeleteWindowListItem(Self);
  MainForm.Caption := AppName +' '+ VersionString;
  //?
  //VTMP := nil;
  Action := caFree;
end;

function TMDIChild.GetBackupVersionCounter: Integer;
var
  s, FilePath: String;
  i: Integer;
begin
  if IsDemosong then
  begin
    Result := 0;
    Exit;
  end;

  Result := 1;
  if WinFileName = '' then Exit;
  FilePath := WinFileName;

  // Is backup file opened?
  if AnsiContainsText(WinFileName, ' ver ') then
  begin
    // cut ' ver 001.vt2'
    FilePath := AnsiLeftStr(WinFileName, AnsiPos(' ver ', WinFileName)-1);
  end;

  for i := 1 to 10000 do
  begin
    s := ExtractFileDir(FilePath) + '\' + ExtractFileNameEX(FilePath) +
         ' ver ' + Format('%.3d', [i]) + '.vt2';
    if not FileExists(s) then
    begin
      Result := i;
      Exit;
    end;
  end;

end;


function TMDIChild.ModuleInPlayingWindow: Boolean;
begin
  if PlayingWindow[2] <> nil then
    Result := (PlayingWindow[2] = Self) or (PlayingWindow[2].TSWindow = Self)
  else
    Result := PlayingWindow[1] = Self;
end;

procedure TMDIChild.SetModuleFreq;
begin
  if not IsPlaying or ModuleInPlayingWindow then Exit;
  StopPlaying;
  SetAYFreq(VTMP.ChipFreq);
  SetIntFreq(VTMP.IntFreq);
end;


procedure TMDIChild.FormCreate(Sender: TObject);
var
  i: Integer;
  sel: TGridRect;

begin

  InitFinished := False;
  IsTemplate := SetChildAsTemplate;

  if MainForm.MDIChildCount > 1 then
    BorderStyle := bsSizeable
  else
    BorderStyle := bsSingle;

  PageControl1.ActivePageIndex := 0;
  LeftModule := True;
  AutoScroll := False;
  AutoSize := False;
  LastWidth := 0;
  LastHeight := 0;
  ControlStyle := ControlStyle + [csOpaque];
  IsSinchronizing := False;
  TSWindow := nil;
  WinFileName  := '';
  SamplesDir   := MainForm.SamplesDir;
  OrnamentsDir := MainForm.OrnamentsDir;
  SavedAsText := True;
  UndoWorking := True;
  ChangeCount := 0;
  ChangeTop := 0;
  SetLength(ChangeList, 64);
  OrGenRunning := False;
  NewVTMP(VTMP);
  PatternNumUpDown.Max := MaxPatNum;
  PatternLenUpDown.Max := MaxPatLen;
  AutoStepUpDown.Max := MaxPatLen;
  AutoStepUpDown.Min := -MaxPatLen;
  UpDown15.Max := MaxPatLen;
  SampleLenUpDown.Max := MaxSamLen;
  SampleLoopUpDown.Max := MaxSamLen - 1;
  OrnamentLenUpDown.Max := MaxOrnLen;
  OrnamentLoopUpDown.Max := MaxOrnLen - 1;
  VtmFeaturesGrp.ItemIndex := FeaturesLevel;
  SaveHead.ItemIndex := Ord(not VortexModuleHeader);
  TrackOptsScrollBox.BorderStyle := bsNone;

  StringGrid1.Cells[0, 0] := 'L0';
  PatNum := 0;
  SamNum := 1;
  OrnNum := 1;
  PositionNumber := 0;
  PosBegin := 0;
  LineInts := 0;
  PosDelay := VTMP.Initial_Delay;
  TotInts := 0;
  AutoEnv := False;
  StdAutoEnvIndex := 0;
  AutoEnv0 := 1;
  AutoEnv1 := 1;
  AutoStep := False;

  CreateTracks;
  CreateTestLines;
  CreateSamples;
  CreateOrnaments;

  Tracks.TabOrder := 0;
  Tracks.PopupMenu := MainForm.PopupMenu2;
  Samples.TabOrder := 0;
  SampleTestLine.TabOrder := 6;
  Ornaments.TabOrder := 0;
  OrnamentTestLine.TabOrder := 6;

  FBRename.Bitmap.Transparent := True;
  FBSetQuickAccess.Bitmap.Transparent := True;
  FBNewFolder.Bitmap.Transparent := True;
  FBDelete.Bitmap.Transparent := True;
  FBSaveInstrument.Bitmap.Transparent := True;
  MainForm.ImageList1.GetBitmap(48, FBRename.Bitmap);
  MainForm.ImageList1.GetBitmap(49, FBSetQuickAccess.Bitmap);
  MainForm.ImageList1.GetBitmap(50, FBNewFolder.Bitmap);
  MainForm.ImageList1.GetBitmap(51, FBDelete.Bitmap);
  MainForm.ImageList1.GetBitmap(52, FBSaveInstrument.Bitmap);

  DuplicateNoteParams.Checked := DupNoteParams;
  BetweenPatterns.Checked := MoveBetweenPatrns;
  UpDown4.Position := MainForm.DefaultTable;

  PatternNumEdit.Text := IntToStr(PatNum);
  if DecBaseLinesOn then
  begin
    PatternLenEdit.Text  := IntToStr(PatternLenUpDown.Position);
  end
  else
  begin
    PatternLenEdit.Text   := IntToHex(PatternLenUpDown.Position, 2);
    SampleLenEdit.Text    := '01';
    OrnamentLenEdit.Text  := '01';
    SampleLoopEdit.Text   := '00';
    OrnamentLoopEdit.Text := '00';
  end;
  SampleNumEdit.Text   := IntToStr(SamNum);
  OrnamentNumEdit.Text := IntToStr(OrnNum);

  if DrawOffAfterClose then
    MainForm.RedrawOff;

  WidthChanged := True;
  HeightChanged := True;

  PrepareForm;
  AutoResizeForm;

  UndoWorking := False;
  SongChanged := False;
  BackupSongChanged := False;
  UpdateSpeedBPM;
  ShowStat;


  sel.Left := 1;
  sel.Right := 6;
  sel.Top := 0;
  sel.Bottom := 0;
  StringGrid1.Selection := sel;
  
  SamToneShiftAsNoteOpt.Checked := SamToneShiftAsNote;
  OrnToneShiftAsNoteOpt.Checked := OrnToneShiftAsNote;
  UpdateSamToneShiftControls;
  UpdateOrnToneShiftControls;

  // Prevent to flickering some controls
  DoubleBuffered := True;
  SampleBox.DoubleBuffered := True;
  UnloopBtn.DoubleBuffered := True;
  ClearSample.DoubleBuffered := True;
  SampleNumEdit.DoubleBuffered := True;
  SampleLenUpDown.DoubleBuffered := True;
  SampleLenEdit.DoubleBuffered := True;
  SampleLoopEdit.DoubleBuffered := True;
  SampleLoopUpDown.DoubleBuffered := True;
  SampleNumUpDown.DoubleBuffered := True;
  LoadSampleBtn.DoubleBuffered := True;
  SaveSampleBtn.DoubleBuffered := True;
  HideSamBrowserBtn.DoubleBuffered := True;
  PrevSampleBtn.DoubleBuffered := True;
  NextSampleBtn.DoubleBuffered := True;
  NextPrevSampleBox.DoubleBuffered := True;
  SamplesTestFieldBox.DoubleBuffered := True;
  PatOptions.DoubleBuffered := True;
  SpeedBox.DoubleBuffered := True;
  SampleLenUpDown.DoubleBuffered := True;
  OctaveBox.DoubleBuffered := True;
  AutoStepBox.DoubleBuffered := True;
  AutoEnvBox.DoubleBuffered := True;
  OctaveUpDown.DoubleBuffered := True;
  AutoStepUpDown.DoubleBuffered := True;
  SpeedBpmUpDown.DoubleBuffered := True;
  SampleLenUpDown.DoubleBuffered := True;
  StringGrid1.DoubleBuffered := True;
  AutoHLBox.DoubleBuffered := True;
  Channel1Box.DoubleBuffered := True;
  Channel2Box.DoubleBuffered := True;
  Channel3Box.DoubleBuffered := True;
  PatternNumUpDown.DoubleBuffered := True;
  PatternLenUpDown.DoubleBuffered := True;
  PatternNumEdit.DoubleBuffered := True;
  PatternLenEdit.DoubleBuffered := True;
  SpeedBpmEdit.DoubleBuffered := True;
  OctaveEdit.DoubleBuffered := True;
  AutoStepEdit.DoubleBuffered := True;
  InterfaceOpts.DoubleBuffered := True;
  PageControl1.DoubleBuffered := True;
  Edit4.DoubleBuffered := True;
  Edit3.DoubleBuffered := True;
  EnvelopeAsNoteOpt.DoubleBuffered := True;
  DuplicateNoteParams.DoubleBuffered := True;
  BetweenPatterns.DoubleBuffered := True;
  UpDown15.DoubleBuffered := True;
  Edit17.DoubleBuffered := True;
  SampleEditBox.DoubleBuffered := True;
  SampleBrowserBox.DoubleBuffered := True;
  OrnamentBox.DoubleBuffered := True;
  OrnamentsBrowserBox.DoubleBuffered := True;
  OrnamentsTestFieldBox.DoubleBuffered := True;
  OrnamentEditBox.DoubleBuffered := True;
  OrnamentNumEdit.DoubleBuffered := True;
  OrnamentNumUpDown.DoubleBuffered := True;
  OrnamentLenEdit.DoubleBuffered := True;
  OrnamentLenUpDown.DoubleBuffered := True;
  OrnamentLoopEdit.DoubleBuffered := True;
  OrnamentLoopUpDown.DoubleBuffered := True;
  ClearOrnBut.DoubleBuffered := True;
  LoadOrnamentBtn.DoubleBuffered := True;
  SaveOrnamentBtn.DoubleBuffered := True;
  ShowOrnBrowserBtn.DoubleBuffered := True;
  HideOrnBrowserBtn.DoubleBuffered := True;
  PrevOrnBtn.DoubleBuffered := True;
  NextOrnBtn.DoubleBuffered := True;
  NextPrevOrnBox.DoubleBuffered := True;
  VtmFeaturesGrp.DoubleBuffered := True;
  SaveHead.DoubleBuffered := True;
  Edit7.DoubleBuffered := True;
  UpDown4.DoubleBuffered := True;
  PatEmptyBox.DoubleBuffered := True;
  PositionsScrollBox.DoubleBuffered := True;
  TrackInfoBox.DoubleBuffered := True;
  SampleOpts.DoubleBuffered := True;
  SamToneShiftAsNoteOpt.DoubleBuffered := True;
  SamOctaveNum.DoubleBuffered := True;
  OrnamentOpts.DoubleBuffered := True;
  OrnToneShiftAsNoteOpt.DoubleBuffered := True;
  OrnOctaveNum.DoubleBuffered := True;
  TrackChipFreq.DoubleBuffered := True;
  ManualHz.DoubleBuffered := True;
  for i := 0 to TrackChipFreq.Items.Count - 1 do
    TrackChipFreq.Buttons[i].DoubleBuffered := True;
  TrackOptsScrollBox.DoubleBuffered := True;
  TrackIntSel.DoubleBuffered := True;
  for i := 0 to TrackIntSel.Items.Count - 1 do
    TrackIntSel.Buttons[i].DoubleBuffered := True;
  TrackInfoGB.DoubleBuffered := True;
  ShowInfoOnLoad.DoubleBuffered := True;
  EditPanel.DoubleBuffered := True;
  ToneTableBox.DoubleBuffered := True;
  JoinTracksBox.DoubleBuffered := True;

end;

function TMDIChild.GetPositionNumber;
begin
  Result := PositionNumber;
end;

procedure TMDIChild.ResizeChannelsBox;
begin

  AutoHLBox.Width := Tracks.Sep3X - AutoHLBox.Left + 3;
  UpDown15.Left := AutoHLBox.Width - UpDown15.Width - 5;
  Edit17.Left   := UpDown15.Left - Edit17.Width;
  AutoHL.Left  := 5;
  AutoHL.Width := Edit17.Left - AutoHL.Left - 2 ;


  // Channel A
  Channel1Box.Left := Tracks.Sep3X + 4;
  Channel1Box.Width := Tracks.Sep4X - Tracks.Sep3X - 1; 

  SpeedButton13.Left := Channel1Box.Width - SpeedButton13.Width - 5;   // Channel A: Solo button
  SpeedButton4.Left  := SpeedButton13.Left - SpeedButton4.Width + 1;   // Channel A: Envelope button
  SpeedButton3.Left  := SpeedButton4.Left - SpeedButton3.Width + 1;    // Channel A: Noise button
  SpeedButton2.Left  := SpeedButton3.Left - SpeedButton2.Width + 1;    // Channel A: Tone button

  // Channel A Button
  SpeedButton1.Left := 4;
  SpeedButton1.Width := SpeedButton2.Left - SpeedButton1.Left + 1;
  if SpeedButton1.Width > 67 then
    SpeedButton1.Caption := 'Channel A'
  else if SpeedButton1.Width < 43 then
    SpeedButton1.Caption := 'A'
  else
    SpeedButton1.Caption := 'Chan A';



  // Channel B Box
  Channel2Box.Left := Tracks.Sep4X + 4;
  Channel2Box.Width := Tracks.Sep5X - Tracks.Sep4X - 1;


  SpeedButton14.Left := Channel2Box.Width - SpeedButton14.Width - 5;   // Channel B: Solo button
  SpeedButton8.Left := SpeedButton14.Left - SpeedButton8.Width + 1;    // Channel B: Envelope button
  SpeedButton7.Left := SpeedButton8.Left - SpeedButton7.Width + 1;     // Channel B: Noise button
  SpeedButton6.Left := SpeedButton7.Left - SpeedButton6.Width + 1;     // Channel B: Tone button

  // Channel B Button
  SpeedButton5.Left := 4;
  SpeedButton5.Width := SpeedButton6.Left - SpeedButton5.Left + 1;
  if SpeedButton5.Width > 67 then
    SpeedButton5.Caption := 'Channel B'
  else if SpeedButton5.Width < 43 then
    SpeedButton5.Caption := 'B'
  else
    SpeedButton5.Caption := 'Chan B';


  // Channel C Box
  Channel3Box.Left := Tracks.Sep5X + 4;
  Channel3Box.Width := Tracks.PatWidth - Tracks.Sep5X;


  SpeedButton15.Left := Channel3Box.Width - SpeedButton15.Width - 5;    // Channel C: Solo button
  SpeedButton12.Left := SpeedButton15.Left - SpeedButton12.Width + 1;   // Channel C: Envelope button
  SpeedButton11.Left := SpeedButton12.Left - SpeedButton11.Width + 1;   // Channel C: Noise button
  SpeedButton10.Left := SpeedButton11.Left - SpeedButton10.Width + 1;   // Channel C: Tone button

  // Channel C Button
  SpeedButton9.Left := 4;
  SpeedButton9.Width := SpeedButton10.Left - SpeedButton9.Left + 1;
  if SpeedButton9.Width >= 67 then
    SpeedButton9.Caption := 'Channel C'
  else if SpeedButton9.Width < 43 then
    SpeedButton9.Caption := 'C'
  else
    SpeedButton9.Caption := 'Chan C';

end;

procedure TMDIChild.ResizeAutoStepEnvBox;
begin
  Exit;
  {if strict then
  begin
    AutoStepBtn.Width := AStepWidth; // AutoStep
    AutoEnvBtn.Width := AEnvWidth;  // AutoEnv
  end
  else
  begin
    AutoStepBtn.Width := Round(AStepWidth * x); // AutoStep
    AutoEnvBtn.Width := Round(AEnvWidth * x);  // AutoEnv
  end;

  //SpeedButton22.Margin := (SpeedButton22.Width div 8) - 9; // AutoStep
  //SpeedButton15.Margin := (SpeedButton15.Width div 8) - 9; // AutoEnv

  AutoEnvBtn.Left := AutoStepBtn.Left + AutoStepBtn.Width + BtnsMargin;  // AutoEnv

  AutoStepUpDown.Left := AutoStepBtn.Left + AutoStepBtn.Width - AutoStepUpDown.Width; // AStep updown
  AutoStepEdit.Width := AutoStepBtn.Width - AutoStepUpDown.Width; // AStep edit

  SpeedButton16.Width := Round(AutoEnvBtn.Width / b); // AEnv 1 btn
  SpeedButton17.Width := SpeedButton16.Width;          // AEnv 2 btn
  SpeedButton18.Width := SpeedButton16.Width;          // AEnv 3 btn

  SpeedButton16.Left := AutoEnvBtn.Left;            // AEnv 1 btn
  SpeedButton17.Left := (AutoEnvBtn.Width div 2) + AutoEnvBtn.Left - // AEnv 2 btn
    (SpeedButton17.Width div 2);
  SpeedButton18.Left := AutoEnvBtn.Width + AutoEnvBtn.Left - // AEnv 3 btn
    SpeedButton18.Width;

  SpeedButton16.Margin := (SpeedButton16.Width div 2) - 5;
  SpeedButton18.Margin := (SpeedButton16.Width div 2) - 5;

  AutoStepBox.Width := AutoEnvBtn.Width + AutoStepBtn.Width + (AutoStepBtn.Left * 2) + BtnsMargin;
  }
end;


procedure TMDIChild.FitSampleBox;
var
  spacer1, spacer2, spacer4: Integer;
  EditWidth: Integer;
begin

  spacer1 := SampleNumEdit.Top - (Label9.Top + Label9.Height); // Label -> EditBox vertical space
  spacer2 := spacer1 * 2;                              // EditBox -> Next Label vertical space
  spacer4 := SampleBox.Width div 20;
  
  // Controls width
  EditWidth := PrevSampleBtn.Width - spacer4;
  if PrevSampleBtn.Width < 60 then begin
    spacer4 := spacer4 - 2;
    EditWidth := PrevSampleBtn.Width - spacer4;
  end;

  // Sample number
  SampleNumEdit.Width := EditWidth - SampleNumUpDown.Width;
  SampleNumUpDown.Left := SampleNumEdit.Left + SampleNumEdit.Width;

  // Length label
  Label10.Left := NextSampleBtn.Left + spacer4;
  Label10.Top := Label9.Top;

  // Length edit box
  SampleLenEdit.Left := Label10.Left;
  SampleLenEdit.Top := Label10.Top + Label10.Height + spacer1;
  SampleLenEdit.Width := SampleNumEdit.Width;
  SampleLenUpDown.Left := SampleLenEdit.Left + SampleLenEdit.Width;
  SampleLenUpDown.Top := SampleLenEdit.Top;

  // Loop label
  Label11.Top := SampleNumEdit.Top + SampleNumEdit.Height + spacer2;
  Label11.Left := Label9.Left;

  // Loop edit box
  SampleLoopEdit.Top := Label11.Top + Label11.Height + spacer1;
  SampleLoopEdit.Left := Label11.Left;
  SampleLoopEdit.Width := SampleNumEdit.Width;

  SampleLoopUpDown.Top := SampleLoopEdit.Top;
  SampleLoopUpDown.Left := SampleNumUpDown.Left;

  // Copy button
  CopySamBut.Left := SampleLenEdit.Left;
  CopySamBut.Top := SampleLenEdit.Top + SampleLenEdit.Height + spacer2;
  CopySamBut.Width := EditWidth;


  // Paste button
  PasteSamBut.Left := SampleLenEdit.Left;
  PasteSamBut.Top := CopySamBut.Top + CopySamBut.Height + 2;
  PasteSamBut.Width := EditWidth;


  // Unloop button
  UnloopBtn.Top := SampleLoopEdit.Top + SampleLoopEdit.Height + spacer2;
  UnloopBtn.Left := SampleLoopEdit.Left;
  UnloopBtn.Width  := EditWidth;

  // Clear button
  ClearSample.Top := UnloopBtn.Top;
  ClearSample.Left := PasteSamBut.Left;
  ClearSample.Width := EditWidth;


  SampleBox.Height := ClearSample.Top + ClearSample.Height + Label9.Top - 3;


end;


procedure TMDIChild.PrepareForm;
begin
  InitStringGridMetrix;

  PatEmptyBox.Width := 2500;
  TopBackgroundBox.Top := 0;

  // Channels box
  AutoHLBox.Top := PositionsScrollBox.Top + PositionsScrollBox.Height - 3;
  Channel1Box.Top := AutoHLBox.Top;
  Channel2Box.Top := AutoHLBox.Top;
  Channel3Box.Top := AutoHLBox.Top;
  Tracks.Top := AutoHLBox.Top + AutoHLBox.Height + 1;
  Tracks.Left := PositionsScrollBox.Left;

  TrackInfoBox.Left := -2;

  Samples.Left := 7;
  Samples.Top := 13;


  SampleEditBox.Left := 0;
  SampleEditBox.Top := SamplesTestFieldBox.Top + SamplesTestFieldBox.Height - 7;


  // Samples Testline
  LoadSampleBtn.Left := SampleTestLine.Left + SampleTestLine.Width + 7;
  SaveSampleBtn.Left := LoadSampleBtn.Left + LoadSampleBtn.Width + 4;
  LoadSampleBtn.Height := SampleTestLine.Height;
  SaveSampleBtn.Height := SampleTestLine.Height;


  SamplesDriveSelect.Top  := 14;
  SamplesDriveSelect.Left := 9;

  SamplesBrowser.Top  := SamplesDriveSelect.Top + SamplesDriveSelect.Height;
  SamplesBrowser.Left := SamplesDriveSelect.Left;

  ShowSamBrowserBtn.Top  := SamplesDriveSelect.Top;
  ShowSamBrowserBtn.Left := SamplesDriveSelect.Left;
  HideSamBrowserBtn.Left := SamplesBrowser.Left;


  Ornaments.Left := 7;
  Ornaments.Top  := 13;
  OrnamentBox.Top := NextPrevOrnBox.Top + NextPrevOrnBox.Height - 7;
  OrnamentsBrowserBox.Top := OrnamentBox.Top + OrnamentBox.Height - 7;

  OrnamentsDriveSelect.Top  := 14;
  OrnamentsDriveSelect.Left := 9;

  OrnamentsBrowser.Top    := OrnamentsDriveSelect.Top + OrnamentsDriveSelect.Height;
  OrnamentsBrowser.Left   := OrnamentsDriveSelect.Left;
  ShowOrnBrowserBtn.Top   := OrnamentsDriveSelect.Top;
  ShowOrnBrowserBtn.Left  := OrnamentsDriveSelect.Left;
  HideOrnBrowserBtn.Left  := OrnamentsBrowser.Left;


  // Testline
  LoadOrnamentBtn.Left := OrnamentTestLine.Left + OrnamentTestLine.Width + 7;
  SaveOrnamentBtn.Left := LoadOrnamentBtn.Left + LoadOrnamentBtn.Width + 4;
  LoadOrnamentBtn.Height := OrnamentTestLine.Height;
  SaveOrnamentBtn.Height := OrnamentTestLine.Height;


  ClientWidth := PageControl1.Width;
  ClientHeight := PageControl1.Height;

end;


procedure TMDIChild.AutoResizeForm;
var
  EditWidth, spacer: Integer;
  MainWidth, HalfWidth: Integer;
  SheetWidth, SheetHeight: Integer;

begin
  DisableAlign;
  SheetHeight := PatternsSheet.Height;
  ToolBoxesWidth := JoinTracksBox.Left + JoinTracksBox.Width + 6;

  InitSamplesMetrix;
  Ornaments.InitMetrix;


  // PageControl & tracks width
  PageControl1.Width := Tracks.Width + 8;
  if PageControl1.Width < ToolBoxesWidth then
    PageControl1.Width := ToolBoxesWidth;


  MainWidth := PageControl1.Width;
  HalfWidth := MainWidth div 2;
  SheetWidth := PatternsSheet.Width;

  if Tracks.Width < MainWidth then
    Tracks.Width := MainWidth - 8;

  WidthChanged := MainWidth <> LastWidth;


  if HeightChanged then begin

    AutoHLBox.Top   := PositionsScrollBox.Top + PositionsScrollBox.Height - 3;
    Channel1Box.Top := AutoHLBox.Top;
    Channel2Box.Top := AutoHLBox.Top;
    Channel3Box.Top := AutoHLBox.Top;

    Tracks.Top := AutoHLBox.Top + AutoHLBox.Height + 1;

    // ---- Patterns editor tab -----------
    Tracks.Height := SheetHeight - Tracks.Top - InterfaceOpts.Height;
    Tracks.FitNumberOfLines;
  end;

  
  if WidthChanged then begin

    TopBackgroundBox.Left  := PageControl1.Left;
    TopBackgroundBox.Width := PageControl1.ClientWidth;

    // Patterns positions
    PositionsScrollBox.Width := MainWidth - 10;
    InitStringGridMetrix;

    // Channels box
    ResizeChannelsBox;
    RememberChannelsPosition;

    // Interface options (Boottom box with checkboxes)
    InterfaceOpts.Width := MainWidth + 10;
    BetweenPatterns.Left := MainWidth - BetweenPatterns.Width;
    DuplicateNoteParams.Left := HalfWidth - (DuplicateNoteParams.Width div 2);

    // Trackname & Author
    TrackInfoBox.Width := MainWidth + 20;
    Edit3.Width := HalfWidth - Label6.Width - 2;
    Edit4.Width := Edit3.Width - 1;
    Edit4.Left := MainWidth - Edit4.Width - 6; // Patterns/Author input
    Label6.Left := HalfWidth - 8; // by


  end;


  if HeightChanged then begin
    TopBackgroundBox.Height  := PageControl1.Top;

    // Interface options (Boottom box with checkboxes)
    InterfaceOpts.Top := Tracks.Top + Tracks.Height;


    // ---- Samples editor tab ------------

    SampleBox.Top := NextPrevSampleBox.Top + NextPrevSampleBox.Height - 7;
    SampleOpts.Top := SheetHeight - SampleOpts.Height - 1;

    SampleEditBox.Height := SampleOpts.Top - SampleEditBox.Top + 7;
    Samples.Height := SampleEditBox.Height - Samples.Top - 8;

    Samples.NOfLines := Samples.Height div Samples.CelH;

  end;


  if WidthChanged then begin

    // Samples editor box
    SampleEditBox.Width := Samples.Width + (Samples.Left * 2);
    SamplesTestFieldBox.Width := SampleEditBox.Width;


    // Samples Test Field
    if SamplesTestFieldBox.Width < SaveSampleBtn.Left + SaveSampleBtn.Width then
    begin
      SamplesTestFieldBox.Width := SaveSampleBtn.Left + SaveSampleBtn.Width + 7;
      SampleEditBox.Width := SamplesTestFieldBox.Width;
      Samples.Width := SampleEditBox.Width - (Samples.Left*2);
    end;

    // PrevNextSample Box
    NextPrevSampleBox.Left  := SamplesTestFieldBox.Left + SamplesTestFieldBox.Width - 2;
    NextPrevSampleBox.Width := SheetWidth - SampleEditBox.Width;
    PrevSampleBtn.Left  := Label9.Left;
    PrevSampleBtn.Width := ((NextPrevSampleBox.Width - (PrevSampleBtn.Left * 2) )) div 2;
    NextSampleBtn.Left  := PrevSampleBtn.Left + PrevSampleBtn.Width;
    NextSampleBtn.Width := PrevSampleBtn.Width;

    // SampleBox: length, loop, copy to, clear
    SampleBox.Left := NextPrevSampleBox.Left;
    SampleBox.Width := NextPrevSampleBox.Width;
    FitSampleBox;

    // Sample browser box
    SampleBrowserBox.Left := SampleBox.Left;
    SampleBrowserBox.Width := SampleBox.Width;

    // Samples Browser
    SamplesBrowser.Width := SampleBrowserBox.Width - 19;

    // Show Sample Browser Button
    ShowSamBrowserBtn.Width := SamplesBrowser.Width;

    // Hide Sample Browser Button
    HideSamBrowserBtn.Width := SamplesBrowser.Width - 1;

    // Disk drive combo box
    SamplesDriveSelect.Width := SamplesBrowser.Width;

    // Bottom options
    SampleOpts.Width := SampleBrowserBox.Left + SampleBrowserBox.Width;
    RecalcTonesBtn.Left := SampleEditBox.Width - RecalcTonesBtn.Width - 8;
    SamOptsSep1.Left := RecalcTonesBtn.Left - 8;
  end;
  

  if HeightChanged then begin

    // Sample browser box
    SampleBrowserBox.Top := SampleBox.Top + SampleBox.Height - 7;
    SampleBrowserBox.Height := (SampleOpts.Top + SampleOpts.Height) - SampleBrowserBox.Top;

    // Samples Browser
    SamplesBrowser.Height := SampleBrowserBox.Height - SamplesBrowser.Top - HideSamBrowserBtn.Height - 10;

    // Hide Sample Browser Button
    HideSamBrowserBtn.Top := SamplesBrowser.Top + SamplesBrowser.Height + 2;

  end;


  // Visibility of samples browser and buttons
  SamplesBrowser.Visible      := MainForm.SampleBrowserVisible;
  SamplesDriveSelect.Visible  := SamplesBrowser.Visible;
  ShowSamBrowserBtn.Visible   := not SamplesBrowser.Visible;
  HideSamBrowserBtn.Visible   := SamplesBrowser.Visible;



  if HeightChanged then begin

    // ---- Ornaments -----
    OrnamentOpts.Top := SampleOpts.Top;
    OrnamentOpts.Height := SampleOpts.Height;

    OrnamentEditBox.Height := SampleEditBox.Height;

    Ornaments.Height := Samples.Height;
    Ornaments.NRaw := Samples.Height div Ornaments.CelH;
    Ornaments.NOfLines := OrnNCol * Ornaments.NRaw;

  end;


  if WidthChanged then begin

    // ---- Ornaments -----
    OrnamentEditBox.Width := Ornaments.Width + Ornaments.Left * 2;
    OrnamentsTestFieldBox.Width := OrnamentEditBox.Width;

    if OrnamentsTestFieldBox.Width < SaveOrnamentBtn.Left + SaveOrnamentBtn.Width + 10 then
    begin
      OrnamentsTestFieldBox.Width := SaveOrnamentBtn.Left + SaveOrnamentBtn.Width + 10;
      OrnamentEditBox.Width := OrnamentsTestFieldBox.Width;
      Ornaments.Width := OrnamentEditBox.Width - Ornaments.Left - Ornaments.Left;
    end;

    // Prev/Next ornament box
    NextPrevOrnBox.Left  := OrnamentsTestFieldBox.Width + OrnamentsTestFieldBox.Left - 2;
    NextPrevOrnBox.Width := SheetWidth - OrnamentEditBox.Width;
    PrevOrnBtn.Left  := Label31.Left;
    PrevOrnBtn.Width := (NextPrevOrnBox.Width - (PrevOrnBtn.Left*2)) div 2;

    if PrevOrnBtn.Width > 110 then PrevOrnBtn.Width := 110;


    NextOrnBtn.Left  := PrevOrnBtn.Left + PrevOrnBtn.Width;
    NextOrnBtn.Width := PrevOrnBtn.Width;


    // Ornament Box
    OrnamentBox.Left  := NextPrevOrnBox.Left;
    OrnamentBox.Width := NextPrevOrnBox.Width;

    spacer := (PrevOrnBtn.Width*2) div 18;
    EditWidth := NextOrnBtn.Width - spacer;
    OrnamentNumEdit.Width  := EditWidth - OrnamentNumUpDown.Width;
    OrnamentNumUpDown.Left := OrnamentNumEdit.Left + OrnamentNumEdit.Width;

    OrnamentLoopEdit.Width  := OrnamentNumEdit.Width;
    OrnamentLoopUpDown.Left := OrnamentNumUpDown.Left;

    Label29.Left := NextOrnBtn.Left + spacer;
    OrnamentLenEdit.Left   := Label29.Left;
    OrnamentLenEdit.Width  := OrnamentNumEdit.Width;
    OrnamentLenUpDown.Left := OrnamentLenEdit.Left + OrnamentLenEdit.Width;

    CopyOrnBut.Left   := Label29.Left;
    CopyOrnBut.Width  := EditWidth;
    PasteOrnBut.Left  := CopyOrnBut.Left;
    PasteOrnBut.Width := EditWidth;
    ClearOrnBut.Width := PasteOrnBut.Left + PasteOrnBut.Width - OrnamentLoopEdit.Left;


    OrnamentsBrowserBox.Left  := OrnamentBox.Left;
    OrnamentsBrowserBox.Width := OrnamentBox.Width;

    // Ornaments Browser
    OrnamentsBrowser.Width     := OrnamentsBrowserBox.Width - 19;
    if OrnamentsBrowser.Width > ClearOrnBut.Left + ClearOrnBut.Width then begin
      OrnamentsBrowser.Width := ClearOrnBut.Width;
      OrnamentsBrowser.Left  := ClearOrnBut.Left;
    end
    else
      OrnamentsBrowser.Left := 9;

    OrnamentsDriveSelect.Width := OrnamentsBrowser.Width;
    OrnamentsDriveSelect.Left  := OrnamentsBrowser.Left;



    // Show Ornaments Browser Button
    ShowOrnBrowserBtn.Width := OrnamentsBrowser.Width;
    ShowOrnBrowserBtn.Left  := OrnamentsBrowser.Left;

    // Hide Ornaments Browser Button
    HideOrnBrowserBtn.Width := OrnamentsBrowser.Width;
    HideOrnBrowserBtn.Left  := OrnamentsBrowser.Left;
    OrnamentOpts.Width      := OrnamentsBrowserBox.Left + OrnamentsBrowserBox.Width;


    // ------- OPTIONS TAB --------
    TrackOptsScrollBox.Width := OptTab.Width;

    TrackChipFreq.Width := TrackOptsScrollBox.ClientWidth - TrackChipFreq.Left - VScrollbarSize - 3;
    TrackIntSel.Width := TrackOptsScrollBox.ClientWidth - TrackIntSel.Left - VScrollbarSize - 3;

    VtmFeaturesGrp.Width := (TrackOptsScrollBox.ClientWidth div 2) - 9 - VtmFeaturesGrp.Left;
    SaveHead.Left := VtmFeaturesGrp.Left + VtmFeaturesGrp.Left + VtmFeaturesGrp.Width + 9;

    SaveHead.Width := TrackOptsScrollBox.ClientWidth - SaveHead.Left - VScrollbarSize - 3;
    ManualHz.Left := TrackChipFreq.Buttons[20].Left + 95;
    ManualIntFreq.Left := TrackIntSel.Buttons[6].Left + 95;


    // --- INFO TAB -------
    TrackInfoGB.Width := InfoTab.Width - (TrackInfoGB.Left*2);
    EditPanel.Width := TrackInfoGB.ClientWidth - (EditPanel.Left*2);

    ViewInfoBtn.Left := EditPanel.Left + EditPanel.Width - ViewInfoBtn.Width - 2;
  end;

  
  if HeightChanged then begin

    TrackOptsScrollBox.Height := OptTab.Height - TrackOptsScrollBox.Top;

    // Ornaments Browser Box
    OrnamentsBrowserBox.Top := OrnamentBox.Top + OrnamentBox.Height - 7;
    OrnamentsBrowserBox.Height := OrnamentOpts.Top + OrnamentOpts.Height - OrnamentsBrowserBox.Top;

    // Ornaments Browser
    OrnamentsBrowser.Top := SamplesBrowser.Top;
    OrnamentsBrowser.Height := SamplesBrowser.Height;

    // Hide Ornaments Browser Button
    HideOrnBrowserBtn.Top := HideSamBrowserBtn.Top;

    // --- INFO TAB -------
    TrackInfoGB.Height := InfoTab.Height - TrackInfoGB.Top - 1;
    EditPanel.Height := TrackInfoGB.ClientHeight - EditPanel.Top - EditPanel.Left;
  end;


  // Visibility of ornaments browser and buttons
  OrnamentsBrowser.Visible     := MainForm.OrnamentsBrowserVisible;
  OrnamentsDriveSelect.Visible := OrnamentsBrowser.Visible;
  ShowOrnBrowserBtn.Visible    := not OrnamentsBrowser.Visible;
  HideOrnBrowserBtn.Visible    := OrnamentsBrowser.Visible;

  LastWidth  := PageControl1.Width;
  LastHeight := PageControl1.Height;

  ResetChanAlloc;

  EnableAlign;

end;


function WhereIsChannel(Num: Integer): Integer;
  var i: Integer;
  begin
    Result := 0;
    for i := 0 to 2 do
      if ChanAlloc[i] = Num then begin
        Result := i;
        Exit;
      end;
  end;


procedure TMDIChild.ResetChanAlloc;
begin
  if Tracks.Focused then
    Tracks.HideMyCaret;
  Tracks.RemoveSelection;
  Tracks.RedrawTracks(0);
  if Tracks.Focused then
  begin
    Tracks.SetCaretPosition;
    Tracks.ShowMyCaret
  end;

  with xc[WhereIsChannel(0)] do
  begin
    Channel1Box.Left   := BoxLeft;
    Channel1Box.Width  := BoxWidth;
    SpeedButton1.Width := ButtonWidth;
    SpeedButton2.Left  := ToneLeft;
    SpeedButton3.Left  := NoiseLeft;
    SpeedButton4.Left  := EnvelopeLeft;
    SpeedButton13.Left := SoloLeft;
  end;

  with xc[WhereIsChannel(1)] do
  begin
    Channel2Box.Left   := BoxLeft;
    Channel2Box.Width  := BoxWidth;
    SpeedButton5.Width := ButtonWidth;
    SpeedButton6.Left  := ToneLeft;
    SpeedButton7.Left  := NoiseLeft;
    SpeedButton8.Left  := EnvelopeLeft;
    SpeedButton14.Left := SoloLeft;
  end;

  with xc[WhereIsChannel(2)] do
  begin
    Channel3Box.Left   := BoxLeft;
    Channel3Box.Width  := BoxWidth;
    SpeedButton9.Width := ButtonWidth;
    SpeedButton10.Left := ToneLeft;
    SpeedButton11.Left := NoiseLeft;
    SpeedButton12.Left := EnvelopeLeft;
    SpeedButton15.Left := SoloLeft;
  end;

end;

constructor TTracks.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  fBitmap := TBitmap.Create;
  Font := MainForm.EditorFont;
  ControlStyle := [csOpaque, csClickEvents, csSetCaption, csDoubleClicks, csFixedHeight, csCaptureMouse];
  TabStop := True;
  ParentColor := False;
  BevelKind := bkTile;
  BevelInner := bvLowered;
  HLStep := 4;
  KeyPressed := 0;
  ShownFrom := 0;
  CaretVisible := False;
  CursorX := 0;
  CursorY := 0;
  Clicked := False;
  ShownPattern := nil;
  RedrawDisabled := False;
end;


destructor TTracks.Destroy;
begin
  fBitmap.Free;
  inherited;
end;

procedure TMDIChild.CreateTracks;
begin
  Tracks := TTracks.Create(PatternsSheet);
  Tracks.InitMetrix;
  Tracks.ParentWin := Self;
  Tracks.Color := GetColor(ColorTheme.Background);
  Tracks.ShowHint := not DisableHints;
  Tracks.OnKeyDown := TracksKeyDown;
  Tracks.OnKeyUp := TracksKeyUp;
  Tracks.OnExit := TracksExit;
  Tracks.OnMouseDown := TracksMouseDown;
  Tracks.OnMouseMove := TracksMouseMove;
  Tracks.OnMouseWheelUp := TracksMouseWheelUp;
  Tracks.OnMouseWheelDown := TracksMouseWheelDown;
end;


procedure TTestLine.WMSysChar(var Message: TWMSysChar);
var MyMsg : TMsg ;
begin
  if (GetKeyState(VK_MENU) < 0) then
    PeekMessage(MyMsg, 0, WM_CHAR, WM_CHAR, PM_REMOVE)
  else
    inherited;
end;

constructor TTestLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  ControlStyle := [csClickEvents, csSetCaption, csDoubleClicks, csFixedHeight];
  TabStop := True;
  ParentColor := False;
  BevelKind := bkTile;
  BevelInner := bvLowered;
  KeyPressed := 0;
  Font := MainForm.TestLineFont;
  TestOct := 4;
  CursorX := 8;
  NoteCounter := 0;
end;

procedure TMDIChild.CreateTestLines;
var
  DC: HDC;
  p: HFONT;
  sz: tagSIZE;
begin
  SampleTestLine := TTestLine.Create(SamplesTestFieldBox);
  SampleTestLine.Color := clWhite;
  SampleTestLine.ParWind := Self;
  SampleTestLine.TestSample := True;
  SampleTestLine.CelH := abs(SampleTestLine.Font.Height);
  DC := GetDC(SampleTestLine.Handle);
  p := SelectObject(DC, SampleTestLine.Font.Handle);
  GetTextExtentPoint32(DC, '0', 1, sz);
  SampleTestLine.CelW := sz.cx;
  SampleTestLine.CelH := sz.cy;
  SelectObject(DC, p);
  ReleaseDC(SampleTestLine.Handle, DC);
  
  SampleTestLine.Left := 7;
  SampleTestLine.Top := LoadSampleBtn.Top;
  SampleTestLine.ClientWidth := SampleTestLine.CelW * 21;
  SampleTestLine.ClientHeight := SampleTestLine.CelH;
  SampleTestLine.OnKeyDown := SampleTestLine.TestLineKeyDown;
  SampleTestLine.OnKeyUp := SampleTestLine.TestLineKeyUp;
  SampleTestLine.OnExit := SampleTestLine.TestLineExit;
  SampleTestLine.OnMouseDown := SampleTestLine.TestLineMouseDown;

  OrnamentTestLine := TTestLine.Create(OrnamentsTestFieldBox);
  OrnamentTestLine.Color := clWhite;
  OrnamentTestLine.ParWind := Self;
  OrnamentTestLine.TestSample := False;
  //OrnamentTestLine.CelH := abs(OrnamentTestLine.Font.Height);
  DC := GetDC(OrnamentTestLine.Handle);
  p := SelectObject(DC, OrnamentTestLine.Font.Handle);
  GetTextExtentPoint32(DC, '0', 1, sz);
  OrnamentTestLine.CelW := sz.cx;
  OrnamentTestLine.CelH := sz.cy;
  SelectObject(DC, p);
  ReleaseDC(OrnamentTestLine.Handle, DC);

  OrnamentTestLine.Left := 7;
  OrnamentTestLine.Top := LoadOrnamentBtn.Top;
  OrnamentTestLine.ClientWidth := OrnamentTestLine.CelW * 21;
  OrnamentTestLine.ClientHeight := OrnamentTestLine.CelH;
  OrnamentTestLine.OnKeyDown := OrnamentTestLine.TestLineKeyDown;
  OrnamentTestLine.OnKeyUp := OrnamentTestLine.TestLineKeyUp;
  OrnamentTestLine.OnExit := OrnamentTestLine.TestLineExit;
  OrnamentTestLine.OnMouseDown := OrnamentTestLine.TestLineMouseDown
end;

constructor TSamples.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  ControlStyle := [csOpaque, csClickEvents, csSetCaption, csFixedHeight];
  fBitmap := TBitmap.Create;
  TabStop := True;
  ParentColor := False;
  BevelKind := bkTile;
  BevelInner := bvLowered;
  NOfLines := 16;
  CursorX := 0;
  CursorY := 0;
  ShownFrom := 0;
  ShownSample := nil;
  CaretVisible := False;
  ArrowsFont := TFont.Create;
  ArrowsFont.Name := 'Arrows';
end;


destructor TSamples.Destroy;
begin
  ArrowsFont.Free;
  fBitmap.Free;
  inherited;
end;


procedure TMDIChild.InitSamplesMetrix;
const
  SpecFonts: Array[0..2] of String = (
    'ProTracker 2', 'WST_Germ', 'ZX Spectrum'
  );
  
var
  DC: HDC;
  sz: tagSIZE;
  i: Integer;
  p: HFONT;
begin

  Samples.Font := MainForm.EditorFont;
  {if AnsiIndexText(Samples.Font.Name, SpecFonts) = -1 then
    Samples.Font.Size := Samples.Font.Size - 1; }

  DC := GetDC(Samples.Handle);
  p := SelectObject(DC, Samples.Font.Handle);
  GetTextExtentPoint32(DC, '0', 1, sz);
  Samples.CelW := sz.cx;
  Samples.CelH := sz.cy;
  //Samples.CelH := abs(Samples.Font.Height);
  SelectObject(DC, p);


  // Fit arrows font size to samples font size
  i := 0;
  repeat
    Samples.ArrowsFont.Size := Samples.Font.Size - i;
    p := SelectObject(DC, Samples.ArrowsFont.Handle);
    GetTextExtentPoint32(DC, '0', 1, sz);
    Samples.ArrowsFontW := sz.cx;
    Samples.ArrowsFontH := sz.cy;
    Inc(i);
    SelectObject(DC, p);
  until Samples.ArrowsFontW < Samples.CelW-1;


  SamplesBrowser.Font.Size := MainForm.EditorFont.Size - 9;
  if SamplesBrowser.Font.Size < 10  then SamplesBrowser.Font.Size := 10;
  if SamplesBrowser.Font.Size > 12 then SamplesBrowser.Font.Size := 12;
  p := SelectObject(DC, SamplesBrowser.Font.Handle);
  GetTextExtentPoint32(DC, '0', 1, sz);
  SamplesBrowser.ItemHeight := sz.cy+1;
  SelectObject(DC, p);

  Samples.fBitmap.Free;
  Samples.fBitmap := TBitmap.Create;

  Samples.ClientWidth := Samples.CelW * 40;
  if Samples.ClientWidth < 400 then Samples.ClientWidth := 400;

  ReleaseDC(Samples.Handle, DC);
end;



procedure TMDIChild.CreateSamples;
begin
  Samples := TSamples.Create(SampleEditBox);
  Samples.Color := GetColor(ColorTheme.Background);
  Samples.ParentWin := Self;
  Samples.UndoSaved := False;
  Samples.ShowHint := not DisableHints;
  Samples.OnKeyDown := SamplesKeyDown;
  Samples.OnKeyUp := SamplesKeyUp;
  Samples.OnMouseDown := SamplesMouseDown;
  Samples.OnMouseUp := SamplesMouseUp;
  Samples.OnMouseMove := SamplesMouseMove;
  Samples.OnMouseWheelUp := SamplesMouseWheelUp;
  Samples.OnMouseWheelDown := SamplesMouseWheelDown;

  SamplesBrowser := TFileBrowser.Create(SampleBrowserBox);
  SamplesBrowser.ParentWin := Self;
  SamplesBrowser.FileExt := 'vts';
  SamplesBrowser.CurrentDir := MainForm.SamplesDir;
  SamplesBrowser.ReadDir;
  SamplesBrowser.OnDrawItem  := SamplesBrowser.MyDrawItem;
  SamplesBrowser.OnMouseDown := SamplesBrowser.MyMouseDown;
  SamplesBrowser.OnClick     := SamplesBrowser.MyClick;
  SamplesBrowser.OnDblClick  := SamplesBrowser.MyDblClick;
  SamplesBrowser.OnKeyUp     := SamplesBrowser.MyKeyUp;
  SamplesBrowser.OnKeyDown   := SamplesBrowser.MyKeyDown;
  SamplesBrowser.OnMouseMove := SamplesBrowser.MyMouseMove;
  SamplesBrowser.PopupMenu   := FileBrowserPopup;

  SamplesDriveSelect := TDriveSelect.Create(SampleBrowserBox);
  SamplesDriveSelect.FileBrowser := SamplesBrowser;
  SamplesDriveSelect.OnChange    := SamplesDriveSelect.MyOnChange;
  SamplesDriveSelect.OnDrawItem  := SamplesDriveSelect.MyDrawItem;
  SamplesBrowser.DriveSelectBox  := @SamplesDriveSelect;

  InitSamplesMetrix;
end;


constructor TOrnaments.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  fBitmap := TBitmap.Create;
  ControlStyle := [csOpaque, csClickEvents, csSetCaption, csFixedHeight];
  TabStop := True;
  ParentColor := False;
  BevelKind := bkTile;
  BevelInner := bvLowered;
  Font := MainForm.EditorFont;
  NOfLines := OrnNCol * NRaw;
  CursorX := 0;
  CursorY := 0;
  ShownFrom := 0;
  ShownOrnament := nil;
  CaretVisible := False;
end;

destructor TOrnaments.Destroy;
begin
  fBitmap.Free;
  inherited;
end;



procedure TMDIChild.CreateOrnaments;
begin
  Ornaments := TOrnaments.Create(OrnamentEditBox);
  Ornaments.Color := GetColor(ColorTheme.Background);
  Ornaments.ParentWin := Self;
  Ornaments.ShowHint := not DisableHints;
  Ornaments.OnKeyDown := OrnamentsKeyDown;
  Ornaments.OnKeyUp := OrnamentsKeyUp;
  Ornaments.OnMouseUp   := OrnamentsMouseUp;
  Ornaments.OnMouseDown := OrnamentsMouseDown;
  Ornaments.OnMouseMove := OrnamentsMouseMove;
  Ornaments.OnMouseWheelUp := OrnamentsMouseWheelUp;
  Ornaments.OnMouseWheelDown := OrnamentsMouseWheelDown;
  NoteCounter := 0;
  MaxNote := 0;

  OrnamentsBrowser := TFileBrowser.Create(OrnamentsBrowserBox);
  OrnamentsBrowser.ParentWin := Self;
  OrnamentsBrowser.FileExt := 'vto';
  OrnamentsBrowser.CurrentDir := MainForm.OrnamentsDir;
  OrnamentsBrowser.ReadDir;
  OrnamentsBrowser.OnDrawItem  := OrnamentsBrowser.MyDrawItem;
  OrnamentsBrowser.OnMouseDown := OrnamentsBrowser.MyMouseDown;
  OrnamentsBrowser.OnClick     := OrnamentsBrowser.MyClick;
  OrnamentsBrowser.OnDblClick  := OrnamentsBrowser.MyDblClick;
  OrnamentsBrowser.OnKeyUp     := OrnamentsBrowser.MyKeyUp;
  OrnamentsBrowser.OnKeyDown   := OrnamentsBrowser.MyKeyDown;
  OrnamentsBrowser.OnMouseMove := OrnamentsBrowser.MyMouseMove;
  OrnamentsBrowser.PopupMenu   := FileBrowserPopup;

  OrnamentsDriveSelect := TDriveSelect.Create(OrnamentsBrowserBox);
  OrnamentsDriveSelect.FileBrowser := OrnamentsBrowser;
  OrnamentsDriveSelect.OnChange    := OrnamentsDriveSelect.MyOnChange;
  OrnamentsDriveSelect.OnDrawItem  := OrnamentsDriveSelect.MyDrawItem;
  OrnamentsBrowser.DriveSelectBox  := @OrnamentsDriveSelect;

  Ornaments.Browser := OrnamentsBrowser;
  Ornaments.InitMetrix;
end;




procedure TTracks.DefaultHandler(var Message);
var
  ps: tagPAINTSTRUCT;
  hDC1: HDC;
begin
  case TMessage(Message).msg of
    WM_GETDLGCODE:
      begin
        TMessage(Message).Result := -1 xor Integer(DLGC_WANTTAB);
        exit
      end;
    WM_PAINT:
      begin
        hDC1 := BeginPaint(Handle, ps);
        RedrawTracks(hDC1);
        EndPaint(Handle, ps);
        TWMPaint(Message).Result := -1;
      end;
    WM_SETFOCUS:
      begin
        if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and not IsWindow(TWMSetFocus(Message).FocusedWnd) then
          TWMSetFocus(Message).FocusedWnd := 0;

        HideMyCaret;
        CreateMyCaret;
        SetCaretPosition;
        RedrawTracks(0);
        ShowMyCaret;
        TMDIChild(ParentWin).ShowStat;
        TMessage(Message).Result := -1;
      end;
    WM_KILLFOCUS:
      begin
        HideMyCaret;
        DestroyCaret;
        RemoveSelection;
        RedrawTracks(0);
        CaretVisible := False;
        Clicked := False;
        TMessage(Message).Result := -1;
      end;
  end;
  inherited;
end;

procedure TTestLine.DefaultHandler(var Message);
var
  ps: tagPAINTSTRUCT;
  hDC1: HDC;
begin
  case TMessage(Message).msg of
    WM_GETDLGCODE:
      begin
        TMessage(Message).Result := -1 xor Integer(DLGC_WANTTAB);
        exit
      end;
    WM_PAINT:
      begin
        hDC1 := BeginPaint(Handle, ps);
        RedrawTestLine(hDC1);
        EndPaint(Handle, ps);
        TWMPaint(Message).Result := -1
      end;
    WM_SETFOCUS:
      begin
        if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and not IsWindow(TWMSetFocus(Message).FocusedWnd) then
          TWMSetFocus(Message).FocusedWnd := 0;

        RedrawTestLine(0);
        CreateMyCaret;
        SetCaretPosition;
        ShowCaret(Handle);
        TMDIChild(MainForm.ActiveMDIChild).ShowStat;
        TMessage(Message).Result := -1
      end;
    WM_KILLFOCUS:
      begin
        DestroyCaret;
        RedrawTestLine(0);
        TMessage(Message).Result := -1
      end;

  end;
  inherited;
end;

procedure TSamples.DoHint(X, Y: Integer);
var
  s: string;
begin
  {$IFDEF DEBUG}Exit;{$ENDIF}
  Application.HintHidePause := HideHintDelay;


  if X = -1 then X := CursorX;

  s := '';
  case X of
    0:
    begin
      s :=    'Tone mask:' +Chr(13);
      s := s +'[T] - On' +Chr(13);
      s := s +'[.] - Off'+Chr(13)+Chr(13);
      s := s +'Mouse click to toggle.';
    end;

    1:
    begin
      s := 'Noise mask:' +Chr(13)+Chr(13);
      s := s + '[N] - On' +Chr(13);
      s := s + '[.] - Off' +Chr(13)+Chr(13);
      s := s + 'Mouse click to toggle.';
    end;
    2:
    begin
      s := 'Envelope mask:' +Chr(13)+Chr(13);
      s := s + '[E] - On' +Chr(13);
      s := s + '[.] - Off' +Chr(13)+Chr(13);
      s := s + 'Mouse click to toggle.';
    end;
    4:
    begin
      s := '+/- Tone shift sign.'+Chr(13)+Chr(13);
      s := s + '[-] - Frequency UP'+Chr(13);
      s := s + '[+] - Frequency DOWN';
    end;
    5..7:
      s := 'Tone shift value 000-FFF.';
    8:
    begin
      s := 'Tone shift accumulation:' +Chr(13)+Chr(13);
      s := s + '[^] - On' +Chr(13);
      s := s + '[.] - Off' +Chr(13)+Chr(13);
      s := s + 'Mouse click to toggle.';
    end;
    10:
    begin
      s := 'Noise frequency shift sign (envelope on/off). ' +Chr(13)+Chr(13);
      s := s + '[+] - Frequency up'+Chr(13);
      s := s + '[-] - Frequency down';
    end;
    11..12:
      s := 'Noise frequency shift value (envelope frequency).';
    14..15:
      s := 'Absolute noise frequency value (envelope frequency).';
    17:
    begin
      s := 'Noise shift accumulation:'+Chr(13)+Chr(13);
      s := s + '[^] - On'+Chr(13);
      s := s + '[.] - Off';
    end;
    19:
      s := 'Volume: 0-F';
    20:
    begin
      s := 'Volume shift:'+Chr(13)+Chr(13);
      s := s + '[^] - Volume up'+Chr(13);
      s := s + '[v] - Volume down'+Chr(13);
      s := s + '[.] - No volume shift';
    end;

  end;

  if s = '' then Exit;

  s := s + Chr(13) + Chr(13);
  s := s + 'Select lines: Shift + Up/Down' + Chr(13);
  s := s + 'Select lines: Shift + Drag mouse' + Chr(13);
  s := s + 'Select columns: Ctrl + Drag mouse' + Chr(13) + Chr(13);
  s := s + 'Change loop an length: drag RIGHT mouse button' + Chr(13);
  s := s + 'CTRL+C, CTRL+V - To copy/paste';

  MainForm.StatusBar.Panels[0].Text := s;
  if DisableHints then begin
    ShowHint := False;
    Application.CancelHint;
  end
  else
  begin
    ShowHint := True;
    Hint := s;

    with TMDIChild(ParentWin) do
    begin

      if (HintLastX <> X) or (HintLastY <> Y) then
      begin
        Application.CancelHint;
        HideHintTimer.Enabled := False;
        ShowHintTimer.Enabled := False;
        ShowHintTimer.Interval := ShowHintDelay;
        ShowHintTimer.Enabled := True;
      end
    end;  
  end;


  HintLastX := X;
  HintLastY := Y;

end;


procedure TSamples.WMEraseBkGnd(var Message:TMessage);
begin
  Message.Result := 0;
end;


procedure TSamples.WMSysChar(var Message: TWMSysChar);
var MyMsg : TMsg ;
begin
  if (GetKeyState(VK_MENU) < 0) then
    PeekMessage(MyMsg, 0, WM_CHAR, WM_CHAR, PM_REMOVE)
  else
    inherited;
end;

procedure TSamples.DefaultHandler(var Message);
var
  ps: tagPAINTSTRUCT;
  hDC1: HDC;
begin
  case TMessage(Message).msg of
    WM_GETDLGCODE:
      begin
        TMessage(Message).Result := -1 xor Integer(DLGC_WANTTAB);
        exit
      end;
    WM_PAINT:
      begin
        hDC1 := BeginPaint(Handle, ps);
        RedrawSamples(hDC1);
        EndPaint(Handle, ps);
        TWMPaint(Message).Result := -1
      end;
    WM_SETFOCUS:
      begin
        if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and not IsWindow(TWMSetFocus(Message).FocusedWnd) then
          TWMSetFocus(Message).FocusedWnd := 0;
        InputSNumber := 0;
        HideMyCaret;
        CreateMyCaret;
        SetCaretPosition;
        ShowMyCaret;
        TMessage(Message).Result := -1
      end;
    WM_KILLFOCUS:
      begin
        CaretVisible := False;
        DestroyCaret;
        TMessage(Message).Result := -1
      end;
    WM_LBUTTONDOWN, WM_MOUSEWHEEL:
      if SamplesDontScroll then
        Exit;
    WM_LBUTTONUP:
      SamplesDontScroll := False;
  end;

  inherited;
end;

procedure TOrnaments.WMEraseBkGnd(var Message:TMessage);
begin
  Message.Result := 0;
end;


procedure TOrnaments.WMSysChar(var Message: TWMSysChar);
var MyMsg : TMsg ;
begin
  if (GetKeyState(VK_MENU) < 0) then
    PeekMessage(MyMsg, 0, WM_CHAR, WM_CHAR, PM_REMOVE)
  else
    inherited;
end;

procedure TOrnaments.DefaultHandler(var Message);
var
  ps: tagPAINTSTRUCT;
  hDC1: HDC;
begin
  case TMessage(Message).msg of
    WM_GETDLGCODE:
      begin
        TMessage(Message).Result := -1 xor Integer(DLGC_WANTTAB);
        exit
      end;
    WM_PAINT:
      begin
        hDC1 := BeginPaint(Handle, ps);
        RedrawOrnaments(hDC1);
        EndPaint(Handle, ps);
        TWMPaint(Message).Result := -1
      end;
    WM_SETFOCUS:
      begin
        if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and not IsWindow(TWMSetFocus(Message).FocusedWnd) then
          TWMSetFocus(Message).FocusedWnd := 0;
        InputONumber := 0;
        HideMyCaret;
        CreateCaret(Handle, 0, CelW * 3, CelH);
        SetCaretPosition;
        ShowMyCaret;
        TMessage(Message).Result := -1
      end;
    WM_KILLFOCUS:
      begin
        CaretVisible := False;
        DestroyCaret;
        TMessage(Message).Result := -1
      end;

  end;
  inherited;
end;



procedure TTracks.WMEraseBkGnd(var Message:TMessage);
begin
  Message.Result := 0;
end;


procedure TTracks.WMSysChar(var Message: TWMSysChar);
var MyMsg : TMsg ;
begin
  if (GetKeyState(VK_MENU) < 0) then
    PeekMessage(MyMsg, 0, WM_CHAR, WM_CHAR, PM_REMOVE)
  else
    inherited;
end;


procedure TTracks.SelectAll;
begin
  ShownFrom := 0;
  CursorY := N1OfLines;
  CursorX := 0;
  if ShownPattern = nil then
    SelY := DefPatLen - 1
  else
    SelY := ShownPattern.Length - 1;
  SelX := 48;
  HideMyCaret;
  ShowSelection;
  RedrawTracks(0);
  RecreateCaret;
  SetCaretPosition;
  ShowMyCaret;
  TMDIChild(MainForm.ActiveMDIChild).ShowStat;
end;


procedure TTracks.FitNumberOfLines;
begin
  NOfLines  := (Height div CelH) + 1;
  N1OfLines := NOfLines div 2;
  CursorY   := N1OfLines;
end;


function TTracks.CurrentPatLine: Integer;
begin
  Result := ShownFrom - N1OfLines + CursorY;
end;

function TTracks.CurrentChannel: Integer;
begin
  Result := ChanAlloc[(CursorX - 8) div 14];
end;


function TTracks.IsTrackPlaying: Boolean;
begin
  Result := (TMDIChild(ParentWin).PlayStopState = BStop) and (PlayMode in [PMPlayModule, PMPlayPattern]);
end;

function TTracks.IsSelected: Boolean;
begin
  Result := (SelX <> CursorX) or (SelY <> CurrentPatLine);
end;

procedure TTracks.ShowSelection;
begin

  ShowSel := True;
  if IsTrackPlaying then
    ShowSel := False;

end;

procedure TTracks.DrawSelection;
var
  Y1, Y2, X1, X2, W: Integer;

begin
  if not ShowSel then Exit;

  Y1 := SelY - ShownFrom + N1OfLines;
  Y2 := CursorY;

  if Y1 > Y2 then
  begin
    Y2 := Y1;
    Y1 := CursorY
  end;
  if Y1 < 0 then
    Y1 := 0;
  if Y2 >= NOfLines then
    Y2 := NOfLines - 1;
  if Y1 > Y2 then
    exit;
  X2 := CursorX;
  X1 := SelX;
  if X1 > X2 then
  begin
    X1 := X2;
    X2 := SelX
  end;

  W := 1;
  if X2 in [8, 22, 36] then
    W := 3;

  InvertRect(fBitmap.Canvas.Handle, Rect((X1 + TracksCursorXLeft) * CelW, Y1 * CelH, (X2 + TracksCursorXLeft + W) * CelW, (Y2 + 1) * CelH));

end;


procedure TTracks.RemoveSelection;
begin

  ShowSel := False;
  SelX := CursorX;
  SelY := CurrentPatLine;

end;


procedure TTracks.ResetLastNoteParams(Pat, Line, Chan: byte);
begin
  with TMDIChild(MainForm.ActiveMDIChild) do
    with VTMP.Patterns[Pat].Items[Line].Channel[Chan] do
    begin
      Tracks.LastNoteParams[Chan].Line := Line;
      Tracks.LastNoteParams[Chan].Sample := Sample;
      Tracks.LastNoteParams[Chan].Envelope := Envelope;
      Tracks.LastNoteParams[Chan].Ornament := Ornament;
      Tracks.LastNoteParams[Chan].Volume := Volume;
    end;

end;


procedure TTracks.RemSel;
begin
  if GetKeyState(VK_SHIFT) < 0 then Exit;

  HideMyCaret;
  RemoveSelection;
  ShowMyCaret;

end;


procedure TTracks.JumpToPatStart(Shift: TShiftState);
begin
  RemSel;
  ShownFrom := 0;
  CursorY := N1OfLines;

  if ssShift in Shift then
    ShowSelection
  else
    RemoveSelection;
    
  HideMyCaret;
  RedrawTracks(0);
  SetCaretPosition;
  ShowMyCaret;
end;



procedure TTracks.JumpToPatEnd(Shift: TShiftState);
var PLen: Integer;
begin

  RemSel;

  if ShownPattern = nil then
    PLen := DefPatLen
  else
    PLen := ShownPattern.Length;

  ShownFrom := PLen - 1;
  CursorY := N1OfLines;

  if ssShift in Shift then
    ShowSelection
  else
    RemoveSelection;

  HideMyCaret;
  RedrawTracks(0);
  SetCaretPosition;
  ShowMyCaret;
end;


procedure TTracks.JumpToLineStart(Shift: TShiftState);
begin
  RemSel;
  CursorX := 0;

  if ssShift in Shift then
    ShowSelection
  else
    RemoveSelection;

  HideMyCaret;
  RedrawTracks(0);
  RecreateCaret;
  SetCaretPosition;
  ShowMyCaret;

end;

procedure TTracks.JumpToLineEnd(Shift: TShiftState);
begin
  RemSel;
  CursorX := 48;

  if ssShift in Shift then
    ShowSelection
  else
    RemoveSelection;

  HideMyCaret;
  RedrawTracks(0);
  RecreateCaret;
  SetCaretPosition;
  ShowMyCaret;
end;



//перерисовка

procedure TTracks.InitMetrix;
var
  CharHalfWidth: Integer;
  DC: HDC;
  sz: tagSIZE;
  p: HFONT;

begin

  // Font
  Font := MainForm.EditorFont;
  DC := GetDC(MainForm.Handle);
  p := SelectObject(DC, Font.Handle);
  GetTextExtentPoint32(DC, '0', 1, sz);
  CelW := sz.cx;
  CelH := sz.cy;


  // Pattern width
  if DecBaseLinesOn then
  begin
    PatNumChars := 53;
    Shift := 1;
  end
  else
  begin
    PatNumChars := 52;
    Shift := 0;
  end;
  PatWidth := PatNumChars * CelW + 2;

  
  // Separators
  CharHalfWidth := (CelW div 2);
  Sep1X := (2+Shift)*CelW + CharHalfWidth;
  Sep2X := (7+Shift) *CelW + CharHalfWidth;
  Sep3X := (10+Shift)*CelW + CharHalfWidth - 1;
  Sep4X := (24+Shift)*CelW + CharHalfWidth - 1;
  Sep5X := (38+Shift)*CelW + CharHalfWidth - 1;


  // Pattern box size
  ClientWidth := PatWidth;

  fBitmap.Free;
  fBitmap := TBitmap.Create;
  fBitmap.Canvas.Font := Font;

  SelectObject(DC, p);
  ReleaseDC(MainForm.Handle, DC);
  

end;


procedure TTracks.RedrawTracks;
var
  Line, i, j, j1, n, i1, CurY, Top, ToLine, num: Integer;

  PrevPat, NextPat: PPattern;
  PrevPatNum, NextPatNum,
    CurPatSepTop, CurPatSepBottom,
    PrevPatSepBottom, PrevPatSepTop,
    NextPatSepTop, NextPatSepBottom: Integer;

  CChanBg, CChanText, CChanNote, CChanNoteParams, CChanNoteCommands: TColor;

  X, Y: Integer;
  DC1: HDC;
  s, s1: string;
  p: HFONT;
  PLen: Integer;
  sz: tagSIZE;
  PositionNumber: Integer;


  procedure Print(X, Y: Integer; Str: string);
  begin
    fBitmap.Canvas.TextOut(X, Y, Str);
  end;

  procedure TextColor(Color: TColor);
  begin
    fBitmap.Canvas.Font.Color := Color;
  end;

  procedure BgColor(Color: TColor);
  begin
    fBitmap.Canvas.Brush.Color := Color;
  end;


begin
  if RedrawDisabled then Exit;
  if not TMDIChild(ParentWin).Visible then Exit;
  if not TMDIChild(ParentWin).InitFinished then Exit;
  if TMDIChild(ParentWin).VTMP = nil then Exit;
  if ShownPattern = nil then Exit;
  if TMDIChild(ParentWin).Closed then Exit;
  if (ClientWidth <= 0) or (ClientHeight <= 0) then Exit;

  num := 0;
  Top := 0;
  PrevPat := nil;
  NextPat := nil;

  if DC = 0 then
    DC1 := GetDC(Handle)
  else
    DC1 := DC;


  if (fBitmap.Width <> ClientWidth) or (fBitmap.Height <> ClientHeight) then
  begin
    fBitmap.Width := ClientWidth;
    fBitmap.Height := ClientHeight;
    fBitmap.Canvas.Font := Font;
  end;

  p := SelectObject(DC1, Font.Handle);


  Y := (N1OfLines - ShownFrom);
  n := NOfLines - Y;

  PLen := ShownPattern.Length;
  if PLen < n then
    n := PLen;

  if Y < 0 then
  begin
    i1 := -Y;
    inc(n, Y);
    Y := 0
  end
  else
    i1 := 0;


  // Calculate previous and next pattern number
  with TMDIChild(ParentWin) do
  begin
    if PositionNumber > 0 then
    begin
      PrevPatNum := VTMP.Positions.Value[PositionNumber - 1];
      PrevPat := VTMP.Patterns[PrevPatNum];
    end
    else
      PrevPatNum := -1;

    if PositionNumber < VTMP.Positions.Length - 1 then
    begin
      NextPatNum := VTMP.Positions.Value[PositionNumber + 1];
      NextPat := VTMP.Patterns[NextPatNum];
    end
    else
      NextPatNum := -1;
  end;


  // Clear bitmap
  BgColor(CBackground);
  fBitmap.Canvas.FillRect(Rect(0, 0, ClientWidth, ClientHeight));


  // Draw previous pattern lines
  PrevPatSepTop := 0;
  PrevPatSepBottom := -1;
  if (PrevPatNum <> -1) and (Y > 0) then
  begin
    Top := 0;
    TextColor(COutText);

    for Line := Y downto 1 do
    begin

      s := GetOutPatternLineString(PrevPatNum, PrevPat, Line, ChanAlloc, True);

      if (Line mod HLStep = 0) and (PrevPatNum >= 0) and (Trim(s) <> '') and (HLStep <> 256) then
        BgColor(COutHlBackground)
      else if PrevPatNum < 0 then
        BgColor(CBackground)
      else
        BgColor(COutBackground);

      Print(0, Top, s);

      // Line numbers
      if (PrevPatNum <> -1) and (Trim(s) <> '') then
        if DecBaseLinesOn then
          Print(3, Top, Format('%.3d', [PrevPat.Length - Line]))
        else
          Print(3, Top, IntToHex(PrevPat.Length - Line, 2));

      // Fill last 2 pixels
      fBitmap.Canvas.FillRect(Rect(PatWidth-2, Top, PatWidth+1, Top + CelH));

      Inc(Top, CelH);
      if Trim(s) = '' then PrevPatSepTop := Top;
    end;

    PrevPatSepBottom := Top;

  end;


  // Calculate current pattern top Y coordinate
  Y := Y * CelH;
  CurY := CelH * N1OfLines;
  CurPatSepTop := Y;

  if PrevPatSepBottom = -1 then
    PrevPatSepBottom := Y;


  // No previous pattern: draw top horinontal line
  if (PrevPatNum = -1) and (Y > 0) then
  begin
    BgColor(COutSeparators);
    fBitmap.Canvas.FillRect(Rect(0, Y-1, PatWidth+2, Y));
  end;


  // --- Draw current pattern lines


  // All channels is muted - simple draw pattern
  if ChannelState[0].Muted and ChannelState[1].Muted and ChannelState[2].Muted then
  begin


    for Line := i1 to i1 + n - 1 do
    begin

      // Draw pattern line
      s := GetPatternLineString(ShownPattern, Line, ChanAlloc, False, False);

      if Y = CurY then
      begin
        BgColor(CSelLineBackground);
        TextColor(CSelLineText);
      end
      else if (Line mod HLStep = 0) and (HLStep <> 256) then
      begin
        BgColor(COutHlBackground);
        TextColor(COutText);
      end
      else
      begin
        BgColor(COutBackground);
        TextColor(COutText);
      end;

      Print(0, Y, s);

      // Fill last 2 pixels
      fBitmap.Canvas.FillRect(Rect(PatWidth-2, Y, PatWidth+1, Y + CelH));

      // Draw line numbers
      if DecBaseLinesOn then
        Print(3, Y, Format('%.3d', [Line]))
      else
        Print(3, Y, IntToHex(Line, 2));

      Inc(Y, CelH);
    end
  end

  else

  // Not all channels muted
  for Line := i1 to i1 + n - 1 do
  begin

    if Y = CurY then
    begin
      // Selected line
      BgColor(CSelLineBackground);
      TextColor(CSelLineText);
    end
    else if (Line mod HLStep = 0)  and (HLStep <> 256) then
    begin
      // Highlighted line
      BgColor(CHighlBackground);
      TextColor(CHighlText);
    end
    else
    begin
      // Default line
      BgColor(CBackground);
      TextColor(CText);
    end;

    // Fill last 2 pixels
    fBitmap.Canvas.FillRect(Rect(PatWidth-2, Y, PatWidth+1, Y + CelH));

    // Empty line layer and line number

    s := '   .... .. --- .... .... --- .... .... --- .... ....';
    if DecBaseLinesOn then
    begin
      Print(0, Y, ' ' + s);
      if Y = CurY then
        TextColor(CSelLineNum)
      else
      if (Line mod HLStep = 0) and (HLStep <> 256) then
        TextColor(CHighlLineNum)
      else
        TextColor(CLineNum);
      Print(3, Y, Format('%.3d', [Line]));
    end
    else
    begin
      Print(0, Y, s);
      if Y = CurY then
        TextColor(CSelLineNum)
      else
      if (Line mod HLStep = 0) and (HLStep <> 256) then
        TextColor(CHighlLineNum)
      else
        TextColor(CLineNum);
      Print(3, Y, IntToHex(Line, 2));
    end;


    // Envelope
    if ShownPattern.Items[Line].Envelope > 0 then
    begin

      num := ShownPattern.Items[Line].Envelope;

      // Get HEX envelope string
      if num < 16 then
        s := IntToHex(num, 1)
      else if num < 256 then
        s := IntToHex(num, 2)
      else if num < $1000 then
        s := IntToHex(num, 3)
      else
        s := IntToHex(num, 4);

      // Get envelope as note string
      if EnvelopeAsNote then
      begin
        num := GetNoteByEnvelope(ShownPattern.Items[Line].Envelope);
        if (num >= 0) and (num <= 60) then
          s := NoteToStr(num);
      end;

      // Calculate envelope string X coordinate
      // 3 - 3 char from left
      // 4 - max envelope length
      // Shift - 1/0 char
      X := (3 + 4 - Length(s) + Shift) * CelW;
      if Y = CurY then
        TextColor(CSelEnvelope)
      else
        TextColor(CEnvelope);
      Print(X, Y, s);
    end;


    // Noise
    if ShownPattern.Items[Line].Noise > 0 then
    begin

      num := ShownPattern.Items[Line].Noise;

      // Get noise value string
      if DecBaseNoiseOn then
        s := IntToStr(num)
      else if num < 16 then
        s := IntToHex(num, 1)
      else
        s := IntToHex(num, 2);

      // Calculate noise X coordinate
      // 8 - char from left
      // 2 - max noise length
      // Shift - 1/0 char
      X := (8 + 2 - Length(s) + Shift) * CelW;
      if Y = CurY then
        TextColor(CSelNoise)
      else
        TextColor(CNoise);
      Print(X, Y, s);
    end;


    // Draw channels
    for i := 0 to 2 do
    begin

      j := ChanAlloc[i];

      // Channel muted
      // Prepare channel colors
      if ChannelState[j].Muted then
      begin
        // Muted + Selected line
        if Y = CurY then
        begin
          CChanText         := CSelLineText;
          CChanNote         := CSelLineText;
          CChanNoteParams   := CSelLineText;
          CChanNoteCommands := CSelLineText;
          CChanBg           := CSelLineBackground;
        end

        // Muted + Highlight line
        else if (Line mod HLStep = 0) and (HLStep <> 256) then
        begin
          CChanText         := COutText;
          CChanNote         := COutText;
          CChanNoteParams   := COutText;
          CChanNoteCommands := COutText;
          CChanBg           := COutHlBackground;
        end

        // Muted line
        else
        begin
          CChanText         := COutText;
          CChanNote         := COutText;
          CChanNoteParams   := COutText;
          CChanNoteCommands := COutText;
          CChanBg           := COutBackground;
        end;
      end
      else
      begin

        // Selected line
        if Y = CurY then
        begin
          CChanText         := CSelLineText;
          CChanNote         := CSelNote;
          CChanNoteParams   := CSelNoteParams;
          CChanNoteCommands := CSelNoteCommands;
          CChanBg           := CSelLineBackground;
        end

        // Hightlight line
        else if (Line mod HLStep = 0) and (HLStep <> 256) then
        begin
          CChanText         := CHighlText;
          CChanNote         := CNote;
          CChanNoteParams   := CNoteParams;
          CChanNoteCommands := CNoteCommands;
          CChanBg           := CHighlBackground;
        end

        // Line
        else
        begin
          CChanText         := CText;
          CChanNote         := CNote;
          CChanNoteParams   := CNoteParams;
          CChanNoteCommands := CNoteCommands;
          CChanBg           := CBackground;
        end;
      end;

      TextColor(CChanText);
      BgColor(CChanBg);

      // Channel muted
      if ChannelState[j].Muted then
      begin

        // X coord
        case i of
          0: num := 11;
          1: num := 25;
          2: num := 39;
        end;

        X := (num + Shift) * CelW;

        num := CelW div 2;
        Print(X - num, Y, ' ');
        if i <> 2 then
          Print(X + (12 * CelW) + num, Y, ' ');

        Print(X, Y, '--- .... ....');
      end;


      // Note
      if ShownPattern.Items[Line].Channel[j].Note <> -1 then
      begin

        // Note X coord
        case i of
          0: num := 11;
          1: num := 25;
          2: num := 39;
        end;
        X := (num + Shift) * CelW;

        TextColor(CChanNote);
        Print(X, Y, NoteToStr(ShownPattern.Items[Line].Channel[j].Note));
      end;

      TextColor(CChanNoteParams);

      // Sample
      if ShownPattern.Items[Line].Channel[j].Sample > 0 then
      begin

        // Sample X coord
        case i of
          0: num := 15;
          1: num := 29;
          2: num := 43;
        end;
        X := (num + Shift) * CelW;

        // Get sample char
        num := ShownPattern.Items[Line].Channel[j].Sample;
        if num < 16 then
          s := IntToHex(num, 1)
        else
          s := Char(num + Ord('A') - 10);

        Print(X, Y, s);
      end;


      // Note envelope
      if ShownPattern.Items[Line].Channel[j].Envelope > 0 then
      begin
        // Envelope X coord
        case i of
          0: num := 16;
          1: num := 30;
          2: num := 44;
        end;
        X := (num + Shift) * CelW;

        Print(X, Y, IntToHex(ShownPattern.Items[Line].Channel[j].Envelope, 1));
      end;


      // Ornament
      if ShownPattern.Items[Line].Channel[j].Ornament > 0 then
      begin
        // Ornament X coord
        case i of
          0: num := 17;
          1: num := 31;
          2: num := 45;
        end;
        X := (num + Shift) * CelW;

        Print(X, Y, IntToHex(ShownPattern.Items[Line].Channel[j].Ornament, 1));
      end;


      // Volume
      if ShownPattern.Items[Line].Channel[j].Volume > 0 then
      begin
        // Volume X coord
        case i of
          0: num := 18;
          1: num := 32;
          2: num := 46;
        end;
        X := (num + Shift) * CelW;

        Print(X, Y, IntToHex(ShownPattern.Items[Line].Channel[j].Volume, 1));
      end;

      TextColor(CChanNoteCommands);

      // Command number
      if ShownPattern.Items[Line].Channel[j].Additional_Command.Number > 0 then
      begin
        // X coord
        case i of
          0: num := 20;
          1: num := 34;
          2: num := 48;
        end;
        X := (num + Shift) * CelW;

        Print(X, Y, IntToHex(ShownPattern.Items[Line].Channel[j].Additional_Command.Number, 1));
      end;


      // Command delay
      if ShownPattern.Items[Line].Channel[j].Additional_Command.Delay > 0 then
      begin
        // X coord
        case i of
          0: num := 21;
          1: num := 35;
          2: num := 49;
        end;
        X := (num + Shift) * CelW;

        Print(X, Y, IntToHex(ShownPattern.Items[Line].Channel[j].Additional_Command.Delay, 1));
      end;


      // Command parameter
      if ShownPattern.Items[Line].Channel[j].Additional_Command.Parameter > 0 then
      begin

        num := ShownPattern.Items[Line].Channel[j].Additional_Command.Parameter;
        if num < 16 then
          s := IntToHex(num, 1)
        else
          s := IntToHex(num, 2);

        // X coord
        case i of
          0: num := 22;
          1: num := 36;
          2: num := 50;
        end;
        X := (num + 2 - Length(s) + Shift) * CelW;

        Print(X, Y, s);
      end;

    end;

    Inc(Y, CelH);
  end;

  CurPatSepBottom := Y;


  // Draw next pattern lines
  NextPatSepBottom := 0;
  if (NextPatNum <> -1) and (Y < CelH * NOfLines) then
  begin
    Top := Y;
    ToLine := NOfLines - (Y div CelH);
    NextPatSepTop := Y;

    TextColor(COutText);

    for Line := 0 to ToLine do
    begin
      s := GetOutPatternLineString(NextPatNum, NextPat, Line, ChanAlloc, False);

      if NextPatNum < 0 then
        BgColor(CBackground)
      else if (Line mod HLStep = 0) and (NextPatNum >= 0) and (Trim(s) <> '') and (HLStep <> 256) then
        BgColor(COutHlBackground)
      else
        BgColor(COutBackground);

      Print(0, Top, s);

      if (NextPatNum <> -1) and (Trim(s) <> '') then
        if DecBaseLinesOn then
          Print(3, Top, Format('%.3d', [Line]))
        else
          Print(3, Top, IntToHex(Line, 2));

      // Fill last 2 pixels
      fBitmap.Canvas.FillRect(Rect(PatWidth-2, Top, PatWidth+1, Top + CelH));

      if (Trim(s) = '') and (NextPatSepBottom = 0) then NextPatSepBottom := Top;
      Inc(Top, CelH);
    end;

    if NextPatSepBottom = 0 then NextPatSepBottom := Top;

  end
  else

  // No next pattern: draw bottom horinontal line
  begin
    BgColor(COutSeparators);
    fBitmap.Canvas.FillRect(Rect(0, Y, PatWidth+2, Y+1));
  end;


  // Separators
  if not DisableSeparators then
  begin

    fBitmap.Canvas.Pen.Style:= psSolid;

    // Previous pattern separators
    if PrevPatNum <> -1 then
    begin
      BgColor(COutSeparators);

      // Short previous pattern - draw top line
      if PrevPatSepTop > 0 then
        fBitmap.Canvas.FillRect(Rect(0, PrevPatSepTop-1, PatWidth+2, PrevPatSepTop));

      BgColor(COutSeparators);
      fBitmap.Canvas.FillRect(Rect(Sep2X, PrevPatSepTop, Sep2X+2, PrevPatSepBottom));
      fBitmap.Canvas.FillRect(Rect(Sep3X, PrevPatSepTop, Sep3X+2, PrevPatSepBottom));
      fBitmap.Canvas.FillRect(Rect(Sep4X, PrevPatSepTop, Sep4X+2, PrevPatSepBottom));
      fBitmap.Canvas.FillRect(Rect(Sep5X, PrevPatSepTop, Sep5X+2, PrevPatSepBottom));
    end;

    // Current pattern separators
    BgColor(CSeparators);
    fBitmap.Canvas.FillRect(Rect(Sep2X, CurPatSepTop, Sep2X+2, CurPatSepBottom));
    fBitmap.Canvas.FillRect(Rect(Sep3X, CurPatSepTop, Sep3X+2, CurPatSepBottom));
    fBitmap.Canvas.FillRect(Rect(Sep4X, CurPatSepTop, Sep4X+2, CurPatSepBottom));
    fBitmap.Canvas.FillRect(Rect(Sep5X, CurPatSepTop, Sep5X+2, CurPatSepBottom));

    // Next pattern separators
    if NextPatNum <> -1 then
    begin
      BgColor(COutSeparators);

      // Short next pattern - draw bottom line
      if NextPatSepBottom < Top then
        fBitmap.Canvas.FillRect(Rect(0, NextPatSepBottom, PatWidth+2, NextPatSepBottom+1));

      fBitmap.Canvas.FillRect(Rect(Sep2X, NextPatSepTop, Sep2X+2, NextPatSepBottom));
      fBitmap.Canvas.FillRect(Rect(Sep3X, NextPatSepTop, Sep3X+2, NextPatSepBottom));
      fBitmap.Canvas.FillRect(Rect(Sep4X, NextPatSepTop, Sep4X+2, NextPatSepBottom));
      fBitmap.Canvas.FillRect(Rect(Sep5X, NextPatSepTop, Sep5X+2, NextPatSepBottom));
    end;

  end;


  // Right border if pattern editor width < window width (small font size)
  if PatWidth < ClientWidth then
  begin
    BgColor(COutSeparators);

    if PrevPatNum <> -1 then
      fBitmap.Canvas.FillRect(Rect(PatWidth+1, PrevPatSepTop, PatWidth+2, PrevPatSepBottom));

    fBitmap.Canvas.FillRect(Rect(PatWidth+1, CurPatSepTop, PatWidth+2, CurPatSepBottom));

    if NextPatNum <> -1 then
      fBitmap.Canvas.FillRect(Rect(PatWidth+1, NextPatSepTop, PatWidth+2, NextPatSepBottom));
  end;


  // Separator between line number and envelope
  if PrevPatNum <> -1 then
  begin
    BgColor(COutSeparators);
    fBitmap.Canvas.FillRect(Rect(Sep1X, PrevPatSepTop, Sep1X+2, PrevPatSepBottom));
  end;

  BgColor(CSeparators);
  fBitmap.Canvas.FillRect(Rect(Sep1X, CurPatSepTop, Sep1X+2, CurPatSepBottom));

  if NextPatNum <> -1 then
  begin
    BgColor(COutSeparators);
    fBitmap.Canvas.FillRect(Rect(Sep1X, NextPatSepTop, Sep1X+2, NextPatSepBottom));
  end;

  DrawSelection;

  // Copy hidden image to the Tracks control
  if not ManualBitBlt then
  begin
    BitBlt(DC1, 0, 0, Width, Height, fBitmap.Canvas.Handle, 0, 0, SRCCOPY);
  end;
  SelectObject(DC1, p);
  if DC = 0 then
    ReleaseDC(Handle, DC1);

end;

procedure TTracks.DoBitBlt;
var
  DC: HDC;
begin
  DC := GetDC(Handle);
  BitBlt(DC, 0, 0, Width, Height, fBitmap.Canvas.Handle, 0, 0, SRCCOPY);
  ReleaseDC(Handle, DC);
end;


procedure TTracks.Refresh;
begin
  HideMyCaret;
  RemoveSelection;
  RedrawTracks(0);
  RecreateCaret;
  SetCaretPosition;
  ShowMyCaret;
end;


procedure TTestLine.RedrawTestLine;
var
  DC1: HDC;
  s: string;
  p: THANDLE;
begin
  if not TMDIChild(ParWind).Visible then
    Exit;
  if TMDIChild(ParWind).Closed then
    Exit;
  if TMDIChild(ParWind).VTMP = nil then
    Exit;


  if DC = 0 then
    DC1 := GetDC(Handle)
  else
    DC1 := DC;
  p := SelectObject(DC1, Font.Handle);
  SetBkColor(DC1, GetSysColor(COLOR_WINDOW));
  SetTextColor(DC1, GetSysColor(COLOR_WINDOWTEXT));
  with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)] do
  begin
    s := Int4DToStr(Envelope) + '|' + Int2DToStr(Noise) + '|';
    with Channel[0] do
    begin
      s := s + NoteToStr(Note) + ' ' + SampToStr(Sample) + Int1DToStr(Envelope) + Int1DToStr(Ornament) + Int1DToStr(Volume) + ' ' + Int1DToStr(Additional_Command.Number) + Int1DToStr(Additional_Command.Delay) + Int2DToStr(Additional_Command.Parameter);
    end
  end;
  TextOut(DC1, 0, 0, PChar(s), Length(s));
  SelectObject(DC1, p);
  if DC = 0 then
    ReleaseDC(Handle, DC1)
end;

procedure TSamples.SetCaretPosition;
begin
  if not Focused then Exit;
  SetCaretPos(CelW * (3 + CursorX), CelH * CursorY);
end;

procedure TSamples.ShowMyCaret;
begin
  if CaretVisible or isSelecting or isColSelecting then Exit;
  ShowCaret(Handle);
  CaretVisible := True;
end;

procedure TSamples.HideMyCaret;
begin
  if not CaretVisible then Exit;
  HideCaret(Handle);
  CaretVisible := False;
end;


function TSamples.CurrentLine: Integer;
begin
  Result := ShownFrom + CursorY;
end;


procedure TSamples.RecalcBaseNote(NewBaseNote: Integer);
var
  Line, FromLine, ToLine, Delta: Integer;
  BaseNoteFreq, NewNoteFreq: Word;

begin
  if ShownSample = nil then Exit;
  if not TMDIChild(ParentWin).RecalcTonesBtn.Down then Exit;

  TMDIChild(ParentWin).SaveSampleUndo(ShownSample);

  with TMDIChild(ParentWin) do begin
    BaseNoteFreq := GetNoteFreq(VTMP.Ton_Table, VTMP.Patterns[-1].Items[1].Channel[0].Note);
    NewNoteFreq  := GetNoteFreq(VTMP.Ton_Table, NewBaseNote);
    Delta        := NewNoteFreq - BaseNoteFreq;
  end;

  if isSelecting then begin
    FromLine := selStart;
    ToLine   := selEnd;
  end
  else if isColSelecting and (SampleCopy.FromColumn <= 4) and (SampleCopy.ToColumn >= 4) then begin
    FromLine := SampleCopy.FromLine;
    ToLine   := SampleCopy.ToLine;
  end
  else begin
    FromLine := 0;
    ToLine   := ShownSample.Length - 1;
  end;

  for Line := FromLine to ToLine do
    ShownSample.Items[Line].Add_to_Ton := ShownSample.Items[Line].Add_to_Ton - Delta;

  TMDIChild(ParentWin).SongChanged := True;
  TMDIChild(ParentWin).BackupSongChanged := True;

  HideMyCaret;
  RedrawSamples(0);
  ShowMyCaret;
  TMDIChild(ParentWin).SaveSampleRedo;
end;


procedure TSamples.SetNote(Note: ShortInt; Line: Integer; Volume: ShortInt; Redraw, CalcOctave, SetTone: Boolean);
var
  i: Integer;
  NoteFreq, BaseNoteFreq, FreqAccum: Word;
  SampleLine: TSampleTick;

begin
  if Note = -1 then Exit;
  if Note = -3 then Exit;

  TMDIChild(ParentWin).SongChanged := True;
  TMDIChild(ParentWin).BackupSongChanged := True;

  // -2 - Sound off (R--)
  if Note = -2 then begin
    ShownSample.Items[Line].Mixer_Ton   := False;
    ShownSample.Items[Line].Mixer_Noise := False;
    ShownSample.Items[Line].Envelope_Enabled := False;
    ShownSample.Items[Line].Add_to_Ton := 0;
    ShownSample.Items[Line].Ton_Accumulation := False;
    ShownSample.Items[Line].Amplitude_Sliding := False;
    ShownSample.Items[Line].Amplitude_Slide_Up := False;
    ShownSample.Items[Line].Envelope_or_Noise_Accumulation := False;
    ShownSample.Items[Line].Add_to_Envelope_or_Noise := 0;

    if Line > 0 then
      ShownSample.Items[Line].Amplitude := ShownSample.Items[Line-1].Amplitude;

    Exit;
  end;


  // Get note by octave
  if CalcOctave then
    Inc(Note, (TMDIChild(ParentWin).SamOctaveNum.Position - 1) * 12);

  // Is note out of range?
  if LongWord(Note) >= 96 then Exit;

  // Init
  with (TMDIChild(ParentWin)) do begin
    FreqAccum    := 0;
    NoteFreq     := GetNoteFreq(VTMP.Ton_Table, Note);
    BaseNoteFreq := GetNoteFreq(VTMP.Ton_Table, VTMP.Patterns[-1].Items[1].Channel[0].Note);
  end;

  // Calculate frequency accumulation
  for i := 0 to Line-1 do begin
    SampleLine := ShownSample.Items[i];
    if SampleLine.Ton_Accumulation then
      FreqAccum := FreqAccum + SampleLine.Add_to_Ton;
  end;

  // Set tone shift
  ShownSample.Items[Line].Add_to_Ton := NoteFreq - BaseNoteFreq - FreqAccum;

  // Set T mask
  if SetTone then
    ShownSample.Items[Line].Mixer_Ton := True;

  // Set volume
  if Volume > 0 then
    ShownSample.Items[Line].Amplitude := Volume;

  // Redraw samples
  if Redraw then begin
    HideMyCaret;
    RedrawSamples(0);
    ShowMyCaret;
  end;
end;


procedure TSamples.RedrawSamples;

const
  XPosLineNums = 0;
  XPosTone = 3;
  XPosNoise = 4;
  XPosEnvelope = 5;
  XPosToneSign = 7;
  XPosToneValue = 8;
  XPosToneAccumulationSign = 11;
  XPosNoiseSign = 13;
  XPosNoiseBracket1 = 16;
  XPosNoiseBracket2 = 19;
  XPosNoise1 = 14;
  XPosNoise2 = 17;
  XPosNoiseAccumulationSign = 20;
  XPosAmplitude = 22;
  XPosAmplitudeAccumulationSign = 23;
  XPosAmplitudeBars = 25;

var
  Line, X, Y, SampleLen, LastDataLine, LoopLine, SepX, i: Integer;
  SelLine, Selection, Highlight, EmptySample: Boolean;
  BaseNote: ShortInt;
  BaseNoteFreq, LineFreq, PrevLineFreq, FreqAccum: Word;
  PrevNoteStr: String;
  ToneTable: Byte;
  ToneTablePtr: PPT3ToneTable;
  Sample: TSample;
  Color: TColor;
  DC1: HDC;
  s, SamStr: string;
  p: THANDLE;

  procedure Print(X, Y: Integer; Str: string);
  begin
    fBitmap.Canvas.TextOut(X, Y, Str);
  end;

  procedure TextColor(Color: TColor);
  begin
    fBitmap.Canvas.Font.Color := Color;
  end;

  procedure BgColor(Color: TColor);
  begin
    fBitmap.Canvas.Brush.Color := Color;
  end;

  procedure DrawTriangleUp(X, Y: Integer; Color: TColor);
  begin
    fBitmap.Canvas.Font := ArrowsFont;
    Y := Y + (CelH div 2) - (ArrowsFontH div 2);

    TextColor(Color);
    Print(X+2, Y, '0');

    fBitmap.Canvas.Font := Font;
  end;

  procedure DrawTriangleDown(X, Y: Integer; Color: TColor);
  begin
    fBitmap.Canvas.Font := ArrowsFont;
    Y := Y + (CelH div 2) - (ArrowsFontH div 2);

    TextColor(Color);
    Print(X+2, Y, '1');

    fBitmap.Canvas.Font := Font;
  end;

  function FindNote(SampleLine: TSampleTick): String;
  var
    Note: Integer;
    NearestNote: Integer;
    BestDistanceFoundYet: Word;
    FreqFromTable, d: Word;
    Sign: String;

  begin

    LineFreq := BaseNoteFreq + SampleLine.Add_to_Ton + FreqAccum;
    if SampleLine.Ton_Accumulation then
      FreqAccum := FreqAccum + SampleLine.Add_to_Ton;

    if LineFreq = BaseNoteFreq then begin
      Result := '=' + NoteToStr(BaseNote);
      PrevLineFreq := LineFreq;
      PrevNoteStr := Result;
      Exit;
    end;

    if LineFreq = PrevLineFreq then begin
      if PrevNoteStr = '' then
        PrevNoteStr := '=' + NoteToStr(BaseNote);
      Result := PrevNoteStr;
      Exit;
    end;

    // Search nearest freq in the tone table
    NearestNote := -1;
    BestDistanceFoundYet := $FFFF;
    for Note := Length(ToneTablePtr^)-1 downto 0 do begin
      FreqFromTable := ToneTablePtr^[Note];

      // desired frequency found
      if FreqFromTable = LineFreq then begin
        Result := '=' + NoteToStr(Note);
        Exit;
      end;

      d := Abs(LineFreq - FreqFromTable);
      if d < BestDistanceFoundYet then begin
        BestDistanceFoundYet := d;
        NearestNote := Note;
        if LineFreq > FreqFromTable then
          Sign := '<'
        else
          Sign := '>';
      end;
    end;

    Result := Sign + NoteToStr(NearestNote);
    PrevNoteStr := Result;
    PrevLineFreq := LineFreq;
  end;

  function isColSelected(ColNum: Integer): Boolean;
  begin
    Result := isColSelecting and
              (ColNum >= SampleCopy.FromColumn) and
              (ColNum <= SampleCopy.ToColumn) and
              (Line >= SampleCopy.FromLine) and
              (Line <= SampleCopy.ToLine);
  end;

begin

  if not ParentWin.Visible then
    Exit;
  if TMDIChild(ParentWin).VTMP = nil then
    Exit;
  if TMDIChild(ParentWin).Closed then
    Exit;

  if DC = 0 then
    DC1 := GetDC(Handle)
  else
    DC1 := DC;

  if (fBitmap.Width <> ClientWidth) or (fBitmap.Height <> ClientHeight) then
  begin
    fBitmap.Width := ClientWidth;
    fBitmap.Height := ClientHeight;
    fBitmap.Canvas.Font := Font;
  end;

  p := SelectObject(DC1, Font.Handle);

  if ShownSample = nil then
  begin
    Sample := GetEmptySample;
    ShownSample := @Sample;
    EmptySample := True;
  end
  else
    EmptySample := False;
  SampleLen := ShownSample.Length;
  LoopLine  := ShownSample.Loop;

  // Get:
  // 1. Tone table of track
  // 2. Base note from testline
  // 3. Base note frequence.
  with TMDIChild(ParentWin) do begin
    ToneTable := VTMP.Ton_Table;
    BaseNote  := VTMP.Patterns[-1].Items[1].Channel[0].Note;
    BaseNoteFreq := GetNoteFreq(ToneTable, BaseNote);
  end;
  LineFreq  := 0;
  FreqAccum := 0;
  PrevLineFreq := 0;

  // Pointer to current tone table.
  case ToneTable of
    0: ToneTablePtr := @PT3NoteTable_PT;
    1: ToneTablePtr := @PT3NoteTable_ST;
    2: ToneTablePtr := @PT3NoteTable_ASM;
    3: ToneTablePtr := @PT3NoteTable_REAL;
  else
    ToneTablePtr := @PT3NoteTable_NATURAL;
  end;

  // Search last not empty line
  LastDataLine := 0;
  for i := MaxSamLen-1 downto ShownSample.Length do
    with ShownSample.Items[i] do
      if (Add_to_Ton <> 0) or (Amplitude <> 0) or (Add_to_Envelope_or_Noise <> 0) or
         Ton_Accumulation or Amplitude_Sliding or Envelope_Enabled or
         Envelope_or_Noise_Accumulation or Mixer_Ton or Mixer_Noise
      then
      begin
        LastDataLine := i;
        Break;
      end;

  if LastDataLine < ShownSample.Length - 1 then
    LastDataLine := ShownSample.Length - 1;


  // Fill background color
  BgColor(CSamOrnBackground);
  fBitmap.Canvas.FillRect(Rect(0, 0, ClientWidth, ClientHeight));

  Y := 0;
  for Line := ShownFrom to ShownFrom + NOfLines do
  begin

    // Finish
    if Line >= MaxSamLen then Break;

    // Start
    if (Line < LoopLine) or (Line >= SampleLen) then
    begin
      BgColor(CSamOrnBackground);
      TextColor(CSamOrnText);
      SelLine := False;
    end
    else
    begin
      BgColor(CSamOrnBackground);
      TextColor(CSamOrnSelText);
      SelLine := True;
    end;

    Highlight := False;
    Selection := isSelecting and (Line >= selStart) and (Line <= selEnd);
    if Selection then
    begin
      BgColor(CSamOrnSelBackground);
      TextColor(CSamOrnSelLineNum);
    end

    else if HighlightSpeedOn and (TMDIChild(ParentWin).VTMP.Initial_Delay <> 0) and ((Line mod TMDIChild(ParentWin).VTMP.Initial_Delay) = 0) and (Line < SampleLen) then
    begin
      Highlight := True;
      BgColor(CHighlBackground);
      TextColor(CSamOrnSelText);
    end;



    // Get line string
    SamStr := GetSampleStringForRedraw(ShownSample.Items[Line]);
    Print(3*CelW, Y, SamStr);


    // Is T column selected?
    if isColSelected(1) then begin
      TextColor(CSamOrnSelLineNum);
      BgColor(CSamOrnSelBackground);
      Print(XPosTone*CelW, Y, SamStr[1]);
    end;

    // Is N column selected?
    if isColSelected(2) then begin
      TextColor(CSamOrnSelLineNum);
      BgColor(CSamOrnSelBackground);
      Print(XPosNoise*CelW, Y, SamStr[2]);
    end;

    // Is E column selected?
    if isColSelected(3) then begin
      TextColor(CSamOrnSelLineNum);
      BgColor(CSamOrnSelBackground);
      Print(XPosEnvelope*CelW, Y, SamStr[3]);
    end;

    // Is Tone Shift column selected?
    if isColSelected(4) then begin
      TextColor(CSamOrnSelLineNum);
      BgColor(CSamOrnSelBackground);
      Print(XPosToneSign*CelW, Y, SamStr[5]);
      Print(XPosToneAccumulationSign*CelW, Y, SamStr[9]);
    end;

    // Is Noise column selected?
    if isColSelected(5) then begin
      TextColor(CSamOrnSelLineNum);
      BgColor(CSamOrnSelBackground);
      Print(XPosNoiseSign*CelW, Y, SamStr[11]);
      Print(XPosNoiseBracket1*CelW, Y, '(');
      Print(XPosNoiseBracket2*CelW, Y, ')');
      Print(XPosNoiseAccumulationSign*CelW, Y, SamStr[18]);
    end;

    // Is Amplitude value column selected?
    if isColSelected(6) then begin
      TextColor(CSamOrnSelLineNum);
      BgColor(CSamOrnSelBackground);
      Print(XPosAmplitude*CelW, Y, SamStr[20]);
      Print(XPosAmplitudeAccumulationSign*CelW, Y, SamStr[21]);
      Print(XPosAmplitudeBars*CelW, Y, StringOfChar(' ', 16));
    end;


    if SelLine then
    begin
      BgColor(CSamOrnSelBackground);
      TextColor(CSamOrnSelLineNum);
    end
    else
    begin
      BgColor(CSamOrnBackground);
      TextColor(CSamOrnLineNum);
    end;

    if DecBaseLinesOn then
    begin
      s := Format('%.2d', [Line mod 100]);
      if Line = 100 then
        s := '@1';
      if Line = 200 then
        s := '@2';
    end
    else
      s := IntToHex(Line, 2);

    // Background layer for loops
    if SelLine then
    begin
      Print(XPosLineNums, Y, ' ');
      Print(XPosLineNums + 2*CelW - (CelW div 2), Y, ' ');
    end;

    // Draw line numbers
    Print(XPosLineNums+3, Y, s);
    BgColor(CSamOrnBackground);





    //Tone shift
    if Selection or isColSelected(4) then
    begin
      TextColor(CSamOrnSelLineNum);
      BgColor(CSamOrnSelBackground);
    end
    else if Highlight then
    begin
      TextColor(CSamOrnSelText);
      BgColor(CHighlBackground);
    end
    else if SelLine then
      TextColor(CSamOrnSelTone)
    else
      TextColor(CSamOrnTone);


    if ToneShiftAsNote then begin

      if Line > LastDataLine then
        s := '+000'
      else if BaseNote <> -2 then
        s := FindNote(ShownSample.Items[Line])
      else
        s := '+000';
      Print(XPosToneValue*CelW, Y, s[2]+s[3]+s[4]);

      if Highlight or Selection then
        //
      else if SelLine then
        TextColor(CSamOrnSelText)
      else
        TextColor(CSamOrnText);
      Print(XPosToneSign*CelW, Y, s[1]);

    end
    else
      Print(XPosToneValue*CelW, Y, SamStr[6]+SamStr[7]+SamStr[8]);


    // Tone accumulation
    if ShownSample.Items[Line].Ton_Accumulation then
    begin
      Color := CSamOrnText;
      DrawTriangleUp(XPosToneAccumulationSign*CelW, Y, Color);
    end;


    // Noise
    BgColor(CSamOrnBackground);
    if Selection or isColSelected(5) then
    begin
      TextColor(CSamOrnSelLineNum);
      BgColor(CSamOrnSelBackground);
    end
    else if Highlight then
    begin
      TextColor(CSamOrnSelText);
      BgColor(CHighlBackground);
    end
    else if SelLine then
      TextColor(CSamSelNoise)
    else
      TextColor(CSamNoise);
    Print(XPosNoise1*CelW, Y, SamStr[12]+SamStr[13]);
    Print(XPosNoise2*CelW, Y, SamStr[15]+SamStr[16]);


    // Noise accumulation
    if ShownSample.Items[Line].Envelope_or_Noise_Accumulation then
    begin
      if Selection then
        Color := CSamOrnSelLineNum
      else
        Color := CSamOrnText;
      DrawTriangleUp(XPosNoiseAccumulationSign*CelW, Y, Color);
    end;


    // Amplitude sliding sign
    if ShownSample.Items[Line].Amplitude_Sliding then begin
      BgColor(CSamOrnBackground);
      if Selection or isColSelected(6) then
      begin
        Color := CSamOrnSelLineNum;
        BgColor(CSamOrnSelBackground);
      end
      else if Highlight then
      begin
        Color := CSamOrnSelText;
        BgColor(CHighlBackground);
      end
      else if SelLine then
        Color := CSamOrnSelText
      else
        Color := CSamOrnText;

      if ShownSample.Items[Line].Amplitude_Slide_Up then
        DrawTriangleUp(XPosAmplitudeAccumulationSign*CelW, Y, Color)
      else
        DrawTriangleDown(XPosAmplitudeAccumulationSign*CelW, Y, Color);
    end;



    // Volume
    if Highlight then
      BgColor(CSamOrnSelText)
    else if Selection  or isColSelected(6) then
      BgColor(CSamOrnSelLineNum)
    else if SelLine then
      BgColor(CSamOrnSelText)
    else
      BgColor(CSamOrnText);
    if ShownSample.Items[Line].Amplitude > 0 then
      for i := 0 to ShownSample.Items[Line].Amplitude-1 do
      begin
        X := (XPosAmplitudeBars+i)*CelW;
        fBitmap.Canvas.FillRect(Rect(X, Y+2, X+CelW-2, Y+CelH-1));
      end;

    Inc(Y, CelH);

  end;

  // Separator
  SepX := (2*CelW) + (CelW div 2);
  BgColor(CSamOrnSeparators);
  fBitmap.Canvas.FillRect(Rect(SepX, 0, SepX+2, Y));

  // Copy shadow bitmap
  BitBlt(DC1, 0, 0, Width, Height, fBitmap.Canvas.Handle, 0, 0, SRCCOPY);

  SelectObject(DC1, p);
  if DC = 0 then
    ReleaseDC(Handle, DC1);

  if EmptySample then
    ShownSample := nil;
end;

procedure TOrnaments.SetCaretPosition;
begin
  if not Focused then Exit;
  SetCaretPos(CelW * (3 + CursorX + OrnXShift), CelH * CursorY);
end;

procedure TOrnaments.ShowMyCaret;
begin
  if CaretVisible or isSelecting then Exit;
  ShowCaret(Handle);
  CaretVisible := True;
end;

procedure TOrnaments.HideMyCaret;
begin
  if not CaretVisible then Exit;
  HideCaret(Handle);
  CaretVisible := False;
end;


procedure TOrnaments.InitMetrix;
var
  DC: HDC;
  sz: tagSIZE;
  p: HFONT;
begin

  if DecBaseLinesOn then
  begin
    OrnNChars := 10;
    OrnXShift := 1;
  end
  else
  begin
    OrnNChars := 9;
    OrnXShift := 0;
  end;

  Font := MainForm.EditorFont;

  DC := GetDC(Handle);
  p := SelectObject(DC, Font.Handle);
  GetTextExtentPoint32(DC, '0', 1, sz);
  CelW := sz.cx;
  CelH := sz.cy;
  SelectObject(DC, p);

  Browser.Font.Size := MainForm.EditorFont.Size - 9;
  if Browser.Font.Size < 10 then Browser.Font.Size := 10;
  if Browser.Font.Size > 12 then Browser.Font.Size := 12;  


  p := SelectObject(DC, Browser.Font.Handle);
  GetTextExtentPoint32(DC, '0', 1, sz);
  Browser.ItemHeight := sz.cy+1;
  SelectObject(DC, p);

  fBitmap.Free;
  fBitmap := TBitmap.Create;
  fBitmap.Canvas.Font := Font;

  ClientWidth := CelW * OrnNCol * OrnNChars;
  if ClientWidth < 400 then ClientWidth := 400;

  ReleaseDC(Handle, DC);
end;


procedure TOrnaments.ClearSelection;
var i: Integer;
begin
  if not isSelecting then Exit;
  for i := selStart to selEnd do
    ShownOrnament.Items[i] := 0;
  isSelecting := False;
  HideMyCaret;
  RedrawOrnaments(0);
  ShowMyCaret;
end;


procedure TOrnaments.CopyToClipBoard;
begin
  TMDIChild(ParentWin).copyOrnamentToBuffer(False);
end;


procedure TOrnaments.CutToClipBoard;
begin
  if not isSelecting then Exit;
  CopyToClipBoard;
  with TMDIChild(ParentWin) do begin
    SaveOrnamentUndo;
    ShownOrnament.Loop := 0;
    ShownOrnament.Length := 1;
    OrnamentLoopUpDown.Position := 0;
    OrnamentLenUpDown.Position  := 1;
    SaveOrnamentRedo;
  end;
  isSelecting := True;
  ClearSelection;
end;


function TOrnaments.CurrentLine: Integer;
begin
  Result := ShownFrom + (CursorY + (CursorX div OrnNChars) * NRaw);
end;


procedure TOrnaments.SetNote(Note: ShortInt; Line: Integer; CalcOctave, Redraw: Boolean);
var
  BaseNote: ShortInt;
begin
  TMDIChild(ParentWin).SongChanged := True;
  TMDIChild(ParentWin).BackupSongChanged := True;
  
  with TMDIChild(ParentWin) do begin
    ValidateOrnament(OrnNum);
    BaseNote := VTMP.Patterns[-1].Items[0].Channel[0].Note;
  end;

  if CalcOctave then
    Inc(Note, (TMDIChild(ParentWin).OrnOctaveNum.Position - 1) * 12);

  if LongWord(Note) >= 96 then Exit;
  ShownOrnament.Items[Line] := Note - BaseNote;

  if Redraw then begin
    HideMyCaret;
    RedrawOrnaments(0);
    ShowMyCaret;
  end;

end;

procedure TOrnaments.RedrawOrnaments;
var
  Line, OrnLength, Loop, x, y, num, i, LastDataLine: Integer;
  DC1: HDC;
  s: string;
  SelLine, Selection: Boolean;
  p: HFONT;
  BaseNote: ShortInt;

  procedure Print(X, Y: Integer; Str: string);
  begin
    fBitmap.Canvas.TextOut(X, Y, Str);
  end;

  procedure TextColor(Color: TColor);
  begin
    fBitmap.Canvas.Font.Color := Color;
  end;

  procedure BgColor(Color: TColor);
  begin
    fBitmap.Canvas.Brush.Color := Color;
  end;

begin

  if not ParentWin.Visible then
    Exit;
  if TMDIChild(ParentWin).VTMP = nil then
    Exit;
  if TMDIChild(ParentWin).Closed then
    Exit;

  if DC = 0 then
    DC1 := GetDC(Handle)
  else
    DC1 := DC;


  if (fBitmap.Width <> ClientWidth) or (fBitmap.Height <> ClientHeight) then
  begin
    fBitmap.Width := ClientWidth;
    fBitmap.Height := ClientHeight;
    fBitmap.Canvas.Font := Font;
  end;

  p := SelectObject(DC1, Font.Handle);


  with TMDIChild(ParentWin) do
    BaseNote  := VTMP.Patterns[-1].Items[0].Channel[0].Note;

  if ShownOrnament = nil then
    TMDIChild(ParentWin).ValidateOrnament(TMDIChild(ParentWin).OrnNum);

  x := 0;
  y := 0;
  OrnLength := ShownOrnament.Length;
  Loop := ShownOrnament.Loop;


  // Search last not empty line
  LastDataLine := 0;
  for i := MaxOrnLen-1 downto ShownOrnament.Length do
    if ShownOrnament.Items[i] > 0 then begin
      LastDataLine := i;
      Break;
    end;

  if LastDataLine < ShownOrnament.Length - 1 then
    LastDataLine := ShownOrnament.Length - 1;

    
  // Clear bitmap
  BgColor(CSamOrnBackground);
  fBitmap.Canvas.FillRect(Rect(0, 0, ClientWidth, ClientHeight));

  for Line := ShownFrom to ShownFrom + NOfLines - 1 do
  begin
    if Line > MaxOrnLen then Break;

    if (Line < OrnLength) and (Line >= Loop) then
    begin
      TextColor(CSamOrnSelTone);
      SelLine := True;
    end
    else
    begin
      TextColor(CSamOrnTone);
      SelLine := False;
    end;
    BgColor(CSamOrnBackground);


    Selection := isSelecting and (Line <= selEnd) and (Line >= selStart);
    if Selection then
    begin
      BgColor(CSamOrnSelBackground);
      TextColor(CSamOrnSelLineNum);
    end

    else
    if (MainForm.MDIChildCount <> 0) and (TMDIChild(ParentWin).VTMP.Initial_Delay <> 0) then
      if ((Line mod TMDIChild(ParentWin).VTMP.Initial_Delay) = 0) and (Line < OrnLength) and HighlightSpeedOn then begin
        BgColor(CHighlBackground);
        TextColor(CSamOrnSelText);
      end;


    // Ornament items
    if ToneShiftAsNote then
      if Line > LastDataLine then
        s := '+00 '
      else
        if ShownOrnament.Items[Line] > 91 then
          s := 'C-1'
        else
          s := NoteToStr(BaseNote + ShownOrnament.Items[Line]) + ' '
    else
      if ShownOrnament = nil then
        s := '+00 '
      else if ShownOrnament.Items[Line] >= 0 then
        s := '+' + Int2ToStr(ShownOrnament.Items[Line]) + ' '
      else
        s := '-' + Int2ToStr(-ShownOrnament.Items[Line]) + ' ';

    Print((3+OrnXShift)*Celw + x, y, s);


    // Line numbers
    if SelLine then
    begin
      BgColor(CSamOrnSelBackground);
      Print(x, y, ' ');
      Print(x + ((2+OrnXShift)*CelW) - (CelW div 2), y, ' ');
    end
    else
      BgColor(CSamOrnBackground);

    if DecBaseLinesOn then
      s := Format('%.3d', [Line])
    else
      s := IntToHex(Line, 2);

    if SelLine then
      TextColor(CSamOrnSelLineNum)
    else
      TextColor(CSamOrnLineNum);
    Print(x+2, y, s);

    BgColor(CSamOrnBackground);


    if (Line - ShownFrom) mod NRaw = NRaw - 1 then
    begin
      y := 0;
      Inc(x, CelW * OrnNChars);
    end
    else
      Inc(y, CelH);
  end;

  // Separators
  x := 0;
  for i := 0 to OrnNCol-1 do
  begin
    BgColor(CSamOrnSeparators);
    num := x + (2*CelW) + (CelW div 2)+ (OrnXShift*CelW);
    fBitmap.Canvas.FillRect(Rect(num, 0, num+2, NRaw * CelH));
    Inc(x, CelW * OrnNChars);
  end;

  // Copy shadow bitmap
  BitBlt(DC1, 0, 0, Width, Height, fBitmap.Canvas.Handle, 0, 0, SRCCOPY);

  SelectObject(DC1, p);
  if DC = 0 then
    ReleaseDC(Handle, DC1);
end;

procedure TOrnaments.DoHint;
var s: string;
begin
  {$IFDEF DEBUG}Exit;{$ENDIF}
  Application.HintHidePause := 9300;
  if CursorX in [0, 9, 18, 27] then
  begin
    s := 'Half shift tone.' + Chr(13) + Chr(13);
    s := s + 'Right Mouse Button for -/+' + Chr(13);
    s := s + 'Shift + Cursor UP/Down - Select lines' + Chr(13);
    s := s + 'Shift + Drag mouse - Select lines' + Chr(13)+ Chr(13);
    s := s + 'CTRL+C, CTRL+V - To copy/paste'+ Chr(13);
    s := s + 'Drag RIGHT mouse button for length & loop';
  end;
  MainForm.StatusBar.Panels[0].Text := s;
  if DisableHints then
    ShowHint := False
  else
  begin
    ShowHint := True;
    Hint := s;
  end;
end;

function ColSpace(i: Integer): Boolean;
begin
  Result := i in [4, 7, 11, 16, 21, 25, 30, 35, 39, 44]
end;

const
  ColTabs: array[0..11] of Integer = (0, 5, 8, 12, 17, 22, 26, 31, 36, 40, 45, 49);
  ColTabsR: array[0..11] of Integer = (0, 3, 6, 8, 15, 20, 22, 29, 34, 36, 43, 48);
  ColTabsL: array[0..12] of Integer = (0, 5, 8, 12, 17, 22, 26, 31, 36, 40, 45, 46, 49);
  SColTabs: array[0..6] of Integer = (0, 5, 11, 14, 19, 20, 21);
  NoteTabs: array[0..2] of Integer = (8, 22, 36);
  NotePoses =[8, 22, 36];
  ChanPoses =[8, 12..20, 22, 26..34, 36, 40..48];
  EnvelopePoses =[0..3];
  SamTabs: array[0..2] of Integer = (12, 26, 40);
  SamPoses =[12, 26, 40];

function ColTab(i: Integer): Integer;
var
  j: Integer;
begin
  j := 0;
  while i >= ColTabs[j] do
    Inc(j);
  Result := j - 1
end;

function ColTab1(i: Integer; var ColTabs1: array of Integer): Integer;
var
  j: Integer;
begin
  j := 0;
  while i >= ColTabs1[j] do
    Inc(j);
  Result := j - 1
end;

function SColTab(i: Integer): Integer;
var
  j: Integer;
begin
  j := 0;
  while i >= SColTabs[j] do
    Inc(j);
  Result := j - 1
end;

procedure TTracks.DoHint;
var
  s: string;
begin
  {$IFDEF DEBUG}Exit;{$ENDIF}
  if IsSelected then begin
    ShowHint := False;
    Exit;
  end;
  Application.HintHidePause := 9000;
  case CursorX of
    0..3:
      s := 'Envelope generator period (hex range 0-FFFF).' + Chr(13) + 'Set envelope type to 1-E.';
    5..6:
      begin
        if DecBaseNoiseOn then
          s := 'Noise generator base period (decimal range 0-31).'
        else
          s := 'Noise generator base period (hex range 0-1F).';
      end;
    8, 22, 36:
      s := 'Note from C-1 to B-8.' + Chr(13) + 'Numpad 1-8 to octave.' + Chr(13) + 'A to R-- (release).';

    12, 26, 40:
      s := 'Sample (1-9, A-V).' + Chr(13) + 'Used with note or R--.' + Chr(13)+Chr(13)+ 'Ctrl+Enter, Ctrl+Click -- edit sample.';

    13, 27, 41:
      s := 'Envelope type (hex 1-E) or envelope off (F).' + Chr(13) + '0th ornament can be set only with 1-F.';

    14, 28, 42:
      s := 'Ornament (hex 0-F). 0th ornament can be set' + Chr(13) + 'only with envelope type or off (1-F).' +Chr(13)+Chr(13)+ 'Ctrl+Enter, Ctrl+Click -- edit ornament.';

    15, 29, 43:
      s := 'Volume (hex 1-F).' + Chr(13) + 'Use R-- instead of volume 0.';
    17, 31, 45:
      s := 'Special command:' + Chr(13) + '1 - Tone slide Down' + Chr(13) + '2 - Tone slide Up' + Chr(13) + '3 - Tone portamento' + Chr(13) + '4 - Sample offset' + Chr(13) + '5 - Ornament offset' + Chr(13) + '6 - Vibrato' + Chr(13) + '9 - Envelope slide Down' + Chr(13) + 'A - Envelope slide Up' + Chr(13) + 'B - Set Speed';
    18, 32, 46:
      s := 'Delay for commands 1-3, 9-A (1-F for change period, 0 for stop).';
    19, 33, 47:
      s := 'Hi digit for commands 1-5, 9-B. Hex: 0-F.' + #13 +'OR 1st parameter for command 6 (Vibrato)' + Chr(13) + '(1-F to sound on period, 0 to stop).';
    20, 34, 48:
      s := 'Lo digit for commands 1-5, 9-B. Hex: 0-F' +#13+ 'OR second parameter for command 6 (Vibrato)' + Chr(13) + '(1-F to sound off period, 0 to stop after sound on period).';
  end;
  if not (CursorX in [19, 33, 47, 20, 34, 48]) then begin
    s := s + Chr(13) + Chr(13) + 'Ctrl + Space to Autostep On/Off' + Chr(13);
    s := s + 'Ctrl + 0..9 - Step for Autostep.' + Chr(13);
    s := s + 'Numpad 0 to Autoenvelope.';
  end;
  MainForm.StatusBar.Panels[0].Text := s;
  if DisableHints then
    ShowHint := False
  else
  begin
    ShowHint := True;
    Hint := s;
  end;
end;

procedure TTracks.CreateMyCaret;
begin
  DoHint;
  if CursorX in [8, 22, 36] then
  begin
    BigCaret := True;
    CreateCaret(Handle, 0, CelW * 3, CelH)
  end
  else
  begin
    BigCaret := False;
    CreateCaret(Handle, 0, CelW, CelH)
  end
end;

procedure TTracks.RecreateCaret;
begin
  DoHint;
  if CursorX in [8, 22, 36] then
  begin
    if not BigCaret then
    begin
      CaretVisible := False;
      DestroyCaret;
      CreateMyCaret;
      ShowMyCaret;
    end
  end
  else if BigCaret then
  begin
    CaretVisible := False;
    DestroyCaret;
    CreateMyCaret;
    ShowMyCaret;
  end
end;

procedure TTracks.SetCaretPosition;
begin
  SetCaretPos(CelW * (TracksCursorXLeft + CursorX), CelH * CursorY);
end;

procedure TTracks.ShowMyCaret;
begin
  if CaretVisible or IsTrackPlaying or IsSelected then Exit;
  ShowCaret(Handle);
  CaretVisible := True;
end;

procedure TTracks.HideMyCaret;
begin
  if not CaretVisible then Exit;
  HideCaret(Handle);
  CaretVisible := False;
end;

procedure TTestLine.CreateMyCaret;
begin
  if CursorX = 8 then
  begin
    BigCaret := True;
    CreateCaret(Handle, 0, CelW * 3, CelH)
  end
  else
  begin
    BigCaret := False;
    CreateCaret(Handle, 0, CelW, CelH)
  end
end;

procedure TTestLine.SetCaretPosition;
begin
  SetCaretPos(CelW * CursorX, 0);
end;

procedure TTestLine.RecreateCaret;
begin
  if CursorX = 8 then
  begin
    if not BigCaret then
    begin
      DestroyCaret;
      CreateMyCaret;
      ShowCaret(Handle)
    end
  end
  else if BigCaret then
  begin
    DestroyCaret;
    CreateMyCaret;
    ShowCaret(Handle)
  end
end;

procedure TSamples.CreateMyCaret;
begin
  DoHint(-1, -1);
  if CursorX = 5 then
  begin
    BigCaret := 1;
    CreateCaret(Handle, 0, CelW * 3, CelH)
  end
  else if CursorX in [11, 14] then
  begin
    BigCaret := -1;
    CreateCaret(Handle, 0, CelW * 2, CelH)
  end
  else
  begin
    BigCaret := 0;
    CreateCaret(Handle, 0, CelW, CelH)
  end
end;

procedure TSamples.RecreateCaret;
begin
  DoHint(-1, -1);
  if ((CursorX = 5) and (BigCaret <> 1)) or ((CursorX in [11, 14]) and (BigCaret <> -1)) or (not (CursorX in [5, 11, 14]) and (BigCaret <> 0)) then
  begin
    HideMyCaret;
    DestroyCaret;
    CreateMyCaret;
    ShowMyCaret;
  end
end;

procedure TMDIChild.ChangeNote;
var
  f: Boolean;
begin
  f := VTMP.Patterns[Pat].Items[Line].Channel[Chan].Note <> Note;
  if f then
  begin
    SongChanged := True;
    BackupSongChanged := True;
  end;
  if VTMP.Patterns[Pat].Items[Line].Channel[Chan].Note >= 0 then
    PlVars[1].ParamsOfChan[Chan].Note := VTMP.Patterns[Pat].Items[Line].Channel[Chan].Note;
  if not UndoWorking and f then
  begin

    if DuplicateNoteParams.Checked then
    begin
      AddUndo(CAChangeNoteAndParams, Note, 0);
      ChangeList[ChangeCount - 1].Line := Line;
      ChangeList[ChangeCount - 1].Channel := Chan
    end
    else
    begin
      AddUndo(CAChangeNote, VTMP.Patterns[Pat].Items[Line].Channel[Chan].Note, Note);
      ChangeList[ChangeCount - 1].Line := Line;
      ChangeList[ChangeCount - 1].Channel := Chan
    end;

  end;
  VTMP.Patterns[Pat].Items[Line].Channel[Chan].Note := Note
end;

procedure TMDIChild.ChangeTracks(Pat, Line, Chan, CursorX, n: Integer; Keyboard: Boolean);
var
  old, r: Integer;
  oldStr: string[2];
  newStr: string[1];
begin
  old := 0;
  case CursorX of
    0..3:
      begin
        old := VTMP.Patterns[Pat].Items[Line].Envelope;
        if Keyboard then
        begin
          r := 4 * (3 - CursorX);
          n := (old and ($FFFF xor (15 shl r))) or ((n and 15) shl r);
        end;
      end;
    5..6:
      begin
        old := VTMP.Patterns[Pat].Items[Line].Noise;
        if Keyboard then
        begin
          if DecBaseNoiseOn then
          begin

              //StrPLCopy(oldArr, Format('%.2d', [old]), High(oldArr));
            oldStr := Format('%.2d', [old]);
            newStr := IntToStr(n);

            if CursorX = 5 then
              oldStr[1] := newStr[1]
            else
              oldStr[2] := newStr[1];

            n := StrToInt(oldStr);
            if n > 31 then
              n := 31;

          end
          else
          begin
            r := 4 * (6 - CursorX);
            n := (old and ($FF xor (15 shl r))) or ((n and 15) shl r);
          end;

        end;
      end;
    19..20, 33..34, 47..48:
      begin
        old := VTMP.Patterns[Pat].Items[Line].Channel[Chan].Additional_Command.Parameter;
        if Keyboard then
          if CursorX and 1 <> 0 then
            n := (old and 15) or (n shl 4)
          else
            n := (old and $F0) or n
      end;
  end;

  if not UndoWorking then
  begin
    case CursorX of
      0..3:
        if old <> n then
          AddUndo(CAChangeEnvelopePeriod, old, n);
      5..6:
        if old <> n then
          AddUndo(CAChangeNoise, old, n);
      12, 26, 40:
        begin
          old := VTMP.Patterns[Pat].Items[Line].Channel[Chan].Sample;
          if old <> n then
            AddUndo(CAChangeSample, old, n);
        end;
      13, 27, 41:
        begin
          old := VTMP.Patterns[Pat].Items[Line].Channel[Chan].Envelope;
          if old <> n then
            AddUndo(CAChangeEnvelopeType, old, n);
        end;
      14, 28, 42:
        begin
          old := VTMP.Patterns[Pat].Items[Line].Channel[Chan].Ornament;
          if old <> n then
            AddUndo(CAChangeOrnament, old, n);
        end;
      15, 29, 43:
        begin
          old := VTMP.Patterns[Pat].Items[Line].Channel[Chan].Volume;
          if old <> n then
            AddUndo(CAChangeVolume, old, n);
        end;
      17, 31, 45:
        begin
          old := VTMP.Patterns[Pat].Items[Line].Channel[Chan].Additional_Command.Number;
          if old <> n then
            AddUndo(CAChangeSpecialCommandNumber, old, n);
        end;
      18, 32, 46:
        begin
          old := VTMP.Patterns[Pat].Items[Line].Channel[Chan].Additional_Command.Delay;
          if old <> n then
            AddUndo(CAChangeSpecialCommandDelay, old, n);
        end;
      19..20, 33..34, 47..48:
        if old <> n then
          AddUndo(CAChangeSpecialCommandParameter, old, n);
    end;
    if old <> n then
    begin
      if CursorX > 6 then
        ChangeList[ChangeCount - 1].Channel := Chan;
      ChangeList[ChangeCount - 1].Line := Line;
    end;
  end;

  if old <> n then
  begin
    SongChanged := True;
    BackupSongChanged := True;
  end;

  case CursorX of
    0..3:
      VTMP.Patterns[Pat].Items[Line].Envelope := n;
    5..6:
      VTMP.Patterns[Pat].Items[Line].Noise := n;
    12, 26, 40:
      begin
        VTMP.Patterns[Pat].Items[Line].Channel[Chan].Sample := n;
        if Tracks.LastNoteParams[Chan].Line <> Line then
          Tracks.ResetLastNoteParams(Pat, Line, Chan);
        Tracks.LastNoteParams[Chan].Sample := n;
      end;
    13, 27, 41:
      begin
        VTMP.Patterns[Pat].Items[Line].Channel[Chan].Envelope := n;
        if Tracks.LastNoteParams[Chan].Line <> Line then
          Tracks.ResetLastNoteParams(Pat, Line, Chan);
        Tracks.LastNoteParams[Chan].Envelope := n;
      end;
    14, 28, 42:
      begin
        VTMP.Patterns[Pat].Items[Line].Channel[Chan].Ornament := n;
        if Tracks.LastNoteParams[Chan].Line <> Line then
          Tracks.ResetLastNoteParams(Pat, Line, Chan);
        Tracks.LastNoteParams[Chan].Ornament := n;
      end;
    15, 29, 43:
      begin
        VTMP.Patterns[Pat].Items[Line].Channel[Chan].Volume := n;
        if Tracks.LastNoteParams[Chan].Line <> Line then
          Tracks.ResetLastNoteParams(Pat, Line, Chan);
        Tracks.LastNoteParams[Chan].Volume := n;
      end;
    17, 31, 45:
      if old <> n then
      begin
        VTMP.Patterns[Pat].Items[Line].Channel[Chan].Additional_Command.Number := n;
        CalcTotLen
      end;
    18, 32, 46:
      VTMP.Patterns[Pat].Items[Line].Channel[Chan].Additional_Command.Delay := n;
    19..20, 33..34, 47..48:
      if old <> n then
      begin
        VTMP.Patterns[Pat].Items[Line].Channel[Chan].Additional_Command.Parameter := n;
        CalcTotLen
      end;
  end;
end;

procedure TMDIChild.TLArpMidiOn(note: Integer);
begin
  NoteCounter := NoteCounter + 1;
  Arp[note] := 1;
  OrnamentTestLine.TestLineMidiOn(note);
  if MaxNote < NoteCounter then
    MaxNote := NoteCounter;
end;

procedure TMDIChild.TLArpMidiOff(note: Integer);
var
  f: Integer;
  min, len: Integer;
  Orn: array[0..96] of Integer;


  procedure ClearArp;
  var f: Integer;
  begin
    for f := 0 to 96 do
      Arp[f] := 0;
    MaxNote := 0;
  end;

begin
  NoteCounter := NoteCounter - 1;
  OrnamentTestLine.TestLineMidiOff(note);
  if NoteCounter <> 0 then Exit;
  if MaxNote < 3 then
  begin
    ClearArp;
    Exit;
  end;
  
  min := 96;
  len := 0;
  for f := 0 to 96 do
  begin
    if Arp[f] = 1 then
    begin
      if min > f then
        min := f;
      Orn[len] := f;
      len := len + 1;
    end;
  end;

{  if len < 3 then
  begin
    ClearArp;
    Exit;
  end; }

  for f := 0 to len - 1 do
    Orn[f] := Orn[f] - min;

  ValidateOrnament(OrnNum);

  ClearShownOrnament;
  Ornaments.ShownOrnament.Length := len;
  Ornaments.ShownOrnament.Loop := 0;
  
  for f := 0 to len - 1 do
    Ornaments.ShownOrnament.Items[f] := Orn[f];

  OrnamentLenUpDown.Position  := Ornaments.ShownOrnament.Length;
  OrnamentLoopUpDown.Position := Ornaments.ShownOrnament.Loop;

  Ornaments.HideMyCaret;
  Ornaments.RedrawOrnaments(0);
  Ornaments.ShowMyCaret;

//clear Arp when done
  ClearArp;


end;

procedure TMDIChild.OrnamentsMidiNoteOn(Note: Byte);
begin
  Ornaments.isLineTesting := True;
  OrnamentTestLine.KeyPressed := 0;
  OrnamentTestLine.CursorX := 8;

  if VTMP.Patterns[-1].Items[0].Channel[0].Note >= 0 then
    if not IsPlaying or (PlayMode = PMPlayLine) then
      PlVars[1].ParamsOfChan[MidChan].Note := VTMP.Patterns[-1].Items[0].Channel[0].Note;

  VTMP.Patterns[-1].Items[0].Channel[0].Note := Note;
  DoAutoEnv(-1, 0, 0);

  HideCaret(OrnamentTestLine.Handle);
  OrnamentTestLine.RedrawTestLine(0);
  ShowCaret(OrnamentTestLine.Handle);

  RestartPlayingLine(-Ord(OrnamentTestLine.TestSample) - 1);
  Ornaments.CurrentMidiNote := Note;
  PlayStopState := BStop;

  if Ornaments.ToneShiftAsNote then begin
    Ornaments.HideMyCaret;
    Ornaments.RedrawOrnaments(0);
    Ornaments.ShowMyCaret;
  end;
end;

procedure TMDIChild.OrnamentsMidiNoteOff(note: Byte);
begin
  if Ornaments.CurrentMidiNote <> note then
    Exit;
  OrnamentTestLine.TestLineExit(Self);
  Ornaments.isLineTesting := False;
  ResetPlaying;
  PlayStopState := BPlay;
end;

procedure TMDIChild.SamplesMidiNoteOn(note: Byte);
begin
  Samples.isLineTesting := True;
  SampleTestLine.KeyPressed := 0;
  SampleTestLine.CursorX := 8;

  if VTMP.Patterns[-1].Items[Ord(SampleTestLine.TestSample)].Channel[0].note >= 0 then
    if not IsPlaying or (PlayMode = PMPlayLine) then
      PlVars[1].ParamsOfChan[MidChan].note := VTMP.Patterns[-1].Items[Ord(SampleTestLine.TestSample)].Channel[0].note;
  VTMP.Patterns[-1].Items[Ord(SampleTestLine.TestSample)].Channel[0].note := note;

  DoAutoEnv(-1, Ord(SampleTestLine.TestSample), 0);
  HideCaret(SampleTestLine.Handle);
  SampleTestLine.RedrawTestLine(0);
  ShowCaret(SampleTestLine.Handle);

  Samples.HideMyCaret;
  Samples.RedrawSamples(0);
  Samples.ShowMyCaret; 

  RestartPlayingLine(-Ord(SampleTestLine.TestSample) - 1);
  PlayStopState := BStop;
  Samples.CurrentMidiNote := note;
end;

procedure TMDIChild.SamplesMidiNoteOff(note: Byte);
begin
  if Samples.CurrentMidiNote <> note then Exit;
  SampleTestLine.TestLineExit(Self);
  Samples.isLineTesting := False;
  ResetPlaying;
  PlayStopState := BPlay;
end;

procedure TMDIChild.TracksMidiNoteOn(note: SmallInt);
var
  i, j, n, y, e, old: Integer;

  procedure DuplicateMidiNoteParams(Pat, Line, Chan: byte);
  begin
    if not DuplicateNoteParams.Checked then
      Exit;

    with VTMP.Patterns[Pat].Items[Line].Channel[Chan] do
    begin
      if (Sample <> 0) or (Envelope <> 0) or (Ornament <> 0) or (Volume <> 0) then
        Exit;
      Sample := Tracks.LastNoteParams[Chan].Sample;
      Envelope := Tracks.LastNoteParams[Chan].Envelope;
      Ornament := Tracks.LastNoteParams[Chan].Ornament;
      Volume := Tracks.LastNoteParams[Chan].Volume;
    end;

  end;

begin
  if (note < 0) or (note > 96) then Exit;
  if Tracks.CurrentMidiNote = note then Exit;

  if IsPlaying then begin
    ResetPlaying;
    UnlimiteDelay := False;
  end;
  
  e := 0;
  if Tracks.CursorX in ChanPoses then
  begin
    ValidatePattern2(PatNum);
    i := Tracks.CurrentPatLine;
    if (i >= 0) and (i < Tracks.ShownPattern.Length) then
    begin
      j := ChanAlloc[(Tracks.CursorX - 8) div 14];
      Tracks.CurrentMidiNote := note;
      ChangeNote(PatNum, i, j, note);
      DuplicateMidiNoteParams(PatNum, i, j);
      DoAutoEnv(PatNum, i, j);
      Tracks.HideMyCaret;
      if DoStep(i, True, False) then
        ShowStat;
      Tracks.RedrawTracks(0);
      Tracks.ShowMyCaret;
      RestartPlayingNote(i);
    end;

  end;
  if Tracks.CursorX in EnvelopePoses then
  begin
    n := note;
    if n < 0 then
      exit;
    ValidatePattern2(PatNum);
    y := Tracks.CurrentPatLine;

    if (y >= 0) and (y < Tracks.ShownPattern.Length) then
      e := round(GetNoteFreq(VTMP.Ton_Table, n) * AutoEnv0 / AutoEnv1 / 16);
    begin
      old := VTMP.Patterns[PatNum].Items[y].Envelope;
      if not UndoWorking then
      begin
        AddUndo(CAChangeEnvelopePeriod, old, e);
        ChangeList[ChangeCount - 1].Line := y;
      end;
      VTMP.Patterns[PatNum].Items[y].Envelope := e;
      Tracks.CurrentMidiNote := note;
      SongChanged := True;
      BackupSongChanged := True;
      
      Tracks.HideMyCaret;
      if DoStep(y, True, False) then
        ShowStat;
      Tracks.RedrawTracks(0);
      Tracks.ShowMyCaret;
      RestartPlayingNote(y);
    end;
  end;
end;

procedure TMDIChild.TracksMidiNoteOff(note: SmallInt);
begin
  if Tracks.CurrentMidiNote <> note then Exit;
    
  if IsPlaying then begin
    MainForm.RestoreControls;

    if PlayMode in [PMPlayLine, PMPlayPattern] then
      ResetPlaying;

    if PlayMode = PMPlayModule then
      StopPlaying;

    PlayMode := PMPlayLine
  end;
  
  Tracks.KeyPressed := 0;
  Tracks.CurrentMidiNote := -1;
  UnlimiteDelay := False;

  Tracks.RemoveSelection;
  Tracks.HideMyCaret;
  Tracks.RecreateCaret;
  Tracks.SetCaretPosition;
  Tracks.ShowMyCaret;
  
  PlayStopState := BPlay;
end;


function TMDIChild.GetCurrentPatternLength;
begin
  Result := Tracks.ShownPattern.Length;
end;

{Tracks MIDI In}

procedure TMDIChild.OpenSampleOrnament;
var
  Line, Channel, i: Integer;
  ASample, AOrnament, AVolume, AEnvelope: Byte;
  ANote, CNote: Shortint;
  GEnvelope, GNoise, ANumber, ADelay, AParameter: Byte;
  TestSample: Boolean;

begin
  // Calculate line & channel
  Line    := Tracks.CurrentPatLine;
  Channel := (Tracks.CursorX - 8) div 14;
  Channel := ChanAlloc[Channel];

  // Get note params
  with Tracks.ShownPattern.Items[Line].Channel[Channel] do
  begin
    ANote      := Note;
    CNote      := Note;
    ASample    := Sample;
    AOrnament  := Ornament;
    AVolume    := Volume;
    AEnvelope  := Envelope;
    ANumber    := Additional_Command.Number;
    ADelay     := Additional_Command.Delay;
    AParameter := Additional_Command.Parameter;
  end;

  // Get Envelope & Noise for line
  GEnvelope  := Tracks.ShownPattern.Items[Line].Envelope;
  GNoise     := Tracks.ShownPattern.Items[Line].Noise;

  // Note not found - find previous note
  if ANote = -1 then
    for i := Line-1 downto 0 do
      if Tracks.ShownPattern.Items[i].Channel[Channel].Note <> -1 then
      begin
        ANote := Tracks.ShownPattern.Items[i].Channel[Channel].Note;
        Break;
      end;

  // Sample not found - find prev sample
  if ASample = 0 then
    for i := Line-1 downto 0 do
      if Tracks.ShownPattern.Items[i].Channel[Channel].Sample <> 0 then
      begin
        ASample := Tracks.ShownPattern.Items[i].Channel[Channel].Sample;
        Break;
      end;

  // Ornament not found - find prev ornament
  if AOrnament = 0 then
    for i := Line-1 downto 0 do
      if Tracks.ShownPattern.Items[i].Channel[Channel].Ornament <> 0 then
      begin
        AOrnament := Tracks.ShownPattern.Items[i].Channel[Channel].Ornament;
        Break;
      end;

  // Envelope not found - find prev envelope
  if AEnvelope = 0 then
    for i := Line-1 downto 0 do
      if Tracks.ShownPattern.Items[i].Channel[Channel].Envelope <> 0 then
      begin
        AEnvelope := Tracks.ShownPattern.Items[i].Channel[Channel].Envelope;
        Break;
      end;

  // Volume not found - find prev volume
  if AVolume = 0 then
    for i := Line-1 downto 0 do
      if Tracks.ShownPattern.Items[i].Channel[Channel].Volume <> 0 then
      begin
        AVolume := Tracks.ShownPattern.Items[i].Channel[Channel].Volume;
        Break;
      end;

  // Note add. param number not found
  if (CNote = -1) and (ANumber = 0) then
    for i := Line-1 downto 0 do
      with Tracks.ShownPattern.Items[i].Channel[Channel] do
        if Note <> -1 then
        begin
          ANumber := Additional_Command.Number;
          Break;
        end;

  // Note add. param Delay not found
  if (CNote = -1) and (ADelay = 0) then
    for i := Line-1 downto 0 do
      with Tracks.ShownPattern.Items[i].Channel[Channel] do
        if Note <> -1 then
        begin
          ADelay := Additional_Command.Delay;
          Break;
        end;

  // Note add. parameter not found
  if (CNote = -1) and (AParameter = 0) then
    for i := Line-1 downto 0 do
      with Tracks.ShownPattern.Items[i].Channel[Channel] do
      if Note <> -1 then
      begin
        AParameter := Additional_Command.Parameter;
        Break;
      end;

  // Line Envelope not found
  if GEnvelope = 0 then
    for i := Line-1 downto 0 do
      with Tracks.ShownPattern.Items[i] do
      if Envelope <> 0 then
      begin
        GEnvelope := Envelope;
        Break;
      end;


  // Cursor on Sample?
  if Tracks.CursorX in [12, 26, 40] then
    TestSample := True
  else
    TestSample := False;

  // Copy note params to a testline
  with VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0] do
  begin
    Note      := ANote;
    Sample    := ASample;
    Ornament  := AOrnament;
    Volume    := AVolume;
    Envelope  := AEnvelope;
    Additional_Command.Number    := ANumber;
    Additional_Command.Delay     := ADelay;
    Additional_Command.Parameter := AParameter;
  end;
  VTMP.Patterns[-1].Items[Ord(TestSample)].Envelope := GEnvelope;
  VTMP.Patterns[-1].Items[Ord(TestSample)].Noise    := GNoise;


  // Open sample
  if Tracks.CursorX in [12, 26, 40] then
  begin

    // Select sample
    SampleNumUpDown.Position := ASample;

    // Activate samples tab
    PageControl1.ActivePageIndex := 1;

    // Set focus
    if SampleTestLine.Enabled and SampleTestLine.CanFocus then
    begin
      SampleTestLine.CursorX := 8;
      SampleTestLine.SetFocus;
    end;

    HideCaret(SampleTestLine.Handle);
    SampleTestLine.CreateMyCaret;
    SampleTestLine.SetCaretPosition;
    ShowCaret(SampleTestLine.Handle);

  end;

  // Open ornament
  if Tracks.CursorX in [14, 28, 42] then
  begin

    // Select ornament
    OrnamentNumUpDown.Position := AOrnament;

    // Activate ornaments tab
    PageControl1.ActivePageIndex := 2;

    // Set focus
    if OrnamentTestLine.Enabled and OrnamentTestLine.CanFocus then
    begin
      OrnamentTestLine.CursorX := 8;
      OrnamentTestLine.SetFocus;
    end;

    HideCaret(OrnamentTestLine.Handle);
    OrnamentTestLine.CreateMyCaret;
    OrnamentTestLine.SetCaretPosition;
    ShowCaret(OrnamentTestLine.Handle);

  end;
end;

procedure TMDIChild.DoSwapChannels(RightDirect: Boolean);
var
  FromX, ToX, NumChansSelected, i: Integer;
  FromChan, ToChan: Integer;
  FromLine, ToLine, Line: Integer;
  AllocMap: Array[0..2] of Integer;
  CopyFromChannel, CopyToChannel: Integer;
  OriginalChannel: array[0..2] of TChannelLine;

begin
  //if not Tracks.IsSelected then Exit;

  // Calculate X coordinates range
  with Tracks do
    if SelX < CursorX then
    begin
      FromX := SelX;
      ToX   := CursorX;
    end
    else
    begin
      FromX := CursorX;
      ToX   := SelX;
    end;

  // Detect selected channels
  FromChan := 0;
  if (FromX <= 20) then FromChan := 0;
  if (FromX > 20) and (FromX <= 34) then FromChan := 1;
  if (FromX > 34) and (FromX <= 48) then FromChan := 2;

  ToChan := 0;
  if (ToX <= 20) then ToChan := 0;
  if (ToX > 20) and (ToX <= 34) then ToChan := 1;
  if (ToX > 34) and (ToX <= 48) then ToChan := 2;

  NumChansSelected := ToChan - FromChan + 1;


  // Save undo
  SavePatternUndo;

  // All channels selected
  if (NumChansSelected = 3) and RightDirect then
  begin
    AllocMap[0] := 1;
    AllocMap[1] := 2;
    AllocMap[2] := 0;
  end;
  if (NumChansSelected = 3) and not RightDirect then
  begin
    AllocMap[0] := 2;
    AllocMap[1] := 0;
    AllocMap[2] := 1;
  end;

  // Channel0 and Channel1 selected
  if (NumChansSelected = 2) and (FromChan = 0) and (ToChan = 1) then
  begin
    AllocMap[0] := 1;
    AllocMap[1] := 0;
    AllocMap[2] := 2;
  end;

  // Channel1 and Channel2 selected
  if (NumChansSelected = 2) and (FromChan = 1) and (ToChan = 2) then
  begin
    AllocMap[0] := 0;
    AllocMap[1] := 2;
    AllocMap[2] := 1;
  end;


  if (NumChansSelected = 1) then begin

    // Channel 0 to right
    if (FromChan = 0) and RightDirect then
    begin
      AllocMap[0] := 1;
      AllocMap[1] := 0;
      AllocMap[2] := 2;
      if Tracks.IsSelected then begin
        Tracks.SelX    := 22;
        Tracks.CursorX := 34;
      end
      else begin
        Inc(Tracks.CursorX, 14);
        Tracks.SelX := Tracks.CursorX;
      end;
    end;

    // Channel 0 to left
    if (FromChan = 0) and not RightDirect then
    begin
      AllocMap[0] := 2;
      AllocMap[1] := 1;
      AllocMap[2] := 0;
      if Tracks.IsSelected then begin
        Tracks.SelX    := 36;
        Tracks.CursorX := 48;
      end
      else begin
        Tracks.CursorX := 36 + (Tracks.CursorX - 8);
        Tracks.SelX := Tracks.CursorX;
      end;
    end;

    // Channel 1 to right
    if (FromChan = 1) and RightDirect then
    begin
      AllocMap[0] := 0;
      AllocMap[1] := 2;
      AllocMap[2] := 1;
      if Tracks.IsSelected then begin
        Tracks.SelX    := 36;
        Tracks.CursorX := 48;
      end
      else begin
        Inc(Tracks.CursorX, 14);
        Tracks.SelX := Tracks.CursorX;
      end;
    end;

    // Channel 1 to left
    if (FromChan = 1) and not RightDirect then
    begin
      AllocMap[0] := 1;
      AllocMap[1] := 0;
      AllocMap[2] := 2;
      if Tracks.IsSelected then begin
        Tracks.SelX    := 8;
        Tracks.CursorX := 20;
      end
      else begin
        Dec(Tracks.CursorX, 14);
        Tracks.SelX := Tracks.CursorX;
      end;
    end;

    // Channel 2 to right
    if (FromChan = 2) and RightDirect then
    begin
      AllocMap[0] := 2;
      AllocMap[1] := 1;
      AllocMap[2] := 0;
      if Tracks.IsSelected then begin
        Tracks.SelX    := 8;
        Tracks.CursorX := 20;
      end
      else begin
        Tracks.CursorX := 8 + (Tracks.CursorX - 36);
        Tracks.SelX := Tracks.CursorX;
      end;
    end;

    // Channel 2 to left
    if (FromChan = 2) and not RightDirect then
    begin
      AllocMap[0] := 0;
      AllocMap[1] := 2;
      AllocMap[2] := 1;
      if Tracks.IsSelected then begin
        Tracks.SelX    := 22;
        Tracks.CursorX := 34;
      end
      else begin
        Dec(Tracks.CursorX, 14);
        Tracks.SelX := Tracks.CursorX;
      end;
    end;

  end;



  // Calculate range of selected pattern lines
  with Tracks do
    if SelY < CurrentPatLine then
    begin
      FromLine := SelY;
      ToLine   := CurrentPatLine;
    end
    else
    begin
      FromLine := CurrentPatLine;
      ToLine   := SelY;
    end;


  // Swap channels
  for Line := FromLine to ToLine do with Tracks.ShownPattern.Items[Line] do
  begin

    // Remember original channels before swap
    OriginalChannel[0] := Channel[0];
    OriginalChannel[1] := Channel[1];
    OriginalChannel[2] := Channel[2];

    for i := 0 to 2 do
    begin
      // Don't swap channel
      if AllocMap[i] = i then Continue;

      CopyFromChannel := ChanAlloc[i];
      CopyToChannel   := ChanAlloc[AllocMap[i]];
      Channel[CopyToChannel] := OriginalChannel[CopyFromChannel];
    end;

  end;

  // Save redo
  SavePatternRedo;
  SongChanged := True;
  BackupSongChanged := True;

  Tracks.HideMyCaret;
  Tracks.RecreateCaret;
  Tracks.SetCaretPosition;
  Tracks.RedrawTracks(0);
  Tracks.ShowMyCaret;

end;


procedure TMDIChild.BetweenPatternsUp;
var
  PLen: Integer;
begin
  if not BetweenPatterns.Checked then Exit;
  if PositionNumber - 1 >= 0 then
    Dec(PositionNumber)
  else
    PositionNumber := VTMP.Positions.Length-1;
  Tracks.RedrawDisabled := True;
  IsSinchronizing       := True;
  SelectPosition2(PositionNumber);
  IsSinchronizing       := False;
  Tracks.RedrawDisabled := False;
  if Tracks.ShownPattern = nil then
    PLen := DefPatLen
  else
    PLen := Tracks.ShownPattern.Length;
  Tracks.ShownFrom := PLen - 1;
  Tracks.CursorY   := Tracks.N1OfLines;
  Tracks.HideMyCaret;
  Tracks.RemoveSelection;
  Tracks.RedrawTracks(0);
  Tracks.SetCaretPosition;
  Tracks.ShowMyCaret;
end;


procedure TMDIChild.BetweenPatternsDown;
begin
  if not BetweenPatterns.Checked then Exit;
  if PositionNumber + 1 < VTMP.Positions.Length then
    Inc(PositionNumber)
  else
    PositionNumber := VTMP.Positions.Loop;
  Tracks.RedrawDisabled := True;
  IsSinchronizing       := True;
  SelectPosition2(PositionNumber);
  Tracks.RedrawDisabled := False;
  IsSinchronizing  := False;
  Tracks.ShownFrom := 0;
  Tracks.CursorY   := Tracks.N1OfLines;
  Tracks.HideMyCaret;
  Tracks.RemoveSelection;
  Tracks.RedrawTracks(0);
  Tracks.SetCaretPosition;
  Tracks.ShowMyCaret;
end;


procedure TMDIChild.TracksKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  PLen, i, j: Integer;
  Incr, Decr: Boolean;
  
  procedure GoToNextWindow(Right: Boolean);
  var
    CurWinCurY, PLen: Integer;
  begin

    if (TSWindow = nil) or (TSWindow = Self) or Tracks.IsSelected then
      Exit;

    CurWinCurY := Tracks.CursorY;

    if TSWindow.Tracks.Enabled then with TSWindow do
    begin

      // Set cursor X
      if Right then
        Tracks.CursorX := 48
      else
        Tracks.CursorX := 0;

      // Set cursor Y
      Tracks.CursorY := CurWinCurY;

      // Is CursorY < ShownFrom?
      if Tracks.CurrentPatLine < 0 then
        Tracks.CursorY := Tracks.N1OfLines - Tracks.ShownFrom;

      // Is CursorY > ShownFrom?
      PLen := Tracks.ShownPattern.Length;
      if Tracks.CurrentPatLine >= PLen then
        Tracks.CursorY := PLen - Tracks.ShownFrom + Tracks.N1OfLines - 1;

      Tracks.RemoveSelection;
      Tracks.RedrawTracks(0);
      PageControl1.ActivePageIndex := 0;
      Show;
      SetFocus;
      if Tracks.CanFocus then
        Tracks.SetFocus;
    end;

  end;

  procedure RemSel;
  begin
    if not (ssShift in Shift) then
    begin
      Tracks.HideMyCaret;
      Tracks.RemoveSelection;
      Tracks.ShowMyCaret;
    end
  end;

  procedure DoDiffSlide;
  var
    y, sfreq, efreq, snote, enote, spos, epos: Integer;
    len, diff: Integer;
    chan: Integer;
  begin
    chan := ChanAlloc[(Tracks.CursorX - 8) div 14];
    y := Tracks.CurrentPatLine;
    spos := y;
    snote := VTMP.Patterns[PatNum].Items[spos].Channel[chan].note;
    if snote = 0 then
      Exit;
    epos := y;
    enote := snote;
    for y := spos + 1 to (Tracks.ShownPattern.Length - 1) do
    begin
      epos := y;
      enote := VTMP.Patterns[PatNum].Items[y].Channel[chan].note;
      if enote >= 0 then
        Break;
    end;
    if (enote < 0) or (enote = snote) then
      Exit;

    sfreq := GetNoteFreq(VTMP.Ton_Table, snote);
    efreq := GetNoteFreq(VTMP.Ton_Table, enote);
    len := Abs(epos - spos) * VTMP.Initial_Delay;
    diff := (Abs((efreq - sfreq))) div len;
    if diff = 0 then
      diff := 1;
    if efreq > sfreq then
    begin
//      if not UndoWorking then AddUndo(CAChangeSpecialCommandNumber, VTMP.Patterns[PatNum].Items[spos].Channel[Chan].Additional_Command.Number,1);
//      if not UndoWorking then AddUndo(CAChangeSpecialCommandDelay, VTMP.Patterns[PatNum].Items[spos].Channel[Chan].Additional_Command.Delay,1);
//      if not UndoWorking then AddUndo(CAChangeSpecialCommandParameter, VTMP.Patterns[PatNum].Items[spos].Channel[Chan].Additional_Command.Parameter,diff);

      VTMP.Patterns[PatNum].Items[spos].Channel[chan].Additional_Command.Number := 1;
      VTMP.Patterns[PatNum].Items[spos].Channel[chan].Additional_Command.Delay := 1;
      VTMP.Patterns[PatNum].Items[spos].Channel[chan].Additional_Command.Parameter := diff;
    end
    else
    begin
//      if not UndoWorking then AddUndo(CAChangeSpecialCommandNumber, VTMP.Patterns[PatNum].Items[spos].Channel[Chan].Additional_Command.Number,2);
//      if not UndoWorking then AddUndo(CAChangeSpecialCommandDelay, VTMP.Patterns[PatNum].Items[spos].Channel[Chan].Additional_Command.Delay,1);
//      if not UndoWorking then AddUndo(CAChangeSpecialCommandParameter, VTMP.Patterns[PatNum].Items[spos].Channel[Chan].Additional_Command.Parameter,diff);

      VTMP.Patterns[PatNum].Items[spos].Channel[chan].Additional_Command.Number := 2;
      VTMP.Patterns[PatNum].Items[spos].Channel[chan].Additional_Command.Delay := 1;
      VTMP.Patterns[PatNum].Items[spos].Channel[chan].Additional_Command.Parameter := diff;
    end;
    Tracks.RedrawTracks(0);
//    snote := VTMP.Patterns[PatNum].items
//   if (y >= 0) and (y < Tracks.ShownPattern.Length) then

//   e := round(GetNoteFreq(VTMP.Ton_Table, n) * AutoEnv0 / AutoEnv1 / 16);
    begin
//      old := VTMP.Patterns[PatNum].Items[y].Envelope;
    end;
  end;

  procedure DoNoteInEnvelope;
  var
    Note, n, e, y, old: Integer;
  begin
    if Key >= 256 then
      exit;
    Note := NoteKeys[Key];
    if Note = -3 then
      exit;
    if Note > 32 then
    begin
      OctaveUpDown.Position := Note and 31;
      exit
    end;
    e := 0;
    if Note >= 0 then
    begin
      Inc(Note, (OctaveUpDown.Position - 1) * 12);
      if Shift = [ssShift] then
        Inc(Note, 12)
      else if Shift = [ssShift, ssCtrl] then
        Dec(Note, 12);
      if longword(Note) >= 96 then
        exit
    end;
    //note is defined
    n := Note;
    if n < 0 then
      exit;
    ValidatePattern2(PatNum);
    y := Tracks.CurrentPatLine;

    if (y >= 0) and (y < Tracks.ShownPattern.Length) then
      e := round(GetNoteFreq(VTMP.Ton_Table, n) * AutoEnv0 / AutoEnv1 / 16);
    begin
      old := VTMP.Patterns[PatNum].Items[y].Envelope;
      if not UndoWorking then
      begin
        AddUndo(CAChangeEnvelopePeriod, old, e);
        ChangeList[ChangeCount - 1].Line := y;
      end;
      VTMP.Patterns[PatNum].Items[y].Envelope := e;
      SongChanged := True;
      BackupSongChanged := True;
      RemSel;
      Tracks.KeyPressed := Key;
      Tracks.HideMyCaret;
      if DoStep(y, True, False) then
        ShowStat;
      Tracks.RecreateCaret;
      Tracks.SetCaretPosition;
      Tracks.RedrawTracks(0);
      Tracks.ShowMyCaret;
      RestartPlayingNote(y);
    end;
  end;

  procedure DoDuplicateNoteParams(Pat, Line, Chan: byte);
  begin
    if not DuplicateNoteParams.Checked then
      Exit;

    with VTMP.Patterns[Pat].Items[Line].Channel[Chan] do
    begin
      if (Sample <> 0) or (Envelope <> 0) or (Ornament <> 0) or (Volume <> 0) then
        Exit;
      Sample := Tracks.LastNoteParams[Chan].Sample;
      Envelope := Tracks.LastNoteParams[Chan].Envelope;
      Ornament := Tracks.LastNoteParams[Chan].Ornament;
      Volume := Tracks.LastNoteParams[Chan].Volume;
    end;

  end;

  // For patterns editor
  procedure DoNoteKey;
  var
    Note, i, j: Integer;
  begin
    if Key >= 256 then
      exit;
    Note := NoteKeys[Key];
    if Note = -3 then
      exit;
    if Note > 32 then
    begin
      OctaveUpDown.Position := Note and 31;
      exit
    end;
    if Note >= 0 then
    begin
      Inc(Note, (OctaveUpDown.Position - 1) * 12);
      if Shift = [ssShift] then
        Inc(Note, 12)
      else if Shift = [ssShift, ssCtrl] then
        Dec(Note, 12); 
      if longword(Note) >= 96 then
        exit
    end;
    Tracks.KeyPressed := Key;
    ValidatePattern2(PatNum);
    i := Tracks.CurrentPatLine;
    if (i >= 0) and (i < Tracks.ShownPattern.Length) then
    begin
      RemSel;
      j := Tracks.CurrentChannel;
      ChangeNote(PatNum, i, j, Note);

      // Don't do duplicate note params for R--
      if Key <> Ord('A') then
        DoDuplicateNoteParams(PatNum, i, j);

      DoAutoEnv(PatNum, i, j);
      Tracks.HideMyCaret;
      Tracks.RecreateCaret;
      Tracks.SetCaretPosition;
      if DoStep(i, True, False) then
        ShowStat;
      Tracks.RedrawTracks(0);
      Tracks.ShowMyCaret;
      RestartPlayingNote(i);

    end;
  end;

  procedure DoOtherKeys;
  var
    i, n, c: Integer;
  begin
    if Tracks.CursorX in SamPoses then
      i := 31

    else if Tracks.CursorX = 5 then         // First number of noise
      if DecBaseNoiseOn then
        i := 3  // Dec noise
      else
        i := 1  // Hex noise
    else
      i := 15;

    if Key in [Ord('0')..Ord('9')] then
      n := Key - Ord('0')
    else
      n := Key - Ord('A') + 10;

    if (n < 0) or (n > i) then
      exit;

    Tracks.KeyPressed := Key;
    ValidatePattern2(PatNum);
    i := Tracks.CurrentPatLine;
    if (i >= 0) and (i < Tracks.ShownPattern.Length) then
    begin
      RemSel;
      c := (Tracks.CursorX - 8) div 14;
      if c >= 0 then
        c := ChanAlloc[c];
      ChangeTracks(PatNum, i, c, Tracks.CursorX, n, True);
      if Tracks.CursorX in [13, 27, 41] then
        DoAutoEnv(PatNum, i, c);
      Tracks.HideMyCaret;
      //    if Tracks.CursorX in [12,15,26,29,40,43] then //comment -> step in any col
      if DoStep(i, True, False) then
        ShowStat;
      Tracks.RecreateCaret;
      Tracks.SetCaretPosition;
      Tracks.RedrawTracks(0);
      Tracks.ShowMyCaret;
      RestartPlayingNote(i);
    end;
  end;

  procedure RedrawTrs;
  begin
    Tracks.HideMyCaret;
    Tracks.RedrawTracks(0);
    Tracks.ShowMyCaret;
  end;

  procedure DoCursorDown;
  var
    To1, PLen: Integer;
  begin
    Tracks.ManualBitBlt := True;
    if TSWindow <> nil then
      TSWindow.Tracks.ManualBitBlt := True;

    if Tracks.ShownPattern = nil then
      PLen := DefPatLen
    else
      PLen := Tracks.ShownPattern.Length;
    To1 := PLen - Tracks.ShownFrom + Tracks.N1OfLines;
    if To1 > Tracks.NOfLines then
      To1 := Tracks.NOfLines;

    if (Tracks.CursorY < To1 - 1) and (Tracks.CursorY <> Tracks.N1OfLines) then
    begin
      Tracks.HideMyCaret;
      if ssAlt in Shift then
        DoStep(Tracks.CurrentPatLine, True, True)
      else
        Inc(Tracks.CursorY);
      Tracks.SetCaretPosition;
      if ssShift in Shift then
        Tracks.ShowSelection
      else
        Tracks.RemoveSelection;
      Tracks.RedrawTracks(0);
      Tracks.ShowMyCaret;
    end

    // On selected line
    else if Tracks.ShownFrom < PLen - Tracks.CursorY - 1 + Tracks.N1OfLines then
    begin
      if ssAlt in Shift then
        DoStep(Tracks.CurrentPatLine, True, True)
      else
        Inc(Tracks.ShownFrom);
      if ssShift in Shift then
        Tracks.ShowSelection
      else
        Tracks.RemoveSelection;
      RedrawTrs;
    end
    else if Shift = [] then
    begin
      if BetweenPatterns.Checked then
        BetweenPatternsDown
      else begin
        Tracks.ShownFrom := 0;
        Tracks.CursorY := Tracks.N1OfLines;
        Tracks.RemoveSelection;
        Tracks.RedrawTracks(0);
      end;
    end;
    ShowStat;
    
    Tracks.HideMyCaret;
    Tracks.DoBitBlt;
    Tracks.SetCaretPosition;
    Tracks.ShowMyCaret;
    Tracks.ManualBitBlt := False;

    if TSWindow <> nil then
    begin
      TSWindow.Tracks.ManualBitBlt := False;
      TSWindow.Tracks.DoBitBlt;
    end;

  end;

  procedure DoCursorUp;
  var
    From, PLen: Integer;
  begin
    Tracks.ManualBitBlt := True;
    if TSWindow <> nil then
      TSWindow.Tracks.ManualBitBlt := True;

    From := (Tracks.N1OfLines - Tracks.ShownFrom);
    if From < 0 then
      From := 0;
    if (Tracks.CursorY > From) and (Tracks.CursorY <> Tracks.N1OfLines) then
    begin
      Tracks.HideMyCaret;
      if ssAlt in Shift then
        DoStep(Tracks.CurrentPatLine, False, True)
      else
        Dec(Tracks.CursorY);
      Tracks.SetCaretPosition;
      if ssShift in Shift then
        Tracks.ShowSelection
      else
        Tracks.RemoveSelection;
      Tracks.RedrawTracks(0);
      Tracks.ShowMyCaret;
    end
    else if Tracks.ShownFrom > Tracks.N1OfLines - Tracks.CursorY then
    begin
      if ssAlt in Shift then
        DoStep(Tracks.CurrentPatLine, False, True)
      else
        Dec(Tracks.ShownFrom);
      if ssShift in Shift then
        Tracks.ShowSelection
      else
        Tracks.RemoveSelection;
      RedrawTrs;
    end
    else if Shift = [] then
    begin
      if Tracks.ShownPattern = nil then
        PLen := DefPatLen
      else
        PLen := Tracks.ShownPattern.Length;

      if BetweenPatterns.Checked then
        BetweenPatternsUp
      else begin
        Tracks.ShownFrom := PLen - 1;
        Tracks.CursorY := Tracks.N1OfLines;
        Tracks.RemoveSelection;
        Tracks.RedrawTracks(0);
      end;

    end;
    ShowStat;

    Tracks.HideMyCaret;
    Tracks.DoBitBlt;
    Tracks.SetCaretPosition;
    Tracks.ShowMyCaret;
    Tracks.ManualBitBlt := False;

    if TSWindow <> nil then
    begin
      TSWindow.Tracks.ManualBitBlt := False;
      TSWindow.Tracks.DoBitBlt;
    end;

  end;

  procedure DoCursorLeft;
  var
    min: Integer;
  begin
    min := 0;
    if ssCtrl in Shift then
      min := 4;
    if Tracks.CursorX > min then
    begin
      if Shift = [ssCtrl] then
        Tracks.CursorX := ColTabs[ColTab(Tracks.CursorX) - 1]
      else if (Shift = [ssCtrl, ssShift]) and (Tracks.CursorX <= Tracks.SelX) then
      begin
        Tracks.CursorX := ColTabsL[ColTab1(Tracks.CursorX, ColTabsL) - 1];
      end
      else if (Shift = [ssCtrl, ssShift]) and (Tracks.CursorX > Tracks.SelX) then
        Tracks.CursorX := ColTabsR[ColTab1(Tracks.CursorX, ColTabsR) - 1]
      else
      begin
        if Tracks.CursorX in [12, 26, 40] then
          Dec(Tracks.CursorX, 4)
        else if ColSpace(Tracks.CursorX - 1) then
          Dec(Tracks.CursorX, 2)
        else
          Dec(Tracks.CursorX)
      end;
      Tracks.HideMyCaret;
      Tracks.RecreateCaret;
      Tracks.SetCaretPosition;
      if ssShift in Shift then
        Tracks.ShowSelection
      else
        Tracks.RemoveSelection;
      Tracks.RedrawTracks(0);
      Tracks.ShowMyCaret;
    end
    else
      GoToNextWindow(True);
  end;

  procedure DoCursorRight;
  var
    max: Integer;
  begin
    max := 48;
    if Shift = [ssCtrl] then
      max := 44;
    if Tracks.CursorX < max then
    begin
      if Shift = [ssCtrl] then
        Tracks.CursorX := ColTabs[ColTab(Tracks.CursorX) + 1]
      else if (Shift = [ssCtrl, ssShift]) and (Tracks.CursorX >= Tracks.SelX) then
      begin
        Tracks.CursorX := ColTabsR[ColTab1(Tracks.CursorX, ColTabsR) + 1];
      end
      else if (Shift = [ssCtrl, ssShift]) and (Tracks.CursorX < Tracks.SelX) then
      begin
        Tracks.CursorX := ColTabsL[ColTab1(Tracks.CursorX, ColTabsL) + 1];
      end
      else
      begin
        Inc(Tracks.CursorX);
        if ColSpace(Tracks.CursorX) then
          Inc(Tracks.CursorX)
        else if Tracks.CursorX in [9, 23, 37] then
          Inc(Tracks.CursorX, 3)
      end;
      Tracks.HideMyCaret;
      Tracks.RecreateCaret;
      Tracks.SetCaretPosition;
      if ssShift in Shift then
        Tracks.ShowSelection
      else
        Tracks.RemoveSelection;
      Tracks.RedrawTracks(0);
      Tracks.ShowMyCaret;
    end
    else
      GoToNextWindow(False);
  end;


type
  TA3 = array[0..2] of Boolean;

  procedure GetColsToEdit(var E, N: Boolean; var T: TA3; AllPat: Boolean);
  begin
    if AllPat then
    begin
      E := True;
      N := True;
      T[0] := True;
      T[1] := True;
      T[2] := True
    end
    else
    begin
      E := False;
      N := False;
      T[0] := False;
      T[1] := False;
      T[2] := False;
      if Tracks.CursorX < 4 then
        E := True
      else if Tracks.CursorX < 8 then
        N := True
      else
        T[ChanAlloc[(Tracks.CursorX - 8) div 14]] := True
    end
  end;

  procedure DoInsertLine(AllPat: Boolean);
  var
    i, j, c: Integer;
    E, N: Boolean;
    T: TA3;
  begin
    RemSel;
    if Tracks.ShownPattern <> nil then
    begin
      i := Tracks.CurrentPatLine;
      if (i >= 0) and (i < Tracks.ShownPattern.Length) then
      begin
        SongChanged := True;
        BackupSongChanged := True;
        AddUndo(CAPatternInsertLine, 0, 0);
        New(ChangeList[ChangeCount - 1].Pattern);
        ChangeList[ChangeCount - 1].Pattern^ := Tracks.ShownPattern^;
        GetColsToEdit(E, N, T, AllPat);
        if E then
        begin
          for j := MaxPatLen - 1 downto i do
            Tracks.ShownPattern.Items[j].Envelope := Tracks.ShownPattern.Items[j - 1].Envelope;
          Tracks.ShownPattern.Items[i].Envelope := 0
        end;
        if N then
        begin
          for j := MaxPatLen - 1 downto i do
            Tracks.ShownPattern.Items[j].Noise := Tracks.ShownPattern.Items[j - 1].Noise;
          Tracks.ShownPattern.Items[i].Noise := 0
        end;
        for c := 0 to 2 do
          if T[c] then
          begin
            for j := MaxPatLen - 1 downto i do
              Tracks.ShownPattern.Items[j].Channel[c] := Tracks.ShownPattern.Items[j - 1].Channel[c];
            Tracks.ShownPattern.Items[i].Channel[c] := EmptyChannelLine
          end;
        CalcTotLen;
        ShowStat;
        RedrawTrs;
        ChangeList[ChangeCount - 1].NewParams.prm.PatternCursorY := Tracks.CursorY;
        ChangeList[ChangeCount - 1].NewParams.prm.PatternShownFrom := Tracks.ShownFrom;
      end;
    end;
  end;

  procedure DoNextColumn;
  begin

    if (Tracks.CursorX in [36..48]) and not (ssShift in Shift) then
    begin
      Tracks.Refresh;
      GoToNextWindow(False);
      Exit;
    end;

    if (Tracks.CursorX in [0..6]) and (ssShift in Shift) then
    begin
      Tracks.Refresh;
      GoToNextWindow(True);
      Exit;
    end;

    if ssShift in Shift then
    begin
      if Tracks.CursorX in [8..20] then
        Tracks.CursorX := 0;
      if Tracks.CursorX in [22..34] then
        Tracks.CursorX := 8;
      if Tracks.CursorX in [36..48] then
        Tracks.CursorX := 22;
    end
    else
    begin
      if Tracks.CursorX in [22..34] then
        Tracks.CursorX := 36;
      if Tracks.CursorX in [8..20] then
        Tracks.CursorX := 22;
      if Tracks.CursorX in [0..6] then
        Tracks.CursorX := 8;
    end;

    Tracks.Refresh;
  end;


  procedure DoMuteDismuteChannels;
  var
    State: Boolean;
    ChanNum: Integer;
  begin

    if Tracks.CursorX >= 36 then ChanNum := ChanAlloc[2] else
    if Tracks.CursorX >= 22 then ChanNum := ChanAlloc[1] else
    if Tracks.CursorX >= 8  then ChanNum := ChanAlloc[0]
    else
      ChanNum := -1;

    // Channel A
    if ChanNum = 0 then
      if not Tracks.ChannelState[1].Muted and not Tracks.ChannelState[2].Muted then
        SoloChannelA(True)
      else
        DismuteAllChannels(True)


    // Channel B
    else if ChanNum = 1 then
      if not Tracks.ChannelState[0].Muted and not Tracks.ChannelState[2].Muted then
        SoloChannelB(True)
      else
        DismuteAllChannels(True)

    // Channel C
    else if ChanNum = 2 then
      if not Tracks.ChannelState[0].Muted and not Tracks.ChannelState[1].Muted then
          SoloChannelC(True)
        else
          DismuteAllChannels(True)

    // Noise
    else if Tracks.CursorX >= 5 then
    begin
      State :=
        VTMP.IsChans[0].Global_Noise and
        VTMP.IsChans[1].Global_Noise and
        VTMP.IsChans[2].Global_Noise
      ;

      VTMP.IsChans[0].Global_Noise := not State;
      VTMP.IsChans[1].Global_Noise := not State;
      VTMP.IsChans[2].Global_Noise := not State;

      SpeedButton3.Down  := State;
      SpeedButton7.Down  := State;
      SpeedButton11.Down := State;
    end

    // Envelope
    else if Tracks.CursorX >= 0 then
    begin
      State :=
        VTMP.IsChans[0].Global_Envelope and
        VTMP.IsChans[1].Global_Envelope and
        VTMP.IsChans[2].Global_Envelope
      ;

      VTMP.IsChans[0].Global_Envelope := not State;
      VTMP.IsChans[1].Global_Envelope := not State;
      VTMP.IsChans[2].Global_Envelope := not State;

      SpeedButton4.Down  := State;
      SpeedButton8.Down  := State;
      SpeedButton12.Down := State;
    end;

    UpdateChannelsState;
  end;

  procedure DoRemoveLine;
  var
    i, j, c: Integer;
    E, N: Boolean;
    T: TA3;
  begin
    RemSel;
    if Tracks.ShownPattern <> nil then
    begin
      i := Tracks.CurrentPatLine;
      if (i >= 0) and (i < Tracks.ShownPattern.Length) then
      begin
        SongChanged := True;
        BackupSongChanged := True;
        AddUndo(CAPatternDeleteLine, 0, 0);
        New(ChangeList[ChangeCount - 1].Pattern);
        ChangeList[ChangeCount - 1].Pattern^ := Tracks.ShownPattern^;
        GetColsToEdit(E, N, T, ssCtrl in Shift);
        if E then
        begin
          for j := i + 1 to MaxPatLen - 1 do
            Tracks.ShownPattern.Items[j - 1].Envelope := Tracks.ShownPattern.Items[j].Envelope;
          Tracks.ShownPattern.Items[MaxPatLen - 1].Envelope := 0
        end;
        if N then
        begin
          for j := i + 1 to MaxPatLen - 1 do
            Tracks.ShownPattern.Items[j - 1].Noise := Tracks.ShownPattern.Items[j].Noise;
          Tracks.ShownPattern.Items[MaxPatLen - 1].Noise := 0
        end;
        for c := 0 to 2 do
          if T[c] then
          begin
            for j := i + 1 to MaxPatLen - 1 do
              Tracks.ShownPattern.Items[j - 1].Channel[c] := Tracks.ShownPattern.Items[j].Channel[c];
            Tracks.ShownPattern.Items[MaxPatLen - 1].Channel[c] := EmptyChannelLine
          end;
        CalcTotLen;
        ShowStat;
        RedrawTrs;
        ChangeList[ChangeCount - 1].NewParams.prm.PatternCursorY := Tracks.CursorY;
        ChangeList[ChangeCount - 1].NewParams.prm.PatternShownFrom := Tracks.ShownFrom;
      end;
    end;
  end;

  procedure DoClearLine;
  var
    i, c: Integer;
    E, N: Boolean;
    T: TA3;
  begin
    RemSel;
    if Tracks.ShownPattern <> nil then
    begin
      i := Tracks.CurrentPatLine;
      if (i >= 0) and (i < Tracks.ShownPattern.Length) then
      begin
        SongChanged := True;
        BackupSongChanged := True;
        AddUndo(CAPatternClearLine, 0, 0);
        New(ChangeList[ChangeCount - 1].Pattern);
        ChangeList[ChangeCount - 1].Pattern^ := Tracks.ShownPattern^;
        GetColsToEdit(E, N, T, ssCtrl in Shift);
        if E then
          Tracks.ShownPattern.Items[i].Envelope := 0;
        if N then
          Tracks.ShownPattern.Items[i].Noise := 0;
        for c := 0 to 2 do
          if T[c] then
            Tracks.ShownPattern.Items[i].Channel[c] := EmptyChannelLine;
        CalcTotLen;
        if DoStep(i, True, False) then
          ShowStat;
        RedrawTrs;
        ChangeList[ChangeCount - 1].NewParams.prm.PatternCursorY := Tracks.CursorY;
        ChangeList[ChangeCount - 1].NewParams.prm.PatternShownFrom := Tracks.ShownFrom;
      end;
    end;
  end;


begin

  // Ctrl+Enter -> Open selected sample or ornament
  if (Shift = [ssCtrl]) and (Key = VK_RETURN) and (Tracks.CursorX in [12, 14, 26, 28, 40, 42]) then
  begin
    OpenSampleOrnament;
    Exit;
  end;

  // Ctrl+R -> Toggle autostep
  if (Shift = [ssCtrl]) and (Key = Ord('R')) then begin
    Exit;
  end;


  // Change octave: Alt + 1..8
  if (Shift = [ssAlt]) and (Key >= 49) and (Key <= 56) then
  begin
    OctaveUpDown.Position := Key - 48;
    Exit;
  end;   


  // Jump to first line
  if ShortCut(Key, Shift - [ssShift]) = MainForm.JmpPatStartAct.ShortCut then
  begin
    Tracks.JumpToPatStart(Shift);
    ShowStat;
    Exit;
  end;

  // Jump to last line
  if ShortCut(Key, Shift - [ssShift]) = MainForm.JmpPatEndAct.ShortCut then
  begin
    Tracks.JumpToPatEnd(Shift);
    ShowStat;
    Exit;
  end;

  // Jump to line start
  if ShortCut(Key, Shift - [ssShift]) = MainForm.JmpLineStartAct.ShortCut then
  begin
    Tracks.JumpToLineStart(Shift);
    ShowStat;
    Exit;
  end;

  // Jump to line end
  if ShortCut(Key, Shift - [ssShift]) = MainForm.JmpLineEndAct.ShortCut then
  begin
    Tracks.JumpToLineEnd(Shift);
    ShowStat;
    Exit;
  end;

  Incr := (Key = 187);
  Decr := (Key = 189);

  if Tracks.IsSelected and (Incr or Decr) then begin

    if Incr and (Shift = []) then MainForm.TransposeSelection(1);
    if Decr and (Shift = []) then MainForm.TransposeSelection(-1);
    if Incr and (Shift = [ssShift]) then MainForm.TransposeSelection(3);
    if Decr and (Shift = [ssShift]) then MainForm.TransposeSelection(-3);
    if Incr and (Shift = [ssCtrl])  then MainForm.TransposeSelection(12);
    if Decr and (Shift = [ssCtrl])  then MainForm.TransposeSelection(-12);
    if Incr and (Shift = [ssCtrl,ssShift]) then MainForm.TransposeSelection(5);
    if Decr and (Shift = [ssCtrl,ssShift]) then MainForm.TransposeSelection(-5);
    
    Exit;
  end;


  case Key of

    // Cursor key DOWN
    VK_DOWN:
      if (ssCtrl in Shift) then
      begin
        if Tracks.ShownPattern = nil then
          PLen := DefPatLen
        else
          PLen := Tracks.ShownPattern.Length;

        Tracks.ShownFrom := PLen - 1;
        Tracks.CursorY := Tracks.N1OfLines;
        if ssShift in Shift then
          Tracks.ShowSelection
        else
          Tracks.RemoveSelection;
        Tracks.HideMyCaret;
        Tracks.RedrawTracks(0);
        Tracks.SetCaretPosition;
        Tracks.ShowMyCaret;
        ShowStat;
      end
      else
      begin
        DoCursorDown;
      end;

    // Cursor key UP
    VK_UP:
      if (ssCtrl in Shift) then
      begin
        Tracks.ShownFrom := 0;
        Tracks.CursorY := Tracks.N1OfLines;
        if ssShift in Shift then
          Tracks.ShowSelection
        else
          Tracks.RemoveSelection;
        Tracks.HideMyCaret;
        Tracks.RedrawTracks(0);
        Tracks.SetCaretPosition;
        Tracks.ShowMyCaret;
        ShowStat;
      end
      else
      begin
        DoCursorUp;
      end;

    // Cursor key LEFT
    VK_LEFT:
      DoCursorLeft;

    // Cursor key RIGHT
    VK_RIGHT:
      DoCursorRight;

    //TAB
    VK_TAB:
      DoNextColumn;

    // CAPS LOCK -> Solo Channel, noise, envelope
    VK_CAPITAL:
      DoMuteDismuteChannels;


    // Numpad * -> Mute channel/channels
    //          -> Expand
    VK_MULTIPLY:
      if (ssCtrl in Shift) and (ssShift in Shift) then
      begin
        MainForm.ExpandTwice1Click(Sender);
      end
      else if (ssShift in Shift) then
      begin
      end
      else if (ssCtrl in Shift) then
      begin
      //next position
      end
      else
        DoMuteDismuteChannels;

    220:
      if (ssCtrl in Shift) and (ssShift in Shift) then
      begin
        DoDiffSlide;
      end;

    VK_DIVIDE:
      if (ssCtrl in Shift) and (ssShift in Shift) then
      begin
        MainForm.Compresspattern1Click(Sender);
      end
      else if (ssShift in Shift) then
      begin
      end
      else if (ssCtrl in Shift) then
      begin
      //next position
      end
      else
      begin
      //next pattern
        EnvelopeAsNoteOpt.Checked := not EnvelopeAsNoteOpt.Checked;

      end;

    VK_ADD:
      if (ssCtrl in Shift) and (ssShift in Shift) then
      begin
        MainForm.TransposeSelection(12);
//    TransposeSelection(12);
      end
      else if (ssShift in Shift) then
      begin
        MainForm.TransposeSelection(1);
      end
      else if (ssCtrl in Shift) then
      begin
      //next position
      //SelectPosition(StringGrid1.Col+1)
        if (StringGrid1.Col < StringGrid1.ColCount) and (StringGrid1.Col < VTMP.Positions.Length-1) then
          StringGrid1.Col := StringGrid1.Col + 1;

      end
      else
      begin
      //next pattern
//      ChangePattern(PatNum+1);
        if PatNum <= 83 then
          PatternNumEdit.Text := IntToStr(PatNum + 1);
      end;

    VK_SUBTRACT:
      if (ssCtrl in Shift) and (ssShift in Shift) then
      begin
        MainForm.TransposeSelection(-12);
//    TransposeSelection(12);
      end
      else if (ssShift in Shift) then
      begin
        MainForm.TransposeSelection(-1);
      end
      else if (ssCtrl in Shift) then
      begin
      //prev position
        if StringGrid1.Col >= 1 then
          StringGrid1.Col := StringGrid1.Col - 1
      //  SelectPosition(StringGrid1.Col-1)
      end
      else
      begin
      //prev pattern
      //ChangePattern(PatNum-1);
        if PatNum >= 1 then
          PatternNumEdit.Text := IntToStr(PatNum - 1);
      end;


    // Page UP
    VK_PRIOR:
      begin
        // Ctrl + Page UP -> Up to 8 lines
        if ssCtrl in Shift then
        begin
          Dec(Tracks.ShownFrom, 8);
          if Tracks.ShownFrom < 0 then
            if BetweenPatterns.Checked then
              BetweenPatternsUp
            else
              Tracks.ShownFrom := 0;

          Tracks.CursorY := Tracks.N1OfLines;
          Tracks.HideMyCaret;
          Tracks.RedrawTracks(0);
          if ssShift in Shift then
            Tracks.ShowSelection
          else
            Tracks.RemoveSelection;
          Tracks.SetCaretPosition;
          Tracks.ShowMyCaret
        end
        else
        begin
          //cursor points to the first pattern line?
          if (Tracks.CurrentPatLine = 0) and not (ssShift in Shift) then begin

            if BetweenPatterns.Checked then
              BetweenPatternsUp
            else begin

              if Tracks.ShownPattern = nil then
                PLen := DefPatLen
              else
                PLen := Tracks.ShownPattern.Length;
              Tracks.ShownFrom := PLen - 1;
              Tracks.CursorY := Tracks.N1OfLines;
              Tracks.HideMyCaret;
              Tracks.RemoveSelection;
              Tracks.RedrawTracks(0);
              Tracks.SetCaretPosition;
              Tracks.ShowMyCaret

            end;
          end

          // Page Up -> Up to 16 lines
          // cursor in the middle or on the first line?
          else if (Tracks.CursorY = Tracks.N1OfLines) or (Tracks.CursorY = 0) then
          begin
            Dec(Tracks.ShownFrom, 16);
            if Tracks.ShownFrom < 0 then
              if BetweenPatterns.Checked then
                BetweenPatternsUp
              else
                Tracks.ShownFrom := 0;

            if Tracks.CurrentPatLine < 0 then
              Tracks.CursorY := Tracks.N1OfLines - Tracks.ShownFrom;

            Tracks.HideMyCaret;
            Tracks.SetCaretPosition;
            if ssShift in Shift then
              Tracks.ShowSelection
            else
              Tracks.RemoveSelection;
            Tracks.RedrawTracks(0);
            Tracks.ShowMyCaret
          end
            //cursor in other location
          else
          begin
            Tracks.CursorY := Tracks.N1OfLines - Tracks.ShownFrom;
            if Tracks.CursorY < 0 then
              Tracks.CursorY := 0;
            Tracks.SetCaretPosition;
            if ssShift in Shift then
              Tracks.ShowSelection
            else
              Tracks.RemoveSelection;
            Tracks.RedrawTracks(0);
          end;
        end;
        ShowStat;
      end;

    // Page Down
    VK_NEXT:
      begin

        if Tracks.ShownPattern = nil then
          PLen := DefPatLen
        else
          PLen := Tracks.ShownPattern.Length;

        // Ctrl + Page Down -> Down to 8 lines
        if ssCtrl in Shift then
        begin
          Inc(Tracks.ShownFrom, 8);
          if Tracks.ShownFrom >= PLen then
            if BetweenPatterns.Checked then
              BetweenPatternsDown
            else
              Tracks.ShownFrom := PLen-1;
              
          Tracks.CursorY := Tracks.N1OfLines;
          Tracks.HideMyCaret;
          if ssShift in Shift then
            Tracks.ShowSelection
          else
            Tracks.RemoveSelection;
          Tracks.RedrawTracks(0);            
          Tracks.SetCaretPosition;
          Tracks.ShowMyCaret
        end
        else
        begin
          //cursor points to the last pattern line?
          if Tracks.CurrentPatLine = PLen - 1 then
          begin
            if not (ssShift in Shift) then
              if BetweenPatterns.Checked then
                BetweenPatternsDown
              else begin
                Tracks.ShownFrom := 0;
                Tracks.CursorY := Tracks.N1OfLines;
                Tracks.HideMyCaret;
                Tracks.RemoveSelection;
                Tracks.RedrawTracks(0);
                Tracks.SetCaretPosition;
                Tracks.ShowMyCaret
              end
          end
          
          // Pade Down -> Down to 16 lines
          //cursor in the middle or in the last line?
          else if (Tracks.CursorY = Tracks.N1OfLines) or (Tracks.CursorY = Tracks.NOfLines - 1) then
          begin
          
            Inc(Tracks.ShownFrom, 16);
            if Tracks.ShownFrom >= PLen then
              Tracks.ShownFrom := PLen - 1;

            if Tracks.CurrentPatLine >= PLen then
              Tracks.CursorY := PLen - Tracks.ShownFrom + Tracks.N1OfLines - 1;

            Tracks.HideMyCaret;
            Tracks.SetCaretPosition;
            if ssShift in Shift then
              Tracks.ShowSelection
            else
              Tracks.RemoveSelection;
            Tracks.RedrawTracks(0);
            Tracks.ShowMyCaret
          end
            //cursor in other location
          else
          begin
            Tracks.CursorY := PLen - Tracks.ShownFrom + Tracks.N1OfLines - 1;
            if Tracks.CursorY >= Tracks.NOfLines then
              Tracks.CursorY := Tracks.NOfLines - 1;
            Tracks.SetCaretPosition;
            if ssShift in Shift then
              Tracks.ShowSelection
            else
              Tracks.RemoveSelection;
            Tracks.RedrawTracks(0);
          end;
        end;
        ShowStat;
      end;

    VK_INSERT:
      if Shift = [] then
        DoInsertLine(False)
      else if Shift = [ssShift] then
        Tracks.PasteFromClipboard(False)
      else if Shift = [ssCtrl] then
        Tracks.CopyToClipboard;

    VK_BACK:
      if Shift = [ssShift] then
      begin
        i := Tracks.CurrentPatLine;
        if (i >= 0) and (i < Tracks.ShownPattern.Length) then
          if DoStep(i, False, False) then
          begin
            ShowStat;
            RedrawTrs;
          end;
      end
      else
        DoRemoveLine;

    VK_DELETE:
      if Shift = [ssShift] then
      begin
        if MainForm.EditCut1.Enabled then
          MainForm.EditCut1.Execute
      end
      else if (Shift = []) then begin
        if Tracks.CursorX in EnvelopePoses then
        begin
          i := Tracks.CurrentPatLine;
          if (i >= 0) and (i < Tracks.ShownPattern.Length) then
            Tracks.ShownPattern.Items[i].Envelope := 0;
        end;
        Tracks.ClearSelection;
        if DoStep(Tracks.CurrentPatLine, True, False) then
          ShowStat;
        RedrawTrs;
      end

      else
        DoClearLine;

    192:
      begin
        if Shift = [] then
        begin
          if StringGrid1.CanFocus then
            StringGrid1.SetFocus;
        end;
      end;

    VK_NUMPAD0:
      ToggleAutoEnv;

    VK_SPACE:
      {Edit song?}
      ToggleAutoStep;

    VK_RETURN:
      begin

        if Tracks.KeyPressed <> VK_RETURN then
        begin

          // Ctrl+Enter Return back after playing
          if ssCtrl in Shift then
          begin
            Tracks.ReturnAfterPlay := True;
            Tracks.ReturnCursorY   := Tracks.N1OfLines;
            Tracks.ReturnShownFrom := Tracks.CurrentPatLine;
            Tracks.ReturnPosition  := PositionNumber;
          end
          else
            Tracks.ReturnAfterPlay := False;

          Tracks.KeyPressed := VK_RETURN;
          ValidatePattern2(PatNum);
          Tracks.HideMyCaret;
          Tracks.ShownFrom := Tracks.CurrentPatLine;
          Tracks.CursorY := Tracks.N1OfLines;
          Tracks.RedrawTracks(0);
          ShowStat;
          if TSWindow = nil then
            RestartPlaying(True, True)
          else
            RestartPlayingTS(True, False);
        end
      end;
  else
    begin
      // Ctrl + Y
      if (Shift = [ssCtrl]) and (Key = Ord('Y')) then
        DoRemoveLine

      // Ctrl + A or Numpad 5
      else if (Shift = [ssCtrl]) and ((Key = Ord('A')) or (Key = VK_NUMPAD5)) then
        Tracks.SelectAll

      // Ctrl + I
      else if (Shift = [ssCtrl]) and (Key = Ord('I')) then
        DoInsertLine(True)

      // Note, Noise, Envelope keys, etc...
      else if Tracks.KeyPressed <> Key then
        if Tracks.CursorX in NotePoses then
          DoNoteKey
        else if Tracks.CursorX in EnvelopePoses then
        begin
          if EnvelopeAsNote or (ssShift in Shift) then
            DoNoteInEnvelope
          else
            DoOtherKeys
        end
        else
          DoOtherKeys;
    end;
  end;
end;

procedure TTestLine.TestLineMidiOn(note: Integer);
begin
  if not IsPlaying or (PlayMode = PMPlayLine) then
    PlVars[1].ParamsOfChan[MidChan].note := TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].note;
  TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].note := note;
  TMDIChild(ParWind).DoAutoEnv(-1, Ord(TestSample), 0);
  HideCaret(Handle);
  RedrawTestLine(0);
  ShowCaret(Handle);
  TMDIChild(ParWind).RestartPlayingLine(-Ord(TestSample) - 1);
  TMDIChild(ParWind).PlayStopState := BStop;
  Self.CurrentMidiNote := note;

  if TestSample then with TMDIChild(ParWind) do begin
    Samples.HideMyCaret;
    Samples.RedrawSamples(0);
    Samples.ShowMyCaret;
  end;
end;

procedure TTestLine.TestLineMidiOff(note: Integer);
begin
  if Self.CurrentMidiNote <> note then
    Exit;
  if (PlayMode = PMPlayLine) and IsPlaying and (PlayingWindow[1] = ParWind) then
  begin
    ResetPlaying;
    TMDIChild(ParWind).PlayStopState := BPlay;
  end;
  KeyPressed := 0
end;

procedure TTestLine.PlayCurrentNote;
begin

  with TMDIChild(ParWind) do
  begin
    if VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Note < 0 then Exit;

    PlayStopState := BStop;
  
    if not IsPlaying or (PlayMode = PMPlayLine) then begin
      PlVars[1].ParamsOfChan[MidChan].Note := VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Note;

      if Preview then begin
        VTMP.Patterns[-1].Items[Ord(TestSample)+2].Channel[0] := VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0];
        if TestSample then
          VTMP.Patterns[-1].Items[Ord(TestSample)+2].Channel[0].Sample := PreviewSamNum
        else
          VTMP.Patterns[-1].Items[Ord(TestSample)+2].Channel[0].Ornament := PreviewOrnNum;
      end;
    end;
      
    DoAutoEnv(-1, Ord(TestSample), 0);
    HideCaret(Handle);
    RedrawTestLine(0);
    ShowCaret(Handle);

    if Preview then
      RestartPlayingLine(-(Ord(TestSample)+2) - 1)
    else
      RestartPlayingLine(-Ord(TestSample) - 1);

    Preview := False;
  end;

end;

procedure TTestLine.TestLineKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  // Testline
  procedure DoNoteKey;
  var
    Note: Integer;
  begin
    if Key >= 256 then
      exit;
    Note := NoteKeys[Key];
    if Note <= -2 then
      exit;
    if Note > 32 then
    begin
      TestOct := Note and 31;
      if TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Note >= 0 then
        Note := (TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Note mod 12) + (TestOct - 1) * 12
      else
        Note := TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Note
    end
    else if Note >= 0 then
      Inc(Note, (TestOct - 1) * 12);
    if Note >= 96 then
      exit;

    if Shift = [ssShift] then
    begin
      if Note < 96 - 12 then
        Inc(Note, 12)
    end
    else if Shift = [ssShift, ssCtrl] then
      if Note >= 12 then
        Dec(Note, 12); 

    if TestSample then
      TMDIChild(ParWind).Samples.RecalcBaseNote(Note);

    KeyPressed := Key;
    if TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Note >= 0 then
      if not IsPlaying or (PlayMode = PMPlayLine) then
        PlVars[1].ParamsOfChan[MidChan].Note := TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Note;
    TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Note := Note;
    TMDIChild(ParWind).DoAutoEnv(-1, Ord(TestSample), 0);
    HideCaret(Handle);
    RedrawTestLine(0);
    ShowCaret(Handle);
    TMDIChild(ParWind).PlayStopState := BStop;
    TMDIChild(ParWind).RestartPlayingLine(-Ord(TestSample) - 1);

    if TestSample then with TMDIChild(ParWind) do begin
      Samples.HideMyCaret;
      Samples.RedrawSamples(0);
      Samples.ShowMyCaret;
    end
    else with TMDIChild(ParWind) do begin
      Ornaments.HideMyCaret;
      Ornaments.RedrawOrnaments(0);
      Ornaments.ShowMyCaret
    end;
  end;

  procedure DoOtherKeys;
  var
    i, n: Integer;
  begin
    if CursorX = 5 then
      i := 1
    else if CursorX = 12 then
      i := 31
    else
      i := 15;
    if Key in [Ord('0')..Ord('9')] then
      n := Key - Ord('0')
    else
      n := Key - Ord('A') + 10;
    if (n < 0) or (n > i) then
      exit;
    KeyPressed := Key;
    case CursorX of
    {      0..3:
        begin
          Note := NoteKeys[Key];
          TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Envelope :=
           round(GetNoteFreq(TMDIChild(ParWind).VTMP.Ton_Table, Note) / 16);
        end;}
      0:
        TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Envelope := TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Envelope and $FFF or (n shl 12);
      1:
        TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Envelope := TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Envelope and $F0FF or (n shl 8);
      2:
        TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Envelope := TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Envelope and $FF0F or (n shl 4);
      3:
        TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Envelope := TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Envelope and $FFF0 or n;

      5:
        TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Noise := TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Noise and 15 or (n shl 4);
      6:
        TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Noise := TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Noise and $F0 or n;
      12:
        begin
          TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Sample := n;
          if (n > 0) and TestSample then
            TMDIChild(ParWind).SampleNumUpDown.Position := n
        end;
      13:
        begin
          TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Envelope := n;
          TMDIChild(ParWind).DoAutoEnv(-1, Ord(TestSample), 0)
        end;
      14:
        begin
          TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Ornament := n;
          if (n > 0) and not TestSample then
            TMDIChild(ParWind).OrnamentNumUpDown.Position := n
        end;
      15:
        TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Volume := n;
      17:
        TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Additional_Command.Number := n;
      18:
        TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Additional_Command.Delay := n;
      19:
        TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Additional_Command.Parameter := TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Additional_Command.Parameter and 15 or (n shl 4);
      20:
        TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Additional_Command.Parameter := TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Additional_Command.Parameter and $F0 or n
    end;
    HideCaret(Handle);
    RedrawTestLine(0);
    ShowCaret(Handle);
    if IsPlaying and (PlayMode = PMPlayModule) then Exit;
    TMDIChild(ParWind).PlayStopState := BStop;
    TMDIChild(ParWind).RestartPlayingLine(-Ord(TestSample) - 1)
  end;
  
var
  Note: SmallInt;

begin

  // Change octave: Alt + 0..9
  if (Shift = [ssAlt]) and (Key >= 49) and (Key <= 56) then
  begin
    if KeyPressed = Key then Exit;
    KeyPressed := Key;

    TestOct := Key - 48;
    Note := (TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Note mod 12) + (TestOct - 1) * 12;

    if TestSample then
      TMDIChild(ParWind).Samples.RecalcBaseNote(Note);

    TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Note := Note;
    HideCaret(Handle);
    RedrawTestLine(0);
    ShowCaret(Handle);

    if TestSample and TMDIChild(ParWind).SamToneShiftAsNoteOpt.Checked then begin
      TMDIChild(ParWind).Samples.HideMyCaret;
      TMDIChild(ParWind).Samples.RedrawSamples(0);
      TMDIChild(ParWind).Samples.ShowMyCaret;
    end;
    if not TestSample and TMDIChild(ParWind).OrnToneShiftAsNoteOpt.Checked then begin
      TMDIChild(ParWind).Ornaments.HideMyCaret;
      TMDIChild(ParWind).Ornaments.RedrawOrnaments(0);
      TMDIChild(ParWind).Ornaments.ShowMyCaret;
    end;

    PlayCurrentNote;
    Exit;
  end;


  if Shift = [] then
    case Key of
      VK_UP:
      begin
        // Octave UP
        if CursorX = 8 then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)] do
        begin
          Note := Channel[0].Note;
          if Note < 96 - 12 then
          begin
            Inc(Note, 12);
            Inc(TestOct);
          end;

          if not IsPlaying or (PlayMode = PMPlayLine)then
            PlVars[1].ParamsOfChan[MidChan].Note := Note;

          if TestSample then
            TMDIChild(ParWind).Samples.RecalcBaseNote(Note);

          Channel[0].Note := Note;
          TMDIChild(ParWind).DoAutoEnv(-1, Ord(TestSample), 0);

          if TestSample and TMDIChild(ParWind).SamToneShiftAsNoteOpt.Checked then begin
            TMDIChild(ParWind).Samples.HideMyCaret;
            TMDIChild(ParWind).Samples.RedrawSamples(0);
            TMDIChild(ParWind).Samples.ShowMyCaret;
          end;
          if not TestSample and TMDIChild(ParWind).OrnToneShiftAsNoteOpt.Checked then begin
            TMDIChild(ParWind).Ornaments.HideMyCaret;
            TMDIChild(ParWind).Ornaments.RedrawOrnaments(0);
            TMDIChild(ParWind).Ornaments.ShowMyCaret;
          end;

        end

        // Change Sample UP
        else if CursorX = 12 then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0] do
        begin
          if (Sample+1 <= 31) then
            if TestSample then
              TMDIChild(ParWind).ChangeSample(Sample+1, True)
            else
              Inc(Sample);
        end

        // Change Envelope up
        else if CursorX = 13 then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0] do
        begin
          if (Envelope+1 <= 15) then
            Inc(Envelope);
        end

        // Change Ornament up
        else if CursorX = 14 then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0] do
        begin
          if (Ornament+1 <= 15) then
            Inc(Ornament);
        end

        // Change Volume up
        else if CursorX = 15 then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0] do
        begin
          if (Volume+1 <= 15) then
            Inc(Volume);
        end

        // Change Noise up
        else if (CursorX = 5) or (CursorX = 6) then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)] do
        begin
          if (Noise+1 <= 31) then
            Inc(Noise);
        end

        // Change Global Envelope up
        else if (CursorX >= 0) and (CursorX <= 4) then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)] do
        begin
          if (Envelope+1 <= $ffff) then
            Inc(Envelope);
        end;

        RedrawTestLine(0);
      end;


      VK_DOWN:
      begin
        // Octave DOWN
        if CursorX = 8 then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)] do
        begin
          Note := Channel[0].Note;
          if Note >= 12 then
          begin
            Dec(Note, 12);
            Dec(TestOct);
          end;

          if TestOct = 0 then
            TestOct := 1;

          if not IsPlaying or (PlayMode = PMPlayLine)then
            PlVars[1].ParamsOfChan[MidChan].Note := Note;

          if TestSample then
            TMDIChild(ParWind).Samples.RecalcBaseNote(Note);

          Channel[0].Note := Note;
          TMDIChild(ParWind).DoAutoEnv(-1, Ord(TestSample), 0);

          if TestSample and TMDIChild(ParWind).SamToneShiftAsNoteOpt.Checked then begin
            TMDIChild(ParWind).Samples.HideMyCaret;
            TMDIChild(ParWind).Samples.RedrawSamples(0);
            TMDIChild(ParWind).Samples.ShowMyCaret;
          end;
          if not TestSample and TMDIChild(ParWind).OrnToneShiftAsNoteOpt.Checked then begin
            TMDIChild(ParWind).Ornaments.HideMyCaret;
            TMDIChild(ParWind).Ornaments.RedrawOrnaments(0);
            TMDIChild(ParWind).Ornaments.ShowMyCaret;
          end;
        end

        // Change sample DOWN
        else if CursorX = 12 then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0] do
        begin
          if (Sample-1 > 0) then
            if TestSample then
              TMDIChild(ParWind).ChangeSample(Sample-1, True)
            else
              Dec(Sample);
        end

        // Change Envelope down
        else if CursorX = 13 then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0] do
        begin
          if (Envelope-1 >= 0) then
            Dec(Envelope);
        end

        // Change Ornament down
        else if CursorX = 14 then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0] do
        begin
          if (Ornament-1 >= 0) then
            Dec(Ornament);
        end

        // Change Volume down
        else if CursorX = 15 then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0] do
        begin
          if (Volume-1 > 0) then
            Dec(Volume);
        end

        // Change Noise down
        else if (CursorX = 5) or (CursorX = 6) then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)] do
        begin
          if (Noise-1 >= 0) then
            Dec(Noise);
        end

        // Change Global Envelope up
        else if (CursorX >= 0) and (CursorX <= 4) then with TMDIChild(ParWind).VTMP.Patterns[-1].Items[Ord(TestSample)] do
        begin
          if (Envelope-1 >= 0) then
            Dec(Envelope);
        end;

        RedrawTestLine(0);
      end;

      VK_LEFT:
        if CursorX > 0 then
        begin
          if CursorX = 12 then
            Dec(CursorX, 4)
          else if ColSpace(CursorX - 1) then
            Dec(CursorX, 2)
          else
            Dec(CursorX);
          RecreateCaret;
          SetCaretPosition;
          RedrawTestLine(0);
        end;
      VK_RIGHT:
        if CursorX < 20 then
        begin
          Inc(CursorX);
          if ColSpace(CursorX) then
            Inc(CursorX)
          else if CursorX = 9 then
            Inc(CursorX, 3);
          RecreateCaret;
          SetCaretPosition;
          RedrawTestLine(0);
        end;
      192:
        begin
          if TestSample then
          begin
            if TMDIChild(ParWind).Samples.CanFocus then
              TMDIChild(ParWind).Samples.SetFocus
          end
          else if TMDIChild(ParWind).Ornaments.CanFocus then
            TMDIChild(ParWind).Ornaments.SetFocus
        end
    else
      begin
        if KeyPressed <> Key then
          if CursorX in NotePoses then
            DoNoteKey
          else
            DoOtherKeys;
      end;
    end
  else if Shift = [ssCtrl] then
    case Key of
      VK_RIGHT:
        if CursorX < 17 then
        begin
          CursorX := ColTabs[ColTab(CursorX) + 1];
          RecreateCaret;
          SetCaretPosition;
          RedrawTestLine(0);
        end;
      VK_LEFT:
        if CursorX > 4 then
        begin
          CursorX := ColTabs[ColTab(CursorX) - 1];
          RecreateCaret;
          SetCaretPosition;
          RedrawTestLine(0);
        end;
      VK_ADD, VK_SUBTRACT:
        begin
          if TestSample then
          begin
            if TMDIChild(ParWind).Samples.CanFocus then
              TMDIChild(MainForm.ActiveMDIChild).SamplesKeyDown(Sender, Key, Shift);
          end
          else if TMDIChild(ParWind).Ornaments.CanFocus then
            TMDIChild(MainForm.ActiveMDIChild).SamplesKeyDown(Sender, Key, Shift);

        end;
        
      VK_RETURN:
        if CursorX = 12 then
          OpenSample
        else if CursorX = 14 then
          OpenOrnament;

    end
  else if (Shift = [ssCtrl, ssShift]) or (Shift = [ssShift]) then
    if KeyPressed <> Key then
      if CursorX in NotePoses then
        DoNoteKey
end;

procedure TMDIChild.SamplesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Shift = [ssShift]) and Samples.isLineTesting then
    SampleTestLine.KeyUp(Key, []);

  if (Shift <> [ssShift]) and (Samples.isLineTesting) then
  begin

    if (PlayMode = PMPlayLine) and IsPlaying then
      ResetPlaying;

    PlayStopState := BPlay;
    SampleTestLine.TestLineExit(Sender);
    Samples.isLineTesting := False;
  end;
end;

procedure TMDIChild.SaveSyncSample;
var i: Integer;
begin
  SyncBufferBlocked := True;
  AssignFile(TxtFile, SyncSampleBufferFile);
  Rewrite(TxtFile);
  try
    with MainForm.BuffSample do
      for i := 0 to Length-1 do
      begin
        Write(TxtFile, GetSampleString(Items[i], False, False));
        if i = Loop then Write(TxtFile, ' L');
        Writeln(TxtFile);
      end;
  finally
    CloseFile(TxtFile);
  end;
  SyncSampleBufferFileAge := FileAge(SyncSampleBufferFile);
  SyncBufferBlocked := False;
end;


procedure TMDIChild.copySampleToBuffer(All: Boolean);
var
  ff, SampleLength: Integer;
  TxtFile: TextFile;

begin
  if not All and not Samples.isSelecting and not Samples.isColSelecting then Exit;
  LastClipboard := LCSamples;

  ValidateSample2(SamNum);

  
  if Samples.isColSelecting then begin
    SampleCopy.SrcWindow   := Self;
    SampleCopy.Ready       := True;
    Samples.isColSelecting := False;
    Samples.HideMyCaret;
    Samples.RedrawSamples(0);
    Samples.ShowMyCaret;

    SyncBufferBlocked := True;
    AssignFile(TxtFile, SyncSamplePartFile);
    Rewrite(TxtFile);
    try
      Writeln(TxtFile, IntToStr(SampleCopy.FromColumn));
      Writeln(TxtFile, IntToStr(SampleCopy.ToColumn));
      Writeln(TxtFile, IntToStr(SampleCopy.FromLine));
      Writeln(TxtFile, IntToStr(SampleCopy.ToLine));
    finally
      CloseFile(TxtFile);
    end;
    SyncSamplePartFileAge := FileAge(SyncSamplePartFile);
    SyncBufferBlocked := False;

    MainForm.BuffSample.Items := Samples.ShownSample.Items;
    MainForm.BuffSample.Loop := 0;
    MainForm.BuffSample.Length := 63;    
    SaveSyncSample;
    Exit;
  end;
  SampleCopy.Ready := False;


  if All then
  begin
    SampleLength := Samples.ShownSample.Length;
    Samples.selStart := 0;
  end
  else
    SampleLength := Samples.selEnd - Samples.selStart + 1;

  if SampleLength > MaxSamLen then
    SampleLength := MaxSamLen;
    

  for ff := 0 to SampleLength do
    MainForm.BuffSample.Items[ff] := Samples.ShownSample.items[ff + Samples.selStart];

  // If copied entire sample (Ctrl+A)
  if All or (SampleLength = MaxSamLen) then
  begin
    MainForm.BuffSample.Loop := Samples.ShownSample.Loop;
    MainForm.BuffSample.Length := Samples.ShownSample.Length;
  end
  else
  begin
    MainForm.BuffSample.Loop := 0;
    MainForm.BuffSample.Length := SampleLength;
  end;

  // Save sample to copy/paste buffer file
  SaveSyncSample;

  SamplesSelectionOff;

end;


procedure TMDIChild.PastePatternToSample;
var
  i, Res, SampleLine, CurPatLine: Integer;
  Chan: Byte;
  BaseNoteFreq, FreqAccum: Word;
  SampleTick: TSampleTick;
  NewSample: TSample;
  Inited: Boolean;
  ChanParams: TChanParams;
  AyRegisters: TRegisters;
  CurSample, ToneBit, NoiseBit: Byte;
  SavedPattern: TPattern;
  PatChannelLine: PChannelLine;
  SrcVTMP: PModule;
  SrcWindow: TMDIChild;

  function Bit(const aValue: Byte; const Bit: Byte): Boolean;
  begin
    Result := (aValue and (1 shl Bit)) <> 0;
  end;

begin
  if LastClipboard <> LCTracks then Exit;


  ValidateSample2(SamNum);
  SaveSampleUndo(Samples.ShownSample);

  SrcWindow    := TracksCopy.SrcWindow;
  SrcVTMP      := SrcWindow.VTMP;
  SavedPattern := TPattern(TracksCopy.Pattern^);

  if not TracksCopy.Command or not TracksCopy.Ornament then
    for i := 0 to TracksCopy.Pattern.Length-1 do begin
      PatChannelLine := @TracksCopy.Pattern.Items[i].Channel[TracksCopy.Channel];

      // Remove commands from pattern if user doesn't select commands column
      if not TracksCopy.Command then begin

        // Remove some commands
        if PatChannelLine.Additional_Command.Number in [1..3, 6..10] then begin
          PatChannelLine.Additional_Command.Number := 0;
          PatChannelLine.Additional_Command.Parameter := 0;
        end;

        // Remove commands delay
        PatChannelLine.Additional_Command.Delay := 0;

      end;


      // Remove ornaments if user doesn't select ornaments column
      if not TracksCopy.Ornament and (PatChannelLine.Ornament > 0) then
        PatChannelLine.Ornament := 0;

    end;


  Inited       := False;
  NewSample    := TSample(Samples.ShownSample^);
  SampleLine   := Samples.CurrentLine - 1;
  BaseNoteFreq := GetNoteFreq(VTMP.Ton_Table, VTMP.Patterns[-1].Items[1].Channel[0].Note);
  Chan         := TracksCopy.Channel;
  CurPatLine   := TracksCopy.FromLine;
  FreqAccum    := 0;

  NumberOfSoundChips := 1;
  PlayingWindow[1]   := SrcWindow;

  ToneBit  := 0;
  NoiseBit := 0;
  case Chan of
    0: begin ToneBit := 0; NoiseBit := 3; end;
    1: begin ToneBit := 1; NoiseBit := 4; end;
    2: begin ToneBit := 2; NoiseBit := 5; end;
  end;


  RerollToLineNum(1, TracksCopy.FromLine, TracksCopy.FromLine = 0, SrcVTMP);
  Res := 0;


  repeat
    Inc(SampleLine);

    if Inited then Res := Pattern_PlayCurrentLine;
    if Res = 1 then Inc(CurPatLine);

    if (CurPatLine > TracksCopy.ToLine) and (Res = 1) then Break;
    if Res = 2 then Break;
    if SampleLine = MaxSamLen then begin
      MessageBox(Handle, 'Maximum sample length reached', 'Application.Title', MB_OK + MB_ICONWARNING + MB_TOPMOST);
      Break;
    end;

    AyRegisters   := SoundChip[1].AYRegisters;
    ChanParams    := PlVars[1].ParamsOfChan[Chan];
    CurSample     := SrcVTMP.IsChans[Chan].Sample;


    // Calculate frequency accumulation
    for i := 0 to SampleLine-1 do begin
      SampleTick := NewSample.Items[i];
      if SampleTick.Ton_Accumulation then
        Inc(FreqAccum, SampleTick.Add_to_Ton);
    end;

    // Set Tone, Masks and Volume
    NewSample.Items[SampleLine].Add_to_Ton  := ChanParams.Ton - BaseNoteFreq - FreqAccum;
    NewSample.Items[SampleLine].Mixer_Ton   := not Bit(AyRegisters.Index[7], ToneBit);
    NewSample.Items[SampleLine].Mixer_Noise := not Bit(AyRegisters.Index[7], NoiseBit);
    NewSample.Items[SampleLine].Amplitude   := ChanParams.Amplitude and $f;
    NewSample.Items[SampleLine].Envelope_Enabled := SrcVTMP.Samples[CurSample].Items[ChanParams.SamplePrevPosition].Envelope_Enabled;

    // Note R--
    if SrcVTMP.Patterns[TracksCopy.PatNum].Items[CurPatLine].Channel[Chan].Note = -2 then begin
      NewSample.Items[SampleLine].Mixer_Ton   := False;
      NewSample.Items[SampleLine].Mixer_Noise := False;
      NewSample.Items[SampleLine].Add_to_Ton  := 0;
    end;

    // Envelope or Noise param
    if not NewSample.Items[SampleLine].Mixer_Noise then
      NewSample.Items[SampleLine].Add_to_Envelope_or_Noise := PlVars[1].AddToEnv
    else
      NewSample.Items[SampleLine].Add_to_Envelope_or_Noise := PlVars[1].PT3Noise;

    Inited := True;

  until False;

  NewSample.Length := SampleLine;

  // Restore pattern
  TracksCopy.Pattern.Items := SavedPattern.Items;
  
  // Copy sample
  for i := 0 to 63 do
    Samples.ShownSample.Items[i] := NewSample.Items[i];
  Samples.ShownSample.Length := NewSample.Length;
  Samples.ShownSample.Loop   := NewSample.Loop;

  // Redraw samples
  SampleLenUpDown.Position := Samples.ShownSample.Length;
  Samples.HideMyCaret;
  Samples.RedrawSamples(0);
  Samples.ShowMyCaret;

  SongChanged := True;
  BackupSongChanged := True;
  SaveSampleRedo;
end;

procedure TMDIChild.PasteOrnamentToSample;
var
  OrnamentLine, SampleLine: Integer;
  BaseNote, Note: ShortInt;
begin

  ValidateSample2(SamNum);
  SaveSampleUndo(Samples.ShownSample);

  SampleLine   := Samples.CurrentLine;
  BaseNote     := VTMP.Patterns[-1].Items[1].Channel[0].Note;

  
  for OrnamentLine := 0 to MainForm.BuffOrnament.Length - 1 do begin

    Note := BaseNote + MainForm.BuffOrnament.Items[OrnamentLine];
    Samples.SetNote(Note, SampleLine, $f, False, False, True);

    Inc(SampleLine);
    if SampleLine = MaxSamLen then begin
      MessageBox(Handle, 'Maximum sample length reached', 'Application.Title', MB_OK + MB_ICONWARNING + MB_TOPMOST);
      Break;
    end;

  end;


  Samples.ShownSample.Length := SampleLine;
  SampleLenUpDown.Position := SampleLine;
  Samples.HideMyCaret;
  Samples.RedrawSamples(0);
  Samples.ShowMyCaret;

  SongChanged := True;
  BackupSongChanged := True;
  SaveSampleRedo;

end;


procedure TMDIChild.pasteSampleFromBuffer(All: Boolean);
var
  ff, jj, ll, ii, Line, SrcLine: Integer;
begin

  if LastClipboard = LCTracks then begin
    PastePatternToSample;
    Exit;
  end;

  if LastClipboard = LCOrnaments then begin
    PasteOrnamentToSample;
    Exit;
  end;

  SongChanged := True;
  BackupSongChanged := True;

  // Paste sample columns
  if SampleCopy.Ready then begin
    SaveSampleUndo(Samples.ShownSample);
    SrcLine  := SampleCopy.FromLine;
    for Line := Samples.CurrentLine to Samples.CurrentLine + SampleCopy.ToLine - SampleCopy.FromLine do begin

      for jj := SampleCopy.FromColumn to SampleCopy.ToColumn do begin

        case jj of
          1: Samples.ShownSample.Items[Line].Mixer_Ton := SampleCopy.Sample.Items[SrcLine].Mixer_Ton;
          2: Samples.ShownSample.Items[Line].Mixer_Noise := SampleCopy.Sample.Items[SrcLine].Mixer_Noise;
          3: Samples.ShownSample.Items[Line].Envelope_Enabled := SampleCopy.Sample.Items[SrcLine].Envelope_Enabled;
          4: begin
            Samples.ShownSample.Items[Line].Add_to_Ton := SampleCopy.Sample.Items[SrcLine].Add_to_Ton;
            Samples.ShownSample.Items[Line].Ton_Accumulation := SampleCopy.Sample.Items[SrcLine].Ton_Accumulation;
          end;
          5: begin
            Samples.ShownSample.Items[Line].Envelope_or_Noise_Accumulation := SampleCopy.Sample.Items[SrcLine].Envelope_or_Noise_Accumulation;
            Samples.ShownSample.Items[Line].Add_to_Envelope_or_Noise := SampleCopy.Sample.Items[SrcLine].Add_to_Envelope_or_Noise;
          end;
          6: begin
            Samples.ShownSample.Items[Line].Amplitude := SampleCopy.Sample.Items[SrcLine].Amplitude;
            Samples.ShownSample.Items[Line].Amplitude_Sliding := SampleCopy.Sample.Items[SrcLine].Amplitude_Sliding;
            Samples.ShownSample.Items[Line].Amplitude_Slide_Up := SampleCopy.Sample.Items[SrcLine].Amplitude_Slide_Up;
          end;

        end;

      end;

      Inc(SrcLine);

      if Samples.ShownSample.Length < Line + 1 then
        Samples.ShownSample.Length := Line + 1;

    end;

    SampleLenUpDown.Position := Samples.ShownSample.Length;
    Samples.HideMyCaret;
    Samples.RedrawSamples(0);
    Samples.ShowMyCaret;
    SaveSampleRedo;
    Exit;
  end;


  ValidateSample2(SamNum);
  SaveSampleUndo(Samples.ShownSample);
  GetSamParams(ll, ii);

  if All then
  begin
    ii := 0;
    ClearShownSample;
  end;    

  // Paste part of sample
  for ff := 0 to MainForm.BuffSample.Length-1 do
  begin
    if ff + ii <= 63 then
    begin
      Samples.ShownSample.items[ff + ii] := MainForm.BuffSample.Items[ff];
      if ff + ii >= Samples.ShownSample.Length then
        Samples.ShownSample.Length := ff + ii + 1;
    end;
  end;

  if MainForm.BuffSample.Loop <> 0 then
    Samples.ShownSample.Loop := ii + MainForm.BuffSample.Loop;

  SampleLenUpDown.Position  := Samples.ShownSample.Length;
  SampleLoopUpDown.Position := Samples.ShownSample.Loop;

  SamplesSelectionOff;
  SaveSampleRedo;

end;


procedure TMDIChild.GetSamParams(var l, i: Integer);
begin
  with Samples do
  begin
    if ShownSample = nil then
      l := 1
    else
      l := ShownSample.Length;
    i := ShownFrom + CursorY
  end
end;

procedure TMDIChild.SamplesSelectionOff;
begin
  Samples.isSelecting := False;
  Samples.isColSelecting := False;  
  Samples.HideMyCaret;
  Samples.RedrawSamples(0);
  Samples.ShowMyCaret;
end;


procedure TMDIChild.SamplesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
type
  TSamToggles = (TgMixTone, TgMixNoise, TgMaskEnv, TgSgnTone, TgSgnNoise, TgAccTone, TgAccNoise, TgAccVol, TgSgnToneP, TgSgnToneM, TgSgnNoiseP, TgSgnNoiseM, TgAccVolP, TgAccVolM, TgAccTone_, TgAccNoise_, TgAccVol_, TgAccToneA, TgAccNoiseA);

  TSamNumbers = (NmTone, NmNoise, NmNoiseAbs, NmVol);


var
  ST: PSampleTick;
  ff, ll, ii, i: Integer; //for, len , position
  curToneTab, noteFreq1, noteFreq2: Integer;
 // envshift: ShortInt;
  envFreq: Integer;
  Incr, Decr: Boolean;

  procedure DoToggle(n: TSamToggles);
  var
    i, l: Integer;
  begin
    SamplesSelectionOff;
    with Samples do
    begin
      GetSamParams(l, i);
      if i >= l then
        exit;
      SongChanged := True;
      BackupSongChanged := True;
      ValidateSample2(SamNum);
      New(ST);
      ST^ := ShownSample.Items[i];
      AddUndo(CAChangeSampleValue, Integer(ST), i);
      with ShownSample.Items[i] do
        case n of
          TgMixTone:
            Mixer_Ton := not Mixer_Ton;
          TgMixNoise:
            Mixer_Noise := not Mixer_Noise;
          TgMaskEnv:
            Envelope_Enabled := not Envelope_Enabled;
          TgSgnTone:
            if not ToneShiftAsNote then
              Add_to_Ton := -Add_to_Ton;
          TgSgnToneP:
            if not ToneShiftAsNote then
              Add_to_Ton := abs(Add_to_Ton);
          TgSgnToneM:
            if not ToneShiftAsNote then
              Add_to_Ton := -abs(Add_to_Ton);
          TgSgnNoise:
            Add_to_Envelope_or_Noise := Ns(-Add_to_Envelope_or_Noise);
          TgSgnNoiseP:
            Add_to_Envelope_or_Noise := Ns(abs(Add_to_Envelope_or_Noise));
          TgSgnNoiseM:
            Add_to_Envelope_or_Noise := Ns(-abs(Add_to_Envelope_or_Noise));
          TgAccTone:
            Ton_Accumulation := not Ton_Accumulation;
          TgAccNoise:
            Envelope_or_Noise_Accumulation := not Envelope_or_Noise_Accumulation;
          TgAccVol:
            if not Amplitude_Sliding then
            begin
              Amplitude_Sliding := True;
              Amplitude_Slide_Up := False
            end
            else if not Amplitude_Slide_Up then
              Amplitude_Slide_Up := True
            else
              Amplitude_Sliding := False;
          TgAccVolP:
            begin
              Amplitude_Sliding := True;
              Amplitude_Slide_Up := True
            end;
          TgAccVolM:
            begin
              Amplitude_Sliding := True;
              Amplitude_Slide_Up := False
            end;
          TgAccVol_:
            Amplitude_Sliding := False;
          TgAccTone_:
            Ton_Accumulation := False;
          TgAccNoise_:
            Envelope_or_Noise_Accumulation := False;
          TgAccToneA:
            Ton_Accumulation := True;
          TgAccNoiseA:
            Envelope_or_Noise_Accumulation := True
        end;
      HideMyCaret;
      RedrawSamples(0);
      ShowMyCaret;
    end
  end;

  procedure DoToggleSpace;
  begin
    SamplesSelectionOff;
    if Samples.ToneShiftAsNote and (Samples.CursorX in [4..7]) then Exit;
    case Samples.CursorX of
      0..2:
        DoToggle(TSamToggles(Samples.CursorX));
      4..7:
        DoToggle(TgSgnTone);
      8:
        DoToggle(TgAccTone);
      10..15:
        DoToggle(TgSgnNoise);
      17:
        DoToggle(TgAccNoise);
      19, 20:
        DoToggle(TgAccVol)
    end
  end;

  procedure DoTogglePlus;
  begin
    SamplesSelectionOff;
    if Samples.ToneShiftAsNote and (Samples.CursorX in [4..7]) then Exit;
    case Samples.CursorX of
      4..7:
        DoToggle(TgSgnToneP);
      10..15:
        DoToggle(TgSgnNoiseP);
      19, 20:
        DoToggle(TgAccVolP)
    end
  end;

  procedure DoToggleMinus;
  begin
    SamplesSelectionOff;
    if Samples.ToneShiftAsNote and (Samples.CursorX in [4..7]) then Exit;
    case Samples.CursorX of
      4..7:
        DoToggle(TgSgnToneM);
      10..15:
        DoToggle(TgSgnNoiseM);
      19, 20:
        DoToggle(TgAccVolM)
    end
  end;

  procedure DoToggleAccA;
  begin
    SamplesSelectionOff;
    if Samples.ToneShiftAsNote and (Samples.CursorX in [4..7]) then Exit;
    case Samples.CursorX of
      4..8:
        DoToggle(TgAccToneA);
      10..17:
        DoToggle(TgAccNoiseA)
    end
  end;

  procedure DoToggle_;
  begin
    SamplesSelectionOff;
    if Samples.ToneShiftAsNote and (Samples.CursorX in [4..7]) then Exit;
    case Samples.CursorX of
      4..8:
        DoToggle(TgAccTone_);
      10..17:
        DoToggle(TgAccNoise_);
      19, 20:
        DoToggle(TgAccVol_)
    end
  end;

  procedure DoNumber(n: TSamNumbers);
  var
    i, l: Integer;
  begin
    if Samples.ToneShiftAsNote and (Samples.CursorX in [4..7]) then Exit;

    with Samples do
    begin
      SamplesSelectionOff;
      GetSamParams(l, i);
      if i >= l then
        exit;
      SongChanged := True;
      BackupSongChanged := True;
      ValidateSample2(SamNum);
      New(ST);
      ST^ := ShownSample.Items[i];
      AddUndo(CAChangeSampleValue, Integer(ST), i);
      with ShownSample.Items[i] do
        case n of
          NmTone:
            if Add_to_Ton < 0 then
              Add_to_Ton := -InputSNumber
            else
              Add_to_Ton := InputSNumber;
          NmNoise:
            if Add_to_Envelope_or_Noise < 0 then
              Add_to_Envelope_or_Noise := Ns(-InputSNumber)
            else
              Add_to_Envelope_or_Noise := Ns(InputSNumber);
          NmNoiseAbs:
            Add_to_Envelope_or_Noise := Ns(InputSNumber);
          NmVol:
            Amplitude := InputSNumber
        end;
      HideMyCaret;
      RedrawSamples(0);
      ShowMyCaret;
    end
  end;

  procedure DoDigit(n: Integer);
  var
    nm: Integer;
  begin
    SamplesSelectionOff;
    if Samples.ToneShiftAsNote and (Samples.CursorX in [4..8]) then Exit;

    if DecBaseNoiseOn and (Samples.CursorX in [10, 11, 14, 17]) then
      nm := Samples.InputSNumber * 10 + n
    else
      nm := Samples.InputSNumber * 16 + n;

    case Samples.CursorX of
      4..8:
        begin
          if nm > $FFF then
            nm := n;
          Samples.InputSNumber := nm;
          DoNumber(NmTone)
        end;
      10, 11:
        begin
          if nm > $10 then
            nm := n;
          Samples.InputSNumber := nm;
          DoNumber(NmNoise)
        end;
      14, 17:
        begin
          if nm > $1F then
            nm := n;
          Samples.InputSNumber := nm;
          DoNumber(NmNoiseAbs)
        end;
      19, 20:
        begin
          if nm > $F then
            nm := n;
          Samples.InputSNumber := nm;

          ValidateSample2(SamNum);
          if Samples.ShownSample.Length <= Samples.ShownFrom + Samples.CursorY then
            Samples.ShownSample.Length := Samples.ShownFrom + Samples.CursorY + 1;

          DoNumber(NmVol)
        end
    end
  end;


begin

  Incr := (Key = VK_ADD) or (Key = 187);
  Decr := (Key = VK_SUBTRACT) or (Key = 189);

  // Increase/Descrease selected columns
  if Incr or Decr then begin
    if Samples.ToneShiftAsNote and (Samples.CursorX in [4..8]) then Exit;

    if not Samples.isColSelecting and not Samples.isSelecting then
      ResetSampleVolumeBuf;

    if Incr then IncreaseSampleCols(Shift);
    if Decr then DecreaseSampleCols(Shift);

    Exit;
  end;


  // Delete selected cols
  if Samples.isColSelecting and ((Key = VK_BACK) or (Key = VK_DELETE)) then begin
    ClearSampleCols;
    Exit;
  end;


  // Exit testline if Shift+Note pressed
  if Shift <> [ssShift] then
  begin
    SampleTestLine.KeyPressed := 0;
    SampleTestLine.TestLineExit(Sender);
  end;


  // Alt+1..8 - change octave
  if (Shift = [ssAlt]) and (Key >= 49) and (Key <= 56) then
  begin
    SamOctaveNum.Position  := Key - 48;
    SampleTestLine.TestOct := SamOctaveNum.Position;
    Exit;
  end;


  // Numpad 1-8 - change octave
  if (Key in [VK_NUMPAD1..VK_NUMPAD8]) then begin
    SamOctaveNum.Position := Key - VK_NUMPAD0;
    Exit;
  end;


  // Set note in tone shift position
  if Samples.ToneShiftAsNote and (Samples.CursorX in [4, 5]) and (NoteKeys[Key] <> -3) and (Shift <> [ssShift]) then begin
    if Key >= 256 then Exit;
    Samples.SetNote(NoteKeys[Key], Samples.CurrentLine, -1, True, True, False);
    Exit;
  end;


  if (Shift <> []) or not (Key in [Ord('0')..Ord('9'), Ord('A')..Ord('F')]) then
    Samples.InputSNumber := 0;

  ff := Ord('C');
  ll := ff;

  if (Shift = []) or (Shift = [ssDouble]) then
    case Key of
      VK_NEXT:
        begin
          if (Samples.CursorY < Samples.NOfLines - 1) then
          begin
            Samples.CursorY := Samples.NOfLines - 1;
            Samples.SetCaretPosition;
          end
          else if Samples.ShownFrom < MaxSamLen - Samples.NOfLines then
          begin
            Inc(Samples.ShownFrom, Samples.NOfLines);
            if Samples.ShownFrom > MaxSamLen - Samples.NOfLines then
              Samples.ShownFrom := MaxSamLen - Samples.NOfLines;
            Samples.HideMyCaret;
            Samples.RedrawSamples(0);
            Samples.ShowMyCaret;
          end
        end;
      VK_PRIOR:
        begin
          if (Samples.CursorY > 0) then
          begin
            Samples.CursorY := 0;
            Samples.SetCaretPosition;
          end
          else if Samples.ShownFrom > 0 then
          begin
            Dec(Samples.ShownFrom, Samples.NOfLines);
            if Samples.ShownFrom < 0 then
              Samples.ShownFrom := 0;
            Samples.HideMyCaret;
            Samples.RedrawSamples(0);
            Samples.ShowMyCaret;
          end
        end;
        
      VK_HOME:
        if Samples.CursorX <> 0 then
        begin
          Samples.CursorX := 0;
          Samples.RecreateCaret;
          Samples.SetCaretPosition;
        end;

      VK_END:
        if Samples.CursorX <> 20 then
        begin
          Samples.CursorX := 20;
          Samples.RecreateCaret;
          Samples.SetCaretPosition;
        end;

      VK_DOWN:
        begin
          if Shift <> [ssDouble] then
            SamplesSelectionOff;
          if (Samples.CursorY < Samples.NOfLines - 1) then
          begin
            Inc(Samples.CursorY);
            Samples.SetCaretPosition;
          end
          else if Samples.ShownFrom < MaxSamLen - Samples.NOfLines then
          begin
            Inc(Samples.ShownFrom);
            Samples.HideMyCaret;
            Samples.RedrawSamples(0);
            Samples.ShowMyCaret;
          end;
        end;
      VK_UP:
        begin
          if Shift <> [ssDouble] then
            SamplesSelectionOff;
          if (Samples.CursorY > 0) then
          begin
            Dec(Samples.CursorY);
            Samples.SetCaretPosition;
          end
          else if Samples.ShownFrom > 0 then
          begin
            Dec(Samples.ShownFrom);
            Samples.HideMyCaret;
            Samples.RedrawSamples(0);
            Samples.ShowMyCaret
          end
        end;

      VK_LEFT: begin
        if Shift <> [ssDouble] then
          SamplesSelectionOff;
        if Samples.CursorX > 0 then
        begin
          if Samples.CursorX in [4, 10, 19] then
            Dec(Samples.CursorX, 2)
          else if Samples.CursorX in [8, 14, 17] then
            Dec(Samples.CursorX, 3)
          else
            Dec(Samples.CursorX);
          Samples.RecreateCaret;
          Samples.SetCaretPosition;
        end;
      end;

      VK_RIGHT: begin
        if Shift <> [ssDouble] then
          SamplesSelectionOff;
        if Samples.CursorX < 20 then
        begin
          Inc(Samples.CursorX);
          if Samples.CursorX in [3, 9, 13, 16, 18] then
            Inc(Samples.CursorX)
          else if Samples.CursorX = 6 then
            Samples.CursorX := 8
          else if Samples.CursorX = 12 then
            Samples.CursorX := 14
          else if Samples.CursorX = 15 then
            Samples.CursorX := 17;
          Samples.RecreateCaret;
          Samples.SetCaretPosition;
        end;
      end;
      
      VK_DELETE:
        if (ssCtrl in Shift) and (ssShift in Shift) then
        begin
        end
        else if (ssShift in Shift) then
        begin
        end
        else if (ssCtrl in Shift) then
        begin
        //next position
        end
        else
        begin
        //delete position of sample.
        //Samples.CursorY;
          ValidateSample2(SamNum);
          GetSamParams(ll, ii);

          if (Samples.ShownSample.Length > 0) and (ii < (ll - 1)) then
          begin
            Samples.ShownSample.Length := Samples.ShownSample.Length - 1;
            if Samples.ShownSample.Loop > ii then
              Samples.ShownSample.Loop := Samples.ShownSample.Loop - 1;
          end;

          for ff := ii to 62 do
          begin
            Samples.ShownSample.Items[ff] := Samples.ShownSample.Items[ff + 1];
          end;
          Samples.ShownSample.Items[63].Add_to_Ton := 0;
          Samples.ShownSample.Items[63].Add_to_Ton := 0;
          Samples.ShownSample.Items[63].Ton_Accumulation := False;
          Samples.ShownSample.Items[63].Amplitude := 0;
          Samples.ShownSample.Items[63].Amplitude_Sliding := False;
          Samples.ShownSample.Items[63].Amplitude_Slide_Up := False;
          Samples.ShownSample.Items[63].Envelope_Enabled := False;
          Samples.ShownSample.Items[63].Envelope_or_Noise_Accumulation := False;
          Samples.ShownSample.Items[63].Add_to_Envelope_or_Noise := 0;
          Samples.ShownSample.Items[63].Mixer_Ton := False;
          Samples.ShownSample.Items[63].Mixer_Noise := False;

          SampleLenUpDown.Position  := Samples.ShownSample.Length;
          SampleLoopUpDown.Position := Samples.ShownSample.Loop;

          Samples.HideMyCaret;
          Samples.RedrawSamples(0);
          Samples.ShowMyCaret;
        end;
      VK_INSERT:
        if (ssCtrl in Shift) and (ssShift in Shift) then
        begin
        end
        else if (ssShift in Shift) then
        begin
        end
        else if (ssCtrl in Shift) then
        begin
        //next position
        end
        else
        begin
          ValidateSample2(SamNum);
          GetSamParams(ll, ii);

          if (ll < 64) and (ii <= (ll)) then
          begin
            Samples.ShownSample.Length := Samples.ShownSample.Length + 1;
            if Samples.ShownSample.Loop >= ii then
              Samples.ShownSample.Loop := Samples.ShownSample.Loop + 1;
          end;

          for ff := 62 downto ii do
          begin
            Samples.ShownSample.Items[ff + 1] := Samples.ShownSample.Items[ff];
          end;
          SampleLenUpDown.Position := Samples.ShownSample.Length;
          SampleLoopUpDown.Position := Samples.ShownSample.Loop;
          Samples.HideMyCaret;
          Samples.RedrawSamples(0);
          Samples.ShowMyCaret;

        end;

      Ord('T'):
        DoToggle(TgMixTone);
      Ord('N'):
        DoToggle(TgMixNoise);
      Ord('M'):
        DoToggle(TgMaskEnv);
      Ord(' '):
        DoToggleSpace;
      $BB, VK_ADD:
        DoTogglePlus;
      $BD, VK_SUBTRACT:
        DoToggleMinus;
      Ord('0')..Ord('9'):
        DoDigit(Key - Ord('0'));
      Ord('A')..Ord('F'):
        if not DecBaseNoiseOn or not (Samples.CursorX in [10, 11, 14, 17]) then
          DoDigit(Key - Ord('A') + 10)
        else
          Exit;
      192:
        if SampleTestLine.CanFocus then
          SampleTestLine.SetFocus
    end
  else if Shift = [ssCtrl] then
    case Key of

      // Ctrl + PgDown, Ctrl + End
      VK_NEXT, VK_END:
        begin
          SamplesSelectionOff;
          if (((Key = VK_END) or (Key = VK_DOWN)) and (Samples.CursorX <> 20)) or (Samples.CursorY < Samples.NOfLines - 1) then
          begin
            if (Key = VK_END) or (Key = VK_DOWN) then
            begin
              //Samples.CursorX := 20;
              Samples.RecreateCaret
            end;
            Samples.CursorY := Samples.NOfLines - 1;
            Samples.SetCaretPosition;
          end;
          if Samples.ShownFrom < MaxSamLen - Samples.NOfLines then
          begin
            Samples.ShownFrom := MaxSamLen - Samples.NOfLines;
            Samples.HideMyCaret;
            Samples.RedrawSamples(0);
            Samples.ShowMyCaret
          end
        end;

      // Ctrl + PgUp, Ctrl + Home
      VK_PRIOR, VK_HOME:
        begin
          SamplesSelectionOff;
          if (((Key = VK_HOME) or (Key = VK_UP)) and (Samples.CursorX <> 0)) or (Samples.CursorY > 0) then
          begin
            if (Key = VK_HOME) or (Key = VK_UP) then
            begin
              //Samples.CursorX := 0;
              Samples.RecreateCaret
            end;
            Samples.CursorY := 0;
            Samples.SetCaretPosition;
          end;
          if Samples.ShownFrom > 0 then
          begin
            Samples.ShownFrom := 0;
            Samples.HideMyCaret;
            Samples.RedrawSamples(0);
            Samples.ShowMyCaret
          end
        end;

      // Selecting columns
      // Ctrl + Arrows
      VK_UP, VK_DOWN, VK_RIGHT, VK_LEFT: begin

        Samples.isSelecting := False;

        if not Samples.isColSelecting then begin
          ResetSampleVolumeBuf;
          SampleCopy.StartLine   := Samples.CurrentLine;
          SampleCopy.FromLine    := SampleCopy.StartLine;
          SampleCopy.ToLine      := SampleCopy.StartLine;
          SampleCopy.StartColumn := DetectSampleColumn(Samples.CursorX);
          SampleCopy.FromColumn  := SampleCopy.StartColumn;
          SampleCopy.ToColumn    := SampleCopy.StartColumn;
          Samples.isColSelecting := True;
        end
        else begin

          // Tone jump
          if (Samples.CursorX >= 4) and (Samples.CursorX <= 8) and (Key = VK_LEFT) then Samples.CursorX := 4
          else if (Samples.CursorX >= 4) and (Samples.CursorX <= 8) and (Key = VK_RIGHT) then Samples.CursorX := 10
          // Noise
          else if (Samples.CursorX >= 10) and (Samples.CursorX <= 17) and (Key = VK_LEFT) then Samples.CursorX := 5
          else if (Samples.CursorX >= 10) and (Samples.CursorX <= 17) and (Key = VK_RIGHT) then Samples.CursorX := 19
          // Amplitude
          else if (Samples.CursorX >= 19) and (Samples.CursorX <= 20) and (Key = VK_RIGHT) then Samples.CursorX := 19
          else if (Samples.CursorX >= 19) and (Samples.CursorX <= 20) and (Key = VK_LEFT) then Samples.CursorX := 17;          
                                   
         { if Key = VK_DOWN  then Inc(Samples.CursorY);
          if Key = VK_UP    then Dec(Samples.CursorY);
          if Key = VK_LEFT  then Inc(Samples.CursorX);
          if Key = VK_RIGHT then Dec(Samples.CursorX);

          if Samples.CurrentLine <= 0 then Samples.CursorY := 0;
          if Samples.CurrentLine >= MaxSamLen-1 then Samples.CursorY := 0;
          if Samples.CursorX < 0 then Samples.CursorX := 0;
          if Samples.CursorX >= 20 then Samples.CursorX := 20;  }

          SamplesKeyDown(Sender, Key, [ssDouble]);

          SampleCopy.ToLine      := Samples.CurrentLine;
          SampleCopy.ToColumn    := DetectSampleColumn(Samples.CursorX);

          if SampleCopy.StartLine >= SampleCopy.ToLine then
          begin
            SampleCopy.ToLine := SampleCopy.StartLine;
            SampleCopy.FromLine := Samples.CurrentLine;
          end;

          if SampleCopy.StartLine < SampleCopy.ToLine then
          begin
            SampleCopy.FromLine := SampleCopy.StartLine;
            SampleCopy.ToLine := Samples.CurrentLine;
          end;

          if SampleCopy.StartColumn >= SampleCopy.ToColumn then begin
            i := SampleCopy.ToColumn;
            SampleCopy.ToColumn := SampleCopy.StartColumn;
            SampleCopy.FromColumn := i;
          end;

          if SampleCopy.StartColumn < SampleCopy.ToColumn then begin
            i := SampleCopy.ToColumn;
            SampleCopy.FromColumn := SampleCopy.StartColumn;
            SampleCopy.ToColumn := i;
          end;
        end;

        Samples.HideMyCaret;
        Samples.RedrawSamples(0);
        Samples.ShowMyCaret;
      end;

      // Ctrl + Num+
      VK_ADD:
        begin
        //next sample
          if SampleNumUpDown.Position in [1..30] then
          begin
            ChangeSample(SampleNumUpDown.Position + 1, True);
          end;
        end;

      // Ctrl + Num-
      VK_SUBTRACT:
        begin
        //previous sample
          if SampleNumUpDown.Position in [2..31] then
          begin
            ChangeSample(SampleNumUpDown.Position - 1, True);
          end;
        end;

      // Ctrl + Delete
      VK_DELETE:
        begin
        // delete sample position
{           ValidateSample2(Samples.);
        if then
        begin
          ChangeSample(StrToInt(Edit5.Text)-1);
          Edit5.Text:= IntToStr((StrToInt(Edit5.Text)-1));
        end;}
        end;
{      VK_INSERT:
        begin
          ValidateSample2(SamNum);
          GetSamParams(ll,ii);

          if ii > ll-1 then
          begin
          for ff:= Samples.ShownSample.loop to ll do
          begin
            if ii + ff - Samples.ShownSample.loop <=63 then
            Samples.ShownSample.Items[ii+ff - Samples.ShownSample.loop ]:= Samples.ShownSample.Items[ff];
          end;

          end
          else
          begin

          end;

          Edit9.Text:= IntToStr(Samples.ShownSample.Length);
          Edit10.Text:= IntToStr(Samples.ShownSample.Loop);
          Samples.HideMyCaret;
          Samples.RedrawSamples(0);
          Samples.ShowMyCaret;
        end;}

      // Ctrl + Insert - Copy sample part to buffer
      VK_INSERT:
        copySampleToBuffer(False);

      // Ctrl + A
      Ord('A'):
        begin
          ValidateSample2(SamNum);
          GetSamParams(ll, ii);

//          Samples.ShownSample.Length := 64;
//          Samples.ShownSample.Loop := 0;

          if not Samples.isSelecting then
          begin
            Samples.selStart := 0;
            Samples.selEnd := 64;
            Samples.isSelecting := True;
          end
          else
            Samples.isSelecting := False;



//          Edit9.Text := IntToStr(Samples.ShownSample.Length);
//          Edit10.Text := IntToStr(Samples.ShownSample.Loop);
          Samples.HideMyCaret;
          Samples.RedrawSamples(0);
          Samples.ShowMyCaret;
        end;
//      Ord('C'): CTRL + INS
//      end;
//      Ord('V'): SHIFT + INS
//       begin
//       ll:= ll;
//      end;

    end
  else if Shift = [ssShift] then
    case Key of

      Ord('6'):
        DoToggleAccA;
      $BB:
        DoTogglePlus;
      $BD:
        DoToggle_;

      // Shift + Home
      VK_HOME:
        begin
          Samples.isColSelecting := False;
          ValidateSample2(SamNum);
          GetSamParams(ll, ii);

          if (Samples.ShownSample.Length > 0) and (ii < ll) then
          begin
            Samples.ShownSample.Loop := ii;
          end;
          SampleLenUpDown.Position := Samples.ShownSample.Length;
          SampleLoopUpDown.Position := Samples.ShownSample.Loop;

          Samples.HideMyCaret;
          Samples.RedrawSamples(0);
          Samples.ShowMyCaret;
        end;

      // Shift + End
      VK_END:
        begin
          Samples.isColSelecting := False;
          ValidateSample2(SamNum);
          GetSamParams(ll, ii);

          Samples.ShownSample.Length := ii + 1;
          if Samples.ShownSample.Loop > Samples.ShownSample.Length then
            Samples.ShownSample.Loop := ii;

          SampleLenUpDown.Position := Samples.ShownSample.Length;
          SampleLoopUpDown.Position := Samples.ShownSample.Loop;

          Samples.HideMyCaret;
          Samples.RedrawSamples(0);
          Samples.ShowMyCaret;
        end;

      // Shift + Insert
      VK_INSERT:
        pasteSampleFromBuffer(False);

      // Shift + Left/Right
      VK_LEFT, VK_RIGHT:
        begin
          Samples.isColSelecting := False;

          GetSamParams(ll, ii);
          Samples.selStart := ii;
          Samples.selEnd := ii;
          Samples.isSelecting := True;

          Samples.HideMyCaret;
          Samples.RedrawSamples(0);
          Samples.ShowMyCaret;
        end;

      // Shift + Down
      VK_DOWN:
        begin
          Samples.isColSelecting := False;

          if not Samples.isSelecting then
          begin
            ResetSampleVolumeBuf;
            GetSamParams(ll, ii);
            Samples.selStart := ii;
            Samples.selEnd := ii;
            Samples.isSelecting := True;
          end;

          if (Samples.CursorY < Samples.NOfLines - 1) then
          begin
            Inc(Samples.CursorY);
            Samples.SetCaretPosition;
          end
          else if Samples.ShownFrom < MaxSamLen - Samples.NOfLines then
          begin
            Inc(Samples.ShownFrom);

          end;

          if Samples.isSelecting then
          begin
            GetSamParams(ll, ii);
            Samples.selEnd := ii;
          end;

          if Samples.selEnd < Samples.selStart then
          begin
            ii := Samples.selEnd;
            Samples.selEnd := Samples.selStart;
            Samples.selStart := ii;
          end;

          Samples.HideMyCaret;
          Samples.RedrawSamples(0);
          Samples.ShowMyCaret;

        end;

      // Shift + Up   
      VK_UP:
        begin
          Samples.isColSelecting := False;
          
          if not Samples.isSelecting then
          begin
            ResetSampleVolumeBuf;
            GetSamParams(ll, ii);
            Samples.selStart := ii;
            Samples.selEnd := ii;
            samples.isSelecting := True
          end;

          //Samples.selEnd = Samples.selStart then
          //  Inc(Samples.selEnd);

          if (Samples.CursorY > 0) then
          begin
            Dec(Samples.CursorY);
            Samples.SetCaretPosition;
          end
          else if Samples.ShownFrom > 0 then
          begin
            Dec(Samples.ShownFrom);

          end;

          if Samples.isSelecting then
          begin
            GetSamParams(ll, ii);

            Samples.selStart := ii;
          end;

          if Samples.selEnd < Samples.selStart then
          begin
            ii := Samples.selEnd;
            Samples.selEnd := Samples.selStart;
            Samples.selStart := ii;
          end;

          Samples.HideMyCaret;
          Samples.RedrawSamples(0);
          Samples.ShowMyCaret

        end;
    else
      begin
        if NoteKeys[Key] <= -2 then Exit;
        Samples.isLineTesting := True;
        Shift := [];
        SampleTestLine.CursorX := 8;
        SampleTestLine.TestLineKeyDown(Sender, Key, Shift);
      end;
    end
  {
    // Commented block, because users no need templates for samples
    else if Shift = [ssAlt] then
    case Key of
      VK_RIGHT:
        AddCurrentToSampTemplate;
      VK_LEFT:
        CopySampTemplateToCurrent
    end
  }
  else if Shift = [ssShift, ssCtrl] then
  begin
//      ValidateSample2(Key);
    Shift := [];
    GetSamParams(ll, ii);
//tone
    if (Samples.CursorX >= 4) and (Samples.CursorX <= 8) then
    begin

//        curToneTab:= TMDIChild(ActiveMDIChild).VTMP.Ton_Table;
      curToneTab := VTMP.Ton_Table;
      if Key >= 256 then
        exit;
      if NoteKeys[Key] >= 0 then
      begin
        //noteFreq1:= GetNoteFreq(curToneTab,VTMP.Patterns[-1].Items[SamNum].Channel[0].Note);
        noteFreq1 := GetNoteFreq(curToneTab, VTMP.Patterns[-1].Items[1].Channel[0].note);
        noteFreq2 := GetNoteFreq(curToneTab, NoteKeys[Key] + (12 * (SampleTestLine.TestOct - 1)));

        Samples.ShownSample.Items[ii].Add_to_Ton := noteFreq2 - noteFreq1;
        Samples.HideMyCaret;
        Samples.RedrawSamples(0);
        Samples.ShowMyCaret
      end

    end

//envelope
    else if (Samples.CursorX >= 10) and (Samples.CursorX <= 18) then
    begin
//        curToneTab:= TMDIChild(ActiveMDIChild).VTMP.Ton_Table;
      curToneTab := VTMP.Ton_Table;
      if Key >= 256 then
        exit;
      if NoteKeys[Key] >= 0 then
      begin
        //noteFreq1:= GetNoteFreq(curToneTab,VTMP.Patterns[-1].Items[SamNum].Channel[0].Note);
        noteFreq1 := GetNoteFreq(curToneTab, VTMP.Patterns[-1].Items[1].Channel[0].note);
        noteFreq2 := GetNoteFreq(curToneTab, NoteKeys[Key] + (12 * (SampleTestLine.TestOct - 1)));

//  envshift:ShortInt;
//  envFreq: Integer;
        envFreq := (noteFreq2 - noteFreq1);
        if envFreq >= 0 then
        begin
          envFreq := (noteFreq2 - noteFreq1 + 8) div 16;
          if envFreq > 15 then
            envFreq := 0;
        end
        else
        begin
          envFreq := (noteFreq2 - noteFreq1 - 8) div 16;
          if envFreq < -15 then
            envFreq := 0;
        end;
//          envshift =

        Samples.ShownSample.Items[ii].Add_to_Envelope_or_Noise := envFreq;
        Samples.HideMyCaret;
        Samples.RedrawSamples(0);
        Samples.ShowMyCaret
      end
    end;
  end;
end;

procedure TMDIChild.OrnamentsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key <> Ornaments.KeyPressed then Exit;
  
  if (Shift = [ssShift]) and Ornaments.isLineTesting then
    OrnamentTestLine.KeyUp(Key, []);


  if Samples.isLineTesting then begin
    if (PlayMode = PMPlayLine) and IsPlaying then
      ResetPlaying;

    PlayStopState := BPlay;
    SampleTestLine.TestLineExit(Sender);
    Samples.isLineTesting := False;

    VTMP.Patterns[-1].Items[1].Channel[0] := Ornaments.SavedSampleTestLine;
  end;
  

  if (Shift <> [ssShift]) and (Ornaments.isLineTesting) then
  begin

    if (PlayMode = PMPlayLine) and IsPlaying then
      ResetPlaying;

    PlayStopState := BPlay;
    OrnamentTestLine.TestLineExit(Sender);
    Ornaments.isLineTesting := False;
  end;

  Ornaments.KeyPressed := 0;

end;


procedure TMDIChild.copyOrnamentToBuffer(All: Boolean);
var
  ff, OrnLength, i: Integer;
begin

  OrnamentCopySrcWindow := Self;

  if not Ornaments.isSelecting then begin
    Ornaments.selStart := Ornaments.CurrentLine;
    Ornaments.selEnd   := Ornaments.CurrentLine;
    Ornaments.isSelecting := True;
  end;

  if (Ornaments.selStart = 0) and (Ornaments.selEnd = MaxOrnLen) then
    All := True;

  LastClipboard := LCOrnaments;
  ValidateOrnament(OrnNum);

  // Copy entire ornament
  if All then begin
    MainForm.BuffOrnament.Items  := Ornaments.ShownOrnament.Items;
    MainForm.BuffOrnament.Loop   := Ornaments.ShownOrnament.Loop;
    MainForm.BuffOrnament.Length := Ornaments.ShownOrnament.Length;
  end

  else

  // Copy selected part of ornament
  begin
    OrnLength := Ornaments.selEnd - Ornaments.selStart;
    for ff := 0 to OrnLength do
      MainForm.BuffOrnament.Items[ff] := Ornaments.ShownOrnament.items[ff + Ornaments.selStart];
    MainForm.BuffOrnament.Loop := 0;
    MainForm.BuffOrnament.Length := OrnLength + 1;
  end;

  MainForm.BuffOrnament.CopyAll := All;


  // Save ornament to copy/paste buffer file
  SyncBufferBlocked := True;
  AssignFile(TxtFile, SyncOrnamentBufferFile);
  Rewrite(TxtFile);
  try
    with MainForm.BuffOrnament do begin
      for i := 0 to Length-1 do
      begin
        if i = Loop then Write(TxtFile, 'L');
        Write(TxtFile, IntToStr(Items[i]));
        if i < Length-1 then Write(TxtFile, ',')
      end;
      if All then
        Writeln(TxtFile, #13#10'All');
    end;
  finally
    CloseFile(TxtFile);
  end;
  SyncOrnamentBufferFileAge := FileAge(SyncOrnamentBufferFile);
  SyncBufferBlocked := False;


  OrnamentSelectionOff;

end;


procedure TMDIChild.PastePatternToOrnament;
var
  i, Note, LastNote, TmpNote, BaseNote, Chan: ShortInt;

  TrackSpeed, j: SmallInt;
  TracksLine, OrnamentLine, SrcOrnamentLine: Integer;
  Finish: Boolean;
  ChannelLine: TChannelLine;
  Pattern:  PPattern;
  SrcOrnament: POrnament;
  SrcOrnamentNum: Byte;

  SrcWindow: TMDIChild;
  SrcVTMP: PModule;


begin
  if (LastClipboard <> LCTracks) then Exit;

  SrcWindow := TracksCopy.SrcWindow;
  SrcVTMP   := SrcWindow.VTMP;

  ValidateOrnament(OrnNum);
  SaveOrnamentUndo;

  Chan            := TracksCopy.Channel;
  LastNote        := -3;
  BaseNote        := VTMP.Patterns[-1].Items[0].Channel[0].Note;
  OrnamentLine    := Ornaments.CurrentLine;
  SrcOrnamentNum  := 0;
  SrcOrnamentLine := 0;
  TrackSpeed      := 0;
  Pattern         := TracksCopy.Pattern;
  Finish          := False;



  for TracksLine := TracksCopy.FromLine to TracksCopy.ToLine do begin

    ChannelLine := Pattern.Items[TracksLine].Channel[Chan];
    Note := ChannelLine.Note;

    if (LastNote = -3) or (Note >= 0) then
      LastNote := Note;

    if (LastNote = -3) and (Note < 0) then
      LastNote := BaseNote;


    // ---- ORNAMENT ---
    //
    // Remember last ornament
    if TracksCopy.Ornament and (ChannelLine.Ornament > 0) then begin
      SrcOrnamentNum  := ChannelLine.Ornament;
      SrcOrnament     := SrcVTMP.Ornaments[SrcOrnamentNum];
      SrcOrnamentLine := 0;
    end;

    // Search last ornament
    if TracksCopy.Ornament and (SrcOrnamentNum = 0) and (TracksLine > 0) then
      for j := TracksLine-1 downto 0 do
        if Pattern.Items[j].Channel[Chan].Ornament > 0 then begin
          SrcOrnamentNum  := Pattern.Items[j].Channel[Chan].Ornament;
          SrcOrnament     := SrcVTMP.Ornaments[SrcOrnamentNum];
          SrcOrnamentLine := 0;
        end;


    // ---- COMMAND: Ornament offset ---
    //
    if TracksCopy.Ornament and (ChannelLine.Additional_Command.Number = 4) then begin
      SrcOrnamentLine := ChannelLine.Additional_Command.Parameter;
      if SrcOrnamentLine >= SrcOrnament.Length then
        SrcOrnamentLine := SrcOrnament.Length - 1;
    end;


    // ---- SPEED ---
    //
    // Remember speed
    if ChannelLine.Additional_Command.Number = $b then
      TrackSpeed := ChannelLine.Additional_Command.Parameter;

    // Search last speed command
    if (TrackSpeed = 0) and (TracksLine > 0) then
      for j := TracksLine-1 downto 0 do
        if Pattern.Items[j].Channel[Chan].Additional_Command.Parameter = $b then
          TrackSpeed := Pattern.Items[j].Channel[Chan].Additional_Command.Parameter;

    // Track speed command not found
    if TrackSpeed = 0 then
      TrackSpeed := SrcWindow.SpeedBpmUpDown.Position;


    // Paste note 'TrackSpeed' times
    for i := 1 to TrackSpeed do begin

      TmpNote := LastNote;

      // Apply ornament
      if TracksCopy.Ornament and (SrcOrnamentNum <> 0) then
        Inc(TmpNote, SrcOrnament.Items[SrcOrnamentLine]);

      // Set ornament line note
      Ornaments.SetNote(TmpNote, OrnamentLine, False, False);

      if TracksCopy.Ornament and (SrcOrnamentNum <> 0) then begin
        Inc(SrcOrnamentLine);
        if SrcOrnamentLine = SrcOrnament.Length then
          SrcOrnamentLine := 0;
      end;


      Inc(OrnamentLine);
      if OrnamentLine = MaxOrnLen then begin
        MessageBox(Handle, 'Maximum ornament length reached', 'Application.Title', MB_OK + MB_ICONWARNING + MB_TOPMOST);
        Finish := True;
        Break;
      end;

    end;

    if Finish then Break;


  end;


  Ornaments.ShownOrnament.Length := OrnamentLine;
  OrnamentLenUpDown.Position := OrnamentLine;
  Ornaments.HideMyCaret;
  Ornaments.RedrawOrnaments(0);
  Ornaments.ShowMyCaret;

  SaveOrnamentRedo;
end;


procedure TMDIChild.pasteOrnamentFromBuffer;
var
  i, OrnCurLine, OrnLine: Integer;
begin

  if LastClipboard = LCTracks then begin
    PastePatternToOrnament;
    Exit;
  end;

  ValidateOrnament(OrnNum);
  SaveOrnamentUndo;

  OrnCurLine := Ornaments.CurrentLine;

  for i := 0 to MainForm.BuffOrnament.Length-1 do
  begin
    OrnLine := OrnCurLine + i;
    if OrnLine > 254 then Break;
    Ornaments.ShownOrnament.Items[OrnLine] := MainForm.BuffOrnament.Items[i];
    if OrnLine >= Ornaments.ShownOrnament.Length then
      Ornaments.ShownOrnament.Length := OrnLine + 1;
  end;

  if MainForm.BuffOrnament.CopyAll then
  begin
    Ornaments.ShownOrnament.Loop := MainForm.BuffOrnament.Loop + OrnCurLine;
    OrnamentLoopUpDown.Position  := MainForm.BuffOrnament.Loop + OrnCurLine;
  end
  else
  begin
    //OrnamentLoopUpDown.Position := Ornaments.ShownOrnament.Loop;
    OrnamentLenUpDown.Position  := Ornaments.ShownOrnament.Length;
  end;
  OrnamentSelectionOff;
  SaveOrnamentRedo;

  SongChanged := True;
  BackupSongChanged := True;
end;

procedure TMDIChild.OrnamentSelectionOff;
begin
  Ornaments.isSelecting := False;
  Ornaments.HideMyCaret;
  Ornaments.RedrawOrnaments(0);
  Ornaments.ShowMyCaret;
end;


procedure TMDIChild.GetOrnParams(var l, i, c: Integer);
begin
  with Ornaments do
  begin
    if ShownOrnament = nil then
      l := 1
    else
      l := ShownOrnament.Length;
    c := CursorY + (CursorX div OrnNChars) * Ornaments.NRaw;
    i := ShownFrom + c;
  end;
end;


procedure TMDIChild.IncreaseOrnamentValue(Line: Integer; Shift: TShiftState);
begin
  if Ornaments.ShownOrnament = nil then Exit;
  if Shift = []        then Inc(Ornaments.ShownOrnament.Items[Line]);
  if Shift = [ssShift] then Inc(Ornaments.ShownOrnament.Items[Line], 3);
  if Shift = [ssCtrl]  then Inc(Ornaments.ShownOrnament.Items[Line], 12);
  if Shift = [ssCtrl,ssShift]  then Inc(Ornaments.ShownOrnament.Items[Line], 5);

  if Ornaments.ShownOrnament.Items[Ornaments.CurrentLine] > 96 then
     Ornaments.ShownOrnament.Items[Ornaments.CurrentLine] := 96;

  SongChanged := True;
  BackupSongChanged := True;
end;


procedure TMDIChild.DecreaseOrnamentValue(Line: Integer; Shift: TShiftState);
begin
  if Ornaments.ShownOrnament = nil then Exit;
  if Shift = []        then Dec(Ornaments.ShownOrnament.Items[Line]);
  if Shift = [ssShift] then Dec(Ornaments.ShownOrnament.Items[Line], 3);
  if Shift = [ssCtrl]  then Dec(Ornaments.ShownOrnament.Items[Line], 12);
  if Shift = [ssCtrl,ssShift]  then Dec(Ornaments.ShownOrnament.Items[Line], 5);  

  if Ornaments.ShownOrnament.Items[Ornaments.CurrentLine] < -96 then
     Ornaments.ShownOrnament.Items[Ornaments.CurrentLine] := -96;

  SongChanged := True;
  BackupSongChanged := True;
end;


procedure TMDIChild.OrnamentsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
type
  TOrnToggles = (TgSgn, TgSgnP, TgSgnM);
var
  ff, ii, ll, cc: Integer;
  Incr, Decr: Boolean;

  procedure DoToggles(n: TOrnToggles);
  var
    c, i, l, o: Integer;
  begin
    with Ornaments do
    begin
      GetOrnParams(l, i, c);
      if i >= l then
        exit;
      SongChanged := True;
      BackupSongChanged := True;
      ValidateOrnament(OrnNum);
      o := ShownOrnament.Items[i];
      case n of
        TgSgn:
          ShownOrnament.Items[i] := -ShownOrnament.Items[i];
        TgSgnP:
          ShownOrnament.Items[i] := Abs(ShownOrnament.Items[i]);
        TgSgnM:
          ShownOrnament.Items[i] := -Abs(ShownOrnament.Items[i])
      end;
      AddUndo(CAChangeOrnamentValue, o, ShownOrnament.Items[i]);
      ChangeList[ChangeCount - 1].OldParams.prm.OrnamentCursor := c;
      ChangeList[ChangeCount - 1].OldParams.prm.OrnamentShownFrom := ShownFrom;
      HideMyCaret;
      RedrawOrnaments(0);
      ShowMyCaret;
    end
  end;

  procedure DoToggleSpace;
  begin
    DoToggles(TgSgn)
  end;

  procedure DoTogglePlus;
  begin
    DoToggles(TgSgnP)
  end;

  procedure DoToggleMinus;
  begin
    DoToggles(TgSgnM)
  end;

  procedure DoNumber;
  var
    c, i, l, o: Integer;
  begin
    with Ornaments do
    begin
      GetOrnParams(l, i, c);
    // you can edit everywhere
     { if i >= l then
        exit;}
      SongChanged := True;
      BackupSongChanged := True;
      ValidateOrnament(OrnNum);
      with ShownOrnament^ do
      begin
        o := Items[i];
        if Items[i] < 0 then
          Items[i] := -InputONumber
        else
          Items[i] := InputONumber;
        AddUndo(CAChangeOrnamentValue, o, Items[i]);
        ChangeList[ChangeCount - 1].OldParams.prm.OrnamentCursor := c;
        ChangeList[ChangeCount - 1].OldParams.prm.OrnamentShownFrom := ShownFrom;
      end;
      HideMyCaret;
      RedrawOrnaments(0);
      ShowMyCaret;
    end
  end;

  procedure DoDigit(n: Integer);
  var
    nm: Integer;
  begin
    nm := Ornaments.InputONumber * 10 + n;
    if nm > 96 then
      nm := n;
    Ornaments.InputONumber := nm;
    DoNumber;
  end;


begin

  Incr := (Key = VK_ADD) or (Key = 187);
  Decr := (Key = VK_SUBTRACT) or (Key = 189);

  // Increase/Decrease
  if Incr or Decr then begin

    // Increase/Decrease selected values
    if Ornaments.isSelecting then begin

      for ii := Ornaments.selStart to Ornaments.selEnd do
        if Incr then
          IncreaseOrnamentValue(ii, Shift)
        else
          DecreaseOrnamentValue(ii, Shift);
          
    end

    // Increase/Decrease current line only
    else begin
      if Incr then IncreaseOrnamentValue(Ornaments.CurrentLine, Shift);
      if Decr then DecreaseOrnamentValue(Ornaments.CurrentLine, Shift);
    end;

    Ornaments.HideMyCaret;
    Ornaments.RedrawOrnaments(0);
    Ornaments.ShowMyCaret;

    Exit;
  end;

  
  if (Shift <> []) or not (Key in [Ord('0')..Ord('9')]) then
    Ornaments.InputONumber := 0;

  // Alt+1..8 - change octave
  if (Shift = [ssAlt]) and (Key >= 49) and (Key <= 56) then
  begin
    OrnOctaveNum.Position := Key - 48;
    OrnamentTestLine.TestOct := OrnOctaveNum.Position;
    Exit;
  end;

  // Numpad 1-8 - change octave
  if (Key in [VK_NUMPAD1..VK_NUMPAD8]) then begin
    OrnOctaveNum.Position := Key - VK_NUMPAD0;
    Exit;
  end;

  // Set note in tone shift position
  if Ornaments.ToneShiftAsNote and (NoteKeys[Key] <> -3) and (Shift <> [ssCtrl]) then begin
    if Key >= 256 then Exit;
    if Ornaments.KeyPressed <> Key then begin
      Ornaments.SetNote(NoteKeys[Key], Ornaments.CurrentLine, True, True);

      // Hack: Temporary replacement of sample testline
      Ornaments.SavedSampleTestLine := VTMP.Patterns[-1].Items[1].Channel[0];
      VTMP.Patterns[-1].Items[1].Channel[0] := VTMP.Patterns[-1].Items[0].Channel[0];
      VTMP.Patterns[-1].Items[1].Channel[0].Ornament := 0;
      VTMP.Patterns[-1].Items[1].Channel[0].Note :=
        VTMP.Patterns[-1].Items[0].Channel[0].Note + Ornaments.ShownOrnament.Items[Ornaments.CurrentLine];

      Samples.isLineTesting := True;
      SampleTestLine.PlayCurrentNote;
      Ornaments.KeyPressed := Key;
    end;
    Exit;
  end;

  if Shift = [] then
    case Key of
      VK_NEXT:
        begin
          Ornaments.CursorY := Ornaments.NRaw - 1;
          Ornaments.SetCaretPosition;
        end;
      VK_PRIOR:
        begin
          Ornaments.CursorY := 0;
          Ornaments.SetCaretPosition;
        end;
      VK_HOME:
        if Ornaments.CursorX <> 0 then
        begin
          Ornaments.CursorX := 0;
          Ornaments.SetCaretPosition;
        end;
      VK_END:
        if Ornaments.CursorX <> (OrnNCol - 1) * OrnNChars then
        begin
          Ornaments.CursorX := (OrnNCol - 1) * OrnNChars;
          Ornaments.SetCaretPosition;
        end;
      VK_DOWN:
        begin
          OrnamentSelectionOff;
          if Ornaments.CursorY < Ornaments.NRaw - 1 then
          begin
            Inc(Ornaments.CursorY);
            Ornaments.SetCaretPosition;
          end
          else if Ornaments.CursorX < (OrnNCol - 1) * OrnNChars then
          begin
            Ornaments.CursorY := 0;
            Inc(Ornaments.CursorX, OrnNChars);
            Ornaments.SetCaretPosition;
          end
          else if Ornaments.ShownFrom < MaxOrnLen - Ornaments.NOfLines then
          begin
            Inc(Ornaments.ShownFrom);
            Ornaments.HideMyCaret;
            Ornaments.RedrawOrnaments(0);
            Ornaments.ShowMyCaret;
          end;
        end;
      VK_UP:
        begin
          OrnamentSelectionOff;
          if Ornaments.CursorY > 0 then
          begin
            Dec(Ornaments.CursorY);
            Ornaments.SetCaretPosition;
          end
          else if Ornaments.CursorX > 0 then
          begin
            Ornaments.CursorY := Ornaments.NRaw - 1;
            Dec(Ornaments.CursorX, OrnNChars);
            Ornaments.SetCaretPosition;
          end
          else if Ornaments.ShownFrom > 0 then
          begin
            Dec(Ornaments.ShownFrom);
            Ornaments.HideMyCaret;
            Ornaments.RedrawOrnaments(0);
            Ornaments.ShowMyCaret;
          end;
        end;
      VK_LEFT:
        if Ornaments.CursorX > 0 then
        begin
          OrnamentSelectionOff;
          Dec(Ornaments.CursorX, OrnNChars);
          Ornaments.SetCaretPosition;
        end
        else if Ornaments.ShownFrom > 0 then
        begin
          OrnamentSelectionOff;
          Dec(Ornaments.ShownFrom, Ornaments.NRaw);
          if Ornaments.ShownFrom < 0 then
            Ornaments.ShownFrom := 0;
          Ornaments.HideMyCaret;
          Ornaments.RedrawOrnaments(0);
          Ornaments.ShowMyCaret;
        end;
      VK_RIGHT:
        if Ornaments.CursorX < (OrnNCol - 1) * OrnNChars then
        begin
          OrnamentSelectionOff;
          Inc(Ornaments.CursorX, OrnNChars);
          Ornaments.SetCaretPosition;
        end
        else if Ornaments.ShownFrom < MaxOrnLen - Ornaments.NOfLines then
        begin
          OrnamentSelectionOff;
          Inc(Ornaments.ShownFrom, Ornaments.NRaw);
          if Ornaments.ShownFrom > MaxOrnLen - Ornaments.NOfLines then
            Ornaments.ShownFrom := MaxOrnLen - Ornaments.NOfLines;
          Ornaments.HideMyCaret;
          Ornaments.RedrawOrnaments(0);
          Ornaments.ShowMyCaret;
        end;
      Ord(' '):
        DoToggleSpace;
      $BB, VK_ADD:
        DoTogglePlus;
      $BD, VK_SUBTRACT:
        DoToggleMinus;
      Ord('0')..Ord('9'):
        DoDigit(Key - Ord('0'));
      192:
        if OrnamentTestLine.CanFocus then
          OrnamentTestLine.SetFocus;
      VK_DELETE:
        if (ssCtrl in Shift) and (ssShift in Shift) then
        begin
        end
        else if (ssShift in Shift) then
        begin
        end
        else if (ssCtrl in Shift) then
        begin
        //next position
        end
        else
        begin

          // If ornament selected, delete selection
          if Ornaments.isSelecting then begin
            Ornaments.ClearSelection;
            Exit;
          end;

          //delete ornament position.
          ValidateOrnament(OrnNum);
          GetOrnParams(ll, ii, cc);

          if (Ornaments.ShownOrnament.Length > 0) and (ii < (ll - 1)) then
          begin
            Ornaments.ShownOrnament.Length := Ornaments.ShownOrnament.Length - 1;
            if Ornaments.ShownOrnament.Loop > ii then
              Ornaments.ShownOrnament.Loop := Ornaments.ShownOrnament.Loop - 1;
          end;

          for ff := ii to 62 do
          begin
            Ornaments.ShownOrnament.Items[ff] := Ornaments.ShownOrnament.Items[ff + 1];
          end;
          Ornaments.ShownOrnament.Items[254] := 0;

          OrnamentLenUpDown.Position  := Ornaments.ShownOrnament.Length;
          OrnamentLoopUpDown.Position := Ornaments.ShownOrnament.Loop;

          Ornaments.HideMyCaret;
          Ornaments.RedrawOrnaments(0);
          Ornaments.ShowMyCaret;
        end;
      VK_INSERT:
        if (ssCtrl in Shift) and (ssShift in Shift) then
        begin
        end
        else if (ssShift in Shift) then
        begin
        end
        else if (ssCtrl in Shift) then
        begin
        //next position
        end
        else
        begin
          ValidateOrnament(OrnNum);
          GetOrnParams(ll, ii, cc);

          if (ll < 255) and (ii <= (ll)) then
          begin
            Ornaments.ShownOrnament.Length := Ornaments.ShownOrnament.Length + 1;
            if Ornaments.ShownOrnament.Loop >= ii then
              Ornaments.ShownOrnament.Loop := Ornaments.ShownOrnament.Loop + 1;
          end;

          for ff := 253 downto ii do
          begin
            Ornaments.ShownOrnament.Items[ff + 1] := Ornaments.ShownOrnament.Items[ff];
          end;
          OrnamentLenUpDown.Position  := Ornaments.ShownOrnament.Length;
          OrnamentLoopUpDown.Position := Ornaments.ShownOrnament.Loop;

          Ornaments.HideMyCaret;
          Ornaments.RedrawOrnaments(0);
          Ornaments.ShowMyCaret;

        end;
    else
      begin
        if (Key >= 256) or (Key = 16) or (Key = 17) then Exit;
        
        ValidateOrnament(OrnNum);
        GetOrnParams(ll, ii, cc);

        if NoteKeys[Key] >= 0 then
        begin
          Ornaments.ShownOrnament.Items[ii] := NoteKeys[Key];
          Ornaments.HideMyCaret;
          Ornaments.RedrawOrnaments(0);
          Ornaments.ShowMyCaret;

        end;
      end;
    end
  else if Shift = [ssCtrl] then
    case Key of
      VK_NEXT, VK_END:
        begin
          OrnamentSelectionOff;
          Ornaments.CursorY := Ornaments.NRaw - 1;
          Ornaments.CursorX := (OrnNCol - 1) * OrnNChars;
          Ornaments.SetCaretPosition;
          Ornaments.ShownFrom := MaxOrnLen - Ornaments.NOfLines;
          Ornaments.HideMyCaret;
          Ornaments.RedrawOrnaments(0);
          Ornaments.ShowMyCaret;
        end;
      VK_PRIOR, VK_HOME:
        begin
          OrnamentSelectionOff;
          Ornaments.CursorY := 0;
          Ornaments.CursorX := 0;
          Ornaments.SetCaretPosition;
          Ornaments.ShownFrom := 0;
          Ornaments.HideMyCaret;
          Ornaments.RedrawOrnaments(0);
          Ornaments.ShowMyCaret;
        end;
      VK_ADD:
        begin
        //next ornament
          if StrToInt(OrnamentNumEdit.Text) in [1..14] then
          begin
            ChangeOrnament(StrToInt(OrnamentNumEdit.Text) + 1);
            OrnamentNumEdit.Text := IntToStr((StrToInt(OrnamentNumEdit.Text) + 1));
          end;
        end;
      VK_SUBTRACT:
        begin
        //previous sample
          if StrToInt(OrnamentNumEdit.Text) in [2..15] then
          begin
            ChangeSample(StrToInt(OrnamentNumEdit.Text) - 1, True);
            OrnamentNumEdit.Text := IntToStr((StrToInt(OrnamentNumEdit.Text) - 1));
          end;
        end;
{      VK_INSERT:
        begin
          ValidateOrnament(OrnNum);
          GetOrnParams(ll,ii,cc);

          if ii > ll-1 then
          begin
          for ff:= Ornaments.ShownOrnament.loop to ll do
          begin
            if ii + ff - Ornaments.ShownOrnament.loop <=254 then
            Ornaments.ShownOrnament.Items[ii+ff - Ornaments.ShownOrnament.loop ]:= Ornaments.ShownOrnament.Items[ff];
          end;

          end
          else
          begin

          end;
            Edit13.Text:= IntToStr(Ornaments.ShownOrnament.Length);
            Edit12.Text:= IntToStr(Ornaments.ShownOrnament.Loop);

            Ornaments.HideMyCaret;
            Ornaments.RedrawOrnaments(0);
            Ornaments.ShowMyCaret;
        end;}
      VK_INSERT:
          copyOrnamentToBuffer(False);

      // CTRL+A
      Ord('A'):
        begin
          ValidateOrnament(OrnNum);
          GetOrnParams(ll, ii, cc);

          if not Ornaments.isSelecting then begin
            Ornaments.selEnd := 255;
            Ornaments.selStart := 0;
            Ornaments.isSelecting := True;
          end
          else
            Ornaments.isSelecting := False;

          Ornaments.HideMyCaret;
          Ornaments.RedrawOrnaments(0);
          Ornaments.ShowMyCaret;
        end;

    end
  else if Shift = [ssShift] then
    case Key of
      $BB:
        DoTogglePlus;
      VK_HOME:
        begin
          ValidateOrnament(OrnNum);
          GetOrnParams(ll, ii, cc);

          if (Ornaments.ShownOrnament.Length > 0) and (ii < ll) then
          begin
            Ornaments.ShownOrnament.Loop := ii;
          end;
          OrnamentLenUpDown.Position  := Ornaments.ShownOrnament.Length;
          OrnamentLoopUpDown.Position := Ornaments.ShownOrnament.Loop;

          Ornaments.HideMyCaret;
          Ornaments.RedrawOrnaments(0);
          Ornaments.ShowMyCaret;
        end;
      VK_END:
        begin
          ValidateOrnament(OrnNum);
          GetOrnParams(ll, ii, cc);

          Ornaments.ShownOrnament.Length := ii + 1;
          if Ornaments.ShownOrnament.Loop > Ornaments.ShownOrnament.Length then
            Ornaments.ShownOrnament.Loop := ii;

          OrnamentLenUpDown.Position  := Ornaments.ShownOrnament.Length;
          OrnamentLoopUpDown.Position := Ornaments.ShownOrnament.Loop;

          Ornaments.HideMyCaret;
          Ornaments.RedrawOrnaments(0);
          Ornaments.ShowMyCaret;
        end;

      VK_INSERT:
        pasteOrnamentFromBuffer;

      VK_DOWN:
        begin
          if Ornaments.isSelecting = False then
          begin
            GetOrnParams(ll, ii, cc);
            Ornaments.selStart := ii;
            Ornaments.selEnd := ii;
            Ornaments.isSelecting := True
          end;


          if Ornaments.CursorY < Ornaments.NRaw - 1 then
          begin
            Inc(Ornaments.CursorY);
            Ornaments.SetCaretPosition;
          end
          else if Ornaments.CursorX < (OrnNCol - 1) * OrnNChars then
          begin
            Ornaments.CursorY := 0;
            Inc(Ornaments.CursorX, OrnNChars);
            Ornaments.SetCaretPosition;
          end
          else if Ornaments.ShownFrom < MaxOrnLen - Ornaments.NOfLines then
            Inc(Ornaments.ShownFrom);


          if Ornaments.isSelecting = True then
          begin
            GetOrnParams(ll, ii, cc);
            Ornaments.selEnd := ii;
          end;

          if Ornaments.selEnd < Ornaments.selStart then
          begin
            ii := Ornaments.selEnd;
            Ornaments.selEnd := Ornaments.selStart;
            Ornaments.selStart := ii;
          end;

          Ornaments.HideMyCaret;
          Ornaments.RedrawOrnaments(0);
          Ornaments.ShowMyCaret;

        end;
      VK_UP:
        begin
          if Ornaments.isSelecting = False then
          begin
            GetOrnParams(ll, ii, cc);
            Ornaments.selStart := ii;
            Ornaments.selEnd := ii;
            Ornaments.isSelecting := True
          end;

          if Ornaments.CursorY > 0 then
          begin
            Dec(Ornaments.CursorY);
            Ornaments.SetCaretPosition;
          end
          else if Ornaments.CursorX > 0 then
          begin
            Ornaments.CursorY := Ornaments.NRaw - 1;
            Dec(Ornaments.CursorX, OrnNChars);
            Ornaments.SetCaretPosition;
          end
          else if Ornaments.ShownFrom > 0 then
            Dec(Ornaments.ShownFrom);


          if Ornaments.isSelecting = True then
          begin
            GetOrnParams(ll, ii, cc);
            Ornaments.selStart := ii;
          end;

          if Ornaments.selEnd < Ornaments.selStart then
          begin
            ii := Ornaments.selEnd;
            Ornaments.selEnd := Ornaments.selStart;
            Ornaments.selStart := ii;
          end;

          Ornaments.HideMyCaret;
          Ornaments.RedrawOrnaments(0);
          Ornaments.ShowMyCaret;

        end;

    else
      begin
        if (Key = 16) or (Key = 17) then Exit;
        
        Ornaments.isLineTesting := True;
        OrnamentTestLine.CursorX := 8;
        if (Key <> VK_LEFT) and (Key <> VK_RIGHT) then
        begin
          OrnamentTestLine.TestLineKeyDown(Sender, Key, []);
        end;
      end;
    end
  else if Shift = [ssShift, ssCtrl] then
  begin
    if (Key >= 256) or (Key = 16) or (Key = 17) then Exit;
      
    ValidateOrnament(OrnNum);
    GetOrnParams(ll, ii, cc);

    if (NoteKeys[Key] + 12 >= 0) and (NoteKeys[Key] + 12 <= 96) then
    begin
      Ornaments.ShownOrnament.Items[ii] := NoteKeys[Key] + 12;
      Ornaments.HideMyCaret;
      Ornaments.RedrawOrnaments(0);
      Ornaments.ShowMyCaret;

    end;
  end;
end;

procedure TMDIChild.TracksMoveCursorMouse(X, Y: Integer; Sel, Mv, ButRight: Boolean);
var
  x1, y1, i, PLen: Integer;
  SX1, SX2, SY1, SY2: Integer;
  
begin
  if Mv and not Tracks.Clicked then
    exit;
  SX2 := Tracks.CursorX;
  SX1 := Tracks.SelX;
  if SX1 > SX2 then
  begin
    SX1 := SX2;
    SX2 := Tracks.SelX;
  end;
  SY1 := Tracks.SelY;
  SY2 := Tracks.CurrentPatLine;
  if SY1 > SY2 then
  begin
    SY1 := SY2;
    SY2 := Tracks.SelY
  end;


  x1 := X div Tracks.CelW - TracksCursorXLeft;
  y1 := Y div Tracks.CelH;

  // X out of border
  if x1 > Tracks.PatNumChars - 1 - TracksCursorXLeft then Exit;

  if Y < 0 then
    dec(y1);
  i := Tracks.N1OfLines - Tracks.ShownFrom;
  if Tracks.ShownPattern = nil then
    PLen := DefPatLen
  else
    PLen := Tracks.ShownPattern.Length;
    
  if Mv then
  begin
    if y1 < i then
      y1 := i
    else if y1 >= i + PLen then
      y1 := i + PLen - 1;
    if x1 < 0 then
      x1 := 0
    else if x1 > 48 then
      x1 := 48;
  end
  else
    Tracks.Clicked := (y1 >= i) and (y1 < i + PLen) and (x1 >= 0) and not ColSpace(x1);


  if      x1 in [9..10]  then x1 := 8
  else if x1 in [23..24] then x1 := 22
  else if x1 in [37..38] then x1 := 36;

  // Click on a previous pattern
  if MoveBetweenPatrns and (y1 < i) and (x1 >= 0) and not ColSpace(x1) and (PositionNumber - 1 >= 0) then begin

    Dec(PositionNumber);

    Tracks.RedrawDisabled := True;
    IsSinchronizing       := True;
    SelectPosition2(PositionNumber);
    IsSinchronizing       := False;
    Tracks.RedrawDisabled := False;

    if Tracks.ShownPattern = nil then
      PLen := DefPatLen
    else
      PLen := Tracks.ShownPattern.Length;

    Tracks.ShownFrom := PLen - (i - y1);
    if Tracks.ShownFrom < 0 then
      Tracks.ShownFrom := 0;
    Tracks.CursorY   := Tracks.N1OfLines;
    Tracks.CursorX   := x1;
    Tracks.RemoveSelection;

  end

  // Click on a next pattern
  else if MoveBetweenPatrns and (y1 >= i + PLen) and (x1 >= 0) and not ColSpace(x1) and (PositionNumber + 1 < VTMP.Positions.Length) then begin

    Inc(PositionNumber);

    Tracks.RedrawDisabled := True;
    IsSinchronizing       := True;
    SelectPosition2(PositionNumber);
    IsSinchronizing       := False;
    Tracks.RedrawDisabled := False;

    Tracks.ShownFrom := y1 - (i + PLen);

    if Tracks.ShownPattern = nil then
      PLen := DefPatLen
    else
      PLen := Tracks.ShownPattern.Length;

    if Tracks.ShownFrom > PLen then
      Tracks.ShownFrom := PLen-1;
      
    Tracks.CursorY   := Tracks.N1OfLines;
    Tracks.CursorX   := x1;
    Tracks.RemoveSelection;

  end

  // Click inside current pattern
  else if (y1 >= i) and (y1 < i + PLen) and (x1 >= 0) then
  begin

    if ButRight and (x1 >= SX1) and (x1 <= SX2) and (y1 >= SY1 + i) and (y1 <= SY2 + i) then
    begin
      if not Mv then
        Tracks.Clicked := False;
      exit;
    end;

    if ColSpace(x1) and Tracks.IsSelected then
      if x1 < SX1 then
        Inc(x1)
      else
        Dec(x1);

    if ColSpace(x1) and not Tracks.IsSelected then
      Dec(x1);
               
    if      x1 in [9..10]  then x1 := 8
    else if x1 in [23..24] then x1 := 22
    else if x1 in [37..38] then x1 := 36;

    if (Tracks.CursorX <> x1) or (Tracks.CursorY <> y1) then
    begin

      if Tracks.Focused then
        Tracks.HideMyCaret;
      Tracks.CursorX := x1;
      Tracks.CursorY := y1;

      if Tracks.CursorY >= Tracks.NOfLines then
      begin
        Inc(Tracks.ShownFrom, Tracks.CursorY - Tracks.NOfLines + 1);
        Tracks.CursorY := Tracks.NOfLines - 1;
      end
      else if Tracks.CursorY < 0 then
      begin
        Inc(Tracks.ShownFrom, Tracks.CursorY);
        Tracks.CursorY := 0;
      end
    end;

    if Sel then
      Tracks.ShowSelection
    else
      Tracks.RemoveSelection;

  end;


  if Tracks.Focused then
  begin
    Tracks.HideMyCaret;
    Tracks.CreateMyCaret;
    Tracks.SetCaretPosition;
    Tracks.RedrawTracks(0);
    Tracks.ShowMyCaret;
  end;

  ShowStat;
end;

procedure TMDIChild.TracksMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not Tracks.Focused then
    Windows.SetFocus(Tracks.Handle);

  if (PlayStopState <> BStop) or not (PlayMode in [PMPlayPattern, PMPlayModule]) then
    TracksMoveCursorMouse(X, Y, GetKeyState(VK_SHIFT) and 128 <> 0, False, Shift = [ssRight]);

  if (ssCtrl in Shift) and not DisableCtrlClick then
    OpenSampleOrnament;
end;


procedure TTestLine.OpenSample;
var Sample: byte;
begin
  with TMDIChild(ParWind) do
  begin

    // Get sample num
    Sample := VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Sample;

    // Copy all tesline params
    if not TestSample then
      VTMP.Patterns[-1].Items[1] := VTMP.Patterns[-1].Items[0];

    // Select sample
    SampleNumUpDown.Position := Sample;

    // Activate samples tab
    PageControl1.ActivePageIndex := 1;

    // Set focus
    if SampleTestLine.Enabled and SampleTestLine.CanFocus then
    begin
      SampleTestLine.CursorX := 8;
      SampleTestLine.SetFocus;
    end;

    HideCaret(SampleTestLine.Handle);
    SampleTestLine.CreateMyCaret;
    SampleTestLine.SetCaretPosition;
    ShowCaret(SampleTestLine.Handle);


  end;
end;


procedure TTestLine.OpenOrnament;
var Ornament: byte;
begin
  with TMDIChild(ParWind) do
  begin
    // Get ornament num
    Ornament := VTMP.Patterns[-1].Items[Ord(TestSample)].Channel[0].Ornament;

    // Copy all tesline params
    if TestSample then
      VTMP.Patterns[-1].Items[0] := VTMP.Patterns[-1].Items[1];

    // Select ornament
    OrnamentNumUpDown.Position := Ornament;

    // Activate ornaments tab
    PageControl1.ActivePageIndex := 2;

    // Set focus
    if OrnamentTestLine.Enabled and OrnamentTestLine.CanFocus then
    begin
      OrnamentTestLine.CursorX := 8;
      OrnamentTestLine.SetFocus;
    end;

    HideCaret(OrnamentTestLine.Handle);
    OrnamentTestLine.CreateMyCaret;
    OrnamentTestLine.SetCaretPosition;
    ShowCaret(OrnamentTestLine.Handle);
    
  end;
end;


procedure TTestLine.TestLineMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  x1: Integer;
begin
  x1 := X div CelW;

  // Ctrl+Click on sample position -> open sample
  if (x1 = 12) and  (ssCtrl in Shift) then
  begin
    OpenSample;
    Exit;
  end;

  // Ctrl+Click on ornament position -> open ornament
  if (x1 = 14) and (ssCtrl in Shift) then
  begin
    OpenOrnament;
    Exit;
  end;


  if x1 in [9..10] then
    x1 := 8;
  if not ColSpace(x1) then
    CursorX := x1;
  if Focused then
  begin
    HideCaret(Handle);
    RecreateCaret;
    SetCaretPosition;
    RedrawTestLine(0);
    ShowCaret(Handle);
  end
  else
    Windows.SetFocus(Handle)
end;

function TMDIChild.SamplesVolMouse(x, y: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  Dec(x, 21);
  if (x < 0) or (x > 15) then Exit;

  with Samples do
  begin
    i := ShownFrom + y;

    if ShownSample.Items[i].Amplitude <> x then
    begin
      SongChanged := True;
      BackupSongChanged := True;
      Result := True;
      ValidateSample2(SamNum);
      ShownSample.Items[i].Amplitude := x;
    end;

  end
end;


procedure TMDIChild.DrawOnSample(CurX, CurY, LineNum: Integer; Everywere: Boolean);
var
  SampleChanged: Boolean;
  BackupSample: TSample;
  
begin

  if (SamplesLastCursorX = CurX) and (SamplesLastCursorY = CurY) then Exit;

  // Make sample backup
  if not Samples.UndoSaved then
  begin
    BackupSample.Items   := Samples.ShownSample.Items;
    BackupSample.Length  := Samples.ShownSample.Length;
    BackupSample.Loop    := Samples.ShownSample.Loop;
    BackupSample.Enabled := Samples.ShownSample.Enabled;
  end;

  SampleChanged := SamplesVolMouse(CurX, CurY);
  {if (CurY <> SamplesLastCursorY) and (CurX > 20) then
  begin
    if Samples.ShownSample.Items[LineNum].Amplitude <> 0 then
      Samples.ShownSample.Items[LineNum].Mixer_Ton := True
    else
      Samples.ShownSample.Items[LineNum].Mixer_Ton := False;
    SampleChanged := True;
  end; }

  SamplesLastCursorX := CurX;
  SamplesLastCursorY := CurY;

  // Prevent to change tone sign in the Tone Shift as Note mode.
  if SamToneShiftAsNote and (CurX = 4) then Exit;


  if not Everywere and (CurX in [8, 17, 20]) then
  begin
    if SampleChanged then
    begin
      if not Samples.UndoSaved then
        SaveSampleUndo(@BackupSample);
      Samples.HideMyCaret;
      Samples.RedrawSamples(0);
      Samples.ShowMyCaret;
    end
    else
      Exit;
  end;

    
  {if (LineNum >= Samples.ShownSample.Length) and ((CurX in [0,1,2,8,17,20]) or (CurX > 20)) then
  begin
    Samples.ShownSample.Length := LineNum + 1;
    Edit9.Text := IntToStr(Samples.ShownSample.Length);
    Edit10.Text := IntToStr(Samples.ShownSample.Loop);
    SampleChanged := True;
  end; }

  with Samples.ShownSample.Items[LineNum] do
    if DrawOnlyT then
    begin
      Mixer_Ton := TNEValue;
      SampleChanged := True;
    end

    else if DrawOnlyN then
    begin
      Mixer_Noise := TNEValue;
      SampleChanged := True;
    end

    else if DrawOnlyE then
    begin
      Envelope_Enabled := TNEValue;
      SampleChanged := True;
    end

    else if DrawOnlyToneSign then
    begin
      if (PositiveSign and (Add_to_Ton < 0)) or (not PositiveSign and (Add_to_Ton > 0)) then
        Add_to_Ton := -Add_to_Ton;
      SampleChanged := True;
    end

    else if DrawOnlyNoiseSign then
    begin
      if (PositiveSign and (Add_to_Envelope_or_Noise < 0)) or (not PositiveSign and (Add_to_Envelope_or_Noise > 0)) then
        Add_to_Envelope_or_Noise := -Add_to_Envelope_or_Noise;
      SampleChanged := True;
    end

    else
      case CurX of
        0: begin
             Mixer_Ton := not Mixer_Ton;
             SampleChanged := True;
           end;
        1: begin
             Mixer_Noise := not Mixer_Noise;
             SampleChanged := True;
           end;
        2: begin
             Envelope_Enabled := not Envelope_Enabled;
             SampleChanged := True;
           end;
        4: begin
             Add_to_Ton := -Add_to_Ton;
             SampleChanged := True;
           end;
        8: begin
             Ton_Accumulation := not Ton_Accumulation;
             SampleChanged := True;
           end;
        10: begin
              Add_to_Envelope_or_Noise := Ns(-Add_to_Envelope_or_Noise);
              SampleChanged := True;
            end;
        17: begin
              Envelope_or_Noise_Accumulation := not Envelope_or_Noise_Accumulation;
              SampleChanged := True;
            end;
        20: begin
              SampleChanged := True;
              if not Amplitude_Sliding then
              begin
                Amplitude_Sliding := True;
                Amplitude_Slide_Up := False
              end
              else if not Amplitude_Slide_Up then
                Amplitude_Slide_Up := True
              else
                Amplitude_Sliding := False;
            end;
      end;

  if SampleChanged then
  begin
    if not Samples.UndoSaved then
      SaveSampleUndo(@BackupSample);
    Samples.HideMyCaret;
    Samples.RedrawSamples(0);
    Samples.ShowMyCaret;
  end;

end;


function TMDIChild.DetectSampleColumn(X: Integer): Byte;
begin
  Result := 0;
  if X = 0 then Result := 1;
  if X = 1 then Result := 2;
  if X = 2 then Result := 3;
  if (X >= 4)  and (X <= 8)  then Result := 4;
  if (X >= 10) and (X <= 17) then Result := 5;
  if (X >= 19) and (X <= 36) then Result := 6;
end;


procedure TMDIChild.SamplesMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, x1, y1, LineNum: Integer;

begin

  if Shift <> [] then
  begin
    Application.HideHint;
    ShowHintTimer.Enabled := False;
    ShowHintTimer.Interval := 9000;
  end;

  Samples.InputSNumber := 0;
  ValidateSample2(SamNum);

  x1 := X div Samples.CelW - 3;
  y1 := Y div Samples.CelH;
  LineNum := Samples.ShownFrom + y1;

  // Check limits, because mouse pointer can be out of the TSamples box
  if LineNum > MaxSamLen - 1 then LineNum := MaxSamLen - 1;
  if LineNum < 0             then LineNum := 0;

  // Calculate cursor position on samples sheet
  if (y1 >= 0) and (y1 < Samples.NOfLines) and (x1 >= 0) and not (x1 in [3, 9, 18, 21..36]) then
  begin
    if x1 in [6..7] then
      x1 := 5
    else if x1 = 12 then
      x1 := 11
    else if x1 in [13, 16] then
      x1 := 14
    else if x1 = 15 then
      x1 := 14;
    Samples.CursorX := x1;
    Samples.CursorY := y1;
    Samples.DoHint(x1, y1);
  end;

  // Select lines
  if (Shift = [ssShift,ssLeft]) and not Samples.isSelecting then
  begin
    Samples.selStart := LineNum;
    Samples.selEnd   := LineNum;
    SamplesClickStartLine    := LineNum;
    SamplesLeftMouseButton   := True;
    SamplesLastMouseCursorY := Y;
  end;


  // Select columns
  if (Shift = [ssCtrl,ssLeft]) and not Samples.isSelecting then
  begin
    SampleCopy.FromLine := LineNum;
    SampleCopy.ToLine   := LineNum;

    i := DetectSampleColumn(x1);
    if i = 0 then Exit;
    SampleCopy.FromColumn := i;
    SampleCopy.ToColumn := SampleCopy.FromColumn;
    SampleCopy.StartColumn := SampleCopy.ToColumn;

    SamplesClickStartLine    := LineNum;
    SamplesLeftMouseButton   := True;
    SamplesLastMouseCursorY := Y;
  end;


  // Start to set loop position
  if (Shift = [ssRight]) and (not SamplesRightMouseButton) then
  begin
    SamplesClickStartLine   := LineNum;
    SamplesClickEndLine     := LineNum;
    SamplesLastMouseCursorY := Y;
    SamplesRightMouseButton := True;
  end;


  // Left click -> Change sample params
  if (Shift = [ssLeft]) and not Samples.isSelecting then
  begin
    SamplesLastCursorY:= y1;
    DrawOnSample(x1, y1, LineNum, True);

    if x1 = 0 then
    begin
      TNEValue := Samples.ShownSample.Items[LineNum].Mixer_Ton;
      DrawOnlyT := True;
    end
    else if x1 = 1 then
    begin
      TNEValue := Samples.ShownSample.Items[LineNum].Mixer_Noise;
      DrawOnlyN := True;
    end
    else if x1 = 2 then
    begin
      TNEValue := Samples.ShownSample.Items[LineNum].Envelope_Enabled;
      DrawOnlyE := True;
    end
    else if x1 = 4 then
    begin
      PositiveSign := Samples.ShownSample.Items[LineNum].Add_to_Ton >= 0;
      DrawOnlyToneSign := True;
    end
    else if x1 = 10 then
    begin
      PositiveSign := Samples.ShownSample.Items[LineNum].Add_to_Envelope_or_Noise >= 0;
      DrawOnlyNoiseSign := True;
    end;

    Samples.RecreateCaret;
    Samples.SetCaretPosition;
  end;


  // Deselecting
  if Samples.isSelecting or Samples.isColSelecting then
    SamplesSelectionOff;

  // Set focus
  if not Samples.Focused then
    Windows.SetFocus(Samples.Handle);

end;

procedure TMDIChild.SamplesMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Release mouse events capture
  ReleaseCapture;

  SamplesRightMouseButton   := False;
  SamplesLeftMouseButton    := False;
  Samples.SamplesDontScroll := False;
  SamplesLastCursorX := -1;
  SamplesLastCursorY := -1;
  DrawOnlyT := False;
  DrawOnlyN := False;
  DrawOnlyE := False;
  DrawOnlyNoiseSign := False;
  DrawOnlyToneSign  := False;
  
  SaveSampleRedo;

end;


procedure TMDIChild.TracksMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if ((ssLeft in Shift) or (ssRight in Shift)) and Tracks.Focused then
    TracksMoveCursorMouse(X, Y, True, True, False);
end;

procedure TMDIChild.SamplesMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
const
  MouseShift = 8;
var
  i, x1, y1, LineNum: Integer;
  Accept: Boolean;
  ButtonPressed: Boolean;
begin
  ValidateSample2(SamNum);

  // Calculate cursor position on the TSamples sheet, and current line
  x1 := X div Samples.CelW - 3;
  y1 := Y div Samples.CelH;
  LineNum := y1 + Samples.ShownFrom;
  ButtonPressed := (ssLeft in Shift) or (ssRight in Shift);

  // Check limits, because mouse pointer can be out of the TSamples box
  if LineNum > MaxSamLen - 1 then LineNum := MaxSamLen - 1;
  if LineNum < 0             then LineNum := 0;

  // Do hit for cursor position
  if Shift = [] then
    Samples.DoHint(x1, y1)
  else
  begin
    Application.HideHint;
    ShowHintTimer.Enabled := False;
    ShowHintTimer.Interval := 9000;
  end;

  // Accept means, mouse Y coordinate more than Y +- MouseShift value
  Accept := (Y <= SamplesLastMouseCursorY - MouseShift) or (Y >= SamplesLastMouseCursorY + MouseShift);


  // Restart line selecting
  if (Shift = [ssShift,ssLeft]) and not SamplesLeftMouseButton then
  begin
    Samples.selStart := LineNum;
    Samples.selEnd   := LineNum;
    SamplesClickStartLine := LineNum;
    SamplesLastMouseCursorY := Y;
    SamplesLeftMouseButton := True;
    Accept := False;
  end;

  // Restart column selecting
  if (Shift = [ssCtrl,ssLeft]) and not SamplesLeftMouseButton then
  begin
    SampleCopy.FromLine := LineNum;
    SampleCopy.ToLine   := LineNum;

    i := DetectSampleColumn(x1);
    if i = 0 then Exit;
    SampleCopy.FromColumn := i;
    
    SampleCopy.ToColumn := SampleCopy.FromColumn;
    SampleCopy.StartColumn := SampleCopy.ToColumn;

    SamplesClickStartLine    := LineNum;
    SamplesLeftMouseButton   := True;
    SamplesLastMouseCursorY := Y;
  end;


  // Column selecting
  if (Shift = [ssCtrl,ssLeft]) and SamplesLeftMouseButton then
  begin

    if not Samples.isColSelecting then ResetSampleVolumeBuf;

    Samples.isSelecting := False;
    Samples.isColSelecting := True;
    SampleCopy.Sample := Samples.ShownSample;

    if SamplesClickStartLine >= LineNum then
    begin
      SampleCopy.ToLine := SamplesClickStartLine;
      SampleCopy.FromLine := LineNum;
    end;

    if SamplesClickStartLine < LineNum then
    begin
      SampleCopy.FromLine := SamplesClickStartLine;
      SampleCopy.ToLine := LineNum;
    end;

    i := DetectSampleColumn(x1);
    if i = 0 then Exit;
    SampleCopy.ToColumn := i;


    if SampleCopy.StartColumn >= SampleCopy.ToColumn then begin
      i := SampleCopy.ToColumn;
      SampleCopy.ToColumn := SampleCopy.StartColumn;
      SampleCopy.FromColumn := i;
    end;

    if SampleCopy.StartColumn < SampleCopy.ToColumn then begin
      i := SampleCopy.ToColumn;
      SampleCopy.FromColumn := SampleCopy.StartColumn;
      SampleCopy.ToColumn := i;
    end;

    Samples.ShowMyCaret;
    Samples.RedrawSamples(0);
    Samples.HideMyCaret;

  end;


  // Line selecting
  if (Shift = [ssShift,ssLeft])
     and (
      (SamplesClickStartLine = Samples.selStart) or (SamplesClickStartLine = Samples.selEnd)
     )
     and Accept
     and SamplesLeftMouseButton then
  begin

    if not Samples.isSelecting then ResetSampleVolumeBuf;

    Samples.isSelecting := True;
    Samples.isColSelecting := False;
    
    if SamplesClickStartLine >= LineNum then
    begin
      Samples.selEnd := SamplesClickStartLine;
      Samples.selStart := LineNum;
    end;

    if SamplesClickStartLine < LineNum then
    begin
      Samples.selStart :=  SamplesClickStartLine;
      Samples.selEnd := LineNum;
    end;

    Samples.ShowMyCaret;
    Samples.RedrawSamples(0);
    Samples.HideMyCaret;
  end;



  // Change sample length & loop
  if (Shift = [ssRight]) and SamplesRightMouseButton and Accept then
  begin
  
    if not Samples.UndoSaved then
      SaveSampleUndo(Samples.ShownSample);

    if SamplesClickStartLine >= LineNum then
    begin
      ChangeSampleLength(SamplesClickStartLine + 1, True);
      ChangeSampleLoop(LineNum, True);
    end;

    if SamplesClickStartLine < LineNum then
    begin
      ChangeSampleLength(LineNum + 1, True);
      ChangeSampleLoop(SamplesClickStartLine, True);
    end;

  end;


  if (Shift = [ssLeft]) then
  begin
    Samples.InputSNumber := 0;
    DrawOnSample(x1, y1, LineNum, False);
  end;

  // Scroll down
  if ButtonPressed and (y1 >= Samples.NOfLines) and (Samples.ShownFrom + Samples.NOfLines < MaxSamLen) then
  begin
    Inc(Samples.ShownFrom);
    Samples.RedrawSamples(0);
  end;

  // Scroll up
  if ButtonPressed and (y1 = 0) and (Samples.ShownFrom > 0) then
  begin
    Dec(Samples.ShownFrom);
    Samples.RedrawSamples(0);
  end;


  // For catching MouseUp event outside samples control
  if ButtonPressed then
    SetCaptureControl(Samples);

end;

procedure TMDIChild.OrnamentsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  x1, y1, i, c, LineNum: Integer;
begin

  // Release mouse events capture
  ReleaseCapture;

  x1 := X div Ornaments.CelW;
  y1 := Y div Ornaments.CelH;

  if (y1 >= 0) and (y1 < Ornaments.NRaw) and (x1 >= 3 + OrnXShift) and (x1 < OrnNCol * OrnNChars - 1) and not ((x1 mod OrnNChars) in [0..2, 7]) then
    with Ornaments do
    begin

      i := x1 div OrnNChars;
      x1 := i * OrnNChars;
      c := i * Ornaments.NRaw + y1;
      LineNum := ShownFrom + c;

      if Ornaments.RightMouseButton and not Ornaments.LoopStarted and (ShownOrnament <> nil) then
      begin
        CursorX := x1;
        CursorY := y1;
        SetCaretPosition;

        // Change sign for ornament item
        if (LineNum < ShownOrnament.Length) and (ShownOrnament.Items[LineNum] <> 0) then
        begin
          SongChanged := True;
          BackupSongChanged := True;
          AddUndo(CAChangeOrnamentValue, ShownOrnament.Items[LineNum], -ShownOrnament.Items[LineNum]);
          ChangeList[ChangeCount - 1].OldParams.prm.OrnamentCursor := c;
          ChangeList[ChangeCount - 1].OldParams.prm.OrnamentShownFrom := ShownFrom;
          ShownOrnament.Items[LineNum] := -ShownOrnament.Items[LineNum];
        end;

        if Focused then
          HideMyCaret;
        RedrawOrnaments(0);
        if Focused then
          ShowMyCaret;
      end;
    end;

  Ornaments.LeftMouseButton  := False;
  Ornaments.RightMouseButton := False;
  Ornaments.LoopStarted      := False;
  Ornaments.InputONumber     := 0;

  SaveOrnamentRedo;
end;

procedure TMDIChild.OrnamentsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  x1, y1, LineNum: Integer;
begin
  Ornaments.InputONumber := 0;
  x1 := X div Ornaments.CelW;
  y1 := Y div Ornaments.CelH;
  LineNum := Ornaments.ShownFrom + (x1 div OrnNChars) * Ornaments.NRaw + y1;


  // Start to set loop & length
  if (Shift = [ssRight]) and (not Ornaments.LoopStarted) then
  begin
    Ornaments.ClickStartLine := LineNum;
    Ornaments.ClickEndLine   := LineNum;
    Ornaments.ClickMouseCursorY := Y;
  end;
  

  if (y1 >= 0) and (y1 < Ornaments.NRaw) and (x1 >= 3 + OrnXShift) and (x1 < OrnNCol * OrnNChars - 1) and not ((x1 mod OrnNChars) in [0..2, 7]) then
    with Ornaments do
    begin

      // Set cursor by left mouse click
      if Shift = [ssLeft] then
      begin
        CursorX := (x1 div OrnNChars) * OrnNChars;
        CursorY := y1;
      end;


      // Start selecting by Shift
      if ((Shift = [ssLeft,ssShift]) or (Shift = [ssLeft,ssCtrl])) and not Ornaments.isSelecting then
      begin
        Ornaments.selStart := LineNum;
        Ornaments.selEnd := LineNum;
        Ornaments.ClickStartLine := LineNum;
        Ornaments.ClickMouseCursorY := Y;
        Ornaments.LeftMouseButton := True;
      end;

      // Set flag for ornament sign change by right mouse button
      if (Shift = [ssRight]) then
        Ornaments.RightMouseButton := True;

    end;


  // Deselecting
  OrnamentSelectionOff;

  if not Ornaments.Focused then
    Windows.SetFocus(Ornaments.Handle);

  // Set cursor position
  Ornaments.HideMyCaret;
  Ornaments.SetCaretPosition;
  Ornaments.ShowMyCaret;
  Ornaments.DoHint;
end;


procedure TMDIChild.OrnamentsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
const
  MouseShift = 8;

var
  x1, y1, LineNum: Integer;
  Accept: Boolean;
  ButtonPressed: Boolean;
begin

  x1 := X div Ornaments.CelW;
  y1 := Y div Ornaments.CelH;
  LineNum := Ornaments.ShownFrom + (x1 div OrnNChars) * Ornaments.NRaw + y1;
  ButtonPressed :=(ssLeft in Shift) or (ssRight in Shift);

  // Accept means mouse Y coordinate more than Y +- MouseShift const
  Accept := (Y <= Ornaments.ClickMouseCursorY - MouseShift) or (Y >= Ornaments.ClickMouseCursorY + MouseShift);

  // Change ornament length & loop
  if (Shift = [ssRight]) and Accept then
  begin

    if not Ornaments.UndoSaved and Ornaments.LoopStarted then
      SaveOrnamentUndo;

    if (Ornaments.ClickStartLine >= LineNum) and Ornaments.LoopStarted then
    begin
      ChangeOrnamentLength(Ornaments.ClickStartLine + 1, True);
      ChangeOrnamentLoop(LineNum, True);
    end;

    if (Ornaments.ClickStartLine < LineNum) and Ornaments.LoopStarted then
    begin
      ChangeOrnamentLength(LineNum + 1, True);
      ChangeOrnamentLoop(Ornaments.ClickStartLine, True);
    end;

    Ornaments.LoopStarted := True;
  end;


  if (y1 >= 0) and (y1 < Ornaments.NRaw) and (x1 >= 3 + OrnXShift) and (x1 < OrnNCol * OrnNChars - 1) and not ((x1 mod OrnNChars) in [0..2, 7]) then
    with Ornaments do
    begin

      // Restart selecting
      if ((Shift = [ssLeft,ssShift]) or (Shift = [ssLeft,ssCtrl])) and not Ornaments.isSelecting and not Ornaments.LeftMouseButton then
      begin
        Ornaments.selStart := LineNum;
        Ornaments.selEnd   := LineNum;
        Ornaments.ClickStartLine := LineNum;
        Ornaments.ClickMouseCursorY := Y;
        Ornaments.LeftMouseButton := True;
        Accept := False;
      end;

      // Selecting
      if (Shift = [ssLeft,ssShift]) and ((Ornaments.ClickStartLine = Ornaments.selStart) or (Ornaments.ClickStartLine = Ornaments.selEnd)) and Accept and Ornaments.LeftMouseButton then
      begin
        Ornaments.isSelecting := True;

        if Ornaments.ClickStartLine >= LineNum then
        begin
          Ornaments.selEnd := Ornaments.ClickStartLine;
          Ornaments.selStart := LineNum;
        end;

        if Ornaments.ClickStartLine < LineNum then
        begin
          Ornaments.selStart :=  Ornaments.ClickStartLine;
          Ornaments.selEnd := LineNum;
        end;

        Ornaments.HideMyCaret;
        Ornaments.RedrawOrnaments(0);
        Ornaments.ShowMyCaret;
      end;

    end;

  // For catching MouseUp event outside ornaments control
  if ButtonPressed then
    SetCaptureControl(Ornaments);
end;

procedure TMDIChild.OrnamentsMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if Ornaments.ShownFrom = 0 then Exit;
  Ornaments.ShownFrom := Ornaments.ShownFrom - 1;
  Ornaments.RedrawOrnaments(0);
end;

procedure TMDIChild.OrnamentsMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if Ornaments.ShownFrom = MaxOrnLen - (OrnNCol * Ornaments.NRaw) then Exit;
  Ornaments.ShownFrom := Ornaments.ShownFrom + 1;
  Ornaments.RedrawOrnaments(0);
end;

procedure TMDIChild.DisposeUndo;
var
  i: Integer;
begin
  if All then
    i := 0
  else
    i := ChangeCount - 1;
  for i := i to ChangeTop - 1 do
    case ChangeList[i].Action of
      CALoadPattern, CAInsertPatternFromClipboard, CAPatternInsertLine, CAPatternDeleteLine, CAPatternClearLine, CAPatternClearSelection, CATransposePattern, CATracksManagerCopy, CAExpandCompressPattern:
        Dispose(ChangeList[i].Pattern);
      CADeletePosition, CAInsertPosition:
        Dispose(ChangeList[i].PositionList);
      CALoadOrnament, CAOrGen, CACopyOrnamentToOrnament:
        Dispose(ChangeList[i].Ornament);
      CALoadSample, CACopySampleToSample:
        Dispose(ChangeList[i].Sample);
      CAChangeSampleValue:
        Dispose(ChangeList[i].SampleLineValues);
      CAChangePositionsAndPatterns:
        begin
          Dispose(ChangeList[i].PositionList);
          Dispose(ChangeList[i].ComParams.Patterns);
        end;
      CAChangePatternContent:
        Dispose(ChangeList[i].ComParams.ChangedPattern);
      CAChangeEntireSample:
        Dispose(ChangeList[i].ComParams.EntireSample);
      CAChangeEntireOrnament:
        Dispose(ChangeList[i].ComParams.EntireOrnament);
    end;
  if All then
    ChangeCount := 0;
  ChangeTop := ChangeCount;
end;

procedure TMDIChild.FormDestroy(Sender: TObject);
begin

  if IsPlaying and ((PlayingWindow[1] = Self) or ((NumberOfSoundChips > 1) and (PlayingWindow[2] = Self))) then
  begin
    StopPlaying;
    MainForm.RestoreControls;
  end;
  MainForm.DeleteWindowListItem(Self);
  MainForm.Caption := AppName +' '+ VersionString;;

  DisposeUndo(True);
  ChangeList := nil;
  ChangePatternsList := nil;
  ChangeOnePatternList := nil;
  ChangeSamplesList := nil;
  ChangeOrnamentsList := nil;
  ChangeNilPatternsList := nil;

  {FreeAndNil(SampleTestLine);
  FreeAndNil(OrnamentTestLine);
  FreeAndNil(Samples);
  FreeAndNil(Ornaments);
  FreeAndNil(Tracks); }
  FreeVTMP(VTMP);
end;

procedure TMDIChild.SetFileName(Name: string);
begin

  IsDemosong := AnsiContainsText(Name, VortexDocumentsDir + DemosongsDefaultDir);
  if not IsDemosong and not IsTemplate then
    WinFileName := Name;

  if AnsiContainsText(Name, 'template.vt2') then
    Caption := 'Template Song'
  else
    Caption := ExtractFileName(Name);

  BackupVersionCounter := GetBackupVersionCounter;
end;

function TMDIChild.LoadTrackerModule(Name: string; var VTMP2: PModule): Boolean;
const
  ers: array[1..6] of string = ('Module not found', 'Syntax error', 'Parameter out of range', 'Unexpected end of file', 'Bad sample structure', 'Bad pattern structure');
var
  ZXP: TSpeccyModule;
  i, Tm, TSSize2: Integer;
  Andsix: byte;
  ZXAddr: word;
  AuthN, SongN: string;

  function Convert(FType: Available_Types; VTMP: PModule; var VTMP2: PModule): Boolean;
  var
    j: Integer;
  begin
    Result := True;
    case FType of

      Unknown:
        begin
          i := LoadModuleFromText(Name, VTMP, VTMP2);

          if i <> 0 then
            Result := False;

          if i = -1 then
            MessageBox(MainForm.Handle, PChar('Patterns not found'), 'Text module loader error', MB_ICONEXCLAMATION);
          if i = -2 then
            MessageBox(MainForm.Handle, PChar('Samples not found'), 'Text module loader error', MB_ICONEXCLAMATION);
          if i = -3 then
            MessageBox(MainForm.Handle, PChar('Ornaments not found'), 'Text module loader error', MB_ICONEXCLAMATION);
          if i > 0 then
            MessageBox(MainForm.Handle, PChar(ers[i] + ' (line: ' + IntToStr(TxtLine) + ')'), 'Text module loader error', MB_ICONEXCLAMATION);

          if not Result then Exit;

          if VTMP2 <> nil then begin
            VTMP2.ShowInfo := VTMP.ShowInfo;
            VTMP2.Info     := VTMP.Info;
          end;

        end;

      PT2File: PT22VTM(@ZXP, VTMP);
      PT1File: PT12VTM(@ZXP, VTMP);
      STCFile: STC2VTM(@ZXP, i, VTMP);
      STPFile: STP2VTM(@ZXP, VTMP);
      SQTFile: SQT2VTM(@ZXP, VTMP);
      ASCFile: ASC2VTM(@ZXP, VTMP);
      PSCFile: PSC2VTM(@ZXP, VTMP);
      FLSFile: FLS2VTM(@ZXP, VTMP);
      GTRFile: GTR2VTM(@ZXP, VTMP);
      FTCFile: FTC2VTM(@ZXP, VTMP);
      FXMFile: FXM2VTM(@ZXP, ZXAddr, Tm, Andsix, SongN, AuthN, VTMP);
      PSMFile: PSM2VTM(@ZXP, VTMP);
      PT3File:

      begin
       PT32VTM(@ZXP, i, VTMP, VTMP2);
       SavedAsText := False;
      end;
    end;

    
    // Validate loaded module
    for j := 0 to High(VTMP.Patterns) do
      // Check for incorrect pattern length
      if (VTMP.Patterns[j] <> nil) and ((VTMP.Patterns[j].Length <= 0) or (VTMP.Patterns[j].Length > MaxPatLen)) then begin
        Result := False;
        Break;
      end;

      
    if Result then
      for j := 0 to VTMP.Positions.Length-1 do begin

        // Check for incorrect position value
        if (VTMP.Positions.Value[j] > MaxPatNum) or (VTMP.Positions.Value[j] < 0) then begin
          Result := False;
          Break;
        end;

        // Check if pattern exists
        if VTMP.Patterns[VTMP.Positions.Value[j]] = nil then begin
          Result := False;
          Break;
        end;
      end;


    // Check for incorrect sample length
    if Result then
      for j := Low(VTMP.Samples) to High(VTMP.Samples) do
        if (VTMP.Samples[j] <> nil) and ((VTMP.Samples[j].Length <= 0) or (VTMP.Samples[j].Length > MaxSamLen)) then begin
          Result := False;
          Break;
        end;

        
    // Check for incorrect ornament length
    if Result then
      for j := Low(VTMP.Ornaments) to High(VTMP.Ornaments) do
        if (VTMP.Ornaments[j] <> nil) and ((VTMP.Ornaments[j].Length <= 0) or (VTMP.Ornaments[j].Length > MaxOrnLen)) then begin
          Result := False;
          Break;
        end;

    // Check for incorrect sample tone value
    {if Result then
      for j := Low(VTMP.Samples) to High(VTMP.Samples) do
        for k := 0 to MaxSamLen-1 do
          if (VTMP.Samples[j] <> nil) and ((VTMP.Samples[j].Items[k].Add_to_Ton > $FFF) or (VTMP.Samples[j].Items[k].Add_to_Ton < -$FFF)) then begin
            Result := False;
            Break;
          end; }

    // Check for incorrect speed
    if VTMP.Initial_Delay = 0 then Result := False;


    // Check for incorrect tone table
    if VTMP.Ton_Table > 4 then Result := False;

    if not Result then
      Application.MessageBox('Module loading error', 'Vortex Tracker', MB_OK + MB_ICONSTOP + MB_TOPMOST);

  end;

var
  FileType, FType2: Available_Types;
  s: string;
  f: file;
  dummy: PModule;
begin
  Result := True;
  SavedAsText := True;
  UndoWorking := True;

  if not FileExists(Name) then
  begin
    MessageBox(Handle, PChar('File not found: "'+ Name +'"'), 'Can''t open file', MB_OK +
       MB_ICONWARNING + MB_TOPMOST);
    Result := False;
    Exit;
  end;

  try
    if VTMP2 = nil then
    begin
      FileType := LoadAndDetect(@ZXP, Name, i, FType2, TSSize2, ZXAddr, Tm, Andsix, AuthN, SongN);
      Result := Convert(FileType, VTMP, VTMP2);
      if not Result then
        Exit;
        
      if (VTMP2 = nil) and (FType2 <> Unknown) and (TSSize2 <> 0) then
      begin
        FillChar(ZXP, 65536, 0);
        AssignFile(f, Name);
        Reset(f, 1);
        Seek(f, i);
        BlockRead(f, ZXP, TSSize2, i);
        CloseFile(f);
        if i = TSSize2 then
        begin
          PrepareZXModule(@ZXP, FType2, TSSize2);
          if FType2 <> Unknown then
          begin
            NewVTMP(VTMP2);
            dummy := nil;
            Convert(FType2, VTMP2, dummy);
            if dummy <> nil then
              FreeVTMP(dummy);
          end;
        end;
      end;
    end
    else
    begin
      FreeVTMP(VTMP);
      VTMP := VTMP2;
      if LowerCase(ExtractFileExt(Name)) = '.pt3' then
        SavedAsText := False;
    end;
    Module_SetPointer(VTMP, 1);
    SetFileName(Name);
    VtmFeaturesGrp.ItemIndex := VTMP.FeaturesLevel;
    SaveHead.ItemIndex := Ord(not VTMP.VortexModule_Header);
    MainForm.AddFileName(Name);
    if VTMP.Positions.Length > 0 then
    begin
      PatternNumUpDown.Position := VTMP.Positions.Value[0];
      Tracks.ShownPattern := VTMP.Patterns[VTMP.Positions.Value[0]];
      if Tracks.ShownPattern <> nil then
        PatternLenUpDown.Position := VTMP.Patterns[VTMP.Positions.Value[0]].Length
      else
        PatternLenUpDown.Position := DefPatLen;
    end
    else
    begin
      Tracks.ShownPattern := VTMP.Patterns[0];
      if VTMP.Patterns[0] <> nil then
        PatternLenUpDown.Position := VTMP.Patterns[0].Length
      else
        PatternLenUpDown.Position := DefPatLen
    end;
    if AutoHL.Down then
      CalcHLStep;
    SpeedBpmUpDown.Position := VTMP.Initial_Delay;
    UpDown4.Position := VTMP.Ton_Table;
    Edit3.Text := VTMP.Title;
    Edit4.Text := VTMP.Author;
    PosDelay := VTMP.Initial_Delay;
    for i := 0 to VTMP.Positions.Length - 1 do
    begin
      s := IntToStr(VTMP.Positions.Value[i]);
      if i = VTMP.Positions.Loop then
        s := 'L' + s;
      StringGrid1.Cells[i, 0] := s
    end;
    InitStringGridMetrix;
    Samples.ShownSample := VTMP.Samples[1];
    if VTMP.Samples[1] <> nil then
    begin
      SampleLenUpDown.Position := VTMP.Samples[1].Length;
      SampleLoopUpDown.Position := VTMP.Samples[1].Loop;
    end;
    Ornaments.ShownOrnament := VTMP.Ornaments[1];
    if VTMP.Ornaments[1] <> nil then
    begin
      OrnamentLenUpDown.Position := VTMP.Ornaments[1].Length;
      OrnamentLoopUpDown.Position := VTMP.Ornaments[1].Loop;
    end;
    CalcTotLen;
    for i := 1 to 31 do
      if VTMP.Samples[i] <> nil then
      begin
        VTMP.Samples[i].Enabled := True;
        for Tm := VTMP.Samples[i].Length to MaxSamLen - 1 do
          VTMP.Samples[i].Items[Tm] := EmptySampleTick;
      end;
    for i := 1 to 15 do
      if VTMP.Ornaments[i] <> nil then
        for Tm := VTMP.Ornaments[i].Length to MaxOrnLen - 1 do
          VTMP.Ornaments[i].Items[Tm] := 0;
  finally
    UndoWorking := False;
    SongChanged := False;
    BackupSongChanged := False;
    Tracks.RedrawTracks(0);
  end;
end;

procedure TMDIChild.TracksMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  PLen: Integer;
begin
  if IsPlaying and ((PlayMode = PMPlayModule) or (PlayMode = PMPlayPattern)) then Exit;


  if IsMouseOverControl(PositionsScrollBox) then
  begin
    // Scroll positions, not pattern
    StringGrid1.SetFocus;
    StringGrid1MouseWheelDown(Sender, Shift, MousePos, Handled);
    Exit;
  end;

  // Mouse pointer under another control
  if not IsMouseOverControl(Tracks) then Exit;


  Tracks.ManualBitBlt := True;
  if TSWindow <> nil then
    TSWindow.Tracks.ManualBitBlt := True;

  Handled := True;
  if Tracks.ShownPattern = nil then
    PLen := DefPatLen
  else
    PLen := Tracks.ShownPattern.Length;
  if Tracks.ShownFrom < PLen - 1 then
  begin
    Inc(Tracks.ShownFrom);
    Tracks.HideMyCaret;
    if (Tracks.CursorY > 0) and (Tracks.CursorY <> Tracks.N1OfLines) then
    begin
      Dec(Tracks.CursorY);
      Tracks.SetCaretPosition;
    end
    else if GetKeyState(VK_SHIFT) and 128 = 0 then
      Tracks.RemoveSelection;
    Tracks.RedrawTracks(0);
    Tracks.ShowMyCaret;
  end
  else
  begin
    if BetweenPatterns.Checked then
      BetweenPatternsDown
    else begin
      Tracks.ShownFrom := 0;
      Tracks.CursorY := Tracks.N1OfLines;
      Tracks.RemoveSelection;
      Tracks.HideMyCaret;
      Tracks.RedrawTracks(0);
      Tracks.SetCaretPosition;
      Tracks.ShowMyCaret;
    end;
  end;
  ShowStat;

  Tracks.ManualBitBlt := False;
  Tracks.DoBitBlt;
  if TSWindow <> nil then
  begin
    TSWindow.Tracks.ManualBitBlt := False;
    TSWindow.Tracks.DoBitBlt;
  end;

end;

procedure TMDIChild.TracksMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  PLen: Integer;
begin
  if IsPlaying and ((PlayMode = PMPlayModule) or (PlayMode = PMPlayPattern)) then Exit;

  if IsMouseOverControl(PositionsScrollBox) then
  begin
    // Scroll positions, not pattern
    StringGrid1.SetFocus;
    StringGrid1MouseWheelUp(Sender, Shift, MousePos, Handled);
    Exit;
  end;

  // Mouse pointer under another control
  if not IsMouseOverControl(Tracks) then Exit;


  Tracks.ManualBitBlt := True;
  if TSWindow <> nil then
    TSWindow.Tracks.ManualBitBlt := True;

  Handled := True;
  if Tracks.ShownFrom > 0 then
  begin
    Dec(Tracks.ShownFrom);
    Tracks.HideMyCaret;
    if (Tracks.CursorY < Tracks.NOfLines - 1) and (Tracks.CursorY <> Tracks.N1OfLines) then
    begin
      Inc(Tracks.CursorY);
      Tracks.SetCaretPosition;
    end
    else if GetKeyState(VK_SHIFT) and 128 = 0 then
      Tracks.RemoveSelection;
    Tracks.RedrawTracks(0);
    Tracks.ShowMyCaret;
  end
  else
  begin
    if Tracks.ShownPattern = nil then
      PLen := DefPatLen
    else
      PLen := Tracks.ShownPattern.Length;
    if BetweenPatterns.Checked then
      BetweenPatternsUp
    else begin
      Tracks.ShownFrom := PLen - 1;
      Tracks.CursorY := Tracks.N1OfLines;
      Tracks.RemoveSelection;
      Tracks.HideMyCaret;
      Tracks.RedrawTracks(0);
      Tracks.SetCaretPosition;
      Tracks.ShowMyCaret;
    end;
  end;
  ShowStat;

  Tracks.ManualBitBlt := False;
  Tracks.DoBitBlt;
  if TSWindow <> nil then
  begin
    TSWindow.Tracks.ManualBitBlt := False;
    TSWindow.Tracks.DoBitBlt;
  end;
end;


procedure TMDIChild.ResetSampleVolumeBuf;
begin
  SetLength(VolumeLBuffer, 0); SetLength(VolumeLBuffer, MaxSamLen);
  SetLength(VolumeRBuffer, 0); SetLength(VolumeRBuffer, MaxSamLen);
end;


procedure TMDIChild.ClearSampleCols;
var
  Line, Col: Integer;
  SampleTick: PSampleTick;
begin
  if Samples.ShownSample = nil then Exit;
  SaveSampleUndo(Samples.ShownSample);

  for Line := SampleCopy.FromLine to SampleCopy.ToLine do begin
    SampleTick := @Samples.ShownSample.Items[Line];

    for Col := SampleCopy.FromColumn to SampleCopy.ToColumn do begin
      case Col of

        1: SampleTick.Mixer_Ton := False;
        2: SampleTick.Mixer_Noise := False;
        3: SampleTick.Envelope_Enabled := False;

        4: begin
          SampleTick.Add_to_Ton := 0;
          SampleTick.Ton_Accumulation := False;
        end;

        5: begin
          SampleTick.Add_to_Envelope_or_Noise := 0;
          SampleTick.Envelope_or_Noise_Accumulation := False;
        end;

        6: begin
          SampleTick.Amplitude := 0;
          SampleTick.Amplitude_Sliding := False;
          SampleTick.Amplitude_Slide_Up := False;
        end;
      end;
    end;
  end;

  SaveSampleRedo;

  Samples.HideMyCaret;
  Samples.RedrawSamples(0);
  Samples.ShowMyCaret;
end;


procedure TMDIChild.IncreaseSampleTone(SampleTick: PSampleTick; Shift: TShiftState);
begin
  if Shift = [ssShift] then
    SampleTick.Add_to_Ton := SampleTick.Add_to_Ton + 32
  else if Shift = [ssCtrl] then
    SampleTick.Add_to_Ton := SampleTick.Add_to_Ton + 64
  else
    SampleTick.Add_to_Ton := SampleTick.Add_to_Ton + 1;
  if (Abs(SampleTick.Add_to_Ton) > $FFF) then
    SampleTick.Add_to_Ton := SampleTick.Add_to_Ton and $FFF;
end;


procedure TMDIChild.IncreaseSampleNoise(SampleTick: PSampleTick);
begin
  if SampleTick.Add_to_Envelope_or_Noise < 31 then
    Inc(SampleTick.Add_to_Envelope_or_Noise);
end;


procedure TMDIChild.IncreaseSampleAmplitude(SampleTick: PSampleTick; Line: Integer; Overflow: Boolean);
begin
  if (SampleTick.Amplitude = $F) and not Overflow then Exit;

  if (SampleTick.Amplitude = 0) and (VolumeLBuffer[Line] < 0) then
    Inc(VolumeLBuffer[Line])

  else if (SampleTick.Amplitude = $F) then begin
    if (VolumeRBuffer[Line] < $F) then Inc(VolumeRBuffer[Line]);
    
  end
  else
    Inc(SampleTick.Amplitude);
end;



procedure TMDIChild.IncreaseSampleCols(Shift: TShiftState);
var
  i, Line, Column: Integer;
  SampleTick: PSampleTick;
  Limit, ShiftVol: Boolean;

begin
  if Samples.ShownSample = nil then Exit;
  Limit    := False;
  ShiftVol := True;

  if Samples.isSelecting then begin
    SampleCopy.FromLine := Samples.selStart;
    SampleCopy.ToLine   := Samples.selEnd;
    SampleCopy.FromColumn := 4;
    SampleCopy.TOColumn   := 6;
  end;

  if not Samples.isSelecting and not Samples.isColSelecting then begin
    SampleCopy.FromLine   := Samples.CurrentLine;
    SampleCopy.ToLine     := SampleCopy.FromLine;
    SampleCopy.FromColumn := DetectSampleColumn(Samples.CursorX);
    SampleCopy.ToColumn   := SampleCopy.FromColumn;
    ShiftVol := False;
  end;
  

  for i := 0 to MaxSamLen-1 do
    if VolumeRBuffer[i] = $F then begin
      Limit := True;
      Break;
    end;
  if Limit then Exit;

  for Line := SampleCopy.FromLine to SampleCopy.ToLine do begin
    SampleTick := @Samples.ShownSample.Items[Line];

    for Column := SampleCopy.FromColumn to SampleCopy.ToColumn do
      case Column of

        4: IncreaseSampleTone(SampleTick, Shift);
        5: IncreaseSampleNoise(SampleTick);
        6: IncreaseSampleAmplitude(SampleTick, Line, ShiftVol);

      end;
  end;

  SongChanged := True;
  BackupSongChanged := True;

  Samples.HideMyCaret;
  Samples.RedrawSamples(0);
  Samples.ShowMyCaret;
  Exit;
end;



procedure TMDIChild.DecreaseSampleTone(SampleTick: PSampleTick; Shift: TShiftState);
begin
  if Shift = [ssShift] then
    SampleTick.Add_to_Ton := SampleTick.Add_to_Ton - 32
  else if Shift = [ssCtrl] then
    SampleTick.Add_to_Ton := SampleTick.Add_to_Ton - 64
  else
    SampleTick.Add_to_Ton := SampleTick.Add_to_Ton - 1;
  if (Abs(SampleTick.Add_to_Ton) > $FFF) then
    SampleTick.Add_to_Ton := SampleTick.Add_to_Ton and $FFF;
end;


procedure TMDIChild.DecreaseSampleNoise(SampleTick: PSampleTick);
begin
  if SampleTick.Add_to_Envelope_or_Noise > -31 then
    Dec(SampleTick.Add_to_Envelope_or_Noise);
end;


procedure TMDIChild.DecreaseSampleAmplitude(SampleTick: PSampleTick; Line: Integer; Overflow: Boolean);
begin
  if (SampleTick.Amplitude = 0) and not Overflow then Exit;

  if (SampleTick.Amplitude = $F) and (VolumeRBuffer[Line] > 0) then
    Dec(VolumeRBuffer[Line])

  else if (SampleTick.Amplitude = 0) then begin
    if (VolumeLBuffer[Line] > -$F) then Dec(VolumeLBuffer[Line])

  end
  else
    Dec(SampleTick.Amplitude);
end;



procedure TMDIChild.DecreaseSampleCols(Shift: TShiftState);
var
  i, Line, Column: Integer;
  SampleTick: PSampleTick;
  Limit: Boolean;

begin
  if Samples.ShownSample = nil then Exit;
  Limit := False;

  if Samples.isSelecting then begin
    SampleCopy.FromLine := Samples.selStart;
    SampleCopy.ToLine   := Samples.selEnd;
    SampleCopy.FromColumn := 4;
    SampleCopy.TOColumn   := 6;
  end;

  if not Samples.isSelecting and not Samples.isColSelecting then begin
    SampleCopy.FromLine   := Samples.CurrentLine;
    SampleCopy.ToLine     := SampleCopy.FromLine;
    SampleCopy.FromColumn := DetectSampleColumn(Samples.CursorX);
    SampleCopy.ToColumn   := SampleCopy.FromColumn;
  end;


  for i := 0 to MaxSamLen-1 do
    if VolumeLBuffer[i] = -$F then begin
      Limit := True;
      Break;
    end;
  if Limit then Exit;

  for Line := SampleCopy.FromLine to SampleCopy.ToLine do begin
    SampleTick := @Samples.ShownSample.Items[Line];

    for Column := SampleCopy.FromColumn to SampleCopy.ToColumn do
      case Column of

        4: DecreaseSampleTone(SampleTick, Shift);
        5: DecreaseSampleNoise(SampleTick);
        6: DecreaseSampleAmplitude(SampleTick, Line, True);

      end;
  end;

  SongChanged := True;
  BackupSongChanged := True;

  Samples.HideMyCaret;
  Samples.RedrawSamples(0);
  Samples.ShowMyCaret;
  Exit;
end;





procedure TMDIChild.SamplesMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  Samples.InputSNumber := 0;
  ValidateSample2(SamNum);


  // Decrease selected columns
  if Samples.isColSelecting then begin
    DecreaseSampleCols(Shift);
    Exit;
  end;


  if (Shift = [ssRight]) and (SamplesRightMouseButton) then
  begin

    if (SamplesClickEndLine - Samples.ShownFrom + 4 < Samples.NOfLines) then
      Samples.SamplesDontScroll := True
    else
      Samples.SamplesDontScroll := False;

    if (SamplesClickEndLine < MaxSamLen) then
      inc(SamplesClickEndLine);

  end;

  if not Samples.SamplesDontScroll then
  begin
    Handled := True;
    if Samples.ShownFrom < MaxSamLen - Samples.NOfLines then
    begin
      Inc(Samples.ShownFrom);
      Samples.HideMyCaret;
      Samples.RedrawSamples(0);
      if Samples.CursorY > 0 then
      begin
        Dec(Samples.CursorY);
        Samples.SetCaretPosition;
      end;
      Samples.ShowMyCaret
    end;
  end;

  if (Shift = [ssRight]) and (SamplesRightMouseButton) then
    if SamplesClickStartLine >= SamplesClickEndLine then
    begin
      ChangeSampleLength(SamplesClickStartLine + 1, True);
      ChangeSampleLoop(SamplesClickEndLine, True);
      SampleLenUpDown.Position := SamplesClickStartLine + 1;
      SampleLoopUpDown.Position := SamplesClickEndLine;
    end
    else
    begin
      ChangeSampleLength(SamplesClickEndLine, True);
      SampleLenUpDown.Position := SamplesClickEndLine;
    end;

  {else     // Disabled Jump to samples top when scrolling beyond end of sample
  begin
    Samples.ShownFrom := 0;
    Samples.CursorY := 0;
    Samples.HideMyCaret;
    Samples.RedrawSamples(0);
    Samples.SetCaretPosition;
    Samples.ShowMyCaret
  end }
end;

procedure TMDIChild.SamplesMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  Samples.InputSNumber := 0;
  Handled := True;


  // Increase selected columns
  if Samples.isColSelecting then begin
    IncreaseSampleCols(Shift);
    Exit;
  end;


  if (Shift = [ssRight]) and (SamplesRightMouseButton) then
  begin

    if (SamplesClickEndLine - 4 <= Samples.ShownFrom) then
      Samples.SamplesDontScroll := False
    else
      Samples.SamplesDontScroll := True;

    if (SamplesClickEndLine > 0) then
      dec(SamplesClickEndLine);

  end;

  if (Samples.ShownFrom > 0) and not Samples.SamplesDontScroll then
  begin
    Dec(Samples.ShownFrom);
    Samples.HideMyCaret;
    Samples.RedrawSamples(0);
    if Samples.CursorY < Samples.NOfLines - 1 then
    begin
      Inc(Samples.CursorY);
      Samples.SetCaretPosition;
    end;
    Samples.ShowMyCaret
  end;

  if (Shift = [ssRight]) and (SamplesRightMouseButton) then
    if SamplesClickStartLine >= SamplesClickEndLine then
    begin
      ChangeSampleLength(SamplesClickStartLine + 1, True);
      ChangeSampleLoop(SamplesClickEndLine, True);
      SampleLenUpDown.Position := SamplesClickStartLine + 1;
      SampleLoopUpDown.Position := SamplesClickEndLine;
    end
    else
    begin
      ChangeSampleLength(SamplesClickEndLine, True);
      SampleLenUpDown.Position := SamplesClickEndLine;
    end;


  {else  // Disabled jump to bottom when scroll beyound start of sample
  begin
    Samples.ShownFrom := MaxSamLen - Samples.NOfLines;
    Samples.CursorY := Samples.NOfLines - 1;
    Samples.HideMyCaret;
    Samples.RedrawSamples(0);
    Samples.SetCaretPosition;
    Samples.ShowMyCaret
  end }
end;

procedure TMDIChild.ValidatePattern2;
begin
  ValidatePattern(Pat, VTMP);
  if Pat = PatNum then
    Tracks.ShownPattern := VTMP.Patterns[PatNum]
end;

procedure TMDIChild.TracksKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if Tracks.KeyPressed <> Key then
    Exit;

  UnlimiteDelay := False;
  Tracks.KeyPressed := 0;

  if IsPlaying then
  begin
    MainForm.RestoreControls;

    if PlayMode = PMPlayLine then
      ResetPlaying
    else
      StopPlaying;

    PlayMode := PMPlayLine;
    PlayStopState := BPlay;
    
    // Restore checkboxes
    BetweenPatterns.Enabled := True;
    DuplicateNoteParams.Enabled := True;
    EnvelopeAsNoteOpt.Enabled := True;
  end;
  
  // Return back after play (Ctrl+Enter)
  if Tracks.ReturnAfterPlay then
  begin
    Tracks.RedrawDisabled := True;
    IsSinchronizing       := True;
    SelectPosition2(Tracks.ReturnPosition);
    Tracks.RedrawDisabled := False;
    IsSinchronizing       := False;

    Tracks.ShownFrom := Tracks.ReturnShownFrom;
    Tracks.CursorY   := Tracks.ReturnCursorY;

    Tracks.RemoveSelection;
    Tracks.HideMyCaret;
    Tracks.RedrawTracks(0);
    Tracks.ShowMyCaret;

    if Self.TSWindow <> nil then
    begin
      SinchronizeModules;
      Self.TSWindow.Tracks.ShownFrom := Tracks.ReturnShownFrom;
      Self.TSWindow.Tracks.CursorY   := Tracks.ReturnCursorY;
      Self.TSWindow.Tracks.RemoveSelection;
      Tracks.HideMyCaret;
      Self.TSWindow.Tracks.RedrawTracks(0);
      Tracks.ShowMyCaret;
    end;
    Tracks.ReturnAfterPlay := False;
  end;
  
  // Restore cursor
  Tracks.RemoveSelection;
  Tracks.HideMyCaret;
  Tracks.RecreateCaret;
  Tracks.SetCaretPosition;
  Tracks.ShowMyCaret;  

end;

procedure TTestLine.TestLineKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if KeyPressed = Key then
  begin
    if (PlayMode = PMPlayLine) and IsPlaying and (PlayingWindow[1] = ParWind) then
    begin
      ResetPlaying;
      TMDIChild(ParWind).PlayStopState := BPlay;
    end;
    KeyPressed := 0;
  end;
end;

procedure TMDIChild.RestartPlayingPos(Pos: Integer);
begin
  if not IsPlaying then Exit;
  if PlayMode = PMPlayLine then Exit;

  if Pos > VTMP.Positions.Length-1 then
    Exit;
  if PlayingWindow[1] = Self then
  begin
    if not Reseted then
      ResetPlaying;
    RerollToPos(Pos, 1);
    UnresetPlaying;
  end
  else if (NumberOfSoundChips > 1) and (PlayingWindow[2] = Self) then
  begin
    if not Reseted then
      ResetPlaying;
    RerollToPos(Pos, 2);
    UnresetPlaying;
  end;
end;


procedure TMDIChild.RestartPlayingNote(Line: Integer);
begin

  if IsPlaying and UnlimiteDelay then
    StopPlaying;

  SetModuleFreq;
  PlayingWindow[1] := Self;
  NumberOfSoundChips := 1;
  if TSWindow <> nil then begin
    PlayingWindow[2] := TSWindow;
    NumberOfSoundChips := 2;
  end;

  RerollToLineNum(1, Tracks.CurrentPatLine, True);
  
  if TSWindow = nil then
    RestartPlayingLine(Line)
  else
    RestartPlayingTS(True, True);
end;


procedure TMDIChild.RestartPlayingLine(Line: Integer);
var
  NT: array[0..2] of Integer;
  i: Integer;
  EnvP, EnvT: Integer;
  Stoped: Boolean;

begin
  Stoped := False;

  SetModuleFreq;

  if IsPlaying then
  begin
    MainForm.RestoreControls;
    if PlayMode = PMPlayLine then
      ResetPlaying
    else begin
      StopPlaying;
      Stoped := True
    end;
  end;
  UnlimiteDelay := False;

  PlayingWindow[1] := Self;
  NumberOfSoundChips := 1;
  PlayMode := PMPlayLine;
  EnvP := PlVars[1].Env_Base;
  EnvT := SoundChip[1].AYRegisters.EnvType;
  Module_SetPointer(VTMP, 1);
  if Line >= 0 then
  begin
    for i := 0 to 2 do
      NT[i] := PlVars[1].ParamsOfChan[i].note;
    InitForAllTypes(False);
    for i := 0 to 2 do
      PlVars[1].ParamsOfChan[i].note := NT[i];
    for i := 0 to 2 do
      if VTMP.IsChans[i].EnvelopeEnabled then
      begin
        PlVars[1].Env_Base := EnvP;
        SoundChip[1].SetEnvelopeRegister(EnvT);
        break
      end;
    for i := 0 to 2 do
      if ((VTMP.Patterns[PatNum].Items[Line].Channel[i].note = -1) and (VTMP.Patterns[PatNum].Items[Line].Channel[i].Envelope in [1..14])) then
        PlVars[1].ParamsOfChan[i].SoundEnabled := True;
    Module_SetCurrentPattern(PatNum);
    Pattern_SetCurrentLine(Line)
  end
  else
  begin
    NT[0] := PlVars[1].ParamsOfChan[MidChan].note;
    InitForAllTypes(False);
    PlVars[1].ParamsOfChan[MidChan].note := NT[0];
    if VTMP.IsChans[MidChan].EnvelopeEnabled then
    begin
      PlVars[1].Env_Base := EnvP;
      SoundChip[1].SetEnvelopeRegister(EnvT)
    end;
    if ((VTMP.Patterns[-1].Items[-(Line + 1)].Channel[0].note = -1) and (VTMP.Patterns[-1].Items[-(Line + 1)].Channel[0].Envelope in [1..14])) then
      PlVars[1].ParamsOfChan[MidChan].SoundEnabled := True;
    Module_SetCurrentPattern(-1);
    Pattern_SetCurrentLine(-(Line + 1))
  end;
  Pattern_PlayCurrentLine;
  LineReady := True;

  if IsPlaying then begin
    if Stoped then
      StartWOThread
    else
      UnresetPlaying;
  end
  else
    StartWOThread;
end;


procedure TMDIChild.RestartPlaying(PlayPat, Enter: Boolean);
var Stoped: Boolean;
begin

  SetModuleFreq;

  Stoped := False;
  if IsPlaying then
  begin
    MainForm.RestoreControls;
    if PlayMode = PMPlayLine then
      ResetPlaying
    else begin
      StopPlaying;
      Stoped := True
    end;
  end;

  UnlimiteDelay := False;
  PlayStopState := BStop;

  if PlayPat then
    PlayMode := PMPlayPattern
  else
    PlayMode := PMPlayModule;

  if Enter then
  begin
    PlayingWindow[1] := Self;
    //BetweenPatterns.Enabled := False;
    //DuplicateNoteParams.Enabled := False;
    //EnvelopeAsNoteOpt.Enabled := False;
  end
  else
    MainForm.DisableControls(False);
    
  NumberOfSoundChips := 1;
  Tracks.RemoveSelection;

  PlVars[1].CurrentPosition := PositionNumber;
  Module_SetCurrentPattern(PatNum);

  // Shift+Enter - infinite play current line
  if Enter and (GetKeyState(VK_SHIFT) and 128 <> 0) then
  begin
    RerollToLine0(1);
    UnlimiteDelay := True;
    Tracks.HideMyCaret;
  end
  else
  begin
    RerollToLine(1);
    UnlimiteDelay := False;
  end;

  if IsPlaying then begin
    if Stoped then
      StartWOThread
    else
      UnresetPlaying;
  end
  else
    StartWOThread;
end;


procedure TMDIChild.RestartPlayingTS(PlayPat, PlayNote: Boolean);
begin

  if IsPlaying then
  begin
    MainForm.RestoreControls;
    StopPlaying;
    UnlimiteDelay := False;
  end;
  PlayStopState := BStop;

  if PlayPat then
    PlayMode := PMPlayPattern
  else begin
    PlayMode := PMPlayModule;
    MainForm.DisableControls(False);
  end;

  PlayingWindow[1] := Self;
  PlayingWindow[2] := TSWindow;
  PlayingWindow[1].Tracks.RemoveSelection;
  PlayingWindow[2].Tracks.RemoveSelection;
  NumberOfSoundChips := 2;

  // Shift+Enter - infinite play current line
  if PlayNote or (GetKeyState(VK_SHIFT) and 128 <> 0) then
  begin
    UnlimiteDelay := True;
    if not PlayNote then begin
      Tracks.HideMyCaret;
      RerollToLine0(1);
    end;
  end
  else
    RerollToLine(1);

  StartWOThread;

end;


procedure TMDIChild.StopAndRestart;
begin
  if not IsPlaying then
    exit;
  if Reseted then
    exit;
  if PlayMode <> PMPlayModule then
    exit;
  ResetPlaying;
  PlayingWindow[1].RerollToLine(1);
  UnresetPlaying;
end;

procedure TMDIChild.RerollToInt;
begin
  Module_SetPointer(VTMP, Chip);
  Module_SetDelay(VTMP.Initial_Delay);
  Module_SetCurrentPosition(0);
  if Int_ > 0 then
  begin
    repeat
      if Module_PlayCurrentLine = 3 then
        if not LoopAllowed and (not MainForm.LoopAllAllowed or (MainForm.MDIChildCount <> 1)) then
        begin
          Real_End[Chip] := True;
          SoundChip[Chip].SetAmplA(0);
          SoundChip[Chip].SetAmplB(0);
          SoundChip[Chip].SetAmplC(0);
        end;
    until (PlVars[Chip].IntCnt >= Int_) or Real_End[Chip];
    LineReady := True;
  end;
end;

procedure TMDIChild.RerollToPos;
var
  i: Integer;
begin
  InitForAllTypes(True);
  Module_SetPointer(VTMP, Chip);
  Module_SetDelay(VTMP.Initial_Delay);
  Module_SetCurrentPosition(0);
  if Pos > 0 then
  begin
    repeat
      i := Module_PlayCurrentLine;
    until (i = 2) and (PlVars[Chip].CurrentPosition = Pos);
    LineReady := True;
  end;
  if NumberOfSoundChips > 1 then
    PlayingWindow[3 - Chip].RerollToInt(PlVars[Chip].IntCnt, 3 - Chip);
end;


procedure TMDIChild.RerollToLineNum(Chip, Line: Integer; ZeroLine: Boolean; SrcVTMP: PModule = nil);
var
  i: Integer;
begin
  if SrcVTMP = nil then SrcVTMP := VTMP;


  InitForAllTypes(True);
  Module_SetPointer(SrcVTMP, Chip);
  Module_SetDelay(SrcVTMP.Initial_Delay);
  Module_SetCurrentPosition(0);
  if PositionNumber > 0 then
  begin
    repeat
      i := Module_PlayCurrentLine
    until (i = 2) and (PlVars[Chip].CurrentPosition = PositionNumber);
    LineReady := True;
    ZeroLine := False;
  end;

  if ZeroLine and (Line = 0) then begin
    Module_PlayCurrentLine;
    LineReady := True;
  end
  
  else if Line > 0 then
  begin                            
    repeat
      i := Module_PlayCurrentLine
    until (i = 1) and (PlVars[Chip].CurrentLine = Line + 1);
    LineReady := True
  end;
  if NumberOfSoundChips > 1 then
    PlayingWindow[3 - Chip].RerollToInt(PlVars[Chip].IntCnt, 3 - Chip);
end;

procedure TMDIChild.RerollToLine(Chip: Integer);
var
  i: Integer;
begin
  InitForAllTypes(True);
  Module_SetPointer(VTMP, Chip);
  Module_SetDelay(VTMP.Initial_Delay);
  Module_SetCurrentPosition(0);
  if PositionNumber > 0 then
  begin
    repeat
      i := Module_PlayCurrentLine
    until (i = 2) and (PlVars[Chip].CurrentPosition = PositionNumber);
    LineReady := True
  end;
  if Tracks.ShownFrom > 0 then
  begin
    repeat
      i := Module_PlayCurrentLine
    until (i = 1) and (PlVars[Chip].CurrentLine = Tracks.ShownFrom + 1);
    LineReady := True
  end;
  if NumberOfSoundChips > 1 then
    PlayingWindow[3 - Chip].RerollToInt(PlVars[Chip].IntCnt, 3 - Chip);
end;

procedure TMDIChild.RerollToLine0(Chip: Integer);
var
  i: Integer;
begin
  InitForAllTypes(True);
  Module_SetPointer(VTMP, Chip);
  Module_SetDelay(VTMP.Initial_Delay);
  Module_SetCurrentPosition(0);
  if PositionNumber > 0 then
  begin
    repeat
      i := Module_PlayCurrentLine
    until (i = 2) and (PlVars[Chip].CurrentPosition = PositionNumber);
    LineReady := True
  end;

  if Tracks.ShownFrom = 0 then
  begin
    Module_PlayCurrentLine;
    LineReady := True;
  end
  else if Tracks.ShownFrom > 0 then
  begin
    repeat
      i := Module_PlayCurrentLine
    until (i = 1) and (PlVars[Chip].CurrentLine = Tracks.ShownFrom + 1);
    LineReady := True
  end;

  if NumberOfSoundChips > 1 then
    PlayingWindow[3 - Chip].RerollToInt(PlVars[Chip].IntCnt, 3 - Chip);
end;

procedure TMDIChild.RerollToPatternLine;
var
  i, j: Integer;
begin
  LineReady := False;
  j := Tracks.CurrentPatLine;
  if (j >= 0) and (j < GetCurrentPatternLength) then
  begin
    repeat
      i := Pattern_PlayCurrentLine
    until (i = 1) and (PlVars[Chip].CurrentLine = j + 1);
    LineReady := True
  end;
end;


procedure TMDIChild.GoToTime(Time: Integer);
var
  Pos, Line: Integer;
begin
  GetTimeParams(VTMP, Time, Pos, Line);
  if PlayMode = PMPlayPattern then Exit;
  //if Pos = -1 then Exit;
  MainForm.RedrawPlWindow(Self, Pos, VTMP.Positions.Value[Pos], Line);
end;

procedure TMDIChild.SinchronizeModules;
begin
  if IsSinchronizing or (TSWindow = nil) or (TSWindow = Self) then
    Exit;
  if (Tracks.ShownFrom = TSWindow.Tracks.ShownFrom) and (PositionNumber = TSWindow.PositionNumber) then
    Exit;


  if not IsPlaying or (PlayMode <> PMPlayModule) then
  begin
    TSWindow.IsSinchronizing := True;
    try
      TSWindow.GoToTime(PosBegin + LineInts);
    finally
      TSWindow.IsSinchronizing := False;
    end;
  end;
end;


procedure TMDIChild.SetStringGrid1Scroll(ACol: Integer);
var
  ScrollPos, ColPos, VisibleArea, SelRows, VisibleColCount: Integer;
  Shift: Boolean;
  
begin
  VisibleColCount := PositionsScrollBox.ClientWidth div (StringGrid1.DefaultColWidth+1);
  SelRows := StringGrid1.Selection.Right - StringGrid1.Selection.Left + 1;

  Shift := False;
  if ACol = -1 then begin
    if SelRows = 1 then
      ACol := StringGrid1.Selection.Left + 1
    else begin
      ACol := StringGrid1.Selection.Left - (VisibleColCount div 2) + (SelRows div 2);
      Shift := True;
    end;
  end;

  if ACol > VTMP.Positions.Length - 1 then
    ACol := VTMP.Positions.Length - 1;

  ScrollPos := PositionsScrollBox.HorzScrollBar.Position;
  ColPos := ACol * (StringGrid1.DefaultColWidth+1);
  VisibleArea := ScrollPos + PositionsScrollBox.ClientWidth;

  if (ColPos < ScrollPos) or (ColPos >= VisibleArea) or Shift then
    ScrollPos := ColPos;

  PositionsScrollBox.HorzScrollBar.Position := ScrollPos;

  if (TSWindow <> nil) and not IsSinchronizing then begin
    TSWindow.IsSinchronizing := True;
    TSWindow.SelectPosition2(PositionNumber);
    TSWindow.IsSinchronizing := False;
  end;

end;


procedure TMDIChild.SelectPosition;
var
  PrevPatNum: Integer;
begin

  InputPNumber := 0;

  if Pos > VTMP.Positions.Length then
  begin
    PosBegin := TotInts;
    //Label25.Caption := IntsToTime(PosBegin);
    ReCalcTimes(PosBegin);
    UpdateIntsInfo(PosBegin);
    SinchronizeModules;
    Exit;
  end;

  if Pos > VTMP.Positions.Length - 1 then Exit;
  if Pos < 0 then Pos := 0;


  if IsPlaying and (PlayMode = PMPlayModule) and ((PlayingWindow[1] = Self) or ((NumberOfSoundChips > 1) and (PlayingWindow[2] = Self))) then
  begin
    PositionNumber := Pos;
    CalculatePos0;
    RestartPlayingPos(Pos);
  end
  else if not IsPlaying or (PlayMode <> PMPlayPattern) then
  begin
    PositionNumber := Pos;
    CalculatePos0;
    PrevPatNum := PatternNumUpDown.Position;
    PatternNumUpDown.Position := VTMP.Positions.Value[Pos];
    if PrevPatNum = VTMP.Positions.Value[Pos] then
    begin
      Tracks.ShownFrom := 0;
      Tracks.CursorY := Tracks.N1OfLines;
      Tracks.RemoveSelection;
      Tracks.HideMyCaret;
      Tracks.RedrawTracks(0);
      Tracks.SetCaretPosition;
      Tracks.ShowMyCaret;
    end;
  end;

  SinchronizeModules;

end;

procedure TMDIChild.SelectPosition2(ps: Integer);
var
  sel: TGridRect;
  PrevPatNum: Integer;
begin
  if VTMP = nil then
    exit;

  if VTMP.Positions.Length = 0 then
  begin
    sel.Left := 0;
    sel.Right := 0;
    sel.Top := 0;
    sel.Bottom := 0;
    SetStringGrid1Scroll(0);
    StringGrid1.Selection := sel;
    PositionNumber := ps;
    exit;
  end;

  if StringGrid1.Selection.Left <> ps then
  begin

    if ps > VTMP.Positions.Length - 1 then ps := VTMP.Positions.Length - 1;
    if ps < 0 then ps := 0;

    sel.Left := ps;
    sel.Right := ps;
    sel.Top := 0;
    sel.Bottom := 0;
    SetStringGrid1Scroll(ps);
    StringGrid1.Selection := sel;
    InputPNumber := 0;
    PositionNumber := ps;
    CalculatePos0;
  end;

  PrevPatNum := PatternNumUpDown.Position;
  PatternNumUpDown.Position := VTMP.Positions.Value[ps];
  if PrevPatNum = VTMP.Positions.Value[ps] then begin
    //Tracks.ShownFrom := 0;
    //Tracks.CursorY := Tracks.N1OfLines;
    //Tracks.RemoveSelection;
    Tracks.HideMyCaret;
    Tracks.RedrawTracks(0);
    //Tracks.SetCaretPosition;
    Tracks.ShowMyCaret;
  end;
end;

procedure TMDIChild.SelectPositions(SelGrid: TGridRect);
begin
  if SelGrid.Left > 0 then
    if SelGrid.Left >= StringGrid1.LeftCol + StringGrid1.VisibleColCount then
      StringGrid1.LeftCol := SelGrid.Left + 1 - StringGrid1.VisibleColCount
    else if SelGrid.Left < StringGrid1.LeftCol then
      StringGrid1.LeftCol := SelGrid.Left;

  StringGrid1.Selection := SelGrid;
  InputPNumber := 0;
  CalculatePos0;

  PatternsOrderSelection := StringGrid1.Selection;
end;


procedure TMDIChild.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if Tracks.IsTrackPlaying and (ACol >= VTMP.Positions.Length) then
  begin
    ACol := VTMP.Positions.Length-1;
    SelectPosition2(ACol);
  end
  else
  begin
    SetStringGrid1Scroll(ACol);
    SelectPosition(ACol);
  end;

end;

procedure TMDIChild.ChangePositionValue(pos, value: Integer);
var
  s: string;
begin
  SongChanged := True;
  BackupSongChanged := True;
  PositionNumber := pos;
  AddUndo(CAChangePositionValue, VTMP.Positions.Value[pos], value);
  if pos = VTMP.Positions.Length then
    Inc(VTMP.Positions.Length);
  if not UndoWorking then
  begin
    ChangeList[ChangeCount - 1].NewParams.prm.CurrentPosition := pos;
    ChangeList[ChangeCount - 1].OldParams.prm.CurrentPosition := pos;
    ChangeList[ChangeCount - 1].NewParams.prm.PositionListLen := VTMP.Positions.Length;
    ChangeList[ChangeCount - 1].OldGridSelection := StringGrid1.Selection;
    ChangeList[ChangeCount - 1].NewGridSelection := StringGrid1.Selection;
  end;
  VTMP.Positions.Value[pos] := value;
  s := IntToStr(value);
  if pos = VTMP.Positions.Loop then
    s := 'L' + s;
  StringGrid1.Cells[pos, 0] := s;
  CalcTotLen;
  ValidatePattern2(value);
  SelectPosition2(pos);
end;

procedure TMDIChild.ChangePositionValueNoUndo(pos, value: Integer);
var
  s: string;
begin
  SongChanged := True;
  BackupSongChanged := True;
  PositionNumber := pos;
  if pos = VTMP.Positions.Length then
    Inc(VTMP.Positions.Length);
  VTMP.Positions.Value[pos] := value;
  s := IntToStr(value);
  if pos = VTMP.Positions.Loop then
    s := 'L' + s;
  StringGrid1.Cells[pos, 0] := s;
  CalcTotLen;
  ValidatePattern2(value);
  if StringGrid1.Selection.Left <> pos then
    SelectPosition2(pos);
end;

function TMDIChild.GetNewPatternNumber: Integer;
begin
  Result := MaxIntValue(VTMP.Positions.Value) + 1;
  if Result > MaxPatNum then
    Result := -1
  else
    ValidatePattern2(Result);
end;

function TMDIChild.GetNewPatternNumbers(NumNewPatterns: Integer): TIntegersArray;
var
  NewPatternNumber, i: Integer;
  PatternsArray: TIntegersArray;
begin
  SetLength(PatternsArray, 0);
  NewPatternNumber := MaxIntValue(VTMP.Positions.Value) + 1;

  if NewPatternNumber + NumNewPatterns - 1 <= MaxPatNum then
  begin
    SetLength(PatternsArray, NumNewPatterns);
    for i := Low(PatternsArray) to High(PatternsArray) do
    begin
      ValidatePattern2(NewPatternNumber);
      PatternsArray[i] := NewPatternNumber;
      Inc(NewPatternNumber);
    end;
  end;

  Result := PatternsArray;

end;

procedure TMDIChild.IncreaseTrackLength(NumNewPositions: Integer);
var
  i: Integer;
begin
  with VTMP.Positions do
  begin
    Inc(Length, NumNewPositions);
    for i := Length - 1 downto Length - NumNewPositions do
      value[i] := 0;
  end;
end;

procedure TMDIChild.RedrawPatternPositions;
var
  i: Integer;
  s: string;
begin
  for i := 0 to VTMP.Positions.Length - 1 do
  begin
    s := IntToStr(VTMP.Positions.Value[i]);
    if i = VTMP.Positions.Loop then
      s := 'L' + s;
    StringGrid1.Cells[i, 0] := s
  end;

  for i := VTMP.Positions.Length to StringGrid1.ColCount-1 do
    StringGrid1.Cells[i, 0] := '';

  InitStringGridMetrix;

end;


procedure TMDIChild.UnselectPositions;
begin
  StringGrid1.Selection := TGridRect(Rect(-1, -1, -1, -1));
  StringGrid1.Repaint;
end;


procedure TMDIChild.ShiftLoopPosition(Operation, SourceCol, DestCol, NumChangedPositions: Integer);
var
  Loop, SourceColsRight, SourceColsLeft: Integer;
  LoopInsideSelected: Boolean;
begin
  Loop := VTMP.Positions.Loop;
  SourceColsLeft  := SourceCol;
  SourceColsRight := SourceCol + NumChangedPositions - 1;
  LoopInsideSelected := (SourceColsLeft <= Loop) and (SourceColsRight >= Loop);

  if DestCol > VTMP.Positions.Length-1 then
    DestCol := VTMP.Positions.Length-1;

  if (Operation = POS_MOVE) then
  begin
    if not LoopInsideSelected and (SourceColsRight > Loop) and (DestCol <= Loop) then
      Inc(VTMP.Positions.Loop, NumChangedPositions);

    if not LoopInsideSelected and (SourceColsRight < Loop) and (DestCol >= Loop) then
      Dec(VTMP.Positions.Loop, NumChangedPositions);

    if LoopInsideSelected and (DestCol > Loop) then
      Inc(VTMP.Positions.Loop, DestCol - SourceColsRight);

    if LoopInsideSelected and (DestCol < Loop) then
      Dec(VTMP.Positions.Loop, SourceColsLeft - DestCol);
  end

  else if (Operation = POS_COPY) then
  begin
    if (DestCol <= Loop) then
      Inc(VTMP.Positions.Loop, NumChangedPositions);
  end

  else if (Operation = POS_DELETE) then
  begin
    if (SourceColsRight <= Loop) then
      Dec(VTMP.Positions.Loop, NumChangedPositions);
      
    if LoopInsideSelected then
      VTMP.Positions.Loop := 0;
  end;

end;

procedure TMDIChild.SavePositionsUndo;
begin

  // Add undo event 'Insert new position'
  AddUndo(CAInsertPosition, 0, 0);

  // Save current selected track position
  ChangeList[ChangeCount - 1].OldGridSelection := StringGrid1.Selection;

  // Save current selected track position
  ChangeList[ChangeCount - 1].OldParams.prm.CurrentPosition := PositionNumber;

  // Save current pattern number
  ChangeList[ChangeCount - 1].OldParams.prm.CurrentPattern := PatNum;

  // Save cursor position
  ChangeList[ChangeCount - 1].OldParams.prm.PatternCursorX := Tracks.CursorX;
  ChangeList[ChangeCount - 1].OldParams.prm.PatternCursorY := Tracks.CursorY;
  ChangeList[ChangeCount - 1].OldParams.prm.PatternShownFrom := Tracks.ShownFrom;

  // Save current positions array
  New(ChangeList[ChangeCount - 1].PositionList);
  ChangeList[ChangeCount - 1].PositionList^ := VTMP.Positions;
  
end;


procedure TMDIChild.SavePositionsRedo;
begin
  ChangeList[ChangeCount - 1].NewGridSelection := StringGrid1.Selection;
  ChangeList[ChangeCount - 1].NewParams.prm.PatternCursorX := Tracks.CursorX;
  ChangeList[ChangeCount - 1].NewParams.prm.PatternCursorY := Tracks.CursorY;
  ChangeList[ChangeCount - 1].NewParams.prm.PatternShownFrom := Tracks.ShownFrom;
  ChangeList[ChangeCount - 1].NewParams.prm.CurrentPosition := PositionNumber;
  ChangeList[ChangeCount - 1].NewParams.prm.CurrentPattern := PatNum;
end;


procedure TMDIChild.SaveTrackUndo;
var
  i, j, index: Integer;
  SavedPattern: TChangePattern;
begin

  // Add undo event 'Change Positions And Patterns'
  AddUndo(CAChangePositionsAndPatterns, 0, 0);

  // Save current selected track position
  ChangeList[ChangeCount - 1].OldParams.prm.CurrentPosition := PositionNumber;

  // Save current pattern number
  ChangeList[ChangeCount - 1].OldParams.prm.CurrentPattern := PatNum;

  // Save current selected track position
  ChangeList[ChangeCount - 1].OldGridSelection := StringGrid1.Selection;

  // Save current positions array
  New(ChangeList[ChangeCount - 1].PositionList);
  ChangeList[ChangeCount - 1].PositionList^ := VTMP.Positions;

  // Prepare arrays for store previous patterns version
  SetLength(ChangePatternsList, Length(ChangePatternsList)+1);
  SetLength(ChangeNilPatternsList, Length(ChangePatternsList));
  index := High(ChangePatternsList);
  SetLength(ChangePatternsList[index], 2);

  // Save current patterns data
  for i := Low(VTMP.Patterns) to High(VTMP.Patterns) do
  begin

    // Save number of unused pattern
    if VTMP.Patterns[i] = nil then
    begin
      // Increase dynamic array length
      SetLength(ChangeNilPatternsList[index], Length(ChangeNilPatternsList[index])+1);

      // Get last index
      j := High(ChangeNilPatternsList[index]);

      // Save nil-pattern number
      ChangeNilPatternsList[index][j] := i;
    end

    // Save used pattern data
    else
    begin
      // Prepare structure
      SavedPattern.Number := i;
      SavedPattern.Pattern.Items  := VTMP.Patterns[i].Items;
      SavedPattern.Pattern.Length := VTMP.Patterns[i].Length;

      // Increase array length
      SetLength(ChangePatternsList[index][0], Length(ChangePatternsList[index][0])+1);

      // Get last index
      j := High(ChangePatternsList[index][0]);

      // Save pattern
      ChangePatternsList[index][0][j] := SavedPattern;
    end;

  end;

  New(ChangeList[ChangeCount - 1].ComParams.Patterns);
  New(ChangeList[ChangeCount - 1].ComParams.NilPatterns);
  ChangeList[ChangeCount - 1].ComParams.Patterns^ := ChangePatternsList[index];
  ChangeList[ChangeCount - 1].ComParams.NilPatterns^ := ChangeNilPatternsList[index];

end;

procedure TMDIChild.SaveTrackRedo;
var
  i, j, index: Integer;
  SavedPattern: TChangePattern;
begin

  index := High(ChangePatternsList);

  // Save new patterns data
  for i := Low(VTMP.Patterns) to High(VTMP.Patterns) do
  begin

    // Save number of unused pattern
    if VTMP.Patterns[i] <> nil then
    begin
      // Prepare structure
      SavedPattern.Number := i;
      SavedPattern.Pattern.Items  := VTMP.Patterns[i].Items;
      SavedPattern.Pattern.Length := VTMP.Patterns[i].Length;

      // Increase array length
      SetLength(ChangePatternsList[index][1], Length(ChangePatternsList[index][1])+1);

      // Get last index
      j := High(ChangePatternsList[index][1]);

      // Save pattern
      ChangePatternsList[index][1][j] := SavedPattern;
    end;
  end;

  ChangeList[ChangeCount - 1].NewGridSelection := StringGrid1.Selection;
  ChangeList[ChangeCount - 1].NewParams.prm.CurrentPosition  := PositionNumber;
  ChangeList[ChangeCount - 1].NewParams.prm.PatternCursorX   := Tracks.CursorX;
  ChangeList[ChangeCount - 1].NewParams.prm.PatternCursorY   := Tracks.CursorY;
  ChangeList[ChangeCount - 1].NewParams.prm.PatternShownFrom := Tracks.ShownFrom;
  ChangeList[ChangeCount - 1].NewParams.prm.CurrentPattern   := PatNum;
end;


procedure TMDIChild.SavePatternUndo;
var index: Integer;
begin
  // Add undo event 'Change Positions And Patterns'
  AddUndo(CAChangePatternContent, 0, 0);

  // Save current selected track position
  ChangeList[ChangeCount - 1].OldParams.prm.CurrentPosition := PositionNumber;
  ChangeList[ChangeCount - 1].NewParams.prm.CurrentPosition := PositionNumber;

  // Save current pattern number
  ChangeList[ChangeCount - 1].OldParams.prm.CurrentPattern := PatNum;
  ChangeList[ChangeCount - 1].NewParams.prm.CurrentPattern := PatNum;

  // Save current selected track position
  ChangeList[ChangeCount - 1].OldGridSelection := StringGrid1.Selection;
  ChangeList[ChangeCount - 1].NewGridSelection := StringGrid1.Selection;

  // Increase array
  SetLength(ChangeOnePatternList, Length(ChangeOnePatternList)+1);
  index := High(ChangeOnePatternList);

  // Save current pattern state
  ChangeOnePatternList[index].OldPattern.Length := Tracks.ShownPattern.Length;
  ChangeOnePatternList[index].OldPattern.Items  := Tracks.ShownPattern.Items;


end;


procedure TMDIChild.SavePatternRedo;
var index: Integer;
begin
  index := High(ChangeOnePatternList);

  // Save result pattern state
  ChangeOnePatternList[index].NewPattern.Length := Tracks.ShownPattern.Length;
  ChangeOnePatternList[index].NewPattern.Items  := Tracks.ShownPattern.Items;

  New(ChangeList[ChangeCount - 1].ComParams.ChangedPattern);
  ChangeList[ChangeCount - 1].ComParams.ChangedPattern^ := ChangeOnePatternList[index];
  ChangeList[ChangeCount - 1].NewParams.prm.CurrentPattern   := PatNum;
  ChangeList[ChangeCount - 1].NewParams.prm.PatternCursorX   := Tracks.CursorX;
  ChangeList[ChangeCount - 1].NewParams.prm.PatternCursorY   := Tracks.CursorY;
  ChangeList[ChangeCount - 1].NewParams.prm.PatternShownFrom := Tracks.ShownFrom;
end;


procedure TMDIChild.SaveSampleUndo(Sample: PSample);
var index: Integer;
begin
  if Sample = nil then Exit;
  if Samples.UndoSaved then Exit;

  SongChanged := True;
  BackupSongChanged := True;

  AddUndo(CAChangeEntireSample, 0, 0);
  ChangeList[ChangeCount - 1].OldParams.prm.SampleShownFrom := Samples.ShownFrom;
  ChangeList[ChangeCount - 1].OldParams.prm.SampleCursorX := Samples.CursorX;
  ChangeList[ChangeCount - 1].OldParams.prm.SampleCursorY := Samples.CursorY;

  SetLength(ChangeSamplesList, Length(ChangeSamplesList)+1);
  index := High(ChangeSamplesList);

  ChangeSamplesList[index].Number := SampleNumUpDown.Position;
  ChangeSamplesList[index].OldSample.Length := Sample.Length;
  ChangeSamplesList[index].OldSample.Loop := Sample.Loop;
  ChangeSamplesList[index].OldSample.Enabled := Sample.Enabled;
  ChangeSamplesList[index].OldSample.Items := Sample.Items;

  Samples.UndoSaved := True;
end;

procedure TMDIChild.SaveSampleRedo;
var index: Integer;
begin
  if not Samples.UndoSaved then Exit;

  ChangeList[ChangeCount - 1].NewParams.prm.SampleShownFrom := Samples.ShownFrom;
  ChangeList[ChangeCount - 1].NewParams.prm.SampleCursorX := Samples.CursorX;
  ChangeList[ChangeCount - 1].NewParams.prm.SampleCursorY := Samples.CursorY;

  index := High(ChangeSamplesList);

  ChangeSamplesList[index].NewSample.Length  := Samples.ShownSample.Length;
  ChangeSamplesList[index].NewSample.Loop    := Samples.ShownSample.Loop;
  ChangeSamplesList[index].NewSample.Enabled := Samples.ShownSample.Enabled;
  ChangeSamplesList[index].NewSample.Items   := Samples.ShownSample.Items;

  New(ChangeList[ChangeCount - 1].ComParams.EntireSample);
  ChangeList[ChangeCount - 1].ComParams.EntireSample^ := ChangeSamplesList[index];

  Samples.UndoSaved := False;
end;


procedure TMDIChild.SaveOrnamentUndo;
var
  index: Integer;
begin
  if Ornaments.UndoSaved then Exit;

  AddUndo(CAChangeEntireOrnament, 0, 0);
  ChangeList[ChangeCount - 1].OldParams.prm.OrnamentShownFrom := Ornaments.ShownFrom;
  ChangeList[ChangeCount - 1].OldParams.prm.OrnamentCursor := Ornaments.Cursor;

  SetLength(ChangeOrnamentsList, Length(ChangeOrnamentsList)+1);
  index := High(ChangeOrnamentsList);

  ChangeOrnamentsList[index].Number := SampleNumUpDown.Position;
  if Ornaments.ShownOrnament <> nil then
  begin
    ChangeOrnamentsList[index].OldOrnament.Length := Ornaments.ShownOrnament.Length;
    ChangeOrnamentsList[index].OldOrnament.Loop := Ornaments.ShownOrnament.Loop;
    ChangeOrnamentsList[index].OldOrnament.Items := Ornaments.ShownOrnament.Items;
  end
  else
  begin
    ChangeOrnamentsList[index].OldOrnament.Length := 1;
    ChangeOrnamentsList[index].OldOrnament.Loop := 0;
  end;

  Ornaments.UndoSaved := True;
end;


procedure TMDIChild.SaveOrnamentRedo;
var index: Integer;
begin
  if not Ornaments.UndoSaved then Exit;
  
  ChangeList[ChangeCount - 1].NewParams.prm.OrnamentShownFrom := Ornaments.ShownFrom;
  ChangeList[ChangeCount - 1].NewParams.prm.OrnamentCursor := Ornaments.Cursor;

  index := High(ChangeOrnamentsList);

  ValidateOrnament(OrnamentNumUpDown.Position);

  ChangeOrnamentsList[index].NewOrnament.Length := Ornaments.ShownOrnament.Length;
  ChangeOrnamentsList[index].NewOrnament.Loop := Ornaments.ShownOrnament.Loop;
  ChangeOrnamentsList[index].NewOrnament.Items := Ornaments.ShownOrnament.Items;

  New(ChangeList[ChangeCount - 1].ComParams.EntireOrnament);
  ChangeList[ChangeCount - 1].ComParams.EntireOrnament^ := ChangeOrnamentsList[index];

  Ornaments.UndoSaved := False;
end;


procedure TMDIChild.ShiftPositionsToRight(FromPos, NumNewPositions: Integer);
var i: Integer;
begin
  // Shift positions and colors to the right
  for i := VTMP.Positions.Length - 1 downto FromPos do
  begin
    VTMP.Positions.Value[i] := VTMP.Positions.Value[i - NumNewPositions];
    VTMP.Positions.Colors[i] := VTMP.Positions.Colors[i - NumNewPositions];
  end;
end;

procedure TMDIChild.ShiftPositionsToLeft(FromPos, ToPos: Integer);
var i, PositionShift: Integer;
begin
  PositionShift := FromPos - ToPos;

  // Shift positions and colors to the left
  for i := ToPos to VTMP.Positions.Length - PositionShift - 1 do
  begin
    VTMP.Positions.Value[i] := VTMP.Positions.Value[i + PositionShift];
    VTMP.Positions.Colors[i] := VTMP.Positions.Colors[i + PositionShift];
  end;
end;

procedure TMDIChild.InsertPosition(Duplicate, MakeUndo, ChangePosition: boolean);
var
  i: Integer;
  DestCol, NumNewPositions, NewPatternNumber, LastPatternNumber, PatternLength: Integer;
  SelectLeft, SelectRight, TrackLength: Integer;
  SavedPositions, SavedPositionsColors: array of Integer;
begin
  NewPatternNumber := 0;

  // Shortcuts
  SelectLeft := StringGrid1.Selection.Left;
  SelectRight := StringGrid1.Selection.Right;
  TrackLength := VTMP.Positions.Length;

  // Selected position > Track length?
  if (SelectRight > TrackLength) then
    Exit;

  if Duplicate then
    // Number of new positions is Right selection pos - Left selection pos + 1
    NumNewPositions := SelectRight - SelectLeft + 1
  else
  begin
    NumNewPositions := 1;
    SelectLeft := SelectRight;
  end;


  // Current track length + num new positions > Max track length?
  if TrackLength + NumNewPositions - 1 > MaxPosNum then
    Exit;

  // Save positions state for undo
  if MakeUndo and Duplicate then
    SavePositionsUndo;
  if MakeUndo and not Duplicate then
    SaveTrackUndo;

  // Check new pattern number
  if not Duplicate then
  begin
    // Get new pattern number
    NewPatternNumber := GetNewPatternNumber;

    // Is new pattern number > Max pattern number?
    if NewPatternNumber = -1 then
      Exit;
  end;


  // Get length of last pattern
  if SelectLeft > 0 then
    LastPatternNumber := VTMP.Positions.Value[SelectLeft-1]
  else
    LastPatternNumber := VTMP.Positions.Value[SelectLeft];
  PatternLength := VTMP.Patterns[LastPatternNumber].Length;

  // Change pattern length
  if not Duplicate and MakeUndo and ChangePosition then
    VTMP.Patterns[NewPatternNumber].Length := PatternLength;

  // Index for new position(s) in positions array
  DestCol := SelectRight + 1;

  // Increase track length
  IncreaseTrackLength(NumNewPositions);
  SongChanged := True;
  BackupSongChanged := True;

  // Save position values and colors if duplicate
  if Duplicate then
  begin
    SetLength(SavedPositions, NumNewPositions);
    SetLength(SavedPositionsColors, NumNewPositions);
    for i := Low(SavedPositions) to High(SavedPositions) do
    begin
      SavedPositions[i] := VTMP.Positions.Value[SelectLeft + i];
      SavedPositionsColors[i] := VTMP.Positions.Colors[SelectLeft + i];
    end;
  end;

  // Shift positions and colors to the right
  ShiftPositionsToRight(DestCol, NumNewPositions);

  // Shift loop
  ShiftLoopPosition(POS_COPY, SelectLeft, DestCol, NumNewPositions);

  // Insert new positions OR duplicete selected positions/colors
  if Duplicate then
    for i := Low(SavedPositions) to High(SavedPositions) do
    begin
      VTMP.Positions.Value[DestCol + i] := SavedPositions[i];
      VTMP.Positions.Colors[DestCol + i] := SavedPositionsColors[i];
    end
  else
  begin
    VTMP.Positions.Value[DestCol] := NewPatternNumber;
    VTMP.Positions.Colors[DestCol] := 0;
  end;

  // Redraw StringGrid1 positions
  RedrawPatternPositions;

  // Select inserted positions
  if ChangePosition then
    PositionMakeSelection(DestCol, DestCol + NumNewPositions - 1);

  // Set positions scrollbar
  SetStringGrid1Scroll(-1);

  // Recalculate track length
  CalcTotLen;
  InputPNumber := 0;

  // Set pattern editor cursor to the first line and on the channel A note.
  if Duplicate then
  begin
    Tracks.ShownFrom := 0;
    Tracks.CursorX := 8;
    Tracks.CursorY := Tracks.N1OfLines;
  end;

  // Save information for REDO
  if MakeUndo and Duplicate then
    SavePositionsRedo;
  if MakeUndo and not Duplicate then
    SaveTrackRedo;

end;

procedure TMDIChild.ClonePositions;
var
  i: Integer;
  DestCol, NumNewPositions: Integer;
  SelectLeft, SelectRight, TrackLength: Integer;
  SavedPositions, SavedPositionsColors: array of Integer;
  NewPatternNumbers: TIntegersArray;
begin
  // Shortcuts
  SelectLeft := StringGrid1.Selection.Left;
  SelectRight := StringGrid1.Selection.Right;
  TrackLength := VTMP.Positions.Length;
  SetLength(NewPatternNumbers, 0);

  // Selected position > Track length?
  if (SelectRight > TrackLength) then
    Exit;

  // Num new positions
  NumNewPositions := SelectRight - SelectLeft + 1;

  // Current track length + num new positions > Max track length?
  if TrackLength + NumNewPositions - 1 > MaxPosNum then
    Exit;

  // Save positions and patterns state for UNDO
  SaveTrackUndo;

  // Get new pattern numbers
  NewPatternNumbers := GetNewPatternNumbers(NumNewPositions);

  // Is one of new pattern numbers > Max pattern number?
  if Length(NewPatternNumbers) = 0 then
    Exit;

  // Index of new position(s) in positions array
  DestCol := SelectRight + 1;

  // Increase track length
  IncreaseTrackLength(NumNewPositions);
  SongChanged := True;
  BackupSongChanged := True;

  // Save position values and colors
  SetLength(SavedPositions, NumNewPositions);
  SetLength(SavedPositionsColors, NumNewPositions);
  for i := Low(SavedPositions) to High(SavedPositions) do
  begin
    SavedPositions[i] := VTMP.Positions.Value[SelectLeft + i];
    SavedPositionsColors[i] := VTMP.Positions.Colors[SelectLeft + i];
  end;

  // Shift positions and colors to the right
  ShiftPositionsToRight(DestCol, NumNewPositions);

  // Shift loop
  ShiftLoopPosition(POS_COPY, SelectLeft, DestCol, NumNewPositions);

  // Clone old patterns to new patterns
  for i := Low(NewPatternNumbers) to High(NewPatternNumbers) do
  begin
    CloneAndCopyPattern(SavedPositions[i], NewPatternNumbers[i]);
    VTMP.Positions.Value[DestCol + i] := NewPatternNumbers[i];
    VTMP.Positions.Colors[DestCol + i] := SavedPositionsColors[i];
  end;

  // Redraw StringGrid1 positions
  RedrawPatternPositions;

  // Select inserted positions
  PositionMakeSelection(DestCol, DestCol + NumNewPositions - 1);

  // Set positions scroll
  SetStringGrid1Scroll(-1);

  // Recalculate track length
  CalcTotLen;

  InputPNumber := 0;

  // Set pattern editor cursor to the first line and on the channel A note.
  Tracks.ShownFrom := 0;
  Tracks.CursorX := 8;
  Tracks.CursorY := Tracks.N1OfLines;

  // Save new patterns state for UNDO
  SaveTrackRedo;

end;

procedure TMDIChild.DeletePositions;
var
  i, SelectLeft, SelectRight, NumSelected, TrackLength: Integer;
begin
  // Shortcuts
  SelectLeft  := StringGrid1.Selection.Left;
  SelectRight := StringGrid1.Selection.Right;
  NumSelected := SelectRight - SelectLeft + 1;
  TrackLength := VTMP.Positions.Length;

  if (SelectLeft < 0) or (SelectRight < 0) or (VTMP.Positions.Length = 1) then
    Exit;

  // Save UNDO information
  SongChanged := True;
  BackupSongChanged := True;
  AddUndo(CADeletePosition, 0, 0);
  ChangeList[ChangeCount - 1].OldParams.prm.CurrentPosition := PositionNumber;
  ChangeList[ChangeCount - 1].OldGridSelection := StringGrid1.Selection;
  ChangeList[ChangeCount - 1].OldParams.prm.CurrentPattern := PatNum;
  New(ChangeList[ChangeCount - 1].PositionList);
  ChangeList[ChangeCount - 1].PositionList^ := VTMP.Positions;

  // Shift pattern positions
  ShiftPositionsToLeft(SelectRight+1, SelectLeft);

  // Zerofill last positions
  for i := TrackLength - 1 downto TrackLength - NumSelected do
  begin
    VTMP.Positions.Value[i]  := 0;
    VTMP.Positions.Colors[i] := 0;
  end;

  // Decrease track length
  Dec(VTMP.Positions.Length, NumSelected);

  // Shift loop
  ShiftLoopPosition(POS_DELETE, SelectLeft, SelectRight, NumSelected);

  UnselectPositions;
  RedrawPatternPositions;
  CalcTotLen;
  InputPNumber := 0;

  // Change position and pattern
  if SelectLeft = VTMP.Positions.Length then
    Dec(SelectLeft);
  SelectPosition2(SelectLeft);

  // Set pattern editor cursor to the first line and on the channel A note.
  Tracks.ShownFrom := 0;
  Tracks.CursorX := 8;
  Tracks.CursorY := Tracks.N1OfLines;

  // Save grid selection for REDO
  SavePositionsRedo;

end;

procedure TMDIChild.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    '0'..'9':
      if not (IsPlaying and (PlayMode = PMPlayModule) and ((PlayingWindow[1] = Self) or ((NumberOfSoundChips = 2) and (PlayingWindow[2] = Self)))) and (StringGrid1.Selection.Left <= VTMP.Positions.Length) then
      begin
        InputPNumber := InputPNumber * 10 + Ord(Key) - Ord('0');
        if InputPNumber > MaxPatNum then
          InputPNumber := Ord(Key) - Ord('0');
        ChangePositionValue(StringGrid1.Selection.Left, InputPNumber);
        RedrawPatternPositions;
        exit
      end
  end;
  InputPNumber := 0;
end;

procedure TMDIChild.PatternNumEditExit(Sender: TObject);
begin
  PatternNumEdit.Text := IntToStr(PatternNumUpDown.Position);
end;

procedure TMDIChild.InitStringGridMetrix;
var
  DC: HDC;
  sz: tagSIZE;
  i: Integer;
  VisibleColCount, ColCount: Integer;
  p: HFONT;
  

begin

  PosArrowHShift := -1;
  StringGridTextHShift := 0;

  case PositionSize of
    0: begin
      StringGrid1.Font.Size := 8;
      PosArrowSize       := 5;
      PosArrowVShift     := 0;
      PosArrowHShift     := -2;
      StringGridTextVShift := 0;
      StringGridTextHShift := 1;
      StringGridAddHeight  := 0;
    end;
    1: begin
      StringGrid1.Font.Size := 10;
      PosArrowSize         := 7;
      StringGridTextVShift := -1;
      StringGridAddHeight  := -1;
      PosArrowVShift       := 1;
    end;
    2: begin
      StringGrid1.Font.Size := 12;
      PosArrowSize         := 8;
      StringGridTextVShift := 1;
      StringGridAddHeight  := 0;
      PosArrowVShift       := 1;
    end;
    3: begin
      StringGrid1.Font.Size := 14;
      PosArrowSize       := 9;
      StringGridTextVShift := 0;
      StringGridAddHeight  := 0;
      StringGridTextHShift := 1;
      PosArrowVShift       := 1;
      PosArrowHShift       := -2;
    end;
    4: begin
      StringGrid1.Font.Size := 16;
      PosArrowSize       := 9;
      StringGridTextVShift := 0;
      StringGridAddHeight  := -1;
      PosArrowVShift     := 1;
    end;
    5: begin
      StringGrid1.Font.Size := 18;
      PosArrowSize       := 12;
      StringGridTextVShift := 1;
      StringGridAddHeight  := 2;
      PosArrowVShift     := 2;
    end;
  end;

  
  DC := GetDC(Handle);
  p := SelectObject(DC, StringGrid1.Font.Handle);
  GetTextExtentPoint32(DC, '0', 1, sz);
  StringGridCelW := sz.cx;
  StringGridCelH := sz.cy;

  StringGrid1.DefaultColWidth := (StringGridCelW * 3) + 4;
  StringGrid1.DefaultRowHeight :=  StringGridCelH + 10 + StringGridAddHeight;

  VisibleColCount := PositionsScrollBox.Width div StringGrid1.DefaultColWidth;
  ColCount := VTMP.Positions.Length;

  // Add empty cells
  if ColCount >= VisibleColCount then Inc(ColCount);
  if ColCount < VisibleColCount  then ColCount := VisibleColCount;
  if ((StringGrid1.DefaultColWidth+1) * ColCount) < PositionsScrollBox.ClientWidth then
    Inc(ColCount);

  StringGrid1.ColCount := ColCount;
  for i := 0 to StringGrid1.ColCount-1 do
    if StringGrid1.Cells[i, 0] = '' then
      StringGrid1.Cells[i, 0] := '...';    


  StringGrid1.Width := (StringGrid1.DefaultColWidth+1) * ColCount - 1;
  PositionsScrollBox.AutoScroll := False;
  PositionsScrollBox.HorzScrollBar.Range := StringGrid1.Width+1;
  PositionsScrollBox.Height := StringGrid1.DefaultRowHeight + HScrollbarSize + 5;

  SelectObject(DC, p);
  ReleaseDC(Handle, DC);
end;

procedure TMDIChild.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  S: string;
  SavedAlign: word;
  LoopCell, LightBg: Boolean;
  PosNumberX, PosNumberY: Integer;
  PrevFont: TFont;
  FontColor, PrevColor: TColor;
  ARect: TRect;
begin

  if VTMP = nil then
    Exit;

  with StringGrid1 do
  begin

    case VTMP.Positions.Colors[ACol] of
      0:  Canvas.Brush.Color := clWhite;            // White
      1:  Canvas.Brush.Color := TColor($002525BA);  // Red
      2:  Canvas.Brush.Color := TColor($003A8330);  // Green
      3:  Canvas.Brush.Color := TColor($0095483E);  // Blue
      4:  Canvas.Brush.Color := TColor($002958A5);  // Maroon
      5:  Canvas.Brush.Color := TColor($00914899);  // Purple
      6:  Canvas.Brush.Color := TColor($00727272);  // Gray
      7:  Canvas.Brush.Color := TColor($008F8C0E);  // Teal
      8:  Canvas.Brush.Color := TColor(clBlack);    // Black
      9:  Canvas.Brush.Color := TColor($008CFFFF);  // Light1
      10: Canvas.Brush.Color := TColor($00CDCDFF);  // Light2
      11: Canvas.Brush.Color := TColor($00FFCAFA);  // Light3
      12: Canvas.Brush.Color := TColor($00B9FFB7);  // Light4
      13: Canvas.Brush.Color := TColor($00FFC6C6);  // Light5      
    end;
    LightBg := ((VTMP.Positions.Colors[ACol] > 8) or (VTMP.Positions.Colors[ACol] = 0)) and not (gdSelected in State);


    if (Canvas.Brush.Color = clWhite) or LightBg then
      FontColor := clBlack
    else
      FontColor := clWhite;

    if gdSelected in State then
    begin
      FontColor := clWhite;
      Canvas.Brush.Color := TColor($00422106);
    end;


    S := Cells[ACol, ARow]; // cell content

    if S[1] = 'L' then
    begin
      S := AnsiRightStr(S, Length(S)-1);
      LoopCell := True;
    end
    else
      LoopCell := False;

    Canvas.FillRect(Rect);
    SavedAlign := SetTextAlign(Canvas.Handle, TA_CENTER);


    PosNumberX := (Rect.Left + (Rect.Right - Rect.Left) div 2) + StringGridTextHShift;
    PosNumberY := Rect.Top + 5 + StringGridTextVShift;
    SetTextColor(Canvas.Handle, FontColor);

    // Empty cell
    if S = '...' then begin
      Canvas.Brush.Color := FontColor;

      ARect.Top := DefaultRowHeight - PosArrowSize - 2;
      if PositionSize < 2 then
        ARect.Bottom := ARect.Top + 1
      else
        ARect.Bottom := ARect.Top + 2;

      ARect.Left := PosNumberX - 7;
      if PositionSize = 0 then ARect.Left := ARect.Left + 3;
      if PositionSize = 1 then ARect.Left := ARect.Left + 2;

      ARect.Right := ARect.Left + 2;
      Canvas.FillRect(ARect);

      if PositionSize < 2 then
        ARect.Left := ARect.Left + 4
      else
        ARect.Left := ARect.Left + 6;
      ARect.Right  := ARect.Left + 2;
      Canvas.FillRect(ARect);

      if PositionSize < 2 then
        ARect.Left := ARect.Left + 4
      else
        ARect.Left := ARect.Left + 6;
      ARect.Right  := ARect.Left + 2;
      Canvas.FillRect(ARect);

      Exit;
    end
    else
      Canvas.TextRect(Rect, PosNumberX, PosNumberY, S);

    SetTextAlign(Canvas.Handle, SavedAlign);


    if LoopCell then
    begin
      PrevFont := Font;
      Canvas.Font.Name := 'Arrows';
      Canvas.Font.Size := PosArrowSize;

      if LightBg then
        FontColor := TColor($000D0DA4)
      else
        FontColor := clWhite;

      SetTextColor(Canvas.Handle, FontColor);
      //if PositionSize = 0 then

      Canvas.TextOut(PosNumberX - (StringGridCelW div 2) + PosArrowHShift, -1, '4');

      // Win95/98/ME fix
      if Win32MajorVersion = 4 then
      begin
        ARect.Left := PosNumberX - (StringGridCelW div 2) - 1;
        ARect.Top := -1;
        ARect.Right := ARect.Left + 1;
        ARect.Bottom := PosArrowSize;
        Canvas.FillRect(ARect);
        ARect.Bottom := 1;
        PrevColor := Canvas.Brush.Color;
        Canvas.Brush.Color := FontColor;
        Canvas.FillRect(ARect);
        Canvas.Brush.Color := PrevColor;
      end;

      Canvas.Font := PrevFont;
    end;


    // Current cell
    if (gdSelected in State) and (ACol = PositionNumber) then
    begin
      PrevFont := Font;
      Canvas.Font.Name := 'Arrows';
      Canvas.Font.Size := PosArrowSize;
      SetTextColor(Canvas.Handle, clWhite);
      Canvas.TextOut(
        // X coord
        PosNumberX - (StringGridCelW div 2) + PosArrowHShift,
        // Y coord
        DefaultRowHeight - PosArrowSize + PosArrowVShift,
        // Triangle symbol char
        '3');
      Canvas.Font := PrevFont;

      // Win95/98/ME fix
      if Win32MajorVersion = 4 then
      begin
        ARect.Left := PosNumberX - (StringGridCelW div 2) - 1;
        ARect.Top := StringGridCelH + 3;
        ARect.Right := ARect.Left + 1;
        ARect.Bottom := ARect.Top + PosArrowSize;
        Canvas.FillRect(ARect);
      end;
    end;

  end;
end;

procedure TMDIChild.StringGrid1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  sel: TGridRect;
begin

  // If selected range is bigger than track length
  if (StringGrid1.Selection.Right > StringGrid1.Selection.Left) and (StringGrid1.Selection.Right > VTMP.Positions.Length - 1) then
  begin
    SelectPosition2(VTMP.Positions.Length - 1);
    sel := StringGrid1.Selection;
    sel.Right := sel.Left;
    StringGrid1.Selection := sel;
    PatternsOrderSelection := StringGrid1.Selection;
  end;

  // Prevent to change position if playing only current pattern
  if IsPlaying and (PlayMode = PMPlayPattern) then
  begin
    sel.Left := PositionNumber;
    sel.Right := PositionNumber;
    sel.Top := 0;
    sel.Bottom := 0;
    StringGrid1.Selection := sel;
  end;

end;

procedure TMDIChild.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  x1, y1, SourceCol: Integer;
  sel: TGridRect;
begin
  if (Button = mbRight) then
  begin
    if (StringGrid1.Selection.Left = StringGrid1.Selection.Right) and (not IsPlaying and (PlayMode <> PMPlayPattern)) then
    begin
      StringGrid1.MouseToCell(X, Y, x1, y1);
      sel.Left := x1;
      sel.Right := x1;
      sel.Top := y1;
      sel.Bottom := y1;
      StringGrid1.Selection := sel;
    end;
    PatternsOrderSelection := StringGrid1.Selection;
  end;

  // Prevent to change position if playing only current pattern
  if IsPlaying and (PlayMode = PMPlayPattern) then
  begin
    sel.Left := PositionNumber;
    sel.Right := PositionNumber;
    sel.Top := 0;
    sel.Bottom := 0;
    StringGrid1.Selection := sel;
  end;

  if (Button = mbLeft) then
  begin
    // If track is playing, then do nothing
    if IsPlaying and (PlayMode in [PMPlayModule, PMPlayPattern]) then
      Exit;

    // If empty pattern selected
    if StringGrid1.Selection.Right > VTMP.Positions.Length - 1 then
      Exit; 

    // If Shift Key is pressed, then save selection range in special variable
    if ssShift in Shift then
      PatternsOrderSelection := StringGrid1.Selection;

    StringGrid1.MouseToCell(X, Y, SourceCol, y1);
    if SourceCol >= 0 then
      StringGrid1.BeginDrag(False, 2);
  end;

end;

procedure TMDIChild.PositionMakeSelection(FromPos, ToPost: byte);
var
  sel: TGridRect;
begin
  sel.Left := FromPos;
  sel.Right := ToPost;
  sel.Top := 0;
  sel.Bottom := 0;
  StringGrid1.Selection := sel;
  PatternsOrderSelection := StringGrid1.Selection;

  PatNum := VTMP.Positions.Value[sel.Left];
  PositionNumber := sel.Left;
  ChangePattern(PatNum);
  PatternNumUpDown.Position := PatNum;
end;

procedure TMDIChild.CloneAndCopyPattern(SrcPatternNumber, NewPatternNumber: byte);
begin
  if NewPatternNumber > MaxPatNum then
    exit;

  // Create pattern and set length
  ValidatePattern2(NewPatternNumber);
  VTMP.Patterns[NewPatternNumber].Length := VTMP.Patterns[SrcPatternNumber].Length;
  CheckTracksAfterSizeChanged(NewPatternNumber);

  // Copy pattern data from src to dest by Track Manager
  TrMng.CheckBox1.Checked := True;  // Flag: copy envelope data ON
  TrMng.CheckBox2.Checked := True;  // Flag: copy noise data ON
  TrMng.TracksOp(SrcPatternNumber, 0, 0, NewPatternNumber, 0, 0, 0, False);  // Copy chan A
  TrMng.TracksOp(SrcPatternNumber, 0, 1, NewPatternNumber, 0, 1, 0, False);  // Copy chan B
  TrMng.TracksOp(SrcPatternNumber, 0, 2, NewPatternNumber, 0, 2, 0, False);  // Copy chan C
  TrMng.CheckBox1.Checked := False;
  TrMng.CheckBox2.Checked := False;
end;

procedure TMDIChild.StringGrid1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  i: Integer;
  DestCol, DestRow: Integer;
  SourceCol, SourceColEnd: Integer;
  NumSelectedCols, TrackLength: Integer;
  SourceColsContent, SourceColsColors: array of Integer;
  ControlPressed, ShiftPressed: Boolean;
  OperationType: Integer;


  procedure MoveItemsFromLeftToRight();
  var
    i: Integer;
  begin
    with StringGrid1 do
    begin
      // Shift columns to left
      for i := SourceCol to DestCol - NumSelectedCols do
      begin
        VTMP.Positions.Value[i]  := VTMP.Positions.Value[i + NumSelectedCols];
        VTMP.Positions.Colors[i] := VTMP.Positions.Colors[i + NumSelectedCols];
      end;

      // Copy stored selected columns to dest columns
      for i := 0 to NumSelectedCols - 1 do
      begin
        VTMP.Positions.Value[DestCol + 1 - NumSelectedCols + i]  := SourceColsContent[i];
        VTMP.Positions.Colors[DestCol + 1 - NumSelectedCols + i] := SourceColsColors[i];
      end;

      PositionMakeSelection(DestCol - NumSelectedCols + 1, DestCol);
    end;
  end;

  procedure MoveItemsFromLeftToRight2();
  var
    i: Integer;
  begin
    with StringGrid1 do
    begin
      // Destination column = End of soundtrack
      DestCol := VTMP.Positions.Length;

      // Shift columns to left
      for i := SourceCol to DestCol - NumSelectedCols - 1 do
      begin
        VTMP.Positions.Value[i]  := VTMP.Positions.Value[i + NumSelectedCols];
        VTMP.Positions.Colors[i] := VTMP.Positions.Colors[i + NumSelectedCols];
      end;

      // Copy stored selected columns to dest columns
      for i := 0 to NumSelectedCols - 1 do
      begin
        VTMP.Positions.Value[DestCol - NumSelectedCols + i]  := SourceColsContent[i];
        VTMP.Positions.Colors[DestCol - NumSelectedCols + i] := SourceColsColors[i];
      end;

      PositionMakeSelection(DestCol - NumSelectedCols, DestCol - 1);
    end;
  end;

  procedure MoveItemsFromRightToLeft();
  var
    i: Integer;
  begin
    with StringGrid1 do
    begin
      // Shift columns to right
      for i := SourceCol + NumSelectedCols - 1 downto DestCol + NumSelectedCols - 1 do
      begin
        VTMP.Positions.Value[i]  := VTMP.Positions.Value[i - NumSelectedCols];
        VTMP.Positions.Colors[i] := VTMP.Positions.Colors[i - NumSelectedCols];
      end;

      // Copy stored selected columns to dest columns
      for i := 0 to NumSelectedCols - 1 do
      begin
        VTMP.Positions.Value[DestCol + i]  := SourceColsContent[i];
        VTMP.Positions.Colors[DestCol + i] := SourceColsColors[i];
      end;

      PositionMakeSelection(DestCol, DestCol + NumSelectedCols - 1);
    end;
  end;

  procedure CopyItemsFromLeftToRight();
  var
    i: Integer;
  begin
    with StringGrid1 do
    begin
      // Increase track length
      IncreaseTrackLength(NumSelectedCols);

      // Shift patterns to right FROM DestCol to end
      ShiftPositionsToRight(DestCol + 1, NumSelectedCols);

      // Copy selected patterns to DestCol
      for i := 0 to NumSelectedCols - 1 do
      begin
        VTMP.Positions.Value[DestCol + 1 + i]  := SourceColsContent[i];
        VTMP.Positions.Colors[DestCol + 1 + i] := SourceColsColors[i];
      end;

      PositionMakeSelection(DestCol + 1, DestCol + NumSelectedCols);
    end;
  end;

  procedure CopyItemsFromLeftToRight2();
  var
    i: Integer;
  begin
    with StringGrid1 do
    begin
      // Destination column = End of soundtrack
      DestCol := VTMP.Positions.Length;

      // Increase soundtrack length
      IncreaseTrackLength(NumSelectedCols);

      // Copy selected patterns to DestCol
      for i := 0 to NumSelectedCols - 1 do
      begin
        VTMP.Positions.Value[DestCol + i]  := SourceColsContent[i];
        VTMP.Positions.Colors[DestCol + i] := SourceColsColors[i];
      end;

      PositionMakeSelection(DestCol, DestCol + NumSelectedCols - 1);
    end;
  end;

  procedure CopyItemsFromRightToLeft();
  var
    i: Integer;
  begin
    with StringGrid1 do
    begin
      // Increase soundtrack length
      IncreaseTrackLength(NumSelectedCols);

      // Shift columns to right
      ShiftPositionsToRight(DestCol + NumSelectedCols, NumSelectedCols);

      // Copy selected patterns to DestCol
      for i := 0 to NumSelectedCols - 1 do
      begin
        VTMP.Positions.Value[DestCol + i]  := SourceColsContent[i];
        VTMP.Positions.Colors[DestCol + i] := SourceColsColors[i];
      end;

      PositionMakeSelection(DestCol, DestCol + NumSelectedCols - 1);
    end;
  end;

  procedure CloneItemsFromLeftToRight();
  var
    i: Integer;
    NewPatternNumbers: TIntegersArray;
  begin
    with StringGrid1 do
    begin

      NewPatternNumbers := GetNewPatternNumbers(NumSelectedCols);
      if Length(NewPatternNumbers) = 0 then
        exit;

      // Increase track length
      IncreaseTrackLength(NumSelectedCols);

      // Shift patterns to right FROM DestCol to end
      ShiftPositionsToRight(DestCol + 1, NumSelectedCols);

      // Clone selected patterns to DestCol
      for i := 0 to NumSelectedCols - 1 do
      begin
        CloneAndCopyPattern(SourceColsContent[i], NewPatternNumbers[i]);
        VTMP.Positions.Value[DestCol + 1 + i] := NewPatternNumbers[i];
        VTMP.Positions.Colors[DestCol + 1 + i] := SourceColsColors[i];
      end;

      PositionMakeSelection(DestCol + 1, DestCol + NumSelectedCols);
    end;
  end;

  procedure CloneItemsFromLeftToRight2();
  var
    i: Integer;
    NewPatternNumbers: TIntegersArray;
  begin
    with StringGrid1 do
    begin
      NewPatternNumbers := GetNewPatternNumbers(NumSelectedCols);
      if Length(NewPatternNumbers) = 0 then
        exit;

      // Destination column = End of soundtrack
      DestCol := VTMP.Positions.Length;

      // Increase track length
      IncreaseTrackLength(NumSelectedCols);

      // Clone selected patterns to DestCol
      for i := 0 to NumSelectedCols - 1 do
      begin
        CloneAndCopyPattern(SourceColsContent[i], NewPatternNumbers[i]);
        VTMP.Positions.Value[DestCol + i] := NewPatternNumbers[i];
        VTMP.Positions.Colors[DestCol + i] := SourceColsColors[i];
      end;

      PositionMakeSelection(DestCol, DestCol + NumSelectedCols - 1);
    end;
  end;

  procedure CloneItemsFromRightToLeft();
  var
    i: Integer;
    NewPatternNumbers: TIntegersArray;
  begin
    with StringGrid1 do
    begin
      NewPatternNumbers := GetNewPatternNumbers(NumSelectedCols);
      if Length(NewPatternNumbers) = 0 then
        exit;

      // Increase soundtrack length
      IncreaseTrackLength(NumSelectedCols);

      // Shift columns to right
      ShiftPositionsToRight(DestCol + NumSelectedCols, NumSelectedCols);

      // Clone selected patterns to DestCol
      for i := 0 to NumSelectedCols - 1 do
      begin
        CloneAndCopyPattern(SourceColsContent[i], NewPatternNumbers[i]);
        VTMP.Positions.Value[DestCol + i] := NewPatternNumbers[i];
        VTMP.Positions.Colors[DestCol + i] := SourceColsColors[i];
      end;

      PositionMakeSelection(DestCol, DestCol + NumSelectedCols - 1);
    end;
  end;

begin
  with StringGrid1 do
  begin
    MouseToCell(X, Y, DestCol, DestRow);

    SourceCol := Selection.Left;      // Left index of selection
    SourceColEnd := Selection.Right;  // Right index of selection
    NumSelectedCols := Succ(Selection.Right - Selection.Left);
    
    ControlPressed := GetKeyState(VK_CONTROL) < 0; // Is Ctrl key pressed?
    ShiftPressed := GetKeyState(VK_SHIFT) < 0;     // Is Shift key pressed?
    TrackLength := VTMP.Positions.Length;

    // Do nothing if drag to the same column
    if (SourceCol = DestCol) then
      Exit;

    // Detect operation
    if ShiftPressed or ControlPressed then
      OperationType := POS_COPY
    else
      OperationType := POS_MOVE;

    // Save information for UNDO operation
    if not ShiftPressed then
      SavePositionsUndo // save positions state only (move and copy)
    else
      SaveTrackUndo;    // save positions and patterns (clone)

    // Set length of arrays for store selected columns
    SetLength(SourceColsContent, NumSelectedCols);
    SetLength(SourceColsColors, NumSelectedCols);

    // Save values of selected columns and colors
    for i := 0 to NumSelectedCols - 1 do
    begin
      SourceColsContent[i] := VTMP.Positions.Value[SourceCol + i];
      SourceColsColors[i] := VTMP.Positions.Colors[SourceCol + i];
    end;

    // Move patterns
    // If user drag items from left to right
    if (SourceColEnd < DestCol) and (DestCol < TrackLength) and not ControlPressed and not ShiftPressed then
      MoveItemsFromLeftToRight;

    // MOVE patterns
    // If user drag items to the end of track
    if (SourceColEnd < DestCol) and (DestCol >= TrackLength) and not ControlPressed and not ShiftPressed then
      MoveItemsFromLeftToRight2;

    // MOVE patterns
    // If user drags items from right to left
    if (SourceCol > DestCol) and not ControlPressed and not ShiftPressed then
      MoveItemsFromRightToLeft;

    // COPY patterns
    // If user drag items from left to right AND press Ctrl key
    if (SourceColEnd < DestCol) and (DestCol < TrackLength) and ControlPressed and not ShiftPressed then
      CopyItemsFromLeftToRight;

    // COPY patterns
    // If user drag items from left to the end of track AND press Ctrl key
    if (SourceColEnd < DestCol) and (DestCol >= TrackLength) and ControlPressed and not ShiftPressed then
      CopyItemsFromLeftToRight2;

    // COPY patterns
    // If user drag items from right to left AND press Ctrl key
    if (SourceCol > DestCol) and ControlPressed and not ShiftPressed then
      CopyItemsFromRightToLeft;

    // CLONE patterns
    // If user drag items from left to right AND press Shift key
    if (SourceColEnd < DestCol) and (DestCol < TrackLength) and ShiftPressed and not ControlPressed then
      CloneItemsFromLeftToRight;

    // CLONE patterns
    // If user drag items from left to the end of track AND press Shift key
    if (SourceColEnd < DestCol) and (DestCol >= TrackLength) and ShiftPressed and not ControlPressed then
      CloneItemsFromLeftToRight2;

    // CLONE patterns
    // If user drag items from right to left AND press Shift key
    if (SourceCol > DestCol) and ShiftPressed and not ControlPressed then
      CloneItemsFromRightToLeft;


    // Shift loop position
    ShiftLoopPosition(OperationType, SourceCol, DestCol, NumSelectedCols);

    // Redraw stringgrid with pattern positions
    RedrawPatternPositions;

    // Set pattern editor cursor to the first line and on the channel A note.
    if OperationType = POS_COPY then
    begin
      Tracks.ShownFrom := 0;
      Tracks.CursorX := 8;
      Tracks.CursorY := Tracks.N1OfLines;
    end;

    // Recalculate total track length
    CalcTotLen;

    InputPNumber := 0;

    // If clone, then save new patterns state for REDO
    if ShiftPressed then
      SaveTrackRedo
    else
      SavePositionsRedo;

  end;
end;

procedure TMDIChild.StringGrid1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  CurrentCol, CurrentRow: Integer;
begin
  StringGrid1.MouseToCell(X, Y, CurrentCol, CurrentRow);
  Accept := (Sender = Source) and (CurrentCol >= 0);
  if Accept then
  begin
    if (PatternsOrderSelection.Right <> PatternsOrderSelection.Left) then
      StringGrid1.Selection := PatternsOrderSelection;

    if (GetKeyState(VK_CONTROL) < 0) then
      StringGrid1.DragCursor := crMultiDrag
    else if (GetKeyState(VK_SHIFT) < 0) then
      StringGrid1.DragCursor := crUpArrow
    else
      StringGrid1.DragCursor := crDrag;

  end;

end;

procedure TMDIChild.StringGrid1EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  PatternsOrderSelection := StringGrid1.Selection;
end;

procedure TMDIChild.Edit3Change(Sender: TObject);
var
  s: string;
begin

  if not InitFinished then Exit;

  SongChanged := True;
  BackupSongChanged := True;
  s := Edit3.Text;
  AddUndo(CAChangeTitle, Integer(PChar(VTMP.Title)), Integer(PChar(s)));
  VTMP.Title := s
end;

procedure TMDIChild.Edit4Change(Sender: TObject);
var
  s: string;
begin

  if not InitFinished then Exit;

  SongChanged := True;
  BackupSongChanged := True;
  s := Edit4.Text;
  AddUndo(CAChangeAuthor, Integer(PChar(VTMP.Author)), Integer(PChar(s)));
  VTMP.Author := s;
end;

procedure TMDIChild.ChangePattern(n: Integer);
var
  l: Integer;
begin
  PatNum := n;
  Tracks.ShownPattern := VTMP.Patterns[PatNum];

  if VTMP.Patterns[PatNum] = nil then
    l := DefPatLen
  else
    l := VTMP.Patterns[PatNum].Length;

  PatternLenUpDown.Position := l;

  if AutoHL.Down then
    CalcHLStep;

  Tracks.ShownFrom := 0;
  if Tracks.Focused then
    Tracks.HideMyCaret;

  if Tracks.CursorY > l - 1 + Tracks.N1OfLines then
  begin
    Tracks.CursorY := l - 1 + Tracks.N1OfLines;
    if Tracks.Focused then
      Tracks.SetCaretPosition;
  end
  else if Tracks.CursorY < Tracks.N1OfLines then
  begin
    Tracks.CursorY := Tracks.N1OfLines;
    if Tracks.Focused then
      Tracks.SetCaretPosition;
  end;
  Tracks.RemoveSelection;
  Tracks.RedrawTracks(0);

  if Tracks.Focused then
    Tracks.ShowMyCaret;

  if Active then
    SetToolsPattern;
end;

procedure TMDIChild.PatternNumUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
begin
  if DisableChangingEx then Exit;
  AllowChange := NewValue in [0..MaxPatNum];
  if AllowChange then
    ChangePattern(NewValue)
end;

procedure TMDIChild.PatternNumEditChange(Sender: TObject);
begin
  if DisableChangingEx then Exit;
  if PatNum <> PatternNumUpDown.Position then
    ChangePattern(PatternNumUpDown.Position)
end;

function TMDIChild.GetSpeedBPMString(TrackSpeed: Smallint): string;
var
  TrackSpeedStr, BPMStr: string;
begin
  TrackSpeedStr := IntToStr(TrackSpeed);
  BPMStr := IntToStr(Round((Interrupt_Freq * 60 / (TrackSpeed * 4)) / 1000));

  if Length(TrackSpeedStr) + Length(BPMStr) <= 4 then
    Result := TrackSpeedStr + ' / ' + BPMStr
  else
    Result := TrackSpeedStr + '/' + BPMStr;

end;

procedure TMDIChild.UpdateSpeedBPM;
begin
  SpeedBpmEdit.Text := GetSpeedBPMString(SpeedBpmUpDown.Position);
end;

procedure TMDIChild.SpeedBpmUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
begin
  AllowChange := NewValue in [1..255];
  if AllowChange then
  begin
    SetInitDelay(NewValue);
    if not SpeedBpmEdit.Focused then
      SpeedBpmEdit.Text := GetSpeedBPMString(NewValue);
  end;
end;

procedure change_Envelope_when_toneTableChanged(VTMZ: PModule; oldT: Integer; newT: Integer);
var
  coeff: Real;
  ii, ff: Integer;
  ENote, oldE, e: Integer;
  Notefreq: Integer;
begin
  for ff := -1 to 84 do
  begin
    if VTMZ.Patterns[ff] = nil then
      Continue;
    for ii := 0 to VTMZ.Patterns[ff].Length do
    begin

      oldE := VTMZ.Patterns[ff].Items[ii].Envelope;
      if oldE = 0 then Continue;

      coeff := GetNoteFreq(oldT, 0) / GetNoteFreq(newT, 0);
      ENote := GetNoteByEnvelope2(oldT, oldE);
      if ENote = 0 then
      begin
        VTMZ.Patterns[ff].Items[ii].Envelope := Round(oldE / coeff);
      end
      else
      begin
        Notefreq := GetNoteFreq(newT, ENote);
        e := Round(Notefreq / 16);
        VTMZ.Patterns[ff].Items[ii].Envelope := e;
      end;
    end;
  end;
end;

procedure TMDIChild.UpDown4ChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
begin
  AllowChange := NewValue in [0..4];
  if not AllowChange then Exit;
  if VTMP.Ton_Table = NewValue then Exit;

  change_Envelope_when_toneTableChanged(VTMP, VTMP.Ton_Table, NewValue);
  SongChanged := True;
  BackupSongChanged := True;
  AddUndo(CAChangeToneTable, VTMP.Ton_Table, NewValue);
  VTMP.Ton_Table := NewValue;

  UpdateToneTableHints;

  Tracks.RedrawTracks(0);
  if Active then
    SetToolsPattern;

  if BlockRecursion then Exit;

  if TSWindow <> nil then begin
    TSWindow.BlockRecursion := True;
    TSWindow.UpDown4.Position := NewValue;
    TSWindow.BlockRecursion := False;
  end;
end;

procedure TMDIChild.Edit7Exit(Sender: TObject);
begin
  Edit7.Text := IntToStr(UpDown4.Position);
end;

procedure TMDIChild.Edit7Change(Sender: TObject);
begin
  if VTMP.Ton_Table <> UpDown4.Position then
  begin
    change_Envelope_when_toneTableChanged(VTMP, VTMP.Ton_Table, UpDown4.Position);
    SongChanged := True;
    BackupSongChanged := True;
    AddUndo(CAChangeToneTable, VTMP.Ton_Table, UpDown4.Position);
    VTMP.Ton_Table := UpDown4.Position;
  end;

  UpdateToneTableHints;

  Tracks.RedrawTracks(0);
  if Tracks.Focused then
    Tracks.ShowMyCaret;
  if Active then
    SetToolsPattern;
end;

procedure TMDIChild.PatternLenEditExit(Sender: TObject);
var
  NewValue: Integer;
  AllowChange: Boolean;
begin
  AllowChange := True;
  NewValue := PatternLenUpDown.Position;

  if DecBaseLinesOn then
    if IsDecValid(PatternLenEdit.Text) then
      NewValue := StrToInt(PatternLenEdit.Text)
    else
      AllowChange := False;

  if not DecBaseLinesOn then
    if IsHexValid(PatternLenEdit.Text) then
      NewValue := StrToInt('$' + PatternLenEdit.Text)
    else
      AllowChange := False;

  if NewValue > MaxPatLen then
    AllowChange := False;

  if AllowChange then
    PatternLenUpDown.Position := NewValue
  else if DecBaseLinesOn then
    PatternLenEdit.Text := IntToStr(PatternLenUpDown.Position)
  else
    PatternLenEdit.Text := IntToHex(PatternLenUpDown.Position, 2);
      
  //ChangePatternLength(PatternLenUpDown.Position)
end;

procedure TMDIChild.PatternLenUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
begin
  if DisableChangingEx then Exit;
  AllowChange := (NewValue > 0) and (NewValue <= MaxPatLen);

  if DecBaseLinesOn then
    PatternLenEdit.Text := IntToStr(NewValue)
  else
    PatternLenEdit.Text := IntToHex(NewValue, 2);

  if AllowChange then
    ChangePatternLength(NewValue);
end;

procedure TMDIChild.CheckTracksAfterSizeChanged(NL: Integer);
begin
  if AutoHL.Down then
    CalcHLStep;
  if not UndoWorking then
  begin
    if Tracks.ShownFrom >= NL then
      Tracks.ShownFrom := NL - 1;
    if Tracks.Focused then
      Tracks.HideMyCaret;
    if Tracks.CursorY > NL - Tracks.ShownFrom - 1 + Tracks.N1OfLines then
    begin
      Tracks.CursorY := NL - Tracks.ShownFrom - 1 + Tracks.N1OfLines;
      if Tracks.Focused then
        Tracks.SetCaretPosition;
    end;
    Tracks.RemoveSelection;
    Tracks.RedrawTracks(0);
    if Tracks.Focused then
      Tracks.ShowMyCaret;
    ChangeList[ChangeCount - 1].NewParams.prm.PatternShownFrom := Tracks.ShownFrom;
    ChangeList[ChangeCount - 1].NewParams.prm.PatternCursorY := Tracks.CursorY;
  end;
  CalcTotLen;
  CalculatePos0;
end;

procedure TMDIChild.ChangePatternLength(NL: Integer);
begin
  ValidatePattern2(PatNum);
  if NL <> VTMP.Patterns[PatNum].Length then
  begin
    SongChanged := True;
    BackupSongChanged := True;
    AddUndo(CAChangePatternSize, VTMP.Patterns[PatNum].Length, NL);
    VTMP.Patterns[PatNum].Length := NL;
    CheckTracksAfterSizeChanged(NL);
  end;
end;

procedure TMDIChild.OctaveEditExit(Sender: TObject);
begin
  OctaveEdit.Text := IntToStr(OctaveUpDown.Position)
end;

procedure TMDIChild.SetChannelAMutedState(Muted: Boolean);
begin
  Tracks.ChannelState[0].Muted := Muted;
end;

procedure TMDIChild.SetChannelBMutedState(Muted: Boolean);
begin
  Tracks.ChannelState[1].Muted := Muted;
end;

procedure TMDIChild.SetChannelCMutedState(Muted: Boolean);
begin
  Tracks.ChannelState[2].Muted := Muted;
end;

procedure TMDIChild.UpdateChannelsMutedState;
begin
  SetChannelAMutedState(SpeedButton2.Down and SpeedButton3.Down and SpeedButton4.Down);
  SetChannelBMutedState(SpeedButton6.Down and SpeedButton7.Down and SpeedButton8.Down);
  SetChannelCMutedState(SpeedButton10.Down and SpeedButton11.Down and SpeedButton12.Down);
end;

{procedure TMDIChild.CheckSoloButtons;
begin

    // Channel A solo button state
    SpeedButton13.Down :=
        SpeedButton6.Down and
        SpeedButton7.Down and
        SpeedButton8.Down and
        SpeedButton10.Down and
        SpeedButton11.Down and
        SpeedButton12.Down
        and (
          not SpeedButton2.Down or
          not SpeedButton3.Down or
          not SpeedButton4.Down
        )
    ;

    if TSWindow <> nil then
      SpeedButton13.Down := SpeedButton13.Down and
          TSWindow.SpeedButton6.Down and
          TSWindow.SpeedButton7.Down and
          TSWindow.SpeedButton8.Down and
          TSWindow.SpeedButton10.Down and
          TSWindow.SpeedButton11.Down and
          TSWindow.SpeedButton12.Down and
          TSWindow.SpeedButton2.Down and
          TSWindow.SpeedButton3.Down and
          TSWindow.SpeedButton4.Down
      ;

    // Channel B solo button state
    SpeedButton14.Down :=
        SpeedButton2.Down and
        SpeedButton3.Down and
        SpeedButton4.Down and
        SpeedButton10.Down and
        SpeedButton11.Down and
        SpeedButton12.Down
        and (
          not SpeedButton6.Down or
          not SpeedButton7.Down or
          not SpeedButton8.Down
        )
    ;

    if TSWindow <> nil then
      SpeedButton14.Down := SpeedButton14.Down and
          TSWindow.SpeedButton2.Down and
          TSWindow.SpeedButton3.Down and
          TSWindow.SpeedButton4.Down and
          TSWindow.SpeedButton10.Down and
          TSWindow.SpeedButton11.Down and
          TSWindow.SpeedButton12.Down and
          TSWindow.SpeedButton6.Down and
          TSWindow.SpeedButton7.Down and
          TSWindow.SpeedButton8.Down
      ;

    // Channel C solo button state
    SpeedButton15.Down :=
        SpeedButton2.Down and
        SpeedButton3.Down and
        SpeedButton4.Down and
        SpeedButton6.Down and
        SpeedButton7.Down and
        SpeedButton8.Down
        and (
          not SpeedButton10.Down or
          not SpeedButton11.Down or
          not SpeedButton12.Down
        )
    ;

    if TSWindow <> nil then
      SpeedButton15.Down := SpeedButton15.Down and
          TSWindow.SpeedButton2.Down and
          TSWindow.SpeedButton3.Down and
          TSWindow.SpeedButton4.Down and
          TSWindow.SpeedButton6.Down and
          TSWindow.SpeedButton7.Down and
          TSWindow.SpeedButton8.Down and
          TSWindow.SpeedButton10.Down and
          TSWindow.SpeedButton11.Down and
          TSWindow.SpeedButton12.Down
      ;

end;
}

procedure TMDIChild.CheckButtonStateChanA;
begin
  SpeedButton1.Down := SpeedButton2.Down and SpeedButton3.Down and SpeedButton4.Down;
end;

procedure TMDIChild.CheckButtonStateChanB;
begin
  SpeedButton5.Down := SpeedButton6.Down and SpeedButton7.Down and SpeedButton8.Down;
end;

procedure TMDIChild.CheckButtonStateChanC;
begin
  SpeedButton9.Down := SpeedButton10.Down and SpeedButton11.Down and SpeedButton12.Down;
end;

procedure TMDIChild.UpdateHintsForChannelButtons;
const
  MuteChannel    = 'Mute Channel';
  MuteTone       = 'Mute Tone';
  MuteNoise      = 'Mute Noise';
  MuteEnvelope   = 'Mute Envelope';
  UnmuteChannel  = 'Unmute Channel';
  UnmuteTone     = 'Unmute Tone';
  UnmuteNoise    = 'Unmute Noise';
  UnmuteEnvelope = 'Unmute Envelope';
  SoloChannel    = 'Solo Channel';
  UnsoloChannel  = 'Unsolo Channel';

begin
  // Channel A button
  with SpeedButton1 do
    case Down of
      True:  Hint := UnmuteChannel;
      False: Hint := MuteChannel;
    end;

  with SpeedButton2 do
    case Down of
      True:  Hint := UnmuteTone;
      False: Hint := MuteTone;
    end;

  with SpeedButton3 do
    case Down of
      True:  Hint := UnmuteNoise;
      False: Hint := MuteNoise;
    end;

  with SpeedButton4 do
    case Down of
      True:  Hint := UnmuteEnvelope;
      False: Hint := MuteEnvelope;
    end;

  with SpeedButton13 do
    case Down of
      True:  Hint := UnsoloChannel;
      False: Hint := SoloChannel;
    end;

  // Channel B buttons
  with SpeedButton5 do
    case Down of
      True:  Hint := UnmuteChannel;
      False: Hint := MuteChannel;
    end;

  with SpeedButton6 do
    case Down of
      True:  Hint := UnmuteTone;
      False: Hint := MuteTone;
    end;

  with SpeedButton7 do
    case Down of
      True:  Hint := UnmuteNoise;
      False: Hint := MuteNoise;
    end;

  with SpeedButton8 do
    case Down of
      True:  Hint := UnmuteEnvelope;
      False: Hint := MuteEnvelope;
    end;

  with SpeedButton14 do
    case Down of
      True:  Hint := UnsoloChannel;
      False: Hint := SoloChannel;
    end;


  // Channel C buttons
  with SpeedButton9 do
    case Down of
      True:  Hint := UnmuteChannel;
      False: Hint := MuteChannel;
    end;

  with SpeedButton10 do
    case Down of
      True:  Hint := UnmuteTone;
      False: Hint := MuteTone;
    end;

  with SpeedButton11 do
    case Down of
      True:  Hint := UnmuteNoise;
      False: Hint := MuteNoise;
    end;

  with SpeedButton12 do
    case Down of
      True:  Hint := UnmuteEnvelope;
      False: Hint := MuteEnvelope;
    end;

  with SpeedButton15 do
    case Down of
      True:  Hint := UnsoloChannel;
      False: Hint := SoloChannel;
    end;


end;

procedure TMDIChild.UpdateChannelsState;
begin
  CheckButtonStateChanA;
  CheckButtonStateChanB;
  CheckButtonStateChanC;
  if TSWindow <> nil then
    with TSWindow do
    begin
      CheckButtonStateChanA;
      CheckButtonStateChanB;
      CheckButtonStateChanC;
    end;

  {CheckSoloButtons;
  if TSWindow <> nil then
    TSWindow.CheckSoloButtons;  }

  UpdateHintsForChannelButtons;
  UpdateChannelsMutedState;
  Tracks.HideMyCaret;
  Tracks.RedrawTracks(0);
  Tracks.ShowMyCaret;

  if TSWindow <> nil then
    with TSWindow do
    begin
      UpdateHintsForChannelButtons;
      UpdateChannelsMutedState;
      Tracks.HideMyCaret;
      Tracks.RedrawTracks(0);
      Tracks.ShowMyCaret;
    end;

  StopAndRestart;
end;

function TMDIChild.AnotherSoloPressed: Boolean;
begin
  Result := SpeedButton13.Down or SpeedButton14.Down or SpeedButton15.Down;
  if TSWindow = nil then Exit;
  Result := Result or TSWindow.SpeedButton13.Down or TSWindow.SpeedButton14.Down or TSWindow.SpeedButton15.Down;
end;

procedure TMDIChild.MuteChannelA(Force: Boolean);
begin
  if SpeedButton13.Down and not Force then Exit;
  VTMP.IsChans[0].Global_Ton      := False;
  VTMP.IsChans[0].Global_Noise    := False;
  VTMP.IsChans[0].Global_Envelope := False;
  SpeedButton1.Down := True;
  SpeedButton2.Down := True;
  SpeedButton3.Down := True;
  SpeedButton4.Down := True;
  SpeedButton13.Down := False;
end;

procedure TMDIChild.MuteChannelB(Force: Boolean);
begin
  if SpeedButton14.Down and not Force then Exit;
  VTMP.IsChans[1].Global_Ton      := False;
  VTMP.IsChans[1].Global_Noise    := False;
  VTMP.IsChans[1].Global_Envelope := False;
  SpeedButton5.Down := True;
  SpeedButton6.Down := True;
  SpeedButton7.Down := True;
  SpeedButton8.Down := True;
  SpeedButton14.Down := False;
end;

procedure TMDIChild.MuteChannelC(Force: Boolean);
begin
  if SpeedButton15.Down and not Force then Exit;
  VTMP.IsChans[2].Global_Ton      := False;
  VTMP.IsChans[2].Global_Noise    := False;
  VTMP.IsChans[2].Global_Envelope := False;
  SpeedButton9.Down := True;
  SpeedButton10.Down := True;
  SpeedButton11.Down := True;
  SpeedButton12.Down := True;
  SpeedButton15.Down := False;
end;

procedure TMDIChild.DismuteChannelA;
begin
  VTMP.IsChans[0].Global_Ton      := True;
  VTMP.IsChans[0].Global_Noise    := True;
  VTMP.IsChans[0].Global_Envelope := True;
  SpeedButton1.Down := False;
  SpeedButton2.Down := False;
  SpeedButton3.Down := False;
  SpeedButton4.Down := False;
end;

procedure TMDIChild.DismuteChannelB;
begin
  VTMP.IsChans[1].Global_Ton      := True;
  VTMP.IsChans[1].Global_Noise    := True;
  VTMP.IsChans[1].Global_Envelope := True;
  SpeedButton5.Down := False;
  SpeedButton6.Down := False;
  SpeedButton7.Down := False;
  SpeedButton8.Down := False;
end;

procedure TMDIChild.DismuteChannelC;
begin
  VTMP.IsChans[2].Global_Ton      := True;
  VTMP.IsChans[2].Global_Noise    := True;
  VTMP.IsChans[2].Global_Envelope := True;
  SpeedButton9.Down := False;
  SpeedButton10.Down := False;
  SpeedButton11.Down := False;
  SpeedButton12.Down := False;
end;

procedure TMDIChild.DismuteAllChannels(Force: Boolean);
begin

  if Force then begin
    DismuteChannelA;
    DismuteChannelB;
    DismuteChannelC;
    SpeedButton13.Down := False;
    SpeedButton14.Down := False;
    SpeedButton15.Down := False;
    if TSWindow <> nil then with TSWindow do
    begin
      DismuteChannelA;
      DismuteChannelB;
      DismuteChannelC;
      SpeedButton13.Down := False;
      SpeedButton14.Down := False;
      SpeedButton15.Down := False;
    end;
    Exit;
  end;

  if AnotherSoloPressed then MuteChannelA(False) else DismuteChannelA;
  if AnotherSoloPressed then MuteChannelB(False) else DismuteChannelB;
  if AnotherSoloPressed then MuteChannelC(False) else DismuteChannelC;
  if TSWindow <> nil then
    with TSWindow do
    begin
      if AnotherSoloPressed then MuteChannelA(False) else DismuteChannelA;
      if AnotherSoloPressed then MuteChannelB(False) else DismuteChannelB;
      if AnotherSoloPressed then MuteChannelC(False) else DismuteChannelC;
    end;
end;

procedure TMDIChild.MuteSecondWidnowChannels;
begin
  if TSWindow <> nil then
    with TSWindow do
    begin
      MuteChannelA(False);
      MuteChannelB(False);
      MuteChannelC(False);
    end;
end;

procedure TMDIChild.SoloChannelA(Force: Boolean);
begin
  DismuteChannelA;
  SpeedButton13.Down := True;
  MuteChannelB(Force);
  MuteChannelC(Force);
  MuteSecondWidnowChannels;
end;

procedure TMDIChild.SoloChannelB(Force: Boolean);
begin
  DismuteChannelB;
  SpeedButton14.Down := True;
  MuteChannelA(Force);
  MuteChannelC(Force);
  MuteSecondWidnowChannels;
end;

procedure TMDIChild.SoloChannelC(Force: Boolean);
begin
  DismuteChannelC;
  SpeedButton15.Down := True;
  MuteChannelA(Force);
  MuteChannelB(Force);
  MuteSecondWidnowChannels;
end;

procedure TMDIChild.SpeedButton1Click(Sender: TObject);
begin
  if SpeedButton1.Down then
    MuteChannelA(False)
  else
    DismuteChannelA;
  UpdateChannelsState;
end;


procedure TMDIChild.SpeedButton2Click(Sender: TObject);
begin
  VTMP.IsChans[0].Global_Ton := not SpeedButton2.Down;
  UpdateChannelsState;
end;

procedure TMDIChild.SpeedButton3Click(Sender: TObject);
begin
  VTMP.IsChans[0].Global_Noise := not SpeedButton3.Down;
  UpdateChannelsState;
end;

procedure TMDIChild.SpeedButton4Click(Sender: TObject);
begin
  VTMP.IsChans[0].Global_Envelope := not SpeedButton4.Down;
  UpdateChannelsState;
end;

procedure TMDIChild.SpeedButton13Click(Sender: TObject);
begin
  if SpeedButton13.Down then
    SoloChannelA(False)
  else
    DismuteAllChannels(False);
  UpdateChannelsState;
end;

procedure TMDIChild.SpeedButton5Click(Sender: TObject);
begin
  if SpeedButton5.Down then
    MuteChannelB(False)
  else
    DismuteChannelB;
  UpdateChannelsState;
end;

procedure TMDIChild.SpeedButton6Click(Sender: TObject);
begin
  VTMP.IsChans[1].Global_Ton := not SpeedButton6.Down;
  UpdateChannelsState;
end;

procedure TMDIChild.SpeedButton7Click(Sender: TObject);
begin
  VTMP.IsChans[1].Global_Noise := not SpeedButton7.Down;
  UpdateChannelsState;
end;

procedure TMDIChild.SpeedButton8Click(Sender: TObject);
begin
  VTMP.IsChans[1].Global_Envelope := not SpeedButton8.Down;
  UpdateChannelsState;
end;

procedure TMDIChild.SpeedButton14Click(Sender: TObject);
begin
  if SpeedButton14.Down then
    SoloChannelB(False)
  else
    DismuteAllChannels(False);
  UpdateChannelsState;
end;

procedure TMDIChild.SpeedButton9Click(Sender: TObject);
begin
  if SpeedButton9.Down then
    MuteChannelC(False)
  else
    DismuteChannelC;
  UpdateChannelsState;
end;

procedure TMDIChild.SpeedButton10Click(Sender: TObject);
begin
  VTMP.IsChans[2].Global_Ton := not SpeedButton10.Down;
  UpdateChannelsState;
end;

procedure TMDIChild.SpeedButton11Click(Sender: TObject);
begin
  VTMP.IsChans[2].Global_Noise := not SpeedButton11.Down;
  UpdateChannelsState;
end;

procedure TMDIChild.SpeedButton12Click(Sender: TObject);
begin
  VTMP.IsChans[2].Global_Envelope := not SpeedButton12.Down;
  UpdateChannelsState;
end;

procedure TMDIChild.SpeedButton15Click(Sender: TObject);
begin
  if SpeedButton15.Down then
    SoloChannelC(False)
  else
    DismuteAllChannels(False);
  UpdateChannelsState;
end;

procedure TMDIChild.VtmFeaturesGrpClick(Sender: TObject);
begin
  if InitFinished then begin
    SongChanged := True;
    BackupSongChanged := True;
    AddUndo(CAChangeFeatures, VTMP.FeaturesLevel, VtmFeaturesGrp.ItemIndex);
  end;
  VTMP.FeaturesLevel := VtmFeaturesGrp.ItemIndex;

  if BlockRecursion then Exit;

  if TSWindow <> nil then begin
    TSWindow.BlockRecursion := True;
    TSWindow.VtmFeaturesGrp.ItemIndex := VtmFeaturesGrp.ItemIndex;
    TSWindow.BlockRecursion := False;
  end;

end;

procedure TMDIChild.SaveHeadClick(Sender: TObject);
begin

  if not InitFinished then Exit;

  SongChanged := True;
  BackupSongChanged := True;
  AddUndo(CAChangeHeader, Integer(not VTMP.VortexModule_Header), SaveHead.ItemIndex);
  VTMP.VortexModule_Header := not Boolean(SaveHead.ItemIndex);

  if BlockRecursion then Exit;

  if TSWindow <> nil then begin
    TSWindow.BlockRecursion := True;
    TSWindow.SaveHead.ItemIndex := SaveHead.ItemIndex;
    TSWindow.BlockRecursion := False;
  end;
end;

procedure TMDIChild.SampleNumEditChange(Sender: TObject);
begin
  if SamNum <> SampleNumUpDown.Position then
    ChangeSample(SampleNumUpDown.Position, True)
end;

procedure TMDIChild.SampleNumEditExit(Sender: TObject);
begin
  SampleNumEdit.Text := IntToStr(SampleNumUpDown.Position)
end;

procedure TMDIChild.SampleNumUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
begin
  AllowChange := NewValue in [1..31];
  if AllowChange then begin
    SamplesSelectionOff;
    ChangeSample(NewValue, False);
  end;
end;

procedure TMDIChild.SampleLenEditExit(Sender: TObject);
var
  NewValue: Integer;
  AllowChange: Boolean;
begin

  AllowChange := True;
  NewValue := SampleLenUpDown.Position;

  if DecBaseLinesOn then
    if IsDecValid(SampleLenEdit.Text) then
      NewValue := StrToInt(SampleLenEdit.Text)
    else
      AllowChange := False;

  if not DecBaseLinesOn then
    if IsHexValid(SampleLenEdit.Text) then
      NewValue := StrToInt('$' + SampleLenEdit.Text)
    else
      AllowChange := False;

  if NewValue > MaxSamLen then
    AllowChange := False;

  if AllowChange then
    SampleLenUpDown.Position := NewValue
  else
  if DecBaseLinesOn then
    SampleLenEdit.Text := IntToStr(SampleLenUpDown.Position)
  else
    SampleLenEdit.Text := IntToHex(SampleLenUpDown.Position, 2);

  //ChangeSampleLength(SampleLenUpDown.Position)
end;

procedure TMDIChild.SampleLenUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
begin
  AllowChange := NewValue in [1..MaxSamLen];

  if AllowChange then
  begin
    SamplesSelectionOff;
    if DecBaseLinesOn then
      SampleLenEdit.Text := IntToStr(NewValue)
    else
      SampleLenEdit.Text := IntToHex(NewValue, 2);

    ChangeSampleLength(NewValue, False);
  end;
end;

procedure TMDIChild.ChangeSample(n: Integer; UpdateUpDown: Boolean);
var
  l: Integer;
begin

  if SamNum <> n then
  begin
    Samples.isSelecting := False;
    SamNum := n;
    with SampleTestLine do
    begin
      VTMP.Patterns[-1].Items[1].Channel[0].Sample := n;
      if Focused then
        HideCaret(Handle);
      RedrawTestLine(0);
      if Focused then
        ShowCaret(Handle);
    end;
    Samples.ShownSample := VTMP.Samples[SamNum];

    if UpdateUpDown then
      SampleNumUpDown.Position := n;
      
    if VTMP.Samples[SamNum] = nil then
      l := 1
    else
      l := VTMP.Samples[SamNum].Length;
    SampleLenUpDown.Position := l;
    if VTMP.Samples[SamNum] = nil then
      l := 0
    else
      l := VTMP.Samples[SamNum].Loop;
    SampleLoopUpDown.Position := l;
    if not UndoWorking then
    begin
      Samples.ShownFrom := 0;
      Samples.CursorX := 0;
      Samples.CursorY := 0;
    end;
  end;
  
  if Samples.Focused then
  begin
    Samples.RecreateCaret;
    Samples.SetCaretPosition;
    Samples.HideMyCaret
  end;
  Samples.RedrawSamples(0);
  if Samples.Focused then
    Samples.ShowMyCaret;
end;

procedure TMDIChild.ChangeSampleLength(NL: Integer; UpdateUpDown: Boolean);
begin

  if (VTMP.Samples[SamNum] = nil) and (NL = 1) then
    Exit;

  Samples.isSelecting := False;
  ValidateSample2(SamNum);
  
  if NL <> VTMP.Samples[SamNum].Length then
  begin
    SongChanged := True;
    BackupSongChanged := True;
    
    if not Samples.UndoSaved then
      AddUndo(CAChangeSampleSize, VTMP.Samples[SamNum].Length, NL);

    VTMP.Samples[SamNum].Length := NL;

    if not UndoWorking then
    begin

      if not Samples.UndoSaved then
        ChangeList[ChangeCount - 1].OldParams.prm.PrevLoop := VTMP.Samples[SamNum].Loop;

      // If sample loop > length
      if VTMP.Samples[SamNum].Loop >= VTMP.Samples[SamNum].Length then
      begin
        VTMP.Samples[SamNum].Loop := VTMP.Samples[SamNum].Length - 1;
        SampleLoopUpDown.Position := VTMP.Samples[SamNum].Loop;
      end;

      if not Samples.UndoSaved then
        ChangeList[ChangeCount - 1].NewParams.prm.PrevLoop := VTMP.Samples[SamNum].Loop;

      if UpdateUpDown then
       SampleLenUpDown.Position := NL;

      if Samples.Focused then
        Samples.HideMyCaret;
      Samples.RedrawSamples(0);
      if Samples.Focused then
        Samples.ShowMyCaret;
    end;
  end
end;

procedure TMDIChild.ChangeSampleLoop(NL: Integer; UpdateUpDown: Boolean);
begin
  Samples.isSelecting := False;
  if (VTMP.Samples[SamNum] = nil) then
    exit;
  if (NL <> VTMP.Samples[SamNum].Loop) and (NL <= VTMP.Samples[SamNum].Length) then
  begin
    SongChanged := True;
    BackupSongChanged := True;

    if not Samples.UndoSaved then
      AddUndo(CAChangeSampleLoop, VTMP.Samples[SamNum].Loop, NL);
      
    VTMP.Samples[SamNum].Loop := NL;

    if UpdateUpDown then
      SampleLoopUpDown.Position := NL;

    if Samples.Focused then
      Samples.HideMyCaret;
    Samples.RedrawSamples(0);
    if Samples.Focused then
      Samples.ShowMyCaret;
  end
end;

procedure TMDIChild.ClearShownOrnament;
var i: Integer;
begin
  if Ornaments.ShownOrnament = nil then Exit;

  for i := 0 to MaxOrnLen-1 do
    Ornaments.ShownOrnament.Items[i] := 0;

  with Ornaments do begin
    CursorY := 0;
    CursorX := 0;
    ShownFrom := 0;
    ShownOrnament.Length := 1;
    ShownOrnament.Loop := 0;
    SetCaretPosition;
  end;
  OrnamentLenUpDown.Position := 1;
  OrnamentLoopUpDown.Position := 0;

  SongChanged := True;
  BackupSongChanged := True;
end;


procedure TMDIChild.ClearShownSample;
var
  Sample: TSample;
begin
  if Samples.ShownSample = nil then Exit;
  Sample := GetEmptySample;
  with Samples do begin
    ShownSample.Items   := Sample.Items;
    ShownSample.Length  := Sample.Length;
    ShownSample.Loop    := Sample.Loop;
    ShownSample.Enabled := True;
    CursorY             := 0;
    ShownFrom           := 0;
    SetCaretPosition;
  end;
  SampleLenUpDown.Position  := Sample.Length;
  SampleLoopUpDown.Position := Sample.Loop;

  SongChanged := True;
  BackupSongChanged := True;
end;

procedure TMDIChild.ChangeOrnament(n: Integer);
var
  l: Integer;
begin

  Ornaments.isSelecting := False;
  OrnNum := n;
  with OrnamentTestLine do
  begin
    VTMP.Patterns[-1].Items[0].Channel[0].Ornament := n;
    if Focused then
      HideCaret(Handle);
    RedrawTestLine(0);
    if Focused then
      ShowCaret(Handle);
  end;
  Ornaments.ShownOrnament := VTMP.Ornaments[OrnNum];
  if VTMP.Ornaments[OrnNum] = nil then
    l := 1
  else
    l := VTMP.Ornaments[OrnNum].Length;
  OrnamentLenUpDown.Position := l;
  if VTMP.Ornaments[OrnNum] = nil then
    l := 0
  else
    l := VTMP.Ornaments[OrnNum].Loop;
  OrnamentLoopUpDown.Position := l;
  if not UndoWorking then
  begin
    Ornaments.CursorX := 0;
    Ornaments.CursorY := 0;
    Ornaments.ShownFrom := 0;
  end;
  if Ornaments.Focused then
  begin
    Ornaments.SetCaretPosition;
    Ornaments.HideMyCaret;
  end;
  Ornaments.RedrawOrnaments(0);
  if Ornaments.Focused then
    Ornaments.ShowMyCaret;
end;

procedure TMDIChild.ChangeOrnamentLength(NL: Integer; UpdateUpDown: Boolean);
begin
  Ornaments.isSelecting := False;
  if (VTMP.Ornaments[OrnNum] = nil) and (NL = 1) then
    exit;
  ValidateOrnament(OrnNum);
  if NL <> VTMP.Ornaments[OrnNum].Length then
  begin
    SongChanged := True;
    BackupSongChanged := True;

    if not Ornaments.UndoSaved then
      AddUndo(CAChangeOrnamentSize, VTMP.Ornaments[OrnNum].Length, NL);

    VTMP.Ornaments[OrnNum].Length := NL;
    if not UndoWorking then
    begin

      if not Ornaments.UndoSaved then
        ChangeList[ChangeCount - 1].OldParams.prm.PrevLoop := VTMP.Ornaments[OrnNum].Loop;

      // Decrease loop if length < loop
      if VTMP.Ornaments[OrnNum].Loop >= VTMP.Ornaments[OrnNum].Length then
      begin
        VTMP.Ornaments[OrnNum].Loop := VTMP.Ornaments[OrnNum].Length - 1;
        OrnamentLoopUpDown.Position := VTMP.Ornaments[OrnNum].Loop;
      end;

      if not Ornaments.UndoSaved then
        ChangeList[ChangeCount - 1].NewParams.prm.PrevLoop := VTMP.Ornaments[OrnNum].Loop;

      if UpdateUpDown then
        OrnamentLenUpDown.Position := NL;

      if Ornaments.Focused then
        Ornaments.HideMyCaret;
      Ornaments.RedrawOrnaments(0);
      if Ornaments.Focused then
        Ornaments.ShowMyCaret;
    end;
  end
end;

procedure TMDIChild.ChangeOrnamentLoop(NL: Integer; UpdateUpDown: Boolean);
begin
  Ornaments.isSelecting := False;
  if (VTMP.Ornaments[OrnNum] = nil) then
    exit;
  if (NL <> VTMP.Ornaments[OrnNum].Loop) and (NL < VTMP.Ornaments[OrnNum].Length) then
  begin
    SongChanged := True;
    BackupSongChanged := True;

    if not Ornaments.UndoSaved then
      AddUndo(CAChangeOrnamentLoop, VTMP.Ornaments[OrnNum].Loop, NL);

    VTMP.Ornaments[OrnNum].Loop := NL;

    if UpdateUpDown then
      OrnamentLoopUpDown.Position := NL;

    if Ornaments.Focused then
      Ornaments.HideMyCaret;
    Ornaments.RedrawOrnaments(0);
    if Ornaments.Focused then
      Ornaments.ShowMyCaret;
  end
end;

procedure TMDIChild.ValidateSample2;
begin
  ValidateSample(sam, VTMP);
  if sam = SamNum then
    Samples.ShownSample := VTMP.Samples[SamNum];
end;

procedure TMDIChild.ValidateOrnament;
var
  i: Integer;
begin
  if VTMP.Ornaments[Orn] = nil then
  begin
    New(VTMP.Ornaments[Orn]);
    VTMP.Ornaments[Orn].Loop := 0;
    VTMP.Ornaments[Orn].Length := 1;
    for i := 0 to MaxOrnLen - 1 do
      VTMP.Ornaments[Orn].Items[i] := 0;
    if Orn = OrnNum then
      Ornaments.ShownOrnament := VTMP.Ornaments[OrnNum]
  end
end;

procedure TMDIChild.SampleLoopEditExit(Sender: TObject);
var
  NewValue, SamLen: Integer;
  AllowChange: Boolean;
begin

  AllowChange := True;
  NewValue := SampleLoopUpDown.Position;

  if Samples.ShownSample = nil then
    SamLen := 1
  else
    SamLen := Samples.ShownSample.Length;

  if DecBaseLinesOn then
    if IsDecValid(SampleLoopEdit.Text) then
      NewValue := StrToInt(SampleLoopEdit.Text)
    else
      AllowChange := False;

  if not DecBaseLinesOn then
    if IsHexValid(SampleLoopEdit.Text) then
      NewValue := StrToInt('$' + SampleLoopEdit.Text)
    else
      AllowChange := False;

  if (NewValue > MaxSamLen) or (NewValue > SamLen) then
    AllowChange := False;

  if AllowChange then
    SampleLoopUpDown.Position := NewValue
  else if DecBaseLinesOn then
    SampleLoopEdit.Text := IntToStr(SampleLoopUpDown.Position)
  else
    SampleLoopEdit.Text := IntToHex(SampleLoopUpDown.Position, 2);

  //ChangeSampleLoop(SampleLoopUpDown.Position)
end;

procedure TMDIChild.SampleLoopUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
var
  l: Integer;
begin
  if VTMP.Samples[SamNum] = nil then
    l := 1
  else
    l := VTMP.Samples[SamNum].Length;
  AllowChange := (NewValue >= 0) and (NewValue < l);

  if AllowChange then
  begin
    SamplesSelectionOff;
    
    if DecBaseLinesOn then
      SampleLoopEdit.Text := IntToStr(NewValue)
    else
      SampleLoopEdit.Text := IntToHex(NewValue, 2);

    ChangeSampleLoop(NewValue, False);
  end;
end;

procedure TMDIChild.CalculatePos0;
begin
  PosBegin := GetPositionTime(VTMP, PositionNumber, PosDelay);
  LineInts := 0;
  //Label25.Caption := IntsToTime(PosBegin);
  ReCalcTimes(PosBegin);
  UpdateIntsInfo(PosBegin);
  SinchronizeModules;
end;

procedure TMDIChild.CalculatePos;
var
  i: Integer;
begin
  if (PositionNumber >= VTMP.Positions.Length) or (VTMP.Positions.Value[PositionNumber] <> PatNum) then
    exit;
  LineInts := GetPositionTimeEx(VTMP, PositionNumber, PosDelay, Line);
  i := PosBegin + LineInts;
  ReCalcTimes(i);
  UpdateIntsInfo(i);
  MainForm.StatusBar.Refresh;
  SinchronizeModules;
end;

procedure TMDIChild.CheckStringGrid1Position;
var
  sel: TGridRect;
begin

  if Closed then Exit;

  if VTMP.Positions.Length = 0 then begin
    sel.Left := 0;
    sel.Right := 0;
    sel.Top := 0;
    sel.Bottom := 0;
    StringGrid1.Selection := sel;
    Exit;
  end;

  if (StringGrid1.Selection.Left <> StringGrid1.Selection.Right) then begin
    sel.Left := PositionNumber;
    sel.Right := PositionNumber;
    sel.Top := 0;
    sel.Bottom := 0;
    StringGrid1.Selection := sel;
  end;

  if (StringGrid1.Selection.Left > VTMP.Positions.Length - 1) then begin
    SelectPosition2(VTMP.Positions.Length - 1);
   { sel.Left := VTMP.Positions.Length - 1;
    sel.Right := sel.Left;
    sel.Top := 0;
    sel.Bottom := 0;
    StringGrid1.Selection := sel;   }
  end;

  if (TSWindow = nil) or (TSWindow.Closed) or not TSWindow.Visible then Exit;

  if (TSWindow.StringGrid1.Selection.Left > TSWindow.VTMP.Positions.Length - 1) then begin
    TSWindow.SelectPosition2(TSWindow.VTMP.Positions.Length - 1);
{    sel.Left := TSWindow.VTMP.Positions.Length - 1;
    sel.Right := sel.Left;
    sel.Top := 0;
    sel.Bottom := 0;
    TSWindow.StringGrid1.Selection := sel; }
  end;

end;


procedure TMDIChild.ShowStat;
begin
  if Closed then Exit;

  CheckStringGrid1Position;

  if VTMP.Positions.Length = 0 then begin
    MainForm.StatusBar.Panels[1].Text := '0:0:0';
    MainForm.StatusBar.Panels[2].Text := '0:00 / 0:04';
    Exit;
  end;

  if (VTMP <> nil) and (VTMP.Positions.Length > 0) and (StringGrid1.Selection.Left < VTMP.Positions.Length) and (VTMP.Positions.Value[PositionNumber] = PatNum) then
    //CalculatePos(Tracks.ShownFrom + Tracks.CursorY - Tracks.N1OfLines)
    CalculatePos(Tracks.ShownFrom)
end;

procedure TMDIChild.UpdateIntsInfo(PSBegin: Integer);
begin
  MainForm.StatusBar.Panels[1].Text :=
    IntToStr(PSBegin) + ':' +
    IntToStr(LineInts) + ':' +
    IntToStr(TotInts);
end;

procedure TMDIChild.ShowAllTots;
begin
  //Label20.Caption := IntsToTime(TotInts);
  ReCalcTimes(PosBegin);
  UpdateIntsInfo(PosBegin);
  MainForm.StatusBar.Refresh;
end;

procedure TMDIChild.CalcTotLen;
begin
  TotInts := GetModuleTime(VTMP);
  ShowAllTots
end;

procedure TMDIChild.ReCalcTimes(PSBegin: Integer);
begin
  //Label20.Caption := IntsToTime(TotInts);
  //Label25.Caption := IntsToTime(PosBegin + LineInts)
  MainForm.StatusBar.Panels[2].Text := IntsToTime(PSBegin) +' / '+ IntsToTime(TotInts);
end;

procedure TMDIChild.SetInitDelay(nd: Integer);
begin
  if VTMP.Initial_Delay <> nd then
  begin
    SongChanged := True;
    BackupSongChanged := True;
    AddUndo(CAChangeSpeed, VTMP.Initial_Delay, nd);
    VTMP.Initial_Delay := nd;
    CalcTotLen;
    CalculatePos0;
    if IsPlaying then
      RestartPlayingPos(PositionNumber)
  end
end;

{  // Templates in samples editor disabled
   // People really no need this feature

procedure TMDIChild.ListBox1Click(Sender: TObject);
begin
  MainForm.SetSampleTemplate(ListBox1.ItemIndex)
end;

procedure TMDIChild.SpeedButton13Click(Sender: TObject);
begin
  AddCurrentToSampTemplate
end;

procedure TMDIChild.AddCurrentToSampTemplate;
var
  i: Integer;
begin
  with Samples do
  begin
    if ShownSample = nil then
      exit;
    i := ShownFrom + CursorY;
    if i >= ShownSample.Length then
      exit;
    MainForm.AddToSampTemplate(ShownSample.Items[i])
  end
end;

procedure TMDIChild.SpeedButton14Click(Sender: TObject);
begin
  CopySampTemplateToCurrent
end;

procedure TMDIChild.SpeedButton23Click(Sender: TObject);
begin
  MainForm.ResetSampTemplate
end;

procedure TMDIChild.CopySampTemplateToCurrent;
var
  i, l: Integer;
  ST: PSampleTick;
begin
  with Samples do
  begin
    if ShownSample = nil then
      l := 1
    else
      l := ShownSample.Length;
    i := ShownFrom + CursorY;
    if i >= l then
      exit;
    SongChanged := True;
    ValidateSample2(SamNum);
    New(ST);
    ST^ := ShownSample.Items[i];
    AddUndo(CAChangeSampleValue, Integer(ST), i);
    ShownSample.Items[i] :=
      MainForm.SampleLineTemplates[MainForm.CurrentSampleLineTemplate];
    if Focused then
      HideCaret(Handle);
    RedrawSamples(0);
    if Focused then
      ShowCaret(Handle)
  end
end; }

procedure TMDIChild.OrnamentNumUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
begin
  AllowChange := NewValue in [1..15];
  if AllowChange then
    ChangeOrnament(NewValue)
end;

procedure TMDIChild.OrnamentNumEditChange(Sender: TObject);
begin
  if OrnNum <> OrnamentNumUpDown.Position then
    ChangeOrnament(OrnamentNumUpDown.Position)
end;

procedure TMDIChild.OrnamentNumEditExit(Sender: TObject);
begin
  OrnamentNumEdit.Text := IntToStr(OrnamentNumUpDown.Position)
end;

procedure TMDIChild.OrnamentLoopUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
var
  l: Integer;
begin
  if VTMP.Ornaments[OrnNum] = nil then
    l := 1
  else
    l := VTMP.Ornaments[OrnNum].Length;
  AllowChange := (NewValue >= 0) and (NewValue < l);

  if AllowChange then
  begin
    if DecBaseLinesOn then
      OrnamentLoopEdit.Text := IntToStr(NewValue)
    else
      OrnamentLoopEdit.Text := IntToHex(NewValue, 2);

    ChangeOrnamentLoop(NewValue, False);
  end;
end;

procedure TMDIChild.OrnamentLoopEditExit(Sender: TObject);
var
  NewValue, OrnLen: Integer;
  AllowChange: Boolean;
begin

  AllowChange := True;
  NewValue := OrnamentLoopUpDown.Position;

  if Ornaments.ShownOrnament = nil then
    OrnLen := 1
  else
    OrnLen := Ornaments.ShownOrnament.Length;

  if DecBaseLinesOn then
    if IsDecValid(OrnamentLoopEdit.Text) then
      NewValue := StrToInt(OrnamentLoopEdit.Text)
    else
      AllowChange := False;

  if not DecBaseLinesOn then
    if IsHexValid(OrnamentLoopEdit.Text) then
      NewValue := StrToInt('$' + OrnamentLoopEdit.Text)
    else
      AllowChange := False;

  if (NewValue > MaxOrnLen) or (NewValue > OrnLen) then
    AllowChange := False;

  if AllowChange then
    OrnamentLoopUpDown.Position := NewValue
  else if DecBaseLinesOn then
    OrnamentLoopEdit.Text := IntToStr(OrnamentLoopUpDown.Position)
  else
    OrnamentLoopEdit.Text := IntToHex(OrnamentLoopUpDown.Position, 2);

end;

procedure TMDIChild.OrnamentLenUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
begin
  AllowChange := NewValue in [1..MaxOrnLen];

  if AllowChange then
  begin
    if DecBaseLinesOn then
      OrnamentLenEdit.Text := IntToStr(NewValue)
    else
      OrnamentLenEdit.Text := IntToHex(NewValue, 2);

    ChangeOrnamentLength(NewValue, False);
  end;
end;

procedure TMDIChild.OrnamentLenEditExit(Sender: TObject);
var
  NewValue: Integer;
  AllowChange: Boolean;
begin

  AllowChange := True;
  NewValue := OrnamentLenUpDown.Position;

  if DecBaseLinesOn then
    if IsDecValid(OrnamentLenEdit.Text) then
      NewValue := StrToInt(OrnamentLenEdit.Text)
    else
      AllowChange := False;

  if not DecBaseLinesOn then
    if IsHexValid(OrnamentLenEdit.Text) then
      NewValue := StrToInt('$' + OrnamentLenEdit.Text)
    else
      AllowChange := False;

  if NewValue > MaxOrnLen then
    AllowChange := False;

  if AllowChange then
    OrnamentLenUpDown.Position := NewValue
  else if DecBaseLinesOn then
    OrnamentLenEdit.Text := IntToStr(OrnamentLenUpDown.Position)
  else
    OrnamentLenEdit.Text := IntToHex(OrnamentLenUpDown.Position, 2);


end;

procedure TMDIChild.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if Shift = [ssCtrl] then
  begin
    case Key of
      Ord('E'), VK_NUMPAD0:
        ToggleAutoEnv;
      Ord('R'):
        ToggleAutoStep;
      192:
        begin
{        case PageControl1.TabIndex of
          0: PageControl1.TabIndex:=1;
          1: PageControl1.TabIndex:=0;
        else ;
          PageControl1.TabIndex:=1;
        end;                       }
          PageControl1.TabIndex := 0;
          if Tracks.CanFocus then
            Tracks.SetFocus
        end;
      Ord('1'):
        begin
          PageControl1.TabIndex := 1;
          if Samples.CanFocus then
            Samples.SetFocus
        end;
      Ord('2'):
        begin
          PageControl1.TabIndex := 2;
          if Ornaments.CanFocus then
            Ornaments.SetFocus
        end;
    end
  end
  else if Shift = [ssCtrl, ssAlt] then
    if Key = Ord('E') then
      ToggleStdAutoEnv
end;

procedure TMDIChild.ToggleAutoEnv;
begin
  AutoEnv := not AutoEnv;
  AutoEnvBtn.Down := AutoEnv
end;

procedure TMDIChild.ToggleStdAutoEnv;
begin
  if not AutoEnv then
    ToggleAutoEnv;
  if StdAutoEnvIndex = StdAutoEnvMax then
    StdAutoEnvIndex := 0
  else
    Inc(StdAutoEnvIndex);
  AutoEnv0 := StdAutoEnv[StdAutoEnvIndex, 0];
  AutoEnv1 := StdAutoEnv[StdAutoEnvIndex, 1];
  SpeedButton16.Caption := IntToStr(AutoEnv0);
  SpeedButton18.Caption := IntToStr(AutoEnv1)
end;

procedure TMDIChild.SpeedButton17Click(Sender: TObject);
begin
  ToggleStdAutoEnv
end;

procedure TMDIChild.AutoEnvBtnClick(Sender: TObject);
begin
  ToggleAutoEnv
end;

procedure TMDIChild.SpeedButton16Click(Sender: TObject);
begin
  if not AutoEnv then
    ToggleAutoEnv;
  StdAutoEnvIndex := -1;
  if AutoEnv0 = 9 then
    AutoEnv0 := 1
  else
    Inc(AutoEnv0);
  SpeedButton16.Caption := IntToStr(AutoEnv0)
end;

procedure TMDIChild.SpeedButton18Click(Sender: TObject);
begin
  if not AutoEnv then
    ToggleAutoEnv;
  StdAutoEnvIndex := -1;
  if AutoEnv1 = 9 then
    AutoEnv1 := 1
  else
    Inc(AutoEnv1);
  SpeedButton18.Caption := IntToStr(AutoEnv1)
end;

procedure TMDIChild.DoAutoEnv;
var
  n, old: Integer;
begin
  if AutoEnv then
  begin
    n := VTMP.Patterns[i].Items[j].Channel[k].note;
    if n < 0 then
      exit;
    case VTMP.Patterns[i].Items[j].Channel[k].Envelope of
      8, 12:
        n := round(GetNoteFreq(VTMP.Ton_Table, n) * AutoEnv0 / AutoEnv1 / 16);
      10, 14:
        n := round(GetNoteFreq(VTMP.Ton_Table, n) * AutoEnv0 / AutoEnv1 / 32);
    else
      exit;
    end;
    old := VTMP.Patterns[i].Items[j].Envelope;
    if n = old then
      exit;
    if not UndoWorking then
    begin
      AddUndo(CAChangeEnvelopePeriod, old, n);
      ChangeList[ChangeCount - 1].Line := j;
    end;
    VTMP.Patterns[i].Items[j].Envelope := n;
    SongChanged := True;
    BackupSongChanged := True;
  end
end;

procedure TMDIChild.StringGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var sel: TGridRect;
begin
  if (Shift = []) and (Key = 192) then
    if Tracks.CanFocus then
      Tracks.SetFocus;

  // End pressed
  if Key = VK_END then
  begin
    Sel.Left := VTMP.Positions.Length-1;
    Sel.Right := Sel.Left;
    StringGrid1.Selection := Sel;
    SelectPosition(Sel.Left);
    Key := 0;
  end;
    
end;

procedure TMDIChild.TracksExit(Sender: TObject);
begin
  if (PlayMode = PMPlayLine) and IsPlaying and (PlayingWindow[1] = Self) then
    ResetPlaying;
  Tracks.KeyPressed := 0
end;

procedure TTestLine.TestLineExit(Sender: TObject);
begin
  KeyPressed := 0;
end;

procedure TMDIChild.AutoStepEditExit(Sender: TObject);
begin
  AutoStepEdit.Text := IntToStr(AutoStepUpDown.Position)
end;

function TMDIChild.DoStep(i: Integer; StepForward, ForceAutoStep: Boolean): Boolean;
var
  t: Integer;
begin
  Result := False;
  if not AutoStep and not ForceAutoStep then
    exit;
  t := AutoStepUpDown.Position;
  if t <> 0 then
  begin
    if StepForward then
      Inc(t, i)
    else
      t := i - t;
    if (t >= 0) and (t < Tracks.ShownPattern.Length) then
    begin
      Result := True;
      Tracks.ShownFrom := t;
      if Tracks.CursorY <> Tracks.N1OfLines then
      begin
        Tracks.CursorY := Tracks.N1OfLines;
        Tracks.SetCaretPosition;
      end;
      Tracks.RemoveSelection;
    end;
  end;
end;

procedure TMDIChild.SaveOrnamentFile(FullPath: String);
var Index: Integer;
begin
  AssignFile(TxtFile, FullPath);
  Rewrite(TxtFile);
  try
    Writeln(TxtFile, '[Ornament]');
    SaveOrnament(VTMP, OrnamentNumUpDown.Position);

    // User save ornament to a current FileBrowser directory
    if ExtractFileDir(FullPath) = ExtractFileDir(OrnamentsBrowser.CurrentDir) then begin
      OrnamentsBrowser.ReadDir;
      Index := OrnamentsBrowser.GetIndex(ExtractFileName(FullPath));
      if Index <> -1 then
        OrnamentsBrowser.Selected[Index] := True
      else
        OrnamentsBrowser.Selected[0] := True;
    end;

  finally
    CloseFile(TxtFile);
  end;
  
end;


procedure TMDIChild.SaveOrnamentBtnClick(Sender: TObject);
begin
  StopAndRestoreControls;

  SaveTextDlg.Title := 'Save ornament';
  SaveTextDlg.Filter := 'Ornament files|*.vto|Text files|*.txt|All files|*.*';
  SaveTextDlg.DefaultExt := 'vto';
  SaveTextDlg.FileName := 'Ornament ' + IntToStr(OrnamentNumUpDown.Position) + '.vto';
  SaveTextDlg.InitialDir := OrnamentsDir;

  if SaveTextDlg.Execute then
  begin
    OrnamentsDir := ExtractFilePath(SaveTextDlg.FileName);
    SaveOrnamentFile(SaveTextDlg.FileName);
  end
end;


procedure TMDIChild.LoadOrnamentBtnClick(Sender: TObject);
begin
  StopAndRestoreControls;
  
  LoadTextDlg.Title := 'Load ornament';
  LoadTextDlg.Filter := 'Ornament files|*.vto|Text files|*.txt|All files|*.*';
  LoadTextDlg.DefaultExt := 'vto';
  LoadTextDlg.FileName   := '';
  LoadTextDlg.InitialDir := OrnamentsDir;

  if LoadTextDlg.Execute then
  begin
    OrnamentsDir := ExtractFilePath(LoadTextDlg.FileName);
    LoadOrnament(LoadTextDlg.FileName);
  end;
end;

procedure TMDIChild.LoadOrnament(FN: string; Index: Integer = -1);
var
  f: TextFile;
  s: string;
  Orn: POrnament;

begin
  if not OrnamentLenUpDown.Enabled then
  begin
    ShowMessage('Stop playing before loading ornament');
    exit
  end;

  AssignFile(f, FN);
  Reset(f);
  try
    repeat
      if eof(f) then
      begin
        ShowMessage('Ornament data not found');
        exit
      end;
      Readln(f, s);
      s := UpperCase(Trim(s));
    until s = '[ORNAMENT]';
    Readln(f, s);
  finally
    CloseFile(f)
  end;
  New(Orn);
  if not RecognizeOrnamentString(s, Orn) then
  begin
    ShowMessage('Bad file structure');
    Dispose(Orn)
  end
  else
  begin

    if Index = -1 then begin
      SongChanged := True;
      BackupSongChanged := True;
      AddUndo(CALoadOrnament, 0, 0);
      ChangeList[ChangeCount - 1].Ornament := VTMP.Ornaments[OrnNum];
      VTMP.Ornaments[OrnNum] := Orn;
      Ornaments.CursorX := 0;
      Ornaments.CursorY := 0;
      Ornaments.ShownFrom := 0;
      ChangeOrnament(OrnNum);
      ChangeList[ChangeCount - 1].NewParams.prm.OrnamentCursor := Ornaments.CursorY + Ornaments.CursorX div OrnNChars * Ornaments.NRaw;
      ChangeList[ChangeCount - 1].NewParams.prm.OrnamentShownFrom := 0;
    end
    else begin
      if VTMP.Ornaments[Index] <> nil then begin
        Dispose(VTMP.Ornaments[Index]);
        VTMP.Ornaments[Index] := nil;
      end;
      VTMP.Ornaments[Index] := Orn;
    end;
  end;
end;

procedure TMDIChild.SpeedButton21Click(Sender: TObject);
const
  FN = 'VTIITempOrnament.txt';
var
  tmpp, dir: string;
  ExCode: DWORD;
  SI: STARTUPINFO;
  PI: PROCESS_INFORMATION;
begin
  if OrGenRunning then
    exit;
  SetLength(tmpp, MAX_PATH + 1);
  GetTempPath(MAX_PATH, PChar(tmpp));
  tmpp := PChar(tmpp) + FN;
  if FileExists(tmpp) then
    if not DeleteFile(tmpp) then
    begin
      ShowMessage('Plug-in communication error: cannot delete file.');
      exit
    end;
  dir := ExtractFilePath(ParamStr(0));
  FillChar(SI, sizeof(SI), 0);
  SI.cb := sizeof(SI);
  if not CreateProcess(PChar(dir + 'orgen.exe'), PChar(dir + 'orgen.exe ' + FN), nil, nil, False, 0, nil, PChar(dir), SI, PI) then
    RaiseLastOSError
  else
  begin
    OrGenRunning := True;
    SpeedButton21.Enabled := False;
    repeat
      if not GetExitCodeProcess(PI.hProcess, ExCode) then
      begin
        ShowMessage('Plug-in communication error: no answer.');
        OrGenRunning := False;
        SpeedButton21.Enabled := True;
        exit
      end;
      if ExCode = STILL_ACTIVE then
        Application.ProcessMessages
    until ExCode <> STILL_ACTIVE;
    OrGenRunning := False;
    SpeedButton21.Enabled := True;
    if FileExists(tmpp) then
    begin
      LoadOrnament(tmpp);
      ChangeList[ChangeCount - 1].Action := CAOrGen;
      DeleteFile(tmpp)
    end
  end
end;

procedure TMDIChild.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  res: Integer;
begin

  CanClose := not (SongChanged or ((TSWindow <> nil) and TSWindow.SongChanged));

  // Save changes dialog
  if not CanClose then begin
    res := MessageDlg('Edition ' + Caption + ' is changed. Save it now?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    CanClose := res in [mrYes, mrNo];
    if res = mrYes then
      SaveModule;
  end;

  if CanClose then begin
    MainForm.RedrawOff;
    Closed := True;
    SongChanged := False;
    BackupSongChanged := False;
    if (TSWindow <> nil) and (not TSWindow.Closed) then begin
      TSWindow.SongChanged := False;
      TSWindow.BackupSongChanged := False;
      TSWindow.Closed := True;
      DrawOffAfterClose := True;

      // When application exit, we no need to close second child manually.
      // Otherwise there will be crash
      if SysCmd <> SC_CLOSE then
        TSWindow.Close;

     // DrawOffAfterClose := False;
    end
  end;

end;

procedure TMDIChild.ToggleAutoStep;
begin
  AutoStep := not AutoStep;
  AutoStepBtn.Down := AutoStep
end;

procedure TMDIChild.AutoStepBtnClick(Sender: TObject);
begin
  ToggleAutoStep;
end;

procedure TMDIChild.OrnamentCopyToUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
begin
  AllowChange := NewValue in [1..15]
end;



procedure TMDIChild.CopyOrnButClick(Sender: TObject);
begin
  copyOrnamentToBuffer(True);
end;


procedure TMDIChild.SampleCopyToUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
begin
  AllowChange := NewValue in [1..31]
end;

procedure TMDIChild.CopySamButClick(Sender: TObject);
begin
  copySampleToBuffer(True);
end;

procedure TMDIChild.SaveSampleFile(FullPath: String);
var Index: Integer;
begin

  AssignFile(TxtFile, FullPath);
  Rewrite(TxtFile);
  try
    Writeln(TxtFile, '[Sample]');
    SaveSample(VTMP, SampleNumUpDown.Position);

    // User save sample to a current FileBrowser directory
    if ExtractFileDir(FullPath) = ExtractFileDir(SamplesBrowser.CurrentDir) then begin
      SamplesBrowser.ReadDir;
      Index := SamplesBrowser.GetIndex(ExtractFileName(FullPath));
      if Index <> -1 then
        SamplesBrowser.Selected[Index] := True
      else
        SamplesBrowser.Selected[0] := True;
    end;

  finally
    CloseFile(TxtFile);
  end;
  
end;

procedure TMDIChild.SaveSampleBtnClick(Sender: TObject);
begin
  StopAndRestoreControls;

  SaveTextDlg.Title      := 'Save sample';
  SaveTextDlg.Filter     := 'Sample files|*.vts|Text files|*.txt|All files|*.*';
  SaveTextDlg.DefaultExt := 'vts';
  SaveTextDlg.FileName   := 'Sample ' + IntToStr(SampleNumUpDown.Position) + '.vts';
  SaveTextDlg.InitialDir := SamplesDir;

  if SaveTextDlg.Execute then
  begin
    SamplesDir := ExtractFilePath(SaveTextDlg.FileName);
    SaveSampleFile(SaveTextDlg.FileName);
  end;

end;

procedure TMDIChild.LoadSampleBtnClick(Sender: TObject);
begin
  StopAndRestoreControls;

  LoadTextDlg.Title := 'Load sample';
  LoadTextDlg.Filter := 'Sample files|*.vts|Text files|*.txt|All files|*.*';
  LoadTextDlg.DefaultExt := 'vts';
  LoadTextDlg.FileName   := '';
  LoadTextDlg.InitialDir := SamplesDir;

  if LoadTextDlg.Execute then
  begin
    SamplesDir := ExtractFilePath(LoadTextDlg.FileName);
    LoadSample(LoadTextDlg.FileName);
  end;
end;

procedure TMDIChild.LoadSample(FN: String; Index: Integer = -1);
var
  s: string;
  Sam: PSample;
begin
  if not SampleLenUpDown.Enabled then
  begin
    ShowMessage('Stop playing before loading sample');
    exit
  end;

  AssignFile(TxtFile, FN);
  Reset(TxtFile);
  try
    repeat
      if eof(TxtFile) then
      begin
        ShowMessage('Sample data not found');
        exit
      end;
      Readln(TxtFile, s);
      s := Trim(s);
    until UpperCase(s) = '[SAMPLE]';
    New(Sam);
    s := LoadSampleDataTxt(Sam, False);
    if s <> '' then
    begin
      Dispose(Sam);
      ShowMessage(s);
      exit
    end
  finally
    CloseFile(TxtFile)
  end;

  if Index = -1 then begin
    SongChanged := True;
    BackupSongChanged := True;
    
    AddUndo(CALoadSample, 0, 0);
    ChangeList[ChangeCount - 1].Sample := VTMP.Samples[SamNum];

    VTMP.Samples[SamNum] := Sam;
    ValidateSample2(SamNum);

    Samples.ShownFrom := 0;
    Samples.CursorX := 0;
    Samples.CursorY := 0;
    ChangeSample(SamNum, False);

    SampleLenUpDown.Position  := VTMP.Samples[SamNum].Length;
    SampleLoopUpDown.Position := VTMP.Samples[SamNum].Loop;

    ChangeList[ChangeCount - 1].NewParams.prm.SampleCursorX := 0;
    ChangeList[ChangeCount - 1].NewParams.prm.SampleCursorY := 0;
    ChangeList[ChangeCount - 1].NewParams.prm.SampleShownFrom := 0;
  end
  else begin
    if VTMP.Samples[Index] <> nil then begin
      Dispose(VTMP.Samples[Index]);
      VTMP.Samples[Index] := nil;
    end;
    VTMP.Samples[Index] := Sam;
    ValidateSample2(Index);
  end;
end;

procedure TMDIChild.SpeedButton26Click(Sender: TObject);
begin
  LoadTextDlg.Title := 'Load pattern from text file';
  LoadTextDlg.Filter := 'Pattern files|*.vtp|Text files|*.txt|All files|*.*';
  LoadTextDlg.DefaultExt := 'vtp';

  if LoadTextDlg.Execute then
  begin
    LoadTextDlg.InitialDir := ExtractFilePath(LoadTextDlg.FileName);
    SaveTextDlg.InitialDir := LoadTextDlg.InitialDir;
    LoadPattern(LoadTextDlg.FileName)
  end
end;

procedure TMDIChild.LoadPattern;
var
  s: string;
  i: Integer;
  Pat: PPattern;
  DecNoise: Boolean;
begin
  AssignFile(TxtFile, FN);
  Reset(TxtFile);
  try
    repeat
      if eof(TxtFile) then
      begin
        ShowMessage('Pattern data not found');
        exit
      end;
      Readln(TxtFile, s);
      s := Trim(s);
    until UpperCase(s) = '[PATTERN]';

    repeat
      if eof(TxtFile) then
        Break;
      Readln(TxtFile, s);
      s := Trim(s);
    until (UpperCase(s) = 'DECNOISE') or (UpperCase(s) = 'HEXNOISE');

    if s = 'DecNoise' then
      DecNoise := True
    else
      DecNoise := False;

    New(Pat);
    i := LoadPatternDataTxt(Pat, DecNoise);
    if i <> 0 then
    begin
      Dispose(Pat);
      ShowMessage('Bad file structure');
      exit;
    end;
    ValidatePattern(PatNum, VTMP);
    AddUndo(CALoadPattern, 0, 0);
    ChangeList[ChangeCount - 1].Pattern := VTMP.Patterns[PatNum];
    VTMP.Patterns[PatNum] := Pat;
  finally
    CloseFile(TxtFile)
  end;
  SongChanged := True;
  BackupSongChanged := True;
  //ValidatePattern2(PatNum);
  ChangePattern(PatNum);
  ChangeList[ChangeCount - 1].NewParams.prm.PatternCursorY := Tracks.CursorY;
  ChangeList[ChangeCount - 1].NewParams.prm.PatternShownFrom := Tracks.ShownFrom;
end;

procedure TMDIChild.SpeedButton27Click(Sender: TObject);
var
  p: Integer;
begin
  p := PatternNumUpDown.Position;
  SaveTextDlg.Title := 'Save pattern in text file';
  SaveTextDlg.Filter := 'Pattern files|*.vtp|Text files|*.txt|All files|*.*';
  SaveTextDlg.DefaultExt := 'vtp';
  SaveTextDlg.FileName := 'Pattern ' + IntToStr(p) + '.vtp';

  if SaveTextDlg.Execute then
  begin
    SaveTextDlg.InitialDir := ExtractFilePath(SaveTextDlg.FileName);
    LoadTextDlg.InitialDir := SaveTextDlg.InitialDir;
    AssignFile(TxtFile, SaveTextDlg.FileName);
    Rewrite(TxtFile);
    try
      Writeln(TxtFile, '[Pattern]');
      if DecBaseNoiseOn then
        Writeln(TxtFile, 'DecNoise')
      else
        Writeln(TxtFile, 'HexNoise');
      SavePattern(VTMP, p)
    finally
      CloseFile(TxtFile)
    end
  end
end;

procedure TMDIChild.CopyToFamiTracker;
var
  s: string;
  X1, X2, Y1, Y2, PatLine: Integer;
  FromChan, ToChan, CurChan: Integer;
  ChannelLine: PChannelLine;

  hBuf: THandle;
  Bufptr: Pointer;
  MStream: TMemoryStream;
  FamiClipboard: TFamiTrackerBuffer;
  num: Integer;
  FamiRowsCount: Integer;
  FamiRow: PFamiRow;

begin
  if not Tracks.IsSelected then Exit;
  LastClipboard := LCNone;

  try
    EmptyClipboard;
    X2 := Tracks.CursorX;
    X1 := Tracks.SelX;
    if X1 > X2 then
    begin
      X1 := X2;
      X2 := Tracks.SelX
    end;
    Y1 := Tracks.SelY;
    Y2 := Tracks.CurrentPatLine;
    if Y1 > Y2 then
    begin
      Y1 := Y2;
      Y2 := Tracks.SelY
    end;

    FromChan := 0;
    if (X1 <= 20) then FromChan := 0;
    if (X1 > 20) and (X1 <= 34) then FromChan := 1;
    if (X1 > 34) and (X1 <= 48) then FromChan := 2;

    ToChan := 0;
    if (X2 <= 20) then ToChan := 0;
    if (X2 > 20) and (X2 <= 34) then ToChan := 1;
    if (X2 > 34) and (X2 <= 48) then ToChan := 2;


    FamiClipboard.Channels := ToChan-FromChan+1;
    FamiClipboard.Rows := Y2-Y1+1;
    FamiClipboard.SelectStart := 0;
    FamiClipboard.SelectEnd := 3;
    FamiClipboard.undefined1 := 0;
    FamiClipboard.undefined2 := 0;

    // Note poses [8, 22, 36]

    FamiRowsCount := 0;

    for CurChan := FromChan to ToChan do begin
      for PatLine := Y1 to Y2 do begin

        SetLength(FamiClipboard.Data, FamiRowsCount+1);
        ChannelLine := @VTMP.Patterns[PatNum].Items[PatLine].Channel[ChanAlloc[CurChan]];
        FamiRow     := @FamiClipboard.Data[FamiRowsCount];

        // Note
        if ChannelLine.Note <> -1 then begin
          s := NoteToStr(ChannelLine.Note);
          if s = 'R--' then begin
            FamiRow.Note := $0e;
          end
          else begin
            num := pos(s[1]+s[2], FamiNotes);
            FamiRow.Note := (num+1) div 2;
            FamiRow.Octave := StrToInt(s[3]);
          end;
        end;

        // Sample
        if ChannelLine.Sample > 0 then
          FamiRow.Instrument := ChannelLine.Sample - 1
        else
          FamiRow.Instrument := $40;

        // Volume
        if ChannelLine.Volume > 0 then
          FamiRow.NoteVolume := ChannelLine.Volume
        else
          FamiRow.NoteVolume := $10;

        // Command -> FX
        case ChannelLine.Additional_Command.Number of

          // Tone slide up
          2: begin
            FamiRow.fx1cmd := $10;
            FamiRow.fx1prm := ChannelLine.Additional_Command.Parameter;
          end;

          // Tone slide down
          1: begin
            FamiRow.fx1cmd := $11;
            FamiRow.fx1prm := ChannelLine.Additional_Command.Parameter;
          end;

          // Portamento
          3: begin
            FamiRow.fx1cmd := $06;
            FamiRow.fx1prm := ChannelLine.Additional_Command.Parameter;
          end;

          // Vibrato
          6: begin
            FamiRow.fx1cmd := $0b;
            FamiRow.fx1prm := ChannelLine.Additional_Command.Parameter;
          end;

          // Speed
          $B: begin
            FamiRow.fx1cmd := $01;
            FamiRow.fx1prm := ChannelLine.Additional_Command.Parameter;
          end;

          else
            FamiRow.fx1cmd := 0;
            FamiRow.fx1prm := 0;

        end;
        FamiRow.fx2cmd := 0;
        FamiRow.fx2prm := 0;
        FamiRow.fx3cmd := 0;
        FamiRow.fx3prm := 0;
        FamiRow.fx4cmd := 0;
        FamiRow.fx4prm := 0;

        Inc(FamiRowsCount);
      end;


    end;

    MStream := TMemoryStream.Create;
    MStream.Write(FamiClipboard,sizeof(FamiClipboard)-4);
    MStream.Write(FamiClipboard.data[0],length(FamiClipboard.Data)*12);

    try
      // write data to the stream
      hBuf := GlobalAlloc(GMEM_MOVEABLE, MStream.Size);
      try
        BufPtr := GlobalLock(hBuf);
        try
          Move(MStream.Memory^, BufPtr^, MStream.Size);
          Clipboard.SetAsHandle(FamiClipboardType, hBuf);
        finally
          GlobalUnlock(hBuf);
        end;
      except
        GlobalFree(hBuf);
      end;
    finally
      MStream.Free;
    end;

  finally
    CloseClipboard;
  end;

  Tracks.RemoveSelection;
  Tracks.HideMyCaret;
  Tracks.RedrawTracks(0);
  Tracks.ShowMyCaret;
end;

procedure TMDIChild.CopyToModplug;
var
  res, line, s: string;
  X1, X2, Y1, Y2, PatLine: Integer;
  FromChan, ToChan, CurChan: Integer;
  ChannelLine: PChannelLine;

begin
  if not Tracks.IsSelected then Exit;
  LastClipboard := LCNone;

  res := 'ModPlug Tracker MOD'#13#10;
  try
    EmptyClipboard;
    X2 := Tracks.CursorX;
    X1 := Tracks.SelX;
    if X1 > X2 then
    begin
      X1 := X2;
      X2 := Tracks.SelX
    end;
    Y1 := Tracks.SelY;
    Y2 := Tracks.CurrentPatLine;
    if Y1 > Y2 then
    begin
      Y1 := Y2;
      Y2 := Tracks.SelY
    end;

    FromChan := 0;
    if (X1 <= 20) then FromChan := 0;
    if (X1 > 20) and (X1 <= 34) then FromChan := 1;
    if (X1 > 34) and (X1 <= 48) then FromChan := 2;

    ToChan := 0;
    if (X2 <= 20) then ToChan := 0;
    if (X2 > 20) and (X2 <= 34) then ToChan := 1;
    if (X2 > 34) and (X2 <= 48) then ToChan := 2;


    // Note poses [8, 22, 36]

    for PatLine := Y1 to Y2 do begin

      for CurChan := FromChan to ToChan do begin
        line := '|...........';
        ChannelLine := @VTMP.Patterns[PatNum].Items[PatLine].Channel[ChanAlloc[CurChan]];

        // Note
        if ChannelLine.Note <> -1 then begin
          s := NoteToStr(ChannelLine.Note);
          if s = 'R--' then begin
            line[2] := '^';
            line[3] := '^';
            line[4] := '^';
          end
          else begin
            line[2] := s[1];
            line[3] := s[2];
            line[4] := s[3];
          end;
        end;

        // Sample
        if ChannelLine.Sample > 0 then begin
          s := Format('%.2d', [ChannelLine.Sample]);
          line[5] := s[1];
          line[6] := s[2];
        end;

        // Volume
        if ChannelLine.Volume > 0 then begin
          s := Format('%.2d', [ChannelLine.Volume * 64 div $F]);
          line[7] := 'v';
          line[8] := s[1];
          line[9] := s[2];
        end;

        // Command
        if ChannelLine.Additional_Command.Number > 0 then begin
          s := Format('%.2x', [ChannelLine.Additional_Command.Parameter]);
          line[11] := s[1];
          line[12] := s[2];

          case ChannelLine.Additional_Command.Number of
            2:  line[10] := '1';  // Tone Slide Up
            1:  line[10] := '2';  // Tone Slide Down
            3:  line[10] := '3';  // Tone Portamento
            6:  line[10] := '4';  // Vibrato
            $B: line[10] := 'F';  // Set Speed
          end;
        end;

        res := res + line;
      end;

      res := res + #13#10;

    end;

    Clipboard.AsText := res;

  finally
    CloseClipboard;
  end;

  Tracks.RemoveSelection;
  Tracks.HideMyCaret;
  Tracks.RedrawTracks(0);
  Tracks.ShowMyCaret;
end;

procedure TMDIChild.CopyToRenoise;
var
  res: string;
  i, X1, X2, Y1, Y2, PatLine, LineIndex: Integer;
  FromChan, ToChan, CurChan: Integer;
  ChannelLine: PChannelLine;

begin
  if not Tracks.IsSelected then Exit;
  LastClipboard := LCNone;
  
  res := '<?xml version="1.0" encoding="UTF-8"?>'#13#10;
  res := res + '<PatternClipboard.BlockBuffer doc_version="0">'#13#10;
  res := res + '<Columns>'#13#10;

  try
    EmptyClipboard;
    X2 := Tracks.CursorX;
    X1 := Tracks.SelX;
    if X1 > X2 then
    begin
      X1 := X2;
      X2 := Tracks.SelX
    end;
    Y1 := Tracks.SelY;
    Y2 := Tracks.CurrentPatLine;
    if Y1 > Y2 then
    begin
      Y1 := Y2;
      Y2 := Tracks.SelY
    end;

    // Note poses [8, 22, 36]
    FromChan := 0;
    if (X1 <= 20) then FromChan := 0;
    if (X1 > 20) and (X1 <= 34) then FromChan := 1;
    if (X1 > 34) and (X1 <= 48) then FromChan := 2;

    ToChan := 0;
    if (X2 <= 20) then ToChan := 0;
    if (X2 > 20) and (X2 <= 34) then ToChan := 1;
    if (X2 > 34) and (X2 <= 48) then ToChan := 2;

    for CurChan := FromChan to ToChan do begin
      res := res + '<Column><Column>'#13#10;
      res := res + '<Lines>'#13#10;
      LineIndex := 0;

      for PatLine := Y1 to Y2 do begin
        ChannelLine := @VTMP.Patterns[PatNum].Items[PatLine].Channel[ChanAlloc[CurChan]];

        if (ChannelLine.Note = -1) and (ChannelLine.Sample = 0) and (ChannelLine.Volume = 0) then begin
          res := res + '<Line/>'#13#10;
          Inc(LineIndex);
          Continue;
        end;

        res := res + Format('<Line index="%d">'#13#10, [LineIndex]);
        res := res + '<NoteColumns><NoteColumn>'#13#10;
        Inc(LineIndex);


        // Note
        if ChannelLine.Note = -2 then
          res := res + '<Note>OFF</Note>'
        else if ChannelLine.Note <> -1 then
          res := res + '<Note>' + NoteToStr(ChannelLine.Note) + '</Note>';

        // Sample
        if ChannelLine.Sample > 0 then
          res := res + Format('<Instrument>%.2d</Instrument>', [ChannelLine.Sample-1]);

        // Volume
        if ChannelLine.Volume > 0 then
          res := res + Format('<Volume>%.2d</Volume>'#13#10, [ChannelLine.Volume * 99 div $F]);

        res := res + '</NoteColumn></NoteColumns></Line>'#13#10;
      end;

      res := res + '</Lines>'#13#10;
      res := res + '<ColumnType>NoteColumn</ColumnType>'#13#10;
      res := res + '<SubColumnMask>true true true false false false false false</SubColumnMask>'#13#10;
      res := res + '</Column>'#13#10;


      // Effects column
      res := res + '<Column><Lines>'#13#10;
      for i := 0 to LineIndex do
        res := res + '<Line/>'#13#10;
      res := res + '</Lines>'#13#10;
      res := res + '<ColumnType>EffectColumn</ColumnType>'#13#10;
      res := res + '<SubColumnMask>false false false false false true true false</SubColumnMask>'#13#10;
      res := res + '</Column>'#13#10;
      
      res := res + '</Column>'#13#10;
    end;


    res := res + '</Columns>'#13#10;
    res := res + '</PatternClipboard.BlockBuffer>'#13#10;

    Clipboard.AsText := res;
  finally
    CloseClipboard;
  end;

  Tracks.RemoveSelection;
  Tracks.HideMyCaret;
  Tracks.RedrawTracks(0);
  Tracks.ShowMyCaret;

end;

procedure TMDIChild.PasteFamiTrackerPattern;
var
  i, j, CurChan, StartChan, PatLine, FamiLine: Integer;
  Note: ShortInt;
  str: String;
  ChannelLine: PChannelLine;

  hBuf: THandle;
  BufPtr: Pointer;
  MStream: TMemoryStream;
  FamiClipboard: TFamiTrackerBuffer;
  FamiRowsSize: integer;
  FamiRow: PFamiRow;

begin
  if not Clipboard.HasFormat(FamiClipboardType) then Exit;
  hBuf := Clipboard.GetAsHandle(FamiClipboardType);
  if hBuf = 0 then Exit;
  BufPtr := GlobalLock(hBuf);
  if BufPtr = nil then begin
    GlobalUnlock(hBuf);
    Exit;
  end;

  SavePatternUndo;

  try
    MStream := TMemoryStream.Create;
    try
      MStream.WriteBuffer(BufPtr^, GlobalSize(hBuf));
      MStream.Position := 0;

      // read header (24 bytes)
      MStream.Read(FamiClipboard, 24);

      // Calculating rows count (records)
      FamiRowsSize := (MStream.Size-24) div 12;

      // memory alloc
      SetLength(FamiClipboard.Data, FamiRowsSize);

      // read all Fami's rows (bytes: 12 per record)
      MStream.Read(FamiClipboard.Data[0], FamiRowsSize*12);

      // now
      // FamiClipboard.Channels == selection channels count
      // FamiClipboard.Rows == selection rows count
      // FamiClipboard.SelectStart == selection start (channel relative)
      // FamiClipboard.SelectEnd == selection end (channel relative)

      // FamiClipboard.Data filled with TFamiRow records
      // For (i=0;i<Rows;++i)
      // For (j=0;j<Channels;++j)

      // TFamiRow
      // FamiClipboard.Data[i].Note          ( C = 1; C# = 2; B = 12; Note cut = 14 )
      // FamiClipboard.Data[i].Octave        ( 0..7 )
      // FamiClipboard.Data[i].NoteVolume    ( 0..15 )
      // FamiClipboard.Data[i].Instrument    ( 0..63 )
      // FamiClipboard.Data[i].fx1cmd .. FamiClipboard.Data[i].fx4cmd - 4 bytes
      // FamiClipboard.Data[i].fx1prm .. FamiClipboard.Data[i].fx4prm - 4 bytes
      // EOF TFamiRow: 12 bytes total

    finally
      MStream.Free;
    end;
  finally
    GlobalUnlock(hBuf);
  end;

  
  // Paste to Vortex patterns:

  StartChan := 0;
  if (Tracks.CursorX <= 20) then StartChan := 0;
  if (Tracks.CursorX > 20) and (Tracks.CursorX <= 34) then StartChan := 1;
  if (Tracks.CursorX > 34) and (Tracks.CursorX <= 48) then StartChan := 2;

  FamiLine := 0;
  CurChan  := StartChan;
  for j := 0 to FamiClipboard.Channels-1 do begin

    PatLine := Tracks.CurrentPatLine;
    for i := 0 to FamiClipboard.Rows-1 do begin

      ChannelLine := @VTMP.Patterns[PatNum].Items[PatLine].Channel[ChanAlloc[CurChan]];
      FamiRow     := @FamiClipboard.Data[FamiLine];
      Inc(FamiLine);
      ChannelLine.Ornament := 0;
      ChannelLine.Envelope := 0;

      // Note
      if (FamiRow.Note = 0) and (FamiRow.Octave = 0) then
        Note := -1
      else if FamiRow.Note = 14 then
        Note := -2
      else begin
        str := FamiNotes[FamiRow.Note*2-1] + FamiNotes[FamiRow.Note*2] + IntToStr(FamiRow.Octave);
        Note := SGetNote2(str);
      end;
      ChannelLine.Note := Note;

      // Sample
      if FamiRow.Instrument <> 64 then
        ChannelLine.Sample := (FamiRow.Instrument+1) and 31
      else
        ChannelLine.Sample := 0;

      // Volume
      if FamiRow.NoteVolume <= $F then
        ChannelLine.Volume := FamiRow.NoteVolume
      else
        ChannelLine.Volume := 0;


      // Command
      case FamiRow.fx1cmd of

        // Tone slide up
        $10: begin
          ChannelLine.Additional_Command.Number    := 2;
          ChannelLine.Additional_Command.Parameter := FamiRow.fx1prm;
        end;

        // Tone slide down
        $11: begin
          ChannelLine.Additional_Command.Number    := 1;
          ChannelLine.Additional_Command.Parameter := FamiRow.fx1prm;
        end;

        // Portamento
        $06: begin
          ChannelLine.Additional_Command.Number    := 3;
          ChannelLine.Additional_Command.Parameter := FamiRow.fx1prm;
        end;

        // Vibrato
        $0b: begin
          ChannelLine.Additional_Command.Number    := 6;
          ChannelLine.Additional_Command.Parameter := FamiRow.fx1prm;
        end;

        // Set Volume
        $05: begin
          ChannelLine.Volume := FamiRow.fx1prm;
        end;

        // Set Speed
        $01: if FamiRow.fx1prm < $20 then begin
          ChannelLine.Additional_Command.Number    := $b;
          ChannelLine.Additional_Command.Parameter := FamiRow.fx1prm;
        end;

        else
          ChannelLine.Additional_Command.Number    := 0;
          ChannelLine.Additional_Command.Delay     := 0;
          ChannelLine.Additional_Command.Parameter := 0;
      end;

      Inc(PatLine);
      if PatLine = VTMP.Patterns[PatNum].Length then Break;
    end;

    if CurChan = 2 then Break;
    Inc(CurChan);
  end;

  SavePatternRedo;
  SongChanged := True;
  BackupSongChanged := True;
  
  Tracks.HideMyCaret;
  Tracks.RedrawTracks(0);
  Tracks.ShowMyCaret;
end;

procedure TMDIChild.PasteModPlugPattern(txt: String);
var
  i, j, num, CurChan, StartChan, PatLine: Integer;
  Note: ShortInt;
  Lines, ChanLines: TStrings;
  ChannelLine: PChannelLine;
  ModType: String;

begin

  ModType := 'MOD';
  if AnsiContainsStr(txt, 'MOD') then ModType := 'MOD';
  if AnsiContainsStr(txt, 'S3M') then ModType := 'S3M';
  if AnsiContainsStr(txt, 'XM')  then ModType := 'XM';
  if AnsiContainsStr(txt, 'MPT') then ModType := 'MPT';

  SavePatternUndo;

  StartChan := 0;
  if (Tracks.CursorX <= 20) then StartChan := 0;
  if (Tracks.CursorX > 20) and (Tracks.CursorX <= 34) then StartChan := 1;
  if (Tracks.CursorX > 34) and (Tracks.CursorX <= 48) then StartChan := 2;
  PatLine := Tracks.CurrentPatLine;


  Lines := TStringList.Create;
  ChanLines := TStringList.Create;

  SplitRegExpr('\r?\n', txt, Lines);

  for i := 1 to Lines.Count-1 do begin
    ChanLines.Clear;

    // Remove more than 3 channels
    Lines[i] := ReplaceRegExpr('^(\|[^|]+)(\|[^|]+)(\|[^|]+).*$', Lines[i], '$1$2$3', True);

    // Get parts for each channel
    SplitRegExpr('\|', Lines[i], ChanLines);
    ChanLines.Delete(0);

    CurChan := StartChan;
    for j := 0 to ChanLines.Count-1 do begin
      ChannelLine := @VTMP.Patterns[PatNum].Items[PatLine].Channel[ChanAlloc[CurChan]];
      ChannelLine.Ornament := 0;
      ChannelLine.Envelope := 0;

      // Note
      if ChanLines[j][1] = #0 then Break;
      if ChanLines[j][1] in ['.', ' '] then
        Note := -1
      else if ChanLines[j][1] = '^' then
        Note := -2
      else
        Note := SGetNote2(ChanLines[j][1]+ChanLines[j][2]+ChanLines[j][3]);
      ChannelLine.Note := Note;

      // Sample
      if ChanLines[j][4] = #0 then Break;
      if not (ChanLines[j][4] in ['.', ' ']) and not (ChanLines[j][5] in ['.', ' ']) then begin
        num := StrToInt(ChanLines[j][4]+ChanLines[j][5]) and 31;
        ChannelLine.Sample := num;
      end
      else
        ChannelLine.Sample := 0;

      // Volume
      if ChanLines[j][7] = #0 then Break;
      if not (ChanLines[j][7] in ['.', ' ']) and not (ChanLines[j][8] in ['.', ' ']) then begin
        num := StrToInt(ChanLines[j][7]+ChanLines[j][8]);
        ChannelLine.Volume := $F * num div 64;
      end
      else
        ChannelLine.Volume := 0;

      // Command
      if ChanLines[j][9] = #0 then Break;
      if not (ChanLines[j][9] in ['.', ' ']) and not (ChanLines[j][10] in ['.', ' ']) and not (ChanLines[j][11] in ['.', ' ']) then begin

        if (ModType = 'MOD') or (ModType = 'XM') then
          case ChanLines[j][9] of
            // Tone Slide Up
            '1': ChannelLine.Additional_Command.Number := 2;
            // Tone Slide Down
            '2': ChannelLine.Additional_Command.Number := 1;
            // Tone Portamento
            '3': ChannelLine.Additional_Command.Number := 3;
            // Vibrato
            '4': ChannelLine.Additional_Command.Number := 6;
            // Speed
            'F': ChannelLine.Additional_Command.Number := $b;
          end;

        if (ModType = 'S3M') or (ModType = 'IT') or (ModType = 'MPT') then
          case ChanLines[j][9] of
            // Tone Slide Up
            'F': ChannelLine.Additional_Command.Number := 2;
            // Tone Slide Down
            'E': ChannelLine.Additional_Command.Number := 1;
            // Tone Portamento
            'G': ChannelLine.Additional_Command.Number := 3;
            // Vibrato
            'H': ChannelLine.Additional_Command.Number := 6;
            // Speed
            'A': ChannelLine.Additional_Command.Number := $b;
          end;

        if ChannelLine.Additional_Command.Number <> 0 then
          ChannelLine.Additional_Command.Parameter := StrToInt('$'+ChanLines[j][10]+ChanLines[j][11]);

        // Remove Set Tempo command
        if (ChannelLine.Additional_Command.Number = $b) and (ChannelLine.Additional_Command.Parameter > $20) then begin
          ChannelLine.Additional_Command.Number := 0;
          ChannelLine.Additional_Command.Parameter := 0;
        end;

          {if Ord(ChanLines[j][9]) > Ord('F') then
            num := 0
          else
            num := StrToInt('$' + ChanLines[j][9]) and $F;
          ChannelLine.Additional_Command.Delay := num;
          num := StrToInt('$' + ChanLines[j][10] + ChanLines[j][11]) and $FF;
          ChannelLine.Additional_Command.Parameter := num; }
      end
      else begin
        ChannelLine.Additional_Command.Number    := 0;
        ChannelLine.Additional_Command.Delay     := 0;
        ChannelLine.Additional_Command.Parameter := 0;
      end;

      if CurChan = 2 then Break;
      Inc(CurChan);
    end;

    Inc(PatLine);
    if PatLine = VTMP.Patterns[PatNum].Length then Break;
  end;

  Lines.Free;
  ChanLines.Free;

  SavePatternRedo;
  SongChanged := True;
  BackupSongChanged := True;
  
  Tracks.HideMyCaret;
  Tracks.RedrawTracks(0);
  Tracks.ShowMyCaret;
end;


procedure TMDIChild.PasteRenoisePattern(txt: String);
var
  i, j, CurChan, StartChan, PatLine: Integer;
  Note, Sample, Volume: ShortInt;
  str: String;
  Lines, ChanLines: TStrings;
  ChannelLine: PChannelLine;
  re: TRegExpr;

  function Match(RegExp, Str: String): String;
  begin
    Result := '';
    re.Expression := RegExp;
    if re.Exec(Str) then
      Result := Trim(re.Match[1]);
  end;

begin

  SavePatternUndo;

  StartChan := 0;
  if (Tracks.CursorX <= 20) then StartChan := 0;
  if (Tracks.CursorX > 20) and (Tracks.CursorX <= 34) then StartChan := 1;
  if (Tracks.CursorX > 34) and (Tracks.CursorX <= 48) then StartChan := 2;

  re := TRegExpr.Create;
  re.ModifierI := True;
  re.ModifierS := True;
  re.ModifierM := True;

  // Remove some necessary shit
  re.Expression := '<\?xml[^>]+>';
  txt := re.Replace(txt, '');

  re.Expression := '</?PatternClipboard[^>]+>';
  txt := re.Replace(txt, '');

  re.Expression := '</?Columns?>';
  txt := re.Replace(txt, '');

  re.Expression := '</?Lines>';
  txt := re.Replace(txt, '');

  re.Expression := '<SubColumnMask>[^<]+</SubColumnMask>';
  txt := re.Replace(txt, '');

  re.Expression := '\s+';
  txt := re.Replace(txt, '');


  // Break at columns
  re.Expression := '</ColumnType>';
  txt := re.Replace(txt, '</ColumnType>####');
  ChanLines := TStringList.Create;
  re.Expression := '####';
  re.Split(txt, ChanLines);


  // Delete effects&other columns. Leave just note columns.
  re.Expression := '<ColumnType>NoteColumn</ColumnType>';
  for i := ChanLines.Count-1 downto 0 do
    if (Trim(ChanLines[i]) = '') or not re.Exec(ChanLines[i]) then
      ChanLines.Delete(i);

  Lines := TStringList.Create;
  CurChan := StartChan;
  for i := 0 to ChanLines.Count-1 do begin
    PatLine := Tracks.CurrentPatLine;

    // Break column at lines
    Lines.Clear;
    re.Expression := '<Line[^>]+>';
    re.Split(ChanLines[i], Lines);
    Lines.Delete(0);

    for j := 0 to Lines.Count-1 do begin
      ChannelLine := @VTMP.Patterns[PatNum].Items[PatLine].Channel[ChanAlloc[CurChan]];
      ChannelLine.Ornament := 0;
      ChannelLine.Envelope := 0;

      // Empty line
      if Trim(Lines[j]) = '' then begin
        ChannelLine.Note   := -1;
        ChannelLine.Sample := 0;
        ChannelLine.Volume := 0;
        Inc(PatLine);
        if PatLine = VTMP.Patterns[PatNum].Length then
          Break
        else
          Continue;
      end;

      Note := -1;
      str := Match('^.*<Note>([^<]+)</Note>.*$', Lines[j]);
      if str = 'OFF' then
        Note := -2
      else if Length(str) = 3 then
        Note := SGetNote2(str);

      Sample := 0;
      str := Match('^.*<Instrument>(\d+)</Instrument>.*$', Lines[j]);
      if GetValue(str) <> -1 then
        Sample := (StrToInt(str) + 1) and 31;

      Volume := 0;
      str := Match('^.*<Volume>(\d+)</Volume>.*$', Lines[j]);
      if GetValue(str) <> -1 then
        Volume := $F * StrToInt(str) div 99;

      ChannelLine.Note   := Note;
      ChannelLine.Sample := Sample;
      ChannelLine.Volume := Volume;
      ChannelLine.Additional_Command.Number    := 0;
      ChannelLine.Additional_Command.Delay     := 0;
      ChannelLine.Additional_Command.Parameter := 0;

      Inc(PatLine);
      if PatLine = VTMP.Patterns[PatNum].Length then Break;
    end;

    if CurChan = 2 then Break;
    Inc(CurChan);
  end;

  re.Free;
  Lines.Free;
  ChanLines.Free;

  SavePatternRedo;
  SongChanged := True;
  BackupSongChanged := True;
  
  Tracks.HideMyCaret;
  Tracks.RedrawTracks(0);
  Tracks.ShowMyCaret;

end;


const
  ClipHdrPat = 'Vortex Tracker II v2.0 Pattern'#13#10;

procedure TTracks.CopyToClipboard;
var
  hglbCopy: HGLOBAL;
  s: string;
  lptstrCopy: PChar;
  X1, X2, Y1, Y2, i, l, ps: Integer;
  RepaintDisabled: Boolean;
  // sc:array[0..2] of string;
begin
  if not OpenClipboard(MainForm.Handle) then
    exit;
  RepaintDisabled := False;

  
  // Dirty hack for copy with enabled option 'Envelope as Note'
  if TMDIChild(ParentWin).EnvelopeAsNoteOpt.Checked then
  begin
    // 1. Disable tracks repaint
    MainForm.RedrawOff;
    RepaintDisabled := True;

    // 2. Disable Envelope as Note option (temporary)
    TMDIChild(ParentWin).EnvelopeAsNoteOpt.Checked := False;

    // 3. Redraw Tracks
    RedrawTracks(0);

    // 4. Copy without problems now ...
  end;

  try
    EmptyClipboard;
    X2 := CursorX;
    X1 := SelX;
    if X1 > X2 then
    begin
      X1 := X2;
      X2 := SelX
    end;
    Y1 := SelY;
    Y2 := CurrentPatLine;
    if Y1 > Y2 then
    begin
      Y1 := Y2;
      Y2 := SelY
    end;

    // Note poses [8, 22, 36]

    // 1 channel
    if (X2 >= 8) and (X1 <= 8) then begin
      TracksCopy.Channel  := ChanAlloc[0];
      TracksCopy.Ornament := X2 >= 14;
      TracksCopy.Command  := X2 >= 17;
    end;

    // 2 channel
    if (X2 >= 22) and (X1 <= 22) and (X1 > 8) then begin
      TracksCopy.Channel  := ChanAlloc[1];
      TracksCopy.Ornament := X2 >= 28;
      TracksCopy.Command  := X2 >= 31;
    end;

    // 3 channel
    if (X2 >= 36) and (X1 <= 36) and (X1 > 22) then begin
      TracksCopy.Channel  := ChanAlloc[2];
      TracksCopy.Ornament := X2 >= 36;
      TracksCopy.Command  := X2 >= 39;
    end;

    TracksCopy.SrcWindow := TMDIChild(ParentWin);
    TracksCopy.FromLine  := Y1;
    TracksCopy.ToLine    := Y2;
    TracksCopy.Pattern   := ShownPattern;
    TracksCopy.PatNum    := TMDIChild(ParentWin).PatNum;
    LastClipboard := LCTracks;

    l := Length(ClipHdrPat) + 51 * (Y2 - Y1 + 1) + 1;
    hglbCopy := GlobalAlloc(GMEM_MOVEABLE and GMEM_DDESHARE, l);
    lptstrCopy := GlobalLock(hglbCopy);
    try
      ps := Length(ClipHdrPat);
      Move(ClipHdrPat[1], lptstrCopy^, ps);
      for i := Y1 to Y2 do
      begin
        s := GetPatternLineString(ShownPattern, i, ChanAlloc, True, True) + #13#10;
        for l := 0 to X1 - 1 do
          s[l + TracksCursorXLeft + 1] := #32;
        l := 1;
        if X2 in NotePoses then
          l := TracksCursorXLeft;
        for l := X2 + l to 48 do
          s[l + TracksCursorXLeft + 1] := #32;
        Move(s[4], pointer(Integer(lptstrCopy) + ps)^, 51 + Ord(i = Y2));
        inc(ps, 51)
      end
    finally
      GlobalUnlock(hglbCopy)
    end;
    SetClipboardData(CF_TEXT, hglbCopy)
  finally
    CloseClipboard
  end;

  // End of dirty hack
  if RepaintDisabled then
  begin

    // 5. Enable option 'Envelope as Note' back
    TMDIChild(ParentWin).EnvelopeAsNoteOpt.Checked := True;

    // 6. Redraw tracks again
    RedrawTracks(0);

    // 7. Enable tracks repaint
    MainForm.RedrawOn;
  end;
end;

procedure TTracks.CutToClipboard;
begin
  CopyToClipboard;
  ClearSelection
end;



procedure TTracks.PasteFromClipboard(Merge: Boolean);

  function GetStr(lps: PChar; var s: string): Boolean;
  var
    ps: PChar;
    l: Integer;
  begin
    Result := False;
    ps := StrScan(lps, #13);
    if ps = nil then
      exit;
    l := Integer(ps) - Integer(lps);
    SetLength(s, l);
    Move(lps^, s[1], l);
    Result := True
  end;

var
  hglb: HGLOBAL;
  lps, ps: PChar;
  X1, X2, Y1, Y2, sz, l, i, j, k, m, newe, newn: Integer;
  newc: array[0..2] of TAdditionalCommand;
  s: string;
  nums: array[0..MaxPatLen - 1, 0..32] of Integer;
  re: TRegExpr;
  
begin

  if IsClipboardFormatAvailable(FamiClipboardType) then begin
    TMDIChild(ParentWin).PasteFamiTrackerPattern;
    Exit;
  end;

  if not IsClipboardFormatAvailable(CF_TEXT) then Exit;
  if not OpenClipboard(MainForm.Handle) then Exit;
  try
    hglb := GetClipboardData(CF_TEXT);
    if hglb = 0 then Exit;
    lps := GlobalLock(hglb);
    s := Trim(String(lps));
    GlobalUnlock(hglb);
  finally
    CloseClipboard;
  end;

  // Check buffer format
  re := TRegExpr.Create;
  re.ModifierI := True;
  re.ModifierS := True;
  re.ModifierM := True;

  re.Expression := '^ModPlug Tracker';
  if re.Exec(s) then begin
    re.Free;
    TMDIChild(ParentWin).PasteModPlugPattern(s);
    Exit;
  end;

  re.Expression := '^<\?xml version="1\.0" encoding="UTF-8"\?>\s+<PatternClipboard';
  if re.Exec(s) then begin
    re.Free;
    TMDIChild(ParentWin).PasteRenoisePattern(s);
    Exit;
  end;

  re.Free;
  sz := StrLen(lps);
  if not GetStr(lps, s) then
    exit;
  if (s + #13#10) <> ClipHdrPat then
    exit;
  Integer(ps) := Integer(lps) + Length(s) + 2;
  FillChar(nums, SizeOf(nums), 255);
  l := 0;
  while (Integer(ps) + 2 - Integer(lps) < sz) and (l < MaxPatLen) do
  begin
    if not GetStr(ps, s) then
      exit;

    if DecBaseLinesOn then
      s := copy(s, 2, Length(s));

    inc(Integer(ps), Length(s) + 2);
    if Length(s) <> 49 then
      exit;
    for j := 0 to 3 do
      if s[j + 1] <> #32 then
      begin
        if not SGetNumber(s[j + 1], 15, i) then
          exit;
        nums[l, j] := i
      end;
    if s[6] <> #32 then
    begin
      if DecBaseNoiseOn then
      begin
        if not SGetDecNumber(s[6], 3, i) then
          exit
      end
      else if not SGetNumber(s[6], 1, i) then
        exit;
      //if not SGetNumber(s[6], 1, i) then
      //  exit;
      nums[l, 4] := i
    end;
    if s[7] <> #32 then
    begin
      if DecBaseNoiseOn then
      begin
        if not SGetDecNumber(s[7], 9, i) then
          exit
      end
      else if not SGetNumber(s[7], 15, i) then
        exit;
      nums[l, 5] := i
    end;
    for k := 0 to 2 do
    begin
      if s[9 + k * 14] <> #32 then
      begin
        if not SGetNote(Copy(s, 9 + k * 14, 3), i) then
          exit;
        nums[l, 6 + k * 9] := i + 256
      end;
      if s[13 + k * 14] <> #32 then
      begin
        if not SGetNumber(s[13 + k * 14], 31, i) then
          exit;
        nums[l, 7 + k * 9] := i
      end;
      for j := 0 to 2 do
        if s[14 + k * 14 + j] <> #32 then
        begin
          if not SGetNumber(s[14 + k * 14 + j], 15, i) then
            exit;
          nums[l, 8 + k * 9 + j] := i
        end;
      for j := 0 to 3 do
        if s[18 + k * 14 + j] <> #32 then
        begin
          if not SGetNumber(s[18 + k * 14 + j], 15, i) then
            exit;
          nums[l, 11 + k * 9 + j] := i
        end
    end;
    inc(l);
  end;

  if l = 0 then
    exit;
  i := 0;
  while (i <= 32) and (nums[0, i] < 0) do
    inc(i);
  if i = 33 then
    exit;
  j := 32;
  while (j >= 0) and (nums[0, j] < 0) do
    dec(j);
  with TMDIChild(MainForm.ActiveMDIChild) do
  begin
    SongChanged := True;
    BackupSongChanged := True;
    ValidatePattern2(PatNum);
    AddUndo(CAInsertPatternFromClipboard, 0, 0);
    New(ChangeList[ChangeCount - 1].Pattern);
    ChangeList[ChangeCount - 1].Pattern^ := Tracks.ShownPattern^;
  end;

  X2 := CursorX;
  X1 := SelX;
  if X1 > X2 then
  begin
    X1 := X2;
    X2 := SelX
  end;
  Y1 := SelY;
  Y2 := CurrentPatLine;
  if Y1 > Y2 then
  begin
    Y1 := Y2;
    Y2 := SelY
  end;
  if (X1 = X2) and (Y1 = Y2) then
  begin
    X2 := 48;
    Y2 := ShownPattern.Length - 1
  end;
  if l > Y2 - Y1 + 1 then
    l := Y2 - Y1 + 1;
  for l := 0 to l - 1 do
  begin
    m := X1;
    newe := ShownPattern.Items[Y1 + l].Envelope;
    newn := ShownPattern.Items[Y1 + l].Noise;
    newc[0] := ShownPattern.Items[Y1 + l].Channel[0].Additional_Command;
    newc[1] := ShownPattern.Items[Y1 + l].Channel[1].Additional_Command;
    newc[2] := ShownPattern.Items[Y1 + l].Channel[2].Additional_Command;
    for k := i to j do
      if nums[l, k] >= 0 then
      begin
        if m in NotePoses then
        begin
          if nums[l, k] >= 256 - 2 then
            if not Merge or (nums[l, k] <> 255) then
              ShownPattern.Items[Y1 + l].Channel[ChanAlloc[(m - 8) div 14]].note := nums[l, k] - 256
        end
        else
        begin
          if (m = 5) and not DecBaseNoiseOn then
            sz := 1
          else if (m = 5) and DecBaseNoiseOn then
            sz := 3
          else if (m = 6) and DecBaseNoiseOn then
            sz := 9
          else if m in SamPoses then
            sz := 31
          //else if (m in [5, 6]) and DecBaseLinesOn then // fix for dec noise
          //  sz := 31
          else
            sz := 15;
          if nums[l, k] <= sz then
          begin
            sz := (m - 8) div 14;
            if sz >= 0 then
              sz := ChanAlloc[sz];
            case m of
              0:
                newe := newe and $FFF or (nums[l, k] shl 12);
              1:
                newe := newe and $F0FF or (nums[l, k] shl 8);
              2:
                newe := newe and $FF0F or (nums[l, k] shl 4);
              3:
                newe := newe and $FFF0 or nums[l, k];
              5:
                begin
                  if DecBaseNoiseOn then  // fix for dec noise
                    newn := 10 * nums[l, k]
                  else
                    newn := newn and 15 or (nums[l, k] shl 4);
                end;
              6:
                begin
                  if DecBaseNoiseOn then  // fix for dec noise
                    newn := newn + nums[l, k]
                  else
                    newn := newn and $F0 or nums[l, k];
                end;
              12, 26, 40:
                if not Merge or (nums[l, k] <> 0) then
                  ShownPattern.Items[Y1 + l].Channel[sz].Sample := nums[l, k];
              13, 27, 41:
                if not Merge or (nums[l, k] <> 0) then
                  ShownPattern.Items[Y1 + l].Channel[sz].Envelope := nums[l, k];
              14, 28, 42:
                if not Merge or (nums[l, k] <> 0) then
                  ShownPattern.Items[Y1 + l].Channel[sz].Ornament := nums[l, k];
              15, 29, 43:
                if not Merge or (nums[l, k] <> 0) then
                  ShownPattern.Items[Y1 + l].Channel[sz].Volume := nums[l, k];
              17, 31, 45:
                newc[sz].Number := nums[l, k];
              18, 32, 46:
                newc[sz].Delay := nums[l, k];
              19, 33, 47:
                newc[sz].Parameter := newc[sz].Parameter and 15 or (nums[l, k] shl 4);
              20, 34, 48:
                newc[sz].Parameter := newc[sz].Parameter and $F0 or nums[l, k];
            end;
          end;
        end;
        if m >= 48 then
          break;
        Inc(m);
        if ColSpace(m) then
          Inc(m)
        else if m in [9, 23, 37] then
          Inc(m, 3);
        if m > X2 then
          break;
      end;
    if not Merge or (newe <> 0) then
      ShownPattern.Items[Y1 + l].Envelope := newe;
    if not Merge or (newn <> 0) then
      ShownPattern.Items[Y1 + l].Noise := newn;
    if not Merge or (newc[0].Number <> 0) then
      ShownPattern.Items[Y1 + l].Channel[0].Additional_Command := newc[0];
    if not Merge or (newc[1].Number <> 0) then
      ShownPattern.Items[Y1 + l].Channel[1].Additional_Command := newc[1];
    if not Merge or (newc[2].Number <> 0) then
      ShownPattern.Items[Y1 + l].Channel[2].Additional_Command := newc[2];
  end;
  CursorY := Y1 - ShownFrom + N1OfLines;
  CursorX := X1;
  RemoveSelection;
  RecreateCaret;
  SetCaretPosition;
  with TMDIChild(MainForm.ActiveMDIChild) do
  begin
    DoStep(Y1, True, False);
    ChangeList[ChangeCount - 1].NewParams.prm.PatternCursorY := CursorY;
    ChangeList[ChangeCount - 1].NewParams.prm.PatternShownFrom := ShownFrom;
    CalcTotLen;
    ShowStat;
  end;
  HideMyCaret;
  RedrawTracks(0);
  ShowMyCaret;
end;

procedure TTracks.ClearSelection;
var
  X1, X2, Y1, Y2, c, m: Integer;
  one: Boolean;
begin
  X2 := CursorX;
  X1 := SelX;
  if X1 > X2 then
  begin
    X1 := X2;
    X2 := SelX
  end;
  Y1 := SelY;
  Y2 := CurrentPatLine;
  if Y1 > Y2 then
  begin
    Y1 := Y2;
    Y2 := SelY
  end;
  one := (Y1 = Y2) and (X1 = X2);
  with TMDIChild(ParentWin) do
  begin
    SongChanged := True;
    BackupSongChanged := True;
    ValidatePattern2(PatNum);
    if not one then
    begin
      AddUndo(CAPatternClearSelection, 0, 0);
      New(ChangeList[ChangeCount - 1].Pattern);
      ChangeList[ChangeCount - 1].Pattern^ := VTMP.Patterns[PatNum]^;
      ChangeList[ChangeCount - 1].NewParams.prm.PatternCursorY := CursorY;
      ChangeList[ChangeCount - 1].NewParams.prm.PatternShownFrom := ShownFrom
    end;

    for Y1 := Y1 to Y2 do
    begin
      m := X1;
      repeat
        c := (m - 8) div 14;
        if c >= 0 then
          c := ChanAlloc[c];
        if m in NotePoses then
        begin
          if one then
            ChangeNote(PatNum, Y1, c, -1)
          else
            ShownPattern.Items[Y1].Channel[c].note := -1
        end
        else if one then
          ChangeTracks(PatNum, Y1, c, m, 0, True)
        else
          case m of
            0:
              ShownPattern.Items[Y1].Envelope := ShownPattern.Items[Y1].Envelope and $FFF;
            1:
              ShownPattern.Items[Y1].Envelope := ShownPattern.Items[Y1].Envelope and $F0FF;
            2:
              ShownPattern.Items[Y1].Envelope := ShownPattern.Items[Y1].Envelope and $FF0F;
            3:
              ShownPattern.Items[Y1].Envelope := ShownPattern.Items[Y1].Envelope and $FFF0;
            5:
              ShownPattern.Items[Y1].Noise := ShownPattern.Items[Y1].Noise and 15;
            6:
              ShownPattern.Items[Y1].Noise := ShownPattern.Items[Y1].Noise and $F0;
            12, 26, 40:
              ShownPattern.Items[Y1].Channel[c].Sample := 0;
            13, 27, 41:
              ShownPattern.Items[Y1].Channel[c].Envelope := 0;
            14, 28, 42:
              ShownPattern.Items[Y1].Channel[c].Ornament := 0;
            15, 29, 43:
              ShownPattern.Items[Y1].Channel[c].Volume := 0;
            17, 31, 45:
              ShownPattern.Items[Y1].Channel[c].Additional_Command.Number := 0;
            18, 32, 46:
              ShownPattern.Items[Y1].Channel[c].Additional_Command.Delay := 0;
            19, 33, 47:
              ShownPattern.Items[Y1].Channel[c].Additional_Command.Parameter := ShownPattern.Items[Y1].Channel[c].Additional_Command.Parameter and 15;
            20, 34, 48:
              ShownPattern.Items[Y1].Channel[c].Additional_Command.Parameter := ShownPattern.Items[Y1].Channel[c].Additional_Command.Parameter and $F0;
          end;
        if m >= 48 then
          break;
        Inc(m);
        if ColSpace(m) then
          Inc(m)
        else if m in [9, 23, 37] then
          Inc(m, 3)
      until m > X2
    end;

  end;
  HideMyCaret;
  RedrawTracks(0);
  ShowMyCaret;
  TMDIChild(ParentWin).CalcTotLen;
  TMDIChild(ParentWin).ShowStat
end;

procedure TMDIChild.UpDown15ChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
begin
  AllowChange := (NewValue >= 0) and (NewValue <= MaxPatLen);
  if AllowChange then
    ChangeHLStep(NewValue)
end;

procedure TMDIChild.AutoHLCheckClick(Sender: TObject);
begin
  if AutoHL.Down then
    CalcHLStep;
end;

procedure TMDIChild.CalcHLStep;
var
  PLen, NS: Integer;
begin
  if Tracks.ShownPattern = nil then
    PLen := DefPatLen
  else
    PLen := Tracks.ShownPattern.Length;
  if PLen mod 5 = 0 then
    NS := 5
  else if PLen mod 3 = 0 then
    NS := 3
  else
    NS := 4;
  if NS <> Tracks.HLStep then
    UpDown15.Position := NS
end;

procedure TMDIChild.Edit17Exit(Sender: TObject);
begin
  if not Edit17.Modified then
    exit;
  AutoHL.Down := False;
  Edit17.Text := IntToStr(UpDown15.Position);
  ChangeHLStep(UpDown15.Position)
end;

procedure TMDIChild.ChangeHLStep(NewStep: Integer);
begin
  if NewStep = 0 then
    NewStep := 256;
  if Tracks.HLStep <> NewStep then
  begin
    Tracks.HLStep := NewStep;
    Tracks.RedrawTracks(0);
  end;
end;

procedure TMDIChild.UpDown15Click(Sender: TObject; Button: TUDBtnType);
begin
  AutoHL.Down := False;
end;

procedure TMDIChild.SetLoopPos(lp: Integer);
begin
  SongChanged := True;
  BackupSongChanged := True;
  AddUndo(CAChangePositionListLoop, VTMP.Positions.Loop, lp);
  StringGrid1.Cells[VTMP.Positions.Loop, 0] := IntToStr(VTMP.Positions.Value[VTMP.Positions.Loop]);
  VTMP.Positions.Loop := lp;
  StringGrid1.Cells[VTMP.Positions.Loop, 0] := 'L' + IntToStr(VTMP.Positions.Value[VTMP.Positions.Loop]);
  if StringGrid1.Selection.Left <> lp then
    SelectPosition2(lp)
end;

procedure TMDIChild.AddUndo(CA: TChangeAction; par1, par2: Integer);
var
  i, CurLine, CurChannel: Integer;
begin
  if UndoWorking then Exit;
  inc(ChangeCount);
  DisposeUndo(False);
  i := Length(ChangeList);
  if ChangeCount > i then
    SetLength(ChangeList, i + 64);
  with ChangeList[ChangeCount - 1] do
  begin
    Action := CA;
    case CA of
      CAChangeSpeed, CAChangeToneTable, CAChangePositionListLoop, CAChangeFeatures, CAChangeHeader:
        begin
          OldParams.prm.Value := par1;
          NewParams.prm.Value := par2
        end;
      CAChangeTitle, CAChangeAuthor:
        begin
          StrCopy(OldParams.str, PChar(par1));
          StrCopy(NewParams.str, PChar(par2))
        end;
      CAChangeSampleLoop, CAChangeSampleSize:
        begin
          OldParams.prm.Value := par1;
          NewParams.prm.Value := par2;
          ComParams.CurrentSample := SamNum
        end;
      CAChangeOrnamentLoop, CAChangeOrnamentSize, CAChangeOrnamentValue:
        begin
          OldParams.prm.Value := par1;
          NewParams.prm.Value := par2;
          ComParams.CurrentOrnament := OrnNum
        end;
      CAInsertPosition, CADeletePosition, CAChangePositionsAndPatterns, CAChangePatternSize,
      CAChangeNote, CAChangeNoteAndParams, CAChangeEnvelopePeriod, CAChangeNoise, CAChangeSample,
      CAChangeEnvelopeType, CAChangeOrnament, CAChangeVolume,
      CAChangeSpecialCommandNumber, CAChangeSpecialCommandDelay,
      CAChangeSpecialCommandParameter, CALoadPattern, CAInsertPatternFromClipboard,
      CAPatternInsertLine, CAPatternDeleteLine, CAPatternClearLine,
      CAPatternClearSelection, CATransposePattern, CATracksManagerCopy,
      CAExpandCompressPattern, CAChangePatternContent:
        begin
          OldParams.prm.Value := par1;
          NewParams.prm.Value := par2;
          if CA = CAChangeNoteAndParams then
          begin
            CurLine := Tracks.CurrentPatLine;
            CurChannel := Tracks.CurrentChannel;
            
            OldParams.prm.NoteParam := VTMP.Patterns[PatNum].Items[CurLine].Channel[CurChannel].Note;
            OldParams.prm.SampleParam := VTMP.Patterns[PatNum].Items[CurLine].Channel[CurChannel].Sample;
            OldParams.prm.OrnamentParam := VTMP.Patterns[PatNum].Items[CurLine].Channel[CurChannel].Ornament;
            OldParams.prm.VolumeParam := VTMP.Patterns[PatNum].Items[CurLine].Channel[CurChannel].Volume;
            OldParams.prm.EnvelopeParam := VTMP.Patterns[PatNum].Items[CurLine].Channel[CurChannel].Envelope;

            NewParams.prm.NoteParam := par1;
            NewParams.prm.SampleParam := Tracks.LastNoteParams[CurChannel].Sample;
            NewParams.prm.OrnamentParam := Tracks.LastNoteParams[CurChannel].Ornament;
            NewParams.prm.VolumeParam := Tracks.LastNoteParams[CurChannel].Volume;
            NewParams.prm.EnvelopeParam := Tracks.LastNoteParams[CurChannel].Envelope;
          end;
          if CA in [CATransposePattern, CATracksManagerCopy] then
          begin
            OldParams.prm.CurrentPattern := par1;
            OldParams.prm.PatternCursorX := 0;
            OldParams.prm.PatternCursorY := Tracks.N1OfLines;
            OldParams.prm.PatternShownFrom := 0;
            NewParams.prm.CurrentPattern := par1;
            NewParams.prm.PatternCursorX := 0;
            NewParams.prm.PatternCursorY := Tracks.N1OfLines;
            NewParams.prm.PatternShownFrom := 0;
          end
          else
          begin
            OldParams.prm.CurrentPattern := PatNum;
            OldParams.prm.PatternCursorX := Tracks.CursorX;
            OldParams.prm.PatternCursorY := Tracks.CursorY;
            OldParams.prm.PatternShownFrom := Tracks.ShownFrom;
            NewParams.prm.CurrentPattern := PatNum;
            NewParams.prm.PatternCursorX := Tracks.CursorX;
            NewParams.prm.PatternCursorY := Tracks.CursorY;
            NewParams.prm.PatternShownFrom := Tracks.ShownFrom;
          end;
          if VTMP.Positions.Value[PositionNumber] = PatNum then
          begin
            OldParams.prm.CurrentPosition := PositionNumber;
            NewParams.prm.CurrentPosition := PositionNumber;
          end
          else
          begin
            OldParams.prm.CurrentPosition := -1;
            NewParams.prm.CurrentPosition := -1;
          end;
        end;
      CAChangePositionValue:
        begin
          OldParams.prm.Value := par1;
          NewParams.prm.Value := par2;
          OldParams.prm.PositionListLen := VTMP.Positions.Length;
        end;
      CALoadOrnament, CAOrGen:
        begin
          OldParams.prm.OrnamentCursor := Ornaments.CursorY + Ornaments.CursorX div OrnNChars * Ornaments.NRaw;
          OldParams.prm.OrnamentShownFrom := Ornaments.ShownFrom;
          ComParams.CurrentOrnament := OrnNum;
        end;
      CALoadSample, CAChangeSampleValue:
        begin
          if CA = CAChangeSampleValue then
          begin
            SampleLineValues := PSampleTick(par1);
            Line := par2
          end;
          OldParams.prm.SampleCursorX := Samples.CursorX;
          NewParams.prm.SampleCursorX := Samples.CursorX;
          OldParams.prm.SampleCursorY := Samples.CursorY;
          OldParams.prm.SampleShownFrom := Samples.ShownFrom;
          ComParams.CurrentSample := SamNum;
        end;
    end;
  end;
end;

procedure TMDIChild.DoUndo(Steps: Integer; Undo: Boolean);

  procedure SetF(Page: Integer; Ctrl: TWinControl);
  var
    f: Boolean;
  begin
    f := PageControl1.ActivePageIndex = Page;
    PageControl1.ActivePageIndex := Page;
    case Page of
      0:
        if not f or not (Tracks.Enabled and Tracks.Focused) then
          if Ctrl.CanFocus then
            Ctrl.SetFocus;
      1:
        if not f or not (Samples.Enabled and Samples.Focused) then
          if Ctrl.CanFocus then
            Ctrl.SetFocus;
      2:
        if not f or not (Ornaments.Enabled and Ornaments.Focused) then
          if Ctrl.CanFocus then
            Ctrl.SetFocus;
      3:
        if Ctrl.CanFocus then
          Ctrl.SetFocus;
    end;
  end;

  procedure RedrawTracks(index: Integer; Pars: PChangeParameters; sz: Boolean);
  begin
    with ChangeList[index] do
    begin
      if Pars.prm.CurrentPosition >= 0 then
        SelectPosition2(Pars.prm.CurrentPosition);
      ValidatePattern2(Pars.prm.CurrentPattern);
      Tracks.ShownPattern := VTMP.Patterns[Pars.prm.CurrentPattern];
      if sz then
        PatternLenUpDown.Position := Pars.prm.Size
      else
        PatternLenUpDown.Position := Tracks.ShownPattern.Length;
      if Tracks.Focused then
        Tracks.HideMyCaret;
      Tracks.ShownFrom := Pars.prm.PatternShownFrom;
      Tracks.CursorY := Pars.prm.PatternCursorY;
      Tracks.CursorX := Pars.prm.PatternCursorX;
      Tracks.RemoveSelection;
      Tracks.RedrawTracks(0);
      if Tracks.Focused then
        Tracks.ShowMyCaret
      else
      begin
        PageControl1.ActivePageIndex := 0;
        if Tracks.CanFocus then
          Windows.SetFocus(Tracks.Handle);
      end;
      Tracks.SetCaretPosition;
      Tracks.RecreateCaret;

      ShowStat;
    end;
  end;


var
  Pars: PChangeParameters;
  index: Integer;

  procedure ShowSmp;
  begin
    SongChanged := True;
    BackupSongChanged := True;
    Samples.CursorY := Pars.prm.SampleCursorY;
    Samples.CursorX := Pars.prm.SampleCursorX;
    Samples.ShownFrom := Pars.prm.SampleShownFrom;
    with ChangeList[index] do
    begin
      if SampleNumUpDown.Position = ComParams.CurrentSample then
        ChangeSample(ComParams.CurrentSample, False)
      else
        SampleNumUpDown.Position := ComParams.CurrentSample;
    end;
    if not Samples.Focused then
    begin
      PageControl1.ActivePageIndex := 1;
      if Samples.CanFocus then
        Windows.SetFocus(Samples.Handle)
    end;
  end;


var
  i, j, PatternNumber: Integer;
  Pnt: pointer;
  PosLst: TPosition;
  s: string;
  ST: TSampleTick;
  PatternsState: TChangePatterns;
  NilPatternsState: TNilPatterns;
  PatternState: TChangeOnePattern;
  SampleState: TChangeSample;
  OrnamentState: TChangeOrnament;
  
begin
  UndoWorking := True;
  PatternsState := nil;
  NilPatternsState := nil;
  try
    for i := Steps downto 1 do
    begin
      if Undo then
      begin
        if ChangeCount = 0 then
          exit;
        dec(ChangeCount);
        index := ChangeCount;
        Pars := @ChangeList[index].OldParams
      end
      else
      begin
        if ChangeCount >= ChangeTop then
          exit;
        index := ChangeCount;
        inc(ChangeCount);
        Pars := @ChangeList[index].NewParams
      end;
      with ChangeList[index] do
        case Action of
          CAChangeSpeed:
            begin
              SpeedBpmUpDown.Position := Pars.prm.Speed;
              SpeedBpmEdit.SelectAll;
              SetF(0, SpeedBpmEdit);
              CalcTotLen;
            end;
          CAChangeTitle:
            begin
              Edit3.Text := Pars.str;
              SetF(0, Edit3)
            end;
          CAChangeAuthor:
            begin
              Edit4.Text := Pars.str;
              SetF(0, Edit4)
            end;
          CAChangeToneTable:
            begin
              UpDown4.Position := Pars.prm.Table;
              Edit7.SelectAll;
              SetF(0, Edit7)
            end;
          CAChangeSampleLoop:
            begin
              SampleNumUpDown.Position := ComParams.CurrentSample;
              SampleLoopUpDown.Position := Pars.prm.Loop;
              SampleLoopEdit.SelectAll;
              SetF(1, SampleLoopEdit)
            end;
          CAChangeOrnamentLoop:
            begin
              OrnamentNumUpDown.Position := ComParams.CurrentOrnament;
              OrnamentLoopUpDown.Position := Pars.prm.Loop;
              OrnamentLoopEdit.SelectAll;
              SetF(2, OrnamentLoopEdit)
            end;
          CAChangePatternSize:
            begin
              RedrawTracks(index, Pars, True);
              CalcTotLen;
            end;
          CAChangeNote:
            begin
              ChangeNote(Pars.prm.CurrentPattern, Line, Channel, Pars.prm.Note);
              RedrawTracks(index, @OldParams, False)
            end;
          CAChangeNoteAndParams:
            begin
              ChangeNote(Pars.prm.CurrentPattern, Line, Channel, Pars.prm.NoteParam);
              with VTMP.Patterns[Pars.prm.CurrentPattern].Items[Line].Channel[Channel] do
              begin
                Sample := Pars.prm.SampleParam;
                Ornament := Pars.prm.OrnamentParam;
                Volume := Pars.prm.VolumeParam;
                Envelope := Pars.prm.EnvelopeParam;
              end;
              RedrawTracks(index, @OldParams, False)
            end;
          CAChangeEnvelopePeriod:
            begin
              j := Pars.prm.PatternCursorX;
              if j > 3 then
                j := 0;
              ChangeTracks(Pars.prm.CurrentPattern, Line, Channel, j, Pars.prm.Value, False);
              RedrawTracks(index, @OldParams, False);
            end;
          CAChangeNoise, CAChangeSample, CAChangeEnvelopeType, CAChangeOrnament, CAChangeVolume, CAChangeSpecialCommandDelay:
            begin
              ChangeTracks(Pars.prm.CurrentPattern, Line, Channel, Pars.prm.PatternCursorX, Pars.prm.Value, False);
              RedrawTracks(index, @OldParams, False);
            end;
          CAChangeSpecialCommandNumber, CAChangeSpecialCommandParameter:
            begin
              ChangeTracks(Pars.prm.CurrentPattern, Line, Channel, Pars.prm.PatternCursorX, Pars.prm.Value, False);
              RedrawTracks(index, @OldParams, False);
              CalcTotLen;
            end;
          CALoadPattern, CAInsertPatternFromClipboard, CAPatternInsertLine, CAPatternDeleteLine, CAPatternClearLine, CAPatternClearSelection, CATransposePattern, CATracksManagerCopy, CAExpandCompressPattern:
            begin
              SongChanged := True;
              BackupSongChanged := True;
              Pnt := Pattern;
              Pattern := VTMP.Patterns[Pars.prm.CurrentPattern];
              VTMP.Patterns[Pars.prm.CurrentPattern] := Pnt;
              RedrawTracks(index, Pars, False);
              CalcTotLen;
            end;
          CAChangePositionListLoop:
            begin
              SetLoopPos(Pars.prm.Loop);
              SetF(0, StringGrid1);
              PatternNumUpDown.Position := VTMP.Positions.Value[Pars.prm.Loop]
            end;
          CAChangePositionValue:
            begin
              for j := Pars.prm.PositionListLen to VTMP.Positions.Length - 1 do
                StringGrid1.Cells[j, 0] := '...';
              VTMP.Positions.Length := Pars.prm.PositionListLen;
              if Pars.prm.CurrentPosition < VTMP.Positions.Length then
                ChangePositionValue(Pars.prm.CurrentPosition, Pars.prm.Value);
              if Undo then
                SelectPositions(OldGridSelection)
              else
                SelectPositions(NewGridSelection);
              SetF(0, StringGrid1);
              CalcTotLen;
            end;
          CADeletePosition, CAInsertPosition:
            begin
              PosLst := PositionList^;
              PositionList^ := VTMP.Positions;
              VTMP.Positions := PosLst;
              for j := 0 to 255 do
                if j < VTMP.Positions.Length then
                begin
                  s := IntToStr(VTMP.Positions.Value[j]);
                  if j = VTMP.Positions.Loop then
                    s := 'L' + s;
                  StringGrid1.Cells[j, 0] := s
                end
                else
                  StringGrid1.Cells[j, 0] := '...';

              RedrawPatternPositions;

              // Restore tracks, position and selection
              if Undo then
              begin
                RedrawTracks(index, @OldParams, False);
                SelectPositions(OldGridSelection);
              end
              else
              begin
                RedrawTracks(index, @NewParams, False);
                SelectPositions(NewGridSelection);
              end;
              CalcTotLen;
              InputPNumber := 0;
              SetF(0, StringGrid1)
            end;

          CAChangePositionsAndPatterns:
            begin
              // Undo/Redo positions
              PosLst := PositionList^;
              PositionList^ := VTMP.Positions;
              VTMP.Positions := PosLst;
              PatternsState := ComParams.Patterns^;
              NilPatternsState := ComParams.NilPatterns^;

              // UNDO patterns
              if Undo then
              begin
                // Copy saved patterns back
                for j := Low(PatternsState[0]) to High(PatternsState[0]) do
                begin
                  PatternNumber := PatternsState[0][j].Number;
                  ValidatePattern2(PatternNumber);
                  VTMP.Patterns[PatternNumber].Items := PatternsState[0][j].Pattern.Items;
                  VTMP.Patterns[PatternNumber].Length := PatternsState[0][j].Pattern.Length;
                end;
                // Clear unused patterns
                for j := Low(NilPatternsState) to High(NilPatternsState) do
                  VTMP.Patterns[NilPatternsState[j]] := nil;
              end

              // REDO patterns
              else
              begin
                // Copy saved patterns back
                for j := Low(PatternsState[1]) to High(PatternsState[1]) do
                begin
                  PatternNumber := PatternsState[1][j].Number;
                  ValidatePattern2(PatternNumber);
                  VTMP.Patterns[PatternNumber].Items := PatternsState[1][j].Pattern.Items;
                  VTMP.Patterns[PatternNumber].Length := PatternsState[1][j].Pattern.Length;
                end;
              end;

              RedrawPatternPositions;

              // Restore tracks, position and selection
              if Undo then
              begin
                RedrawTracks(index, @OldParams, False);
                SelectPositions(OldGridSelection);
              end
              else
              begin
                RedrawTracks(index, @NewParams, False);
                SelectPositions(NewGridSelection);
              end;

              CalcTotLen;
              InputPNumber := 0;
              SetF(0, StringGrid1);
            end;

          CAChangePatternContent:
            begin
              PatternState := ComParams.ChangedPattern^;

              // UNDO pattern
              if Undo then
              begin
                PatNum := OldParams.prm.CurrentPattern;
                PositionNumber := OldParams.prm.CurrentPosition;

                Tracks.CursorX   := OldParams.prm.PatternCursorX;
                Tracks.CursorY   := OldParams.prm.PatternCursorY;
                Tracks.ShownFrom := OldParams.prm.PatternShownFrom;
                Tracks.ShownPattern := VTMP.Patterns[PatNum];

                Tracks.ShownPattern.Length := PatternState.OldPattern.Length;
                Tracks.ShownPattern.Items  := PatternState.OldPattern.Items;
                PatternLenUpDown.Position  := Tracks.ShownPattern.Length;
                PatternNumUpDown.Position  := PatNum;

                SelectPositions(OldGridSelection);
              end
              else

              // REDO pattern
              begin
                PatNum := NewParams.prm.CurrentPattern;
                PositionNumber := NewParams.prm.CurrentPosition;

                Tracks.CursorX   := NewParams.prm.PatternCursorX;
                Tracks.CursorY   := NewParams.prm.PatternCursorY;
                Tracks.ShownFrom := NewParams.prm.PatternShownFrom;
                Tracks.ShownPattern := VTMP.Patterns[PatNum];

                Tracks.ShownPattern.Length := PatternState.NewPattern.Length;
                Tracks.ShownPattern.Items  := PatternState.NewPattern.Items;
                PatternLenUpDown.Position  := Tracks.ShownPattern.Length;
                PatternNumUpDown.Position  := PatNum;
                
                SelectPositions(NewGridSelection);
              end;

              Tracks.HideMyCaret;
              Tracks.SetCaretPosition;
              Tracks.RemoveSelection;
              Tracks.RedrawTracks(0);
              Tracks.RecreateCaret;
              Tracks.ShowMyCaret;
              Tracks.KeyPressed := 0;

              CalcTotLen;
              SetF(0, Tracks);
            end;

          CAChangeEntireSample:
            begin
              SampleState := ComParams.EntireSample^;

              // UNDO sample
              if Undo then
              begin
                SampleNumUpDown.Position  := SampleState.Number;
                Samples.ShownFrom := OldParams.prm.SampleShownFrom;
                Samples.CursorX   := OldParams.prm.SampleCursorX;
                Samples.CursorY   := OldParams.prm.SampleCursorY;

                Samples.ShownSample.Length  := SampleState.OldSample.Length;
                Samples.ShownSample.Loop    := SampleState.OldSample.Loop;
                Samples.ShownSample.Enabled := SampleState.OldSample.Enabled;
                Samples.ShownSample.Items   := SampleState.OldSample.Items;
                SampleLoopUpDown.Position   := Samples.ShownSample.Loop;
                SampleLenUpDown.Position    := Samples.ShownSample.Length;

              end
              else

              // REDO sample
              begin
                SampleNumUpDown.Position := SampleState.Number;
                
                Samples.ShownFrom := NewParams.prm.SampleShownFrom;
                Samples.CursorX   := NewParams.prm.SampleCursorX;
                Samples.CursorY   := NewParams.prm.SampleCursorY;

                Samples.ShownSample.Length  := SampleState.NewSample.Length;
                Samples.ShownSample.Loop    := SampleState.NewSample.Loop;
                Samples.ShownSample.Enabled := SampleState.NewSample.Enabled;
                Samples.ShownSample.Items   := SampleState.NewSample.Items;
                SampleLoopUpDown.Position   := Samples.ShownSample.Loop;
                SampleLenUpDown.Position    := Samples.ShownSample.Length;
              end;

              if Samples.Focused then
                Samples.HideMyCaret;
              Samples.RedrawSamples(0);
              if Samples.Focused then
                Samples.ShowMyCaret;
              SetF(1, Samples)

            end;

          CAChangeEntireOrnament:
            begin
              OrnamentState := ComParams.EntireOrnament^;

              // UNDO ornament
              if Undo then
              begin
                SampleNumUpDown.Position    := OrnamentState.Number;
                Ornaments.ShownFrom := OldParams.prm.OrnamentShownFrom;
                Ornaments.Cursor    := OldParams.prm.OrnamentCursor;

                Ornaments.ShownOrnament.Length := OrnamentState.OldOrnament.Length;
                Ornaments.ShownOrnament.Loop   := OrnamentState.OldOrnament.Loop;
                Ornaments.ShownOrnament.Items  := OrnamentState.OldOrnament.Items;
                OrnamentLenUpDown.Position     := Ornaments.ShownOrnament.Length;
                OrnamentLoopUpDown.Position    := Ornaments.ShownOrnament.Loop;
              end
              else

              // REDO ornament
              begin
                SampleNumUpDown.Position  := OrnamentState.Number;
                Ornaments.ShownFrom := NewParams.prm.OrnamentShownFrom;
                Ornaments.Cursor    := NewParams.prm.OrnamentCursor;

                Ornaments.ShownOrnament.Length  := OrnamentState.NewOrnament.Length;
                Ornaments.ShownOrnament.Loop    := OrnamentState.NewOrnament.Loop;
                Ornaments.ShownOrnament.Items   := OrnamentState.NewOrnament.Items;
                OrnamentLenUpDown.Position     := Ornaments.ShownOrnament.Length;
                OrnamentLoopUpDown.Position    := Ornaments.ShownOrnament.Loop;
              end;

              if Ornaments.Focused then
                Ornaments.HideMyCaret;
              Ornaments.RedrawOrnaments(0);
              if Ornaments.Focused then
                Ornaments.ShowMyCaret;
              SetF(2, Ornaments)

            end;

          CAChangeSampleSize:
            begin
              SampleNumUpDown.Position := ComParams.CurrentSample;
              SampleLenUpDown.Position := Pars.prm.Size;
              SampleLoopUpDown.Position := Pars.prm.PrevLoop;
              if Samples.Focused then
                Samples.HideMyCaret;
              Samples.RedrawSamples(0);
              if Samples.Focused then
                Samples.ShowMyCaret;
              SampleLenEdit.SelectAll;
              SetF(1, SampleLenEdit)
            end;
          CAChangeOrnamentSize:
            begin
              OrnamentNumUpDown.Position  := ComParams.CurrentOrnament;
              OrnamentLenUpDown.Position  := Pars.prm.Size;
              OrnamentLoopUpDown.Position := Pars.prm.PrevLoop;
              if Ornaments.Focused then
                Ornaments.HideMyCaret;
              Ornaments.RedrawOrnaments(0);
              if Ornaments.Focused then
                Ornaments.ShowMyCaret;
              OrnamentLenEdit.SelectAll;
              SetF(2, OrnamentLenEdit)
            end;
          CAChangeFeatures:
            begin
              VtmFeaturesGrp.ItemIndex := Pars.prm.NewFeatures;
              SetF(3, VtmFeaturesGrp.Buttons[VtmFeaturesGrp.ItemIndex])
            end;
          CAChangeHeader:
            begin
              SaveHead.ItemIndex := Pars.prm.NewHeader;
              SetF(3, SaveHead.Buttons[SaveHead.ItemIndex])
            end;
          CAChangeOrnamentValue:
            begin
              OrnamentNumUpDown.Position := ComParams.CurrentOrnament;
              VTMP.Ornaments[ComParams.CurrentOrnament].Items[OldParams.prm.OrnamentShownFrom + OldParams.prm.OrnamentCursor] := Pars.prm.Value;
              with Ornaments do
              begin
                if Focused then
                  HideMyCaret;
                CursorY := OldParams.prm.OrnamentCursor mod Ornaments.NRaw;
                CursorX := OldParams.prm.OrnamentCursor div Ornaments.NRaw * OrnNChars;
                Ornaments.SetCaretPosition;
                Ornaments.ShownFrom := OldParams.prm.OrnamentShownFrom;
                RedrawOrnaments(0);
                if Focused then
                  ShowMyCaret
                else
                begin
                  PageControl1.ActivePageIndex := 2;
                  if CanFocus then
                    Windows.SetFocus(Handle);
                end;
              end;
            end;
          CALoadOrnament, CAOrGen, CACopyOrnamentToOrnament:
            begin
              SongChanged := True;
              BackupSongChanged := True;
              Pnt := Ornament;
              Ornament := VTMP.Ornaments[ComParams.CurrentOrnament];
              VTMP.Ornaments[ComParams.CurrentOrnament] := Pnt;
              Ornaments.CursorY := Pars.prm.OrnamentCursor mod Ornaments.NRaw;
              Ornaments.CursorX := Pars.prm.OrnamentCursor div Ornaments.NRaw * OrnNChars;
              Ornaments.ShownFrom := Pars.prm.OrnamentShownFrom;
              if OrnamentNumUpDown.Position = ComParams.CurrentOrnament then
                ChangeOrnament(ComParams.CurrentOrnament)
              else
                OrnamentNumUpDown.Position := ComParams.CurrentOrnament;
              if not Ornaments.Focused then
              begin
                PageControl1.ActivePageIndex := 2;
                if Ornaments.CanFocus then
                  Windows.SetFocus(Ornaments.Handle)
              end;
            end;
          CALoadSample, CACopySampleToSample:
            begin
              Pnt := Sample;
              Sample := VTMP.Samples[ComParams.CurrentSample];
              VTMP.Samples[ComParams.CurrentSample] := Pnt;
              Samples.ShownSample := Pnt;
              ShowSmp;
            end;
          CAChangeSampleValue:
            begin
              Pars := @ChangeList[index].OldParams;
              ST := SampleLineValues^;
              SampleLineValues^ := VTMP.Samples[ComParams.CurrentSample].Items[Line];
              VTMP.Samples[ComParams.CurrentSample].Items[Line] := ST;
              ShowSmp;
            end;
        end;
    end;
  finally
    UndoWorking := False;
  end;
end;

procedure TMDIChild.SaveModuleAs;
begin
  with MainForm do
  begin


    if WinFileName <> '' then
      SaveDialog1.FileName := WinFileName

    else if (TSWindow <> nil) and (TSWindow.WinFileName <> '') then
      SaveDialog1.FileName := TSWindow.WinFileName

    else
      SaveDialog1.FileName := 'MyBestTrack' + IntToStr(WinNumber);

    SaveDialog1.FilterIndex := Ord(not SavedAsText) + 1;


    if AnsiContainsText(WinFileName, VortexDir +'\template.vt2') then
    begin
      SaveDialog1.InitialDir := ExtractFilePath(RecentFiles[0]);
      SaveDialog1.FileName :=''
    end
    else
    if AnsiContainsText(SaveDialog1.FileName, VortexDir) or AnsiContainsText(SaveDialog1.FileName, VortexDocumentsDir) then
      SaveDialog1.FileName := SaveDialog1.InitialDir + ExtractFileName(SaveDialog1.FileName);


    if SaveDialog1.Execute then
    begin
      IsDemosong := False;
      IsTemplate := False;

      if SaveDialog1.FilterIndex = 1 then
        SaveDialog1.FileName := ChangeFileExt(SaveDialog1.FileName, '.vt2')
      else
        SaveDialog1.FileName := ChangeFileExt(SaveDialog1.FileName, '.pt3');

      SaveDialog1.InitialDir := SaveDialog1.FileName;
      SetFileName(SaveDialog1.FileName);
      SavePT3(Self, SaveDialog1.FileName, SaveDialog1.FilterIndex = 1);
    end



  end;
end;

procedure TMDIChild.SaveModule;
var
  s: string;
begin
  if not SongChanged and (TSWindow = nil) then Exit;
  if not SongChanged and not TSWindow.SongChanged then Exit;
  
  if WinFileName = '' then
    SaveModuleAs
  else
  begin
    if SavedAsText then
      s := ChangeFileExt(WinFileName, '.vt2')
    else
      s := ChangeFileExt(WinFileName, '.pt3');
    if s <> WinFileName then
      SetFileName(s);
    MainForm.SavePT3(Self, WinFileName, SavedAsText);
  end;
end;

procedure TMDIChild.SaveModuleBackup;
var
  s, FilePath: string;
begin
  if not SongChanged or (WinFileName = '') or IsDemosong then
    Exit;

  FilePath := WinFileName;

  // Is backup file opened?
  if AnsiContainsText(WinFileName, ' ver ') then
  begin
    // cut ' ver 001.vt2'
    FilePath := AnsiLeftStr(WinFileName, AnsiPos(' ver ', WinFileName)-1);
  end;

  s := ExtractFileDir(FilePath) + '\' + ExtractFileNameEX(FilePath) +
       ' ver ' + Format('%.3d', [BackupVersionCounter]) + '.vt2';

  MainForm.SavePT3Backup(Self, s, True);
  BackupSongChanged := False;
end;

procedure TMDIChild.FormActivate(Sender: TObject);
var
  i: Integer;
begin
  if VTMP = nil then Exit;

  for i := 1 to 31 do
    TogSam[i].Checked := (VTMP.Samples[i] = nil) or VTMP.Samples[i].Enabled;
  SetToolsPattern;

  if (MainForm.MDIChildCount > 2) and (TSWindow <> nil) then
    SetWindowPos(TSWindow.Handle, HWND_TOP, 0,0,0,0, SWP_NOACTIVATE+SWP_NOMOVE+SWP_NOSIZE);

  if Tracks.CanFocus then
    Tracks.SetFocus;
end;

function TMDIChild.PrepareTSString(TSBut: TSpeedButton; s: string): string;
var
  DC: HDC;
  sz: tagSIZE;
  nch: Integer;
begin
  Result := s;
  DC := GetDC(Handle);
  GetTextExtentExPoint(DC, PChar(s), Length(s), TSBut.ClientWidth, @nch, nil, sz);
  ReleaseDC(Handle, DC);
  if nch < Length(s) then
  begin
    Result[nch] := '.';
    Result[nch - 1] := '.';
    Result[nch - 2] := '.';
    SetLength(Result, nch);
  end;
end;

procedure TMDIChild.JoinChild(Child: TMDIChild);
var LeftChild, RightChild: TMDIChild;
begin

  TSWindow := Child;
  Child.TSWindow := Self;
  SongChanged := True;  TSWindow.SongChanged := True;
  IsTemplate  := False; TSWindow.IsTemplate  := False;
  IsDemosong  := False; TSWindow.IsDemosong  := False;  

  TSWindow.Top := Top;
  TSWindow.Height := Height;
  TSWindow.PageControl1.Height := ClientHeight;
  TSWindow.Tracks.Height := Tracks.Height;
  TSWindow.InterfaceOpts.Top := InterfaceOpts.Top;
  TSWindow.InterfaceOpts.Width := InterfaceOpts.Width;
  TSWindow.BetweenPatterns.Left := BetweenPatterns.Left;
  TSWindow.DuplicateNoteParams.Left := DuplicateNoteParams.Left;
  //TSWindow.SmartRedraw;

  if Left < TSWindow.Left then begin
    LeftModule := True;
    TSWindow.LeftModule := False;
    LeftChild := Self;
    RightChild := TSWindow;
  end
  else begin
    LeftModule := False;
    TSWindow.LeftModule := True;
    LeftChild := TSWindow;
    RightChild := Self;
  end;

  if (LeftChild.WinFileName = '') and (RightChild.WinFileName = '') then begin
    LeftChild.Caption  := 'Left turbosound module ' + IntToStr(WinCount);
    RightChild.Caption := 'Right turbosound module ' + IntToStr(WinCount);
  end
  else
  if (LeftChild.WinFileName <> '') and (RightChild.WinFileName = '') then begin
    RightChild.Caption := LeftChild.Caption;
    RightChild.WinFileName := LeftChild.WinFileName;
  end
  else
  begin
    LeftChild.Caption := RightChild.Caption;
    LeftChild.WinFileName := RightChild.WinFileName;
  end;

end;

procedure TMDIChild.SetToolsPattern;
begin
  GlbTrans.Edit2.Text := IntToStr(PatNum);
  TrMng.Edit2.Text := IntToStr(PatNum);
  TrMng.Edit3.Text := IntToStr(PatNum);
end;

procedure TMDIChild.PatternLenEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i: Integer;
begin
  case Key of
    VK_PRIOR:
      begin
        i := PatternLenUpDown.Position + Tracks.HLStep;
        if i > MaxPatLen then
          i := MaxPatLen;
        PatternLenUpDown.Position := i;
      end;
    VK_NEXT:
      begin
        i := PatternLenUpDown.Position - Tracks.HLStep;
        if i <= 0 then
          i := 1;
        PatternLenUpDown.Position := i;
      end;
  end;
end;

procedure TMDIChild.EnvelopeAsNoteOptMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Tracks.SetFocus;
end;

procedure TMDIChild.AutoNumeratePatterns;
var
  StartPos, DestPos, PatterNumber, i,
    PatternLength, LastPatternNumber: Integer;
begin
  if StringGrid1.Selection.Left < VTMP.Positions.Length then
    exit;

  SavePositionsUndo;
  SongChanged := True;
  BackupSongChanged := True;

  StartPos := VTMP.Positions.Length;
  DestPos := StringGrid1.Selection.Left;
  PatterNumber := MaxIntValue(VTMP.Positions.Value);

  // Get length of last pattern
  if StartPos > 0 then
    LastPatternNumber := VTMP.Positions.Value[StartPos-1]
  else
    LastPatternNumber := VTMP.Positions.Value[StartPos];
  PatternLength := VTMP.Patterns[LastPatternNumber].Length;

  // Increase track length
  IncreaseTrackLength(DestPos-StartPos+1);

  // Create new patterns
  if PatterNumber = 0 then Dec(PatterNumber);
  for i := StartPos to DestPos do
  begin
    Inc(PatterNumber);
    if PatterNumber > MaxPatNum then
      exit;
    ValidatePattern2(PatterNumber);
    VTMP.Patterns[PatterNumber].Length := PatternLength;
    VTMP.Positions.Value[i] := PatterNumber;
  end;

  RedrawPatternPositions;
  SelectPosition(DestPos);
  SetStringGrid1Scroll(-1);
  CalcTotLen;

end;

{
procedure TMDIChild.SmartRedraw;
begin

  case PageControl1.ActivePageIndex of

    0: with Tracks do begin
      RedrawTracks(0);
      RemoveSelection(0, True);
      HideMyCaret;
      CreateMyCaret;
      SetCaretPosition;
      ShowMyCaret;
    end;

    1: with Samples do begin
      RedrawSamples(0);
      HideMyCaret;
      CreateMyCaret;
      SetCaretPosition;
      ShowMyCaret;
    end;

    2: with Ornaments do
    begin
      RedrawOrnaments(0);
      HideMyCaret;
      CursorX := 0;
      CreateCaret(Handle, 0, CelW * 3, CelH);
      SetCaretPosition;
      ShowMyCaret;
    end;
  end;
end;
}

procedure TMDIChild.WMEnterSizeMove(var Message:TWMMove);
begin
  DisableAlign;
end;

procedure TMDIChild.WMExitSizeMove(var Message:TWMMove);
begin
  EnableAlign;
end;


procedure TMDIChild.RedrawOff;
begin
  SendMessage(Handle, WM_SETREDRAW, 0, 0);
end;

procedure TMDIChild.RedrawOn;
begin
  SendMessage(Handle, WM_SETREDRAW, 1, 0);
end;


procedure TMDIChild.InvalidateChild;
var
  Rect: TRect;
begin

  if PageControl1.ActivePage = PatternsSheet then begin

    // Invalidate Tracks
    RedrawWindow(Tracks.Handle, nil, 0, RDW_INVALIDATE or RDW_NOERASE or RDW_NOINTERNALPAINT or RDW_UPDATENOW);


    // Invalidate child bootom
    Rect.Top := PatternsSheet.Top + InterfaceOpts.Top;
    Rect.Left := Tracks.Left;
    Rect.Right := ClientWidth;
    Rect.Bottom := ClientHeight;
    RedrawWindow(Handle, @Rect, 0, RDW_INVALIDATE or RDW_NOERASE or RDW_NOINTERNALPAINT or RDW_ALLCHILDREN or RDW_UPDATENOW);


    // Invalidate left border
    Rect.Top := ClientHeight div 2;
    Rect.Left := 0;
    Rect.Right := PatternsSheet.Left;
    Rect.Bottom := ClientHeight;
    InvalidateRect(Handle, @Rect, False);

    // Invalidate right border
    Rect.Top := ClientHeight div 2;
    Rect.Left := ClientWidth - (ClientWidth - Tracks.Left - Tracks.Width);
    Rect.Right := ClientWidth;
    Rect.Bottom := ClientHeight;
    InvalidateRect(Handle, @Rect, False);

  end;


  if PageControl1.ActivePage = SamplesSheet then begin

    // Invalidate sample editor
    RedrawWindow(Samples.Handle, nil, 0, RDW_NOERASE or RDW_INVALIDATE or RDW_UPDATENOW);

    // Invalidate window boottom
    Rect.Top := SampleEditBox.Top + SampleEditBox.Height + 11;
    Rect.Left := 0;
    Rect.Right := ClientWidth;
    Rect.Bottom := ClientHeight;
    RedrawWindow(Handle, @Rect, 0, RDW_NOERASE or RDW_INVALIDATE or RDW_ALLCHILDREN or RDW_UPDATENOW);

    // Invalidate left border
    Rect.Top := ClientHeight div 2;
    Rect.Left := 0;
    Rect.Right := 13;
    Rect.Bottom := ClientHeight;
    RedrawWindow(Handle, @Rect, 0, RDW_NOERASE or RDW_INVALIDATE or RDW_ALLCHILDREN or RDW_UPDATENOW);

    // Invalidate samples browser
    Rect.Top := SampleBrowserBox.Top;
    Rect.Left := SampleBrowserBox.Left - 3;
    Rect.Right := ClientWidth;
    Rect.Bottom := ClientHeight;
    RedrawWindow(Handle, @Rect, 0, RDW_NOERASE or RDW_NOINTERNALPAINT or RDW_INVALIDATE or RDW_ALLCHILDREN or RDW_UPDATENOW);

  end;

  if PageControl1.ActivePage = OrnamentsSheet then begin

    // Invalidate ornaments editor
    RedrawWindow(Ornaments.Handle, nil, 0, RDW_NOINTERNALPAINT or RDW_INVALIDATE or RDW_UPDATENOW);


    // Invalidate window boottom
    Rect.Top := OrnamentEditBox.Top + OrnamentEditBox.Height + 11;
    Rect.Left := 0;
    Rect.Right := ClientWidth;
    Rect.Bottom := ClientHeight;
    RedrawWindow(Handle, @Rect, 0, RDW_NOINTERNALPAINT or RDW_INVALIDATE or RDW_ALLCHILDREN or RDW_UPDATENOW);


    // Invalidate left border
    Rect.Top := ClientHeight div 2;
    Rect.Left := 0;
    Rect.Right := 13;
    Rect.Bottom := ClientHeight;
    RedrawWindow(Handle, @Rect, 0, RDW_NOINTERNALPAINT or RDW_INVALIDATE or RDW_ALLCHILDREN or RDW_UPDATENOW);

    // Invalidate ornaments browser
    Rect.Top := OrnamentsBrowserBox.Top;
    Rect.Left := OrnamentsBrowserBox.Left - 3;
    Rect.Right := ClientWidth;
    Rect.Bottom := ClientHeight;
    RedrawWindow(Handle, @Rect, 0, RDW_NOINTERNALPAINT or RDW_INVALIDATE or RDW_ALLCHILDREN or RDW_UPDATENOW);

  end;


  if (PageControl1.ActivePage = OptTab) or (PageControl1.ActivePage = InfoTab) then begin

    // Invalidate window
    RedrawWindow(Handle, nil, 0, RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN or RDW_UPDATENOW);

  end;

end;


procedure TMDIChild.FormResize(Sender: TObject);
begin
  if (WindowState = wsMaximized) then Exit;
  if ChildsEventsBlocked then Exit;

  ChildsEventsBlocked := True;

  if TSWindow = nil then
    RedrawOff
  else
    MainForm.RedrawOff;   

  PageControl1.Height := ClientHeight;
  HeightChanged := True;
  LastHeight := PageControl1.Height;
  MainForm.LastChildHeight := Height;

  AutoResizeForm;

  if TSWindow <> nil then begin
    TSWindow.Top := Top;
    TSWindow.PageControl1.Height := ClientHeight;
    TSWindow.ClientHeight := ClientHeight;
    TSWindow.HeightChanged := True;
    TSWindow.LastHeight := LastHeight;
    TSWindow.AutoResizeForm;
  end;

  if TSWindow = nil then begin
    RedrawOn;
    InvalidateChild;
  end
  else
    MainForm.RedrawOn;

  ChildsEventsBlocked := False;
end;


procedure TMDIChild.UnloopBtnClick(Sender: TObject);
var
  NextLine, LastLine, UnloopCount, LoopLength, i: Integer;
  TilTheEnd, Done: Boolean;

  LineTone, FreqAccum, LineNoise, NoiseAccum, LineAmplitude, AmplitudeAccum: SmallInt;
  SampleTick: PSampleTick;
  Sample: PSample;
  UnloopDialog: TUnloopDlg;
begin
  if Samples.ShownSample = nil then Exit;

  Samples.isSelecting := False;
  Sample     := Samples.ShownSample;
  NextLine   := Sample.Length;
  LastLine   := MaxSamLen - 1;
  LoopLength := Sample.Length - Sample.Loop;
  Done       := False;

  // If next line goes beyond the sample, then there is nowhere to unloop
  if NextLine > LastLine then begin
    MessageDlg('Unloop is not possible because the sample has a maximum length.' 
      + #13#10 + 'There is nowhere to unloop.',  mtWarning, [mbOK], 0);
    Exit;
  end;

  SaveSampleUndo(Sample);
  SongChanged := True;
  BackupSongChanged := True;

  UnloopDialog := TUnloopDlg.Create(MainForm);
  if UnloopDialog.ShowModal = mrCancel then
    Exit;

  UnloopCount := UnloopDialog.UnloopUpDown.Position;
  TilTheEnd   := UnloopCount = 0;
  repeat
  
    for i := Sample.Loop to Sample.Length - 1 do
    begin
      Sample.Items[NextLine] := Sample.Items[i];

      if NextLine = LastLine then
      begin
        Sample.Length := LastLine + 1;
        Sample.Loop := LastLine;
        Done := True;
        Break;
      end
      else
        Inc(NextLine);
    end;

    if not TilTheEnd and (UnloopCount = 1) then
      Done := True
    else
      Dec(UnloopCount);

  until Done;

  if not TilTheEnd and (NextLine <> LastLine) then
  begin
    Sample.Length := NextLine;
    Sample.Loop := NextLine - LoopLength;
  end;

  SampleLenUpDown.Position := Sample.Length;
  SampleLoopUpDown.Position := Sample.Loop;


  if not UnloopDialog.CalcSlides.Checked then begin
    Samples.RedrawSamples(0);
    SaveSampleRedo;
    Exit;
  end;

  // Re-calculate tone, noise and volume accumulation
  FreqAccum  := 0;
  NoiseAccum := 0;
  AmplitudeAccum := 0;
  for i := 0 to Sample.Length-1 do begin
    SampleTick := @Sample.Items[i];

    // Re-calculate Tone Shift
    LineTone := SampleTick.Add_to_Ton + FreqAccum;
    if SampleTick.Ton_Accumulation then
      Inc(FreqAccum, SampleTick.Add_to_Ton);
    if (LineTone > $FFF) or (LineTone < -$FFF) then
      LineTone := LineTone and $FFF;
    SampleTick.Add_to_Ton := LineTone;
    SampleTick.Ton_Accumulation := False;

    // Re-calculate Noise or Envelope
    LineNoise := SampleTick.Add_to_Envelope_or_Noise + NoiseAccum;
    if SampleTick.Envelope_or_Noise_Accumulation then
      Inc(NoiseAccum, SampleTick.Add_to_Envelope_or_Noise);
    SampleTick.Add_to_Envelope_or_Noise := LineNoise and 31;
    SampleTick.Envelope_or_Noise_Accumulation := False;

    // Re-calculate Amplitude
    LineAmplitude := SampleTick.Amplitude;
    if SampleTick.Amplitude_Sliding then
      if SampleTick.Amplitude_Slide_Up then
      begin
        if AmplitudeAccum < 15 then Inc(AmplitudeAccum)
      end
      else
      begin
        if AmplitudeAccum > -15 then Dec(AmplitudeAccum);
      end;
    Inc(LineAmplitude, AmplitudeAccum);
    if LineAmplitude < 0 then  LineAmplitude := 0;
    if LineAmplitude > 15 then LineAmplitude := 15;
    SampleTick.Amplitude := LineAmplitude;
    SampleTick.Amplitude_Sliding := False;
    SampleTick.Amplitude_Slide_Up := False;

  end;

  Samples.RedrawSamples(0);
  SaveSampleRedo;
end;


procedure TMDIChild.SampleCopyToEditContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True;
  Samples.SetFocus;
end;

procedure TMDIChild.ChangePatternsLength(PatternsLength: Integer);
var
  i, SelectLeft, SelectRight, PatternNumber: Integer;
begin
  // Shortcuts
  SelectLeft := StringGrid1.Selection.Left;
  SelectRight := StringGrid1.Selection.Right;

  // Save positions and patterns for UNDO
  SaveTrackUndo;

  SongChanged := True;
  BackupSongChanged := True;

  for i := SelectLeft to SelectRight do
  begin
    PatternNumber := VTMP.Positions.Value[i];
    VTMP.Patterns[PatternNumber].Length := PatternsLength;
  end;

  // Update current pattern length value
  PatternLenUpDown.Position := PatternsLength;

  CalcTotLen;
  Tracks.RedrawTracks(0);

  // Save new patterns for REDO
  SaveTrackRedo;

end;


procedure TMDIChild.RenumberPatterns;
  var
    NewNumber, OldNumber, i, j: Integer;
    ItemsTable: Array of Array of Smallint;
    NewPatterns: array[-1..MaxPatNum] of PPattern;

  function PatternAdded(const PatternNumber: Smallint) : boolean;
  var i: Integer;
  begin
    for i := Low(ItemsTable) to High(ItemsTable) do
      if PatternNumber = ItemsTable[i][0] then
      begin
        Result := True;
        Exit;
      end;
    Result := False;
  end;

  function GetNewPatternNumber1(const OldPatternNumber: Smallint) : Smallint;
  var i: Integer;
  begin
    Result := 0;
    for i := Low(ItemsTable) to High(ItemsTable) do
      if OldPatternNumber = ItemsTable[i][0] then
      begin
        Result := ItemsTable[i][1]; // Return new number
        Exit;
      end;
  end;


begin

  for i := Low(NewPatterns) to High(NewPatterns) do
    NewPatterns[i] := nil;
  NewPatterns[-1] := VTMP.Patterns[-1];

  // Save undo information
  SavePositionsUndo;

  // Init items dictionary:
  //   [i][0] - old pattern number
  //   [i][1] - new pattern number
  SetLength(ItemsTable, VTMP.Positions.Length);
  for i := Low(ItemsTable) to High(ItemsTable) do
  begin
    SetLength(ItemsTable[i], 2);
    ItemsTable[i][0] := -1;
    ItemsTable[i][1] := -1;
  end;

  // Create new numeration for old paterns numbers
  j := 0;
  NewNumber := 0;
  for i := 0 to VTMP.Positions.Length-1 do
  begin
    OldNumber := VTMP.Positions.Value[i];
    if not PatternAdded(OldNumber) then
    begin
      ItemsTable[j][0] := OldNumber;
      ItemsTable[j][1] := NewNumber;
      NewPatterns[NewNumber] := VTMP.Patterns[OldNumber];
      Inc(j);
      Inc(NewNumber);
    end;
  end;

  // Copy new patterns to old patterns
  for i := Low(NewPatterns) to High(NewPatterns) do
    VTMP.Patterns[i] := NewPatterns[i];

  // Renumber patterns
  for i := 0 to VTMP.Positions.Length-1 do
    ChangePositionValueNoUndo(i, GetNewPatternNumber1(VTMP.Positions.Value[i]));

end;


procedure TMDIChild.SplitPattern;
var
  i, j: Integer;
  CurrentPatternPosition, CurrentPatternNumber, CurrentPatternLine: Integer;
  CurrentPatternLength, CurrentPatternNewLength: Integer;
  NewPatternLength, NewPatternNumber, NewPatternPosition: Integer;
  sel: TGridRect;
  
begin

  if Tracks.SelY = 0 then Exit;

  // Disable autoupdate UpDown controls
  DisableChangingEx := True;

  sel.Left   := StringGrid1.Selection.Left;
  sel.Right  := StringGrid1.Selection.Left;
  sel.Top    := 0;
  sel.Bottom := 0;
  StringGrid1.Selection := sel;

  // Save positions and patterns state for UNDO
  SaveTrackUndo;

  CurrentPatternPosition := PositionNumber;
  CurrentPatternNumber   := PatNum;
  CurrentPatternLine     := Tracks.SelY;
  CurrentPatternLength   := VTMP.Patterns[CurrentPatternNumber].Length;

  CurrentPatternNewLength := CurrentPatternLine;
  NewPatternLength := CurrentPatternLength - CurrentPatternNewLength;

  // Insert new position and create new pattern
  InsertPosition(False, False, False);

  NewPatternPosition := CurrentPatternPosition + 1;
  NewPatternNumber   := VTMP.Positions.Value[NewPatternPosition];

  // Copy pattern data from current pattern to new by Track Manager
  TrMng.CheckBox1.Checked := True;  // Flag: copy envelope data ON
  TrMng.CheckBox2.Checked := True;  // Flag: copy noise data ON
  TrMng.TracksOp(CurrentPatternNumber, CurrentPatternLine, 0, NewPatternNumber, 0, 0, 0, False);  // Copy chan A
  TrMng.TracksOp(CurrentPatternNumber, CurrentPatternLine, 1, NewPatternNumber, 0, 1, 0, False);  // Copy chan B
  TrMng.TracksOp(CurrentPatternNumber, CurrentPatternLine, 2, NewPatternNumber, 0, 2, 0, False);  // Copy chan C
  TrMng.CheckBox1.Checked := False;
  TrMng.CheckBox2.Checked := False;


  // Change current pattern length
  VTMP.Patterns[CurrentPatternNumber].Length := CurrentPatternNewLength;
  PatternLenUpDown.Position := CurrentPatternNewLength;

  // Change new pattern length
  VTMP.Patterns[NewPatternNumber].Length :=  NewPatternLength;

  // Clear current pattern lines > current line
  for i := CurrentPatternLine to MaxPatLen-1 do
    with VTMP.Patterns[CurrentPatternNumber].Items[i] do
    begin
      Noise := 0;
      Envelope := 0;
      for j := 0 to 2 do
      begin
        Channel[j].Note := -1;
        Channel[j].Sample := 0;
        Channel[j].Ornament := 0;
        Channel[j].Volume := 0;
        Channel[j].Envelope := 0;
        Channel[j].Additional_Command.Number := 0;
        Channel[j].Additional_Command.Delay := 0;
        Channel[j].Additional_Command.Parameter := 0;
      end;
    end;

  // Enable autoupdate UpDown controls
  DisableChangingEx := False;

  // Set pattern editor cursor to the first line and on the Channel A note
  Tracks.ShownFrom := 0;
  Tracks.CursorY   := Tracks.N1OfLines;
  Tracks.CursorX   := 8;

  // Redraw tracks, cursor and selection
  Tracks.RemoveSelection;
  Tracks.HideMyCaret;
  Tracks.RedrawTracks(0);
  Tracks.SetCaretPosition;
  Tracks.ShowMyCaret;

  // Set position to a new pattern
  SelectPosition2(NewPatternPosition);

  // Save new patterns state for REDO
  SaveTrackRedo;

end;


procedure TMDIChild.ExpandPattern;
var
  PatLen, NewPatLen, i: integer;
  OldPat: PPattern;

begin
  PatLen := DefPatLen;
  if (VTMP.Patterns[PatNum] <> nil) then
    PatLen := VTMP.Patterns[PatNum].Length;
  NewPatLen := PatLen * 2;

  if NewPatLen > MaxPatLen then begin
    ShowMessage('To expand pattern twice the original size it must be ' +
      IntToStr(MaxPatLen div 2) + ' lines or less.');
    Exit;
  end;

  SongChanged := True;
  BackupSongChanged := True;
  ValidatePattern2(PatNum);

  New(OldPat); OldPat^ := VTMP.Patterns[PatNum]^;
  AddUndo(CAExpandCompressPattern, 0, 0);
  ChangeList[ChangeCount - 1].Pattern := OldPat;
  VTMP.Patterns[PatNum].Length := NewPatLen;
  PatternLenUpDown.Position := NewPatLen;

  for i := PatLen - 1 downto 0 do begin
    with VTMP.Patterns[PatNum].Items[i * 2 + 1] do begin
      Envelope := 0;
      Noise := 0;
      Channel[0] := EmptyChannelLine;
      Channel[1] := EmptyChannelLine;
      Channel[2] := EmptyChannelLine;
    end;
    VTMP.Patterns[PatNum].Items[i * 2] := VTMP.Patterns[PatNum].Items[i];
  end;

  CheckTracksAfterSizeChanged(NewPatLen);

end;


procedure TMDIChild.CompressPattern;
var
  PatLen, NewPatLen, i: integer;
  OldPat: PPattern;

begin
  PatLen := DefPatLen;
  if (VTMP.Patterns[PatNum] <> nil) then
    PatLen := VTMP.Patterns[PatNum].Length;
  NewPatLen := PatLen div 2;

  if NewPatLen <= 0 then begin
    ShowMessage('To shrink pattern by half it must be 2 lines or more.');
    Exit;
  end;

  SongChanged := True;
  BackupSongChanged := True;
  ValidatePattern2(PatNum);

  New(OldPat); OldPat^ := VTMP.Patterns[PatNum]^;
  AddUndo(CAExpandCompressPattern, 0, 0);
  ChangeList[ChangeCount - 1].Pattern := OldPat;
  VTMP.Patterns[PatNum].Length := NewPatLen; PatternLenUpDown.Position := NewPatLen;

  for i := 1 to NewPatLen - 1 do
    VTMP.Patterns[PatNum].Items[i] := VTMP.Patterns[PatNum].Items[i * 2];

  for i := NewPatLen to MaxPatLen - 1 do
    with VTMP.Patterns[PatNum].Items[i] do begin
      Envelope := 0;
      Noise := 0;
      Channel[0] := EmptyChannelLine;
      Channel[1] := EmptyChannelLine;
      Channel[2] := EmptyChannelLine;
    end;
  CheckTracksAfterSizeChanged(NewPatLen);

end;


procedure TMDIChild.PackPattern;
var
  Packer: TPatternsPacker;
  FromLine, ToLine: Integer;
begin

  // Calculate from and to lines
  if not Tracks.IsSelected then begin
    FromLine := 0;
    ToLine   := Tracks.ShownPattern.Length-1;
  end
  else begin
    FromLine := Tracks.SelY;
    ToLine   := Tracks.CurrentPatLine;
    if FromLine > ToLine then
    begin
      FromLine := ToLine;
      ToLine   := Tracks.SelY
    end;
  end;

  // Too small to pack
  if ToLine - FromLine < 2 then begin
    ShowMessage('Pattern block too small to pack.');
    Exit;
  end;

  // Init packer
  Packer := TPatternsPacker.Create(Self);
  Packer.Pattern  := Tracks.ShownPattern;
  Packer.FromLine := FromLine;
  Packer.ToLine   := ToLine;

  // Is pattern packable?
  if Packer.CantPack then begin
    Packer.Free;
    Exit;
  end;

  // Pack
  SavePatternUndo;
  Packer.Process;
  Packer.Free;

  // Redraw
  Tracks.HideMyCaret;
  Tracks.ShownFrom := FromLine;
  Tracks.CursorY := Tracks.N1OfLines;
  Tracks.RemoveSelection;
  Tracks.SetCaretPosition;
  Tracks.RedrawTracks(0);
  Tracks.ShowMyCaret;
  PatternLenUpDown.Position := Tracks.ShownPattern.Length;

  SavePatternRedo;

end;


procedure TMDIChild.ShowHintTimerTimer(Sender: TObject);
var
  aPoint: TPoint;
begin
  if DisableHints then Exit;
  ShowHintTimer.Enabled := False;
  HideHintTimer.Interval := HideHintDelay;
  HideHintTimer.Enabled := True;
  aPoint := Mouse.CursorPos;
  Application.ActivateHint(aPoint);
end;

procedure TMDIChild.HideHintTimerTimer(Sender: TObject);
begin
  HideHintTimer.Enabled := False;
  Application.CancelHint;
end;

procedure TMDIChild.ChangeBackupVersionTimer(Sender: TObject);
begin
  if not BackupSongChanged then Exit;
  Inc(BackupVersionCounter);
end;


procedure TMDIChild.PrepareExportDialog(Dlg: TSaveDialog; Ext: String; InitDir: String = '');
var
  OpenPath: String;
begin

  // Prepare filename
  if IsTemplate or IsDemosong then
    Dlg.FileName := ChangeFileExt(Caption, Ext)

  else if WinFileName <> '' then
    Dlg.FileName := ChangeFileExt(WinFileName, Ext)

  else if (TSWindow <> nil) and (TSWindow.WinFileName <> '') then
    Dlg.FileName := ChangeFileExt(TSWindow.WinFileName, Ext)

  else
    Dlg.FileName := 'MyBestTrack' + Ext;


  // Prepare initial dir
  if Dlg.InitialDir = '' then
  begin

    if InitDir <> '' then
      OpenPath := InitDir
    else
      OpenPath := ExtractFilePath(MainForm.RecentFiles[0]);

    if DirectoryExists(OpenPath) then
      Dlg.InitialDir := OpenPath;

    //if AnsiContainsText(Dlg.FileName, VortexDir) or AnsiContainsText(Dlg.FileName, VortexDocumentsDir) then
    Dlg.FileName := OpenPath +'\'+ ExtractFileName(Dlg.FileName);
  end
  else
    Dlg.FileName := Dlg.InitialDir +'\'+ ExtractFileName(Dlg.FileName);

  Dlg.FileName := StringReplace(Dlg.FileName, '\\', '\', [rfReplaceAll]);

end;


procedure TMDIChild.ExportToWavFile;

  function IsOpen(fName: string): Boolean;
  var
    HFileRes: HFILE;
  begin
    Result := False;
    if not FileExists(fName) then
      Exit;

    HFileRes := CreateFile(PChar(fName), GENERIC_READ or GENERIC_WRITE,
                           0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    Result := (HFileRes = INVALID_HANDLE_VALUE);
    if not(Result) then
      CloseHandle(HFileRes);
  end;
  
begin

  PlayingWindow[1] := Self;
  if PlayingWindow[1] = PlayingWindow[2] then
    PlayingWindow[2] := nil;

  if (PlayingWindow[1].TSWindow <> nil) and (PlayingWindow[1].TSWindow.VTMP.Positions.Length <> 0) then
  begin
    PlayingWindow[2] := PlayingWindow[1].TSWindow;
    NumberOfSoundChips := 2;
  end
  else
  begin
    PlayingWindow[2] := nil;
    NumberOfSoundChips := 1;
  end;

  ExportOptions := TExportOptions.Create(MainForm);

  ExportOptions.ExportSelected.Checked :=
    (PlayingWindow[1].StringGrid1.Selection.Right > PlayingWindow[1].StringGrid1.Selection.Left)
    or
    ((NumberOfSoundChips = 2) and (PlayingWindow[2].StringGrid1.Selection.Right > PlayingWindow[2].StringGrid1.Selection.Left));


  if ExportOptions.ShowModal = mrCancel then
    Exit;


  PrepareExportDialog(ExportWavDialog, '.wav', ExportPath);
  if ExportWavDialog.Execute then
  begin

    if IsOpen(ExportWavDialog.FileName) then
    begin
      MessageDlg('Can''t open file. File is already opened in another application.', mtWarning, [mbOK], 0);
      Exit;
    end;
    ExportWavDialog.InitialDir := ExtractFilePath(ExportWavDialog.FileName);
    ExportPath := ExportWavDialog.InitialDir;

    //CreateWave(ExportWavDialog.FileName);
    CreateWaveAyumi(ExportWavDialog.FileName);
  end
  else
    Self.PageControl1.Repaint;

end;

procedure TMDIChild.FormPaint(Sender: TObject);
begin
  Canvas.Brush.Color := CFullScreenBackground;
  //Canvas.Brush.Color := clRed;
  Canvas.FillRect(Rect(0, 0, ClientWidth, ClientHeight));
end;

procedure TMDIChild.FormDblClick(Sender: TObject);
begin
  MainForm.FileOpen1Execute(MainForm);
end;


procedure TMDIChild.ClearSampleClick(Sender: TObject);

begin
  StopAndRestoreControls;
  
  SaveSampleUndo(Samples.ShownSample);
  ClearShownSample;
  SamplesSelectionOff;
  SaveSampleRedo;

  SongChanged := True;
  BackupSongChanged := True;

  Samples.HideMyCaret;
  Samples.RedrawSamples(0);
  Samples.ShowMyCaret;
  if Samples.CanFocus then
    Samples.SetFocus;

end;

procedure TMDIChild.UnsetFocus(var Key: Char; Control: TWinControl);
begin
  if Key = Chr(13) then
  begin
    if Control.CanFocus then Control.SetFocus
    else
      Self.ActiveControl := nil;
    Key := #0;
  end;
end;

procedure TMDIChild.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  UnsetFocus(Key, Tracks);
end;

procedure TMDIChild.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  UnsetFocus(Key, Tracks);
end;

procedure TMDIChild.PatternLenEditKeyPress(Sender: TObject; var Key: Char);
begin
  UnsetFocus(Key, Tracks);
end;

procedure TMDIChild.SpeedBpmEditKeyPress(Sender: TObject; var Key: Char);
begin
  UnsetFocus(Key, Tracks);
end;

procedure TMDIChild.OctaveEditKeyPress(Sender: TObject; var Key: Char);
begin
  UnsetFocus(Key, Tracks);
end;

procedure TMDIChild.AutoStepEditKeyPress(Sender: TObject; var Key: Char);
begin
  UnsetFocus(Key, Tracks);
end;

procedure TMDIChild.Edit17KeyPress(Sender: TObject; var Key: Char);
begin
  UnsetFocus(Key, Tracks);
end;

procedure TMDIChild.PatternNumEditKeyPress(Sender: TObject; var Key: Char);
begin
  UnsetFocus(Key, Tracks);
end;



procedure TMDIChild.DuplicateNoteParamsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if DupNoteParams then
  begin
    DuplicateNoteParams.Checked := False;
    DupNoteParams := False;
  end
  else
  begin
    DuplicateNoteParams.Checked := True;
    DupNoteParams := True;
  end;
  MainForm.ChangeDupNoteParams;
  Tracks.SetFocus;
end;

procedure TMDIChild.BetweenPatternsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if MoveBetweenPatrns then
  begin
    BetweenPatterns.Checked := False;
    MoveBetweenPatrns := False;
  end
  else
  begin
    BetweenPatterns.Checked := True;
    MoveBetweenPatrns := True;
  end;
  MainForm.ChangeBetweenPatterns;
  Tracks.SetFocus;
end;

procedure TMDIChild.SampleNumEditKeyPress(Sender: TObject; var Key: Char);
begin
  UnsetFocus(Key, Samples);
end;

procedure TMDIChild.SampleLenEditKeyPress(Sender: TObject; var Key: Char);
begin
  UnsetFocus(Key, Samples);
end;

procedure TMDIChild.SampleCopyToEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  UnsetFocus(Key, Samples);
end;

procedure TMDIChild.SampleLoopEditKeyPress(Sender: TObject; var Key: Char);
begin
  UnsetFocus(Key, Samples);
end;

procedure TMDIChild.OrnamentNumEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  UnsetFocus(Key, Ornaments);
end;

procedure TMDIChild.OrnamentLenEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  UnsetFocus(Key, Ornaments);
end;

procedure TMDIChild.OrnamentCopyToEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  UnsetFocus(Key, Ornaments);
end;

procedure TMDIChild.OrnamentLoopEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  UnsetFocus(Key, Ornaments);
end;

procedure TMDIChild.StringGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Sel: TGridRect;
begin
  if Tracks.IsTrackPlaying and (Key = VK_RIGHT) and (StringGrid1.Selection.Left >= VTMP.Positions.Length-1) then
  begin
    Sel.Left := VTMP.Positions.Length-1;
    Sel.Right := Sel.Left;
    StringGrid1.Selection := Sel;
    //SelectPosition(Sel.Left);
  end;
end;

procedure TMDIChild.EnvelopeAsNoteOptClick(Sender: TObject);
begin
  EnvelopeAsNote := EnvelopeAsNoteOpt.Checked;
  MainForm.UpdateEnvelopeAsNote;
  Tracks.RedrawTracks(0);
  if Tracks.Focused then
    Tracks.ShowMyCaret;
  if Active then
    SetToolsPattern;
end;



procedure TMDIChild.SavePSGRegisterDump(FileName: string; VTMP: PModule; Chip: byte);
var
  i: Integer;
  f: file of byte;
  iReg, fByte: byte;
  currRegs: array[0..13] of byte;

begin
  AssignFile(f, FileName);
  Rewrite(f);

  // write header
  fByte := 80; Write(f, fByte); // "P"
  fByte := 83; Write(f, fByte); // "S"
  fByte := 71; Write(f, fByte); // "G"
  fByte := 26; Write(f, fByte); // #1A

  // fill zerobytes
  fByte := 0;
  for i := 0 to 11 do begin
    Write(f, fByte);
  end;

  // zerofill rurrent registers
  for iReg := 0 to 13 do begin
    currRegs[iReg] := 0;
  end;

  PlayMode := PMPlayModule;
  if IsPlaying then StopPlaying;

  MainForm.DisableControlsForExport;
  InitForAllTypes(True);

  // Init pointer, position, delay
  Module_SetPointer(VTMP, Chip);
  Module_SetDelay(VTMP.Initial_Delay);
  Module_SetCurrentPosition(0);


  ExportLoops := 1;
  LoopAllowed := False;
  ExportStarted  := True;
  ExportFinished := False;

  fByte := 255; //next frame
  while (Module_PlayCurrentLine() <> 3) do begin
    Write(f, fByte);
    for iReg := 0 to 13 do begin
      if (currRegs[iReg] <> SoundChip[Chip].AYRegisters.Index[iReg]) then begin
        Write(f, iReg);
        Write(f, SoundChip[Chip].AYRegisters.Index[iReg]);
      end;
      currRegs[iReg] := SoundChip[Chip].AYRegisters.Index[iReg];
    end;

  end;
  CloseFile(f);

  ExportStarted  := False;
  ExportFinished := True;
  MainForm.EnableControlsForExport;


end;



procedure TMDIChild.ExportPSG;
var
  Chip1Name, Chip2Name: String;
  
begin

  PrepareExportDialog(ExportPSGDlg, '.psg');
  if ExportPSGDlg.Execute then
  begin
    ExportPSGDlg.InitialDir := ExtractFilePath(ExportPSGDlg.FileName);

    if TSWindow <> nil then
    begin
      Chip1Name := StringReplace(ExportPSGDlg.FileName, '.psg', '.1.psg', [rfReplaceAll, rfIgnoreCase]);
      Chip2Name := StringReplace(ExportPSGDlg.FileName, '.psg', '.2.psg', [rfReplaceAll, rfIgnoreCase]);
      SavePSGRegisterDump(Chip1Name, VTMP, 1);
      SavePSGRegisterDump(Chip2Name, TSWindow.VTMP, 2);
    end
    else
      SavePSGRegisterDump(ExportPSGDlg.FileName, VTMP, 1);

  end;


end;


procedure TMDIChild.StopAndRestoreControls;
begin
  if not IsPlaying then Exit;
  MainForm.RestoreControls;
  if PlayMode = PMPlayModule then
    StopPlaying
  else
    ResetPlaying;
  UnlimiteDelay := False;
  PlayStopState := BPlay;
end;


procedure TMDIChild.SamplePreview;
begin
  if IsPlaying and (PlayMode in [PMPlayPattern, PMPlayModule]) then Exit;
  StopPlayTimer.Enabled := False;
  SampleTestLine.PlayCurrentNote;
  StopPlayTimer.Enabled := True;
end;

procedure TMDIChild.OrnamentPreview;
begin
  if IsPlaying and (PlayMode in [PMPlayPattern, PMPlayModule]) then Exit;
  if IsPlaying then ResetPlaying;
  if (Ornaments.ShownOrnament.Length = 1) and (Ornaments.ShownOrnament.Items[0] = 0) then Exit;
  StopPlayTimer.Enabled := False;
  OrnamentTestLine.PlayCurrentNote;
  StopPlayTimer.Enabled := True;
end;


procedure TMDIChild.PrevSampleBtnClick(Sender: TObject);
begin
  SampleNumUpDown.Position := SampleNumUpDown.Position - 1;
  SamplePreview;
end;

procedure TMDIChild.NextSampleBtnClick(Sender: TObject);
begin
  SampleNumUpDown.Position := SampleNumUpDown.Position + 1;
  SamplePreview;
end;

procedure TMDIChild.PrevOrnBtnClick(Sender: TObject);
begin
  OrnamentNumUpDown.Position := OrnamentNumUpDown.Position - 1;
  OrnamentPreview;
end;

procedure TMDIChild.NextOrnBtnClick(Sender: TObject);
begin
  OrnamentNumUpDown.Position := OrnamentNumUpDown.Position + 1;
  OrnamentPreview;
end;

procedure TMDIChild.ClearOrnButClick(Sender: TObject);
begin
  StopAndRestoreControls;
  SaveOrnamentUndo;

  ClearShownOrnament;
  SaveOrnamentRedo;

  Ornaments.HideMyCaret;
  Ornaments.RedrawOrnaments(0);
  Ornaments.ShowMyCaret;
  if Ornaments.CanFocus then
    Ornaments.SetFocus;
  
end;

procedure TMDIChild.PasteOrnButClick(Sender: TObject);
begin
  if LastClipboard in [LCNone, LCSamples] then Exit;

  StopAndRestoreControls;
  SaveOrnamentUndo;
  ClearShownOrnament;

  case LastClipboard of
    LCOrnaments: pasteOrnamentFromBuffer;
    LCTracks: PastePatternToOrnament;
  end;

  SaveOrnamentRedo;
  if Ornaments.CanFocus then
    Ornaments.SetFocus;

end;

procedure TMDIChild.PasteSamButClick(Sender: TObject);
begin
  if LastClipboard = LCNone then Exit;

  StopAndRestoreControls;
  SaveSampleUndo(Samples.ShownSample);
  ClearShownSample;

  case LastClipboard of
    LCSamples: pasteSampleFromBuffer(True);
    LCOrnaments: PasteOrnamentToSample;
    LCTracks: PastePatternToSample;
  end;

  SaveSampleRedo;
  if Samples.CanFocus then
    Samples.SetFocus;
end;

procedure TMDIChild.HideSamBrowserBtnClick(Sender: TObject);
begin
{  SamplesBrowser.Visible := False;
  ShowSamBrowserBtn.Visible := True;
  HideSamBrowserBtn.Visible := False;  }

  MainForm.SampleBrowserVisible := False;
  MainForm.RedrawAllSamOrnBrowsers;
end;

procedure TMDIChild.ShowSamBrowserBtnClick(Sender: TObject);
begin
  {SamplesBrowser.Visible := True;
  ShowSamBrowserBtn.Visible := False;
  HideSamBrowserBtn.Visible := True;   }
  MainForm.SampleBrowserVisible := True;
  MainForm.RedrawAllSamOrnBrowsers;
end;

procedure TMDIChild.PageControl1Change(Sender: TObject);
begin

  // If CTRL pressed, then change Tab in second turbotrack module
  if (GetKeyState(VK_CONTROL) < 0) and (TSWindow <> nil) then begin
    TSWindow.PageControl1.ActivePageIndex := PageControl1.ActivePageIndex;

    if PageControl1.ActivePage = OptTab then begin
      TSWindow.ManualHz.Left := TrackChipFreq.Buttons[20].Left + 95;
      TSWindow.ManualIntFreq.Left := TrackIntSel.Buttons[6].Left + 95;
    end;

  end;


  if IsPlaying and not (PlayMode in [PMPlayPattern, PMPlayModule]) then
    StopAndRestoreControls;

  if PageControl1.ActivePage = PatternsSheet then
  begin
    RefreshPositionsHScroll;
    PositionsScrollBox.SetFocus;
  end;

  if PageControl1.ActivePage = SamplesSheet then
  begin
    SamplesDriveSelect.FillDiskDrives;
    SampleTestLine.CursorX := 12;
    SampleTestLine.SetFocus;
  end;

  if PageControl1.ActivePage = OrnamentsSheet then
  begin
    OrnamentsDriveSelect.FillDiskDrives;
    OrnamentTestLine.CursorX := 14;
    OrnamentTestLine.SetFocus;
  end;

  if PageControl1.ActivePage = OptTab then begin
    ManualHz.Left := TrackChipFreq.Buttons[20].Left + 95;
    ManualIntFreq.Left := TrackIntSel.Buttons[6].Left + 95;
  end;

  if (PageControl1.ActivePage = InfoTab) and (TrackInfo.CanFocus) then
    TrackInfo.SetFocus;

end;

procedure TMDIChild.HideOrnBrowserBtnClick(Sender: TObject);
begin
  MainForm.OrnamentsBrowserVisible := False;
  MainForm.RedrawAllSamOrnBrowsers;
end;

procedure TMDIChild.ShowOrnBrowserBtnClick(Sender: TObject);
begin
  MainForm.OrnamentsBrowserVisible := True;
  MainForm.RedrawAllSamOrnBrowsers;
end;


procedure TMDIChild.StopPlayTimerTimer(Sender: TObject);
begin
  StopAndRestoreControls;
  StopPlayTimer.Enabled := False;
  if PageControl1.ActivePage = SamplesSheet then
    SamplesBrowser.PreviewPlaying := False;
  if PageControl1.ActivePage = OrnamentsSheet then
    OrnamentsBrowser.PreviewPlaying := False;
end;

procedure TMDIChild.UpdateSamToneShiftControls;
var Bool: Boolean;
begin
  Bool := SamToneShiftAsNoteOpt.Checked;
  Samples.ToneShiftAsNote := Bool;
  SamOctaveLabel.Visible  := Bool;
  SamOptsSep.Visible      := Bool;
  SamOctaveLabel.Visible  := Bool;
  SamOctaveTxt.Visible    := Bool;
  SamOctaveNum.Visible    := Bool;
  SamOctaveTxt.Caption    := IntToStr(SamOctaveNum.Position);
end;

procedure TMDIChild.SamToneShiftAsNoteOptClick(Sender: TObject);

begin
  SamToneShiftAsNote := SamToneShiftAsNoteOpt.Checked;
  UpdateSamToneShiftControls;
  Samples.HideMyCaret;
  Samples.RedrawSamples(0);
  Samples.ShowMyCaret;
  if InitFinished and Samples.CanFocus then Samples.SetFocus;
end;

procedure TMDIChild.SamOctaveNumChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);

begin
  AllowChange := (NewValue >= 1) and (NewValue <= 8);
  if not AllowChange then Exit;
  SamOctaveTxt.Caption := IntToStr(NewValue);
end;


procedure TMDIChild.UpdateOrnToneShiftControls;
var Bool: Boolean;
begin
  Bool := OrnToneShiftAsNoteOpt.Checked;
  Ornaments.ToneShiftAsNote := Bool;
  OrnOctaveLabel.Visible    := Bool;
  OrnOptsSep.Visible        := Bool;
  OrnOctaveLabel.Visible    := Bool;
  OrnOctaveTxt.Visible      := Bool;
  OrnOctaveNum.Visible      := Bool;
  OrnOctaveTxt.Caption      := IntToStr(OrnOctaveNum.Position);
end;


procedure TMDIChild.OrnToneShiftAsNoteOptClick(Sender: TObject);
begin
  OrnToneShiftAsNote := OrnToneShiftAsNoteOpt.Checked;
  UpdateOrnToneShiftControls;
  Ornaments.HideMyCaret;
  Ornaments.RedrawOrnaments(0);
  Ornaments.ShowMyCaret;
  if InitFinished and Ornaments.CanFocus then Ornaments.SetFocus;
end;

procedure TMDIChild.OrnOctaveNumChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  AllowChange := (NewValue >= 1) and (NewValue <= 8);
  if not AllowChange then Exit;
  OrnOctaveTxt.Caption := IntToStr(NewValue);
end;


function TMDIChild.GetValue(const s: string): Integer;
var Er: Integer;
begin
  Val(Trim(s), Result, Er);
  if Er <> 0 then Result := -1
end;

function TMDIChild.GetValueF(s: string): Double;
var Er: Integer;
begin
  s := StringReplace(s, ',', '.', [rfReplaceAll]);
  Val(Trim(s), Result, Er);
  if Er <> 0 then Result := -1
end;


procedure TMDIChild.UpdateChipFreq;
begin
  if BlockRecursion or not InitFinished or Closed then Exit;

  if TSWindow <> nil then begin
    TSWindow.BlockRecursion := True;
    TSWindow.SetTrackFreq(VTMP.ChipFreq);
    TSWindow.BlockRecursion := False;
  end;

  if not ModuleInPlayingWindow then Exit;


  SongChanged := True;
  BackupSongChanged := True;

  if VTMP.ChipFreq <> AY_Freq then
    SetAYFreq(VTMP.ChipFreq);
end;


procedure TMDIChild.UpdateToneTableHints;
begin
  Edit7.Hint   := Format('Table #%d: %s', [VTMP.Ton_Table, TableNames[VTMP.Ton_Table]]);
  UpDown4.Hint := Edit7.Hint;
  ToneTableBox.Hint := Edit7.Hint;
end;


procedure TMDIChild.InitTrack;
begin
  SetTrackFreq(VTMP.ChipFreq);
  SetTrackIntFreq(VTMP.IntFreq);
  SetRTFText(TrackInfo, VTMP.Info);
  UpdateToneTableHints;
  
  if LeftModule and not DisableInfoWin then
    TrackInfoTimer.Enabled := True;
  ShowInfoOnLoad.Checked := VTMP.ShowInfo;

end;

procedure TMDIChild.SetTrackFreq(FreqValue: Integer);
begin
  VTMP.ChipFreq := FreqValue;
  case FreqValue of

    894887:  TrackChipFreq.ItemIndex := 0;
    831303:  TrackChipFreq.ItemIndex := 1;
    1773400: TrackChipFreq.ItemIndex := 2;
    1750000: TrackChipFreq.ItemIndex := 3;
    1000000: TrackChipFreq.ItemIndex := 4;
    1500000: TrackChipFreq.ItemIndex := 5;
    2000000: TrackChipFreq.ItemIndex := 6;
    3500000: TrackChipFreq.ItemIndex := 7;
    1520640: TrackChipFreq.ItemIndex := 8;
    1611062: TrackChipFreq.ItemIndex := 9;
    1706861: TrackChipFreq.ItemIndex := 10;
    1808356: TrackChipFreq.ItemIndex := 11;
    1915886: TrackChipFreq.ItemIndex := 12;
    2029811: TrackChipFreq.ItemIndex := 13;
    2150510: TrackChipFreq.ItemIndex := 14;
    2278386: TrackChipFreq.ItemIndex := 15;
    2413866: TrackChipFreq.ItemIndex := 16;
    2557401: TrackChipFreq.ItemIndex := 17;
    2709472: TrackChipFreq.ItemIndex := 18;
    2870586: TrackChipFreq.ItemIndex := 19;
    3041280: TrackChipFreq.ItemIndex := 20;
    else
      TrackChipFreq.ItemIndex := 21;
      ManualHz.Text := IntToStr(FreqValue);
  end;
end;

procedure TMDIChild.TrackChipFreqClick(Sender: TObject);
var f: Integer;
begin

  case TrackChipFreq.ItemIndex of
    0:  VTMP.ChipFreq := 894887;
    1:  VTMP.ChipFreq := 831303;
    2:  VTMP.ChipFreq := 1773400;
    3:  VTMP.ChipFreq := 1750000;
    4:  VTMP.ChipFreq := 1000000;
    5:  VTMP.ChipFreq := 1500000;
    6:  VTMP.ChipFreq := 2000000;
    7:  VTMP.ChipFreq := 3500000;
    8:  VTMP.ChipFreq := 1520640;
    9:  VTMP.ChipFreq := 1611062;
    10: VTMP.ChipFreq := 1706861;
    11: VTMP.ChipFreq := 1808356;
    12: VTMP.ChipFreq := 1915886;
    13: VTMP.ChipFreq := 2029811;
    14: VTMP.ChipFreq := 2150510;
    15: VTMP.ChipFreq := 2278386;
    16: VTMP.ChipFreq := 2413866;
    17: VTMP.ChipFreq := 2557401;
    18: VTMP.ChipFreq := 2709472;
    19: VTMP.ChipFreq := 2870586;
    20: VTMP.ChipFreq := 3041280;
    21: begin
          f := GetValue(ManualHz.Text);
          if (f < 0) or (f < 700000) or (f > 3546800) then Exit;
          VTMP.ChipFreq := f;
        end;
  end;

  UpdateChipFreq;
  
end;

procedure TMDIChild.UpdateIntFreq;
begin
  if BlockRecursion or not InitFinished or Closed then Exit;

  if TSWindow <> nil then begin
    TSWindow.BlockRecursion := True;
    TSWindow.SetTrackIntFreq(VTMP.IntFreq);
    TSWindow.CalcTotLen;
    TSWindow.ReCalcTimes(TSWindow.PosBegin + TSWindow.LineInts);
    TSWindow.UpdateSpeedBPM;
    TSWindow.BlockRecursion := False;
  end;

  if not ModuleInPlayingWindow then Exit;

  if VTMP.IntFreq <> Interrupt_Freq then
    SetIntFreq(VTMP.IntFreq);

  SongChanged := True;
  BackupSongChanged := True;

  CalcTotLen;
  ReCalcTimes(PosBegin + LineInts);
  UpdateSpeedBPM;
end;


procedure TMDIChild.SetTrackIntFreq(IntFreqValue: Integer);
var f: Double;
begin
  VTMP.IntFreq := IntFreqValue;
  case IntFreqValue of
    48828:  TrackIntSel.ItemIndex := 0;
    50000:  TrackIntSel.ItemIndex := 1;
    60000:  TrackIntSel.ItemIndex := 2;
    100000: TrackIntSel.ItemIndex := 3;
    200000: TrackIntSel.ItemIndex := 4;
    48000:  TrackIntSel.ItemIndex := 5;
    else
      TrackIntSel.ItemIndex := 6;
      if not ManualIntFreq.Focused then begin
        f := IntFreqValue / 1000;
        ManualIntFreq.Text := FloatToStr(f);
      end;
  end;

end;


procedure TMDIChild.TrackIntSelClick(Sender: TObject);
var f: Double;
begin
  case TrackIntSel.ItemIndex of
    0: VTMP.IntFreq := 48828;
    1: VTMP.IntFreq := 50000;
    2: VTMP.IntFreq := 60000;
    3: VTMP.IntFreq := 100000;
    4: VTMP.IntFreq := 200000;
    5: VTMP.IntFreq := 48000;
    6: begin
         f := GetValueF(ManualIntFreq.Text);
         if f < 0 then exit;
         VTMP.IntFreq := round(f * 1000);
       end;
  else
    Exit;
  end;

  UpdateIntFreq;

end;

procedure TMDIChild.ManualHzKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9']) and (Key <> #8) then begin
    Key := #0;
    Exit;
  end;
end;


procedure TMDIChild.ManualHzKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var NewValue: Integer;
begin
  if TrackChipFreq.ItemIndex <> 21 then
    TrackChipFreq.ItemIndex := 21;

  NewValue := GetValue(ManualHz.Text);
  if (NewValue < 0) or (NewValue < 700000) or (NewValue > 3546800) then exit;
  SetTrackFreq(NewValue);
  UpdateChipFreq;

  SongChanged := True;
  BackupSongChanged := True;
end;


procedure TMDIChild.ManualIntFreqKeyPress(Sender: TObject; var Key: Char);
var Wrong: Boolean;
begin
  Wrong := not (Key in ['0'..'9','.',',']) and (Key <> #8);
  Wrong := Wrong or ( AnsiContainsText(ManualIntFreq.Text, ',') and (Key in ['.', ',']) );
  Wrong := Wrong or ( (ManualIntFreq.Text = '') and (Key in ['.', ',']) );

  if Wrong then begin
    Key := #0;
    Exit;
  end;

  if Key = '.' then begin
    Key := ',';
    Exit;
  end;
end;

procedure TMDIChild.ManualIntFreqKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  NewValue, f: Double;
  Wrong: Boolean;
begin

  NewValue := GetValueF(ManualIntFreq.Text);
  if NewValue < 0 then Exit;

  f := Frac(StrToFloat(ManualIntFreq.Text));
  Wrong := Length(FloatToStr(f)) > 5;
  NewValue := NewValue * 1000;
  Wrong := Wrong or ((NewValue < 1000) or (NewValue > 2000000));

  if Wrong then begin
    f := VTMP.IntFreq / 1000;
    ManualIntFreq.Text := FloatToStr(f);
    ManualIntFreq.SelStart := Length(ManualIntFreq.Text);
    Exit;
  end;

  SetTrackIntFreq(round(NewValue));
  UpdateIntFreq;
  SongChanged := True;
  BackupSongChanged := True;
         
end;

procedure TMDIChild.UpdateTrackInfo;
begin
  VTMP.Info := GetRTFText(TrackInfo);
  if TSWindow <> nil then begin
    TSWindow.VTMP.Info := VTMP.Info;
    SetRTFText(TSWindow.TrackInfo, VTMP.Info);
  end;
  SongChanged := True;
  BackupSongChanged := True;
end;

procedure TMDIChild.BoldClick(Sender: TObject);
begin
  if fsBold in TrackInfo.SelAttributes.Style then
    TrackInfo.SelAttributes.Style := []
  else
    TrackInfo.SelAttributes.Style := [fsBold];
  UpdateTrackInfo;
end;

procedure TMDIChild.ItalicClick(Sender: TObject);
begin
  if fsItalic in TrackInfo.SelAttributes.Style then
    TrackInfo.SelAttributes.Style := []
  else
    TrackInfo.SelAttributes.Style := [fsItalic];
  UpdateTrackInfo;
end;

procedure TMDIChild.UnderlineClick(Sender: TObject);
begin
  if fsUnderline in TrackInfo.SelAttributes.Style then
    TrackInfo.SelAttributes.Style := []
  else
    TrackInfo.SelAttributes.Style := [fsUnderline];
  UpdateTrackInfo;
end;

function TMDIChild.GetRTFText(ARichEdit: TRichedit): string;
var
  ss: TStringStream;
  emptystr: string;
begin
  emptystr := '';
  ss := TStringStream.Create(emptystr);
  try
    ARichEdit.PlainText := False;
    ARichEdit.Lines.SaveToStream(ss);
    Result := Trim(ss.DataString);
  finally
    ss.Free;
  end;
end;

procedure TMDIChild.SetRTFText(ARichEdit: TRichEdit; RTFText: String);
var
  ss: TStringStream;
  emptystr: string;
begin
  emptystr := '';
  ss := TStringStream.Create(emptystr);
  try
    ss.WriteString(RTFText);
    ss.Position := 0;
    ARichEdit.PlainText := False;
    ARichEdit.Lines.BeginUpdate;
    ARichEdit.Lines.LoadFromStream(ss);
    ARichEdit.Lines.EndUpdate;
  finally
    ss.Free;
  end;
end;

procedure TMDIChild.TrackInfoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateTrackInfo;
end;

procedure TMDIChild.TrackInfoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift <> [ssCtrl] then Exit;
  if Key = Ord('B') then BoldClick(Sender);
  if Key = Ord('I') then ItalicClick(Sender);
  if Key = Ord('U') then UnderlineClick(Sender);
end;

procedure TMDIChild.ShowInfoOnLoadMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  VTMP.ShowInfo := ShowInfoOnLoad.Checked;
  if TSWindow <> nil then begin
    TSWindow.ShowInfoOnLoad.Checked := VTMP.ShowInfo;
    TSWindow.VTMP.ShowInfo := VTMP.ShowInfo;
  end;
  SongChanged := True;
  BackupSongChanged := True;
end;


procedure TMDIChild.TrackInfoTimerTimer(Sender: TObject);
begin
  TrackInfoTimer.Enabled := False;
  if not VTMP.ShowInfo then Exit;

  TrackInfoForm.Init(VTMP);
  TrackInfoForm.Show;

end;

procedure TMDIChild.ViewInfoBtnClick(Sender: TObject);
begin
  TrackInfoForm.Init(VTMP);
  TrackInfoForm.Show;
end;

procedure TMDIChild.StringGrid1MouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  NewPos: Integer;
  sel: TGridRect;
begin

  if IsMouseOverControl(Tracks) then
  begin
    // Scroll pattern, not positions
    if Tracks.CanFocus then begin
      Tracks.SetFocus;
      TracksMouseWheelDown(Sender, Shift, MousePos, Handled);
    end;
    Exit;
  end;

  // Mouse pointer under another control
  if not IsMouseOverControl(PositionsScrollBox) then Exit;

  // If playing current pattern only
  if IsPlaying and (PlayMode = PMPlayPattern) then Exit;
  
  NewPos := PositionNumber + 1;
  if NewPos = VTMP.Positions.Length then Exit;
  
  SetStringGrid1Scroll(NewPos);
  SelectPosition(NewPos);

  sel.Left := NewPos; sel.Right := NewPos;
  sel.Top := 0; sel.Bottom := 0;
  StringGrid1.Selection := sel;

end;

procedure TMDIChild.StringGrid1MouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  NewPos: Integer;
  sel: TGridRect;
begin

  if IsMouseOverControl(Tracks) then
  begin
    // Scroll pattern, not positions
    if Tracks.CanFocus then begin
      Tracks.SetFocus;
      TracksMouseWheelUp(Sender, Shift, MousePos, Handled);
    end;
    Exit;
  end;

  // Mouse pointer under another control
  if not IsMouseOverControl(PositionsScrollBox) then Exit;

  // If playing current pattern only
  if IsPlaying and (PlayMode = PMPlayPattern) then Exit;

  NewPos := PositionNumber - 1;
  if NewPos < 0 then Exit;

  SetStringGrid1Scroll(NewPos);
  SelectPosition(NewPos);

  sel.Left := NewPos; sel.Right := NewPos;
  sel.Top := 0; sel.Bottom := 0;
  StringGrid1.Selection := sel;
end;

procedure TMDIChild.SpeedBpmEditEnter(Sender: TObject);
begin
  SpeedBpmEdit.Text := IntToStr(VTMP.Initial_Delay);
end;

procedure TMDIChild.SpeedBpmEditExit(Sender: TObject);
begin
  UpdateSpeedBPM;
end;

procedure TMDIChild.SpeedBpmEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var NewValue: Integer;
begin

  NewValue := GetValue(SpeedBpmEdit.Text);
  if (NewValue <> -1) and (NewValue in [1..255]) then
    SpeedBpmUpDown.Position := NewValue;

end;

procedure TMDIChild.SpeedBpmUpDownClick(Sender: TObject;
  Button: TUDBtnType);
begin
  SpeedBpmUpDown.SetFocus;
end;

procedure TMDIChild.Edit7KeyPress(Sender: TObject; var Key: Char);
begin
  UnsetFocus(Key, Tracks);
end;







end.

