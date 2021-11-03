{
This is part of Vortex Tracker II project

Version 2.0 and later
(c)2017-2021 Ivan Pirog, ivan.pirog@gmail.com
https://github.com/ivanpirog/vortextracker
}

unit ColorThemes;

interface

uses Classes, SysUtils, inifiles, Dialogs, Controls, Graphics, HotKeys, Windows;

type
  PRGBColor = ^TRGBColor;
  TRGBColor = string[7];

  TColorTheme = record
    Name: String;
    Background: TRGBColor;          // Main background color
    SelLineBackground: TRGBColor;   // Selected line bg color
    HighlBackground: TRGBColor;     // Highlighted lines bg color
    OutBackground: TRGBColor;       // Prev/Next pattern bg color
    OutHlBackground: TRGBColor;     // Prev/Next pattern highlighted lines bg color
    Text: TRGBColor;                // Text color (dots)
    SelLineText: TRGBColor;         // Selected line text color
    HighlText: TRGBColor;           // Highlighted text color (dots)
    OutText: TRGBColor;             // Prev/Next pattern text color
    LineNum: TRGBColor;             // Line numbers color
    SelLineNum: TRGBColor;          // Selected line line numbers
    HighlLineNum: TRGBColor;        // Highlighted line numbers
    Envelope: TRGBColor;            // Envelope value color
    SelEnvelope: TRGBColor;         // Highlighted envelope
    Noise: TRGBColor;               // Noise value color
    SelNoise: TRGBColor;            // Highlighted noise
    Note: TRGBColor;                // Note color
    SelNote: TRGBColor;             // Highlighted notes
    NoteParams: TRGBColor;          // Note parameters color (Sample, Ornament, Volume)
    SelNoteParams: TRGBColor;       // Highlighted note params
    NoteCommands: TRGBColor;        // Note special commands color
    SelNoteCommands: TRGBColor;     // Highlighted note commands
    Separators: TRGBColor;          // Vertical separators color
    OutSeparators: TRGBColor;       // Prev/Next pattern separators color
    SamOrnBackground: TRGBColor;    // Sample/Ornament editor background
    SamOrnSelBackground:TRGBColor;  // Sample/Ornament selected line background
    SamOrnText: TRGBColor;          // Sample/Ornament text color
    SamOrnSelText: TRGBColor;       // Sample/Ornament selected line text color
    SamOrnLineNum: TRGBColor;       // Sample/Ornament line number
    SamOrnSelLineNum:TRGBColor;     // Sample/Ornament selected line number
    SamNoise: TRGBColor;            // Sample noise color
    SamSelNoise: TRGBColor;         // Sample selected line noise color
    SamOrnSeparators: TRGBColor;    // Sample/Ornament separators
    SamOrnTone: TRGBColor;             // Sample/Ornament tone shift color
    SamOrnSelTone: TRGBColor;          // Sample/Ornament selected line tone shift color
    FullScreenBackground:TRGBColor; // Fullscreen background color
  end;

  TThemesArray = array of string;

const

  BrightBG  = $333333;
  BrightHL  = $171717;
  BrightTXT = $525252;

  ThemeINIKey = 'Vortex Tracker 2.0 Theme';

  DefaultColorThemes : array[0..25] of TColorTheme = (
    (
      Name: 'Default';
      Background: TRGBColor('FFFFFF');
      SelLineBackground: TRGBColor('4256A2');
      HighlBackground: TRGBColor('EFEFEF');
      OutBackground: TRGBColor('FFFFFF');
      OutHlBackground: TRGBColor('F5F5F5');
      Text: TRGBColor('7D7D88');
      SelLineText: TRGBColor('798EAB');
      HighlText: TRGBColor('54545C');
      OutText: TRGBColor('8D8D95');
      LineNum: TRGBColor('454455');
      SelLineNum: TRGBColor('ECEDD1');
      HighlLineNum: TRGBColor('414050');
      Envelope: TRGBColor('515A6F');
      SelEnvelope: TRGBColor('FFFED9');
      Noise: TRGBColor('477C80');
      SelNoise: TRGBColor('FFFED9');
      Note: TRGBColor('1F1C65');
      SelNote: TRGBColor('FFFED9');
      NoteParams: TRGBColor('5A5E74');
      SelNoteParams: TRGBColor('FFFED9');
      NoteCommands: TRGBColor('536B71');
      SelNoteCommands: TRGBColor('FFFED9');
      Separators: TRGBColor('8E8E9F');
      OutSeparators: TRGBColor('8E8E9F');
      SamOrnBackground: TRGBColor('FEFFFA');
      SamOrnSelBackground: TRGBColor('4256A2');
      SamOrnText: TRGBColor('766A66');
      SamOrnSelText: TRGBColor('6D7484');
      SamOrnLineNum: TRGBColor('5C4845');
      SamOrnSelLineNum: TRGBColor('FFFED9');
      SamNoise: TRGBColor('766A66');
      SamSelNoise: TRGBColor('515A6F');
      SamOrnSeparators: TRGBColor('92929A');
      SamOrnTone: TRGBColor('766A66');
      SamOrnSelTone: TRGBColor('515A6F');
      FullScreenBackground: TRGBColor('221C1C');
    ),
    (
      Name: 'Classic Vortex 1.0';
      Background: TRGBColor('FFFFFF');
      SelLineBackground: TRGBColor('0078D7');
      HighlBackground: TRGBColor('EFEFEF');
      OutBackground: TRGBColor('FEFFFA');
      OutHlBackground: TRGBColor('F3F8FE');
      Text: TRGBColor('000000');
      SelLineText: TRGBColor('FFFFFF');
      HighlText: TRGBColor('000000');
      OutText: TRGBColor('828282');
      LineNum: TRGBColor('000000');
      SelLineNum: TRGBColor('FFFFFF');
      HighlLineNum: TRGBColor('000000');
      Envelope: TRGBColor('000000');
      SelEnvelope: TRGBColor('FFFFFF');
      Noise: TRGBColor('000000');
      SelNoise: TRGBColor('FFFFFF');
      Note: TRGBColor('000000');
      SelNote: TRGBColor('FFFFFF');
      NoteParams: TRGBColor('000000');
      SelNoteParams: TRGBColor('FFFFFF');
      NoteCommands: TRGBColor('000000');
      SelNoteCommands: TRGBColor('FFFFFF');
      Separators: TRGBColor('404040');
      OutSeparators: TRGBColor('404040');
      SamOrnBackground: TRGBColor('FFFFFF');
      SamOrnSelBackground: TRGBColor('006DC3');
      SamOrnText: TRGBColor('626262');
      SamOrnSelText: TRGBColor('686868');
      SamOrnLineNum: TRGBColor('252525');
      SamOrnSelLineNum: TRGBColor('FFFFFF');
      SamNoise: TRGBColor('626262');
      SamSelNoise: TRGBColor('3F3D56');
      SamOrnSeparators: TRGBColor('727272');
      SamOrnTone: TRGBColor('626262');
      SamOrnSelTone: TRGBColor('3F3D56');
      FullScreenBackground: TRGBColor('221C1C');
    ),
    (
      Name: 'MmcM';
      Background: TRGBColor('000000');
      SelLineBackground: TRGBColor('0009A5');
      HighlBackground: TRGBColor('000000');
      OutBackground: TRGBColor('000000');
      OutHlBackground: TRGBColor('000000');
      Text: TRGBColor('808080');
      SelLineText: TRGBColor('CCCCCC');
      HighlText: TRGBColor('D0D0D0');
      OutText: TRGBColor('808080');
      LineNum: TRGBColor('808080');
      SelLineNum: TRGBColor('C0C0C0');
      HighlLineNum: TRGBColor('D0D0D0');
      Envelope: TRGBColor('06A6E1');
      SelEnvelope: TRGBColor('CCCCCC');
      Noise: TRGBColor('D47908');
      SelNoise: TRGBColor('CCCCCC');
      Note: TRGBColor('CCCCCC');
      SelNote: TRGBColor('CCCCCC');
      NoteParams: TRGBColor('00A30C');
      SelNoteParams: TRGBColor('CCCCCC');
      NoteCommands: TRGBColor('C0C000');
      SelNoteCommands: TRGBColor('CCCCCC');
      Separators: TRGBColor('505050');
      OutSeparators: TRGBColor('505050');
      SamOrnBackground: TRGBColor('000000');
      SamOrnSelBackground: TRGBColor('0009A5');
      SamOrnText: TRGBColor('CCCCCC');
      SamOrnSelText: TRGBColor('C6C6C6');
      SamOrnLineNum: TRGBColor('808080');
      SamOrnSelLineNum: TRGBColor('D4D4D4');
      SamNoise: TRGBColor('EE8809');
      SamSelNoise: TRGBColor('EE8809');
      SamOrnSeparators: TRGBColor('606060');
      SamOrnTone: TRGBColor('59C40C');
      SamOrnSelTone: TRGBColor('59C40C');
      FullScreenBackground: TRGBColor('001020');
    ),
    (
      Name: 'n1k-o';
      Background: TRGBColor('000000');
      SelLineBackground: TRGBColor('0009A5');
      HighlBackground: TRGBColor('1D1D1D');
      OutBackground: TRGBColor('000000');
      OutHlBackground: TRGBColor('181818');
      Text: TRGBColor('777777');
      SelLineText: TRGBColor('CCCCCC');
      HighlText: TRGBColor('DAA721');
      OutText: TRGBColor('636363');
      LineNum: TRGBColor('7F7F7F');
      SelLineNum: TRGBColor('CCCCCC');
      HighlLineNum: TRGBColor('BBBBBB');
      Envelope: TRGBColor('06A6E1');
      SelEnvelope: TRGBColor('CCCCCC');
      Noise: TRGBColor('D47908');
      SelNoise: TRGBColor('CCCCCC');
      Note: TRGBColor('CCCCCC');
      SelNote: TRGBColor('CCCCCC');
      NoteParams: TRGBColor('00A30C');
      SelNoteParams: TRGBColor('CCCCCC');
      NoteCommands: TRGBColor('C9C804');
      SelNoteCommands: TRGBColor('CCCCCC');
      Separators: TRGBColor('717171');
      OutSeparators: TRGBColor('3C3C3C');
      SamOrnBackground: TRGBColor('000000');
      SamOrnSelBackground: TRGBColor('0009A5');
      SamOrnText: TRGBColor('CCCCCC');
      SamOrnSelText: TRGBColor('C6C6C6');
      SamOrnLineNum: TRGBColor('7B7B7B');
      SamOrnSelLineNum: TRGBColor('D4D4D4');
      SamNoise: TRGBColor('EE8809');
      SamSelNoise: TRGBColor('EE8809');
      SamOrnSeparators: TRGBColor('717171');
      SamOrnTone: TRGBColor('59C40C');
      SamOrnSelTone: TRGBColor('59C40C');
      FullScreenBackground: TRGBColor('001020');
    ),
    (
      Name: 'EA''s Theme';
      Background: TRGBColor('000000');
      SelLineBackground: TRGBColor('0000FF');
      HighlBackground: TRGBColor('000040');
      OutBackground: TRGBColor('000000');
      OutHlBackground: TRGBColor('000040');
      Text: TRGBColor('404040');
      SelLineText: TRGBColor('FFFFFF');
      HighlText: TRGBColor('404040');
      OutText: TRGBColor('404040');
      LineNum: TRGBColor('008000');
      SelLineNum: TRGBColor('FFFFFF');
      HighlLineNum: TRGBColor('00B501');
      Envelope: TRGBColor('00FFFF');
      SelEnvelope: TRGBColor('FFFFFF');
      Noise: TRGBColor('FF8000');
      SelNoise: TRGBColor('FFFFFF');
      Note: TRGBColor('FFFFFF');
      SelNote: TRGBColor('FFFFFF');
      NoteParams: TRGBColor('00FF00');
      SelNoteParams: TRGBColor('FFFFFF');
      NoteCommands: TRGBColor('FFFF00');
      SelNoteCommands: TRGBColor('FFFFFF');
      Separators: TRGBColor('C0C0C0');
      OutSeparators: TRGBColor('404040');
      SamOrnBackground: TRGBColor('000000');
      SamOrnSelBackground: TRGBColor('FF0000');
      SamOrnText: TRGBColor('808080');
      SamOrnSelText: TRGBColor('FFFFFF');
      SamOrnLineNum: TRGBColor('008000');
      SamOrnSelLineNum: TRGBColor('EEF41F');
      SamNoise: TRGBColor('C08000');
      SamSelNoise: TRGBColor('FF8000');
      SamOrnSeparators: TRGBColor('C0C0C0');
      SamOrnTone: TRGBColor('008000');
      SamOrnSelTone: TRGBColor('00FF00');
      FullScreenBackground: TRGBColor('000000');
    ),
    (
      Name: 'Flexx';
      Background: TRGBColor('131313');
      SelLineBackground: TRGBColor('42387A');
      HighlBackground: TRGBColor('1D1C18');
      OutBackground: TRGBColor('161616');
      OutHlBackground: TRGBColor('1E1D19');
      Text: TRGBColor('00570C');
      SelLineText: TRGBColor('B3B3B3');
      HighlText: TRGBColor('515152');
      OutText: TRGBColor('4E4A35');
      LineNum: TRGBColor('3F6B93');
      SelLineNum: TRGBColor('FFFFFF');
      HighlLineNum: TRGBColor('44739E');
      Envelope: TRGBColor('FA7351');
      SelEnvelope: TRGBColor('DAD9E4');
      Noise: TRGBColor('D3CCB2');
      SelNoise: TRGBColor('D8D2BB');
      Note: TRGBColor('9391F4');
      SelNote: TRGBColor('EEEEC8');
      NoteParams: TRGBColor('BF6240');
      SelNoteParams: TRGBColor('E8AB95');
      NoteCommands: TRGBColor('35A36D');
      SelNoteCommands: TRGBColor('A1CBB2');
      Separators: TRGBColor('4B4D44');
      OutSeparators: TRGBColor('3B3D35');
      SamOrnBackground: TRGBColor('131313');
      SamOrnSelBackground: TRGBColor('3E306D');
      SamOrnText: TRGBColor('B4B591');
      SamOrnSelText: TRGBColor('BFB398');
      SamOrnLineNum: TRGBColor('3F675D');
      SamOrnSelLineNum: TRGBColor('CFDA9C');
      SamNoise: TRGBColor('8584A8');
      SamSelNoise: TRGBColor('9CABCA');
      SamOrnSeparators: TRGBColor('5E6156');
      SamOrnTone: TRGBColor('C77759');
      SamOrnSelTone: TRGBColor('D8C075');
      FullScreenBackground: TRGBColor('0C0C0C');
    ),
    (
      Name: TRGBColor('FruityLoops');
      Background: TRGBColor('34444E');
      SelLineBackground: TRGBColor('29363D');
      HighlBackground: TRGBColor('3D4E59');
      OutBackground: TRGBColor('3A4853');
      OutHlBackground: TRGBColor('3E4F5D');
      Text: TRGBColor('4D565B');
      SelLineText: TRGBColor('CFDEEA');
      HighlText: TRGBColor('808082');
      OutText: TRGBColor('607783');
      LineNum: TRGBColor('7CA0AA');
      SelLineNum: TRGBColor('98B4BC');
      HighlLineNum: TRGBColor('6F97A2');
      Envelope: TRGBColor('8590AE');
      SelEnvelope: TRGBColor('778BB1');
      Noise: TRGBColor('8C98BB');
      SelNoise: TRGBColor('778BB1');
      Note: TRGBColor('C6C8CB');
      SelNote: TRGBColor('D8E8F1');
      NoteParams: TRGBColor('77808A');
      SelNoteParams: TRGBColor('B997AC');
      NoteCommands: TRGBColor('5C6E70');
      SelNoteCommands: TRGBColor('A1CBB2');
      Separators: TRGBColor('5F686D');
      OutSeparators: TRGBColor('5F686D');
      SamOrnBackground: TRGBColor('34444E');
      SamOrnSelBackground: TRGBColor('526878');
      SamOrnText: TRGBColor('8DACB4');
      SamOrnSelText: TRGBColor('CFDEEA');
      SamOrnLineNum: TRGBColor('7CA0AA');
      SamOrnSelLineNum: TRGBColor('B9D0D0');
      SamNoise: TRGBColor('6B799F');
      SamSelNoise: TRGBColor('7A8CAD');
      SamOrnSeparators: TRGBColor('5F686D');
      SamOrnTone: TRGBColor('848C95');
      SamOrnSelTone: TRGBColor('C3A6B8');
      FullScreenBackground: TRGBColor('34444E');
    ),
    (
      Name: 'OpenMPT';
      Background: TRGBColor('FAFAFA');
      SelLineBackground: TRGBColor('2B2B2B');
      HighlBackground: TRGBColor('EEEEEE');
      OutBackground: TRGBColor('FAFAFA');
      OutHlBackground: TRGBColor('F3F3F3');
      Text: TRGBColor('8A8A8A');
      SelLineText: TRGBColor('FFFFFF');
      HighlText: TRGBColor('757575');
      OutText: TRGBColor('A5A5A5');
      LineNum: TRGBColor('374D5B');
      SelLineNum: TRGBColor('FFFFFF');
      HighlLineNum: TRGBColor('1F2B33');
      Envelope: TRGBColor('714D47');
      SelEnvelope: TRGBColor('FFFFFF');
      Noise: TRGBColor('617B4C');
      SelNoise: TRGBColor('FFFFFF');
      Note: TRGBColor('38386E');
      SelNote: TRGBColor('FFFFFF');
      NoteParams: TRGBColor('458C3B');
      SelNoteParams: TRGBColor('FFFFFF');
      NoteCommands: TRGBColor('86880A');
      SelNoteCommands: TRGBColor('FFFFFF');
      Separators: TRGBColor('CBCBCB');
      OutSeparators: TRGBColor('C7C7BF');
      SamOrnBackground: TRGBColor('FAFAFA');
      SamOrnSelBackground: TRGBColor('3C3C3C');
      SamOrnText: TRGBColor('8A8A8A');
      SamOrnSelText: TRGBColor('747474');
      SamOrnLineNum: TRGBColor('40596A');
      SamOrnSelLineNum: TRGBColor('BFD8D1');
      SamNoise: TRGBColor('458C3B');
      SamSelNoise: TRGBColor('7B750F');
      SamOrnSeparators: TRGBColor('A9A99D');
      SamOrnTone: TRGBColor('565686');
      SamOrnSelTone: TRGBColor('57577E');
      FullScreenBackground: TRGBColor('607179');
    ),
    (
      Name: 'Relaxed';
      Background: TRGBColor('111B21');
      SelLineBackground: TRGBColor('275272');
      HighlBackground: TRGBColor('122832');
      OutBackground: TRGBColor('131E24');
      OutHlBackground: TRGBColor('142C37');
      Text: TRGBColor('303D43');
      SelLineText: TRGBColor('B7B85C');
      HighlText: TRGBColor('4E626C');
      OutText: TRGBColor('3B584C');
      LineNum: TRGBColor('A2B099');
      SelLineNum: TRGBColor('ECEDD1');
      HighlLineNum: TRGBColor('BAC4B3');
      Envelope: TRGBColor('8D8942');
      SelEnvelope: TRGBColor('E1E4C8');
      Noise: TRGBColor('997D59');
      SelNoise: TRGBColor('E1E4C8');
      Note: TRGBColor('F3A586');
      SelNote: TRGBColor('E1E4C8');
      NoteParams: TRGBColor('8E8D5E');
      SelNoteParams: TRGBColor('E1E4C8');
      NoteCommands: TRGBColor('8E8D5E');
      SelNoteCommands: TRGBColor('E1E4C8');
      Separators: TRGBColor('35434A');
      OutSeparators: TRGBColor('35434A');
      SamOrnBackground: TRGBColor('131E24');
      SamOrnSelBackground: TRGBColor('1A326D');
      SamOrnText: TRGBColor('C0B77F');
      SamOrnSelText: TRGBColor('CBC395');
      SamOrnLineNum: TRGBColor('A2B099');
      SamOrnSelLineNum: TRGBColor('F6F5D3');
      SamNoise: TRGBColor('9F9D6D');
      SamSelNoise: TRGBColor('D5D4B3');
      SamOrnSeparators: TRGBColor('35434A');
      SamOrnTone: TRGBColor('9F9D6D');
      SamOrnSelTone: TRGBColor('DEDDAD');
      FullScreenBackground: TRGBColor('0F0D0D');
     ),
    (
      Name: 'Quiet';
      Background: TRGBColor('181B18');
      SelLineBackground: TRGBColor('17BCD9');
      HighlBackground: TRGBColor('282828');
      OutBackground: TRGBColor('191919');
      OutHlBackground: TRGBColor('262626');
      Text: TRGBColor('10991C');
      SelLineText: TRGBColor('FFFFFF');
      HighlText: TRGBColor('515152');
      OutText: TRGBColor('717171');
      LineNum: TRGBColor('448265');
      SelLineNum: TRGBColor('FFFFFF');
      HighlLineNum: TRGBColor('55A25E');
      Envelope: TRGBColor('16DA28');
      SelEnvelope: TRGBColor('FFFFFF');
      Noise: TRGBColor('EFF518');
      SelNoise: TRGBColor('FFFFFF');
      Note: TRGBColor('16DA28');
      SelNote: TRGBColor('FFFFFF');
      NoteParams: TRGBColor('76D2E2');
      SelNoteParams: TRGBColor('FFFFFF');
      NoteCommands: TRGBColor('B65FFC');
      SelNoteCommands: TRGBColor('FFFFFF');
      Separators: TRGBColor('31BDC1');
      OutSeparators: TRGBColor('434343');
      SamOrnBackground: TRGBColor('181B18');
      SamOrnSelBackground: TRGBColor('2C2C2C');
      SamOrnText: TRGBColor('63A569');
      SamOrnSelText: TRGBColor('85A889');
      SamOrnLineNum: TRGBColor('3F675D');
      SamOrnSelLineNum: TRGBColor('7BC6B8');
      SamNoise: TRGBColor('A9AC3A');
      SamSelNoise: TRGBColor('D3D74D');
      SamOrnSeparators: TRGBColor('256462');
      SamOrnTone: TRGBColor('9270AE');
      SamOrnSelTone: TRGBColor('AF88CF');
      FullScreenBackground: TRGBColor('141614');
    ),
    (
      Name: 'Bfox';
      Background: TRGBColor('000000');
      SelLineBackground: TRGBColor('0000E6');
      HighlBackground: TRGBColor('101010');
      OutBackground: TRGBColor('000000');
      OutHlBackground: TRGBColor('0F0F0F');
      Text: TRGBColor('005000');
      SelLineText: TRGBColor('FEFEFE');
      HighlText: TRGBColor('005000');
      OutText: TRGBColor('303030');
      LineNum: TRGBColor('00CC00');
      SelLineNum: TRGBColor('FEFEFE');
      HighlLineNum: TRGBColor('009D00');
      Envelope: TRGBColor('009D00');
      SelEnvelope: TRGBColor('FEFEFE');
      Noise: TRGBColor('009D00');
      SelNoise: TRGBColor('FEFEFE');
      Note: TRGBColor('00CC00');
      SelNote: TRGBColor('FEFEFE');
      NoteParams: TRGBColor('009D00');
      SelNoteParams: TRGBColor('FEFEFE');
      NoteCommands: TRGBColor('009D00');
      SelNoteCommands: TRGBColor('FEFEFE');
      Separators: TRGBColor('9D9D9D');
      OutSeparators: TRGBColor('202020');
      SamOrnBackground: TRGBColor('000000');
      SamOrnSelBackground: TRGBColor('7840CC');
      SamOrnText: TRGBColor('CCCCCC');
      SamOrnSelText: TRGBColor('E9E9E9');
      SamOrnLineNum: TRGBColor('00A8A8');
      SamOrnSelLineNum: TRGBColor('CCCCCC');
      SamNoise: TRGBColor('CCCC00');
      SamSelNoise: TRGBColor('E9E900');
      SamOrnSeparators: TRGBColor('9D9D9D');
      SamOrnTone: TRGBColor('CCCCCC');
      SamOrnSelTone: TRGBColor('FEFEFE');
      FullScreenBackground: TRGBColor('030403');
    ),
    (
      Name: 'PT2 Scheme';
      Background: TRGBColor('000000');
      SelLineBackground: TRGBColor('000000');
      HighlBackground: TRGBColor('181818');
      OutBackground: TRGBColor('000000');
      OutHlBackground: TRGBColor('0F0F0F');
      Text: TRGBColor('007800');
      SelLineText: TRGBColor('CCCCCC');
      HighlText: TRGBColor('007800');
      OutText: TRGBColor('303030');
      LineNum: TRGBColor('00CC00');
      SelLineNum: TRGBColor('FEFEFE');
      HighlLineNum: TRGBColor('CCCC00');
      Envelope: TRGBColor('00CCCC');
      SelEnvelope: TRGBColor('FEFEFE');
      Noise: TRGBColor('CCCC00');
      SelNoise: TRGBColor('FEFEFE');
      Note: TRGBColor('00CC00');
      SelNote: TRGBColor('FEFEFE');
      NoteParams: TRGBColor('00CC00');
      SelNoteParams: TRGBColor('FEFEFE');
      NoteCommands: TRGBColor('00CC00');
      SelNoteCommands: TRGBColor('FEFEFE');
      Separators: TRGBColor('CCCCCC');
      OutSeparators: TRGBColor('3A3A3A');
      SamOrnBackground: TRGBColor('000000');
      SamOrnSelBackground: TRGBColor('CCCCCC');
      SamOrnText: TRGBColor('CCCCCC');
      SamOrnSelText: TRGBColor('E9E9E9');
      SamOrnLineNum: TRGBColor('00CC00');
      SamOrnSelLineNum: TRGBColor('000000');
      SamNoise: TRGBColor('CCCC00');
      SamSelNoise: TRGBColor('E9E900');
      SamOrnSeparators: TRGBColor('787878');
      SamOrnTone: TRGBColor('00CCCC');
      SamOrnSelTone: TRGBColor('00E9E9');
      FullScreenBackground: TRGBColor('090909');
    ),
    (
      Name: 'PT3 Green';
      Background: TRGBColor('000000');
      SelLineBackground: TRGBColor('0000FE');
      HighlBackground: TRGBColor('141414');
      OutBackground: TRGBColor('000000');
      OutHlBackground: TRGBColor('0F0F0F');
      Text: TRGBColor('009D00');
      SelLineText: TRGBColor('FEFEFE');
      HighlText: TRGBColor('009D00');
      OutText: TRGBColor('383838');
      LineNum: TRGBColor('00FE00');
      SelLineNum: TRGBColor('FEFEFE');
      HighlLineNum: TRGBColor('00CC00');
      Envelope: TRGBColor('00CC00');
      SelEnvelope: TRGBColor('FEFEFE');
      Noise: TRGBColor('00CC00');
      SelNoise: TRGBColor('FEFEFE');
      Note: TRGBColor('00CC00');
      SelNote: TRGBColor('FEFEFE');
      NoteParams: TRGBColor('00CC00');
      SelNoteParams: TRGBColor('FEFEFE');
      NoteCommands: TRGBColor('00CC00');
      SelNoteCommands: TRGBColor('FEFEFE');
      Separators: TRGBColor('CCCCCC');
      OutSeparators: TRGBColor('3A3A3A');
      SamOrnBackground: TRGBColor('000000');
      SamOrnSelBackground: TRGBColor('CC00CC');
      SamOrnText: TRGBColor('CCCCCC');
      SamOrnSelText: TRGBColor('CCCCCC');
      SamOrnLineNum: TRGBColor('00CCCC');
      SamOrnSelLineNum: TRGBColor('CCCCCC');
      SamNoise: TRGBColor('CCCCCC');
      SamSelNoise: TRGBColor('CCCCCC');
      SamOrnSeparators: TRGBColor('CCCCCC');
      SamOrnTone: TRGBColor('CCCCCC');
      SamOrnSelTone: TRGBColor('CCCCCC');
      FullScreenBackground: TRGBColor('090909');
    ),
    (
      Name: 'Calmness';
      Background: TRGBColor('181F2D');
      SelLineBackground: TRGBColor('1E4769');
      HighlBackground: TRGBColor('1A2635');
      OutBackground: TRGBColor('181F2D');
      OutHlBackground: TRGBColor('192433');
      Text: TRGBColor('3F3852');
      SelLineText: TRGBColor('918581');
      HighlText: TRGBColor('464F54');
      OutText: TRGBColor('3D3D3D');
      LineNum: TRGBColor('769A93');
      SelLineNum: TRGBColor('DFDFDF');
      HighlLineNum: TRGBColor('7BA39A');
      Envelope: TRGBColor('816E88');
      SelEnvelope: TRGBColor('B4B4B4');
      Noise: TRGBColor('7E6049');
      SelNoise: TRGBColor('B6B6B6');
      Note: TRGBColor('D5D8CA');
      SelNote: TRGBColor('FFFFFF');
      NoteParams: TRGBColor('806E4F');
      SelNoteParams: TRGBColor('CACACA');
      NoteCommands: TRGBColor('8E6B47');
      SelNoteCommands: TRGBColor('CACACA');
      Separators: TRGBColor('2D424E');
      OutSeparators: TRGBColor('2D424E');
      SamOrnBackground: TRGBColor('181F2D');
      SamOrnSelBackground: TRGBColor('1E4769');
      SamOrnText: TRGBColor('9EABA0');
      SamOrnSelText: TRGBColor('B7C4BB');
      SamOrnLineNum: TRGBColor('80A19A');
      SamOrnSelLineNum: TRGBColor('DFDFDF');
      SamNoise: TRGBColor('588150');
      SamSelNoise: TRGBColor('6B9962');
      SamOrnSeparators: TRGBColor('2D424E');
      SamOrnTone: TRGBColor('8F614F');
      SamOrnSelTone: TRGBColor('B38575');
      FullScreenBackground: TRGBColor('12121C');
    ),
    (
      Name: 'Grayscaled Light';
      Background: TRGBColor('FFFFFF');
      SelLineBackground: TRGBColor('666666');
      HighlBackground: TRGBColor('EFEFEF');
      OutBackground: TRGBColor('FFFFFF');
      OutHlBackground: TRGBColor('F9F9F9');
      Text: TRGBColor('929292');
      SelLineText: TRGBColor('CCCCCC');
      HighlText: TRGBColor('4F595F');
      OutText: TRGBColor('B9B9B9');
      LineNum: TRGBColor('6C6C6C');
      SelLineNum: TRGBColor('DFDFDF');
      HighlLineNum: TRGBColor('475056');
      Envelope: TRGBColor('606060');
      SelEnvelope: TRGBColor('E0E0E0');
      Noise: TRGBColor('585858');
      SelNoise: TRGBColor('F7F7F7');
      Note: TRGBColor('383838');
      SelNote: TRGBColor('FFFFFF');
      NoteParams: TRGBColor('696969');
      SelNoteParams: TRGBColor('EAEAEA');
      NoteCommands: TRGBColor('7C7C7C');
      SelNoteCommands: TRGBColor('D2D2D2');
      Separators: TRGBColor('909090');
      OutSeparators: TRGBColor('ACACAC');
      SamOrnBackground: TRGBColor('FFFFFF');
      SamOrnSelBackground: TRGBColor('787878');
      SamOrnText: TRGBColor('6F6F6F');
      SamOrnSelText: TRGBColor('636363');
      SamOrnLineNum: TRGBColor('7E7E7E');
      SamOrnSelLineNum: TRGBColor('ECECEC');
      SamNoise: TRGBColor('484848');
      SamSelNoise: TRGBColor('3C3C3C');
      SamOrnSeparators: TRGBColor('909090');
      SamOrnTone: TRGBColor('5C5C5C');
      SamOrnSelTone: TRGBColor('474747');
      FullScreenBackground: TRGBColor('737373');
    ),
    (
      Name: 'Grayscaled Dark';
      Background: TRGBColor('131313');
      SelLineBackground: TRGBColor('3B3B3B');
      HighlBackground: TRGBColor('191919');
      OutBackground: TRGBColor('0B0B0B');
      OutHlBackground: TRGBColor('1A1A1A');
      Text: TRGBColor('323232');
      SelLineText: TRGBColor('CCCCCC');
      HighlText: TRGBColor('424B50');
      OutText: TRGBColor('323232');
      LineNum: TRGBColor('515151');
      SelLineNum: TRGBColor('DFDFDF');
      HighlLineNum: TRGBColor('7C7C7C');
      Envelope: TRGBColor('606060');
      SelEnvelope: TRGBColor('B4B4B4');
      Noise: TRGBColor('585858');
      SelNoise: TRGBColor('B6B6B6');
      Note: TRGBColor('C5C5C5');
      SelNote: TRGBColor('FFFFFF');
      NoteParams: TRGBColor('696969');
      SelNoteParams: TRGBColor('CACACA');
      NoteCommands: TRGBColor('565656');
      SelNoteCommands: TRGBColor('CACACA');
      Separators: TRGBColor('3A3A3A');
      OutSeparators: TRGBColor('353535');
      SamOrnBackground: TRGBColor('131313');
      SamOrnSelBackground: TRGBColor('393939');
      SamOrnText: TRGBColor('A1A1A1');
      SamOrnSelText: TRGBColor('8B8B8B');
      SamOrnLineNum: TRGBColor('BABABA');
      SamOrnSelLineNum: TRGBColor('909090');
      SamNoise: TRGBColor('B1B1B1');
      SamSelNoise: TRGBColor('BFBFBF');
      SamOrnSeparators: TRGBColor('4E4E4E');
      SamOrnTone: TRGBColor('9E9E9E');
      SamOrnSelTone: TRGBColor('BABABA');
      FullScreenBackground: TRGBColor('101010');
    ),
    (
      Name: 'Dark Blue';
      Background: TRGBColor('101021');
      SelLineBackground: TRGBColor('242478');
      HighlBackground: TRGBColor('181830');
      OutBackground: TRGBColor('0D0D1B');
      OutHlBackground: TRGBColor('141427');
      Text: TRGBColor('2C2739');
      SelLineText: TRGBColor('918581');
      HighlText: TRGBColor('424B50');
      OutText: TRGBColor('364357');
      LineNum: TRGBColor('63494D');
      SelLineNum: TRGBColor('DFDFDF');
      HighlLineNum: TRGBColor('906B70');
      Envelope: TRGBColor('507088');
      SelEnvelope: TRGBColor('B4B4B4');
      Noise: TRGBColor('4C7A67');
      SelNoise: TRGBColor('B6B6B6');
      Note: TRGBColor('CCCCD3');
      SelNote: TRGBColor('FFFFFF');
      NoteParams: TRGBColor('6A463A');
      SelNoteParams: TRGBColor('CACACA');
      NoteCommands: TRGBColor('734D69');
      SelNoteCommands: TRGBColor('CACACA');
      Separators: TRGBColor('242139');
      OutSeparators: TRGBColor('1E1B2F');
      SamOrnBackground: TRGBColor('101021');
      SamOrnSelBackground: TRGBColor('1C1C36');
      SamOrnText: TRGBColor('837F90');
      SamOrnSelText: TRGBColor('A0A2B1');
      SamOrnLineNum: TRGBColor('63494D');
      SamOrnSelLineNum: TRGBColor('8E696E');
      SamNoise: TRGBColor('4F7448');
      SamSelNoise: TRGBColor('6B9962');
      SamOrnSeparators: TRGBColor('3F3B58');
      SamOrnTone: TRGBColor('764F41');
      SamOrnSelTone: TRGBColor('A36E5A');
      FullScreenBackground: TRGBColor('0B0B1A');
    ),
    (
      Name: 'Burgundi';
      Background: TRGBColor('211010');
      SelLineBackground: TRGBColor('772222');
      HighlBackground: TRGBColor('281414');
      OutBackground: TRGBColor('180B0B');
      OutHlBackground: TRGBColor('1D1010');
      Text: TRGBColor('392927');
      SelLineText: TRGBColor('8D5E4D');
      HighlText: TRGBColor('433737');
      OutText: TRGBColor('3F251E');
      LineNum: TRGBColor('914237');
      SelLineNum: TRGBColor('AED697');
      HighlLineNum: TRGBColor('C16F64');
      Envelope: TRGBColor('81814B');
      SelEnvelope: TRGBColor('B4B4B4');
      Noise: TRGBColor('756537');
      SelNoise: TRGBColor('B89878');
      Note: TRGBColor('E8C64D');
      SelNote: TRGBColor('E9C54C');
      NoteParams: TRGBColor('AA654B');
      SelNoteParams: TRGBColor('CB8F79');
      NoteCommands: TRGBColor('4F6C3D');
      SelNoteCommands: TRGBColor('83B761');
      Separators: TRGBColor('402525');
      OutSeparators: TRGBColor('361E1E');
      SamOrnBackground: TRGBColor('211010');
      SamOrnSelBackground: TRGBColor('611919');
      SamOrnText: TRGBColor('B68774');
      SamOrnSelText: TRGBColor('C5A094');
      SamOrnLineNum: TRGBColor('773C34');
      SamOrnSelLineNum: TRGBColor('C1A173');
      SamNoise: TRGBColor('AA654B');
      SamSelNoise: TRGBColor('BE6C4E');
      SamOrnSeparators: TRGBColor('3D2323');
      SamOrnTone: TRGBColor('AE7F43');
      SamOrnSelTone: TRGBColor('C38940');
      FullScreenBackground: TRGBColor('120D0D');
    ),
    (
      Name: 'Night Mode';
      Background: TRGBColor('060906');
      SelLineBackground: TRGBColor('193449');
      HighlBackground: TRGBColor('0B1315');
      OutBackground: TRGBColor('060906');
      OutHlBackground: TRGBColor('080E10');
      Text: TRGBColor('172825');
      SelLineText: TRGBColor('8D5E4D');
      HighlText: TRGBColor('283431');
      OutText: TRGBColor('192329');
      LineNum: TRGBColor('1F4240');
      SelLineNum: TRGBColor('2B706F');
      HighlLineNum: TRGBColor('326A67');
      Envelope: TRGBColor('896241');
      SelEnvelope: TRGBColor('B8875D');
      Noise: TRGBColor('756537');
      SelNoise: TRGBColor('B89878');
      Note: TRGBColor('E7C731');
      SelNote: TRGBColor('E9C54C');
      NoteParams: TRGBColor('476B32');
      SelNoteParams: TRGBColor('5B8A40');
      NoteCommands: TRGBColor('543B31');
      SelNoteCommands: TRGBColor('8D6453');
      Separators: TRGBColor('1A2B2D');
      OutSeparators: TRGBColor('152324');
      SamOrnBackground: TRGBColor('060906');
      SamOrnSelBackground: TRGBColor('432718');
      SamOrnText: TRGBColor('62AD6B');
      SamOrnSelText: TRGBColor('71C77F');
      SamOrnLineNum: TRGBColor('4B4F25');
      SamOrnSelLineNum: TRGBColor('AB8E4D');
      SamNoise: TRGBColor('AA654B');
      SamSelNoise: TRGBColor('BE6C4E');
      SamOrnSeparators: TRGBColor('1A2B2D');
      SamOrnTone: TRGBColor('697530');
      SamOrnSelTone: TRGBColor('6CA04A');
      FullScreenBackground: TRGBColor('060906');
    ),
    (
      Name: 'Night Mode 2';
      Background: TRGBColor('0B0C1B');
      SelLineBackground: TRGBColor('521C1C');
      HighlBackground: TRGBColor('161627');
      OutBackground: TRGBColor('080911');
      OutHlBackground: TRGBColor('12121B');
      Text: TRGBColor('172825');
      SelLineText: TRGBColor('8D5E4D');
      HighlText: TRGBColor('283431');
      OutText: TRGBColor('443727');
      LineNum: TRGBColor('8C7545');
      SelLineNum: TRGBColor('C7C870');
      HighlLineNum: TRGBColor('B69E6C');
      Envelope: TRGBColor('7792A6');
      SelEnvelope: TRGBColor('91A8B9');
      Noise: TRGBColor('786838');
      SelNoise: TRGBColor('B89878');
      Note: TRGBColor('E0E542');
      SelNote: TRGBColor('EDCF69');
      NoteParams: TRGBColor('6F8B42');
      SelNoteParams: TRGBColor('947A46');
      NoteCommands: TRGBColor('A97049');
      SelNoteCommands: TRGBColor('A97049');
      Separators: TRGBColor('4D302A');
      OutSeparators: TRGBColor('2D2423');
      SamOrnBackground: TRGBColor('0B0C1B');
      SamOrnSelBackground: TRGBColor('521C1C');
      SamOrnText: TRGBColor('AC7D6C');
      SamOrnSelText: TRGBColor('CAC34D');
      SamOrnLineNum: TRGBColor('733838');
      SamOrnSelLineNum: TRGBColor('BFB756');
      SamNoise: TRGBColor('B5B92A');
      SamSelNoise: TRGBColor('DDE32D');
      SamOrnSeparators: TRGBColor('4D302A');
      SamOrnTone: TRGBColor('B9662E');
      SamOrnSelTone: TRGBColor('D48048');
      FullScreenBackground: TRGBColor('060906');
    ),
    (
      Name: TRGBColor('School Notebook');
      Background: TRGBColor('FFFFFF');
      SelLineBackground: TRGBColor('414273');
      HighlBackground: TRGBColor('ECF1E4');
      OutBackground: TRGBColor('FFFFFF');
      OutHlBackground: TRGBColor('F8FAF5');
      Text: TRGBColor('8E8F9F');
      SelLineText: TRGBColor('7175B1');
      HighlText: TRGBColor('767996');
      OutText: TRGBColor('918FAF');
      LineNum: TRGBColor('7A7995');
      SelLineNum: TRGBColor('E5E9F5');
      HighlLineNum: TRGBColor('56566C');
      Envelope: TRGBColor('B26853');
      SelEnvelope: TRGBColor('F6DAC3');
      Noise: TRGBColor('756537');
      SelNoise: TRGBColor('B89878');
      Note: TRGBColor('4E4ACB');
      SelNote: TRGBColor('FCFCF2');
      NoteParams: TRGBColor('A5693D');
      SelNoteParams: TRGBColor('D8B296');
      NoteCommands: TRGBColor('A75B83');
      SelNoteCommands: TRGBColor('E8B7D1');
      Separators: TRGBColor('BAB7DB');
      OutSeparators: TRGBColor('C0BEDE');
      SamOrnBackground: TRGBColor('FFFFFF');
      SamOrnSelBackground: TRGBColor('FFFE8B');
      SamOrnText: TRGBColor('62A4C3');
      SamOrnSelText: TRGBColor('519ABC');
      SamOrnLineNum: TRGBColor('658DB6');
      SamOrnSelLineNum: TRGBColor('337FCE');
      SamNoise: TRGBColor('B26853');
      SamSelNoise: TRGBColor('CD421B');
      SamOrnSeparators: TRGBColor('BAB7DB');
      SamOrnTone: TRGBColor('6866A8');
      SamOrnSelTone: TRGBColor('615FAE');
      FullScreenBackground: TRGBColor('3D3D5D');
    ),
    (
      Name: 'Iodine';
      Background: TRGBColor('F7F7E7');
      SelLineBackground: TRGBColor('7D5737');
      HighlBackground: TRGBColor('FFEBD2');
      OutBackground: TRGBColor('F7F7E7');
      OutHlBackground: TRGBColor('EEF1DE');
      Text: TRGBColor('AB9F60');
      SelLineText: TRGBColor('B4A971');
      HighlText: TRGBColor('9D9C54');
      OutText: TRGBColor('B6A573');
      LineNum: TRGBColor('804D38');
      SelLineNum: TRGBColor('FFFAFA');
      HighlLineNum: TRGBColor('6A402E');
      Envelope: TRGBColor('737046');
      SelEnvelope: TRGBColor('FBF5E3');
      Noise: TRGBColor('617544');
      SelNoise: TRGBColor('FBF0EA');
      Note: TRGBColor('29573B');
      SelNote: TRGBColor('FBF0EA');
      NoteParams: TRGBColor('927553');
      SelNoteParams: TRGBColor('FBF0EA');
      NoteCommands: TRGBColor('3F8F38');
      SelNoteCommands: TRGBColor('FBF0EA');
      Separators: TRGBColor('BF9E75');
      OutSeparators: TRGBColor('C6A884');
      SamOrnBackground: TRGBColor('F7F7E7');
      SamOrnSelBackground: TRGBColor('B0884D');
      SamOrnText: TRGBColor('B09172');
      SamOrnSelText: TRGBColor('917F42');
      SamOrnLineNum: TRGBColor('50965A');
      SamOrnSelLineNum: TRGBColor('FDFFE1');
      SamNoise: TRGBColor('3C8F70');
      SamSelNoise: TRGBColor('437F68');
      SamOrnSeparators: TRGBColor('C29E5E');
      SamOrnTone: TRGBColor('AD823E');
      SamOrnSelTone: TRGBColor('A95119');
      FullScreenBackground: TRGBColor('181412');
    ),
    (
      Name: 'Aqua';
      Background: TRGBColor('0B4152');
      SelLineBackground: TRGBColor('3A84BA');
      HighlBackground: TRGBColor('3C4F68');
      OutBackground: TRGBColor('18415B');
      OutHlBackground: TRGBColor('0E4F64');
      Text: TRGBColor('098285');
      SelLineText: TRGBColor('FFFFFF');
      HighlText: TRGBColor('0A989B');
      OutText: TRGBColor('208D9E');
      LineNum: TRGBColor('9DB7C8');
      SelLineNum: TRGBColor('FFFFFF');
      HighlLineNum: TRGBColor('A9C0CF');
      Envelope: TRGBColor('00F782');
      SelEnvelope: TRGBColor('FFFFFF');
      Noise: TRGBColor('EBB54D');
      SelNoise: TRGBColor('FFFFFF');
      Note: TRGBColor('E9FFFF');
      SelNote: TRGBColor('FFFFFF');
      NoteParams: TRGBColor('5EE566');
      SelNoteParams: TRGBColor('FFFFFF');
      NoteCommands: TRGBColor('CBCA1A');
      SelNoteCommands: TRGBColor('FFFFFF');
      Separators: TRGBColor('5B86A3');
      OutSeparators: TRGBColor('5B86A3');
      SamOrnBackground: TRGBColor('0C4A5D');
      SamOrnSelBackground: TRGBColor('0865E0');
      SamOrnText: TRGBColor('9AEFF8');
      SamOrnSelText: TRGBColor('FFFFFF');
      SamOrnLineNum: TRGBColor('9DB7C8');
      SamOrnSelLineNum: TRGBColor('DDFADC');
      SamNoise: TRGBColor('EBB54D');
      SamSelNoise: TRGBColor('EEC456');
      SamOrnSeparators: TRGBColor('DFDFDF');
      SamOrnTone: TRGBColor('FFFFE7');
      SamOrnSelTone: TRGBColor('FFFEA5');
      FullScreenBackground: TRGBColor('072C38');
    ),
    (
      Name: TRGBColor('Red Wine');
      Background: TRGBColor('290D0D');
      SelLineBackground: TRGBColor('911E1E');
      HighlBackground: TRGBColor('350D0D');
      OutBackground: TRGBColor('280C1B');
      OutHlBackground: TRGBColor('31141C');
      Text: TRGBColor('803030');
      SelLineText: TRGBColor('ADBA5F');
      HighlText: TRGBColor('973939');
      OutText: TRGBColor('6E402D');
      LineNum: TRGBColor('CE6262');
      SelLineNum: TRGBColor('FCF9B2');
      HighlLineNum: TRGBColor('F88181');
      Envelope: TRGBColor('BFDE40');
      SelEnvelope: TRGBColor('FCF9B2');
      Noise: TRGBColor('E6D689');
      SelNoise: TRGBColor('FCF9B2');
      Note: TRGBColor('D1D400');
      SelNote: TRGBColor('FFFD9C');
      NoteParams: TRGBColor('C28342');
      SelNoteParams: TRGBColor('FFFD9C');
      NoteCommands: TRGBColor('BF841A');
      SelNoteCommands: TRGBColor('FFFD9C');
      Separators: TRGBColor('431D13');
      OutSeparators: TRGBColor('431D13');
      SamOrnBackground: TRGBColor('2D0E0E');
      SamOrnSelBackground: TRGBColor('892B2B');
      SamOrnText: TRGBColor('AB9D74');
      SamOrnSelText: TRGBColor('C1C298');
      SamOrnLineNum: TRGBColor('B35F5F');
      SamOrnSelLineNum: TRGBColor('FDFCD2');
      SamNoise: TRGBColor('E69746');
      SamSelNoise: TRGBColor('E3AC75');
      SamOrnSeparators: TRGBColor('431D13');
      SamOrnTone: TRGBColor('97BE80');
      SamOrnSelTone: TRGBColor('BDD799');
      FullScreenBackground: TRGBColor('1D0B1E');
    ),
    (
      Name: 'Green State';
      Background: TRGBColor('132416');
      SelLineBackground: TRGBColor('1B5E16');
      HighlBackground: TRGBColor('1D331F');
      OutBackground: TRGBColor('081D13');
      OutHlBackground: TRGBColor('172A19');
      Text: TRGBColor('627A5F');
      SelLineText: TRGBColor('7CD568');
      HighlText: TRGBColor('586D54');
      OutText: TRGBColor('3D5B28');
      LineNum: TRGBColor('AEAB6B');
      SelLineNum: TRGBColor('FEFEEC');
      HighlLineNum: TRGBColor('B4E19C');
      Envelope: TRGBColor('7CDE40');
      SelEnvelope: TRGBColor('FEFEEC');
      Noise: TRGBColor('E6CB89');
      SelNoise: TRGBColor('FEFEEC');
      Note: TRGBColor('B7F2B2');
      SelNote: TRGBColor('FEFEEC');
      NoteParams: TRGBColor('C9A84B');
      SelNoteParams: TRGBColor('FEFEEC');
      NoteCommands: TRGBColor('C2C123');
      SelNoteCommands: TRGBColor('FEFEEC');
      Separators: TRGBColor('37663A');
      OutSeparators: TRGBColor('37663A');
      SamOrnBackground: TRGBColor('182D1B');
      SamOrnSelBackground: TRGBColor('26681A');
      SamOrnText: TRGBColor('B7F2B2');
      SamOrnSelText: TRGBColor('EEEBC0');
      SamOrnLineNum: TRGBColor('9CF8BB');
      SamOrnSelLineNum: TRGBColor('F9E5AA');
      SamNoise: TRGBColor('FCBE64');
      SamSelNoise: TRGBColor('FEE3BA');
      SamOrnSeparators: TRGBColor('38693B');
      SamOrnTone: TRGBColor('FDFC73');
      SamOrnSelTone: TRGBColor('C1EC80');
      FullScreenBackground: TRGBColor('072C38');
     ),
     (
      Name: 'Norton';
      Background: TRGBColor('181F3B');
      SelLineBackground: TRGBColor('414186');
      HighlBackground: TRGBColor('232B4E');
      OutBackground: TRGBColor('0D1536');
      OutHlBackground: TRGBColor('192042');
      Text: TRGBColor('103E59');
      SelLineText: TRGBColor('399FB6');
      HighlText: TRGBColor('355777');
      OutText: TRGBColor('455855');
      LineNum: TRGBColor('9C9F7C');
      SelLineNum: TRGBColor('ECEDD1');
      HighlLineNum: TRGBColor('C9CB9D');
      Envelope: TRGBColor('B5B887');
      SelEnvelope: TRGBColor('E0DE92');
      Noise: TRGBColor('847D42');
      SelNoise: TRGBColor('E0DE92');
      Note: TRGBColor('FBFBD8');
      SelNote: TRGBColor('F4F2A7');
      NoteParams: TRGBColor('D29673');
      SelNoteParams: TRGBColor('E0DE92');
      NoteCommands: TRGBColor('BA7E5A');
      SelNoteCommands: TRGBColor('E0DE92');
      Separators: TRGBColor('1D3656');
      OutSeparators: TRGBColor('1D3656');
      SamOrnBackground: TRGBColor('181F3B');
      SamOrnSelBackground: TRGBColor('3612A3');
      SamOrnText: TRGBColor('D1D3A9');
      SamOrnSelText: TRGBColor('F9F7B7');
      SamOrnLineNum: TRGBColor('C9CB9D');
      SamOrnSelLineNum: TRGBColor('ECEDD1');
      SamNoise: TRGBColor('D5B380');
      SamSelNoise: TRGBColor('E4B771');
      SamOrnSeparators: TRGBColor('0B4569');
      SamOrnTone: TRGBColor('D0AB71');
      SamOrnSelTone: TRGBColor('EDC079');
      FullScreenBackground: TRGBColor('121022');
     )

  );


  WinColors: array[0..22] of Integer = (
    COLOR_SCROLLBAR,  COLOR_MENU, COLOR_MENUTEXT, COLOR_MENUHILIGHT,
    COLOR_MENUBAR, COLOR_WINDOW, COLOR_WINDOWFRAME, COLOR_WINDOWTEXT,
    COLOR_ACTIVEBORDER,COLOR_INACTIVEBORDER, COLOR_APPWORKSPACE,
    COLOR_HIGHLIGHT, COLOR_HIGHLIGHTTEXT, COLOR_BTNFACE, COLOR_BTNSHADOW,
    COLOR_BTNTEXT, COLOR_BTNHIGHLIGHT, COLOR_3DLIGHT,
    COLOR_GRAYTEXT, COLOR_3DDKSHADOW, COLOR_HOTLIGHT,
    COLOR_INFOTEXT, COLOR_INFOBK
  );

  WinColorThemes: array[0..6] of array[0..22] of TColor = (
    (
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    ),
    (
      TColor($00C8D0D4),     // COLOR_SCROLLBAR
      TColor($00E6E3E1),     // COLOR_MENU
      TColor($002D2319),     // COLOR_MENUTEXT
      TColor($007D5F3C),     // COLOR_MENUHILIGHT
      TColor($00E6E3E1),     // COLOR_MENUBAR
      TColor($00F0F0F0),     // COLOR_WINDOW
      TColor($00000000),     // COLOR_WINDOWFRAME
      TColor($002D2319),     // COLOR_WINDOWTEXT
      TColor($00321900),     // COLOR_ACTIVEBORDER
      TColor($00321900),     // COLOR_INACTIVEBORDER
      TColor($00808080),     // COLOR_APPWORKSPACE
      TColor($00735532),     // COLOR_HIGHLIGHT
      TColor($00FFF5EB),     // COLOR_HIGHLIGHTTEXT
      TColor($00E6E3E1),     // COLOR_BTNFACE
      TColor($00D2CFCD),     // COLOR_BTNSHADOW
      TColor($00000000),     // COLOR_BTNTEXT
      TColor($00FAF7F5),     // COLOR_BTNHIGHLIGHT
      TColor($00F5EBE1),     // COLOR_3DLIGHT
      TColor($00AAA096),     // COLOR_GRAYTEXT
      TColor($00C8C5C3),     // COLOR_3DDKSHADOW
      TColor($007D5F3C),     // COLOR_HOTLIGHT
      TColor($00000000),     // COLOR_INFOTEXT
      TColor($00E1FFFF)      // COLOR_INFOBK
    ),
    (
      TColor($00C8D0D4),     // COLOR_SCROLLBAR
      TColor($00E5EDF0),     // COLOR_MENU
      TColor($00000000),     // COLOR_MENUTEXT
      TColor($00958370),     // COLOR_MENUHILIGHT
      TColor($00E5EDF0),     // COLOR_MENUBAR
      TColor($00FBFBFB),     // COLOR_WINDOW
      TColor($00000000),     // COLOR_WINDOWFRAME
      TColor($00000000),     // COLOR_WINDOWTEXT
      TColor($00C8D0D4),     // COLOR_ACTIVEBORDER
      TColor($00C8D0D4),     // COLOR_INACTIVEBORDER
      TColor($00808080),     // COLOR_APPWORKSPACE
      TColor($00958370),     // COLOR_HIGHLIGHT
      TColor($00F5F5F5),     // COLOR_HIGHLIGHTTEXT
      TColor($00E5EDF0),     // COLOR_BTNFACE
      TColor($00C2CDD4),     // COLOR_BTNSHADOW
      TColor($00000000),     // COLOR_BTNTEXT
      TColor($00FAFAFA),     // COLOR_BTNHIGHLIGHT
      TColor($00E9E9E9),     // COLOR_3DLIGHT
      TColor($00969696),     // COLOR_GRAYTEXT
      TColor($00C2CDD4),     // COLOR_3DDKSHADOW
      TColor($0064C8C0),     // COLOR_HOTLIGHT
      TColor($00000000),     // COLOR_INFOTEXT
      TColor($00E0EDEE)      // COLOR_INFOBK
    ),
    (
      TColor($00C8D0D4),     // COLOR_SCROLLBAR
      TColor($00E8E8E8),     // COLOR_MENU
      TColor($00000000),     // COLOR_MENUTEXT
      TColor($00967A55),     // COLOR_MENUHILIGHT
      TColor($00E8E8E8),     // COLOR_MENUBAR
      TColor($00FFFFFF),     // COLOR_WINDOW
      TColor($00000000),     // COLOR_WINDOWFRAME
      TColor($00000000),     // COLOR_WINDOWTEXT
      TColor($00C8D0D4),     // COLOR_ACTIVEBORDER
      TColor($00C8D0D4),     // COLOR_INACTIVEBORDER
      TColor($00808080),     // COLOR_APPWORKSPACE
      TColor($00967A55),     // COLOR_HIGHLIGHT
      TColor($00FFFFFF),     // COLOR_HIGHLIGHTTEXT
      TColor($00E8E8E8),     // COLOR_BTNFACE
      TColor($00C8C8C8),     // COLOR_BTNSHADOW
      TColor($00000000),     // COLOR_BTNTEXT
      TColor($00E8E8E8),     // COLOR_BTNHIGHLIGHT
      TColor($00EBEBEB),     // COLOR_3DLIGHT
      TColor($00C8C8C8),     // COLOR_GRAYTEXT
      TColor($00A0A0A0),     // COLOR_3DDKSHADOW
      TColor($00B7B7B7),     // COLOR_HOTLIGHT
      TColor($00000000),     // COLOR_INFOTEXT
      TColor($00E8E8E8)      // COLOR_INFOBK
    ),
    (
      TColor($00C8D0D4),     // COLOR_SCROLLBAR
      TColor($00FFFFFF),     // COLOR_MENU
      TColor($004B4B4B),     // COLOR_MENUTEXT
      TColor($00EA9A3B),     // COLOR_MENUHILIGHT
      TColor($00F3EFEF),     // COLOR_MENUBAR
      TColor($00FFFFFF),     // COLOR_WINDOW
      TColor($00000000),     // COLOR_WINDOWFRAME
      TColor($00000000),     // COLOR_WINDOWTEXT
      TColor($00C8D0D4),     // COLOR_ACTIVEBORDER
      TColor($00C8D0D4),     // COLOR_INACTIVEBORDER
      TColor($00808080),     // COLOR_APPWORKSPACE
      TColor($00DD7E26),     // COLOR_HIGHLIGHT
      TColor($00FFFFFF),     // COLOR_HIGHLIGHTTEXT
      TColor($00F3EFEF),     // COLOR_BTNFACE
      TColor($00ACA899),     // COLOR_BTNSHADOW
      TColor($00000000),     // COLOR_BTNTEXT
      TColor($00FFFFFF),     // COLOR_BTNHIGHLIGHT
      TColor($00E2EFF1),     // COLOR_3DLIGHT
      TColor($0099A8AC),     // COLOR_GRAYTEXT
      TColor($00C8C5C3),     // COLOR_3DDKSHADOW
      TColor($00800000),     // COLOR_HOTLIGHT
      TColor($00000000),     // COLOR_INFOTEXT
      TColor($00E8E8E8)      // COLOR_INFOBK
    ),
    (
      TColor($00C8D0D4),     // COLOR_SCROLLBAR
      TColor($00DCDCDC),     // COLOR_MENU
      TColor($00000000),     // COLOR_MENUTEXT
      TColor($00926836),     // COLOR_MENUHILIGHT
      TColor($00DCDCDC),     // COLOR_MENUBAR
      TColor($00FFFFFF),     // COLOR_WINDOW
      TColor($00000000),     // COLOR_WINDOWFRAME
      TColor($00000000),     // COLOR_WINDOWTEXT
      TColor($00C8D0D4),     // COLOR_ACTIVEBORDER
      TColor($00C8D0D4),     // COLOR_INACTIVEBORDER
      TColor($00808080),     // COLOR_APPWORKSPACE
      TColor($00926836),     // COLOR_HIGHLIGHT
      TColor($00FFFFFF),     // COLOR_HIGHLIGHTTEXT
      TColor($00DCDCDC),     // COLOR_BTNFACE
      TColor($00B4B4B4),     // COLOR_BTNSHADOW
      TColor($00000000),     // COLOR_BTNTEXT
      TColor($00DCDCDC),     // COLOR_BTNHIGHLIGHT
      TColor($00EBEBEB),     // COLOR_3DLIGHT
      TColor($00B4B4B4),     // COLOR_GRAYTEXT
      TColor($00A0A0A0),     // COLOR_3DDKSHADOW
      TColor($00B7B7B7),     // COLOR_HOTLIGHT
      TColor($00000000),     // COLOR_INFOTEXT
      TColor($00DCDCDC)      // COLOR_INFOBK
    ),
    (
      TColor($00D0D0D0),     // COLOR_SCROLLBAR
      TColor($00FFFFFF),     // COLOR_MENU
      TColor($00000000),     // COLOR_MENUTEXT
      TColor($009A785C),     // COLOR_MENUHILIGHT
      TColor($00FFFFFF),     // COLOR_MENUBAR
      TColor($00FFFFFF),     // COLOR_WINDOW
      TColor($00000000),     // COLOR_WINDOWFRAME
      TColor($00000000),     // COLOR_WINDOWTEXT
      TColor($00D0D0D0),     // COLOR_ACTIVEBORDER
      TColor($00D0D0D0),     // COLOR_INACTIVEBORDER
      TColor($00808080),     // COLOR_APPWORKSPACE
      TColor($0099705E),     // COLOR_HIGHLIGHT
      TColor($00FFFFFF),     // COLOR_HIGHLIGHTTEXT
      TColor($00FFFFFF),     // COLOR_BTNFACE
      TColor($00C2CDD4),     // COLOR_BTNSHADOW
      TColor($00000000),     // COLOR_BTNTEXT
      TColor($00FFFFFF),     // COLOR_BTNHIGHLIGHT
      TColor($00E2EFF1),     // COLOR_3DLIGHT
      TColor($0099A8AC),     // COLOR_GRAYTEXT
      TColor($00C2CDD4),     // COLOR_3DDKSHADOW
      TColor($00800000),     // COLOR_HOTLIGHT
      TColor($00000000),     // COLOR_INFOTEXT
      TColor($00FFFFFF)      // COLOR_INFOBK
    )
  );




  function SelectedThemeName: string;
  function GetThemeIndex(ThemeName: String): Integer;
  function GetColor(Color: TRGBColor): TColor;
  function TColorToRGB(Color: TColor): TRGBColor;
  function ColorThemeExists(ThemeName: string) : boolean;
  function ValidColorThemeName(NewName: string) : boolean;
  function ChangeBrightness(Color: TColor; Shift: Integer): TColor;
  function ChangeBlueColor(Color: TColor; Shift: Integer): TColor;
  function ChangeRedColor(Color: TColor; Shift: Integer): TColor;
  function ChangeGreenColor(Color: TColor; Shift: Integer): TColor;
  function GetSelectionColor(Color: TColor): TColor;
  function GetHighlightColor(Color: TColor): TColor;
  procedure SetupColorBars(Theme: TColorTheme);
  procedure AddColorTheme(Theme: TColorTheme);
  procedure SetColorTheme(Theme: TColorTheme);
  procedure SetColorThemeByName(ThemeName: string);
  procedure InitColorThemes;
  procedure FillColorThemesList;
  procedure UpdateCurrentTheme;
  procedure SaveColorTheme(FileName, ThemeName: String);
  function LoadColorTheme(FileName: String): Boolean;
  procedure CloneColorTheme;
  function GetColorTheme(ThemeName: String): TColorTheme;
  function GetCurrentColorTheme: TColorTheme;
  procedure RenameSelectedTheme;
  procedure DeleteSelectedTheme;
  function AllUserThemesToStr: TThemesArray;
  function LoadColorThemeFromStr(Str: String): TColorTheme;
  procedure SaveSystemColors;
  procedure RestoreSystemColors;
  procedure SetWindowColors(ThemeIndex: Integer);

var
  VTColorThemes: array of TColorTheme;
  SystemColors: array[0..22] of LongInt;

implementation

uses main, options;

function GetColor(Color: TRGBColor): TColor;
var bgr: string;
begin
  bgr := '$00'+Color[5]+Color[6]+Color[3]+Color[4]+Color[1]+Color[2];
  Result := StringToColor(bgr);
end;

function TColorToRGB(Color: TColor): TRGBColor;
begin
  Result := Format('%.2x%.2x%.2x', [byte(color), byte(color shr 8), byte(color shr 16)]);
end;

function ChangeBrightness(Color: TColor; Shift: Integer): TColor;
var
  R, G, B: Integer;
begin
  R := byte(Color);
  G := byte(Color shr 8);
  B := byte(Color shr 16);
  R := R + Shift;
  G := G + Shift;
  B := B + Shift;
  if R < 0 then
    R := 0;
  if R > 255 then
    R := 255;
  if G < 0 then
    G := 0;
  if G > 255 then
    G := 255;
  if B < 0 then
    B := 0;
  if B > 255 then
    B := 255;
  Result := StringToColor(Format('$00%.2x%.2x%.2x', [B, G, R]));
end;

function ChangeBlueColor(Color: TColor; Shift: Integer): TColor;
var
  R, G, B: Integer;
begin
  R := byte(Color);
  G := byte(Color shr 8);
  B := byte(Color shr 16);
  B := B + Shift;
  if B < 0 then
    B := 0;
  if B > 255 then
    B := 255;
  Result := StringToColor(Format('$00%.2x%.2x%.2x', [B, G, R]));
end;

function ChangeRedColor(Color: TColor; Shift: Integer): TColor;
var
  R, G, B: Integer;
begin
  R := byte(Color);
  G := byte(Color shr 8);
  B := byte(Color shr 16);
  R := R + Shift;
  if R < 0 then
    R := 0;
  if R > 255 then
    R := 255;
  Result := StringToColor(Format('$00%.2x%.2x%.2x', [B, G, R]));
end;

function ChangeGreenColor(Color: TColor; Shift: Integer): TColor;
var
  R, G, B: Integer;
begin
  R := byte(Color);
  G := byte(Color shr 8);
  B := byte(Color shr 16);
  G := G + Shift;
  if G < 0 then
    G := 0;
  if G > 255 then
    G := 255;
  Result := StringToColor(Format('$00%.2x%.2x%.2x', [B, G, R]));
end;

function GetSelectionColor(Color: TColor): TColor;
var
  R, G, B, R1, G1, B1: Integer;
begin

  R := byte(Color);
  G := byte(Color shr 8);
  B := byte(Color shr 16);

  R1 := byte(Color);
  G1 := byte(Color shr 8);
  B1 := byte(Color shr 16);

  R := R - 30;
  G := G - 30;
  B := B - 30;

  if R < 40 then
    R := 40;
  if G < 40 then
    G := 40;
  if B < 40 then
    B := 40;

  if (B1 < R1) and (B1 < G1) then
    B := B + 30
  else
  if (R1 < B1) and (R1 < G1) then
    R := R + 30
  else
  if (G1 < B1) and (G1 < R1) then
    G := G + 30
  else
    B := B + 30;

  if R > 200 then
    R := 200;
  if G > 200 then
    G := 200;
  if B > 200 then
    B := 200;

  Result := StringToColor(Format('$00%.2x%.2x%.2x', [B, G, R]));
end;


function GetHighlightColor(Color: TColor): TColor;
var
  R, G, B, R1, G1, B1: Integer;
begin

  R := byte(Color);
  G := byte(Color shr 8);
  B := byte(Color shr 16);

  R1 := byte(Color);
  G1 := byte(Color shr 8);
  B1 := byte(Color shr 16);

  R := R + 15;
  G := G + 15;
  B := B + 15;

  if R > 200 then
    R := 200;
  if G > 200 then
    G := 200;
  if B > 200 then
    B := 200;

  if (B1 < R1) and (B1 < G1) then
    B := B + 10
  else
  if (R1 < B1) and (R1 < G1) then
    R := R + 10
  else
  if (G1 < B1) and (G1 < R1) then
    G := G + 10;

  if R >= 255 then
    R := 200;
  if G >= 255 then
    G := 200;
  if B >= 255 then
    B := 200;

  if R < 40 then
    R := 40;
  if G < 40 then
    G := 40;
  if B < 40 then
    B := 40;

  Result := StringToColor(Format('$00%.2x%.2x%.2x', [B, G, R]));
end;



procedure SetupColorBars(Theme: TColorTheme);
begin
  if not Assigned(Form1) then
    Exit;

  Form1.ColBackground.Brush.Color := GetColor(Theme.Background);
  Form1.ColSelLineBackground.Brush.Color := GetColor(Theme.SelLineBackground);
  Form1.ColHighlBackground.Brush.Color := GetColor(Theme.HighlBackground);
  Form1.ColOutBackground.Brush.Color := GetColor(Theme.OutBackground);
  Form1.ColOutHlBackground.Brush.Color := GetColor(Theme.OutHlBackground);
  Form1.ColText.Brush.Color := GetColor(Theme.Text);
  Form1.ColSelLineText.Brush.Color := GetColor(Theme.SelLineText);
  Form1.ColHighlText.Brush.Color := GetColor(Theme.HighlText);
  Form1.ColOutText.Brush.Color := GetColor(Theme.OutText);
  Form1.ColLineNum.Brush.Color := GetColor(Theme.LineNum);
  Form1.ColSelLineNum.Brush.Color := GetColor(Theme.SelLineNum);
  Form1.ColHighlLineNum.Brush.Color := GetColor(Theme.HighlLineNum);
  Form1.ColEnvelope.Brush.Color := GetColor(Theme.Envelope);
  Form1.ColSelEnvelope.Brush.Color := GetColor(Theme.SelEnvelope);
  Form1.ColNoise.Brush.Color := GetColor(Theme.Noise);
  Form1.ColSelNoise.Brush.Color := GetColor(Theme.SelNoise);
  Form1.ColNote.Brush.Color := GetColor(Theme.Note);
  Form1.ColSelNote.Brush.Color := GetColor(Theme.SelNote);
  Form1.ColNoteParams.Brush.Color := GetColor(Theme.NoteParams);
  Form1.ColSelNoteParams.Brush.Color := GetColor(Theme.SelNoteParams);
  Form1.ColNoteCommands.Brush.Color := GetColor(Theme.NoteCommands);
  Form1.ColSelNoteCommands.Brush.Color := GetColor(Theme.SelNoteCommands);
  Form1.ColSeparators.Brush.Color := GetColor(Theme.Separators);
  Form1.ColOutSeparators.Brush.Color := GetColor(Theme.OutSeparators);
  Form1.ColSamOrnBackground.Brush.Color := GetColor(ColorTheme.SamOrnBackground);
  Form1.ColSamOrnSelBackground.Brush.Color := GetColor(ColorTheme.SamOrnSelBackground);
  Form1.ColSamOrnText.Brush.Color := GetColor(ColorTheme.SamOrnText);
  Form1.ColSamOrnSelText.Brush.Color := GetColor(ColorTheme.SamOrnSelText);
  Form1.ColSamOrnLineNum.Brush.Color := GetColor(ColorTheme.SamOrnLineNum);
  Form1.ColSamOrnSelLineNum.Brush.Color := GetColor(ColorTheme.SamOrnSelLineNum);
  Form1.ColSamNoise.Brush.Color := GetColor(ColorTheme.SamNoise);
  Form1.ColSamSelNoise.Brush.Color := GetColor(ColorTheme.SamSelNoise);
  Form1.ColSamOrnSeparators.Brush.Color := GetColor(ColorTheme.SamOrnSeparators);
  Form1.ColSamOrnTone.Brush.Color := GetColor(ColorTheme.SamOrnTone);
  Form1.ColSamOrnSelTone.Brush.Color := GetColor(ColorTheme.SamOrnSelTone);
  Form1.ColFullScreenBackground.Brush.Color := GetColor(ColorTheme.FullScreenBackground);

end;

function SelectedThemeName: string;
var i: Integer;
begin
  Result := '';
  for i := 0 to Form1.ColorThemesList.Count-1 do
    if Form1.ColorThemesList.Selected[i] then
    begin
      Result := Form1.ColorThemesList.Items[i];
      Exit;
    end;
end;


function GetThemeIndex(ThemeName: String): Integer;
var i: Integer;
begin
  Result := -1;
  for i := 0 to Length(VTColorThemes)-1 do
    if VTColorThemes[i].Name = ThemeName then
    begin
      Result := i;
      break;
    end;
end;


function ColorThemeExists(ThemeName: string) : boolean;
var i: Integer;
begin

  for i := 0 to High(VTColorThemes) do
    if VTColorThemes[i].Name = ThemeName then
    begin
      Result := True;
      Exit;
    end;

  Result := False;

end;

function ValidColorThemeName(NewName: string) : boolean;
begin

  NewName := Trim(NewName);

  if NewName = '' then
  begin
    Result := False;
    Exit;
  end;

  Result := not ColorThemeExists(NewName);

end;


procedure AddColorTheme(Theme: TColorTheme);
var i: Integer;
begin

  // Increase themes array length
  SetLength(VTColorThemes, Length(VTColorThemes)+1);

  // Shift themes
  for i := Length(VTColorThemes)-1 downto 1 do
    VTColorThemes[i] := VTColorThemes[i-1];

  // Insert new theme at first position
  VTColorThemes[0] := Theme;
  ColorTheme := Theme;
  MainForm.PrepareColors;
  FillColorThemesList;

end;


procedure SetColorTheme(Theme: TColorTheme);
var
  i: Integer;
  Redraw: Boolean;
begin
  Redraw := False;
  if ColorThemeName <> Theme.Name then
    Redraw := True;

  ColorThemeName := Theme.Name;
  ColorTheme := Theme;
  MainForm.PrepareColors;
  if Assigned(Form1) then
  begin
    i := GetThemeIndex(Theme.Name);
    Form1.ColorThemesList.Selected[i] := True;
    SetupColorBars(Theme);
  end;

  if Redraw and not SyncVTInstanses then
    MainForm.RedrawChilds;
end;


procedure SetColorThemeByName(ThemeName: string);
var Theme: TColorTheme;
begin
  Theme := GetColorTheme(ThemeName);
  SetColorTheme(Theme);
end;



procedure InitColorThemes;
var
  i: Integer;
begin

  if Length(VTColorThemes) = 0 then
  begin
    SetLength(VTColorThemes, Length(DefaultColorThemes));
    for i := Low(DefaultColorThemes) to High(DefaultColorThemes) do
      VTColorThemes[i] := DefaultColorThemes[i];
  end;

  FillColorThemesList;

  if GetThemeIndex(ColorThemeName) = -1 then
    SetColorTheme(VTColorThemes[0])
  else
    SetColorThemeByName(ColorThemeName);

end;


procedure FillColorThemesList;
var
  I : Integer;
begin
  if not Assigned(Form1) then Exit;
  Form1.ColorThemesList.Clear;

  for I := 0 to Length(VTColorThemes) - 1 do
    begin
     Form1.ColorThemesList.Items.Add(VTColorThemes[I].Name);
      if VTColorThemes[I].Name = ColorThemeName then
        Form1.ColorThemesList.Selected[I] := True;
    end;


  I := GetThemeIndex(ColorThemeName);
  if I = -1 then
  begin
    SetColorTheme(VTColorThemes[0]);
  end
  else
    SetColorTheme(VTColorThemes[I]);

  //Form1.BtnRenameTheme.Enabled := Form1.BtnSaveTheme.Enabled;
  Form1.BtnDelTheme.Enabled := Length(VTColorThemes) > 1;

end;

procedure UpdateCurrentTheme;
var
  Theme: TColorTheme;
  i: Integer;
begin
  Theme := GetCurrentColorTheme;
  i := GetThemeIndex(Theme.Name);
  VTColorThemes[i] := ColorTheme;
end;


procedure SaveColorTheme(FileName, ThemeName: String);
var
  ini: TextFile;
  Theme: TColorTheme;
begin
  Theme := GetColorTheme(ThemeName);
  AssignFile(ini, FileName);
  Rewrite(ini);
  try
    Writeln(ini, '['+ ThemeINIKey +']');
    Writeln(ini, 'Name=' + ThemeName);
    Writeln(ini, 'Background=' + Theme.Background);
    Writeln(ini, 'SelLineBackground=' + Theme.SelLineBackground);
    Writeln(ini, 'HighlBackground=' + Theme.HighlBackground);
    Writeln(ini, 'OutBackground=' + Theme.OutBackground);
    Writeln(ini, 'OutHlBackground=' + Theme.OutHlBackground);
    Writeln(ini, 'Text=' + Theme.Text);
    Writeln(ini, 'SelLineText=' + Theme.SelLineText);
    Writeln(ini, 'HighlText=' + Theme.HighlText);
    Writeln(ini, 'OutText=' + Theme.OutText);
    Writeln(ini, 'LineNum=' + Theme.LineNum);
    Writeln(ini, 'SelLineNum=' + Theme.SelLineNum);
    Writeln(ini, 'HighlLineNum=' + Theme.HighlLineNum);
    Writeln(ini, 'Envelope=' + Theme.Envelope);
    Writeln(ini, 'SelEnvelope=' + Theme.SelEnvelope);
    Writeln(ini, 'Noise=' + Theme.Noise);
    Writeln(ini, 'SelNoise=' + Theme.SelNoise);
    Writeln(ini, 'Note=' + Theme.Note);
    Writeln(ini, 'SelNote=' + Theme.SelNote);
    Writeln(ini, 'NoteParams=' + Theme.NoteParams);
    Writeln(ini, 'SelNoteParams=' + Theme.SelNoteParams);
    Writeln(ini, 'NoteCommands=' + Theme.NoteCommands);
    Writeln(ini, 'SelNoteCommands=' + Theme.SelNoteCommands);
    Writeln(ini, 'Separators=' + Theme.Separators);
    Writeln(ini, 'OutSeparators=' + Theme.OutSeparators);
    Writeln(ini, 'SamOrnBackground=' + Theme.SamOrnBackground);
    Writeln(ini, 'SamOrnSelBackground=' + Theme.SamOrnSelBackground);
    Writeln(ini, 'SamOrnText=' + Theme.SamOrnText);
    Writeln(ini, 'SamOrnSelText=' + Theme.SamOrnSelText);
    Writeln(ini, 'SamOrnLineNum=' + Theme.SamOrnLineNum);
    Writeln(ini, 'SamOrnSelLineNum=' + Theme.SamOrnSelLineNum);
    Writeln(ini, 'SamNoise=' + Theme.SamNoise);
    Writeln(ini, 'SamSelNoise=' + Theme.SamSelNoise);
    Writeln(ini, 'SamOrnSeparators=' + Theme.SamOrnSeparators);
    Writeln(ini, 'SamOrnTone=' + Theme.SamOrnTone);
    Writeln(ini, 'SamOrnSelTone=' + Theme.SamOrnSelTone);
    Writeln(ini, 'FullScreenBackground=' + Theme.FullScreenBackground);
  finally
    CloseFile(ini);
  end;
end;


function LoadColorTheme(FileName: String): Boolean;
var
  ini: TIniFile;
  Theme: TColorTheme;
  i: Integer;
  NewName: String;
  
begin
  Result := True;
  ini := TIniFile.Create(FileName);
  try
    Theme.Name := ini.ReadString(ThemeINIKey,  'Name', '');
    if Theme.Name = '' then begin
      Result := False;
      Exit;
    end;
    Theme.Background := ini.ReadString(ThemeINIKey,  'Background', TColorToRGB(CBackground));
    Theme.SelLineBackground := ini.ReadString(ThemeINIKey,  'SelLineBackground', TColorToRGB(CSelLineBackground));
    Theme.HighlBackground := ini.ReadString(ThemeINIKey,  'HighlBackground', TColorToRGB(CHighlBackground));
    Theme.OutBackground := ini.ReadString(ThemeINIKey,  'OutBackground', TColorToRGB(COutBackground));
    Theme.OutHlBackground := ini.ReadString(ThemeINIKey,  'OutHlBackground', TColorToRGB(COutHlBackground));
    Theme.Text := ini.ReadString(ThemeINIKey,  'Text', TColorToRGB(CText));
    Theme.SelLineText := ini.ReadString(ThemeINIKey,  'SelLineText', TColorToRGB(CSelLineText));
    Theme.HighlText := ini.ReadString(ThemeINIKey,  'HighlText', TColorToRGB(CHighlText));
    Theme.OutText := ini.ReadString(ThemeINIKey,  'OutText', TColorToRGB(COutText));
    Theme.LineNum := ini.ReadString(ThemeINIKey,  'LineNum', TColorToRGB(CLineNum));
    Theme.SelLineNum := ini.ReadString(ThemeINIKey,  'SelLineNum', TColorToRGB(CSelLineNum));
    Theme.HighlLineNum := ini.ReadString(ThemeINIKey,  'HighlLineNum', TColorToRGB(CHighlLineNum));
    Theme.Envelope := ini.ReadString(ThemeINIKey,  'Envelope', TColorToRGB(CEnvelope));
    Theme.SelEnvelope := ini.ReadString(ThemeINIKey,  'SelEnvelope', TColorToRGB(CSelEnvelope));
    Theme.Noise := ini.ReadString(ThemeINIKey,  'Noise', TColorToRGB(CNoise));
    Theme.SelNoise := ini.ReadString(ThemeINIKey,  'SelNoise', TColorToRGB(CSelNoise));
    Theme.Note := ini.ReadString(ThemeINIKey,  'Note', TColorToRGB(CNote));
    Theme.SelNote := ini.ReadString(ThemeINIKey,  'SelNote', TColorToRGB(CSelNote));
    Theme.NoteParams := ini.ReadString(ThemeINIKey,  'NoteParams', TColorToRGB(CNoteParams));
    Theme.SelNoteParams := ini.ReadString(ThemeINIKey,  'SelNoteParams', TColorToRGB(CSelNoteParams));
    Theme.NoteCommands := ini.ReadString(ThemeINIKey,  'NoteCommands', TColorToRGB(CNoteCommands));
    Theme.SelNoteCommands := ini.ReadString(ThemeINIKey,  'SelNoteCommands', TColorToRGB(CSelNoteCommands));
    Theme.Separators := ini.ReadString(ThemeINIKey,  'Separators', TColorToRGB(CSeparators));
    Theme.OutSeparators := ini.ReadString(ThemeINIKey,  'OutSeparators', TColorToRGB(COutSeparators));
    Theme.SamOrnBackground := ini.ReadString(ThemeINIKey,  'SamOrnBackground', TColorToRGB(CSamOrnBackground));
    Theme.SamOrnSelBackground := ini.ReadString(ThemeINIKey,  'SamOrnSelBackground', TColorToRGB(CSamOrnSelBackground));
    Theme.SamOrnText := ini.ReadString(ThemeINIKey,  'SamOrnText', TColorToRGB(CSamOrnText));
    Theme.SamOrnSelText := ini.ReadString(ThemeINIKey,  'SamOrnSelText', TColorToRGB(CSamOrnSelText));
    Theme.SamOrnLineNum := ini.ReadString(ThemeINIKey,  'SamOrnLineNum', TColorToRGB(CSamOrnLineNum));
    Theme.SamOrnSelLineNum := ini.ReadString(ThemeINIKey,  'SamOrnSelLineNum', TColorToRGB(CSamOrnSelLineNum));
    Theme.SamNoise := ini.ReadString(ThemeINIKey,  'SamNoise', TColorToRGB(CSamNoise));
    Theme.SamSelNoise := ini.ReadString(ThemeINIKey,  'SamSelNoise', TColorToRGB(CSamSelNoise));
    Theme.SamOrnSeparators := ini.ReadString(ThemeINIKey,  'SamOrnSeparators', TColorToRGB(CSamOrnSeparators));
    Theme.SamOrnTone := ini.ReadString(ThemeINIKey,  'SamOrnTone', TColorToRGB(CSamOrnTone));
    Theme.SamOrnSelTone := ini.ReadString(ThemeINIKey,  'SamOrnSelTone', TColorToRGB(CSamOrnSelTone));
    Theme.FullScreenBackground := ini.ReadString(ThemeINIKey,  'FullScreenBackground', TColorToRGB(CFullScreenBackground));
    if ColorThemeExists(Theme.Name) then
    begin
      i := 1;
      repeat
        NewName := Theme.Name + ' ' + IntToStr(i);
        Inc(i);
      until not ColorThemeExists(NewName);
      Theme.Name := NewName;
    end;

    AddColorTheme(Theme);
    SetColorTheme(Theme);
    
  finally
    ini.Free;
  end;
  
end;


procedure CloneColorTheme;
var
  NewName: String;
  Theme: TColorTheme;
begin
  Theme := GetCurrentColorTheme;
  repeat
    if not InputQuery('Vortex Tracker II', 'Enter new theme name', NewName) then
      Exit;
  until ValidColorThemeName(NewName);
  Theme.Name := NewName;

  AddColorTheme(Theme);
  SetColorTheme(Theme);
end;



function GetColorTheme(ThemeName: String): TColorTheme;
var
  i: Integer;
  ok: Boolean;
begin
  ok := False;
  for i := 0 to Length(VTColorThemes)-1 do
    if VTColorThemes[i].Name = ThemeName then
    begin
      Result := VTColorThemes[i];
      ok := True;
      Break;
    end;

  if not ok then
    Result := GetColorTheme('Default');

end;


function GetCurrentColorTheme: TColorTheme;
var
  ThemeName: String;
  i: Integer;
begin
  ThemeName := SelectedThemeName;
  for i := 0 to Form1.ColorThemesList.Count-1 do
    if Form1.ColorThemesList.Items[i] = ThemeName then
      Result := VTColorThemes[i];
end;

procedure RenameSelectedTheme;
var
  i: Integer;
  NewName: String;
begin
  i := GetThemeIndex(SelectedThemeName);
  NewName := VTColorThemes[i].Name;

  repeat
    if not InputQuery('Vortex Tracker II', 'Enter a new name', NewName) then
      Exit;
  until ValidColorThemeName(NewName);

  VTColorThemes[i].Name := NewName;
  ColorThemeName := NewName;

  FillColorThemesList;

end;

procedure DeleteSelectedTheme;
var
  Theme: TColorTheme;
  i: Integer;
begin
  Theme := GetCurrentColorTheme;

  if MessageDlg('Are you sure?', mtWarning, mbOKCancel, 0) = mrCancel then
    exit;

  // Shift themes to right
  for i := GetThemeIndex(Theme.Name) to Length(VTColorThemes)-2 do
    VTColorThemes[i] := VTColorThemes[i+1];

  // Decrease themes array
  SetLength(VTColorThemes, Length(VTColorThemes)-1);

  SetColorTheme(VTColorThemes[0]);
  FillColorThemesList;

end;


function AllUserThemesToStr: TThemesArray;
var
  i: Integer;
  s: string;
begin
  SetLength(Result, Length(VTColorThemes));
  for i := Low(VTColorThemes) to High(VTColorThemes) do
    begin
      s := VTColorThemes[i].Name + Chr(180);
      s := s + VTColorThemes[i].Background + ',';
      s := s + VTColorThemes[i].SelLineBackground + ',';
      s := s + VTColorThemes[i].HighlBackground + ',';
      s := s + VTColorThemes[i].OutBackground + ',';
      s := s + VTColorThemes[i].OutHlBackground + ',';
      s := s + VTColorThemes[i].Text + ',';
      s := s + VTColorThemes[i].SelLineText + ',';
      s := s + VTColorThemes[i].HighlText + ',';
      s := s + VTColorThemes[i].OutText + ',';
      s := s + VTColorThemes[i].LineNum + ',';
      s := s + VTColorThemes[i].SelLineNum + ',';
      s := s + VTColorThemes[i].HighlLineNum + ',';
      s := s + VTColorThemes[i].Envelope + ',';
      s := s + VTColorThemes[i].SelEnvelope + ',';
      s := s + VTColorThemes[i].Noise + ',';
      s := s + VTColorThemes[i].SelNoise + ',';
      s := s + VTColorThemes[i].Note + ',';
      s := s + VTColorThemes[i].SelNote + ',';
      s := s + VTColorThemes[i].NoteParams + ',';
      s := s + VTColorThemes[i].SelNoteParams + ',';
      s := s + VTColorThemes[i].NoteCommands + ',';
      s := s + VTColorThemes[i].SelNoteCommands + ',';
      s := s + VTColorThemes[i].Separators + ',';
      s := s + VTColorThemes[i].OutSeparators + ',';
      s := s + VTColorThemes[i].SamOrnBackground + ',';
      s := s + VTColorThemes[i].SamOrnSelBackground + ',';
      s := s + VTColorThemes[i].SamOrnText + ',';
      s := s + VTColorThemes[i].SamOrnSelText + ',';
      s := s + VTColorThemes[i].SamOrnLineNum + ',';
      s := s + VTColorThemes[i].SamOrnSelLineNum + ',';
      s := s + VTColorThemes[i].SamNoise + ',';
      s := s + VTColorThemes[i].SamSelNoise + ',';
      s := s + VTColorThemes[i].SamOrnSeparators + ',';
      s := s + VTColorThemes[i].SamOrnTone + ',';
      s := s + VTColorThemes[i].SamOrnSelTone + ',';
      s := s + VTColorThemes[i].FullScreenBackground;
      Result[i] := s;
    end;
end;

function LoadColorThemeFromStr(Str: String): TColorTheme;
var
  Part, Color: TStrings;

begin

  if Trim(Str) = '' then Exit;
  try
    Part  := Split(Chr(180), Str);
    if Part.Count <> 2 then Exit;
    Color := Split(',', Part[1]);
    if Color.Count <> 36 then Exit;
    if Trim(Part[0]) = '' then Exit;

    Result.Name := Part[0];
    Result.Background := Color[0];
    Result.SelLineBackground := Color[1];
    Result.HighlBackground := Color[2];
    Result.OutBackground := Color[3];
    Result.OutHlBackground := Color[4];
    Result.Text := Color[5];
    Result.SelLineText := Color[6];
    Result.HighlText := Color[7];
    Result.OutText := Color[8];
    Result.LineNum := Color[9];
    Result.SelLineNum := Color[10];
    Result.HighlLineNum := Color[11];
    Result.Envelope := Color[12];
    Result.SelEnvelope := Color[13];
    Result.Noise := Color[14];
    Result.SelNoise := Color[15];
    Result.Note := Color[16];
    Result.SelNote := Color[17];
    Result.NoteParams := Color[18];
    Result.SelNoteParams := Color[19];
    Result.NoteCommands := Color[20];
    Result.SelNoteCommands := Color[21];
    Result.Separators := Color[22];
    Result.OutSeparators := Color[23];
    Result.SamOrnBackground := Color[24];
    Result.SamOrnSelBackground := Color[25];
    Result.SamOrnText := Color[26];
    Result.SamOrnSelText := Color[27];
    Result.SamOrnLineNum := Color[28];
    Result.SamOrnSelLineNum := Color[29];
    Result.SamNoise := Color[30];
    Result.SamSelNoise := Color[31];
    Result.SamOrnSeparators := Color[32];
    Result.SamOrnTone := Color[33];
    Result.SamOrnSelTone := Color[34];
    Result.FullScreenBackground := Color[35];
  finally
    FreeAndNil(Part);
    FreeAndNil(Color);
  end;

end;

procedure SaveSystemColors;
var i: Integer;
begin

  for i := 0 to High(WinColors) do
  begin
    SystemColors[i] := GetSysColor(WinColors[i]);
    WinColorThemes[0][i] := SystemColors[i];
  end;

end;


procedure RestoreSystemColors;
begin
  SetSysColors(Length(SystemColors), WinColors, SystemColors);
end;


procedure SetWindowColors(ThemeIndex: Integer);

begin
  SetSysColors(Length(SystemColors), WinColors, WinColorThemes[ThemeIndex]);
end;


end.
