unit Logger;

interface


type
  TLogger = class
    Opened: Boolean;
    LogFile: TextFile;
    constructor Create(FileName: String);
    destructor Destruct;
    procedure Add(Str: String);
  end;

implementation

constructor TLogger.Create(FileName: String);
begin
  if Opened then Exit;
  AssignFile(LogFile, FileName);
  Rewrite(LogFile);
  Opened := True;
end;

destructor TLogger.Destruct;
begin
  CloseFile(LogFile);
end;

procedure TLogger.Add(Str: String);
begin
  Writeln(LogFile, Str);
end;

end.
 