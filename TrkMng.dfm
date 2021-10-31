object TrMng: TTrMng
  Left = 888
  Top = 212
  BorderStyle = bsToolWindow
  Caption = 'Tracks manager'
  ClientHeight = 379
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 80
    Top = 36
    Width = 113
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '<---  Pattern  --->'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 80
    Top = 63
    Width = 113
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '<---    Line    --->'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 80
    Top = 94
    Width = 113
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '<--- Channel --->'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 69
    Height = 113
    Caption = ' Location 1 '
    TabOrder = 0
    object Edit2: TEdit
      Left = 10
      Top = 25
      Width = 33
      Height = 21
      Hint = 'Pattern number'
      TabOrder = 0
      Text = '0'
    end
    object UpDown1: TUpDown
      Left = 43
      Top = 25
      Width = 15
      Height = 21
      Hint = 'Pattern number'
      Associate = Edit2
      Max = 84
      TabOrder = 1
    end
    object Edit1: TEdit
      Left = 10
      Top = 53
      Width = 33
      Height = 21
      Hint = 'Start pattern line'
      TabOrder = 2
      Text = '0'
    end
    object UpDown2: TUpDown
      Left = 43
      Top = 53
      Width = 15
      Height = 21
      Hint = 'Start pattern line'
      Associate = Edit1
      Max = 99
      TabOrder = 3
    end
    object Edit6: TEdit
      Left = 10
      Top = 81
      Width = 33
      Height = 21
      Hint = 'Channel number: 0 - A; 1 - B; 2 - C'
      TabOrder = 4
      Text = 'A'
      OnKeyDown = Edit6_7KeyDown
      OnKeyPress = Edit6_7KeyPress
    end
    object UpDown6: TUpDown
      Left = 43
      Top = 81
      Width = 15
      Height = 21
      Hint = 'Channel number: 0 - A; 1 - B; 2 - C'
      Max = 2
      TabOrder = 5
      OnChangingEx = UpDown6_7ChangingEx
    end
  end
  object GroupBox2: TGroupBox
    Left = 196
    Top = 8
    Width = 69
    Height = 113
    Caption = ' Location 2 '
    TabOrder = 1
    object Edit3: TEdit
      Left = 10
      Top = 25
      Width = 33
      Height = 21
      Hint = 'Pattern number'
      TabOrder = 0
      Text = '0'
    end
    object UpDown3: TUpDown
      Left = 43
      Top = 25
      Width = 15
      Height = 21
      Hint = 'Pattern number'
      Associate = Edit3
      ArrowKeys = False
      Max = 84
      TabOrder = 1
    end
    object Edit4: TEdit
      Left = 10
      Top = 53
      Width = 33
      Height = 21
      Hint = 'Start pattern line'
      TabOrder = 2
      Text = '0'
    end
    object UpDown4: TUpDown
      Left = 43
      Top = 53
      Width = 15
      Height = 21
      Hint = 'Start pattern line'
      Associate = Edit4
      ArrowKeys = False
      Max = 63
      TabOrder = 3
    end
    object Edit7: TEdit
      Left = 10
      Top = 81
      Width = 33
      Height = 21
      Hint = 'Channel number: 0 - A; 1 - B; 2 - C'
      TabOrder = 4
      Text = 'A'
      OnKeyDown = Edit6_7KeyDown
      OnKeyPress = Edit6_7KeyPress
    end
    object UpDown7: TUpDown
      Left = 43
      Top = 81
      Width = 15
      Height = 21
      Hint = 'Channel number: 0 - A; 1 - B; 2 - C'
      ArrowKeys = False
      Max = 2
      TabOrder = 5
      OnChangingEx = UpDown6_7ChangingEx
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 138
    Width = 81
    Height = 55
    Caption = ' Copy '
    TabOrder = 2
    object SpeedButton1: TSpeedButton
      Left = 10
      Top = 20
      Width = 28
      Height = 21
      Caption = '<<'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 42
      Top = 20
      Width = 28
      Height = 21
      Caption = '>>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton2Click
    end
  end
  object GroupBox4: TGroupBox
    Left = 96
    Top = 138
    Width = 81
    Height = 55
    Caption = ' Move '
    TabOrder = 3
    object SpeedButton3: TSpeedButton
      Left = 10
      Top = 20
      Width = 28
      Height = 21
      Caption = '<<'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 42
      Top = 20
      Width = 28
      Height = 21
      Caption = '>>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton4Click
    end
  end
  object GroupBox5: TGroupBox
    Left = 184
    Top = 138
    Width = 81
    Height = 55
    Caption = ' Swap '
    TabOrder = 4
    object SpeedButton5: TSpeedButton
      Left = 16
      Top = 20
      Width = 49
      Height = 21
      Caption = '<<  >>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Spacing = 1
      OnClick = SpeedButton5Click
    end
  end
  object GroupBox6: TGroupBox
    Left = 8
    Top = 216
    Width = 125
    Height = 113
    Caption = ' Area '
    TabOrder = 5
    object Label5: TLabel
      Left = 8
      Top = 27
      Width = 28
      Height = 13
      Caption = 'Lines:'
    end
    object CheckBox1: TCheckBox
      Left = 10
      Top = 60
      Width = 108
      Height = 17
      Caption = 'Envelope column'
      TabOrder = 2
    end
    object CheckBox2: TCheckBox
      Left = 10
      Top = 84
      Width = 94
      Height = 17
      Caption = 'Noise column'
      TabOrder = 3
    end
    object Edit5: TEdit
      Left = 41
      Top = 25
      Width = 33
      Height = 21
      Hint = 'Number of pattern lines for operation'
      TabOrder = 0
      Text = '100'
    end
    object UpDown5: TUpDown
      Left = 74
      Top = 25
      Width = 15
      Height = 21
      Hint = 'Number of pattern lines for operation'
      Associate = Edit5
      Min = 1
      Position = 100
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 187
    Top = 340
    Width = 77
    Height = 29
    Cancel = True
    Caption = 'Close'
    Default = True
    ModalResult = 1
    TabOrder = 7
    OnClick = Button1Click
  end
  object GroupBox7: TGroupBox
    Left = 144
    Top = 216
    Width = 121
    Height = 113
    Caption = ' Transposition '
    TabOrder = 6
    object Label8: TLabel
      Left = 10
      Top = 27
      Width = 52
      Height = 13
      Caption = 'Semitones:'
    end
    object SpeedButton6: TSpeedButton
      Left = 10
      Top = 56
      Width = 100
      Height = 21
      Caption = 'Location 1'
      OnClick = SpeedButton6Click
    end
    object SpeedButton7: TSpeedButton
      Left = 10
      Top = 80
      Width = 100
      Height = 21
      Caption = 'Location 2'
      OnClick = SpeedButton7Click
    end
    object Edit8: TEdit
      Left = 69
      Top = 25
      Width = 25
      Height = 21
      Hint = 
        'Number of semitones to transpose: positive - up and negative - d' +
        'own'
      TabOrder = 0
      Text = '0'
    end
    object UpDown8: TUpDown
      Left = 94
      Top = 25
      Width = 15
      Height = 21
      Hint = 
        'Number of semitones to transpose: positive - up and negative - d' +
        'own'
      Associate = Edit8
      Min = -95
      Max = 95
      TabOrder = 1
    end
  end
end
