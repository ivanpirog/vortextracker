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

unit Hybrid_BSC_HSL_ColorPickerDlgUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BSC_ColorPickerDlgUnit, ExtCtrls, StdCtrls, StrUtils;

type
  THybrid_BSC_HSL_ColorPickerDlg_Mode =
    (BSC_Only_ColorPicker_Mode, HSL_Only_ColorPicker_Mode, Any_Colorpicker_Mode);
  THybrid_BSC_HSL_ColorPickerDlg = class(TBSC_ColorPickerDlg)
    AllowedColorsModeRadioGroup: TRadioGroup;
    HSLColorPickerGroupBox: TGroupBox;
    HSLValuesLabel: TLabel;
    LumPanel: TPanel;
    LumSliderPanel: TPanel;
    LumSliderImage: TImage;
    LumArrowImage: TImage;
    LumLeftSidePanel: TPanel;
    LumImage: TImage;
    LumMarkerShape: TShape;
    HueSaturationPanel: TPanel;
    HueSliderPanel: TPanel;
    HueSliderImage: TImage;
    HueArrowImage: TImage;
    HueSaturationImagePanel: TPanel;
    HueSaturationImage: TImage;
    HueSaturationMarkerShape: TShape;
    SatSliderPanel: TPanel;
    SatSliderImage: TImage;
    SatArrowImage: TImage;
    UpdateDisplayTimer: TTimer;
    HexColor: TEdit;
    Label5: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure HueSaturationImageMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HueSaturationImageMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure HueArrowImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HueArrowImageMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure HueSliderImageMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SatArrowImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SatArrowImageMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure SatSliderImageMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LumArrowImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LumArrowImageMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure LumSliderImageMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LumImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LumImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure HandleMouseUp (Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AllowedColorsModeRadioGroupClick(Sender: TObject);
    procedure UpdateDisplayTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HexColorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    mouse_state: integer;
    grab_pt: integer;
    grab_pt_value: real;
    last_update_display_color: TColor;
    mode: THybrid_BSC_HSL_ColorPickerDlg_Mode;

    procedure set_HSL;

    function rH: real;
    procedure wH (hue: real);
    property H: real read rH write wH;

    function rS: real;
    procedure wS (sat: real);
    property S: real read rS write wS;

    function rL: real;
    procedure wL (lum: real);
    property L: real read rL write wL;

    procedure calculate_sizes;
    procedure display_luminosity_range;
    procedure regenerate_hue_saturation_image;
    procedure display_HSL_values;

  public
    HSBitmapRegenerationExpected: boolean;
    function Execute (Mode: THybrid_BSC_HSL_ColorPickerDlg_Mode): boolean;
    procedure generate_new_hue_saturation_bitmap (fn: string);
  end;

var
  Hybrid_BSC_HSL_ColorPickerDlg: THybrid_BSC_HSL_ColorPickerDlg;

implementation

{$ifdef clr}
  uses Borland.Vcl.Types;
{$endif}

{----------------------------------------------------------------------}
{  The conversion algorithms for HSL color spaces are from Chapter 17  }
{  of the book Fundamentals of Interactive Computer Graphics by Foley  }
{  and van Dam, Addison-Wesley, 1982.                                  }
{----------------------------------------------------------------------}

{$R *.DFM}

const
   mouse_state_up = 0;
   mouse_state_down = 1;
   mouse_state_hue_left = 2;
   mouse_state_hue_right = 3;
   mouse_state_sat_up = 4;
   mouse_state_sat_down = 5;
   mouse_state_lum_up = 6;
   mouse_state_lum_down = 7;

const
   // Must correspond to the indexes of the Items in AllowedColorsModeRadioGroup
   AllowedColors_BSCMode = 0;
   AllowedColors_AllMode = 1;

// Delphi 2 doesn't implement assert
{$ifdef VER90}
procedure assert (b: boolean);
begin
end;
{$endif}

function iClamp (v: integer; min, max: integer): integer;
   begin
      assert (min <= max);
      result := v;
      if v < min
      then
         result := min
      else
         if v > max
         then
            result := max
   end;

function rClamp (v: real; min, max: real): real;
   begin
      assert (min <= max);
      result := v;
      if v < min
      then
         result := min
      else
         if v > max
         then
            result := max
   end;

function convert_HSL_to_RGB (H, S, L: real): TColor;   // H,S,L are 0.0 .. 1.0

   function RGB (R, G, B: real): TColor;  // R,G,B are 0.0 .. 1.0
      begin
         assert ((0 <= R) and (R <= 1));
         assert ((0 <= G) and (G <= 1));
         assert ((0 <= B) and (B <= 1));
         result := round(r*255) + (round(g*255) shl 8) + (round(b*255) shl 16)
      end;

   var
      t1, t2: real;

   function convert (t3: real): real;
      begin
         if t3 < 0
         then
            t3 := t3 + 1;
         if t3 > 1
         then
            t3 := t3 - 1;
         if (6*t3) < 1
            then
               result := t1 + ((t2-t1)*6*t3)
         else if (2*t3) < 1
            then
               result := t2
         else if (3*t3) < 2
            then
               result := t1 + ((t2-t1)*((2/3)-t3)*6)
         else
            result := t1;
         assert ((0 <= result) and (result <= 1))
      end;

   begin
      assert ((0 <= H) and (H <= 1));
      assert ((0 <= S) and (S <= 1));
      assert ((0 <= L) and (L <= 1));
      if S = 0
      then
         result := RGB (L, L, L)
      else
         begin
            if L < 0.5
            then
               t2 := L * (1 + S)
            else
               t2 := L + S - (L*S);
            t1 := (2 * L) - t2;
            result := RGB (convert(H+(1/3)), convert(H), convert(H-(1/3)))
         end
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.calculate_sizes;
   procedure draw_indented_border_panel (img: TImage;
                                         indent_left, indent_top, indent_right, indent_bottom: integer
                                         // indent values are to make bitmaps appear in correct place
                                        );
      begin
         with img
         do begin
               Canvas.Brush.Color := TPanel(Parent).Color;
               Canvas.FillRect (Rect (0,0,Width,Height));
               Canvas.Pen.Color := RGB(128,128,128);
               Canvas.MoveTo (indent_left, Height-1-indent_bottom);
               Canvas.LineTo (indent_left, indent_top);
               Canvas.LineTo (Width-1-indent_right, indent_top);
               Canvas.Pen.Color := clWhite;
               Canvas.LineTo (Width-1-indent_right, Height-1-indent_bottom);
               Canvas.LineTo (indent_left, Height-1-indent_bottom)
            end
      end;
   procedure draw_horizontal_indented_border_panel (img: TImage;
                                                    caption: string;
                                                    indent_left, indent_right: integer
                                                   );
      begin
         draw_indented_border_panel (img, indent_left, 0, indent_right, 0);
         with img.Canvas
         do TextOut ((img.Width - TextWidth(caption)) div 2,
                     (img.Height - TextHeight(caption)) div 2,
                     caption
                    )
      end;
   procedure draw_vertical_indented_border_panel (img: TImage;
                                                  caption: string;
                                                  indent_top, indent_bottom: integer
                                                 );
      var
         vertical_font, old_font: HFont;
         vertical_font_info: TLogFont;
      begin
         draw_indented_border_panel (img, 0, indent_top, 0, indent_bottom);

         img.Canvas.Font.Name := 'Arial';
         img.Canvas.Font.Size := 8;
         {$ifdef clr}
         if GetObject (img.Canvas.Font.Handle, sizeOf (vertical_font_info), vertical_font_info) = 0
         {$else}
         if GetObject (img.Canvas.Font.Handle, sizeOf (vertical_font_info), @vertical_font_info) = 0
         {$endif}
         then
            raise Exception.Create ('cant create vertical font');
         vertical_font_info.lfEscapement := 900;
         vertical_font_info.lfOrientation := 900;
         vertical_font_info.lfQuality := PROOF_QUALITY;
         vertical_font := CreateFontIndirect (vertical_font_info);
         assert (vertical_font <> 0);
         old_font := SelectObject (img.Canvas.Handle, vertical_font);
         assert (old_font <> 0);
         img.Canvas.TextOut (((img.Width - img.Canvas.TextHeight(caption)) div 2) + 1,
                             (img.Height + img.Canvas.TextWidth(caption)) div 2,
                             caption
                            );
         old_font := SelectObject (img.Canvas.Handle, old_font);
         assert (old_font <> 0);
         DeleteObject (vertical_font)
      end;
   begin
      HSLColorPickerGroupBox.Left := 0;
      HSLColorPickerGroupBox.Top := 0;
      HSLColorPickerGroupBox.Width := ColorPickerPanel.Width;
      HSLColorPickerGroupBox.Height := ColorPickerPanel.Height;

      LumPanel.Left := HSLColorPickerGroupBox.Width - 68;
      LumPanel.Top := 16;
      LumPanel.Width := 50;
      LumPanel.Height := HSLColorPickerGroupBox.Height - 39;

      HueSaturationPanel.Left := 8;
      HueSaturationPanel.Top := 16;
      HueSaturationPanel.Width := LumPanel.Left - 23;
      HueSaturationPanel.Height := HSLColorPickerGroupBox.Height - 56;

      HueSaturationImagePanel.Left := 8;
      HueSaturationImagePanel.Top := 12;
      HueSaturationImagePanel.Width := HueSaturationPanel.Width - 25;
      HueSaturationImagePanel.Height := HueSaturationPanel.Height - 29;

      HueSaturationImage.Left := 0;
      HueSaturationImage.Top := 0;
      HueSaturationImage.Width := HueSaturationImagePanel.Width;
      HueSaturationImage.Height := HueSaturationImagePanel.Height;

      HueSliderPanel.Left := 0;
      HueSliderPanel.Top := HueSaturationPanel.Height - 17;
      HueSliderPanel.Width := HueSaturationPanel.Width - 9;
      HueSliderPanel.Height := 17;

      HueSliderImage.Left := 0;
      HueSliderImage.Top := 0;
      HueSliderImage.Width := HueSliderPanel.Width;
      HueSliderImage.Height := HueSliderPanel.Height;

      HueArrowImage.Top := 0;

      SatSliderPanel.Left := HueSaturationPanel.Width - 17;
      SatSliderPanel.Top := 0;
      SatSliderPanel.Width := 17;
      SatSliderPanel.Height := HueSaturationPanel.Height - 13;

      SatSliderImage.Left := 0;
      SatSliderImage.Top := 0;
      SatSliderImage.Width := SatSliderPanel.Width;
      SatSliderImage.Height := SatSliderPanel.Height;

      SatArrowImage.Left := 0;

      LumSliderPanel.Left := LumPanel.Width - 17;
      LumSliderPanel.Top := 0;
      LumSliderPanel.Width := 17;
      LumSliderPanel.Height := LumPanel.Height;

      LumSliderImage.Left := 0;
      LumSliderImage.Top := 0;
      LumSliderImage.Width := LumSliderPanel.Width;
      LumSliderImage.Height := LumSliderPanel.Height;

      LumLeftSidePanel.Left := 0;
      LumLeftSidePanel.Top := 0;
      LumLeftSidePanel.Width := LumPanel.Width - LumSliderPanel.Width;
      LumLeftSidePanel.Height := LumPanel.Height;

      LumImage.Left := 0;
      LumImage.Top := 12;
      LumImage.Width := LumLeftSidePanel.Width;
      LumImage.Height := LumLeftSidePanel.Height - 29;

      LumMarkerShape.Left := (LumImage.Width div 2) - 2;

      LumArrowImage.Left := 0;

      HSLValuesLabel.Left := (HSLColorPickerGroupBox.Width - HSLValuesLabel.Width) div 2;
      HSLValuesLabel.Top := HSLColorPickerGroupBox.Height - 25;

      draw_horizontal_indented_border_panel (HueSliderImage, 'Hue', 8, 8);
      draw_vertical_indented_border_panel (SatSliderImage, 'Saturation', 12, 5);
      draw_vertical_indented_border_panel (LumSliderImage, 'Brightness', 12, 17);
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.FormActivate (Sender: TObject);
   begin
      old_color := ColorPick;
      calculate_sizes;

      case Mode of
         BSC_Only_ColorPicker_Mode:
            begin
               AllowedColorsModeRadioGroup.Visible := false;
               AllowedColorsModeRadioGroup.ItemIndex := AllowedColors_BSCMode
            end;
         HSL_Only_ColorPicker_Mode:
            begin
               AllowedColorsModeRadioGroup.Visible := false;
               AllowedColorsModeRadioGroup.ItemIndex := AllowedColors_AllMode
            end;
         Any_Colorpicker_Mode:
            begin
               AllowedColorsModeRadioGroup.Visible := true
            end
      end;

      AllowedColorsModeRadioGroup.Visible := Mode = Any_Colorpicker_Mode;

      if AllowedColorsModeRadioGroup.ItemIndex = AllowedColors_BSCMode
      then
         begin
            HSLColorPickerGroupBox.Visible := false;
            BSCColorPickerGroupBox.Visible := true;
            bscFormActivate
         end
      else
         begin
            HSLColorPickerGroupBox.Visible := true;
            BSCColorPickerGroupBox.Visible := false;
            set_HSL;
            display_luminosity_range
         end;
      UpdateDialogPreview;

      // this part must be last within FormActivate to ensure that the possible exception is harmless
      with HueSaturationImage
      do if (Width <> Picture.Bitmap.Width)
            or
            (Height <> Picture.Bitmap.Height)
         then
            begin
               regenerate_hue_saturation_image;
               {if not HSBitmapRegenerationExpected
               then
                  raise Exception.Create ('Hue/Image Bitmap Size Problem - contact program vendor')
                     // If you are seeing this exception, please consult the documentation about
                     //    "Regenerating the Hue/Saturation Color Map Bitmap".}
            end
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.FormPaint (Sender: TObject);
   begin
      if AllowedColorsModeRadioGroup.ItemIndex = AllowedColors_BSCMode
      then
         inherited
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.OKBtnClick (Sender: TObject);
   begin
      inherited;
      if UpdateDisplayTimer.Enabled
         and
         (last_update_display_color <> ColorPick)
      then
         fire_color_change_event;
      UpdateDisplayTimer.Enabled := false;
      mouse_state := mouse_state_up
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.CancelBtnClick (Sender: TObject);
   begin
      inherited;
      UpdateDisplayTimer.Enabled := false;
      mouse_state := mouse_state_up
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.HueSaturationImageMouseDown
                                            (Sender: TObject;
                                             Button: TMouseButton;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   var
      clicked_color: TColor;
   begin
      mouse_state := mouse_state_down;
      X := iClamp (X, 0, HueSaturationImage.Width-1);
      Y := iClamp (Y, 0, HueSaturationImage.Height-1);
      H := X / (HueSaturationImage.Width-1);
      S := 1 - (Y / (HueSaturationImage.Height-1));
      clicked_color := convert_HSL_to_RGB (H, S, L);
      if ColorPick <> clicked_color
      then
         begin
            ColorPick := clicked_color;
            fire_color_change_event;
            UpdateDialogPreview;
            display_luminosity_range;
            last_update_display_color := ColorPick
         end;
      UpdateDisplayTimer.Enabled := true
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.HueSaturationImageMouseMove
                                            (Sender: TObject;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   begin
      if mouse_state = mouse_state_down
      then
         begin
            X := iClamp (X, 0, HueSaturationImage.Width-1);
            Y := iClamp (Y, 0, HueSaturationImage.Height-1);
            H := X / (HueSaturationImage.Width-1);
            S := 1 - (Y / (HueSaturationImage.Height-1));
            ColorPick := convert_HSL_to_RGB (H, S, L);
         end
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.HueArrowImageMouseDown
                                            (Sender: TObject;
                                             Button: TMouseButton;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   begin
      mouse_state := mouse_state_down;
      grab_pt := X;
      last_update_display_color := ColorPick;
      UpdateDisplayTimer.Enabled := true
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.HueArrowImageMouseMove
                                            (Sender: TObject;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   begin
      if mouse_state = mouse_state_down
      then
         begin
            H := rClamp (H + ((X-grab_pt) / (HueSaturationImage.Width-1)), 0, 1);
            ColorPick := convert_HSL_to_RGB (H, S, L)
         end
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.HueSliderImageMouseDown
                                            (Sender: TObject;
                                             Button: TMouseButton;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   begin
      if X > HueArrowImage.Left
      then
         begin
            H := H + (1 / HueSaturationImage.Width);
            mouse_state := mouse_state_hue_left
         end
      else
         begin
            H := H - (1 / HueSaturationImage.Width);
            mouse_state := mouse_state_hue_right
         end;
      ColorPick := convert_HSL_to_RGB (H, S, L);
      display_luminosity_range;
      fire_color_change_event;
      UpdateDialogPreview;
      UpdateDisplayTimer.Enabled := true
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.SatArrowImageMouseDown
                                            (Sender: TObject;
                                             Button: TMouseButton;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   begin
      mouse_state := mouse_state_down;
      grab_pt := SatArrowImage.Top + Y;
      grab_pt_value := S;
      last_update_display_color := ColorPick;
      UpdateDisplayTimer.Enabled := true
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.SatArrowImageMouseMove
                                            (Sender: TObject;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   begin
      if mouse_state = mouse_state_down
      then
         begin
            S := rClamp (grab_pt_value + ((grab_pt - (SatArrowImage.Top + Y)) / (HueSaturationImage.Height-1)), 0, 1);
            ColorPick := convert_HSL_to_RGB (H, S, L)
         end
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.SatSliderImageMouseDown
                                            (Sender: TObject;
                                             Button: TMouseButton;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   begin
      if Y > SatArrowImage.Top
      then
         begin
            S := S - (1 / HueSaturationImage.Height);
            mouse_state := mouse_state_sat_down
         end
      else
         begin
            S := S + (1 / HueSaturationImage.Height);
            mouse_state := mouse_state_sat_up
         end;
      ColorPick := convert_HSL_to_RGB (H, S, L);
      display_luminosity_range;
      fire_color_change_event;
      UpdateDialogPreview;
      UpdateDisplayTimer.Enabled := true
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.LumImageMouseDown
                                            (Sender: TObject;
                                             Button: TMouseButton;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   var
      clicked_color: TColor;
   begin
      mouse_state := mouse_state_down;
      Y := iClamp (Y, 0, LumImage.Height-1);
      L := 1 - (Y / (LumImage.Height-1));
      clicked_color := convert_HSL_to_RGB (H, S, L);
      if ColorPick <> clicked_color
      then
         begin
            ColorPick := clicked_color;
            fire_color_change_event;
            UpdateDialogPreview;
            display_luminosity_range;
            last_update_display_color := Color
         end;
      UpdateDisplayTimer.Enabled := true
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.LumImageMouseMove
                                            (Sender: TObject;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   begin
      if mouse_state = mouse_state_down
      then
         begin
            Y := iClamp (Y, 0, LumImage.Height-1);
            L := 1 - (Y / (LumImage.Height-1));
            ColorPick := convert_HSL_to_RGB (H, S, L)
         end
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.LumArrowImageMouseDown
                                            (Sender: TObject;
                                             Button: TMouseButton;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   begin
      mouse_state := mouse_state_down;
      grab_pt := LumArrowImage.Top + Y;
      grab_pt_value := L;
      last_update_display_color := ColorPick;
      UpdateDisplayTimer.Enabled := true
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.LumArrowImageMouseMove
                                            (Sender: TObject;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   begin
      if mouse_state = mouse_state_down
      then
         begin
            L := rClamp (grab_pt_value - (((LumArrowImage.Top + Y) - grab_pt) / (LumImage.Height-1)), 0, 1);
            ColorPick := convert_HSL_to_RGB (H, S, L)
         end
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.LumSliderImageMouseDown
                                            (Sender: TObject;
                                             Button: TMouseButton;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   begin
      if Y > LumArrowImage.Top
      then
         begin
            L := L - (1 / LumImage.Height);
            mouse_state := mouse_state_lum_down
         end
      else
         begin
            L := L + (1 / LumImage.Height);
            mouse_state := mouse_state_lum_up
         end;
      ColorPick := convert_HSL_to_RGB (H, S, L);
      fire_color_change_event;
      UpdateDialogPreview;
      UpdateDisplayTimer.Enabled := true
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.HandleMouseUp
                                            (Sender: TObject;
                                             Button: TMouseButton;
                                             Shift: TShiftState;
                                             X, Y: Integer
                                            );
   begin
      if mouse_state <> mouse_state_down
      then
         UpdateDisplayTimer.Enabled := false;
      mouse_state := mouse_state_up
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.AllowedColorsModeRadioGroupClick (Sender: TObject);
   begin
      case AllowedColorsModeRadioGroup.ItemIndex of
         AllowedColors_BSCMode:
            begin
               bscActivate;
               BSCColorPickerGroupBox.Visible := true;
               HSLColorPickerGroupBox.Visible := false
            end;
         AllowedColors_AllMode:
            begin
               BSCColorPickerGroupBox.Visible := false;
               HSLColorPickerGroupBox.Visible := true;
               set_HSL;
               display_luminosity_range
            end
      end
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.UpdateDisplayTimerTimer (Sender: TObject);
   procedure update_display;
      begin
         display_luminosity_range;
         fire_color_change_event;
         UpdateDialogPreview;
      end;
   begin
      case mouse_state of
         mouse_state_up:
            UpdateDisplayTimer.Enabled := false;
         mouse_state_down:
            if last_update_display_color <> ColorPick
            then
               begin
                  update_display;
                  last_update_display_color := ColorPick
               end;
         mouse_state_hue_left:
            begin
               H := rClamp (H + (1 / HueSaturationImage.Width), 0, 1);
               update_display
            end;
         mouse_state_hue_right:
            begin
               H := rClamp (H - (1 / HueSaturationImage.Width), 0, 1);
               update_display
            end;
         mouse_state_sat_up:
            begin
               S := rClamp (S + (1 / HueSaturationImage.Height), 0, 1);
               update_display
            end;
         mouse_state_sat_down:
            begin
               S := rClamp (S - (1 / HueSaturationImage.Height), 0, 1);
               update_display
            end;
         mouse_state_lum_up:
            begin
               L := rClamp (L + (1 / LumImage.Height), 0, 1);
               update_display
            end;
         mouse_state_lum_down:
            begin
               L := rClamp (L - (1 / LumImage.Height), 0, 1);
               update_display
            end
      end
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.set_HSL;
   var
      r, g, b, maxcolor, mincolor, new_h: real;
   procedure get_max_min (c: real);
      begin
         if c > maxcolor
         then
            maxcolor := c;
         if c < mincolor
         then
            mincolor := c
      end;
   begin
      r := (ColorPick and $ff) / 255;
      g := ((ColorPick shr 8) and $ff) / 255;
      b := ((ColorPick shr 16) and $ff) / 255;
      maxcolor := 0;
      mincolor := 1;
      get_max_min (r);
      get_max_min (g);
      get_max_min (b);
      L := (maxcolor + mincolor) / 2;
      if maxcolor = mincolor
      then  // some kind of gray
         begin
            S := 0;
            H := 0
         end
      else
         begin
            if L < 0.5
            then
               S := (maxcolor-mincolor)/(maxcolor+mincolor)
            else
               S := (maxcolor-mincolor)/(2-maxcolor-mincolor);

            if r = maxcolor
               then new_h := ((g-b)/(maxcolor-mincolor))
            else if g = maxcolor
               then new_h := (2 + ((b-r)/(maxcolor-mincolor)))
            else  // b=maxcolor
               new_h := (4 + ((r-g)/(maxcolor-mincolor)));

            if new_h < 0
            then
               new_h := new_h + 6;

            H := new_h / 6
         end
   end;

function THybrid_BSC_HSL_ColorPickerDlg.rH: real;
   begin
      rH := (HueSaturationMarkerShape.Left+2) / (HueSaturationImage.Width-1)
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.wH (hue: real);
   var x: integer;
   begin
      assert ((0 <= hue) and (hue <= 1));
      x := round ((HueSaturationImage.Width-1) * hue);
      // fudge to get bitmaps in right place:
      HueSaturationMarkerShape.Left := x - 2;
      HueArrowImage.Left := x + 0;
      display_HSL_values
   end;

function THybrid_BSC_HSL_ColorPickerDlg.rS: real;
   begin
      rS := 1 - ((HueSaturationMarkerShape.Top+2) / (HueSaturationImage.Height-1))
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.wS (sat: real);
   var y: integer;
   begin
      assert ((0 <= sat) and (sat <= 1));
      y := round ((HueSaturationImage.Height-1) * (1-sat));
      // fudge to get bitmaps in right place:
      HueSaturationMarkerShape.Top := y - 2;
      SatArrowImage.Top := y + 4;
      display_HSL_values
   end;

function THybrid_BSC_HSL_ColorPickerDlg.rL: real;
   begin
      rL := 1 - ((LumMarkerShape.Top - LumImage.Top + 2) / (LumImage.Height-1))
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.wL (lum: real);
   var y: integer;
   begin
      assert ((0 <= lum) and (lum <= 1));
      y := round ((LumImage.Height-1) * (1-lum));
      // fudge to get bitmaps in right place:
      LumMarkerShape.Top := LumImage.Top + y - 2;
      LumArrowImage.Top := y + 4;
      display_HSL_values
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.display_luminosity_range;
   var
      i: integer;
   begin
      for i := 0 to LumImage.Height-1
      do begin
            LumImage.Canvas.Brush.Color :=
               convert_HSL_to_RGB (H, S, 1 - (i/(LumImage.Height-1)));
            LumImage.Canvas.FillRect (Rect (0, i, LumImage.Width, i+1))
         end;
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.regenerate_hue_saturation_image;
   var
      h, s: integer;
   begin
      calculate_sizes;
      with HueSaturationImage
      do begin
            Picture.Bitmap.Width := Width;
            Picture.Bitmap.Height := Height;
            for h := 0 to Width-1
            do for s := 0 to Height-1
               do Canvas.Pixels[h,s] :=
                     convert_HSL_to_RGB (h / (Width-1),
                                         1 - (s / (Height-1)),
                                         0.5
                                        )
         end
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.display_HSL_values;
   begin
     HexColor.Text := Format('%.2x%.2x%.2x', [byte(ColorPick), byte(ColorPick shr 8), byte(ColorPick shr 16)]);
      HSLValuesLabel.Caption :=
         format ('Hue = %3d°     Saturation = %3d%s     Brightness = %3d%s',
                 [round (H*360), round(S*100), '%', round(L*100), '%']
                )
   end;

function THybrid_BSC_HSL_ColorPickerDlg.Execute (Mode: THybrid_BSC_HSL_ColorPickerDlg_Mode): boolean;
   begin
      self.Mode := Mode;
      result := ShowModal = mrOk
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.generate_new_hue_saturation_bitmap (fn: string);
   begin
      regenerate_hue_saturation_image;
      HueSaturationImage.Picture.SaveToFile (fn)
   end;

procedure THybrid_BSC_HSL_ColorPickerDlg.FormCreate(Sender: TObject);
begin
   inherited;
   // Delphi 2's TImage component doesn't implement the Transparent property,
   //    setting it when available is an aesthetic improvement.
   {$ifndef VER90}
   HueArrowImage.Transparent := true;
   SatArrowImage.Transparent := true;
   LumArrowImage.Transparent := true;
   {$endif}
end;



procedure THybrid_BSC_HSL_ColorPickerDlg.HexColorKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);

const
  ValidChars: array[0..22] of string = (
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
  'a', 'b', 'c', 'd', 'e', 'f', '#'
  );

var
  i: Integer;
  Valid: Boolean;
  s, Color: string;

begin

  inherited;

  Color := HexColor.Text;
  if Trim(Color) = '' then Exit;
  if not (Length(Color) in [6, 7]) then Exit;
  if (Length(Color) = 7) and not (Color[1] = '#') then
  begin
    HexColor.Text := copy(HexColor.Text, 1, 6);
    Exit;
  end;

  Valid := True;
  for i := 1 to Length(Color) do
    if not AnsiMatchStr(Color[i], ValidChars) then
    begin
      Valid := False;
      Break;
    end;

  if not Valid then Exit;

  if Color[1] = '#' then
    s := '$00'+Color[6]+Color[7]+Color[4]+Color[5]+Color[2]+Color[3]
  else if Length(Color) = 6 then
    s := '$00'+Color[5]+Color[6]+Color[3]+Color[4]+Color[1]+Color[2];

  ColorPick := StringToColor(s);
  last_update_display_color := ColorPick;
  set_HSL;
  display_HSL_values;
  display_luminosity_range;
  fire_color_change_event;
  UpdateDialogPreview;
  UpdateDisplayTimer.Enabled := true;

end;

end.
