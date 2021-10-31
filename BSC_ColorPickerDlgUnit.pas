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

unit BSC_ColorPickerDlgUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ColorPickerDlgUnit, ExtCtrls, StdCtrls;

type
  TPredominantColorCategory = (pccWhite, pccRed, pccYellow, pccGreen, pccCyan, pccBlue, pccMagenta);
  TBrowserSafeColorIntensity = 0..5;
  TBrowserSafeColor =
    class
      procedure set_closest_safe_color (color: TColor);
      procedure set_color (Category: TPredominantColorCategory; Intensity: TBrowserSafeColorIntensity; col, row: TBrowserSafeColorIntensity);
      function Color: TColor;
    private
      PredominantColorCategory: TPredominantColorCategory;
      PredominantColorIntensity: TBrowserSafeColorIntensity;
      ShadeCol: TBrowserSafeColorIntensity;
      ShadeRow: TBrowserSafeColorIntensity;
      procedure calc_rgb (var r,g,b: TBrowserSafeColorIntensity);
    end;

type
  TBSC_ColorPickerDlg = class(TColorPickerDlg)
    BSCColorPickerGroupBox: TGroupBox;
    OuterSpacerPanel: TPanel;
    PredominantColorGroupBox: TGroupBox;
    PredominantColorImage: TImage;
    GapSpacerPanel: TPanel;
    ShadeColorGroupBox: TGroupBox;
    ShadeColorImage: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure PredominantColorImageMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ShadeColorImageMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    browser_safe_color, temp_color_var: TBrowserSafeColor;
    procedure calculate_sizes;
    function swatch_rect (col, row: integer): TRect;
    function swatch_border_rect (col, row: integer): TRect;
    function useful_predominant_color (col: TPredominantColorCategory; row: TBrowserSafeColorIntensity): boolean;
    procedure set_color (Category: TPredominantColorCategory; Intensity: TBrowserSafeColorIntensity; col, row: TBrowserSafeColorIntensity);
  protected
    procedure bscFormActivate;
    procedure bscActivate;
  public
    procedure SetClosestBrowserSafeColor (c: TColor);
    function Execute: Boolean;
  end;

var
  BSC_ColorPickerDlg: TBSC_ColorPickerDlg;

implementation

{$R *.DFM}

{$ifdef clr}
  uses Borland.Vcl.Types;
{$endif}

//=============
//  TBrowserSafeColor

procedure TBrowserSafeColor.calc_rgb (var r,g,b: TBrowserSafeColorIntensity);
   procedure vary1 (var c1,c2,c3: TBrowserSafeColorIntensity);
      begin
         c2 := ShadeCol;
         c3 := ShadeRow
      end;
   procedure vary2 (var c1,c2,c3: TBrowserSafeColorIntensity);
      begin
         if ShadeCol > ShadeRow
         then
            begin
               c1 := c1 - ShadeCol + ShadeRow;
               c3 := ShadeRow
            end
         else
            begin
               c2 := c1 - ShadeRow + ShadeCol;
               c3 := ShadeCol
            end
      end;
   begin
      case PredominantColorCategory of
         pccWhite:
            begin
               r := PredominantColorIntensity;
               g := PredominantColorIntensity;
               b := PredominantColorIntensity
            end;
         pccRed:
            begin
               r := PredominantColorIntensity;
               g := 0;
               b := 0;
               vary1 (r,g,b);
            end;
         pccMagenta:
            begin
               r := PredominantColorIntensity;
               g := 0;
               b := PredominantColorIntensity;
               vary2 (b,r,g)
            end;
         pccGreen:
            begin
               r := 0;
               g := PredominantColorIntensity;
               b := 0;
               vary1 (g,b,r)
            end;
         pccCyan:
            begin
               r := 0;
               g := PredominantColorIntensity;
               b := PredominantColorIntensity;
               vary2 (g,b,r)
            end;
         pccBlue:
            begin
               r := 0;
               g := 0;
               b := PredominantColorIntensity;
               vary1 (b,r,g)
            end;
         pccYellow:
            begin
               r := PredominantColorIntensity;
               g := PredominantColorIntensity;
               b := 0;
               vary2 (r,g,b)
            end
      end
   end;

procedure TBrowserSafeColor.set_closest_safe_color (color: TColor);
   var
      r,g,b: TBrowserSafeColorIntensity;
   function nearest_intensity (c: integer): TBrowserSafeColorIntensity;
      begin
         result := round (c / 51)
      end;
   procedure vary1 (pred_color: TPredominantColorCategory; c1,c2,c3: TBrowserSafeColorIntensity);
      begin
         PredominantColorCategory := pred_color;
         PredominantColorIntensity := c1;
         ShadeCol := c2;
         ShadeRow := c3
      end;
   procedure vary2 (pred_color: TPredominantColorCategory; c1,c2,c3: TBrowserSafeColorIntensity);
      begin
         PredominantColorCategory := pred_color;
         PredominantColorIntensity := c1;
         ShadeCol := c3;
         ShadeRow := c3
      end;
   begin
      r := nearest_intensity (color and $ff);
      g := nearest_intensity ((color shr 8) and $ff);
      b := nearest_intensity ((color shr 16) and $ff);
      if (r=g) and (r=b)
         then
            begin
               PredominantColorCategory := pccWhite;
               PredominantColorIntensity := r;
               ShadeCol := 0;
               ShadeRow := 0
            end
      else if (r>g) and (r>b)
         then
            vary1 (pccRed, r, g, b)
      else if (g>r) and (g>b)
         then
            vary1 (pccGreen, g, b, r)
      else if (b>r) and (b>g)
         then
            vary1 (pccBlue, b, r, g)
      else if (r=g)
         then
            vary2 (pccYellow, r, g, b)
      else if (g=b)
         then
            vary2 (pccCyan, g, b, r)
      else if (b=r)
         then
            vary2 (pccMagenta, b, r, g)
   end;

function TBrowserSafeColor.Color: TColor;
   var
      r,g,b: TBrowserSafeColorIntensity;
   begin
      calc_rgb (r,g,b);
      result := TColor ((r*51) + ((g*51) shl 8) + ((b*51) shl 16))
   end;

procedure TBrowserSafeColor.set_color (Category: TPredominantColorCategory; Intensity: TBrowserSafeColorIntensity; col, row: TBrowserSafeColorIntensity);
   begin
      PredominantColorCategory := Category;
      PredominantColorIntensity := Intensity;
      ShadeCol := col;
      ShadeRow := row
   end;


//=====================
//  TBSC_ColorPickerDlg

procedure TBSC_ColorPickerDlg.calculate_sizes;
   var
      total_image_hts, pred_image_ht, shade_image_ht: integer;
   begin
      total_image_hts := ColorPickerPanel.Height - 115;
      pred_image_ht := (total_image_hts * 6 div 11) - 1;
      shade_image_ht := total_image_hts - pred_image_ht;

      BSCColorPickerGroupBox.Left := 0;
      BSCColorPickerGroupBox.Top := 0;
      BSCColorPickerGroupBox.Width := ColorPickerPanel.Width;
      BSCColorPickerGroupBox.Height := ColorPickerPanel.Height;

      OuterSpacerPanel.Left := 16;
      OuterSpacerPanel.Top := 24;
      OuterSpacerPanel.Width := BSCColorPickerGroupBox.Width - 32;
      OuterSpacerPanel.Height := BSCColorPickerGroupBox.Height - 40;

      PredominantColorGroupBox.Left := 0;
      PredominantColorGroupBox.Top := 0;
      PredominantColorGroupBox.Width := OuterSpacerPanel.Width;
      PredominantColorGroupBox.Height := pred_image_ht + 32;

      GapSpacerPanel.Left := 0;
      GapSpacerPanel.Top := PredominantColorGroupBox.Height;
      GapSpacerPanel.Width := OuterSpacerPanel.Width;
      GapSpacerPanel.Height := 12;

      ShadeColorGroupBox.Left := 0;
      ShadeColorGroupBox.Top := PredominantColorGroupBox.Height + GapSpacerPanel.Height;
      ShadeColorGroupBox.Width := OuterSpacerPanel.Width;
      ShadeColorGroupBox.Height := shade_image_ht + 31;

      PredominantColorImage.Left := 8;
      PredominantColorImage.Top := 24;
      PredominantColorImage.Width := PredominantColorGroupBox.Width - 16;
      PredominantColorImage.Height := pred_image_ht;

      ShadeColorImage.Left := 8;
      ShadeColorImage.Top := 24;
      ShadeColorImage.Width := ShadeColorGroupBox.Width - 16;
      ShadeColorImage.Height := shade_image_ht;

      pred_image_ht := ((PredominantColorImage.Height + ShadeColorImage.Height) * 6 div 11) - 1;
      PredominantColorGroupBox.Height :=
         (PredominantColorGroupBox.Height - PredominantColorImage.Height) + pred_image_ht
   end;

procedure TBSC_ColorPickerDlg.FormCreate(Sender: TObject);
   begin
      browser_safe_color := TBrowserSafeColor.Create;
      temp_color_var := TBrowserSafeColor.Create;
      inherited
   end;

procedure TBSC_ColorPickerDlg.FormDestroy(Sender: TObject);
   begin
      browser_safe_color.Free;
      temp_color_var.Free;
      inherited
   end;

procedure TBSC_ColorPickerDlg.FormActivate(Sender: TObject);
   begin
      old_color := ColorPick;
      bscFormActivate;
      UpdateDialogPreview
   end;

procedure TBSC_ColorPickerDlg.bscFormActivate;
   begin
      calculate_sizes;
      browser_safe_color.set_closest_safe_color (ColorPick);
      if browser_safe_color.Color <> ColorPick
      then
         begin
            ColorPick := browser_safe_color.Color;
            fire_color_change_event
         end
   end;

procedure TBSC_ColorPickerDlg.bscActivate;
   begin
      browser_safe_color.set_closest_safe_color (ColorPick);
      if browser_safe_color.Color <> ColorPick
      then
         begin
            ColorPick := browser_safe_color.Color;
            fire_color_change_event;
            UpdateDialogPreview
         end;
      Repaint
   end;

function TBSC_ColorPickerDlg.useful_predominant_color (col: TPredominantColorCategory; row: TBrowserSafeColorIntensity): boolean;
   // this marks as unuseful all the black swatches except the main one in the white column
   begin
      result := not ((col <> pccWhite)
                     and
                     (row = low(TBrowserSafeColorIntensity))
                    )
   end;

function TBSC_ColorPickerDlg.swatch_rect (col, row: integer): TRect;
   const
      margin = 3;
   begin
      result := swatch_border_rect (col, row);
      result.Left := result.Left + margin;
      result.Right := result.Right - margin;
      result.Top := result.Top + margin;
      result.Bottom := result.Bottom - margin
   end;

function TBSC_ColorPickerDlg.swatch_border_rect (col, row: integer): TRect;
   begin
      result.Left := trunc (ord(col) * PredominantColorImage.Width / (ord(high(TPredominantColorCategory))+1));
      result.Right := trunc ((ord(col)+1) * PredominantColorImage.Width / (ord(high(TPredominantColorCategory))+1));
      result.Top := trunc (row * PredominantColorImage.Height / (high(TBrowserSafeColorIntensity) + 1));
      result.Bottom := trunc ((row+1) * PredominantColorImage.Height / (high(TBrowserSafeColorIntensity) + 1));
   end;

procedure TBSC_ColorPickerDlg.FormPaint(Sender: TObject);
   procedure paint_predominant_color_area;
      var
         col: TPredominantColorCategory;
         row: TBrowserSafeColorIntensity;
      begin
         with PredominantColorImage.Canvas
         do begin
               Brush.Color := clWhite;
               FillRect (Rect (0, 0, PredominantColorImage.Width, PredominantColorImage.Height));
               for col := low(TPredominantColorCategory) to high(TPredominantColorCategory)
               do for row := low(TBrowserSafeColorIntensity) to high(TBrowserSafeColorIntensity)
                  do if useful_predominant_color (col, row)
                     then
                        begin
                           if (browser_safe_color.PredominantColorCategory = col)
                              and
                              (browser_safe_color.PredominantColorIntensity = row)
                           then
                              begin
                                 Brush.Color := clBlack;
                                 FillRect (swatch_border_rect (ord(col), high(TBrowserSafeColorIntensity)-row))
                              end;
                           temp_color_var.set_color (col, row, 0, 0);
                           Brush.Color := temp_color_var.color;
                           FillRect (swatch_rect (ord(col), high(TBrowserSafeColorIntensity)-row))
                        end
                     else
                        begin
                           Brush.Color := PredominantColorGroupBox.Color;
                           FillRect (swatch_border_rect (ord(col), high(TBrowserSafeColorIntensity)-row))
                        end
            end;

         ShadeColorGroupBox.Visible :=
            (browser_safe_color.PredominantColorCategory <> pccWhite)
            and
            (browser_safe_color.PredominantColorIntensity > 1)
      end;
   procedure paint_shade_color_area;
      var
         col, row: TBrowserSafeColorIntensity;
      begin
         with ShadeColorImage.Canvas
         do begin
               Brush.Color := ShadeColorGroupBox.Color;
               FillRect (Rect (0, 0, ShadeColorImage.Width, ShadeColorImage.Height));
               for col := 0 to browser_safe_color.PredominantColorIntensity-1
               do for row := 0 to browser_safe_color.PredominantColorIntensity-1
                  do begin
                        if (col = browser_safe_color.ShadeCol) and (row = browser_safe_color.ShadeRow)
                        then
                           Brush.Color := clBlack
                        else
                           Brush.Color := clWhite;
                        FillRect (swatch_border_rect (col, row));

                        temp_color_var.set_color (browser_safe_color.PredominantColorCategory, browser_safe_color.PredominantColorIntensity, col, row);
                        Brush.Color := temp_color_var.Color;
                        FillRect (swatch_rect (col, row))
                     end
            end
      end;
   begin   // FormPaint
      inherited;
      paint_predominant_color_area;
      if ShadeColorGroupBox.Visible
      then
         paint_shade_color_area
   end;   // FormPaint

procedure TBSC_ColorPickerDlg.PredominantColorImageMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
   var
      col: TPredominantColorCategory;
      row: TBrowserSafeColorIntensity;
      r: TRect;
   begin
      for col := low(TPredominantColorCategory) to high(TPredominantColorCategory)
      do for row := low(TBrowserSafeColorIntensity) to high(TBrowserSafeColorIntensity)
         do if useful_predominant_color (col, row)
            then
               begin
                  r := swatch_border_rect (ord(col), high(TBrowserSafeColorIntensity)-row);
                  if (r.Left <= x) and (x <= r.Right)
                     and
                     (r.Top <= y) and (y <= r.Bottom)
                  then
                     begin
                        set_color (col, row, 0, 0);
                        exit
                     end
               end
   end;

procedure TBSC_ColorPickerDlg.ShadeColorImageMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
   var
      col, row: TBrowserSafeColorIntensity;
      r: TRect;
   begin
      for col := 0 to browser_safe_color.PredominantColorIntensity-1
      do for row := 0 to browser_safe_color.PredominantColorIntensity-1
         do begin
               r := swatch_border_rect (col, row);
               if (r.Left <= x) and (x <= r.Right)
                  and
                  (r.Top <= y) and (y <= r.Bottom)
               then
                  begin
                     set_color (browser_safe_color.PredominantColorCategory, browser_safe_color.PredominantColorIntensity, col, row);
                     exit
                  end
            end
   end;

function TBSC_ColorPickerDlg.Execute: Boolean;
begin
   Execute := ShowModal = mrOk
end;

procedure TBSC_ColorPickerDlg.set_color (Category: TPredominantColorCategory; Intensity: TBrowserSafeColorIntensity; col, row: TBrowserSafeColorIntensity);
   begin
      browser_safe_color.set_color (Category, Intensity, col, row);
      if ColorPick <> browser_safe_color.Color
      then
         begin
            ColorPick := browser_safe_color.Color;
            fire_color_change_event;
            UpdateDialogPreview;
            Repaint
         end
   end;

procedure TBSC_ColorPickerDlg.SetClosestBrowserSafeColor (c: TColor);
   begin
      browser_safe_color.set_closest_safe_color (c);
      if Active
      then
         begin
            if ColorPick <> browser_safe_color.Color
            then
               begin
                  ColorPick := browser_safe_color.Color;
                  fire_color_change_event;
                  UpdateDialogPreview;
                  Repaint
               end
         end
      else
         ColorPick := browser_safe_color.Color
   end;

end.
