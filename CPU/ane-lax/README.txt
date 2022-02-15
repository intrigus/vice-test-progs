Readme for ane-lax
------------------

format of the dump files:

; results for ANE #imm
;  $1200 bytes with imm value $ff
;  $1200 bytes with imm value $00
;  $1200 bytes with imm value $5a
;  $1200 bytes with imm value $a5

; results for LAX #imm
;  $1200 bytes with imm value $ff
;  $1200 bytes with imm value $00
;  $1200 bytes with imm value $5a
;  $1200 bytes with imm value $a5

for each $1200 bytes, the tests start with A=X=0, A is incremented by 3, X is
incremented by 5 for each test.

-----------------------------------------------------------------------

dump6510_3184.prg
-----------------

Dumped on Machine (tlr):
(four successive dumps at normal operating temperature are identical)
(retested four successive dumps beginning with a cold start.  
 still identical)

C64: PAL Breadbox
Ser# U.K.B 1521345

CPU:  MOS/6510 CBM/3184
CIA1: MOS/6526/3884
CIA2: MOS/6526 R4/3283
VICII: 6569R3 (guess)
SID: <unknown>
(1541U-II plugged in)


dump6510_4782-coldstart/alresult[1-5].prg
-----------------------------------------
Dumped on Machine (tlr):
(five successive dumps directly after power up of a cold box, roughly 2
 minutes between dumps)
This machine sometime has some video glitches on char rom fetches.   
(particularly visible on ".")

C64: PAL Breadbox (silver badge)
Ser# WG C 3264

CPU:  MOS/6510 CBM/4782
CIA1: MOS/6526/3884
CIA2: MOS/6526R4/3583
VICII: 6569R1 (guess)
SID: none
(machine is modified with piggybacked EPROMs on ROMs and some switches)

dump8500_0787-coldstart/alresult[1-5].prg
-----------------------------------------
Dumped on Machine (unseen):
five successive dumps:
- first one was directly after power up
- second one as soon as the first finished saving
- third 8 minutes after power up
- fourth 13 minutes after power up
- fifth 19 minutes after power up

C64C PAL
Assy. 250469

CPU:  MOS/8500R4/0787
CIA1: MOS/6526A/0687
CIA2: MOS/6526A/0687
VICII: MOS/8565R2/0787
SID:  MOS/8680R5/0687
Glue: MOS/251715-01/no datecode, just "S 54ZA"


dump8500_1588-coldstart/alresult[1-5].prg
-----------------------------------------

Dumped on Machine (unseen):
(five successive dumps directly after power up)
Unseen: "first one was cold, box was kept on, timestamps should be correct"
 (00:30, 00:38, 00:42, 00:48, 00:48)
[14:26] Unseen2 just noticed that the RTC of his sd2iec board actually wasn't set, so the timestamps of the ANE-LAX files from yesterday are actually the time when they were copied, not when they were created.
[17:13] _tlr: unseen: thanks!  So the timestamps are still somewhat related to the times?
[17:13] Unseen2: Yes

C64C PAL
Assy. 250469

CPU:  MOS/8500/1588
CIA1: MOS/6526A/2088
CIA2: MOS/6526A/2088
VICII: MOS/8565R2/1988
SID:  MOS/8680R5/2288
Glue: Sharp/251715-01/8823
(2 Mb Neoram cartridge plugged in, machine is modified with
piggybacked EPROM on the kernal rom)


dump8500_1588-cooling/* & dump8500_1588-power/*
-----------------------------------------------

Dumped on Machine (unseen):
(See dumps/dump8500_1588-cooling/README.txt
 and dumps/dump8500_1588-power/README.txt)

C64C PAL
Assy. 250469

CPU:  MOS/8500/1588
CIA1: MOS/6526A/2088
CIA2: MOS/6526A/2088
VICII: MOS/8565R2/1988
SID:  MOS/8680R5/2288
Glue: Sharp/251715-01/8823
(no cartridge)


-----------------------------------------------------------------------
eof
