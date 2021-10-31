{
This is part of Vortex Tracker II project

(c)2000-2009 S.V.Bulba
Author: Sergey Bulba, vorobey@mail.khstu.ru
Support page: http://bulba.untergrund.net/

Version 2.0 and later
(c)2017-2018 Ivan Pirog, ivan.pirog@gmail.com
}

unit ExportZX;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TExpDlg = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Edit2: TEdit;
    Label3: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    RadioGroup1: TRadioGroup;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Memo1: TMemo;
    Label15: TLabel;
    LoopChk: TCheckBox;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label30: TLabel;
    procedure Edit2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ShowZXStat;
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExpDlg: TExpDlg;
  ZXCompAddr: integer = $C000;
  zxplsz, zxdtsz: word;
  ZXModSize1, ZXModSize2, blksz, TmpAddr: integer;

implementation

{$R *.DFM}

procedure TExpDlg.Edit2Change(Sender: TObject);
var
  i, j: integer;
begin
  if Edit2.Modified then
  begin
    Val(Trim(Edit2.Text), i, j);
    if j <> 0 then exit;
    Edit1.Text := IntToHex(i, 4);
    TmpAddr := i;
    ShowZXStat
  end
end;

procedure TExpDlg.Edit1Change(Sender: TObject);
var
  s: string;
  i, j: integer;
begin
  if Edit1.Modified then
  begin
    s := UpperCase(Trim(Edit1.Text));
    i := 0;
    j := 0;
    while j < Length(s) do
    begin
      Inc(j);
      if not (s[j] in ['0'..'9', 'A'..'F']) then exit;
      if s[j] in ['0'..'9'] then
        i := i * 16 + Ord(s[j]) - Ord('0')
      else
        i := i * 16 + Ord(s[j]) - Ord('A') + 10
    end;
    Edit2.Text := IntToStr(i);
    TmpAddr := i;
    ShowZXStat
  end;
end;

procedure TExpDlg.FormShow(Sender: TObject);
begin
  Edit1.Text := IntToHex(ZXCompAddr, 4);
  Edit2.Text := IntToStr(ZXCompAddr);
  TmpAddr := ZXCompAddr;
  ShowZXStat;
end;

procedure TExpDlg.ShowZXStat;
var
  i: integer;
begin
  blksz := ZXModSize1 + ZXModSize2;
  if RadioGroup1.ItemIndex <> 1 then
    inc(blksz, zxplsz + zxdtsz)
  else
    inc(blksz, 16);
  Label22.Caption := IntToHex(65536 - blksz, 4) + '):';
  i := TmpAddr and 65535;
  if i + blksz > 65536 then
    i := 65536 - blksz;
  ZXCompAddr := i;
  if ZXModSize2 = 0 then
  begin
    Label24.Caption := '----';
    Label30.Caption := '----';
  end
  else
    Label30.Caption := IntToHex(ZXModSize2, 4);
  Label14.Caption := '(' + '----' + ')';
  if RadioGroup1.ItemIndex = 1 then
  begin
    Label4.Caption := '----';
    Label6.Caption := '----';
    Label8.Caption := '----';
    Label10.Caption := '(' + '----' + ')';
    Label17.Caption := '----';
    Label19.Caption := '----';
    Label21.Caption := '----';
    Label27.Caption := IntToHex(ZXCompAddr, 4);
    if ZXModSize2 <> 0 then
      Label24.Caption := IntToHex(ZXCompAddr + ZXModSize1, 4);
  end
  else
  begin
    Label4.Caption := IntToHex(ZXCompAddr, 4);
    Label6.Caption := IntToHex(ZXCompAddr + 5, 4);
    Label8.Caption := IntToHex(ZXCompAddr + 8, 4);
    Label10.Caption := '(' + IntToHex(ZXCompAddr + 10, 4) + ')';
    if ZXModSize2 = 0 then
      Label14.Caption := '(' + IntToHex(ZXCompAddr + 11, 4) + ')';
    Label17.Caption := IntToHex(ZXCompAddr + zxplsz, 4);
    Label19.Caption := IntToHex(zxdtsz, 4);
    Label21.Caption := IntToHex(zxplsz, 4);
    Label27.Caption := IntToHex(ZXCompAddr + zxplsz + zxdtsz, 4);
    if ZXModSize2 <> 0 then
      Label24.Caption := IntToHex(ZXCompAddr + zxplsz + zxdtsz + ZXModSize1, 4);
  end;
  Label29.Caption := IntToHex(ZXModSize1, 4);
end;

procedure TExpDlg.RadioGroup1Click(Sender: TObject);
begin
  ShowZXStat
end;

end.
