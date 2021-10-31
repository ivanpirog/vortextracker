{
This is part of Vortex Tracker II project

(c)2000-2009 S.V.Bulba
Author: Sergey Bulba, vorobey@mail.khstu.ru
Support page: http://bulba.untergrund.net/

Version 2.0 and later
(c)2017-2018 Ivan Pirog, ivan.pirog@gmail.com
}

unit FXMImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFXMParams = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label6: TLabel;
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckAll;
    procedure Edit5Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FXMParams: TFXMParams;

implementation

uses trfuncs;

{$R *.dfm}

procedure TFXMParams.Edit1Change(Sender: TObject);
begin
  if Edit1.Modified then CheckAll
end;

procedure TFXMParams.Edit2Change(Sender: TObject);
begin
  if Edit2.Modified then CheckAll
end;

procedure TFXMParams.Edit3Change(Sender: TObject);
begin
  if Edit3.Modified then CheckAll
end;

procedure TFXMParams.Edit4Change(Sender: TObject);
begin
  if Edit4.Modified then CheckAll
end;

procedure TFXMParams.Edit5Change(Sender: TObject);
begin
  if Edit5.Modified then CheckAll
end;

procedure TFXMParams.Edit6Change(Sender: TObject);
begin
  if Edit6.Modified then CheckAll
end;

procedure TFXMParams.FormShow(Sender: TObject);
begin
  CheckAll
end;

procedure TFXMParams.CheckAll;
var
  flg: boolean;
  s: string;
  i, l, j: integer;
begin
  s := Trim(Edit1.Text);
  Val(s, l, j);
  flg := (j = 0) and (l > 0) and (l <= 2167500);
  if flg then
  begin
    s := Trim(Edit2.Text);
    Val(s, i, j);
    flg := (j = 0) and (i >= 0) and (i < l)
  end;
  if flg then
  begin
    s := Trim(Edit3.Text);
    Val(s, i, j);
    flg := (j = 0) and (i in [1..255])
  end;
  if flg then
  begin
    s := Trim(Edit4.Text);
    Val(s, i, j);
    flg := (j = 0) and (i > 0) and (i <= MaxPatLen)
  end;
  if flg then
  begin
    s := Trim(Edit5.Text);
    Val(s, i, j);
    flg := (j = 0) and ((i + 95) in [0..190])
  end;
  if flg then
  begin
    s := Trim(Edit6.Text);
    Val(s, i, j);
    flg := (j = 0) and (i in [0, 1, 3, 7, 15, 31])
  end;
  Button1.Enabled := Flg;
end;


end.
