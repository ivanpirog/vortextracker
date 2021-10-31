{
This is part of Vortex Tracker II project

(c)2000-2009 S.V.Bulba
Author: Sergey Bulba, vorobey@mail.khstu.ru
Support page: http://bulba.untergrund.net/

Version 2.0 and later
(c)2017-2018 Ivan Pirog, ivan.pirog@gmail.com
}

unit AY;

interface

uses Windows, trfuncs, WaveOutAPI, ayumi;

type
//Available soundchips
  ChTypes = (No_Chip, AY_Chip, YM_Chip);
  TPlayModes = (PMPlayModule, PMPlayPattern, PMPlayLine);

const
{//Two amplitude tables of sound chips (c)Hacker KAY
  Amplitudes_AY: array[0..15] of Word =
  (0, 836, 1212, 1773, 2619, 3875, 5397, 8823, 10392, 16706, 23339,
    29292, 36969, 46421, 55195, 65535);
    
  Amplitudes_YM: array[0..31] of Word =
  (0, 0, $F8, $1C2, $29E, $33A, $3F2, $4D7, $610, $77F, $90A, $A42,
    $C3B, $EC2, $1137, $13A7, $1750, $1BF9, $20DF, $2596, $2C9D, $3579,
    $3E55, $4768, $54FF, $6624, $773B, $883F, $A1DA, $C0FC, $E094, $FFFF); }


  // Two amplitude tables of sound chips (c) Introspec
  Amplitudes_AY: array[0..15] of Word =
  (
    $0000, $028F, $03B3, $0564, $07DC, $0BA9, $1083, $1B7C, $2068, $347A, $4ACE,
    $5F72, $7E16, $A2A4, $CE3A, $FFFF
  );

  Amplitudes_YM: array[0..31] of Word =
  (
    $0000, $0000, $0131, $01FA, $02CE, $0393, $045A, $0520, $063D, $079A, $08FA,
    $0A57, $0C6D, $0EEF, $116C, $13E9, $17AF, $1C70, $2137, $2603, $2D3A, $3628,
    $3F13, $47F6, $556F, $6682, $77A6, $88D0, $A29A, $C20C, $E142, $FFFF
  );


  AY_Freq_Def = 1750000; //1773400;
  Interrupt_Freq_Def = 48828; //50000;
  NumberOfChannels_Def = 2;
  SampleRate_Def = 44100;
  SampleBit_Def = 16;
  Index_AL_Def = 255;
  Index_AR_Def = 13;
  Index_BL_Def = 170;
  Index_BR_Def = 170;
  Index_CL_Def = 13;
  Index_CR_Def = 255;
  StdChannelsAllocationDef = 1;
  Filt_NKoefs = 32; //powers of 2

type
  PRegisters = ^TRegisters;
  TRegisters = packed record
    case Boolean of
      True: (Index: array[0..13] of byte);
      False: (TonA, TonB, TonC: word;
        Noise, Mixer: byte;
        AmplitudeA, AmplitudeB, AmplitudeC: byte;
        Envelope: word;
        EnvType: byte);
  end;
  TSoundChip = object
    AYRegisters: TRegisters;
    First_Period: boolean;
    Ampl: integer;
    Ton_Counter_A, Ton_Counter_B, Ton_Counter_C, Noise_Counter: packed record
      case integer of
        0: (Lo: word;
          Hi: word);
        1: (Re: longword);
    end;
    Envelope_Counter: packed record
      case integer of
        0: (Lo: dword;
          Hi: dword);
        1: (Re: int64);
    end;
    Ton_A, Ton_B, Ton_C: integer;
    Noise: packed record
      case boolean of
        True: (Seed: longword);
        False: (Low: word;
          Val: dword);
    end;
    Case_EnvType: procedure of object;
    Ton_EnA, Ton_EnB, Ton_EnC, Noise_EnA, Noise_EnB, Noise_EnC: boolean;
    Envelope_EnA, Envelope_EnB, Envelope_EnC: boolean;
    procedure Case_EnvType_0_3__9;
    procedure Case_EnvType_4_7__15;
    procedure Case_EnvType_8;
    procedure Case_EnvType_10;
    procedure Case_EnvType_11;
    procedure Case_EnvType_12;
    procedure Case_EnvType_13;
    procedure Case_EnvType_14;
    procedure Synthesizer_Logic_Q;
    procedure Synthesizer_Logic_P;
    procedure SetMixerRegister(Value: byte);
    procedure SetEnvelopeRegister(Value: byte);
    procedure SetAmplA(Value: byte);
    procedure SetAmplB(Value: byte);
    procedure SetAmplC(Value: byte);
    procedure Synthesizer_Mixer_Q;
    procedure Synthesizer_Mixer_Q_Mono;

  end;
  TFilt_K = array of integer;


var
  Filt_M: integer = Filt_NKoefs;
  IsFilt: boolean = True;
  Filt_K, Filt_XL, Filt_XR: TFilt_K;
  Filt_I: integer;
  PlayMode: TPlayModes;
  DCType, DCCutOff: Integer;

  NumberOfSoundChips: integer = MaxNumberOfSoundChips;

 //Sound chip parameters
  SoundChip: array[1..MaxNumberOfSoundChips] of TSoundChip;
  AyumiChip1, AyumiChip2: TAyumi;

 //Parameters for all sound chips
  Index_AL, Index_AR, Index_BL, Index_BR, Index_CL, Index_CR: byte;
  Emulating_Chip: ChTypes;
  AY_Freq: integer;
  Level_AR, Level_AL, Level_BR, Level_BL, Level_CR, Level_CL: array[0..31] of Integer;
  LevelL, LevelR, Left_Chan, Right_Chan: integer;
  Tick_Counter: byte;
  Tik: packed record
    case Integer of
      0: (Lo: Word;
        Hi: word);
      1: (Re: dword);
  end;
  Delay_in_tiks: dword;
  Current_Tik: longword;
  Number_Of_Tiks: packed record
    case boolean of
      false: (lo: longword;
        hi: longword);
      true: (re: int64);
  end;
  IntFlag: boolean;
  AY_Tiks_In_Interrupt: longword;
  Synthesizer: procedure(Buf: pointer);
  StdChannelsAllocation: integer;

  Real_End: array[1..MaxNumberOfSoundChips] of boolean;
  Real_End_All, LoopAllowed: boolean;


(*type
 TFilt_K = array of integer;
var
 Filt_M:integer = Filt_NKoefs;
 IsFilt:boolean = True;
 Filt_K,Filt_XL,Filt_XR:TFilt_K;
 Filt_I:integer;
 PlayMode:TPlayModes;
 Index_AL,Index_AR,Index_BL,Index_BR,Index_CL,Index_CR:byte;
 Emulating_Chip:ChTypes;
 AY_Freq:integer;
 First_Period:boolean;
 Ampl:integer;
 Ton_Counter_A,
 Ton_Counter_B,
 Ton_Counter_C,
 Noise_Counter:packed record
     case integer of
      0:(Lo:word;
         Hi:word);
      1:(Re:longword);
     end;
 Envelope_Counter:packed record
     case integer of
     0:(Lo:dword;
        Hi:dword);
     1:(Re:int64);
     end;
 Ton_A,Ton_B,Ton_C:integer;
 Noise:packed record
     case boolean of
      True: (Seed:longword);
      False:(Low:word;
             Val:dword);
     end;
 Level_AR,Level_AL,
 Level_BR,Level_BL,
 Level_CR,Level_CL:array[0..31]of Integer;
 Left_Chan,Right_Chan:integer;
 Tick_Counter:byte;
 Tik:packed record
     Case Integer of
      0:(Lo:Word;
         Hi:word);
      1:(Re:dword);
     end;
 Delay_in_tiks:dword;
 Case_EnvType:procedure;
 Ton_EnA,Ton_EnB,
 Ton_EnC,Noise_EnA,
 Noise_EnB,Noise_EnC:boolean;
 Envelope_EnA,Envelope_EnB,Envelope_EnC:boolean;
 Current_Tik:longword;*)
  RenderEngine: Integer = 2;
(* Number_Of_Tiks:packed record
     case boolean of
      false:(lo:longword;
             hi:longword);
      true: (re:int64);
     end;
 IntFlag:boolean;
 AY_Tiks_In_Interrupt:longword;
 Synthesizer:procedure(Buf:pointer);
 Real_End,LoopAllowed:boolean;
 StdChannelsAllocation:integer;*)

procedure SetAyumiRegisters(Ayumi: TAyumi; r:PRegisters);
procedure Synthesizer_Ayumi(Buf: pointer);
procedure Synthesizer_Stereo16(Buf: pointer);
procedure Synthesizer_Stereo16_P(Buf: pointer);
procedure Synthesizer_Stereo8(Buf: pointer);
procedure Synthesizer_Stereo8_P(Buf: pointer);
procedure Synthesizer_Mono16(Buf: pointer);
procedure Synthesizer_Mono16_P(Buf: pointer);
procedure Synthesizer_Mono8(Buf: pointer);
procedure Synthesizer_Mono8_P(Buf: pointer);
procedure UpdatePanoram;
procedure MakeBuffer(Buf: pointer);
(*procedure SetEnvelopeRegister(Value:byte);
procedure SetMixerRegister(Value:byte);
procedure SetAmplA(Value:byte);
procedure SetAmplB(Value:byte);
procedure SetAmplC(Value:byte);*)
procedure SetDefault(samrate, nchan, sambit: integer);
procedure Calculate_Level_Tables;
function ToggleChanMode: string;
function SetStdChannelsAllocation(CA: integer): string;
procedure SetIntFreq(f: integer);
procedure SetSampleRate(f: integer);
procedure SetBuffers(len, num: integer);
procedure SetBitRate(SB: integer);
procedure SetNChans(St: integer);
procedure Set_Engine(EngineIndex: Integer);
procedure SetAYFreq(f: integer);
procedure SetFilter(Filt: boolean; M: integer);
procedure CalcFiltKoefs;

implementation

uses Childwin, Main;

{$J+} { Assignable Typed Constant }

type
  T24Bit = record
     b1, b2, b3: Byte
  end;

  TS16 = packed array[0..0] of record
    Left: smallint;
    Right: smallint;
  end;
  PS16 = ^TS16;
  
  TS8 = packed array[0..0] of record
    Left: byte;
    Right: byte;
  end;
  PS8 = ^TS8;

  TS24 = packed array[0..0] of record
    Left: T24Bit;
    Right: T24Bit;
  end;
  PS24 = ^TS24;

  TS32 = packed array[0..0] of record
    Left: Integer;
    Right: Integer;
  end;
  PS32 = ^TS32;

  TM16 = packed array[0..0] of smallint;
  PM16 = ^TM16;

  TM8 = packed array[0..0] of byte;
  PM8 = ^TM8;

  TM24 = packed array[0..0] of T24Bit;
  PM24 = ^TM24;

  TM32 = packed array[0..0] of Integer;
  PM32 = ^TM32;

procedure TSoundChip.Case_EnvType_0_3__9;
begin
  if First_Period then
  begin
    dec(Ampl);
    if Ampl = 0 then First_Period := False
  end
end;

procedure TSoundChip.Case_EnvType_4_7__15;
begin
  if First_Period then
  begin
    Inc(Ampl);
    if Ampl = 32 then
    begin
      First_Period := False;
      Ampl := 0
    end
  end
end;

procedure TSoundChip.Case_EnvType_8;
begin
  Ampl := (Ampl - 1) and 31
end;

procedure TSoundChip.Case_EnvType_10;
begin
  if First_Period then
  begin
    dec(Ampl);
    if Ampl < 0 then
    begin
      First_Period := False;
      Ampl := 0
    end
  end
  else
  begin
    inc(Ampl);
    if Ampl = 32 then
    begin
      First_Period := True;
      Ampl := 31
    end
  end
end;

procedure TSoundChip.Case_EnvType_11;
begin
  if First_Period then
  begin
    dec(Ampl);
    if Ampl < 0 then
    begin
      First_Period := False;
      Ampl := 31
    end
  end
end;

procedure TSoundChip.Case_EnvType_12;
begin
  Ampl := (Ampl + 1) and 31
end;

procedure TSoundChip.Case_EnvType_13;
begin
  if First_Period then
  begin
    inc(Ampl);
    if Ampl = 32 then
    begin
      First_Period := False;
      Ampl := 31
    end
  end
end;

procedure TSoundChip.Case_EnvType_14;
begin
  if not First_Period then
  begin
    dec(Ampl);
    if Ampl < 0 then
    begin
      First_Period := True;
      Ampl := 0
    end
  end
  else
  begin
    inc(Ampl);
    if Ampl = 32 then
    begin
      First_Period := False;
      Ampl := 31
    end
  end
end;

function NoiseGenerator(Seed: integer): integer;
asm
 shld edx,eax,16
 shld ecx,eax,19
 xor ecx,edx
 and ecx,1
 add eax,eax
 and eax,$1ffff
 inc eax
 xor eax,ecx
end;

procedure TSoundChip.Synthesizer_Logic_Q;
begin
  inc(Ton_Counter_A.Hi);
  if Ton_Counter_A.Hi >= AYRegisters.TonA then
  begin
    Ton_Counter_A.Hi := 0;
    Ton_A := Ton_A xor 1
  end;
  inc(Ton_Counter_B.Hi);
  if Ton_Counter_B.Hi >= AYRegisters.TonB then
  begin
    Ton_Counter_B.Hi := 0;
    Ton_B := Ton_B xor 1
  end;
  inc(Ton_Counter_C.Hi);
  if Ton_Counter_C.Hi >= AYRegisters.TonC then
  begin
    Ton_Counter_C.Hi := 0;
    Ton_C := Ton_C xor 1
  end;
  inc(Noise_Counter.Hi);
  if (Noise_Counter.Hi and 1 = 0) and
    (Noise_Counter.Hi >= AYRegisters.Noise shl 1) then
  begin
    Noise_Counter.Hi := 0;
    Noise.Seed := NoiseGenerator(Noise.Seed);
  end;
  if Envelope_Counter.Hi = 0 then Case_EnvType;
  inc(Envelope_Counter.Hi);
  if Envelope_Counter.Hi >= AYRegisters.Envelope then
    Envelope_Counter.Hi := 0
end;

procedure TSoundChip.Synthesizer_Logic_P;
var
  k: word;
  k2: longword;
begin

  inc(Ton_Counter_A.Re, Delay_In_Tiks);
  k := AYRegisters.TonA; if k = 0 then inc(k);
  if k <= Ton_Counter_A.Hi then
  begin
    Ton_A := Ton_A xor ((Ton_Counter_A.Hi div k) and 1);
    Ton_Counter_A.Hi := Ton_Counter_A.Hi mod k
  end;

  inc(Ton_Counter_B.Re, Delay_In_Tiks);
  k := AYRegisters.TonB; if k = 0 then inc(k);
  if k <= Ton_Counter_B.Hi then
  begin
    Ton_B := Ton_B xor ((Ton_Counter_B.Hi div k) and 1);
    Ton_Counter_B.Hi := Ton_Counter_B.Hi mod k
  end;

  inc(Ton_Counter_C.Re, Delay_In_Tiks);
  k := AYRegisters.TonC; if k = 0 then inc(k);
  if k <= Ton_Counter_C.Hi then
  begin
    Ton_C := Ton_C xor ((Ton_Counter_C.Hi div k) and 1);
    Ton_Counter_C.Hi := Ton_Counter_C.Hi mod k
  end;

  inc(Noise_Counter.Re, Delay_In_Tiks);
  k := AYRegisters.Noise; if k = 0 then inc(k);
  k := k shl 1;
  if Noise_Counter.Hi >= k then
  begin
    Noise_Counter.Hi := Noise_Counter.Hi mod k;
    Noise.Seed := NoiseGenerator(Noise.Seed);
  end;

  k2 := AYRegisters.Envelope; if k2 = 0 then inc(k2);
  if Envelope_Counter.Hi = 0 then inc(Envelope_Counter.Hi, k2);
  while (Envelope_Counter.Hi >= k2) do
  begin
    dec(Envelope_Counter.Hi, k2);
    Case_EnvType
  end;
  inc(Envelope_Counter.Re, int64(Delay_In_Tiks) shl 16)
end;

procedure TSoundChip.SetMixerRegister(Value: byte);
begin
  AYRegisters.Mixer := Value;
  Ton_EnA := (Value and 1) = 0;
  Noise_EnA := (Value and 8) = 0;
  Ton_EnB := (Value and 2) = 0;
  Noise_EnB := (Value and 16) = 0;
  Ton_EnC := (Value and 4) = 0;
  Noise_EnC := (Value and 32) = 0
end;

procedure TSoundChip.SetEnvelopeRegister(Value: byte);
begin
  Envelope_Counter.Hi := 0;
  First_Period := True;
  if (Value and 4) = 0 then
    ampl := 32
  else
    ampl := -1;
  AYRegisters.EnvType := Value;
  case Value of
    0..3, 9: Case_EnvType := Case_EnvType_0_3__9;
    4..7, 15: Case_EnvType := Case_EnvType_4_7__15;
    8: Case_EnvType := Case_EnvType_8;
    10: Case_EnvType := Case_EnvType_10;
    11: Case_EnvType := Case_EnvType_11;
    12: Case_EnvType := Case_EnvType_12;
    13: Case_EnvType := Case_EnvType_13;
    14: Case_EnvType := Case_EnvType_14;
  end;
end;

procedure TSoundChip.SetAmplA(Value: byte);
begin
  AYRegisters.AmplitudeA := Value;
  Envelope_EnA := (Value and 16) = 0;
end;

procedure TSoundChip.SetAmplB(Value: byte);
begin
  AYRegisters.AmplitudeB := Value;
  Envelope_EnB := (Value and 16) = 0;
end;

procedure TSoundChip.SetAmplC(Value: byte);
begin
  AYRegisters.AmplitudeC := Value;
  Envelope_EnC := (Value and 16) = 0;
end;

//sorry for assembler, I can't make effective qword procedure on pascal...

function ApplyFilter(Lev: integer; var Filt_X: TFilt_K): integer;
asm
        push    ebx
        push    esi
        push    edi
        add     esp,-8
        mov     ecx,Filt_M
        mov     edi,Filt_K
        lea     esi,edi+ecx*4
        mov     ebx,[edx]
        mov     ecx,Filt_I
        mov     [ebx+ecx*4],eax
        imul    dword ptr [edi]
        mov     [esp],eax
        mov     [esp+4],edx
@lp:    dec     ecx
        jns     @gz
        mov     ecx,Filt_M
@gz:    mov     eax,[ebx+ecx*4]
        add     edi,4
        imul    dword ptr [edi]
        add     [esp],eax
        adc     [esp+4],edx
        cmp     edi,esi
        jnz     @lp
        mov     Filt_I,ecx
        pop     eax
        pop     edx
        pop     edi
        pop     esi
        pop     ebx
        test    edx,edx
        jns     @nm
        add     eax,0FFFFFFh
        adc     edx,0
@nm:    shrd    eax,edx,24
end;

procedure TSoundChip.Synthesizer_Mixer_Q;
var
  LevL, LevR, k: integer;
begin
  LevL := 0;
  LevR := LevL;

  k := 1;
  if Ton_EnA then k := Ton_A;
  if Noise_EnA then k := k and Noise.Val;
  if k <> 0 then
  begin
    if Envelope_EnA then
    begin
      inc(LevL, Level_AL[AYRegisters.AmplitudeA * 2 + 1]);
      inc(LevR, Level_AR[AYRegisters.AmplitudeA * 2 + 1])
    end
    else
    begin
      inc(LevL, Level_AL[Ampl]);
      inc(LevR, Level_AR[Ampl])
    end
  end;

  k := 1;
  if Ton_EnB then k := Ton_B;
  if Noise_EnB then k := k and Noise.Val;
  if k <> 0 then
    if Envelope_EnB then
    begin
      inc(LevL, Level_BL[AYRegisters.AmplitudeB * 2 + 1]);
      inc(LevR, Level_BR[AYRegisters.AmplitudeB * 2 + 1])
    end
    else
    begin
      inc(LevL, Level_BL[Ampl]);
      inc(LevR, Level_BR[Ampl])
    end;

  k := 1;
  if Ton_EnC then k := Ton_C;
  if Noise_EnC then k := k and Noise.Val;
  if k <> 0 then
    if Envelope_EnC then
    begin
      inc(LevL, Level_CL[AYRegisters.AmplitudeC * 2 + 1]);
      inc(LevR, Level_CR[AYRegisters.AmplitudeC * 2 + 1])
    end
    else
    begin
      inc(LevL, Level_CL[Ampl]);
      inc(LevR, Level_CR[Ampl])
    end;

  inc(LevelL, LevL);
  inc(LevelR, LevR)
end;


function packPosPatLine(PositionNumber, PatternNumber, LineNumber: Integer): Integer;
begin
  Result := (PositionNumber and $1FF) +
            (PatternNumber  shl 9)    +
            (LineNumber     shl 17);
end;

procedure FillPlayGrid;
var k: Cardinal;
begin
  k := NOfTicks div PlayGridLen;
  MkVisPos := NOfTicks - (PlayGridLen * k);

  with PlVars[1] do
    PlayingGrid[MkVisPos].M1 := packPosPatLine(CurrentPosition, CurrentPattern, CurrentLine - 1);

  if NumberOfSoundChips > 1 then
    with PlVars[2] do
      PlayingGrid[MkVisPos].M2 := packPosPatLine(CurrentPosition, CurrentPattern, CurrentLine - 1);
end;


procedure SetAyumiRegisters(Ayumi: TAyumi; r:PRegisters);
begin
  Ayumi.SetTone(0, (r.Index[1] shl 8) or r.Index[0]);
  Ayumi.SetTone(1, (r.Index[3] shl 8) or r.Index[2]);
  Ayumi.SetTone(2, (r.Index[5] shl 8) or r.Index[4]);
  Ayumi.SetNoise(r.Index[6]);
  Ayumi.SetMixer(0, r.Index[7] and 1, (r.Index[7] shr 3) and 1, r.Index[8] shr 4);
  Ayumi.SetMixer(1, (r.Index[7] shr 1) and 1, (r.Index[7] shr 4) and 1, (r.Index[9] shr 4) and 1);
  Ayumi.SetMixer(2, (r.Index[7] shr 2) and 1, (r.Index[7] shr 5) and 1, (r.Index[10] shr 4) and 1);
  Ayumi.SetVolume(0, r.Index[8] and $0f);
  Ayumi.SetVolume(1, r.Index[9] and $0f);
  Ayumi.SetVolume(2, r.Index[10] and $0f);
  Ayumi.SetEnvelope((r.Index[12] shl 8) or r.Index[11]);
  if (r.Index[13] <> 255) then
      ayumi.setEnvelopeShape(r.Index[13]);
  r.Index[13] := 255;
end;


procedure Synthesizer_Stereo16;
var
  Tmp: integer;
begin
  repeat
    Tmp := 0; LevelL := Tmp; LevelR := Tmp;
    for Tmp := 1 to NumberOfSoundChips do
    begin
      SoundChip[Tmp].Synthesizer_Logic_Q;
      SoundChip[Tmp].Synthesizer_Mixer_Q;
    end;
    if IsFilt then
    begin
      Tmp := Filt_I;
      LevelL := ApplyFilter(LevelL, Filt_XL);
      Filt_I := Tmp;
      LevelR := ApplyFilter(LevelR, Filt_XR)
    end;
    inc(Left_Chan, LevelL);
    inc(Right_Chan, LevelR);
    Inc(Current_Tik);
    Inc(Tick_Counter);
    if Tick_Counter >= Tik.Hi then
    begin
      Inc(Tik.Re, Delay_In_Tiks);
      Dec(Tik.Hi, Tick_Counter);
      Tmp := Left_Chan div Tick_Counter;
      if Tmp > 32767 then
        Tmp := 32767
      else if Tmp < -32768 then
        Tmp := -32768;
      PS16(Buf)^[BuffLen].Left := Tmp;
      Tmp := Right_Chan div Tick_Counter;
      if Tmp > 32767 then
        Tmp := 32767
      else if Tmp < -32768 then
        Tmp := -32768;
      PS16(Buf)^[BuffLen].Right := Tmp;

      FillPlayGrid;
      Inc(BuffLen);
      Inc(NOfTicks);

      Tmp := 0;
      Left_Chan := Tmp;
      Right_Chan := Tmp;
      Tick_Counter := Tmp;
      if BuffLen = BufferLength then
      begin
        if Current_Tik < Number_Of_Tiks.Hi then
          IntFlag := True;
        exit
      end
    end
  until Current_Tik >= Number_Of_Tiks.Hi;
  Tmp := 0;
  Number_Of_Tiks.hi := Tmp;
  Current_Tik := Tmp
end;

procedure Synthesizer_Stereo8;
var
  Tmp: integer;
begin
  repeat
    Tmp := 0; LevelL := Tmp; LevelR := Tmp;
    for Tmp := 1 to NumberOfSoundChips do
    begin
      SoundChip[Tmp].Synthesizer_Logic_Q;
      SoundChip[Tmp].Synthesizer_Mixer_Q;
    end;
    if IsFilt then
    begin
      Tmp := Filt_I;
      LevelL := ApplyFilter(LevelL, Filt_XL);
      Filt_I := Tmp;
      LevelR := ApplyFilter(LevelR, Filt_XR)
    end;
    inc(Left_Chan, LevelL);
    inc(Right_Chan, LevelR);
    Inc(Current_Tik);
    Inc(Tick_Counter);
    if Tick_Counter >= Tik.Hi then
    begin
      Inc(Tik.Re, Delay_In_Tiks);
      Dec(Tik.Hi, Tick_Counter);
      Tmp := Left_Chan div Tick_Counter;
      if Tmp > 127 then
        Tmp := 127
      else if Tmp < -128 then
        Tmp := -128;
      PS8(Buf)^[BuffLen].Left := 128 + Tmp;
      Tmp := Right_Chan div Tick_Counter;
      if Tmp > 127 then
        Tmp := 127
      else if Tmp < -128 then
        Tmp := -128;
      PS8(Buf)^[BuffLen].Right := 128 + Tmp;

      FillPlayGrid;
      Inc(BuffLen);
      Inc(NOfTicks);

      Tmp := 0;
      Left_Chan := Tmp;
      Right_Chan := Tmp;
      Tick_Counter := Tmp;
      if BuffLen = BufferLength then
      begin
        if Current_Tik < Number_Of_Tiks.Hi then
          IntFlag := True;
        exit
      end
    end
  until Current_Tik >= Number_Of_Tiks.Hi;
  Tmp := 0;
  Number_Of_Tiks.hi := Tmp;
  Current_Tik := Tmp
end;

procedure TSoundChip.Synthesizer_Mixer_Q_Mono;
var
  Lev, k: integer;
begin
  Lev := 0;

  k := 1;
  if Ton_EnA then k := Ton_A;
  if Noise_EnA then k := k and Noise.Val;
  if k <> 0 then
    if Envelope_EnA then
      inc(Lev, Level_AL[AYRegisters.AmplitudeA * 2 + 1])
    else
      inc(Lev, Level_AL[Ampl]);

  k := 1;
  if Ton_EnB then k := Ton_B;
  if Noise_EnB then k := k and Noise.Val;
  if k <> 0 then
    if Envelope_EnB then
      inc(Lev, Level_BL[AYRegisters.AmplitudeB * 2 + 1])
    else
      inc(Lev, Level_BL[Ampl]);

  k := 1;
  if Ton_EnC then k := Ton_C;
  if Noise_EnC then k := k and Noise.Val;
  if k <> 0 then
    if Envelope_EnC then
      inc(Lev, Level_CL[AYRegisters.AmplitudeC * 2 + 1])
    else
      inc(Lev, Level_CL[Ampl]);

  inc(LevelL, Lev)
end;


procedure Synthesizer_Ayumi;
const
  Volume: Integer = 0;
  LevelRatio: Double = 0;
  MaxPeak = 1.6;
  MinPeak = -1.6;

var
  r: PRegisters;
  Chip, k: Integer;
  Left, Right: Double;


begin

  for Chip := 1 to NumberOfSoundChips do begin

    r := @SoundChip[Chip].AYRegisters;
    if Chip = 1 then
      SetAyumiRegisters(AyumiChip1, r)
    else
      SetAyumiRegisters(AyumiChip2, r);

  end;

  repeat

    Inc(Current_Tik);
    Inc(Tick_Counter);
    if Tick_Counter >= Tik.Hi then begin

      Inc(Tik.Re, Delay_In_Tiks);
      Dec(Tik.Hi, Tick_Counter);

      AyumiChip1.Process;
      AyumiChip1.RemoveDC;

      Left  := AyumiChip1.left;
      Right := AyumiChip1.right;

      if NumberOfSoundChips = 2 then begin
        AyumiChip2.Process;
        AyumiChip2.RemoveDC;
        Left  := Left + AyumiChip2.left;
        Right := Right + AyumiChip2.right;
      end;

      if MainForm.GlobalVolume <> Volume then begin
        Volume := MainForm.GlobalVolume;
        LevelRatio := exp(Volume * ln(2) / MainForm.GlobalVolumeMax) - 1;
      end;

      Left  := Left * LevelRatio;
      Right := Right * LevelRatio;

      if Left > MaxPeak then Left := MaxPeak;
      if Left < MinPeak then Left := MinPeak;
      if Right > MaxPeak then Right := MaxPeak;
      if Right < MinPeak then Right := MinPeak;

      case NumberOfChannels of

        // MONO
        1: begin

          case SampleBit of
            16: begin
              PM16(Buf)^[BuffLen] := Round(((Left + Right) / 2) * $4FFF);
            end;

            24: begin
              k := Round(((Left + Right) / 2) * $4FFFFF);
              PM24(Buf)^[BuffLen].b1 := k and $FF;
              PM24(Buf)^[BuffLen].b2 := k shr 8;
              PM24(Buf)^[BuffLen].b3 := k shr 16;
            end;

            32: begin
              PM32(Buf)^[BuffLen] := Round(((Left + Right) / 2) * $4FFFFFFF);
            end;
          end;

        end;

        // STEREO
        2: begin

          case SampleBit of
            16: begin
              PS16(Buf)^[BuffLen].Left  := Round(Left * $4FFF);
              PS16(Buf)^[BuffLen].Right := Round(Right * $4FFF);
            end;

            24: begin
              k := Round(Left * $4FFFFF);
              PS24(Buf)^[BuffLen].Left.b1 := k and $FF;
              PS24(Buf)^[BuffLen].Left.b2 := k shr 8;
              PS24(Buf)^[BuffLen].Left.b3 := k shr 16;
              k := Round(Right * $4FFFFF);
              PS24(Buf)^[BuffLen].Right.b1 := k and $FF;
              PS24(Buf)^[BuffLen].Right.b2 := k shr 8;
              PS24(Buf)^[BuffLen].Right.b3 := k shr 16;
            end;

            32: begin
              PS32(Buf)^[BuffLen].Left  := Round(Left * $4FFFFFFF);
              PS32(Buf)^[BuffLen].Right := Round(Right * $4FFFFFFF);
            end;
          end;

        end;
      end;

      FillPlayGrid;
      Inc(BuffLen);
      Inc(NOfTicks);
      Tick_Counter := 0;

      if BuffLen = BufferLength then
      begin
        if Current_Tik < Number_Of_Tiks.Hi then
          IntFlag := True;
        Exit;
      end;
    end;
  until Current_Tik >= Number_Of_Tiks.Hi;

  Number_Of_Tiks.hi := 0;
  Current_Tik := 0;

end;


procedure Synthesizer_Mono16;
var
  Tmp: integer;
begin
  repeat
    LevelL := 0;
    for Tmp := 1 to NumberOfSoundChips do
    begin
      SoundChip[Tmp].Synthesizer_Logic_Q;
      SoundChip[Tmp].Synthesizer_Mixer_Q_Mono;
    end;
    if IsFilt then
      LevelL := ApplyFilter(LevelL, Filt_XL);
    inc(Left_Chan, LevelL);
    Inc(Current_Tik);
    Inc(Tick_Counter);
    if Tick_Counter >= Tik.Hi then
    begin
      Inc(Tik.Re, Delay_In_Tiks);
      Dec(Tik.Hi, Tick_Counter);
      Tmp := Left_Chan div Tick_Counter;
      if Tmp > 32767 then
        Tmp := 32767
      else if Tmp < -32768 then
        Tmp := -32768;
      PM16(Buf)^[BuffLen] := Tmp;

      FillPlayGrid;
      Inc(BuffLen);
      Inc(NOfTicks);

      Tmp := 0;
      Left_Chan := Tmp;
      Tick_Counter := Tmp;
      if BuffLen = BufferLength then
      begin
        if Current_Tik < Number_Of_Tiks.Hi then
          IntFlag := True;
        exit
      end
    end
  until Current_Tik >= Number_Of_Tiks.Hi;
  Tmp := 0;
  Number_Of_Tiks.hi := Tmp;
  Current_Tik := Tmp
end;

procedure Synthesizer_Mono8;
var
  Tmp: integer;
begin
  repeat
    LevelL := 0;
    for Tmp := 1 to NumberOfSoundChips do
    begin
      SoundChip[Tmp].Synthesizer_Logic_Q;
      SoundChip[Tmp].Synthesizer_Mixer_Q_Mono;
    end;
    if IsFilt then
      LevelL := ApplyFilter(LevelL, Filt_XL);
    inc(Left_Chan, LevelL);
    inc(Current_Tik);
    inc(Tick_Counter);
    if Tick_Counter >= Tik.Hi then
    begin
      Inc(Tik.Re, Delay_In_Tiks);
      dec(Tik.Hi, Tick_Counter);
      Tmp := Left_Chan div Tick_Counter;
      if Tmp > 127 then
        Tmp := 127
      else if Tmp < -128 then
        Tmp := -128;
      PM8(Buf)^[BuffLen] := 128 + Tmp;

      FillPlayGrid;
      Inc(BuffLen);
      Inc(NOfTicks);

      Tmp := 0;
      Left_Chan := Tmp;
      Tick_Counter := Tmp;
      if BuffLen = BufferLength then
      begin
        if Current_Tik < Number_Of_Tiks.Hi then
          IntFlag := True;
        exit
      end
    end
  until Current_Tik >= Number_Of_Tiks.Hi;
  Tmp := 0;
  Number_Of_Tiks.hi := Tmp;
  Current_Tik := Tmp
end;

procedure Synthesizer_Stereo16_P;
var
  LevL, LevR, k, c: integer;
begin
  repeat

    Inc(Current_Tik);
    Inc(Tick_Counter);
    if Tick_Counter >= Tik.Hi then begin
      Inc(Tik.Re, Delay_In_Tiks);
      Dec(Tik.Hi, Tick_Counter);

      for c := 1 to NumberOfSoundChips do
        SoundChip[c].Synthesizer_Logic_P;

      LevL := 0;
      LevR := LevL;

      for c := 1 to NumberOfSoundChips do
        with SoundChip[c] do
        begin
          k := 1;
          if Ton_EnA then k := Ton_A;
          if Noise_EnA then k := k and Noise.Val;
          if k <> 0 then
            if Envelope_EnA then
            begin
              inc(LevL, Level_AL[AYRegisters.AmplitudeA * 2 + 1]);
              inc(LevR, Level_AR[AYRegisters.AmplitudeA * 2 + 1])
            end
            else
            begin
              inc(LevL, Level_AL[Ampl]);
              inc(LevR, Level_AR[Ampl])
            end;

          k := 1;
          if Ton_EnB then k := Ton_B;
          if Noise_EnB then k := k and Noise.Val;
          if k <> 0 then
            if Envelope_EnB then
            begin
              inc(LevL, Level_BL[AYRegisters.AmplitudeB * 2 + 1]);
              inc(LevR, Level_BR[AYRegisters.AmplitudeB * 2 + 1])
            end
            else
            begin
              inc(LevL, Level_BL[Ampl]);
              inc(LevR, Level_BR[Ampl])
            end;

          k := 1;
          if Ton_EnC then k := Ton_C;
          if Noise_EnC then k := k and Noise.Val;
          if k <> 0 then
            if Envelope_EnC then
            begin
              inc(LevL, Level_CL[AYRegisters.AmplitudeC * 2 + 1]);
              inc(LevR, Level_CR[AYRegisters.AmplitudeC * 2 + 1])
            end
            else
            begin
              inc(LevL, Level_CL[Ampl]);
              inc(LevR, Level_CR[Ampl])
            end;
        end;

      if LevL > 32767 then LevL := 32767;
      if LevR > 32767 then LevR := 32767;

      PS16(Buf)^[BuffLen].Left := LevL;
      PS16(Buf)^[BuffLen].Right := LevR;

      FillPlayGrid;
      Inc(BuffLen);
      Inc(NOfTicks);
      Tick_Counter := 0;

      if BuffLen = BufferLength then
      begin
        if Current_Tik < Number_Of_Tiks.Hi then
          IntFlag := True;
        exit
      end;
    end;
  until Current_Tik >= Number_Of_Tiks.Hi;
  k := 0;
  Number_Of_Tiks.hi := k;
  Current_Tik := k
end;

procedure Synthesizer_Stereo8_P;
var
  LevL, LevR, k, c: integer;
begin
  repeat

    Inc(Current_Tik);
    Inc(Tick_Counter);
    if Tick_Counter >= Tik.Hi then begin
      Inc(Tik.Re, Delay_In_Tiks);
      Dec(Tik.Hi, Tick_Counter);

      for c := 1 to NumberOfSoundChips do
        SoundChip[c].Synthesizer_Logic_P;

      LevL := 128;
      LevR := LevL;

      for c := 1 to NumberOfSoundChips do
        with SoundChip[c] do
        begin
          k := 1;
          if Ton_EnA then k := Ton_A;
          if Noise_EnA then k := k and Noise.Val;
          if k <> 0 then
            if Envelope_EnA then
            begin
              inc(LevL, Level_AL[AYRegisters.AmplitudeA * 2 + 1]);
              inc(LevR, Level_AR[AYRegisters.AmplitudeA * 2 + 1])
            end
            else
            begin
              inc(LevL, Level_AL[Ampl]);
              inc(LevR, Level_AR[Ampl])
            end;

          k := 1;
          if Ton_EnB then k := Ton_B;
          if Noise_EnB then k := k and Noise.Val;
          if k <> 0 then
            if Envelope_EnB then
            begin
              inc(LevL, Level_BL[AYRegisters.AmplitudeB * 2 + 1]);
              inc(LevR, Level_BR[AYRegisters.AmplitudeB * 2 + 1])
            end
            else
            begin
              inc(LevL, Level_BL[Ampl]);
              inc(LevR, Level_BR[Ampl])
            end;

          k := 1;
          if Ton_EnC then k := Ton_C;
          if Noise_EnC then k := k and Noise.Val;
          if k <> 0 then
            if Envelope_EnC then
            begin
              inc(LevL, Level_CL[AYRegisters.AmplitudeC * 2 + 1]);
              inc(LevR, Level_CR[AYRegisters.AmplitudeC * 2 + 1])
            end
            else
            begin
              inc(LevL, Level_CL[Ampl]);
              inc(LevR, Level_CR[Ampl])
            end;
        end;

      if LevL > 255 then LevL := 255;
      if LevR > 255 then LevR := 255;

      PS8(Buf)^[BuffLen].Left := LevL;
      PS8(Buf)^[BuffLen].Right := LevR;

      FillPlayGrid;
      Inc(BuffLen);
      Inc(NOfTicks);
      Tick_Counter := 0;

      if BuffLen = BufferLength then
      begin
        if Current_Tik < Number_Of_Tiks.Hi then
          IntFlag := True;
        exit
      end;
    end;
  until Current_Tik >= Number_Of_Tiks.Hi;
  k := 0;
  Number_Of_Tiks.hi := k;
  Current_Tik := k
end;

procedure Synthesizer_Mono16_P;
var
  Lev, k, c: integer;
begin
  repeat

    Inc(Current_Tik);
    Inc(Tick_Counter);
    if Tick_Counter >= Tik.Hi then begin
      Inc(Tik.Re, Delay_In_Tiks);
      Dec(Tik.Hi, Tick_Counter);

      for c := 1 to NumberOfSoundChips do
        SoundChip[c].Synthesizer_Logic_P;

      Lev := 0;

      for c := 1 to NumberOfSoundChips do
        with SoundChip[c] do
        begin
          k := 1;
          if Ton_EnA then k := Ton_A;
          if Noise_EnA then k := k and Noise.Val;
          if k <> 0 then
            if Envelope_EnA then
              Inc(Lev, Level_AL[AYRegisters.AmplitudeA * 2 + 1])
            else
              Inc(Lev, Level_AL[Ampl]);

          k := 1;
          if Ton_EnB then k := Ton_B;
          if Noise_EnB then k := k and Noise.Val;
          if k <> 0 then
            if Envelope_EnB then
              inc(Lev, Level_BL[AYRegisters.AmplitudeB * 2 + 1])
            else
              inc(Lev, Level_BL[Ampl]);

          k := 1;
          if Ton_EnC then k := Ton_C;
          if Noise_EnC then k := k and Noise.Val;
          if k <> 0 then
            if Envelope_EnC then
              inc(Lev, Level_CL[AYRegisters.AmplitudeC * 2 + 1])
            else
              inc(Lev, Level_CL[Ampl]);
        end;

      if Lev > 32767 then Lev := 32767;

      PM16(Buf)^[BuffLen] := Lev;

      FillPlayGrid;
      Inc(BuffLen);
      Inc(NOfTicks);
      Tick_Counter := 0;

      if BuffLen = BufferLength then
      begin
        if Current_Tik < Number_Of_Tiks.Hi then
          IntFlag := True;
        exit
      end;
    end;
  until Current_Tik >= Number_Of_Tiks.Hi;
  k := 0;
  Number_Of_Tiks.hi := k;
  Current_Tik := k
end;

procedure Synthesizer_Mono8_P;
var
  Lev, k, c: integer;
begin
  repeat

    Inc(Current_Tik);
    Inc(Tick_Counter);
    if Tick_Counter >= Tik.Hi then begin
      Inc(Tik.Re, Delay_In_Tiks);
      Dec(Tik.Hi, Tick_Counter);

      for c := 1 to NumberOfSoundChips do
        SoundChip[c].Synthesizer_Logic_P;

      Lev := 128;

      for c := 1 to NumberOfSoundChips do
        with SoundChip[c] do
        begin
          k := 1;
          if Ton_EnA then k := Ton_A;
          if Noise_EnA then k := k and Noise.Val;
          if k <> 0 then
            if Envelope_EnA then
              inc(Lev, Level_AL[AYRegisters.AmplitudeA * 2 + 1])
            else
              inc(Lev, Level_AL[Ampl]);

          k := 1;
          if Ton_EnB then k := Ton_B;
          if Noise_EnB then k := k and Noise.Val;
          if k <> 0 then
            if Envelope_EnB then
              inc(Lev, Level_BL[AYRegisters.AmplitudeB * 2 + 1])
            else
              inc(Lev, Level_BL[Ampl]);

          k := 1;
          if Ton_EnC then k := Ton_C;
          if Noise_EnC then k := k and Noise.Val;
          if k <> 0 then
            if Envelope_EnC then
              inc(Lev, Level_CL[AYRegisters.AmplitudeC * 2 + 1])
            else
              inc(Lev, Level_CL[Ampl]);
        end;

      if Lev > 255 then Lev := 255;

      PM8(Buf)^[BuffLen] := Lev;

      FillPlayGrid;
      Inc(BuffLen);
      Inc(NOfTicks);
      Tick_Counter := 0;

      if BuffLen = BufferLength then
      begin
        if Current_Tik < Number_Of_Tiks.Hi then
          IntFlag := True;
        exit
      end;
    end;
  until Current_Tik >= Number_Of_Tiks.Hi;
  k := 0;
  Number_Of_Tiks.hi := k;
  Current_Tik := k
end;

procedure UpdatePanoram;
begin
  Calculate_Level_Tables;

  // Ayumi render
  if (RenderEngine = 2) and (AyumiChip1 <> nil) and (AyumiChip2 <> nil) then begin
    AyumiChip1.SetPan(0, Panoram[0]/255, False);
    AyumiChip1.SetPan(1, Panoram[1]/255, False);
    AyumiChip1.SetPan(2, Panoram[2]/255, False);
    AyumiChip2.SetPan(0, Panoram[0]/255, False);
    AyumiChip2.SetPan(1, Panoram[1]/255, False);
    AyumiChip2.SetPan(2, Panoram[2]/255, False);
    Exit;
  end;

  PlayingWindow[1].StopAndRestart;
end;

procedure FrameSynthesizer(Buf: pointer);
begin
  if not IntFlag then
    Number_Of_Tiks.hi := AY_Tiks_In_Interrupt
  else
    IntFlag := False;
  Synthesizer(Buf)
end;


procedure Get_Registers;
var Finish: Boolean;
begin
  if Real_End[CurChip] then
  begin
    SoundChip[CurChip].SetAmplA(0);
    SoundChip[CurChip].SetAmplB(0);
    SoundChip[CurChip].SetAmplC(0);
    exit
  end;
  case PlayMode of

    PMPlayModule:
      begin
        if Module_PlayCurrentLine = 3 then begin

          Finish := False;

          if ExportStarted then begin

            // Export loops checker
            //
            LoopAllowed := ExportLoops > 0;
            if LoopAllowed then
              Dec(ExportLoops)
            else
              Finish := True;

          end
          else
             Finish := not LoopAllowed and (not MainForm.LoopAllAllowed or (MainForm.MDIChildCount <> 1));


          // STOP playing!
          //
          if Finish then begin
          
            ExportFinished := True;
            Real_End[CurChip] := True;
            SoundChip[CurChip].SetAmplA(0);
            SoundChip[CurChip].SetAmplB(0);
            SoundChip[CurChip].SetAmplC(0);

          end;
        end;
      end;


    PMPlayPattern:
      begin
        if Pattern_PlayCurrentLine = 2 then

          if MoveBetweenPatrns and (GetKeyState(VK_RETURN) and $8000 = $8000) then
            Module_GoNextPosition

          else if not LoopAllowed and not MainForm.LoopAllAllowed then
          begin
            Real_End[CurChip] := True;
            SoundChip[CurChip].SetAmplA(0);
            SoundChip[CurChip].SetAmplB(0);
            SoundChip[CurChip].SetAmplC(0);
          end
          
          else
          begin // Play the same pattern from start if Loop active
            Pattern_SetCurrentLine(0);
            Pattern_PlayCurrentLine;
          end;
      end;

      
    PMPlayLine:
      Pattern_PlayOnlyCurrentLine;
  end;

end;

procedure MakeBuffer(Buf: pointer);
var
  i: integer;
begin
  BuffLen := 0;
  if IntFlag then FrameSynthesizer(Buf);
  if IntFlag then exit;

  if LineReady then
  begin
    LineReady := False;
    FrameSynthesizer(Buf)
  end;
  while not Real_End_All and (BuffLen < BufferLength) do
  begin
    Real_End_All := True;
    for i := 1 to NumberOfSoundChips do
    begin
      Module_SetPointer(PlayingWindow[i].VTMP, i);
      Get_Registers;
      Real_End_All := Real_End_All and Real_End[i];
    end;
    if not Real_End_All then FrameSynthesizer(Buf)
  end;

end;

procedure Calculate_Level_Tables;
var i, b, l, r: integer;
  Index_A, Index_B, Index_C: integer;
  k: real;
begin
  Index_A := Index_AL; Index_B := Index_BL; Index_C := Index_CL;
  l := Index_A + Index_B + Index_C;
  r := Index_AR + Index_BR + Index_CR;
  if NumberOfChannels = 2 then
  begin
    if l < r then
      l := r;
  end
  else
  begin
    l := l + r;
    inc(Index_A, Index_AR);
    inc(Index_B, Index_BR);
    inc(Index_C, Index_CR)
  end;
  if l = 0 then inc(l);
  if SampleBit = 8 then r := 127 else r := 32767;
  l := 255 * r div l;

  case Emulating_Chip of
    AY_Chip: for i := 0 to 15 do
      begin
        b := round(Index_A / 255 * Amplitudes_AY[i]);
        b := round(b / 65535 * l);
        Level_AL[i * 2] := b; Level_AL[i * 2 + 1] := b;
        b := round(Index_AR / 255 * Amplitudes_AY[i]);
        b := round(b / 65535 * l);
        Level_AR[i * 2] := b; Level_AR[i * 2 + 1] := b;
        b := round(Index_B / 255 * Amplitudes_AY[i]);
        b := round(b / 65535 * l);
        Level_BL[i * 2] := b; Level_BL[i * 2 + 1] := b;
        b := round(Index_BR / 255 * Amplitudes_AY[i]);
        b := round(b / 65535 * l);
        Level_BR[i * 2] := b; Level_BR[i * 2 + 1] := b;
        b := round(Index_C / 255 * Amplitudes_AY[i]);
        b := round(b / 65535 * l);
        Level_CL[i * 2] := b; Level_CL[i * 2 + 1] := b;
        b := round(Index_CR / 255 * Amplitudes_AY[i]);
        b := round(b / 65535 * l);
        Level_CR[i * 2] := b; Level_CR[i * 2 + 1] := b;
      end;
    YM_Chip: for i := 0 to 31 do         
      begin
        b := round(Index_A / 255 * Amplitudes_YM[i]);
        Level_AL[i] := round(b / 65535 * l);
        b := round(Index_AR / 255 * Amplitudes_YM[i]);
        Level_AR[i] := round(b / 65535 * l);
        b := round(Index_B / 255 * Amplitudes_YM[i]);
        Level_BL[i] := round(b / 65535 * l);
        b := round(Index_BR / 255 * Amplitudes_YM[i]);
        Level_BR[i] := round(b / 65535 * l);
        b := round(Index_C / 255 * Amplitudes_YM[i]);
        Level_CL[i] := round(b / 65535 * l);
        b := round(Index_CR / 255 * Amplitudes_YM[i]);
        Level_CR[i] := round(b / 65535 * l);
      end;
  end;
  k := exp(MainForm.GlobalVolume * ln(2) / MainForm.GlobalVolumeMax) - 1;
  for i := 0 to 31 do
  begin
    Level_AL[i] := round(Level_AL[i] * k);
    Level_AR[i] := round(Level_AR[i] * k);
    Level_BL[i] := round(Level_BL[i] * k);
    Level_BR[i] := round(Level_BR[i] * k);
    Level_CL[i] := round(Level_CL[i] * k);
    Level_CR[i] := round(Level_CR[i] * k);
  end
end;

procedure SetDefault;
begin
  SampleRate := samrate;
  AY_Freq := AY_Freq_Def;
  Interrupt_Freq := Interrupt_Freq_Def;
  Delay_In_Tiks := round(8192 / SampleRate * AY_Freq);
  AY_Tiks_In_Interrupt := round(AY_Freq / (Interrupt_Freq / 1000 * 8));
  SampleBit := sambit;
  NumberOfBuffers := NumberOfBuffersDef;
  BufLen_ms := BufLen_msDef;
  BufferLength := round(BufLen_ms * SampleRate / 1000);
  NumberOfChannels := nchan;
  StdChannelsAllocation := StdChannelsAllocationDef;
  Index_AL := Index_AL_Def; Index_AR := Index_AR_Def;
  Index_BL := Index_BL_Def; Index_BR := Index_BR_Def;
  Index_CL := Index_CL_Def; Index_CR := Index_CR_Def;
  Emulating_Chip := YM_Chip;
  Calculate_Level_Tables;
  SetLength(waveOutBuffers, NumberOfBuffers);
  PlayGridLen := BufferLength * NumberOfBuffers * 2;
  SetLength(PlayingGrid, PlayGridLen);
  IsFilt := True;
  Filt_M := Filt_NKoefs;
  SetLength(Filt_K, Filt_NKoefs + 1);
  CalcFiltKoefs;
  SetLength(Filt_XL, Filt_NKoefs + 1);
  SetLength(Filt_XR, Filt_NKoefs + 1);
  FillChar(Filt_XL[0], (Filt_M + 1) * 4, 0);
  FillChar(Filt_XR[0], (Filt_M + 1) * 4, 0);
  Filt_I := 0
end;

function ToggleChanMode;
begin
  Inc(StdChannelsAllocation);
  if StdChannelsAllocation > 3 then
    StdChannelsAllocation := 0;
  Result := SetStdChannelsAllocation(StdChannelsAllocation)
end;

function SetStdChannelsAllocation;
begin
  Result := '';
  StdChannelsAllocation := CA;

  case StdChannelsAllocation of
    0:
      begin
        MidChan := 0;
        Result := 'Mono';
        Panoram[0] := 128;
        Panoram[1] := 128;
        Panoram[2] := 128;
      end;
    1:
      begin
        MidChan := 1;
        Result := 'ABC';
        Panoram[0] := 64;
        Panoram[1] := 128;
        Panoram[2] := 192;
      end;
    2:
      begin
        MidChan := 2;
        Result := 'ACB';
        Panoram[0] := 64;
        Panoram[1] := 192;
        Panoram[2] := 128;
      end;
    3:
      begin
        MidChan := 0;
        Result := 'BAC';
        Panoram[0] := 128;
        Panoram[1] := 64;
        Panoram[2] := 192;
      end;
    4:
      begin
        MidChan := 2;
        Result := 'BCA';
        Panoram[0] := 192;
        Panoram[1] := 64;
        Panoram[2] := 128;
      end;
    5:
      begin
        MidChan := 0;
        Result := 'CAB';
        Panoram[0] := 128;
        Panoram[1] := 192;
        Panoram[2] := 64;
      end;
    6:
      begin
        MidChan := 1;
        Result := 'CBA';
        Panoram[0] := 192;
        Panoram[1] := 128;
        Panoram[2] := 64;
      end
  end;
  Index_AL := 255 - Panoram[0];
  Index_AR := Panoram[0];
  Index_BL := 255 - Panoram[1];
  Index_BR := Panoram[1];
  Index_CL := 255 - Panoram[2];
  Index_CR := Panoram[2];
  Calculate_Level_Tables
end;

procedure SetIntFreq(f: integer);
var
  R: boolean;
begin
  if (f < 1000) or (f > 2000000) then exit;
  R := IsPlaying and not Reseted and (PlayMode = PMPlayModule);
  if not R and IsPlaying and not Reseted then StopPlaying;
  if R then ResetPlaying;
  Interrupt_Freq := f;
  AY_Tiks_In_Interrupt := round(AY_Freq / (Interrupt_Freq / 1000 * 8));
  PlayGridLen := BufferLength * NumberOfBuffers * 2;
  SetLength(PlayingGrid, PlayGridLen);
  if R then
  begin
    PlayingWindow[1].RerollToLine(1);
    UnresetPlaying;
  end;
end;

procedure SetSampleRate(f: integer);
begin

  if f = SampleRate then Exit;
  if (RenderEngine < 2) and (f > 96000) then
    f := 96000;

  SampleRate := f;
  Delay_In_Tiks := round(8192 / SampleRate * AY_Freq);
  BufferLength := round(BufLen_ms * SampleRate / 1000);
  PlayGridLen := BufferLength * NumberOfBuffers * 2;
  SetLength(PlayingGrid, PlayGridLen);
  CalcFiltKoefs
end;

procedure SetBuffers(len, num: integer);
begin
  if (BufLen_ms = len) and (NumberOfBuffers = num) then Exit;
  BufLen_ms := len;
  NumberOfBuffers := num;
  SetLength(waveOutBuffers, NumberOfBuffers);
  BufferLength := round(BufLen_ms * SampleRate / 1000);
  PlayGridLen := BufferLength * NumberOfBuffers * 2;
  SetLength(PlayingGrid, PlayGridLen);
end;

procedure SetBitRate(SB: integer);
begin

  SampleBit := SB;
  if RenderEngine = 2 then begin
    Synthesizer := Synthesizer_Ayumi;
    if SampleBit = 8 then
      SampleBit := 16;
  end

  else if RenderEngine = 0 then
  begin

    if SampleBit > 16 then
      SampleBit := 16;

    if NumberOfChannels = 2 then
    begin
      if SB = 8 then
        Synthesizer := Synthesizer_Stereo8
      else
        Synthesizer := Synthesizer_Stereo16;
    end
    else if SB = 8 then
      Synthesizer := Synthesizer_Mono8
    else
      Synthesizer := Synthesizer_Mono16;
  end
  else
  begin

    if SampleBit > 16 then
      SampleBit := 16;

    if NumberOfChannels = 2 then
    begin
      if SB = 8 then
        Synthesizer := Synthesizer_Stereo8_P
      else
        Synthesizer := Synthesizer_Stereo16_P;
    end
    else if SB = 8 then
      Synthesizer := Synthesizer_Mono8_P
    else
      Synthesizer := Synthesizer_Mono16_P;
  end;
  Calculate_Level_Tables
end;

procedure SetNChans(St: integer);
begin
  NumberOfChannels := St;
  if RenderEngine = 2 then
    Synthesizer := Synthesizer_Ayumi

  else if RenderEngine = 0 then
  begin
    if St = 2 then
    begin
      if SampleBit = 8 then
        Synthesizer := Synthesizer_Stereo8
      else
        Synthesizer := Synthesizer_Stereo16
    end
    else
      if SampleBit = 8 then
        Synthesizer := Synthesizer_Mono8
      else
        Synthesizer := Synthesizer_Mono16
  end
  else
  begin
    if St = 2 then
    begin
      if SampleBit = 8 then
        Synthesizer := Synthesizer_Stereo8_P
      else
        Synthesizer := Synthesizer_Stereo16_P
    end
    else
      if SampleBit = 8 then
        Synthesizer := Synthesizer_Mono8_P
      else
        Synthesizer := Synthesizer_Mono16_P
  end;
  Calculate_Level_Tables
end;

procedure Set_Engine(EngineIndex: Integer);
var
  R, Q: boolean;
begin
  Q := EngineIndex = 0;
  R := IsPlaying;
  if R then StopPlaying;
  RenderEngine := EngineIndex;

  Current_Tik := round(Current_Tik / SampleRate * (AY_Freq div 8));
  Number_Of_Tiks.Re := round(Number_Of_Tiks.Re / SampleRate * (AY_Freq div 8));

  // Ayumi render
  if EngineIndex = 2 then
    Synthesizer := Synthesizer_Ayumi

  else if Q then
  begin
    if NumberOfChannels = 2 then
    begin
      if SampleBit = 8 then
        Synthesizer := Synthesizer_Stereo8
      else
        Synthesizer := Synthesizer_Stereo16
    end
    else if SampleBit = 8 then
      Synthesizer := Synthesizer_Mono8
    else
      Synthesizer := Synthesizer_Mono16
  end
  else
  begin
    if NumberOfChannels = 2 then
    begin
      if SampleBit = 8 then
        Synthesizer := Synthesizer_Stereo8_P
      else
        Synthesizer := Synthesizer_Stereo16_P
    end
    else if SampleBit = 8 then
      Synthesizer := Synthesizer_Mono8_P
    else
      Synthesizer := Synthesizer_Mono16_P
  end;
  if R then
  begin
    PlayingWindow[1].RerollToLine(1);
    StartWOThread;
  end;
end;

procedure SetAYFreq(f: integer);
var
  R: boolean;
begin
  if (f < 700000) or (f > 3546800) then exit;

  R := IsPlaying and (RenderEngine <> 2);
  if R then
    StopPlaying;

  AY_Freq := f;
  Delay_In_Tiks := round(8192 / SampleRate * AY_Freq);
  AY_Tiks_In_Interrupt := round(AY_Freq / (Interrupt_Freq / 1000 * 8));
  CalcFiltKoefs;

  if (RenderEngine = 2) and (AyumiChip1 <> nil) and (AyumiChip2 <> nil) then begin
    AyumiChip1.SetChipFreq(AY_Freq);
    AyumiChip2.SetChipFreq(AY_Freq);
  end;

  if R then
  begin
    PlayingWindow[1].RerollToLine(1);
    StartWOThread;
  end;


end;


procedure CalcFiltKoefs;
var
  i, i2, Filt_M2: integer;
  K, F, C: double;
  FKt: array of double;
begin
  C := Pi * SampleRate / (AY_Freq div 8);
  SetLength(FKt, Filt_M + 1);
  Filt_M2 := Filt_M div 2;
  K := 0;
  for i := 0 to Filt_M do
  begin
    i2 := i - Filt_M2;
    if i2 = 0 then
      F := C
    else
      F := sin(C * i2) / i2 * (0.54 - 0.46 * cos(2 * Pi / Filt_M * i));
    FKt[i] := F;
    K := K + F
  end;
  for i := 0 to Filt_M do
    Filt_K[i] := round(FKt[i] / K * $1000000)
end;

procedure SetFilter(Filt: boolean; M: integer);
var
  R: boolean;
begin
  if (Filt_M = M) and (IsFilt = Filt) then exit;
  R := IsPlaying and not Reseted and (PlayMode = PMPlayModule);
  if not R and IsPlaying and not Reseted then StopPlaying;
  if R then ResetPlaying;
  IsFilt := Filt;
  if Filt_M <> M then
  begin
    Filt_M := M;
    SetLength(Filt_K, M + 1);
    CalcFiltKoefs;
    SetLength(Filt_XL, M + 1);
    SetLength(Filt_XR, M + 1);
    FillChar(Filt_XL[0], (Filt_M + 1) * 4, 0);
    FillChar(Filt_XR[0], (Filt_M + 1) * 4, 0);
    Filt_I := 0;
  end;
  if R then
  begin
    PlayingWindow[1].RerollToLine(1);
    UnresetPlaying;
  end;
end;

end.
