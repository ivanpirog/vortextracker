{
ZX Spectrum Pro Tracker 3.0x - 3.6x modules player
Designed to compile for Atari ST with MC68000 processor
Used in Vortex Tracker II in PT3 to SNDH converter
To work on other MC68K based systems simply replace 'ROut' procedure
Based on Ay_Emul sources, tables packed via Ivan Roshin's algorithms

(c)2003-2006 S.V.Bulba

http://bulba.at.kz is
 - Micro ST (Win32 SNDH player)
 - AY Emulator (Win32 AY-3-8910/12 and YM2149F emulator/player/converter/ripper
 - Vortex Tracker II (Win32 AY/YM music editor)
 - and many other AY/YM soundchips related

Author Sergey Bulba <vorobey@mail.khstu.ru>
}
program MC68KPT3;

type

 BytePtr = ^byte;

 TModTypes = packed record
 case Integer of
 0: (Index:array[0..65535] of byte);
 1: (PT3_MusicName:array[0..$62]of char;
     PT3_TonTableId:byte;
     PT3_Delay:byte;
     PT3_NumberOfPositions:byte;
     PT3_LoopPosition:byte;
     PT3_PatternsPointer:word;
     PT3_SamplesPointers:array[0..31]of word;
     PT3_OrnamentsPointers:array[0..15]of word;
     PT3_PositionList:array[0..65535-201]of byte);
 end;

 TRegisterAY = packed record
 case Integer of
  0:(Index:array[0..13] of byte);
  1:(TonA,TonB,TonC: word;
     Noise:byte;
     Mixer:byte;
     AmplitudeA,AmplitudeB,AmplitudeC:byte;
     EnvelopeL:byte;
     EnvelopeH:byte;
     EnvType:byte);
 end;

 PT3_Channel_Parameters = record
  Address_In_Pattern,
  OrnamentPointer,
  SamplePointer,
  Ton:word;
  Loop_Ornament_Position,
  Ornament_Length,
  Position_In_Ornament,
  Loop_Sample_Position,
  Sample_Length,
  Position_In_Sample,
  Volume,
  Number_Of_Notes_To_Skip,
  Note,
  Slide_To_Note,
  Amplitude:byte;
  Envelope_Enabled,
  Enabled,
  SimpleGliss:boolean;
  Current_Amplitude_Sliding,
  Current_Noise_Sliding,
  Current_Envelope_Sliding,
  Ton_Slide_Count,
  Current_OnOff,
  OnOff_Delay,
  OffOn_Delay,
  Ton_Slide_Delay,
  Current_Ton_Sliding,
  Ton_Accumulator,
  Ton_Slide_Step,
  Ton_Delta:integer;
  Note_Skip_Counter:shortint;
  Dump:byte;
 end;

 PT3_Parameters = record
  PT3_Version:integer;
  Cur_Env_Slide,
  Env_Slide_Add:integer;
  PatPtr:word;
  Cur_Env_Delay,
  Env_Delay:shortint;
  Noise_Base,
  Delay,
  AddToNoise,
  DelayCounter,
  CurrentPosition:byte;
  Dump:byte;
 end;

 PT3ToneTable = array[0..95] of word;
 PT3VolTable = array[0..15,0..15] of byte;

 TPlVars = record
  T_PACK:array[0..53] of byte;
  TC:array[0..65] of byte;
  NT_DATA:array[0..7,0..1]of byte;
  VT_:record
   case integer of
   0:(VT:PT3VolTable); //Created Volume Table
   1:(R:TRegisterAY;
      Env_Base:word;
      TT:array[0..49-1]of word); //Tone tables data temporary depacked here
   2:(V:array[0..255]of byte);
  end;
  NT_:PT3ToneTable; //Created Note Table
  PT3:PT3_Parameters;PT3_A,PT3_B,PT3_C:PT3_Channel_Parameters;
  RAM:TModTypes;
 end;

const
//9 tables total are:
{Table #0 of Pro Tracker 3.3x - 3.4r}
{Table #0 of Pro Tracker 3.4x - 3.5x}
{Table #1 of Pro Tracker 3.3x - 3.5x)}
{Table #2 of Pro Tracker 3.4r}
{Table #2 of Pro Tracker 3.4x - 3.5x}
{Table #3 of Pro Tracker 3.4r}
{Table #3 of Pro Tracker 3.4x - 3.5x}
{Volume table of Pro Tracker 3.3x - 3.4x}
{Volume table of Pro Tracker 3.5x}

 //first 12 values of tone tables (packed)
 T_PACK1:array[0..53] of byte =
 ($06EC*2 div 256,$06EC*2 mod 256,
  $0755-$06EC,
  $07C5-$0755,
  $083B-$07C5,
  $08B8-$083B,
  $093D-$08B8,
  $09CA-$093D,
  $0A5F-$09CA,
  $0AFC-$0A5F,
  $0BA4-$0AFC,
  $0C55-$0BA4,
  $0D10-$0C55,
  $066D*2 div 256,$066D*2 mod 256,
  $06CF-$066D,
  $0737-$06CF,
  $07A4-$0737,
  $0819-$07A4,
  $0894-$0819,
  $0917-$0894,
  $09A1-$0917,
  $0A33-$09A1,
  $0ACF-$0A33,
  $0B73-$0ACF,
  $0C22-$0B73,
  $0CDA-$0C22,
  $0704*2 div 256,$0704*2 mod 256,
  $076E-$0704,
  $07E0-$076E,
  $0858-$07E0,
  $08D6-$0858,
  $095C-$08D6,
  $09EC-$095C,
  $0A82-$09EC,
  $0B22-$0A82,
  $0BCC-$0B22,
  $0C80-$0BCC,
  $0D3E-$0C80,
  $07E0*2 div 256,$07E0*2 mod 256,
  $0858-$07E0,
  $08E0-$0858,
  $0960-$08E0,
  $09F0-$0960,
  $0A88-$09F0,
  $0B28-$0A88,
  $0BD8-$0B28,
  $0C80-$0BD8,
  $0D60-$0C80,
  $0E10-$0D60,
  $0EF8-$0E10,
  0{Dummy});

 //tone tables corrections
 TCOLD_0 = 0;
 TCOLD_1 = 12;
 TCOLD_2 = 14;
 TCOLD_3 = 33;
 TCNEW_0 = 42;
 TCNEW_1 = TCOLD_1;
 TCNEW_2 = 53;
 TCNEW_3 = 32;
 TC1:array[0..65] of byte =
 ($00+1,$04+1,$08+1,$0A+1,$0C+1,$0E+1,$12+1,$14+1,
  $18+1,$24+1,$3C+1,0,
  $5C+1,0,
  $30+1,$36+1,$4C+1,$52+1,$5E+1,$70+1,$82,$8C,$9C,
  $9E,$A0,$A6,$A8,$AA,$AC,$AE,$AE,0,
  $56+1,
  $1E+1,$22+1,$24+1,$28+1,$2C+1,$2E+1,$32+1,$BE+1,0,
  $1C+1,$20+1,$22+1,$26+1,$2A+1,$2C+1,$30+1,$54+1,
  $BC+1,$BE+1,0,
  $1A+1,$20+1,$24+1,$28+1,$2A+1,$3A+1,$4C+1,$5E+1,
  $BA+1,$BC+1,$BE+1,0,
  0{Dummy});

 //first 12 values of tone tables (depacked structure)
 T_OLD_1 = 0;
 T_OLD_2 = T_OLD_1+24;
 T_OLD_3 = T_OLD_2+24;
 T_OLD_0 = T_OLD_3+2;
 T_NEW_0 = T_OLD_0;
 T_NEW_1 = T_OLD_1;
 T_NEW_2 = T_NEW_0+24;
 T_NEW_3 = T_OLD_3;

 NT_DATA1:array[0..7,0..1]of byte =
 ((T_NEW_0,TCNEW_0),
  (T_OLD_0+1,TCOLD_0),
  (T_NEW_1+1,TCNEW_1),
  (T_OLD_1+1,TCOLD_1),
  (T_NEW_2,TCNEW_2),
  (T_OLD_2,TCOLD_2),
  (T_NEW_3,TCNEW_3),
  (T_OLD_3,TCOLD_3));

var
 PVars:^TPlVars;

procedure ROut;
var
 i:integer;
begin
with PVars^ do
 begin
  for i := 0 to 12 do
   begin
    BytePtr($FF8800)^ := i;
    BytePtr($FF8802)^ := VT_.R.Index[i]
   end;
  if shortint(VT_.R.EnvType) <> -1 then
   begin
    BytePtr($FF8800)^ := 13;
    BytePtr($FF8802)^ := VT_.R.EnvType
   end
 end
end;

function MW(L,H:byte):word;
begin
MW := L + (word(H) shl 8)
end;

function IW(W:word):word;
begin
IW := (W shl 8) or (W shr 8)
end;

procedure PT3Init;
var
 i,j,k,l,m:integer;
 a:byte;
 w:word;
 fl:boolean;
begin
with PVars^ do
 begin

  for i := 0 to sizeof(VT_) + sizeof(NT_) + sizeof(PT3) + sizeof(PT3_A)*3 - 1 do
   VT_.V[i] := 0;
     (*256{vt} + 192{nt} + 16{pt3} + 48*3{pt3_a+pt3_b+pt3_c}*)

  //note table data depacker
  i := 0; j := 49-1;
  repeat
  a := T_PACK[i]; inc(i);
  if a < 15*2 then
   begin
    w := word(a) shl 8 + T_PACK[i]; inc(i);
   end
  else
   inc(w,a + a);
  VT_.TT[j] := w; dec(j);
  until j < 0;

  with PT3,RAM do
    begin
     PT3_Version := 6;
     if (Index[13] >= $30) and (Index[13] <= $39) then
      PT3_Version := Index[13] - $30;

     //NoteTableCreator (c) Ivan Roshin
     //A - NoteTableNumber*2+VersionForNoteTable
     //(xx1b - 3.xx..3.4r, xx0b - 3.4x..3.6x..VTII1.0)
     a := (PT3_TonTableId shl 1) and 7;
     if PT3_Version < 4 then inc(a);

     j := NT_DATA[a,0];
     fl := (j and 1) <> 0;
     j := j shr 1;
     for i := 0 to 11 do
      begin
       w := VT_.TT[j]; inc(j);
       l := i;
       for k := 0 to 7 do
        begin
         m := Ord(not fl and ((w and 1) <> 0));
         w := w shr 1;
         NT_[l] := w + m;
         inc(l,12);
        end;
      end;

     j := NT_DATA[a,1];
     if j = TCOLD_1 then NT_[23] := $3FD;
     repeat
     i := TC[j]; if i = 0 then break;
     if i and 1 <> 0 then
      dec(NT_[i shr 1])
     else
      inc(NT_[i shr 1]);
     inc(j);
     until False;

     //VolTableCreator (c) Ivan Roshin
     //VersionForVolumeTable (0..4 - 3.xx..3.4x; 5.. - 3.5x..3.6x..VTII1.0)

     w := 0;
     i := $11;
     fl := PT3_Version >= 5;
     if not fl then
      begin
       w := $10;
       i := $10;
      end;

     j := 16;
     repeat
      inc(w,i);
      l := 0;
      repeat
       k := l shr 8;
       if fl and ((l and 128) <> 0) then inc(k);
       VT_.V[j] := k;
       inc(l,w);
       inc(j)
      until (j and 15) = 0;
      if (w and 255) = $77 then inc(w);
     until j = 256;


     DelayCounter := 1;
     Delay := PT3_Delay;
     PatPtr := MW(Index[103],Index[104]);
     w := PatPtr + PT3_PositionList[0] * 2;
     PT3_A.Address_In_Pattern := MW(Index[w + 0],Index[w + 1]);
     PT3_B.Address_In_Pattern := MW(Index[w + 2],Index[w + 3]);
     PT3_C.Address_In_Pattern := MW(Index[w + 4],Index[w + 5])
    end;

   with PT3_A,RAM do
    begin
     OrnamentPointer := MW(Index[169],Index[170]);
     Loop_Ornament_Position := Index[OrnamentPointer];
     inc(OrnamentPointer);
     Ornament_Length := Index[OrnamentPointer];
     inc(OrnamentPointer);
     SamplePointer := MW(Index[107],Index[108]);
     Loop_Sample_Position := Index[SamplePointer];
     inc(SamplePointer);
     Sample_Length := Index[SamplePointer];
     inc(SamplePointer);
     Volume := 15;
     Note_Skip_Counter := 1;
    end;

   with PT3_B do
    begin
     OrnamentPointer := PT3_A.OrnamentPointer;
     Loop_Ornament_Position := PT3_A.Loop_Ornament_Position;
     Ornament_Length := PT3_A.Ornament_Length;
     SamplePointer := PT3_A.SamplePointer;
     Loop_Sample_Position := PT3_A.Loop_Sample_Position;
     Sample_Length := PT3_A.Sample_Length;
     Volume := 15;
     Note_Skip_Counter := 1;
    end;

   with PT3_C do
    begin
     OrnamentPointer := PT3_A.OrnamentPointer;
     Loop_Ornament_Position := PT3_A.Loop_Ornament_Position;
     Ornament_Length := PT3_A.Ornament_Length;
     SamplePointer := PT3_A.SamplePointer;
     Loop_Sample_Position := PT3_A.Loop_Sample_Position;
     Sample_Length := PT3_A.Sample_Length;
     Volume := 15;
     Note_Skip_Counter := 1;
    end;

 end;

ROut

end;

procedure Pl;

 procedure P(var Chan:PT3_Channel_Parameters);
 var
  quit:boolean;
  Flag9,Flag8,Flag5,Flag4,
  Flag3,Flag2,Flag1:byte;
  counter:byte;
  PrNote,PrSliding:integer;
  wp:word;
 begin
  PrNote := Chan.Note;
  PrSliding := Chan.Current_Ton_Sliding;
  quit := False;
  counter := 0;
  Flag9 := 0; Flag8 := 0; Flag5 := 0; Flag4 := 0;
  Flag3 := 0; Flag2 := 0; Flag1 := 0;
  with PVars^ do
  with Chan,RAM do
   begin
    repeat
     case Index[Address_In_Pattern] of
     $f0..$ff:
       begin
        wp := 169 + (Index[Address_In_Pattern] - $f0) * 2;
        OrnamentPointer := MW(Index[wp],Index[wp + 1]);
        Loop_Ornament_Position := Index[OrnamentPointer];
        Inc(OrnamentPointer);
        Ornament_Length := Index[OrnamentPointer];
        Inc(OrnamentPointer);
        Inc(Address_In_Pattern);
        wp := 105 + Index[Address_In_Pattern];
        SamplePointer := MW(Index[wp],Index[wp + 1]);
        Loop_Sample_Position := Index[SamplePointer];
        Inc(SamplePointer);
        Sample_Length := Index[SamplePointer];
        Inc(SamplePointer);
        Envelope_Enabled := False;
        Position_In_Ornament := 0
       end;
     $d1..$ef:
       begin
        wp := 105 + (Index[Address_In_Pattern] - $d0) * 2;
        SamplePointer := MW(Index[wp],Index[wp + 1]);
        Loop_Sample_Position := Index[SamplePointer];
        Inc(SamplePointer);
        Sample_Length := Index[SamplePointer];
        Inc(SamplePointer)
       end;
     $d0:
       quit := true;
     $c1..$cf:
       Volume := Index[Address_In_Pattern] - $c0;
     $c0:
       begin
        Position_In_Sample := 0;
        Current_Amplitude_Sliding := 0;
        Current_Noise_Sliding := 0;
        Current_Envelope_Sliding := 0;
        Position_In_Ornament := 0;
        Ton_Slide_Count := 0;
        Current_Ton_Sliding := 0;
        Ton_Accumulator := 0;
        Current_OnOff := 0;
        Enabled := False;
        quit := True
       end;
     $b2..$bf:
       begin
        Envelope_Enabled := True;
        VT_.R.EnvType := Index[Address_In_Pattern] - $b1;
        Inc(Address_In_Pattern);
        with PT3 do
         begin
          {not big-endian}
          VT_.Env_Base := MW(Index[Address_In_Pattern + 1],Index[Address_In_Pattern]);
          Inc(Address_In_Pattern);
          Position_In_Ornament := 0;
          Cur_Env_Slide := 0;
          Cur_Env_Delay := 0
         end
       end;
     $b1:
       begin
        inc(Address_In_Pattern);
        Number_Of_Notes_To_Skip := Index[Address_In_Pattern]
       end;
     $b0:
       begin
        Envelope_Enabled := False;
        Position_In_Ornament := 0
       end;
     $50..$af:
       begin
        Note := Index[Address_In_Pattern] - $50;
        Position_In_Sample := 0;
        Current_Amplitude_Sliding := 0;
        Current_Noise_Sliding := 0;
        Current_Envelope_Sliding := 0;
        Position_In_Ornament := 0;
        Ton_Slide_Count := 0;
        Current_Ton_Sliding := 0;
        Ton_Accumulator := 0;
        Current_OnOff := 0;
        Enabled := True;
        quit := True
       end;
     $40..$4f:
       begin
        wp := 169 + (Index[Address_In_Pattern] - $40) * 2;
        OrnamentPointer := MW(Index[wp],Index[wp + 1]);
        Loop_Ornament_Position := Index[Chan.OrnamentPointer];
        Inc(OrnamentPointer);
        Ornament_Length := Index[OrnamentPointer];
        Inc(OrnamentPointer);
        Position_In_Ornament := 0
       end;
     $20..$3f:
       PT3.Noise_Base := Index[Address_In_Pattern] - $20;
     $10..$1f:
       begin
        if Index[Address_In_Pattern] = $10 then
         Envelope_Enabled := False
        else
         begin
          VT_.R.EnvType := Index[Address_In_Pattern] - $10;
          Inc(Address_In_Pattern);
          with PT3 do
           begin
            {not big-endian}
            VT_.Env_Base := MW(Index[Address_In_Pattern + 1],Index[Address_In_Pattern]);
            Inc(Address_In_Pattern);
            Envelope_Enabled := True;
            Cur_Env_Slide := 0;
            Cur_Env_Delay := 0
           end
         end;
        Inc(Address_In_Pattern);
        wp := 105 + Index[Address_In_Pattern];
        SamplePointer := MW(Index[wp],Index[wp + 1]);
        Loop_Sample_Position := Index[SamplePointer];
        Inc(SamplePointer);
        Sample_Length := Index[SamplePointer];
        Inc(SamplePointer);
        Position_In_Ornament := 0
       end;
     $9:
       begin
        Inc(counter);
        Flag9 := counter
       end;
     $8:
       begin
        Inc(counter);
        Flag8 := counter
       end;
     $5:
       begin
        Inc(counter);
        Flag5 := counter
       end;
     $4:
       begin
        Inc(counter);
        Flag4 := counter
       end;
     $3:
       begin
        Inc(counter);
        Flag3 := counter
       end;
     $2:
       begin
        Inc(counter);
        Flag2 := counter
       end;
     $1:
       begin
        Inc(counter);
        Flag1 := counter
       end
     end;
     inc(Address_In_Pattern)
    until quit;
    while counter > 0 do
     begin
      if (counter = Flag1) then
       begin
        Ton_Slide_Delay := Index[Address_In_Pattern];
        Ton_Slide_Count := Ton_Slide_Delay;
        Inc(Address_In_Pattern);
        Ton_Slide_Step := MW(Index[Address_In_Pattern],Index[Address_In_Pattern + 1]);
        Inc(Address_In_Pattern,2);
        SimpleGliss := True;
        Current_OnOff := 0
       end
      else if (counter = Flag2) then
       begin
        SimpleGliss := False;
        Current_OnOff := 0;
        Ton_Slide_Delay := Index[Address_In_Pattern];
        Ton_Slide_Count := Ton_Slide_Delay;
        Inc(Address_In_Pattern,3);
        Ton_Slide_Step := Abs(integer(MW(Index[Address_In_Pattern],Index[Address_In_Pattern + 1])));
        Inc(Address_In_Pattern,2);
        Ton_Delta := NT_[Note] - NT_[PrNote];
        Slide_To_Note := Note;
        Note := PrNote;
        if PT3.PT3_Version >= 6 then
         Current_Ton_Sliding := PrSliding;
        if Ton_Delta - Current_Ton_Sliding < 0 then
         Ton_Slide_Step := -Ton_Slide_Step
       end
      else if counter = Flag3 then
       begin
        Position_in_Sample := Index[Address_In_Pattern];
        Inc(Address_In_Pattern)
       end
      else if counter = Flag4 then
       begin
        Position_in_Ornament := Index[Address_In_Pattern];
        inc(Address_In_Pattern)
       end
      else if counter = Flag5 then
       begin
        OnOff_Delay := Index[Address_In_Pattern];
        Inc(Address_In_Pattern);
        OffOn_Delay := Index[Address_In_Pattern];
        Current_OnOff := OnOff_Delay;
        Inc(Address_In_Pattern);
        Ton_Slide_Count := 0;
        Current_Ton_Sliding := 0
       end
      else if counter = Flag8 then
       begin
        with PT3 do
         begin
          Env_Delay := Index[Address_In_Pattern];
          Cur_Env_Delay := Env_Delay;
          Inc(Address_In_Pattern);
          Env_Slide_Add := MW(Index[Address_In_Pattern],Index[Address_In_Pattern + 1]);
         end;
        Inc(Address_In_Pattern,2)
       end
      else if counter = Flag9 then
       begin
        PT3.Delay := Index[Address_In_Pattern];
        Inc(Address_In_Pattern)
       end;
      Dec(counter)
     end;
    Note_Skip_Counter := Number_Of_Notes_To_Skip
   end
 end;

var
 TempMixer:byte;
 AddToEnv:shortint;

 procedure C(var Chan:PT3_Channel_Parameters);
 var
  j,b1,b0:byte;
  w,wp:word;
 begin
  with PVars^ do
  with Chan,RAM do
   begin
    if Enabled then
     begin
      wp := SamplePointer + Position_In_Sample * 4;
      Ton := MW(Index[wp + 2],Index[wp + 3]);
      Inc(Ton,Ton_Accumulator);
      b0 := Index[wp];
      b1 := Index[wp + 1];
      if b1 and $40 <> 0 then
       Ton_Accumulator := Ton;
      j := Note + Index[OrnamentPointer + Position_In_Ornament];
      if shortint(j) < 0 then j := 0
      else if j > 95 then j := 95;
      w := NT_[j];
      Ton := (Ton + Current_Ton_Sliding + w) and $fff;
      if Ton_Slide_Count > 0 then
       begin
        Dec(Ton_Slide_Count);
        if Ton_Slide_Count = 0 then
         begin
          Inc(Current_Ton_Sliding,Ton_Slide_Step);
          Ton_Slide_Count := Ton_Slide_Delay;
          if not SimpleGliss then
           if ((Ton_Slide_Step < 0) and (Current_Ton_Sliding <= Ton_Delta)) or
              ((Ton_Slide_Step >= 0) and (Current_Ton_Sliding >= Ton_Delta)) then
            begin
             Note := Slide_To_Note;
             Ton_Slide_Count := 0;
             Current_Ton_Sliding := 0
            end
         end
       end;
      Amplitude := b1 and $f;
      if b0 and $80 <> 0 then
      if b0 and $40 <> 0 then
       begin
        if Current_Amplitude_Sliding < 15 then
         inc(Current_Amplitude_Sliding)
       end
      else if Current_Amplitude_Sliding > -15 then
       dec(Current_Amplitude_Sliding);
      inc(Amplitude,Current_Amplitude_Sliding);
      if shortint(Amplitude) < 0 then Amplitude := 0
      else if Amplitude > 15 then Amplitude := 15;
      Amplitude := VT_.VT[Volume,Amplitude];
      if (b0 and 1 = 0) and Envelope_Enabled then
       Amplitude := Amplitude or 16;
      if b1 and $80 <> 0 then
       begin
        if b0 and $20 <> 0 then
         j := (b0 shr 1) or $F0 + Current_Envelope_Sliding
        else
         j := (b0 shr 1) and $F + Current_Envelope_Sliding;
        if b1 and $20 <> 0 then Current_Envelope_Sliding := j;
        Inc(AddToEnv,j)
       end
      else
       begin
        PT3.AddToNoise := b0 shr 1 + Current_Noise_Sliding;
        if b1 and $20 <> 0 then
         Current_Noise_Sliding := PT3.AddToNoise
       end;
      TempMixer := b1 shr 1 and $48 or TempMixer;
      Inc(Position_In_Sample);
      if Position_In_Sample >= Sample_Length then
       Position_In_Sample := Loop_Sample_Position;
      Inc(Position_In_Ornament);
      if Position_In_Ornament >= Ornament_Length then
       Position_In_Ornament := Loop_Ornament_Position
     end
    else
     Amplitude := 0;
    TempMixer := TempMixer shr 1;
    if Current_OnOff > 0 then
     begin
      dec(Current_OnOff);
      if Current_OnOff = 0 then
       begin
        Enabled := not Enabled;
        if Enabled then Current_OnOff := OnOff_Delay
        else Current_OnOff := OffOn_Delay
       end;
     end
   end
 end;

var
 wp:word;
begin

with PVars^ do
begin

shortint(VT_.R.EnvType) := -1;
with PT3 do
 begin
  Dec(DelayCounter);
  if DelayCounter = 0 then
   begin
    with PT3_A do
     begin
      Dec(Note_Skip_Counter);
      if Note_Skip_Counter = 0 then
       with RAM do
        begin
         if (Index[Address_In_Pattern] = 0) then
          begin
           inc(CurrentPosition);
           if CurrentPosition = PT3_NumberOfPositions then
            CurrentPosition := PT3_LoopPosition;
           wp := PatPtr + PT3_PositionList[CurrentPosition] * 2;
           Address_In_Pattern := MW(Index[wp + 0],Index[wp + 1]);
           PT3_B.Address_In_Pattern := MW(Index[wp + 2],Index[wp + 3]);
           PT3_C.Address_In_Pattern := MW(Index[wp + 4],Index[wp + 5]);
           Noise_Base := 0
          end;
         P(PT3_A)
        end
     end;
    with PT3_B do
     begin
      Dec(Note_Skip_Counter);
      if Note_Skip_Counter = 0 then
       P(PT3_B)
     end;
    with PT3_C do
     begin
      Dec(Note_Skip_Counter);
      if Note_Skip_Counter = 0 then
       P(PT3_C)
     end;
    DelayCounter := Delay
   end;

  AddToEnv := 0;
  TempMixer := 0;
  C(PT3_A);
  C(PT3_B);
  C(PT3_C);

  VT_.R.Mixer := TempMixer;

  VT_.R.TonA := IW(PT3_A.Ton);
  VT_.R.TonB := IW(PT3_B.Ton);
  VT_.R.TonC := IW(PT3_C.Ton);

  VT_.R.AmplitudeA := PT3_A.Amplitude;
  VT_.R.AmplitudeB := PT3_B.Amplitude;
  VT_.R.AmplitudeC := PT3_C.Amplitude;

  VT_.R.Noise := (Noise_Base + AddToNoise) and 31;

  wp := VT_.Env_Base + AddToEnv + Cur_Env_Slide;
  VT_.R.EnvelopeL := wp;
  VT_.R.EnvelopeH := wp shr 8;

  if Cur_Env_Delay > 0 then
   begin
    Dec(Cur_Env_Delay);
    if Cur_Env_Delay = 0 then
     begin
      Cur_Env_Delay := Env_Delay;
      Inc(Cur_Env_Slide,Env_Slide_Add)
     end
   end
 end

end;

ROut

end;

begin
end.