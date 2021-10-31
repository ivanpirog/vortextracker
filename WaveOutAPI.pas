{
This is part of Vortex Tracker II project

(c)2000-2009 S.V.Bulba
Author: Sergey Bulba, vorobey@mail.khstu.ru
Support page: http://bulba.untergrund.net/

Version 2.0 and later
(c)2017-2019 Ivan Pirog, ivan.pirog@gmail.com
}

unit WaveOutAPI;

interface

uses Windows, Messages, Dialogs, MMSystem, SysUtils, Forms, trfuncs, Classes,
     ExportWav, ayumi;

type
//Digital sound data buffer
  TWaveOutBuffer = packed array of byte;

  TWaveHeader = record
    idRiff: array [0..3] of AnsiChar;
    RiffLen: longint;
    idWave: array [0..3] of AnsiChar;
    idFmt: array [0..3] of AnsiChar;
    InfoLen: longint;
    WaveType: smallint;
    Ch: smallint;
    Freq: longint;
    BytesPerSec: longint;
    align: smallint;
    Bits: smallint;
    idData: array [0..3] of char;
    DataLen: longint;
  end;


const
  NumberOfBuffersDef = 3;
  BufLen_msDef = 100; //726;
  WODevice: DWORD = WAVE_MAPPER;

var
  NumberOfBuffers, BufferLength, BuffLen, BufLen_ms: integer;
  NOfTicks: Cardinal;
  IsPlaying: boolean = False;
  Reseted: boolean = False;
  Interrupt_Freq, NumberOfChannels, SampleRate, SampleBit: integer;

  PlayingGrid: array of record
    M1, M2: Integer;
  end;
  PlayGridLen: Cardinal;
  MkVisPos: Cardinal;

  ResetMutex: THandle;
  HWO: HWAVEOUT;
  waveOutBuffers: array of record
    Buf: TWaveOutBuffer;
    WH: WAVEHDR;
  end;
  LineReady: boolean;
  ExportStarted, ExportFinished: Boolean;
  ExportLoops: Integer;



procedure InitForAllTypes(All: boolean);
procedure StartWOThread;
procedure WOThreadFinalization;
procedure StopPlaying;
procedure WOCheck(Res: MMRESULT);
procedure ResetAYChipEmulation(chip: integer);
function WOThreadActive: boolean;
procedure ResetPlaying;
procedure UnresetPlaying;
procedure CreateWaveHeader(Length, SampleRate: Integer;
  BitsPerSample, Channels: Smallint; var WaveHeader: TWaveHeader);
procedure CreateWaveAyumi(FileName: string);


implementation

uses AY, Childwin, Main, ExportWavOpts;

var
  WOEventH: THANDLE;
  WOThreadID: DWORD;
  WOThreadH: THANDLE = 0;
  WOCS: RTL_CRITICAL_SECTION;

  TSEventH: THANDLE;
  TSThreadID: DWORD;
  TSThreadH: THANDLE;

  AudioProblem: Boolean;

type
  EMultiMediaError = class(Exception);

procedure WOCheck(Res: MMRESULT);
var
  ErrMsg: array[0..255] of Char;
begin
  if Res <> 0 then
  begin
    EnterCriticalSection(WOCS);
    waveOutGetErrorText(Res, ErrMsg, SizeOf(ErrMsg));
    LeaveCriticalSection(WOCS);
    raise EMultiMediaError.Create(ErrMsg)
  end
end;


function TSThreadFunc(a: pointer): dword; stdcall;
var
  CurVisPos, k: DWORD;
  MMTIME1: MMTime;
  PW1Changed, PW2Changed: Boolean;

begin

  while WaitForSingleObject(TSEventH, 0) <> WAIT_OBJECT_0 do
  begin

    if Reseted then begin
      Sleep(2);
      Continue;
    end;

    if IsPlaying and WOThreadActive and (PlayMode in [PMPlayModule, PMPlayPattern]) then begin

      MMTIME1.wType := TIME_SAMPLES;
      waveOutGetPosition(HWO, @MMTIME1, sizeof(MMTIME1));

      k := MMTIME1.Sample div PlayGridLen;
      CurVisPos := MMTIME1.Sample - (PlayGridLen * k);

      PW1Changed := (
        ((PlayingGrid[CurVisPos].M1 shr 17) and $1FF <> PlayingWindow[1].Tracks.ShownFrom) or
        ((PlayingGrid[CurVisPos].M1 shr 9) and $FF  <> PlayingWindow[1].PatNum) or
        (PlayingGrid[CurVisPos].M1 and $1FF <> PlayingWindow[1].PositionNumber)
      );

      if PlayingWindow[2] = nil then
        PW2Changed := False
      else
        PW2Changed := (
          ((PlayingGrid[CurVisPos].M2 shr 17) and $1FF <> PlayingWindow[2].Tracks.ShownFrom) or
          ((PlayingGrid[CurVisPos].M2 shr 9) and $FF  <> PlayingWindow[2].PatNum) or
          (PlayingGrid[CurVisPos].M2 and $1FF <> PlayingWindow[2].PositionNumber)
        );

      //Main.Logger.Add(IntToStr((PlayingGrid[CurVisPos].M1 shr 17) and $1FF));

      if PW1Changed or PW2Changed then
        PostMessage(MainForm.Handle, UM_REDRAWTRACKS, PlayingGrid[CurVisPos].M1, PlayingGrid[CurVisPos].M2);

      Sleep(2);
    end
    else
      Sleep(20)
  end;
  Result := STILL_ACTIVE - 1;
end;


procedure StartTrackSlider;
begin
  TSEventH := CreateEvent(nil, False, False, nil);
  TSThreadH := CreateThread(nil, 0, @TSThreadFunc, nil, 0, TSThreadID);
  SetThreadPriority(TSThreadH, HIGH_PRIORITY_CLASS);
end;

procedure SkipRedraw;
var
  msg: TMsg;
begin
  Sleep(0);
  if PlayMode in [PMPlayModule, PMPlayPattern] then
    PeekMessage(msg, MainForm.Handle, UM_REDRAWTRACKS, UM_REDRAWTRACKS, PM_REMOVE);
end;

procedure StopTrackSlider;
var
  ExCode: DWORD;
begin
  SetEvent(TSEventH);
  repeat
    if not GetExitCodeThread(TSThreadH, ExCode) then break;
    if ExCode = STILL_ACTIVE then SkipRedraw;
  until ExCode <> STILL_ACTIVE;
  CloseHandle(TSThreadH);
  CloseHandle(TSEventH);
end;

procedure WaitForWOThreadExit;
var
  ExCode: DWORD;
begin
  if WOThreadH = 0 then exit;
  repeat
    if not GetExitCodeThread(WOThreadH, ExCode) then break;
    if ExCode = STILL_ACTIVE then Sleep(0);
  until ExCode <> STILL_ACTIVE;
  CloseHandle(WOThreadH);
  WOThreadH := 0
end;

procedure StopPlaying;
var
  msg: TMsg;
begin
  UnlimiteDelay := False;
  IsPlaying := False;

  if WOThreadActive then
  begin
    AudioProblem := False;
    ResetPlaying;
    UnresetPlaying;
    SetEvent(WOEventH);
    WaitForWOThreadExit;
    while not PeekMessage(msg, MainForm.Handle,
      UM_FINALIZEWO, UM_FINALIZEWO, PM_REMOVE) do Sleep(0);
    WOThreadFinalization
  end
end;

function WOThreadFunc(a: pointer): dword; stdcall;

  function AllBuffersDone: boolean;
  var
    i: integer;
  begin
    Result := False;
    for i := 0 to NumberOfBuffers - 1 do
      if waveOutBuffers[i].WH.dwFlags and WHDR_DONE = 0 then exit;
    Result := True
  end;

var
  i, j, SampleSize: integer;
  mut: boolean;

begin
  SampleSize := (SampleBit div 8) * NumberOfChannels;
  mut := False;
  try
    repeat
      WaitForSingleObject(ResetMutex, INFINITE);
      mut := True;
      if not Real_End_All then
      begin
        for i := 0 to NumberOfBuffers - 1 do
          with waveOutBuffers[i] do
          begin
            if Reseted then break;
            if not IsPlaying then break;
            if WH.dwFlags and WHDR_DONE <> 0 then
            begin
              MakeBuffer(WH.lpdata);
              if Reseted then break;
              if not IsPlaying then break;
              if BuffLen = 0 then
              begin
                if AllBuffersDone then break
              end
              else
              begin
                WH.dwBufferLength := BuffLen * SampleSize;
                WH.dwFlags := WH.dwFlags and not WHDR_DONE;

                EnterCriticalSection(WOCS);
                try
                  WOCheck(waveOutWrite(HWO, @WH, sizeof(WAVEHDR)));
                except
                  // Audio device settings changed
                  LeaveCriticalSection(WOCS);
                  IsPlaying := False;
                  Reseted := False;
                  ReleaseMutex(ResetMutex);
                  AudioProblem := True;
                  WOCheck(waveOutClose(HWO));
                  Result := 0;
                  Exit;
                end;

                LeaveCriticalSection(WOCS);

              end
            end;
          end
      end;
      if Real_End_All and not Reseted and AllBuffersDone then break;
      mut := False;
      ReleaseMutex(ResetMutex);
      if not IsPlaying then break;
      j := WaitForSingleObject(WOEventH, BufLen_ms);
      if (j <> WAIT_OBJECT_0) and (j <> WAIT_TIMEOUT) then break
    until not IsPlaying
  finally
    if mut then
      ReleaseMutex(ResetMutex);
    PostMessage(MainForm.Handle, UM_FINALIZEWO, 0, 0);
    Result := STILL_ACTIVE - 1;
    UnlimiteDelay := False;
  end
end;

procedure StartWOThread;
var
  pwfx: pcmwaveformat;
  i, bl: integer;
begin
  if WOThreadActive then exit;

  SetAYFreq(TMDIChild(MainForm.ActiveMDIChild).VTMP.ChipFreq);
  SetIntFreq(TMDIChild(MainForm.ActiveMDIChild).VTMP.IntFreq);

  ExportStarted := False;
  AudioProblem := False;

  StartTrackSlider;

  with pwfx.wf do
  begin
    wFormatTag := 1;
    nChannels := NumberOfChannels;
    nSamplesPerSec := SampleRate;
    nBlockAlign := (SampleBit div 8) * NumberOfChannels;
    nAvgBytesPerSec := SampleRate * pwfx.wf.nBlockAlign;
  end;
  pwfx.wBitsPerSample := SampleBit;
  try
    WOCheck(waveOutOpen(@HWO, WODevice, @pwfx, WOEventH, 0, CALLBACK_EVENT));
  except
    PostMessage(MainForm.Handle, UM_PLAYINGOFF, 0, 0);
    MessageDlg('Can''t play: audio device is busy or not available. Check sound settings.',
      mtWarning, [mbOK], 0);
    Exit;
  end;
  WaitForSingleObject(WOEventH, INFINITE);
  try
    bl := BufferLength * pwfx.wf.nBlockAlign;
    for i := 0 to NumberOfBuffers - 1 do
      with waveOutBuffers[i] do
      begin
        SetLength(Buf, bl);
        with WH do
        begin
          lpdata := @Buf[0];
          dwBufferLength := bl;
          dwFlags := 0;
          dwUser := 0;
          dwLoops := 0;
        end;
        WOCheck(waveOutPrepareHeader(HWO, @WH, sizeof(WAVEHDR)));
        WH.dwFlags := WH.dwFlags or WHDR_DONE;
      end
  except
    PostMessage(MainForm.Handle, UM_PLAYINGOFF, 0, 0);
    MessageDlg('Can''t play: audio device is busy or not available. Check sound settings.',
      mtWarning, [mbOK], 0);
    //Exit;
    WOCheck(waveOutClose(HWO));
    Exit;
  end;

  // Init Ayumi Engine
  AyumiChip1 := TAyumi.Create;
  AyumiChip1.Configure(Emulating_Chip = YM_Chip, AY_Freq, SampleRate, DCType);
  AyumiChip1.SetDCCutoff(DCCutOff);
  AyumiChip1.SetPan(0, Panoram[0]/255, False);
  AyumiChip1.SetPan(1, Panoram[1]/255, False);
  AyumiChip1.SetPan(2, Panoram[2]/255, False);
  AyumiChip2 := TAyumi.Create;
  AyumiChip2.Configure(Emulating_Chip = YM_Chip, AY_Freq, SampleRate, DCType);
  AyumiChip2.SetDCCutoff(DCCutOff);
  AyumiChip2.SetPan(0, Panoram[0]/255, False);
  AyumiChip2.SetPan(1, Panoram[1]/255, False);
  AyumiChip2.SetPan(2, Panoram[2]/255, False);

  IsPlaying := True;
  Reseted := False;

  WOThreadH := CreateThread(nil, 0, @WOThreadFunc, nil, 0, WOThreadID);

end;

procedure WOThreadFinalization;
var
  i: integer;
begin
  WaitForWOThreadExit;
  StopTrackSlider;

  AyumiChip1.Free;
  AyumiChip2.Free;
  AyumiChip1 := nil;
  AyumiChip2 := nil;


  try
    WOCheck(waveOutReset(HWO));
    for i := 0 to NumberOfBuffers - 1 do
      with waveOutBuffers[i] do
      begin
        while WH.dwFlags and WHDR_DONE = 0 do Sleep(0);
        if WH.dwFlags and WHDR_PREPARED <> 0 then
          WOCheck(waveOutUnprepareHeader(HWO, @WH, sizeof(WAVEHDR)));
        Buf := nil
      end;
    WOCheck(waveOutClose(HWO));
  except
    if AudioProblem then
    begin
      Application.MessageBox('Audio device settings were changed. Check audio options and try again.', 
        'Vortex Tracker', MB_OK + MB_ICONWARNING + MB_TOPMOST);
    end
    else
      ShowException(ExceptObject, ExceptAddr);
  end;

  IsPlaying := False;
  Reseted := False;
  AudioProblem := False;

end;

procedure ResetAYChipEmulation;
begin
  with SoundChip[chip] do
  begin
    FillChar(AYRegisters, 14, 0);
    SetEnvelopeRegister(0);
    First_Period := False;
    Ampl := 0;
    SetMixerRegister(0);
    SetAmplA(0);
    SetAmplB(0);
    SetAmplC(0);
    IntFlag := False;
    Number_Of_Tiks.Re := 0;
    Current_Tik := 0;
    Envelope_Counter.Re := 0;
    Ton_Counter_A.Re := 0;
    Ton_Counter_B.Re := 0;
    Ton_Counter_C.Re := 0;
    Noise_Counter.Re := 0;
    Ton_A := 0;
    Ton_B := 0;
    Ton_C := 0;
    Left_Chan := 0; Right_Chan := 0; Tick_Counter := 0;
    Tik.Re := Delay_In_Tiks;
    Noise.Seed := $FFFF;
    Noise.Val := 0;
  end;

  if (chip = 1) and (AyumiChip1 <> nil) then
    AyumiChip1.ResetChip;

  if (chip = 2) and (AyumiChip2 <> nil) then
    AyumiChip2.ResetChip;

end;

procedure InitForAllTypes(All: boolean);
var
  i: integer;
begin
  LineReady := False;
  MkVisPos := 0;
  NOfTicks := 0;
  for i := 1 to NumberOfSoundChips do
  begin
    ResetAYChipEmulation(i);
    Real_End[i] := False;
  end;
  Real_End_All := False;
  if (RenderEngine = 0) and IsFilt then
  begin
    FillChar(Filt_XL[0], (Filt_M + 1) * 4, 0);
    FillChar(Filt_XR[0], (Filt_M + 1) * 4, 0);
    Filt_I := 0;
  end;
  for i := NumberOfSoundChips downto 1 do
  begin
    Module_SetPointer(PlayingWindow[i].VTMP, i);
    InitTrackerParameters(All);
  end;
end;

function WOThreadActive;
var
  ExCode: DWORD;
begin
  Result := (WOThreadH <> 0) and
    GetExitCodeThread(WOThreadH, ExCode) and
    (ExCode = STILL_ACTIVE);
  if not Result then
    if WOThreadH <> 0 then
    begin
      CloseHandle(WOThreadH);
      WOThreadH := 0
    end
end;

procedure ResetPlaying;
var
  i: integer;
begin
  if Reseted then exit;
  Reseted := True;
  UnlimiteDelay := False;
  AudioProblem := False;
  WaitForSingleObject(ResetMutex, INFINITE);
  EnterCriticalSection(WOCS);
  WOCheck(waveOutReset(HWO));
  LeaveCriticalSection(WOCS);
  MkVisPos := 0;
  NOfTicks := 0;
  for i := 0 to NumberOfBuffers - 1 do
    with waveOutBuffers[i] do
      while WH.dwFlags and WHDR_DONE = 0 do Sleep(0)
end;

procedure UnresetPlaying;
begin
  if Reseted then
  begin
    AudioProblem := False;
    SetEvent(WOEventH);
    Reseted := False;
    ReleaseMutex(ResetMutex);
  end
end;



procedure CreateWaveHeader(Length, SampleRate: Integer;
  BitsPerSample, Channels: Smallint; var WaveHeader: TWaveHeader);
begin
  if (SampleRate < 1) or (not BitsPerSample in [8, 16, 24, 32]) or (not Channels in [1, 2])
    then raise Exception.Create('Wrong params');

  //len := SampleCount * BitsPerSample div 8 * Channeles;
  with WaveHeader do begin
    idRiff := 'RIFF';
    RiffLen := Length + 38;
    idWave := 'WAVE';
    idFmt := 'fmt ';
    InfoLen := 16;
    WaveType := 1;
    Ch := Channels;
    Freq := SampleRate;
    BytesPerSec := SampleRate * BitsPerSample div 8 * Channels;
    align := Channels * BitsPerSample div 8;
    Bits := BitsPerSample;
    idData := 'data';
    DataLen := Length;
  end;
end;

{
procedure CreateWave(FileName: string);
var
  WaveHeader: TWaveHeader;
  AudioBufferSize, i: Integer;
  FileStream, TMPFileStream: TFileStream;
  Buf: TWaveOutBuffer;

  prevSampleRate, prevBitRate, prevNumChans: Integer;
  prevOptForQuality, prevLoopAllowed: Boolean;
  prevEmulatingChip: ChTypes;
  prevVolume: Integer;

  ExportModal: TExport;
  Chip1Position, Chip2Position: Integer;

  TMPFileName: string;

begin

  // Save chip & audio params
  prevSampleRate    := SampleRate;
  prevBitRate       := SampleBit;
  prevNumChans      := NumberOfChannels;
  prevEmulatingChip := Emulating_Chip;
  //prevOptForQuality := Optimization_For_Quality;
  prevLoopAllowed   := LoopAllowed;
  prevVolume        := MainForm.TrackBar1.Position;

  MainForm.TrackBar1.Position := 58;


  PlayMode := PMPlayModule;

  if IsPlaying then
    StopPlaying;

  // Force set active tab to patterns tab
  PlayingWindow[1].PageControl1.ActivePageIndex := 0;
  if (PlayingWindow[2] <> nil) then PlayingWindow[2].PageControl1.ActivePageIndex := 0;

  MainForm.DisableControlsForExport;

  // Set chip & audio params for export
  MainForm.SetEmulatingChip(ExportOptions.GetChip);
  //Set_Optimization(True);
  SetSampleRate(ExportOptions.GetSampleRate);
  SetBitRate(16);
  SetNChans(2);
  InitForAllTypes(True);


  // Init pointer, position, delay
  for i := 1 to NumberOfSoundChips do
  begin
    Module_SetPointer(PlayingWindow[i].VTMP, i);
    Module_SetDelay(PlayingWindow[i].VTMP.Initial_Delay);
    Module_SetCurrentPosition(0);
  end;


  // Set loop repeats
  ExportLoops := ExportOptions.GetRepeats;
  LoopAllowed := ExportLoops > 0;

  // Show export modal
  ExportModal := TExport.Create(MainForm);
  ExportModal.ExportProgress.Position := 1;
  ExportModal.ExportProgress.Step := 1;
  ExportModal.ExportProgress.Min  := 0;
  ExportModal.ExportProgress.Max  := PlayingWindow[1].VTMP.Positions.Length +
    ((PlayingWindow[1].VTMP.Positions.Length - PlayingWindow[1].VTMP.Positions.Loop) * ExportLoops);
  ExportModal.Show;

  // Prepare memory stream and buffer
  TMPFileName := FileName+'.tmp';
  TMPFileStream := TFileStream.Create(TMPFileName, fmCreate);
  AudioBufferSize := BufferLength * (SampleBit div 8) * NumberOfChannels;
  SetLength(Buf, AudioBufferSize);
  Chip1Position := 0;
  Chip2Position := 0;

  i := 0;
  ExportStarted  := True;
  ExportFinished := False;
  repeat

    // Cancel export by Esc or Application Exit
    if MainForm.VTExit or (GetAsyncKeyState(VK_ESCAPE) and $8001 <> 0) then
    begin
      TMPFileStream.Free;
      ExportModal.Free;
      DeleteFile(TMPFileName);

      MainForm.SetEmulatingChip(prevEmulatingChip);
      //Set_Optimization(prevOptForQuality);
      SetSampleRate(prevSampleRate);
      SetBitRate(prevBitRate);
      SetNChans(prevNumChans);
      LoopAllowed := prevLoopAllowed;
      MainForm.TrackBar1.Position := prevVolume;

      ExportStarted := False;
      if MainForm.VTExit then
        Exit;

      MainForm.EnableControlsForExport;
      PlayingWindow[1].SelectPosition2(0);
      if PlayingWindow[2] <> nil then PlayingWindow[2].SelectPosition2(0);

      Exit;
    end;

    // Reset buffer
    FillChar(Buf[0], AudioBufferSize, 0);

    // Make buffer and save to memory stream
    MakeBuffer(@Buf[0]);

    // Save buffer
    if BuffLen < BufferLength then
      TMPFileStream.Write(Buf[0], BuffLen * (SampleBit div 8) * NumberOfChannels)
    else
      TMPFileStream.Write(Buf[0], AudioBufferSize);

    if ExportFinished then
      Break;

    // Process messages each 3 loops
    Inc(i);
    if i = 2 then
    begin
      Application.ProcessMessages;
      i := 0;
    end;

    // Change positions
    if Chip1Position <> PlVars[1].CurrentPosition then
    begin
      Chip1Position := PlVars[1].CurrentPosition;
      PlayingWindow[1].SelectPosition2(Chip1Position);
      PlayingWindow[1].PageControl1.Repaint;
      ExportModal.ExportProgress.Position := ExportModal.ExportProgress.Position + 1;
    end;

    if (NumberOfSoundChips = 2) and (Chip2Position <> PlVars[2].CurrentPosition) then
    begin
      Chip2Position := PlVars[2].CurrentPosition;
      PlayingWindow[2].SelectPosition2(Chip2Position);
      PlayingWindow[2].PageControl1.Repaint;
    end;

  until False;

  ExportModal.Free;



  // Save wav
  CreateWaveHeader(TMPFileStream.Size, SampleRate, SampleBit, 2, WaveHeader);

  FileStream := TFileStream.Create(FileName, fmCreate);
  FileStream.Seek(0, soFromBeginning);
  FileStream.Write(WaveHeader, SizeOf(WaveHeader));
  TMPFileStream.Position := 0;
  FileStream.CopyFrom(TMPFileStream, TMPFileStream.Size);

  FileStream.Free;
  TMPFileStream.Free;
  DeleteFile(TMPFileName);


  // Restore chip & audio params
  MainForm.SetEmulatingChip(prevEmulatingChip);
  //Set_Optimization(prevOptForQuality);
  SetSampleRate(prevSampleRate);
  SetBitRate(prevBitRate);
  SetNChans(prevNumChans);
  LoopAllowed := prevLoopAllowed;
  MainForm.TrackBar1.Position := prevVolume;

  // Restore controls
  MainForm.EnableControlsForExport;

  // Set childs positions
  PlayingWindow[1].SelectPosition2(0);
  if PlayingWindow[2] <> nil then PlayingWindow[2].SelectPosition2(0);

  ExportStarted := False;

end;
 }




procedure CreateWaveAyumi(FileName: string);
type
  T24Bit = record
     b1, b2, b3: Byte
  end;

const
  AudioBufferSize = 4096;


var
  WaveHeader: TWaveHeader;
  i, BitRate, NumChannels, PrevChanAlloc: Integer;
  FileStream, TMPFileStream: TFileStream;
  isrCounter, isrStep: Double;
  ExportModal: TExport;
  RealBufferSize: Integer;
  FromPosition, ToPosition, CurPosition: Integer;
  PrevLoopAllowed: Boolean;
  PlayAll: Boolean;
  LeadWindow: TMDIChild;
  PrevPosNum1, PrevPosNum2, PrevPatNum1, PrevPatNum2: Integer;

  TMPFileName: string;
  ayumi1, ayumi2: TAyumi;

  AudioBuff8Stereo: array of array[0..1] of Byte;
  AudioBuff16Stereo: array of array[0..1] of Word;
  AudioBuff24Stereo: array of array[0..1] of T24Bit;
  AudioBuff32Stereo: array of array[0..1] of Integer;

  AudioBuff8Mono: array of Byte;
  AudioBuff16Mono: array of Word;
  AudioBuff24Mono: array of T24Bit;
  AudioBuff32Mono: array of Integer;


  procedure SetAyumiParams(ayumi: TAyumi; Chip: Byte);
  var
    j: Byte;
    r: array[0..13] of byte;
  begin
    if ayumi = nil then Exit;

    for j := 0 to 13 do
      r[j] := SoundChip[Chip].AYRegisters.Index[j];

    ayumi.SetTone(0, (r[1] shl 8) or r[0]);
    ayumi.SetTone(1, (r[3] shl 8) or r[2]);
    ayumi.SetTone(2, (r[5] shl 8) or r[4]);
    ayumi.SetNoise(r[6]);
    ayumi.SetMixer(0, r[7] and 1, (r[7] shr 3) and 1, r[8] shr 4);
    ayumi.SetMixer(1, (r[7] shr 1) and 1, (r[7] shr 4) and 1, (r[9] shr 4) and 1);
    ayumi.SetMixer(2, (r[7] shr 2) and 1, (r[7] shr 5) and 1, (r[10] shr 4) and 1);
    ayumi.SetVolume(0, r[8] and $0f);
    ayumi.SetVolume(1, r[9] and $0f);
    ayumi.SetVolume(2, r[10] and $0f);
    ayumi.SetEnvelope((r[12] shl 8) or r[11]);
    
    if (r[13] <> 255) then
      ayumi.setEnvelopeShape(r[13]);
    SoundChip[Chip].AYRegisters.Index[13] := 255;

  end;


  procedure ChangePositions(PlayWindow: TMDIChild);
  begin
    if PlayWindow <> LeadWindow then begin
      if LeadWindow.PositionNumber > PlayWindow.VTMP.Positions.Length - 1 then
        Module_SetCurrentPosition(PlayWindow.VTMP.Positions.Length - 1)
      else
        Module_SetCurrentPosition(LeadWindow.PositionNumber);
      Exit;
    end;

    if PlVars[CurChip].CurrentPosition = ToPosition then begin

      if PlayAll then
        Module_SetCurrentPosition(PlayWindow.VTMP.Positions.Loop)
      else
        Module_SetCurrentPosition(FromPosition);

      if ExportLoops > 0 then
        Dec(ExportLoops)
      else
        ExportFinished := True;

    end
    else
      Module_SetCurrentPosition(PlVars[CurChip].CurrentPosition+1);

    LeadWindow.PositionNumber := PlVars[CurChip].CurrentPosition;
  end;


  procedure FillBuffer;
  var
    i, j: Integer;
    Left, Right: Double;
  const
    MaxPeak = 1.6;
    MinPeak = -1.6;
  begin
    RealBufferSize := 0;

    for i := 0 to AudioBufferSize-1 do begin

      isrCounter := isrCounter + isrStep;
      if isrCounter >= 1 then begin
        isrCounter := isrCounter - 1;

        Module_SetPointer(PlayingWindow[1].VTMP, 1);
        if Pattern_PlayCurrentLine = 2 then begin
          ChangePositions(PlayingWindow[1]);
          if not ExportFinished then
            Pattern_PlayCurrentLine;
        end;
        SetAyumiParams(ayumi1, 1);

        if ayumi2 <> nil then begin
          Module_SetPointer(PlayingWindow[2].VTMP, 2);
          if Pattern_PlayCurrentLine = 2 then begin
            ChangePositions(PlayingWindow[2]);
            if not ExportFinished then
              Pattern_PlayCurrentLine;
          end;
          SetAyumiParams(ayumi2, 2);
        end;

      end;

      ayumi1.Process;
      ayumi1.RemoveDC;

      if ayumi2 <> nil then begin
        ayumi2.Process;
        ayumi2.RemoveDC;
      end;

      Left  := ayumi1.left;
      Right := ayumi1.right;
      if ayumi2 <> nil then begin
        Left  := Left + ayumi2.left;
        Right := Right + ayumi2.right;
      end;

      if Left > MaxPeak then Left := MaxPeak;
      if Left < MinPeak then Left := MinPeak;
      if Right > MaxPeak then Right := MaxPeak;
      if Right < MinPeak then Right := MinPeak;

      
      case NumChannels of

        // MONO
        1: case BitRate of

          16: begin
            AudioBuff16Mono[i] := Round(((Left + Right) / 2) * $4FFF);
          end;
          24: begin
            j := Round(((Left + Right) / 2) * $4FFFFF);
            AudioBuff24Mono[i].b1 := j and $FF;
            AudioBuff24Mono[i].b2 := j shr 8;
            AudioBuff24Mono[i].b3 := j shr 16;
          end;
          32: begin
            AudioBuff32Mono[i] := Round(((Left + Right) / 2) * $4FFFFFFF);
          end;
        end;

        // STEREO
        2: case BitRate of

          16: begin
            AudioBuff16Stereo[i][0] := Round(Left * $4FFF);
            AudioBuff16Stereo[i][1] := Round(Right * $4FFF);
          end;
          24: begin
            j := Round(Left * $4FFFFF);
            AudioBuff24Stereo[i][0].b1 := j and $FF;
            AudioBuff24Stereo[i][0].b2 := j shr 8;
            AudioBuff24Stereo[i][0].b3 := j shr 16;
            j := Round(Right * $4FFFFF);
            AudioBuff24Stereo[i][1].b1 := j and $FF;
            AudioBuff24Stereo[i][1].b2 := j shr 8;
            AudioBuff24Stereo[i][1].b3 := j shr 16;
          end;
          32: begin
            AudioBuff32Stereo[i][0] := Round(Left * $4FFFFFFF);
            AudioBuff32Stereo[i][1] := Round(Right * $4FFFFFFF);
          end;
        end;

      end;

      RealBufferSize := i;
      if ExportFinished then Break;

    end;


  end;

  procedure RestorePositionAndPattern(Child: TMDIChild; PosNum, PatNum: Integer);
  begin
    Child.PositionNumber := PosNum;
    Child.PatNum := PatNum;
    Child.Tracks.HideMyCaret;
    Child.Tracks.RedrawTracks(0);
    Child.Tracks.ShowMyCaret;
  end;

begin
  MainForm.DisableControlsForExport;
  PrevPatNum2 := 0;
  PrevPosNum2 := 0;

  isrCounter := 1;
  isrStep := (PlayingWindow[1].VTMP.IntFreq / 1000) / ExportOptions.GetSampleRate;
  CurPosition := 0;
  BitRate := ExportOptions.GetBitRate;
  NumChannels := ExportOptions.GetNumChannels;
  PlayAll := not ExportOptions.ExportSelected.Checked;

  PrevChanAlloc := ChanAllocIndex;
  PrevLoopAllowed := LoopAllowed;

  // If mono, then set ABC
  if ChanAllocIndex = 0 then
    MainForm.SetChannelsAllocation(1);


  if IsPlaying then StopPlaying;
  PlayMode := PMPlayModule;


  // Set chip & audio params for export
  ayumi1 := TAyumi.Create;
  ayumi1.Configure(ExportOptions.GetChip = YM_Chip, AY_Freq, ExportOptions.GetSampleRate, DCType);
  ayumi1.SetPan(0, Panoram[0]/255, False);
  ayumi1.SetPan(1, Panoram[1]/255, False);
  ayumi1.SetPan(2, Panoram[2]/255, False);

  ayumi2 := nil;
  if PlayingWindow[2] <> nil then begin
    ayumi2 := TAyumi.Create;
    ayumi2.Configure(ExportOptions.GetChip = YM_Chip, AY_Freq, ExportOptions.GetSampleRate, DCType);
    ayumi2.SetPan(0, Panoram[0]/255, False);
    ayumi2.SetPan(1, Panoram[1]/255, False);
    ayumi2.SetPan(2, Panoram[2]/255, False);
  end;



  // Set from and to position
  if PlayAll then begin
    FromPosition := 0;
    ToPosition   := PlayingWindow[1].VTMP.Positions.Length - 1;
    LeadWindow   := PlayingWindow[1];
  end

  else if (PlayingWindow[1].StringGrid1.Selection.Right > PlayingWindow[1].StringGrid1.Selection.Left) then begin
    FromPosition := PlayingWindow[1].StringGrid1.Selection.Left;
    ToPosition   := PlayingWindow[1].StringGrid1.Selection.Right;
    LeadWindow   := PlayingWindow[1];
  end

  else if (PlayingWindow[2] <> nil) and (PlayingWindow[2].StringGrid1.Selection.Right > PlayingWindow[2].StringGrid1.Selection.Left) then begin
    FromPosition := PlayingWindow[2].StringGrid1.Selection.Left;
    ToPosition   := PlayingWindow[2].StringGrid1.Selection.Right;
    LeadWindow   := PlayingWindow[2];
  end

  else begin
    FromPosition := PlayingWindow[1].PositionNumber;
    ToPosition   := PlayingWindow[1].PositionNumber;
    LeadWindow   := PlayingWindow[1];
  end;

  PrevPosNum1 := LeadWindow.PositionNumber;
  PrevPatNum1 := LeadWindow.PatNum;
  if LeadWindow.TSWindow <> nil then begin
    PrevPosNum2 := LeadWindow.TSWindow.PositionNumber;
    PrevPatNum2 := LeadWindow.TSWindow.PatNum;
  end;


  
  // Init pointer, position, delay
  InitForAllTypes(True);
  for i := 1 to NumberOfSoundChips do
  begin
    Module_SetPointer(PlayingWindow[i].VTMP, i);
    Module_SetDelay(PlayingWindow[i].VTMP.Initial_Delay);

    if (PlayingWindow[i] = LeadWindow) or (FromPosition <= PlayingWindow[i].VTMP.Positions.Length-1) then
      Module_SetCurrentPosition(FromPosition)
    else
      Module_SetCurrentPosition(PlayingWindow[i].VTMP.Positions.Length-1);
  end;


  // Set loop repeats
  ExportLoops := ExportOptions.GetRepeats;

  // Show export modal
  ExportModal := TExport.Create(MainForm);
  ExportModal.ExportProgress.Position := 1;
  ExportModal.ExportProgress.Step := 1;
  ExportModal.ExportProgress.Min  := 0;
  ExportModal.ExportProgress.Max  := PlayingWindow[1].VTMP.Positions.Length +
    ((PlayingWindow[1].VTMP.Positions.Length - PlayingWindow[1].VTMP.Positions.Loop) * ExportLoops);
  ExportModal.Show;

  
  // Prepare memory stream and buffer
  TMPFileName := FileName+'.tmp';
  TMPFileStream := TFileStream.Create(TMPFileName, fmCreate);


  i := 0;
  ExportStarted  := True;
  ExportFinished := False;


  repeat

    if MainForm.VTExit or (GetAsyncKeyState(VK_ESCAPE) < 0) then
    begin
      TMPFileStream.Free;
      ExportModal.Free;
      ayumi1.Free;
      ayumi2.Free;
      
      DeleteFile(TMPFileName);

      ExportStarted := False;
      if MainForm.VTExit then
        Exit;

      LoopAllowed := PrevLoopAllowed;

      RestorePositionAndPattern(LeadWindow, PrevPosNum1, PrevPatNum1);
      if LeadWindow.TSWindow <> nil then
        RestorePositionAndPattern(LeadWindow.TSWindow, PrevPosNum2, PrevPatNum2);

      MainForm.SetChannelsAllocation(PrevChanAlloc);
      MainForm.EnableControlsForExport;
      Exit;
    end;


    // Reset buffer
    case NumChannels of

      1: case BitRate of
        8:  begin SetLength(AudioBuff8Mono,  0); SetLength(AudioBuff8Mono,  AudioBufferSize); end;
        16: begin SetLength(AudioBuff16Mono, 0); SetLength(AudioBuff16Mono, AudioBufferSize); end;
        24: begin SetLength(AudioBuff24Mono, 0); SetLength(AudioBuff24Mono, AudioBufferSize); end;
        32: begin SetLength(AudioBuff32Mono, 0); SetLength(AudioBuff32Mono, AudioBufferSize); end;
      end;

      2: case BitRate of
        8:  begin SetLength(AudioBuff8Stereo,  0); SetLength(AudioBuff8Stereo,  AudioBufferSize); end;
        16: begin SetLength(AudioBuff16Stereo, 0); SetLength(AudioBuff16Stereo, AudioBufferSize); end;
        24: begin SetLength(AudioBuff24Stereo, 0); SetLength(AudioBuff24Stereo, AudioBufferSize); end;
        32: begin SetLength(AudioBuff32Stereo, 0); SetLength(AudioBuff32Stereo, AudioBufferSize); end;
      end;

    end;



    // Make buffer and save to memory stream
    FillBuffer;

    // Save buffer
    case NumChannels of

      1: case BitRate of
        8:  TMPFileStream.Write(AudioBuff8Mono[0],  RealBufferSize);
        16: TMPFileStream.Write(AudioBuff16Mono[0], RealBufferSize*2);
        24: TMPFileStream.Write(AudioBuff24Mono[0], RealBufferSize*3);
        32: TMPFileStream.Write(AudioBuff32Mono[0], RealBufferSize*4);
      end;

      2: case BitRate of
        8:  TMPFileStream.Write(AudioBuff8Stereo[0],  RealBufferSize*2);
        16: TMPFileStream.Write(AudioBuff16Stereo[0], RealBufferSize*2*2);
        24: TMPFileStream.Write(AudioBuff24Stereo[0], RealBufferSize*2*3);
        32: TMPFileStream.Write(AudioBuff32Stereo[0], RealBufferSize*2*4);
      end;

    end;


    if CurPosition <> PlVars[1].CurrentPosition then
    begin
      ExportModal.ExportProgress.Position := ExportModal.ExportProgress.Position + 1;
      CurPosition := PlVars[1].CurrentPosition;
    end;

    
    // Process messages each 3 loops
    Inc(i);
    if i = 2 then
    begin
      Application.ProcessMessages;
      i := 0;
    end;


  until ExportFinished;

  ExportModal.Free;
  ayumi1.Free;
  ayumi2.Free;

  // Save wav
  CreateWaveHeader(TMPFileStream.Size, ExportOptions.GetSampleRate, BitRate, NumChannels, WaveHeader);

  FileStream := TFileStream.Create(FileName, fmCreate);
  FileStream.Seek(0, soFromBeginning);
  FileStream.Write(WaveHeader, SizeOf(WaveHeader));
  TMPFileStream.Position := 0;
  FileStream.CopyFrom(TMPFileStream, TMPFileStream.Size);

  FileStream.Free;
  TMPFileStream.Free;
  DeleteFile(TMPFileName);

  // Set child positions
  RestorePositionAndPattern(LeadWindow, PrevPosNum1, PrevPatNum1);
  if LeadWindow.TSWindow <> nil then
    RestorePositionAndPattern(LeadWindow.TSWindow, PrevPosNum2, PrevPatNum2);

  // Restore controls
  MainForm.EnableControlsForExport;
  MainForm.SetChannelsAllocation(PrevChanAlloc);
  LoopAllowed := PrevLoopAllowed;

  ExportStarted := True;
  ExportStarted := False;

end;





initialization

  WOEventH := CreateEvent(nil, False, False, nil);
  InitializeCriticalSection(WOCS);

finalization

  DeleteCriticalSection(WOCS);
  CloseHandle(WOEventH);

end.
