    1 x=0
    2 ready:ify=-1then10
    3 poke513+x,y:x=x+1:goto2
   10 x=0
   20 ready:ify=-1then100
   30 poke256+x,y:x=x+1:goto20
  100 sys513:ifpeek(512)=1thenprint"cpu is a 6509":end
  110 load"new6502",8
 1000 data120,165,1,72,165,0,72,165,254,72,165,255,72,169,0,133,254,168,162,1,169
 1010 data2,133,255,132,1,177,254,141,0,2,134,1,177,254,205,0,2,208,18,73,255
 1020 data132,1,145,254,141,0,2,134,1,177,254,205,0,2,240,5,162,1,76,0,1,162,0
 1030 data76,0,1,-1
 2000 data132,1,173,0,2,73,255,145,254,104,133,255,104,133,254,104,133,0,104,133
 2010 data1,142,0,2,88,96,-1
 3030 data76,0,1,-1

