unit PatternPacker;

interface

uses
  CHILDWIN, trfuncs, AY, Dialogs;

type

  PPatternBlock = ^TPatternBlock;
  TPatternBlock = record
    StartLine: Integer;
    EndLine: Integer;
    Speed: Integer;
    BaseSpeed: Integer;
    Step: Integer;
  end;


  TPatternsPacker = class
    FromLine, ToLine: Integer;
    Pattern: PPattern;

    constructor Create(ChildWindow: TMDIChild);
    function CantPack: Boolean;
    procedure Process;

    private
      ResPattern: TPattern;
      Chan0, Chan1, Chan2: PChannelLine;
      Child: TMDIChild;
      Validated: Boolean;
      EntirePattern: Boolean;

      CurrentBlockNum: Integer;
      SrcBlocks:  array of TPatternBlock;
      DestBlocks: array of TPatternBlock;
      SrcBlock, DestBlock: PPatternBlock;
      RestLines: Integer;

      function IsEmptyChan(Chan: PChannelLine): Boolean;
      function IsEmptyLine(Line: Integer): Boolean;
      function LineHasSpeedCommand(Line: Integer): Boolean;
      function EmptyLinesEnough: Boolean;

      procedure PrepareResultPattern;
      procedure Init;
      procedure FindBlocks;

      function  GetBlockSpeed(BlockNum: Integer): Integer;
      function  GetBaseSpeed(BlockNum: Integer): Integer;
      procedure CalculateBlockSpeed(BlockNum: Integer);

      procedure UpdateSpeedCommands(Line: Integer);
      procedure PackBlock;
      procedure SetSpeedCommand(Line, Speed: Integer; StartSpeed: Boolean);

      function GetSpeedParam(Line: Integer): Integer;
      procedure RemoveSpeedCommand(Line: Integer);
      procedure SpeedCommandsCleaner;
      procedure PackBlocks;

  end;


implementation


// --- PUBLIC ----

constructor TPatternsPacker.Create(ChildWindow: TMDIChild);
begin
  Child     := ChildWindow;
  Validated := False;
  Pattern   := nil;
  FromLine  := -1;
  ToLine    := -1;
end;


function TPatternsPacker.CantPack: Boolean;
begin

  Result := False; // Can pack
  
  if Pattern  = nil then Exit;
  if FromLine = -1  then Exit;
  if ToLine   = -1  then Exit;

  Init;
  Result := not EmptyLinesEnough;

  // success
  if not Result then
    Validated := True;

end;



procedure TPatternsPacker.Process;
begin
  if not Validated then Exit;


  PrepareResultPattern;
  FindBlocks;
  PackBlocks;

  // Copy a new pattern to destination
  Pattern.Length := ResPattern.Length;
  Pattern.Items  := ResPattern.Items;

  ToLine := DestBlocks[High(DestBlocks)].EndLine;
  Init;

  if not EmptyLinesEnough then Exit;

  FindBlocks;
  PackBlocks;

  // Copy a new pattern to destination
  Pattern.Length := ResPattern.Length;
  Pattern.Items  := ResPattern.Items;

end;




// --- PRIVATE ---

function TPatternsPacker.IsEmptyChan(Chan: PChannelLine): Boolean;
begin
  Result := (Chan.Note = -1) and (Chan.Sample = 0) and (Chan.Ornament = 0) and
            (Chan.Volume = 0) and (Chan.Envelope = 0) and
            (Chan.Additional_Command.Number = 0) and
            (Chan.Additional_Command.Delay = 0) and
            (Chan.Additional_Command.Parameter = 0);
end;

function TPatternsPacker.IsEmptyLine(Line: Integer): Boolean;
begin
  Chan0  := @Pattern.Items[Line].Channel[0];
  Chan1  := @Pattern.Items[Line].Channel[1];
  Chan2  := @Pattern.Items[Line].Channel[2];
  Result := IsEmptyChan(Chan0) and IsEmptyChan(Chan1) and IsEmptyChan(Chan2)
            and (Pattern.Items[Line].Noise = 0)
            and (Pattern.Items[Line].Envelope = 0);
end;


function TPatternsPacker.LineHasSpeedCommand(Line: Integer): Boolean;
begin

  Result := (ResPattern.Items[Line].Channel[0].Additional_Command.Number = $B) or
            (ResPattern.Items[Line].Channel[1].Additional_Command.Number = $B) or
            (ResPattern.Items[Line].Channel[2].Additional_Command.Number = $B);

end;


function TPatternsPacker.EmptyLinesEnough: Boolean;
var Line, Counter: Integer;
begin

  Counter := 0;
  Result  := False;
  for Line := FromLine to Toline do begin
    if IsEmptyLine(Line) then
      Inc(Counter);

    if Counter = 1 then begin
      Result := True;
      Break;
    end;
  end;

end;

procedure TPatternsPacker.PrepareResultPattern;
var Line: Integer;
begin
  Exit;
  if EntirePattern then Exit;

  for Line := 0 to FromLine do
    ResPattern.Items[Line] := Pattern.Items[Line];

  for Line := ToLine to Pattern.Length-1 do
    ResPattern.Items[Line] := Pattern.Items[Line];

end;

procedure TPatternsPacker.Init;
var Line: Integer;
begin
  RestLines := 0;
  SetLength(SrcBlocks, 0);
  SetLength(DestBlocks, 0);

  for Line := 0 to MaxPatLen-1 do begin
    ResPattern.Items[Line].Channel[0] := EmptyChannelLine;
    ResPattern.Items[Line].Channel[1] := EmptyChannelLine;
    ResPattern.Items[Line].Channel[2] := EmptyChannelLine;
  end;

  EntirePattern := (FromLine = 0) and (ToLine = Pattern.Length-1);

  // Set FromLine to non empty line
  if IsEmptyLine(FromLine) then
    for Line := FromLine to Pattern.Length-1 do
      if not IsEmptyLine(Line) then begin
        FromLine := Line;
        Break;
      end;

  if IsEmptyLine(ToLine) then
    for Line := ToLine downto FromLine do
      if not IsEmptyLine(Line) then begin
        RestLines := ToLine - Line;
        ToLine := Line;
        Break;
      end;

end;



procedure TPatternsPacker.FindBlocks;
var
  EmptyLineCounter, Line, i: Integer;
  LineIsEmpty: Boolean;
  BlockNum: Integer;
  SrcBlock, DestBlock: PPatternBlock;
begin

  BlockNum := 0;
  EmptyLineCounter := 0;
  Line := FromLine;


  while (Line <= ToLine) do begin

    LineIsEmpty := IsEmptyLine(Line);

    // Line is empty, then increase empty lines counter
    if LineIsEmpty then begin
     Inc(Line);
     Inc(EmptyLineCounter);
     Continue;
    end;


    // Line is not empty...
    

    // Start a new block
    if EmptyLineCounter = 0 then begin

      // Finalize previous block, if exists
      if Line > FromLine then begin
        SrcBlocks[BlockNum].EndLine  := Line - 1;
        DestBlocks[BlockNum].EndLine := Line - 1;
      end;

      // Create new a block
      BlockNum := Length(SrcBlocks);
      SetLength(SrcBlocks, BlockNum+1);
      SrcBlocks[BlockNum].StartLine := Line;
      SrcBlocks[BlockNum].EndLine   := -1;

      SetLength(DestBlocks, BlockNum + 1);
      DestBlocks[BlockNum].StartLine := Line;
      DestBlocks[BlockNum].EndLine   := -1;

      Inc(Line);
      Continue;
    end;


    // Reset empty lines counter
    if EmptyLineCounter > 0 then EmptyLineCounter := 0;
    Inc(Line);

  end;

  // Finalize last block
  if SrcBlocks[BlockNum].EndLine = -1 then begin
    SrcBlocks[BlockNum].EndLine := Line - 1;
    DestBlocks[BlockNum].EndLine := Line - 1;
  end;


  // Check for skipped lines
  BlockNum := 0;
  repeat
    SrcBlock := @SrcBlocks[BlockNum];
    DestBlock := @DestBlocks[BlockNum];

    CalculateBlockSpeed(BlockNum);
    Line := SrcBlock.StartLine;
    repeat

      if Line = SrcBlock.StartLine then begin
        Inc(Line, SrcBlock.Step);
        Continue;
      end;

      // Line skipped - insert new block
      if not IsEmptyLine(Line-1) then begin

        // Create a new block
        SetLength(SrcBlocks, Length(SrcBlocks)+1);
        SetLength(DestBlocks, Length(DestBlocks)+1);

        // Shift blocks
        for i := High(SrcBlocks) downto BlockNum+1 do begin
          SrcBlocks[i] := SrcBlocks[i-1];
          DestBlocks[i] := DestBlocks[i-1];
        end;

        // Fix next block params
        SrcBlocks[BlockNum+1].StartLine  := Line-1;
        DestBlocks[BlockNum+1].StartLine := Line-1;

        // Set a new block params
        SrcBlocks[BlockNum].EndLine  := Line-2;
        DestBlocks[BlockNum].EndLine := Line-2;

        Break;
      end;

      Inc(Line, SrcBlock.Step);

    until Line >= SrcBlock.EndLine;

    Inc(BlockNum);
    if BlockNum > High(SrcBlocks) then Break;
  until False;


  // If empty lines in pattern bottom, then add new block
  if RestLines > 0 then begin
    SetLength(SrcBlocks, Length(SrcBlocks)+1);
    SetLength(DestBlocks, Length(DestBlocks)+1);

    SrcBlocks[BlockNum].StartLine  := SrcBlocks[BlockNum-1].EndLine + 1;
    SrcBlocks[BlockNum].EndLine    := SrcBlocks[BlockNum].StartLine + RestLines - 1;

    DestBlocks[BlockNum].StartLine := SrcBlocks[BlockNum].StartLine;
    DestBlocks[BlockNum].EndLine   := SrcBlocks[BlockNum].EndLine;

    CalculateBlockSpeed(BlockNum)

  end;

end;


function TPatternsPacker.GetBlockSpeed(BlockNum: Integer): Integer;
var
  Line: Integer;
  Distance: Integer;
  NotEmptyLineNum: Integer;
  SrcBlock: PPatternBlock;

begin
  SrcBlock := @SrcBlocks[BlockNum];

  if SrcBlock.EndLine - SrcBlock.StartLine <= 1  then begin
    SrcBlock.Step := SrcBlock.EndLine - SrcBlock.StartLine;
    Result := SrcBlock.BaseSpeed;
    Exit;
  end;

  NotEmptyLineNum := -1;
  SrcBlock.Step := SrcBlock.EndLine - SrcBlock.StartLine;


  // Find minimal distance between lines
  for Line := SrcBlock.StartLine to SrcBlock.EndLine do begin

    if IsEmptyLine(Line) then Continue;

    if NotEmptyLineNum = -1 then begin
      NotEmptyLineNum := Line;
      Continue;
    end;

    Distance := Line - NotEmptyLineNum;
    if Distance < SrcBlock.Step then
      SrcBlock.Step  := Distance;

    NotEmptyLineNum := Line;

  end;


  Result := SrcBlock.Step * SrcBlock.BaseSpeed;

end;


function TPatternsPacker.GetBaseSpeed(BlockNum: Integer): Integer;
begin

  // Init
  PlayingWindow[1]   := Child;
  NumberOfSoundChips := 1;

  // Detect speed
  Child.RerollToLineNum(1, SrcBlocks[BlockNum].StartLine, True);
  Result := PlVars[CurChip].Delay;

end;


procedure TPatternsPacker.CalculateBlockSpeed(BlockNum: Integer);
var
  SrcBlock, DestBlock: PPatternBlock;
begin

  SrcBlock  := @SrcBlocks[BlockNum];
  DestBlock := @DestBlocks[BlockNum];

  SrcBlock.BaseSpeed  := GetBaseSpeed(BlockNum);
  SrcBlock.Speed      := GetBlockSpeed(BlockNum);

  DestBlock.Speed     := SrcBlock.Speed;
  DestBlock.BaseSpeed := SrcBlock.BaseSpeed;
  DestBlock.Step      := SrcBlock.Step;

end;




procedure TPatternsPacker.UpdateSpeedCommands(Line: Integer);
begin

  Chan0 := @ResPattern.Items[Line].Channel[0];
  Chan1 := @ResPattern.Items[Line].Channel[1];
  Chan2 := @ResPattern.Items[Line].Channel[2];

  if (Line = DestBlock.EndLine) and (
     (Chan0.Additional_Command.Number = $B) or
     (Chan1.Additional_Command.Number = $B) or
     (Chan2.Additional_Command.Number = $B)) then Exit;

  if Chan0.Additional_Command.Number = $B then
    Inc(Chan0.Additional_Command.Parameter, DestBlock.Speed)

  else if Chan1.Additional_Command.Number = $B then
    Inc(Chan1.Additional_Command.Parameter, DestBlock.Speed)

  else if Chan2.Additional_Command.Number = $B then
    Inc(Chan2.Additional_Command.Parameter, DestBlock.Speed);

end;

procedure TPatternsPacker.PackBlock;
var
  BlockLength: Integer;
  Line, SrcLine: Integer;

begin

  if CurrentBlockNum > 0 then
    DestBlock.StartLine := DestBlocks[CurrentBlockNum-1].EndLine + 1;

  SrcLine     := SrcBlock.StartLine;
  BlockLength := SrcBlock.EndLine - SrcBlock.StartLine;
  if BlockLength = 0 then
    DestBlock.EndLine := DestBlock.StartLine
  else
    DestBlock.EndLine := DestBlock.StartLine + (BlockLength div SrcBlock.Step);


  // Just copy line without compression
  if DestBlock.StartLine = DestBlock.EndLine then begin
    Line := DestBlock.StartLine;
    ResPattern.Items[Line] := Pattern.Items[SrcLine];
    Exit;
  end;


  // Compress
  for Line := DestBlock.StartLine to DestBlock.EndLine do begin

    ResPattern.Items[Line] := Pattern.Items[SrcLine];
    UpdateSpeedCommands(Line);

    if Line < DestBlock.EndLine then
      Inc(SrcLine, SrcBlock.Step);

  end;


  // Set block start speed
  SetSpeedCommand(DestBlock.StartLine, DestBlock.Speed, True);

  // Restore base speed after
  SetSpeedCommand(DestBlock.EndLine, DestBlock.BaseSpeed, False);

end;


procedure TPatternsPacker.SetSpeedCommand(Line, Speed: Integer; StartSpeed: Boolean);
begin

  if not StartSpeed and (Speed = DestBlock.Speed) then Exit;
  if (Line = DestBlock.EndLine) and LineHasSpeedCommand(Line) then Exit;

  Chan0 := @ResPattern.Items[Line].Channel[0];
  Chan1 := @ResPattern.Items[Line].Channel[1];
  Chan2 := @ResPattern.Items[Line].Channel[2];

  if StartSpeed and LineHasSpeedCommand(Line) then begin
    if (Chan0.Additional_Command.Number = $B) then
      Chan0.Additional_Command.Parameter := Speed
    else if (Chan1.Additional_Command.Number = $B) then
      Chan1.Additional_Command.Parameter := Speed
    else if (Chan2.Additional_Command.Number = $B) then
      Chan2.Additional_Command.Parameter := Speed;
    Exit;
  end;


  if Chan0.Additional_Command.Number = 0 then begin
    Chan0.Additional_Command.Number := $B;
    Chan0.Additional_Command.Delay  := 0;
    Chan0.Additional_Command.Parameter := Speed;
  end

  else if Chan1.Additional_Command.Number = 0 then begin
    Chan1.Additional_Command.Number := $B;
    Chan1.Additional_Command.Delay  := 0;
    Chan1.Additional_Command.Parameter := Speed;
  end

  else begin
    Chan2.Additional_Command.Number := $B;
    Chan2.Additional_Command.Delay  := 0;
    Chan2.Additional_Command.Parameter := Speed;
  end;
end;


function TPatternsPacker.GetSpeedParam(Line: Integer): Integer;
begin

  Result := 0;

  if ResPattern.Items[Line].Channel[0].Additional_Command.Number = $B then
    Result := ResPattern.Items[Line].Channel[0].Additional_Command.Parameter

  else if ResPattern.Items[Line].Channel[1].Additional_Command.Number = $B then
    Result := ResPattern.Items[Line].Channel[1].Additional_Command.Parameter

  else if ResPattern.Items[Line].Channel[2].Additional_Command.Number = $B then
    Result := ResPattern.Items[Line].Channel[2].Additional_Command.Parameter;

end;


procedure TPatternsPacker.RemoveSpeedCommand(Line: Integer);
begin

  if ResPattern.Items[Line].Channel[0].Additional_Command.Number = $B then begin
    ResPattern.Items[Line].Channel[0].Additional_Command.Number := 0;
    ResPattern.Items[Line].Channel[0].Additional_Command.Parameter := 0;
  end

  else if ResPattern.Items[Line].Channel[1].Additional_Command.Number = $B then begin
    ResPattern.Items[Line].Channel[1].Additional_Command.Number := 0;
    ResPattern.Items[Line].Channel[1].Additional_Command.Parameter := 0;
  end

  else if ResPattern.Items[Line].Channel[2].Additional_Command.Number = $B then begin
    ResPattern.Items[Line].Channel[2].Additional_Command.Number := 0;
    ResPattern.Items[Line].Channel[2].Additional_Command.Parameter := 0;
  end;
  
end;


procedure TPatternsPacker.SpeedCommandsCleaner;
var
  Line, Speed, LastSpeed: Integer;
begin

  LastSpeed := -1;
  for Line := 0 to High(ResPattern.Items) do begin

    if not LineHasSpeedCommand(Line) then Continue;

    Speed := GetSpeedParam(Line);
    if LastSpeed = -1 then begin
      LastSpeed := Speed;
      Continue;
    end;

    if Speed = LastSpeed then
      RemoveSpeedCommand(Line);

    LastSpeed := Speed;

  end;

end;


procedure TPatternsPacker.PackBlocks;
var
  Line, SrcLine, BlockNum: Integer;
begin

  for BlockNum := 0 to High(SrcBlocks) do begin
    CurrentBlockNum := BlockNum;
    SrcBlock  := @SrcBlocks[BlockNum];
    DestBlock := @DestBlocks[BlockNum];
    PackBlock;
  end;

  if EntirePattern then
    ResPattern.Length := DestBlock.EndLine + 1
  else begin

    for Line := 0 to DestBlocks[0].StartLine - 1 do
      ResPattern.Items[Line] := Pattern.Items[Line];

    Line := DestBlocks[High(SrcBlocks)].EndLine;
    for SrcLine := SrcBlocks[High(DestBlocks)].EndLine + 1 to Pattern.Length - 1 do begin
      Inc(Line);
      ResPattern.Items[Line] := Pattern.Items[SrcLine];
    end;

    ResPattern.Length := Line + 1;

  end;


  SpeedCommandsCleaner;

end;

end.
