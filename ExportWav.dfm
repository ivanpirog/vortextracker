object Export: TExport
  Left = 421
  Top = 165
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Export to wav...'
  ClientHeight = 66
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ExportProgress: TProgressBar
    Left = 16
    Top = 16
    Width = 360
    Height = 33
    Position = 100
    Step = 1
    TabOrder = 0
  end
  object ExportActions: TActionList
    Left = 352
    Top = 40
    object StopExport: TAction
      Caption = 'StopExport'
      ShortCut = 27
    end
  end
end
