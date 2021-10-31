{
Compares 'C000_1.bin', 'C201_2.bin' and 'C100_2.bin' and creates 'ZX_3.bin'
with tables of differencies and player, compiled at 0000 address using
C000_1.cor for high byte of addresses
Used Vortex Tracker II v1.0 PT3 and Universal PT2'n'PT3 Turbo Sound players
for ZX Spectrum by S.V.Bulba
(c)2003-2008 S.V.Bulba
}

{$APPTYPE CONSOLE}

uses
 SysUtils;

function GetHex(var s:string):integer;
var
 i:integer;
begin
Result := 0;
i := 1;
while i <= length(s) do
 begin
  case s[i] of
  '0'..'9':Result := Result*16+ord(s[i])-ord('0');
  'a'..'f':Result := Result*16+ord(s[i])-ord('a')+10;
  'A'..'F':Result := Result*16+ord(s[i])-ord('A')+10;
  ' ':break;
  else halt(1);
  end;
  inc(i);
 end;
if i = length(s) then
 s := ''
else
 s := Copy(s,i+1,length(s)-i);
end;

var
 f,f0:file;
 b1,b2:array of byte;
 l,i,d:integer;
 codelen:integer;
 s,File1,File2,File3,File4,FileC:string;
 fc:textfile;
begin
if ParamCount <> 6 then halt(1);
File1 := ParamStr(1);
File2 := ParamStr(2);
File3 := ParamStr(3);
File4 := ParamStr(4);
s := ParamStr(5);
FileC := ParamStr(6);
codelen := GetHex(s);
if codelen > 65535 then halt(1);
AssignFile(f,File1);
Reset(f,1);
l := FileSize(f) - codelen;
if l < 0 then halt(1);
SetLength(b1,codelen);
SetLength(b2,codelen);
BlockRead(f,b1[0],codelen);
CloseFile(f);
AssignFile(f,File2);
Reset(f,1);
BlockRead(f,b2[0],codelen);
CloseFile(f);
AssignFile(f,File4);
Rewrite(f,1);
BlockWrite(f,codelen,2);
BlockWrite(f,l,2);
Seek(f,codelen + 4);
i := 0;
while i < codelen - 1 do
 begin
  d := b2[i] - b1[i];
  if (d = 1) and (b2[i+1] - b1[i+1] = 2) then
   begin
    BlockWrite(f,i,2);
    b2[i] := b1[i];
    inc(i);
    Dec(b1[i],$C0);
    b2[i] := b1[i]
   end;
  inc(i);
 end;
i := -1;
BlockWrite(f,i,2);
for i := 0 to codelen - 1 do
 if b2[i] - b1[i] = 1 then
  BlockWrite(f,i,2);
i := -1;
BlockWrite(f,i,2);
AssignFile(f0,File3);
Reset(f0,1);
BlockRead(f0,b2[0],codelen);
CloseFile(f0);
AssignFile(fc,FileC);
Reset(fc);
for i := 0 to codelen - 1 do
 if b2[i] - b1[i] = 1 then
  begin
   Readln(fc,s);
   l := GetHex(s); d := GetHex(s);
   if (i <> l) or ((d shr 8) <> b1[i]) then
    begin
     Writeln(FileC,' has error: no info about address ',IntToHex(i,4));
     Halt(1);
    end;
   BlockWrite(f,i,2);
   dec(d,$C000);
   BlockWrite(f,d,2);
   Dec(b1[i],$C0);
  end;
CloseFile(fc);
i := -1;
BlockWrite(f,i,2);
Seek(f,4);
BlockWrite(f,b1[0],codelen);
CloseFile(f);
end.