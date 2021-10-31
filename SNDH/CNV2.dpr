{Strippes first 28 bytes}
var
 f:file;
 b:array of byte;
 l:integer;
begin
AssignFile(f,'PT3SNDH.BIN');
Reset(f,1);
l := FileSize(f);
SetLength(b,l);
BlockRead(f,b[0],l,l);
CloseFile(f);
if l > 28 then
 begin
  AssignFile(f,'PT3SNDH.SND');
  Rewrite(f,1);
  BlockWrite(f,b[28],l - 28,l);
  CloseFile(f);
 end
end.
