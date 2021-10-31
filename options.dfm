object Form1: TForm1
  Left = 1043
  Top = 118
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Options'
  ClientHeight = 568
  ClientWidth = 545
  Color = clBtnFace
  Constraints.MaxHeight = 607
  Constraints.MaxWidth = 561
  Constraints.MinHeight = 598
  Constraints.MinWidth = 530
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object OpsPages: TPageControl
    Left = 0
    Top = 0
    Width = 545
    Height = 529
    ActivePage = CurWinds
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object CurWinds: TTabSheet
      Caption = 'Main'
      ImageIndex = 2
      object PatEditorOpts: TGroupBox
        Left = 8
        Top = 8
        Width = 521
        Height = 209
        Caption = ' Interface Options '
        TabOrder = 0
        object DecNumbersLines: TCheckBox
          Left = 12
          Top = 27
          Width = 295
          Height = 17
          Hint = 'Delete Position'
          Caption = 'Line numbers in pattern, sample, ornament in Decimal'
          TabOrder = 0
          OnClick = DecNumbersLinesClick
        end
        object DecNumbersNoise: TCheckBox
          Left = 12
          Top = 52
          Width = 287
          Height = 17
          Caption = 'Noise level in pattern and sample in Decimal'
          TabOrder = 1
          OnClick = DecNumbersNoiseClick
        end
        object chkHS: TCheckBox
          Left = 12
          Top = 78
          Width = 287
          Height = 17
          Hint = 'Delete Position'
          Caption = 'Highlight speed position for samples and ornaments'
          TabOrder = 2
          OnClick = chkHSClick
        end
        object DisablePatSeparators: TCheckBox
          Left = 12
          Top = 103
          Width = 273
          Height = 17
          Caption = 'Disable vertical pattern separators'
          TabOrder = 3
          OnClick = DisablePatSeparatorsClick
        end
        object DisableHintsOpt: TCheckBox
          Left = 12
          Top = 129
          Width = 279
          Height = 17
          Caption = 'Disable Hints in pattern, sample and ornament editor'
          TabOrder = 4
          OnClick = DisableHintsOptClick
        end
        object DisableCtrlClickOpt: TCheckBox
          Left = 12
          Top = 154
          Width = 279
          Height = 17
          Caption = 'Disable Ctrl+Click on sample/ornament'
          TabOrder = 5
          OnClick = DisableCtrlClickOptClick
        end
        object DisableInfoWinOpt: TCheckBox
          Left = 12
          Top = 180
          Width = 261
          Height = 17
          Caption = 'Don'#39't show Info Window when track is loaded'
          TabOrder = 6
          OnMouseUp = DisableInfoWinOptMouseUp
        end
      end
      object BackupOpts: TGroupBox
        Left = 277
        Top = 232
        Width = 252
        Height = 137
        Caption = ' Backup Options '
        TabOrder = 2
        object Label16: TLabel
          Left = 12
          Top = 66
          Width = 30
          Height = 13
          Caption = 'Every:'
        end
        object Label17: TLabel
          Left = 104
          Top = 66
          Width = 36
          Height = 13
          Caption = 'minutes'
        end
        object Label18: TLabel
          Left = 10
          Top = 103
          Width = 191
          Height = 13
          Caption = 'Backup filename: "filename ver 001.vt2"'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clTeal
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object AutoSaveBackups: TCheckBox
          Left = 12
          Top = 30
          Width = 145
          Height = 17
          Caption = 'Autosave Backups'
          TabOrder = 0
          OnMouseUp = AutoSaveBackupsMouseUp
        end
        object BackupsMinsVal: TEdit
          Left = 50
          Top = 63
          Width = 33
          Height = 21
          MaxLength = 3
          TabOrder = 1
          Text = '1'
          OnChange = BackupsMinsValChange
        end
        object BackupEveryMins: TUpDown
          Left = 83
          Top = 63
          Width = 14
          Height = 21
          Associate = BackupsMinsVal
          Min = 1
          Max = 30
          Position = 1
          TabOrder = 2
        end
      end
      object PriorGrp: TRadioGroup
        Left = 277
        Top = 384
        Width = 252
        Height = 105
        Caption = ' Application Priority '
        ItemIndex = 0
        Items.Strings = (
          'Normal'
          'High')
        TabOrder = 4
        OnClick = PriorGrpClick
      end
      object StartupBox: TGroupBox
        Left = 8
        Top = 232
        Width = 252
        Height = 137
        Caption = ' Startup '
        TabOrder = 1
        object start1: TLabel
          Left = 12
          Top = 30
          Width = 93
          Height = 13
          Caption = 'When Vortex starts:'
        end
        object TemplPathLab: TLabel
          Left = 12
          Top = 82
          Width = 91
          Height = 13
          Caption = 'Use template song:'
        end
        object StartsAction: TComboBox
          Left = 12
          Top = 47
          Width = 221
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = StartsActionChange
          Items.Strings = (
            'Open template'
            'Open blank song'
            'Do nothing')
        end
        object TemplateSong: TEdit
          Left = 12
          Top = 99
          Width = 192
          Height = 21
          TabOrder = 1
        end
        object BrowseTemplate: TButton
          Left = 206
          Top = 99
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 2
          OnClick = BrowseTemplateClick
        end
      end
      object FreqTableBox: TGroupBox
        Left = 8
        Top = 384
        Width = 252
        Height = 105
        Caption = ' Frequency Table '
        TabOrder = 3
        object Label15: TLabel
          Left = 12
          Top = 30
          Width = 120
          Height = 13
          Hint = 'Default Frequency Table for new tracks'
          Caption = 'Default Frequency Table:'
          ParentShowHint = False
          ShowHint = True
        end
        object TableName: TLabel
          Left = 11
          Top = 83
          Width = 114
          Height = 13
          Caption = 'ASM or PSC (1.75 MHz)'
        end
        object DefaultTable: TEdit
          Left = 12
          Top = 55
          Width = 31
          Height = 21
          Hint = 
            'Want to change track frequency table?'#13#10'Check the track options t' +
            'ab.'
          MaxLength = 1
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 0
          Text = '2'
          OnChange = DefaultTableChange
        end
        object UpDown2: TUpDown
          Left = 43
          Top = 55
          Width = 14
          Height = 21
          Hint = 
            'Want to change track frequency table?'#13#10'Check the track options t' +
            'ab.'
          Associate = DefaultTable
          Max = 4
          ParentShowHint = False
          Position = 2
          ShowHint = True
          TabOrder = 1
        end
      end
    end
    object ColorThemesTab: TTabSheet
      Caption = 'Appearance'
      ImageIndex = 5
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 257
        Height = 145
        Caption = ' Color Themes '
        TabOrder = 0
        object ColorThemesList: TListBox
          Left = 8
          Top = 24
          Width = 177
          Height = 112
          ItemHeight = 13
          TabOrder = 0
          OnClick = ColorThemesListClick
        end
        object BtnLoadTheme: TButton
          Left = 191
          Top = 24
          Width = 58
          Height = 21
          Caption = 'Load'
          TabOrder = 1
          OnClick = BtnLoadThemeClick
        end
        object BtnSaveTheme: TButton
          Left = 191
          Top = 47
          Width = 58
          Height = 21
          Caption = 'Save'
          TabOrder = 2
          OnClick = BtnSaveThemeClick
        end
        object BtnDelTheme: TButton
          Left = 191
          Top = 116
          Width = 58
          Height = 21
          Caption = 'Delete'
          TabOrder = 5
          OnClick = BtnDelThemeClick
        end
        object BtnCloneTheme: TButton
          Left = 191
          Top = 70
          Width = 58
          Height = 21
          Caption = 'Duplicate'
          TabOrder = 3
          OnClick = BtnCloneThemeClick
        end
        object BtnRenameTheme: TButton
          Left = 191
          Top = 93
          Width = 58
          Height = 21
          Caption = 'Rename'
          TabOrder = 4
          OnClick = BtnRenameThemeClick
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 160
        Width = 521
        Height = 337
        Caption = ' Color Theme Options  '
        TabOrder = 2
        object TableBottom: TShape
          Left = 8
          Top = 48
          Width = 505
          Height = 281
          Brush.Color = 16382455
          Pen.Color = 13290186
        end
        object Shape1: TShape
          Left = 8
          Top = 304
          Width = 505
          Height = 25
          Brush.Color = 15461355
          Pen.Color = 13290186
        end
        object BG10: TShape
          Left = 9
          Top = 272
          Width = 504
          Height = 25
          Brush.Color = 14737632
          Pen.Style = psClear
        end
        object BG1: TShape
          Left = 9
          Top = 56
          Width = 504
          Height = 25
          Brush.Color = 15461355
          Pen.Style = psClear
        end
        object TableHeader: TShape
          Left = 8
          Top = 24
          Width = 505
          Height = 25
          Brush.Color = 16382455
          Pen.Color = 13290186
        end
        object ColBackground: TShape
          Left = 154
          Top = 59
          Width = 25
          Height = 18
          Hint = 'Main Background'
          Brush.Color = 2894892
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColBackgroundMouseDown
        end
        object LDefinition: TLabel
          Left = 20
          Top = 30
          Width = 44
          Height = 13
          Caption = 'Definition'
          Color = 16382455
          ParentColor = False
        end
        object LCurrPat: TLabel
          Left = 154
          Top = 30
          Width = 70
          Height = 13
          Caption = 'Current pattern'
          Color = 16382455
          ParentColor = False
        end
        object LNextPrevPat: TLabel
          Left = 278
          Top = 30
          Width = 85
          Height = 13
          Caption = 'Next/Prev pattern'
          Color = 16382455
          ParentColor = False
        end
        object LBackgr: TLabel
          Left = 20
          Top = 61
          Width = 69
          Height = 13
          Caption = 'Background'
          Color = 15461355
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object BG2: TShape
          Left = 9
          Top = 80
          Width = 504
          Height = 25
          Brush.Color = 14737632
          Pen.Style = psClear
        end
        object LText: TLabel
          Left = 20
          Top = 85
          Width = 26
          Height = 13
          Caption = 'Text'
          Color = 14737632
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object BG3: TShape
          Left = 9
          Top = 104
          Width = 504
          Height = 25
          Brush.Color = 15461355
          Pen.Style = psClear
        end
        object ColText: TShape
          Left = 154
          Top = 83
          Width = 25
          Height = 18
          Hint = 'Text (Dots)'
          Brush.Color = 15658734
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColTextMouseDown
        end
        object BG4: TShape
          Left = 9
          Top = 128
          Width = 504
          Height = 25
          Brush.Color = 14737632
          Pen.Style = psClear
        end
        object BG5: TShape
          Left = 9
          Top = 152
          Width = 504
          Height = 25
          Brush.Color = 15461355
          Pen.Style = psClear
        end
        object BG6: TShape
          Left = 9
          Top = 176
          Width = 504
          Height = 25
          Brush.Color = 14737632
          Pen.Style = psClear
        end
        object LLineNumbs: TLabel
          Left = 20
          Top = 109
          Width = 76
          Height = 13
          Caption = 'Line numbers'
          Color = 15461355
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LEnvelope: TLabel
          Left = 20
          Top = 133
          Width = 54
          Height = 13
          Caption = 'Envelope'
          Color = 14737632
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LNoise: TLabel
          Left = 20
          Top = 157
          Width = 33
          Height = 13
          Caption = 'Noise'
          Color = 15461355
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LNote: TLabel
          Left = 20
          Top = 181
          Width = 28
          Height = 13
          Caption = 'Note'
          Color = 14737632
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object BG7: TShape
          Left = 9
          Top = 200
          Width = 504
          Height = 25
          Brush.Color = 15461355
          Pen.Style = psClear
        end
        object BG8: TShape
          Left = 9
          Top = 224
          Width = 504
          Height = 25
          Brush.Color = 14737632
          Pen.Style = psClear
        end
        object BG9: TShape
          Left = 9
          Top = 248
          Width = 504
          Height = 25
          Brush.Color = 15461355
          Pen.Style = psClear
        end
        object LNoteParams: TLabel
          Left = 20
          Top = 205
          Width = 72
          Height = 13
          Caption = 'Note params'
          Color = 15461355
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LNoteCommands: TLabel
          Left = 20
          Top = 229
          Width = 91
          Height = 13
          Caption = 'Note commands'
          Color = 14737632
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object ColSelLineBackground: TShape
          Left = 186
          Top = 59
          Width = 25
          Height = 18
          Hint = 'Selected Line Background'
          Brush.Color = 11053224
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSelLineBackgroundMouseDown
        end
        object ColHighlBackground: TShape
          Left = 218
          Top = 59
          Width = 25
          Height = 18
          Hint = 'Highlighted Line Background'
          Brush.Color = 4868682
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColHighlBackgroundMouseDown
        end
        object ColHighlText: TShape
          Left = 218
          Top = 83
          Width = 25
          Height = 18
          Hint = 'Highlighted Text (Dots)'
          Brush.Color = 15263976
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColHighlTextMouseDown
        end
        object ColLineNum: TShape
          Left = 154
          Top = 107
          Width = 25
          Height = 18
          Hint = 'Line Numbers'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColLineNumMouseDown
        end
        object ColEnvelope: TShape
          Left = 154
          Top = 131
          Width = 25
          Height = 18
          Hint = 'Envelope'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColEnvelopeMouseDown
        end
        object ColNoise: TShape
          Left = 154
          Top = 155
          Width = 25
          Height = 18
          Hint = 'Noise'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColNoiseMouseDown
        end
        object ColNote: TShape
          Left = 154
          Top = 179
          Width = 25
          Height = 18
          Hint = 'Note'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColNoteMouseDown
        end
        object ColNoteParams: TShape
          Left = 154
          Top = 203
          Width = 25
          Height = 18
          Hint = 'Note Params (Sample, Envelope, Ornament, Volume)'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColNoteParamsMouseDown
        end
        object ColNoteCommands: TShape
          Left = 154
          Top = 227
          Width = 25
          Height = 18
          Hint = 'Special Note Commands'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColNoteCommandsMouseDown
        end
        object ColOutBackground: TShape
          Left = 278
          Top = 59
          Width = 25
          Height = 18
          Hint = 'Main Background'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColOutBackgroundMouseDown
        end
        object ColOutText: TShape
          Left = 278
          Top = 83
          Width = 25
          Height = 18
          Hint = 'Text'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColOutTextMouseDown
        end
        object ColOutHlBackground: TShape
          Left = 310
          Top = 59
          Width = 25
          Height = 18
          Hint = 'Highlighted Line Background'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColOutHlBackgroundMouseDown
        end
        object LSeparators: TLabel
          Left = 20
          Top = 253
          Width = 62
          Height = 13
          Caption = 'Separators'
          Color = 15461355
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object ColSeparators: TShape
          Left = 154
          Top = 251
          Width = 25
          Height = 18
          Hint = 'Vertical Separators'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSeparatorsMouseDown
        end
        object Sep1: TShape
          Left = 140
          Top = 51
          Width = 1
          Height = 251
          Pen.Color = 12171705
        end
        object Sep2: TShape
          Left = 137
          Top = 51
          Width = 1
          Height = 251
          Pen.Color = 12171705
        end
        object Sep3: TShape
          Left = 264
          Top = 51
          Width = 1
          Height = 251
          Pen.Color = 12171705
        end
        object Sep4: TShape
          Left = 264
          Top = 27
          Width = 1
          Height = 19
          Pen.Color = 13290186
        end
        object Sep5: TShape
          Left = 137
          Top = 27
          Width = 1
          Height = 19
          Pen.Color = 13290186
        end
        object Sep6: TShape
          Left = 140
          Top = 27
          Width = 1
          Height = 19
          Pen.Color = 13290186
        end
        object ColOutSeparators: TShape
          Left = 278
          Top = 251
          Width = 25
          Height = 18
          Hint = 'Vertical Separators'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColOutSeparatorsMouseDown
        end
        object ColSelLineText: TShape
          Left = 186
          Top = 83
          Width = 25
          Height = 18
          Hint = 'Selected Line Text (Dots)'
          Brush.Color = 15263976
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSelLineTextMouseDown
        end
        object ColSelLineNum: TShape
          Left = 186
          Top = 107
          Width = 25
          Height = 18
          Hint = 'Line numbers of selected line'
          Brush.Color = 15263976
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSelLineNumMouseDown
        end
        object ColSelEnvelope: TShape
          Left = 186
          Top = 131
          Width = 25
          Height = 18
          Hint = 'Selected Line Envelope'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSelEnvelopeMouseDown
        end
        object ColSelNoise: TShape
          Left = 186
          Top = 155
          Width = 25
          Height = 18
          Hint = 'Selected Line Noise'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSelNoiseMouseDown
        end
        object ColSelNote: TShape
          Left = 186
          Top = 179
          Width = 25
          Height = 18
          Hint = 'Selected Line Note'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSelNoteMouseDown
        end
        object ColSelNoteParams: TShape
          Left = 186
          Top = 203
          Width = 25
          Height = 18
          Hint = 'Selected Line Note Params'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSelNoteParamsMouseDown
        end
        object ColSelNoteCommands: TShape
          Left = 186
          Top = 227
          Width = 25
          Height = 18
          Hint = 'Selected Line Special Note Commands'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSelNoteCommandsMouseDown
        end
        object Sep7: TShape
          Left = 387
          Top = 51
          Width = 1
          Height = 251
          Pen.Color = 12171705
        end
        object Sep8: TShape
          Left = 387
          Top = 27
          Width = 1
          Height = 19
          Pen.Color = 13290186
        end
        object LSampleOrnament: TLabel
          Left = 401
          Top = 30
          Width = 86
          Height = 13
          Caption = 'Sample/Ornament'
          Color = 16382455
          ParentColor = False
        end
        object ColSamOrnBackground: TShape
          Left = 401
          Top = 59
          Width = 25
          Height = 18
          Hint = 'Main Background'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSamOrnBackgroundMouseDown
        end
        object ColSamOrnText: TShape
          Left = 401
          Top = 83
          Width = 25
          Height = 18
          Hint = 'Sample: Text Color'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSamOrnTextMouseDown
        end
        object ColSamOrnLineNum: TShape
          Left = 401
          Top = 107
          Width = 25
          Height = 18
          Hint = 'Line Numbers'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSamOrnLineNumMouseDown
        end
        object ColSamNoise: TShape
          Left = 401
          Top = 155
          Width = 25
          Height = 18
          Hint = 'Sample: Noise'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSamNoiseMouseDown
        end
        object ColSamOrnSeparators: TShape
          Left = 401
          Top = 251
          Width = 25
          Height = 18
          Hint = 'Sample/Ornament Separators'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSamOrnSeparatorsMouseDown
        end
        object LToneShift: TLabel
          Left = 20
          Top = 277
          Width = 58
          Height = 13
          Caption = 'Tone shift'
          Color = 14737632
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object ColSamOrnTone: TShape
          Left = 401
          Top = 275
          Width = 25
          Height = 18
          Hint = 'Sample/Ornament: Tone Shift'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSamOrnToneMouseDown
        end
        object LFullScrBackground: TLabel
          Left = 20
          Top = 310
          Width = 141
          Height = 13
          Caption = 'Full Screen Background:'
          Color = 15461355
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object ColFullScreenBackground: TShape
          Left = 176
          Top = 307
          Width = 25
          Height = 18
          Hint = 'Highlighted Line Background'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColFullScreenBackgroundMouseDown
        end
        object Sep12: TShape
          Left = 166
          Top = 307
          Width = 1
          Height = 19
          Pen.Color = 13290186
        end
        object ColSamOrnSelBackground: TShape
          Left = 433
          Top = 59
          Width = 25
          Height = 18
          Hint = 'Selected Line Background'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSamOrnSelBackgroundMouseDown
        end
        object ColSamOrnSelText: TShape
          Left = 433
          Top = 83
          Width = 25
          Height = 18
          Hint = 'Sample: Selected Line Text'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSamOrnSelTextMouseDown
        end
        object ColSamSelNoise: TShape
          Left = 433
          Top = 155
          Width = 25
          Height = 18
          Hint = 'Sample: Selected Line Noise'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSamSelNoiseMouseDown
        end
        object ColSamOrnSelTone: TShape
          Left = 433
          Top = 275
          Width = 25
          Height = 18
          Hint = 'Sample/Ornament: Selected line Tone Shift'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSamOrnSelToneMouseDown
        end
        object ColSamOrnSelLineNum: TShape
          Left = 433
          Top = 107
          Width = 25
          Height = 18
          Hint = 'Selected Line Numbers'
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColSamOrnSelLineNumMouseDown
        end
        object Shape2: TShape
          Left = 387
          Top = 307
          Width = 1
          Height = 19
          Pen.Color = 13290186
        end
        object Label2: TLabel
          Left = 288
          Top = 310
          Width = 92
          Height = 13
          Caption = 'Window Theme:'
          Color = 15461355
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object Shape3: TShape
          Left = 264
          Top = 307
          Width = 1
          Height = 19
          Pen.Color = 13290186
        end
        object ColHighlLineNum: TShape
          Left = 218
          Top = 107
          Width = 25
          Height = 18
          Hint = 'Line numbers of highlighted line'
          Brush.Color = 15263976
          ParentShowHint = False
          Pen.Color = 11447982
          ShowHint = True
          OnMouseDown = ColHighlLineNumMouseDown
        end
        object WinColorsBox: TComboBox
          Left = 394
          Top = 306
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 0
          Text = 'Default'
          OnChange = WinColorsBoxChange
          Items.Strings = (
            'Default'
            'Crystaline'
            'Yellow'
            'Soft'
            'Relief'
            'Flatlines'
            'Light')
        end
      end
      object GroupBox1: TGroupBox
        Left = 272
        Top = 8
        Width = 257
        Height = 145
        Caption = ' Font Settings '
        TabOrder = 1
        object FontBold: TSpeedButton
          Left = 192
          Top = 52
          Width = 45
          Height = 21
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Bold'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = FontBoldClick
        end
        object Label1: TLabel
          Left = 192
          Top = 96
          Width = 45
          Height = 13
          Caption = 'Positions:'
        end
        object FontsList: TListBox
          Left = 8
          Top = 24
          Width = 177
          Height = 113
          ItemHeight = 13
          TabOrder = 0
          OnClick = FontsListClick
        end
        object FontSize: TEdit
          Left = 192
          Top = 24
          Width = 31
          Height = 21
          MaxLength = 2
          TabOrder = 1
          Text = '12'
          OnChange = FontSizeChange
        end
        object FontSizeInt: TUpDown
          Left = 223
          Top = 24
          Width = 14
          Height = 21
          Associate = FontSize
          Min = 12
          Max = 30
          Position = 12
          TabOrder = 2
        end
        object DecPositionsSize: TButton
          Left = 192
          Top = 115
          Width = 21
          Height = 21
          Caption = '-'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = DecPositionsSizeClick
        end
        object IncPositionsSize: TButton
          Left = 216
          Top = 115
          Width = 21
          Height = 21
          Caption = '+'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = IncPositionsSizeClick
        end
      end
    end
    object AYEmu: TTabSheet
      Caption = 'Chip emulation'
      ImageIndex = 1
      object Label7: TLabel
        Left = 16
        Top = 485
        Width = 166
        Height = 13
        Caption = 'Some changes will be heared after:'
        Visible = False
      end
      object LBChg: TLabel
        Left = 186
        Top = 485
        Width = 40
        Height = 13
        Caption = '2178 ms'
        Visible = False
      end
      object ChipSel: TRadioGroup
        Left = 128
        Top = 128
        Width = 152
        Height = 65
        Caption = ' Sound chip '
        ItemIndex = 1
        Items.Strings = (
          'AY-3-8910/12'
          'YM2149F')
        TabOrder = 3
        OnClick = ChipSelClick
      end
      object IntSel: TRadioGroup
        Left = 8
        Top = 288
        Width = 272
        Height = 193
        Hint = 
          'Want to change track interrupt frequency?'#13#10'Check the track optio' +
          'ns tab.'
        Caption = ' Default Interrupt Frequency '
        ItemIndex = 0
        Items.Strings = (
          '48.828 Hz (Pentagon 128K)'
          '50 Hz (ZX Spectrum / PAL)'
          '60 Hz (Atari ST / NTSC)'
          '100 Hz (Twice per INT)'
          '200 Hz (Atari ST)'
          '48 Hz (Non-fractional BPM)'
          'Manual (Hz)')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = IntSelClick
      end
      object Opt: TRadioGroup
        Left = 8
        Top = 200
        Width = 113
        Height = 81
        Hint = 
          'Ayumi Render has the best quality and performance.'#13#10'STRONGLY rec' +
          'ommended!'
        Caption = ' Sound Engine '
        ItemIndex = 0
        Items.Strings = (
          'VT quality'
          'VT perfomance'
          'Ayumi (best)')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = OptClick
      end
      object ChFreq: TRadioGroup
        Left = 288
        Top = 8
        Width = 241
        Height = 473
        Hint = 'Want to change track frequency?'#13#10'Check the track options tab.'
        Caption = ' Default Chip Frequency '
        ItemIndex = 0
        Items.Strings = (
          '0.894887 MHz (NES NTSC)'
          '0.8313035 MHz (NES PAL)'
          '1.7734 MHz (ZX Spectrum)'
          '1.75 MHz (Pentagon 128K)'
          '1 MHz (Amstrad CPC)'
          '1.5 MHz (Vectrex console)'
          '2 MHz (Atari ST)'
          '3.5 MHz'
          '1520640 Hz (Natural C/Am for 4th table)'
          '1611062 Hz (Natural C#/A#m for 4th table)'
          '1706861 Hz (Natural D/Bm for 4th table)'
          '1808356 Hz (Natural D#/Cm for 4th table)'
          '1915886 Hz (Natural E/C#m for 4th table)'
          '2029811 Hz (Natural F/Dm for 4th table)'
          '2150510 Hz (Natural F#/D#m for 4th table)'
          '2278386 Hz (Natural G/Em for 4th table)'
          '2413866 Hz (Natural G#/Fm for 4th table)'
          '2557401 Hz (Natural A/F#m for 4th table)'
          '2709472 Hz (Natural A#/Gm for 4th table)'
          '2870586 Hz (Natural B/G#m for 4th table)'
          '3041280 Hz (Natural C/Am for 4th table)'
          'Manual (Hz)')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = ChFreqClick
      end
      object FiltersGroup: TGroupBox
        Left = 128
        Top = 200
        Width = 152
        Height = 81
        Caption = ' Downsampling '
        TabOrder = 5
        object Label9: TLabel
          Left = 7
          Top = 61
          Width = 12
          Height = 13
          Caption = 'Lo'
        end
        object Label10: TLabel
          Left = 132
          Top = 61
          Width = 10
          Height = 13
          Caption = 'Hi'
        end
        object FiltChk: TCheckBox
          Left = 10
          Top = 20
          Width = 65
          Height = 17
          Caption = 'FIR-filter'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = FiltChkClick
        end
        object FiltNK: TTrackBar
          Left = 6
          Top = 43
          Width = 139
          Height = 17
          Max = 9
          Min = 4
          PageSize = 1
          Position = 5
          TabOrder = 1
          ThumbLength = 10
          OnChange = FiltNKChange
        end
      end
      object EdChipFrq: TEdit
        Left = 378
        Top = 451
        Width = 52
        Height = 17
        AutoSize = False
        MaxLength = 7
        TabOrder = 8
        OnKeyPress = EdChipFrqKeyPress
        OnKeyUp = EdChipFrqKeyUp
      end
      object EdIntFrq: TEdit
        Left = 100
        Top = 456
        Width = 52
        Height = 17
        AutoSize = False
        MaxLength = 8
        TabOrder = 9
        OnKeyPress = EdIntFrqKeyPress
        OnKeyUp = EdIntFrqKeyUp
      end
      object PanoramBox: TGroupBox
        Left = 128
        Top = 8
        Width = 152
        Height = 113
        Caption = ' Panning  '
        TabOrder = 1
        object APanLabel: TLabel
          Left = 11
          Top = 25
          Width = 7
          Height = 13
          Caption = 'A'
        end
        object BPanLabel: TLabel
          Left = 11
          Top = 54
          Width = 7
          Height = 13
          Caption = 'B'
        end
        object CPanLabel: TLabel
          Left = 11
          Top = 83
          Width = 7
          Height = 13
          Caption = 'C'
        end
        object APan: TTrackBar
          Left = 20
          Top = 24
          Width = 91
          Height = 17
          LineSize = 3
          Max = 255
          TabOrder = 0
          ThumbLength = 10
          TickStyle = tsManual
          OnChange = APanChange
        end
        object BPan: TTrackBar
          Left = 20
          Top = 53
          Width = 91
          Height = 17
          Max = 255
          TabOrder = 2
          ThumbLength = 10
          TickStyle = tsManual
          OnChange = BPanChange
        end
        object CPan: TTrackBar
          Left = 20
          Top = 82
          Width = 91
          Height = 17
          Max = 255
          TabOrder = 4
          ThumbLength = 10
          TickStyle = tsManual
          OnChange = CPanChange
        end
        object APanValue: TEdit
          Left = 113
          Top = 27
          Width = 26
          Height = 19
          AutoSize = False
          MaxLength = 3
          TabOrder = 1
          Text = '255'
          OnKeyUp = APanValueKeyUp
        end
        object BPanValue: TEdit
          Left = 113
          Top = 56
          Width = 26
          Height = 19
          AutoSize = False
          MaxLength = 3
          TabOrder = 3
          Text = '255'
          OnKeyUp = BPanValueKeyUp
        end
        object CPanValue: TEdit
          Left = 113
          Top = 85
          Width = 26
          Height = 19
          AutoSize = False
          MaxLength = 3
          TabOrder = 5
          Text = '255'
          OnKeyUp = CPanValueKeyUp
        end
      end
      object ChanVisAlloc: TRadioGroup
        Left = 8
        Top = 8
        Width = 113
        Height = 185
        Caption = ' Channels mapping '
        ItemIndex = 0
        Items.Strings = (
          'Mono'
          'ABC'
          'ACB'
          'BAC'
          'BCA'
          'CAB'
          'CBA')
        TabOrder = 0
        OnClick = ChanVisAllocClick
      end
      object AyumiDCFiltBox: TGroupBox
        Left = 184
        Top = 280
        Width = 152
        Height = 81
        Caption = ' Ayumi DC Filter '
        TabOrder = 6
        Visible = False
        object DCCutOffLab: TLabel
          Left = 74
          Top = 38
          Width = 49
          Height = 13
          Caption = 'DC Cutoff:'
        end
        object DCCutOffBar: TTrackBar
          Left = 70
          Top = 55
          Width = 77
          Height = 17
          Min = 3
          PageSize = 1
          Position = 5
          TabOrder = 2
          ThumbLength = 10
          OnChange = DCCutOffBarChange
        end
        object DCOff: TRadioButton
          Left = 8
          Top = 20
          Width = 41
          Height = 17
          Caption = 'Off'
          TabOrder = 0
          OnMouseUp = DCOffMouseUp
        end
        object DCAyumi: TRadioButton
          Left = 8
          Top = 38
          Width = 49
          Height = 17
          Caption = 'Ayumi'
          TabOrder = 1
          OnMouseUp = DCAyumiMouseUp
        end
        object DCWbcbz7: TRadioButton
          Left = 8
          Top = 56
          Width = 65
          Height = 17
          Caption = 'Wbcbz7'
          TabOrder = 3
          OnMouseUp = DCWbcbz7MouseUp
        end
      end
    end
    object WOAPITAB: TTabSheet
      Caption = 'Audio'
      ImageIndex = 4
      object SpeedButton1: TSpeedButton
        Left = 472
        Top = 376
        Width = 55
        Height = 25
        Action = MainForm.Stop
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF000000000000000000000000000000000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000
          0000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF000000000000000000000000000000000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000
          0000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF000000000000000000000000000000000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000
          0000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF000000000000000000000000000000000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000
          0000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        Margin = 2
      end
      object grp1: TGroupBox
        Left = 277
        Top = 224
        Width = 252
        Height = 137
        Caption = ' MIDI Keyboard  '
        TabOrder = 5
        object midibtn1: TButton
          Left = 136
          Top = 64
          Width = 97
          Height = 25
          Caption = 'Next Device >'
          TabOrder = 2
          OnClick = midibtn1Click
        end
        object midibtn2: TButton
          Left = 16
          Top = 64
          Width = 105
          Height = 25
          Caption = '< Previous Device'
          TabOrder = 1
          OnClick = midibtn2Click
        end
        object midibtn3: TButton
          Left = 16
          Top = 96
          Width = 217
          Height = 25
          Caption = 'Stop MIDI'
          TabOrder = 3
          Visible = False
          OnClick = midibtn3Click
        end
        object MIDIDeviceName: TEdit
          Left = 16
          Top = 28
          Width = 217
          Height = 21
          Enabled = False
          TabOrder = 0
          Text = '(none)'
        end
      end
      object SR: TRadioGroup
        Left = 8
        Top = 8
        Width = 129
        Height = 201
        Hint = '192000 Hz only for Ayumi Engine!'
        Caption = ' Sample Rate '
        ItemIndex = 2
        Items.Strings = (
          '11025 Hz'
          '22050 Hz'
          '44100 Hz'
          '48000 Hz'
          '88200 Hz'
          '96000 Hz'
          '192000 Hz')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = SRClick
      end
      object BR: TRadioGroup
        Left = 152
        Top = 8
        Width = 108
        Height = 121
        Hint = '24 bit and 32 bit only for Ayumi Engine!'
        Caption = ' Bit Rate  '
        ItemIndex = 1
        Items.Strings = (
          '8 bit'
          '16 bit'
          '24 bit'
          '32 bit')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = BRClick
      end
      object NCh: TRadioGroup
        Left = 152
        Top = 144
        Width = 108
        Height = 65
        Caption = 'Channels'
        ItemIndex = 1
        Items.Strings = (
          'Mono'
          'Stereo')
        TabOrder = 3
        OnClick = NChClick
      end
      object Buff: TGroupBox
        Left = 277
        Top = 8
        Width = 252
        Height = 201
        Caption = ' Buffers '
        TabOrder = 2
        object Label6: TLabel
          Left = 16
          Top = 104
          Width = 87
          Height = 13
          Caption = 'Number of buffers:'
        end
        object LbLen: TLabel
          Left = 88
          Top = 32
          Width = 34
          Height = 13
          Caption = '726 ms'
        end
        object LbNum: TLabel
          Left = 107
          Top = 104
          Width = 6
          Height = 13
          Caption = '3'
        end
        object Label4: TLabel
          Left = 16
          Top = 169
          Width = 63
          Height = 13
          Caption = 'Total Length:'
        end
        object LBTot: TLabel
          Left = 85
          Top = 169
          Width = 40
          Height = 13
          Caption = '2178 ms'
        end
        object Label5: TLabel
          Left = 16
          Top = 32
          Width = 67
          Height = 13
          Caption = 'Buffer Length:'
        end
        object TrackBar1: TTrackBar
          Left = 8
          Top = 48
          Width = 233
          Height = 33
          Hint = 'Length of one buffer'
          Max = 2000
          Min = 5
          PageSize = 1
          Frequency = 100
          Position = 726
          TabOrder = 0
          OnChange = TrackBar1Change
        end
        object TrackBar2: TTrackBar
          Left = 8
          Top = 119
          Width = 233
          Height = 33
          Hint = 'Number of buffers'
          Min = 2
          PageSize = 1
          Position = 3
          TabOrder = 1
          OnChange = TrackBar2Change
        end
      end
      object SelDev: TGroupBox
        Left = 8
        Top = 224
        Width = 252
        Height = 137
        Caption = ' Wave Out Device '
        TabOrder = 4
        object Edit3: TEdit
          Left = 16
          Top = 28
          Width = 217
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
          Text = 'Wave mapper'
        end
        object Button4: TButton
          Left = 16
          Top = 96
          Width = 217
          Height = 25
          Caption = 'Get full list'
          TabOrder = 2
          OnClick = Button4Click
        end
        object ComboBox1: TComboBox
          Left = 16
          Top = 64
          Width = 217
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          Visible = False
          OnChange = ComboBox1Change
        end
      end
    end
    object HotKeys: TTabSheet
      Caption = 'HotKeys'
      ImageIndex = 6
      object GroupBox2: TGroupBox
        Left = 8
        Top = 8
        Width = 521
        Height = 481
        TabOrder = 0
        object HotKeyList: TListView
          Left = 8
          Top = 14
          Width = 505
          Height = 459
          BiDiMode = bdLeftToRight
          Columns = <
            item
              AutoSize = True
              Caption = 'Name'
              MaxWidth = 359
              MinWidth = 359
            end
            item
              AutoSize = True
              Caption = 'HotKey'
              MaxWidth = 125
              MinWidth = 125
            end>
          ColumnClick = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GridLines = True
          IconOptions.Arrangement = iaLeft
          IconOptions.WrapText = False
          ReadOnly = True
          RowSelect = True
          ParentBiDiMode = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          TabStop = False
          ViewStyle = vsReport
          OnKeyDown = HotKeyListKeyDown
          OnKeyPress = HotKeyListKeyPress
        end
      end
    end
    object OpMod: TTabSheet
      Caption = 'Compatibility'
      ImageIndex = 3
      object SaveHead: TRadioGroup
        Left = 8
        Top = 264
        Width = 521
        Height = 97
        Caption = ' Save with header '
        ItemIndex = 2
        Items.Strings = (
          '"Vortex Tracker II 2.0 module:" where possible'
          '"ProTracker 3.x compilation of" always'
          'Try to detect')
        TabOrder = 1
        OnClick = SaveHeadClick
      end
      object RadioGroup1: TRadioGroup
        Left = 8
        Top = 376
        Width = 521
        Height = 113
        Caption = ' Features Level '
        ItemIndex = 3
        Items.Strings = (
          'Pro Tracker 3.5'
          'Vortex Tracker II (PT 3.6)'
          'Pro Tracker 3.7'
          'Try to detect')
        TabOrder = 2
        OnClick = RadioGroup1Click
      end
      object FileAssocBox: TGroupBox
        Left = 8
        Top = 8
        Width = 521
        Height = 241
        Caption = ' File Associations '
        TabOrder = 0
        object FileAssocList: TListView
          Left = 16
          Top = 48
          Width = 489
          Height = 177
          Checkboxes = True
          Columns = <
            item
              Caption = 'Extension'
              MaxWidth = 65
              MinWidth = 65
              Width = 65
            end
            item
              Caption = 'Type'
              MaxWidth = 403
              MinWidth = 403
              Width = 403
            end>
          ColumnClick = False
          GridLines = True
          Items.Data = {
            200000000100000000000000FFFFFFFFFFFFFFFF000000000000000003567433}
          ReadOnly = True
          RowSelect = True
          TabOrder = 2
          ViewStyle = vsReport
          OnClick = FileAssocListClick
        end
        object AllFileAssoc: TButton
          Left = 16
          Top = 24
          Width = 73
          Height = 17
          Caption = 'Check All'
          TabOrder = 0
          OnClick = AllFileAssocClick
        end
        object NoneFileAssoc: TButton
          Left = 96
          Top = 24
          Width = 73
          Height = 17
          Caption = 'Uncheck All'
          TabOrder = 1
          OnClick = NoneFileAssocClick
        end
      end
    end
  end
  object Button1: TButton
    Left = 368
    Top = 536
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 456
    Top = 536
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object SaveThemeDialog: TSaveDialog
    DefaultExt = 'vtt'
    Filter = 'Vortext Tracker Theme (*.vtt)|*.vtt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoChangeDir, ofCreatePrompt, ofNoReadOnlyReturn, ofEnableSizing]
    Left = 16
    Top = 536
  end
  object LoadThemeDialog: TOpenDialog
    DefaultExt = 'vtt'
    Filter = 'Vortext Tracker Theme (*.vtt)|*.vtt'
    Options = [ofHideReadOnly, ofNoChangeDir, ofFileMustExist, ofNoLongNames, ofEnableSizing]
    Left = 48
    Top = 536
  end
  object TemplateDialog: TOpenDialog
    DefaultExt = 'vt2'
    Filter = 
      'VortexTracker 2.0 module (*.vt2)|*.vt2|VortexTracker 1.0 module ' +
      '(*.txt)|*.txt'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 80
    Top = 536
  end
end
