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

unit HSL_ColorPickerDlgUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Hybrid_BSC_HSL_ColorPickerDlgUnit, ExtCtrls, StdCtrls;

type
  THSL_ColorPickerDlg = class(THybrid_BSC_HSL_ColorPickerDlg)
  public
    function Execute: boolean;
  end;

var
  HSL_ColorPickerDlg: THSL_ColorPickerDlg;

implementation

{$R *.DFM}

function THSL_ColorPickerDlg.Execute: boolean;
  begin
    result := inherited Execute (HSL_Only_ColorPicker_Mode)
  end;

end.
