{ $Header: /MidiComp/MONPROCS.PAS 2     10/06/97 7:33 Davec $ }

{ Written by David Churcher <dchurcher@cix.compulink.co.uk>,
  released to the public domain. }


unit Monprocs;

interface

uses Sysutils, MidiType, Midicons;

type
	TEventNames = array[1..8] of string[24];
	TSysMsgNames = array[1..16] of string[24];
const
	EventNames: TEventNames = (
		'Note Off',
		'Note On',
		'Key Aftertouch',
		'Control Change',
		'Program Change',
		'Channel Aftertouch',
		'Pitch Bend',
		'System Message' );
		SysMsgNames: TSysMsgNames = (
		'System Exclusive',
		'MTC Quarter Frame',
		'Song Position Pointer',
		'Song Select',
		'Undefined',
		'Undefined',
		'Tune Request',
		'System Exclusive End',
		'Timing Clock',
		'Undefined',
		'Start',
		'Continue',
		'Stop',
		'Undefined',
		'Active Sensing',
		'System Reset');

	format3 = '%4.4x%4.4x   %2.2x       %2.2x    %2.2x     %s';
	format2 = '%4.4x%4.4x   %2.2x       %2.2x           %s';
	format1 = '%4.4x%4.4x   %2.2x                    %s';

	function BinaryToHexList( bin: PChar; binSize: Word ): String;
	function MonitorMessageText( ThisEvent: TMyMidiEvent ): String;

implementation

function BinaryToHexList( bin: PChar; binSize: Word ): String;
var
	ctr: Word;
	thisChar: Char;
begin
	if binSize > 200 then
		binSize := 200;

	Result := '';
	for ctr := 0 to binSize-1 do
	begin
		thisChar := bin^;
		Result := Result + Format('%2.2x ', [Integer(thisChar)]);
		Inc(bin);
	end;
end;

{ Converts MIDI event to text description. Straight out of Microsoft MIDIMON example }
function MonitorMessageText( ThisEvent: TMyMidiEvent ): String;
var
	bStatus: Byte;
	EventDesc: String;
	TimeLow: Word;
	TimeHigh: Word;
begin
	bStatus := ThisEvent.MidiMessage And $f0;
	TimeHigh := Word(ThisEvent.Time Div 65536);
	TimeLow := Word(ThisEvent.Time MOD 65536);

	EventDesc := 'Unrecognized MIDI Event';

	case bStatus of

	{ 3-byte events }
	MIDI_NOTEOFF,
	MIDI_NOTEON,
	MIDI_KEYAFTERTOUCH,
	MIDI_CONTROLCHANGE,
	MIDI_PITCHBEND:
		begin
			{ Note on with velocity of 0 is a Note Off }
{			if (bStatus = MIDI_NOTEON) And (ThisEvent.Data2 = 0) then
				bStatus := MIDI_NOTEOFF; }
			EventDesc := Format(format3,
				[TimeHigh, TimeLow,
				ThisEvent.MidiMessage,
				ThisEvent.Data1,
				ThisEvent.Data2,
				EventNames[ ((ThisEvent.MidiMessage-$80) Div 16) + 1 ]]);
		end;
	{ 2-byte events }
	MIDI_PROGRAMCHANGE,
	MIDI_CHANAFTERTOUCH:
		begin
			EventDesc := Format(format2,[TimeHigh, TimeLow,
				ThisEvent.MidiMessage,
				ThisEvent.Data1,
				EventNames[ ((ThisEvent.MidiMessage-$80) Div 16) + 1 ]]);
		end;

	{ System events $f0-$ff }
	MIDI_BEGINSYSEX:
		begin
			case ThisEvent.MidiMessage of
			MIDI_BEGINSYSEX:
				EventDesc := Format('Sysex (%d): ', [ThisEvent.SysexLength]) +
					BinaryToHexList(PWideChar(ThisEvent.Sysex), ThisEvent.SysexLength);

			{2-byte system events}
			MIDI_MTCQUARTERFRAME,
			MIDI_SONGSELECT:
				EventDesc := Format(format1,[TimeHigh, TimeLow,
									ThisEvent.MidiMessage,
					ThisEvent.Data1,
					SysMsgNames[ (ThisEvent.MidiMessage And $f) +1 ]]);

			{3-byte system events}
			MIDI_SONGPOSPTR:
				EventDesc := Format(format3,[TimeHigh, TimeLow,
					ThisEvent.MidiMessage,
					ThisEvent.Data1,
					ThisEvent.Data2,
					SysMsgNames[ (ThisEvent.MidiMessage And $f) +1 ]]);

			{1-byte system events}
			else
				EventDesc := Format(format1,[TimeHigh, TimeLow,
					ThisEvent.MidiMessage,
					SysMsgNames[ (ThisEvent.MidiMessage And $f) +1 ]]);
			end;
		end;
	end;
	Result := EventDesc;
end;

end.
