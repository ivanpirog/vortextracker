unit TrackInf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, RichEdit, ShellAPI, trfuncs;

type

  TRichEdit = class(ComCtrls.TRichEdit)
  private
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
  protected
    procedure CreateWnd; override;
  end;

  TTrackInfoForm = class(TForm)
    Info: TRichEdit;
    OK: TButton;
    procedure OKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetRTFText(RTFText: String);
    procedure Init(VTMP: PModule);
  end;

var
  TrackInfoForm: TTrackInfoForm;

implementation

uses Main;

{$R *.dfm}


procedure TRichEdit.CreateWnd;
var
  mask: LResult;
begin
  inherited;
  mask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
  SendMessage(Handle, EM_AUTOURLDETECT, 1, 0);
end;

procedure TRichEdit.CNNotify(var Message: TWMNotify);
type
  PENLink = ^TENLink;
var
  p: PENLink;
  tr: TEXTRANGE;
  url: array of Char;
begin

  if (Message.NMHdr.code = EN_LINK) then begin
    p := PENLink(Message.NMHdr);
    if (p.Msg = WM_LBUTTONDOWN) then begin
      try
        SetLength(url, p.chrg.cpMax - p.chrg.cpMin + 1);
        tr.chrg := p.chrg;
        tr.lpstrText := PChar(url);
        SendMessage(Handle, EM_GETTEXTRANGE, 0, LPARAM(@tr));
        ShellExecute(Handle, nil, PChar(url), nil, nil, SW_SHOWNORMAL);
      except
        {ignore}
      end;
      Exit;
    end;
  end;

  inherited;
end;



procedure TTrackInfoForm.SetRTFText(RTFText: String);
var
  ss: TStringStream;
  emptystr: string;
begin
  emptystr := '';
  ss := TStringStream.Create(emptystr);
  try
    ss.WriteString(RTFText);
    ss.Position := 0;
    Info.PlainText := False;
    Info.Lines.BeginUpdate;
    Info.Lines.LoadFromStream(ss);
    Info.Lines.EndUpdate;
  finally
    ss.Free;
  end;
end;

procedure TTrackInfoForm.Init(VTMP: PModule);
var Title: String;
begin

  SetRTFText(VTMP.Info);

  Title := 'Track Info';
  if Trim(VTMP.Title) <> '' then Title := VTMP.Title;
  if Trim(VTMP.Author) <> '' then Title := Title + ' by ' + VTMP.Author;
  Caption := Title;

  Left := MainForm.Left + (MainForm.Width div 2)  - (Width div 2);
  Top  := MainForm.Top  + (MainForm.Height div 2) - (Height div 2);

end;


procedure TTrackInfoForm.OKClick(Sender: TObject);
begin
  Hide;
end;

end.
