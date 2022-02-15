/*
 * FILE  analyze.c
 *
 * Copyright (c) 2011 Daniel Kahlin <daniel@kahlin.net>
 * Written by Daniel Kahlin <daniel@kahlin.net>
 *
 * DESCRIPTION
 *   analysis of ane-lax.prg dumps.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define ACC_STRIDE 3
#define XR_STRIDE 5
#define SCAN_LEN 0x1200

int verbose = 0;

uint8_t ane_buf[SCAN_LEN * 4];
uint8_t lax_buf[SCAN_LEN * 4];

void read_dump(const char *name)
{
    FILE *fp = fopen(name, "rb");
    if (!fp) {
        fprintf(stderr, "couldn't open file\n");
        exit(-1);
    }

    /* skip header */
    fseek(fp, 0x42, SEEK_CUR);

    fread(ane_buf, 1, SCAN_LEN * 4, fp);
    fread(lax_buf, 1, SCAN_LEN * 4, fp);

    fclose(fp);
}

static char *binstr(uint8_t b, const char ch[2])
{
    static char str[9];
    int i;

    for (i = 0; i < 8; i++) {
        str[i] = ((b >> (7-i)) & 1) ? ch[1] : ch[0];
    }

    str[8] = 0;
    return str;
}

struct Bin {
    uint8_t b;
    int count;          // total matches including unstable cases
    uint8_t fault0;
    uint8_t fault1;
    uint8_t fault_abn;
};

static int cmpfunc(const void *ap, const void *bp)
{
    struct Bin *a = (struct Bin *)ap;
    struct Bin *b = (struct Bin *)bp;

    if (a->count < b->count) {
        return 1;
    }
    if (b->count > a->count) {
        return -1;
    }
    return 0;
}

static void match_ane(struct Bin *p, uint8_t *tab, uint8_t op, uint8_t c)
{
    int i;
    uint8_t acc, xr;

    acc = 0;
    xr = 0;
    for (i = 0; i < SCAN_LEN; i++) {
        uint8_t acc_r;
        uint8_t acc_e, acc_b;

        /* measured result */
        acc_r = tab[i];

        /* ANE #<imm> model (expected result) */
        acc_e = (acc | c) & (xr & op);
        acc_b = (xr & op);

        /* evaluate result */
        if (acc_r == acc_e) {
            p->count++;
        } else {
            /* cleared bits */
            p->fault0 |= (~acc_r) & acc_e;
            /* set bits */
            p->fault1 |= acc_r & (~acc_e);
            /* abnormal bits */
            p->fault_abn |= acc_r & (~acc_b);
        }

        acc += ACC_STRIDE;
        xr += XR_STRIDE;
    }
}

static int match_ane2(uint8_t *tab, uint8_t imm, uint8_t magic)
{
    int i, unstable, err = 0;
    uint8_t acc, xr;

    acc = 0;
    xr = 0;
    for (i = 0; i < SCAN_LEN; i++) {
        uint8_t acc_r;
        uint8_t acc_e, acc_b;

        /* measured result */
        acc_r = tab[i];

        /* ANE #<imm> model (expected result) */
        acc_e = (acc | magic) & (xr & imm);
        acc_b = (xr & imm);
        unstable = ((acc ^ 0xff) & acc_b);

        /* evaluate result */
        if (unstable == 0) {
            if (acc_r != acc_e) {
                err++;
            }
        }

        acc += ACC_STRIDE;
        xr += XR_STRIDE;
    }
    return err;
}


static void match_lax(struct Bin *p, uint8_t *tab, uint8_t op, uint8_t c)
{
    int i;
    uint8_t acc, xr;

    acc = 0;
    xr = 0;
    for (i = 0; i < SCAN_LEN; i++) {
        uint8_t acc_r;
        uint8_t acc_e, acc_b;

        /* measured result */
        acc_r = tab[i];

        /* LAX #<imm> model (expected result) */
        acc_e = (acc | c) & op;
        acc_b = op;

        /* evaluate result */
        if (acc_r == acc_e) {
            p->count++;
        } else {
            /* cleared bits */
            p->fault0 |= (~acc_r) & acc_e;
            /* set bits */
            p->fault1 |= acc_r & (~acc_e);
            /* abnormal bits */
            p->fault_abn |= acc_r & (~acc_b);
        }

        acc += ACC_STRIDE;
        xr += XR_STRIDE;
    }
}

static int match_lax2(uint8_t *tab, uint8_t imm, uint8_t magic)
{
    int i, unstable, err = 0;
    uint8_t acc, xr;

    acc = 0;
    xr = 0;
    for (i = 0; i < SCAN_LEN; i++) {
        uint8_t acc_r;
        uint8_t acc_e, acc_b;

        /* measured result */
        acc_r = tab[i];

        /* LAX #<imm> model (expected result) */
        acc_e = (acc | magic) & imm;
        acc_b = imm;
        unstable = ((acc ^ 0xff) & acc_b);

        /* evaluate result */
        if (unstable == 0) {
            if (acc_r != acc_e) {
                err++;
            }
        }

        acc += ACC_STRIDE;
        xr += XR_STRIDE;
    }
    return err;
}


uint8_t ops[] = {
    0xff, 0x00, 0x5a, 0xa5
};


int main(int argc, char *argv[])
{
    int c;
    int i, unstable;
    struct Bin match[256];
    
    if (argc < 2) {
        exit(-1);
    }
    
    read_dump(argv[1]);

    if (argc > 2) {
        for (i = 2; i < argc; i++) {
            if (!strcmp(argv[i], "-v") || !strcmp(argv[i], "-_verbose")) {
                verbose++;
            }
        }
    }
    
    printf("testing dump: %s\n", argv[1]);
    
    for (i = 0; i < 256; i++) {
        match[i].b = i;
        match[i].count = 0;
        match[i].fault0 = 0;
        match[i].fault1 = 0;
        match[i].fault_abn = 0;
    }

    // loop over all possible magic constants
    for (c = 0x00; c <= 0xff; c++) {
        for (i = 0; i < 4; i++) {
            match_ane(&match[c], ane_buf + SCAN_LEN * i, ops[i], c);
        }
    }
    qsort(match, 256, sizeof(struct Bin), cmpfunc);

    if (verbose) {
        if (match[0].count == SCAN_LEN * 4) {
            printf(" ANE ($8B) matches: Acc = (Acc | $%02X) & X & #<imm>\n", match[0].b);
        } else {
            printf(" ANE ($8B) does not match: Acc = (Acc | CONST) & X & #<imm>\n");
            if (verbose > 1) {
                printf("  closest CONST = $%02X, %d errors\n", match[0].b, SCAN_LEN*4-match[0].count);
                printf("       CONST: %s\n", binstr(match[0].b, "01") );
                printf("     cleared: %s\n", binstr(match[0].fault0, "-0") );
                printf("         set: %s\n", binstr(match[0].fault1, "-1") );
                printf("    abnormal: %s\n", binstr(match[0].fault_abn, "-!") );
            }
        }
    }

    unstable = 0;
    for (i = 0; i < 4; i++) {
        unstable += match_ane2(ane_buf + SCAN_LEN * i, ops[i], match[0].b);
    }

    if (unstable) {
        printf(" ANE ($8b) %d stable cases behave unexpected, most likely magic constant is $%02x.\n", unstable, match[0].b);
    } else {
        printf(" ANE ($8b) all stable cases behave as expected, most likely magic constant is $%02x.\n", match[0].b);
    }

    for (i = 0; i < 256; i++) {
        match[i].b = i;
        match[i].count = 0;
        match[i].fault0 = 0;
        match[i].fault1 = 0;
        match[i].fault_abn = 0;
    }

    // loop over all possible magic constants
    for (c = 0x00; c <= 0xff; c++) {
        for (i = 0; i < 4; i++) {
            match_lax(&match[c], lax_buf + SCAN_LEN * i, ops[i], c);
        }
    }

    qsort(match, 256, sizeof(struct Bin), cmpfunc);

    if (verbose) {
        if (match[0].count == SCAN_LEN * 4) {
            printf(" LAX ($AB) matches: Acc = (Acc | $%02X) & #<imm>\n", match[0].b);
        } else {
            printf(" LAX ($AB) does not match: Acc = (Acc | CONST) & #<imm>\n");
            if (verbose > 1) {
                printf("  closest CONST = $%02X, %d errors\n", match[0].b, SCAN_LEN*4-match[0].count);
                printf("       CONST: %s\n", binstr(match[0].b, "01") );
                printf("     cleared: %s\n", binstr(match[0].fault0, "-0") );
                printf("         set: %s\n", binstr(match[0].fault1, "-1") );
                printf("    abnormal: %s\n", binstr(match[0].fault_abn, "-!") );
            }
        }
    }

    unstable = 0;
    for (i = 0; i < 4; i++) {
        unstable += match_lax2(lax_buf + SCAN_LEN * i, ops[i], match[0].b);
    }

    if (unstable) {
        printf(" LAX ($AB) %d stable cases behave unexpected, most likely magic constant is $%02x.\n", unstable, match[0].b);
    } else {
        printf(" LAX ($AB) all stable cases behave as expected, most likely magic constant is $%02x.\n", match[0].b);
    }
    
    exit(0);
}
/* eof */
