
Some tests to check REU DMA timing vs VICII (badline- and sprite-) DMA

a.prg:

all 8 Sprites are active, x- and y-expanded, starting at line 132 and 8 lines
apart vertically (y-pos = 132, 140, 148, 156, 164, 172, 180, 188)

one REU transfer is started at the top of the gfx area, producing a color change
in $d020 each cycle.

b.prg:

same as a.prg, but with the gfx area disabled (but still producing badline DMA)

b2.prg:

like b.prg, but the sprites are NOT active

b3.prg:

like b.prg, but the sprites are in revers vertical order (y-pos = 188, 180, 172,
164, 156, 148, 140, 132)

c.prg:

one short REU transfer per 8 rasterlines, offset by one cycle so one will end
on the start of a badline.

- does NOT work in x64sc 3.5 r39581

c2.prg:

like c.prg, but the transfer is one cycle shorter, resulting in a different 
pattern.

- does NOT work in x64sc 3.5 r39581

d.prg:

like c.prg, but with sprite 7 active in the lines where the dma happens

- does NOT work in x64sc 3.5 r39581

d2.prg:

like d.prg, but the transfer is one cycle shorter, resulting in a different 
pattern.

- does NOT work in x64sc 3.5 r39581
