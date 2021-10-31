object MainForm: TMainForm
  Left = 641
  Top = 159
  Width = 627
  Height = 618
  HorzScrollBar.Smooth = True
  HorzScrollBar.Tracking = True
  Caption = 'Vortex Tracker'
  Color = clAppWorkSpace
  Constraints.MinHeight = 440
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Visible = True
  WindowMenu = Window1
  OnClose = FormClose
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 539
    Width = 611
    Height = 20
    AutoHint = True
    Panels = <
      item
        Width = 70
      end
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Alignment = taCenter
        Width = 61
      end>
    SizeGrip = False
  end
  object ToolBar2: TToolBar
    Left = 0
    Top = 0
    Width = 611
    AutoSize = True
    BorderWidth = 1
    ButtonWidth = 27
    Color = clBtnFace
    EdgeBorders = [ebTop, ebBottom]
    Images = ImageList1
    ParentColor = False
    ParentShowHint = False
    PopupMenu = PopupMenu3
    ShowHint = True
    TabOrder = 0
    Wrapable = False
    object ToolButton9: TToolButton
      Left = 0
      Top = 2
      Action = FileNew1
    end
    object ToolButton1: TToolButton
      Left = 27
      Top = 2
      Action = FileOpen1
    end
    object ToolButton2: TToolButton
      Left = 54
      Top = 2
      Action = FileSave1
    end
    object ToolButton3: TToolButton
      Left = 81
      Top = 2
      Width = 5
      Caption = 'ToolButton3'
      ImageIndex = 22
      Style = tbsSeparator
    end
    object ToolButton6: TToolButton
      Left = 86
      Top = 2
      Action = Undo
    end
    object ToolButton7: TToolButton
      Left = 113
      Top = 2
      Action = Redo
    end
    object ToolButton8: TToolButton
      Left = 140
      Top = 2
      Width = 5
      Caption = 'ToolButton8'
      ImageIndex = 22
      Style = tbsSeparator
    end
    object PlayStopBtn: TToolButton
      Left = 145
      Top = 2
      Hint = 'Play/Stop'
      Action = PlayStop
    end
    object ToolButton13: TToolButton
      Left = 172
      Top = 2
      Action = Play1
    end
    object ToolButton20: TToolButton
      Left = 199
      Top = 2
      Hint = 
        'Play current pattern only from the current line|Play current pat' +
        'tern only from the current line'
      Action = PlayPatFromLine
      Caption = 'Play pattern from current line'
    end
    object ToolButton21: TToolButton
      Left = 226
      Top = 2
      Hint = 
        'Play current pattern only from start|Play current pattern only f' +
        'rom start'
      Action = PlayPat
    end
    object ToolButton15: TToolButton
      Left = 253
      Top = 2
      Hint = 'Loop at one track|One module is playing again and again.'
      Action = ToggleLooping
      AllowAllUp = True
      Grouped = True
      Style = tbsCheck
    end
    object ToolButton17: TToolButton
      Left = 280
      Top = 2
      Hint = 'Loop for all tracks|Toggle looping in all opened files'
      Action = ToggleLoopingAll
      AllowAllUp = True
      Caption = 'Loop All Files'
      Grouped = True
      Style = tbsCheck
    end
    object ToolButton4: TToolButton
      Left = 307
      Top = 2
      Width = 5
      Caption = 'ToolButton4'
      ImageIndex = 22
      Style = tbsSeparator
    end
    object ToolButton25: TToolButton
      Left = 312
      Top = 2
      Action = ToggleSamplesAct
    end
    object ToolButton26: TToolButton
      Left = 339
      Top = 2
      Action = TracksManagerAct
    end
    object ToolButton27: TToolButton
      Left = 366
      Top = 2
      Action = GlobalTranspositionAct
    end
    object ToolButton5: TToolButton
      Left = 393
      Top = 2
      Width = 5
      Caption = 'ToolButton5'
      ImageIndex = 22
      Style = tbsSeparator
    end
    object SpeedButton1: TSpeedButton
      Left = 398
      Top = 2
      Width = 23
      Height = 22
      Action = ToggleChip
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SpeedButton2: TSpeedButton
      Left = 421
      Top = 2
      Width = 33
      Height = 22
      Hint = 'Channels|Toggle channel mapping'
      Action = ToggleChanAlloc
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ToolButton29: TToolButton
      Left = 454
      Top = 2
      Hint = 'Options'
      Caption = 'Options'
      ImageIndex = 21
      OnClick = Options1Click
    end
    object TrackBar1: TTrackBar
      Left = 481
      Top = 2
      Width = 73
      Height = 22
      Hint = 'Volume control'
      Max = 64
      PageSize = 8
      Frequency = 5
      Position = 56
      TabOrder = 0
      TabStop = False
      ThumbLength = 15
      OnChange = TrackBar1Change
    end
  end
  object MainMenu1: TMainMenu
    Images = ImageList1
    Left = 40
    Top = 200
    object File1: TMenuItem
      AutoLineReduction = maManual
      Caption = 'File'
      object FileNewItem: TMenuItem
        Action = FileNew1
      end
      object Newturbosoudtrack1: TMenuItem
        Action = NewTurbosound
      end
      object JoinTracks1: TMenuItem
        Action = JoinTracks
      end
      object FileOpenItem: TMenuItem
        Action = FileOpen1
      end
      object OpenDemo: TMenuItem
        Caption = 'Open &Demosong'
      end
      object FileCloseItem: TMenuItem
        Action = FileClose1
      end
      object FileSaveItem: TMenuItem
        Action = FileSave1
      end
      object FileSaveAsItem: TMenuItem
        Action = FileSaveAs1
        ShortCut = 24659
      end
      object Saveas2modules1: TMenuItem
        Action = SaveAsTwoModules
      end
      object SaveAsTemplate1: TMenuItem
        Action = SaveAsTemplate
        Caption = 'Set As Startup Template'
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object ExportWAV: TMenuItem
        Action = ExportToWAV
      end
      object ExportPSG: TMenuItem
        Action = ExportPSGAct
      end
      object Exports1: TMenuItem
        Caption = 'Exports'
        object SaveSNDHMenu: TMenuItem
          Caption = 'Save in SNDH (Atari ST)'
          OnClick = SaveSNDHMenuClick
        end
        object SaveforZXMenu: TMenuItem
          Caption = 'Save with ZX Spectrum player'
          OnClick = SaveforZXMenuClick
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Options1: TMenuItem
        Caption = 'Options...'
        ShortCut = 24655
        OnClick = Options1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object RFile1: TMenuItem
        Visible = False
        OnClick = RFile1Click
      end
      object RFile2: TMenuItem
        Visible = False
        OnClick = RFile2Click
      end
      object RFile3: TMenuItem
        Visible = False
        OnClick = RFile3Click
      end
      object RFile4: TMenuItem
        Visible = False
        OnClick = RFile4Click
      end
      object RFile5: TMenuItem
        Visible = False
        OnClick = RFile5Click
      end
      object RFile6: TMenuItem
        Visible = False
        OnClick = RFile6Click
      end
      object N3: TMenuItem
        Caption = '-'
        Visible = False
      end
      object FileExitItem: TMenuItem
        Action = FileExit1
      end
    end
    object Play2: TMenuItem
      Caption = 'Play'
      Hint = 'Playback controls'
      object Play3: TMenuItem
        Action = PlayStop
      end
      object PlayFromLine1: TMenuItem
        Action = PlayFromLine
      end
      object Play4: TMenuItem
        Action = Play1
      end
      object Playpatternfromcurrentline1: TMenuItem
        Action = PlayPatFromLine
      end
      object Playpatternfromstart1: TMenuItem
        Action = PlayPat
      end
      object Stop2: TMenuItem
        Action = Stop
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object Togglelooping1: TMenuItem
        Action = ToggleLooping
      end
      object Toggleloopingall1: TMenuItem
        Action = ToggleLoopingAll
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object Togglesamples1: TMenuItem
        Caption = 'Toggle samples'
        Hint = 'Switch on/off standalone samples'
        ImageIndex = 31
        OnClick = ToggleSamplesClick
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      Hint = 'Edit commands'
      object Undo1: TMenuItem
        Action = Undo
      end
      object Redo1: TMenuItem
        Action = Redo
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object CutItem: TMenuItem
        Action = EditCut1
      end
      object CopyItem: TMenuItem
        Action = EditCopy1
      end
      object PasteItem: TMenuItem
        Action = EditPaste1
      end
      object N21: TMenuItem
        Caption = '-'
      end
      object CopyToModPlug: TMenuItem
        Action = CopyToModplugAct
        ImageIndex = 44
      end
      object CopyToRenoise: TMenuItem
        Action = CopyToRenoiseAct
        ImageIndex = 44
      end
      object CopyToFami: TMenuItem
        Action = CopyToFamiAct
        ImageIndex = 44
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Tracksmanager1: TMenuItem
        Caption = 'Tracks manager'
        Hint = 'Copy/move/swap/transpose tracks'
        ImageIndex = 42
        OnClick = TracksManagerClick
      end
      object Globaltransposition1: TMenuItem
        Caption = 'Global transposition'
        Hint = 'Transpose channel/pattern/module'
        ImageIndex = 36
        ShortCut = 49236
        OnClick = GlobalTranspositionClick
      end
    end
    object Window1: TMenuItem
      Caption = '&Window'
      Hint = 'Window related commands'
      object Maximize: TMenuItem
        Action = Maximize1
        ShortCut = 49222
      end
      object Normal1: TMenuItem
        Action = Normal
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      Hint = 'Help topics'
      object HelpAboutItem: TMenuItem
        Action = HelpAbout1
      end
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'PT3'
    Filter = 
      'All supported files|*.vt2;*.pt3;*.pt2;*.stc;*.stp;*.sqt;*.asc;*.' +
      'psc;*.fls;*.pt1;*.gtr;*.ftc;*.fxm;*.ay;*.psm;*.txt|Vortex Tracke' +
      'r module (*.vt2)|*.vt2|Vortex Tracker old module (*.txt)|*.txt|P' +
      'ro Tracker 3.xx files (PT3)|*.pt3|Pro Tracker 2.xx files (PT2)|*' +
      '.pt2|Sound Tracker 1.x compiled files (STC)|*.stc|Sound Tracker ' +
      'Pro compiled files (STP)|*.stp|SQ-Tracker compiled files (SQT)|*' +
      '.sqt|ASC Sound Master compiled files (ASC)|*.asc|Pro Sound Creat' +
      'or files (PSC)|*.psc|Flash Tracker files (FLS)|*.fls|Pro Tracker' +
      ' 1.xx files (PT1)|*.pt1|Global Tracker 1.x (GTR)|*.gtr|Fast Trac' +
      'ker (FTC)|*.ftc|Fuxoft'#39's AY Language (FXM, AY AMAD)|*.fxm;*.ay|P' +
      'ro Sound Maker files (PSM)|*.psm'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofEnableSizing]
    Title = 'Open module(s):'
    Left = 8
    Top = 200
  end
  object ActionList1: TActionList
    Images = ImageList1
    Left = 72
    Top = 200
    object PlayStop: TAction
      Category = 'Play'
      Caption = 'Play/Stop'
      ImageIndex = 18
      ShortCut = 32
      OnExecute = PlayStopExecute
      OnUpdate = PlayStopUpdate
    end
    object PlayFromLine: TAction
      Category = 'Play'
      Caption = 'Play from Line'
      ImageIndex = 18
      OnExecute = PlayFromLineExecute
      OnUpdate = PlayFromLineUpdate
    end
    object Play1: TAction
      Category = 'Play'
      Caption = 'Play from Start'
      Hint = 'Play from start|Play module from start'
      ImageIndex = 38
      OnExecute = Play1Execute
      OnUpdate = Play1Update
    end
    object FileNew1: TAction
      Category = 'File'
      Caption = '&New'
      Hint = 'New|Create a new file'
      ImageIndex = 6
      ShortCut = 16462
      OnExecute = FileNew1Execute
      OnUpdate = FileNew1Update
    end
    object PlayPatFromLine: TAction
      Category = 'Play'
      Caption = 'Play pattern'
      Hint = 'Play pattern|Play current pattern from current line'
      ImageIndex = 40
      OnExecute = PlayPatFromLineExecute
      OnUpdate = PlayPatFromLineUpdate
    end
    object FileOpen1: TAction
      Category = 'File'
      Caption = '&Open'
      Hint = 'Open|Open a file'
      ImageIndex = 7
      ShortCut = 16463
      OnExecute = FileOpen1Execute
      OnUpdate = FileOpen1Update
    end
    object FileClose1: TWindowClose
      Category = 'File'
      Caption = '&Close'
      Hint = 'Close|Close current file'
      ShortCut = 16471
      OnUpdate = FileClose1Update
    end
    object FileSave1: TAction
      Category = 'File'
      Caption = '&Save'
      Hint = 'Save|Save current file'
      ImageIndex = 8
      ShortCut = 16467
      OnExecute = FileSave1Execute
      OnUpdate = FileSave1Update
    end
    object FileSaveAs1: TAction
      Category = 'File'
      Caption = 'Save &As...'
      Hint = 'Save As|Save current file with different name'
      OnExecute = FileSaveAs1Execute
      OnUpdate = FileSaveAs1Update
    end
    object JoinTracksBtn: TAction
      Category = 'File'
      Caption = 'TS'
      OnExecute = JoinTracksExecute
      OnUpdate = JoinTracksUpdate
    end
    object FileExit1: TAction
      Category = 'File'
      Caption = 'E&xit'
      Hint = 'Exit|Exit application'
      OnExecute = FileExit1Execute
    end
    object EditCut1: TAction
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = 'Cut|Cuts the selection and puts it on the Clipboard'
      ImageIndex = 0
      ShortCut = 16472
      OnExecute = EditCut1Execute
      OnUpdate = EditCut1Update
    end
    object EditCopy1: TAction
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 1
      ShortCut = 16451
      OnExecute = EditCopy1Execute
      OnUpdate = EditCopy1Update
    end
    object EditPaste1: TAction
      Category = 'Edit'
      Caption = '&Paste'
      Hint = 'Paste|Inserts Clipboard contents'
      ImageIndex = 2
      ShortCut = 16470
      OnExecute = EditPaste1Execute
      OnUpdate = EditPaste1Update
    end
    object HelpAbout1: TAction
      Category = 'Help'
      Caption = '&About...'
      Hint = 
        'About|Displays program information, version number, and copyrigh' +
        't'
      OnExecute = HelpAbout1Execute
    end
    object SetLoopPos: TAction
      Category = 'Edit'
      Caption = 'Set loop position'
      Hint = 'Loop|Set loop position'
      ShortCut = 76
      OnExecute = SetLoopPosExecute
      OnUpdate = SetLoopPosUpdate
    end
    object InsertPosition: TAction
      Category = 'Edit'
      Caption = 'Insert position'
      Hint = 'Insert position'
      ShortCut = 45
      OnExecute = InsertPositionExecute
      OnUpdate = InsertPositionUpdate
    end
    object DeletePosition: TAction
      Category = 'Edit'
      Caption = 'Delete position'
      Hint = 'Delete Position'
      ShortCut = 46
      OnExecute = DeletePositionExecute
      OnUpdate = DeletePositionUpdate
    end
    object ToggleChip: TAction
      Caption = 'YM'
      Hint = 'Chip|Toggle sound chip'
      OnExecute = ToggleChipExecute
    end
    object ToggleChanAlloc: TAction
      Caption = 'ABC'
      Hint = 'Channels|Toggle channel allocation'
      OnExecute = ToggleChanAllocExecute
    end
    object PlayPat: TAction
      Category = 'Play'
      Caption = 'Play pattern from start'
      Hint = 'Play pattern from start|Play current pattern from start'
      ImageIndex = 41
      OnExecute = PlayPatExecute
      OnUpdate = PlayPatUpdate
    end
    object ToggleLoopingAll: TAction
      Category = 'Play'
      Caption = 'Toggle looping all'
      Hint = 'Loop all|Toggle looping among all opened files'
      ImageIndex = 39
      OnExecute = ToggleLoopingAllExecute
      OnUpdate = ToggleLoopingAllUpdate
    end
    object ToggleLooping: TAction
      Category = 'Play'
      Caption = 'Toggle looping'
      Hint = 'Loop|Toggle looping'
      ImageIndex = 37
      OnExecute = ToggleLoopingExecute
      OnUpdate = ToggleLoopingUpdate
    end
    object Undo: TAction
      Category = 'Edit'
      Caption = 'Undo'
      Hint = 'Undo|Undo last change'
      ImageIndex = 3
      ShortCut = 16474
      OnExecute = UndoExecute
      OnUpdate = UndoUpdate
    end
    object Redo: TAction
      Category = 'Edit'
      Caption = 'Redo'
      Hint = 'Redo|Redo last undo'
      ImageIndex = 4
      ShortCut = 24666
      OnExecute = RedoExecute
      OnUpdate = RedoUpdate
    end
    object TransposeUp1: TAction
      Category = 'Edit'
      Caption = 'Transpose +1'
      SecondaryShortCuts.Strings = (
        '')
      OnExecute = TransposeUp1Execute
      OnUpdate = TransposeUp1Update
    end
    object TransposeDown1: TAction
      Category = 'Edit'
      Caption = 'Transpose -1'
      OnExecute = TransposeDown1Execute
      OnUpdate = TransposeDown1Update
    end
    object TransposeUp3: TAction
      Category = 'Edit'
      Caption = 'TransposeUp3'
      OnExecute = TransposeUp3Execute
      OnUpdate = TransposeUp3Update
    end
    object TransposeDown3: TAction
      Category = 'Edit'
      Caption = 'TransposeDown3'
      OnExecute = TransposeDown3Execute
      OnUpdate = TransposeDown3Update
    end
    object TransposeUp5: TAction
      Category = 'Edit'
      Caption = 'TransposeUp5'
      OnExecute = TransposeUp5Execute
      OnUpdate = TransposeUp5Update
    end
    object TransposeDown5: TAction
      Category = 'Edit'
      Caption = 'TransposeDown5'
      OnExecute = TransposeDown5Execute
      OnUpdate = TransposeDown5Update
    end
    object TransposeUp12: TAction
      Category = 'Edit'
      Caption = 'Transpose +12'
      OnExecute = TransposeUp12Execute
      OnUpdate = TransposeUp12Update
    end
    object TransposeDown12: TAction
      Category = 'Edit'
      Caption = 'Transpose -12'
      OnExecute = TransposeDown12Execute
      OnUpdate = TransposeDown12Update
    end
    object DuplicateLastNoteParams: TAction
      Category = 'Edit'
      Caption = 'Duplicate Last Note Params'
      ShortCut = 8219
      OnExecute = DuplicateLastNoteParamsExecute
    end
    object MoveBetwnPatrns: TAction
      Category = 'Edit'
      Caption = 'Move Between Patterns'
      ShortCut = 8384
      OnExecute = MoveBetwnPatrnsExecute
    end
    object AutoStep0: TAction
      Caption = 'Set autostep to 0'
      ShortCut = 16432
      OnExecute = AutoStep0Execute
    end
    object AutoStep1: TAction
      Caption = 'AutoStep1'
      ShortCut = 16433
      OnExecute = AutoStep1Execute
    end
    object AutoStep2: TAction
      Caption = 'AutoStep2'
      ShortCut = 16434
      OnExecute = AutoStep2Execute
    end
    object AutoStep3: TAction
      Caption = 'AutoStep3'
      ShortCut = 16435
      OnExecute = AutoStep3Execute
    end
    object AutoStep4: TAction
      Caption = 'AutoStep4'
      ShortCut = 16436
      OnExecute = AutoStep4Execute
    end
    object AutoStep5: TAction
      Caption = 'AutoStep5'
      ShortCut = 16437
      OnExecute = AutoStep5Execute
    end
    object AutoStep6: TAction
      Caption = 'AutoStep6'
      ShortCut = 16438
      OnExecute = AutoStep6Execute
    end
    object AutoStep7: TAction
      Caption = 'AutoStep7'
      ShortCut = 16439
      OnExecute = AutoStep7Execute
    end
    object AutoStep8: TAction
      Caption = 'AutoStep8'
      ShortCut = 16440
      OnExecute = AutoStep8Execute
    end
    object AutoStep9: TAction
      Caption = 'AutoStep9'
      ShortCut = 16441
      OnExecute = AutoStep9Execute
    end
    object ExportToWAV: TAction
      Category = 'File'
      Caption = 'Export to WAV...'
      OnExecute = ExportToWAVExecute
      OnUpdate = ExportToWAVUpdate
    end
    object NewTurbosound: TAction
      Category = 'File'
      Caption = 'New &Turbosound'
      ImageIndex = 6
      ShortCut = 24654
      OnExecute = NewTurbosoundExecute
      OnUpdate = NewTurbosoundUpdate
    end
    object SaveAsTwoModules: TAction
      Category = 'File'
      Caption = 'Save As 2 modules...'
      OnExecute = SaveAsTwoModulesExecute
      OnUpdate = SaveAsTwoModulesUpdate
    end
    object Stop: TAction
      Category = 'Play'
      Caption = 'Stop'
      ImageIndex = 20
      OnExecute = StopExecute
      OnUpdate = StopUpdate
    end
    object Maximize1: TAction
      Category = 'Window'
      Caption = '&Maximize'
      OnExecute = Maximize1Execute
    end
    object Normal: TAction
      Category = 'Window'
      Caption = '&Normal'
      ShortCut = 49223
      OnExecute = NormalExecute
    end
    object SwapChannelsLeft1: TAction
      Category = 'Edit'
      Caption = 'Swap channels left'
      ShortCut = 16421
      OnExecute = SwapChannelsLeft1Execute
      OnUpdate = SwapChannelsLeft1Update
    end
    object SwapChannelsRight1: TAction
      Category = 'Edit'
      Caption = 'Swap channels right'
      ShortCut = 16423
      OnExecute = SwapChannelsRight1Execute
      OnUpdate = SwapChannelsRight1Update
    end
    object JoinTracks: TAction
      Category = 'File'
      Caption = 'Join Tracks...'
      OnExecute = JoinTracksExecute
      OnUpdate = JoinTracksUpdate
    end
    object SaveAsTemplate: TAction
      Category = 'File'
      Caption = 'Save As Template'
      OnExecute = SaveAsTemplateExecute
      OnUpdate = SaveAsTemplateUpdate
    end
    object JmpPatStartAct: TAction
      Category = 'Edit'
      Caption = 'HK_JMP_PAT_START'
    end
    object JmpPatEndAct: TAction
      Category = 'Edit'
      Caption = 'JmpPatEndAct'
    end
    object JmpLineStartAct: TAction
      Category = 'Edit'
      Caption = 'JmpLineStartAct'
    end
    object JmpLineEndAct: TAction
      Category = 'Edit'
      Caption = 'JmpLineEndAct'
    end
    object CopyToModplugAct: TAction
      Category = 'Edit'
      Caption = 'Copy to OpenMPT'
      OnExecute = CopyToModplugActExecute
      OnUpdate = CopyToModplugActUpdate
    end
    object CopyToRenoiseAct: TAction
      Category = 'Edit'
      Caption = 'Copy to Renoise'
      OnExecute = CopyToRenoiseActExecute
      OnUpdate = CopyToRenoiseActUpdate
    end
    object CopyToFamiAct: TAction
      Category = 'Edit'
      Caption = 'Copy to FamiTracker'
      OnExecute = CopyToFamiActExecute
      OnUpdate = CopyToFamiActUpdate
    end
    object PackPatternAct: TAction
      Category = 'Edit'
      Caption = 'Pattern packer'
      OnExecute = PackPatternActExecute
    end
    object ExportPSGAct: TAction
      Category = 'File'
      Caption = 'Export PSG...'
      OnExecute = ExportPSGActExecute
      OnUpdate = ExportPSGActUpdate
    end
    object ToggleSamplesAct: TAction
      Caption = 'Toggle Samples Window'
      Hint = 'Toggle Samples|Switch on/off standalone samples'
      ImageIndex = 31
      OnExecute = ToggleSamplesClick
      OnUpdate = ToggleSamplesUpdate
    end
    object TracksManagerAct: TAction
      Caption = 'TracksManagerAct'
      Hint = 'Tracks Manager|Copy/move/swap/transpose tracks'
      ImageIndex = 42
      OnExecute = TracksManagerClick
      OnUpdate = TracksManagerUpdate
    end
    object GlobalTranspositionAct: TAction
      Caption = 'GlobalTranspositionAct'
      Hint = 'Global transposition|Transpose channel/pattern/module'
      ImageIndex = 36
      OnExecute = GlobalTranspositionClick
      OnUpdate = GlobalTranspositionUpdate
    end
  end
  object ImageList1: TImageList
    Left = 104
    Top = 200
    Bitmap = {
      494C010135007D00500010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000000002000001002000000000000000
      0200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B98D5800A971
      2900A8712800A8712800A8712800A8712800A8712800A8712800A8712800A871
      2800A9712900B98E580000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BA8E5800B9853800CA9E
      6100CB9E6100CB9E6100CB9E6100CB9E6100CB9E6100CB9E6100CB9E6100CB9E
      6100CA9E6100B9853800BA8E5800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AB752900B27B2F00DBBA
      8F00EDD9BE00EED9BF00EED9BF00EED9BF00EED9BF00EED9BF00EED9BF00EDD9
      BE00DBBA8F00B27B2F00AB752900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AE792B00C4955200E9D1
      B200F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2
      CC00E9D1B200C4955200AE792B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B17C3300C2904A00E8D0
      B000F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2
      CC00E8D0B000C2904A00B17C3400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B3813B00BF8C4200E7CF
      AE00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2
      CC00E7CFAE00BF8C4200B3813B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B6844400BC883800E1C5
      9D00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2CC00F3E2
      CC00E1C59D00BC883800B6854400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B8884B00B9832E00BB87
      3300CBA05D00CBA15F00CBA15F00CBA15F00CBA15F00CBA15F00CBA15F00CBA0
      5D00BB873300B9832E00B8894C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BC8C5300B57D2100B181
      3600AE803200AC7D2E00AC7C2D00AC7C2D00AC7C2D00AC7C2D00AC7C2D00AC7C
      2D00AA782800B57D2100BC8D5400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BF925C00B1781500D2BC
      9700C8B28400B89E6300DACAA900DED0B500DED0B500DBCCAD00CBB38300D2BE
      9600B8985D00B1781500BF925C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C2976500AE750E00D1BA
      9400E0D2B500D0BC9300F8F4EC000000000000000000F2EADF00B2965700CEBA
      8E00C0A36E00AE750E00C2986500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C59D6C00AC720F00C8AF
      8200D6C4A000DCCBAB00F8F4EC000000000000000000F2EADF00B2965700CEBA
      8E00C0A36E00AC720F00C59E6D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C8A47B00C4995400C4AA
      7B00CEBB9100D1BD9300F8F4EC000000000000000000F2EBDF00B49A5E00CEBA
      8F00C0A36E00C4995400C9A57C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C5A17500B890
      5A00BB966000BC966100D9C2A400DECAB100DECAB100DCC7AA00D1B58B00D5BC
      9700BA956000C5A1750000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009E6613009E6613009E66
      13009E6613000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D5DADD003A3A3A00C7D6E000FDFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B5B4B400B2B1B100B2B1
      B100B2B1B100B2B1B100B2B1B100B2B1B100B2B1B1009E661300E5E9F000E5E9
      F0009E661300B2B1B100B5B4B400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F4F7F9005B6872000B70BD001D8E
      E70073B8E900CBE5F40000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A0704B00A0704B00A070
      4B00A0704B00A0704B00A0704B00A0704B00A0704B00A0704B00A0704B00A070
      4B00A0704B00A0704B00A0704B0000000000B6844400B6844400B6844400B684
      4400B6844400B6844400B6844400B6844400B68444009E661300E2E4E800E2E4
      E8009E661300B6844400B6844400B68444000000000000000000000000000000
      0000D6CFC100DFDAD20000000000000000000000000000000000DFDAD100DAD3
      C6000000000000000000000000000000000000000000C7E0F0000A90F4000D9E
      FE000C9BFB000B90F300358FC700BECAC2000000000000000000000000000000
      00000000000000000000000000000000000000000000A3755000F6AF6900F6AF
      6900F6AF6900F6AF6900F6AF6900F6AF6900F6AF6900F6AF6900F6AF6900F6AF
      6900F6AF6900F6AF6900A375500000000000B6844400D19E6000D4AD7C00D6AE
      7C00D6AE7C00D6AE7C009E6613009E6613009E6613009E661300E3E5E800E3E5
      E8009E6613009E6613009E6613009E661300000000000000000000000000D4CC
      BE00D4A55000D4AB5E00E0DBD3000000000000000000E0DBD100E5BA6800EABB
      6100D9D2C4000000000000000000000000000000000000000000319FEB001BB2
      FF001EC1FF001DBDFF00647951007D661A00C2C4B10000000000000000000000
      00000000000000000000000000000000000000000000A67A5700FCBF7700FFC7
      7D00FFC77D00FFC77D00FFC77D00FFC77D00FFC77D00FFC77D00FFC77D00FFC7
      7D00FFC77D00FCBF7700A67A570000000000B6844400DAAF7400DEBC8E00E1BD
      8E00E1BD8E00E1BD8E009E661300EBF1FB00E6E8EB00E5E7E900E3E3E300E3E3
      E300E5E7E900E6E8EB00E9EEF6009E6613000000000000000000D3CBBD00CC9C
      4600D3A14800D8A95200DAB26B00E0DCD500DFDAD200E2B96D00EABA5E00ECB9
      5900EABA5D00DAD2C400000000000000000000000000000000008FC8EB0028B8
      FE002ED3FF00549883008D721800967C1F00866D1B00D8D0B600000000000000
      00000000000000000000000000000000000000000000AA805E00FCC58100FFCF
      8900FFCF8900FFCF8900FFCF8900FFCF8900FFCF8900D0A98300F3C58800F3C5
      8800D0A98300FCC58100AA805E0000000000B6844400CBAB7C00D9BE9600DBC0
      9600DBC09700DBC097009E661300F4FAFF00EFF1F500EDEFF200EAEAEA00EAEA
      EA00EDEFF200EFF1F500F2F7FF009E6613000000000000000000D8D2C600C799
      4700D09F4600D9AA5400E1B46100DEB87300E2BB7500EABC6700E8B75D00E9B7
      5700E5B65D00DFD9CD0000000000000000000000000000000000E8F3F800339E
      C9006F8F5F0096791B0098781600A7871E00A387230091751E00D9D1B6000000
      00000000000000000000000000000000000000000000AE876500FCCD8D00FFD8
      9700FFD89700FFD89700FFD89700FFD89700FFD897005C4E81008F7987008F79
      87005C4E8100FCCD8D00AE87650000000000B6844400E2CAA100ECD9BA00EDD9
      B700EDD8B300ECD6B0009E6613009E6613009E6613009E661300F1F3F600F1F3
      F6009E6613009E6613009E6613009E661300000000000000000000000000D9D2
      C600CB9E4D00D7A85200DEB05C00E2B56300E5B86500E8BA6400E7B65B00E0B2
      5E00DED8CC0000000000000000000000000000000000000000000000000096A5
      9200A1801800AB8D2700B3912200B5901B00B6942200AC8F2800997B2000DAD1
      B6000000000000000000000000000000000000000000B28D6C00FBD49900FFE0
      A500FFE0A500FFE0A500FFE0A500FFE0A500FFE0A5004A4299000F0FA5000F0F
      A5004A429900FBD49900B28D6C0000000000B6844400DECEB000E7DBC400E7D9
      C100E7D8BD00E6D6BA00E4D4B400E3D1AF00E2CFAB009E661300F6F8FC00F6F8
      FC009E661300E0CEAB00D5BE9200B68444000000000000000000000000000000
      0000D9D2C700D0A35400DBAB5600DEB05B00E2B35D00E5B65E00DFB26000DDD7
      CC0000000000000000000000000000000000000000000000000000000000FAFB
      F900A7A37700AE8B1B00BC9C2D00C5A02700C49B1F00C39E2700B7982B00A383
      2200DBD3B90000000000000000000000000000000000B5927300FBDAA300FFE7
      B200FFE7B200FFE7B200FFE7B200FFE7B200FFE7B200625CB7003434D6003434
      D600625CB700FBDAA300B592730000000000B6844400E8DAB900F4E9D000F5E8
      CC00F4E7C900F4E5C700F3E4C500F2E3C100F1E1BD009E661300FCFFFF00FCFF
      FF009E661300EEDEB800E1CB9E00B68444000000000000000000000000000000
      0000DBD5CB00C99C4C00D6A54E00DBAB5300DFAE5600E2B15700D9AD5B00DFDA
      D000000000000000000000000000000000000000000000000000000000000000
      0000FDFCFB00BFAE7800BB951E00C7A63100D2AB2A00D2A72200CFA92B00C2A1
      2F00A98E3800D7D2C200000000000000000000000000B8977800FBDFAD00FFED
      BD00FFEDBD00FFEDBD00FFEDBD00FFEDBD00FFEDBD005753BD002424D9002424
      D9005753BD00FBDFAD00B897780000000000B6844400DFD3B300E9E0C600E9DF
      C400E9DEC100E9DDBF00E8DBBB00E8D9B800E7D8B6009E6613009E6613009E66
      13009E661300E4D5B100D8C39700B6844400000000000000000000000000DAD4
      C900BE8F3C00C6923600CC993E00D4A14700DAA74C00DDAA4D00D9A44400D3A3
      4B00DFD9CE000000000000000000000000000000000000000000000000000000
      000000000000FDFDFB00C2B07900C79F2100D2AF3500DFB52E00E0B32600DCB4
      2E00C4BB9D00BAB9B700D3D1CB000000000000000000BA9A7C00FFF6D700FFF6
      D700FFF6D700FFF6D700FFF6D700FFF6D700FFF6D7004644C7000909DE000909
      DE004644C700FFF6D700BA9A7C0000000000B6844400F5E9D300F8F0DF00F8EF
      DC00F8EEDC00F7EEDA00FAF4E300FAF2DD00F3E6BF00F4E5BD00F3E4BB00F3E3
      B900F3E3B900F0E2BA00E4D0A100B68444000000000000000000D8D2C700B281
      2B00BC852600C28C2E00C7923400C8984400CD9D4700D09B3A00D19A3600D49C
      3600D1A04400DED9CE0000000000000000000000000000000000000000000000
      00000000000000000000FDFDFB00C4B27900D3A92400DDB83900EBBF3100CBB3
      6B00D2D2D200E3E3E4003855C000CED4E50000000000C4C3C000AAAAAB00AAAA
      AB00AAAAAB00AAAAAB00AAAAAB00AAAAAB00AAAAAB003535BD000505DA000505
      DA003535BD00AAAAAB000000000000000000B6844400B6844400B6844400B684
      4400B6844400B6844400B6844400FAF4E300FCF7E300FBF5E000FBF5DF00FBF5
      DE00FBF5DE00FAF4DF00F2E8CE00B68444000000000000000000CAC0AD00B07B
      2000B57E1E00BC852500BF8E3700DAD3C700D7D0C300C5923600CC942F00CF97
      3100D29C3900D8CDB80000000000000000000000000000000000000000000000
      0000000000000000000000000000FDFDFB00C7B57B00D0AC3A00CFC49A00D5D5
      D500D3D3D30091A1D5001144D000AFB9D90000000000000000008B8B8B00E4E4
      E500E0E0E100DFE0E100DFE0E100E0E1E200E1E2E300DDDDDF00DDDEDF00DDDE
      DF00E2E3E5008B8B8C00000000000000000000000000BDBBB900E2E6EC00EDF0
      F500EBEEF300EBF0F700DFD2C100B6844400B6844400B6844400B6844400B684
      4400B6844400B6844400B6844400B6844400000000000000000000000000C9BE
      AC00B07B1F00B2812A00DCD4C6000000000000000000D7CFC100C4913400CA95
      3300D6CAB5000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFDFB00C3BCA800D4D4D400EEEE
      EE00A1B0DC002865DD005D7BCC00F8F9FC000000000000000000909090000000
      0000000000000000000000000000000000008E8E8E0093939300959595009595
      95009595950000000000000000000000000000000000B4B5B600EAEAEA00F4F4
      F400F2F2F200F2F2F200F4F5F800F0ECE600C0B8AE00A7A19700ABA59B00ABA5
      9B00ABA69C00A6A19B00CAC0B000000000000000000000000000000000000000
      0000CABFAC00DBD2C40000000000000000000000000000000000D7CFC100D5C9
      B400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FCFCFB00C1C0BA005F8B
      DD002A7CEA006182CE00F7F9FC00000000000000000000000000000000008C8C
      8C00969696009696960096969600939393000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000ACACAC00B2B2
      B200B1B1B100B1B1B100B1B1B100AFB0B1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FDFDFD00A9BB
      DC009BB1D900F7F9FC0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000ADA49500ADA49500ADA4
      9500ADA49500ADA49500ADA49500ADA49500ADA4950061727D0061727D006172
      7D00ADA49500ADA49500ADA49500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000ADA49500E8E4DD00E6E1
      DA00E4DFD700E2DCD400E1DAD100DFD8CE00DDD6CB004D453F004C443F004D46
      4000D7CEC100D6CCBF00ADA4950000000000716A6000716A6000716A6000716A
      6000716A6000716A6000716A6000716A6000716A6000716A6000716A6000716A
      6000716A6000716A6000716A6000716A60000000000000000000000000000000
      00000000000000000000000000001500E9001500E9001500E9001500E9001500
      E9001500E9001500E9001500E9001500E9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000ADA49500EAE6E000E8E4
      DD00E6E1DA00E5E0D800E3DDD500E1DBD100E0D9CF003D3631003C3631003E38
      3300D8D0C300D7CEC100ADA495000000000079726800BBB4A800B9B2A800B8B1
      A600CAC3BA00C9C1B900C9C1B900C7C0B800C6BFB700C5BEB500C5BEB500C4BD
      B300ADA69900ADA69900ADA69900797268000000000000000000000000000000
      00000000000000000000000000001500E900E7E7E700E7E7E700DEDEDE00D6D6
      D600CECECE00C6C6C600BDBDBD001500E900BDBDBD00A0A0A0009B9B9B009797
      9700929292008E8E8E008A8A8A0085858500818181007D7D7D00797979007575
      7500727272006E6E6E006B6B6B009292920000000000ADA49500ECE9E300EAE6
      E100E9E5DF00E7E2DB00E5E0D800E3DDD500E2DCD300433C38003E3834003C36
      3100DBD3C700DAD1C500ADA49500000000007D766B00CEC7BD00CDC6BD00CBC4
      B9006F665C00736B6000736B6000736B6000736A5F0072695F0071685D007168
      5D00BEB7A900BDB4A800BDB3A7007D766B000000000000000000000000000000
      00000000000000000000000000001500E900EFEFEF0049282E0049282E004928
      2E0049282E0049282E00BDBDBD001500E900A9A9A900E9E9E900D3D3D300D2D2
      D200D1D1D100D0D0D000CECECE00CDCDCD00CDCDCD00CBCBCB00CBCBCB00CACA
      CA00C9C9C900C8C8C800E2E2E2006B6B6B0000000000ADA49500EDEAE600ECE9
      E400EAE7E100E9E5DF00E7E3DC00E5E0D900E3DED600A4A7A800443F3B00413B
      3600DDD5CA00DBD3C700ADA495000000000082797000D7D1C700D6D0C600D4CD
      C30099908700797166007F776D00847C7100837B70007D756A00766C6300978E
      8300C5BDB100C4BDAF00C4BDAF008279700000000000843D4700843D4700843D
      4700843D4700843D4700843D47001500E900EFEFEF00E7E7E700DEDEDE00D6D6
      D600CECECE00C6C6C600BDBDBD001500E900AEAEAE00D6D6D600B1B1B100A8A8
      A800A6A6A600A4A4A400A2A2A200A1A1A1009E9E9E009C9C9C009C9C9C009A9A
      9A0099999900A2A2A200C8C8C8006F6F6F0000000000ADA49500EEEBE800EDEA
      E600898685005F5B590049454300E7E2DC00E6E1DA00949291001A1817001917
      1600DFD8CE00DDD6CB00ADA4950000000000857E7200E0DBD100DED9D000DDD7
      CE00DCD6CC00D0CABF00A1998E00847C7100837970009D958B00CBC3B800D0CA
      BD00CFC7BD00CDC5BA00CBC3B700857E720000000000843D4700E7E7E700DEDE
      DE00D6D6D600C6C6C600BDBDBD001500E900EFEFEF0049282E0049282E004928
      2E0049282E0049282E00C6C6C6001500E900B2B2B200D9D9D900717171006767
      6700666666006464640064646400636363006161610061616100606060005E5E
      5E005D5D5D0078787800CACACA007373730000000000ADA49500F0EEEB00EFED
      E900888380009A9593004C474500EAE6E000E8E4DD0033302E000A090900100F
      0E00E1DAD100E0D9CF00ADA49500000000008B837800E9E4DD00E8E3DC00E7E1
      D900E4DED600E4DED600E0DBD200877E7500877E7500E0DBD100DBD4CA00D8D1
      C700D7D0C500D7CFC400D5CDC1008B83780000000000843D4700EFEFEF000000
      00000000000000000000000000001500E900F7F7F700EFEFEF00E7E7E700DEDE
      DE00D6D6D600CECECE00C6C6C6001500E900B7B7B700DDDDDD00B7B7B700ADAD
      AD00ACACAC00AAAAAA00A8A8A800A6A6A600A5A5A500A3A3A300A1A1A1009E9E
      9E009D9D9D00A8A8A800CFCFCF0077777700E1E5EC00ADA49500D2C7B800F0EE
      EB006B686700534F4D00413C3A00ECE8E300EAE6E100463F3A00413D3A003D38
      3500E3DED500D2C7B800ADA49500D7DCE6008F887D00F1ECE600EEEAE300EDE9
      E100ECE7E000EBE6DD00C3BDB4008A82780089827700C3BDB400E3DDD400E1DB
      D100E0DBD000DDD7CD00DCD5CB008F887D0000000000843D4700EFEFEF00E7E7
      E700D6D6D600CECECE00C6C6C6001500E900F7F7F70049282E0049282E00DEDE
      DE001500E9001500E9001500E9001500E900CCCCCC00DADADA00C8C8C800C1C1
      C100C0C0C000BEBEBE00BBBBBB00B9B9B900B8B8B800B6B6B600B4B4B400B1B1
      B100B0B0B000B4B4B400C3C3C3009D9D9D0049557200F0EDE700ADA49500D2C7
      B800F0EEEB00EFEDEA00EEECE800EDEAE600ECE9E400EAE6E100E9E5DE00E8E3
      DC00D2C7B800ADA49500F0EDE70049557200948B8100F4F1EA00F3EFE900F3EE
      E900F2EDE700EFEBE400BAB3AB008F897F008E887E00BEB7AE00E9E3DC00E7E1
      D900E6E0D700E3DDD400E2DCD200948B810000000000843D4700EFEFEF000000
      00000000000000000000000000001500E900FFFFFF00F7F7F700EFEFEF00E7E7
      E7001500E900DEDEDE001500E90000000000CFCFCF00E3E3E300E7E7E700E1E1
      E100E0E0E000E0E0E000DFDFDF00DFDFDF00DEDEDE00DDDDDD00DDDDDD00DCDC
      DC00DBDBDB00E0E0E000D0D0D000A0A0A000788AA40049557200F0EDE700ADA4
      9500D2C7B800F1EFEC00F0EEEB00EEEBE800EDEAE600ECE9E400EAE6E100D2C7
      B800ADA49500F0EDE70049557200A0ABBE00978F8400F8F4EE00F8F4EE00F5F2
      EC00F4F1EB00F3EFE900B5AEA700908A81008E877E00BDB7AD00EDE9E100ECE7
      E000EBE6DD00E9E3DC00E7E1D900978F840000000000843D4700F7F7F700E7E7
      E700DEDEDE00D6D6D600C6C6C6001500E900FFFFFF00F7F7F700EFEFEF00E7E7
      E7001500E9001500E9000000000000000000F0F0F000CECECE00ECECEC00DEDE
      DE00D8D8D800D2D2D200CCCCCC00C8C8C800C7C7C700C8C8C800CBCBCB00D0D0
      D000DDDDDD00E8E8E800A5A5A500DFDFDF00000000008695AD0049557200F0ED
      E700ADA49500D2C7B800F1F0ED00F0EEEB00EFEDE900EEEBE700D2C7B800ADA4
      9500F0EDE700495572008897AF00000000009C938800F9F5EF00F9F5EF00F9F5
      EF00F8F4EE00F8F4EE00DDD7D000958E8500A09A9000E6E1D900F3EEE800F1EC
      E600EEEAE300EDE9E100ECE7E0009C93880000000000843D4700F7F7F7000000
      000000000000D6D6D600843D47001500E9001500E9001500E9001500E9001500
      E9001500E90000000000000000000000000000000000D3D3D300E3E3E300DBDB
      DB00E2E2E200E2E2E200E1E1E100E0E0E000E0E0E000E0E0E000DFDFDF00C3C3
      C300D1D1D100D3D3D300ABABAB00000000000000000000000000748299004955
      7200F0EDE700ADA49500D2C7B800F1F0ED00F0EEEB00D2C7B800ADA49500F0ED
      E700495572008897AF000000000000000000A0968B00FFFFFA00FFFFFA00FFFF
      FA00FFFFFA00FFFFFA00FFFFFA00FFFEF900FFFEF900FFFDF900FFFDF900FEFB
      F800FEFBF800FDF9F500FBF9F400A0968B0000000000843D4700F7F7F700EFEF
      EF00E7E7E700D6D6D600843D4700C8D0D400843D470000000000000000000000
      00000000000000000000000000000000000000000000F1F1F100D1D1D100F3F3
      F300EDEDED00EDEDED00EDEDED00EDEDED00EDEDED00ECECEC00ECECEC00ECEC
      EC00F1F1F100B0B0B000E3E3E300000000000000000000000000ADA495007683
      990049557200F0EDE700ADA49500D2C7B800D2C7B800ADA49500F0EDE7004955
      72008897AF00000000000000000000000000C7C2BB00A2998E00A2998E00A299
      8E00A2998E00A2998E00A2998E00A2998E00A2998E00A2998E00A2998E00A299
      8E00A2998E00A2998E00A2998E00C7C2BB0000000000843D4700FFFFFF00EFEF
      EF00E7E7E700DEDEDE00843D4700843D4700000000000000000000000000843D
      4700000000000000000000000000000000000000000000000000D6D6D600C5C5
      C500C1C1C100BEBEBE00BABABA00B6B6B600B2B2B200AEAEAE00A9A9A900A5A5
      A500A1A1A100B5B5B50000000000000000000000000000000000BCB2A300D4CD
      C30074829A0049557200F0EDE700ADA49500ADA49500F0EDE700495572008897
      AF0000000000000000000000000000000000FFFFFF00A49E9500E4DED600E4DE
      D600E4DED600E4DED600A49E9500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000843D4700843D4700843D
      4700843D4700843D4700843D47000000000000000000843D4700843D47000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A79F9700C7C2
      BC00A29A92008695AD0049557200F0EDE700F0EDE700495572008897AF000000
      000000000000000000000000000000000000FFFFFF00CAC6C100A49E9500A49E
      9500A49E9500A49E9500CAC6C100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BCB2A300D4CD
      C300ADA49500000000008695AD0049557200495572008897AF00000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848284008482
      8400848284008482840084828400848284008482840084828400848284008482
      84008482840084828400848284000000000000000000000000009F9F9F009C9C
      9C009898980095959500919191008E8E8E008B8B8B0087878700848484008181
      8100808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFCED60000000000000000000000
      0000000000000000000000000000000000000000000004020400040204000402
      0400040204000402040004020400048204000402040004020400040204000402
      0400040204000402040084828400000000000000000000000000A8A8A8001F1F
      1F001F1F1F001F1F1F001F1F1F001F1F1F001F1F1F001F1F1F001F1F1F001F1F
      1F00858585000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFB5BD00FFD6D600FFEFF700000000000000
      0000000000000000000000000000000000000000000004020400040204000402
      040004020400040204000402040004FE04000402040000EBF000040204000402
      0400040204000402040084828400000000000000000000000000B1B1B1004646
      460000FF000000FF000000FF00001F1F1F0000FF00001F1F1F0000FF00004646
      46008E8E8E000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF8C9C00FFADB500FFC6CE00FFD6DE00FFD6DE000000
      00000000000000000000000000000000000000000000040204001200FF000402
      0400040204001200FF00040204000482040000EBF00000EBF000040204000402
      0400040204000402040084828400000000000000000000000000B9B9B9001F1F
      1F001F1F1F0000FF00001F1F1F001F1F1F0000FF00002525250000FF00002525
      2500979797000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFCED60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF637300FF7B8C00FF94A500FFADB500FFBDC600FFBDC600FFAD
      B5000000000000000000000000000000000000000000040204001200FF000012
      9100040204001200FF001200FF0000EBF00000EBF00000EBF00000EBF00000EB
      F000008380000402040084828400000000000000000000000000C1C1C1004646
      46004646460000FF00001F1F1F001F1F1F0000FF000000FF00001F1F1F004646
      46009F9F9F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFB5BD00FFD6D600FFEFF700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000004020400001291001200
      FF001200FF001200FF001200FF001200FF0000EBF00000EBF000040204000083
      800000EBF0000402040084828400000000000000000000000000C9C9C9001F1F
      1F0000FF000000FF000000FF00001F1F1F001F1F1F001F1F1F001F1F1F001F1F
      1F00A7A7A7000000000000000000000000000000000000000000000000000000
      00000000000000000000FF8C9C00FFADB500FFC6CE00FFD6DE00FFD6DE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000004020400040204000402
      0400040204001200FF001200FF00048204000402040000EBF000040204000402
      040000EBF0000402040084828400000000000000000000000000D2D2D2004646
      4600464646004646460046464600464646004646460046464600464646004646
      4600B0B0B0000000000000000000000000000000000000000000000000000000
      000000000000FF637300FF7B8C00FF94A500FFADB500FFBDC600FFBDC600FFAD
      B500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000004020400040204000402
      0400040204001200FF000402040004FE04000402040004020400040204000402
      0400040204000402040084828400000000000000000000000000DBDBDB00D8D8
      D800D4D4D400D0D0D000CDCDCD00C9C9C900C6C6C600C3C3C300BFBFBF00BCBC
      BC00B9B9B9000000000000000000000000000000000000000000000000000000
      0000FF9C9C00FF9C9C00FF9C9C00FF9C9C00FF9C9C00FF9C9C00FF9C9C00FF9C
      9C00FF9C9C000000000000000000000000000000000000000000000000000000
      0000FF9C9C00FF9C9C00FF9C9C00FF9C9C00FF9C9C00FF9C9C00FF9C9C00FF9C
      9C00FF9C9C00000000000000000000000000000000000482040004FE04000402
      04000482040004FE040004020400048204000402040004FE040004FE040004FE
      0400040204000402040084828400000000000000000000000000E3E3E300E0E0
      E000DCDCDC00D9D9D900D6D6D600D2D2D200CECECE00CCCCCC00C8C8C800C5C5
      C500C1C1C1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF9C9C00FF9C9C00FF9C9C00FF9C9C00FF9C9C00FF9C9C00FF9C9C00FF9C
      9C00FF9C9C00000000000000000000000000000000000482040004FE04000402
      04000482040004FE04000402040004FE04000402040004FE0400040204000482
      040004FE04000402040084828400000000000000000000000000ECECEC008080
      80008080800080808000DEDEDE00DBDBDB00D7D7D700D4D4D400D0D0D000CDCD
      CD00CACACA000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000482040004FE040004FE
      040004FE040004FE040004020400048204000402040004FE040004FE040004FE
      0400040204000402040084828400000000000000000000000000F4F4F400EDED
      ED00EDEDED00E6E6E600E6E6E600E3E3E300DFDFDF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000482040004FE04000402
      04000482040004FE04000402040004FE04000402040004FE0400040204000482
      040004FE04000402040084828400000000000000000000000000FCFCFC008080
      800080808000EBEBEB00EBEBEB00EBEBEB00E8E8E80000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000040204000482040004FE
      040004FE04000482040004020400048204000402040004FE040004FE040004FE
      0400040204000402040084828400000000000000000000000000FFFFFF00FFFF
      FF00FEFEFE00FAFAFA00F7F7F700F4F4F400F0F0F00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000004020400040204000402
      040004020400040204000402040004FE04000402040004020400040204000402
      0400040204000402040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFA5A5000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFB0B000FFA6A6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF9C9C00FF9C9C0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFDB
      DB00FFD2D200FFCACA00FFC1C100FFB9B900FFB1B100FFA8A800FFA0A000FF97
      9700FF8E8E0000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000000000000000000000000000000000000000000080
      000000FF0000000000008080800000000000000000000000000000000000FFEC
      EC00FFE3E300000000000000000000000000FFBBBB00FFB1B100FFA7A700FF9D
      9D00FF939300FF898900FF808000000000000000000000000000000000000000
      0000FF9C9C00FF9C9C00000000000000000000000000FF94A500000000000000
      000000000000000000000000000000000000000000000000000000000000FFDC
      DC00000000000000000000000000000000000000000000000000000000000000
      0000FF8F8F0000000000000000000000000000000000000000000000000000FF
      00000080000000FF00000000000000FF000000FF00000000000000FF000000FF
      000000FF0000000000008080800000000000000000000000000000000000FFED
      ED000000000000000000000000000000000000000000FFB2B200FFA8A8000000
      00000000000000000000FF808000000000000000000000000000000000000000
      0000FF9C9C00FF9C9C00000000000000000000000000FFADB500FFC6CE000000
      000000000000000000000000000000000000000000000000000000000000FFDD
      DD00000000000000000000000000000000000000000000000000000000000000
      0000FF90900000000000000000000000000000000000000000000000000000FF
      00000000000000FF00000000000000000000000000000000000000FF00000080
      000000FF0000000000008080800000000000000000000000000000000000FFEE
      EE00000000000000000000000000000000000000000000000000FFA9A9000000
      00000000000000000000FF818100000000000000000000000000000000000000
      0000FF9C9C00FF9C9C00000000000000000000000000FFBDC600FFD6DE00FFEF
      F70000000000000000000000000000000000000000000000000000000000FFDE
      DE00000000000000000000000000000000000000000000000000000000000000
      0000FF91910000000000000000000000000000000000000000000000000000FF
      000000FF0000008000000000000000000000000000000000000000FF00000000
      000000000000000000008080800000000000000000000000000000000000FFEF
      EF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF828200000000000000000000000000000000000000
      0000FF9C9C00FF9C9C00000000000000000000000000FFBDC600FFD6DE00FFEF
      F700FFE7E700000000000000000000000000000000000000000000000000FFDF
      DF00000000000000000000000000000000000000000000000000000000000000
      0000FF9191000000000000000000000000000000000000000000000000000080
      0000000000000080000000000000008000000000000000800000000000000080
      000000000000000000008080800000000000000000000000000000000000FFF0
      F000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF838300000000000000000000000000000000000000
      0000FF9C9C00FF9C9C00000000000000000000000000FFADB500FFC6CE00FFD6
      D600FFCED600FFBDC600000000000000000000000000FFF1F100FFE8E800FFE0
      E000FFD7D700FFCECE0000000000000000000000000000000000000000000000
      0000FF92920000000000000000000000000000000000000000000000000000FF
      00000080000000FF00000080000000FF00000080000000FF00000080000000FF
      000000800000000000008080800000000000000000000000000000000000FFF1
      F100000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF848400000000000000000000000000000000000000
      0000FF9C9C00FF9C9C00000000000000000000000000FF94A500FFADB500FFB5
      BD00FFB5BD000000000000000000000000000000000000000000FFE9E900FFE1
      E100FFD8D800000000000000000000000000000000000000000000000000FF9C
      9C00FF939300FF8B8B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008080800000000000000000000000000000000000FFF2
      F200000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF858500000000000000000000000000000000000000
      0000FF9C9C00FF9C9C00000000000000000000000000FF7B8C00FF8C9C00FF94
      9C0000000000000000000000000000000000000000000000000000000000FFE2
      E200000000000000000000000000000000000000000000000000FFA6A600FF9D
      9D00FF959500FF8C8C00FF848400000000000000000000000000000000000080
      000000FF000000FF000000000000000000000000000000000000000000000080
      000000FF0000000000008080800000000000000000000000000000000000FFF3
      F300000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF868600000000000000000000000000000000000000
      0000FF9C9C00FF9C9C00000000000000000000000000FF637300FF6B84000000
      000000000000000000000000000000000000000000000000000000000000FFE2
      E200000000000000000000000000000000000000000000000000000000000000
      0000FF96960000000000000000000000000000000000000000000000000000FF
      000000000000000000000000000000FF000000FF00000000000000FF000000FF
      000000FF0000000000008080800000000000000000000000000000000000FFF4
      F400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF878700000000000000000000000000000000000000
      0000FF9C9C00FF9C9C00000000000000000000000000FF425A00000000000000
      000000000000000000000000000000000000000000000000000000000000FFE3
      E300000000000000000000000000000000000000000000000000000000000000
      0000FF96960000000000000000000000000000000000000000000000000000FF
      000000800000000000000000000000000000000000000000000000FF00000080
      000000FF0000000000008080800000000000000000000000000000000000FFF5
      F500FFECEC00FFE1E100FFD7D700FFCECE00FFC3C300FFB9B900FFB0B000FFA6
      A600FF9C9C00FF929200FF888800000000000000000000000000000000000000
      0000FF9C9C00FF9C9C0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFE5
      E500000000000000000000000000000000000000000000000000000000000000
      0000FF9797000000000000000000000000000000000000000000000000000080
      000000FF000000FF00000000000000000000000000000000000000FF00000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFE6
      E600000000000000000000000000000000000000000000000000000000000000
      0000FF9898000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFE6
      E600FFDDDD00FFD5D500FFCCCC00FFC4C400FFBBBB00FFB3B300FFAAAA00FFA1
      A100FF9999000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000080008080800000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000800000008000808080000000000000000000000000000000FF000000
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000080000000FF000000FF
      00000080000000FF000000FF00000080000000FF000000FF00000080000000FF
      000000FF00000080000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF0000008000000080000000800080808000000000000000FF00000080000000
      8000000080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000080000000FF000000FF
      00000080000000FF000000FF00000080000000FF000000FF00000080000000FF
      000000FF00000080800000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000800000008000000080000000800000008000000080000000
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000080800000FFFF0000FF
      FF000080800000FFFF0000FFFF000080800000FFFF0000FFFF000080800000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000008000000080000000800000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000080800000FFFF0000FF
      FF000080800000808000008080000080800000FFFF0000FFFF000080800000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000000080000000800000008000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000080800000FFFF0000FF
      FF000080800000000000000000000080800000FFFF0000FFFF000080800000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000080000000800000008000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000080800000FFFF0000FF
      FF000080800000000000000000000080800000FFFF0000FFFF000080800000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000008000000080000000800000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000008080000080
      80000080800000000000000000000080800000FFFF0000FFFF000080800000FF
      FF0000FFFF000080800000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000800000008000000080008080800000008000000080000000
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000080800000FFFF0000FFFF00008080000080
      8000008080000080800000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000008000000080000000800080808000000000000000FF00000080000000
      8000000080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000080800000FFFF0000FFFF00008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF0000008000000000000000000000000000000000000000FF000000
      8000000080000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000FF000000FF00000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000080000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000FF000000FF00000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080000000800000008000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009F9F9F009C9C
      9C009898980095959500919191008E8E8E008B8B8B0087878700848484008181
      81008080800000000000000000000000000000000000000000009F9F9F009C9C
      9C009898980095959500919191008E8E8E008B8B8B0087878700848484008181
      81008080800000000000000000000000000000000000000000009F9F9F009C9C
      9C009898980095959500919191008E8E8E008B8B8B0087878700848484008181
      810080808000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000A8A8A8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000858585000000000000000000000000000000000000000000A8A8A8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000858585000000000000000000000000000000000000000000A8A8A8000000
      0000000000000000000000000000000000000000000000000000000000000000
      000085858500000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000B1B1B1000000
      000000FF000000FF00000000000000000000000000000000000000FF00000000
      00008E8E8E000000000000000000000000000000000000000000B1B1B1000000
      000000FF0000000000000000000000FF0000000000000000000000FF00000000
      00008E8E8E000000000000000000000000000000000000000000B1B1B1000000
      00000000000000000000000000000000000000FF000000FF0000000000000000
      00008E8E8E00000000000000000000000000000000000000000000000000FFFF
      FF00000000008080800000000000808080008080800080808000808080008080
      800000000000FFFFFF0000000000000000000000000000000000B9B9B9000000
      000000FF00000000000000FF00000000000000FF000000FF000000FF00000000
      0000979797000000000000000000000000000000000000000000B9B9B9000000
      000000FF000000FF00000000000000FF00000000000000FF000000FF00000000
      0000979797000000000000000000000000000000000000000000B9B9B9000000
      000000FF0000000000000000000000FF0000000000000000000000FF00000000
      000097979700000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000C1C1C1000000
      000000FF00000000000000FF00000000000000FF00000000000000FF00000000
      00009F9F9F000000000000000000000000000000000000000000C1C1C1000000
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000
      00009F9F9F000000000000000000000000000000000000000000C1C1C1000000
      000000FF0000000000000000000000FF0000000000000000000000FF00000000
      00009F9F9F00000000000000000000000000000000000000000000000000FFFF
      FF00000000008080800000000000808080008080800080808000808080008080
      800000000000FFFFFF0000000000000000000000000000000000C9C9C9000000
      000000FF000000FF0000000000000000000000FF000000000000000000000000
      0000A7A7A7000000000000000000000000000000000000000000C9C9C9000000
      00000000000000FF000000FF00000000000000FF000000FF0000000000000000
      0000A7A7A7000000000000000000000000000000000000000000C9C9C9000000
      00000000000000FF000000FF00000000000000000000000000000000000000FF
      0000A7A7A700000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000D2D2D2000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B0B0B0000000000000000000000000000000000000000000D2D2D2000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B0B0B0000000000000000000000000000000000000000000D2D2D2000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B0B0B000000000000000000000000000000000000000000000000000FFFF
      FF00000000008080800000000000808080008080800080808000808080008080
      800000000000FFFFFF0000000000000000000000000000000000DBDBDB00D8D8
      D800D4D4D400D0D0D000CDCDCD00C9C9C900C6C6C600C3C3C300BFBFBF00BCBC
      BC00B9B9B9000000000000000000000000000000000000000000DBDBDB00D8D8
      D800D4D4D400D0D0D000CDCDCD00C9C9C900C6C6C600C3C3C300BFBFBF00BCBC
      BC00B9B9B9000000000000000000000000000000000000000000DBDBDB00D8D8
      D800D4D4D400D0D0D000CDCDCD00C9C9C900C6C6C600C3C3C300BFBFBF00BCBC
      BC00B9B9B900000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000E3E3E300E0E0
      E000DCDCDC00D9D9D900D6D6D600D2D2D200CECECE00CCCCCC00C8C8C800C5C5
      C500C1C1C1000000000000000000000000000000000000000000E3E3E300E0E0
      E0007F7F7F007F7F7F00D6D6D600D2D2D200CECECE00CCCCCC00C8C8C800C5C5
      C500C1C1C1000000000000000000000000000000000000000000E3E3E300E0E0
      E000DCDCDC00D9D9D900D6D6D600D2D2D200CECECE00CCCCCC00C8C8C800C5C5
      C500C1C1C100000000000000000000000000000000000000000000000000FFFF
      FF00000000008080800000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000ECECEC008080
      80008080800080808000DEDEDE00DBDBDB00D7D7D700D4D4D400D0D0D000CDCD
      CD00CACACA000000000000000000000000000000000000000000ECECEC007F7F
      7F007F7F7F007F7F7F007F7F7F00DBDBDB00D7D7D700D4D4D400D0D0D000CDCD
      CD00CACACA000000000000000000000000000000000000000000ECECEC008080
      800080808000E2E2E2008080800080808000D7D7D700D4D4D400D0D0D000CDCD
      CD00CACACA00000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000F4F4F4008080
      8000C8D0D40080808000E6E6E600E3E3E300DFDFDF0000000000000000000000
      0000000000000000000000000000000000000000000000000000F4F4F4007F7F
      7F00EDEDED007F7F7F007F7F7F00E3E3E300DFDFDF0000000000000000000000
      0000000000000000000000000000000000000000000000000000F4F4F400F0F0
      F000EDEDED00EAEAEA00E6E6E600E3E3E300DFDFDF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000008080800000000000808080000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FCFCFC008080
      80008080800080808000EFEFEF00EBEBEB00E8E8E80000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000FCFCFC00F9F9
      F900F6F6F6007F7F7F00EFEFEF00EBEBEB00E8E8E80000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000FCFCFC008080
      8000808080008080800080808000EBEBEB00E8E8E80000000000FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FEFEFE00FAFAFA00F7F7F700F4F4F400F0F0F00000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FEFEFE00FAFAFA00F7F7F700F4F4F400F0F0F00000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FEFEFE00FAFAFA00F7F7F700F4F4F400F0F0F00000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000808080000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF0000FFFF0000FF
      0000FFFF0000FFFFFF00000000000000000000000000808080000000FF008080
      800000000000000000000000000000000000808080000000FF00808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000808080000000FF0000000000808080000000FF00808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000808080000000FF000000FF000000FF000000FF000000FF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF0000FF
      FF0000FF0000FFFF0000000000000000000000000000808080000000FF000000
      FF0080808000000000000000000000000000808080000000FF000000FF008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080000000FF000000FF0000000000808080000000FF000000FF008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      FF0000FFFF0000FF0000000000000000000000000000808080000000FF000000
      FF000000FF00808080000000000000000000808080000000FF000000FF000000
      FF00808080000000000000000000000000000000000000000000000000008080
      80000000FF000000FF000000FF0000000000808080000000FF000000FF000000
      FF00808080000000000000000000000000000000000000000000000000008080
      80000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000FF0000FFFF00000000000000000000000000808080000000FF000000
      FF000000FF000000FF008080800000000000808080000000FF000000FF000000
      FF000000FF008080800000000000000000000000000000000000808080000000
      FF000000FF000000FF000000FF0000000000808080000000FF000000FF000000
      FF000000FF008080800000000000000000000000000000000000808080000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000FF00000000000000000000000000808080000000FF000000
      FF000000FF000000FF000000FF0000000000808080000000FF000000FF000000
      FF000000FF000000FF00808080000000000000000000808080000000FF000000
      FF000000FF000000FF000000FF0000000000808080000000FF000000FF000000
      FF000000FF000000FF0080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000808080000000FF000000
      FF000000FF000000FF000000FF000000FF00808080000000FF000000FF000000
      FF000000FF000000FF000000FF0000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF0000000000808080000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      800080808000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000808080000000FF000000
      FF000000FF000000FF000000FF0000000000808080000000FF000000FF000000
      FF000000FF000000FF00000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF0000000000808080000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000808080000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000808080000000FF000000
      FF000000FF000000FF000000000000000000808080000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF0000000000808080000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000008080
      80000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000808080000000FF000000
      FF000000FF00000000000000000000000000808080000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF0000000000808080000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000808080000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000808080000000FF000000
      FF0000000000000000000000000000000000808080000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF0000000000808080000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000808080000000FF000000FF000000FF000000FF000000FF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000FF000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF0000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000808080000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000FF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      8000808080008080800080808000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080008000B4B4B40080008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000808080009F9F9F009C9C9C009898
      980095959500919191000000000000000000C8D0D40000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080008000A0A0A000FFFFFF00FFFFFF0000000000800080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004000400040004000400040004000400040004000400040004000
      40000000000000000000000000000000000080808000A8A8A800A6A6A600FFFF
      FF00FFFFFF00FFFFFF000080800000808000000000000000000000FFFF000080
      8000000000000080800000FFFF00000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      8000A0A0A000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000008000
      8000000000000000000000000000000000000000000000000000000000000000
      0000FFF5F500FFE8E800FFDDDD00FFD1D100FFC5C500FFB9B900FFADAD004000
      40000000000000000000000000000000000080808000B1B1B100AEAEAE008080
      800000000000C8D0D4000000000000FFFF000080800000000000FFFFFF000080
      80000080800000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080008000A0A0A000FFFF
      FF00FFFFFF00FFFFFF0000000000808080000000000000000000000000000000
      0000800080000000000000000000000000000000000000000000000000000000
      0000FFEFEF00FFE2E200FFD7D700FFCBCB00FFBFBF00FFB3B300FFA8A8004000
      40000000000000000000000000000000000080808000BBBBBB00B7B7B7008080
      80000000000000000000008080000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000808000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000008080800000000000800080008000800000000000000000000000
      0000000000008000800000000000000000000000000000000000000000000000
      0000FFE9E900FFDDDD00FFD1D100FFC5C500FFB9B900FFAEAE00FFA2A2004000
      40000000000000000000000000000000000080808000C4C4C400C1C1C1008080
      800000000000000000000080800000FFFF00FFFFFF0000000000000000000000
      0000FFFFFF0000FFFF0000808000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000008080
      8000000000008000800080008000800080008000800080008000000000000000
      0000000000000000000080008000000000000000000000000000000000000000
      0000FFE3E300FFD7D700FFCBCB00FFC0C000FFB3B300FFA8A800FF9C9C004000
      40000000000000000000000000000000000080808000CDCDCD00CACACA008080
      8000808080000080800000000000FFFFFF000000000080808000FFFFFF000000
      0000000000000080800000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000008000
      8000800080008000800000FFFF00800080008000800080008000800080008000
      8000000000000000000000000000000000000000000000000000000000000000
      0000FFDEDE00FFD1D100FFC6C600FFBABA00FFAEAE00FFA2A200FF9696004000
      40000000000000000000000000000000000080808000D7D7D700D3D3D300FFFF
      FF00FFFFFF00FFFFFF00000000000080800000FFFF0080808000FFFFFF000000
      00000080800000FFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000008000800080008000800080008000
      8000800080008000800080008000008080008000800080008000800080008000
      8000000000000000000000000000000000000000000000000000000000000000
      0000FFD8D800FFCCCC00FFC0C000FFB4B400FFA8A800FF9C9C00FF9191004000
      40000000000000000000000000000000000080808000E0E0E000DCDCDC008080
      800000000000C8D0D4000080800000FFFF000000000080808000FFFFFF000000
      0000000000000080800000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000080008000800080008000
      800080008000800080008000800000FFFF0000FFFF0000FFFF00800080008000
      8000800080000000000000000000000000000000000000000000000000000000
      0000FFD2D200FFC6C600FFBABA00FFAFAF00FFA2A200FF979700FF8B8B000000
      00000000000000000000000000000000000080808000E8E8E800E5E5E5008080
      800000000000FFFFFF000080800000808000D1D1D1008080800080808000C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000800080008000
      800080008000800080008000800000808000800080000080800000FFFF008000
      8000800080008000800000000000000000000000000000000000000000000000
      0000FFCDCD00FFC0C000FFB5B500FFA9A900FF9D9D00FF919100FF8585000000
      00000000000000000000000000000000000080808000F2F2F200EFEFEF008080
      80000000000000000000C8D0D400FFFFFF00DADADA00D7D7D700D3D3D300D0D0
      D000000000000000000000000000000000000000000000000000000000000000
      000000FFFF00000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000008000
      800080008000800080008000800000FFFF00008080000080800000FFFF008000
      8000800080008000800080008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FBFBFB00F8F8F8008080
      8000808080008080800080808000FFFFFF00E3E3E300E0E0E000DDDDDD00D9D9
      D900000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000800080008000800080008000800000FFFF0000FFFF00800080008000
      8000800080008000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FFFFFF00FFFFFF00FDFD
      FD00FAFAFA00F6F6F600F3F3F300EFEFEF00ECECEC00E8E8E800E6E6E600E2E2
      E200000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000800080008000800080008000800080008000800080008000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080008000800080008000800080008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000DDDD
      DD00DBDBDB00D7D7D700D5D5D500D2D2D20080000000CCCCCC00CACACA00C7C7
      C700C5C5C500C2C2C20080000000000000000000000000000000000000000000
      00000000000080000000DCDCDC00D6D6D600CFCFCF00C9C9C900C3C3C300BCBC
      BC00B6B6B600B0B0B00080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000E1E1
      E100DEDEDE00DCDCDC00D9D9D900D6D6D60080000000D1D1D100CECECE00CBCB
      CB00C9C9C900C6C6C60080000000000000000000000000000000000000000000
      00000000000080000000DCDCDC00D6D6D600D0D0D000CACACA00C3C3C300BDBD
      BD00B7B7B700B0B0B00080000000000000000000000000000000000000000000
      00000000000000000000FF9C9C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000E5E5
      E500E2E2E200E0E0E000DDDDDD00DBDBDB0080000000D5D5D500D2D2D200D0D0
      D000CCCCCC00CACACA0080000000000000000000000000000000000000000000
      00000000000080000000DCDCDC00D6D6D600D1D1D100CACACA00C4C4C400BEBE
      BE00B7B7B700B1B1B10080000000000000000000000000000000000000000000
      00000000000000000000FF9C9C00FF94A5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000E9E9
      E900E7E7E700E4E4E400E1E1E100DEDEDE0080000000D9D9D900D6D6D600D3D3
      D300D1D1D100CECECE0080000000000000000000000000000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      00000000000000000000FF9C9C00FFADB500FFC6CE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000EDED
      ED00EBEBEB00E8E8E800E5E5E500E2E2E20080000000DDDDDD00DBDBDB00D7D7
      D700D5D5D500D2D2D2008000000000000000000000000000000080000000F1F1
      F100EAEAEA008000000080000000800000008000000080000000800000008000
      000080000000FFFFFF0080000000000000000000000000000000000000000000
      00000000000000000000FF9C9C00FFBDC600FFD6DE00FFEFF700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000F2F2
      F200EFEFEF00ECECEC00E9E9E900E7E7E70080000000E1E1E100DEDEDE00DCDC
      DC00D9D9D900D6D6D6008000000000000000000000000000000080000000F1F1
      F100EBEBEB008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      00000000000000000000FF9C9C00FFBDC600FFD6DE00FFEFF700FFE7E7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000F6F6
      F600F2F2F200F0F0F000EDEDED00EBEBEB0080000000E5E5E500E2E2E200E0E0
      E000DDDDDD00DBDBDB008000000000000000000000000000000080000000F2F2
      F200ECECEC00E6E6E600DFDFDF00D9D9D900D3D3D300CCCCCC00C6C6C6008000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF9C9C00FFADB500FFC6CE00FFD6D600FFCED600FFBD
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000F9F9
      F900F7F7F700F4F4F400F2F2F200EFEFEF0080000000E9E9E900E7E7E700E4E4
      E400E1E1E100DEDEDE0080000000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF9C9C00FF94A500FFADB500FFB5BD00FFB5BD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000FDFD
      FD00FBFBFB00F8F8F800F6F6F600F2F2F20080000000EDEDED00EBEBEB00E8E8
      E800E5E5E500E2E2E200800000000000000080000000FFFFFF00800000008000
      0000800000008000000080000000800000008000000080000000FFFFFF008000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF9C9C00FF7B8C00FF8C9C00FF949C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      00008000000080000000800000000000000080000000FFFFFF00800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF9C9C00FF637300FF6B840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000FFFFFF008000000080000000800000008000
      000080000000FFFFFF00800000000000000080000000FFFFFF00FAFAFA00F4F4
      F400EEEEEE00E7E7E700E1E1E100DCDCDC00D5D5D50080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF9C9C00FF425A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF9C9C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      000080000000800000008000000080000000FFFFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000C0C0C0008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000C0C0
      C000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C000000000000000000000000000000000000000000080000000DDDD
      DD00DBDBDB00D7D7D700D5D5D500D2D2D200D0D0D000CCCCCC00CACACA00C7C7
      C700C5C5C500C2C2C20080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000C0C0C0008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C0000000000000000000000000000000000080000000E1E1
      E100DEDEDE00DCDCDC00D9D9D900D6D6D600D3D3D300D1D1D100CECECE00CBCB
      CB00C9C9C900C6C6C60080000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000C0C0C000800000008000
      000080000000000000000000000000000000000000000000000080808000C0C0
      C000FFFFFF008080800000000000800000000000000000000000000000000000
      00000000800000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00000FFFF0000FFFF0000FFFF00C0C0C000C0C0
      C00000000000000000000000000000000000000000000000000080000000E5E5
      E500E2E2E200E0E0E000DDDDDD00DBDBDB00D7D7D700D5D5D500D2D2D200D0D0
      D000CCCCCC00CACACA0080000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000FFFFFF008080800080000000800000008000
      0000000000000000000000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000FFFFFF0080808000000000000000000000000000000000000000
      80000000800000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000808080008080800080808000C0C0C000C0C0
      C00000000000C0C0C00000000000000000000000000000000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000800000008000000000000000000000000000000080808000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF0080808000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000FFFFFF00000000000000000000000000000080000000
      8000000080000000800000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000000000000000000000000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000FFFFFF0080000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      0000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      80000000800000000000000000000000800000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C00000000000C0C0C000000000000000000000000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      00008000000080000000800000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00C0C0C000C0C0C00080808000000000000000000000000000000000000000
      0000000080000000000000000000000080000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000C0C0C0000000000000000000000000000000000080000000F6F6
      F600F2F2F200F0F0F000EDEDED00EBEBEB00E8E8E800E5E5E500E2E2E200E0E0
      E000DDDDDD00DBDBDB00800000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      000000000000000000000000000000000000000000000000000080808000C0C0
      C000C0C0C0008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000008000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C00000000000000000000000000080000000F9F9
      F900F7F7F700F4F4F400F2F2F200EFEFEF00ECECEC00E9E9E900E7E7E700E4E4
      E400E1E1E100DEDEDE00800000000000000000000000C0C0C000FFFFFF00FFFF
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000000000000000000080000000FDFD
      FD00FBFBFB00F8F8F800F6F6F600F2F2F200F0F0F000EDEDED00EBEBEB00E8E8
      E800E5E5E500E2E2E200800000000000000000000000C0C0C000FFFFFF00FFFF
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000FFFFFF00FFFF
      FF00FFFF0000FFFF0000C0C0C000C0C0C000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000080000000800000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000FFFFFF008000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      8000000080000000800000008000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BABDFB00C4C6
      FC00000000000000000000000000000000000000000000000000C6C6C600C6C6
      C60000000000B5B8FB00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B4B7FB00BDC0
      FB00000000000000000000000000000000000000000000000000C6C6C600C6C6
      C60000000000AFB2FA00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000ACB0FA00B4B7
      FB00000000000000000000000000000000000000000000000000C6C6C600C6C6
      C60000000000A8ACFA00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000080808000C0C0C000C0C0C0008080
      80000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000A4A8FA00ABAF
      FA00000000000000000000000000000000000000000000000000000000000000
      000000000000A0A4F900000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000080808000C0C0C000C0C0C000FFFF00008080
      80008080800000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009A9FF900A2A6
      FA00A7ABFA00ABAFFA00AEB1FA00AFB2FA00AFB2FA00ADB0FA00A9ADFA00A5A9
      FA009FA3F900979CF900000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000C0C0C000C0C0C000C0C0C000C0C0C0008080
      8000C0C0C00000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      00008000000000000000000000000000000000000000000000009197F900979C
      F900000000000000000000000000000000000000000000000000000000000000
      00009499F9008E94F800000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000C0C0C000FFFF0000C0C0C000C0C0C0008080
      8000C0C0C00000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000878DF8000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C60000000000848AF800000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000080808000FFFF0000FFFF0000C0C0C0008080
      80008080800000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000C0C0C00000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      00008000000080000000000000000000000000000000000000007D83F7000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000007A81F700000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000080808000C0C0C000C0C0C0008080
      80000000000000000000000000000000000000000000FFFFFF0000000000C0C0
      C00000000000FFFFFF0000000000C0C0C00000000000C0C0C000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000000000000000000000000000737AF7000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000007077F700000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C00000000000C0C0C00000000000C0C0C000C0C0
      C000C0C0C0000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      00000000000080000000800000008000000000000000000000006970F6000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C60000000000666DF600000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000C0C0C00000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00080000000800000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      00000000000080000000800000008000000000000000000000005E66F6000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C6000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C00000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00080000000800000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      0000000000008000000080000000800000000000000000000000535BF5000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C60000000000C6C6C600000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E7E7
      E700E7E7E700DEDEDE00D6D6D600D6D6D600CECECE00C6C6C600BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFEF
      EF00E7E7E700DEDEDE00DEDEDE00D6D6D600CECECE00C6C6C600C6C6C600BDBD
      BD0000000000000000000000000000000000000000006A5C950000000000C8E0
      F500C8E0F500C8E0F500C8E0F500C8E0F500C8E0F500C8E0F500C8E0F500C8E0
      F500000000000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFEF
      EF00E7E7E700E7E7E700DEDEDE00D6D6D600CECECE00CECECE00C6C6C600BDBD
      BD0000000000000000000000000000000000000000004494DC004695DD000000
      000092C1EB0092C1EB0092C1EB0092C1EB0092C1EB0092C1EB0092C1EB0092C1
      EB0092C1EB000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFEF
      EF00E7E7E700E7E7E700DEDEDE00D6D6D600D6D6D600CECECE00C6C6C600BDBD
      BD00000000000000000000000000000000000000000063A6E20065A7E20066A7
      E200000000005BA1E1005BA1E1005BA1E1005BA1E1005BA1E1005BA1E1005BA1
      E1005BA1E1005BA1E10000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7F7
      F700EFEFEF00E7E7E700DEDEDE00DEDEDE00D6D6D600CECECE00C6C6C600C6C6
      C60000000000000000000000000000000000000000007FB6E70081B7E80082B8
      E80084B9E8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7F7
      F700EFEFEF00E7E7E700E7E7E700DEDEDE00D6D6D600CECECE00CECECE00C6C6
      C60000000000000000000000000000000000000000009CC6ED009EC7ED009FC8
      ED00A1C9EE00A3CAEE00A5CBEE00A6CCEE00A7CDEF00A9CEEF00000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7F7
      F700EFEFEF00E7E7E700E7E7E700DEDEDE00D6D6D600D6D6D600CECECE00C6C6
      C6000000000000000000000000000000000000000000B9D7F200BBD8F200BCD9
      F300BEDAF300BFDAF300C1DBF300C2DCF400C4DDF400C6DEF400000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7F7
      F700F7F7F700EFEFEF00E7E7E700DEDEDE00DEDEDE00D6D6D600CECECE00C6C6
      C6000000000000000000000000000000000000000000D7E8F800D9E9F800DAEA
      F800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00F7F7F700EFEFEF00E7E7E700E7E7E700DEDEDE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00F7F7F700EFEFEF00EFEFEF00E7E7E700DEDEDE0000000000C8D0D4000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00F7F7F700F7F7F700EFEFEF00E7E7E700DEDEDE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BD524A00BD29210000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BD31
      29000000000000000000BD1808000000000000000000BD524A00BD2921000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BD39
      39000000000000000000BD18100000000000BD4A4A000000000000000000BD31
      2900000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084000000E7E7E700E7E7E700DEDEDE00D6D6
      D600CECECE00C6C6C600BDBDBD00840000000000000000000000000000000000
      0000000000000000000084000000DEDEDE00DEDEDE00DEDEDE00DEDEDE00D6D6
      D600D6D6D600D6D6D600D6D6D600840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BD4A
      42000000000000000000BD21180000000000BD524A000000000000000000BD39
      3900000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084000000EFEFEF0000000000000000000000
      00000000000000000000BDBDBD008400000000000000FF94A500FF8C9C00FF8C
      9400FF849400FF7B8C0084000000DEDEDE008400000084000000840000008400
      00008400000084000000D6D6D600840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BD5A5A00BD423900BD29210000000000BD5252000000000000000000BD4A
      4200000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084000000EFEFEF00E7E7E700DEDEDE00D6D6
      D600CECECE00C6C6C600BDBDBD008400000000000000FF9CA500FF94A500FF8C
      9C00FF849400FF7B8C0084000000DEDEDE00DEDEDE00DEDEDE00DEDEDE00D6D6
      D600D6D6D600D6D6D600D6D6D600840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      00000000000000000000BD29210000000000BD5A5A00BD424200BD2921000000
      0000000000000000000000000000000000000000000000000000E7E7E700DEDE
      DE00D6D6D600C6C6C600BDBDBD0084000000EFEFEF0000000000000000000000
      00000000000000000000C6C6C6008400000000000000FF9CAD00FF94A500FF8C
      9C00FF8C9400FF84940084000000DEDEDE00840000008400000084000000DEDE
      DE00840000008400000084000000840000000000000000000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      00000000000000000000BD31290052424200BD63630000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFEF000000
      000000000000000000000000000084000000F7F7F700EFEFEF00E7E7E700DEDE
      DE00D6D6D600CECECE00C6C6C6008400000000000000FF9CAD00FF9CA500FF94
      9C00FF8C9C00FF84940084000000E7E7E700DEDEDE00DEDEDE00DEDEDE00DEDE
      DE0084000000D6D6D60084000000000000000000000000000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000393131000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFEF00E7E7
      E700D6D6D600CECECE00C6C6C60084000000F7F7F7000000000000000000DEDE
      DE008400000084000000840000008400000000000000FFA5AD00FF9CAD00FF94
      A500FF8C9C00FF84940084000000E7E7E700DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00840000008400000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000042393900393131003929290000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFEF000000
      000000000000000000000000000084000000FFFFFF00F7F7F700EFEFEF00E7E7
      E70084000000DEDEDE00840000000000000000000000FFA5B500FF9CAD00FF94
      A500FF949C00FF8C940084000000840000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000800000008000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000042393900000000002118180000000000000000000000
      0000000000000000000000000000000000000000000000000000F7F7F700E7E7
      E700DEDEDE00D6D6D600C6C6C60084000000FFFFFF00F7F7F700EFEFEF00E7E7
      E7008400000084000000000000000000000000000000FFADB500FFA5AD00FF9C
      A500FF94A500FF8C9C00FF849400FF7B8C00FF738400FF6B8400FF6B7B00FF63
      7300FF5A6B000000000000000000000000000000000000000000800000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000004A4242005A4A4A00000000000808080008000000000000000000
      0000000000000000000000000000000000000000000000000000F7F7F7000000
      000000000000D6D6D60000000000840000008400000084000000840000008400
      00008400000000000000000000000000000000000000FFADB500FFA5B5000008
      180000081800000818000008180000101800001018000010180000101800FF63
      7300FF5A73000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004A42420000000000000000000000000021181800000000000000
      0000000000000000000000000000000000000000000000000000F7F7F700EFEF
      EF00E7E7E700D6D6D60000000000C8D0D4000000000000000000000000000000
      00000000000000000000000000000000000000000000FFADBD00FFA5B5000008
      1800D6CEBD00D6CEBD00D6CEBD00D6CEBD00D6CEBD00D6CEBD0000101800FF63
      7B00FF5A73000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004A42420000000000000000000000000021181800000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00EFEF
      EF00E7E7E700DEDEDE0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFB5BD00FFADB500FFA5
      AD0000000000D6CEBD000000000000000000D6CEBD0000000000FF738400FF6B
      7B00FF6373000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004A42420000000000000000000000000021181800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D6CEBD00D6CEBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000000200000100010000000000001000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFF000000000000C003000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000818100000000000081810000000000008181000000000000
      C003000000000000FFFF000000000000BFFFFFFFFF87FFFF0FFFFFFF8001FFFF
      03FF80010000F3CF80FF80010000E187C07F80010000C003C03F80010000C003
      C01F80010000E007E00F80010000F00FE00780010000F00FF00380010000E007
      F80180010000C003FC0080030000C003FE00C0038000E187FF00DF078001F3CF
      FF81E0FFC0FFFFFFFFC3FFFFFFFFFFFFFFFFFFFF8001FFFFFFFFFFFF80010000
      FE00FFFF80010000FE00000080010000FE000000800100008000000080010000
      8000000080010000800000000000000080000000000000008001000000000000
      800300008001000080078001C0030000807F8001C007000080EFC003C00F0000
      819FFFFFC01F0000FFFFFFFFC43F0000FFFFFFFFFFFF8003FFFFFF7FC0018003
      FFFFFE3F80018003FFFFFC1F80018003FF7FF80F80018003FE3FF00780018003
      FC1FF00780018003F80FFFFF80018003F007E00380018003E003E00380018003
      E003E00380018003FFFFE00380018007FFFFFFFF8001800FFFFFFFFF8001801F
      FFFFFFFF8003803FFFFFFFFFFFFFFFFFFFFFFFCFFFFFFFFFE001FF8FE1FFE007
      C001C301E13FC003C001C200E11FC003C001C300E10FC7E3C001C788E107C7E3
      C001C7C8E10301E3C001C7F8E10101E3C001C7F8E10383C1C001C7F8E107C780
      C001C7F8E10FC780C001C000E11FC7E3C001C000E13FC7E3C001E001E1FFC003
      C003FFFFFFFFC003FFFFFFFFFFFFE007FFFFFFFFFFFFFFFFFFFFF7FFFFFFFFFF
      FFFFE3EFFFFF8003FC3FE1C7FFFF8003F81FE083FE7F8003F00FF007FE7F8003
      E007F80FFC3F8003E007FC1FFC3F8603E007FC1FF81F8603E007F80FF81F8603
      F00FF007F00FFE03F81FF083F00FFE1FFC3FF3C3FFFFFE1FFFFFFFE3FFFFFE1F
      FFFFFFFFFFFFFE1FFFFFFFFFFFFFFFFFFFFF800380038003C001800380038003
      C001800380038003CFF9800380038003CA09800380038003CFF9800380038003
      CA09800380038003CFF9800380038003CA09800380038003CFF9800380038003
      CA81800380038003CF83800780078007CA87800F800F800FCF8F801F801F801F
      C01F803F803F803FC03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7FC001
      9F3FFD3FFC3FC0018F1FF91FF81FC001870FF10FF00FC0018307E107E007C001
      8103C103C003C00181018101FFFFC00180018101C007C0018103C103C003C001
      8307E107E007C001870FF10FF00FC0038F1FF91FF81FC007DFBFFDBFFC3FC00F
      FFFFFFFFFE7FC01FFFFFFFFFFFFFC03FFFFF8007FFFFFF7FFFFF0007FE3FFC3F
      FFFF0001FC1FF05FE00F0000FC1FC06FE00F0001FE7F0277E00F0000FC3F083B
      E00F0000FC3F201DE00F0000FC3F000EE00F0001FC1F0007E00F0001F20F8003
      E00F0007E107C001E00F0007E187E000E00F0007E007F001FFFF0007F00FF807
      FFFF0007F81FFC1FFFFFFFFFFFFFFE7FFFFFFFFFFFFFFFFFC001F801FFFFFFFF
      C001F801F9FFFFFFC001F801F8FFFFFFC001F801F87FF18FC001C001F83FF18F
      C001C001F81FF18FC001C001F80FF18FC001C00FF807F18FC001000FF80FF18F
      C001000FF81FF18FC001000FF83FF18FC001003FF87FFFFFC001003FF8FFFFFF
      FFFF003FF9FFFFFFFFFF003FFFFFFFFFFFF3FFFFFFFFFFFFFFE1FF3FC007C001
      FFC1FE3F8003C001FF83C07F0001C001F00780F70001C001C00F00E70001C001
      801F00C10000C001801F00E60000C001000F00F68000C001000F81FEC000C001
      000FC3BFE001C001000FFFB7E007C001801FFFB3F007C001801FFFC1F003C001
      C03FFFF3F803FFFFF0FFFFF7FFFFFFFFFFFFFFFFFFFFFFFFC001000C000FF9FF
      80010008000FF9FF80010001000FF3C780010003000F73C780010003000F27FF
      80010003000F07C780010003000F00C780010003000F01E380010007000403F1
      8001000F000006388001000F00000E388001000FF8001E388001001FFC003F01
      8001003FFE047F83FFFF007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFEFFDC007001FFFFFC7FFC007000FFFFFC3FBC0070007EFFFE3F7C0070003
      EF83F1E7C0070001DFC3F8CFC0070001DFE3FC1FC007001FDFD3FE3FC007001F
      EF3BFC1FC007001FF0FFF8CFC0078FF1FFFFE1E7C00FFFF9FFFFC3F3C01FFF75
      FFFFC7FDC03FFF8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3FFFFFFFFFFFFFF
      ED9FFE00FC00FFFFED6FFE008000FFFFED6FFE000000FFFFF16F80000000FFF7
      FD1F80000000C1F7FC7F80000001C3FBFEFF80000003C7FBFC7F80010003CBFB
      FD7F80030003DCF7F93F80070003FF0FFBBF807F0003FFFFFBBF80FF0003FFFF
      FBBF81FF8007FFFFFFFFFFFFF87FFFFF00000000000000000000000000000000
      000000000000}
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Vortex Tracker (.vt2)|*.vt2|Pro Tracker 3 (*.pt3)|*.pt3'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofShareAware, ofEnableSizing]
    OnTypeChange = SaveDialog1TypeChange
    Left = 136
    Top = 200
  end
  object PopupMenu1: TPopupMenu
    OwnerDraw = True
    OnPopup = PopupMenu1Popup
    Left = 168
    Top = 200
    object Color1: TMenuItem
      Caption = 'Set Color'
      object PositionColorL5: TMenuItem
        Caption = 'Light5'
        OnClick = PositionColorL5Click
        OnDrawItem = PositionColorL5DrawItem
      end
      object PositionColorL4: TMenuItem
        Caption = 'Light4'
        OnClick = PositionColorL4Click
        OnDrawItem = PositionColorL4DrawItem
      end
      object PositionColorL3: TMenuItem
        Caption = 'Light3'
        OnClick = PositionColorL3Click
        OnDrawItem = PositionColorL3DrawItem
      end
      object PositionColorL2: TMenuItem
        Caption = 'Light2'
        OnClick = PositionColorL2Click
        OnDrawItem = PositionColorL2DrawItem
      end
      object PositionColorL1: TMenuItem
        Caption = 'Light1'
        OnClick = PositionColorL1Click
        OnDrawItem = PositionColorL1DrawItem
      end
      object PositionColorDefault: TMenuItem
        Caption = 'Default'
        OnClick = PositionColorDefaultClick
        OnDrawItem = PositionColorDefaultDrawItem
      end
      object PositionColorRed: TMenuItem
        Caption = 'Red'
        OnClick = PositionColorRedClick
        OnDrawItem = PositionColorRedDrawItem
      end
      object PositionColorGreen: TMenuItem
        Caption = 'Green'
        OnClick = PositionColorGreenClick
        OnDrawItem = PositionColorGreenDrawItem
      end
      object PositionColorBlue: TMenuItem
        Caption = 'Blue'
        OnClick = PositionColorBlueClick
        OnDrawItem = PositionColorBlueDrawItem
      end
      object PositionColorMaroon: TMenuItem
        Caption = 'Maroon'
        OnClick = PositionColorMaroonClick
        OnDrawItem = PositionColorMaroonDrawItem
      end
      object PositionColorPurple: TMenuItem
        Caption = 'Purple'
        OnClick = PositionColorPurpleClick
        OnDrawItem = PositionColorPurpleDrawItem
      end
      object PositionColorGray: TMenuItem
        Caption = 'Gray'
        OnClick = PositionColorGrayClick
        OnDrawItem = PositionColorGrayDrawItem
      end
      object PositionColorTeal: TMenuItem
        Caption = 'Teal'
        OnClick = PositionColorTealClick
        OnDrawItem = PositionColorTealDrawItem
      end
    end
    object ResetColors: TMenuItem
      Caption = 'Reset Colors'
      OnClick = ResetColorsClick
    end
    object sep2: TMenuItem
      Caption = '-'
    end
    object Setloopposition1: TMenuItem
      Action = SetLoopPos
      OnMeasureItem = Setloopposition1MeasureItem
    end
    object sep1: TMenuItem
      Caption = '-'
    end
    object Insertposition1: TMenuItem
      Action = InsertPosition
    end
    object Deleteposition1: TMenuItem
      Action = DeletePosition
    end
    object DuplicatePosition1: TMenuItem
      Caption = 'Duplicate position'
      OnClick = DuplicatePosition1Click
    end
    object ClonePosition1: TMenuItem
      Caption = 'Clone Position'
      OnClick = ClonePosition1Click
    end
    object sep3: TMenuItem
      Caption = '-'
    end
    object Changepatternslength1: TMenuItem
      Caption = 'Change patterns length...'
      OnClick = Changepatternslength1Click
    end
    object sep4: TMenuItem
      Caption = '-'
    end
    object RenumberPatterns: TMenuItem
      Caption = 'Renumber patterns'
      OnClick = RenumberPatternsClick
    end
    object AutoNumeratePatterns: TMenuItem
      Caption = 'Fill empty positions'
      OnClick = AutoNumeratePatternsClick
    end
  end
  object SaveDialogSNDH: TSaveDialog
    Filter = 'Atari ST'#39's SNDH files (SND, SNDH)|*.snd;*.sndh|Any file|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofShareAware, ofEnableSizing]
    Left = 200
    Top = 200
  end
  object SaveDialogZXAY: TSaveDialog
    Filter = 
      'Hobeta with player ($c)|*.$c|Hobeta without player ($m)|*.$m|.AY' +
      '-files (AY)|*.ay|SCL-files (SCL)|*.scl|ZX tape files (TAP)|*.tap' +
      '|Any file|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofShareAware, ofEnableSizing]
    OnTypeChange = SaveDialogZXAYTypeChange
    Left = 232
    Top = 200
  end
  object PopupMenu2: TPopupMenu
    Left = 264
    Top = 200
    object Undo2: TMenuItem
      Action = Undo
    end
    object Redo2: TMenuItem
      Action = Redo
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Copy1: TMenuItem
      Action = EditCopy1
    end
    object Cut1: TMenuItem
      Action = EditCut1
    end
    object Paste1: TMenuItem
      Action = EditPaste1
    end
    object Merge1: TMenuItem
      Caption = 'Merge'
      Hint = 'Merge|Merges Clipboard contents'
      ShortCut = 49238
      OnClick = Merge1Click
    end
    object N20: TMenuItem
      Caption = '-'
    end
    object CopyTo: TMenuItem
      Caption = 'Copy To...'
      object CopyOpenMPT: TMenuItem
        Action = CopyToModplugAct
      end
      object CopyRenoise: TMenuItem
        Action = CopyToRenoiseAct
      end
      object CopyFami: TMenuItem
        Action = CopyToFamiAct
      end
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object TransposeUp1a: TMenuItem
      Action = TransposeUp1
      Hint = 
        '+1 semitone|Transpose selected notes and envelope periods 1 semi' +
        'tone up'
    end
    object TransposeDown1a: TMenuItem
      Action = TransposeDown1
      Hint = 
        '-1 semitone|Transpose selected notes and envelope periods 1 semi' +
        'tone down'
    end
    object TransposeUp3a: TMenuItem
      Action = TransposeUp3
      Caption = 'Transpose +3'
    end
    object TransposeDown3a: TMenuItem
      Action = TransposeDown3
      Caption = 'Transpose -3'
    end
    object TransposeUp5a: TMenuItem
      Action = TransposeUp5
      Caption = 'Transpose +5'
    end
    object TransposeDown5a: TMenuItem
      Action = TransposeDown5
      Caption = 'Transpose -5'
    end
    object TransposeUp12a: TMenuItem
      Action = TransposeUp12
      Hint = 
        '+12 semitones|Transpose selected notes and envelope periods 12 s' +
        'emitones up'
    end
    object TransposeDown12a: TMenuItem
      Action = TransposeDown12
      Hint = 
        '-12 semitones|Transpose selected notes and envelope periods 12 s' +
        'emitones down'
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object ExpandTwice1: TMenuItem
      Caption = 'Expand pattern'
      Hint = 
        'Expand pattern twice|Multiply pattern size x2 and insert empty l' +
        'ine after each original line'
      OnClick = ExpandTwice1Click
    end
    object Compresspattern1: TMenuItem
      Caption = 'Shrink pattern'
      Hint = 
        'Compress pattern twice|Remove each second line and divide patter' +
        'n size /2'
      OnClick = Compresspattern1Click
    end
    object Splitpattern1: TMenuItem
      Caption = 'Split pattern'
      OnClick = Splitpattern1Click
    end
    object PackPattern1: TMenuItem
      Action = PackPatternAct
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object SwapChannelsLeft: TMenuItem
      Action = SwapChannelsLeft1
    end
    object SwapChannelsRight: TMenuItem
      Action = SwapChannelsRight1
    end
  end
  object PopupMenu3: TPopupMenu
    Left = 296
    Top = 200
    object File2: TMenuItem
      Caption = 'File'
      Checked = True
      OnClick = PopupMenu3Click
    end
    object Play5: TMenuItem
      Tag = 1
      Caption = 'Play'
      Checked = True
      OnClick = PopupMenu3Click
    end
    object rack1: TMenuItem
      Tag = 2
      Caption = 'Track tools'
      Checked = True
      OnClick = PopupMenu3Click
    end
  end
  object midiin1: TMidiInput
    SysexBufferSize = 4096
    FilteredMessages = [msgActiveSensing, msgMidiTimeCode]
    OnMidiInput = midiin1MidiInput
    Left = 8
    Top = 240
  end
  object BackupTimer: TTimer
    OnTimer = SaveBackups
    Left = 40
    Top = 240
  end
  object SyncCheckTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = SyncCheckTimerTimer
    Left = 72
    Top = 240
  end
  object SyncFinishTimer: TTimer
    Enabled = False
    Interval = 800
    OnTimer = SyncFinishTimerTimer
    Left = 104
    Top = 240
  end
  object SyncCopyBuffers: TTimer
    OnTimer = SyncCopyBuffersTimer
    Left = 136
    Top = 240
  end
  object MIDITimer: TTimer
    OnTimer = MIDITimerTimer
    Left = 168
    Top = 240
  end
end
