{
This is part of Vortex Tracker II project

(c)2000-2009 S.V.Bulba
Author: Sergey Bulba, vorobey@mail.khstu.ru
Support page: http://bulba.untergrund.net/

Version 2.0 and later
(c)2017-2018 Ivan Pirog, ivan.pirog@gmail.com
}

unit TglSams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TToglSams = class(TForm)
    procedure CheckUsedSamples;
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ToglSams: TToglSams;
  TogSam: array[1..31] of TCheckBox;

implementation

uses Main, Childwin, trfuncs;

{$R *.dfm}


procedure TToglSams.CheckUsedSamples;
var
  PosNum, PatLine, i: Integer;
  VTMP: PModule;
  Pattern: PPattern;

begin
  if MainForm.MDIChildCount = 0 then exit;
  
  VTMP := TMDIChild(MainForm.ActiveMDIChild).VTMP;

  for i := 1 to 31 do
    TogSam[i].Enabled := False;

  for PosNum := 0 to VTMP.Positions.Length-1 do begin
    Pattern := VTMP.Patterns[VTMP.Positions.Value[PosNum]];

    for PatLine := 0 to Pattern.Length-1 do begin

      if Pattern.Items[PatLine].Channel[0].Sample > 0 then
        TogSam[Pattern.Items[PatLine].Channel[0].Sample].Enabled := True;

      if Pattern.Items[PatLine].Channel[1].Sample > 0 then
        TogSam[Pattern.Items[PatLine].Channel[1].Sample].Enabled := True;

      if Pattern.Items[PatLine].Channel[2].Sample > 0 then
        TogSam[Pattern.Items[PatLine].Channel[2].Sample].Enabled := True;

    end;

  end;


end;

procedure TToglSams.FormCreate(Sender: TObject);
var
  i, y, x: integer;
begin
  y := 8; x := 8;
  for i := 1 to 31 do
  begin
    TogSam[i] := TCheckBox.Create(Self);
    with TogSam[i] do
    begin
      Parent := Self;
      Top := y; inc(y, Height + 8);
      Left := x; if i mod 8 = 0 then begin inc(x, 40); y := 8; end;
      Caption := SampToStr(i);
      Width := 32;
      Tag := i;
      Checked := True;
      OnClick := CheckBoxClick;
    end;
  end;
  ClientWidth := 4 * 40 + 4;
  ClientHeight := 8 * (TogSam[1].Height + 8) + 8;
end;

procedure TToglSams.CheckBoxClick(Sender: TObject);
var
  sam: integer;
begin
  if MainForm.MDIChildCount = 0 then exit;
  
  with TMDIChild(MainForm.ActiveMDIChild) do
    if VTMP <> nil then
    begin
      sam := (Sender as TCheckBox).Tag;
      ValidateSample2(sam);
      VTMP.Samples[sam].Enabled := (Sender as TCheckBox).Checked;
    end;
end;


procedure TToglSams.FormShow(Sender: TObject);
begin
  CheckUsedSamples;
end;

end.
