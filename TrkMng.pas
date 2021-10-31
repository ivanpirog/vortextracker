{
This is part of Vortex Tracker II project

(c)2000-2009 S.V.Bulba
Author: Sergey Bulba, vorobey@mail.khstu.ru
Support page: http://bulba.untergrund.net/

Version 2.0 and later
(c)2017-2018 Ivan Pirog, ivan.pirog@gmail.com
}

unit TrkMng;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons;

type
  TTrMng = class(TForm)
    GroupBox1: TGroupBox;
    Edit2: TEdit;
    UpDown1: TUpDown;
    Edit1: TEdit;
    UpDown2: TUpDown;
    GroupBox2: TGroupBox;
    Edit3: TEdit;
    UpDown3: TUpDown;
    Edit4: TEdit;
    UpDown4: TUpDown;
    GroupBox3: TGroupBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    GroupBox4: TGroupBox;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    GroupBox5: TGroupBox;
    SpeedButton5: TSpeedButton;
    GroupBox6: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label5: TLabel;
    Edit5: TEdit;
    UpDown5: TUpDown;
    Button1: TButton;
    Edit6: TEdit;
    UpDown6: TUpDown;
    Edit7: TEdit;
    UpDown7: TUpDown;
    GroupBox7: TGroupBox;
    Edit8: TEdit;
    UpDown8: TUpDown;
    Label8: TLabel;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure SpeedButton2Click(Sender: TObject);
    procedure TracksOp(FPat, FLin, FChn, TPat, TLin, TChn, TrOp: integer; MakeUndo: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure Transp(Pat, Lin, Chn: integer);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure UpDown6_7ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure Edit6_7KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit6_7KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TrMng: TTrMng;

implementation

uses Main, Childwin, TrFuncs;

{$R *.DFM}

procedure TTrMng.TracksOp;
var
 {FPLen,TPLen,} i, j: integer;
  cl: TChannelLine;
  OldPat: PPattern;
  Flg: boolean;
  CurrentWindow: TMDIChild;
begin
  if MainForm.MDIChildCount = 0 then exit;
  OldPat := nil;
  CurrentWindow := TMDIChild(MainForm.ActiveMDIChild);
  with CurrentWindow do
  begin
    if (VTMP.Patterns[FPat] = nil) and (VTMP.Patterns[TPat] = nil) then exit;
    ValidatePattern2(FPat);
    ValidatePattern2(TPat);
    if TrOp = 0 then
    begin
      New(OldPat); OldPat^ := VTMP.Patterns[TPat]^;
    end
    else
    begin
      if MessageDlg('This operation cannot be undone. Are you sure to continue?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then exit;
      DisposeUndo(True);
    end;
//  FPLen := VTMP.Patterns[FPat].Length;
//  TPLen := VTMP.Patterns[TPat].Length;
    Flg := False;
    for i := 0 to TrMng.UpDown5.Position - 1 do
    begin
//    if (i + FLin >= FPLen) or (i + TLin >= TPLen) then break;
    //Work with all pattern lines even if it greater then pattern length
      if (i + FLin >= MaxPatLen) or (i + TLin >= MaxPatLen) then break;
      Flg := True;
      if TrMng.CheckBox1.Checked then
      begin
        j := VTMP.Patterns[FPat].Items[i + FLin].Envelope;
        case TrOp of
          0: VTMP.Patterns[TPat].Items[i + TLin].Envelope := j;
          1: begin
              VTMP.Patterns[TPat].Items[i + TLin].Envelope := j;
              VTMP.Patterns[FPat].Items[i + FLin].Envelope := 0
            end;
          2: begin
              VTMP.Patterns[FPat].Items[i + FLin].Envelope := VTMP.Patterns[TPat].Items[i + TLin].Envelope;
              VTMP.Patterns[TPat].Items[i + TLin].Envelope := j
            end
        end
      end;
      if TrMng.CheckBox2.Checked then
      begin
        j := VTMP.Patterns[FPat].Items[i + FLin].Noise;
        case TrOp of
          0: VTMP.Patterns[TPat].Items[i + TLin].Noise := j;
          1: begin
              VTMP.Patterns[TPat].Items[i + TLin].Noise := j;
              VTMP.Patterns[FPat].Items[i + FLin].Noise := 0;
            end;
          2: begin
              VTMP.Patterns[FPat].Items[i + FLin].Noise := VTMP.Patterns[TPat].Items[i + TLin].Noise;
              VTMP.Patterns[TPat].Items[i + TLin].Noise := j;
            end
        end
      end;
      cl := VTMP.Patterns[FPat].Items[i + FLin].Channel[FChn];
      case TrOp of
        0: VTMP.Patterns[TPat].Items[i + TLin].Channel[TChn] := cl;
        1: begin
            VTMP.Patterns[TPat].Items[i + TLin].Channel[TChn] := cl;
            VTMP.Patterns[FPat].Items[i + FLin].Channel[FChn].Note := -1;
            VTMP.Patterns[FPat].Items[i + FLin].Channel[FChn].Sample := 0;
            VTMP.Patterns[FPat].Items[i + FLin].Channel[FChn].Ornament := 0;
            VTMP.Patterns[FPat].Items[i + FLin].Channel[FChn].Volume := 0;
            VTMP.Patterns[FPat].Items[i + FLin].Channel[FChn].Envelope := 0;
            VTMP.Patterns[FPat].Items[i + FLin].Channel[FChn].Additional_Command.Number := 0;
            VTMP.Patterns[FPat].Items[i + FLin].Channel[FChn].Additional_Command.Delay := 0;
            VTMP.Patterns[FPat].Items[i + FLin].Channel[FChn].Additional_Command.Parameter := 0
          end;
        2: begin
            VTMP.Patterns[FPat].Items[i + FLin].Channel[FChn] := VTMP.Patterns[TPat].Items[i + TLin].Channel[TChn];
            VTMP.Patterns[TPat].Items[i + TLin].Channel[TChn] := cl
          end
      end
    end;
    if Flg and MakeUndo then
    begin
      SongChanged := True;
      BackupSongChanged := True;
      if TrOp = 0 then
      begin
        AddUndo(CATracksManagerCopy, TPat, 0);
        ChangeList[ChangeCount - 1].Pattern := OldPat;
      end;
    end
    else if TrOp = 0 then
      Dispose(OldPat);
    if (PatNum = TPat) or (PatNum = FPat) then Tracks.RedrawTracks(0);
  end;
end;

procedure TTrMng.SpeedButton2Click(Sender: TObject);
begin
  TracksOp(UpDown1.Position, UpDown2.Position, UpDown6.Position, UpDown3.Position, UpDown4.Position, UpDown7.Position, 0, True)
end;

procedure TTrMng.SpeedButton1Click(Sender: TObject);
begin
  TracksOp(UpDown3.Position, UpDown4.Position, UpDown7.Position, UpDown1.Position, UpDown2.Position, UpDown6.Position, 0, True)
end;

procedure TTrMng.SpeedButton4Click(Sender: TObject);
begin
  TracksOp(UpDown1.Position, UpDown2.Position, UpDown6.Position, UpDown3.Position, UpDown4.Position, UpDown7.Position, 1, True)
end;

procedure TTrMng.SpeedButton3Click(Sender: TObject);
begin
  TracksOp(UpDown3.Position, UpDown4.Position, UpDown7.Position, UpDown1.Position, UpDown2.Position, UpDown6.Position, 1, True)
end;

procedure TTrMng.SpeedButton5Click(Sender: TObject);
begin
  TracksOp(UpDown1.Position, UpDown2.Position, UpDown6.Position, UpDown3.Position, UpDown4.Position, UpDown7.Position, 2, True)
end;

procedure TTrMng.Transp;
var
  Chans: TChansArrayBool;
begin
  if MainForm.MDIChildCount = 0 then exit;
  Chans[0] := False; Chans[1] := False; Chans[2] := False; Chans[Chn] := True;
  MainForm.TransposeColumns(TMDIChild(MainForm.ActiveMDIChild), Pat, CheckBox1.Checked,
    Chans, Lin, Lin + TrMng.UpDown5.Position - 1, TrMng.UpDown8.Position, True);
end;

procedure TTrMng.SpeedButton6Click(Sender: TObject);
begin
  Transp(UpDown1.Position, UpDown2.Position, UpDown6.Position)
end;

procedure TTrMng.SpeedButton7Click(Sender: TObject);
begin
  Transp(UpDown3.Position, UpDown4.Position, UpDown7.Position)
end;

procedure TTrMng.FormCreate(Sender: TObject);
begin
  UpDown5.Max := MaxPatLen;
  UpDown5.Position := MaxPatLen;
  UpDown2.Max := MaxPatLen - 1;
  UpDown4.Max := MaxPatLen - 1;
end;

procedure TTrMng.Button1Click(Sender: TObject);
begin
  Hide;
end;

procedure TTrMng.UpDown6_7ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  AllowChange := NewValue in [0..2];
  if AllowChange then
    if Sender = UpDown6 then
      Edit6.Text := Char(Ord('A') + NewValue)
    else
      Edit7.Text := Char(Ord('A') + NewValue);
end;

procedure TTrMng.Edit6_7KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  procedure SetChanUpDown(UpDown: TUpDown);
  begin
    case Key of
      VK_UP: UpDown6.Position := UpDown.Position + 1;
      VK_DOWN: UpDown6.Position := UpDown.Position - 1;
      Ord('0')..Ord('2'): UpDown.Position := Key - Ord('0');
      Ord('A')..Ord('C'): UpDown.Position := Key - Ord('A');
      VK_NUMPAD0..VK_NUMPAD2: UpDown.Position := Key - VK_NUMPAD0;
    end;
  end;

begin
  if Sender = Edit6 then
    SetChanUpDown(UpDown6)
  else
    SetChanUpDown(UpDown7);
end;

procedure TTrMng.Edit6_7KeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

end.
