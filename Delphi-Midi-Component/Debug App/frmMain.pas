(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 3.0/LGPL 3.0
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is MIDI I/O components debugger app.
 *
 * The Initial Developer of the Original Code is
 * Manuel Kroeber <manuel.kroeber@googlemail.com>.
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   None
 *
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 3 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 3 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *)

unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,

  MidiIn,
  MidiOut,
  MidiType,
  MidiCons,

  ExtCtrls, ComCtrls;

type
  TFormMain = class(TForm)
    gbInputMidiPod: TGroupBox;
    cbInputMIDIDevices: TComboBox;
    gbOutputMidiPod: TGroupBox;
    cbOutputMIDIDevices: TComboBox;
    btnOpenAll: TButton;
    btnStopAll: TButton;
    Button1: TButton;
    memoInputDebug: TMemo;
    Timer1: TTimer;
    Button2: TButton;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbInputMIDIDevicesChange(Sender: TObject);
    procedure cbOutputMIDIDevicesChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnOpenAllClick(Sender: TObject);
    procedure btnStopAllClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    FMidiIn: TMidiInput;
    FMidiOut: TMidiOutput;
    procedure UpdateStatusBar;
    procedure OnMidiInput(Sender: TObject);
  public
    { Public-Deklarationen }
    function ByteArrayToHexString(const InArr: array of Byte): string;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.btnOpenAllClick(Sender: TObject);
begin
  FMidiIn.OpenAndStart;
  UpdateStatusBar;
  FMidiOut.Open;
end;

procedure TFormMain.btnStopAllClick(Sender: TObject);
begin
  FMidiIn.Stop;
  FMidiIn.Close;
  FMidiOut.Close;
end;

procedure TFormMain.Button1Click(Sender: TObject);
var
 I: Integer;
begin
  cbOutputMIDIDevices.Clear;
  
  if FMidiOut.Numdevs > 0 then
  begin
    for I := -1 to FMidiOut.Numdevs - 1 do
    begin
      FMidiOut.DeviceID := I;
      cbOutputMIDIDevices.Items.Add(FMidiOut.ProductName+' (ID '+IntToStr(i)+')');
    end;

    FMidiOut.DeviceID := FMidiOut.Numdevs - 1;
    cbOutputMIDIDevices.ItemIndex := cbOutputMIDIDevices.Items.Count - 1;
  end
  else
    MessageDlg('No MIDI output devices found.',
      mtError, [mbOK], 0);


  cbInputMIDIDevices.Clear;

  if FMidiIn.DeviceCount > 0 then
  begin
    for I := 0 to FMidiIn.DeviceCount - 1 do
    begin
      FMidiIn.DeviceID := I;
      cbInputMIDIDevices.Items.Add(FMidiIn.ProductName+' (ID '+IntToStr(i)+')');
    end;

    FMidiIn.DeviceID := FMidiIn.DeviceCount - 1;
    cbInputMIDIDevices.ItemIndex := cbInputMIDIDevices.Items.Count - 1;
  end
  else
    MessageDlg('No MIDI input devices found.',
      mtError, [mbOK], 0);
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  FMidiOut.ChangeInstrument(0, gmiDistortionGuitar);
  FMidiOut.NoteOn(0, 64, 127);
  Sleep(300);
  FMidiOut.NoteOn(0, 69, 127);
  Sleep(300);
  FMidiOut.NoteOn(0, 74, 127);
  Sleep(300);
  FMidiOut.NoteOff(0, 64, 64);
  FMidiOut.NoteOff(0, 69, 64);
  FMidiOut.NoteOff(0, 74, 64);
end;

function TFormMain.ByteArrayToHexString(const InArr: array of Byte): string;
var
  tmpStrList: TStringList;
  i: Integer;
begin
  tmpStrList := TStringList.Create;
  try
    for I := Low(InArr) to High(InArr) do
    begin
      tmpStrList.Append(IntToHex(InArr[i], 2));
    end;
    tmpStrList.Delimiter := ' ';
    Result := tmpStrList.DelimitedText;
  finally
    tmpStrList.Free;
  end;
end;

procedure TFormMain.cbInputMIDIDevicesChange(Sender: TObject);
begin
  FMidiIn.ChangeDevice(cbInputMIDIDevices.ItemIndex, False);
end;

procedure TFormMain.cbOutputMIDIDevicesChange(Sender: TObject);
begin
  if (cbOutputMIDIDevices.ItemIndex - 1) < 0 then
    FMidiOut.ChangeDevice(MIDI_MAPPER, False)
  else
    FMidiOut.ChangeDevice(cbOutputMIDIDevices.ItemIndex - 1, False);
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  FMidiOut := TMidiOutput.Create(nil);

  if FMidiOut.Numdevs > 0 then
  begin
    for I := -1 to FMidiOut.Numdevs - 1 do
    begin
      FMidiOut.DeviceID := I;
      cbOutputMIDIDevices.Items.Add(FMidiOut.ProductName+' (ID '+IntToStr(i)+')');
    end;

    FMidiOut.DeviceID := FMidiOut.Numdevs - 1;
    cbOutputMIDIDevices.ItemIndex := cbOutputMIDIDevices.Items.Count - 1;
  end
  else
    MessageDlg('No MIDI output devices found.',
      mtError, [mbOK], 0);

  FMidiIn := TMidiInput.Create(nil);
  FMidiIn.SysexBufferSize := 64000-1;
  FMidiIn.OnMidiInput := OnMIDIInput;

  if FMidiIn.DeviceCount > 0 then
  begin
    for I := 0 to FMidiIn.DeviceCount - 1 do
    begin
      FMidiIn.DeviceID := I;
      cbInputMIDIDevices.Items.Add(FMidiIn.ProductName+' (ID '+IntToStr(i)+')');
    end;

    FMidiIn.DeviceID := FMidiIn.DeviceCount - 1;
    cbInputMIDIDevices.ItemIndex := cbInputMIDIDevices.Items.Count - 1;
  end
  else
    MessageDlg('No MIDI input devices found.',
      mtError, [mbOK], 0);

end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FMidiIn.Free;
  FMidiOut.Free;
end;

procedure TFormMain.OnMidiInput(Sender: TObject);
var
	thisEvent: TMyMidiEvent;
  ReceivingInput: TMidiInput;
  OutStr: string;
  SysExArray: array of Byte;
begin
  try
    if (Sender is TMidiInput) then
    begin
      ReceivingInput := (Sender as TMidiInput);

      while (ReceivingInput.MessageCount > 0) do
      begin
        UpdateStatusBar;
        { Get the event as an object }
        thisEvent := ReceivingInput.GetMidiEvent;
        try
          SetLength(SysExArray, thisEvent.SysexLength);
          Move(thisEvent.Sysex, SysExArray[0], thisEvent.SysexLength);
          
          OutStr := MidiMessageToStr(thisEvent.MidiMessage) + #13#10 +
            'Channel:     ' + IntToStr(thisEvent.MidiMessage and $0F) + #13#10 +
            'Data1:       ' + IntToStr(thisEvent.Data1) + #13#10 +
            'Data2:       ' + IntToStr(thisEvent.Data2) + #13#10 +
            'Time:        ' + IntToStr(thisEvent.Time) + #13#10 +
            'SysexLength: ' + IntToStr(thisEvent.SysexLength) + #13#10 +
            'Sysex: ' + #13#10 + ByteArrayToHexString(SysExArray) + #13#10;

          memoInputDebug.Lines.Text := OutStr;

          FMidiOut.PutMidiEvent(thisEvent);
        finally
          { Event was dynamically created by GetMidiEvent so must free it here }
          thisEvent.Free;
        end;
      end;
    end;
  except
    // ignore exeptions to continue after bad events
  end;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  if Assigned(FMidiIn) then
  begin
    case FMidiIn.State of
      misOpen: gbInputMidiPod.Caption := ' Input (OPEN)';
      misClosed: gbInputMidiPod.Caption := ' Input (CLOSED)';
      misCreating: gbInputMidiPod.Caption := ' Input (CREATING)';
      misDestroying: gbInputMidiPod.Caption := ' Input (DESTROYING)';
    end;
    gbInputMidiPod.Caption := gbInputMidiPod.Caption + ' ' + FMidiIn.ProductName;
    UpdateStatusBar;
  end;

  if Assigned(FMidiOut) then
  begin
    case FMidiOut.State of
      mosOpen: gbOutputMidiPod.Caption := ' Output (OPEN)';
      mosClosed: gbOutputMidiPod.Caption := ' Output (CLOSED)';
    end;
    gbOutputMidiPod.Caption := gbOutputMidiPod.Caption + ' ' + FMidiOut.ProductName;
  end;
end;

procedure TFormMain.UpdateStatusBar;
begin
  StatusBar.Panels[2].Text := IntToStr(FMidiIn.MessageCount);
end;

end.
