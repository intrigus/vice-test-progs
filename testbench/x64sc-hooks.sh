
X64SCOPTS+=" -default"
X64SCOPTS+=" -model c64c"
#X64SCOPTS+=" -model c64 -ntsc "
X64SCOPTS+=" -VICIIfilter 0"
X64SCOPTS+=" -VICIIextpal"
X64SCOPTS+=" -VICIIpalette pepto-pal.vpl"
X64SCOPTS+=" -warp"
#X64SCOPTS+=" -console"
X64SCOPTS+=" -debugcart"
X64SCOPTS+=" -jamaction 1"
#X64SCOPTS+=" -raminitstartvalue 255 -raminitvalueinvert 4"

#X64SCOPTS+=" -autostartprgmode 1"

#X64SCOPTS+=" -raminitstartvalue 0"
#X64SCOPTS+=" -raminitvalueinvert 8"
#X64SCOPTS+=" -raminitpatterninvert 0"
#X64SCOPTS+=" -raminitvalueoffset 0"
#X64SCOPTS+=" -raminitpatterninvertvalue 0"
#X64SCOPTS+=" -raminitstartrandom 0"
#X64SCOPTS+=" -raminitrepeatrandom 0"
#X64SCOPTS+=" -raminitrandomchance 1"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
X64SCOPTSEXITCODE+=" -console"
X64SCOPTSSCREENSHOT+=" -minimized"

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
X64SCSXO=32
X64SCSYO=35

X64SCREFSXO=32
X64SCREFSYO=35

function x64sc_check_environment
{
    X64SC="$EMUDIR"x64sc
    
    emu_default_videosubtype="8565"
}

# $1  option
# $2  test path
function x64sc_get_options
{
#    echo x64sc_get_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vicii-pal")
                exitoptions="-pal"
                testprogvideotype="PAL"
            ;;
        "vicii-ntsc")
                exitoptions="-ntsc"
                testprogvideotype="NTSC"
            ;;
        "vicii-ntscold")
                exitoptions="-ntscold"
                testprogvideotype="NTSCOLD"
            ;;
        "vicii-old") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "old" PAL
                    exitoptions="-VICIImodel 6569"
                    testprogvideosubtype="6569"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "old" NTSC
                    exitoptions="-VICIImodel 6567"
                    testprogvideosubtype="6567"
                fi
            ;;
        "vicii-new") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "new" PAL
                    exitoptions="-VICIImodel 8565"
                    testprogvideosubtype="8565"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "new" NTSC
                    exitoptions="-VICIImodel 8562"
                    testprogvideosubtype="8562"
                fi
            ;;
        "cia-old")
                exitoptions="-ciamodel 0"
                new_cia_enabled=0
            ;;
        "cia-new")
                exitoptions="-ciamodel 1"
                new_cia_enabled=1
            ;;
        "sid-old")
                exitoptions="-sidenginemodel 256"
                new_sid_enabled=0
            ;;
        "sid-new")
                exitoptions="-sidenginemodel 257"
                new_sid_enabled=1
            ;;
        "reu128k")
                exitoptions="-reu -reusize 128"
                reu_enabled=1
            ;;
        "reu256k")
                exitoptions="-reu -reusize 256"
                reu_enabled=1
            ;;
        "reu512k")
                exitoptions="-reu -reusize 512"
                reu_enabled=1
            ;;
        "reu1m")
                exitoptions="-reu -reusize 1024"
                reu_enabled=1
            ;;
        "reu2m")
                exitoptions="-reu -reusize 2048"
                reu_enabled=1
            ;;
        "reu4m")
                exitoptions="-reu -reusize 4096"
                reu_enabled=1
            ;;
        "reu8m")
                exitoptions="-reu -reusize 8192"
                reu_enabled=1
            ;;
        "reu16m")
                exitoptions="-reu -reusize 16384"
                reu_enabled=1
            ;;
        "geo512k")
                exitoptions="-georam -georamsize 512"
                georam_enabled=1
            ;;
        "plus60k")
                exitoptions="-memoryexphack 2"
                plus60k_enabled=1
            ;;
        "plus256k")
                exitoptions="-memoryexphack 3"
                plus256k_enabled=1
            ;;
        "dqbb")
                exitoptions="-dqbb"
                dqbb_enabled=1
            ;;
        "ramcart128k")
                exitoptions="-ramcart -ramcartsize 128"
                ramcart_enabled=1
            ;;
        "isepic")
                exitoptions="-isepicswitch -isepic"
                isepic_enabled=1
            ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    exitoptions="-8 $2/${1:9}"
                    mounted_d64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    exitoptions="-8 $2/${1:9}"
                    mounted_g64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountp64:" ]; then
                    exitoptions="-8 $2/${1:9}"
                    mounted_p64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then
                    exitoptions="-cartcrt $2/${1:9}"
                    mounted_crt="${1:9}"
                    echo -ne "(cartridge:${1:9}) "
                fi
            ;;
    esac
}

# $1  option
# $2  test path
function x64sc_get_cmdline_options
{
#    echo x64sc_get_cmdline_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "PAL")
                exitoptions="-pal"
            ;;
        "NTSC")
                exitoptions="-ntsc"
            ;;
        "NTSCOLD")
                exitoptions="-ntscold"
            ;;
        "6569") # "old" PAL
                exitoptions="-VICIImodel 6569"
            ;;
        "8565") # "new" PAL
                exitoptions="-VICIImodel 8565"
            ;;
        "6567") # "old" NTSC
                exitoptions="-VICIImodel 6567"
            ;;
        "8562") # "new" NTSC
                exitoptions="-VICIImodel 8562"
            ;;
        "6526") # "old" CIA
                exitoptions="-ciamodel 0"
            ;;
        "6526A") # "new" CIA
                exitoptions="-ciamodel 1"
            ;;
    esac
}

# called once before any tests run
function x64sc_prepare
{
    true
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
function x64sc_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-x64sc.png
    if [ $verbose == "1" ]; then
        echo $X64SC $X64SCOPTS $X64SCOPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-x64sc.png "$4"
        $X64SC $X64SCOPTS $X64SCOPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-x64sc.png "$4" 2> /dev/null | grep "cycles elapsed" | tr '\n' ' '
        exitcode=${PIPESTATUS[0]}
    else
        $X64SC $X64SCOPTS $X64SCOPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-x64sc.png "$4" 1> /dev/null 2> /dev/null
        exitcode=$?
    fi    
    
    if [ $verbose == "1" ]; then
        echo $X64SC "exited with: " $exitcode
    fi
    
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $X64SC failed.\n"
                exit -1
            fi
        fi
    fi

    if [ $exitcode -eq 0 ] || [ $exitcode -eq 255 ]
    then
        if [ -f "$refscreenshotname" ]
        then

            # defaults for PAL
            X64SCREFSXO=32
            X64SCREFSYO=35
            X64SCSXO=32
            X64SCSYO=35
            
#            echo [ refscreenshotvideotype:"${refscreenshotvideotype}" videotype:"${videotype}" testprogvideomode:"${testprogvideomode}"]
        
            if [ "${refscreenshotvideotype}" == "NTSC" ]; then
                X64SCREFSXO=32
                X64SCREFSYO=23
            fi
        
            # when either the testbench was run with --ntsc, or the test is ntsc-specific,
            # then we need the offsets on the NTSC screenshot
            if [ "${videotype}" == "NTSC" ] || [ "${testprogvideotype}" == "NTSC" ]; then
                X64SCSXO=32
                X64SCSYO=23
            fi
        
    #        echo ./cmpscreens "$refscreenshotname" "$X64SCREFSXO" "$X64SCREFSYO" "$1"/.testbench/"$screenshottest"-x64sc.png "$X64SCSXO" "$X64SCSYO"
            ./cmpscreens "$refscreenshotname" "$X64SCREFSXO" "$X64SCREFSYO" "$1"/.testbench/"$screenshottest"-x64sc.png "$X64SCSXO" "$X64SCSYO"
            exitcode=$?
        else
            echo -ne "reference screenshot missing - "
            exitcode=255
        fi
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
function x64sc_run_exitcode
{
    if [ $verbose == "1" ]; then
        echo $X64SC $X64SCOPTS $X64SCOPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4"
        $X64SC $X64SCOPTS $X64SCOPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 2> /dev/null | grep "cycles elapsed" | tr '\n' ' '
        exitcode=${PIPESTATUS[0]}
    else
        $X64SC $X64SCOPTS $X64SCOPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 1> /dev/null 2> /dev/null
        exitcode=$?
    fi
    if [ $verbose == "1" ]; then
        echo $X64SC "exited with: " $exitcode
    fi
}
