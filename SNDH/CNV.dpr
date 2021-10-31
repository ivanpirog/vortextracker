{
Converts MC68KPT3.S standard MC68000 assembler text was produced by PP68K.EXE to
make it compatible with X68K.EXE assembler. Additionally strips some not used
data, changes all static jumps and calls to relative ones (branches), makes
all memory access relative to PC to load program at any address.
(c)2003-2006 S.V.Bulba
}
program CNV;

{$APPTYPE CONSOLE}

uses Sysutils;
var
 f1,f2:text;
 s,sa:string;
 si:array of string;
 i1,i2,i,lc:integer;
 bi:shortint;
begin
if ParamCount <> 1 then exit;
AssignFile(f1,ParamStr(1));
Reset(f1);
AssignFile(f2,ChangeFileExt(ParamStr(1),'.X68'));
Rewrite(f2);
try
 lc := 0;
 while not eof(f1) do
  begin
   Readln(f1,s);
   si := nil;
   while Length(s) > 0 do
    begin
     i1 := Pos(#32,s);
     i2 := Pos(#9,s);
     if (i1 <> 0) and (i1 < i2) then i2 := i1;
     if i2 = 0 then i2 := i1;
     if i2 = 0 then i2 := Length(s) + 1;
     if i2 > 0 then
      begin
       i := Length(si);
       SetLength(si,i + 1);
       if i2 > 1 then
        si[i] := Copy(s,1,i2 - 1)
       else
        si[i] := ''
      end;
     if i2 < Length(s) then
      s := Copy(s,i2 + 1,Length(s) - i2)
     else
      s := ''
    end;
   i1 := Length(si);
   if (i1 > 0) and (si[0] = 'PASCALMAIN:') then
    begin
     Writeln(f2,'vars:');
     for i := 1 to 12 do Readln(f1)
    end
   else if (i1 > 0) and (si[0] <> '__stklen') and (si[0] <> 'HEAP_SIZE') and
      (si[0] <> 'HEAP') and (si[0] <> '_PVARS') then
    if (i1 = 1) or ((i1 > 1) and (si[1] <> 'XREF') and (si[1] <> 'SECTION') and
                    (si[1] <> 'CNOP') and (si[1] <> 'XDEF') and (si[1] <> 'END')) then
     if (i1 < 3) or ((si[2] <> 'INIT$$SYSATARI') and (si[2] <> '__EXIT')) then
      begin
       if si[0] <> '' then
        begin
         for i := 1 to Length(si[0]) do
          if si[0][i] in ['_','$'] then si[0][i] := 'A';
         s := si[0]
        end;
       if i1 > 1 then
        begin
        if si[1] = 'sge.b' then si[1] := 'sge';
        if si[1] = 'sne.b' then si[1] := 'sne';
        if si[1] = 'moveq.l' then si[1] := 'moveq';
        if si[1] = 'pea.l' then si[1] := 'pea';
        if si[1] = 'jsr' then si[1] := 'bsr';
        if si[1] = 'jmp' then si[1] := 'bra';
         s := s + #9 + si[1];
         if i1 > 2 then
          begin
           if i1 > 3 then
            if si[2] = 'DC.B' then
             begin
              Val(si[3],bi,i);
              if (i = 0) and (bi < 0) then
               si[3] := IntToStr(bi)
             end;

           if si[2] = '_SYSATARI$$_INC$WORD$LONGINT' then
            si[2] := 'INCW';
           if si[2] = '_SYSATARI$$_ABS$LONGINT' then
            si[2] := 'AABS';
           if si[2] = '_SYSATARI$$_DEC$INTEGER$LONGINT' then
            si[2] := 'DECI';
           if si[2] = '_SYSATARI$$_INC$INTEGER$LONGINT' then
            si[2] := 'INCI';
           if si[2] = '_SYSATARI$$_INC$BYTE$LONGINT' then
            si[2] := 'INCB';
           if si[2] = '_SYSATARI$$_INC$SHORTINT$LONGINT' then
            si[2] := 'INCS';
           if Pos('_PVARS,',si[2]) = 1 then
            begin
             sa := Copy(si[2],8,Length(si[2]) - 7);
             Writeln(f2,#9'bsr'#9'lb' + IntToStr(lc));
             Writeln(f2,'lb' + IntToStr(lc) + ':'#9'move.l'#9'(sp)+,' + sa);
             s := #9'add.l'#9'#vars-lb' + IntToStr(lc) + ',' + sa;
             inc(lc);
            end
           else
            begin
             for i := 1 to Length(si[2]) do
              if si[2][i] in ['_','$'] then si[2][i] := 'A';
             s := s + #9 + si[2]
            end
          end
        end;
       for i := 3 to i1 - 1 do
        s := s + #9 + si[i];
       Writeln(f2,s)
      end
  end;
 for i := 1 to 256{vt} + 192{nt} + 16{pt3} + 48*3{pt3_a+pt3_b+pt3_c} do
  Writeln(f2,#9'DC.B'#9'0');

{ Writeln(f2,#9'DC.L'#9'0,0,0,0,0,0,0,0,0,0,0');
 Writeln(f2,#9'DC.L'#9'0,0,0,0,0,0,0,0,0,0,0');
 Writeln(f2,#9'DC.L'#9'0,0,0,0,0,0,0,0,0,0,0');
 Writeln(f2,#9'DC.L'#9'0,0,0,0,0,0,0,0,0,0,0');}
 Writeln(f2,#9'END'#9'0');
finally
 CloseFile(f2);
 CloseFile(f1)
end
end.