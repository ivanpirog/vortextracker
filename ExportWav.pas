{
This is part of Vortex Tracker II project

Version 2.0 and later
(c)2017-2021 Ivan Pirog, ivan.pirog@gmail.com
https://github.com/ivanpirog/vortextracker
}
unit ExportWav;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ActnList;

type
  TExport = class(TForm)
    ExportProgress: TProgressBar;
    ExportActions: TActionList;
    StopExport: TAction;

  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Export: TExport;


implementation



{$R *.dfm}


end.
