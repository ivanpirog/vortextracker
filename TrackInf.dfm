object TrackInfoForm: TTrackInfoForm
  Left = 645
  Top = 245
  BorderStyle = bsDialog
  Caption = 'Track Info'
  ClientHeight = 486
  ClientWidth = 619
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  PixelsPerInch = 96
  TextHeight = 13
  object Info: TRichEdit
    Left = 10
    Top = 10
    Width = 599
    Height = 423
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clCream
    Ctl3D = True
    ParentCtl3D = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WantReturns = False
  end
  object OK: TButton
    Left = 10
    Top = 443
    Width = 599
    Height = 33
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    OnClick = OKClick
  end
end
