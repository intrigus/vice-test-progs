; this file is part of the C64 Emulator Test Suite. public domain, no copyright

; original file was: arrb.asm
;-------------------------------------------------------------------------------

            .include "common.asm"
            .include "printhb.asm"
            .include "showregs.asm"

;------------------------------------------------------------------------------           
thisname   .null "arrb"      ; name of this test
nextname   .null "aneb"      ; name of next test, "-" means no more tests
;------------------------------------------------------------------------------ 
main:
         lda #%00011011
         sta db
         lda #%11000110
         sta ab
         lda #%10110001
         sta xb
         lda #%01101100
         sta yb
         lda #0
         sta pb
         tsx
         stx sb

         lda #0
         sta db
         sta ab

next     lda db
         sta da
         sta dr
         sta cmd+1

         lda #%00001000
         bit pb
         bne decimal

         lda pb
         lsr a
         lda ab
         and db
         ror a
         sta ar

         lda pb
         ora #%00110000
         and #%00111100
         ldx ar
         bne nozero
         ora #%00000010
nozero
         ldx ar
         bpl nominus
         ora #%10000000
nominus
         tax
         lda ar
         and #%01000000
         beq nocarry
         inx
nocarry
         lda ar
         and #%01100000
         beq noover
         cmp #%01100000
         beq noover
         txa
         ora #%01000000
         tax
noover
.ifne (TARGET - TARGETDTV)
         stx pr
.else
         txa
         and #$cf
         sta pr
.endif
         jmp nodecimal

decimal
         lda pb
         lsr a
         lda ab
         and db
         sta aa
         ror a
         sta ar

         lda pb
         ora #%00110000
         and #%00111100
         ldx ar
         bne dnozero
         ora #%00000010
dnozero
         ldx ar
         bpl dnominus
         ora #%10000000
dnominus
         tax
         lda ar
         eor aa
         and #%01000000
         beq dnoover
         txa
         ora #%01000000
         tax
dnoover
         lda aa
         and #$0f
         cmp #$05
         bcc noadjustlow
         lda ar
         and #$f0
         sta andlow+1
         lda ar
         clc
         adc #$06
         and #$0f
andlow   ora #$11
         sta ar
noadjustlow
         lda aa
         and #$f0
         cmp #$50
         bcc noadjusthigh
         inx
         lda ar
         clc
         adc #$60
         sta ar
noadjusthigh
.ifne (TARGET - TARGETDTV)
         stx pr
.else
         txa
         and #$cf
         sta pr
.endif

nodecimal
         lda xb
         sta xr

         lda yb
         sta yr

         lda sb
         sta sr

         ldx sb
         txs
         lda pb
         pha
         lda ab
         ldx xb
         ldy yb
         plp

cmd      .byte $6b
         .byte 0

         php
         cld
         sta aa
         stx xa
         sty ya
         pla
         sta pa
         tsx
         stx sa
         jsr check

         clc
         lda db
         adc #17
         sta db
         bcc jmpnext
         lda #0
         sta db
         clc
         lda ab
         adc #17
         sta ab
         bcc jmpnext
         lda #0
         sta ab
         inc pb
         beq nonext
jmpnext  jmp next
nonext

         rts ; success

db       .byte 0
ab       .byte 0
xb       .byte 0
yb       .byte 0
pb       .byte 0
sb       .byte 0
da       .byte 0
aa       .byte 0
xa       .byte 0
ya       .byte 0
pa       .byte 0
sa       .byte 0
dr       .byte 0
ar       .byte 0
xr       .byte 0
yr       .byte 0
pr       .byte 0
sr       .byte 0

check
         .block
         lda da
         cmp dr
         bne error
         lda aa
         cmp ar
         bne error
         lda xa
         cmp xr
         bne error
         lda ya
         cmp yr
         bne error
         lda pa
.ifeq (TARGET - TARGETDTV)
         and #$cf
.endif
         cmp pr
         bne error
         lda sa
         cmp sr
         bne error
         rts

error    jsr print
         .byte 13
         .null "before  "
         ldx #<db
         ldy #>db
         jsr showregs
         jsr print
         .byte 13
         .null "after   "
         ldx #<da
         ldy #>da
         jsr showregs
         jsr print
         .byte 13
         .null "right   "
         ldx #<dr
         ldy #>dr
         jsr showregs
         lda #13
         jsr $ffd2

         #SET_EXIT_CODE_FAILURE

wait     jsr $ffe4
         beq wait
         rts

showregs stx 172
         sty 173
         ldy #0
         lda (172),y
         jsr hexb
         lda #32
         jsr $ffd2
         lda #32
         jsr $ffd2
         iny
         lda (172),y
         jsr hexb
         lda #32
         jsr $ffd2
         iny
         lda (172),y
         jsr hexb
         lda #32
         jsr $ffd2
         iny
         lda (172),y
         jsr hexb
         lda #32
         jsr $ffd2
         iny
         lda (172),y
         ldx #"n"
         asl a
         bcc ok7
         ldx #"N"
ok7      pha
         txa
         jsr $ffd2
         pla
         ldx #"v"
         asl a
         bcc ok6
         ldx #"V"
ok6      pha
         txa
         jsr $ffd2
         pla
         ldx #"0"
         asl a
         bcc ok5
         ldx #"1"
ok5      pha
         txa
         jsr $ffd2
         pla
         ldx #"b"
         asl a
         bcc ok4
         ldx #"B"
ok4      pha
         txa
         jsr $ffd2
         pla
         ldx #"d"
         asl a
         bcc ok3
         ldx #"D"
ok3      pha
         txa
         jsr $ffd2
         pla
         ldx #"i"
         asl a
         bcc ok2
         ldx #"I"
ok2      pha
         txa
         jsr $ffd2
         pla
         ldx #"z"
         asl a
         bcc ok1
         ldx #"Z"
ok1      pha
         txa
         jsr $ffd2
         pla
         ldx #"c"
         asl a
         bcc ok0
         ldx #"C"
ok0      pha
         txa
         jsr $ffd2
         pla
         lda #32
         jsr $ffd2
         iny
         lda (172),y
         .bend
hexb     pha
         lsr a
         lsr a
         lsr a
         lsr a
         jsr hexn
         pla
         and #$0f
hexn     ora #$30
         cmp #$3a
         bcc hexn0
         adc #6
hexn0    jmp $ffd2
