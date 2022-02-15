VDC Timing test based on "Some preliminary data on VDC timing"
by Steven L. Judd / Andreas Boose from Commodore Discovery Issue # 1 

The original basic program was corrupted, however there was a republished 
version recently posted on the commodore 128 forum:
http://c-128.freeforums.net/thread/672/overy-magazine-issue-preliminary-timing

The original programs are included here:
vdc-explorer.bas
vdc-explorer.o

To use:
- Disable TDE
- Enable virtual device traps
- Launch x128 from this testprogs directory
- Make sure the VDC screen is active from BASIC. (type GRAPHIC5 otherwise)
- LOAD "vdc-explorer.bas",8
- RUN
- (wait, or switch to warp)

Results from real 128 yet to be posted for 'fixed' versions of programs above.

=============================================================================

(OLD first attempt before the uncorrupted versions were found)

Note the original basic program included in the above magazine was corrupted. 
The ML stuff was OK.
Based on what I could recover I've completed the basic program, and it produces 
similar results on a real c128 to the original article so it's probably close 
enough if not the same.
Either way, the code I've added to Vice approximates the timing produced by my 
re-written program on a real c128.

To use:
- Disable TDE
- Enable virtual device traps
- Launch x128 from this testprogs directory
- LOAD "V*",8,1
- LOAD "TT*",8
- RUN
- (wait, or switch to warp)

Results should approximately match screenshot off real c128 found with this test 
program.

TODO:
- combine the ml and basic into one program so it's less fiddly to launch
- add separate tests for fill & copy operations, because common sense suggests 
  a copy should take twice as long as a fill
