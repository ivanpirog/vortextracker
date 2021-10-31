{ $Header: /MidiComp/MIDIMONP.PAS 3     28/02/01 11:24 Davec $ }

{ This demo shows how MidiInput and MidiOutput components can be used
  interactively at design time on a form.
  The monitor has one TMidiInput control whose device ID is set interactively
  at runtime using a combo box.
  Anything received on the input device, including sysex data, is displayed by
  the monitor and echoed to the selected output device. }

unit Midimonp;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, MMSystem, StdCtrls, MIDIIn, MidiOut, ExtCtrls,
  Menus, monprocs, MidiType;

type
  TForm1 = class(TForm)
	MIDIInput1: TMIDIInput;
	lstLog: TListBox;
	pnlColumnHeading: TPanel;
	MidiOutput1: TMidiOutput;
	MainMenu1: TMainMenu;
	File1: TMenuItem;
	mnuExit: TMenuItem;
	Label1: TLabel;
	cmbInput: TComboBox;
	cmbOutput: TComboBox;
	Bevel1: TBevel;
	procedure MIDIInput1MidiInput(Sender: TObject);
	procedure LogMessage(ThisEvent:TMyMidiEvent);
	procedure FormCreate(Sender: TObject);
	procedure FormResize(Sender: TObject);
	procedure FormClose(Sender: TObject; var Action: TCloseAction);
	procedure mnuExitClick(Sender: TObject);
	procedure cmbInputChange(Sender: TObject);
	procedure OpenDevs;
	procedure CloseDevs;
  private
	logItemMax: Integer;
  public
	{ Public declarations }
  end;

var
  Form1: TForm1;
  inh: HMidiIn;

implementation

{$R *.DFM}


procedure TForm1.LogMessage(ThisEvent:TMyMidiEvent);
{ Logging MIDI messages with a Windows list box is rather slow and ugly,
  but it makes the example very simple.  If you need a faster and less
  flickery log you could port the rest of Microsoft's MIDIMON.C example. }
begin
	if logItemMax > 0 then
		begin
		With lstLog.Items do
			begin
			if Count >= logItemMax then
				Delete(0);
			Add(MonitorMessageText(ThisEvent));
			end;
		end;
end;

procedure TForm1.MIDIInput1MidiInput(Sender: TObject);
var
	thisEvent: TMyMidiEvent;
begin
	with (Sender As TMidiInput) do
		begin
		while (MessageCount > 0) do
			begin

			{ Get the event as an object }
			thisEvent := GetMidiEvent;

			{ Log it }
			LogMessage(thisEvent);

			{ Echo to the output device }
			MidiOutput1.PutMidiEvent(thisEvent);

			{ Event was dynamically created by GetMyMidiEvent so must
				free it here }
			thisEvent.Free;

			end;
		end;
end;

procedure TForm1.OpenDevs;
begin
	{ Use selected devices }
	MidiInput1.ProductName := cmbInput.Text;
	MidiOutput1.ProductName := cmbOutput.Text;
	{ Open devices }
        { DEBUG }
	MidiInput1.Open;
	MidiInput1.Start;
	MidiOutput1.Open;
end;

procedure TForm1.CloseDevs;
begin
	MidiInput1.Close;
	MidiOutput1.Close;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
	thisDevice: Word;
begin
     Cursor := crHourglass;

	{ Load the lists of installed MIDI devices }
	cmbInput.Clear;
	for thisDevice := 0 To MidiInput1.NumDevs - 1 do
		begin
		MidiInput1.DeviceID := thisDevice;
		cmbInput.Items.Add(MidiInput1.ProductName);
		end;
	cmbInput.ItemIndex := 0;
	cmbOutput.Clear;
	for thisDevice := 0 To MidiOutput1.NumDevs - 1 do
		begin
		MidiOutput1.DeviceID := thisDevice;
		cmbOutput.Items.Add(MidiOutput1.ProductName);
		end;
	cmbOutput.ItemIndex := 0;
	OpenDevs;

     Cursor := crDefault;
end;

procedure TForm1.FormResize(Sender: TObject);
const
	logMargin = 8;
begin
	{ Set maximum items that can be stored in the list box without scrolling }
	if lstLog.ItemHeight > 0 then
		begin
		logItemMax := (lstLog.Height div lstLog.ItemHeight)-1;
		{ If there are currently more items than the max, remove them
		  otherwise the list will have scrollbars when resized }
		with lstLog.Items do
			begin
			while (Count >= logItemMax) and (Count > 0) do
				Delete(0);
				end;
			end
	else
		logItemMax := 0;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	{ This is not strictly necessary since the objects close themselves
	  when the form containing them is destroyed }
	CloseDevs;
end;

procedure TForm1.mnuExitClick(Sender: TObject);
begin
	Application.Terminate;
end;


procedure TForm1.cmbInputChange(Sender: TObject);
begin
	{ Close and reopen devices with changed device selection }
	Cursor := crHourglass;
	CloseDevs;
	OpenDevs;
    Cursor := crDefault;
end;

end.
