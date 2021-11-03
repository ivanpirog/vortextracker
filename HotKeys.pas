{
This is part of Vortex Tracker II project

Version 2.0 and later
(c)2017-2021 Ivan Pirog, ivan.pirog@gmail.com
https://github.com/ivanpirog/vortextracker
}

unit HotKeys;

interface

uses ActnList, Menus, Classes, Dialogs, ComCtrls, StrUtils, Controls, SysUtils;

const
  HK_PLAY_STOP            = 0;
  HK_PLAY_FROM_LINE       = 1;
  HK_PLAY_FROM_START      = 2;
  HK_PLAY_PATT_FROM_LINE  = 3;
  HK_PLAY_PATT_FROM_START = 4;
  HK_STOP                 = 5;
  HK_LOOP_TOGGLE          = 6;
  HK_LOOP_TOGGLE_ALL      = 7;
  HK_LOOP_SET_POSITION    = 8;
  HK_POSITIONS_INSERT     = 9;
  HK_POSITIONS_DELETE     = 10;
  HK_POSITIONS_DUPLICATE  = 11;
  HK_POSITIONS_CLONE      = 12;
  HK_TOGGLE_SAMPLES       = 13;
  HK_TRACKS_MANAGER       = 14;
  HK_TOGGLE_CHIP          = 15;
  HK_TOGGLE_CHANNELS      = 16;
  HK_UNDO                 = 17;
  HK_REDO                 = 18;
  HK_TRANSPOSE_UP1        = 19;
  HK_TRANSPOSE_DOWN1      = 20;
  HK_TRANSPOSE_UP3        = 21;
  HK_TRANSPOSE_DOWN3      = 22;
  HK_TRANSPOSE_UP5        = 23;
  HK_TRANSPOSE_DOWN5      = 24;
  HK_TRANSPOSE_UP12       = 25;
  HK_TRANSPOSE_DOWN12     = 26;
  HK_EXPAND_PATTERN       = 27;
  HK_COMPRESS_PATTERN     = 28;
  HK_OPTIONS              = 29;
  HK_DUP_NOTE_PARAMS      = 30;
  HK_MOVE_BETWEEN_PATRNS  = 31;
  HK_SPLIT_PATTERN        = 32;
  HK_SWAP_CHANS_LEFT      = 33;
  HK_SWAP_CHANS_RIGHT     = 34;
  HK_JMP_PAT_START        = 35;
  HK_JMP_PAT_END          = 36;
  HK_JMP_LINE_START       = 37;
  HK_JMP_LINE_END         = 38;
  HK_COPY_MODPLUG         = 39;
  HK_COPY_RENOISE         = 40;
  HK_COPY_FAMI            = 41;
  HK_PATTERN_PACKER       = 42;


  SystemHotKeys : array[0..12] of string = (
     'Ctrl+A', 'Ctrl+V', 'Ctrl+N', 'Ctrl+O',
     'Ctrl+C', 'Ctrl+X', 'Ctrl+V', 'Ctrl+W',
     'Ctrl+S', 'Ctrl+Shift+S', 'Shift+Ctrl+S',
     'Alt+Space', 'Alt+F4'
  );

var
  VTHotKeys : array[0..42, 0..1] of string = (
      ('Play/Stop',               'Space'),        // HK_PLAY_STOP
      ('Play from Line',          'F5'),           // HK_PLAY_FROM_LINE
      ('Play Track from Start',   'F6'),           // HK_PLAY_FROM_START
      ('Play Pattern from Line',  'F7'),           // HK_PLAY_PATT_FROM_LINE
      ('Play Pattern from Start', 'F8'),           // HK_PLAY_PATT_FROM_START
      ('Stop',                    'Esc'),          // HK_STOP
      ('Toggle Looping',          'Ctrl+L'),       // HK_LOOP_TOGGLE
      ('Toggle Loopting All',     'Ctrl+Alt+L'),   // HK_LOOP_TOGGLE_ALL
      ('Set Loop Position',       'L'),            // HK_LOOP_SET_POSITION
      ('Insert position',         'Ins'),          // HK_POSITIONS_INSERT
      ('Delete positions',        'Del'),          // HK_POSITIONS_DELETE
      ('Duplicate positions',     'Ctrl+D'),       // HK_POSITIONS_DUPLICATE
      ('Clone positions',         'Ctrl+Shift+D'), // HK_POSITIONS_CLONE
      ('Toggle Samples',          'Ctrl+M'),       // HK_TOGGLE_SAMPLES
      ('Show Tracks Manager',     'Ctrl+T'),       // HK_TRACKS_MANAGER
      ('Toggle Chip',             'Ctrl+Alt+C'),   // HK_TOGGLE_CHIP
      ('Toggle Channels',         'Ctrl+Alt+A'),   // HK_TOGGLE_CHANNELS
      ('Undo',                    'Ctrl+Z'),       // HK_UNDO
      ('Redo',                    'Ctrl+Shift+Z'), // HK_REDO
      ('Transpose +1',            'Num +'),        // HK_TRANSPOSE_UP1
      ('Transpose -1',            'Num -'),        // HK_TRANSPOSE_DOWN1
      ('Transpose +3',            'Shift+Num +'),  // HK_TRANSPOSE_UP3
      ('Transpose -3',            'Shift+Num -'),  // HK_TRANSPOSE_DOWN3
      ('Transpose +5',            'Ctrl+Shift+Num +'), // HK_TRANSPOSE_UP5
      ('Transpose -5',            'Ctrl+Shift+Num -'), // HK_TRANSPOSE_DOWN5
      ('Transpose +12',           'Ctrl+Num +'),       // HK_TRANSPOSE_UP12
      ('Transpose -12',           'Ctrl+Num -'),       // HK_TRANSPOSE_DOWN12
      ('Expand Pattern',          'Ctrl+Shift+/'),     // HK_EXPAND_PATTERN
      ('Compress Pattern',        'Ctrl+Shift+Num *'), // HK_COMPRESS_PATTERN
      ('Options',                 'Ctrl+Shift+O'),     // HK_OPTIONS
      ('Use Last Note params - on/off',  'Shift+Esc'), // HK_DUP_NOTE_PARAMS
      ('Move Between Patterns - on/off', 'Shift+`'),   // HK_MOVE_BETWEEN_PATRNS
      ('Split Pattern',           'Alt+X'),            // HK_SPLIT_PATTERN
      ('Swap selected channels left', 'Ctrl+Alt+Left'),    // HK_SWAP_CHANS_LEFT
      ('Swap selected channels right', 'Ctrl+Alt+Right'),  // HK_SWAP_CHANS_RIGHT
      ('Jump to the pattern first line', 'Ctrl+Home'),     // HK_JMP_PAT_START
      ('Jump to the pattern last line',  'Ctrl+End'),      // HK_JMP_PAT_END
      ('Jump to the line start',         'Home'),          // HK_JMP_LINE_START
      ('Jump to the line end',           'End'),           // HK_JMP_LINE_END
      ('Copy pattern to OpenMPT',        'Ctrl+Alt+C'),    // HK_COPY_MODPLUG
      ('Copy pattern to Renoise',        'Ctrl+Shift+C'),  // HK_COPY_RENOISE
      ('Copy pattern to FamiTracker',    'Alt+C'),         // HK_COPY_FAMI
      ('Pattern packer',                 'Ctrl+P')         // HK_PATTERN_PACKER
  );



procedure InitOptionsHotKeys;
procedure SetDefaultHotKeys;
procedure AssignHotKey(HotKeyIndex: Integer; ShortCutText: string);
procedure LoadHotKeysFromText(HotKeysText: string);
procedure ReAssignHotKey(HotKeyIndex: Integer; ShortCutText: string);
function Split(Delimiter: Char; Str: string): TStrings;
function AllHotKeysToText : string;


implementation

uses options, Main;



procedure InitOptionsHotKeys;
var
  I: Integer;
  ListItem: TListItem;
begin
  with options.Form1.HotKeyList do
  begin
    Clear;
    for I := Low(VTHotKeys) to High(VTHotKeys) do
    begin
      ListItem := Items.Add;
      ListItem.Caption := VTHotKeys[I][0];
      ListItem.SubItems.Add(VTHotKeys[I][1]);
    end;
  end;

end;

procedure SetDefaultHotKeys;
var I : Integer;
begin
  for I := Low(VTHotKeys) to High(VTHotKeys) do
    AssignHotKey(I, VTHotKeys[I][1]);
end;


procedure ReAssignHotKey(HotKeyIndex: Integer; ShortCutText: string);
var I: Integer;
begin

  // If shortcut in SystemHotKeys array (like Ctrl+C, Ctrl+V) - exit
  if AnsiIndexText(ShortCutText, SystemHotKeys) > -1 then
  begin
    ShowMessage('Error: Key "' + ShortCutText + '" is a system key.');
    Exit;
  end;

  // User can't assign the Shift key for the pattern jumps
  if (HotKeyIndex in [HK_JMP_PAT_START, HK_JMP_PAT_END, HK_JMP_LINE_START, HK_JMP_LINE_END]) and
     (AnsiPos('Shift', ShortCutText) <> 0) then
     Exit;

  for I := Low(VTHotKeys) to High(VTHotKeys) do
  begin
    if VTHotKeys[I][1] = ShortCutText then
      if MessageDlg('Key "' + ShortCutText + '" already assigned to "' + VTHotKeys[I][0] +'" function. Assign anyway?', mtWarning, mbOKCancel, 0) = mrCancel then
        Exit
      else
      begin
        // Clear old hotkey
        VTHotKeys[I][1] := '';
        AssignHotKey(I, '');
        options.Form1.HotKeyList.Items[I].SubItems[0] := '';

        // Set new hotkey
        VTHotKeys[HotKeyIndex][1] := ShortCutText;
        AssignHotKey(HotKeyIndex, ShortCutText);
        options.Form1.HotKeyList.Items[HotKeyIndex].SubItems[0] := ShortCutText;
        Exit;
      end;
  end;

  VTHotKeys[HotKeyIndex][1] := ShortCutText;
  AssignHotKey(HotKeyIndex, ShortCutText);
  options.Form1.HotKeyList.Items[HotKeyIndex].SubItems[0] := ShortCutText;

end;





procedure AssignHotKey(HotKeyIndex: Integer; ShortCutText: string);
var
  ShortCut : TShortCut;
begin

  if HotKeyIndex > High(VTHotKeys) then Exit;

  VTHotKeys[HotKeyIndex, 1] := ShortCutText;
  ShortCut := TextToShortCut(ShortCutText);

  with MainForm do case HotKeyIndex of
    HK_PLAY_STOP:            begin PlayStop.ShortCut := ShortCut; Play3.ShortCut := ShortCut; end;
    HK_PLAY_FROM_LINE:       begin PlayFromLine.ShortCut := ShortCut; PlayFromLine1.ShortCut := ShortCut; end;
    HK_PLAY_FROM_START:      begin Play1.ShortCut := ShortCut; Play4.ShortCut := ShortCut; end;
    HK_PLAY_PATT_FROM_START: begin PlayPat.ShortCut := ShortCut; Playpatternfromstart1.ShortCut := ShortCut; end;
    HK_PLAY_PATT_FROM_LINE:  begin PlayPatFromLine.ShortCut := ShortCut; Playpatternfromcurrentline1.ShortCut := ShortCut; end;
    HK_LOOP_TOGGLE:          begin ToggleLooping.ShortCut := ShortCut; Togglelooping1.ShortCut := ShortCut; end;
    HK_LOOP_TOGGLE_ALL:      begin ToggleLoopingAll.ShortCut := ShortCut; Toggleloopingall1.ShortCut := ShortCut; end;
    HK_LOOP_SET_POSITION:    Setloopposition1.ShortCut := ShortCut;
    HK_POSITIONS_INSERT:     Insertposition1.ShortCut := ShortCut;
    HK_POSITIONS_DELETE:     Deleteposition1.ShortCut := ShortCut;
    HK_POSITIONS_DUPLICATE:  DuplicatePosition1.ShortCut := ShortCut;
    HK_POSITIONS_CLONE:      ClonePosition1.ShortCut := ShortCut;
    HK_TOGGLE_SAMPLES:       begin Togglesamples1.ShortCut := ShortCut; Togglesamples1.ShortCut := ShortCut; end;
    HK_TRACKS_MANAGER:       begin Tracksmanager1.ShortCut := ShortCut; Tracksmanager1.ShortCut := ShortCut; end;
    HK_TOGGLE_CHIP:          ToggleChip.ShortCut := ShortCut;
    HK_TOGGLE_CHANNELS:      ToggleChanAlloc.ShortCut := ShortCut;
    HK_UNDO:                 Undo.ShortCut := ShortCut;
    HK_REDO:                 Redo.ShortCut := ShortCut;
    HK_TRANSPOSE_UP1:        TransposeUp1.ShortCut := ShortCut;
    HK_TRANSPOSE_DOWN1:      TransposeDown1.ShortCut := ShortCut;
    HK_TRANSPOSE_UP3:        TransposeUp3.ShortCut := ShortCut;
    HK_TRANSPOSE_DOWN3:      TransposeDown3.ShortCut := ShortCut;
    HK_TRANSPOSE_UP5:        TransposeUp5.ShortCut := ShortCut;
    HK_TRANSPOSE_DOWN5:      TransposeDown5.ShortCut := ShortCut;
    HK_TRANSPOSE_UP12:       TransposeUp12.ShortCut := ShortCut;
    HK_TRANSPOSE_DOWN12:     TransposeDown12.ShortCut := ShortCut;
    HK_EXPAND_PATTERN:       ExpandTwice1.ShortCut := ShortCut;
    HK_COMPRESS_PATTERN:     Compresspattern1.ShortCut := ShortCut;
    HK_OPTIONS:              Options1.ShortCut := ShortCut;
    HK_DUP_NOTE_PARAMS:      DuplicateLastNoteParams.ShortCut := ShortCut;
    HK_MOVE_BETWEEN_PATRNS:  MoveBetwnPatrns.ShortCut := ShortCut;
    HK_SPLIT_PATTERN:        Splitpattern1.ShortCut := ShortCut;
    HK_STOP:                 begin Stop.ShortCut := ShortCut; Stop2.ShortCut := ShortCut; end;
    HK_SWAP_CHANS_LEFT:      SwapChannelsLeft1.ShortCut := ShortCut;
    HK_SWAP_CHANS_RIGHT:     SwapChannelsRight1.ShortCut := ShortCut;
    HK_JMP_PAT_START:        JmpPatStartAct.ShortCut := ShortCut;
    HK_JMP_PAT_END:          JmpPatEndAct.ShortCut := ShortCut;
    HK_JMP_LINE_START:       JmpLineStartAct.ShortCut := ShortCut;
    HK_JMP_LINE_END:         JmpLineEndAct.ShortCut := ShortCut;
    HK_COPY_MODPLUG:         begin CopyToModplugAct.ShortCut := ShortCut; CopyToModplug.ShortCut := ShortCut; end;
    HK_COPY_RENOISE:         begin CopyToRenoiseAct.ShortCut := ShortCut; CopyToRenoise.ShortCut := ShortCut; end;
    HK_COPY_FAMI:            begin CopyToFamiAct.ShortCut := ShortCut; CopyToFami.ShortCut := ShortCut; end;
    HK_PATTERN_PACKER:       PackPatternAct.ShortCut := ShortCut;
  else
  end;
end;


function AllHotKeysToText : string;
var
  I: Integer;
begin
  for I := Low(VTHotKeys) to High(VTHotKeys) do
  begin
    Result := Result + VTHotKeys[I][1];
    if I < High(VTHotKeys) then Result := Result + ',';
  end;
end;


procedure LoadHotKeysFromText(HotKeysText: string);
var
  HotKeysList : TStrings;
  I : Integer;

begin
  HotKeysList := Split(',', HotKeysText);
  for I := 0 to HotKeysList.Count-1 do
  begin
    AssignHotKey(I, HotKeysList[I]);
  end;
  FreeAndNil(HotKeysList);
end;


function Split(Delimiter: Char; Str: string): TStrings;
var
  i: Integer;
  row: string;
begin
  Result := TStringList.Create;
  i := 1;
  row := '';
  while i <= Length(Str) do
  begin
    if (Str[i] = Delimiter) then
    begin
      Result.Add(row);
      row := '';
    end
    else
      row := row + Str[i];
    i := i + 1;
  end;
  if (row <> '') then
    Result.Add(row);
end;


end.
