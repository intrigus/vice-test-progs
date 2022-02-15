; Obviously the undocumented instructions RRA (ROR+ADC) and ISB (INC+SBC) have 
; inherited also the decimal operation from the official instructions ADC and SBC. 
; The program droradc proves this statement for ROR,

        * =  $801
basicstart:
        !word nextline
        ; 1993 syspeek(43)+256*peek(44)+26
        !word 1993
        !byte $9e, $c2, $28, $34, $33, $29, $aa
        !byte $32, $35, $36, $ac, $c2, $28, $34, $34
        !byte $29, $aa, $32, $36
        !byte 0
nextline:
        !word 0
; --------------------------------------
        sei
        lda #$18
loc_81e:
        ldy #0
        sty $fb
        sty $fc
        pha
        ldy #loc_82d - basicstart
        sta ($2b),y     ; $0801+$2c=$082d
        ldy #loc_88e - basicstart
        sta ($2b),y     ; $0801+$8d=$088e

loc_82d:
        sec
        php
        lda $fc
        and #$f
        sta $fd
        lda $fb
        and #$f
        adc $fd
        cmp #$a
        bcc loc_841
        adc #5

loc_841:
        tay
        and #$f
        sta $fd
        lda $fb
        and #$f0
        adc $fc
        and #$f0
        php
        cpy #$10
        bcc loc_855
        adc #$f

loc_855:
        tax
        bcs loc_860
        plp
        bcs loc_862
        cmp #$a0
        bcc loc_865
        php

loc_860:
        plp
        sec

loc_862:
        adc #$5f
        sec

loc_865:
        ora $fd
        sta $fd
        php
        pla
        and #$3d
        cpx #0
        bpl loc_873
        ora #$80

loc_873:
        tay
        txa
        eor $fb
        bpl loc_883
        lda $fb
        eor $fc
        bmi loc_883
        tya
        ora #$40
        tay

loc_883:
        plp
        lda $fb
        adc $fc
        bne loc_88e
        tya
        ora #2
        tay

loc_88e:
        sec
        clv
        sed
        lda $fb
        rol $fc
        rra $fc
        cld
        php
        eor $fd
        bne failure
        pla
        sty $fd
        eor $fd
        bne failure
        inc $fb
        bne loc_82d
        inc $fc
        bne loc_82d
        pla
        eor #$18
        beq loc_8b3
        cli
pass:
        ;rts
        lda #5 
        sta $d020
        lda #$00
        sta $d7ff
        jmp *
; --------------------------------------

loc_8b3:
        lda #<(loc_81e - basicstart)
        clc
        adc $2b          ; $0801+$1d=$081e
        sta $fb
        lda #>(loc_81e - basicstart)
        adc $2c
        sta $fc
        lda #$38 

loc_8c2:
        jmp ($fb)

failure:
        ;brk
        lda #10
        sta $d020
        lda #$ff
        sta $d7ff
        jmp *
        
