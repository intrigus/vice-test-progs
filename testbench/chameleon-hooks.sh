
DUMMY=.dummyfile
RDUMMY=.dummyfile2
CDUMMY=.dummyfile3

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
CHAMSXO=53
CHAMSYO=62

function chameleon_check_environment
{
    if ! [ -x "$(command -v chacocmd)" ]; then
        echo 'Error: chacocmd is not installed.' >&2
        exit 1
    fi
    if ! [ -x "$(command -v chshot)" ]; then
        echo 'Error: chshot is not installed.' >&2
        exit 1
    fi
    if ! [ -x "$(command -v chcodenet)" ]; then
        echo 'Error: chcodenet is not installed.' >&2
        exit 1
    fi
    if ! [ -x "$(command -v chmount)" ]; then
        echo 'Error: chmount is not installed.' >&2
        exit 1
    fi

    emu_default_videosubtype="8565early"
}

function chameleon_reset
{
#    echo "chameleon_reset"

    # clear the "ready"
    echo -ne "XXXXXX" > $RDUMMY
    chacocmd --addr 1224 --writemem $RDUMMY > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi

    # trigger reset
    echo -ne "X" > $RDUMMY
    chacocmd --addr 0x80000000 --writemem $RDUMMY > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
#    sleep 3

    # check for "ready."
    RET="XXXXXX"
#    echo "poll1:" "$RET"
    SECONDSEND=$((SECONDS + 5))
    while [ "$RET" != "12 05 01 04 19 2e" ]
    do
#        chacocmd --len 1 --addr 0x000100ff --dumpmem
#        chacocmd --len 6 --addr 1224 --readmem $DUMMY > /dev/null
        e=`chacocmd --noprogress --len 6 --addr 1224 --dumpmem`
        if [ "$?" != "0" ]; then exit -1; fi
        RET=${e:10:17}
 #      echo "poll:" "$RET"
        if [ $SECONDS -gt $SECONDSEND ]
        then
            if [ $verbose == "1" ]; then
                echo -ne "[timeout when waiting for reset] "
            fi
            return
        fi
    done;

#    echo "chameleon_reset done"
}

function chameleon_clear_returncode
{
    # clear the return code
    echo -ne "X" > $DUMMY
    chacocmd --addr 0x000100ff --writemem $DUMMY > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
#    echo "chameleon_clear_returncode done"
}

# should return:
# 0   - test passed
# 1   - timeout
# 255 - test failed
function chameleon_poll_returncode
{
    # poll return code
    echo -ne "X" > $DUMMY
    RET="58"
#    RET="58"
#    echo "poll1:" "$RET"
    SECONDSSTART=$((SECONDS + 1 + ((0 + 999999) / 1000000)))
    SECONDSEND=$((SECONDS + 1 + (($1 + 999999) / 1000000)))
#    echo timeout cycles: $1
#    echo secs: $SECONDS
#    echo secsstart: $SECONDSSTART
#    echo secsend: $SECONDSEND
    while [ "$RET" = "58" ]
    do
#        chacocmd --len 1 --addr 0x000100ff --dumpmem
#        chacocmd --len 1 --addr 0x000100ff --readmem $DUMMY > /dev/null
        e=`chacocmd --noprogress --len 1 --addr 0x000100ff --dumpmem`
        if [ "$?" != "0" ]; then exit -1; fi
        RET=${e:10:2}
#        echo "poll:" "$RET"
        if [ $SECONDS -gt $SECONDSEND ]
        then
            if [ $verbose == "1" ]; then
                echo -ne "[timeout when waiting for return code, start:"$SECONDSSTART" end:"$SECONDSEND"] "
            fi
            RET=1
            return $RET
        fi
#        echo "$SECONDS"" -gt ""$SECONDSEND"
#        sleep 1
    done;

    if [ "$RET" = "ff" ]; then
        RET=255
    fi

    if [ $verbose == "1" ]; then
        echo -ne "[start:"$SECONDSSTART" end:"$SECONDSEND"] "
    fi
    
#    echo "chameleon_poll_returncode done"
#    echo "poll:" "$RET"
    return $RET
}

# $1 test path
# $2 cartridge name
function chameleon_make_crtid
{
    dd if="$1/$2" bs=1 skip=23 count=1 of=$CDUMMY 2> /dev/null > /dev/null
# use od instead of hex, since that always works
#    crtid=`hex $CDUMMY`
#    crtid="${crtid:6:2}"
#    echo -ne "[chameleon_make_crtid:"$1":"$2"]"
    crtlit=`od -An -t x1 $CDUMMY`
    crtlit="${crtlit:1:2}"
#    echo -ne "[id:"$crtlit"]"
    dd if="$1/$2" bs=1 skip=24 count=1 of=$CDUMMY 2> /dev/null > /dev/null
    crtexrom=`od -An -t x1 $CDUMMY`
    crtexrom="${crtexrom:1:2}"
    dd if="$1/$2" bs=1 skip=25 count=1 of=$CDUMMY 2> /dev/null > /dev/null
    crtgame=`od -An -t x1 $CDUMMY`
    crtgame="${crtgame:1:2}"

#    echo "exrom:"$crtexrom
#    echo "game:"$crtgame
    
    case "$crtlit" in
        "00")
                # generic (16k ultimax)
                crtid="\xfd"
                if [ "$crtexrom" == "00" ] && [ "$crtgame" == "01" ]
                then
                    # generic (8k)
                    crtid="\xfe"
                fi
                if [ "$crtexrom" == "00" ] && [ "$crtgame" == "00" ]
                then
                    # generic (16k)
                    crtid="\xfc"
                fi
        
            ;;
        "01")
                # ar -> retro replay
                crtid="\x01"
            ;;
        "08")
                # supergames
                crtid="\x08"
            ;;
        "09")
                # nordic power -> retro replay
                crtid="\x01"
            ;;
        "20")
                # easyflash
                crtid="\x20"
            ;;
        "24")
                # retro replay
                crtid="\x01"
            ;;
        "35")
                # pagefox
                crtid="\x35"
            ;;
        *)
                echo -ne " *** unsupported crt id: 0x"$crtlit" *** "
                crtid="\x00"
            ;;
    esac
    echo -ne "(crtid:\$"$crtlit")"
}

# $1 test path
# $2 cartridge name
function chameleon_mount_cartridge
{
# put a message on C64 screen
# "uploading cartridge image, please wait  "
    echo -ne "\x15\x10\x0c\x0f\x01\x04\x09\x0e\x07\x20\x03\x01\x12\x14\x12\x09\x04\x07\x05\x20\x09\x0d\x01\x07\x05\x2c\x20\x10\x0c\x05\x01\x13\x05\x20\x17\x01\x09\x14\x20\x20" > $RDUMMY
    chacocmd --addr 1984 --writemem $RDUMMY > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
# send cartridge image
    echo -ne "(cartridge:$2) "
    chmount --silent --embedded-progress -crt "$1/$2"
    if [ "$?" != "0" ]; then exit -1; fi
# remove message from C64 screen
    echo -ne "                                        " > $RDUMMY
    chacocmd --addr 1984 --writemem $RDUMMY > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
}

# $1 test path
# $2 d64 name
function chameleon_mount_d64
{
# put a message on C64 screen
# "uploading disk image, please wait  "
    echo -ne "\x15\x10\x0c\x0f\x01\x04\x09\x0e\x07\x20\x04\x09\x13\x0b\x20\x09\x0d\x01\x07\x05\x2c\x20\x10\x0c\x05\x01\x13\x05\x20\x17\x01\x09\x14\x20\x20\x20\x20\x20\x20\x20" > $RDUMMY
    chacocmd --addr 1984 --writemem $RDUMMY > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
# send cartridge image
    echo -ne "(disk:$2) "
    if [ $verbose == "1" ]; then
        echo "[chmount -d64 ""$1/$2""]"
    fi
    chmount --silent --embedded-progress -d64 "$1/$2"
    if [ "$?" != "0" ]; then exit -1; fi
# remove message from C64 screen
    echo -ne "                                        " > $RDUMMY
    chacocmd --addr 1984 --writemem $RDUMMY > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
}

# $1 test path
# $2 g64 name
function chameleon_mount_g64
{
# put a message on C64 screen
# "uploading disk image, please wait  "
    echo -ne "\x15\x10\x0c\x0f\x01\x04\x09\x0e\x07\x20\x04\x09\x13\x0b\x20\x09\x0d\x01\x07\x05\x2c\x20\x10\x0c\x05\x01\x13\x05\x20\x17\x01\x09\x14\x20\x20\x20\x20\x20\x20\x20" > $RDUMMY
    chacocmd --addr 1984 --writemem $RDUMMY > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
# send cartridge image
    echo -ne "(disk:$2) "
    chmount --silent --embedded-progress -g64 "$1/$2"
    if [ "$?" != "0" ]; then exit -1; fi
# remove message from C64 screen
    echo -ne "                                        " > $RDUMMY
    chacocmd --addr 1984 --writemem $RDUMMY > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
}

# $1 test path
function chameleon_mount_diskimage
{
    # if test uses a diskimage, mount it
    if [ x"$mounted_d64"x != x""x ]; then
        chameleon_mount_d64 "$1" "$mounted_d64"
    fi
    if [ x"$mounted_g64"x != x""x ]; then
        chameleon_mount_g64 "$1" "$mounted_g64"
    fi
}

# $1 = 1 - enable cartridge
# $2 test path
function chameleon_make_helper_options
{
#    echo -ne "[chameleon_make_helper_options:"$1":"$2"]"
    # set cartridge type
    if [ X"$1"X = X"1"X ]
    then
        chameleon_make_crtid "$2" "$mounted_crt"
        echo -ne "\x00" > $RDUMMY
        echo -ne "$crtid" >> $RDUMMY
    else
        echo -ne "\x20" > $RDUMMY
        echo -ne "\x00" >> $RDUMMY
    fi

    # set REU type
    if [ $reu_enabled = 1 ]
    then
        case "$reu_size" in
            128)
                    echo -ne "\x80" >> $RDUMMY
                ;;
            256)
                    echo -ne "\x81" >> $RDUMMY
                ;;
            512)
                    echo -ne "\x82" >> $RDUMMY
                ;;
            1024)
                    echo -ne "\x83" >> $RDUMMY
                ;;
            2048)
                    echo -ne "\x84" >> $RDUMMY
                ;;
            4096)
                    echo -ne "\x85" >> $RDUMMY
                ;;
            8192)
                    echo -ne "\x86" >> $RDUMMY
                ;;
            16384)
                    echo -ne "\x87" >> $RDUMMY
                ;;
            *)
                    echo -ne "\x00" >> $RDUMMY
                ;;
        esac
    else
        # set GEORAM type
        if [ $georam_enabled = 1 ]
        then
            case "$georam_size" in
                512)
                        echo -ne "\x58" >> $RDUMMY
                    ;;
                1024)
                        echo -ne "\x60" >> $RDUMMY
                    ;;
                2048)
                        echo -ne "\x68" >> $RDUMMY
                    ;;
                4096)
                        echo -ne "\x70" >> $RDUMMY
                    ;;
                *)
                        echo -ne "\x00" >> $RDUMMY
                    ;;
            esac
        else
            echo -ne "\x00" >> $RDUMMY
        fi
    fi
    # set SID type
    if [ $new_sid_enabled = 1 ]
    then
        echo -ne "\x01" >> $RDUMMY
    else
        echo -ne "\x00" >> $RDUMMY
    fi
    # set CIA type
    if [ $new_cia_enabled = 1 ]
    then
        echo -ne "\x02" >> $RDUMMY
    else
        echo -ne "\x00" >> $RDUMMY
    fi
    chacocmd --addr 0x400 --writemem $RDUMMY > /dev/null
}

function chameleon_setup_videomode
{
#    echo "setup_videomode":"${videotype}":"$lastprogvideotype":"$testprogvideotype":

    if [ x"$testprogvideotype"x = x-1x ]; then
        # if testprog has no mode and no mode was set -> do not switch
        if [ x"${videotype}"x == xx ]; then
            if [ $verbose == "1" ]; then
                echo -ne "[videomode: using last: "${lastprogvideotype}"] - "
            fi
            return
        fi
        nextprogvideotype="${videotype}"
    else
        nextprogvideotype="$testprogvideotype"
    fi
    
    if [ $verbose == "1" ]; then
        echo -ne "[videomode: "$nextprogvideotype"] - "
    fi

    # return if new mode is the same as the old mode
    if [ x"$lastprogvideotype"x == x"$nextprogvideotype"x ]; then
        return
    fi
    
    if [ x"$nextprogvideotype"x == x"PAL"x ]; then
        echo -ne "\x20" > $RDUMMY
    fi
    if [ x"$nextprogvideotype"x == x"NTSC"x ]; then
        echo -ne "\x01" > $RDUMMY
    fi
    lastprogvideotype=$nextprogvideotype
    
    chacocmd --addr 0x400 --writemem $RDUMMY > /dev/null    
    
    # run helper program
    chameleon_clear_returncode
    chcodenet -x chameleon-videomode.prg > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
    chameleon_poll_returncode 5

    chameleon_reset
    
#    echo "setup_videomode done"
}

function chameleon_remove_cartridge
{
    # overwrite the CBM80 signature with generic "cartridge off" program
    chacocmd --addr 0x00120000 --writemem chameleon-crtoff.prg > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
#    echo -ne "."    
    chacocmd --addr 0x00110000 --writemem chameleon-crtoff.prg > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
#    echo -ne "."    
    chacocmd --addr 0x00a00000 --writemem chameleon-crtoff.prg > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
#    echo -ne "."    
    chacocmd --addr 0x00b00000 --writemem chameleon-crtoff.prg > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
#    echo -ne "."    
    # reset
    chameleon_reset
}

# FIXME
function chameleon_remove_disk
{
    # reset here so the previous test doesnt keep reading from drive
    chameleon_reset
}

################################################################################

# called once before any tests run
function chameleon_prepare
{
    lastprogvideotype=-1
    if [ x"${videotype}"x == xx ]; then
        testprogvideotype=-1
    else
        testprogvideotype="${videotype}"
    fi

    echo -ne "preparing chameleon."
    # fill 0x00300000-0x003a8000 to prevent "killer tracks"
#    dd if=/dev/zero of=$RDUMMY bs=64k count=58 > /dev/null 2> /dev/null 
#    dd if=/dev/random of=$RDUMMY bs=64k count=1 > /dev/null 2> /dev/null 
#    cat /dev/null | tr '\000' '\010' | dd of=$RDUMMY bs=64k count=1 > /dev/null 2> /dev/null
#    chacocmd --addr 0x00301ffe --writemem $RDUMMY > /dev/null
    echo -ne "."
    # press F3 in the menu
    echo -ne "\x86" > $RDUMMY
    chacocmd --addr 0x001300b4 --writemem $RDUMMY > /dev/null    
    sleep 3
    echo -ne "."
    chameleon_remove_cartridge
    echo -ne "."
    chameleon_setup_videomode
    echo -ne "."
#    dd bs=256 count=768 if=/dev/zero of=$RDUMMY > /dev/null 2> /dev/null 
#    chmount -d64 $RDUMMY > /dev/null
    chcodenet -x chameleon-driveinit.prg > /dev/null
#    echo -ne "."
#    # run helper program
#    chameleon_clear_returncode
#    chcodenet -x chameleon-helper.prg > /dev/null
#    if [ "$?" != "0" ]; then exit -1; fi
#    chameleon_poll_returncode 5
    echo "ok"
}

# $1  option
# $2  test path
function chameleon_get_options
{
#    echo chameleon_get_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vicii-pal")
#                exitoptions="-pal"
                testprogvideotype="PAL"
            ;;
        "vicii-ntsc")
#                exitoptions="-ntsc"
                testprogvideotype="NTSC"
            ;;
        "vicii-ntscold")
#                exitoptions="-ntscold"
                testprogvideotype="NTSCOLD"
            ;;
        "vicii-old") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "old" PAL
#                    exitoptions="-VICIImodel 6569"
                    testprogvideosubtype="6569"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "old" NTSC
#                    exitoptions="-VICIImodel 6567"
                    testprogvideosubtype="6567"
                fi
            ;;
        "vicii-new") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "new" PAL
#                    exitoptions="-VICIImodel 8565"
                    testprogvideosubtype="8565early"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "new" NTSC
#                    exitoptions="-VICIImodel 8562"
                    testprogvideosubtype="8562early"
                fi
            ;;
        "cia-old")
#                exitoptions="-ciamodel 0"
                new_cia_enabled=0
            ;;
        "cia-new")
#                exitoptions="-ciamodel 1"
                new_cia_enabled=1
            ;;
        "sid-old")
#                exitoptions="-sidenginemodel 256"
                new_sid_enabled=0
            ;;
        "sid-new")
#                exitoptions="-sidenginemodel 257"
                new_sid_enabled=1
            ;;
        "reu128k")
                reu_size=128
                reu_enabled=1
            ;;
        "reu256k")
                reu_size=256
                reu_enabled=1
            ;;
        "reu512k")
                reu_size=512
                reu_enabled=1
            ;;
        "reu1m")
                reu_size=1024
                reu_enabled=1
            ;;
        "reu2m")
                reu_size=2048
                reu_enabled=1
            ;;
        "reu4m")
                reu_size=4096
                reu_enabled=1
            ;;
        "reu8m")
                reu_size=8192
                reu_enabled=1
            ;;
        "reu16m")
                reu_size=16384
                reu_enabled=1
            ;;
        "geo512k")
                georam_size=512
                georam_enabled=1
            ;;
        "geo1m")
                georam_size=1024
                georam_enabled=1
            ;;
        "geo2m")
                georam_size=2048
                georam_enabled=1
            ;;
        "geo4m")
                georam_size=4096
                georam_enabled=1
            ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    mounted_d64="${1:9}"
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    mounted_g64="${1:9}"
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then
                    mounted_crt="${1:9}"
                fi
            ;;
    esac
}


# $1  option
# $2  test path
function chameleon_get_cmdline_options
{
#    echo chameleon_get_cmdline_options "$1"
    exitoptions=""
    case "$1" in
        # FIXME: the returned options are meaningless right now,
        #        chameleon_run_screenshot and chameleon_run_exitcode may use them
        "PAL")
                exitoptions="-pal"
            ;;
        "NTSC")
                exitoptions="-ntsc"
            ;;
        "NTSCOLD")
                exitoptions="-ntscold"
            ;;
#        "8565") # "new" PAL
#                exitoptions=""
#            ;;
#        "8562") # "new" NTSC
#                exitoptions=""
#            ;;
        "6526") # "old" CIA
                exitoptions="-ciamodel 0"
                new_cia_enabled=0
            ;;
        "6526A") # "new" CIA
                exitoptions="-ciamodel 1"
                new_cia_enabled=1
            ;;
    esac
}

################################################################################
# reset
# run test program
# exit when write to $d7ff occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)
# save a screenshot at exit - success or failure is determined by comparing screenshots

# $1  test path
# $2  test program name
# $3  timeout cycles
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function chameleon_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-chameleon.png

    if [ X"$screenshottest"X == X"$mounted_crt"X ]
    then
        # no test program, the test must be in a cartridge

        # also resets c64
        chameleon_remove_cartridge
        
        chameleon_mount_diskimage "$1"
        
        chameleon_setup_videomode

        chameleon_make_helper_options 1 "$1"
        if [ "$?" != "0" ]; then exit -1; fi

        # run helper program
        chameleon_clear_returncode
        chcodenet -x chameleon-helper.prg > /dev/null
        if [ "$?" != "0" ]; then exit -1; fi
        chameleon_poll_returncode 5

        chameleon_mount_cartridge "$1" "$mounted_crt"
        
        chameleon_clear_returncode
        # trigger reset  (run cartridge)
        chcodenet --reset
        if [ "$?" != "0" ]; then exit -1; fi
        chameleon_poll_returncode $(($3 + 1))
#        exitcode=$?
    else

#       also resets c64
        chameleon_remove_cartridge

        chameleon_mount_diskimage "$1"
        
        chameleon_setup_videomode

        if [ X"$mounted_crt"X == X""X ]
        then
            chameleon_make_helper_options 0 "$1"
            if [ "$?" != "0" ]; then exit -1; fi
        else
            chameleon_make_helper_options 1 "$1"
            if [ "$?" != "0" ]; then exit -1; fi
        fi

        # run the helper program (enable I/O RAM at $d7xx)
        chameleon_clear_returncode
        chcodenet -x chameleon-helper.prg > /dev/null
        if [ "$?" != "0" ]; then exit -1; fi
        chameleon_poll_returncode 5

        # if there is a cartridge image, then mount it        
        if [ X"$mounted_crt"X != X""X ]
        then
#echo call chameleon_mount_cartridge "$1" "$mounted_crt"
            chameleon_mount_cartridge "$1" "$mounted_crt"
            # trigger reset  (run cartridge)
            chcodenet --resetwait
        fi
    
        # run program
        chameleon_clear_returncode
        chcodenet -x "$1"/"$screenshottest" > /dev/null
        if [ "$?" != "0" ]; then exit -1; fi
        chameleon_poll_returncode $(($3 + 1))
#        exitcode=$?
    fi

    # sleep until timeout, then get the screenshot
#    timeoutsecs=`expr \( $3 + 999999 \) / 1000000`
#    sleep $timeoutsecs
    if [ "${videotype}" == "NTSC" ]; then
        chshot --ntsc -o "$1"/.testbench/"$screenshottest"-chameleon.png
        if [ "$?" != "0" ]; then exit -1; fi
    else
        chshot -o "$1"/.testbench/"$screenshottest"-chameleon.png
        if [ "$?" != "0" ]; then exit -1; fi
    fi
    
    # if the test was a cartrige, kill it
    if [ X"$screenshottest"X == X"$mounted_crt"X ]; then
        chameleon_remove_cartridge
    fi
    
    # if test used a diskimage, remove it
    if [ x"$mounted_d64"x != x""x ] || [ x"$mounted_g64"x != x""x ]; then
        chameleon_remove_disk
    fi
    
    # compare screenshot against reference
    if [ -f "$refscreenshotname" ]
    then
        # defaults for PAL
        CHAMREFSXO=32
        CHAMREFSYO=35
        CHAMSXO=53
        CHAMSYO=62

#        echo [ "${refscreenshotvideotype}":"${videotype}" ]

        if [ "${refscreenshotvideotype}" == "NTSC" ]; then
            CHAMREFSXO=32
            CHAMREFSYO=23
        fi

        # when either the testbench was run with --ntsc, or the test is ntsc-specific,
        # then we need the offsets on the NTSC screenshot
        if [ "${videotype}" == "NTSC" ] || [ "${testprogvideotype}" == "NTSC" ]; then
            CHAMSXO=61
            CHAMSYO=38
        fi

#        echo ./cmpscreens "$refscreenshotname" "$CHAMREFSXO" "$CHAMREFSYO" "$1"/.testbench/"$screenshottest"-chameleon.png "$CHAMSXO" "$CHAMSYO"
        ./cmpscreens "$refscreenshotname" "$CHAMREFSXO" "$CHAMREFSYO" "$1"/.testbench/"$screenshottest"-chameleon.png "$CHAMSXO" "$CHAMSYO"
        exitcode=$?
    else
        echo -ne "reference screenshot missing ("$refscreenshotname") - "
        exitcode=255
    fi

    if [ $verbose == "1" ]; then
        echo -ne "[exitcode: "$exitcode"] "
    fi

}

################################################################################
# reset
# run test program
# exit when write to $d7ff occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)

# $1  test path
# $2  test program name
# $3  timeout cycles
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function chameleon_run_exitcode
{
#    echo chameleon_run_exitcode X"$1"X / X"$2"X

    if [ X"$2"X == X""X ]
    then
        # no test program, the test must be in a cartridge
   
        # also resets c64
        chameleon_remove_cartridge
        
        chameleon_mount_diskimage "$1"

        chameleon_setup_videomode

        chameleon_make_helper_options 1 "$1"
        if [ "$?" != "0" ]; then exit -1; fi

        # run helper program
        chameleon_clear_returncode
        chcodenet -x chameleon-helper.prg > /dev/null
        if [ "$?" != "0" ]; then exit -1; fi
        chameleon_poll_returncode 5

#echo call chameleon_mount_cartridge "$1" "$mounted_crt"
        chameleon_mount_cartridge "$1" "$mounted_crt"

        # trigger reset  (run cartridge)
        chameleon_clear_returncode
        chcodenet --reset
        if [ "$?" != "0" ]; then exit -1; fi
        chameleon_poll_returncode $(($3 + 1))
        exitcode=$?

        chameleon_remove_cartridge
    else
#       also resets c64
        chameleon_remove_cartridge

        chameleon_mount_diskimage "$1"
        
        chameleon_setup_videomode

        if [ X"$mounted_crt"X == X""X ]
        then
            chameleon_make_helper_options 0 "$1"
            if [ "$?" != "0" ]; then exit -1; fi
        else
            chameleon_make_helper_options 1 "$1"
            if [ "$?" != "0" ]; then exit -1; fi
        fi

        # run the helper program (enable I/O RAM at $d7xx)
        chameleon_clear_returncode
        chcodenet -x chameleon-helper.prg > /dev/null
        if [ "$?" != "0" ]; then exit -1; fi
        chameleon_poll_returncode 5

# if there is a cartridge image, then mount it        
        if [ X"$mounted_crt"X != X""X ]
        then
#echo call chameleon_mount_cartridge "$1" "$mounted_crt"
            chameleon_mount_cartridge "$1" "$mounted_crt"
            # trigger reset  (run cartridge)
            chcodenet --resetwait > /dev/null
        fi
        
        # run program
        chameleon_clear_returncode
        chcodenet -x "$1"/"$2" > /dev/null
        if [ "$?" != "0" ]; then exit -1; fi
        chameleon_poll_returncode $(($3 + 1))
        exitcode=$?
        
        chameleon_remove_cartridge
        
    fi
    
    # if test used a diskimage, remove it
    if [ x"$mounted_d64"x != x""x ] || [ x"$mounted_g64"x != x""x ]; then
        chameleon_remove_disk
    fi

    if [ $verbose == "1" ]; then
        echo -ne "[exitcode: "$exitcode"] "
    fi
#    echo "exited with: " $exitcode
}

