unit ExportWavOpts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, AY;

type
  TExportOptions = class(TForm)
    Chip: TRadioGroup;
    SampleRate: TRadioGroup;
    GroupBox1: TGroupBox;
    ExportNumLoops: TLabel;
    LoopRepeats: TUpDown;
    LpRepeat: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    BitRate: TRadioGroup;
    Channels: TRadioGroup;
    ExportSelected: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    function GetSampleRate: Integer;
    function GetBitRate: Integer;
    function GetNumChannels: Integer;        
    function GetChip: ChTypes;
    function GetRepeats: Integer;
  end;

var
  ExportOptions: TExportOptions;


implementation

uses main;

{$R *.dfm}

procedure TExportOptions.FormCreate(Sender: TObject);
begin
  SampleRate.ItemIndex := ExportSampleRate;
  BitRate.ItemIndex    := ExportBitRate;
  Channels.ItemIndex   := ExportChannels;
  Chip.ItemIndex       := ExportChip;
  LoopRepeats.Position := ExportRepeats;
end;


function TExportOptions.GetSampleRate: Integer;
begin
  Result := 44100;
  case ExportSampleRate of
    0: Result := 22050;
    1: Result := 44100;
    2: Result := 48000;
    3: Result := 88200;
    4: Result := 96000;
    5: Result := 192000;
  end;
end;


function TExportOptions.GetBitRate: Integer;
begin
  Result := 16;
  case ExportBitRate of
    0: Result := 16;
    1: Result := 24;
    2: Result := 32;
  end;
end;


function TExportOptions.GetNumChannels: Integer;
begin
  Result := 2;
  case ExportChannels of
    0: Result := 1;
    1: Result := 2;
  end;
end;

function TExportOptions.GetChip: ChTypes;
begin
  Result := YM_Chip;
  case ExportChip of
    0: Result := AY_Chip;
    1: Result := YM_Chip;
  end;
end;


function TExportOptions.GetRepeats: Integer;
begin
  Result := ExportRepeats;
end;


procedure TExportOptions.Button1Click(Sender: TObject);
begin
  ExportSampleRate := SampleRate.ItemIndex;
  ExportBitRate    := BitRate.ItemIndex;
  ExportChannels   := Channels.ItemIndex;
  ExportChip       := Chip.ItemIndex;
  ExportRepeats    := LoopRepeats.Position;
  ModalResult := mrOk;
end;

procedure TExportOptions.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
