{
This is part of Vortex Tracker II project

Version 2.0 and later
(c)2017-2021 Ivan Pirog, ivan.pirog@gmail.com
https://github.com/ivanpirog/vortextracker
}
unit InstrumentsPack;

interface

const

  SongResources: array[0..11] of string = (
    '2019_MmcM_Conversions',
    '2019_EA_Road_to_Summer',
    '2019_nq_TESTOTUNOHARDOCORE',
    '2019_Fatalsnipe_Vortex_animation',
    '2019_wbcbz7_you_shouldnt_quit_chipping',
    '2019_MmcM_Strange_movements',
    '2019_Kakos_Nonos_Vortex_Power',
    '2019_MmcM_ft_nq_NEStle_for_ears',
    '2018_nq_skrju_demosong',
    '2018_EA_demosong',
    '2018_mmcm_Dreaming_of_Summer_ts',
    '2018_FatalSnipe_CriticalV'
  );

  SampleResources: array[0..373] of array[0..1] of string = (
//  ('FolderName', 'ResourceName')
    ('Synths', 'DownlifterNote1'),
    ('Synths', 'DownlifterNote2'),
    ('Synths', 'DownlifterNote3'),
    ('Synths', 'DownlifterNote4'),
    ('Synths', 'DownlifterNote5'),
    ('Synths', 'DownlifterNote6'),
    ('Synths', 'DownlifterNote7'),
    ('Synths', 'DownlifterNote8'),
    ('Synths', 'DownlifterNote9'),
    ('Synths', 'DownlifterNote10'),
    ('Synths', 'DownlifterNote11'),
    ('Synths', 'DownlifterNote12'),
    ('Synths', 'DownlifterNote13'),
    ('Synths', 'DownlifterNote14'),
    ('Synths', 'LongNote1'),
    ('Synths', 'LongNote2'),
    ('Synths', 'LongNote3'),
    ('Synths', 'LongNote4'),
    ('Synths', 'LongNote5'),
    ('Synths', 'LongNote6'),
    ('Synths', 'LongNote7'),
    ('Synths', 'LongNote8'),
    ('Synths', 'LongNote9'),
    ('Synths', 'LongNote10'),
    ('Synths', 'LongNote11'),
    ('Synths', 'LongNote12'),
    ('Synths', 'LongNote13'),
    ('Synths', 'LongNote14'),
    ('Synths', 'LongNote15'),
    ('Synths', 'LongNote16'),
    ('Synths', 'LongNote17'),
    ('Synths', 'LongNote18'),
    ('Synths', 'LongNote19'),
    ('Synths', 'LongNote20'),
    ('Synths', 'LongNote21'),
    ('Synths', 'LongNote22'),
    ('Synths', 'LongNote23'),
    ('Synths', 'LongNote24'),
    ('Synths', 'LongNote25'),
    ('Synths', 'LongNote26'),
    ('Synths', 'LongNote27'),
    ('Synths', 'SimpleNote1'),
    ('Synths', 'SimpleNote2'),
    ('Synths', 'Synth1'),
    ('Synths', 'Synth2'),
    ('Synths', 'Synth3'),
    ('Synths', 'Synth4'),
    ('Synths', 'Synth5'),
    ('Synths', 'Synth6'),
    ('Synths', 'Synth7'),
    ('Synths', 'Synth8'),
    ('Synths', 'Synth9'),
    ('Synths', 'Synth10'),
    ('Synths', 'Synth11'),
    ('Synths', 'Synth12'),
    ('Synths', 'Synth13'),
    ('Synths', 'Synth14'),
    ('Synths', 'Synth15'),
    ('Synths', 'Synth16'),
    ('Synths', 'Synth17'),
    ('Synths', 'Synth18'),
    ('Synths', 'Synth19'),
    ('Synths', 'Synth20'),
    ('Synths', 'Synth21'),
    ('Synths', 'Synth22'),
    ('Synths', 'Synth23'),
    ('Synths', 'Synth24'),
    ('Synths', 'Synth25'),
    ('Synths', 'Synth26'),
    ('Synths', 'Synth27'),
    ('Synths', 'Synth28'),
    ('Synths', 'Synth29'),
    ('Synths', 'Synth30'),
    ('Synths', 'Synth31'),
    ('Synths', 'Synth32'),
    ('Synths', 'Synth33'),
    ('Synths', 'Synth34'),
    ('Synths', 'UplifterNote1'),
    ('Synths', 'UplifterNote2'),
    ('Synths', 'UplifterNote3'),
    ('Synths', 'UplifterNote4'),
    ('Synths', 'UplifterNote5'),
    ('Synths', 'UplifterNote6'),
    ('Synths', 'UplifterNote7'),
    ('Synths', 'UplifterNote8'),
    ('Synths', 'UplifterNote9'),
    ('Synths', 'UplifterNote10'),
    ('Synths', 'WaveNote1'),
    ('Snares', 'Snare1'),
    ('Snares', 'Snare2'),
    ('Snares', 'Snare3'),
    ('Snares', 'Snare4'),
    ('Snares', 'Snare5'),
    ('Snares', 'Snare6'),
    ('Snares', 'Snare7'),
    ('Snares', 'Snare8'),
    ('Snares', 'Snare9'),
    ('Snares', 'Snare10'),
    ('Snares', 'Snare11'),
    ('Snares', 'Snare12'),
    ('Snares', 'Snare13'),
    ('Snares', 'Snare14'),
    ('Snares', 'Snare15'),
    ('Snares', 'Snare16'),
    ('Snares', 'Snare17'),
    ('Snares', 'Snare18'),
    ('Snares', 'Snare19'),
    ('Snares', 'Snare20'),
    ('Snares', 'Snare21'),
    ('Snares', 'Snare22'),
    ('Snares', 'Snare23'),
    ('Snares', 'Snare24'),
    ('Snares', 'Snare25'),
    ('Snares', 'Snare26'),
    ('Snares', 'Snare27'),
    ('Snares', 'Snare28'),
    ('Snares', 'Snare29'),
    ('Snares', 'Snare30'),
    ('Snares', 'Snare31'),
    ('Snares', 'Snare32'),
    ('Snares', 'Snare33'),
    ('Snares', 'Snare34'),
    ('Snares', 'Snare35'),
    ('Snares', 'Snare36'),
    ('Snares', 'Snare37'),
    ('Snares', 'Snare38'),    
    ('Snares', 'SnareNote1'),
    ('Snares', 'SnareNote2'),
    ('Snares', 'SnareNote3'),
    ('Snares', 'SnareNote4'),
    ('Snares', 'SnareNote5'),
    ('Snares', 'SnareNote6'),
    ('Snares', 'SnareNote7'),
    ('Snares', 'SnareNote8'),
    ('Snares', 'SnareNote9'),
    ('Sequences', 'Sequence1'),
    ('Sequences', 'Sequence2'),
    ('Sequences', 'Sequence3'),
    ('Sequences', 'Sequence4'),
    ('Sequences', 'Sequence5'),
    ('Sequences', 'Sequence6'),
    ('Sequences', 'Sequence7'),
    ('Sequences', 'Sequence8'),
    ('Sequences', 'Sequence9'),
    ('Noises', 'Noise1'),
    ('Noises', 'Noise2'),
    ('Noises', 'Noise3'),
    ('Noises', 'Noise4'),
    ('Noises', 'Noise5'),
    ('Noises', 'Noise6'),
    ('Noises', 'Noise7'),
    ('Noises', 'Noise8'),
    ('Noises', 'Noise9'),
    ('Noises', 'Noise10'),
    ('Noises', 'Noise11'),
    ('Noises', 'Noise12'),
    ('Noises', 'Noise13'),
    ('Noises', 'Noise14'),
    ('Noises', 'Noise15'),
    ('Noises', 'Noise16'),
    ('Noises', 'Noise17'),
    ('Noises', 'Noise18'),
    ('Noises', 'Noise19'),
    ('Noises', 'NoiseNote1'),
    ('Noises', 'NoiseNote2'),
    ('Noises', 'NoiseNote3'),
    ('Noises', 'NoiseNote4'),
    ('Noises', 'NoiseNote5'),
    ('Noises', 'NoiseNote6'),
    ('Noises', 'NoiseNote7'),
    ('Noises', 'NoiseNote8'),
    ('Noises', 'NoiseNote9'),
    ('Noises', 'NoiseNote10'),
    ('Noises', 'NoiseNote11'),
    ('Noises', 'NoiseNote12'),
    ('Noises', 'NoiseNote13'),
    ('Noises', 'NoiseNote14'),
    ('Noises', 'NoiseNote15'),
    ('Noises', 'NoiseNote16'),
    ('Noises', 'NoiseNote17'),
    ('Noises', 'NoiseNote18'),
    ('Noises', 'NoiseNote19'),
    ('Noises', 'NoiseNote20'),
    ('Noises', 'NoiseNote21'),
    ('Noises', 'NoiseNote22'),
    ('Noises', 'NoiseNote23'),
    ('Noises', 'NoiseNote24'),
    ('Noises', 'NoiseNote25'),
    ('Noises', 'NoiseNote26'),
    ('Noises', 'NoiseNote27'),
    ('Noises', 'NoiseSynth1'),
    ('Noises', 'NoiseSynth2'),
    ('Kicks', 'BassDrum1'),
    ('Kicks', 'BassDrum2'),
    ('Kicks', 'BassDrum3'),
    ('Kicks', 'BassDrum4'),
    ('Kicks', 'BassDrum5'),
    ('Kicks', 'BassDrum6'),
    ('Kicks', 'BassDrum7'),
    ('Kicks', 'BassDrum8'),
    ('Kicks', 'BassDrum9'),
    ('Kicks', 'BassDrum10'),
    ('Kicks', 'BassDrum11'),
    ('Kicks', 'BassDrum12'),
    ('Kicks', 'BassDrum13'),
    ('Kicks', 'BassDrum14'),
    ('Kicks', 'BassDrum15'),
    ('Kicks', 'BassDrum16'),
    ('Kicks', 'BassDrum17'),
    ('Kicks', 'BassDrum18'),
    ('Kicks', 'BassDrum19'),
    ('Kicks', 'BassDrum20'),
    ('Kicks', 'BassDrum21'),
    ('Kicks', 'BassDrum22'),
    ('Kicks', 'BassDrum23'),
    ('Kicks', 'BassDrum24'),
    ('Kicks', 'BassDrum25'),    
    ('Kicks', 'DoubleKick'),
    ('Kicks', 'Kick1'),
    ('Kicks', 'Kick2'),
    ('Kicks', 'Kick3'),
    ('Kicks', 'Kick4'),
    ('Kicks', 'Kick5'),
    ('Kicks', 'Kick6'),
    ('Kicks', 'Kick7'),
    ('Kicks', 'Kick8'),
    ('Kicks', 'Kick9'),
    ('Kicks', 'Kick10'),
    ('Kicks', 'Kick11'),
    ('Kicks', 'Kick12'),
    ('Kicks', 'Kick13'),
    ('Kicks', 'Kick14'),
    ('Kicks', 'Kick15'),
    ('Kicks', 'Kick16'),
    ('Kicks', 'Kick17'),
    ('Kicks', 'Kick18'),
    ('Kicks', 'Kick19'),
    ('Kicks', 'Kick20'),
    ('Kicks', 'Kick21'),
    ('Kicks', 'Kick22'),
    ('Kicks', 'Kick23'),
    ('Kicks', 'Kick24'),
    ('Kicks', 'Kick25'),
    ('Kicks', 'Kick26'),
    ('Kicks', 'Kick27'),
    ('Kicks', 'Kick28'),
    ('Kicks', 'Kick29'),
    ('Kicks', 'Kick30'),
    ('Kicks', 'Kick31'),
    ('Kicks', 'Kick32'),
    ('Kicks', 'Kick33'),
    ('Kicks', 'KickBass1'),
    ('Kicks', 'KickNote1'),
    ('Kicks', 'KickNote2'),
    ('Kicks', 'KickNote3'),
    ('Kicks', 'KickNote4'),
    ('Kicks', 'KickNote5'),
    ('Kicks', 'KickNote6'),
    ('Kicks', 'KickNote7'),
    ('Kicks', 'KickNote8'),
    ('Kicks', 'KickNote9'),
    ('Kicks', 'KickNote10'),
    ('Kicks', 'KickNote11'),
    ('Kicks', 'KickNote12'),
    ('Kicks', 'KickNote13'),
    ('Kicks', 'KickNote14'),
    ('Kicks', 'KickNote15'),
    ('Kicks', 'KickNote16'),
    ('Kicks', 'KickNote17'),
    ('Kicks', 'KickNote18'),
    ('Kicks', 'KickNote19'),
    ('Kicks', 'KickNote20'),
    ('Kicks', 'KickNote21'),
    ('Kicks', 'NoiseKick1'),
    ('Kicks', 'NoiseKick2'),
    ('Keys', 'Key1'),
    ('Keys', 'Key2'),
    ('Keys', 'Key3'),
    ('Keys', 'Key4'),
    ('Keys', 'Key5'),
    ('Keys', 'key6'),
    ('Keys', 'key7'),
    ('Keys', 'Key8'),
    ('Keys', 'Key9'),
    ('Keys', 'Key10'),
    ('Keys', 'Key11'),
    ('Keys', 'Key12'),
    ('Keys', 'Key13'),
    ('Keys', 'Key14'),
    ('Keys', 'Key15'),
    ('Keys', 'Key16'),
    ('Keys', 'Key17'),
    ('Keys', 'Key18'),
    ('Keys', 'Key19'),
    ('Keys', 'Key20'),
    ('Keys', 'Key21'),
    ('Keys', 'Key22'),
    ('Keys', 'Key23'),
    ('Keys', 'Key24'),
    ('Keys', 'Key25'),
    ('Keys', 'Key26'),
    ('Keys', 'Key27'),
    ('Keys', 'Key28'),
    ('Keys', 'Key29'),
    ('Keys', 'Key30'),
    ('Keys', 'Key31'),
    ('Keys', 'Key32'),
    ('Keys', 'Key33'),
    ('HitHats', 'HatNote1'),
    ('HitHats', 'HatNote2'),
    ('HitHats', 'HitHat1'),
    ('HitHats', 'HitHat2'),
    ('HitHats', 'HitHat3'),
    ('HitHats', 'HitHat4'),
    ('HitHats', 'HitHat5'),
    ('HitHats', 'HitHat6'),
    ('HitHats', 'HitHat7'),
    ('HitHats', 'HitHat8'),
    ('HitHats', 'HitHat9'),
    ('HitHats', 'HitHat10'),
    ('HitHats', 'HitHat11'),
    ('HitHats', 'HitHat12'),
    ('HitHats', 'HitHat13'),
    ('HitHats', 'HitHat14'),
    ('HitHats', 'HitHat15'),
    ('HitHats', 'HitHat16'),
    ('HitHats', 'HitHat17'),
    ('HitHats', 'HitHat18'),
    ('HitHats', 'HitHat19'),
    ('HitHats', 'HitHat20'),
    ('HitHats', 'HitHat21'),
    ('HitHats', 'HitHat22'),
    ('HitHats', 'HitHat23'),
    ('HitHats', 'HitHat24'),
    ('HitHats', 'HitHat25'),
    ('HitHats', 'HitHatNote1'),
    ('HitHats', 'OpenHitHat1'),
    ('HitHats', 'OpenHitHat2'),
    ('HitHats', 'UnlimiteHitHat'),
    ('FX', 'EngineFX1'),
    ('FX', 'EngineFX2'),
    ('FX', 'Explosion'),
    ('FX', 'Frrr'),
    ('FX', 'FX1'),
    ('FX', 'FX2'),
    ('FX', 'FX3'),
    ('FX', 'FX4'),
    ('FX', 'FX5'),
    ('FX', 'FX6'),
    ('FX', 'FX7'),
    ('FX', 'FX8'),
    ('FX', 'FX9'),
    ('FX', 'FX10'),
    ('FX', 'FX11'),
    ('FX', 'FX12'),
    ('FX', 'FX13'),
    ('FX', 'FX14'),
    ('FX', 'FX15'),
    ('FX', 'FX16'),
    ('FX', 'FX17'),
    ('FX', 'FX18'),
    ('FX', 'FX19'),
    ('FX', 'MachineGun1'),
    ('FX', 'MachineGun2'),
    ('FX', 'MachineGun3'),
    ('FX', 'Morse'),
    ('FX', 'ThunderFX1'),
    ('FX', 'ThunderFX2'),
    ('FX', 'ThunderNote'),
    ('FX', 'UplifterFX1'),
    ('FX', 'UplifterFX2'),
    ('Clicks', 'BassClick1'),
    ('Clicks', 'Click1'),
    ('Clicks', 'Click2')
  );


  OrnamentResources: array[0..94] of string = (
    'Down1',
    'Down2',
    'Down3',
    'Down4',
    'Down5',
    'Down6',
    'Down7',
    'Down8',
    'Down9',
    'Down10',
    'Down11',
    'Down12',
    'Down13',
    'Down14',
    'Down15',
    'Down16',
    'Down17',
    'Down18',
    'Down19',
    'OrnFX1',
    'OrnFX2',
    'OrnFX3',
    'OrnFX4',
    'OrnFX5',
    'OrnFX6',
    'OrnFX7',
    'OrnFX8',
    'OrnFX9',
    'OrnFX10',
    'OrnFX11',
    'OrnFX12',
    'OrnFX13',
    'OrnFX14',
    'OrnFX15',
    'OrnFX16',
    'OrnFX17',
    'OrnFX18',
    'OrnFX19',
    'OrnFX20',
    'OrnFX21',
    'KickFX',
    'Long1',
    'Long2',
    'Long3',
    'Long4',
    'Long5',
    'Ornament1',
    'Ornament2',
    'Ornament3',
    'Ornament4',
    'Ornament5',
    'Ornament6',
    'Ornament7',
    'Ornament8',
    'Ornament9',
    'Ornament10',
    'Ornament11',
    'Ornament12',
    'Ornament13',
    'Ornament14',
    'Ornament15',
    'Ornament16',
    'Ornament17',
    'Ornament18',
    'Ornament19',
    'Ornament20',
    'Ornament21',
    'Ornament22',
    'Ornament23',
    'Ornament24',
    'Ornament25',
    'Ornament26',
    'Ornament27',
    'Ornament28',
    'Ornament29',
    'Ornament30',
    'Ornament31',
    'Ornament32',
    'Ornament33',
    'Ornament34',
    'Up1',
    'Up2',
    'Up3',
    'Up4',
    'Up5',
    'Up6',
    'Up7',
    'Up8',
    'Up9',
    'Up10',
    'Up11',
    'Up12',
    'Uplifter1',
    'Uplifter2',
    'Uplifter3'
  );


implementation

end.
