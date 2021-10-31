object ExportOptions: TExportOptions
  Left = 987
  Top = 299
  BorderStyle = bsDialog
  Caption = 'Export Options'
  ClientHeight = 350
  ClientWidth = 235
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Chip: TRadioGroup
    Left = 9
    Top = 165
    Width = 218
    Height = 54
    Items.Strings = (
      'AY'
      'YM')
    TabOrder = 3
  end
  object SampleRate: TRadioGroup
    Left = 9
    Top = 4
    Width = 105
    Height = 158
    Items.Strings = (
      '22050 Hz'
      '44100 Hz'
      '48000 Hz'
      '88200 Hz'
      '96000 Hz'
      '192000 Hz')
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 9
    Top = 222
    Width = 218
    Height = 86
    TabOrder = 4
    object ExportNumLoops: TLabel
      Left = 9
      Top = 23
      Width = 61
      Height = 13
      Caption = 'Repeat loop:'
    end
    object Label1: TLabel
      Left = 144
      Top = 23
      Width = 24
      Height = 13
      Caption = 'times'
    end
    object LpRepeat: TEdit
      Left = 80
      Top = 19
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object LoopRepeats: TUpDown
      Left = 121
      Top = 19
      Width = 14
      Height = 21
      Associate = LpRepeat
      Max = 10
      TabOrder = 1
    end
    object ExportSelected: TCheckBox
      Left = 9
      Top = 56
      Width = 153
      Height = 17
      Caption = 'Export selected positions'
      TabOrder = 2
    end
  end
  object Button1: TButton
    Left = 151
    Top = 316
    Width = 75
    Height = 25
    Caption = 'Export'
    Default = True
    ModalResult = 1
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 64
    Top = 316
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
    OnClick = Button2Click
  end
  object BitRate: TRadioGroup
    Left = 122
    Top = 4
    Width = 105
    Height = 94
    Items.Strings = (
      '16 bit'
      '24 bit'
      '32 bit')
    TabOrder = 1
  end
  object Channels: TRadioGroup
    Left = 122
    Top = 101
    Width = 105
    Height = 61
    Items.Strings = (
      'Mono'
      'Stereo')
    TabOrder = 2
  end
end
