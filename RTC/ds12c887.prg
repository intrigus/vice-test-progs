d � &e � THIS IS EXAMPLE OF USING @f � DS12C887 FROM BASIC Fg � Rh � A$(7) ji � A�1�7:� A$(A):� A pj : �m � "�DS12C887 RTC TEST" �n � "SELECT BASE ADDRESS:" �o � "1. $D500" �p � "2. $D600" �q � "3. $D700" �r � "4. $DE00" �s � "5. $DF00" 	t � 198,0:� 198,1: � A$ Y	u � A$ � "1" � BASE�54528:� 130:� BASE ADDRESS OF CHIP (D500) �	v � A$ � "2" � BASE�54784:� 130:� BASE ADDRESS OF CHIP (D600) �	w � A$ � "3" � BASE�55040:� 130:� BASE ADDRESS OF CHIP (D700) 
x � A$ � "4" � BASE�56832:� 130:� BASE ADDRESS OF CHIP (DE00) Y
y � A$ � "5" � BASE�57088:� 130:� BASE ADDRESS OF CHIP (DF00) c
� � 116 m
� � "�" �
� � "PRESS SPACE TO START OSCILLATOR" �
� � GET TIME FROM RTC �
� � BASE,6:DW��(BASE�1):� DW � 7 � DW � 0 �
� � BASE,4:H��(BASE�1) � � BASE,2:MI��(BASE�1) '� � BASE,0:S��(BASE�1) @� � BASE,7:D��(BASE�1) Y� � BASE,8:M��(BASE�1) r� � BASE,9:Y��(BASE�1) �� V�H:� 1100:� V;"� :"; �� V�MI:� 1100:� V;"� :"; �V�S:� 1100:� V;"�  "; �V�M:� 1100:� V;"� /"; �V�D:� 1100:� V;"� /"; V�Y:� 1100:� V;"�  "; '� A$(DW);"        " B	� SETUP CIA1 TOD CLOCK H
: gPM�0:V�H:� 1100:�V�13� 280 }V�V�12:� 1000:H�V �� 56329,S �� 56328,0 �": �#� START OSCILLATOR WHEN SPACE IS PRESSED �': �,� A$:� A$ �� " " � 200 6� BASE,10:A��(BASE�1) #;� BASE�1,(A � 143) � 32 -�� 200 Q�� CONVERT V TO BCD, RETURN IN V q�V��(V�10)�16�(V�10��(V�10)) w�� �L� CONVERT V FROM BCD, RETURN IN V �VV��(V�16)�10�(V�16��(V�16)) �`� j� SUNDAY,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY   