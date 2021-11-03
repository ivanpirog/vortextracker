{
This is part of Vortex Tracker II project

Version 2.0 and later
(c)2017-2021 Ivan Pirog, ivan.pirog@gmail.com
https://github.com/ivanpirog/vortextracker
}
unit ntfs;

interface

uses Types, Windows, SysUtils, Dialogs;


const
  FILE_ATTRIBUTE_REPARSE_POINT = 1024;
  IO_REPARSE_TAG_MOUNT_POINT = $A0000003;
  FILE_FLAG_OPEN_REPARSE_POINT = $00200000;
  MAXIMUM_REPARSE_DATA_BUFFER_SIZE = 16 * 1024;
  FILE_DEVICE_FILE_SYSTEM = $00000009;
  FILE_ANY_ACCESS = 0;
  METHOD_BUFFERED = 0;

  FSCTL_GET_REPARSE_POINT = (
    (FILE_DEVICE_FILE_SYSTEM shl 16) or (FILE_ANY_ACCESS shl 14) or
    (42 shl 2) or METHOD_BUFFERED);


{type

  TReparseDataBuffer = record
    ReparseTag: DWORD;
    ReparseDataLength: Word;
    Reserved: Word;
    case Integer of
      0: ( // SymbolicLinkReparseBuffer and MountPointReparseBuffer
        SubstituteNameOffset: Word;
        SubstituteNameLength: Word;
        PrintNameOffset: Word;
        PrintNameLength: Word;
        PathBuffer: array [0..0] of WCHAR);
      1: ( // GenericReparseBuffer
        DataBuffer: array [0..0] of Byte);
  end;

  TReparseDataBufferOverlay = record
  case Boolean of
    False:
      (Reparse: TReparseDataBuffer;);
    True:
      (Buffer: array [0..MAXIMUM_REPARSE_DATA_BUFFER_SIZE] of Char;);
  end; }

  function NtfsIsFolderMountPoint(const Path: string): Boolean;
  //function NtfsGetJunctionPointDestination(const Source: string; var Destination: string): Boolean;


implementation


function NtfsFileHasReparsePoint(const Path: string): Boolean;
var
  Attr: DWORD;
begin
  Result := False;
  Attr := GetFileAttributes(PChar(Path));
  if Attr <> DWORD(-1) then
    Result := (Attr and FILE_ATTRIBUTE_REPARSE_POINT) <> 0;
end;


{function NtfsGetJunctionPointDestination(const Source: string; var Destination: string): Boolean;
var
  Handle: THandle;
  ReparseData: TReparseDataBufferOverlay;
  BytesReturned: DWORD;
  SubstituteName: WideString;
  SubstituteNameAddr: PWideChar;
begin
  Result := False;
  if NtfsFileHasReparsePoint(Source) then
  begin
    Handle := CreateFile(PChar(Source), GENERIC_READ, 0, nil,
      OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS or FILE_FLAG_OPEN_REPARSE_POINT, 0);
    if Handle <> INVALID_HANDLE_VALUE then
    try
      BytesReturned := 0;
      if DeviceIoControl(Handle, FSCTL_GET_REPARSE_POINT, nil, 0, @ReparseData,
        MAXIMUM_REPARSE_DATA_BUFFER_SIZE, BytesReturned, nil)
        then
      begin
        if BytesReturned >= DWORD(ReparseData.Reparse.SubstituteNameLength + SizeOf(WideChar)) then
        begin
          SetLength(Destination, ReparseData.Reparse.SubstituteNameLength div SizeOf(WideChar));
          SubstituteNameAddr := @ReparseData.Reparse.PathBuffer;
          Inc(SubstituteNameAddr, ReparseData.Reparse.SubstituteNameOffset div SizeOf(WideChar));
          SetString(SubstituteName, SubstituteNameAddr, Length(Destination));
          Destination := string(SubstituteName);
          Result := True;
        end
      end;
    finally
      CloseHandle(Handle);
    end
  end;
end; }



function NtfsGetReparseTag(const Path: string; var Tag: DWORD): Boolean;
var
  SearchRec: TSearchRec;
begin
  Result := NtfsFileHasReparsePoint(Path);
  if Result then
  begin
    Result := FindFirst(Path, faAnyFile, SearchRec) = 0;
    if Result then
    begin
      // Check if file has a reparse point
      Result := ((SearchRec.Attr and FILE_ATTRIBUTE_REPARSE_POINT) <> 0);
      // If so the dwReserved0 field contains the reparse tag
      if Result then
        Tag := SearchRec.FindData.dwReserved0;
      FindClose(SearchRec);
    end;
  end;
end;

function NtfsIsFolderMountPoint(const Path: string): Boolean;
var
  Tag: DWORD;
begin
  if Win32MajorVersion < 5 then
  begin
    Result := False;
    Exit;
  end;
  Tag := 0;
  Result := NtfsGetReparseTag(Path, Tag);
  if Result then
    Result := (Tag = IO_REPARSE_TAG_MOUNT_POINT);
end;

end.
 