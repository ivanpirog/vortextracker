{
This is part of Vortex Tracker II project

(c)2000-2009 S.V.Bulba
Author: Sergey Bulba, vorobey@mail.khstu.ru
Support page: http://bulba.untergrund.net/

Version 2.0 and later
(c)2017-2021 Ivan Pirog, ivan.pirog@gmail.com
https://github.com/ivanpirog/vortextracker
}

unit GlbTrn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TGlbTrans = class(TForm)
    GroupBox1: TGroupBox;
    CheckBox4: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    GroupBox2: TGroupBox;
    UpDown8: TUpDown;
    Edit8: TEdit;
    Label8: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit2: TEdit;
    UpDown1: TUpDown;
    Button1: TButton;
    Button2: TButton;
    procedure Edit2Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit8Exit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GlbTrans: TGlbTrans;

implementation

uses Main, Childwin, trfuncs;

{$R *.DFM}

procedure TGlbTrans.Edit2Exit(Sender: TObject);
begin
  Edit2.Text := IntToStr(UpDown1.Position)
end;

procedure TGlbTrans.FormShow(Sender: TObject);
begin
  if MainForm.MDIChildCount <> 0 then
    UpDown1.Position := TMDIChild(MainForm.ActiveMDIChild).PatNum;
  Edit8.SelectAll;
  Edit8.SetFocus
end;

procedure TGlbTrans.Edit8Exit(Sender: TObject);
begin
  Edit8.Text := IntToStr(UpDown8.Position)
end;

procedure TGlbTrans.Button1Click(Sender: TObject);
var
  i: integer;
  Chans: TChansArrayBool;
  CurrentWindow: TMDIChild;
begin
  if MainForm.MDIChildCount = 0 then exit;
  if not CheckBox1.Checked and
    not CheckBox2.Checked and
    not CheckBox3.Checked and
    not CheckBox4.Checked then exit;
  if UpDown8.Position = 0 then exit;
  CurrentWindow := TMDIChild(MainForm.ActiveMDIChild);
  Chans[0] := CheckBox1.Checked;
  Chans[1] := CheckBox2.Checked;
  Chans[2] := CheckBox3.Checked;

  if RadioButton1.Checked then
  begin
    if MessageDlg('This operation cannot be undo. Are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      CurrentWindow.DisposeUndo(True);
      for i := 0 to MaxPatNum do MainForm.TransposeColumns(CurrentWindow, i,
          CheckBox4.Checked, Chans, 0, MaxPatLen - 1, UpDown8.Position, False);
    end;
  end
  else
    MainForm.TransposeColumns(CurrentWindow, UpDown1.Position,
      CheckBox4.Checked, Chans, 0, MaxPatLen - 1, UpDown8.Position, True);
end;

procedure TGlbTrans.Button2Click(Sender: TObject);
begin
  Hide
end;

end.
