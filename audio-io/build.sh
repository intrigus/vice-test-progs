#!/bin/sh

cl65 -t c64 \
	audio-io.c \
	stream.s \
	c64-drivers.s \
	stubs.s

mv audio-io audio-io-c64.prg

cl65 -t c128 \
	audio-io.c \
	stream.s \
	c64-drivers.s \
	stubs.s

mv audio-io audio-io-c128.prg

cl65 -t cbm510 \
	audio-io.c \
	stream.s \
	cbm5x0-drivers.s \
	cbm2-common-drivers.s \
	stubs.s

mv audio-io audio-io-cbm5x0.prg

cl65 -t cbm610 \
	audio-io.c \
	stream.s \
	cbm2-drivers.s \
	cbm2-common-drivers.s \
	stubs.s

mv audio-io audio-io-cbm6x0.prg

cl65 -t pet \
	audio-io.c \
	stream.s \
	pet-drivers.s \
	stubs.s

mv audio-io audio-io-pet.prg

cl65 -t c16 \
	audio-io.c \
	stream.s \
	plus4-drivers.s \
	stubs.s

mv audio-io audio-io-plus4.prg

cl65 -t vic20 --config /usr/local/share/cc65/cfg/vic20-32k.cfg \
	audio-io.c \
	stream.s \
	vic20-drivers.s \
	stubs.s

mv audio-io audio-io-vic20.prg
