
background: when you power on your C64, the RAM will not be zero, instead
typically (about) half of the RAM cells will be 1, and the other half will be 0.
this results in some kind of pattern typically (mostly) consisting of $00 and
$ff.

the actual pattern may depend on many things, such as the type of RAM used
(organisation, manufacturer, etc) and the main board.

since a surprising number of programs (probably not deliberatly) depend on the
"correct" RAM init pattern, it is important to get this right in emulation.
(a couple such programs are listed at the end of this document)

http://csdb.dk/forums/?roomid=11&topicid=116800

http://www.c64-wiki.de/index.php/RAM/Herstellercodes
http://www.c64-wiki.de/index.php/RAM#Cross-Referenz-Tabelle

================================================================================

hints on how to examine the init pattern
----------------------------------------

you can examine the init pattern using a cartridge with ML monitor (AR) like
this:

- power off the C64. leave it powered off for at least some minutes (yes really)
- power on the C64
- go to "fastload"
- enter the ML monitor (AR: MON)
- look at the memory in "screencode" mode (AR: I*0800-). let the whole memory
  scroll by, this makes it somewhat easier to recognize a pattern even when a
  bunch of values are not exactly $00 or $ff

if in doubt, save the entire memory range (AR: s"dump" 8 0000 ffff) and send the
file to someone from the VICE team for examination

alternatively you can this oneliner in BASIC:

poke43,0:poke44,0:poke45,255:poke46,255:poke55,255:poke56,255:save"mem",8,1

================================================================================

pattern00ff.prg
---------------

this program scans the RAM area not used by the program itself and tries to find
the page that has least bytes that are neither $00 nor $ff. this page will be
displayed at the bottom (white).

this program will not get useful results for RAMs that show a pattern that is
more complex/longer than one page or when the initial pattern contains other
values than $00 and $ff.

platoontest.prg ("Freeload")
----------------------------

extracted from the original Platoon tape - checks if the memory at $1000-$10ff
has been filled with the same constant value

darkstarbbstest.prg
-------------------

extracted from the original Disk - checks if a couple of pages have been filled
with a constant value (first 10 values), or contain incrementing values in the
first 8 locations.

note: the first test fails on some common RAM init patterns!

cyberloadtest.prg ("Cyberload")
-------------------------------

extracted from the original last ninja tape - checks of a page of memory at
f379 is filled with a constant value and fails if that is the case.

typicaltest.prg
---------------

checks unitialized memory for values that would make the "typical" demo crash
eventually.

================================================================================

patterns used by emulators
--------------------------

CCS64 (3.9)

- page starts with 64 times $ff, then 64 times $00 etc. TODO: additionally the bytes
  at offset $13, $53, $93, $d3 seem to be random

  -raminitstartvalue    255
  -raminitvalueinvert   64
  -raminitpatterninvert 0

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 0
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 0

cyberloadtest.prg - ok 
darkstarbbstest.prg - error 
platoontest.prg - ok 
typicaltest.prg - ok 
  
HOXS54 (1.0.8.8)

- first come two pages with 128 bytes $ff, then 128 bytes $00... followed by two
  pages with 128 bytes $99, then 128 bytes $66. additionally the first bytes of
  each page seems to be random. (this is supposed to be taken from a real C64)

  -raminitstartvalue    255
  -raminitvalueinvert   128
  -raminitpatterninvert 512

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 0x66
  -raminitstartrandom 8
  -raminitrepeatrandom 256
  -raminitrandomchance 0
  
cyberloadtest.prg - ok 
darkstarbbstest.prg - ok
platoontest.prg - ok 
typicaltest.prg - error
  
Micro64 (1.00.2013.05.11 - build 714)
VICE (2.4.27, rev 31063)

- page starts with 64 bytes $00, then 64 bytes $ff etc

  -raminitstartvalue    0
  -raminitvalueinvert   64
  -raminitpatterninvert 0

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 0
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 0

cyberloadtest.prg - ok 
darkstarbbstest.prg - error
platoontest.prg - ok 
typicaltest.prg - error
  
================================================================================

results from real C64s
----------------------

C64 PAL (Impetigo) (ASSY: KU-14194HB, RAM: MB8264-15 / JAPAN 8241 R43 BG)

- page starts with 64 times $ff, then 64 times $00 etc. TODO: some random bytes, more
  or less systematically at offsets:
    $00, $25, $37, $3e, $47, $5f, $69, $6b
    $80, $a5, $b7, $be, $c7, $df, $e9, $eb

  -raminitstartvalue    255
  -raminitvalueinvert   64
  -raminitpatterninvert 0

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 0
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 0
  
  this seems to match the pattern CCS64 uses

C64 PAL Breadbox (gpz) (ASSY NO 250407, RAM: mT4264-15 / USA)

- page starts with $00, then $ff, $00, $ff etc. first 16 bytes of each page seem
  completely random. some more occasional random bytes in the rest of the page.
  pattern seems consistant across the whole memory range.

  -raminitstartvalue    0
  -raminitvalueinvert   1
  -raminitpatterninvert 0

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 0
  -raminitstartrandom 16
  -raminitrepeatrandom 256
  -raminitrandomchance 1
  
cyberloadtest.prg - ok 
darkstarbbstest.prg - ok
platoontest.prg - ok 
typicaltest.prg - error
  
C64 PAL Breadbox (TMR) (ASSY: 250425, RAM: MCM6665BP20 / FQQ8502)

- tendency to alternating $00, $ff but lots of other values. apparently takes a
  long time to loose values.

  -raminitstartvalue    0
  -raminitvalueinvert   1
  -raminitpatterninvert 0

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 0
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 10

cyberloadtest.prg - ok 
darkstarbbstest.prg - ok
platoontest.prg - ok 
typicaltest.prg - error
  
C64 1983 Breadbox (pitcher) (ASSY 250407, RAM: mn4164p / 3n6-15)
C64 1984 Breadbox (pitcher) (ASSY 250425, RAM: mn4164p / 4d1-15)
Educator64 PAL (shock) (ASSY: 326298, RAM: ???)

- page starts with $ff, then $00, $ff, $00 etc. lots of random bytes

  -raminitstartvalue    255
  -raminitvalueinvert   1
  -raminitpatterninvert 0

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 0
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 10

cyberloadtest.prg - ok 
darkstarbbstest.prg - ok
platoontest.prg - ok 
typicaltest.prg - error
  
C64 PAL Breadbox (flavioweb) (ASSY 250407 rev C, RAM: JAPAN3L4U / HM4864P-3)
C64 PAL Breadbox (TMR) (ASSY: 250425, RAM: JAPAN4L3U / HM4864P-3)

- page starts with 2 times $ff, then two times $00. pattern is inverted every
  256 bytes. TODO: occasional random bytes mostly at offsets $71, $7f, $f1, $ff in
  each page.

  -raminitstartvalue    255
  -raminitvalueinvert   2
  -raminitpatterninvert 256

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 255
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 0

cyberloadtest.prg - ok 
darkstarbbstest.prg - ok
platoontest.prg - ok 
typicaltest.prg - error
  
(fierman) (ASSY:250407, RAM: MB8264-15 / JAPAN 8313 R46 BG, RAM: TMM4164P-3 / 3-CC3)
(flavioweb) (ASSY: 240407 REV.A, RAM (ceramic): (F) MB8264-15 / JAPAN 8307 R84 BG)

- repeating pattern of $20 bytes that have mostly all bits 1, then $20 bytes
  that have most bits 0 (no clear $ff, $00 pattern)

  -raminitstartvalue    255
  -raminitvalueinvert   32
  -raminitpatterninvert 0

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 0
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 512

cyberloadtest.prg - ok 
darkstarbbstest.prg - ok
platoontest.prg - ok 
typicaltest.prg - error
  
C64 NTSC Breadbox (gpz) (ASSY 250425, RAM: KM4164B-10 / 931C KOREA)

- page starts with 8 times $00, then 8 times $ff, etc. lots of random bytes at
  no particular offsets. pattern seems to be the same on whole memory range

  -raminitstartvalue    0
  -raminitvalueinvert   8
  -raminitpatterninvert 0

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 0
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 512
  
cyberloadtest.prg - ok 
darkstarbbstest.prg - ok
platoontest.prg - ok 
typicaltest.prg - error
  
C64C PAL (magervalp) (ASSY NO 250469 R3, RAM: M41464-15 / OKI / JAPAN 713028)

- repeating ff,ff,00,00,00,00,ff,ff pattern, $every $4000 bytes the pattern
  seems to be inverted (for another $4000 bytes) ($4000-$7fff and $c000-$ffff
  show the inverted pattern).

  -raminitstartvalue    255
  -raminitvalueinvert   4
  -raminitpatterninvert 16384

  -raminitvalueoffset 2
  -raminitpatterninvertvalue 255
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 0
  
cyberloadtest.prg - ok 
darkstarbbstest.prg - ok
platoontest.prg - ok 
typicaltest.prg - error
  
C64G PAL (flavioweb) (ASSY: ???, RAM: ???)
C64C PAL (Impetigo) (ASSY: 250469 R3, RAM: JAPAN 8704 / HM50464P-15 / U1005ZZ)

- repeating 00,00,ff,ff,ff,ff,00,00 pattern

  -raminitstartvalue    0
  -raminitvalueinvert   4
  -raminitpatterninvert 0

  -raminitvalueoffset 2
  -raminitpatterninvertvalue 0
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 0
  
cyberloadtest.prg - ok 
darkstarbbstest.prg - ok
platoontest.prg - ok 
typicaltest.prg - ok

-> all ok!
  
C64C PAL (gpz) (ASSY NO 250469 R4, RAM: M41464-10 / OKI / JAPAN 833050)

- repeating 00,00,ff,ff,ff,ff,00,00 pattern, $every $4000 bytes the pattern
  seems to be inverted (for another $4000 bytes) ($4000-$7fff and $c000-$ffff
  show the inverted pattern). occasional random bytes, almost none after longer
  power off period.

  -raminitstartvalue    0
  -raminitvalueinvert   4
  -raminitpatterninvert 16384

  -raminitvalueoffset 2
  -raminitpatterninvertvalue 255
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 1
  
cyberloadtest.prg - ok 
darkstarbbstest.prg - ok
platoontest.prg - ok 
typicaltest.prg - ok

-> all ok!
  
C64C PAL (gpz) (ASSY NO 250469 R4, RAM: MN414644-08 / JAPAN 75252)
C64C (christopher jam) (ASSY: ???, RAM: ???)

- page starts with $80 times $00, then $80 times $ff, etc. random bytes only at
  offset 0 of each page. TODO: oddly enough $4000-$cfff show the inverted pattern
  In this C64 the RAM content is persistant for literally minutes after power
  off!

  -raminitstartvalue    0
  -raminitvalueinvert   128
  -raminitpatterninvert 16384   ($4000-$7fff and $c000-$ffff will be inverted)

  -raminitvalueoffset 2
  -raminitpatterninvertvalue 255
  -raminitstartrandom 1
  -raminitrepeatrandom 256
  -raminitrandomchance 0
  
cyberloadtest.prg - ok 
darkstarbbstest.prg - error
platoontest.prg - ok 
typicaltest.prg - ok
  
C64C PAL (flavioweb) (ASSY: ???, RAM: ???)
C64C PAL (david horrocks) (ASSY NO. 260469 NO252311 REV.4, RAM: LH2464-12 SHARP JAPAN 9018 1 SA)

- first come two pages with 128 bytes $ff, then 128 bytes $00... followed by two
  pages with 128 bytes $99, then 128 bytes $66. TODO: very few random bytes, mostly in
  the last byte of each page.

  -raminitstartvalue    255
  -raminitvalueinvert   128
  -raminitpatterninvert 512

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 0x66
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 0

  this seems to match the pattern HOXS64 uses

cyberloadtest.prg - ok 
darkstarbbstest.prg - error
platoontest.prg - ok 
typicaltest.prg - error
  
(hypnosis) (ASSY: 250407, RAM: M3764-20RS OKI Japan 3Y311)

- 128 bytes $ff, then 128 bytes $00... TODO: random bytes somewhat systematically at
  offsets $0f, $10, $18, $38, $3a, $fe, $ff

  -raminitstartvalue    255
  -raminitvalueinvert   128
  -raminitpatterninvert 0

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 0
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 0
 
cyberloadtest.prg - ok 
darkstarbbstest.prg - error
platoontest.prg - ok 
typicaltest.prg - ok
 
C64C PAL (willymanilly) (ASSY: 250466, RAM: MN41464-15 / JAPAN 6D632)

- page starts with 128 times $ff, then 128 times $00. pattern is inverted every
  16k ($4000-$7fff and $c000-$ffff show the inverted pattern). TODO: few random bytes.

  -raminitstartvalue    255
  -raminitvalueinvert   128
  -raminitpatterninvert 16384

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 255
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 0
  
cyberloadtest.prg - ok 
darkstarbbstest.prg - error
platoontest.prg - ok 
typicaltest.prg - ok
  
C64reloaded (gpz)

- page starts with 8 times $00, then 8 times $ff, etc. very few random bytes

  -raminitstartvalue    0
  -raminitvalueinvert   8
  -raminitpatterninvert 0

  -raminitvalueoffset 0
  -raminitpatterninvertvalue 0
  -raminitstartrandom 0
  -raminitrepeatrandom 0
  -raminitrandomchance 1
  
cyberloadtest.prg - ok 
darkstarbbstest.prg - ok
platoontest.prg - ok 
typicaltest.prg - error
  
(karmic) (ASSY: 250466, RAM: NEC D41464C / 8605FU037)

.:c000 03 f0 00 f0 00 f0 03 f0 0f ff 0f ff 0f ff 0f ff
.:c010 81 ff ff ef ff 0f ff 0f f0 00 f0 00 f0 00 f0 00
.:c020 00 f0 00 f0 b0 f0 00 f0 0f ff 0f ff 0f ff 0f ff
.:c030 ff c0 ff 0f ff ef 80 0f f0 00 f0 00 f0 00 f0 01

================================================================================

some problematic programs
-------------------------

Typical/Beyond Force  (https://csdb.dk/release/?id=4136)
 - crashes in upscroller (first part), clearing RAM with zeros before RUN makes
   it work. (to be precise, it requires $3fff being zero)

Flying Shark Preview+/Federation Against Copyright (https://csdb.dk/release/?id=21889)
 - crashes after crack intro, clearing RAM with zeros before RUN makes it work

Comic Art 09/Mayhem (https://csdb.dk/release/?id=38695)
 - crashes shortly after start, starting reset pattern with 255 makes it work
 (packed with "Abuze Crunch", the depacker screws up (unpacked binary works))

Defcom/Jazzcat Cracking Team (https://csdb.dk/release/?id=29387)
 - crashes right at the start, starting reset pattern with 255 makes it work
 (packed with "JCT packer", then "JCT cruncher"

Platoon (original tape) ("Freeload")
Rainbow Islands (original tape)
 - crashes while loading around counter 22 when RAM is cleared with zeros before
   (see above)

Darkstar BBS (original disk)
 - contains a check for typical RAM clear patterns (see above). using an init
   pattern that inverts after at most 10 bytes makes it work.

The Last Ninja (original tape) ("Cyberload")
Bangkok Knights (original tape)
Last Ninja 2 (original tape)
Back to the Future 3 (original tape)
 - contains a check for typical RAM clear pattern (see above). RAM pages may not
   be cleared with a constant value

Advanced Music System
 - https://sourceforge.net/p/vice-emu/bugs/732/
 fill RAM with 0s before starting or start VICE like this:
 x64sc -raminitstartvalue 255
