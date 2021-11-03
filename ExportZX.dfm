object ExpDlg: TExpDlg
  Left = 204
  Top = 151
  BorderStyle = bsDialog
  Caption = 'ZX Spectrum PT3/TS player parameters'
  ClientHeight = 320
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 144
    Top = 288
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 280
    Top = 288
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 217
    Height = 81
    Caption = 'Parameters'
    TabOrder = 0
    object Label3: TLabel
      Left = 120
      Top = 35
      Width = 22
      Height = 13
      Caption = 'DEC'
    end
    object Label2: TLabel
      Left = 16
      Top = 35
      Width = 22
      Height = 13
      Caption = 'HEX'
    end
    object Label15: TLabel
      Left = 16
      Top = 16
      Width = 119
      Height = 13
      Caption = 'Compilation address (max'
    end
    object Label22: TLabel
      Left = 144
      Top = 16
      Width = 3
      Height = 13
    end
    object Edit2: TEdit
      Left = 144
      Top = 32
      Width = 57
      Height = 21
      TabOrder = 1
      OnChange = Edit2Change
    end
    object Edit1: TEdit
      Left = 40
      Top = 32
      Width = 57
      Height = 21
      TabOrder = 0
      OnChange = Edit1Change
    end
    object LoopChk: TCheckBox
      Left = 16
      Top = 56
      Width = 97
      Height = 17
      Caption = 'Disable loop'
      TabOrder = 2
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 96
    Width = 217
    Height = 185
    Caption = 'Format'
    ItemIndex = 0
    Items.Strings = (
      'Hobeta with player'
      'Hobeta without player'
      '.AY-file'
      '.SCL-file (player and module separately)'
      '.TAP-file (player and module separately)')
    TabOrder = 2
    OnClick = RadioGroup1Click
  end
  object GroupBox2: TGroupBox
    Left = 232
    Top = 8
    Width = 265
    Height = 273
    Caption = 'Hints'
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 53
      Height = 13
      Caption = 'INIT: CALL'
    end
    object Label4: TLabel
      Left = 72
      Top = 16
      Width = 3
      Height = 13
    end
    object Label5: TLabel
      Left = 16
      Top = 32
      Width = 59
      Height = 13
      Caption = 'PLAY: CALL'
    end
    object Label6: TLabel
      Left = 80
      Top = 32
      Width = 3
      Height = 13
    end
    object Label7: TLabel
      Left = 16
      Top = 48
      Width = 63
      Height = 13
      Caption = 'MUTE: CALL'
    end
    object Label8: TLabel
      Left = 88
      Top = 48
      Width = 3
      Height = 13
    end
    object Label9: TLabel
      Left = 16
      Top = 64
      Width = 54
      Height = 13
      Caption = 'Setup byte:'
    end
    object Label10: TLabel
      Left = 72
      Top = 64
      Width = 3
      Height = 13
    end
    object Label11: TLabel
      Left = 112
      Top = 80
      Width = 124
      Height = 13
      Caption = 'bit 7 is set after each loop.'
    end
    object Label12: TLabel
      Left = 112
      Top = 64
      Width = 111
      Height = 13
      Caption = 'set bit 0 to disable loop;'
    end
    object Label13: TLabel
      Left = 16
      Top = 96
      Width = 143
      Height = 13
      Caption = 'Current position pointer (word):'
    end
    object Label14: TLabel
      Left = 164
      Top = 96
      Width = 3
      Height = 13
    end
    object Label16: TLabel
      Left = 16
      Top = 128
      Width = 86
      Height = 13
      Caption = 'Variables address:'
    end
    object Label17: TLabel
      Left = 104
      Top = 128
      Width = 3
      Height = 13
    end
    object Label18: TLabel
      Left = 136
      Top = 128
      Width = 38
      Height = 13
      Caption = '; length:'
    end
    object Label19: TLabel
      Left = 176
      Top = 128
      Width = 3
      Height = 13
    end
    object Label20: TLabel
      Left = 16
      Top = 112
      Width = 96
      Height = 13
      Caption = 'Player codes length:'
    end
    object Label21: TLabel
      Left = 120
      Top = 112
      Width = 3
      Height = 13
    end
    object Label26: TLabel
      Left = 16
      Top = 144
      Width = 78
      Height = 13
      Caption = 'Module address:'
    end
    object Label27: TLabel
      Left = 104
      Top = 144
      Width = 3
      Height = 13
    end
    object Label28: TLabel
      Left = 136
      Top = 144
      Width = 38
      Height = 13
      Caption = '; length:'
    end
    object Label29: TLabel
      Left = 176
      Top = 144
      Width = 3
      Height = 13
    end
    object Label23: TLabel
      Left = 136
      Top = 159
      Width = 38
      Height = 13
      Caption = '; length:'
    end
    object Label24: TLabel
      Left = 104
      Top = 159
      Width = 3
      Height = 13
    end
    object Label25: TLabel
      Left = 16
      Top = 159
      Width = 84
      Height = 13
      Caption = 'Module2 address:'
    end
    object Label30: TLabel
      Left = 176
      Top = 159
      Width = 3
      Height = 13
    end
    object Memo1: TMemo
      Left = 16
      Top = 176
      Width = 233
      Height = 89
      Lines.Strings = (
        'Classic example (START is player address):'
        '        LD DE,Module2_Address ;for TS-player'
        '        CALL START'
        '        EI'
        'LOOP:'
        '        HALT'
        '        CALL START+5'
        '        JR LOOP'
        ''
        'No loop example (play once):'
        '        LD A,1'
        '        LD (START+10),A'
        '        CALL START'
        '        EI'
        'LOOP:'
        '        HALT'
        '        CALL START+5'
        '        LD A,(START+10)'
        '        RLA'
        '        JR NC,LOOP'
        '        RET'
        ''
        'Pointing module address example:'
        '        LD HL,PT3_Module_Address'
        '        LD DE,Module2_Address ;for TS-player'
        '        CALL START+3'
        '        EI'
        'LOOP:'
        '        HALT'
        '        CALL START+5'
        '        JR LOOP'
        ''
        'Call MUTE (START+8) for sound off during '
        'pause or after stoping playing. In last case '
        'you can call START one more time to reinit '
        'and sound off.')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
