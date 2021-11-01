{
This is part of Vortex Tracker II project

(c)2000-2009 S.V.Bulba
Author: Sergey Bulba, vorobey@mail.khstu.ru
Support page: http://bulba.untergrund.net/

Version 2.0 and later
(c)2017-2019 Ivan Pirog, ivan.pirog@gmail.com
}

unit trfuncs;

interface

uses SysUtils, Controls, Dialogs, Math;

type
  TChansArray = array[0..2] of integer;

const
  StdChns: TChansArray = (0, 1, 2); //ABC (for export to text/clipboard)

  MaxPatLen = 256; //Pro Tracker 3.xx allows 64 max :(

  DefPatLen = 64;

  MaxPatNum = 84; //Alone Coder had made Pro Tracker 3.6x+ with 48 patterns
                  //and with player, which supports up to 85 patterns
  MaxNumOfPats = MaxPatNum + 1;

  MaxOrnLen = 255; //can be up to 255; 64 in ZX version of PT3-editor

  MaxSamLen = 64; //not bigger than 64 (players limitation)

  MaxPosNum = 255; // max positions in track

  PreviewSamNum = 32;
  PreviewOrnNum = 16;

  FeaturesLevel: integer = 1;
  //0 for PT 3.5 and older
  //1 for VT II and PT3.6 (Correct3xxxInterpretation - Allows Vortex Tracker II
        //rightly do the situation like
        //                    A-4 .... 11.1
        //                    --- .... ....
        //                    A-4 .... 31.1
        //An ASC modules conversion also depends of this switch)
  //2 for PT 3.7 (New1xxx2xxxInterpretation - PT 3.7 1.xx and 2.xx allows sinlge
                        //tone offset without glissando)

  DetectFeaturesLevel: boolean = True;

  VortexModuleHeader: boolean = True;
  DetectModuleHeader: boolean = True;
  MaxNumberOfSoundChips = 2;

  
type
  BytePtr = ^byte;
  WordPtr = ^word;
  DWordPtr = ^longword;

  Available_Types =
    (Unknown, STCFile, ASCFile, ASC0File, STPFile, PSCFile, FLSFile, FTCFile,
    PT1File, PT2File, PT3File, SQTFile, GTRFile, FXMFile, PSMFile);

  TRegisters = packed record
    case Boolean of
      True: (Index: array[0..13] of byte);
      False: (TonA, TonB, TonC: word;
        Noise, Mixer: byte;
        AmplitudeA, AmplitudeB, AmplitudeC: byte;
        Envelope: word;
        EnvType: byte);
  end;

  PPosition = ^TPosition;
  TPosition = record
    Value: array[0..255] of integer; {0..42 for compatability with Pro Tracker 3.4r,
                                i.e. max 43 patterns (85 in 3.6+}
    Colors: array[0..255] of Integer;
    Length, Loop: integer;
  end;

  POrnament = ^TOrnament;
  TOrnament = record
    Items: array[0..MaxOrnLen - 1] of shortint;
    Length, Loop: Integer;
    CopyAll: Boolean;
  end;

  PSampleTick = ^TSampleTick;
  TSampleTick = record
    Add_to_Ton: smallint;
    Ton_Accumulation: boolean;
    Amplitude: byte;
    Amplitude_Sliding: boolean;
    Amplitude_Slide_Up: boolean;
    Envelope_Enabled: boolean;
    Envelope_or_Noise_Accumulation: boolean;
    Add_to_Envelope_or_Noise: shortint;
    Mixer_Ton, Mixer_Noise: boolean;
  end;

  PSample = ^TSample;
  TSample = packed record
    Length, Loop: byte;
    Enabled: boolean;
    Items: array[0..MaxSamLen-1] of TSampleTick;
  end;

  TAdditionalCommand = packed record
    Number: byte;
    Delay: byte;
    Parameter: byte;
  end;

  PChannelLine = ^TChannelLine;
  TChannelLine = packed record
    Note: shortint; {0..95} {-2 - Sound off (R--)} {-1 - No note (---)}
    Sample: byte; {0..31}
    Ornament: byte; {0..15}
    Volume: shortint; {1-15 - vol, 0 - prev vol}
    Envelope: byte; {1-14 - R13, 15 - Envelope off, 0 - prev}
    Additional_Command: TAdditionalCommand;
  end;

  PPattern = ^TPattern;
  TPattern = record
    Length: integer;
    Items: array[0..MaxPatLen - 1] of record
      Noise: byte;
      Envelope: word;
      Channel: array[0..2] of TChannelLine;
    end;
  end;

  PLastNoteParams = ^TLastNoteParams;
  TLastNoteParams = array[0..2] of record
    Line: byte; {0..255}
    Sample: byte; {0..31}
    Ornament: byte; {0..15}
    Volume: shortint; {1-15 - vol, 0 - prev vol}
    Envelope: byte; {1-14 - R13, 15 - Envelope off, 0 - prev}
  end;

  PModule = ^TModule;
  TModule = packed record
    ChipFreq: Integer;
    IntFreq: Integer;
    Title, Author, Info: string;
    ShowInfo: Boolean;
    Ton_Table: byte;
    Initial_Delay: byte;
    Positions: TPosition;
    Samples: array[1..32] of PSample;       // 32 sample for samples browser preview (check PreviewSamNum const)
    Ornaments: array[0..16] of POrnament;   // 16 ornament for ornaments browser preview (check PreviewOrnNum const)
    Patterns: array[-1..MaxPatNum] of PPattern;
    FeaturesLevel: integer;
    VortexModule_Header: boolean;
    IsChans: array[0..2] of record
      Global_Ton, Global_Noise, Global_Envelope, EnvelopeEnabled: boolean;
      Ornament, Sample, Volume: byte;
    end;
  end;

  PSpeccyModule = ^TSpeccyModule;
  TSpeccyModule = packed record
    case Integer of
      0: (Index: array[0..65535] of byte);
      1: (PT3_Name: array[0..$62] of char;
        PT3_Table: byte;
        PT3_Delay: byte;
        PT3_NumberOfPositions: byte;
        PT3_LoopPosition: byte;
        PT3_PatternsPointer: word;
        PT3_SamplePointers: array[0..31] of word;
        PT3_OrnamentPointers: array[0..15] of word);
      2: (PT2_Delay: byte;
        PT2_NumberOfPositions: byte;
        PT2_LoopPosition: byte;
        PT2_SamplePointers: array[0..31] of word;
        PT2_OrnamentPointers: array[0..15] of word;
        PT2_PatternsPointer: word;
        PT2_MusicName: array[0..29] of char;
        PT2_PositionList: array[0..65535 - 131] of byte);
      3: (ST_Delay: byte;
        ST_PositionsPointer, ST_OrnamentsPointer, ST_PatternsPointer: word;
        ST_Name: array[0..17] of char;
        ST_Size: word);
      4: (STP_Delay: byte;
        STP_PositionsPointer, STP_PatternsPointer,
        STP_OrnamentsPointer, STP_SamplesPointer: word;
        STP_Init_Id: byte);
      5: (SQT_Size, SQT_SamplesPointer, SQT_OrnamentsPointer, SQT_PatternsPointer,
        SQT_PositionsPointer, SQT_LoopPointer: word);
      6: (ASC1_Delay, ASC1_LoopingPosition: byte;
        ASC1_PatternsPointers, ASC1_SamplesPointers, ASC1_OrnamentsPointers: word;
        ASC1_Number_Of_Positions: byte;
        ASC1_Positions: array[0..65535 - 9] of byte);
      7: (ASC0_Delay: byte;
        ASC0_PatternsPointers, ASC0_SamplesPointers, ASC0_OrnamentsPointers: word;
        ASC0_Number_Of_Positions: byte;
        ASC0_Positions: array[0..65535 - 8] of byte);
      8: (PSC_MusicName: array[0..68] of char;
        PSC_UnknownPointer: word;
        PSC_PatternsPointer: word;
        PSC_Delay: byte;
        PSC_OrnamentsPointer: word;
        PSC_SamplesPointers: array[0..31] of word);
      9: (FLS_PositionsPointer: word;
        FLS_OrnamentsPointer: word;
        FLS_SamplesPointer: word;
        FLS_PatternsPointers: array[1..(65536 - 6) div 6] of packed record
          PatternA, PatternB, PatternC: word;
        end);
      10: (PT1_Delay: byte;
        PT1_NumberOfPositions: byte;
        PT1_LoopPosition: byte;
        PT1_SamplesPointers: array[0..15] of word;
        PT1_OrnamentsPointers: array[0..15] of word;
        PT1_PatternsPointer: word;
        PT1_MusicName: array[0..29] of char;
        PT1_PositionList: array[0..65535 - 99] of byte);
      11: (GTR_Delay: byte;
        GTR_ID: array[0..3] of char;
        GTR_Address: word;
        GTR_Name: array[0..31] of char;
        GTR_SamplesPointers: array[0..14] of word;
        GTR_OrnamentsPointers: array[0..15] of word;
        GTR_PatternsPointers: array[0..31] of packed record
          PatternA, PatternB, PatternC: word;
        end;
        GTR_NumberOfPositions: byte;
        GTR_LoopPosition: byte;
        GTR_Positions: array[0..65536 - 295 - 1] of byte);
      12: (FTC_MusicName: array[0..68] of char;
        FTC_Delay: byte;
        FTC_Loop_Position: byte;
        FTC_Slack: integer;
        FTC_PatternsPointer: word;
        FTC_Slack2: array[0..4] of byte;
        FTC_SamplesPointers: array[0..31] of word;
        FTC_OrnamentsPointers: array[0..32] of word;
        FTC_Positions: array[0..(65536 - $D4) div 2 - 1] of packed record
          Pattern: byte;
          Transposition: shortint;
        end);
      13: (PSM_PositionsPointer: word;
        PSM_SamplesPointer: word;
        PSM_OrnamentsPointer: word;
        PSM_PatternsPointer: word;
        PSM_Remark: array[0..65535 - 8] of byte);
  end;

  //AY-file header and structures
  TAYFileHeader = packed record
    FileID, TypeID: longword;
    FileVersion, PlayerVersion: byte;
    PSpecialPlayer, PAuthor, PMisc: smallint;
    NumOfSongs, FirstSong: byte;
    PSongsStructure: smallint;
  end;

  TSongStructure = packed record
    PSongName, PSongData: smallint;
  end;

  TSongData = packed record
    ChanA, ChanB, ChanC, Noise: byte;
    SongLength: word;
    FadeLength: word;
    HiReg, LoReg: byte;
    PPoints, PAddresses: smallint;
  end;

  TPoints = packed record
    Stek, Init, Inter: word;
    Adr1, Len1, Offs1, Adr2, Len2, Offs2, Zero: word;
  end;


  TChanParams = record
    SamplePosition, SamplePrevPosition: byte;
    OrnamentPosition: byte;
    SoundEnabled: boolean;
    Slide_To_Note, Note: Byte;
    Ton_Slide_Delay: shortint;
    Ton_Slide_Count: shortint;
    Ton_Slide_Step, Ton_Slide_Delta: SmallInt;
    Ton_Slide_Type: integer;
    Current_Ton_Sliding: SmallInt;
    OnOff_Delay, OffOn_Delay, Current_OnOff: shortint;
    Ton, Ton_Accumulator: word;
    Amplitude: Byte;
    Current_Amplitude_Sliding: shortint;
    Current_Envelope_Sliding: shortint;
    Current_Noise_Sliding: shortint;
  end;

  // FamiTracker Row
  PFamiRow = ^TFamiRow;
  TFamiRow = packed record
    Note: Byte;
    Octave: Byte;
    NoteVolume: Byte;
    Instrument: Byte;
    fx1cmd: Byte;
    fx2cmd: Byte;
    fx3cmd: Byte;
    fx4cmd: Byte;
    fx1prm: Byte;
    fx2prm: Byte;
    fx3prm: Byte;
    fx4prm: Byte;
  end;

  // FamiTracker Clipboard
  TFamiTrackerBuffer = record
    Channels: Integer;
    Rows: Integer;
    SelectStart: Integer;
    SelectEnd: Integer;
    undefined1: Integer;
    undefined2: Integer;
    Data: array of TFamiRow;
  end;


const
  FamiNotes = 'C-C#D-D#E-F-F#G-G#A-A#B-';


  EmptySampleTick: TSampleTick =
  (Add_to_Ton: 0; Ton_Accumulation: False; Amplitude: 0; Amplitude_Sliding: False;
    Amplitude_Slide_Up: False; Envelope_Enabled: False;
    Envelope_or_Noise_Accumulation: False; Add_to_Envelope_or_Noise: 0; Mixer_Ton: False;
    Mixer_Noise: False);
  EmptyChannelLine: TChannelLine =
  (Note: - 1; Sample: 0; Ornament: 0; Volume: 0; Envelope: 0;
    Additional_Command: (Number: 0; Delay: 0; Parameter: 0));
  KsaId = 'KSA SOFTWARE COMPILATION OF ';

  
var
  FamiClipboardType: Integer;
  UnlimiteDelay: Boolean;
  TxtFile: TextFile;
  TxtLine: integer;
  TxtString: string;
  MidChan: integer = 1;
  CurChip: integer;
  PlVars: array[1..MaxNumberOfSoundChips] of record
    CurrentPosition: integer;
    CurrentPattern: integer;
    CurrentLine: Integer;
    Env_Base: smallint;
    ParamsOfChan: array[0..2] of TChanParams;
    Delay, DelayCounter: shortint;
    Cur_Env_Slide: smallint;
    Cur_Env_Delay, Env_Delay: shortint;
    Env_Slide_Add: smallint;
    AddToEnv, AddToNoise: shortint;
    PT3Noise: Byte;
    IntCnt: integer;
  end;

procedure checkVTMPointer;

procedure Module_SetPointer(ModulePointer: PModule; Chip: integer);
{устанавливает указатель на структуру модуля}
{Вызывается хотя бы раз перед использованием других процедур}

procedure Module_SetDelay(Dl: shortint);
{Устанавливает текущий Delay
В процессе проигрывания Delay может меняться спец командой}
{Вызывается каждый раз перед началом проигрывания процедурами
 Pattern_PlayCurrentLine или Module_PlayCurrentLine, иначе
 будет использовано последнее значение Delay, которое в общем
 случае может быть любым. Диапазон значений - 3..255
 (3 - для совместимости с PT3)}

procedure Module_SetCurrentPosition(Position: Integer);
{устанавливает текущую позицию}
{значения Position: 0..255;
 Это значение используется в качестве индекса при выборе номера паттерна
 из VTM.Position_List)}

procedure Module_SetCurrentPattern(Pattern: Integer);
{устанавливает текущую позицию}
{значения Pattern: 0..MaxPatNum}

procedure Pattern_SetCurrentLine(Line: Integer);
{устанавливает текущую строку в паттерне}
{Значения: от 0 до PatternLength-1}
{С этой строки начнут проигрывание функции
 Module_PlayCurrentLine или Pattern_PlayCurrentLine)}

procedure Module_GoNextPosition;
{Переход на паттерн следующей позиции, на первую линию}

function Pattern_PlayCurrentLine: Integer;
{возвращает значения регистров AY для текущей строки паттерна
 и делает следующую строку текущей.
 На выходе:
 Если '1' - строка закончилась и AYRegisters уже от новой строки
 Если '2' - больше строк нет и AYRegisters не меняются
 Иначе - '0'}

function Module_PlayCurrentLine: Integer;
{возвращает значения регистров AY для текущей строки паттерна
 и делает следующую строку текущей, по достижению последней
 строки автоматически становится текущим следующий по Position
 List паттерн.
 На выходе:
 Если '1' - строка закончилась и AYRegisters уже от новой строки
 Если '2' - Паттерн закончился и AYRegisters - от первой строки
            следующего по PositionList патерна
 Если '3' - все паттерны закончились и AYRegisters - от первой строки
            первого по PositionList патерна
 Иначе - '0'}


procedure Pattern_PlayOnlyCurrentLine;
{возвращает значения регистров AY для текущей строки паттерна, переход
 на следующую строку не производится.}

function PT32VTM(PT3: PSpeccyModule; FSize: Integer; VTM1: PModule; var VTM2: PModule): boolean;
{конвертер из PT3 в VTM.
 PT3 - указатель на предварительно загруженный PT3}

procedure InitTrackerParameters(All: boolean);
{Вызвать для инициализации внутренних переменных}
{All = True => 1F.F => Sam=1,Env=15,Orn=0,Vol=15}


procedure ValidatePattern(pat: integer; VTM: PModule);
function LoadPatternDataTxt(OnePat: PPattern; DecNoise: Boolean): integer;
function LoadSampleDataTxt(Sam: PSample; DecNoise: Boolean): string;
function GetEmptySample: TSample;
procedure ValidateSample(sam: integer; VTM: PModule);
function RecognizeOrnamentString(const orst: string; Orn: POrnament): boolean;
function LoadModuleFromText(FN: string; VTM1: PModule; var VTM2: PModule): integer;
function PT22VTM(PT2: PSpeccyModule; VTM: PModule): boolean;
function PT12VTM(PT1: PSpeccyModule; VTM: PModule): boolean;
function STC2VTM(STC: PSpeccyModule; FSize: integer; VTM: PModule): boolean;
function STP2VTM(STP: PSpeccyModule; VTM: PModule): boolean;
function SQT2VTM(SQT: PSpeccyModule; VTM: PModule): boolean;
function ASC2VTM(ASC: PSpeccyModule; VTM: PModule): boolean;
function PSC2VTM(PSC: PSpeccyModule; VTM: PModule): boolean;
function FLS2VTM(FLS: PSpeccyModule; VTM: PModule): boolean;
function GTR2VTM(GTR: PSpeccyModule; VTM: PModule): boolean;
function FTC2VTM(FTC: PSpeccyModule; VTM: PModule): boolean;
function FXM2VTM(FXM: PSpeccyModule; ZXAddr, Tm, amad_andsix: integer;
  SongN, AuthN: string; VTM: PModule): boolean;
function PSM2VTM(PSM: PSpeccyModule; VTM: PModule): boolean;

function IntsToTime(i: integer): string;
function Int2ToStr(i: integer): string;
function Int1DToStr(i: integer): string;
function SampToStr(i: integer): string;
function NoteToStr(i: integer): string;
function NoteToStr2(i: integer): string;
function Int2DToStr(i: integer): string;
function Int4DToStr(i: integer): string;
function SGetNumber(s: string; max: integer; var res: integer): boolean;
function SGetDecNumber(s: string; max: integer; var res: integer): boolean;
function SGetNote(s: string; var res: integer): boolean;
function SGetNote2(s: string): ShortInt;
function GetOutPatternLineString(PatNum: integer; PatPtr: PPattern;
  LineNum: integer; Chn: TChansArray; Previous:Boolean): string;
function GetPatternLineString(PatPtr: PPattern; Line: integer; Chn: TChansArray;
  LineNums, Separators: Boolean): string;
function GetSampleString(SL: TSampleTick; Vol, Ns: boolean): string;
function GetSampleStringForRedraw(SL: TSampleTick): string;
procedure SavePattern(VTMP: PModule; n: integer);
procedure SaveSample(VTMP: PModule; n: integer);
procedure SaveOrnament(VTM: PModule; n: integer);
procedure VTM2TextFile(FileName: string; VTM: PModule; Apnd: boolean);
function VTM2PT3(PT3: PSpeccyModule; VTM: PModule;
  var Module_Size: Integer): boolean;
{конвертер из VTM в PT3.
 PT3 - указатель, где будет сформирован PT3
 в Module_Size возвращается размер данного PT3}

procedure PrepareZXModule(ZXP: PSpeccyModule; var FType: Available_Types; Length: integer);
function LoadAndDetect(ZXP: PSpeccyModule; FileName: string; var Length: integer;
  var FType2: Available_Types; var TSSize2: integer;
  var ZXAddr: word; var Tm: integer; var Andsix: byte;
  var AuthorName, SongName: string): Available_Types;
function GetModuleTime(VTM: PModule): integer;
function GetPositionTime(VTM: PModule; Pos: integer; var PosDelay: integer): integer;
function GetPositionTimeEx(VTM: PModule; Pos, PosDelay, Line: integer): integer;
function GetNoteFreq(ToneTable, Note: Integer): Integer;
function GetNoteByEnvelope(e: integer): integer;
function GetNoteByEnvelope2(ToneTableIndex: integer; e: integer): integer;
procedure GetTimeParams(VTM: PModule; Time: integer; var Pos, Line: integer);

procedure FreeVTMP(var VTMP: PModule);
procedure NewVTMP(var VTMP: PModule);


type
  PT3ToneTable = array[0..95] of word;
  PPT3ToneTable = ^PT3ToneTable;

const
  Notes: array[0..11] of string = (
    'C-', 'C#', 'D-', 'D#', 'E-', 'F-', 'F#', 'G-', 'G#', 'A-', 'A#', 'B-'
  );

  TableNames: array[0..4] of String = (
    'ProTracker 3.3',
    'Sound Tracker',
    'ASM or PSC (1.75 MHz)',
    'RealSound',
    'IvanRochin NATURAL Cmaj/Am'
  );

{Table #0 of Pro Tracker 3.4x - 3.5x}
  PT3NoteTable_PT: PT3ToneTable = (
    $0C22, $0B73, $0ACF, $0A33, $09A1, $0917, $0894, $0819, $07A4, $0737, $06CF, $066D,
    $0611, $05BA, $0567, $051A, $04D0, $048B, $044A, $040C, $03D2, $039B, $0367, $0337,
    $0308, $02DD, $02B4, $028D, $0268, $0246, $0225, $0206, $01E9, $01CE, $01B4, $019B,
    $0184, $016E, $015A, $0146, $0134, $0123, $0112, $0103, $00F5, $00E7, $00DA, $00CE,
    $00C2, $00B7, $00AD, $00A3, $009A, $0091, $0089, $0082, $007A, $0073, $006D, $0067,
    $0061, $005C, $0056, $0052, $004D, $0049, $0045, $0041, $003D, $003A, $0036, $0033,
    $0031, $002E, $002B, $0029, $0027, $0024, $0022, $0020, $001F, $001D, $001B, $001A,
    $0018, $0017, $0016, $0014, $0013, $0012, $0011, $0010, $000F, $000E, $000D, $000C);

{Table #1 of Pro Tracker 3.3x - 3.5x)}
  PT3NoteTable_ST: PT3ToneTable = (
    $0EF8, $0E10, $0D60, $0C80, $0BD8, $0B28, $0A88, $09F0, $0960, $08E0, $0858, $07E0,
    $077C, $0708, $06B0, $0640, $05EC, $0594, $0544, $04F8, $04B0, $0470, $042C, $03FD,
    $03BE, $0384, $0358, $0320, $02F6, $02CA, $02A2, $027C, $0258, $0238, $0216, $01F8,
    $01DF, $01C2, $01AC, $0190, $017B, $0165, $0151, $013E, $012C, $011C, $010A, $00FC,
    $00EF, $00E1, $00D6, $00C8, $00BD, $00B2, $00A8, $009F, $0096, $008E, $0085, $007E,
    $0077, $0070, $006B, $0064, $005E, $0059, $0054, $004F, $004B, $0047, $0042, $003F,
    $003B, $0038, $0035, $0032, $002F, $002C, $002A, $0027, $0025, $0023, $0021, $001F,
    $001D, $001C, $001A, $0019, $0017, $0016, $0015, $0013, $0012, $0011, $0010, $000F);

{Table #2 of Pro Tracker 3.4x - 3.5x}
  PT3NoteTable_ASM: PT3ToneTable = (
    $0D10, $0C55, $0BA4, $0AFC, $0A5F, $09CA, $093D, $08B8, $083B, $07C5, $0755, $06EC,
    $0688, $062A, $05D2, $057E, $052F, $04E5, $049E, $045C, $041D, $03E2, $03AB, $0376,
    $0344, $0315, $02E9, $02BF, $0298, $0272, $024F, $022E, $020F, $01F1, $01D5, $01BB,
    $01A2, $018B, $0174, $0160, $014C, $0139, $0128, $0117, $0107, $00F9, $00EB, $00DD,
    $00D1, $00C5, $00BA, $00B0, $00A6, $009D, $0094, $008C, $0084, $007C, $0075, $006F,
    $0069, $0063, $005D, $0058, $0053, $004E, $004A, $0046, $0042, $003E, $003B, $0037,
    $0034, $0031, $002F, $002C, $0029, $0027, $0025, $0023, $0021, $001F, $001D, $001C,
    $001A, $0019, $0017, $0016, $0015, $0014, $0012, $0011, $0010, $000F, $000E, $000D);

{Table #3 of Pro Tracker 3.4x - 3.5x}
  PT3NoteTable_REAL: PT3ToneTable = (
    $0CDA, $0C22, $0B73, $0ACF, $0A33, $09A1, $0917, $0894, $0819, $07A4, $0737, $06CF,
    $066D, $0611, $05BA, $0567, $051A, $04D0, $048B, $044A, $040C, $03D2, $039B, $0367,
    $0337, $0308, $02DD, $02B4, $028D, $0268, $0246, $0225, $0206, $01E9, $01CE, $01B4,
    $019B, $0184, $016E, $015A, $0146, $0134, $0123, $0112, $0103, $00F5, $00E7, $00DA,
    $00CE, $00C2, $00B7, $00AD, $00A3, $009A, $0091, $0089, $0082, $007A, $0073, $006D,
    $0067, $0061, $005C, $0056, $0052, $004D, $0049, $0045, $0041, $003D, $003A, $0036,
    $0033, $0031, $002E, $002B, $0029, $0027, $0024, $0022, $0020, $001F, $001D, $001B,
    $001A, $0018, $0017, $0016, $0014, $0013, $0012, $0011, $0010, $000F, $000E, $000D);

 {Table #4 of IvanRochin NATURAL Cmaj/Am}
  PT3NoteTable_NATURAL: PT3ToneTable = (
//5760, 5400, 5120, 4800, 4608, 4320, 4050, 3840, 3600, 3456, 3240, 3072, //3041280
//1520640 MHz
    2880, 2700, 2560, 2400, 2304, 2160, 2025, 1920, 1800, 1728, 1620, 1536,
    1440, 1350, 1280, 1200, 1152, 1080, 1013, 960, 900, 864, 810, 768,
    720, 675, 640, 600, 576, 540, 506, 480, 450, 432, 405, 384,
    360, 338, 320, 300, 288, 270, 253, 240, 225, 216, 203, 192,
    180, 169, 160, 150, 144, 135, 127, 120, 113, 108, 101, 96,
    90, 84, 80, 75, 72, 68, 63, 60, 56, 54, 51, 48,
    45, 42, 40, 38, 36, 34, 32, 30, 28, 27, 25, 24,
    23, 21, 20, 19, 18, 17, 16, 15, 14, 14, 13, 12);


{Volume table of Pro Tracker 3.5x}
  PT3_Vol: array[0..15, 0..15] of byte = (
    ($00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00),
    ($00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01),
    ($00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $02, $02, $02, $02),
    ($00, $00, $00, $01, $01, $01, $01, $01, $02, $02, $02, $02, $02, $03, $03, $03),
    ($00, $00, $01, $01, $01, $01, $02, $02, $02, $02, $03, $03, $03, $03, $04, $04),
    ($00, $00, $01, $01, $01, $02, $02, $02, $03, $03, $03, $04, $04, $04, $05, $05),
    ($00, $00, $01, $01, $02, $02, $02, $03, $03, $04, $04, $04, $05, $05, $06, $06),
    ($00, $00, $01, $01, $02, $02, $03, $03, $04, $04, $05, $05, $06, $06, $07, $07),
    ($00, $01, $01, $02, $02, $03, $03, $04, $04, $05, $05, $06, $06, $07, $07, $08),
    ($00, $01, $01, $02, $02, $03, $04, $04, $05, $05, $06, $07, $07, $08, $08, $09),
    ($00, $01, $01, $02, $03, $03, $04, $05, $05, $06, $07, $07, $08, $09, $09, $0A),
    ($00, $01, $01, $02, $03, $04, $04, $05, $06, $07, $07, $08, $09, $0A, $0A, $0B),
    ($00, $01, $02, $02, $03, $04, $05, $06, $06, $07, $08, $09, $0A, $0A, $0B, $0C),
    ($00, $01, $02, $03, $03, $04, $05, $06, $07, $08, $09, $0A, $0A, $0B, $0C, $0D),
    ($00, $01, $02, $03, $04, $05, $06, $07, $07, $08, $09, $0A, $0B, $0C, $0D, $0E),
    ($00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F));

implementation

uses AY, WaveOutAPI, FXMImport, Main, RegExpr, Classes, StrUtils;

var
  VTM: PModule;


procedure checkVTMPointer;
  function DoNothing(a: Integer): Boolean;
  begin
    result := True;
  end;
  
var a: Integer;
begin
  if VTM = nil then Exit;
  try
    // Try to get access
    a := VTM.Ton_Table;
    DoNothing(a);
  except
    // VTM pointer is pointing to freed memory!
    // Let's clear pointer.
    VTM := nil;
  end;
end;

procedure Module_SetPointer(ModulePointer: PModule; Chip: integer);
begin
  VTM := ModulePointer;
  CurChip := Chip
end;

procedure Module_SetDelay(Dl: shortint);
begin
  PlVars[CurChip].Delay := Dl;
end;

procedure InitTrackerParameters(All: boolean);
var
  k: integer;
begin
  ResetAYChipEmulation(CurChip);
  PlVars[CurChip].DelayCounter := 1;
  PlVars[CurChip].PT3Noise := 0;
  PlVars[CurChip].Env_Base := 0;
  PlVars[CurChip].IntCnt := 0;
  if All then
    for k := 0 to 2 do
    begin
      VTM.IsChans[k].Sample := 1;
      VTM.IsChans[k].EnvelopeEnabled := False;
      VTM.IsChans[k].Ornament := 0;
      VTM.IsChans[k].Volume := 15
    end;
  for k := 0 to 2 do
  begin
    PlVars[CurChip].ParamsOfChan[k].SamplePosition := 0;
    PlVars[CurChip].ParamsOfChan[k].OrnamentPosition := 0;
    PlVars[CurChip].ParamsOfChan[k].SoundEnabled := False;
    PlVars[CurChip].ParamsOfChan[k].Note := 0;
    PlVars[CurChip].ParamsOfChan[k].Ton_Slide_Count := 0;
    PlVars[CurChip].ParamsOfChan[k].Current_Ton_Sliding := 0;
    PlVars[CurChip].ParamsOfChan[k].Current_OnOff := 0;
    PlVars[CurChip].ParamsOfChan[k].Ton_Accumulator := 0;
    PlVars[CurChip].ParamsOfChan[k].Ton := 0;
    PlVars[CurChip].ParamsOfChan[k].Current_Amplitude_Sliding := 0;
    PlVars[CurChip].ParamsOfChan[k].Current_Envelope_Sliding := 0;
    PlVars[CurChip].ParamsOfChan[k].Current_Noise_Sliding := 0
  end;
  PlVars[CurChip].CurrentLine := 0
end;

procedure Pattern_SetCurrentLine(Line: Integer);
begin
  PlVars[CurChip].CurrentLine := Line
end;

procedure Module_SetCurrentPattern(Pattern: Integer);
begin
  PlVars[CurChip].CurrentPattern := Pattern;
  Pattern_SetCurrentLine(0)
end;

procedure Module_SetCurrentPosition(Position: Integer);
begin
  if VTM.Positions.Length = 0 then exit;
  PlVars[CurChip].CurrentPosition := Position;
  Module_SetCurrentPattern(VTM.Positions.Value[Position])
end;

procedure Module_GoNextPosition;
var
  NextPosition, LastPosition: byte;
begin
  NextPosition := PlVars[CurChip].CurrentPosition + 1;
  LastPosition := VTM.Positions.Length - 1;

  if NextPosition > LastPosition then
    if LoopAllowed or MainForm.LoopAllAllowed then
      Module_SetCurrentPosition(VTM.Positions.Loop)
    else
      Pattern_SetCurrentLine(0)
  else
    Module_SetCurrentPosition(NextPosition);

  Pattern_PlayCurrentLine;
end;

function GetNoteFreq(ToneTable, Note: Integer): Integer;
begin
  case ToneTable of
    0: Result := PT3NoteTable_PT[Note];
    1: Result := PT3NoteTable_ST[Note];
    2: Result := PT3NoteTable_ASM[Note];
    3: Result := PT3NoteTable_REAL[Note];
  else
    Result := PT3NoteTable_NATURAL[Note]
  end
end;


function GetNoteByEnvelope2(ToneTableIndex: Integer; e: integer): integer;
var
  NoteTable: PT3ToneTable;
  n, i, d: Integer;
  f: Real;
  NearestNote: Integer;
  BestDistanceFoundYet: Word;

begin

  case ToneTableIndex of
    0: NoteTable := PT3NoteTable_PT;
    1: NoteTable := PT3NoteTable_ST;
    2: NoteTable := PT3NoteTable_ASM;
    3: NoteTable := PT3NoteTable_REAL;
  else
    NoteTable := PT3NoteTable_NATURAL;
  end;
  Result := -1;
  for i := 0 to Length(NoteTable)-1 do
  begin
    f := (NoteTable[i] / 16);
    n := Round(f);
    if n = e then
    begin
      Result := i;
      Exit;
    end
  end;

  if Result >= 0 then Exit;

  // Search nearest note
  NearestNote := -1;
  BestDistanceFoundYet := $FFFF;
  for i := 0 to Length(NoteTable)-1 do begin
    n := Round(NoteTable[i] / 16);

    d := Abs(e - n);
    if d < BestDistanceFoundYet then begin
      BestDistanceFoundYet := d;
      NearestNote := i;
    end;
  end;

  Result := NearestNote;

end;

function GetNoteByEnvelope(e: integer): integer;
var ToneTable: Integer;
begin
  checkVTMPointer;
  if VTM = nil then ToneTable := -1
  else
    ToneTable := VTM.Ton_Table;

  if ToneTable = -1 then
  begin
    Result := 0;
    Exit;
  end;

  Result := GetNoteByEnvelope2(ToneTable, e);
end;

procedure Pattern_PlayOnlyCurrentLine;
var
  TempMixer: integer;

  procedure GetRegisters(ChNum: integer);
  var
    j: byte;
    w: word;
    gt, gn, ge: boolean;
  begin
    with PlVars[CurChip].ParamsOfChan[ChNum], VTM.IsChans[ChNum] do
    begin
      if SoundEnabled then
      begin
        if (VTM.Samples[Sample] = nil) or
          (SamplePosition >= VTM.Samples[Sample].Length) then
          Ton := 0
        else
        begin
          Ton := Ton_Accumulator + VTM.Samples[Sample].Items[SamplePosition].Add_to_Ton;

          if VTM.Samples[Sample].Items[SamplePosition].Ton_Accumulation then
            Ton_Accumulator := Ton
        end;

        if (VTM.Ornaments[Ornament] = nil) or
          (OrnamentPosition >= VTM.Ornaments[Ornament].Length) then
          j := Note
        else
          j := Note + VTM.Ornaments[Ornament].Items[OrnamentPosition];

        if shortint(j) < 0 then
          j := 0
        else if j > 95 then
          j := 95;

        w := GetNoteFreq(VTM.Ton_Table, j);

        Ton := (Ton + Current_Ton_Sliding + w) and $FFF;

        if Ton_Slide_Count > 0 then
        begin
          Dec(Ton_Slide_Count);
          if Ton_Slide_Count = 0 then
          begin
            Inc(Current_Ton_Sliding, Ton_Slide_Step);
            Ton_Slide_Count := Ton_Slide_Delay;
            if Ton_Slide_Type = 1 then
              if ((Ton_Slide_Step < 0) and (Current_Ton_Sliding <= Ton_Slide_Delta)) or
                ((Ton_Slide_Step >= 0) and (Current_Ton_Sliding >= Ton_Slide_Delta)) then
              begin
                Note := Slide_To_Note;
                Ton_Slide_Count := 0;
                Current_Ton_Sliding := 0
              end
          end
        end;

        if (VTM.Samples[Sample] = nil) or
          (SamplePosition >= VTM.Samples[Sample].Length) then
          Amplitude := 0
        else
        begin
          Amplitude := VTM.Samples[Sample].Items[SamplePosition].Amplitude;
          if VTM.Samples[Sample].Items[SamplePosition].Amplitude_Sliding then
            if VTM.Samples[Sample].Items[SamplePosition].Amplitude_Slide_Up then
            begin
              if Current_Amplitude_Sliding < 15 then inc(Current_Amplitude_Sliding)
            end
            else
              if Current_Amplitude_Sliding > -15 then dec(Current_Amplitude_Sliding);
          inc(Amplitude, Current_Amplitude_Sliding);
          if shortint(Amplitude) < 0 then Amplitude := 0
          else if Amplitude > 15 then Amplitude := 15;
          Amplitude := PT3_Vol[Volume, Amplitude];

          if VTM.Samples[Sample].Items[SamplePosition].Envelope_Enabled and EnvelopeEnabled then
            Amplitude := Amplitude or 16;

          if not VTM.Samples[Sample].Items[SamplePosition].Mixer_Noise then
          begin
            j := Current_Envelope_Sliding +
              VTM.Samples[Sample].Items[SamplePosition].Add_to_Envelope_or_Noise;
            if VTM.Samples[Sample].Items[SamplePosition].
              Envelope_or_Noise_Accumulation then
              Current_Envelope_Sliding := j;
            inc(PlVars[CurChip].AddToEnv, j);
          end
          else
          begin
            PlVars[CurChip].PT3Noise := Current_Noise_Sliding +
              VTM.Samples[Sample].Items[SamplePosition].Add_to_Envelope_or_Noise;
              
            if VTM.Samples[Sample].Items[SamplePosition].Envelope_or_Noise_Accumulation then
              Current_Noise_Sliding := PlVars[CurChip].PT3Noise
          end;

          if not VTM.Samples[Sample].Items[SamplePosition].Mixer_Ton then
            TempMixer := TempMixer or 8;
          if not VTM.Samples[Sample].Items[SamplePosition].Mixer_Noise then
            TempMixer := TempMixer or $40;

        end;
        if VTM.Samples[Sample] <> nil then
        begin
          SamplePrevPosition := SamplePosition;
          Inc(SamplePosition);
          if SamplePosition >= VTM.Samples[Sample].Length then
            SamplePosition := VTM.Samples[Sample].Loop
        end;
        if VTM.Ornaments[Ornament] <> nil then
        begin
          inc(OrnamentPosition);
          if OrnamentPosition >= VTM.Ornaments[Ornament].Length then
            OrnamentPosition := VTM.Ornaments[Ornament].Loop
        end
      end
      else
        Amplitude := 0;

      TempMixer := TempMixer shr 1;
      if Current_OnOff > 0 then
      begin
        Dec(Current_OnOff);
        if Current_OnOff = 0 then
        begin
          SoundEnabled := not SoundEnabled;
          if SoundEnabled then
            Current_OnOff := OnOff_Delay
          else
            Current_OnOff := OffOn_Delay
        end
      end;
      if PlVars[CurChip].CurrentPattern = -1 then exit;
      gt := VTM.IsChans[ChNum].Global_Ton;
      gn := VTM.IsChans[ChNum].Global_Noise;
      ge := VTM.IsChans[ChNum].Global_Envelope;
      if (VTM.Samples[Sample] <> nil) and not VTM.Samples[Sample].Enabled then
      begin
        gt := False;
        gn := False;
        ge := False;
      end;
      if not gt then TempMixer := TempMixer or 4;
      if not gn then TempMixer := TempMixer or 32;
      if not ge then Amplitude := Amplitude and 15;
      if (not gt or not gn) and (Amplitude and 16 = 0) and (TempMixer and 36 = 36) then
        Amplitude := 0;
    end;
  end;

var
  k: integer;
begin
  Inc(PlVars[CurChip].IntCnt);
  PlVars[CurChip].AddToEnv := 0;
  TempMixer := 0;
  for k := 0 to 2 do
    GetRegisters(k);

  with SoundChip[CurChip] do
  begin
    SetMixerRegister(TempMixer);

    AYRegisters.TonA := PlVars[CurChip].ParamsOfChan[0].Ton;
    AYRegisters.TonB := PlVars[CurChip].ParamsOfChan[1].Ton;
    AYRegisters.TonC := PlVars[CurChip].ParamsOfChan[2].Ton;

    SetAmplA(PlVars[CurChip].ParamsOfChan[0].Amplitude);
    SetAmplB(PlVars[CurChip].ParamsOfChan[1].Amplitude);
    SetAmplC(PlVars[CurChip].ParamsOfChan[2].Amplitude);

    AYRegisters.Noise := (PlVars[CurChip].PT3Noise + PlVars[CurChip].AddToNoise) and 31;

    AYRegisters.Envelope := PlVars[CurChip].AddToEnv + PlVars[CurChip].Cur_Env_Slide + PlVars[CurChip].Env_Base;
  end;

  if PlVars[CurChip].Cur_Env_Delay > 0 then
  begin
    Dec(PlVars[CurChip].Cur_Env_Delay);
    if PlVars[CurChip].Cur_Env_Delay = 0 then
    begin
      PlVars[CurChip].Cur_Env_Delay := PlVars[CurChip].Env_Delay;
      Inc(PlVars[CurChip].Cur_Env_Slide, PlVars[CurChip].Env_Slide_Add)
    end
  end
end;

function Pattern_PlayCurrentLine: integer;

  procedure PatternInterpreter(ChNum: integer);
  var
    TS, PrNote, Ch, Gls: integer;
  begin
    Ch := ChNum;
    if PlVars[CurChip].CurrentPattern = -1 then Ch := MidChan;
    with VTM.Patterns[PlVars[CurChip].CurrentPattern].Items[PlVars[CurChip].CurrentLine].Channel[ChNum] do
    begin
      TS := PlVars[CurChip].ParamsOfChan[Ch].Current_Ton_Sliding;
      PrNote := PlVars[CurChip].ParamsOfChan[Ch].Note;
      if Note = -2 then
      begin
        PlVars[CurChip].ParamsOfChan[Ch].SoundEnabled := False;
        PlVars[CurChip].ParamsOfChan[Ch].Current_Envelope_Sliding := 0;
        PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Count := 0;
        PlVars[CurChip].ParamsOfChan[Ch].SamplePosition := 0;
        PlVars[CurChip].ParamsOfChan[Ch].OrnamentPosition := 0;
        PlVars[CurChip].ParamsOfChan[Ch].Current_Noise_Sliding := 0;
        PlVars[CurChip].ParamsOfChan[Ch].Current_Amplitude_Sliding := 0;
        PlVars[CurChip].ParamsOfChan[Ch].Current_OnOff := 0;
        PlVars[CurChip].ParamsOfChan[Ch].Current_Ton_Sliding := 0;
        PlVars[CurChip].ParamsOfChan[Ch].Ton_Accumulator := 0
      end
      else if Note <> -1 then
      begin
        PlVars[CurChip].ParamsOfChan[Ch].SoundEnabled := True;
        PlVars[CurChip].ParamsOfChan[Ch].Note := Note;
        PlVars[CurChip].ParamsOfChan[Ch].Current_Envelope_Sliding := 0;
        PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Count := 0;
        PlVars[CurChip].ParamsOfChan[Ch].SamplePosition := 0;
        PlVars[CurChip].ParamsOfChan[Ch].OrnamentPosition := 0;
        PlVars[CurChip].ParamsOfChan[Ch].Current_Noise_Sliding := 0;
        PlVars[CurChip].ParamsOfChan[Ch].Current_Amplitude_Sliding := 0;
        PlVars[CurChip].ParamsOfChan[Ch].Current_OnOff := 0;
        PlVars[CurChip].ParamsOfChan[Ch].Current_Ton_Sliding := 0;
        PlVars[CurChip].ParamsOfChan[Ch].Ton_Accumulator := 0
      end;

      if (Note <> -1) and (Sample <> 0) then
        VTM.IsChans[Ch].Sample := Sample;

      if not (Envelope in [0, 15]) then
      begin
        VTM.IsChans[Ch].EnvelopeEnabled := True;
        PlVars[CurChip].Env_Base := VTM.Patterns[PlVars[CurChip].CurrentPattern].Items[PlVars[CurChip].CurrentLine].Envelope;
        SoundChip[CurChip].SetEnvelopeRegister(Envelope);
        VTM.IsChans[Ch].Ornament := Ornament;
        PlVars[CurChip].ParamsOfChan[Ch].OrnamentPosition := 0;
        PlVars[CurChip].Cur_Env_Slide := 0;
        PlVars[CurChip].Cur_Env_Delay := 0;
      end
      else if Envelope = 15 then
      begin
        VTM.IsChans[Ch].EnvelopeEnabled := False;
        VTM.IsChans[Ch].Ornament := Ornament;
        PlVars[CurChip].ParamsOfChan[Ch].OrnamentPosition := 0;
      end
      else if Ornament <> 0 then
      begin
        VTM.IsChans[Ch].Ornament := Ornament;
        PlVars[CurChip].ParamsOfChan[Ch].OrnamentPosition := 0
      end;
      if Volume > 0 then VTM.IsChans[Ch].Volume := Volume;
      case Additional_Command.Number of
        1:
          begin
            Gls := Additional_Command.Delay;
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Delay := Gls;
            if (Gls = 0) and (VTM.FeaturesLevel >= 2) then Inc(Gls);
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Count := Gls;
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Step := Additional_Command.Parameter;
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Type := 0;
            PlVars[CurChip].ParamsOfChan[Ch].Current_OnOff := 0;
          end;
        2:
          begin
            Gls := Additional_Command.Delay;
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Delay := Gls;
            if (Gls = 0) and (VTM.FeaturesLevel >= 2) then Inc(Gls);
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Count := Gls;
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Step := -Additional_Command.Parameter;
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Type := 0;
            PlVars[CurChip].ParamsOfChan[Ch].Current_OnOff := 0;
          end;
        3:
          if (Note >= 0) or ((Note <> -2) and (VTM.FeaturesLevel >= 1)) then
          begin
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Delay := Additional_Command.Delay;
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Count := PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Delay;
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Step := Additional_Command.Parameter;
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Delta :=
              GetNoteFreq(VTM.Ton_Table, PlVars[CurChip].ParamsOfChan[Ch].Note) -
              GetNoteFreq(VTM.Ton_Table, PrNote);
            PlVars[CurChip].ParamsOfChan[Ch].Slide_To_Note := PlVars[CurChip].ParamsOfChan[Ch].Note;
            PlVars[CurChip].ParamsOfChan[Ch].Note := PrNote;
            if VTM.FeaturesLevel >= 1 then
              PlVars[CurChip].ParamsOfChan[Ch].Current_Ton_Sliding := TS;
            if PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Delta -
              PlVars[CurChip].ParamsOfChan[Ch].Current_Ton_Sliding < 0 then
              PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Step :=
                -PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Step;
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Type := 1;
            PlVars[CurChip].ParamsOfChan[Ch].Current_OnOff := 0
          end;
        4: PlVars[CurChip].ParamsOfChan[Ch].SamplePosition := Additional_Command.Parameter;
        5: PlVars[CurChip].ParamsOfChan[Ch].OrnamentPosition := Additional_Command.Parameter;
        6:
          begin
            PlVars[CurChip].ParamsOfChan[Ch].OffOn_Delay := Additional_Command.Parameter and 15;
            PlVars[CurChip].ParamsOfChan[Ch].OnOff_Delay := Additional_Command.Parameter shr 4;
            PlVars[CurChip].ParamsOfChan[Ch].Current_OnOff := PlVars[CurChip].ParamsOfChan[Ch].OnOff_Delay;
            PlVars[CurChip].ParamsOfChan[Ch].Ton_Slide_Count := 0;
            PlVars[CurChip].ParamsOfChan[Ch].Current_Ton_Sliding := 0
          end;
        9:
          begin
            PlVars[CurChip].Env_Delay := Additional_Command.Delay;
            PlVars[CurChip].Cur_Env_Delay := PlVars[CurChip].Env_Delay;
            PlVars[CurChip].Env_Slide_Add := Additional_Command.Parameter
          end;
        10:
          begin
            PlVars[CurChip].Env_Delay := Additional_Command.Delay;
            PlVars[CurChip].Cur_Env_Delay := PlVars[CurChip].Env_Delay;
            PlVars[CurChip].Env_Slide_Add := -Additional_Command.Parameter
          end;
        11: if Additional_Command.Parameter <> 0 then
            PlVars[CurChip].Delay := Additional_Command.Parameter
      end
    end;

  end;

var
  k: integer;
begin
  Result := 0;
  if PlVars[CurChip].CurrentPattern = -1 then
  begin
    PlVars[CurChip].AddToNoise := VTM.Patterns[-1].Items[PlVars[CurChip].CurrentLine].Noise;
    PatternInterpreter(0)
  end
  else
  begin

    if not UnlimiteDelay or not IsPlaying then
      Dec(PlVars[CurChip].DelayCounter);

    if PlVars[CurChip].DelayCounter = 0 then
    begin
      Inc(Result);
      if VTM.Patterns[PlVars[CurChip].CurrentPattern].Length <= PlVars[CurChip].CurrentLine then
      begin
        Inc(PlVars[CurChip].DelayCounter);
        Inc(Result);
        exit
      end;
      PlVars[CurChip].AddToNoise := VTM.Patterns[PlVars[CurChip].CurrentPattern].Items[PlVars[CurChip].CurrentLine].Noise;
      for k := 0 to 2 do
        PatternInterpreter(k);
      Inc(PlVars[CurChip].CurrentLine);
      PlVars[CurChip].DelayCounter := PlVars[CurChip].Delay
    end
  end;

  Pattern_PlayOnlyCurrentLine
end;

function Module_PlayCurrentLine: Integer;
begin

  if VTM.Positions.Length = 0 then
  begin
    Result := 3;
    exit;
  end;
  Result := Pattern_PlayCurrentLine;
  if Result = 2 then
  begin
    inc(PlVars[CurChip].CurrentPosition);
    if PlVars[CurChip].CurrentPosition >= VTM.Positions.Length then
    begin
      PlVars[CurChip].CurrentPosition := VTM.Positions.Loop;
      inc(Result);
    end;
    PlVars[CurChip].CurrentPattern := VTM.Positions.Value[PlVars[CurChip].CurrentPosition];
    PlVars[CurChip].CurrentLine := 0;
    Pattern_PlayCurrentLine
  end;

end;


function GetString(var st: string): boolean;
begin
  st := '';
  repeat
    Result := not eof(TxtFile);
    if Result then
    begin
      Readln(TxtFile, st);
      inc(TxtLine)
    end;
    st := Trim(st);
  until (not Result) or (st <> '')
end;

function RecognizeOrnamentString;
var
  lp, l, i, j, sl: integer;
begin
  Result := False;
  lp := 0;
  l := 0;
  i := 1;
  sl := Length(orst);
  repeat
    while (i <= sl) and not (orst[i] in ['0'..'9', '-', '+', 'L']) do Inc(i);
    if i <= sl then
      if orst[i] = 'L' then
      begin
        lp := l;
        Inc(i)
      end
      else
      begin
        j := i;
        repeat
          Inc(i)
        until (i > sl) or not (orst[i] in ['0'..'9']);
        try
          Orn.Items[l] := StrToInt(Copy(orst, j, i - j))
        except
          exit
        end;
        Inc(l)
      end
  until (i > sl) or (l >= MaxOrnLen);
  Result := l <> 0;
  if Result then
  begin
    Orn.Length := l;
    Orn.Loop := lp;
    for i := l to MaxOrnLen - 1 do
      Orn.Items[i] := 0;
  end;
end;

function GetEmptySample: TSample;
var i: Integer;
begin
    Result.Loop := 0;
    Result.Length := 1;
    Result.Enabled := True;
    Result.Items[0].Add_to_Ton := 0;
    Result.Items[0].Ton_Accumulation := False;
    Result.Items[0].Amplitude := 0;
    Result.Items[0].Amplitude_Sliding := False;
    Result.Items[0].Amplitude_Slide_Up := False;
    Result.Items[0].Envelope_Enabled := False;
    Result.Items[0].Envelope_or_Noise_Accumulation := False;
    Result.Items[0].Add_to_Envelope_or_Noise := 0;
    Result.Items[0].Mixer_Ton := False;
    Result.Items[0].Mixer_Noise := False;
    for i := 1 to MaxSamLen - 1 do
      Result.Items[i] := EmptySampleTick;
end;

procedure ValidateSample;
var
  i: integer;
begin
  if VTM.Samples[sam] = nil then
  begin
    New(VTM.Samples[sam]);
    VTM.Samples[sam].Loop := 0;
    VTM.Samples[sam].Length := 1;
    VTM.Samples[sam].Enabled := True;
    VTM.Samples[sam].Items[0].Add_to_Ton := 0;
    VTM.Samples[sam].Items[0].Ton_Accumulation := False;
    VTM.Samples[sam].Items[0].Amplitude := 0;
    VTM.Samples[sam].Items[0].Amplitude_Sliding := False;
    VTM.Samples[sam].Items[0].Amplitude_Slide_Up := False;
    VTM.Samples[sam].Items[0].Envelope_Enabled := False;
    VTM.Samples[sam].Items[0].Envelope_or_Noise_Accumulation := False;
    VTM.Samples[sam].Items[0].Add_to_Envelope_or_Noise := 0;
    VTM.Samples[sam].Items[0].Mixer_Ton := False;
    VTM.Samples[sam].Items[0].Mixer_Noise := False;

    for i := 1 to MaxSamLen - 1 do
      VTM.Samples[sam].Items[i] := EmptySampleTick;
      
    {
    // Sample templates is disabled now
    for i := 1 to MaxSamLen - 1 do
      VTM.Samples[sam].Items[i] := MainForm.SampleLineTemplates[MainForm.CurrentSampleLineTemplate];
    }
  end;
end;

function LoadSampleDataTxt(Sam: PSample; DecNoise: Boolean): string;
var
  str: string;
  pos, sign, num, lp, len: integer;

  function GetNum: boolean;
  begin
    Result := False;
    while (pos <= Length(str)) and not (str[pos] in ['+', '-', '0'..'9', 'A'..'F', 'a'..'f']) do Inc(pos);
    if pos > Length(str) then exit;
    sign := 1;
    if str[pos] in ['+', '-'] then
    begin
      if str[pos] = '-' then sign := -1;
      Inc(pos)
    end;
    num := 0;
    while (pos <= Length(str)) and (str[pos] in ['0'..'9', 'A'..'F', 'a'..'f']) do
    begin
      if DecNoise and (pos = 11) then
      begin
        num := StrToInt(str[pos] + str[pos+1]);
        Inc(pos);
      end
      else
      if str[pos] in ['0'..'9'] then
        num := num * 16 + Ord(str[pos]) - Ord('0')
      else
        num := num * 16 + (Ord(str[pos]) or $20) - Ord('a') + 10;
      Inc(pos);
    end;
    num := num * sign;
    Result := True
  end;

  function RecognizeSampleString: boolean;
  begin
    Result := False;
    str := Trim(str);
    if str = '' then exit;
    Result := True;
    pos := 1;
    Sam.Items[len] := EmptySampleTick;
    while (pos <= Length(str)) and not (str[pos] in ['t', 'T', '.']) do Inc(pos);
    if pos > Length(str) then exit;
    Sam.Items[len].Mixer_Ton := str[pos] = 'T';
    Inc(pos);
    while (pos <= Length(str)) and not (str[pos] in ['n', 'N', '.']) do Inc(pos);
    if pos > Length(str) then exit;
    Sam.Items[len].Mixer_Noise := str[pos] = 'N';
    Inc(pos);
    while (pos <= Length(str)) and not (str[pos] in ['e', 'E', '.']) do Inc(pos);
    if pos > Length(str) then exit;
    Sam.Items[len].Envelope_Enabled := str[pos] = 'E';
    Inc(pos);
    if not GetNum then exit;
    Sam.Items[len].Add_to_Ton := num;
    while (pos <= Length(str)) and not (str[pos] in ['_', '^']) do Inc(pos);
    if pos > Length(str) then exit;
    Sam.Items[len].Ton_Accumulation := str[pos] = '^';
    Inc(pos);
    if not GetNum then exit;
    Sam.Items[len].Add_to_Envelope_or_Noise := num and $1F;
    if Sam.Items[len].Add_to_Envelope_or_Noise and $10 <> 0 then
      Sam.Items[len].Add_to_Envelope_or_Noise :=
        Sam.Items[len].Add_to_Envelope_or_Noise or shortint($F0);
    while (pos <= Length(str)) and not (str[pos] in ['_', '^']) do Inc(pos);
    if pos > Length(str) then exit;
    Sam.Items[len].Envelope_or_Noise_Accumulation := str[pos] = '^';
    Inc(pos);
    if not GetNum then exit;
    Sam.Items[len].Amplitude := num and 15;
    while (pos <= Length(str)) and not (str[pos] in ['_', '+', '-']) do Inc(pos);
    if pos > Length(str) then exit;
    if str[pos] in ['+', '-'] then
    begin
      Sam.Items[len].Amplitude_Sliding := True;
      Sam.Items[len].Amplitude_Slide_Up := str[pos] = '+'
    end;
    Inc(pos);
    while (pos <= Length(str)) and not (str[pos] in ['l', 'L']) do Inc(pos);
    if pos > Length(str) then exit;
    lp := len
  end;

begin
  Result := '';
  len := 0;
  lp := 0;
  while GetString(str) do
  begin
    if str[1] = '[' then break;
    if not RecognizeSampleString then
    begin
      Result := 'Bad file structure';
      exit
    end;
    Inc(len);
    if len = MaxSamLen then break;
  end;
  if len = 0 then
  begin
    Result := 'Error: empty sample';
    exit;
  end
  else
  begin
    TxtString := str;
    Sam.Loop := lp;
    Sam.Length := len;
    Sam.Enabled := True;
    for len := len to MaxSamLen - 1 do
      Sam.Items[len] := EmptySampleTick;
  end;
end;

procedure NewPattern(var Pat: PPattern);
var
  i: integer;
begin
  New(Pat);
  for i := 0 to MaxPatLen - 1 do
    with Pat.Items[i] do
    begin
      Envelope := 0;
      Noise := 0;
      Channel[0] := EmptyChannelLine;
      Channel[1] := EmptyChannelLine;
      Channel[2] := EmptyChannelLine;
    end;
  Pat.Length := DefPatLen;
end;

procedure ValidatePattern;
begin
  if VTM.Patterns[pat] = nil then
    NewPattern(VTM.Patterns[pat]);
end;

function SGetNumber(s: string; max: integer; var res: integer): boolean;
var
  i: integer;
begin
  Result := False;
  res := 0;
  for i := 1 to Length(s) do
  begin
    if s[i] = '.' then s[i] := '0';
    s := UpperCase(s);
    case s[i] of
      '0'..'9': res := res * 16 + Ord(s[i]) - Ord('0');
      'A'..'V': res := res * 16 + Ord(s[i]) - Ord('A') + 10
    else exit
    end
  end;
  if res > max then exit;
  Result := True
end;

function SGetDecNumber(s: string; max: integer; var res: integer): boolean;
var
  i: integer;
begin
  Result := False;
  res := 0;
  for i := 1 to Length(s) do
  begin
    if s[i] = '.' then s[i] := '0';
    res := res * 10 + Ord(s[i]) - Ord('0');
  end;
  if res > max then exit;
  Result := True
end;

function SGetNote(s: string; var res: Integer): boolean;
var
  d, o, n: integer;
begin
  s := UpperCase(s);
  Result := True;
  res := -2;
  if s = 'R--' then exit;
  inc(res);
  if s = '---' then exit;
  Result := False;
  d := 0;
  if s[2] = '#' then d := 1
  else if s[2] <> '-' then exit;
  o := Ord(s[3]) - Ord('1');
  if not (o in [0..7]) then exit;
  case s[1] of
    'C': n := 0;
    'D': n := 2;
    'E': n := 4;
    'F': n := 5;
    'G': n := 7;
    'A': n := 9;
    'B': n := 11
  else exit
  end;
  res := n + d + o * 12;
  if res > 95 then exit;
  Result := True
end;


function SGetNote2(s: string): ShortInt;
var
  d, o, n: integer;
begin
  s := UpperCase(s);
  Result := -2;
  if s = 'R--' then exit;
  Inc(Result);
  if s = '---' then exit;

  d := 0;
  if s[2] = '#' then d := 1
  else if s[2] <> '-' then exit;
  o := Ord(s[3]) - Ord('1');
  if not (o in [0..7]) then exit;
  case s[1] of
    'C': n := 0;
    'D': n := 2;
    'E': n := 4;
    'F': n := 5;
    'G': n := 7;
    'A': n := 9;
    'B': n := 11
  else exit
  end;
  Result := n + d + o * 12;
  if Result > 95 then Exit;
end;

function LoadPatternDataTxt;
var
  s: string;
  len: integer;

  function RecognizePatternString: boolean;
  var
    i, j: integer;
  begin
    Result := False;

    if (Length(s) <> 49) and (Length(s) <> 48) then exit;
    if SGetNumber(Copy(s, 1, 4), 65535, i) then
    begin
      OnePat.Items[len].Envelope := i;
    end
    else if SGetNote(Copy(s, 1, 3), i) then
    begin
      OnePat.Items[len].Envelope := round(GetNoteFreq(MainForm.Tone_Table_On_Load, i) / 16);
      s := ' ' + s;
    end
    else Exit;
    if DecNoise then
    begin
      if not SGetDecNumber(Copy(s, 6, 2), 31, i) then exit
    end
    else
      if not SGetNumber(Copy(s, 6, 2), 31, i) then exit;
    OnePat.Items[len].Noise := i;
    for i := 0 to 2 do
    begin
      if not SGetNote(Copy(s, 9 + i * 14, 3), j) then exit;
      OnePat.Items[len].Channel[i].Note := j;
      if not SGetNumber(Copy(s, 13 + i * 14, 1), 31, j) then exit;
      OnePat.Items[len].Channel[i].Sample := j;
      if not SGetNumber(Copy(s, 14 + i * 14, 1), 15, j) then exit;
      OnePat.Items[len].Channel[i].Envelope := j;
      if not SGetNumber(Copy(s, 15 + i * 14, 1), 15, j) then exit;
      OnePat.Items[len].Channel[i].Ornament := j;
      if not SGetNumber(Copy(s, 16 + i * 14, 1), 15, j) then exit;
      OnePat.Items[len].Channel[i].Volume := j;
      if not SGetNumber(Copy(s, 18 + i * 14, 1), 15, j) then exit;
      OnePat.Items[len].Channel[i].Additional_Command.Number := j;
      if not SGetNumber(Copy(s, 19 + i * 14, 1), 15, j) then exit;
      OnePat.Items[len].Channel[i].Additional_Command.Delay := j;
      if not SGetNumber(Copy(s, 20 + i * 14, 2), 255, j) then exit;
      OnePat.Items[len].Channel[i].Additional_Command.Parameter := j
    end;
    Result := True
  end;

begin
  Result := 0;
  len := 0;
  while GetString(s) do
  begin
    if s[1] = '[' then break;
    if not RecognizePatternString then
    begin
      Result := 6;
      exit
    end;
    Inc(len);
    if Len = MaxPatLen then break
  end;
  if len = 0 then
  begin
    Result := 6;
    exit
  end
  else
  begin
    TxtString := s;
    OnePat.Length := len;
    for len := len to MaxPatLen - 1 do
    begin
      OnePat.Items[len].Noise := 0;
      OnePat.Items[len].Envelope := 0;
      OnePat.Items[len].Channel[0] := EmptyChannelLine;
      OnePat.Items[len].Channel[1] := EmptyChannelLine;
      OnePat.Items[len].Channel[2] := EmptyChannelLine;
    end;
  end
end;

function LoadModuleFromText(FN: string; VTM1: PModule; var VTM2: PModule): integer;
var
  s, s1: string;
  i, j, er, lp: integer;
  Pat: PPattern;
  Orn: POrnament;
  Sam: PSample;
  re: TRegExpr;

  procedure LoadTxtMod(VTM: PModule);
  var
    ii, position: Integer;
    color: string;
    DecNoise: Boolean;
    PatternsFound, SamplesFound, OrnamentsFound: Boolean;
    List: TStringList;

  begin
    DecNoise := False;
    PatternsFound := False;
    SamplesFound := False;
    OrnamentsFound := False;
    VTM.ChipFreq := DefaultChipFreq;
    VTM.IntFreq := DefaultIntFreq;

    // Get track info
    List := TStringList.Create;
    try
      List.Loadfromfile(FN);
      if AnsiContainsText(List.text, '[Info]') then begin
        re := TRegExpr.Create;
        try
          re.ModifierM := True;
          re.ModifierI := True;
          re.ModifierS := True;
          re.Expression := '\[Info\](.*?)\[/Info\]';
          if re.Exec(List.text) then
            VTM.Info := Trim(re.Match[1]);
        finally
          re.Free;
        end;
      end;
    finally
      List.Free;
    end;

    while GetString(s) do
    begin
      if s[1] = '[' then break;
      i := Pos('=', s);
      if i < 2 then
      begin
        Result := 2;
        exit
      end;
      s1 := UpperCase(TrimRight(Copy(s, 1, i - 1)));
      if s1 = 'VORTEXTRACKERII' then
      begin
        if i = Length(s) then
          s1 := ''
        else
          s1 := TrimLeft(Copy(s, i + 1, Length(s) - i));
        if s1 = '' then
        begin
          Result := 2;
          exit
        end;
        VTM.VortexModule_Header := s1 <> '0'
      end
      else if s1 = 'VERSION' then
      begin
        if i = Length(s) then
          s1 := ''
        else
          s1 := TrimLeft(Copy(s, i + 1, Length(s) - i));
        if s1 = '' then
        begin
          Result := 2;
          exit
        end;
        if s1 = '3.5' then
          VTM.FeaturesLevel := 0
        else if s1 = '3.7' then
          VTM.FeaturesLevel := 2
        else
          VTM.FeaturesLevel := 1;
      end
      else if s1 = 'TITLE' then
      begin
        if i = Length(s) then
          s1 := ''
        else
          s1 := TrimLeft(Copy(s, i + 1, Length(s) - i));
        if Length(s1) > 32 then SetLength(s, 32);
        VTM.Title := s1
      end
      else if s1 = 'AUTHOR' then
      begin
        if i = Length(s) then
          s1 := ''
        else
          s1 := TrimLeft(Copy(s, i + 1, Length(s) - i));
        if Length(s1) > 32 then SetLength(s, 32);
        VTM.Author := s1
      end
       else if s1 = 'SHOWINFO' then
      begin
        if i = Length(s) then
          s1 := ''
        else
          s1 := TrimLeft(Copy(s, i + 1, Length(s) - i));
        VTM.ShowInfo := s1 = '1';
      end
      else if s1 = 'NOTETABLE' then
      begin
        if i = Length(s) then
          s1 := ''
        else
          s1 := TrimLeft(Copy(s, i + 1, Length(s) - i));
        Val(s1, i, er);
        if er <> 0 then
        begin
          Result := 2;
          exit
        end;
        if not (i in [0..4]) then
        begin
          Result := 3;
          exit
        end;
        VTM.Ton_Table := i;
        MainForm.Tone_Table_On_Load := VTM.Ton_Table;
      end
      else if s1 = 'CHIPFREQ' then
      begin
        if i = Length(s) then
          s1 := ''
        else
          s1 := TrimLeft(Copy(s, i + 1, Length(s) - i));
        if Length(s1) > 10 then SetLength(s, 10);
        VTM.ChipFreq := StrToInt(s1);
      end
      else if s1 = 'INTFREQ' then
      begin
        if i = Length(s) then
          s1 := ''
        else
          s1 := TrimLeft(Copy(s, i + 1, Length(s) - i));
        if Length(s1) > 10 then SetLength(s, 10);
        VTM.IntFreq := StrToInt(s1);
      end
      else if s1 = 'NOISE' then
      begin
        if i = Length(s) then
          s1 := ''
        else
          s1 := TrimLeft(Copy(s, i + 1, Length(s) - i));
        if UpperCase(s1) = 'DEC' then
          DecNoise := True;
      end
      else if s1 = 'SPEED' then
      begin
        if i = Length(s) then
          s1 := ''
        else
          s1 := TrimLeft(Copy(s, i + 1, Length(s) - i));
        Val(s1, i, er);
        if er <> 0 then
        begin
          Result := 2;
          exit
        end;
        if not (i in [1..255]) then
        begin
          Result := 3;
          exit
        end;
        VTM.Initial_Delay := i
      end
      else if s1 = 'PLAYORDER' then
      begin
        if i = Length(s) then
          s1 := ''
        else
          s1 := TrimLeft(Copy(s, i + 1, Length(s) - i));
        if s1 <> '' then
        begin
          VTM.Positions.Loop := 0;
          s1 := s1 + ',';
          repeat
            i := Pos(',', s1);
            if i < 2 then
            begin
              Result := 2;
              exit
            end;
            s := TrimRight(Copy(s1, 1, i - 1));
            Val(s, j, er);
            lp := 0;
            if er <> 0 then
              if (s <> '') and (UpperCase(s[1]) = 'L') then
              begin
                lp := 1;
                s[1] := ' ';
                Val(TrimLeft(s), j, er);
              end;
            if er <> 0 then
            begin
              Result := 2;
              exit
            end;
            if (not (j in [0..MaxPatNum])) or (VTM.Positions.Length > 255) then
            begin
              Result := 3;
              exit
            end;
            if lp <> 0 then VTM.Positions.Loop := VTM.Positions.Length;
            VTM.Positions.Value[VTM.Positions.Length] := j;
            inc(VTM.Positions.Length);
            if i = Length(s1) then break;
            s1 := TrimLeft(Copy(s1, i + 1, Length(s1) - i));
          until False;
        end;
      end
      else if s1 = 'COLORS' then
      begin
        if i = Length(s) then
          s1 := ''
        else
          s1 := TrimLeft(Copy(s, i + 1, Length(s) - i));
        if s1 <> '' then
        begin
          color := '';
          position := 0;
          ii := 1;
          while ii <= Length(s1) do
          begin
            if s1[ii] = ',' then
            begin
              VTM.Positions.Colors[position] := StrToInt(color);
              color := '';
              Inc(position);
            end
            else
              color := color + s1[ii];
            Inc(ii);
          end;
          if color <> '' then
            VTM.Positions.Colors[position] := StrToInt(color);
        end;
      end;
    end;
    TxtString := s;
    repeat
      if (Length(TxtString) > Length('[ORNAMENT')) and
        (UpperCase(Copy(TxtString, 1, Length('[ORNAMENT'))) = '[ORNAMENT') then
      begin
        s := Copy(TxtString, Length('[ORNAMENT') + 1, Length(TxtString) - Length('[ORNAMENT'));
        if s[Length(s)] <> ']' then
        begin
          Result := 2;
          exit
        end;
        s[Length(s)] := ' ';
        s := Trim(s);
        Val(s, i, er);
        if er <> 0 then
        begin
          Result := 2;
          exit
        end;
        if not (i in [1..15]) then
        begin
          Result := 3;
          exit
        end;
        if not GetString(s1) then
        begin
          Result := 4;
          exit
        end;
        New(Orn);
        if not RecognizeOrnamentString(s1, Orn) then
        begin
          Result := 2;
          Dispose(Orn);
          exit
        end;
        VTM.Ornaments[i] := Orn;
        OrnamentsFound := True;
        if not GetString(TxtString) then exit
      end
      else if (Length(TxtString) > Length('[SAMPLE')) and
        (UpperCase(Copy(TxtString, 1, Length('[SAMPLE'))) = '[SAMPLE') then
      begin
        s := Copy(TxtString, Length('[SAMPLE') + 1, Length(TxtString) - Length('[SAMPLE'));
        if s[Length(s)] <> ']' then
        begin
          Result := 2;
          exit
        end;
        s[Length(s)] := ' ';
        s := Trim(s);
        Val(s, i, er);
        if er <> 0 then
        begin
          Result := 2;
          exit
        end;
        if not (i in [1..31]) then
        begin
          Result := 3;
          exit
        end;
        New(Sam);
        s := LoadSampleDataTxt(Sam, DecNoise);
        if s <> '' then
        begin
          Dispose(Sam);
          Result := 5;
          exit;
        end;
        VTM.Samples[i] := Sam;
        SamplesFound := True;
      end
      else if (Length(TxtString) > Length('[PATTERN')) and
        (UpperCase(Copy(TxtString, 1, Length('[PATTERN'))) = '[PATTERN') then
      begin
        s := Copy(TxtString, Length('[PATTERN') + 1, Length(TxtString) - Length('[PATTERN'));
        if s[Length(s)] <> ']' then
        begin
          Result := 2;
          exit
        end;
        s[Length(s)] := ' ';
        s := Trim(s);
        Val(s, i, er);
        if er <> 0 then
        begin
          Result := 2;
          exit
        end;
        if not (i in [0..MaxPatNum]) then
        begin
          Result := 3;
          exit
        end;
        New(Pat);
        Result := LoadPatternDataTxt(Pat, DecNoise);
        if Result <> 0 then
        begin
          Dispose(Pat);
          exit;
        end;
        VTM.Patterns[i] := Pat;
        PatternsFound := True;
      end
      else if not GetString(TxtString) then break
    until (TxtString = '') or (UpperCase(TxtString) = '[MODULE]');

    if not PatternsFound  then Result := -1;
    if not SamplesFound   then Result := -2;
    if not OrnamentsFound then Result := -3;

  end;

begin
  Result := 0;
  AssignFile(TxtFile, FN);
  Reset(TxtFile);
  TxtLine := 0;
  VTM2 := nil;
  try
    if not GetString(s) or (UpperCase(s) <> '[MODULE]') then
    begin
      Result := 1;
      exit
    end;
    LoadTxtMod(VTM1);
    if (TxtString = '') or (Result <> 0) then exit;
    NewVTMP(VTM2);
    LoadTxtMod(VTM2);
    if Result <> 0 then FreeVTMP(VTM2);
  finally
    CloseFile(TxtFile);
  end;
end;

function PT32VTM(PT3: PSpeccyModule; FSize: Integer; VTM1: PModule; var VTM2: PModule): boolean;
var
  ChPtr: packed array[0..2] of word;
  Skip: array[0..2] of byte;
  SkipCounter: array[0..2] of byte;
  PrevOrn: array[0..2] of byte;
  NsBase: integer;
  TS: integer;

  procedure PatternInterpreter(VTM: PModule; PatNum, LnNum, ChNum: integer);
  var
    quit: boolean;
    tmp: smallint;
  begin
    quit := False;
    repeat
      case PT3.Index[ChPtr[ChNum]] of
        $F0..$FF: begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            PrevOrn[ChNum] := PT3.Index[ChPtr[ChNum]] - $F0;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament :=
              PrevOrn[ChNum];
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample :=
              PT3.Index[ChPtr[ChNum]] div 2
          end;
        $D1..$EF:
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample :=
            PT3.Index[ChPtr[ChNum]] - $D0;
        $D0: begin
            quit := true;
          end;
        $C1..$CF: VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := PT3.Index[ChPtr[ChNum]] - $C0;
        $C0: begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
            quit := true;
          end;
        $B2..$BF: begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := PT3.Index[ChPtr[ChNum]] - $B1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := PrevOrn[ChNum];
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Envelope := word(PT3.Index[ChPtr[ChNum]]) shl 8;
            Inc(ChPtr[ChNum]);
            Inc(VTM.Patterns[PatNum].Items[LnNum].Envelope, PT3.Index[ChPtr[ChNum]])
          end;
        $B1: begin
            inc(ChPtr[ChNum]);
            Skip[ChNum] := PT3.Index[ChPtr[ChNum]];
          end;
        $B0: begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := PrevOrn[ChNum]
          end;
        $50..$AF: begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note :=
              PT3.Index[ChPtr[ChNum]] - $50;
            quit := True;
          end;
        $40..$4F:
          begin
            if PT3.Index[ChPtr[ChNum]] = $40 then //  only for Orn #0 rom pt3.69
              if VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope = 0 then
                VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            PrevOrn[ChNum] := PT3.Index[ChPtr[ChNum]] - $40;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := PrevOrn[ChNum]
          end;
        $20..$3F: NsBase := PT3.Index[ChPtr[ChNum]] - $20;
        $10..$1F: begin
            if PT3.Index[ChPtr[ChNum]] = $10 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15
            else
            begin
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := PT3.Index[ChPtr[ChNum]] - $10;
              inc(ChPtr[ChNum]);
              VTM.Patterns[PatNum].Items[LnNum].Envelope := word(PT3.Index[ChPtr[ChNum]]) shl 8;
              inc(ChPtr[ChNum]);
              inc(VTM.Patterns[PatNum].Items[LnNum].Envelope, PT3.Index[ChPtr[ChNum]]);
            end;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := PrevOrn[ChNum];
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample :=
              PT3.Index[ChPtr[ChNum]] div 2;
          end;
        $8..$9: VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Number := PT3.Index[ChPtr[ChNum]];
        $1..$5: VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Number := PT3.Index[ChPtr[ChNum]];
      end;
      inc(ChPtr[ChNum]);
    until quit;
    case VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Number of
      1: begin
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Delay := PT3.Index[ChPtr[ChNum]];
          inc(ChPtr[ChNum]);
          move(PT3.Index[ChPtr[ChNum]], Tmp, 2);
          if Tmp < 0 then
          begin
            inc(VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Number);
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Parameter := -Tmp;
          end
          else
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Parameter := Tmp;
          inc(ChPtr[ChNum], 2);
        end;
      2: begin
          inc(VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Number);
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Delay := PT3.Index[ChPtr[ChNum]];
          inc(ChPtr[ChNum], 3);
          move(PT3.Index[ChPtr[ChNum]], Tmp, 2);
          if Tmp < 0 then
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Parameter := -Tmp
          else
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Parameter := Tmp;
          inc(ChPtr[ChNum], 2);
        end;
      3, 4: begin
          inc(VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Number);
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Parameter := PT3.Index[ChPtr[ChNum]];
          inc(ChPtr[ChNum]);
        end;
      5: begin
          inc(VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Number);
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Parameter :=
            PT3.Index[ChPtr[ChNum]] shl 4;
          inc(ChPtr[ChNum]);
          inc(VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Parameter,
            PT3.Index[ChPtr[ChNum]]);
          inc(ChPtr[ChNum]);
        end;
      8: begin
          inc(VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Number);
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Delay := PT3.Index[ChPtr[ChNum]];
          inc(ChPtr[ChNum]);
          move(PT3.Index[ChPtr[ChNum]], Tmp, 2);
          if Tmp < 0 then
          begin
            inc(VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Number);
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Parameter := -Tmp;
          end
          else
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Parameter := Tmp;
          inc(ChPtr[ChNum], 2);
        end;
      9: begin
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Number := $B;
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Additional_Command.Parameter := PT3.Index[ChPtr[ChNum]];
          inc(ChPtr[ChNum]);
        end;
    end;
    SkipCounter[ChNum] := Skip[ChNum]
  end;

  procedure DecodePattern(VTM: PModule; j, jj: integer);
  var
    i, k: integer;
    quit: boolean;
  begin
    if VTM.Patterns[j] = nil then
    begin
      NewPattern(VTM.Patterns[j]);
      for k := 0 to 2 do
      begin
        PrevOrn[k] := 0;
        SkipCounter[k] := 1;
        Skip[k] := 1
      end;
      move(PT3.Index[PT3.PT3_PatternsPointer + jj * 6], ChPtr, 6);
      NsBase := 0; i := 0; quit := False;
      while (i < MaxPatLen) and not quit do
      begin
        for k := 0 to 2 do
        begin
          dec(SkipCounter[k]);
          if SkipCounter[k] = 0 then
          begin
            if (k = 0) and (PT3.Index[ChPtr[0]] = 0) then
            begin
              Dec(i);
              quit := True;
              break
            end;
            PatternInterpreter(VTM, j, i, k)
          end
        end;
        if i >= 0 then
          VTM.Patterns[j].Items[i].Noise := NsBase;
        inc(i);
      end;
      VTM.Patterns[j].Length := i;
    end;
  end;

  function FoundPT36TS: boolean;
  var
    j1, j2, k, Pos: Integer;
  begin
    Result := False;
    if PT3.PT3_Name[13] <> '6' then exit;
    Pos := 0;
    while (Pos < 256) and (PT3.Index[Pos + $C9] <> 255) do
    begin
      j1 := PT3.Index[Pos + $C9] div 3;
      if j1 < $30 / 2 then exit;
      j2 := $30 - j1 - 1;
      move(PT3.Index[PT3.PT3_PatternsPointer + j2 * 6], ChPtr, 6);
      for k := 0 to 2 do
        if (ChPtr[k] < 100) or (ChPtr[k] >= FSize - 4) then exit;
      Inc(Pos);
    end;
    if MessageDlg('This PT 3.6 module may contain Turbo Sound data. Try to import?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then exit;
    TS := $30;
    Result := True;
  end;

var
  i, j, k, kk, Pos: Integer;
  tset: boolean;
begin
  Result := True;
  if DetectFeaturesLevel then
  begin
    if StrLComp(@PT3.PT3_Name, 'ProTracker 3.', 13) = 0 then
      case Ord(PT3.PT3_Name[13]) of
        $30..$35: VTM1.FeaturesLevel := 0;
        $37..$39: VTM1.FeaturesLevel := 2;
      else VTM1.FeaturesLevel := 1;
      end
    else if StrLComp(@PT3.PT3_Name, 'Vortex Tracker II', 17) = 0 then
      VTM1.FeaturesLevel := 1
    else
      VTM1.FeaturesLevel := 0;
  end;
  if DetectModuleHeader then
    VTM1.VortexModule_Header := StrLComp(@PT3.PT3_Name, 'ProTracker 3.', 13) <> 0;
  SetLength(VTM1.Title, 32);
  Move(PT3.PT3_Name[$1E], VTM1.Title[1], 32);
  VTM1.Title := TrimRight(VTM1.Title);
  SetLength(VTM1.Author, 32);
  Move(PT3.PT3_Name[$42], VTM1.Author[1], 32);
  VTM1.Author := TrimRight(VTM1.Author);
  VTM1.Ton_Table := PT3.PT3_Table;
  VTM1.Initial_Delay := PT3.PT3_Delay;
  VTM1.Positions.Loop := PT3.PT3_LoopPosition;
  for i := 0 to 255 do
    VTM1.Positions.Value[i] := 0;
  VTM1.Ornaments[0] := nil;
  for i := 1 to 15 do
  begin
    if PT3.PT3_OrnamentPointers[i] = 0 then
      VTM1.Ornaments[i] := nil
    else
    begin
      New(VTM1.Ornaments[i]);
      VTM1.Ornaments[i].Loop := PT3.Index[PT3.PT3_OrnamentPointers[i]];
      VTM1.Ornaments[i].Length := PT3.Index[PT3.PT3_OrnamentPointers[i] + 1];
      for j := 0 to VTM1.Ornaments[i].Length - 1 do
        VTM1.Ornaments[i].Items[j] := PT3.Index[PT3.PT3_OrnamentPointers[i] + 2 + j];
    end;
  end;

  for i := 1 to 31 do
  begin
    if PT3.PT3_SamplePointers[i] = 0 then
      VTM1.Samples[i] := nil
    else
    begin

      if (PT3.Index[PT3.PT3_SamplePointers[i]] > MaxSamLen-1) or (PT3.Index[PT3.PT3_SamplePointers[i] + 1] > MaxSamLen) then
        Continue;

      New(VTM1.Samples[i]);
      VTM1.Samples[i].Loop := PT3.Index[PT3.PT3_SamplePointers[i]];
      VTM1.Samples[i].Length := PT3.Index[PT3.PT3_SamplePointers[i] + 1];
      for j := 0 to VTM1.Samples[i].Length - 1 do
      begin
        VTM1.Samples[i].Items[j].Add_to_Ton :=
          WordPtr(@PT3.Index[PT3.PT3_SamplePointers[i] + j * 4 + 4])^;
        VTM1.Samples[i].Items[j].Ton_Accumulation :=
          PT3.Index[PT3.PT3_SamplePointers[i] + j * 4 + 3] and $40 <> 0;
        VTM1.Samples[i].Items[j].Amplitude :=
          PT3.Index[PT3.PT3_SamplePointers[i] + j * 4 + 3] and $F;
        VTM1.Samples[i].Items[j].Amplitude_Sliding :=
          PT3.Index[PT3.PT3_SamplePointers[i] + j * 4 + 2] and $80 <> 0;
        VTM1.Samples[i].Items[j].Amplitude_Slide_Up :=
          PT3.Index[PT3.PT3_SamplePointers[i] + j * 4 + 2] and $40 <> 0;
        VTM1.Samples[i].Items[j].Envelope_Enabled :=
          PT3.Index[PT3.PT3_SamplePointers[i] + j * 4 + 2] and 1 = 0;
        VTM1.Samples[i].Items[j].Envelope_or_Noise_Accumulation :=
          PT3.Index[PT3.PT3_SamplePointers[i] + j * 4 + 3] and $20 <> 0;
        VTM1.Samples[i].Items[j].Add_to_Envelope_or_Noise :=
          PT3.Index[PT3.PT3_SamplePointers[i] + j * 4 + 2] shr 1;
        if VTM1.Samples[i].Items[j].Add_to_Envelope_or_Noise and $10 <> 0 then
          VTM1.Samples[i].Items[j].Add_to_Envelope_or_Noise :=
            VTM1.Samples[i].Items[j].Add_to_Envelope_or_Noise or shortint($F0)
        else
          VTM1.Samples[i].Items[j].Add_to_Envelope_or_Noise :=
            VTM1.Samples[i].Items[j].Add_to_Envelope_or_Noise and 15;
        VTM1.Samples[i].Items[j].Mixer_Ton :=
          PT3.Index[PT3.PT3_SamplePointers[i] + j * 4 + 3] and $10 = 0;
        VTM1.Samples[i].Items[j].Mixer_Noise :=
          PT3.Index[PT3.PT3_SamplePointers[i] + j * 4 + 3] and $80 = 0
      end
    end
  end;

  for i := 0 to MaxPatNum do
    VTM1.Patterns[i] := nil;

  VTM2 := nil; TS := Byte(PT3.PT3_Name[98]);
  if ((TS <> $20) and (PT3.PT3_Name[13] in ['7'..'9'])) or FoundPT36TS then
  begin
    New(VTM2);
    VTM2^ := VTM1^;
    New(VTM2.Patterns[-1]);
    VTM2.Patterns[-1]^ := VTM1.Patterns[-1]^;
    for i := 1 to 15 do
      if VTM1.Ornaments[i] <> nil then
      begin
        New(VTM2.Ornaments[i]);
        VTM2.Ornaments[i]^ := VTM1.Ornaments[i]^;
      end;
    for i := 1 to 31 do
      if VTM1.Samples[i] <> nil then
      begin
        New(VTM2.Samples[i]);
        VTM2.Samples[i]^ := VTM1.Samples[i]^;
      end;
  end;

  Pos := 0;
  while (Pos < 256) and (PT3.Index[Pos + $C9] <> 255) do
  begin
    j := PT3.Index[Pos + $C9] div 3;
    if VTM2 <> nil then
    begin
      j := TS - j - 1;
      VTM2.Positions.Value[Pos] := j;
    end;
    VTM1.Positions.Value[Pos] := j;

    Inc(Pos);

    if VTM2 <> nil then
    begin
      DecodePattern(VTM2, j, j);
      DecodePattern(VTM1, j, TS - j - 1);
      for i := 0 to MaxPatLen - 1 do
      begin
        tset := False;
        for k := 2 downto 0 do
          if VTM2.Patterns[j].Items[i].Channel[k].Additional_Command.Number = 11 then
          begin
            for kk := 2 downto 0 do
              if VTM1.Patterns[j].Items[i].Channel[kk].Additional_Command.Number in [0, 11] then
              begin
                VTM1.Patterns[j].Items[i].Channel[kk].Additional_Command :=
                  VTM2.Patterns[j].Items[i].Channel[k].Additional_Command;
                break;
              end;
            tset := True;
            break;
          end;
        if not tset then
          for k := 2 downto 0 do
            if VTM1.Patterns[j].Items[i].Channel[k].Additional_Command.Number = 11 then
            begin
              for kk := 2 downto 0 do
                if VTM2.Patterns[j].Items[i].Channel[kk].Additional_Command.Number = 0 then
                begin
                  VTM2.Patterns[j].Items[i].Channel[kk].Additional_Command :=
                    VTM1.Patterns[j].Items[i].Channel[k].Additional_Command;
                  break;
                end;
              break;
            end;
      end;
    end
    else
      DecodePattern(VTM1, j, j);
  end;
  VTM1.Positions.Length := Pos;
  if VTM2 <> nil then
    VTM2.Positions.Length := Pos;
end;

function GetSampleString(SL: TSampleTick; Vol, Ns: boolean): string;
var
  j: integer;
begin
  {Result := Char(Ord('T') or (Ord(not SL.Mixer_Ton) shl 5));
  Result := Result + Char(Ord('N') or (Ord(not SL.Mixer_Noise) shl 5));
  Result := Result + Char(Ord('E') or (Ord(not SL.Envelope_Enabled) shl 5)) + ' '; }

  if SL.Mixer_Ton then
    Result := 'T'
  else
    Result := '.';
  if SL.Mixer_Noise then
    Result := Result + 'N'
  else
    Result := Result + '.';
  if SL.Envelope_Enabled then
    Result := Result + 'E'
  else
    Result := Result + '.';
  Result := Result + ' ';


  if SL.Add_to_Ton >= 0 then
    Result := Result + '+' + IntToHex(SL.Add_to_Ton, 3)
  else
    Result := Result + '-' + IntToHex(-SL.Add_to_Ton, 3);


  if SL.Ton_Accumulation then
    Result := Result + '^ '
  else
    Result := Result + '_ ';


  if SL.Add_to_Envelope_or_Noise >= 0 then
      Result := Result + '+' + IntToHex(SL.Add_to_Envelope_or_Noise, 2)
  else
      Result := Result + '-' + IntToHex(-SL.Add_to_Envelope_or_Noise, 2);
  if Ns then
      Result := Result + '(' +
        IntToHex(SL.Add_to_Envelope_or_Noise and 31, 2) + ')';


  if SL.Envelope_or_Noise_Accumulation then
    Result := Result + '^ '
  else
    Result := Result + '_ ';

  Result := Result + IntToHex(SL.Amplitude, 1);

  if not SL.Amplitude_Sliding then
    Result := Result + '_'
  else if SL.Amplitude_Slide_Up then
    Result := Result + '+'
  else
    Result := Result + '-';

  if Vol then
  begin
    Result := Result + '+';
    for j := 1 to 15 do
      if j <= SL.Amplitude then
        Result := Result + Chr(149)  // 149
      else
        Result := Result + ' '
  end
end;

function GetSampleStringForRedraw;
begin

  if SL.Mixer_Ton then
    Result := 'T'
  else
    Result := '.';
  if SL.Mixer_Noise then
    Result := Result + 'N'
  else
    Result := Result + '.';
  if SL.Envelope_Enabled then
    Result := Result + 'E'
  else
    Result := Result + '.';
  Result := Result + ' ';


  if SL.Add_to_Ton >= 0 then
    Result := Result + '+' + IntToHex(SL.Add_to_Ton, 3)
  else
    Result := Result + '-' + IntToHex(-SL.Add_to_Ton, 3);


  if SL.Ton_Accumulation then
    Result := Result + '  '
  else
    Result := Result + '. ';


  if SL.Add_to_Envelope_or_Noise >= 0 then
    if DecBaseNoiseOn then
      Result := Result + '+' + Format('%.2d', [SL.Add_to_Envelope_or_Noise])
    else
      Result := Result + '+' + IntToHex(SL.Add_to_Envelope_or_Noise, 2)
  else
    if DecBaseNoiseOn then
      Result := Result + '-' + Format('%.2d', [-SL.Add_to_Envelope_or_Noise])
    else
      Result := Result + '-' + IntToHex(-SL.Add_to_Envelope_or_Noise, 2);

    if DecBaseNoiseOn then
      Result := Result + '(' +
        Format('%.2d', [SL.Add_to_Envelope_or_Noise and 31]) + ')'
    else
      Result := Result + '(' +
        IntToHex(SL.Add_to_Envelope_or_Noise and 31, 2) + ')';


  if SL.Envelope_or_Noise_Accumulation then
    Result := Result + '  '
  else
    Result := Result + '. ';

  Result := Result + IntToHex(SL.Amplitude, 1);

  if not SL.Amplitude_Sliding then
    Result := Result + '.'
  else
    Result := Result + ' ';

  Result := Result + StringOfChar(' ', 16);

end;

procedure SaveSample;
var
  lp, l, i: integer;
begin
  if VTMP.Samples[n] = nil then
    Writeln(TxtFile, '... +000_ +00_ 0_ L')
  else
    with VTMP.Samples[n]^ do
    begin
      lp := Loop;
      l := Length - 1;
      for i := 0 to l do
      begin
        Write(TxtFile, GetSampleString(Items[i], False, False));
        if i = lp then Write(TxtFile, ' L');
        Writeln(TxtFile)
      end
    end
end;

procedure SaveOrnament;
var
  lp, l, i: integer;
begin
  if VTM.Ornaments[n] = nil then
    Writeln(TxtFile, 'L0')
  else
    with VTM.Ornaments[n]^ do
    begin
      lp := Loop;
      l := Length - 1;
      for i := 0 to l do
      begin
        if i = lp then Write(TxtFile, 'L');
        Write(TxtFile, IntToStr(Items[i]));
        if i < l then Write(TxtFile, ',')
      end;
      Writeln(TxtFile)
    end
end;

function Int2ToStr(i: integer): string;
begin
  if i < 10 then
    Result := '0' + IntToStr(i)
  else
    Result := IntToStr(i)
end;

function Int4DToStr(i: integer): string;
begin
  if i = 0 then
    Result := '....'
  else if i < 16 then
    Result := '...' + IntToHex(i, 1)
  else if i < 256 then
    Result := '..' + IntToHex(i, 2)
  else if i < $1000 then
    Result := '.' + IntToHex(i, 3)
  else
    Result := IntToHex(i, 4)
end;

function Int2DToStr(i: integer): string;
begin
  if i = 0 then
    Result := '..'
  else if i < 16 then
    Result := '.' + IntToHex(i, 1)
  else
    Result := IntToHex(i, 2)
end;

function Int2DToDecStr(i: integer): string;
begin
  if i = 0 then
    Result := '..'
  else if i < 10 then
    Result := '.' + IntToStr(i)
  else
    Result := IntToStr(i)
end;

function Int1DToStr(i: integer): string;
begin
  if i = 0 then
    Result := '.'
  else
    Result := IntToHex(i, 1)
end;


function NoteToStr(i: integer): string;
var Octave: Integer;
begin

  if i = -1 then
    Result := '---'
  else if i = -2 then
    Result := 'R--'
  else begin
    Octave := i div 12 + 1;
    if Octave < 1 then
      Result := 'C-1'
    else if Octave > 8 then
      Result := 'B-8'
    else
      Result := Notes[Abs(i) mod 12] + IntToStr(Octave);
  end;
  
end;


function NoteToStr2(i: integer): string;
begin
  if i = -1 then
    Result := '---'
  else if i = -2 then
    Result := 'R--'
  else
    Result := Notes[i mod 12] + IntToStr(i div 12 + 1)
end;


function SampToStr(i: integer): string;
begin
  if i = 0 then
    Result := '.'
  else if i < 16 then
    Result := IntToHex(i, 1)
  else
    Result := Char(i + Ord('A') - 10)
end;

function IntsToTime(i: integer): string;
var
  sec, min: integer;
begin
  if i = 0 then begin
    Result := '0:04';
    Exit;
  end;
  sec := round(i * 1000 / Interrupt_Freq);
  min := sec div 60;
  sec := sec mod 60;
  Result := IntToStr(min) + ':' + Int2ToStr(sec)
end;



function GetOutPatternLineString;
var IsEmpty: Boolean;
begin

  IsEmpty := False;
  if Previous and ((PatNum < 0) or (PatPtr.Length - LineNum < 0)) then
    IsEmpty := True;

  if not Previous and ((PatNum < 0) or (LineNum > PatPtr.Length - 1)) then
    IsEmpty := True;

  if IsEmpty then
    if DecBaseLinesOn then
      Result := StringOfChar(' ', 53)
    else
      Result := StringOfChar(' ', 52)
  else
    if Previous then
      Result := GetPatternLineString(PatPtr, PatPtr.Length - LineNum, Chn, False, False)
    else
      Result := GetPatternLineString(PatPtr, LineNum, Chn, False, False);
end;


function GetPatternLineString(PatPtr: PPattern; Line: integer; Chn: TChansArray;
         LineNums, Separators: Boolean): string;
         
  function Envelope2NoteText(e: Integer): string;
  var
    note: Integer;
  begin
    Result := Int4DToStr(e);
    if (EnvelopeAsNote = False) or (e=0) then Exit;

    note := GetNoteByEnvelope(e);
    if (note >= 0) and (note <= 60) then
      Result := ' ' + NoteToStr(note);
  end;
var
  j1, Chan: integer;
  sep: string;
begin

  if Separators then
      sep := '|'
    else
      sep := ' ';

  if LineNums then
    if DecBaseLinesOn then
      Result := Format('%.3d', [Line]) + sep
    else
      Result := IntToHex(Line, 2) + sep
  else
    if DecBaseLinesOn then
      Result := '   ' + sep
    else
      Result := '  ' + sep;

  if PatPtr = nil then
    if DisableSeparators then
      Result := Result + '.... .. --- .... .... --- .... .... --- .... ....'
    else
      Result := Result + '....|..|--- .... ....|--- .... ....|--- .... ....'
  else
  begin
    Result := Result + Envelope2NoteText(PatPtr.Items[Line].Envelope) + sep;

    if DecBaseNoiseOn then
      Result := Result + Int2DToDecStr(PatPtr.Items[Line].Noise)
    else
      Result := Result + Int2DToStr(PatPtr.Items[Line].Noise);

    for j1 := 0 to 2 do
    begin
      Chan := Chn[j1];
      Result := Result + sep + NoteToStr(PatPtr.Items[Line].Channel[Chan].Note) + ' ';
      Result := Result + SampToStr(PatPtr.Items[Line].Channel[Chan].Sample);
      Result := Result + Int1DToStr(PatPtr.Items[Line].Channel[Chan].Envelope);
      Result := Result + Int1DToStr(PatPtr.Items[Line].Channel[Chan].Ornament);
      Result := Result + Int1DToStr(PatPtr.Items[Line].Channel[Chan].Volume) + ' ';
      Result := Result + Int1DToStr(PatPtr.Items[Line].Channel[Chan].Additional_Command.Number);
      Result := Result + Int1DToStr(PatPtr.Items[Line].Channel[Chan].Additional_Command.Delay);
      Result := Result + Int2DToStr(PatPtr.Items[Line].Channel[Chan].Additional_Command.Parameter)
    end
  end;
end;

procedure SavePattern;
var
  s: string;
  i, l: integer;
  Flag1, Flag2: Boolean;
begin
  Flag1 := EnvelopeAsNote;
  Flag2 := DecBaseNoiseOn;
  EnvelopeAsNote := False;
  DecBaseNoiseOn := False;

  l := DefPatLen;
  if VTMP.Patterns[n] <> nil then
    l := VTMP.Patterns[n].Length;
  for i := 0 to l - 1 do
  begin
    s := GetPatternLineString(VTMP.Patterns[n], i, StdChns, True, True);
    Writeln(TxtFile, Copy(s, TracksCursorXLeft+1, Length(s) - TracksCursorXLeft));
  end;

  EnvelopeAsNote := Flag1;
  DecBaseNoiseOn := Flag2;
end;

procedure VTM2TextFile(FileName: string; VTM: PModule; Apnd: boolean);
var
  i, j: integer;
  colors: string;
  Flag1, Flag2: Boolean;
begin
  j := 0;
  AssignFile(TxtFile, FileName);
  if not Apnd then
    Rewrite(TxtFile)
  else
    Append(TxtFile);

  Flag1 := DecBaseNoiseOn;
  DecBaseNoiseOn := False;

  Flag2 := EnvelopeAsNote;
  EnvelopeAsNote := False;

  try
    Writeln(TxtFile, '[Module]');
    if VTM.VortexModule_Header then
      Writeln(TxtFile, 'VortexTrackerII=1')
    else
      Writeln(TxtFile, 'VortexTrackerII=0');
    Writeln(TxtFile, 'Version=3.' + IntToStr(5 + VTM.FeaturesLevel));
    Writeln(TxtFile, 'Title=' + VTM.Title);
    Writeln(TxtFile, 'Author=' + VTM.Author);
    if not Apnd then
      Writeln(TxtFile, 'ShowInfo=' + IntToStr(Ord(VTM.ShowInfo)));
    Writeln(TxtFile, 'NoteTable=' + IntToStr(VTM.Ton_Table));
    Writeln(TxtFile, 'ChipFreq=' + IntToStr(VTM.ChipFreq));
    Writeln(TxtFile, 'IntFreq=' + IntToStr(VTM.IntFreq));
    Writeln(TxtFile, 'Speed=' + IntToStr(VTM.Initial_Delay));
    Writeln(TxtFile, 'Noise=HEX');
    Write(TxtFile, 'PlayOrder=');
    with VTM.Positions do
      for i := 0 to Length - 1 do
      begin
        if i = Loop then Write(TxtFile, 'L');
        Write(TxtFile, Value[i]);
        if i <> Length - 1 then Write(TxtFile, ',');
      end;

    Writeln(TxtFile);

    if MaxIntValue(VTM.Positions.Colors) <> 0 then
    begin
      colors := '';
      for i := 0 to VTM.Positions.Length - 2 do
      begin
        colors := colors + IntToStr(VTM.Positions.Colors[i]) + ',';
        j := i;
      end;
      colors := colors + IntToStr(VTM.Positions.Colors[j]);
      Writeln(TxtFile, 'Colors=' + colors);
    end;

    Writeln(TxtFile);
    Writeln(TxtFile);

    for i := 1 to 15 do
    begin
      Writeln(TxtFile, '[Ornament' + IntToStr(i) + ']');
      SaveOrnament(VTM, i);
      Writeln(TxtFile);
    end;

    for i := 1 to 31 do
    begin
      Writeln(TxtFile, '[Sample' + IntToStr(i) + ']');
      SaveSample(VTM, i);
      Writeln(TxtFile);
    end;

    for i := 0 to MaxPatNum do
      if VTM.Patterns[i] <> nil then
      begin
        Writeln(TxtFile, '[Pattern' + IntToStr(i) + ']');
        SavePattern(VTM, i);
        Writeln(TxtFile);
      end;

    if (Trim(VTM.Info) <> '') and not Apnd then begin
      Writeln(TxtFile, '[Info]');
      Writeln(TxtFile, VTM.Info);
      Writeln(TxtFile, '[/Info]');
      Writeln(TxtFile);
      Writeln(TxtFile);
    end;

    {colors := MainForm.GetPositionsColors;
    if colors <> '' then
    begin
      Writeln(TxtFile, '[Colors]');
      Writeln(TxtFile, colors);
    end; }

  finally
    CloseFile(TxtFile);
  end;

  DecBaseNoiseOn := Flag1;
  EnvelopeAsNote := Flag2;
end;

function VTM2PT3(PT3: PSpeccyModule; VTM: PModule;
  var Module_Size: Integer): boolean;
const
  Pt3Id: array[Boolean, 0..29] of char =
  ('ProTracker 3.6 compilation of ',
    'Vortex Tracker II 1.0 module: ');
  ById: array[0..3] of char = ' by ';
  EmptyPatternString = #$B1#64#$D0#0;
var
  i, i1, j, k, d: integer;
  Patterns: array[0..MaxPatNum] of boolean;
  CompiledPatterns: array[0..MaxPatNum] of boolean;
  VTMPat2PT3Pat: array[0..MaxPatNum] of integer;
  PatOfs: array[0..MaxNumOfPats * 3 - 1] of integer;
  MaxPattern: integer;
  PatStrs: array[0..MaxNumOfPats * 3 - 1] of string;
  PatsIndexes: array[0..MaxPatNum, 0..2] of integer;
  PatNum, StrNum: integer;
  DeltT, TnStp, TnDl, TnCurDl, //<--- vars to avoid bug in Alone Coder's PT3 player
    Note,
    Sample,
    Ornament,
    Volume,
    SkipPrev,
    Skip,
    Envelope: array[0..2] of integer;
  Orn, Sam, Orn1, Sam1: boolean;
  PrevNoise, Dl: integer;
  IsOrnament: array[0..15] of boolean;
  IsSample: array[1..31] of boolean;
begin
  Result := False;

  Move(Pt3Id[VTM.VortexModule_Header and (VTM.FeaturesLevel = 1), 0], PT3.PT3_Name, 30);
  if VTM.FeaturesLevel <> 1 then PT3.PT3_Name[13] := Char($35 + VTM.FeaturesLevel);

  i := 32; if i > Length(VTM.Title) then i := Length(VTM.Title);
  Move(VTM.Title[1], PT3.PT3_Name[30], i);
  j := 32 - i; if j <> 0 then FillChar(PT3.PT3_Name[30 + i], j, 32);

  Move(ById, PT3.PT3_Name[62], 4);

  i := 32; if i > Length(VTM.Author) then i := Length(VTM.Author);
  Move(VTM.Author[1], PT3.PT3_Name[66], i);
  FillChar(PT3.PT3_Name[66 + i], 32 - i + 1, 32);

  PT3.PT3_Table := VTM.Ton_Table;

  PT3.PT3_Delay := VTM.Initial_Delay;

  PT3.PT3_NumberOfPositions := VTM.Positions.Length;

  PT3.PT3_LoopPosition := VTM.Positions.Loop;

  PT3.PT3_PatternsPointer := $C9 + PT3.PT3_NumberOfPositions + 1;

  FillChar(PT3.PT3_SamplePointers, 96, 0);

  PT3.Index[$C9 + PT3.PT3_NumberOfPositions] := 255;

  for i := 0 to MaxPatNum do
  begin
    Patterns[i] := False;
    CompiledPatterns[i] := False
  end;
  MaxPattern := 0;
  for i := 0 to PT3.PT3_NumberOfPositions - 1 do
  begin
    if MaxPattern < VTM.Positions.Value[i] then
      MaxPattern := VTM.Positions.Value[i];
    Patterns[VTM.Positions.Value[i]] := True;
    VTMPat2PT3Pat[VTM.Positions.Value[i]] := VTM.Positions.Value[i]
  end;
  for i := 0 to MaxPattern do
    if not Patterns[i] then
      for j := i + 1 to MaxPattern do Dec(VTMPat2PT3Pat[j]);

  for i := 0 to PT3.PT3_NumberOfPositions - 1 do
    PT3.Index[$C9 + i] := VTMPat2PT3Pat[VTM.Positions.Value[i]] * 3;

  for i := 0 to 15 do IsOrnament[i] := False;
  for i := 1 to 31 do IsSample[i] := False;

  StrNum := 0;

  Note[0] := 0;
  Note[1] := 0;
  Note[2] := 0;

//BUG in AlCo's pt3 player
  DeltT[0] := 0; //
  DeltT[1] := 0; //
  DeltT[2] := 0; // this all for more compatability with old ZX players
  TnDl[0] := 0; //
  TnDl[1] := 0; //
  TnDl[2] := 0; //
//BUG in AlCo's pt3 player

  for i1 := 0 to PT3.PT3_NumberOfPositions - 1 do
  begin
    i := VTM.Positions.Value[i1];
    PatNum := VTMPat2PT3Pat[i];
    if not CompiledPatterns[i] then
    begin
      CompiledPatterns[i] := True;
      if VTM.Patterns[i] <> nil then
      begin
        PrevNoise := 0;
        for k := 0 to 2 do
        begin
          Dl := DeltT[k];
          Sample[k] := -1;
          Ornament[k] := -1;
          Envelope[k] := -1;
          Volume[k] := -1;
          SkipPrev[k] := 255;
          PatStrs[StrNum] := '';
          j := 0;
          while j < VTM.Patterns[i].Length do
          begin

            Orn := ((VTM.Patterns[i].Items[j].Channel[k].Envelope <> 0) or
              (VTM.Patterns[i].Items[j].Channel[k].Ornament <> 0) {new standard in pt3.69}) and
              ((VTM.Patterns[i].Items[j].Channel[k].Ornament <> Ornament[k]) or
              ((Ornament[k] <> 0) and (VTM.Patterns[i].Items[j].Channel[k].Note = -1)));
            if Orn then
              IsOrnament[VTM.Patterns[i].Items[j].Channel[k].Ornament] := True;
            Sam := (VTM.Patterns[i].Items[j].Channel[k].Note <> -1) and
              (VTM.Patterns[i].Items[j].Channel[k].Sample <> 0) and
              (VTM.Patterns[i].Items[j].Channel[k].Sample <> Sample[k]);
            if Sam then
            begin
              IsSample[VTM.Patterns[i].Items[j].Channel[k].Sample] := True;
              Sample[k] := VTM.Patterns[i].Items[j].Channel[k].Sample
            end;

            Orn1 := Orn;
            Sam1 := Sam;
            if Sam and Orn and (VTM.Patterns[i].Items[j].Channel[k].Envelope <> 0) then //new standard in pt3.69then
            begin
              if VTM.Patterns[i].Items[j].Channel[k].Envelope = 15 then
              begin
                if Envelope[k] <> 0 then
                begin
                  Sam1 := False;
                  Orn1 := False;
                  PatStrs[StrNum] := PatStrs[StrNum] +
                    char($F0 + VTM.Patterns[i].Items[j].Channel[k].Ornament) +
                    char(VTM.Patterns[i].Items[j].Channel[k].Sample * 2)
                end
              end
              else
              begin
                Sam1 := False;
                Orn1 := False;
                PatStrs[StrNum] := PatStrs[StrNum] + char($10 +
                  VTM.Patterns[i].Items[j].Channel[k].Envelope) +
                  char(Hi(VTM.Patterns[i].Items[j].Envelope)) +
                  char(VTM.Patterns[i].Items[j].Envelope) +
                  char(VTM.Patterns[i].Items[j].Channel[k].Sample * 2);
                PatStrs[StrNum] := PatStrs[StrNum] +
                  char($40 + VTM.Patterns[i].Items[j].Channel[k].Ornament)
              end
            end;
            if Sam1 then
              PatStrs[StrNum] := PatStrs[StrNum] +
                char($D0 + VTM.Patterns[i].Items[j].Channel[k].Sample);
            if Orn1 then
            begin
              PatStrs[StrNum] := PatStrs[StrNum] +
                char($40 + VTM.Patterns[i].Items[j].Channel[k].Ornament);
              if VTM.Patterns[i].Items[j].Channel[k].Envelope in [1..14] then
                PatStrs[StrNum] := PatStrs[StrNum] + char($B1 +
                  VTM.Patterns[i].Items[j].Channel[k].Envelope) +
                  char(Hi(VTM.Patterns[i].Items[j].Envelope)) +
                  char(VTM.Patterns[i].Items[j].Envelope)
              else if (VTM.Patterns[i].Items[j].Channel[k].Envelope = 15) and (Envelope[k] <> 0) then
                PatStrs[StrNum] := PatStrs[StrNum] + #$B0
            end;

            if not Orn and (VTM.Patterns[i].Items[j].Channel[k].Envelope > 0) then
            begin
              if VTM.Patterns[i].Items[j].Channel[k].Envelope <> 15 then
                PatStrs[StrNum] := PatStrs[StrNum] + char($B1 +
                  VTM.Patterns[i].Items[j].Channel[k].Envelope) +
                  char(Hi(VTM.Patterns[i].Items[j].Envelope)) +
                  char(VTM.Patterns[i].Items[j].Envelope)
              else if Envelope[k] <> 0 then
                PatStrs[StrNum] := PatStrs[StrNum] + #$B0
            end;

            if Orn then
              Ornament[k] := VTM.Patterns[i].Items[j].Channel[k].Ornament;

            if VTM.Patterns[i].Items[j].Channel[k].Envelope <> 0 then
              Envelope[k] := Ord(VTM.Patterns[i].Items[j].Channel[k].Envelope < 15);

            if VTM.Patterns[i].Items[j].Channel[k].Volume <> 0 then
              if VTM.Patterns[i].Items[j].Channel[k].Volume <> Volume[k] then
              begin
                PatStrs[StrNum] := PatStrs[StrNum] + char($C0 +
                  VTM.Patterns[i].Items[j].Channel[k].Volume);
                Volume[k] := VTM.Patterns[i].Items[j].Channel[k].Volume
              end;

            if (k = 1) and (VTM.Patterns[i].Items[j].Noise <> PrevNoise) then
            begin
              PrevNoise := VTM.Patterns[i].Items[j].Noise;
              PatStrs[StrNum] := PatStrs[StrNum] + char($20 +
                VTM.Patterns[i].Items[j].Noise)
            end;

            case VTM.Patterns[i].Items[j].Channel[k].Additional_Command.Number of
              1, 2:
                begin
                  PatStrs[StrNum] := PatStrs[StrNum] + #1;
                  TnDl[k] := VTM.Patterns[i].Items[j].Channel[k].Additional_Command.Delay;
                  TnCurDl[k] := TnDl[k];
                  if VTM.Patterns[i].Items[j].Channel[k].Additional_Command.Number = 1 then
                    TnStp[k] := VTM.Patterns[i].Items[j].Channel[k].Additional_Command.Parameter
                  else
                    TnStp[k] := -VTM.Patterns[i].Items[j].Channel[k].Additional_Command.Parameter
                end;
              3:
                if (VTM.Patterns[i].Items[j].Channel[k].Note >= 0) or
                  ((VTM.Patterns[i].Items[j].Channel[k].Note <> -2) and
                  (VTM.FeaturesLevel >= 1)) then
                begin
                  PatStrs[StrNum] := PatStrs[StrNum] + #2;
                  TnDl[k] := -VTM.Patterns[i].Items[j].Channel[k].Additional_Command.Delay;
                  TnCurDl[k] := -TnDl[k];
                  Dl := DeltT[k];
                  if VTM.Patterns[i].Items[j].Channel[k].Note >= 0 then
                    inc(Dl, GetNoteFreq(VTM.Ton_Table,
                      VTM.Patterns[i].Items[j].Channel[k].Note) -
                      GetNoteFreq(VTM.Ton_Table, Note[k]));
                  if Dl >= 0 then
                    TnStp[k] := VTM.Patterns[i].Items[j].Channel[k].Additional_Command.Parameter
                  else
                    TnStp[k] := -VTM.Patterns[i].Items[j].Channel[k].Additional_Command.Parameter;
                  DeltT[k] := Dl
                end;
              4..6:
                PatStrs[StrNum] := PatStrs[StrNum] + char(
                  VTM.Patterns[i].Items[j].Channel[k].Additional_Command.Number - 1);
              9, 10:
                PatStrs[StrNum] := PatStrs[StrNum] + #8;
              11:
                if VTM.Patterns[i].Items[j].Channel[k].Additional_Command.
                  Parameter <> 0 then
                  PatStrs[StrNum] := PatStrs[StrNum] + #9
            end;

            if (VTM.Patterns[i].Items[j].Channel[k].Note = -2) or
              ((VTM.Patterns[i].Items[j].Channel[k].Note >= 0) and
              not (VTM.Patterns[i].Items[j].Channel[k].Additional_Command.Number in [1..3])) then
            begin
              Dl := 0;
              TnDl[k] := 0;
              DeltT[k] := 0
            end;

            Skip[k] := 0;
            d := j;
            repeat
              if TnDl[k] <> 0 then
              begin
                dec(TnCurDl[k]);
                if TnCurDl[k] = 0 then
                begin
                  TnCurDl[k] := Abs(TnDl[k]);
                  dec(DeltT[k], TnStp[k]);
                  if TnDl[k] < 0 then
                    if ((DeltT[k] >= 0) and (TnStp[k] < 0)) or
                      ((DeltT[k] <= 0) and (TnStp[k] >= 0)) then
                    begin
                      TnDl[k] := 0;
                      DeltT[k] := 0
                    end
                end
              end;
              inc(Skip[k]);
              inc(j)
            until (j >= VTM.Patterns[i].Length) or
              (VTM.Patterns[i].Items[j].Channel[k].Note <> -1) or
              ((VTM.Patterns[i].Items[j].Channel[k].
              Additional_Command.Number = 11) and
              (VTM.Patterns[i].Items[j].Channel[k].
              Additional_Command.Parameter <> 0)) or
              not (VTM.Patterns[i].Items[j].Channel[k].
              Additional_Command.Number in [0, 11]) or
              (VTM.Patterns[i].Items[j].Channel[k].Volume <> 0) or
              (VTM.Patterns[i].Items[j].Channel[k].Envelope in [1..14]) or
              ((VTM.Patterns[i].Items[j].Channel[k].Envelope = 15) and
              ((Envelope[k] <> 0) or
              ((VTM.Patterns[i].Items[j].Channel[k].Ornament = 0) and
              (Ornament[k] <> 0)))) or
              (VTM.Patterns[i].Items[j].Channel[k].Ornament <> 0) or //new standard in pt3.69
              ((k = 1) and (VTM.Patterns[i].Items[d].Noise <>
              VTM.Patterns[i].Items[j].Noise));
            if Skip[k] <> SkipPrev[k] then
            begin
              PatStrs[StrNum] := PatStrs[StrNum] + #$B1 + char(Skip[k]);
              SkipPrev[k] := Skip[k]
            end;

            if VTM.Patterns[i].Items[d].Channel[k].Note = -2 then
              PatStrs[StrNum] := PatStrs[StrNum] + #$C0
            else if VTM.Patterns[i].Items[d].Channel[k].Note = -1 then
              PatStrs[StrNum] := PatStrs[StrNum] + #$D0
            else
            begin
              Note[k] := VTM.Patterns[i].Items[d].Channel[k].Note;
              PatStrs[StrNum] := PatStrs[StrNum] + char($50 + Note[k])
            end;


            case VTM.Patterns[i].Items[d].Channel[k].Additional_Command.Number of
              1:
                begin
                  PatStrs[StrNum] := PatStrs[StrNum] + char(
                    VTM.Patterns[i].Items[d].Channel[k].Additional_Command.Delay) +
                    char(VTM.Patterns[i].Items[d].Channel[k].Additional_Command.
                    Parameter) + #0
                end;
              2:
                begin
                  PatStrs[StrNum] := PatStrs[StrNum] + char(
                    VTM.Patterns[i].Items[d].Channel[k].Additional_Command.Delay) +
                    char(-VTM.Patterns[i].Items[d].Channel[k].Additional_Command.
                    Parameter) + #$FF
                end;
              3:
                if (VTM.Patterns[i].Items[d].Channel[k].Note >= 0) or
                  ((VTM.Patterns[i].Items[d].Channel[k].Note <> -2) and
                  (VTM.FeaturesLevel >= 1)) then
                begin
                  if Dl >= 0 then
                    PatStrs[StrNum] := PatStrs[StrNum] + char(
                      VTM.Patterns[i].Items[d].Channel[k].Additional_Command.Delay) +
                      char(Dl) + char(Hi(Dl)) + char(VTM.Patterns[i].Items[d].
                      Channel[k].Additional_Command.Parameter) + #0
                  else
                    PatStrs[StrNum] := PatStrs[StrNum] + char(
                      VTM.Patterns[i].Items[d].Channel[k].Additional_Command.Delay) +
                      char(-Dl) + char(Hi(-Dl)) + char(-VTM.Patterns[i].Items[d].
                      Channel[k].Additional_Command.Parameter) + #$FF
                end;
              4, 5:
                PatStrs[StrNum] := PatStrs[StrNum] + char(
                  VTM.Patterns[i].Items[d].Channel[k].Additional_Command.Parameter);
              6:
                PatStrs[StrNum] := PatStrs[StrNum] + char(
                  VTM.Patterns[i].Items[d].Channel[k].Additional_Command.Parameter
                  shr 4) + char(
                  VTM.Patterns[i].Items[d].Channel[k].Additional_Command.Parameter
                  and 15);
              9:
                PatStrs[StrNum] := PatStrs[StrNum] + char(
                  VTM.Patterns[i].Items[d].Channel[k].Additional_Command.Delay) +
                  char(VTM.Patterns[i].Items[d].Channel[k].
                  Additional_Command.Parameter) + #0;
              10:
                PatStrs[StrNum] := PatStrs[StrNum] + char(
                  VTM.Patterns[i].Items[d].Channel[k].Additional_Command.Delay) +
                  char(-VTM.Patterns[i].Items[d].Channel[k].
                  Additional_Command.Parameter) + #$FF;
              11:
                if VTM.Patterns[i].Items[d].Channel[k].
                  Additional_Command.Parameter <> 0 then
                  PatStrs[StrNum] := PatStrs[StrNum] + char(
                    VTM.Patterns[i].Items[d].Channel[k].Additional_Command.Parameter)
            end;
            Dl := DeltT[k]
          end;
          PatStrs[StrNum] := PatStrs[StrNum] + #0;

          PatsIndexes[PatNum, k] := StrNum;
          for d := 0 to StrNum - 1 do
            if PatStrs[d] = PatStrs[StrNum] then
            begin
              PatsIndexes[PatNum, k] := d;
              Dec(StrNum);
              break
            end;
          Inc(StrNum)
        end
      end
      else
      begin
        PatStrs[StrNum] := EmptyPatternString;
        PatsIndexes[PatNum, 0] := StrNum;
        PatsIndexes[PatNum, 1] := StrNum;
        PatsIndexes[PatNum, 2] := StrNum;
        for d := 0 to StrNum - 1 do
          if PatStrs[d] = EmptyPatternString then
          begin
            PatsIndexes[PatNum, 0] := d;
            PatsIndexes[PatNum, 1] := d;
            PatsIndexes[PatNum, 2] := d;
            Dec(StrNum);
            break
          end;
        Inc(StrNum)
      end
    end
  end;
  PatNum := PT3.PT3_PatternsPointer + 6 * (VTMPat2PT3Pat[MaxPattern] + 1);
  for i := 0 to StrNum - 1 do
  begin
    if PatNum > 65536 - 3 - Length(PatStrs[i]) then exit;
    PatOfs[i] := PatNum;
    Move(PatStrs[i][1], PT3.Index[PatNum], Length(PatStrs[i]));
    Inc(PatNum, Length(PatStrs[i]))
  end;

  j := PT3.PT3_PatternsPointer;
  for i := 0 to MaxPattern do
    if Patterns[i] then
    begin
      for k := 0 to 2 do
      begin
        WordPtr(@PT3.Index[j])^ := PatOfs[PatsIndexes[VTMPat2PT3Pat[i], k]];
        Inc(j, 2)
      end
    end;

  for i := 1 to 31 do
    if IsSample[i] then
    begin
      if PatNum >= 65536 - 2 - 3 then exit;
      PT3.PT3_SamplePointers[i] := PatNum;
      if VTM.Samples[i] <> nil then
        PT3.Index[PatNum] := VTM.Samples[i].Loop
      else
        PT3.Index[PatNum] := 0;
      Inc(PatNum);
      if VTM.Samples[i] <> nil then
        PT3.Index[PatNum] := VTM.Samples[i].Length
      else
        PT3.Index[PatNum] := 1;
      Inc(PatNum);
      if PatNum > 65536 - PT3.Index[PatNum - 1] * 4 - 3 then exit;
      if VTM.Samples[i] <> nil then
        for j := 0 to VTM.Samples[i].Length - 1 do
        begin
          d := 0;
          if not VTM.Samples[i].Items[j].Envelope_Enabled then d := 1;
          d := d + (VTM.Samples[i].Items[j].Add_to_Envelope_or_Noise) and 31 shl 1;
          if VTM.Samples[i].Items[j].Amplitude_Sliding then
          begin
            d := d or $80;
            if VTM.Samples[i].Items[j].Amplitude_Slide_Up then d := d or $40
          end;
          PT3.Index[PatNum] := d;
          Inc(PatNum);
          d := VTM.Samples[i].Items[j].Amplitude;
          if not VTM.Samples[i].Items[j].Mixer_Ton then d := d or $10;
          if not VTM.Samples[i].Items[j].Mixer_Noise then d := d or $80;
          if VTM.Samples[i].Items[j].Envelope_or_Noise_Accumulation then
            d := d or $20;
          if VTM.Samples[i].Items[j].Ton_Accumulation then d := d or $40;
          PT3.Index[PatNum] := d;
          Inc(PatNum);
          WordPtr(@PT3.Index[PatNum])^ := VTM.Samples[i].Items[j].Add_to_Ton;
          Inc(PatNum, 2)
        end
      else
      begin
        DWordPtr(@PT3.Index[PatNum])^ := $9001;
        Inc(PatNum, 4)
      end
    end;

  if PatNum > 65536 - 3 then exit;
  PT3.PT3_OrnamentPointers[0] := PatNum;
  PT3.Index[PatNum] := 0;
  Inc(PatNum);
  PT3.Index[PatNum] := 1;
  Inc(PatNum);
  PT3.Index[PatNum] := 0;
  Inc(PatNum);
  for i := 1 to 15 do
    if IsOrnament[i] then
    begin
      if PatNum >= 65536 - 2 then exit;
      PT3.PT3_OrnamentPointers[i] := PatNum;
      if VTM.Ornaments[i] <> nil then
        PT3.Index[PatNum] := VTM.Ornaments[i].Loop
      else
        PT3.Index[PatNum] := 0;
      Inc(PatNum);
      if VTM.Ornaments[i] <> nil then
        PT3.Index[PatNum] := VTM.Ornaments[i].Length
      else
        PT3.Index[PatNum] := 1;
      Inc(PatNum);
      if PatNum > 65536 - PT3.Index[PatNum - 1] then exit;
      if VTM.Ornaments[i] <> nil then
        for j := 0 to VTM.Ornaments[i].Length - 1 do
        begin
          PT3.Index[PatNum] := VTM.Ornaments[i].Items[j];
          Inc(PatNum)
        end
      else
      begin
        PT3.Index[PatNum] := 0;
        Inc(PatNum)
      end
    end;

  Module_Size := PatNum;

  Result := True

end;

function PT22VTM(PT2: PSpeccyModule; VTM: PModule): boolean;
var
  ChPtr: packed array[0..2] of word;
  Skip: array[0..2] of shortint;
  SkipCounter: array[0..2] of shortint;
  PrevOrn: array[0..2] of byte;
  NsBase: integer;

  procedure PatternInterpreter(PatNum, LnNum, ChNum: integer);
  var
    quit: boolean;
  begin
    quit := false;
    repeat
      case PT2.Index[ChPtr[ChNum]] of
        $E1..$FF:
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample :=
            PT2.Index[ChPtr[ChNum]] - $E0;
        $E0:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
            quit := True
          end;
        $80..$DF:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note :=
              PT2.Index[ChPtr[ChNum]] - $80;
            quit := True
          end;
        $7F:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := PrevOrn[ChNum]
          end;
        $71..$7E:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := PrevOrn[ChNum];
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope :=
              PT2.Index[ChPtr[ChNum]] - $70;
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Envelope :=
              WordPtr(@PT2.Index[ChPtr[ChNum]])^;
            Inc(ChPtr[ChNum])
          end;
        $70:
          quit := True;
        $60..$6F:
          begin
            PrevOrn[ChNum] := PT2.Index[ChPtr[ChNum]] - $60;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := PrevOrn[ChNum];
            if VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope = 0 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15
          end;
        $20..$5F:
          Skip[ChNum] := PT2.Index[ChPtr[ChNum]] - $20;
        $10..$1F:
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume :=
            PT2.Index[ChPtr[ChNum]] - $10;
        $F:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 11;
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := PT2.Index[ChPtr[ChNum]]
          end;
        $E:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Delay := 1;
            Inc(ChPtr[ChNum]);
            if shortint(PT2.Index[ChPtr[ChNum]]) >= 0 then
            begin
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                Additional_Command.Number := 1;
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                Additional_Command.Parameter := PT2.Index[ChPtr[ChNum]]
            end
            else
            begin
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                Additional_Command.Number := 2;
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                Additional_Command.Parameter := -PT2.Index[ChPtr[ChNum]]
            end
          end;
        $D:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Delay := 1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 3;
            Inc(ChPtr[ChNum]);
            if shortint(PT2.Index[ChPtr[ChNum]]) >= 0 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                Additional_Command.Parameter := PT2.Index[ChPtr[ChNum]]
            else
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                Additional_Command.Parameter := -PT2.Index[ChPtr[ChNum]];
            Inc(ChPtr[ChNum], 2)
          end;
        $C:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Delay := 0;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := 0
          end
      else
        begin
          Inc(ChPtr[ChNum]);
          NsBase := PT2.Index[ChPtr[ChNum]]
        end
      end;
      Inc(ChPtr[ChNum])
    until quit;
    SkipCounter[ChNum] := Skip[ChNum]
  end;

var
  i, j, k, Pos: Integer;
  quit: boolean;
begin
  Result := True;
  if DetectFeaturesLevel then
    VTM.FeaturesLevel := 0;
  if DetectModuleHeader then
    VTM.VortexModule_Header := False;
  SetLength(VTM.Title, 30);
  Move(PT2.PT2_MusicName, VTM.Title[1], 30);
  VTM.Title := TrimRight(VTM.Title);
  VTM.Author := '';
  VTM.Ton_Table := 1;
  VTM.Initial_Delay := PT2.PT2_Delay;
  VTM.Positions.Loop := PT2.PT2_LoopPosition;
  for i := 0 to 255 do
    VTM.Positions.Value[i] := 0;
  VTM.Ornaments[0] := nil;
  for i := 1 to 15 do
  begin
    if PT2.PT2_OrnamentPointers[i] = 0 then
      VTM.Ornaments[i] := nil
    else
    begin
      New(VTM.Ornaments[i]);
      VTM.Ornaments[i].Loop := PT2.Index[PT2.PT2_OrnamentPointers[i] + 1];
      VTM.Ornaments[i].Length := PT2.Index[PT2.PT2_OrnamentPointers[i]];
      if (VTM.Ornaments[i].Length = 0) or (VTM.Ornaments[i].Length > MaxOrnLen) then
        VTM.Ornaments[i].Length := MaxOrnLen;
      if VTM.Ornaments[i].Loop >= VTM.Ornaments[i].Length then
        VTM.Ornaments[i].Loop := VTM.Ornaments[i].Length - 1;
      for j := 0 to VTM.Ornaments[i].Length - 1 do
        VTM.Ornaments[i].Items[j] := PT2.Index[PT2.PT2_OrnamentPointers[i] + 2 + j]
    end
  end;


  for i := 1 to 31 do
  begin
    if PT2.PT2_SamplePointers[i] = 0 then
      VTM.Samples[i] := nil
    else
    begin
      if PT2.Index[PT2.PT2_SamplePointers[i] + 1] > MaxSamLen-1 then Continue;
      if PT2.Index[PT2.PT2_SamplePointers[i]] > MaxSamLen then Continue;

      New(VTM.Samples[i]);
      VTM.Samples[i].Loop := PT2.Index[PT2.PT2_SamplePointers[i] + 1];
      VTM.Samples[i].Length := PT2.Index[PT2.PT2_SamplePointers[i]];

      if (VTM.Samples[i].Length = 0) or (VTM.Samples[i].Length > MaxSamLen) then
        VTM.Samples[i].Length := MaxSamLen;
      if VTM.Samples[i].Loop >= VTM.Samples[i].Length then
        VTM.Samples[i].Loop := VTM.Samples[i].Length - 1;
      for j := 0 to VTM.Samples[i].Length - 1 do
      begin
        VTM.Samples[i].Items[j] := EmptySampleTick;
        VTM.Samples[i].Items[j].Envelope_Enabled := True;
        VTM.Samples[i].Items[j].Add_to_Ton :=
          PT2.Index[PT2.PT2_SamplePointers[i] + j * 3 + 4] +
          word(PT2.Index[PT2.PT2_SamplePointers[i] + j * 3 + 3] and 15) shl 8;
        if PT2.Index[PT2.PT2_SamplePointers[i] + j * 3 + 2] and 4 = 0 then
          VTM.Samples[i].Items[j].Add_to_Ton := -VTM.Samples[i].Items[j].Add_to_Ton;
        VTM.Samples[i].Items[j].Amplitude :=
          PT2.Index[PT2.PT2_SamplePointers[i] + j * 3 + 3] shr 4;
        VTM.Samples[i].Items[j].Mixer_Noise :=
          PT2.Index[PT2.PT2_SamplePointers[i] + j * 3 + 2] and 1 = 0;
        if VTM.Samples[i].Items[j].Mixer_Noise then
          VTM.Samples[i].Items[j].Add_to_Envelope_or_Noise :=
            (PT2.Index[PT2.PT2_SamplePointers[i] + j * 3 + 2] shr 3) and 31;
        if VTM.Samples[i].Items[j].Add_to_Envelope_or_Noise and $10 <> 0 then
          VTM.Samples[i].Items[j].Add_to_Envelope_or_Noise :=
            VTM.Samples[i].Items[j].Add_to_Envelope_or_Noise or shortint($F0);
        VTM.Samples[i].Items[j].Mixer_Ton :=
          PT2.Index[PT2.PT2_SamplePointers[i] + j * 3 + 2] and 2 = 0
      end
    end
  end;

  for i := 0 to MaxPatNum do
    VTM.Patterns[i] := nil;

  Pos := 0;
  while (Pos < 256) and (PT2.PT2_PositionList[Pos] < 128) do
  begin
    j := PT2.PT2_PositionList[Pos];
    VTM.Positions.Value[Pos] := j;
    Inc(Pos);
    if VTM.Patterns[j] = nil then
    begin
      NewPattern(VTM.Patterns[j]);
      for k := 0 to 2 do
      begin
        PrevOrn[k] := 0;
        SkipCounter[k] := 0;
        Skip[k] := 0
      end;
      Move(PT2.Index[PT2.PT2_PatternsPointer + j * 6], ChPtr, 6);
      NsBase := 0; i := 0; quit := False;
      while (i < MaxPatLen) and not quit do
      begin
        for k := 0 to 2 do
        begin
          Dec(SkipCounter[k]);
          if SkipCounter[k] < 0 then
          begin
            if (k = 0) and (PT2.Index[ChPtr[0]] = 0) then
            begin
              Dec(i);
              quit := True;
              break
            end;
            PatternInterpreter(j, i, k)
          end
        end;
        if i >= 0 then
          VTM.Patterns[j].Items[i].Noise := NsBase;
        Inc(i)
      end;
      VTM.Patterns[j].Length := i
    end
  end;
  VTM.Positions.Length := Pos
end;

function STC2VTM(STC: PSpeccyModule; FSize: integer; VTM: PModule): boolean;
type
  TSTCPat = record
    Numb, Trans: integer;
  end;
var
  ChPtr: packed array[0..2] of word;
  Skip: array[0..2] of shortint;
  SkipCounter: array[0..2] of shortint;
  IsOrnament: array[0..15] of boolean;
  IsSample: array[1..16] of boolean;
  CPat: TSTCPat;
  Orn2Sam: array[1..15] of byte;
  CSam, COrn: array[0..2] of byte;

  procedure PatternInterpreter(PatNum, LnNum, ChNum: integer);
  var
    nt: byte;
  begin
    repeat
      case STC.Index[ChPtr[ChNum]] of
        $0..$5F:
          begin
            nt := STC.Index[ChPtr[ChNum]] + CPat.Trans;
            if nt > $5F then nt := $5F;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := nt;
            Inc(ChPtr[ChNum]);
            break
          end;
        $60..$6F:
          begin
            CSam[ChNum] := STC.Index[ChPtr[ChNum]] - $5F;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample := CSam[ChNum];
            IsSample[CSam[ChNum]] := True
          end;
        $70..$7F:
          begin
            COrn[ChNum] := STC.Index[ChPtr[ChNum]] - $70;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := COrn[ChNum];
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            IsOrnament[COrn[ChNum]] := True
          end;
        $80:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
            Inc(ChPtr[ChNum]);
            break
          end;
        $81:
          begin
            Inc(ChPtr[ChNum]);
            break
          end;
        $82:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := 0;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15
          end;
        $83..$8E:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope :=
              STC.Index[ChPtr[ChNum]] - $80;
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Envelope := STC.Index[ChPtr[ChNum]];
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := 0
          end
      else
        Skip[ChNum] := STC.Index[ChPtr[ChNum]] - $A1
      end;
      Inc(ChPtr[ChNum])
    until False;
    if (COrn[ChNum] > 0) and (Orn2Sam[COrn[ChNum]] = 0) then
      Orn2Sam[COrn[ChNum]] := CSam[ChNum];
    SkipCounter[ChNum] := Skip[ChNum]
  end;

var
  i, j, k, n, l, Pos, PatMax: Integer;
  quit: boolean;
  Pats: array[0..MaxPatNum] of TSTCPat;
begin
  Result := True;
  SetLength(VTM.Title, 18);
  Move(STC.ST_Name, VTM.Title[1], 18);
  if (VTM.Title = 'SONG BY ST COMPILE') or
    (VTM.Title = 'SONG BY MB COMPILE') or
    (VTM.Title = 'SONG BY ST-COMPILE') or
    (VTM.Title = 'SOUND TRACKER v1.1') or
    (VTM.Title = 'S.T.FULL EDITION  ') or
    (VTM.Title = 'S.T.FULL EDITION '#127) or
    (VTM.Title = 'SOUND TRACKER v1.3') then
    VTM.Title := ''
  else
  begin
    if STC.ST_Size <> FSize then
      if (STC.ST_Size and 255) in [32..127] then
      begin
        VTM.Title := VTM.Title + Char(STC.ST_Size and 255);
        if (STC.ST_Size shr 8) in [32..127] then
          VTM.Title := VTM.Title + Char(STC.ST_Size shr 8)
      end;
    VTM.Title := TrimRight(VTM.Title)
  end;
  VTM.Author := '';
  VTM.Ton_Table := 1;
  VTM.Initial_Delay := STC.ST_Delay;
  VTM.Positions.Loop := 0;
  for i := 0 to 15 do
    VTM.Ornaments[i] := nil;
  for i := 1 to 15 do
  begin
    IsOrnament[i] := False;
    Orn2Sam[i] := 0
  end;
  for i := 1 to 31 do
    VTM.Samples[i] := nil;
  for i := 1 to 16 do
    IsSample[i] := False;
  for i := 0 to MaxPatNum do
    VTM.Patterns[i] := nil;

  for k := 0 to 2 do
  begin
    CSam[k] := 0;
    COrn[k] := 0
  end;
  PatMax := 0;
  Pos := 0;
  while Pos <= STC.Index[STC.ST_PositionsPointer] do
  begin
    CPat.Numb := STC.Index[STC.ST_PositionsPointer + 1 + Pos * 2];
    CPat.Trans := STC.Index[STC.ST_PositionsPointer + 2 + Pos * 2];
    j := PatMax;
    for i := 0 to PatMax - 1 do
      if (Pats[i].Numb = CPat.Numb) and
        (Pats[i].Trans = CPat.Trans) then
      begin
        j := i;
        break
      end;
    if j = PatMax then
    begin
      Inc(PatMax);
      Pats[j] := CPat
    end;
    VTM.Positions.Value[Pos] := j;
    Inc(Pos);
    if VTM.Patterns[j] = nil then
    begin
      NewPattern(VTM.Patterns[j]);
      for k := 0 to 2 do
      begin
        SkipCounter[k] := 0;
        Skip[k] := 0
      end;
      k := 0;
      n := Pats[j].Numb;

      while STC.Index[STC.ST_PatternsPointer + k * 7] <> n do begin
        inc(k);
        if STC.ST_PatternsPointer + k * 7 > High(STC.Index) then
          Exit;
      end;
      Move(STC.Index[STC.ST_PatternsPointer + k * 7 + 1], ChPtr, 6);
      i := 0; quit := False;
      while (i < MaxPatLen) and not quit do
      begin
        for k := 0 to 2 do
        begin
          Dec(SkipCounter[k]);
          if SkipCounter[k] < 0 then
          begin
            if (k = 0) and (STC.Index[ChPtr[0]] = 255) then
            begin
              Dec(i);
              quit := True;
              break
            end;
            PatternInterpreter(j, i, k)
          end
        end;
        Inc(i)
      end;
      VTM.Patterns[j].Length := i
    end
  end;
  VTM.Positions.Length := Pos;

  for i := 0 to 15 do
  begin
    j := STC.Index[STC.ST_OrnamentsPointer + $21 * i];
    if (j > 0) and (j <= 15) and IsOrnament[j] then
    begin
      IsOrnament[j] := False;
      New(VTM.Ornaments[j]);
      k := Orn2Sam[j] - 1;
      l := 0;
      n := 0;
      if k >= 0 then
      begin
        while STC.Index[$1B + $63 * n] <> k do begin
          Inc(n);
          if $1B + $63 * n > High(STC.Index) then
            Exit;
        end;
        l := STC.Index[$1B + $63 * n + $61]
      end;
      if l = 0 then
      begin
        VTM.Ornaments[j].Loop := 0;
        VTM.Ornaments[j].Length := 32
      end
      else
      begin
        VTM.Ornaments[j].Loop := l - 1;
        if VTM.Ornaments[j].Loop > 31 then VTM.Ornaments[j].Loop := 31;
        VTM.Ornaments[j].Length := l + STC.Index[$1B + $63 * n + $62];
        if VTM.Ornaments[j].Length > 32 then VTM.Ornaments[j].Length := 32;
        if VTM.Ornaments[j].Length = 0 then Inc(VTM.Ornaments[j].Length);
        if VTM.Ornaments[j].Loop >= VTM.Ornaments[j].Length then
          VTM.Ornaments[j].Loop := VTM.Ornaments[j].Length - 1;
        l := VTM.Ornaments[j].Loop + 1;
        if VTM.Ornaments[j].Length < 32 then
        begin
          Inc(VTM.Ornaments[j].Length, 33 - l);
          VTM.Ornaments[j].Loop := 32
        end
      end;
      for k := 0 to 31 do
        VTM.Ornaments[j].Items[k] :=
          STC.Index[STC.ST_OrnamentsPointer + $21 * i + 1 + k];
      for k := 32 to VTM.Ornaments[j].Length - 1 do
        VTM.Ornaments[j].Items[k] := VTM.Ornaments[j].Items[k + l - 33]
    end
  end;

  for i := 0 to 15 do
  begin
    j := STC.Index[$1B + $63 * i] + 1;
    if (j > 0) and (j <= 16) and IsSample[j] then
    begin
      IsSample[j] := False;
      New(VTM.Samples[j]);
      l := STC.Index[$1B + $63 * i + $61];
      if l = 0 then
      begin
        VTM.Samples[j].Length := 33;
        VTM.Samples[j].Loop := 32
      end
      else
      begin
        VTM.Samples[j].Loop := l - 1;
        if VTM.Samples[j].Loop > 31 then VTM.Samples[j].Loop := 31;
        VTM.Samples[j].Length := l + STC.Index[$1B + $63 * i + $62];
        if VTM.Samples[j].Length > 32 then VTM.Samples[j].Length := 32;
        if VTM.Samples[j].Length = 0 then Inc(VTM.Samples[j].Length);
        if VTM.Samples[j].Loop >= VTM.Samples[j].Length then
          VTM.Samples[j].Loop := VTM.Samples[j].Length - 1;
        l := VTM.Samples[j].Loop + 1;
        if VTM.Samples[j].Length < 32 then
        begin
          Inc(VTM.Samples[j].Length, 33 - l);
          VTM.Samples[j].Loop := 32
        end
      end;
      for k := 0 to 31 do
      begin
        VTM.Samples[j].Items[k] := EmptySampleTick;
        VTM.Samples[j].Items[k].Mixer_Noise :=
          STC.Index[$1B + $63 * i + 1 + k * 3 + 1] and 128 = 0;
        if VTM.Samples[j].Items[k].Mixer_Noise then
          VTM.Samples[j].Items[k].Add_to_Envelope_or_Noise :=
            STC.Index[$1B + $63 * i + 1 + k * 3 + 1] and $1F;
        if VTM.Samples[j].Items[k].Add_to_Envelope_or_Noise and $10 <> 0 then
          VTM.Samples[j].Items[k].Add_to_Envelope_or_Noise :=
            VTM.Samples[j].Items[k].Add_to_Envelope_or_Noise or shortint($F0);
        VTM.Samples[j].Items[k].Mixer_Ton :=
          STC.Index[$1B + $63 * i + 1 + k * 3 + 1] and 64 = 0;
        VTM.Samples[j].Items[k].Amplitude :=
          STC.Index[$1B + $63 * i + 1 + k * 3] and 15;
        VTM.Samples[j].Items[k].Add_to_Ton :=
          STC.Index[$1B + $63 * i + 1 + k * 3 + 2] +
          word(STC.Index[$1B + $63 * i + 1 + k * 3] and $F0) shl 4;
        if STC.Index[$1B + $63 * i + 1 + k * 3 + 1] and $20 = 0 then
          VTM.Samples[j].Items[k].Add_to_Ton :=
            -VTM.Samples[j].Items[k].Add_to_Ton;
        VTM.Samples[j].Items[k].Envelope_Enabled := True
      end;
      if l = 0 then
        VTM.Samples[j].Items[32] := EmptySampleTick
      else for k := 32 to VTM.Samples[j].Length - 1 do
          VTM.Samples[j].Items[k] := VTM.Samples[j].Items[k + l - 33]
    end
  end
end;

function STP2VTM(STP: PSpeccyModule; VTM: PModule): boolean;
type
  TSTPPat = record
    Numb, Trans: integer;
  end;
var
  ChPtr: packed array[0..2] of word;
  Gliss, Skip, SkipCounter: array[0..2] of shortint;
  IsOrnament: array[0..15] of boolean;
  IsSample: array[1..15] of boolean;
  CPat: TSTPPat;

  procedure PatternInterpreter(PatNum, LnNum, ChNum: integer);
  var
    quit, StopGliss: boolean;
    nt: byte;
    i: integer;
  begin
    quit := False;
    StopGliss := False;
    repeat
      case STP.Index[ChPtr[ChNum]] of
        $1..$60:
          begin
            nt := STP.Index[ChPtr[ChNum]] - 1 + CPat.Trans;
            if nt > $5F then nt := $5F;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := nt;
            if not StopGliss then
            begin
              i := Gliss[ChNum];
              if (i <> 0) and
                (VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                Additional_Command.Number = 0) then
              begin
                VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                  Additional_Command.Delay := 1;
                if i > 0 then
                begin
                  VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                    Additional_Command.Number := 1;
                  VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                    Additional_Command.Parameter := i
                end
                else
                begin
                  VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                    Additional_Command.Number := 2;
                  VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                    Additional_Command.Parameter := -i
                end
              end
            end
            else
            begin
              StopGliss := False;
              Gliss[ChNum] := 0
            end;
            quit := True
          end;
        $61..$6F:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample :=
              STP.Index[ChPtr[ChNum]] - $60;
            IsSample[VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample] := True
          end;
        $70..$7F:
          begin
            StopGliss := True;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament :=
              STP.Index[ChPtr[ChNum]] - $70;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            IsOrnament[VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Ornament] := True
          end;
        $80..$BF:
          Skip[ChNum] := STP.Index[ChPtr[ChNum]] - $80;
        $C0..$CF:
          begin
            StopGliss := True;
            if STP.Index[ChPtr[ChNum]] <> $C0 then
            begin
              if STP.Index[ChPtr[ChNum]] <> $CF then
                VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope :=
                  STP.Index[ChPtr[ChNum]] - $C0
              else
                VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 7;
              Inc(ChPtr[ChNum]);
              VTM.Patterns[PatNum].Items[LnNum].Envelope := STP.Index[ChPtr[ChNum]]
            end
            else
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := 0
          end;
        $D0..$DF:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
            quit := True
          end;
        $E0..$EF:
          quit := True;
        $F0:
          begin
            Inc(ChPtr[ChNum]);
            i := shortint(STP.Index[ChPtr[ChNum]]);
            if i = 0 then
              StopGliss := True
            else
            begin
              Gliss[ChNum] := i;
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                Additional_Command.Delay := 1;
              if i >= 0 then
              begin
                VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                  Additional_Command.Number := 1;
                VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                  Additional_Command.Parameter := i
              end
              else
              begin
                VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                  Additional_Command.Number := 2;
                VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                  Additional_Command.Parameter := -i
              end
            end
          end;
        $F1..$FF:
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume :=
            256 - STP.Index[ChPtr[ChNum]]
      end;
      Inc(ChPtr[ChNum])
    until quit;
    if StopGliss and (Gliss[ChNum] <> 0) then
    begin
      Gliss[ChNum] := 0;
      if VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
        Additional_Command.Number = 0 then
      begin
        VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
          Additional_Command.Number := 1;
        VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
          Additional_Command.Delay := 0;
        VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
          Additional_Command.Parameter := 0
      end
    end;
    SkipCounter[ChNum] := Skip[ChNum]
  end;

var
  i, j, k, Pos, PatMax: Integer;
  quit: boolean;
  KsaId2: string;
  Pats: array[0..MaxPatNum] of TSTPPat;
begin
  Result := True;
  SetLength(KsaId2, 28);
  Move(STP.Index[10], KsaId2[1], 28);
  if KsaId2 = KsaId then
  begin
    SetLength(VTM.Title, 25);
    Move(STP.Index[38], VTM.Title[1], 25);
    VTM.Title := TrimRight(VTM.Title)
  end
  else
    VTM.Title := '';
  VTM.Author := '';
  VTM.Ton_Table := 1;
  VTM.Initial_Delay := STP.STP_Delay;
  VTM.Positions.Loop := STP.Index[STP.STP_PositionsPointer + 1];
  for i := 0 to 15 do
    VTM.Ornaments[i] := nil;
  for i := 1 to 15 do
    IsOrnament[i] := False;
  for i := 1 to 31 do
    VTM.Samples[i] := nil;
  for i := 1 to 15 do
    IsSample[i] := False;
  for i := 0 to MaxPatNum do
    VTM.Patterns[i] := nil;
  for k := 0 to 2 do
    Gliss[k] := 0;
  PatMax := 0;
  Pos := 0;
  while Pos < STP.Index[STP.STP_PositionsPointer] do
  begin
    CPat.Numb := STP.Index[STP.ST_PositionsPointer + 2 + Pos * 2] div 6;
    CPat.Trans := STP.Index[STP.ST_PositionsPointer + 3 + Pos * 2];
    j := PatMax;
    for i := 0 to PatMax - 1 do
      if (Pats[i].Numb = CPat.Numb) and
        (Pats[i].Trans = CPat.Trans) then
      begin
        j := i;
        break
      end;
    if j = PatMax then
    begin
      Inc(PatMax);
      Pats[j] := CPat
    end;
    VTM.Positions.Value[Pos] := j;
    Inc(Pos);
    if VTM.Patterns[j] = nil then
    begin
      NewPattern(VTM.Patterns[j]);
      for k := 0 to 2 do
      begin
        SkipCounter[k] := 0;
        Skip[k] := 0
      end;
      Move(STP.Index[STP.STP_PatternsPointer + CPat.Numb * 6], ChPtr, 6);
      i := 0; quit := False;
      while (i < MaxPatLen) and not quit do
      begin
        for k := 0 to 2 do
        begin
          Dec(SkipCounter[k]);
          if SkipCounter[k] < 0 then
          begin
            if (k = 0) and (STP.Index[ChPtr[0]] = 0) then
            begin
              Dec(i);
              quit := True;
              break
            end;
            PatternInterpreter(j, i, k)
          end
        end;
        Inc(i)
      end;
      VTM.Patterns[j].Length := i
    end
    else
      for k := 0 to 2 do
        Gliss[k] := 0
  end;
  VTM.Positions.Length := Pos;
  if VTM.Positions.Loop >= Pos then
    VTM.Positions.Loop := Pos - 1;

  for i := 1 to 15 do
  begin
    if IsOrnament[i] then
    begin
      New(VTM.Ornaments[i]);
      j := WordPtr(@STP.Index[STP.STP_OrnamentsPointer + i * 2])^;
      VTM.Ornaments[i].Loop := STP.Index[j]; Inc(j);
      VTM.Ornaments[i].Length := STP.Index[j];
      for k := 0 to VTM.Ornaments[i].Length - 1 do
      begin
        Inc(j);
        VTM.Ornaments[i].Items[k] := STP.Index[j]
      end
    end
  end;

  for i := 1 to 15 do
  begin
    if IsSample[i] then
    begin
      j := WordPtr(@STP.Index[STP.STP_SamplesPointer + (i - 1) * 2])^;
      if (STP.Index[j] > MaxSamLen-1) or (STP.Index[j+1] > MaxSamLen) then
        Continue;

      New(VTM.Samples[i]);
      VTM.Samples[i].Loop := STP.Index[j]; Inc(j);
      VTM.Samples[i].Length := STP.Index[j]; Inc(j);
      for k := 0 to VTM.Samples[i].Length - 1 do
      begin
        VTM.Samples[i].Items[k] := EmptySampleTick;
        VTM.Samples[i].Items[k].Add_to_Ton := WordPtr(@STP.Index[j + k * 4 + 2])^;
        VTM.Samples[i].Items[k].Amplitude := STP.Index[j + k * 4] and 15;
        VTM.Samples[i].Items[k].Envelope_Enabled :=
          STP.Index[j + k * 4 + 1] and 1 <> 0;
        VTM.Samples[i].Items[k].Mixer_Ton := STP.Index[j + k * 4] and $10 = 0;
        VTM.Samples[i].Items[k].Mixer_Noise := STP.Index[j + k * 4] and $80 = 0;
        if VTM.Samples[i].Items[k].Envelope_Enabled or
          VTM.Samples[i].Items[k].Mixer_Noise then
        begin
          VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise :=
            (STP.Index[j + k * 4 + 1] shr 1) and 31;
          if VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise and $10 <> 0 then
            VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise :=
              VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise or shortint($F0)
        end
      end;
      if shortint(VTM.Samples[i].Loop) < 0 then
      begin
        VTM.Samples[i].Loop := VTM.Samples[i].Length;
        Inc(VTM.Samples[i].Length);
        VTM.Samples[i].Items[VTM.Samples[i].Loop] := EmptySampleTick
      end
    end
  end
end;

function SQT2VTM(SQT: PSpeccyModule; VTM: PModule): boolean;
type
  TSQTPat = record
    Del: integer;
    Chn: array[0..2] of record
      EnableEffects: boolean;
      PatChanNumber, Vol, Trans: integer;
    end
  end;
var
  ChPtr: packed array[0..2] of word;
  PrevNote, PrevOrn, PrevSamp: array[0..2] of byte;
  ix21: array[0..2] of byte;
  ix27: array[0..2] of word;
  b6ix0, b7ix0, EnvEn: array[0..2] of boolean;
  orns: array[1..31] of integer;
  IsSample: array[1..31] of boolean;
  CDelay, EnvP, EnvT: byte;
  CPat: TSQTPat;
  CVol: array[0..2] of byte;
  NOrns: integer;
  Orn2Sam: array[1..15] of byte;

  procedure PatternInterpreter(PatNum, LnNum, ChNum: integer);
  var
    Ptr: word;
    Temp, PrOrn: integer;
    SampleSet: boolean;

    procedure Call_LC1D1(a: byte);
    begin
      Inc(Ptr);
      if b6ix0[ChNum] then
      begin
        ChPtr[ChNum] := Ptr + 1;
        b6ix0[ChNum] := False
      end;
      case a - 1 of
        0:
          if CPat.Chn[ChNum].EnableEffects then
          begin
            CVol[ChNum] := SQT.Index[Ptr] and 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := 15 -
              CVol[ChNum];
            if VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume = 0 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := 1
          end;
        1:
          if CPat.Chn[ChNum].EnableEffects then
          begin
            CVol[ChNum] := (CVol[ChNum] + SQT.Index[Ptr]) and 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := 15 -
              CVol[ChNum];
            if VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume = 0 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := 1
          end;
        2:
          if CPat.Chn[ChNum].EnableEffects then
          begin
            CVol[0] := SQT.Index[Ptr] and 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[0].Volume := 15 - CVol[0];
            if VTM.Patterns[PatNum].Items[LnNum].Channel[0].Volume = 0 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[0].Volume := 1;
            CVol[1] := SQT.Index[Ptr] and 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[1].Volume := 15 - CVol[1];
            if VTM.Patterns[PatNum].Items[LnNum].Channel[1].Volume = 0 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[1].Volume := 1;
            CVol[2] := SQT.Index[Ptr] and 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[2].Volume := 15 - CVol[2];
            if VTM.Patterns[PatNum].Items[LnNum].Channel[2].Volume = 0 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[2].Volume := 1
          end;
        3:
          if CPat.Chn[ChNum].EnableEffects then
          begin
            CVol[0] := (CVol[0] + SQT.Index[Ptr]) and 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[0].Volume := 15 - CVol[0];
            if VTM.Patterns[PatNum].Items[LnNum].Channel[0].Volume = 0 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[0].Volume := 1;
            CVol[1] := (CVol[1] + SQT.Index[Ptr]) and 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[1].Volume := 15 - CVol[1];
            if VTM.Patterns[PatNum].Items[LnNum].Channel[1].Volume = 0 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[1].Volume := 1;
            CVol[2] := (CVol[2] + SQT.Index[Ptr]) and 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[2].Volume := 15 - CVol[2];
            if VTM.Patterns[PatNum].Items[LnNum].Channel[2].Volume = 0 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[2].Volume := 1
          end;
        4:
          if CPat.Chn[ChNum].EnableEffects then
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 11;
            CDelay := SQT.Index[Ptr] and 31;
            if CDelay = 0 then CDelay := 32;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := CDelay
          end;
        5:
          if CPat.Chn[ChNum].EnableEffects then
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 11;
            CDelay := (CDelay + SQT.Index[Ptr]) and 31;
            if CDelay = 0 then CDelay := 32;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := CDelay
          end;
        6:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Delay := 1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 2;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := SQT.Index[Ptr]
          end;
        7:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Delay := 1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := SQT.Index[Ptr]
          end;
      else
        begin
          EnvEn[ChNum] := True;
          EnvT := (a - 1) and 15;
          if EnvT = 15 then EnvT := 7;
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := EnvT;
          if PrevOrn[ChNum] <> 255 then
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament :=
              PrevOrn[ChNum];
          EnvP := SQT.Index[Ptr];
          VTM.Patterns[PatNum].Items[LnNum].Envelope := EnvP
        end
      end
    end;

    procedure Call_LC2A8(a: byte);
    begin
      if EnvEn[ChNum] or (PrevOrn[ChNum] <> 0) then
      begin
        SampleSet := True;
        PrOrn := PrevOrn[ChNum];
        PrevOrn[ChNum] := 0;
        EnvEn[ChNum] := False;
        VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
        VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := 0
      end;
      if (a > 0) and (a <= 31) then IsSample[a] := True;
      if PrevSamp[ChNum] <> a then
      begin
        PrevSamp[ChNum] := a;
        VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample := a
      end;
      if a <> 0 then
        VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := PrevNote[ChNum]
    end;

    procedure Call_LC2D9(a: byte);
    var
      orn: integer;
    begin
      if a = 0 then exit;
      orn := orns[a];
      if orn < 0 then
      begin
        if NOrns >= 15 then exit;
        Inc(NOrns);
        orn := NOrns;
        orns[a] := orn
      end;
      if SampleSet then
      begin
        PrevOrn[ChNum] := PrOrn;
        if not EnvEn[ChNum] then
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 0
      end;
      if EnvEn[ChNum] or (PrevOrn[ChNum] <> orn) then
      begin
        PrevOrn[ChNum] := orn;
        if EnvEn[ChNum] then
        begin
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := EnvT;
          VTM.Patterns[PatNum].Items[LnNum].Envelope := EnvP
        end
        else
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
        VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := orn
      end
    end;

    procedure Call_LC283;
    begin
      case SQT.Index[Ptr] of
        0..$7F:
          Call_LC1D1(SQT.Index[Ptr]);
        $80..$FF:
          begin
            if SQT.Index[Ptr] shr 1 and 31 <> 0 then
              Call_LC2A8(SQT.Index[Ptr] shr 1 and 31);
            if SQT.Index[Ptr] and 64 <> 0 then
            begin
              Temp := SQT.Index[Ptr + 1] shr 4;
              if SQT.Index[Ptr] and 1 <> 0 then Temp := Temp or 16;
              if Temp <> 0 then Call_LC2D9(Temp);
              Inc(Ptr);
              if SQT.Index[Ptr] and 15 <> 0 then
                Call_LC1D1(SQT.Index[Ptr] and 15)
            end
          end
      end;
      Inc(Ptr)
    end;

    procedure Call_LC191;
    begin
      Ptr := ix27[ChNum];
      b6ix0[ChNum] := False;
      case SQT.Index[Ptr] of
        0..$7F:
          begin
            Inc(Ptr);
            Call_LC283
          end;
        $80..$FF:
          Call_LC2A8(SQT.Index[Ptr] and 31)
      end
    end;

  var
    nt: byte;

  begin
    SampleSet := False;
    if ix21[ChNum] <> 0 then
    begin
      Dec(ix21[ChNum]);
      if b7ix0[ChNum] then
        Call_LC191;
      if (PrevOrn[ChNum] > 0) and (Orn2Sam[PrevOrn[ChNum]] = 0) then
        Orn2Sam[PrevOrn[ChNum]] := PrevSamp[ChNum];
      exit
    end;
    Ptr := ChPtr[ChNum];
    b7ix0[ChNum] := False;
    b6ix0[ChNum] := True;
    repeat
      case SQT.Index[Ptr] of
        $0..$5F:
          begin
            nt := SQT.Index[Ptr] + CPat.Chn[ChNum].Trans + 2;
            if nt > $5F then nt := $5F;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := nt;
            PrevNote[ChNum] := nt;
            ix27[ChNum] := Ptr;
            Inc(Ptr);
            Call_LC283;
            if b6ix0[ChNum] then ChPtr[ChNum] := Ptr;
            break
          end;
        $60..$6E:
          begin
            Call_LC1D1(SQT.Index[Ptr] - $60);
            break
          end;
        $6F:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
            ChPtr[ChNum] := Ptr + 1;
            break
          end;
        $70..$7F:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
            Call_LC1D1(SQT.Index[Ptr] - $6F);
            break
          end;
        $80..$9F:
          begin
            ChPtr[ChNum] := Ptr + 1;
            if SQT.Index[Ptr] and 16 = 0 then
              Inc(PrevNote[ChNum], SQT.Index[Ptr] and 15)
            else
              Dec(PrevNote[ChNum], SQT.Index[Ptr] and 15);
            if PrevNote[ChNum] > $5F then PrevNote[ChNum] := $5F;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note :=
              PrevNote[ChNum];
            Call_LC191;
            break
          end;
        $A0..$BF:
          begin
            ChPtr[ChNum] := Ptr + 1;
            ix21[ChNum] := SQT.Index[Ptr] and 15;
            if SQT.Index[Ptr] and 16 = 0 then break;
            if ix21[ChNum] <> 0 then b7ix0[ChNum] := True;
            Call_LC191;
            break
          end;
        $C0..$FF:
          begin
            ChPtr[ChNum] := Ptr + 1;
            ix27[ChNum] := Ptr;
            Call_LC2A8(SQT.Index[Ptr] and 31);
            break
          end
      end
    until False;
    if (PrevOrn[ChNum] > 0) and (Orn2Sam[PrevOrn[ChNum]] = 0) then
      Orn2Sam[PrevOrn[ChNum]] := PrevSamp[ChNum]
  end;

var
  i, j, k, l, Pos, c, PatMax, lp, len: Integer;
  IsPattern: array[0..MaxPatNum] of boolean;
  Pats: array[0..MaxPatNum] of TSQTPat;

begin
  Result := True;
  VTM.Title := '';
  VTM.Author := '';
  VTM.Ton_Table := 1;
  VTM.Initial_Delay := 0;
  for i := 0 to 15 do
    VTM.Ornaments[i] := nil;
  for i := 1 to 15 do
    Orn2Sam[i] := 0;
  for i := 1 to 31 do
    orns[i] := -1;
  for i := 1 to 31 do
    VTM.Samples[i] := nil;
  for i := 1 to 31 do
    IsSample[i] := False;

  for i := 0 to MaxPatNum do
  begin
    VTM.Patterns[i] := nil;
    IsPattern[i] := False
  end;

  Pos := 0;
  PatMax := 0;
  NOrns := 0;
  VTM.Positions.Loop := 0;
  while (Pos < 256) and (SQT.Index[SQT.SQT_PositionsPointer + Pos * 7] <> 0) do
  begin
    if SQT.SQT_PositionsPointer + Pos * 7 = SQT.SQT_LoopPointer then
      VTM.Positions.Loop := Pos;
    CPat.Chn[2].PatChanNumber := SQT.Index[SQT.SQT_PositionsPointer + Pos * 7] and $7F;
    CPat.Chn[1].PatChanNumber := SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 2] and $7F;
    CPat.Chn[0].PatChanNumber := SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 4] and $7F;
    CPat.Chn[2].EnableEffects := SQT.Index[SQT.SQT_PositionsPointer + Pos * 7] and 128 <> 0;
    CPat.Chn[1].EnableEffects := SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 2] and 128 <> 0;
    CPat.Chn[0].EnableEffects := SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 4] and 128 <> 0;
    CPat.Chn[2].Vol := SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 1] and 15;
    CPat.Chn[1].Vol := SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 3] and 15;
    CPat.Chn[0].Vol := SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 5] and 15;
    if SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 1] shr 4 < 9 then
      CPat.Chn[2].Trans := SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 1] shr 4
    else
      CPat.Chn[2].Trans := -(SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 1] shr 4
        - 9) - 1;
    if SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 3] shr 4 < 9 then
      CPat.Chn[1].Trans := SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 3] shr 4
    else
      CPat.Chn[1].Trans := -(SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 3] shr 4
        - 9) - 1;
    if SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 5] shr 4 < 9 then
      CPat.Chn[0].Trans := SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 5] shr 4
    else
      CPat.Chn[0].Trans := -(SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 5] shr 4
        - 9) - 1;
    CDelay := SQT.Index[SQT.SQT_PositionsPointer + Pos * 7 + 6];
    if VTM.Initial_Delay = 0 then
      VTM.Initial_Delay := CDelay;
    CPat.Del := CDelay;
    j := PatMax;
    for c := 0 to PatMax - 1 do
    begin
      if (Pats[c].Chn[2].PatChanNumber = CPat.Chn[2].PatChanNumber) and
        (Pats[c].Chn[2].EnableEffects = CPat.Chn[2].EnableEffects) and
        (Pats[c].Chn[2].Vol = CPat.Chn[2].Vol) and
        (Pats[c].Chn[2].Trans = CPat.Chn[2].Trans) and
        (Pats[c].Chn[1].PatChanNumber = CPat.Chn[1].PatChanNumber) and
        (Pats[c].Chn[1].EnableEffects = CPat.Chn[1].EnableEffects) and
        (Pats[c].Chn[1].Vol = CPat.Chn[1].Vol) and
        (Pats[c].Chn[1].Trans = CPat.Chn[1].Trans) and
        (Pats[c].Chn[0].PatChanNumber = CPat.Chn[0].PatChanNumber) and
        (Pats[c].Chn[0].EnableEffects = CPat.Chn[0].EnableEffects) and
        (Pats[c].Chn[0].Vol = CPat.Chn[0].Vol) and
        (Pats[c].Chn[0].Trans = CPat.Chn[0].Trans) and
        (Pats[c].Del = CPat.Del) then
      begin
        j := c;
        break
      end;
    end;
    if j = PatMax then
    begin
      Inc(PatMax);
      if j < MaxNumOfPats then
        Pats[j] := CPat
    end;
    VTM.Positions.Value[Pos] := j;
    inc(Pos);
    if (j < MaxNumOfPats) and not IsPattern[j] then
    begin
      IsPattern[j] := True;
      NewPattern(VTM.Patterns[j]);
      move(SQT.Index[CPat.Chn[0].PatChanNumber * 2 + SQT.SQT_PatternsPointer], ChPtr[0], 2);
      move(SQT.Index[CPat.Chn[1].PatChanNumber * 2 + SQT.SQT_PatternsPointer], ChPtr[1], 2);
      move(SQT.Index[CPat.Chn[2].PatChanNumber * 2 + SQT.SQT_PatternsPointer], ChPtr[2], 2);
      c := SQT.Index[ChPtr[2]]; if c > MaxPatLen then c := MaxPatLen;
      for k := 0 to 2 do
      begin
        Inc(ChPtr[k]);
        EnvEn[k] := False;
        PrevSamp[k] := 0;
        PrevOrn[k] := 255;
        PrevNote[k] := 0;
        ix21[k] := 0
      end;
      VTM.Patterns[j].Length := c;
      CVol[0] := CPat.Chn[0].Vol;
      VTM.Patterns[j].Items[0].Channel[0].Volume := 15 - CVol[0];
      if VTM.Patterns[j].Items[0].Channel[0].Volume = 0 then
        Inc(VTM.Patterns[j].Items[0].Channel[0].Volume);
      CVol[1] := CPat.Chn[1].Vol;
      VTM.Patterns[j].Items[0].Channel[1].Volume := 15 - CVol[1];
      if VTM.Patterns[j].Items[0].Channel[1].Volume = 0 then
        Inc(VTM.Patterns[j].Items[0].Channel[1].Volume);
      CVol[2] := CPat.Chn[2].Vol;
      VTM.Patterns[j].Items[0].Channel[2].Volume := 15 - CVol[2];
      if VTM.Patterns[j].Items[0].Channel[2].Volume = 0 then
        Inc(VTM.Patterns[j].Items[0].Channel[2].Volume);
      i := 0;
      while (i < c) do
      begin
        for k := 2 downto 0 do
          PatternInterpreter(j, i, k);
        Inc(i)
      end;
      if (VTM.Patterns[j].Items[0].Channel[0].Additional_Command.Number <> 11) and
        (VTM.Patterns[j].Items[0].Channel[1].Additional_Command.Number <> 11) and
        (VTM.Patterns[j].Items[0].Channel[2].Additional_Command.Number <> 11) then
      begin
        if VTM.Patterns[j].Items[0].Channel[0].Additional_Command.Number = 0 then
          k := 0
        else if VTM.Patterns[j].Items[0].Channel[1].Additional_Command.Number = 0 then
          k := 1
        else
          k := 2;
        VTM.Patterns[j].Items[0].Channel[k].Additional_Command.Number := 11;
        VTM.Patterns[j].Items[0].Channel[k].Additional_Command.Parameter := CPat.Del
      end
    end
  end;
  VTM.Positions.Length := Pos;

  for i := 1 to 31 do
  begin
    l := orns[i];
    if (l > 0) and (l <= High(VTM.Ornaments)) then
    begin
      New(VTM.Ornaments[l]);
      j := 0;
      move(SQT.Index[SQT.SQT_OrnamentsPointer + i * 2], j, 2);
      lp := SQT.Index[j]; Inc(j);
      if lp > 32 then lp := 32;
      if lp < 32 then
      begin
        len := lp + SQT.Index[j];
        if len > 32 then len := 32;
        if len < 32 then
        begin
          VTM.Ornaments[l].Loop := 32;
          VTM.Ornaments[l].Length := 32 + len - lp
        end
        else
        begin
          VTM.Ornaments[l].Loop := lp;
          VTM.Ornaments[l].Length := 32
        end
      end
      else
      begin
        len := 32;
        k := Orn2Sam[l];
        if k > 0 then
        begin
          c := WordPtr(@SQT.Index[SQT.SQT_SamplesPointer + k * 2])^;
          lp := SQT.Index[c]; Inc(c);
          if lp > 32 then lp := 32;
          len := lp + SQT.Index[c];
          if len > 32 then len := 32
        end;
        if lp < 32 then
        begin
          if len < 32 then
          begin
            VTM.Ornaments[l].Loop := 32;
            VTM.Ornaments[l].Length := 32 + len - lp
          end
          else
          begin
            VTM.Ornaments[l].Loop := lp;
            VTM.Ornaments[l].Length := 32
          end
        end
        else
        begin
          VTM.Ornaments[l].Loop := 31;
          VTM.Ornaments[l].Length := 32
        end
      end;
      Inc(j);
      for k := 0 to 31 do
        VTM.Ornaments[l].Items[k] := SQT.Index[j + k];
      for k := 32 to VTM.Ornaments[l].Length - 1 do
        VTM.Ornaments[l].Items[k] := VTM.Ornaments[l].Items[k - 32 + lp]
    end;
  end;

  for i := 1 to 31 do
  begin
    if IsSample[i] then
    begin
      New(VTM.Samples[i]);
      j := WordPtr(@SQT.Index[SQT.SQT_SamplesPointer + i * 2])^;
      lp := SQT.Index[j]; Inc(j);
      if lp > 32 then lp := 32;
      if lp < 32 then
      begin
        len := lp + SQT.Index[j];
        if len > 32 then len := 32;
        if len <> 32 then
        begin
          VTM.Samples[i].Loop := 32;
          VTM.Samples[i].Length := 32 + len - lp
        end
        else
        begin
          VTM.Samples[i].Loop := lp;
          VTM.Samples[i].Length := 32
        end
      end
      else
      begin
        VTM.Samples[i].Loop := 32;
        VTM.Samples[i].Length := 33
      end;
      Inc(j);
      for k := 0 to 31 do
      begin
        VTM.Samples[i].Items[k] := EmptySampleTick;
        VTM.Samples[i].Items[k].Amplitude := SQT.Index[j + k * 3] and 15;
        if VTM.Samples[i].Items[k].Amplitude = 0 then
          VTM.Samples[i].Items[k].Envelope_Enabled := True;
        VTM.Samples[i].Items[k].Mixer_Noise :=
          SQT.Index[j + k * 3 + 1] and 32 <> 0;
        VTM.Samples[i].Items[k].Mixer_Ton := SQT.Index[j + k * 3 + 1] and 64 <> 0;
        if VTM.Samples[i].Items[k].Mixer_Noise then
        begin
          VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise :=
            (SQT.Index[j + k * 3] and $F0 shr 3);
          if SQT.Index[j + k * 3 + 1] and 128 <> 0 then
            Inc(VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise);
          if VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise and $10 <> 0 then
            VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise :=
              VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise or shortint($F0)
        end;
        if SQT.Index[j + k * 3 + 1] and 16 <> 0 then
          VTM.Samples[i].Items[k].Add_to_Ton :=
            word(SQT.Index[j + k * 3 + 1] and 15) shl 8 + SQT.Index[j + k * 3 + 2]
        else
          VTM.Samples[i].Items[k].Add_to_Ton :=
            -(word(SQT.Index[j + k * 3 + 1] and 15) shl 8 + SQT.Index[j + k * 3 + 2])
      end;
      if lp = 32 then
        VTM.Samples[i].Items[32] := EmptySampleTick
      else
        for k := 32 to VTM.Samples[i].Length - 1 do
          VTM.Samples[i].Items[k] := VTM.Samples[i].Items[k - 32 + lp]
    end
  end
end;

function ASC2VTM(ASC: PSpeccyModule; VTM: PModule): boolean;
var
  ChPtr: packed array[0..2] of word;
  EnvEn: array[0..2] of boolean;
  Skip, SkipCounter, TSCnt: array[0..2] of shortint;
  EnvT, CDelay: integer;
  NOrns, NSams, Ns: integer;
  orns, sams: array[0..31] of integer;
  PrevOrn, PrevNote, PrevVol, Vol, PatVol: array[0..2] of shortint;
  Volume_Counter, VCDop: array[0..2] of integer;
  TS, TSAdd: array[0..2] of smallint;

  procedure PatternInterpreter(PatNum, LnNum, ChNum: integer);
  var
    delta_ton: smallint;
    Initialization_Of_Sample_Disabled: boolean;
    i, a: integer;

    procedure CalcSlide;
    begin
      VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
        Additional_Command.Number := 3;
      Inc(ChPtr[ChNum]);
      if ASC.Index[ChPtr[ChNum] + 1] < $56 then
        delta_ton := (PT3NoteTable_ST[PrevNote[ChNum]] -
          PT3NoteTable_ST[ASC.Index[ChPtr[ChNum] + 1]]) * 16
      else
        delta_ton := 0;
      if FeaturesLevel >= 1 then
        Inc(delta_ton, TS[ChNum]);
      TSAdd[ChNum] := delta_ton div ASC.Index[ChPtr[ChNum]];
      TS[ChNum] := delta_ton - delta_ton mod ASC.Index[ChPtr[ChNum]];
      TSCnt[ChNum] := ASC.Index[ChPtr[ChNum]];
      delta_ton := delta_ton div 16;
      if delta_ton < 0 then delta_ton := -delta_ton;
      if delta_ton <> 0 then
      begin
        i := delta_ton div ASC.Index[ChPtr[ChNum]];
        if i > 255 then i := 255;
        if i > 0 then
        begin
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
            Additional_Command.Delay := 1;
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
            Additional_Command.Parameter := i
        end
        else
        begin
          i := ASC.Index[ChPtr[ChNum]] div delta_ton;
          if i > 15 then i := 15;
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
            Additional_Command.Delay := i;
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
            Additional_Command.Parameter := 1
        end
      end
      else
      begin
        VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
          Additional_Command.Delay := 15;
        VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
          Additional_Command.Parameter := 1
      end
    end;

  begin
    TSCnt[ChNum] := 0;
    Initialization_Of_Sample_Disabled := False;
    Volume_Counter[ChNum] := 0;
    repeat
      case ASC.Index[ChPtr[ChNum]] of
        0..$55:
          begin
            PrevNote[ChNum] := ASC.Index[ChPtr[ChNum]];
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note :=
              PrevNote[ChNum];
            Inc(ChPtr[ChNum]);
            if TSCnt[ChNum] <= 0 then TS[ChNum] := 0;
            if EnvEn[ChNum] then
            begin
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := EnvT;
              VTM.Patterns[PatNum].Items[LnNum].Envelope := ASC.Index[ChPtr[ChNum]];
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := PrevOrn[ChNum];
              Inc(ChPtr[ChNum])
            end;
            if not Initialization_Of_Sample_Disabled then
              if Vol[ChNum] <> PrevVol[ChNum] then
              begin
                VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := Vol[ChNum];
                PatVol[ChNum] := Vol[ChNum];
                PrevVol[ChNum] := Vol[ChNum]
              end;
            break
          end;
        $56..$5D:
          begin
            Inc(ChPtr[ChNum]);
            break
          end;
        $5E:
          begin
//        Break_Sample_Loop := True; //not realisable in pt3...
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
            Inc(ChPtr[ChNum]);
            break
          end;
        $5F:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
            Inc(ChPtr[ChNum]);
            break
          end;
        $60..$9F:
          Skip[ChNum] := ASC.Index[ChPtr[ChNum]] - $60;
        $A0..$BF:
          begin
            a := ASC.Index[ChPtr[ChNum]] - $A0;
            i := sams[a];
            if i < 0 then
              if NSams < 31 then
              begin
                Inc(NSams);
                i := NSams;
                sams[a] := i
              end;
            if i < 0 then i := 0;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample := i
          end;
        $C0..$DF:
          begin
            a := ASC.Index[ChPtr[ChNum]] - $C0;
            i := orns[a];
            if i < 0 then
              if NOrns < 16 then
              begin
                Inc(NOrns);
                i := NOrns;
                orns[a] := i
              end;
            if i < 0 then i := 0;
            PrevOrn[ChNum] := i;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := i;
            if VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope = 0 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15
          end;
        $E0:
          begin
            if PatVol[ChNum] <> 15 then
            begin
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := 15;
              PatVol[ChNum] := 15
            end;
            Vol[ChNum] := 15;
            PrevVol[ChNum] := 15;
            EnvEn[ChNum] := True
          end;
        $E1..$EF:
          begin
            i := ASC.Index[ChPtr[ChNum]] - $E0;
            if PatVol[ChNum] <> i then
            begin
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := i;
              PatVol[ChNum] := i
            end;
            Vol[ChNum] := i;
            PrevVol[ChNum] := i;
            if EnvEn[ChNum] then
            begin
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament :=
                PrevOrn[ChNum];
              EnvEn[ChNum] := False
            end
          end;
        $F0:
          begin
            Inc(ChPtr[ChNum]);
            Ns := ASC.Index[ChPtr[ChNum]]
          end;
        $F1:
          Initialization_Of_Sample_Disabled := True;
        $F2:
//       Initialization_Of_Ornament_Disabled := True
          ;
        $F3:
          begin
            Initialization_Of_Sample_Disabled := True;
//        Initialization_Of_Ornament_Disabled := True
          end;
        $F4:
          begin
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 11;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := ASC.Index[ChPtr[ChNum]]
          end;
        $F5:
          begin
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 2;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Delay := 1;
            TSAdd[ChNum] := ASC.Index[ChPtr[ChNum]] * 16;
            TSCnt[ChNum] := -1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := ASC.Index[ChPtr[ChNum]]
          end;
        $F6:
          begin
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Delay := 1;
            TSAdd[ChNum] := -ASC.Index[ChPtr[ChNum]] * 16;
            TSCnt[ChNum] := -1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := ASC.Index[ChPtr[ChNum]]
          end;
        $F7:
          begin
            Initialization_Of_Sample_Disabled := True;
            CalcSlide
          end;
        $F8:
          EnvT := 8;
        $F9:
          CalcSlide;
        $FA:
          EnvT := 10;
        $FB:
          begin
            Inc(ChPtr[ChNum]);
            Volume_Counter[ChNum] := ASC.Index[ChPtr[ChNum]];
            if Volume_Counter[ChNum] and 32 <> 0 then
              Volume_Counter[ChNum] :=
                shortint(byte(Volume_Counter[ChNum]) or (128 + 64));
            VCDop[ChNum] := 0
          end;
        $FC:
          EnvT := 12;
        $FE:
          EnvT := 14
      end;
      Inc(ChPtr[ChNum])
    until False;
    SkipCounter[ChNum] := Skip[ChNum]
  end;

var
  i, j, k, Pos, n, l, jl, nb, tmp, zo: Integer;
  quit: boolean;
begin
  Result := True;
  if ASC.ASC1_PatternsPointers - ASC.ASC1_Number_Of_Positions = 72 then
  begin
    SetLength(VTM.Title, 20);
    Move(ASC.Index[ASC.ASC1_PatternsPointers - 44], VTM.Title[1], 20);
    VTM.Title := TrimRight(VTM.Title);
    SetLength(VTM.Author, 20);
    Move(ASC.Index[ASC.ASC1_PatternsPointers - 20], VTM.Author[1], 20);
    VTM.Author := TrimRight(VTM.Author)
  end
  else
  begin
    VTM.Title := '';
    VTM.Author := ''
  end;
  VTM.Ton_Table := 1;
  VTM.Initial_Delay := ASC.ASC1_Delay;
  CDelay := ASC.ASC1_Delay;
  VTM.Positions.Loop := ASC.ASC1_LoopingPosition;
  for i := 0 to 255 do
    VTM.Positions.Value[i] := 0;
  for i := 0 to 15 do
    VTM.Ornaments[i] := nil;
  for i := 1 to 31 do
    VTM.Samples[i] := nil;
  for i := 0 to MaxPatNum do
    VTM.Patterns[i] := nil;
  for i := 0 to 31 do
    orns[i] := -1;
  for i := 0 to 31 do
    sams[i] := -1;

  for k := 0 to 2 do
  begin
    TSCnt[k] := 0;
    TS[k] := 0;
    Volume_Counter[k] := 0;
    PrevNote[k] := 0;
    Vol[k] := 0;
    PrevVol[k] := 0
  end;
  EnvT := 0;

  NOrns := 0;
  NSams := 0;
  Pos := 0;
  while Pos < ASC.ASC1_Number_Of_Positions do
  begin
    j := ASC.Index[Pos + 9];
    VTM.Positions.Value[Pos] := j;
    Inc(Pos);
    if VTM.Patterns[j] = nil then
    begin
      NewPattern(VTM.Patterns[j]);
      for k := 0 to 2 do
      begin
        EnvEn[k] := False;
        PatVol[k] := 0;
        PrevOrn[k] := 0;
        SkipCounter[k] := 0;
        Skip[k] := 0
      end;
      Move(WordPtr(@ASC.Index[ASC.ASC1_PatternsPointers + 6 * j])^, ChPtr, 6);
      Inc(ChPtr[0], ASC.ASC1_PatternsPointers);
      Inc(ChPtr[1], ASC.ASC1_PatternsPointers);
      Inc(ChPtr[2], ASC.ASC1_PatternsPointers);
      Ns := 0; i := 0; quit := False;
      while (i < MaxPatLen) and not quit do
      begin
        if CDelay = 0 then CDelay := 256;
        for k := 0 to 2 do
          if Volume_Counter[k] <> 0 then
            if Volume_Counter[k] > 0 then
            begin
              n := (CDelay + VCDop[k]) div Volume_Counter[k];
              VCDop[k] := (CDelay + VCDop[k]) mod Volume_Counter[k];
              Inc(n, PrevVol[k]);
              if n > 15 then n := 15;
              if n <> PrevVol[k] then
              begin
                VTM.Patterns[j].Items[i].Channel[k].Volume := n;
                PrevVol[k] := n
              end
            end
            else
            begin
              n := (CDelay + VCDop[k]) div (-Volume_Counter[k]);
              VCDop[k] := (CDelay + VCDop[k]) mod (-Volume_Counter[k]);
              n := PrevVol[k] - n;
              if n < 0 then n := 0;
              if n <> PrevVol[k] then
              begin
                VTM.Patterns[j].Items[i].Channel[k].Volume := n;
                if n <> 0 then
                  PrevVol[k] := n
              end
            end;
        for k := 0 to 2 do
        begin
          Dec(SkipCounter[k]);
          if SkipCounter[k] < 0 then
          begin
            if (k = 0) and (ASC.Index[ChPtr[0]] = 255) then
            begin
              Dec(i);
              quit := True;
              break
            end;
            PatternInterpreter(j, i, k)
          end;
          for l := 0 to CDelay - 1 do
            if TSCnt[k] <> 0 then
            begin
              if TSCnt[k] > 0 then Dec(TSCnt[k]);
              Dec(TS[k], TSAdd[k])
            end;
        end;
        VTM.Patterns[j].Items[i].Noise := Ns;
        Inc(i)
      end;
      VTM.Patterns[j].Length := i
    end
  end;
  VTM.Positions.Length := Pos;
  if VTM.Positions.Loop >= Pos then
    VTM.Positions.Loop := Pos - 1;

  zo := 0;
  for i := 0 to 31 do
  begin
    l := orns[i];
    if (l > 0) and (l <= High(VTM.Ornaments)) then
    begin
      j := WordPtr(@ASC.Index[i * 2 + ASC.ASC1_OrnamentsPointers])^ +
        ASC.ASC1_OrnamentsPointers;
      jl := j;
      k := 0;
      nb := 0;
      n := 0;
      repeat
        j := jl;
        repeat
          tmp := n;
          Inc(n, shortint(ASC.Index[j + 1]));
          if (n < -$55) or (n > $55) then break;
          if shortint(ASC.Index[j]) < 0 then
          begin
            nb := tmp;
            jl := j
          end;
          Inc(k);
          Inc(j, 2);
          if k = MaxOrnLen then break;
        until ASC.Index[j - 2] and 64 <> 0;
      until (k = MaxOrnLen) or (n = nb) or (n < -$55) or (n > $55);
      if (k = 1) and (n = 0) then
      begin
        zo := l;
        orns[i] := -1;
        break
      end
    end
  end;

  if zo = 0 then
  begin
    if NOrns = 16 then
    begin
      for i := 0 to 31 do
        if orns[i] = 16 then
        begin
          orns[i] := -1;
          break;
        end;
      for i := 0 to MaxPatNum do
        if VTM.Patterns[i] <> nil then
          for j := 0 to VTM.Patterns[i].Length - 1 do
            for k := 0 to 2 do
              if VTM.Patterns[i].Items[j].Channel[k].Ornament = 16 then
                VTM.Patterns[i].Items[j].Channel[k].Ornament := 0;
    end;
  end
  else
  begin
    for i := 0 to 31 do
      if orns[i] > zo then
        Dec(orns[i]);
    for i := 0 to MaxPatNum do
      if VTM.Patterns[i] <> nil then
        for j := 0 to VTM.Patterns[i].Length - 1 do
          for k := 0 to 2 do
            if VTM.Patterns[i].Items[j].Channel[k].Ornament > zo then
              Dec(VTM.Patterns[i].Items[j].Channel[k].Ornament)
            else if VTM.Patterns[i].Items[j].Channel[k].Ornament = zo then
              VTM.Patterns[i].Items[j].Channel[k].Ornament := 0;
  end;

  for i := 0 to 31 do
  begin
    l := orns[i];
    if (l > 0) and (l <= High(VTM.Ornaments)) then
    begin
      New(VTM.Ornaments[l]);
      VTM.Ornaments[l].Loop := 0;
      j := WordPtr(@ASC.Index[i * 2 + ASC.ASC1_OrnamentsPointers])^ +
        ASC.ASC1_OrnamentsPointers;
      jl := j;
      k := 0;
      nb := 0;
      n := 0;
      repeat
        j := jl;
        repeat
          tmp := n;
          Inc(n, shortint(ASC.Index[j + 1]));
          if (n < -$55) or (n > $55) then break;
          if shortint(ASC.Index[j]) < 0 then
          begin
            VTM.Ornaments[l].Loop := k;
            nb := tmp;
            jl := j;
          end;
          Inc(k);
          VTM.Ornaments[l].Items[k - 1] := n;
          Inc(j, 2);
          if k = MaxOrnLen then break;
        until ASC.Index[j - 2] and 64 <> 0;
      until (k = MaxOrnLen) or (n = nb) or (n < -$55) or (n > $55);
      VTM.Ornaments[l].Length := k;
    end;
  end;

  for i := 0 to 31 do
  begin
    l := sams[i];
    if (l > 0) and (l <= High(VTM.Samples)) then
    begin
      New(VTM.Samples[l]);
      VTM.Samples[l].Loop := 0;
      j := WordPtr(@ASC.Index[i * 2 + ASC.ASC1_SamplesPointers])^ +
        ASC.ASC1_SamplesPointers;
      k := 0;
      repeat
        if shortint(ASC.Index[j]) < 0 then
          VTM.Samples[l].Loop := k;
        VTM.Samples[l].Items[k] := EmptySampleTick;
        VTM.Samples[l].Items[k].Ton_Accumulation := True;
        VTM.Samples[l].Items[k].Add_to_Ton := shortint(ASC.Index[j + 1]);
        VTM.Samples[l].Items[k].Mixer_Ton := ASC.Index[j + 2] and 1 = 0;
        VTM.Samples[l].Items[k].Mixer_Noise := ASC.Index[j + 2] and 8 = 0;
        VTM.Samples[l].Items[k].Envelope_Enabled := ASC.Index[j + 2] and 6 = 2;
        if ASC.Index[j + 2] and 6 = 4 then
        begin
          VTM.Samples[l].Items[k].Amplitude_Sliding := True;
          VTM.Samples[l].Items[k].Amplitude_Slide_Up := False
        end
        else if ASC.Index[j + 2] and 6 = 6 then
        begin
          VTM.Samples[l].Items[k].Amplitude_Sliding := True;
          VTM.Samples[l].Items[k].Amplitude_Slide_Up := True
        end;
        VTM.Samples[l].Items[k].Amplitude := ASC.Index[j + 2] shr 4;
        VTM.Samples[l].Items[k].Envelope_or_Noise_Accumulation := True;
        if VTM.Samples[l].Items[k].Envelope_Enabled or
          VTM.Samples[l].Items[k].Mixer_Noise then
          VTM.Samples[l].Items[k].Add_to_Envelope_or_Noise :=
            shortint(ASC.Index[j] shl 3) div 8;
        Inc(k);
        Inc(j, 3);
        if k = MaxSamLen then break;
      until ASC.Index[j - 3] and (64 + 32) <> 0;
      if (ASC.Index[j - 3] and (64 + 32) = 32) and (k < MaxSamLen) then
      begin
        VTM.Samples[l].Loop := k;
        Inc(k);
        VTM.Samples[l].Items[k - 1] := EmptySampleTick;
      end;
      VTM.Samples[l].Length := k;
    end;
  end;
end;

function PSC2VTM(PSC: PSpeccyModule; VTM: PModule): boolean;
type
  TPatPtrs = packed array[0..2] of word;
var
  ChPtr: TPatPtrs;
  SkipCounter: array[0..2] of byte;
  orns, sams: array[0..31] of integer;
  NOrns, NSams, NsC, NsB: integer;
  EnvEn, EnvSet, NtSet: array[0..2] of boolean;
  EnvT, EnvP, CDelay: integer;
  OrnSet, OrnUsed, PrevVol, PrevVol1, InitVol: array[0..2] of shortint;
  OrnEnabled: array[0..2] of boolean;
  Volume_Counter, VCDop, CurSam: array[0..2] of integer;

  procedure PatternInterpreter(PatNum, LnNum, ChNum: integer);
  var
    quit, VCSet, OrnOff, OrnOn: boolean;
    a, i: integer;
    QuitCounter: Integer;

  begin
    quit := False;
    VCSet := False;
    OrnOn := False;
    OrnOff := False;
    QuitCounter := 0;

    repeat
      Inc(QuitCounter);
      if QuitCounter > 65536*2 then Exit;

      case PSC.Index[ChPtr[ChNum]] of
        $C0..$FF:
          begin
            SkipCounter[ChNum] := PSC.Index[ChPtr[ChNum]] - $BF;
            i := -1;
            if OrnOn then
            begin
              if not OrnEnabled[ChNum] or (OrnSet[ChNum] <> OrnUsed[ChNum]) then
                if OrnSet[ChNum] >= 0 then i := OrnSet[ChNum];
              OrnEnabled[ChNum] := True;
            end;
            if OrnOff and OrnEnabled[ChNum] then
            begin
              i := 0;
              OrnEnabled[ChNum] := False;
            end;
            if i >= 0 then
            begin
              OrnUsed[ChNum] := i;
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := i;
              if VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope = 0 then
              begin
                EnvSet[ChNum] := False;
                VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
              end;
            end;
            quit := True;
          end;
        $A0..$BF:
          begin
            a := PSC.Index[ChPtr[ChNum]] - $A0;
            i := orns[a];
            if i < 0 then
              if NOrns < 16 then
              begin
                Inc(NOrns);
                i := NOrns;
                orns[a] := i
              end;
            if i < 0 then i := 0;
            OrnSet[ChNum] := i;
          end;
        $7E..$9F:
          if PSC.Index[ChPtr[ChNum]] >= $80 then
          begin
            a := PSC.Index[ChPtr[ChNum]] - $80;
            i := sams[a];
            if i < 0 then
              if NSams < 31 then
              begin
                Inc(NSams);
                i := NSams;
                sams[a] := i
              end;
            if i < 0 then i := 0;
            CurSam[ChNum] := a;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample := i;
          end;
        $6B:
          begin
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Delay := 1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := PSC.Index[ChPtr[ChNum]]
          end;
        $6C:
          begin
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 2;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Delay := 1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := PSC.Index[ChPtr[ChNum]]
          end;
        $6D:
          begin
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 3;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Delay := 1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := PSC.Index[ChPtr[ChNum]]
          end;
        $6E:
          begin
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 11;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := PSC.Index[ChPtr[ChNum]];
            CDelay := PSC.Index[ChPtr[ChNum]]
          end;
        $6F:
          begin
            OrnOff := True;
            Inc(ChPtr[ChNum]);
          end;
        $70:
          begin
            VCSet := True;
            Inc(ChPtr[ChNum]);
            Volume_Counter[ChNum] := PSC.Index[ChPtr[ChNum]];
            if Volume_Counter[ChNum] and $40 <> 0 then
              Volume_Counter[ChNum] := shortint(Volume_Counter[ChNum] or 128);
            VCDop[ChNum] := 0;
          end;
        $71:
          begin
//        Break_Ornament_Loop := True; //not available in PT3
            Inc(ChPtr[ChNum]);
          end;
        $7A:
          begin
            Inc(ChPtr[ChNum]);
            if ChNum = 1 then
            begin
              EnvSet[0] := False;
              EnvSet[1] := False;
              EnvSet[2] := False;
              i := PSC.Index[ChPtr[1]] and 15;
              if i = 0 then i := 9
              else if i = 15 then i := 7;
              EnvT := i;
              EnvP := WordPtr(@PSC.Index[ChPtr[1] + 1])^;
              Inc(ChPtr[1], 2)
            end
          end;
        $7B:
          begin
            Inc(ChPtr[ChNum]);
            if ChNum = 1 then
              NsB := PSC.Index[ChPtr[1]] and $1F
          end;
        $7C:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
//      OrnOff := True;
          end;
        $7D:
//       Break_Sample_Loop := True //not available in PT3
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
        $58..$66:
          begin
            i := PSC.Index[ChPtr[ChNum]] - $57;
            InitVol[ChNum] := i;
            if PrevVol[ChNum] <> i then
            begin
              PrevVol[ChNum] := i;
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := i;
            end;
            if EnvEn[ChNum] then
            begin
              EnvSet[ChNum] := False;
              EnvEn[ChNum] := False;
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
              i := 0; if OrnEnabled[ChNum] then i := OrnUsed[ChNum];
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := i;
              OrnUsed[ChNum] := i;
            end;
          end;
        $57:
          begin
            if PrevVol[ChNum] <> 15 then
            begin
              InitVol[ChNum] := 15;
              PrevVol[ChNum] := 15;
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := 15;
            end;
            EnvSet[ChNum] := False;
            EnvEn[ChNum] := True;
          end;
        0..$56:
          begin
            OrnOn := True;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := PSC.Index[ChPtr[ChNum]];
            if InitVol[ChNum] <> PrevVol[ChNum] then
            begin
              PrevVol[ChNum] := InitVol[ChNum];
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := InitVol[ChNum];
            end;
            if not VCSet then Volume_Counter[ChNum] := 0;
            NtSet[ChNum] := True;
          end
      else
        Inc(ChPtr[ChNum]);
      end;
      Inc(ChPtr[ChNum]);
    until quit;
  end;

var
  PSC1_00: boolean;

  function IsNsInSam(sn: integer): boolean;
  var
    j, k: integer;
  begin
    Result := False;
    j := PSC.PSC_SamplesPointers[sn];
    if not PSC1_00 then inc(j, $4C);
    k := 0;
    repeat
      if PSC.Index[j + 4] and 8 = 0 then
      begin
        Result := True;
        exit;
      end;
      Inc(k);
      Inc(j, 6);
      if k = MaxSamLen then break;
    until PSC.Index[j - 2] and (64 + 32) in [0, 32, 64];
  end;

var
  i, j, k, Pos, n, l, jl, nb, tmp, zo, nl, PatMax: Integer;
  pp: word;
  Pats: array[0..MaxPatNum] of TPatPtrs;
begin
  Result := True;
  PSC1_00 := PSC.PSC_MusicName[8] in ['0'..'3'];
  SetLength(VTM.Title, 20);
  Move(PSC.PSC_MusicName[$19], VTM.Title[1], 20);
  VTM.Title := TrimRight(VTM.Title);
  SetLength(VTM.Author, 20);
  Move(PSC.PSC_MusicName[$31], VTM.Author[1], 20);
  VTM.Author := TrimRight(VTM.Author);
  VTM.Ton_Table := 1;
  VTM.Initial_Delay := PSC.PSC_Delay;
  CDelay := PSC.PSC_Delay;
  VTM.Positions.Loop := 0;
  for i := 0 to 255 do
    VTM.Positions.Value[i] := 0;
  for i := 0 to 15 do
    VTM.Ornaments[i] := nil;
  for i := 1 to 31 do
    VTM.Samples[i] := nil;
  for i := 0 to MaxPatNum do
    VTM.Patterns[i] := nil;
  for i := 0 to 31 do
    orns[i] := -1;
  for i := 0 to 31 do
    sams[i] := -1;

  for k := 0 to 2 do
  begin
    Volume_Counter[k] := 0;
    PrevVol[k] := 15;
    InitVol[k] := 15;
    CurSam[k] := 0;
    EnvEn[k] := False;
    OrnUsed[k] := 0;
  end;

  EnvT := 0;
  EnvP := 0;
  NOrns := 0;
  NSams := 0;
  Pos := 0;
  PatMax := 0;
  pp := PSC.PSC_PatternsPointer + 1;
  while Pos < 256 do
  begin
    nl := PSC.Index[pp];
    Inc(pp);
    if nl = 255 then
    begin
      j := WordPtr(@PSC.Index[pp])^;
      i := (j - PSC.PSC_PatternsPointer) div 8;
      if i <= Pos then
        VTM.Positions.Loop := i;
      break
    end;
    if nl > MaxPatLen then nl := MaxPatLen;
    Move(PSC.Index[pp], ChPtr, 6);
    Inc(pp, 7);
    j := PatMax;
    if PatMax > High(Pats) then
      Exit;
    for i := 0 to PatMax - 1 do
      if (Pats[i][0] = ChPtr[0]) and
        (Pats[i][1] = ChPtr[1]) and
        (Pats[i][2] = ChPtr[2]) then
      begin
        j := i;
        break
      end;
    if j = PatMax then
    begin
      Inc(PatMax);
      Pats[j] := ChPtr
    end;
    VTM.Positions.Value[Pos] := j;
    Inc(Pos);
    if VTM.Patterns[j] = nil then
    begin
      NewPattern(VTM.Patterns[j]);
      NsC := 0;
      NsB := 0;
      for k := 0 to 2 do
      begin
        PrevVol1[k] := PrevVol[k];
        PrevVol[k] := 0;
        SkipCounter[k] := 1;
        OrnEnabled[k] := False;
        OrnSet[k] := -1;
      end;
      VTM.Patterns[j].Length := nl;
      i := 0;
      while i < nl do
      begin
        if CDelay = 0 then CDelay := 256;
        for k := 0 to 2 do
          if Volume_Counter[k] <> 0 then
            if Volume_Counter[k] > 0 then
            begin
              n := (CDelay + VCDop[k]) div Volume_Counter[k];
              VCDop[k] := (CDelay + VCDop[k]) mod Volume_Counter[k];
              if PrevVol[k] = 0 then
                Inc(n, PrevVol1[k])
              else
                Inc(n, PrevVol[k]);
              if n > 15 then n := 15;
              if n <> PrevVol[k] then
              begin
                VTM.Patterns[j].Items[i].Channel[k].Volume := n;
                PrevVol[k] := n
              end
            end
            else
            begin
              n := (CDelay + VCDop[k]) div (-Volume_Counter[k]);
              VCDop[k] := (CDelay + VCDop[k]) mod (-Volume_Counter[k]);
              if PrevVol[k] = 0 then
                n := PrevVol1[k] - n
              else
                n := PrevVol[k] - n;
              if n < 0 then n := 0;
              if n <> PrevVol[k] then
              begin
                VTM.Patterns[j].Items[i].Channel[k].Volume := n;
                if n <> 0 then
                  PrevVol[k] := n
              end
            end;
        for k := 0 to 2 do
        begin
          NtSet[k] := False;
          Dec(SkipCounter[k]);
          if SkipCounter[k] = 0 then
            PatternInterpreter(j, i, k)
        end;
        for k := 0 to 2 do
          if EnvEn[k] then
            if (VTM.Patterns[j].Items[i].Channel[k].Envelope = 15) or
              not EnvSet[k] then
            begin
              VTM.Patterns[j].Items[i].Channel[k].Envelope := EnvT;
              VTM.Patterns[j].Items[i].Envelope := EnvP;
              VTM.Patterns[j].Items[i].Channel[k].Ornament := OrnUsed[k];
              EnvSet[k] := True;
            end;
        for k := 2 downto 0 do
          if NtSet[k] and IsNsInSam(CurSam[k]) then
          begin
            NsC := 0;
            break
          end;
        NsC := (NsC + NsB) and $1F;
        VTM.Patterns[j].Items[i].Noise := NsC;
        Inc(i)
      end
    end
  end;
  VTM.Positions.Length := Pos;

  zo := 0;
  for i := 0 to 31 do
  begin
    l := orns[i];
    if (l > 0) and (l <= High(VTM.Ornaments)) then
    begin
      j := WordPtr(@PSC.Index[PSC.PSC_OrnamentsPointer + i * 2])^;
      if not PSC1_00 then inc(j, PSC.PSC_OrnamentsPointer);
      jl := j;
      k := 0;
      nb := 0;
      n := 0;
      repeat
        j := jl;
        repeat
          tmp := n;
          Inc(n, shortint(PSC.Index[j + 1]));
          if (n < -$55) or (n > $55) then break;
          if shortint(PSC.Index[j]) >= 0 then
          begin
            nb := tmp;
            jl := j
          end;
          Inc(k);
          Inc(j, 2);
          if k = MaxOrnLen then break;
        until PSC.Index[j - 2] and (64 + 32) in [0, 32, 64];
        if PSC.Index[j - 2] and (64 + 32) = 64 then break;
      until (k = MaxOrnLen) or (n = nb) or (n < -$55) or (n > $55);
      if (k = 1) and (n = 0) then
      begin
        zo := l;
        orns[i] := -1;
        break;
      end
    end
  end;

  if zo = 0 then
  begin
    if NOrns = 16 then
    begin
      for i := 0 to 31 do
        if orns[i] = 16 then
        begin
          orns[i] := -1;
          break;
        end;
      for i := 0 to MaxPatNum do
        if VTM.Patterns[i] <> nil then
          for j := 0 to VTM.Patterns[i].Length - 1 do
            for k := 0 to 2 do
              if VTM.Patterns[i].Items[j].Channel[k].Ornament = 16 then
                VTM.Patterns[i].Items[j].Channel[k].Ornament := 0;
    end;
  end
  else
  begin
    for i := 0 to 31 do
      if orns[i] > zo then
        Dec(orns[i]);
    for i := 0 to MaxPatNum do
      if VTM.Patterns[i] <> nil then
        for j := 0 to VTM.Patterns[i].Length - 1 do
          for k := 0 to 2 do
            if VTM.Patterns[i].Items[j].Channel[k].Ornament > zo then
              Dec(VTM.Patterns[i].Items[j].Channel[k].Ornament)
            else if VTM.Patterns[i].Items[j].Channel[k].Ornament = zo then
              VTM.Patterns[i].Items[j].Channel[k].Ornament := 0;
  end;

  for i := 0 to 31 do
  begin
    l := orns[i];
    if (l > 0) and (l <= High(VTM.Ornaments)) then
    begin
      New(VTM.Ornaments[l]);
      VTM.Ornaments[l].Loop := 0;
      j := WordPtr(@PSC.Index[PSC.PSC_OrnamentsPointer + i * 2])^;
      if not PSC1_00 then inc(j, PSC.PSC_OrnamentsPointer);
      jl := j;
      k := 0;
      nb := 0;
      n := 0;
      repeat
        j := jl;
        repeat
          tmp := n;
          Inc(n, shortint(PSC.Index[j + 1]));
          if (n < -$55) or (n > $55) then break;
          if shortint(PSC.Index[j]) >= 0 then
          begin
            VTM.Ornaments[l].Loop := k;
            nb := tmp;
            jl := j
          end;
          Inc(k);
          VTM.Ornaments[l].Items[k - 1] := n;
          Inc(j, 2);
          if k = MaxOrnLen then break;
        until PSC.Index[j - 2] and (64 + 32) in [0, 32, 64];
        if PSC.Index[j - 2] and (64 + 32) = 64 then
        begin
          VTM.Ornaments[l].Loop := k - 1;
          break;
        end;
      until (k = MaxOrnLen) or (n = nb) or (n < -$55) or (n > $55);
      VTM.Ornaments[l].Length := k;
    end;
  end;

  for i := 0 to 31 do
  begin
    l := sams[i];
    if (l > 0) and (l <= High(VTM.Samples)) then
    begin
      New(VTM.Samples[l]);
      VTM.Samples[l].Loop := 0;
      j := PSC.PSC_SamplesPointers[i];
      if not PSC1_00 then inc(j, $4C);
      k := 0;
      repeat
        if shortint(PSC.Index[j + 4]) >= 0 then
          VTM.Samples[l].Loop := k;
        VTM.Samples[l].Items[k] := EmptySampleTick;
        VTM.Samples[l].Items[k].Ton_Accumulation := True;
        VTM.Samples[l].Items[k].Add_to_Ton := WordPtr(@PSC.Index[j])^;
        VTM.Samples[l].Items[k].Mixer_Ton := PSC.Index[j + 4] and 1 = 0;
        VTM.Samples[l].Items[k].Mixer_Noise := PSC.Index[j + 4] and 8 = 0;
        VTM.Samples[l].Items[k].Envelope_Enabled := PSC.Index[j + 4] and 16 = 0;
        if PSC.Index[j + 4] and (2 + 4) = 2 then
        begin
          VTM.Samples[l].Items[k].Amplitude_Sliding := True;
          VTM.Samples[l].Items[k].Amplitude_Slide_Up := True
        end
        else if PSC.Index[j + 4] and (2 + 4) = 4 then
        begin
          VTM.Samples[l].Items[k].Amplitude_Sliding := True;
          VTM.Samples[l].Items[k].Amplitude_Slide_Up := False
        end;
        VTM.Samples[l].Items[k].Amplitude := PSC.Index[j + 3] and 15;
        VTM.Samples[l].Items[k].Envelope_or_Noise_Accumulation := True;
        if VTM.Samples[l].Items[k].Envelope_Enabled or
          VTM.Samples[l].Items[k].Mixer_Noise then
          VTM.Samples[l].Items[k].Add_to_Envelope_or_Noise :=
            shortint(PSC.Index[j + 2]);
        Inc(k);
        Inc(j, 6);
        if k = MaxSamLen then break;
      until PSC.Index[j - 2] and (64 + 32) in [0, 32, 64];
      if (PSC.Index[j - 2] and (64 + 32) = 64) and (k < MaxSamLen) then
      begin
        VTM.Samples[l].Loop := k;
        Inc(k);
        VTM.Samples[l].Items[k - 1] := EmptySampleTick;
      end;
      VTM.Samples[l].Length := k;
    end;
  end;
end;

procedure PrepareZXModule(ZXP: PSpeccyModule; var FType: Available_Types; Length: integer);
var
  i, j, k, i1, i2: integer;
  pwrd: WordPtr;
begin
  case FType of
    FLSFile:
      begin
        i := ZXP.FLS_OrnamentsPointer - 16;
        if i >= 0 then
          repeat
            i2 := ZXP.FLS_SamplesPointer + 2 - i;
            if (i2 >= 8) and (i2 < Length) then
            begin
              pwrd := @ZXP.Index[i2];
              i1 := pwrd^ - i;
              if (i1 >= 8) and (i1 < Length) then
              begin
                pwrd := @ZXP.Index[i2 - 4];
                i2 := pwrd^ - i;
                if (i2 >= 6) and (i2 < Length) then
                  if i1 - i2 = $20 then
                  begin
                    i2 := ZXP.FLS_PatternsPointers[1].PatternB - i;
                    if (i2 > 21) and (i2 < Length) then
                    begin
                      i1 := ZXP.FLS_PatternsPointers[1].PatternA - i;
                      if (i1 > 20) and (i1 < Length) then
                        if ZXP.Index[i1 - 1] = 0 then
                        begin
                          while (i1 < Length) and (ZXP.Index[i1] <> 255) do
                          begin
                            repeat
                              case ZXP.Index[i1] of
                                0..$5F, $80, $81:
                                  begin
                                    Inc(i1);
                                    break
                                  end;
                                $82..$8E:
                                  Inc(i1)
                              end;
                              Inc(i1);
                            until i1 >= Length;
                          end;
                          if i1 + 1 = i2 then break
                        end
                    end
                  end
              end
            end;
            Dec(i)
          until i < 0;
        if i < 0 then
          FType := Unknown
        else
        begin
          pwrd := pointer(ZXP);
          i1 := ZXP.FLS_SamplesPointer - i + integer(pwrd);
          i2 := ZXP.FLS_PositionsPointer - i + integer(pwrd) + 2;
          repeat
            Dec(pwrd^, i);
            Inc(integer(pwrd), 2)
          until i1 = integer(pwrd);
          Inc(integer(pwrd), 2);
          repeat
            Dec(pwrd^, i);
            Inc(integer(pwrd), 4)
          until i2 = integer(pwrd)
        end
      end;
    SQTFile:
      begin
        i := ZXP.SQT_SamplesPointer - 10;
        j := 0;
        k := ZXP.SQT_PositionsPointer - i;
        while ZXP.Index[k] <> 0 do
        begin
          if j < ZXP.Index[k] and $7F then
            j := ZXP.Index[k] and $7F;
          Inc(k, 2);
          if j < ZXP.Index[k] and $7F then
            j := ZXP.Index[k] and $7F;
          Inc(k, 2);
          if j < ZXP.Index[k] and $7F then
            j := ZXP.Index[k] and $7F;
          Inc(k, 3)
        end;
        pwrd := @ZXP.SQT_SamplesPointer;
        for k := 1 to (ZXP.SQT_PatternsPointer - i + j shl 1) div 2 do
        begin
          Dec(pwrd^, i);
          Inc(integer(pwrd), 2)
        end
      end
  end;
end;

function LoadAndDetect;
type
  TStr4 = array[0..3] of char;

  function GetTSType(TS: TStr4): Available_Types;
  const
    STC = $21435453;
    ASC = $21435341;
    STP = $21505453;
    PSC = $21435350;
    FLS = $21534C46;
    FTC = $21435446;
    PT1 = $21315450;
    PT2 = $21325450;
    PT3 = $21335450;
    SQT = $21545153;
    GTR = $21525447;
    PSM = $214D5350;
  begin
    Result := Unknown;
    case PLongWord(@TS)^ of
      STC: Result := STCFile;
      ASC: Result := ASCFile;
      STP: Result := STPFile;
      PSC: Result := PSCFile;
      FLS: Result := FLSFile;
      FTC: Result := FTCFile;
      PT1: Result := PT1File;
      PT2: Result := PT2File;
      PT3: Result := PT3File;
      SQT: Result := SQTFile;
      GTR: Result := GTRFile;
      PSM: Result := PSMFile;
    end;
  end;

var
  i, CurPos, Offset: integer;
  f: file;
  s: string;
  AYFileHeader: TAYFileHeader;
  SongStructure: TSongStructure;
  Ch: char;
  Byt: byte;
  Wrd: word;
  TSData: packed record
    Type1: TStr4; Size1: word;
    Type2: TStr4; Size2: word;
    TSID: TStr4;
  end;
begin
  Result := Unknown; FType2 := Unknown;
  s := LowerCase(ExtractFileExt(FileName));
  if s = '.pt2' then
    Result := PT2File
  else if s = '.pt1' then
    Result := PT1File
  else if s = '.stc' then
    Result := STCFile
  else if s = '.stp' then
    Result := STPFile
  else if s = '.sqt' then
    Result := SQTFile
  else if s = '.asc' then
    Result := ASCFile
  else if s = '.psc' then
    Result := PSCFile
  else if s = '.fls' then
    Result := FLSFile
  else if s = '.gtr' then
    Result := GTRFile
  else if s = '.ftc' then
    Result := FTCFile
  else if (s = '.fxm') or (s = '.ay') then
    Result := FXMFile
  else if s = '.psm' then
    Result := PSMFile
  else if s = '.pt3' then
    Result := PT3File
  else
    exit;
  FillChar(ZXP^, 65536, 0);
  AssignFile(f, FileName);
  Reset(f, 1);
  Length := 65536;
  try
    if Result <> FXMFile then
    begin
      if FileSize(f) <= SizeOf(TSData) then
      begin
        Result := Unknown;
        exit;
      end;
      Seek(f, FileSize(f) - SizeOf(TSData));
      BlockRead(f, TSData, 16);
      if TSData.TSID = '02TS' then
      begin
        Result := GetTSType(TSData.Type1); if Result = Unknown then exit;
        Length := TSData.Size1;
        FType2 := GetTSType(TSData.Type2);
        TSSize2 := TSData.Size2;
      end;
      Seek(f, 0);
      BlockRead(f, ZXP^, Length, Length);
    end
    else
      if s = '.fxm' then
      begin
        Tm := 0;
        Andsix := 31;
        SongName := ''; AuthorName := '';
        Seek(f, 4);
        BlockRead(f, ZXAddr, 2, i);
        if i <> 2 then
        begin
          Result := Unknown;
          exit
        end;
        BlockRead(f, ZXP.Index[ZXAddr], 65536 - ZXAddr, Length)
      end
      else
      begin
        Result := Unknown;
        BlockRead(f, AYFileHeader, SizeOf(AYFileHeader));
        if AYFileHeader.FileID <> $5941585A then exit;
        if AYFileHeader.TypeID <> $44414D41 then exit;
        Seek(f, SmallInt(IntelWord(AYFileHeader.PAuthor)) + 12);
        AuthorName := '';
        repeat
          BlockRead(f, Ch, 1);
          if Ch <> #0 then AuthorName := AuthorName + Ch;
        until Ch = #0;
        AuthorName := Trim(AuthorName);
        if System.Length(AuthorName) > 32 then SetLength(AuthorName, 32);

        Seek(f, SmallInt(IntelWord(AYFileHeader.PSongsStructure)) + 18);
   //only first module
        BlockRead(f, SongStructure, 4);
        CurPos := FilePos(f);
        Seek(f, SmallInt(IntelWord(SongStructure.PSongName)) + CurPos - 4);
        SongName := '';
        repeat
          BlockRead(f, Ch, 1);
          if Ch <> #0 then SongName := SongName + Ch;
        until Ch = #0;
        SongName := Trim(SongName);
        if System.Length(SongName) > 32 then SetLength(SongName, 32);
        Offset := SmallInt(IntelWord(SongStructure.PSongData)) + CurPos - 2;
        Seek(f, Offset);
        BlockRead(f, ZXAddr, 2);
        ZXAddr := IntelWord(ZXAddr);
        BlockRead(f, Andsix, 1);
        BlockRead(f, Byt, 1);
        BlockRead(f, Wrd, 2);
        Tm := Byt * IntelWord(Wrd);
        Seek(f, Offset + 14);
        BlockRead(f, ZXP.Index[ZXAddr], 65536 - ZXAddr, Length);
        Result := FXMFile
      end
  finally
    CloseFile(f);
  end;
  PrepareZXModule(ZXP, Result, Length);
end;

function FLS2VTM(FLS: PSpeccyModule; VTM: PModule): boolean;
var
  ChPtr: packed array[0..2] of word;
  Skip, SkipCounter: array[0..2] of shortint;
  IsOrnament: array[1..15] of boolean;
  IsSample: array[1..16] of boolean;
  Orn2Sam: array[1..15] of byte;
  CSam, COrn: array[0..2] of byte;

  procedure PatternInterpreter(PatNum, LnNum, ChNum: integer);
  var
    quit: boolean;
    i: integer;
  begin
    quit := False;
    repeat
      case FLS.Index[ChPtr[ChNum]] of
        0..$5F:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note :=
              FLS.Index[ChPtr[ChNum]];
            quit := True
          end;
        $60..$6F:
          begin
            i := FLS.Index[ChPtr[ChNum]] - $5F;
            CSam[ChNum] := i;
            IsSample[i] := True;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample := i
          end;
        $70:
          begin
            COrn[ChNum] := 0;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := 0
          end;
        $71..$7F:
          begin
            i := FLS.Index[ChPtr[ChNum]] - $70;
            COrn[ChNum] := i;
            IsOrnament[i] := True;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := i
          end;
        $80:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
            quit := True
          end;
        $81:
          quit := True;
        $82..$8E:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope :=
              FLS.Index[ChPtr[ChNum]] - $80;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := 0;
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Envelope := FLS.Index[ChPtr[ChNum]]
          end
      else
        Skip[ChNum] := FLS.Index[ChPtr[ChNum]] - $A1
      end;
      Inc(ChPtr[ChNum])
    until quit;
    if (COrn[ChNum] > 0) and (Orn2Sam[COrn[ChNum]] = 0) then
      Orn2Sam[COrn[ChNum]] := CSam[ChNum];
    SkipCounter[ChNum] := Skip[ChNum]
  end;

var
  i, j, k, l, Pos: integer;
  quit: boolean;
begin
  Result := True;
  VTM.Title := '';
  VTM.Author := '';
  VTM.Ton_Table := 1;
  VTM.Initial_Delay := FLS.Index[FLS.FLS_PositionsPointer];
  VTM.Positions.Loop := 0;
  for i := 0 to 15 do
    VTM.Ornaments[i] := nil;
  for i := 1 to 15 do
  begin
    IsOrnament[i] := False;
    Orn2Sam[i] := 0
  end;
  for i := 1 to 31 do
    VTM.Samples[i] := nil;
  for i := 1 to 16 do
    IsSample[i] := False;
  for i := 0 to MaxPatNum do
    VTM.Patterns[i] := nil;

  for k := 0 to 2 do
  begin
    CSam[k] := 0;
    COrn[k] := 0
  end;
  Pos := 0;
  while (Pos < 256) and (FLS.Index[Pos + FLS.FLS_PositionsPointer + 1] <> 0) do
  begin
    j := FLS.Index[Pos + FLS.FLS_PositionsPointer + 1];
    VTM.Positions.Value[Pos] := j;
    Inc(Pos);
    if VTM.Patterns[j] = nil then
    begin
      NewPattern(VTM.Patterns[j]);
      for k := 0 to 2 do
      begin
        SkipCounter[k] := 0;
        Skip[k] := 0
      end;
      Move(FLS.FLS_PatternsPointers[j], ChPtr, 6);
      i := 0; quit := False;
      while (i < MaxPatLen) and not quit do
      begin
        for k := 0 to 2 do
        begin
          Dec(SkipCounter[k]);
          if SkipCounter[k] < 0 then
          begin
            if (k = 0) and (FLS.Index[ChPtr[0]] = 255) then
            begin
              Dec(i);
              quit := True;
              break
            end;
            PatternInterpreter(j, i, k)
          end
        end;
        Inc(i)
      end;
      VTM.Patterns[j].Length := i
    end
  end;
  VTM.Positions.Length := Pos;

  for i := 1 to 15 do
  begin
    if IsOrnament[i] then
    begin
      New(VTM.Ornaments[i]);
      k := Orn2Sam[i] - 1;
      j := FLS.FLS_SamplesPointer + k * 4;
      l := 0;
      if k >= 0 then
        l := FLS.Index[j];
      if l = 0 then
      begin
        VTM.Ornaments[i].Loop := 0;
        VTM.Ornaments[i].Length := 32
      end
      else
      begin
        VTM.Ornaments[i].Loop := l - 1;
        if VTM.Ornaments[i].Loop > 31 then VTM.Ornaments[i].Loop := 31;
        VTM.Ornaments[i].Length := l - 1 + FLS.Index[j + 1];
        if VTM.Ornaments[i].Length > 32 then VTM.Ornaments[i].Length := 32;
        if VTM.Ornaments[i].Length = 0 then Inc(VTM.Ornaments[i].Length);
        if VTM.Ornaments[i].Loop >= VTM.Ornaments[i].Length then
          VTM.Ornaments[i].Loop := VTM.Ornaments[i].Length - 1;
        l := VTM.Ornaments[i].Loop + 1;
        if VTM.Ornaments[i].Length < 32 then
        begin
          Inc(VTM.Ornaments[i].Length, 33 - l);
          VTM.Ornaments[i].Loop := 32
        end
      end;
      j := WordPtr(@FLS.Index[FLS.FLS_OrnamentsPointer + (i - 1) * 2])^;
      for k := 0 to 31 do
        VTM.Ornaments[i].Items[k] := FLS.Index[j + k];
      for k := 32 to VTM.Ornaments[i].Length - 1 do
        VTM.Ornaments[i].Items[k] := VTM.Ornaments[i].Items[k + l - 33]
    end
  end;

  for i := 1 to 16 do
    if IsSample[i] then
    begin
      New(VTM.Samples[i]);
      j := FLS.FLS_SamplesPointer + (i - 1) * 4;
      l := FLS.Index[j];
      if l = 0 then
      begin
        VTM.Samples[i].Length := 33;
        VTM.Samples[i].Loop := 32
      end
      else
      begin
        VTM.Samples[i].Loop := l - 1;
        if VTM.Samples[i].Loop > 31 then VTM.Samples[i].Loop := 31;
        VTM.Samples[i].Length := l - 1 + FLS.Index[j + 1];
        if VTM.Samples[i].Length > 32 then VTM.Samples[i].Length := 32;
        if VTM.Samples[i].Length = 0 then Inc(VTM.Samples[i].Length);
        if VTM.Samples[i].Loop >= VTM.Samples[i].Length then
          VTM.Samples[i].Loop := VTM.Samples[j].Length - 1;
        l := VTM.Samples[i].Loop + 1;
        if VTM.Samples[i].Length < 32 then
        begin
          Inc(VTM.Samples[i].Length, 33 - l);
          VTM.Samples[i].Loop := 32
        end
      end;
      j := WordPtr(@FLS.Index[j + 2])^;
      for k := 0 to 31 do
      begin
        VTM.Samples[i].Items[k] := EmptySampleTick;
        VTM.Samples[i].Items[k].Amplitude := FLS.Index[j + k * 3] and 15;
        VTM.Samples[i].Items[k].Mixer_Noise :=
          shortint(FLS.Index[j + k * 3 + 1]) >= 0;
        if VTM.Samples[i].Items[k].Mixer_Noise then
        begin
          VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise :=
            FLS.Index[j + k * 3 + 1] and $1F;
          if VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise and $10 <> 0 then
            VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise :=
              VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise or shortint($F0)
        end;
        VTM.Samples[i].Items[k].Mixer_Ton :=
          FLS.Index[j + k * 3 + 1] and 64 = 0;
        VTM.Samples[i].Items[k].Add_to_Ton :=
          word(FLS.Index[j + k * 3] and $F0) shl 4 + FLS.Index[j + k * 3 + 2];
        if FLS.Index[j + k * 3 + 1] and 32 = 0 then
          VTM.Samples[i].Items[k].Add_to_Ton :=
            -VTM.Samples[i].Items[k].Add_to_Ton;
        VTM.Samples[i].Items[k].Envelope_Enabled := True
      end;
      if l = 0 then
        VTM.Samples[i].Items[32] := EmptySampleTick
      else for k := 32 to VTM.Samples[i].Length - 1 do
          VTM.Samples[i].Items[k] := VTM.Samples[i].Items[k + l - 33]
    end
end;

function PT12VTM(PT1: PSpeccyModule; VTM: PModule): boolean;
var
  ChPtr: packed array[0..2] of word;
  Skip, SkipCounter: array[0..2] of shortint;
  IsOrnament: array[1..15] of boolean;
  IsSample: array[1..16] of boolean;
  Orn2Sam: array[1..15] of byte;
  CSam, COrn: array[0..2] of byte;

  procedure PatternInterpreter(PatNum, LnNum, ChNum: integer);
  var
    quit: boolean;
    i: integer;
  begin
    quit := False;
    repeat
      case PT1.Index[ChPtr[ChNum]] of
        0..$5F:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note :=
              PT1.Index[ChPtr[ChNum]];
            quit := True
          end;
        $60..$6F:
          begin
            i := PT1.Index[ChPtr[ChNum]] - $5F;
            CSam[ChNum] := i;
            IsSample[i] := True;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample := i
          end;
        $70..$7F:
          begin
            i := PT1.Index[ChPtr[ChNum]] - $70;
            COrn[ChNum] := i;
            if i > 0 then
              IsOrnament[i] := True;
            if VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope = 0 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := i
          end;
        $80:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
            quit := True
          end;
        $81:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := COrn[ChNum]
          end;
        $82..$8F:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope :=
              PT1.Index[ChPtr[ChNum]] - $81;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := COrn[ChNum];
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Envelope :=
              WordPtr(@PT1.Index[ChPtr[ChNum]])^;
            Inc(ChPtr[ChNum])
          end;
        $90:
          quit := True;
        $91..$A0:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Number := 11;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Parameter := PT1.Index[ChPtr[ChNum]] - $91;
          end;
        $A1..$B0:
          begin
            i := PT1.Index[ChPtr[ChNum]] - $A1;
            if i = 0 then Inc(i);
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := i
          end
      else
        Skip[ChNum] := PT1.Index[ChPtr[ChNum]] - $B1
      end;
      Inc(ChPtr[ChNum])
    until quit;
    if (COrn[ChNum] > 0) and (Orn2Sam[COrn[ChNum]] = 0) then
      Orn2Sam[COrn[ChNum]] := CSam[ChNum];
    SkipCounter[ChNum] := Skip[ChNum]
  end;

var
  i, j, k, Pos: integer;
  quit: boolean;
begin
  Result := True;
  SetLength(VTM.Title, 30);
  Move(PT1.PT1_MusicName, VTM.Title[1], 30);
  VTM.Title := TrimRight(VTM.Title);
  VTM.Author := '';
  VTM.Ton_Table := 1;
  VTM.Initial_Delay := PT1.PT1_Delay;
  VTM.Positions.Loop := PT1.PT1_LoopPosition;
  for i := 0 to 15 do
    VTM.Ornaments[i] := nil;
  for i := 1 to 15 do
  begin
    IsOrnament[i] := False;
    Orn2Sam[i] := 0
  end;
  for i := 1 to 31 do
    VTM.Samples[i] := nil;
  for i := 1 to 16 do
    IsSample[i] := False;
  for i := 0 to MaxPatNum do
    VTM.Patterns[i] := nil;

  for k := 0 to 2 do
  begin
    CSam[k] := 0;
    COrn[k] := 0
  end;
  Pos := 0;
  while Pos < PT1.PT1_NumberOfPositions do
  begin
    j := PT1.PT1_PositionList[Pos];
    VTM.Positions.Value[Pos] := j;
    Inc(Pos);
    if VTM.Patterns[j] = nil then
    begin
      NewPattern(VTM.Patterns[j]);
      for k := 0 to 2 do
      begin
        SkipCounter[k] := 0;
        Skip[k] := 0
      end;
      Move(PT1.Index[PT1.PT1_PatternsPointer + j * 6], ChPtr, 6);
      i := 0; quit := False;
      while (i < MaxPatLen) and not quit do
      begin
        for k := 0 to 2 do
        begin
          Dec(SkipCounter[k]);
          if SkipCounter[k] < 0 then
          begin
            if (k = 0) and (PT1.Index[ChPtr[0]] = 255) then
            begin
              Dec(i);
              quit := True;
              break
            end;
            PatternInterpreter(j, i, k)
          end
        end;
        Inc(i)
      end;
      VTM.Patterns[j].Length := i
    end
  end;
  VTM.Positions.Length := Pos;

  for i := 1 to 15 do
  begin
    if IsOrnament[i] then
    begin
      New(VTM.Ornaments[i]);
      k := Orn2Sam[i] - 1;
      if k < 0 then
      begin
        VTM.Ornaments[i].Loop := 0;
        VTM.Ornaments[i].Length := 32
      end
      else
      begin
        j := PT1.PT1_SamplesPointers[k];
        VTM.Ornaments[i].Length := PT1.Index[j];
        VTM.Ornaments[i].Loop := PT1.Index[j + 1];
      end;
      j := PT1.PT1_OrnamentsPointers[i];
      for k := 0 to VTM.Ornaments[i].Length - 1 do
        VTM.Ornaments[i].Items[k] := PT1.Index[j + k]
    end
  end;

  for i := 1 to 16 do
    if IsSample[i] then
    begin
      j := PT1.PT1_SamplesPointers[i - 1];
      if (PT1.Index[j] > MaxSamLen) or (PT1.Index[j + 1] > MaxSamLen-1) then
        Continue;

      New(VTM.Samples[i]);  
      VTM.Samples[i].Length := PT1.Index[j];
      VTM.Samples[i].Loop := PT1.Index[j + 1];
      Inc(j, 2);
      for k := 0 to VTM.Samples[i].Length - 1 do
      begin
        VTM.Samples[i].Items[k] := EmptySampleTick;
        VTM.Samples[i].Items[k].Add_to_Ton :=
          word(PT1.Index[j + k * 3] and $F0) shl 4 + PT1.Index[j + k * 3 + 2];
        if PT1.Index[j + k * 3 + 1] and 32 = 0 then
          VTM.Samples[i].Items[k].Add_to_Ton :=
            -VTM.Samples[i].Items[k].Add_to_Ton;
        VTM.Samples[i].Items[k].Amplitude := PT1.Index[j + k * 3] and 15;
        VTM.Samples[i].Items[k].Mixer_Noise :=
          shortint(PT1.Index[j + k * 3 + 1]) >= 0;
        if VTM.Samples[i].Items[k].Mixer_Noise then
        begin
          VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise :=
            PT1.Index[j + k * 3 + 1] and $1F;
          if VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise and $10 <> 0 then
            VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise :=
              VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise or shortint($F0)
        end;
        VTM.Samples[i].Items[k].Mixer_Ton :=
          PT1.Index[j + k * 3 + 1] and 64 = 0;
        VTM.Samples[i].Items[k].Envelope_Enabled := True;
      end;
    end;
end;

function GTR2VTM(GTR: PSpeccyModule; VTM: PModule): boolean;
var
  ChPtr: packed array[0..2] of word;
  SkipCounter: array[0..2] of shortint;
  IsOrnament: array[1..15] of boolean;
  IsSample: array[1..16] of boolean;
  COrn: array[0..2] of byte;
  EnvEn: array[0..2] of boolean;
  EnvT: integer;

  procedure PatternInterpreter(PatNum, LnNum, ChNum: integer);
  var
    i: integer;
  begin
    SkipCounter[ChNum] := 0;
    repeat
      case GTR.Index[ChPtr[ChNum]] of
        0..$5F:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note :=
              GTR.Index[ChPtr[ChNum]];
            Inc(ChPtr[ChNum]);
            exit
          end;
        $60..$6F:
          begin
            i := GTR.Index[ChPtr[ChNum]] - $5F;
            IsSample[i] := True;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample := i
          end;
        $70..$7F:
          begin
            i := GTR.Index[ChPtr[ChNum]] - $70;
            COrn[ChNum] := i;
            if i > 0 then
              IsOrnament[i] := True;
            if EnvEn[ChNum] and (GTR.GTR_ID[3] = #$10) then
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := EnvT
            else
            begin
              EnvEn[ChNum] := False;
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15
            end;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := i
          end;
        $80..$BF:
          SkipCounter[ChNum] := GTR.Index[ChPtr[ChNum]] - $80;
        $C0..$CF:
          begin
            EnvEn[ChNum] := True;
            i := GTR.Index[ChPtr[ChNum]] - $C0;
            if i = 0 then i := 9
            else if i = 15 then i := 7;
            EnvT := i;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := i;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := COrn[ChNum];
                //вероятно, в GTR 1.x это ошибка, поскольку судя по всему с
                //огибающими должен быть нулевой орнамент
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Envelope := GTR.Index[ChPtr[ChNum]]
          end;
        $D0..$DF:
          begin
            Inc(ChPtr[ChNum]);
            exit
          end;
        $E0:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
            if GTR.GTR_ID[3] <> #$10 then
            begin
              Inc(ChPtr[ChNum]);
              exit
            end
          end;
        $E1..$EF:
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume :=
            GTR.Index[ChPtr[ChNum]] - $E0
      end;
      Inc(ChPtr[ChNum])
    until False
  end;

var
  i, j, k, Pos: integer;
  quit: boolean;
begin
  Result := True;
  SetLength(VTM.Title, 32);
  Move(GTR.GTR_Name, VTM.Title[1], 32);
  VTM.Title := TrimRight(VTM.Title);
  VTM.Author := '';
  VTM.Ton_Table := 1;
  VTM.Initial_Delay := GTR.GTR_Delay;
  VTM.Positions.Loop := GTR.GTR_LoopPosition;
  for i := 0 to 15 do
    VTM.Ornaments[i] := nil;
  for i := 1 to 15 do
    IsOrnament[i] := False;
  for i := 1 to 31 do
    VTM.Samples[i] := nil;
  for i := 1 to 16 do
    IsSample[i] := False;
  for i := 0 to MaxPatNum do
    VTM.Patterns[i] := nil;

  Pos := 0;
  while Pos < GTR.GTR_NumberOfPositions do
  begin
    j := GTR.GTR_Positions[Pos] div 6;
    VTM.Positions.Value[Pos] := j;
    Inc(Pos);
    if VTM.Patterns[j] = nil then
    begin
      NewPattern(VTM.Patterns[j]);
      for k := 0 to 2 do
      begin
        COrn[k] := 0;
        EnvEn[k] := False;
        EnvT := 15;
        SkipCounter[k] := 0
      end;
      Move(GTR.GTR_PatternsPointers[j], ChPtr, 6);
      i := 0; quit := False;
      while (i < MaxPatLen) and not quit do
      begin
        for k := 0 to 2 do
        begin
          Dec(SkipCounter[k]);
          if SkipCounter[k] < 0 then
          begin
            if (k = 0) and (GTR.Index[ChPtr[0]] = 255) then
            begin
              Dec(i);
              quit := True;
              break
            end;
            PatternInterpreter(j, i, k)
          end
        end;
        Inc(i)
      end;
      VTM.Patterns[j].Length := i
    end
  end;
  VTM.Positions.Length := Pos;

  for i := 1 to 15 do
  begin
    if IsOrnament[i] then
    begin
      New(VTM.Ornaments[i]);
      j := GTR.GTR_OrnamentsPointers[i];
      VTM.Ornaments[i].Loop := GTR.Index[j];
      VTM.Ornaments[i].Length := GTR.Index[j + 1];
      Inc(j, 2);
      for k := 0 to VTM.Ornaments[i].Length - 1 do
        VTM.Ornaments[i].Items[k] := GTR.Index[j + k]
    end
  end;

  for i := 1 to 16 do
    if IsSample[i] then
    begin
      j := GTR.GTR_SamplesPointers[i - 1];

      if (GTR.Index[j] div 4 > MaxSamLen-1) or (GTR.Index[j + 1] div 4 > MaxSamLen) then
        Continue;

      New(VTM.Samples[i]);
      VTM.Samples[i].Loop := GTR.Index[j] div 4;
      VTM.Samples[i].Length := GTR.Index[j + 1] div 4;
      Inc(j, 2);
      for k := 0 to VTM.Samples[i].Length - 1 do
      begin
        VTM.Samples[i].Items[k] := EmptySampleTick;
        VTM.Samples[i].Items[k].Add_to_Ton := WordPtr(@GTR.Index[j + k * 4 + 2])^;
        VTM.Samples[i].Items[k].Mixer_Noise :=
          shortint(GTR.Index[j + k * 4 + 1]) and 64 = 0;
        if VTM.Samples[i].Items[k].Mixer_Noise then
        begin
          VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise :=
            GTR.Index[j + k * 4 + 1] and $1F;
          if VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise and $10 <> 0 then
            VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise :=
              VTM.Samples[i].Items[k].Add_to_Envelope_or_Noise or shortint($F0)
        end;
        VTM.Samples[i].Items[k].Amplitude := GTR.Index[j + k * 4] and 15;
        VTM.Samples[i].Items[k].Mixer_Ton :=
          GTR.Index[j + k * 4 + 1] and 32 = 0;
        VTM.Samples[i].Items[k].Envelope_Enabled :=
          shortint(GTR.Index[j + k * 4 + 1]) < 0
      end
    end
end;

function FTC2VTM(FTC: PSpeccyModule; VTM: PModule): boolean;
type
  TFTCPat = record
    Numb, Trans: integer;
  end;
var
  ChPtr: packed array[0..2] of word;
  SkipCounter, PrevOrn, TSStep: array[0..2] of shortint;
  sams: array[0..31] of integer;
  orns: array[0..32] of integer;
  NOrns, NSams, Ns: integer;
  CPat: TFTCPat;

  procedure PatternInterpreter(PatNum, LnNum, ChNum: integer);
  var
    quit: boolean;
    ExxAF: shortint;
    a, i: integer;
    nt: byte;
    QuitCounter: Integer;
  begin
    quit := False;
    EXXAF := 2;
    QuitCounter := 0;
    repeat
      Inc(QuitCounter);
      if QuitCounter > 65536*2 then Exit;
      
      case FTC.Index[ChPtr[ChNum]] of
        0..$1F:
          begin
            a := FTC.Index[ChPtr[ChNum]];
            i := sams[a];
            if i < 0 then
              if NSams < 31 then
              begin
                Inc(NSams);
                i := NSams;
                sams[a] := i
              end;
            if i < 0 then i := 0;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample := i
          end;
        $20..$2F:
          begin
            i := FTC.Index[ChPtr[ChNum]] - $20;
            if i = 0 then i := 1;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := i
          end;
        $30:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
            SkipCounter[ChNum] := 0;
            quit := True
          end;
        $31..$3E:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope :=
              FTC.Index[ChPtr[ChNum]] - $30;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament :=
              PrevOrn[ChNum];
            Inc(ChPtr[ChNum]);
            VTM.Patterns[PatNum].Items[LnNum].Envelope :=
              WordPtr(@FTC.Index[ChPtr[ChNum]])^;
            Inc(ChPtr[ChNum])
          end;
        $3F:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament :=
              PrevOrn[ChNum];
          end;
        $40..$5F:
          begin
            SkipCounter[ChNum] := FTC.Index[ChPtr[ChNum]] - $40;
            EXXAF := 1;
            quit := True
          end;
        $60..$CB:
          begin
            nt := FTC.Index[ChPtr[ChNum]] + CPat.Trans - $60;
            if nt > $5F then nt := $5F;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := nt;
            SkipCounter[ChNum] := 0;
            quit := True
          end;
        $CC..$EC:
          begin
            a := FTC.Index[ChPtr[ChNum]] - $CC;
            i := orns[a];
            if i < 0 then
              if NOrns < 16 then
              begin
                Inc(NOrns);
                i := NOrns;
                orns[a] := i
              end;
            if i < 0 then i := 0;
            PrevOrn[ChNum] := i;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := i;
            if VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope = 0 then
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15
          end;
        $ED:
          begin
            EXXAF := 1;
            Inc(ChPtr[ChNum]);
            i := smallint(WordPtr(@FTC.Index[ChPtr[ChNum]])^);
            if i >= 0 then
            begin
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                Additional_Command.Number := 1;
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                Additional_Command.Parameter := i and 255
            end
            else
            begin
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                Additional_Command.Number := 2;
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
                Additional_Command.Parameter := (-i) and 255
            end;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
              Additional_Command.Delay := 1;
            Inc(ChPtr[ChNum])
          end;
        $EE:
          begin
            EXXAF := 0;
            Inc(ChPtr[ChNum]);
            TSStep[ChNum] := FTC.Index[ChPtr[ChNum]]
          end;
        $EF:
          begin
            Inc(ChPtr[ChNum]);
            Ns := FTC.Index[ChPtr[ChNum]]
          end
      else
        begin
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
            Additional_Command.Number := 11;
          Inc(ChPtr[ChNum]);
          VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
            Additional_Command.Parameter := FTC.Index[ChPtr[ChNum]]
        end
      end;
      Inc(ChPtr[ChNum])
    until quit;
    if exxaf = 0 then
    begin
      VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
        Additional_Command.Number := 3;
      VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
        Additional_Command.Delay := 1;
      VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].
        Additional_Command.Parameter := TSStep[ChNum]
    end
  end;

var
  i, j, k, Pos, n, l, jl, len, nb, tmp, zo, PatMax: Integer;
  quit: boolean;
  Pats: array[0..MaxPatNum] of TFTCPat;
begin
  Result := True;
  SetLength(VTM.Title, 42);
  Move(FTC.FTC_MusicName[8], VTM.Title[1], 42);

  // Detect FTC version
  if (FTC.Index[$32] <> $3b) and (FTC.Index[$32] < 4) then
    VTM.Ton_Table := FTC.Index[$32]
  else
    VTM.Ton_Table := 1;

  VTM.Title := Trim(VTM.Title);
  if Length(VTM.Title) > 32 then
  begin
    VTM.Author := Copy(VTM.Title, 33, Length(VTM.Title) - 32);
    SetLength(VTM.Title, 32)
  end
  else
    VTM.Author := '';
    
  VTM.Initial_Delay := FTC.FTC_Delay;
  VTM.Positions.Loop := FTC.FTC_Loop_Position;
  for i := 0 to 255 do
    VTM.Positions.Value[i] := 0;
  for i := 0 to 15 do
    VTM.Ornaments[i] := nil;
  for i := 1 to 31 do
    VTM.Samples[i] := nil;
  for i := 0 to MaxPatNum do
    VTM.Patterns[i] := nil;
  for i := 0 to 32 do
    orns[i] := -1;
  for i := 0 to 31 do
    sams[i] := -1;

  NOrns := 0;
  NSams := 0;
  PatMax := 0;
  Pos := 0;
  while (Pos < 256) and (FTC.FTC_Positions[Pos].Pattern <> 255) do
  begin
    CPat.Numb := FTC.FTC_Positions[Pos].Pattern;
    CPat.Trans := FTC.FTC_Positions[Pos].Transposition;
    j := PatMax;
    for i := 0 to PatMax - 1 do
      if (Pats[i].Numb = CPat.Numb) and
        (Pats[i].Trans = CPat.Trans) then
      begin
        j := i;
        break
      end;
    if j = PatMax then
    begin
      Inc(PatMax);
      Pats[j] := CPat
    end;
    VTM.Positions.Value[Pos] := j;
    Inc(Pos);
    if VTM.Patterns[j] = nil then
    begin
      NewPattern(VTM.Patterns[j]);
      for k := 0 to 2 do
      begin
        TSStep[k] := 0;
        PrevOrn[k] := 0;
        SkipCounter[k] := 0
      end;
      Move(FTC.Index[FTC.FTC_PatternsPointer + 6 * CPat.Numb], ChPtr, 6);
      Ns := 0; i := 0; quit := False;
      while (i < MaxPatLen) and not quit do
      begin
        for k := 0 to 2 do
        begin
          Dec(SkipCounter[k]);
          if SkipCounter[k] < 0 then
          begin
            if (k = 0) and (FTC.Index[ChPtr[0]] = 255) then
            begin
              Dec(i);
              quit := True;
              break
            end;
            PatternInterpreter(j, i, k)
          end
        end;
        if i >= 0 then
          VTM.Patterns[j].Items[i].Noise := Ns;
        Inc(i)
      end;
      VTM.Patterns[j].Length := i
    end
  end;
  VTM.Positions.Length := Pos;
  if VTM.Positions.Loop >= Pos then
    VTM.Positions.Loop := Pos - 1;

  zo := 0;
  for i := 0 to 32 do
  begin
    l := orns[i];
    if (l > 0) and (l <= High(VTM.Ornaments)) then
    begin
      j := FTC.FTC_OrnamentsPointers[i] + 3;
      jl := j + FTC.Index[j - 2] * 2;
      len := j + (FTC.Index[j - 1] + 1) * 2;
      k := 0;
      nb := 0;
      n := 0;
      repeat
        repeat
          tmp := n;
          if FTC.Index[j] and 64 <> 0 then
          begin
            Inc(n, shortint(FTC.Index[j + 1]));
            if (n < -$5F) or (n > $5F) then break
          end
          else
            n := FTC.Index[j + 1];
          if j = jl then
            nb := tmp;
          Inc(k);
          Inc(j, 2);
          if k = MaxOrnLen then break;
        until j >= len;
        j := jl;
      until (k = MaxOrnLen) or (n = nb) or (n < -$5F) or (n > $5F);
      if (k = 1) and (n = 0) then
      begin
        zo := l;
        orns[i] := -1;
        break;
      end;
    end;
  end;

  if zo = 0 then
  begin
    if NOrns = 16 then
    begin
      for i := 0 to 32 do
        if orns[i] = 16 then
        begin
          orns[i] := -1;
          break
        end;
      for i := 0 to MaxPatNum do
        if VTM.Patterns[i] <> nil then
          for j := 0 to VTM.Patterns[i].Length - 1 do
            for k := 0 to 2 do
              if VTM.Patterns[i].Items[j].Channel[k].Ornament = 16 then
                VTM.Patterns[i].Items[j].Channel[k].Ornament := 0
    end
  end
  else
  begin
    for i := 0 to 32 do
      if orns[i] > zo then
        Dec(orns[i]);
    for i := 0 to MaxPatNum do
      if VTM.Patterns[i] <> nil then
        for j := 0 to VTM.Patterns[i].Length - 1 do
          for k := 0 to 2 do
            if VTM.Patterns[i].Items[j].Channel[k].Ornament > zo then
              Dec(VTM.Patterns[i].Items[j].Channel[k].Ornament)
            else if VTM.Patterns[i].Items[j].Channel[k].Ornament = zo then
              VTM.Patterns[i].Items[j].Channel[k].Ornament := 0
  end;

  for i := 0 to 32 do
  begin
    l := orns[i];
    if (l > 0) and (l <= High(VTM.Ornaments)) then
    begin
      New(VTM.Ornaments[l]);
      VTM.Ornaments[l].Loop := 0;
      j := FTC.FTC_OrnamentsPointers[i] + 3;
      jl := j + FTC.Index[j - 2] * 2;
      len := j + (FTC.Index[j - 1] + 1) * 2;
      k := 0;
      nb := 0;
      n := 0;
      repeat
        repeat
          tmp := n;
          if FTC.Index[j] and 64 <> 0 then
          begin
            Inc(n, shortint(FTC.Index[j + 1]));
            if (n < -$5F) or (n > $5F) then break
          end
          else
            n := FTC.Index[j + 1];
          if j = jl then
          begin
            VTM.Ornaments[l].Loop := k;
            nb := tmp
          end;
          Inc(k);
          VTM.Ornaments[l].Items[k - 1] := n;
          Inc(j, 2);
          if k = MaxOrnLen then break;
        until j >= len;
        j := jl;
      until (k = MaxOrnLen) or (n = nb) or (n < -$5F) or (n > $5F);
      VTM.Ornaments[l].Length := k;
    end;
  end;

  for i := 0 to 31 do
  begin
    l := sams[i];
    if (l > 0) and (l <= High(VTM.Samples)) then
    begin
      j := FTC.FTC_SamplesPointers[i] + 3;

      if (FTC.Index[j - 2] > MaxSamLen-1) or (FTC.Index[j - 1] + 1 > MaxSamLen) then
        Continue;

      New(VTM.Samples[l]);
      VTM.Samples[l].Loop := FTC.Index[j - 2];
      VTM.Samples[l].Length := FTC.Index[j - 1] + 1;

      for k := 0 to VTM.Samples[l].Length - 1 do
      begin
        VTM.Samples[l].Items[k] := EmptySampleTick;
        VTM.Samples[l].Items[k].Mixer_Noise := FTC.Index[j + k * 5] and 64 = 0;
        if VTM.Samples[l].Items[k].Mixer_Noise then
        begin
          VTM.Samples[l].Items[k].Add_to_Envelope_or_Noise :=
            FTC.Index[j + k * 5] and 31;
          if VTM.Samples[l].Items[k].Add_to_Envelope_or_Noise and $10 <> 0 then
            VTM.Samples[l].Items[k].Add_to_Envelope_or_Noise :=
              VTM.Samples[l].Items[k].Add_to_Envelope_or_Noise or shortint($F0);
          VTM.Samples[l].Items[k].Envelope_or_Noise_Accumulation :=
            shortint(FTC.Index[j + k * 5]) < 0
        end;
        VTM.Samples[l].Items[k].Add_to_Ton :=
          WordPtr(@FTC.Index[j + k * 5 + 1])^ and $FFF;
        if VTM.Samples[l].Items[k].Add_to_Ton and $800 <> 0 then
          VTM.Samples[l].Items[k].Add_to_Ton :=
            VTM.Samples[l].Items[k].Add_to_Ton or smallint($F000);
        VTM.Samples[l].Items[k].Ton_Accumulation :=
          shortint(FTC.Index[j + k * 5 + 2]) < 0;
        VTM.Samples[l].Items[k].Mixer_Ton := FTC.Index[j + k * 5 + 2] and 64 = 0;
        if FTC.Index[j + k * 5 + 3] and 32 <> 0 then
        begin
          VTM.Samples[l].Items[k].Amplitude_Sliding := True;
          VTM.Samples[l].Items[k].Amplitude_Slide_Up :=
            FTC.Index[j + k * 5 + 3] and 16 = 0
        end;
        VTM.Samples[l].Items[k].Amplitude := FTC.Index[j + k * 5 + 3] and 15;
        VTM.Samples[l].Items[k].Envelope_Enabled :=
          FTC.Index[j + k * 5 + 3] and 64 <> 0;
        if not VTM.Samples[l].Items[k].Mixer_Noise and
          VTM.Samples[l].Items[k].Envelope_Enabled then
        begin
          VTM.Samples[l].Items[k].Envelope_or_Noise_Accumulation :=
            shortint(FTC.Index[j + k * 5 + 3]) < 0;
          VTM.Samples[l].Items[k].Add_to_Envelope_or_Noise :=
            -shortint(FTC.Index[j + k * 5 + 4])
        end
      end
    end
  end
end;

function FXM2VTM;
type
  FXM_Stek = packed array of word;
var
  ChParams: array[0..2] of record
    Address_In_Pattern: word;
    Stek: FXM_Stek;
    Note, PrevNote, Note_Skip_Counter, PrevOrn, PrevSam: byte;
    Transposit: shortint;
    CurTick: integer;
    SamplePointer, OrnamentPointer: word;
    FXM_Mixer: byte;
    b0e, b1e: boolean;
  end;
  Instruments: array of record
    SamplePtr, OrnPtr: word;
    Mixer, SamNum, OrnNum: byte;
  end;
  MaxInstr: integer;

  SkipFreqs: array[1..255] of integer;
  i, j, k, l, ov, tmp, Tick, Delay, CurDelay, DelayCnt, SkipCounter, Pat, Line, Line2, MinSkip, MinChan, VPLen: integer;
  VirtualPattern: array of record
    Noise: byte;
    Envelope: word;
    Channel: array[0..2] of TChannelLine;
  end;

  VirtualSample: array[0..MaxSamLen - 1] of record
    ST: TSampleTick;
    CAddr: word;
  end;
  VirtualOrnament: array[0..MaxOrnLen - 1] of record
    OT: shortint;
    CAddr: word;
  end;

  flg: boolean;
  Noise_Base, Ns: byte;
  SamCnt, SLoop, OLoop, OLen, SLen, Vol, MaxOrn, MaxSam: integer;
  SamAddr, OrnAddr: word;
  Lp, PatSz, NtCorr: integer;

  procedure GetTime;

    function FXM_Loop_Found(j11, j22, j33: word): boolean;
    var
      j1, j2, j3: longword;
      a1, a2, a3: byte;
      f71, f72, f73: boolean;
      f61, f62, f63: boolean;
      fxms1, fxms2, fxms3: array of word;
      k: integer;
      tr: integer;
    begin
      j1 := WordPtr(@FXM.Index[ZXAddr])^;
      j2 := WordPtr(@FXM.Index[ZXAddr + 2])^;
      j3 := WordPtr(@FXM.Index[ZXAddr + 4])^;
      a1 := 1; a2 := 1; a3 := 1;
      f71 := False; f72 := False; f73 := False;
      f61 := False; f62 := False; f63 := False;
      tr := 0;
      repeat
        if (j1 = j11) and (j2 = j22) and (j3 = j33) then
        begin
          Result := True;
          Lp := tr;
          exit
        end;
        Dec(a1);
        if a1 = 0 then
        begin
          f71 := False;
          f61 := False;
          repeat
            case FXM.Index[j1] of
              0..$7F, $8F..$FF:
                begin
                  inc(j1);
                  a1 := FXM.Index[j1];
                  inc(j1);
                  break
                end;
              $80:
                begin
                  j1 := WordPtr(@FXM.Index[j1 + 1])^;
                  f71 := True
                end;
              $81:
                begin
                  k := Length(fxms1);
                  SetLength(fxms1, k + 1);
                  fxms1[k] := j1 + 3;
                  j1 := WordPtr(@FXM.Index[j1 + 1])^
                end;
              $82:
                begin
                  if (j1 = j11) and (j2 = j22) and (j3 = j33) then
                  begin
                    Result := True;
                    Lp := tr;
                    exit
                  end;
                  k := Length(fxms1);
                  SetLength(fxms1, k + 2);
                  inc(j1);
                  fxms1[k] := FXM.Index[j1];
                  inc(j1);
                  fxms1[k + 1] := j1
                end;
              $83:
                begin
                  k := Length(fxms1);
                  dec(fxms1[k - 2]);
                  if fxms1[k - 2] and 255 <> 0 then
                  begin
                    j1 := fxms1[k - 1];
                    f61 := True
                  end
                  else
                  begin
                    SetLength(fxms1, k - 2);
                    inc(j1)
                  end
                end;
              $84, $85, $88, $8D, $8E:
                inc(j1, 2);
              $86, $87, $8C:
                inc(j1, 3);
              $89:
                begin
                  k := Length(fxms1);
                  j1 := fxms1[k - 1];
                  SetLength(fxms1, k - 1)
                end;
              $8A, $8B:
                inc(j1);
            end;
          until False;
        end;
        Dec(a2);
        if a2 = 0 then
        begin
          f72 := False;
          f62 := False;
          repeat
            case FXM.Index[j2] of
              0..$7F, $8F..$FF:
                begin
                  inc(j2);
                  a2 := FXM.Index[j2];
                  inc(j2);
                  break
                end;
              $80:
                begin
                  j2 := WordPtr(@FXM.Index[j2 + 1])^;
                  f72 := True
                end;
              $81:
                begin
                  k := Length(fxms2);
                  SetLength(fxms2, k + 1);
                  fxms2[k] := j2 + 3;
                  j2 := WordPtr(@FXM.Index[j2 + 1])^
                end;
              $82:
                begin
                  if (j1 = j11) and (j2 = j22) and (j3 = j33) then
                  begin
                    Result := True;
                    Lp := tr;
                    exit
                  end;
                  k := Length(fxms2);
                  SetLength(fxms2, k + 2);
                  inc(j2);
                  fxms2[k] := FXM.Index[j2];
                  inc(j2);
                  fxms2[k + 1] := j2
                end;
              $83:
                begin
                  k := Length(fxms2);
                  dec(fxms2[k - 2]);
                  if fxms2[k - 2] and 255 <> 0 then
                  begin
                    j2 := fxms2[k - 1];
                    f62 := True
                  end
                  else
                  begin
                    SetLength(fxms2, k - 2);
                    inc(j2)
                  end
                end;
              $84, $85, $88, $8D, $8E:
                inc(j2, 2);
              $86, $87, $8C:
                inc(j2, 3);
              $89:
                begin
                  k := Length(fxms2);
                  j2 := fxms2[k - 1];
                  SetLength(fxms2, k - 1)
                end;
              $8A, $8B:
                inc(j2)
            end;
          until False;
        end;
        Dec(a3);
        if a3 = 0 then
        begin
          f73 := False;
          f63 := False;
          repeat
            case FXM.Index[j3] of
              0..$7F, $8F..$FF:
                begin
                  inc(j3);
                  a3 := FXM.Index[j3];
                  inc(j3);
                  break
                end;
              $80:
                begin
                  j3 := WordPtr(@FXM.Index[j3 + 1])^;
                  f73 := True
                end;
              $81:
                begin
                  k := Length(fxms3);
                  SetLength(fxms3, k + 1);
                  fxms3[k] := j3 + 3;
                  j3 := WordPtr(@FXM.Index[j3 + 1])^
                end;
              $82:
                begin
                  if (j1 = j11) and (j2 = j22) and (j3 = j33) then
                  begin
                    Result := True;
                    Lp := tr;
                    exit
                  end;
                  k := Length(fxms3);
                  SetLength(fxms3, k + 2);
                  inc(j3);
                  fxms3[k] := FXM.Index[j3];
                  inc(j3);
                  fxms3[k + 1] := j3
                end;
              $83:
                begin
                  k := Length(fxms3);
                  dec(fxms3[k - 2]);
                  if fxms3[k - 2] and 255 <> 0 then
                  begin
                    j3 := fxms3[k - 1];
                    f63 := True
                  end
                  else
                  begin
                    SetLength(fxms3, k - 2);
                    inc(j3)
                  end
                end;
              $84, $85, $88, $8D, $8E:
                inc(j3, 2);
              $86, $87, $8C:
                inc(j3, 3);
              $89:
                begin
                  k := Length(fxms3);
                  j3 := fxms3[k - 1];
                  SetLength(fxms3, k - 1)
                end;
              $8A, $8B:
                inc(j3);
            end;
          until False;
        end;
        inc(tr);
      until ((f71 and (f72 or f62) and (f73 or f63)) or
        ((f71 or f61) and f72 and (f73 or f63)) or
        ((f71 or f61) and (f72 or f62) and f73));
      Result := False
    end;

  var
    j1, j2, j3: longword;
    a1, a2, a3: shortint;
    f71, f72, f73,
      f61, f62, f63: boolean;
    j11, j22, j33: word;
    fxms1, fxms2, fxms3: array of word;

  begin
    with FXM^ do
    begin
      j1 := WordPtr(@Index[ZXAddr])^;
      j2 := WordPtr(@Index[ZXAddr + 2])^;
      j3 := WordPtr(@Index[ZXAddr + 4])^;
      a1 := 1; a2 := 1; a3 := 1;
      f71 := False; f72 := False; f73 := False;
      f61 := False; f62 := False; f63 := False;
      j11 := 0; j22 := 0; j33 := 0;
      repeat
        Dec(a1);
        if a1 = 0 then
        begin
          f71 := False;
          f61 := False;
          repeat
            case Index[j1] of
              0..$7F, $8F..$FF:
                begin
                  Inc(j1);
                  a1 := Index[j1];
                  Inc(j1);
                  break
                end;
              $80:
                begin
                  j1 := WordPtr(@Index[j1 + 1])^;
                  j11 := j1;
                  f71 := True
                end;
              $81:
                begin
                  k := System.Length(fxms1);
                  SetLength(fxms1, k + 1);
                  fxms1[k] := j1 + 3;
                  j1 := WordPtr(@Index[j1 + 1])^
                end;
              $82:
                begin
                  k := System.Length(fxms1);
                  SetLength(fxms1, k + 2);
                  Inc(j1);
                  fxms1[k] := Index[j1];
                  Inc(j1);
                  fxms1[k + 1] := j1
                end;
              $83:
                begin
                  k := System.Length(fxms1);
                  Dec(fxms1[k - 2]);
                  if fxms1[k - 2] and 255 <> 0 then
                  begin
                    j1 := fxms1[k - 1];
                    j11 := j1 - 2;
                    f61 := True
                  end
                  else
                  begin
                    SetLength(fxms1, k - 2);
                    Inc(j1)
                  end
                end;
              $84, $85, $88, $8D, $8E:
                Inc(j1, 2);
              $86, $87, $8C:
                Inc(j1, 3);
              $89:
                begin
                  k := System.Length(fxms1);
                  j1 := fxms1[k - 1];
                  SetLength(fxms1, k - 1)
                end;
              $8A, $8B:
                Inc(j1)
            end;
          until False;
        end;
        Dec(a2);
        if a2 = 0 then
        begin
          f72 := False;
          f62 := False;
          repeat
            case Index[j2] of
              0..$7F, $8F..$FF:
                begin
                  Inc(j2);
                  a2 := Index[j2];
                  Inc(j2);
                  break
                end;
              $80:
                begin
                  j2 := WordPtr(@Index[j2 + 1])^;
                  j22 := j2;
                  f72 := True
                end;
              $81:
                begin
                  k := System.Length(fxms2);
                  SetLength(fxms2, k + 1);
                  fxms2[k] := j2 + 3;
                  j2 := WordPtr(@Index[j2 + 1])^
                end;
              $82:
                begin
                  k := System.Length(fxms2);
                  SetLength(fxms2, k + 2);
                  Inc(j2);
                  fxms2[k] := Index[j2];
                  Inc(j2);
                  fxms2[k + 1] := j2
                end;
              $83:
                begin
                  k := System.Length(fxms2);
                  Dec(fxms2[k - 2]);
                  if fxms2[k - 2] and 255 <> 0 then
                  begin
                    j2 := fxms2[k - 1];
                    j22 := j2 - 2;
                    f62 := True
                  end
                  else
                  begin
                    SetLength(fxms2, k - 2);
                    Inc(j2)
                  end
                end;
              $84, $85, $88, $8D, $8E:
                Inc(j2, 2);
              $86, $87, $8C:
                Inc(j2, 3);
              $89:
                begin
                  k := System.Length(fxms2);
                  j2 := fxms2[k - 1];
                  SetLength(fxms2, k - 1)
                end;
              $8A, $8B:
                Inc(j2)
            end;
          until False;
        end;
        Dec(a3);
        if a3 = 0 then
        begin
          f73 := False;
          f63 := False;
          repeat
            case Index[j3] of
              0..$7F, $8F..$FF:
                begin
                  Inc(j3);
                  a3 := Index[j3];
                  Inc(j3);
                  break
                end;
              $80:
                begin
                  j3 := WordPtr(@Index[j3 + 1])^;
                  j33 := j3;
                  f73 := True
                end;
              $81:
                begin
                  k := System.Length(fxms3);
                  SetLength(fxms3, k + 1);
                  fxms3[k] := j3 + 3;
                  j3 := WordPtr(@Index[j3 + 1])^
                end;
              $82:
                begin
                  k := System.Length(fxms3);
                  SetLength(fxms3, k + 2);
                  Inc(j3);
                  fxms3[k] := Index[j3];
                  Inc(j3);
                  fxms3[k + 1] := j3
                end;
              $83:
                begin
                  k := System.Length(fxms3);
                  Dec(fxms3[k - 2]);
                  if fxms3[k - 2] and 255 <> 0 then
                  begin
                    j3 := fxms3[k - 1];
                    j33 := j3 - 2;
                    f63 := True
                  end
                  else
                  begin
                    SetLength(fxms3, k - 2);
                    Inc(j3)
                  end
                end;
              $84, $85, $88, $8D, $8E:
                Inc(j3, 2);
              $86, $87, $8C:
                Inc(j3, 3);
              $89:
                begin
                  k := System.Length(fxms3);
                  if k <= 0 then Exit;
                  j3 := fxms3[k - 1];
                  SetLength(fxms3, k - 1)
                end;
              $8A, $8B:
                Inc(j3)
            end;
          until False
        end;
        Inc(tm);
        if tm > 180000 then
        begin
          tm := -14999;
          break
        end
      until ((f71 and (f72 or f62) and (f73 or f63)) or
        ((f71 or f61) and f72 and (f73 or f63)) or
        ((f71 or f61) and (f72 or f62) and f73)
        ) and FXM_Loop_Found(j11, j22, j33);
      Dec(tm)
    end

  end;

  function PatternInterpreter(Chan: integer): boolean;
  var
    b: byte;
    i: integer;
  begin
    with ChParams[Chan] do
    begin
      Dec(Note_Skip_Counter);
      if Note_Skip_Counter <> 0 then
      begin
        Result := False;
        exit //GetRegisters(Chan)
      end
      else
        repeat
          with FXM^ do
            case Index[Address_In_Pattern] of
              0..$7F:
                begin
                  if Index[Address_In_Pattern] <> 0 then
                  begin
                    Note := Index[Address_In_Pattern] - 1 + Transposit;
//           if Note > $53 then b := $53 else b := Note;
                    b := Note + NtCorr;
                    if shortint(b) < 0 then b := 0 else
                      if b > 95 then b := 95;
//           Ton := FXM_Table[b];
//           b3e := False
                  end
                  else
                    b := 254;
                  if not b1e or (b = 254) or (PrevNote <> b) then
                  begin
                    PrevNote := b;
                    VirtualPattern[Line].Channel[Chan].Note := b
                  end;
                  Inc(Address_In_Pattern);
                  Note_Skip_Counter := Index[Address_In_Pattern];
                  Inc(Address_In_Pattern);

                  for i := 0 to MaxInstr do
                    with Instruments[i] do
                      if (SamplePtr = SamplePointer) and (OrnPtr = OrnamentPointer) and
                        (Mixer = FXM_Mixer) then
                      begin
                        if SamNum <> PrevSam then
                        begin
                          PrevSam := SamNum;
                          VirtualPattern[Line].Channel[Chan].Sample := SamNum;
                          VirtualPattern[Line].Channel[Chan].Note := b;
                        end;
                        if OrnNum <> PrevOrn then
                        begin
                          PrevOrn := OrnNum;
                          VirtualPattern[Line].Channel[Chan].Ornament := OrnNum;
                          if OrnNum = 0 then VirtualPattern[Line].Channel[Chan].Envelope := 15;
                        end;
                        break;
                      end;


//         Point_In_Ornament := OrnamentPointer;
                  if not b1e then
                  begin
                    b1e := b0e;

{           Point_In_Sample := SamplePointer;
           Volume := Index[Point_In_Sample];
           Inc(Point_In_Sample);
           Sample_Tik_Counter := Index[Point_In_Sample];
           Inc(Point_In_Sample);
           RealGetRegisters(Chan)}
                  end
{         else
          GetRegisters(Chan)};
                  Result := True;
                  exit
                end;
              $80:
                Address_In_Pattern := WordPtr(@Index[Address_In_Pattern + 1])^;
              $81:
                begin
                  i := Length(Stek);
                  SetLength(Stek, i + 1);
                  Stek[i] := Address_In_Pattern + 3;
                  Address_In_Pattern := WordPtr(@Index[Address_In_Pattern + 1])^
                end;
              $82:
                begin
                  i := Length(Stek);
                  SetLength(Stek, i + 2);
                  Inc(Address_In_Pattern);
                  Stek[i] := Index[Address_In_Pattern];
                  Inc(Address_In_Pattern);
                  Stek[i + 1] := Address_In_Pattern
                end;
              $83:
                begin
                  i := Length(Stek);
                  Dec(Stek[i - 2]);
                  if Stek[i - 2] and 255 <> 0 then
                    Address_In_Pattern := Stek[i - 1]
                  else
                  begin
                    SetLength(Stek, i - 2);
                    Inc(Address_In_Pattern)
                  end
                end;
              $84:
                begin
                  Inc(Address_In_Pattern);
                  Noise_Base := Index[Address_In_Pattern];
                  Inc(Address_In_Pattern)
                end;
              $85:
                begin
                  Inc(Address_In_Pattern);
                  FXM_Mixer := Index[Address_In_Pattern] and 9;
                  Inc(Address_In_Pattern)
                end;
              $86:
                begin
                  Inc(Address_In_Pattern);
                  OrnamentPointer := WordPtr(@Index[Address_In_Pattern])^;
                  Inc(Address_In_Pattern, 2)
                end;
              $87:
                begin
                  Inc(Address_In_Pattern);
                  SamplePointer := WordPtr(@Index[Address_In_Pattern])^;
                  Inc(Address_In_Pattern, 2)
                end;
              $88:
                begin
                  Inc(Address_In_Pattern);
                  Transposit := Index[Address_In_Pattern];
                  Inc(Address_In_Pattern)
                end;
              $89:
                begin
                  i := Length(Stek);
                  Address_In_Pattern := Stek[i - 1];
                  SetLength(Stek, i - 1)
                end;
              $8A:
                begin
                  Inc(Address_In_Pattern);
                  b0e := True;
                  b1e := False
                end;
              $8B:
                begin
                  Inc(Address_In_Pattern);
                  b0e := False;
                  b1e := False
                end;
              $8C:
                Inc(Address_In_Pattern, 3);
              $8D:
                begin
                  Inc(Address_In_Pattern);
                  Noise_Base :=
                    (Noise_Base + Index[Address_In_Pattern])
                    and amad_andsix;
                  Inc(Address_In_Pattern)
                end;
              $8E:
                begin
                  Inc(Address_In_Pattern);
                  Transposit := Transposit + Index[Address_In_Pattern];
                  Inc(Address_In_Pattern)
                end;
              $8F:
                begin
                  i := Length(Stek);
                  SetLength(Stek, i + 1);
                  Stek[i] := Transposit;
                  Inc(Address_In_Pattern)
                end;
              $90:
                begin
                  i := Length(Stek);
                  Transposit := Stek[i - 1];
                  SetLength(Stek, i - 1);
                  Inc(Address_In_Pattern)
                end
            else
              Inc(Address_In_Pattern)
            end
        until False
    end
  end;

  procedure ClearPat;
  begin
    NewPattern(VTM.Patterns[Pat]);
    VTM.Patterns[Pat].Length := PatSz;
  end;

begin
  Result := True;

  Lp := 0;
  PatSz := 64;

  if Tm = 0 then GetTime;

  tmp := 0;
  if Tm < 0 then
  begin
    Tm := -Tm;
    tmp := 1
  end;

  for i := 0 to 2 do
    with ChParams[i] do
    begin
      Address_In_Pattern := WordPtr(@FXM.Index[ZXAddr + i * 2])^;
      SetLength(Stek, 0);
      FXM_Mixer := 8;
      Transposit := 0;
      SamplePointer := 0; OrnamentPointer := 0
    end;
  SetLength(Instruments, 1);
  with Instruments[0] do
  begin
    SamplePtr := 0; OrnPtr := 0; Mixer := 8; SamNum := 0; OrnNum := 0
  end;
  MaxInstr := 0;

  for i := 1 to 255 do SkipFreqs[i] := 0;
  NtCorr := -1;
  Tick := 0;
  repeat
    for j := 0 to 2 do
      repeat
        with FXM^, ChParams[j] do
          case Index[Address_In_Pattern] of
            0..$7F:
              begin
                if Index[Address_In_Pattern] - 1 + Transposit = 0 then NtCorr := 0;
                Inc(Address_In_Pattern);
                i := Index[Address_In_Pattern];
                if i <> 0 then inc(SkipFreqs[i]);
                Inc(Address_In_Pattern);

                flg := false;
                for i := 0 to MaxInstr do
                  with Instruments[i] do
                    if (SamplePtr = SamplePointer) and (OrnPtr = OrnamentPointer) and
                      (Mixer = FXM_Mixer) then
                    begin
                      flg := true;
                      break
                    end;
                if not flg then
                begin
                  inc(MaxInstr);
                  SetLength(Instruments, MaxInstr + 1);
                  with Instruments[MaxInstr] do
                  begin
                    SamplePtr := SamplePointer;
                    OrnPtr := OrnamentPointer;
                    Mixer := FXM_Mixer;
                    SamNum := 0;
                    OrnNum := 0
                  end
                end;

                break
              end;
            $80:
              Address_In_Pattern := WordPtr(@Index[Address_In_Pattern + 1])^;
            $81:
              begin
                i := Length(Stek);
                SetLength(Stek, i + 1);
                Stek[i] := Address_In_Pattern + 3;
                Address_In_Pattern := WordPtr(@Index[Address_In_Pattern + 1])^
              end;
            $82:
              begin
                i := Length(Stek);
                SetLength(Stek, i + 2);
                Inc(Address_In_Pattern);
                Stek[i] := Index[Address_In_Pattern];
                Inc(Address_In_Pattern);
                Stek[i + 1] := Address_In_Pattern
              end;
            $83:
              begin
                i := Length(Stek);
                Dec(Stek[i - 2]);
                if Stek[i - 2] and 255 <> 0 then
                  Address_In_Pattern := Stek[i - 1]
                else
                begin
                  SetLength(Stek, i - 2);
                  Inc(Address_In_Pattern)
                end
              end;
            $84:
              begin
                Inc(Address_In_Pattern);
//         PlParams.FXM.Noise_Base := Index[Address_In_Pattern];
                Inc(Address_In_Pattern)
              end;
            $85:
              begin
                Inc(Address_In_Pattern);
                FXM_Mixer := Index[Address_In_Pattern] and 9;
                Inc(Address_In_Pattern)
              end;
            $86:
              begin
                Inc(Address_In_Pattern);
                OrnamentPointer := WordPtr(@Index[Address_In_Pattern])^;
                Inc(Address_In_Pattern, 2)
              end;
            $87:
              begin
                Inc(Address_In_Pattern);
                SamplePointer := WordPtr(@Index[Address_In_Pattern])^;
                Inc(Address_In_Pattern, 2)
              end;
            $88:
              begin
                Inc(Address_In_Pattern);
                Transposit := Index[Address_In_Pattern];
                Inc(Address_In_Pattern)
              end;
            $89:
              begin
                i := Length(Stek);
                Address_In_Pattern := Stek[i - 1];
                SetLength(Stek, i - 1)
              end;
            $8A:
              begin
                Inc(Address_In_Pattern);
//         b0e := True;
//         b1e := False
              end;
            $8B:
              begin
                Inc(Address_In_Pattern);
//         b0e := False;
//         b1e := False
              end;
            $8C:
              Inc(Address_In_Pattern, 3);
            $8D:
              begin
                Inc(Address_In_Pattern);
{         PlParams.FXM.Noise_Base :=
         (PlParams.FXM.Noise_Base + Index[Address_In_Pattern])
                                  and PlParams.FXM.amad_andsix;
 } Inc(Address_In_Pattern)
              end;
            $8E:
              begin
                Inc(Address_In_Pattern);
                Transposit := Transposit + Index[Address_In_Pattern];
                Inc(Address_In_Pattern)
              end;
            $8F:
              begin
                i := Length(Stek);
                SetLength(Stek, i + 1);
                Stek[i] := Transposit;
                Inc(Address_In_Pattern)
              end;
            $90:
              begin
                i := Length(Stek);
                Transposit := Stek[i - 1];
                SetLength(Stek, i - 1);
                Inc(Address_In_Pattern)
              end
          else
            Inc(Address_In_Pattern)
          end
      until False;
    inc(Tick);
  until Tick = Tm;

  Delay := 1;
  Tick := SkipFreqs[1];
  for i := 2 to 255 do
    if SkipFreqs[i] > Tick then
    begin
      Delay := i;
      Tick := SkipFreqs[i]
    end;

  with FXMParams do
  begin
    if tmp = 0 then
    begin
      Edit1.Text := IntToStr(Tm);
      Edit2.Text := IntToStr(Lp)
    end
    else
    begin
      Edit1.Clear;
      Edit2.Clear
    end;
    Edit3.Text := IntToStr(Delay);
    Edit4.Text := IntToStr(PatSz);
    Edit5.Text := IntToStr(NtCorr);
    Edit6.Text := IntToStr(amad_andsix);
    if ShowModal <> 0 then
    begin
      Tm := StrToInt(Trim(Edit1.Text));
      Lp := StrToInt(Trim(Edit2.Text));
      Delay := StrToInt(Trim(Edit3.Text));
      PatSz := StrToInt(Trim(Edit4.Text));
      NtCorr := StrToInt(Trim(Edit5.Text));
      amad_andsix := StrToInt(Trim(Edit6.Text))
    end
  end;



  MaxSam := 0; MaxOrn := 0;
  for i := 1 to MaxInstr do
  begin
    j := 0; flg := false; SamCnt := 1;
    SLoop := 255; OLoop := 255; OLen := 0; SLen := 0;
    Vol := 0; ov := 0;
    tmp := Instruments[i].Mixer;
    SamAddr := Instruments[i].SamplePtr;
    OrnAddr := Instruments[i].OrnPtr;
    while j < MaxSamLen do
    begin
      VirtualSample[j].CAddr := SamAddr;
      VirtualSample[j].ST := EmptySampleTick;
      VirtualSample[j].ST.Ton_Accumulation := True;
      VirtualOrnament[j].CAddr := OrnAddr;
      if SamAddr <> 0 then
      begin
        Dec(SamCnt);
        if SamCnt = 0 then
        begin
          repeat
            with FXM^ do
              case Index[SamAddr] of
                0..$1D:
                  begin
                    Vol := Index[SamAddr];
                    VirtualSample[j].ST.Amplitude := Vol;
                    Inc(SamAddr);
                    SamCnt := Index[SamAddr];
                    Inc(SamAddr);
                    break
                  end;
                $80:
                  begin
                    SamAddr := WordPtr(@Index[SamAddr + 1])^;
                    SLen := j;
                    for k := 0 to j - 1 do
                      if VirtualSample[k].CAddr = SamAddr then
                      begin
                        SLoop := k;
                        break
                      end
                  end
              else
                begin
                  Vol := Index[SamAddr] - $32;
                  VirtualSample[j].ST.Amplitude := Vol;
                  Inc(SamAddr);
                  SamCnt := 1;
                  break
                end;
              end
          until False;
        end
        else
          VirtualSample[j].ST.Amplitude := Vol;
      end
      else
        VirtualSample[j].ST.Amplitude := 0;
      if OrnAddr <> 0 then
      begin
        repeat
          with FXM^ do
            case Index[OrnAddr] of
              $80:
                begin
                  OrnAddr := WordPtr(@Index[OrnAddr + 1])^;
                  OLen := j;
                  for k := 0 to j - 1 do
                    if VirtualOrnament[k].CAddr = OrnAddr then
                    begin
                      OLoop := k;
                      break
                    end
                end;
              $82:
                begin
                  Inc(OrnAddr);
                  flg := True
                end;
              $83:
                begin
                  Inc(OrnAddr);
                  flg := False
                end;
              $84:
                begin
                  Inc(OrnAddr);
                  tmp := tmp xor 9;
                end
            else
              begin
                if flg then
                begin
                  inc(ov, shortint(Index[OrnAddr]));
                  VirtualOrnament[j].OT := ov
                end
                else
                begin
                  VirtualOrnament[j].OT := ov;
                  VirtualSample[j].ST.Add_to_Ton := shortint(Index[OrnAddr])
                end;
                Inc(OrnAddr);
                break
              end
            end;
        until False
      end
      else
      begin
        VirtualOrnament[j].OT := 0;
        VirtualSample[j].ST.Add_to_Ton := 0
      end;
      VirtualSample[j].ST.Mixer_Ton := (tmp and 1) = 0;
      VirtualSample[j].ST.Mixer_Noise := (tmp and 8) = 0;
      inc(j)
    end;
    if SLen = 0 then SLen := MaxSamLen;
    if SLoop = 255 then
    begin
      SLoop := SLen - 1;
      VirtualSample[SLoop].ST.Ton_Accumulation := False;
    end;
    if OLen = 0 then OLen := MaxOrnLen;
    if OLoop = 255 then OLoop := OLen - 1;
    flg := false;
    for j := 0 to OLen - 1 do
      if VirtualOrnament[j].OT <> 0 then
      begin
        flg := true;
        break
      end;
    if flg then
    begin
      flg := false;
      for k := 1 to MaxOrn do
      begin
        flg := (VTM.Ornaments[k].Length = OLen) and
          (VTM.Ornaments[k].Loop = OLoop);
        if flg then
          for j := 0 to OLen - 1 do
          begin
            flg := VTM.Ornaments[k].Items[j] = VirtualOrnament[j].OT;
            if not flg then break
          end;
        if flg then
        begin
          Instruments[i].OrnNum := k;
          break
        end;
      end;
      if not flg and (MaxOrn < 15) then
      begin
        inc(MaxOrn);
        Instruments[i].OrnNum := MaxOrn;
        New(VTM.Ornaments[MaxOrn]);
        VTM.Ornaments[MaxOrn].Loop := OLoop;
        VTM.Ornaments[MaxOrn].Length := OLen;
        for j := 0 to OLen - 1 do
          VTM.Ornaments[MaxOrn].Items[j] := VirtualOrnament[j].OT
      end;
    end;
    flg := false;
    for k := 1 to MaxSam do
    begin
      flg := (VTM.Samples[k].Length = SLen) and
        (VTM.Samples[k].Loop = SLoop);
      if flg then
        for j := 0 to SLen - 1 do
        begin
          flg := (VTM.Samples[k].Items[j].Add_to_Ton = VirtualSample[j].ST.Add_to_Ton) and
            (VTM.Samples[k].Items[j].Amplitude = VirtualSample[j].ST.Amplitude) and
            (VTM.Samples[k].Items[j].Mixer_Ton = VirtualSample[j].ST.Mixer_Ton) and
            (VTM.Samples[k].Items[j].Mixer_Noise = VirtualSample[j].ST.Mixer_Noise);
          if not flg then break
        end;
      if flg then
      begin
        Instruments[i].SamNum := k;
        break
      end;
    end;
    if not flg and (MaxSam < 31) then
    begin
      inc(MaxSam);
      Instruments[i].SamNum := MaxSam;

      if (SLoop > MaxSamLen-1) or (SLen > MaxSamLen) then
        Continue;

      New(VTM.Samples[MaxSam]);
      VTM.Samples[MaxSam].Loop := SLoop;
      VTM.Samples[MaxSam].Length := SLen;
      for j := 0 to SLen - 1 do
        VTM.Samples[MaxSam].Items[j] := VirtualSample[j].ST
    end;
  end;

  VTM.Initial_Delay := Delay;
  VTM.Ton_Table := 1;
  VTM.Title := SongN;
  VTM.Author := AuthN;

  VPLen := Delay * PatSz;

  SetLength(VirtualPattern, VPLen);

  Noise_Base := 0;

  for i := 0 to 2 do
    with ChParams[i] do
    begin
      Address_In_Pattern := WordPtr(@FXM.Index[ZXAddr + i * 2])^;
      Transposit := 0;
      Note_Skip_Counter := 1;
      PrevOrn := 255; PrevSam := 255;
      SamplePointer := 0; OrnamentPointer := 0;
      FXM_Mixer := 8;
      PrevNote := 255;
      b0e := False; b1e := False;
      SetLength(Stek, 0)
    end;

  Pat := -1;
  Line2 := PatSz;
  CurDelay := Delay;
  Tick := 0;

  while Pat < MaxNumOfPats do
  begin
    if Tick >= Tm then
    begin
      VTM.Patterns[Pat].Length := Line2;
      inc(Pat);
      break
    end;
    for i := 0 to VPLen - 1 do
    begin
      VirtualPattern[i].Envelope := 0;
      for j := 0 to 2 do
        VirtualPattern[i].Channel[j] := EmptyChannelLine;
    end;

    Line := 0;
    while Line < VPLen do
    begin
      for j := 0 to 2 do PatternInterpreter(j);
      VirtualPattern[Line].Noise := Noise_Base;
      inc(Line)
    end;

    Line := 0;
    while (Pat < MaxNumOfPats) and (Line < VPLen) and (Tick < Tm) do
    begin
      while Line2 >= PatSz do
      begin
        dec(Line2, PatSz);
        inc(Pat);
        if Pat >= MaxNumOfPats then break;
        ClearPat
      end;
      if (Tick <> 0) and (Line2 <> 0) and (Tick = Lp) then
      begin
        VTM.Patterns[Pat].Length := Line2;
        Line2 := 0;
        inc(Pat);
        if Pat >= MaxNumOfPats then break;
        VTM.Positions.Loop := Pat;
        ClearPat
      end;
      if Pat >= MaxNumOfPats then break;
      for j := 0 to 2 do
        VTM.Patterns[Pat].Items[Line2].Channel[j] := VirtualPattern[Line].Channel[j];
      Ns := VirtualPattern[Line].Noise;
      VTM.Patterns[Pat].Items[Line2].Noise := Ns;
      MinSkip := 0;
      repeat
        inc(Line);
        inc(Tick);
        inc(MinSkip);
        flg := Line >= VPLen;
        if not flg then
          for j := 0 to 2 do if VirtualPattern[Line].Channel[j].Note <> -1 then
            begin
              flg := true;
              break
            end;
        if not flg then
          for j := 0 to 2 do if VirtualPattern[Line].Channel[j].Envelope = 15 then
            begin
              flg := true;
              break
            end;
        if not flg then
          for j := 0 to 2 do if VirtualPattern[Line].Channel[j].Ornament <> 0 then
            begin
              flg := true;
              break
            end;
        if not flg then
          flg := VirtualPattern[Line].Noise <> Ns
      until flg;
      if Delay > MinSkip then
        i := MinSkip
      else
      begin
        i := Tick mod Delay;
        if i = 0 then i := Delay;
        dec(Line, MinSkip - i);
        dec(Tick, MinSkip - i);
      end;
      if (i <> CurDelay) or (Line2 = 0) then
      begin
        CurDelay := i;
        VTM.Patterns[Pat].Items[Line2].Channel[0].Additional_Command.Number := 11;
        VTM.Patterns[Pat].Items[Line2].Channel[0].Additional_Command.Parameter := i
      end;
      inc(Line2)
    end;
  end;

  VTM.Positions.Length := Pat;
  for i := 0 to Pat - 1 do
  begin
    VTM.Positions.Value[i] := i;
  end;

  Result := Delay = 0;

end;

function PSM2VTM;
type
  TPSMPat = record
    Numb, Trans: integer;
  end;
var
  s: string;
  i, j, k: integer;
  wo: word;
  Pos, PatMax: Integer;
  Pats: array[0..MaxPatNum] of TPSMPat;
  Ch: packed record
    Dl: byte;
    Ptr: array[0..2] of word;
  end;
  RetAddress: array[0..2] of word;
  RetCnt, Vol, EnvType, EnvDiv, PrevSam: array[0..2] of byte;
  Nt: array[0..2] of shortint;
  SkipCounter, Skp, OrnTick, Orn, Sam: array[0..2] of shortint;
  MaxSample, MaxOrnament: integer;
  PSMSamples: array[0..14, 0..15] of integer;
  PSMOrnaments: array[0..31] of integer;
  WasEn: array[0..2] of boolean;

  procedure PatternInterpreter(PatNum, LnNum, ChNum: integer);
  var
    quit: boolean;
    PatAddr: word;
    b: byte;
    i: integer;
  begin
    PatAddr := Ch.Ptr[ChNum];
    if RetCnt[ChNum] <> 0 then
    begin
      Dec(RetCnt[ChNum]); if RetCnt[ChNum] = 0 then PatAddr := RetAddress[ChNum];
    end;
    quit := False;
    repeat
      case PSM.Index[PatAddr] of
        0..$5F:
          begin
            if Nt[ChNum] < 0 then
              Nt[ChNum] := Pats[PatNum].Trans + 48 - PSM.Index[PatAddr]
            else
              Dec(Nt[ChNum], PSM.Index[PatAddr]);
            if Nt[ChNum] < 0 then inc(Nt[ChNum], 96);
            b := Nt[ChNum] + 2;
            if shortint(b) < 0 then b := 0 else if b > 95 then b := 95;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := b;
            if OrnTick[ChNum] < 0 then
              OrnTick[ChNum] := OrnTick[ChNum] and $E0
            else
              OrnTick[ChNum] := OrnTick[ChNum] and $C0;
            if (OrnTick[ChNum] and $40 <> 0) and (Orn[ChNum] >= 33) then
            begin
              WasEn[ChNum] := True;
              VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := 15;
              if EnvType[ChNum] >= $B1 then
              begin
                VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := EnvType[ChNum] - $B1 + 8;
                if EnvDiv[ChNum] >= $F1 then
                  VTM.Patterns[PatNum].Items[LnNum].Envelope := word(EnvDiv[ChNum] and 15) shl 8
                else
                  VTM.Patterns[PatNum].Items[LnNum].Envelope := EnvDiv[ChNum];
                OrnTick[ChNum] := OrnTick[ChNum] or $40;
              end
              else
              begin
                b := EnvType[ChNum] - $A1;
                VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := ((b and 3) shl 1) or 8;
                b := (b and 12) * 3 + Nt[ChNum];
                if b >= 48 then
                begin
                  dec(b, 48);
                  if b >= 48 then dec(b, 48);
                end;
                if b > 45 then b := 45;
                VTM.Patterns[PatNum].Items[LnNum].Envelope := PT3NoteTable_ST[b + 48 + 2];
              end;
            end;
            quit := True;
          end;
        $60:
          begin
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note := -2;
            quit := True;
          end;
        $61..$6F:
          Sam[ChNum] := PSM.Index[PatAddr] - $61;
        $70..$8F:
          begin
            Orn[ChNum] := PSM.Index[PatAddr] - $70;
            OrnTick[ChNum] := 0;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            b := PSMOrnaments[Orn[ChNum]];
            if b = 0 then
              if MaxOrnament < 15 then
              begin
                inc(MaxOrnament);
                PSMOrnaments[Orn[ChNum]] := MaxOrnament;
                b := MaxOrnament
              end;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := b
          end;
        $90:
          quit := True;
        $91..$9F:
          begin
            Vol[ChNum] := PSM.Index[PatAddr] - $90;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := Vol[ChNum];
          end;
        $A0:
          begin
            OrnTick[ChNum] := PSM.Index[PatAddr]; //$a0
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := 15;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Ornament := 0
          end;
        $A1..$B0:
          begin
            Orn[ChNum] := 33;
            OrnTick[ChNum] := OrnTick[ChNum] or $40;
            EnvType[ChNum] := PSM.Index[PatAddr];
          end;
        $B1..$B7:
          begin
            WasEn[ChNum] := True;
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := 15;
            EnvType[ChNum] := PSM.Index[PatAddr];
            inc(PatAddr);
            EnvDiv[ChNum] := PSM.Index[PatAddr];
            VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Envelope := EnvType[ChNum] - $B1 + 8;
            if EnvDiv[ChNum] >= $F1 then
              VTM.Patterns[PatNum].Items[LnNum].Envelope := word(EnvDiv[ChNum] and 15) shl 8
            else
              VTM.Patterns[PatNum].Items[LnNum].Envelope := EnvDiv[ChNum];
            OrnTick[ChNum] := OrnTick[ChNum] or $40;
          end;
        $B8..$F8:
          Skp[ChNum] := PSM.Index[PatAddr] - $B7;
        $F9:
          begin
            RetAddress[ChNum] := PatAddr + 3;
            RetCnt[ChNum] := PSM.Index[word(PatAddr + 2)];
            PatAddr := WordPtr(@PSM.Index[PatAddr])^ - 1;
          end;
        $FA..$FB:
          Orn[ChNum] := PSM.Index[PatAddr] - $FA + 32;
      else
        quit := True;
      end;
      inc(PatAddr)
    until quit;
    if Sam[ChNum] >= 0 then
    begin
      b := ord(OrnTick[ChNum] and $40 <> 0) * Vol[ChNum];
      if PSMSamples[Sam[ChNum], b] = 0 then
        if MaxSample < 31 then
        begin
          inc(MaxSample);
          PSMSamples[Sam[ChNum], b] := MaxSample;
        end
        else
          for i := 15 downto 0 do
            if PSMSamples[Sam[ChNum], i] <> 0 then
            begin
              PSMSamples[Sam[ChNum], b] := PSMSamples[Sam[ChNum], i];
              break
            end;
      b := PSMSamples[Sam[ChNum], b];
      if (VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Note <> -1) and
        (PrevSam[ChNum] <> b) then
      begin
        PrevSam[ChNum] := b;
        VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Sample := b
      end
    end;
    if WasEn[ChNum] and (OrnTick[ChNum] and $40 = 0) then
    begin
      WasEn[ChNum] := False;
      VTM.Patterns[PatNum].Items[LnNum].Channel[ChNum].Volume := Vol[ChNum]
    end;
    Ch.Ptr[ChNum] := PatAddr;
    SkipCounter[ChNum] := Skp[ChNum]
  end;

var
  CPat: TPSMPat;
  quit: boolean;
  l, len: integer;
  b0, b1, b2, lc, lp, ls: byte;
  w: word;

begin
  Result := True;

  i := PSM.PSM_PositionsPointer;
  s := '';
  if (i > 8) and (i <= 65536 - 8) then
  begin
    Dec(i, 8);
    SetLength(s, i);
    move(PSM.PSM_Remark, s[1], i);
    if s = 'psm1'#0 then
      s := ''
    else if (i > 5) and (Copy(s, 1, 5) = 'psm1'#0) then
      s := Copy(s, 6, i - 5);
  end;

  s := Trim(s);

  if Length(s) > 32 then
  begin
    VTM.Author := Copy(s, 33, Length(s) - 32);
    SetLength(s, 32);
    if Length(VTM.Author) > 32 then SetLength(VTM.Author, 32);
  end
  else
    VTM.Author := '';

  VTM.Title := s;

  VTM.Ton_Table := 1;
  VTM.Positions.Loop := 0;
  for i := 0 to 255 do
    VTM.Positions.Value[i] := 0;
  for i := 0 to 15 do
    VTM.Ornaments[i] := nil;
  for i := 1 to 31 do
    VTM.Samples[i] := nil;
  MaxSample := 0;
  for i := 0 to 14 do
  begin
    Sam[i] := -1;
    for j := 0 to 15 do
      PSMSamples[i, j] := 0;
  end;
  MaxOrnament := 0;
  for i := 0 to 31 do
    PSMOrnaments[i] := 0;


  for i := 0 to MaxPatNum do
    VTM.Patterns[i] := nil;


  for k := 0 to 2 do
  begin
    Nt[k] := -128;
    Vol[k] := 15
  end;

  PatMax := 0;
  Pos := 0;
  while Pos < 256 do
  begin
    CPat.Numb := PSM.Index[PSM.PSM_PositionsPointer + Pos * 2];
    CPat.Trans := shortint(PSM.Index[PSM.PSM_PositionsPointer + Pos * 2 + 1]);
    if CPat.Numb = 255 then
    begin
      if CPat.Trans <> -1 then VTM.Positions.Loop := byte(CPat.Trans);
      break;
    end;
    j := PatMax;
    if PatMax > MaxPatNum then Exit;
    for i := 0 to PatMax - 1 do
      if (Pats[i].Numb = CPat.Numb) and
        (Pats[i].Trans = CPat.Trans) then
      begin
        j := i;
        break
      end;
    if j = PatMax then
    begin
      Inc(PatMax);
      Pats[j] := CPat
    end;
    VTM.Positions.Value[Pos] := j;
    Inc(Pos);
    if VTM.Patterns[j] = nil then
    begin
      NewPattern(VTM.Patterns[j]);
      for k := 0 to 2 do
      begin
        WasEn[k] := False;
        PrevSam[k] := 0;
        RetCnt[k] := 0;
        Nt[k] := byte(Nt[k]) or 128;
        SkipCounter[k] := 1
      end;
      Move(PSM.Index[PSM.PSM_PatternsPointer + CPat.Numb * 7], Ch, 7);
      if Pos = 1 then VTM.Initial_Delay := Ch.Dl;
      i := 0; quit := False;
      while (i < MaxPatLen) and not quit do
      begin
        for k := 2 downto 0 do
        begin
          Dec(SkipCounter[k]);
          if SkipCounter[k] = 0 then
          begin
            if (k = 2) and (PSM.Index[Ch.Ptr[2]] = 255) then
            begin
              Dec(i);
              quit := True;
              break
            end;
            PatternInterpreter(j, i, k)
          end
        end;
        inc(i)
      end;
      VTM.Patterns[j].Items[0].Channel[0].Additional_Command.Number := 11;
      VTM.Patterns[j].Items[0].Channel[0].Additional_Command.Parameter := Ch.Dl;
      VTM.Patterns[j].Length := i
    end
  end;
  VTM.Positions.Length := Pos;
  if VTM.Positions.Loop >= Pos then
    VTM.Positions.Loop := Pos - 1;

  for i := 0 to 31 do
  begin
    j := PSMOrnaments[i];
    if j <> 0 then
    begin
      New(VTM.Ornaments[j]);
      wo := WordPtr(@PSM.Index[PSM.PSM_OrnamentsPointer + i * 2])^;
      k := PSM.Index[wo] and 31;
      VTM.Ornaments[j].Length := k + 1;
      if shortint(PSM.Index[wo + 1]) >= 0 then
      begin
        VTM.Ornaments[j].Length := k + 2;
        VTM.Ornaments[j].Loop := k + 1;
        VTM.Ornaments[j].Items[k + 1] := 0;
      end
      else
        VTM.Ornaments[j].Loop := PSM.Index[wo + 1] and 31;
      if VTM.Ornaments[j].Loop >= VTM.Ornaments[j].Length then
        VTM.Ornaments[j].Loop := VTM.Ornaments[j].Length - 1;
      for l := 0 to k do
        VTM.Ornaments[j].Items[l] := PSM.Index[wo + 2 + l];
    end
  end;

  for i := 0 to 14 do
    for j := 0 to 15 do
    begin
      k := PSMSamples[i, j];
      if (k <> 0) and (VTM.Samples[k] = nil) then
      begin
        New(VTM.Samples[k]);
        wo := WordPtr(@PSM.Index[PSM.PSM_SamplesPointer + i * 2])^;
        len := PSM.Index[wo] and 31;
        for l := 0 to len do
        begin
          VTM.Samples[k].Items[l] := EmptySampleTick;
          b0 := PSM.Index[wo + 2 + l * 3];
          b1 := PSM.Index[wo + 2 + l * 3 + 1];
          b2 := PSM.Index[wo + 2 + l * 3 + 2];

          w := word(b1 and 7) shl 8 + b2;
          if b1 and 4 <> 0 then w := w or $F800;
          VTM.Samples[k].Items[l].Add_to_Ton := w;
          VTM.Samples[k].Items[l].Ton_Accumulation := True;

          VTM.Samples[k].Items[l].Amplitude := b0 and 15;
          if j > 0 then
            VTM.Samples[k].Items[l].Amplitude :=
              VTM.Samples[k].Items[l].Amplitude or 16;

          VTM.Samples[k].Items[l].Mixer_Noise := shortint(b0) >= 0;
          VTM.Samples[k].Items[l].Mixer_Ton := (b0 and $10) = 0;

          if VTM.Samples[k].Items[l].Mixer_Noise then
            VTM.Samples[k].Items[l].Add_to_Envelope_or_Noise := b1 shr 3;

        end;
        b0 := PSM.Index[wo];
        b1 := PSM.Index[wo + 1];
        if b1 and $E0 = 0 then
        begin
          inc(len);
          VTM.Samples[k].Items[len] := EmptySampleTick;
          VTM.Samples[k].Loop := len;
        end
        else
        begin
          if b0 and $20 = 0 then
            b0 := b0 shr 6
          else
            b0 := -(b0 shr 6 + 1);
          b2 := b1 and 31;
          VTM.Samples[k].Loop := b2;
          ls := len - b2;
          if b0 <> 0 then
            repeat
              b2 := VTM.Samples[k].Loop;
              lc := b1 shr 5;
              lp := len + 1;
              while (len < MaxSamLen - 1) and (lc > 0) do
              begin
                l := 0;
                while (l <= ls) and (len + l < MaxSamLen - 1) do
                begin
                  VTM.Samples[k].Items[len + l + 1] := VTM.Samples[k].Items[b2 + l];
                  if j > 0 then
                    inc(VTM.Samples[k].Items[len + l + 1].Amplitude, b0)
                  else if shortint(b0) < -1 then
                  begin
                    inc(VTM.Samples[k].Items[len + l + 1].Amplitude, b0);
                    if shortint(VTM.Samples[k].Items[len + l + 1].Amplitude) < 0 then
                      VTM.Samples[k].Items[len + l + 1].Amplitude := 0
                  end
                  else if shortint(b0) > 1 then
                  begin
                    inc(VTM.Samples[k].Items[len + l + 1].Amplitude, b0);
                    if (VTM.Samples[k].Items[len + l + 1].Amplitude > 15) then
                      VTM.Samples[k].Items[len + l + 1].Amplitude := 15
                  end;
                  inc(l)
                end;
                inc(len, l);
                dec(lc)
              end;
              if lp <> len + 1 then VTM.Samples[k].Loop := lp;
              if (j = 0) and (shortint(b0) = -1) then
              begin
                VTM.Samples[k].Items[lp].Amplitude_Sliding := True;
                VTM.Samples[k].Items[lp].Amplitude_Slide_Up := False;
                break;
              end
              else if (j = 0) and (b0 = 1) then
              begin
                VTM.Samples[k].Items[lp].Amplitude_Sliding := True;
                VTM.Samples[k].Items[lp].Amplitude_Slide_Up := True;
                break;
              end
            until len >= MaxSamLen - 1;
        end;
        VTM.Samples[k].Length := Len + 1;
        if VTM.Samples[k].Loop >= VTM.Samples[k].Length then
          VTM.Samples[k].Loop := VTM.Samples[k].Length - 1;
        if j > 0 then
          for l := 0 to len do
          begin
            inc(VTM.Samples[k].Items[l].Amplitude, j - 15);
            if shortint(VTM.Samples[k].Items[l].Amplitude) < 0 then
              VTM.Samples[k].Items[l].Amplitude := 0
            else if VTM.Samples[k].Items[l].Amplitude >= 16 then
            begin
              VTM.Samples[k].Items[l].Amplitude := 15;
              VTM.Samples[k].Items[l].Envelope_Enabled := True
            end
          end;
      end;
    end;

end;

function GetModuleTime;
var
  i, j, k, d, p: integer;
begin
  Result := 0;
  d := VTM.Initial_Delay;
  for i := 0 to VTM.Positions.Length - 1 do
  begin
    p := VTM.Positions.Value[i];
    if VTM.Patterns[p] = nil then
      Inc(Result, d * DefPatLen)
    else
      for j := 0 to VTM.Patterns[p].Length - 1 do
      begin
        for k := 2 downto 0 do
          with VTM.Patterns[p].Items[j].Channel[k].Additional_Command do
            if (Number = 11) and (Parameter <> 0) then
            begin
              d := Parameter;
              break
            end;
        Inc(Result, d)
      end
  end;
end;

function GetPositionTime;
var
  i, j, k, d, p: integer;
begin
  Result := 0;
  d := VTM.Initial_Delay;
  for i := 0 to Pos - 1 do
  begin
    p := VTM.Positions.Value[i];
    if VTM.Patterns[p] = nil then
      Inc(Result, d * DefPatLen)
    else
      for j := 0 to VTM.Patterns[p].Length - 1 do
      begin
        for k := 2 downto 0 do
          with VTM.Patterns[p].Items[j].Channel[k].Additional_Command do
            if (Number = 11) and (Parameter <> 0) then
            begin
              d := Parameter;
              break
            end;
        Inc(Result, d)
      end
  end;
  PosDelay := d
end;

function GetPositionTimeEx;
var
  j, k, p: integer;
begin
  Result := 0;
  p := VTM.Positions.Value[Pos];
  if VTM.Patterns[p] = nil then
    Inc(Result, PosDelay * Line)
  else
    for j := 0 to Line - 1 do
    begin
      for k := 2 downto 0 do
        with VTM.Patterns[p].Items[j].Channel[k].Additional_Command do
          if (Number = 11) and (Parameter <> 0) then
          begin
            PosDelay := Parameter;
            break;
          end;
      Inc(Result, PosDelay);
    end;
end;

procedure GetTimeParams;
var
  i, j, k, d, p, ct, tmp: integer;
begin
  Pos := -1; Line := 0;
  d := VTM.Initial_Delay;
  ct := 0;
  for i := 0 to VTM.Positions.Length - 1 do
  begin
    p := VTM.Positions.Value[i];
    if VTM.Patterns[p] = nil then
    begin
      tmp := d * DefPatLen;
      if ct + tmp < Time then
        Inc(ct, tmp)
      else
      begin
        Pos := i;
        Line := (Time - ct) div d;
        exit;
      end;
    end
    else
      for j := 0 to VTM.Patterns[p].Length - 1 do
      begin
        if ct >= Time then
        begin
          Pos := i;
          Line := j;
          exit;
        end;
        for k := 2 downto 0 do
          with VTM.Patterns[p].Items[j].Channel[k].Additional_Command do
            if (Number = 11) and (Parameter <> 0) then
            begin
              d := Parameter;
              break
            end;
        Inc(ct, d)
      end
  end;
end;

procedure FreeVTMP(var VTMP: PModule);
var
  i: integer;
begin
  if VTMP = nil then exit;

  for i := Low(VTMP.Samples) to High(VTMP.Samples) do
    if VTMP.Samples[i] <> nil then begin
      Dispose(VTMP.Samples[i]);
      VTMP.Samples[i] := nil;
    end;

  for i := Low(VTMP.Ornaments) to High(VTMP.Ornaments) do
    if VTMP.Ornaments[i] <> nil then begin
      Dispose(VTMP.Ornaments[i]);
      VTMP.Ornaments[i] := nil
    end;
    
  for i := -1 to MaxPatNum do
    if VTMP.Patterns[i] <> nil then begin
      Dispose(VTMP.Patterns[i]);
      VTMP.Patterns[i] := nil;
    end;


  Dispose(VTMP);
  VTMP := nil;
  VTM  := nil;
end;

procedure NewVTMP(var VTMP: PModule);
var
  i: integer;
begin
  New(VTMP);
  VTMP.Title := '';
  VTMP.Author := '';
  VTMP.Info := '';
  VTMP.ShowInfo := False;
  VTMP.Ton_Table := 2;
  VTMP.Initial_Delay := 3;
  VTMP.Positions.Length := 0;
  VTMP.Positions.Loop := 0;
  for i := Low(VTMP.Samples) to High(VTMP.Samples) do
    VTMP.Samples[i] := nil;
  for i := Low(VTMP.Ornaments) to High(VTMP.Ornaments) do
    VTMP.Ornaments[i] := nil;
  for i := 0 to MaxPatNum do
    VTMP.Patterns[i] := nil;
  for i := 0 to Length(VTMP.Positions.Value)-1 do
  begin
    VTMP.Positions.Value[i] := 0;
    VTMP.Positions.Colors[i] := 0;
  end;  
  New(VTMP.Patterns[-1]);
  VTMP.Patterns[-1].Length := 2;
  VTMP.Patterns[-1].Items[0].Envelope := 0;
  VTMP.Patterns[-1].Items[1].Envelope := 0;
  VTMP.Patterns[-1].Items[0].Noise := 0;
  VTMP.Patterns[-1].Items[1].Noise := 0;
  VTMP.Patterns[-1].Items[0].Channel[0] := EmptyChannelLine;
  VTMP.Patterns[-1].Items[0].Channel[1] := EmptyChannelLine;
  VTMP.Patterns[-1].Items[0].Channel[2] := EmptyChannelLine;
  VTMP.Patterns[-1].Items[1].Channel[0] := EmptyChannelLine;
  VTMP.Patterns[-1].Items[1].Channel[1] := EmptyChannelLine;
  VTMP.Patterns[-1].Items[1].Channel[2] := EmptyChannelLine;
  VTMP.Patterns[-1].Items[0].Channel[0].Note := 36;
  VTMP.Patterns[-1].Items[1].Channel[0].Note := 36;
  VTMP.Patterns[-1].Items[0].Channel[0].Sample := 1;
  VTMP.Patterns[-1].Items[1].Channel[0].Sample := 1;
  VTMP.Patterns[-1].Items[0].Channel[0].Envelope := 15;
  VTMP.Patterns[-1].Items[1].Channel[0].Envelope := 15;
  VTMP.Patterns[-1].Items[0].Channel[0].Ornament := 1;
  VTMP.Patterns[-1].Items[0].Channel[0].Volume := 15;
  VTMP.Patterns[-1].Items[1].Channel[0].Volume := 15;
  for i := 0 to 2 do
  begin
    VTMP.IsChans[i].Global_Ton := True;
    VTMP.IsChans[i].Global_Noise := True;
    VTMP.IsChans[i].Global_Envelope := True;
    VTMP.IsChans[i].Sample := 1;
    VTMP.IsChans[i].EnvelopeEnabled := False;
    VTMP.IsChans[i].Ornament := 0;
    VTMP.IsChans[i].Volume := 15
  end;
  VTMP.Positions.Loop:=0;
  VTMP.ChipFreq := DefaultChipFreq;
  VTMP.IntFreq := DefaultIntFreq;  
  VTMP.FeaturesLevel := FeaturesLevel;
  VTMP.VortexModule_Header := VortexModuleHeader;
end;








end.
