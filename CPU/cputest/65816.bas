   10 x=0
   20 ready:ify=-1then100
   30 poke513+x,y:x=x+1:goto20
  100 sys513:ifpeek(512)=1thenprint"cpu is a 65816":end
  110 print"cpu is a 65802"
 1000 data120,175,0,48,0,207,0,48,1,208,11,26,143,0,48,0,207,0,48,1,240,4,162,1
 1010 data208,2,162,0,58,143,0,48,0,142,0,2,88,96,-1
