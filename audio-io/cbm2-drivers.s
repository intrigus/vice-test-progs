;
; Marco van den Heuvel, 28.01.2016
;
; void __fastcall__ sampler_2bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_2bit_hummer_input(void);
; void __fastcall__ sampler_4bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_4bit_hummer_input(void);
; void __fastcall__ sampler_2bit_oem_input_init(void);
; unsigned char __fastcall__ sampler_2bit_oem_input(void);
; void __fastcall__ sampler_4bit_oem_input_init(void);
; unsigned char __fastcall__ sampler_4bit_oem_input(void);
; void __fastcall__ sampler_2bit_pet1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_pet1_input(void);
; void __fastcall__ sampler_4bit_pet1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_pet1_input(void);
; void __fastcall__ sampler_2bit_pet2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_pet2_input(void);
; void __fastcall__ sampler_4bit_pet2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_pet2_input(void);
; void __fastcall__ sampler_2bit_cga1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_cga1_input(void);
; void __fastcall__ sampler_4bit_cga1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_cga1_input(void);
; void __fastcall__ sampler_2bit_cga2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_cga2_input(void);
; void __fastcall__ sampler_4bit_cga2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_cga2_input(void);
; void __fastcall__ sampler_2bit_hit1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_hit1_input(void);
; void __fastcall__ sampler_4bit_hit1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_hit1_input(void);
; void __fastcall__ sampler_2bit_hit2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_hit2_input(void);
; void __fastcall__ sampler_4bit_hit2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_hit2_input(void);
; void __fastcall__ sampler_2bit_kingsoft1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_kingsoft1_input(void);
; void __fastcall__ sampler_4bit_kingsoft1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_kingsoft1_input(void);
; void __fastcall__ sampler_2bit_kingsoft2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_kingsoft2_input(void);
; void __fastcall__ sampler_4bit_kingsoft2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_kingsoft2_input(void);
; void __fastcall__ sampler_2bit_starbyte1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_starbyte1_input(void);
; void __fastcall__ sampler_4bit_starbyte1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_starbyte1_input(void);
; void __fastcall__ sampler_2bit_starbyte2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_starbyte2_input(void);
; void __fastcall__ sampler_4bit_starbyte2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_starbyte2_input(void);
; void __fastcall__ sampler_4bit_userport_input_init(void);
; unsigned char __fastcall__ sampler_4bit_userport_input(void);
;
; void __fastcall__ userport_dac_output_init(void);
; void __fastcall__ userport_dac_output(unsigned char sample);
; void __fastcall__ userport_digimax_output_init(void);
; void __fastcall__ userport_digimax_output(unsigned char sample);
;
; void __fastcall__ _show_sample(unsigned char sample);
;

        .export  _sampler_2bit_hummer_input_init, _sampler_2bit_hummer_input
        .export  _sampler_4bit_hummer_input_init, _sampler_4bit_hummer_input
        .export  _sampler_2bit_oem_input_init, _sampler_2bit_oem_input
        .export  _sampler_4bit_oem_input_init, _sampler_4bit_oem_input
        .export  _sampler_2bit_pet1_input_init, _sampler_2bit_pet1_input
        .export  _sampler_4bit_pet1_input_init, _sampler_4bit_pet1_input
        .export  _sampler_2bit_pet2_input_init, _sampler_2bit_pet2_input
        .export  _sampler_4bit_pet2_input_init, _sampler_4bit_pet2_input
        .export  _sampler_2bit_cga1_input_init, _sampler_2bit_cga1_input
        .export  _sampler_4bit_cga1_input_init, _sampler_4bit_cga1_input
        .export  _sampler_2bit_cga2_input_init, _sampler_2bit_cga2_input
        .export  _sampler_4bit_cga2_input_init, _sampler_4bit_cga2_input
        .export  _sampler_2bit_hit1_input_init, _sampler_2bit_hit1_input
        .export  _sampler_4bit_hit1_input_init, _sampler_4bit_hit1_input
        .export  _sampler_2bit_hit2_input_init, _sampler_2bit_hit2_input
        .export  _sampler_4bit_hit2_input_init, _sampler_4bit_hit2_input
        .export  _sampler_2bit_kingsoft1_input_init, _sampler_2bit_kingsoft1_input
        .export  _sampler_4bit_kingsoft1_input_init, _sampler_4bit_kingsoft1_input
        .export  _sampler_2bit_kingsoft2_input_init, _sampler_2bit_kingsoft2_input
        .export  _sampler_4bit_kingsoft2_input_init, _sampler_4bit_kingsoft2_input
        .export  _sampler_2bit_starbyte1_input_init, _sampler_2bit_starbyte1_input
        .export  _sampler_4bit_starbyte1_input_init, _sampler_4bit_starbyte1_input
        .export  _sampler_2bit_starbyte2_input_init, _sampler_2bit_starbyte2_input
        .export  _sampler_4bit_starbyte2_input_init, _sampler_4bit_starbyte2_input
        .export  _sampler_4bit_userport_input_init, _sampler_4bit_userport_input

        .export  _userport_dac_output_init, _userport_dac_output
        .export  _userport_digimax_output_init, _userport_digimax_output

        .export  _show_sample

        .importzp   sreg, tmp1, tmp2

setup_banking:
        ldx     $01
        ldy     #$0f
        sty     $01
        rts

load_pa2:
        ldy     #$dc
        sty     sreg + 1
        ldy     #$00
        sty     sreg
        lda     (sreg),y
        rts

load_userport:
        ldy     #$dc
        sty     sreg + 1
        ldy     #$01
        sty     sreg
        dey
        lda     (sreg),y
        rts

setup_userport_dc01:
        jsr     setup_banking
        ldy     #$dc
        sty     sreg + 1
        ldy     #$01
        sty     sreg
        iny
        lda     #$80
        sta     (sreg),y
        dey
        dey
        rts

_sampler_2bit_cga1_input_init:
_sampler_4bit_cga1_input_init:
        jsr     setup_userport_dc01
storea_dc01:
        sta     (sreg),y
        stx     $01
        rts

_sampler_2bit_cga2_input_init:
_sampler_4bit_cga2_input_init:
        jsr     setup_userport_dc01
        lda     #$00
        jmp     storea_dc01

_sampler_4bit_userport_input_init:
        jsr     setup_banking
        ldy     #$dc
        sty     sreg + 1
        ldy     #$00
        sty     sreg
        ldy     #$02
        lda     (sreg),y
        ora     #$04
        sta     (sreg),y
        ldy     #$00
        lda     (sreg),y
        and     #$fb
        sta     (sreg),y
        tya
        ldy     #$03
        sta     (sreg),y
        stx     $01
        rts

_sampler_2bit_kingsoft1_input_init:
_sampler_4bit_kingsoft1_input_init:
_sampler_2bit_starbyte2_input_init:
_sampler_4bit_starbyte2_input_init:
        jsr     setup_banking
        ldy     #$dc
        sty     sreg + 1
        ldy     #$02
        sty     sreg
        ldy     #$00
        lda     (sreg),y
        and     #$fb
        sta     (sreg),y
        tya
        iny
        sta     (sreg),y
        stx     $01
        rts

_sampler_2bit_hummer_input_init:
_sampler_4bit_hummer_input_init:
_sampler_2bit_oem_input_init:
_sampler_4bit_oem_input_init:
_sampler_2bit_pet1_input_init:
_sampler_4bit_pet1_input_init:
_sampler_2bit_pet2_input_init:
_sampler_4bit_pet2_input_init:
_sampler_2bit_hit1_input_init:
_sampler_4bit_hit1_input_init:
_sampler_2bit_hit2_input_init:
_sampler_4bit_hit2_input_init:
_sampler_2bit_kingsoft2_input_init:
_sampler_4bit_kingsoft2_input_init:
_sampler_2bit_starbyte1_input_init:
_sampler_4bit_starbyte1_input_init:
        jsr     setup_banking
        ldy     #$03
        sty     sreg
        ldy     #$dc
        sty     sreg + 1
        ldy     #$00
        tya
        sta     (sreg),y
        stx     $01
        rts

_sampler_2bit_pet2_input:
_sampler_2bit_hit2_input:
        jsr     setup_banking
        jsr     load_userport
        and     #$30
        asl
        asl
        stx     $01
        rts

_sampler_4bit_pet2_input:
_sampler_4bit_hit2_input:
_sampler_4bit_userport_input:
        jsr     setup_banking
        jsr     load_userport
        and     #$f0
        stx     $01
        rts

_sampler_2bit_starbyte2_input:
        jsr     setup_banking
        jsr     load_pa2
        and     #$04
        asl
        asl
        asl
        asl
        sta     tmp1
        jsr     load_userport
        and     #$20
        asl
        asl
        ora     tmp1
        stx     $01
        rts

_sampler_4bit_starbyte2_input:
        jsr     setup_banking
        jsr     load_pa2
        and     #$04
        asl
        asl
        sta     tmp1
        jsr     load_userport
        sta     tmp2
        and     #$20
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$40
        asl
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$80
        lsr
        ora     tmp1
        stx     $01
        rts

_sampler_2bit_starbyte1_input:
        jsr     setup_banking
        jsr     load_userport
        sta     tmp2
        and     #$01
        clc
        ror
        ror
        sta     tmp1
        lda     tmp2
        and     #$08
        asl
        asl
        asl
        ora     tmp1
        stx     $01
        rts

_sampler_4bit_starbyte1_input:
        jsr     setup_banking
        jsr     load_userport
        sta     tmp2
        and     #$01
        asl
        asl
        asl
        asl
        asl
        sta     tmp1
        lda     tmp2
        and     #$02
        clc
        ror
        ror
        ror
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$04
        asl
        asl
        asl
        asl
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$08
        asl
        ora     tmp1
        stx     $01
        rts

_sampler_2bit_kingsoft1_input:
        jsr     setup_banking
        jsr     load_pa2
        and     #$04
        asl
        asl
        asl
        asl
        sta     tmp1
        jsr     load_userport
        and     #$80
        ora     tmp1
        stx     $01
        rts

_sampler_4bit_kingsoft1_input:
        jsr     setup_banking
        jsr     load_pa2
        and     #$04
        asl
        asl
        sta     tmp1
        jsr     load_userport
        sta     tmp2
        and     #$20
        asl
        asl
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$40
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$80
        lsr
        lsr
        ora     tmp1
        stx     $01
        rts

_sampler_2bit_kingsoft2_input:
        jsr     setup_banking
        jsr     load_userport
        sta     tmp2
        and     #$04
        asl
        asl
        asl
        asl
        asl
        sta     tmp1
        lda     tmp2
        and     #$08
        asl
        asl
        asl
        ora     tmp1
        stx     $01
        rts

_sampler_4bit_kingsoft2_input:
        jsr     setup_banking
        jsr     load_userport
        sta     tmp2
        and     #$01
        clc
        ror
        ror
        sta     tmp1
        lda     tmp2
        and     #$02
        asl
        asl
        asl
        asl
        asl
        ora    tmp1
        sta    tmp1
        lda    tmp2
        and    #$04
        asl
        asl
        asl
        ora    tmp1
        sta    tmp1
        lda    tmp2
        and    #$08
        asl
        ora    tmp1
        stx    $01
        rts

_sampler_2bit_oem_input:
        jsr     setup_banking
        jsr     load_userport
        sta     tmp2
        and     #$40
        asl
        sta     tmp1
        lda     tmp2
        and     #$80
        lsr
        ora     tmp1
        stx     $01
        rts

_sampler_4bit_oem_input:
        jsr     setup_banking
        jsr     load_userport
        sta     tmp2
        and     #$10
        asl
        asl
        asl
        sta     tmp1
        lda     tmp2
        and     #$20
        asl
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$40
        lsr
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$80
        lsr
        lsr
        lsr
        ora     tmp1
        stx     $01
        rts

_sampler_2bit_hummer_input:
_sampler_2bit_pet1_input:
_sampler_2bit_cga1_input:
_sampler_2bit_cga2_input:
_sampler_2bit_hit1_input:
        jsr     setup_banking
        jsr     load_userport
        asl
        asl
do_asl4:
        asl
        asl
        asl
        asl
        stx     $01
        rts

_sampler_4bit_hummer_input:
_sampler_4bit_pet1_input:
_sampler_4bit_cga1_input:
_sampler_4bit_cga2_input:
_sampler_4bit_hit1_input:
        jsr     setup_banking
        jsr     load_userport
        jmp     do_asl4

_userport_digimax_output_init:
_userport_dac_output_init:
        jsr     setup_banking
        ldy     #$03
        sty     sreg
        ldy     #$dc
        sty     sreg + 1
        ldy     #$00
        lda     #$ff
        sta     (sreg),y
        stx     $01
        rts

_userport_digimax_output:
_userport_dac_output:
        jsr     setup_banking
        ldy     #$dc
        sty     sreg + 1
        ldy     #$01
        sty     sreg
        dey
        sta     (sreg),y
        stx     $01
        rts

_show_sample:
        jsr     setup_banking
        ldy     #$d8
        sty     sreg + 1
        ldy     #$00
        sty     sreg
        sta     (sreg),y
        rts
