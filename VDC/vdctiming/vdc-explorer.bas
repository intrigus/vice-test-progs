
   10 print "{gry3}{clr}vdc explorer by stephen l. judd":sleep 1
   20 if peek(dec("1300"))=120 then 40
   30 bload"vdc-explorer.o"
   40 n=120:c=0
   50 slow:f=1:poke 53265,peek(53265) and 239
   60 rem fast:f=2
   70 dim t1(n),t2(n),t3(n),t4(n),t5(n),t6(n),t7(n),t9(n),av(8)
   80 print"{clr}":test=dec("14c9"):r1=test+1:r2=r1+2:ar=r2+2:r3=ar+2:r4=r3+2:fs=r4+2:ma=fs+2:ff=ma+2
   90 av(1)=0:av(2)=0:av(3)=0:av(4)=0:av(5)=0:av(6)=0:av(7)=0:av(8)=0
  100 for i=1 to n
  110 sys dec("1300")
  120 t1(i)=peek(test):av(1)=av(1)+t1(i)-10/f
  130 t2(i)=peek(r1)+256*peek(r1+1):av(2)=av(2)+t2(i)
  140 t3(i)=peek(r2)+256*peek(r2+1):av(3)=av(3)+t3(i)
  150 t4(i)=peek(ar)+256*peek(ar+1):av(4)=av(4)+t4(i)
  160 t5(i)=peek(r3)+256*peek(r3+1):av(5)=av(5)+t5(i)
  170 t6(i)=peek(r4)+256*peek(r4+1):av(6)=av(6)+t6(i)
  180 t7(i)=peek(fs)+256*peek(fs+1):av(7)=av(7)+t7(i)
  190 t8=256*peek(ma)+peek(ma+1)
  200 t9(i)=peek(ff)+256*peek(ff+1):av(8)=av(8)+t9(i)
  210 print "{home}{down}{down}{down}{down}"i;t1(i);t2(i);t3(i);t4(i);t5(i);t6(i);t7(i);t9(i)
  220 next
  230 oh=av(1)/n:print"{clr}{wht}test1: overhead="oh" expected="3/f
  240 print"{red}test2:{down}{left}{left}{left}{left}{left}{left}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}";
  250 sr=(av(2)-av(1))/n
  260 print,"single register="sr
  270 print,"expected value="10/f
  280 gosub 600
  290 print"{cyn}test3:{down}{left}{left}{left}{left}{left}{left}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}";
  300 print,"single register twice="(av(3)-av(1))/n
  310 print,"expected value="sr*2
  320 gosub 600
  330 print"{pur}test4:{down}{left}{left}{left}{left}{left}{left}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}";
  340 tr=(av(4)-av(1))/n:print,"total time="tr
  350 ts=tr-(37*5-1)/f:print,"minus loop overhead="ts
  360 print,"div 37 bit-loops="ts-370/f
  370 print,"=> bit-loop repetitions="(ts-370/f)*f/7
  380 gosub 600
  390 print"{grn}test5:{down}{left}{left}{left}{left}{left}{left}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}";
  400 print,"two reads reg 18="(av(5)-av(1))/n
  410 print,"expected value="sr*2+8/f
  420 gosub 600
  430 print"{blu}test6:{down}{left}{left}{left}{left}{left}{left}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}";
  440 m1=(av(6)-av(1))/n:print,"one memory fetch="m1
  450 ev=sr*3+12/f:print,"expected value="ev" diff="m1-ev
  460 print,"prob. num reps to wait for vdc fetch="(m1-ev)/(7/f)
  470 gosub 600
  480 print"{yel}test7:{down}{left}{left}{left}{left}{left}{left}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}";
  490 ur=(av(7)-av(1))/n:print,"loop memory fill="ur
  500 us=ur-3/f-256*(sr+9/f):print,"extra vdc waits="us
  510 print,"average bit-loop repititions:"us/(256*7/f)
  520 gosub 600
  530 print"{orng}test8:{down}{left}{left}{left}{left}{left}{left}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}";
  540 vr=(av(8)-av(1))/n:print,"total block fill="vr
  550 print,"=> approx vdc time for 256 byte block fill="vr-24/f-3*sr
  560 :
  570 gosub 600:if c=1 then 590
  580 fast:c=1:f=2:goto80
  590 print"{cyn}bye!":end
  600 get a$:if a$="" then 600
  610 return
