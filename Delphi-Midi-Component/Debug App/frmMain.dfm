object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MIDI I/O Pass-Through/Debug'
  ClientHeight = 162
  ClientWidth = 560
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object gbInputMidiPod: TGroupBox
    Left = 8
    Top = 8
    Width = 281
    Height = 45
    Caption = ' Input Device '
    TabOrder = 0
    object cbInputMIDIDevices: TComboBox
      Left = 7
      Top = 16
      Width = 267
      Height = 21
      Hint = 'Select Input MIDI Device (preferrable a virtual MIDI cable)'
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbInputMIDIDevicesChange
    end
  end
  object gbOutputMidiPod: TGroupBox
    Left = 8
    Top = 59
    Width = 281
    Height = 46
    Caption = ' Output Device '
    TabOrder = 1
    object cbOutputMIDIDevices: TComboBox
      Left = 7
      Top = 16
      Width = 267
      Height = 21
      Hint = 'Select a MIDI Output Device (e.g. MS Software Synth)'
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbOutputMIDIDevicesChange
    end
  end
  object btnOpenAll: TButton
    Left = 168
    Top = 111
    Width = 58
    Height = 25
    Hint = 'Open both devices'
    Caption = 'Open'
    TabOrder = 2
    OnClick = btnOpenAllClick
  end
  object btnStopAll: TButton
    Left = 232
    Top = 111
    Width = 57
    Height = 25
    Hint = 'Close both devices'
    Caption = 'Close'
    TabOrder = 3
    OnClick = btnStopAllClick
  end
  object Button1: TButton
    Left = 8
    Top = 111
    Width = 89
    Height = 25
    Hint = 'Refresh Device List'
    Caption = 'Refresh Dev.'
    TabOrder = 4
    OnClick = Button1Click
  end
  object memoInputDebug: TMemo
    Left = 295
    Top = 8
    Width = 257
    Height = 128
    Font.Charset = OEM_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Terminal'
    Font.Style = []
    Lines.Strings = (
      'memoInputDebug')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object Button2: TButton
    Left = 103
    Top = 111
    Width = 44
    Height = 25
    Hint = 'Send some notes to current open Output Device'
    Caption = 'Sound'
    TabOrder = 6
    OnClick = Button2Click
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 143
    Width = 560
    Height = 19
    AutoHint = True
    Panels = <
      item
        Text = ' Incomming messages in queue'
        Width = 300
      end
      item
        Text = ' Incomming messages in queue'
        Width = 165
      end
      item
        Width = 50
      end>
    ExplicitWidth = 528
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 312
    Top = 32
  end
end
