    0 print "{gry3}{clr}patience..."
    1 bload"tt.o"
    2 n=120:c=0
    3 slow:f=1:poke 53265,peek(53265) and 239:rem turn off vic
    4 rem fast:f=2
    5 dim t1(n),t2(n),t3(n),t4(n),t5(n),t6(n),t7(n),t8(n),t9(n),av(9)
   10 test=dec("14c9"):r1=test+1:r2=r1+2:ar=r2+2:r3=ar+2:r4=r3+2:fs=r4+2:ma=fs+2:ff=ma+2
   20 sysdec("1300")
   31 t1(c)=peek(test)-10
   32 t2(c)=peek(r1)+peek(r1+1)*256-10
   33 t3(c)=peek(r2)+peek(r2+1)*256-10
   34 t4(c)=peek(ar)+peek(ar+1)*256-10
   35 t5(c)=peek(r3)+peek(r3+1)*256-10
   36 t6(c)=peek(r4)+peek(r4+1)*256-10
   37 t7(c)=peek(fs)+peek(fs+1)*256-10
   39 t9(c)=peek(ff)+peek(ff+1)*256-10
   40 c=c+1:ifc<ngoto20
   50 fast:poke 53265,peek(53265) or 16:rem turn on vic
   60 c=0
   61 t=0:fori=0ton:t=t+t1(i):next:av(1)=t/n
   62 t=0:fori=0ton:t=t+t2(i):next:av(2)=t/n
   63 t=0:fori=0ton:t=t+t3(i):next:av(3)=t/n
   64 t=0:fori=0ton:t=t+t4(i):next:av(4)=t/n
   65 t=0:fori=0ton:t=t+t5(i):next:av(5)=t/n
   66 t=0:fori=0ton:t=t+t6(i):next:av(6)=t/n
   67 t=0:fori=0ton:t=t+t7(i):next:av(7)=t/n
   69 t=0:fori=0ton:t=t+t9(i):next:av(9)=t/n
  100 fori=1to9:printi,av(i):next
