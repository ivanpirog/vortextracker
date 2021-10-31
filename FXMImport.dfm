object FXMParams: TFXMParams
  Left = 192
  Top = 114
  Width = 264
  Height = 204
  Caption = 'FXM Importer Parameters'
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
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 36
    Height = 13
    Caption = 'Length:'
  end
  object Label3: TLabel
    Left = 16
    Top = 48
    Width = 68
    Height = 13
    Caption = 'Loop interrupt:'
  end
  object Label4: TLabel
    Left = 16
    Top = 88
    Width = 59
    Height = 13
    Caption = 'Initial tempo:'
  end
  object Label5: TLabel
    Left = 136
    Top = 8
    Width = 58
    Height = 13
    Caption = 'Pattern size:'
  end
  object Label2: TLabel
    Left = 136
    Top = 48
    Width = 82
    Height = 13
    Caption = 'Global transpose:'
  end
  object Label6: TLabel
    Left = 136
    Top = 88
    Width = 65
    Height = 13
    Caption = 'amad_andsix:'
  end
  object Edit1: TEdit
    Left = 16
    Top = 24
    Width = 105
    Height = 21
    TabOrder = 0
    OnChange = Edit1Change
  end
  object Edit2: TEdit
    Left = 16
    Top = 64
    Width = 105
    Height = 21
    TabOrder = 1
    OnChange = Edit2Change
  end
  object Edit3: TEdit
    Left = 16
    Top = 104
    Width = 105
    Height = 21
    TabOrder = 2
    OnChange = Edit3Change
  end
  object Edit4: TEdit
    Left = 136
    Top = 24
    Width = 105
    Height = 21
    TabOrder = 3
    OnChange = Edit4Change
  end
  object Button1: TButton
    Left = 32
    Top = 136
    Width = 89
    Height = 25
    Caption = 'Start conversion'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object Button2: TButton
    Left = 136
    Top = 136
    Width = 89
    Height = 25
    Cancel = True
    Caption = 'Default'
    ModalResult = 2
    TabOrder = 7
  end
  object Edit5: TEdit
    Left = 136
    Top = 64
    Width = 105
    Height = 21
    TabOrder = 4
    OnChange = Edit5Change
  end
  object Edit6: TEdit
    Left = 136
    Top = 104
    Width = 105
    Height = 21
    TabOrder = 5
    OnChange = Edit6Change
  end
end
