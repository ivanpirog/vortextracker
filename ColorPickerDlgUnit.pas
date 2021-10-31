//========================================================================
//  Ultimate Color Picker Dialogs - Delphi Edition
//
//  Copyright 2003-2005, SimpleWebsiteNavigation.com, All Rights Reserved.
//
//  Datecode: 050929
//
//  This software is shareware.  You may evaluate it for free, but it you
//  use it you must purchase a license from:
//     www.components.SimpleWebsiteNavigation.com
//========================================================================

unit ColorPickerDlgUnit;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TColorPickerDlg = class;
  TColorPickerColorChangeEvent = procedure (Sender: TColorPickerDlg) of object;
  TColorPickerDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    SelectedColorGroupBox: TGroupBox;
    RedValueLabel: TLabel;
    GreenValueLabel: TLabel;
    BlueValueLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SelectedColorPanel: TPanel;
    ColorPickerPanel: TPanel;
    procedure FormDeactivate(Sender: TObject);
  private
    revert_color: TColor;  // used by SaveColor/RevertColor
    fOnColorChange: TColorPickerColorChangeEvent;
    function rColorPick: TColor;
    procedure wColorPick (c: TColor);
  protected
    old_color: TColor;  // used if this dialog's Cancel button is hit
    procedure fire_color_change_event;
    procedure UpdateDialogPreview;
      virtual;
  public
    property ColorPick: TColor read rColorPick write wColorPick;
    property OnColorChange: TColorPickerColorChangeEvent read fOnColorChange write fOnColorChange;
    procedure SaveColor;
    procedure RevertColor;
  end;

var
   ColorPickerDlg: TColorPickerDlg;

implementation

{$R *.DFM}

procedure TColorPickerDlg.fire_color_change_event;
   begin
      if Assigned (fOnColorChange)
      then
         OnColorChange (self)
   end;

function TColorPickerDlg.rColorPick: TColor;
begin
   result := SelectedColorPanel.Color
end;

procedure TColorPickerDlg.wColorPick (c: TColor);
begin
   SelectedColorPanel.Color := c;
   RedValueLabel.Caption := format ('%d', [c and $ff]);
   GreenValueLabel.Caption := format ('%d', [(c shr 8) and $ff]);
   BlueValueLabel.Caption := format ('%d', [(c shr 16) and $ff])
end;

procedure TColorPickerDlg.SaveColor;
begin
   revert_color := ColorPick
end;

procedure TColorPickerDlg.RevertColor;
begin
   ColorPick := revert_color
end;

procedure TColorPickerDlg.UpdateDialogPreview;
   begin
      { base dialogs have no preview other than SelectedColorPanel (handled in       }
      {    wColorPick above), but descendant classes might implement something more. }
   end;

procedure TColorPickerDlg.FormDeactivate(Sender: TObject);
begin
   if (ModalResult <> mrOK)
      and
      (ColorPick <> old_color)
   then
      begin
         ColorPick := old_color;
         fire_color_change_event
      end
end;

end.
