Cmp C000.bin C201.bin C100.bin ZXAY.bin 651 C000.cor
@if errorlevel 1 goto fail
Cmp C000TS.bin C201TS.bin C100TS.bin ZXTS.bin 951 C000TS.cor
@if errorlevel 1 goto fail
BRCC32 ZX.rc
@goto ex
:fail
@echo Cmp parameter error
:ex