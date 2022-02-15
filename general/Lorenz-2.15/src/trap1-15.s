; this file is part of the C64 Emulator Test Suite. public domain, no copyright

; original file was: trap1-15.asm
;-------------------------------------------------------------------------------

            .include "common.asm"
            .include "printhb.asm"
            ;.include "waitborder.asm"
            ;.include "waitkey.asm"
            ;.include "showregs.asm"
           
;------------------------------------------------------------------------------           
thisname   ; name of this test
           .text "trap"
           .ifmi TRAP - 10
           .byte $30 + TRAP
           .else
           .byte $31
           .byte $30 + (TRAP - 10)
           .endif
           .byte 0
nextname   ; name of next test, "-" means no more tests
           .text "trap"
           .ifmi TRAP - 9
           .byte $31 + TRAP
           .else
           .byte $31
           .byte $30 + (TRAP - 9)
           .endif
;------------------------------------------------------------------------------           
           
           
; #  code  data  zd  zptr   aspect tested
;-----------------------------------------------------------------------------
; 1  2800  29C0  F7  F7/F8  basic functionality
.ifeq TRAP - 1
code       = $2800
data       = $29c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 2  2FFE  29C0  F7  F7/F8  4k boundary within 3 byte commands
.ifeq TRAP - 2
code       = $2ffe
data       = $29c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 3  2FFF  29C0  F7  F7/F8  4k boundary within 2 and 3 byte commands
.ifeq TRAP - 3
code       = $2fff
data       = $29c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 4  D000  29C0  F7  F7/F8  IO traps for code fetch
.ifeq TRAP - 4
code       = $d000
data       = $29c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 5  CFFE  29C0  F7  F7/F8  RAM/IO boundary within 3 byte commands
.ifeq TRAP - 5
code       = $cffe
data       = $29c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 6  CFFF  29C0  F7  F7/F8  RAM/IO boundary within 2 and 3 byte commands
.ifeq TRAP - 6
code       = $cfff
data       = $29c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 7  2800  D0C0  F7  F7/F8  IO traps for 16 bit data access
.ifeq TRAP - 7
code       = $2800
data       = $d0c0
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 8  2800  D000  F7  F7/F8  IO trap adjustment in ax, ay and iy addressing
.ifeq TRAP - 8
code       = $2800
data       = $d000
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
; 9  2800  29C0  02  F7/F8  wrap around in zx and zy addressing
.ifeq TRAP - 9
code       = $2800
data       = $29c0
zerodata   = $02
zeroptr    = $f7;$f8
.endif
;10  2800  29C0  00  F7/F8  IO traps for 8 bit data access
.ifeq TRAP - 10
code       = $2800
data       = $29c0
zerodata   = $00
zeroptr    = $f7;$f8
.endif
;11  2800  29C0  F7  02/03  wrap around in ix addressing
.ifeq TRAP - 11
code       = $2800
data       = $29c0
zerodata   = $f7
zeroptr    = $02;$03
.endif
;12  2800  29C0  F7  FF/00  wrap around and IO trap for pointer accesses
.ifeq TRAP - 12
code       = $2800
data       = $29c0
zerodata   = $f7
zeroptr    = $ff;$00
.endif
;13  2800  0002  F7  F7/F8  64k wrap around in ax, ay and iy addressing
.ifeq TRAP - 13
code       = $2800
data       = $0002
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
;14  2800  0000  F7  F7/F8  64k wrap around plus IO trap
.ifeq TRAP - 14
code       = $2800
data       = $0000
zerodata   = $f7
zeroptr    = $f7;$f8
.endif
;15  CFFF  D0C6  00  FF/00  1-14 all together as a stress test
.ifeq TRAP - 15
code       = $cfff
data       = $d0c6
zerodata   = $00
zeroptr    = $ff;$00
.endif


ptable     = 172    ;173
bcmd       .byte 0  ;opcode
pcode      = 174    ;175

db         = %00011011
ab         = %11000110
xb         = %10110001
yb         = %01101100

da         = data
aa         .byte 0
xa         .byte 0
ya         .byte 0
pa         .byte 0

main:
           
           ; read ANE "magic constant"
           lda #0
           ldx #$ff
           ane #$ff
           sta anemagic
           ; calc reference test result
           lda #$c6 ; value in A
anemagic = * + 1
           ora #0
           and #$1b ; immediate value used in the test
           and #$b1 ; value in X
           sta aneresult
           ; reference status
           lda aneresult
           and #$80
           ora #$30
           sta aneresultstatus
           lda aneresult
           bne sk1
           lda aneresultstatus
           ora #$02
           sta aneresultstatus
sk1:
           ; read the LAX "magic constant"
           lda #0
           .byte $ab, $ff
           sta laxmagic
           ; calc reference test result
           lda #$c6 ; value in A
laxmagic = * + 1
           ora #0
           and #$1b ; immediate value used in the test
           sta laxresulta
           sta laxresultx
           ; reference status
           lda laxresulta
           and #$80
           ora #$30
           sta laxresultstatus
           lda laxresulta
           bne sk2
           lda laxresultstatus
           ora #$02
           sta laxresultstatus
sk2:          

           lda #<code
           sta pcode+0
           lda #>code
           sta pcode+1

           lda #<table
           sta ptable+0
           lda #>table
           sta ptable+1

nextcommand

           ldy #0
           lda bcmd
           sta (pcode),y
           lda #$60
           iny
           sta (pcode),y
           iny
           sta (pcode),y
           iny
           sta (pcode),y
           ldy #3
           lda (ptable),y
           sta jump+1
           iny
           lda (ptable),y
           sta jump+2
waitborder
           lda $d011
           bpl waitborder
;           bmi jump
;           lda $d012
;           cmp #30
;           bcs waitborder
jump       jsr $1111

           ldy #5
           lda da
           cmp (ptable),y
           bne error
           iny
           lda aa
           cmp (ptable),y
           bne error
           iny
           lda xa
           cmp (ptable),y
           bne error
           iny
           lda ya
           cmp (ptable),y
           bne error
           iny
           lda pa
           cmp (ptable),y
           bne error
nostop
           clc
           lda ptable+0
           adc #10
           sta ptable+0
           lda ptable+1
           adc #0
           sta ptable+1
           inc bcmd
           bne jmpnextcommand
           jmp ok
jmpnextcommand
           jmp nextcommand

error
           lda #13
           jsr $ffd2
           ldy #0
           lda (ptable),y
           jsr $ffd2
           iny
           lda (ptable),y
           jsr $ffd2
           iny
           lda (ptable),y
           jsr $ffd2
           lda #32
           jsr $ffd2
           lda bcmd
           jsr printhb
           jsr print
           .byte 13
           .text "after  "
           .byte 0
           lda da
           jsr printhb
           lda #32
           jsr $ffd2
           jsr $ffd2
           lda aa
           jsr printhb
           lda #32
           jsr $ffd2
           lda xa
           jsr printhb
           lda #32
           jsr $ffd2
           lda ya
           jsr printhb
           lda #32
           jsr $ffd2
           jsr $ffd2
           lda pa
           jsr printhb
           jsr print
           .byte 13
           .text "right  "
           .byte 0
           ldy #5
           lda (ptable),y
           jsr printhb
           lda #32
           jsr $ffd2
           jsr $ffd2
           iny
           lda (ptable),y
           jsr printhb
           lda #32
           jsr $ffd2
           iny
           lda (ptable),y
           jsr printhb
           lda #32
           jsr $ffd2
           iny
           lda (ptable),y
           jsr printhb
           lda #32
           jsr $ffd2
           jsr $ffd2
           iny
           lda (ptable),y
           jsr printhb
           lda #13
           jsr $ffd2

            #SET_EXIT_CODE_FAILURE

wait     jsr $ffe4
         beq wait

           jmp nostop
return
           lda #$37
           sta 1
           lda #$2f
           sta 0
           rts

ok
            rts ; SUCCESS


savesp     .byte 0
savedstack = $2a00;2aff


savestack
           .block
           tsx
           stx savesp
           ldx #0
save
           lda $0100,x
           sta savedstack,x
           inx
           bne save
           rts
           .bend


restorestack
           .block
           pla
           sta retlow+1
           pla
           sta rethigh+1
           ldx savesp
           inx
           inx
           txs
           ldx #0
restore
           lda savedstack,x
           sta $0100,x
           inx
           bne restore
rethigh
           lda #$11
           pha
retlow
           lda #$11
           pha
           rts
           .bend

execute
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jsr jmppcode
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts

jmppcode
           jmp (pcode)

n
           jsr execute
           rts

b
           lda #db
           ldy #1
           sta (pcode),y
           jsr execute
           rts

z
           lda #zerodata
           ldy #1
           sta (pcode),y
           lda #db
           sta zerodata
           jsr execute
           lda zerodata
           sta da
           rts

zx
           lda #(zerodata-xb)&$ff
           ldy #1
           sta (pcode),y
           lda #db
           sta zerodata
           jsr execute
           lda zerodata
           sta da
           rts

zy
           lda #(zerodata-yb)&$ff
           ldy #1
           sta (pcode),y
           lda #db
           sta zerodata
           jsr execute
           lda zerodata
           sta da
           rts

a_
           ldy #1
           lda #<da
           sta (pcode),y
           iny
           lda #>da
           sta (pcode),y
           jsr execute
           rts

ax
           ldy #1
           lda #<(da-xb)
           sta (pcode),y
           iny
           lda #>(da-xb)
           sta (pcode),y
           jsr execute
           rts

ay
           ldy #1
           lda #<(da-yb)
           sta (pcode),y
           iny
           lda #>(da-yb)
           sta (pcode),y
           jsr execute
           rts

ix
           ldy #1
           lda #(zeroptr-xb)&$ff
           sta (pcode),y
           lda #<da
           sta zeroptr+0&$ff
           lda #>da
           sta zeroptr+1&$ff
           jsr execute
           rts

iy
           ldy #1
           lda #zeroptr
           sta (pcode),y
           lda #<(da-yb)
           sta zeroptr+0&$ff
           lda #>(da-yb)
           sta zeroptr+1&$ff
           jsr execute
           rts

r
           lda #1
           ldy #1
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jsr jmppcode
           lda #$f3
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jsr jmppcode
           dec pcode+1
           lda #$60
           ldy #130
           sta (pcode),y
           inc pcode+1
           lda #128
           ldy #1
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jsr jmppcode
           lda #$f3
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jsr jmppcode
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts

hltn
           lda #0
           sta da
           sta aa
           sta xa
           sta ya
           sta pa
           rts

brkn
           .block
           lda #<continue
           sta $fffe
           lda #>continue
           sta $ffff
           sei
           lda 0
           sta old0+1
           lda #47
           sta 0
           lda 1
           sta old1+1
           and #$fd
           sta 1
           lda #0
           pha
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
old1
           lda #$11
           sta 1
old0
           lda #$11
           sta 0
           lda #db
           sta da
           cli
           pla
           pla
           pla
           rts
           .bend

jmpi
           .block
           lda #<zeroptr
           ldy #1
           sta (pcode),y
           lda #>zeroptr
           iny
           sta (pcode),y
           lda #<continue
           sta zeroptr+0&$ff
           lda #>continue
           sta zeroptr+1&$ff
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts
           .bend

jmpw
           .block
           lda #<continue
           ldy #1
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts
           .bend

jsrw
           .block
           lda #<continue
           ldy #1
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           pla
           pla
           rts
           .bend


rtin
           .block
           lda #>continue
           pha
           lda #<continue
           pha
           lda #$b3
           pha
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts
           .bend

txsn
           .block
           lda #$4c
           ldy #1
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           jsr savestack
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           tsx
           stx newsp+1
           jsr restorestack
newsp
           lda #$11
           cmp #xb
           bne wrong
           rts
wrong
           pla
           pla
           jmp error
           .bend

plan
           .block
           lda #$4c
           ldy #1
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #$f0
           pha
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts
           .bend

phan
           .block
           lda #$4c
           ldy #1
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           pla
           cmp #ab
           bne wrong
           rts
wrong
           pla
           pla
           jmp error
           .bend

plpn
           .block
           lda #$4c
           ldy #1
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #$b3
           pha
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           rts
           .bend

phpn
           .block
           lda #$4c
           ldy #1
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           pla
           cmp #$30
           bne wrong
           rts
wrong
           pla
           pla
           jmp error
           .bend


shaay
           .ifpl da&$ff-$c0
           lda #>da
           clc
           adc #1
           and #ab
           and #xb
           ldy #5
           sta (ptable),y
           jmp ay
           .endif
shaiy
           .ifpl da&$ff-$c0
           lda #>da
           clc
           adc #1
           and #ab
           and #xb
           ldy #5
           sta (ptable),y
           jmp iy
           .endif
shxay
           .ifpl da&$ff-$c0
           lda #>da
           clc
           adc #1
           and #xb
           ldy #5
           sta (ptable),y
           jmp ay
           .endif
shyax
           .ifpl da&$ff-$c0
           lda #>da
           clc
           adc #1
           and #yb
           ldy #5
           sta (ptable),y
           jmp ax
           .endif
shsay
           .ifpl da&$ff-$c0
           .block
           lda #ab
           and #xb
           sta sr+1
           ldx #>da
           inx
           stx andx+1
andx
           and #$11
           ldy #5
           sta (ptable),y
           jsr savestack
           lda #<da-yb
           ldy #1
           sta (pcode),y
           lda #>da-yb
           iny
           sta (pcode),y
           lda #$4c
           iny
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           tsx
           stx sa+1
           jsr restorestack
sa
           lda #$11
           ldy #6
sr
           cmp #$11
           bne wrong
           rts
wrong
           pla
           pla
           jmp error
           .bend
           .endif

           .ifmi da&$ff-$c0
           pla
           pla
           jmp nostop
           .endif


lasay
           .block
           tsx
           txa
           and #db
           php
           ldy #6
           sta (ptable),y
           iny
           sta (ptable),y
           pla
           and #%10110010
           ldy #9
           sta (ptable),y
           jsr savestack
           lda #<da-yb
           ldy #1
           sta (pcode),y
           lda #>da-yb
           iny
           sta (pcode),y
           lda #$4c
           iny
           sta (pcode),y
           lda #<continue
           iny
           sta (pcode),y
           lda #>continue
           iny
           sta (pcode),y
           lda #0
           pha
           lda #db
           sta da
           lda #ab
           ldx #xb
           ldy #yb
           plp
           jmp (pcode)
continue
           php
           cld
           sta aa
           stx xa
           sty ya
           pla
           sta pa
           tsx
           stx sa+1
           jsr restorestack
sa
           lda #$11
           ldy #6
           cmp (ptable),y
           bne wrong
           rts
wrong
           pla
           pla
           jmp error
           .bend

tsxn
           jsr execute
           tsx
           dex
           dex
           dex
           dex
           php
           txa
           ldy #7
           sta (ptable),y
           pla
           ldy #9
           sta (ptable),y
           rts

           
           ; byte after opcode, returned akku, returned x, returned y, returned status
table
           .text "brk"
           .word brkn
           .byte $1b,$c6,$b1,$6c,$34
           .text "ora"
           .word ix
           .byte $1b,$df,$b1,$6c,$b0
           .text "hlt"
           .word hltn
           .byte $00,$00,$00,$00,$00
           .text "aso"
           .word ix
           .byte $36,$f6,$b1,$6c,$b0
           .text "nop"
           .word z
           .byte $1b,$c6,$b1,$6c,$30
           .text "ora"
           .word z
           .byte $1b,$df,$b1,$6c,$b0
           .text "asl"
           .word z
           .byte $36,$c6,$b1,$6c,$30
           .text "aso"
           .word z
           .byte $36,$f6,$b1,$6c,$b0
           .text "php"
           .word phpn
           .byte $1b,$c6,$b1,$6c,$30
           .text "ora"
           .word b
           .byte $1b,$df,$b1,$6c,$b0
           .text "asl"
           .word n
           .byte $1b,$8c,$b1,$6c,$b1
           .text "anc"
           .word b
           .byte $1b,$02,$b1,$6c,$30
           .text "nop"
           .word a_
           .byte $1b,$c6,$b1,$6c,$30
           .text "ora"
           .word a_
           .byte $1b,$df,$b1,$6c,$b0
           .text "asl"
           .word a_
           .byte $36,$c6,$b1,$6c,$30
           .text "aso"
           .word a_
           .byte $36,$f6,$b1,$6c,$b0
           .text "bpl"
           .word r
           .byte $1b,$c6,$b1,$6c,$f3
           .text "ora"
           .word iy
           .byte $1b,$df,$b1,$6c,$b0
           .text "hlt"
           .word hltn
           .byte $00,$00,$00,$00,$00
           .text "aso"
           .word iy
           .byte $36,$f6,$b1,$6c,$b0
           .text "nop"
           .word zx
           .byte $1b,$c6,$b1,$6c,$30
           .text "ora"
           .word zx
           .byte $1b,$df,$b1,$6c,$b0
           .text "asl"
           .word zx
           .byte $36,$c6,$b1,$6c,$30
           .text "aso"
           .word zx
           .byte $36,$f6,$b1,$6c,$b0
           .text "clc"
           .word n
           .byte $1b,$c6,$b1,$6c,$30
           .text "ora"
           .word ay
           .byte $1b,$df,$b1,$6c,$b0
           .text "nop"
           .word n
           .byte $1b,$c6,$b1,$6c,$30
           .text "aso"
           .word ay
           .byte $36,$f6,$b1,$6c,$b0
           .text "nop"
           .word ax
           .byte $1b,$c6,$b1,$6c,$30
           .text "ora"
           .word ax
           .byte $1b,$df,$b1,$6c,$b0
           .text "asl"
           .word ax
           .byte $36,$c6,$b1,$6c,$30
           .text "aso"
           .word ax
           .byte $36,$f6,$b1,$6c,$b0
           .text "jsr"
           .word jsrw
           .byte $1b,$c6,$b1,$6c,$30
           .text "and"
           .word ix
           .byte $1b,$02,$b1,$6c,$30
           .text "hlt"
           .word hltn
           .byte $00,$00,$00,$00,$00
           .text "rla"
           .word ix
           .byte $36,$06,$b1,$6c,$30
           .text "bit"
           .word z
           .byte $1b,$c6,$b1,$6c,$30
           .text "and"
           .word z
           .byte $1b,$02,$b1,$6c,$30
           .text "rol"
           .word z
           .byte $36,$c6,$b1,$6c,$30
           .text "rla"
           .word z
           .byte $36,$06,$b1,$6c,$30
           .text "plp"
           .word plpn
           .byte $1b,$c6,$b1,$6c,$b3
           .text "and"
           .word b
           .byte $1b,$02,$b1,$6c,$30
           .text "rol"
           .word n
           .byte $1b,$8c,$b1,$6c,$b1
           .text "anc"
           .word b
           .byte $1b,$02,$b1,$6c,$30
           .text "bit"
           .word a_
           .byte $1b,$c6,$b1,$6c,$30
           .text "and"
           .word a_
           .byte $1b,$02,$b1,$6c,$30
           .text "rol"
           .word a_
           .byte $36,$c6,$b1,$6c,$30
           .text "rla"
           .word a_
           .byte $36,$06,$b1,$6c,$30
           .text "bmi"
           .word r
           .byte $1b,$c6,$b1,$6c,$f3
           .text "and"
           .word iy
           .byte $1b,$02,$b1,$6c,$30
           .text "hlt"
           .word hltn
           .byte $00,$00,$00,$00,$00
           .text "rla"
           .word iy
           .byte $36,$06,$b1,$6c,$30
           .text "nop"
           .word zx
           .byte $1b,$c6,$b1,$6c,$30
           .text "and"
           .word zx
           .byte $1b,$02,$b1,$6c,$30
           .text "rol"
           .word zx
           .byte $36,$c6,$b1,$6c,$30
           .text "rla"
           .word zx
           .byte $36,$06,$b1,$6c,$30
           .text "sec"
           .word n
           .byte $1b,$c6,$b1,$6c,$31
           .text "and"
           .word ay
           .byte $1b,$02,$b1,$6c,$30
           .text "nop"
           .word n
           .byte $1b,$c6,$b1,$6c,$30
           .text "rla"
           .word ay
           .byte $36,$06,$b1,$6c,$30
           .text "nop"
           .word ax
           .byte $1b,$c6,$b1,$6c,$30
           .text "and"
           .word ax
           .byte $1b,$02,$b1,$6c,$30
           .text "rol"
           .word ax
           .byte $36,$c6,$b1,$6c,$30
           .text "rla"
           .word ax
           .byte $36,$06,$b1,$6c,$30
           .text "rti"
           .word rtin
           .byte $1b,$c6,$b1,$6c,$b3
           .text "eor"
           .word ix
           .byte $1b,$dd,$b1,$6c,$b0
           .text "hlt"
           .word hltn
           .byte $00,$00,$00,$00,$00
           .text "lse"
           .word ix
           .byte $0d,$cb,$b1,$6c,$b1
           .text "nop"
           .word z
           .byte $1b,$c6,$b1,$6c,$30
           .text "eor"
           .word z
           .byte $1b,$dd,$b1,$6c,$b0
           .text "lsr"
           .word z
           .byte $0d,$c6,$b1,$6c,$31
           .text "lse"
           .word z
           .byte $0d,$cb,$b1,$6c,$b1
           .text "pha"
           .word phan
           .byte $1b,$c6,$b1,$6c,$30
           .text "eor"
           .word b
           .byte $1b,$dd,$b1,$6c,$b0
           .text "lsr"
           .word n
           .byte $1b,$63,$b1,$6c,$30
           .text "alr"
           .word b
           .byte $1b,$01,$b1,$6c,$30
           .text "jmp"
           .word jmpw
           .byte $1b,$c6,$b1,$6c,$30
           .text "eor"
           .word a_
           .byte $1b,$dd,$b1,$6c,$b0
           .text "lsr"
           .word a_
           .byte $0d,$c6,$b1,$6c,$31
           .text "lse"
           .word a_
           .byte $0d,$cb,$b1,$6c,$b1
           .text "bvc"
           .word r
           .byte $1b,$c6,$b1,$6c,$f3
           .text "eor"
           .word iy
           .byte $1b,$dd,$b1,$6c,$b0
           .text "hlt"
           .word hltn
           .byte $00,$00,$00,$00,$00
           .text "lse"
           .word iy
           .byte $0d,$cb,$b1,$6c,$b1
           .text "nop"
           .word zx
           .byte $1b,$c6,$b1,$6c,$30
           .text "eor"
           .word zx
           .byte $1b,$dd,$b1,$6c,$b0
           .text "lsr"
           .word zx
           .byte $0d,$c6,$b1,$6c,$31
           .text "lse"
           .word zx
           .byte $0d,$cb,$b1,$6c,$b1
           .text "cli"
           .word n
           .byte $1b,$c6,$b1,$6c,$30
           .text "eor"
           .word ay
           .byte $1b,$dd,$b1,$6c,$b0
           .text "nop"
           .word n
           .byte $1b,$c6,$b1,$6c,$30
           .text "lse"
           .word ay
           .byte $0d,$cb,$b1,$6c,$b1
           .text "nop"
           .word ax
           .byte $1b,$c6,$b1,$6c,$30
           .text "eor"
           .word ax
           .byte $1b,$dd,$b1,$6c,$b0
           .text "lsr"
           .word ax
           .byte $0d,$c6,$b1,$6c,$31
           .text "lse"
           .word ax
           .byte $0d,$cb,$b1,$6c,$b1
           .text "rts"
           .word n
           .byte $1b,$c6,$b1,$6c,$30
           .text "adc"
           .word ix
           .byte $1b,$e1,$b1,$6c,$b0
           .text "hlt"
           .word hltn
           .byte $00,$00,$00,$00,$00
           .text "rra"
           .word ix
           .byte $0d,$d4,$b1,$6c,$b0
           .text "nop"
           .word z
           .byte $1b,$c6,$b1,$6c,$30
           .text "adc"
           .word z
           .byte $1b,$e1,$b1,$6c,$b0
           .text "ror"
           .word z
           .byte $0d,$c6,$b1,$6c,$31
           .text "rra"
           .word z
           .byte $0d,$d4,$b1,$6c,$b0
           .text "pla"
           .word plan
           .byte $1b,$f0,$b1,$6c,$b0
           .text "adc"
           .word b
           .byte $1b,$e1,$b1,$6c,$b0
           .text "ror"
           .word n
           .byte $1b,$63,$b1,$6c,$30
           .text "arr"
           .word b
           .byte $1b,$01,$b1,$6c,$30
           .text "jmp"
           .word jmpi
           .byte $1b,$c6,$b1,$6c,$30
           .text "adc"
           .word a_
           .byte $1b,$e1,$b1,$6c,$b0
           .text "ror"
           .word a_
           .byte $0d,$c6,$b1,$6c,$31
           .text "rra"
           .word a_
           .byte $0d,$d4,$b1,$6c,$b0
           .text "bvs"
           .word r
           .byte $1b,$c6,$b1,$6c,$f3
           .text "adc"
           .word iy
           .byte $1b,$e1,$b1,$6c,$b0
           .text "hlt"
           .word hltn
           .byte $00,$00,$00,$00,$00
           .text "rra"
           .word iy
           .byte $0d,$d4,$b1,$6c,$b0
           .text "nop"
           .word zx
           .byte $1b,$c6,$b1,$6c,$30
           .text "adc"
           .word zx
           .byte $1b,$e1,$b1,$6c,$b0
           .text "ror"
           .word zx
           .byte $0d,$c6,$b1,$6c,$31
           .text "rra"
           .word zx
           .byte $0d,$d4,$b1,$6c,$b0
           .text "sei"
           .word n
           .byte $1b,$c6,$b1,$6c,$34
           .text "adc"
           .word ay
           .byte $1b,$e1,$b1,$6c,$b0
           .text "nop"
           .word n
           .byte $1b,$c6,$b1,$6c,$30
           .text "rra"
           .word ay
           .byte $0d,$d4,$b1,$6c,$b0
           .text "nop"
           .word ax
           .byte $1b,$c6,$b1,$6c,$30
           .text "adc"
           .word ax
           .byte $1b,$e1,$b1,$6c,$b0
           .text "ror"
           .word ax
           .byte $0d,$c6,$b1,$6c,$31
           .text "rra"
           .word ax
           .byte $0d,$d4,$b1,$6c,$b0
           .text "nop"
           .word b
           .byte $1b,$c6,$b1,$6c,$30
           .text "sta"
           .word ix
           .byte $c6,$c6,$b1,$6c,$30
           .text "nop"
           .word b
           .byte $1b,$c6,$b1,$6c,$30
           .text "axs"
           .word ix
           .byte $80,$c6,$b1,$6c,$30
           .text "sty"
           .word z
           .byte $6c,$c6,$b1,$6c,$30
           .text "sta"
           .word z
           .byte $c6,$c6,$b1,$6c,$30
           .text "stx"
           .word z
           .byte $b1,$c6,$b1,$6c,$30
           .text "axs"
           .word z
           .byte $80,$c6,$b1,$6c,$30
           .text "dey"
           .word n
           .byte $1b,$c6,$b1,$6b,$30
           .text "nop"
           .word b
           .byte $1b,$c6,$b1,$6c,$30
           .text "txa"
           .word n
           .byte $1b,$b1,$b1,$6c,$b0

           .text "ane"  ; $8b
           .word b
aneresult = * + 1
aneresultstatus = * + 4
           .byte $1b,$00,$b1,$6c,$32

           .text "sty"  ; $8c
           .word a_
           .byte $6c,$c6,$b1,$6c,$30
           .text "sta"  ; $8d
           .word a_
           .byte $c6,$c6,$b1,$6c,$30
           .text "stx"  ; $8e
           .word a_
           .byte $b1,$c6,$b1,$6c,$30
           .text "axs"  ; $8f
           .word a_
           .byte $80,$c6,$b1,$6c,$30
           .text "bcc"  ; $90
           .word r
           .byte $1b,$c6,$b1,$6c,$f3
           .text "sta"  ; $91
           .word iy
           .byte $c6,$c6,$b1,$6c,$30
           .text "hlt"  ; $92
           .word hltn
           .byte $00,$00,$00,$00,$00
           .text "sha"  ; $93
           .word shaiy
           .byte $00,$c6,$b1,$6c,$30
           .text "sty"  ; $94
           .word zx
           .byte $6c,$c6,$b1,$6c,$30
           .text "sta"  ; $95
           .word zx
           .byte $c6,$c6,$b1,$6c,$30
           .text "stx"  ; $96
           .word zy
           .byte $b1,$c6,$b1,$6c,$30
           .text "axs"  ; $97
           .word zy
           .byte $80,$c6,$b1,$6c,$30
           .text "tya"  ; $98
           .word n
           .byte $1b,$6c,$b1,$6c,$30
           .text "sta"  ; $99
           .word ay
           .byte $c6,$c6,$b1,$6c,$30
           .text "txs"  ; $9a
           .word txsn
           .byte $1b,$c6,$b1,$6c,$30
           .text "shs"  ; $9b
           .word shsay
           .byte $00,$c6,$b1,$6c,$30
           .text "shy"  ; $9c
           .word shyax
           .byte $00,$c6,$b1,$6c,$30
           .text "sta"  ; $9d
           .word ax
           .byte $c6,$c6,$b1,$6c,$30
           .text "shx"  ; $9e
           .word shxay
           .byte $00,$c6,$b1,$6c,$30
           .text "sha"  ; $9f
           .word shaay
           .byte $00,$c6,$b1,$6c,$30
           .text "ldy"  ; $a0
           .word b
           .byte $1b,$c6,$b1,$1b,$30
           .text "lda"  ; $a1
           .word ix
           .byte $1b,$1b,$b1,$6c,$30
           .text "ldx"  ; $a2
           .word b
           .byte $1b,$c6,$1b,$6c,$30
           .text "lax"  ; $a3
           .word ix
           .byte $1b,$1b,$1b,$6c,$30
           .text "ldy"  ; $a4
           .word z
           .byte $1b,$c6,$b1,$1b,$30
           .text "lda"  ; $a5
           .word z
           .byte $1b,$1b,$b1,$6c,$30
           .text "ldx"  ; $a6
           .word z
           .byte $1b,$c6,$1b,$6c,$30
           .text "lax"  ; $a7
           .word z
           .byte $1b,$1b,$1b,$6c,$30
           .text "tay"  ; $a8
           .word n
           .byte $1b,$c6,$b1,$c6,$b0
           .text "lda"  ; $a9
           .word b
           .byte $1b,$1b,$b1,$6c,$30
           .text "tax"  ; $aa
           .word n
           .byte $1b,$c6,$c6,$6c,$b0
           
           .text "lxa"  ; $ab
           .word b
laxresulta = * + 1
laxresultx = * + 2
laxresultstatus = * + 4
           .byte $1b,$0a,$0a,$6c,$30
           
           .text "ldy"  ; $ac
           .word a_
           .byte $1b,$c6,$b1,$1b,$30
           .text "lda"  ; $ad
           .word a_
           .byte $1b,$1b,$b1,$6c,$30
           .text "ldx"  ; $ae
           .word a_
           .byte $1b,$c6,$1b,$6c,$30
           .text "lax"  ; $af
           .word a_
           .byte $1b,$1b,$1b,$6c,$30
           .text "bcs"
           .word r
           .byte $1b,$c6,$b1,$6c,$f3
           .text "lda"
           .word iy
           .byte $1b,$1b,$b1,$6c,$30
           .text "hlt"
           .word hltn
           .byte $00,$00,$00,$00,$00
           .text "lax"
           .word iy
           .byte $1b,$1b,$1b,$6c,$30
           .text "ldy"
           .word zx
           .byte $1b,$c6,$b1,$1b,$30
           .text "lda"
           .word zx
           .byte $1b,$1b,$b1,$6c,$30
           .text "ldx"
           .word zy
           .byte $1b,$c6,$1b,$6c,$30
           .text "lax"
           .word zy
           .byte $1b,$1b,$1b,$6c,$30
           .text "clv"
           .word n
           .byte $1b,$c6,$b1,$6c,$30
           .text "lda"
           .word ay
           .byte $1b,$1b,$b1,$6c,$30
           .text "tsx"
           .word tsxn
           .byte $1b,$c6,$00,$6c,$00
           .text "las"
           .word lasay
           .byte $1b,$00,$00,$6c,$00
           .text "ldy"
           .word ax
           .byte $1b,$c6,$b1,$1b,$30
           .text "lda"
           .word ax
           .byte $1b,$1b,$b1,$6c,$30
           .text "ldx"
           .word ay
           .byte $1b,$c6,$1b,$6c,$30
           .text "lax"
           .word ay
           .byte $1b,$1b,$1b,$6c,$30
           .text "cpy"
           .word b
           .byte $1b,$c6,$b1,$6c,$31
           .text "cmp"
           .word ix
           .byte $1b,$c6,$b1,$6c,$b1
           .text "nop"
           .word b
           .byte $1b,$c6,$b1,$6c,$30
           .text "dcm"
           .word ix
           .byte $1a,$c6,$b1,$6c,$b1
           .text "cpy"
           .word z
           .byte $1b,$c6,$b1,$6c,$31
           .text "cmp"
           .word z
           .byte $1b,$c6,$b1,$6c,$b1
           .text "dec"
           .word z
           .byte $1a,$c6,$b1,$6c,$30
           .text "dcm"
           .word z
           .byte $1a,$c6,$b1,$6c,$b1
           .text "iny"
           .word n
           .byte $1b,$c6,$b1,$6d,$30
           .text "cmp"
           .word b
           .byte $1b,$c6,$b1,$6c,$b1
           .text "dex"
           .word n
           .byte $1b,$c6,$b0,$6c,$b0
           .text "sbx"
           .word b
           .byte $1b,$c6,$65,$6c,$31
           .text "cpy"
           .word a_
           .byte $1b,$c6,$b1,$6c,$31
           .text "cmp"
           .word a_
           .byte $1b,$c6,$b1,$6c,$b1
           .text "dec"
           .word a_
           .byte $1a,$c6,$b1,$6c,$30
           .text "dcm"
           .word a_
           .byte $1a,$c6,$b1,$6c,$b1
           .text "bne"
           .word r
           .byte $1b,$c6,$b1,$6c,$f3
           .text "cmp"
           .word iy
           .byte $1b,$c6,$b1,$6c,$b1
           .text "hlt"
           .word hltn
           .byte $00,$00,$00,$00,$00
           .text "dcm"
           .word iy
           .byte $1a,$c6,$b1,$6c,$b1
           .text "nop"
           .word zx
           .byte $1b,$c6,$b1,$6c,$30
           .text "cmp"
           .word zx
           .byte $1b,$c6,$b1,$6c,$b1
           .text "dec"
           .word zx
           .byte $1a,$c6,$b1,$6c,$30
           .text "dcm"
           .word zx
           .byte $1a,$c6,$b1,$6c,$b1
           .text "cld"
           .word n
           .byte $1b,$c6,$b1,$6c,$30
           .text "cmp"
           .word ay
           .byte $1b,$c6,$b1,$6c,$b1
           .text "nop"
           .word n
           .byte $1b,$c6,$b1,$6c,$30
           .text "dcm"
           .word ay
           .byte $1a,$c6,$b1,$6c,$b1
           .text "nop"
           .word ax
           .byte $1b,$c6,$b1,$6c,$30
           .text "cmp"
           .word ax
           .byte $1b,$c6,$b1,$6c,$b1
           .text "dec"
           .word ax
           .byte $1a,$c6,$b1,$6c,$30
           .text "dcm"
           .word ax
           .byte $1a,$c6,$b1,$6c,$b1
           .text "cpx"
           .word b
           .byte $1b,$c6,$b1,$6c,$b1
           .text "sbc"
           .word ix
           .byte $1b,$aa,$b1,$6c,$b1
           .text "nop"
           .word b
           .byte $1b,$c6,$b1,$6c,$30
           .text "ins"
           .word ix
           .byte $1c,$a9,$b1,$6c,$b1
           .text "cpx"
           .word z
           .byte $1b,$c6,$b1,$6c,$b1
           .text "sbc"
           .word z
           .byte $1b,$aa,$b1,$6c,$b1
           .text "inc"
           .word z
           .byte $1c,$c6,$b1,$6c,$30
           .text "ins"
           .word z
           .byte $1c,$a9,$b1,$6c,$b1
           .text "inx"
           .word n
           .byte $1b,$c6,$b2,$6c,$b0
           .text "sbc"
           .word b
           .byte $1b,$aa,$b1,$6c,$b1
           .text "nop"
           .word n
           .byte $1b,$c6,$b1,$6c,$30
           .text "sbc"
           .word b
           .byte $1b,$aa,$b1,$6c,$b1
           .text "cpx"
           .word a_
           .byte $1b,$c6,$b1,$6c,$b1
           .text "sbc"
           .word a_
           .byte $1b,$aa,$b1,$6c,$b1
           .text "inc"
           .word a_
           .byte $1c,$c6,$b1,$6c,$30
           .text "ins"
           .word a_
           .byte $1c,$a9,$b1,$6c,$b1
           .text "beq"
           .word r
           .byte $1b,$c6,$b1,$6c,$f3
           .text "sbc"
           .word iy
           .byte $1b,$aa,$b1,$6c,$b1
           .text "hlt"
           .word hltn
           .byte $00,$00,$00,$00,$00
           .text "ins"
           .word iy
           .byte $1c,$a9,$b1,$6c,$b1
           .text "nop"
           .word zx
           .byte $1b,$c6,$b1,$6c,$30
           .text "sbc"
           .word zx
           .byte $1b,$aa,$b1,$6c,$b1
           .text "inc"
           .word zx
           .byte $1c,$c6,$b1,$6c,$30
           .text "ins"
           .word zx
           .byte $1c,$a9,$b1,$6c,$b1
           .text "sed"
           .word n
           .byte $1b,$c6,$b1,$6c,$38
           .text "sbc"
           .word ay
           .byte $1b,$aa,$b1,$6c,$b1
           .text "nop"
           .word n
           .byte $1b,$c6,$b1,$6c,$30
           .text "ins"
           .word ay
           .byte $1c,$a9,$b1,$6c,$b1
           .text "nop"
           .word ax
           .byte $1b,$c6,$b1,$6c,$30
           .text "sbc"
           .word ax
           .byte $1b,$aa,$b1,$6c,$b1
           .text "inc"
           .word ax
           .byte $1c,$c6,$b1,$6c,$30
           .text "ins"
           .word ax
           .byte $1c,$a9,$b1,$6c,$b1
           .byte 0


