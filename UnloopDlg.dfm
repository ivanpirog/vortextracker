object UnloopDlg: TUnloopDlg
  Left = 838
  Top = 300
  Width = 209
  Height = 215
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 164
    Height = 26
    Caption = 'Enter unloop count.'#13#10'0 - for unloop till the end of sample.'
  end
  object Label2: TLabel
    Left = 16
    Top = 67
    Width = 38
    Height = 13
    Caption = 'Count:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object UnloopCount: TEdit
    Left = 57
    Top = 64
    Width = 33
    Height = 21
    TabOrder = 0
    Text = '0'
    OnKeyPress = UnloopCountKeyPress
  end
  object UnloopUpDown: TUpDown
    Left = 90
    Top = 64
    Width = 16
    Height = 21
    Associate = UnloopCount
    TabOrder = 1
  end
  object CalcSlides: TCheckBox
    Left = 16
    Top = 96
    Width = 97
    Height = 21
    Caption = 'Calculate slides'
    TabOrder = 2
  end
  object OkBtn: TButton
    Left = 104
    Top = 136
    Width = 73
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object CancelBtn: TButton
    Left = 16
    Top = 136
    Width = 73
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
