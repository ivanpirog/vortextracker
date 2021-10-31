{
This is part of Vortex Tracker II project

(c)2000-2009 S.V.Bulba
Author: Sergey Bulba, vorobey@mail.khstu.ru
Support page: http://bulba.untergrund.net/

Version 2.0 and later
(c)2017-2019 Ivan Pirog, ivan.pirog@gmail.com
}

unit About;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    OKButton: TButton;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    line1: TGroupBox;
    line2: TGroupBox;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.DFM}

uses Main;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  Version.Caption := HalfVersString
end;

end.
