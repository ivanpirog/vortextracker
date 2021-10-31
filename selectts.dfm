object TSSel: TTSSel
  Left = 443
  Top = 290
  Width = 396
  Height = 285
  BorderIcons = [biSystemMenu]
  Caption = 'Select module for Turbo Sound mode'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 380
    Height = 246
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 16
    Items.Strings = (
      'Test'
      '3231'
      '3424'
      '12343214')
    ParentFont = False
    TabOrder = 0
    OnDblClick = ListBox1DblClick
    OnKeyPress = ListBox1KeyPress
  end
end
