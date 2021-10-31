object GlbTrans: TGlbTrans
  Left = 901
  Top = 403
  BorderStyle = bsToolWindow
  Caption = 'Global Transposition'
  ClientHeight = 150
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 184
    Top = 5
    Width = 129
    Height = 134
    Caption = 'Channels to transpose'
    TabOrder = 1
    object CheckBox4: TCheckBox
      Left = 10
      Top = 104
      Width = 97
      Height = 17
      Caption = 'Envelope track'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object CheckBox1: TCheckBox
      Left = 10
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Channel A track'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 10
      Top = 50
      Width = 97
      Height = 17
      Caption = 'Channel B track'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Left = 10
      Top = 77
      Width = 97
      Height = 17
      Caption = 'Channel C track'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 5
    Top = 5
    Width = 172
    Height = 103
    Caption = 'Global options'
    TabOrder = 0
    object Label8: TLabel
      Left = 8
      Top = 22
      Width = 102
      Height = 13
      Caption = 'Number of semitones:'
    end
    object UpDown8: TUpDown
      Left = 142
      Top = 19
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
    object Edit8: TEdit
      Left = 117
      Top = 19
      Width = 25
      Height = 21
      Hint = 
        'Number of semitones to transpose: positive - up and negative - d' +
        'own'
      TabOrder = 0
      Text = '0'
      OnExit = Edit8Exit
    end
    object RadioButton1: TRadioButton
      Left = 8
      Top = 50
      Width = 89
      Height = 17
      Caption = 'Whole module'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 69
      Width = 105
      Height = 17
      Caption = 'Only pattern num:'
      TabOrder = 5
    end
    object Edit2: TEdit
      Left = 117
      Top = 67
      Width = 25
      Height = 21
      Hint = 'Pattern number to transpose'
      TabOrder = 3
      Text = '0'
      OnExit = Edit2Exit
    end
    object UpDown1: TUpDown
      Left = 142
      Top = 67
      Width = 15
      Height = 21
      Hint = 'Pattern number to transpose'
      Associate = Edit2
      Max = 84
      TabOrder = 4
    end
  end
  object Button1: TButton
    Left = 5
    Top = 117
    Width = 80
    Height = 21
    Caption = 'Transpose'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 96
    Top = 117
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 3
    OnClick = Button2Click
  end
end
