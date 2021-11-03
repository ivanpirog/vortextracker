{
This is part of Vortex Tracker II project

(c)2000-2009 S.V.Bulba
Author: Sergey Bulba, vorobey@mail.khstu.ru
Support page: http://bulba.untergrund.net/

Version 2.0 and later
(c)2017-2021 Ivan Pirog, ivan.pirog@gmail.com
https://github.com/ivanpirog/vortextracker
}

unit selectts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TTSSel = class(TForm)
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TSSel: TTSSel;

implementation

{$R *.dfm}

procedure TTSSel.FormCreate(Sender: TObject);
begin
  ListBox1.Items.AddObject('2nd soundchip is disabled', nil);
  ListBox1.ItemIndex := 0;
end;

procedure TTSSel.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13: ModalResult := mrOk;
    #27: ModalResult := mrCancel;
  end;
end;

procedure TTSSel.ListBox1DblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
