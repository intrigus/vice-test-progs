; ZP-adresses
irqA = 2
irqX = 3
irqY = 4

; Variables
IrqLijn0 = $2f

*=$0801
;  10 SYS2064 
!byte    $0B, $08, $0A, $00, $9E, $32, $30, $36, $34, $00, $00, $00

*=$0810
        sei
        cld
        lda #0
        sta $d015
        sta $d021

        lda #$18
        sta $d018

        ldy #$20
--
        ldx #0
-
        lda #$f0
b0:     sta $2000,x
        inx
        bne -
        inc b0+2
        dey
        bne --
        
        ldy #01
l0:     ldx #39
        tya
m0:     sta $0428,x
        lda #$0e
        sta $d828,x
        dex
        bpl l0+2
        clc
        lda m0+1
        adc #40
        sta m0+1
        sta m0+6
        bcc *+8
        inc m0+2
        inc m0+7
        iny
        cpy #25
        bcc l0
; Dark grey reverse spaces on first character row
        ldx #39
l1:     lda #123
        sta $0400,x 
        lda #12
        sta $d800,x 
        dex
        bpl l1
; chars and colors in $07e8 ... $07ff and $dbe8 ... $dbff
        ldx #$fe 
 l2:    txa       
        sta $0701,x 
        sta $db01,x 
        dex
        cpx #$e6
        bne l2

        jsr setTimer     ; raster sync using timer   

        lda #$7f   
        sta $dc0d 
        sta $dd0d  
        lda $dc0d  
        lda $dd0d  

        lda #$01   
        sta $d01a
        
        lda #IrqLijn0   
        sta $d012 
        
        lda #$3f     
        sta $d011 
        lda #<irq0
        sta $fffe
        lda #>irq0
        sta $ffff     
        lda #$35   
        sta $01
        lda #$55
        sta $3fff

        lda #$01
        sta $d010

        inc $d019
        cli
        jmp *

        !align 255,0
irq0:
        sta irqA
        nop
        lda $dc06     
        eor #7
        sta *+4
        bpl *+2         ; Note: no page boundary crossing allowed here
        lda #$a9
        lda #$a9
        lda $eaa5   
        
        stx irqX
        sty irqY
        ldx $d012

        inc $0200

        inc $d020
        dec $d020
        
        inc $0200
; Create a badline on next rasterline
        inx
        txa
        and #$07
        ora #$38
        sta $d011
        txa
        clc
        adc #$03
        cmp #$f8
        bcs endscrn
        sta $d012
        inc $d019
        ldy irqY
        ldx irqX
        lda irqA
        rti

endscrn:
; open border
        lda $d011
        and #$f7
        sta $d011
        
        bit $d011
        bpl *-3
        lda #$3f
        sta $d011
        lda #IrqLijn0   
        sta $d012
        inc $d019
        ldy irqY
        ldx irqX
        lda irqA
        
        rti

setTimer:
; Via badline detection with timer
        lax $dc04      
        sbx #51
        sta irqA
        cpx $dc04
        bne setTimer    ; Note: no page boundary crossing allowed here
; wait till cycle 54 
        ldx #8
        dex
        bne *-1         ; Note: no page boundary crossing allowed here
        bit $ea             
        lda #8
        sta $dc06
        stx $dc07
        lda #$11
        sta $dc0f     ; This instruction on cycle 54
        rts
