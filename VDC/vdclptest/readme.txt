VDCLPTEST.PRG

v0.0   2009-06-24 Errol Smith (strobe@kludgesoft.com)

Simple basic program to test lightpen/lightgun on VDC (80 column) c128 screen.

It (should) detect either lightpen or lightgun style button to calibrate. 
Hit space to use default calibrations.

NOTE - it polls the VDC $D600 register to see if a lightpen value is ready. to 
skip this, REM out line 8010

To drop the (annoying) updates of the X/Y registers, REM (or delete) line 8021

