   * MAIN .  CHECK IF DRIVE IS PRESENT Z  1,8,0:  1:  (ST ¯ 128) ² 128 § E ² 1 y  "VICE AUTOSTART TEST":   "EXPECTING:" 
  "TDE:"; 1 ; ³  "VDRIVE:"; 0 ; Ã  "VFS:"; 0 Þ  "AUTOSTART DISK:"; 1 õ  "DISK IMAGE:"; 0 û  	  E ² 1 §  90 	  1000 *	  "MSG:";PU$ 5	  2000 F	  "DIR:";DI$ Z	   "DISKID:";ID$ n	Z  "NO DRIVE:";E y	\  3000 	^  	`  4000 ¼	b  F ² 0 §  55295 , 0:  53280, 5:  "ALL OK" ñ	d  F ³± 0 §  55295 , 255:  53280, 2:  "FAILED" ÷	f  
è * GET POWERUP MESSAGE FROM DRIVE 1
ê 15,8,15,"UI" C
ì15,A,PU$,C,D L
î  15 R
ð t
Ð * GET HEADER FROM DIRECTORY ¢
Ò 1,8,0,"$":DI$²"": ID$²"":  ST ³± 0 §  ¼
Ô I ² 0 ¤ 7: ¡#1, A$: Î
Ö ST ³± 0 §  Ô
Ø ý
Ú I ² 0 ¤ 15: ¡#1, A$: DI$²DI$ªA$:  Ü¡ #1,A$:¡ #1,A$ 9Þ I ² 0 ¤ 5: ¡#1, A$: ID$²ID$ªA$:  Aà  1 Gâ b¸ * CHECK WHAT IS WHAT º È(PU$, 7) ² "CBM DOS" § TD ² 1 :  TDE ENABLED Õ¼ È(PU$, 13) ² "VIRTUAL DRIVE" § VD ² 1 :  VIRTUAL DRIVE 	¾ È(PU$, 7) ² "VICE FS" § FS ² 1 :  FILESYSTEM `À È(DI$, 9) ² "AUTOSTART" ¯ ID$ ³± " #8:0" § AD ² 1 :  USING AUTOSTART DISK IMAGE ¢Â È(DI$, 8) ² "TESTDISK" § D ² 1 :  USING REGULAR DISK IMAGE ¨Ä »Æ "TDE:"; TD ; ÑÈ "VDRIVE:"; VD ; âÊ "VFS:"; FS þÌ "AUTOSTART DISK:"; AD Î "DISK IMAGE:"; D Ð 4  * CHECK FOR ERRORS >¢F ² 0 X¤ TD ³± 1 § F ² F ª 1 r¦ VD ³± 0 § F ² F ª 1 ¨ FS ³± 0 § F ² F ª 1 ¦ª AD ³± 1 § F ² F ª 1 ¿¬ D ³± 0 § F ² F ª 1 Ó® "ERRORS: "; F Ù° ø² PRG AUTOSTART MODES ARE: ´ 0 : VIRTUAL FILESYSTEM G¶ 1 : INJECT TO RAM (THERE MIGHT BE NO DRIVE) ]¸ 2 : COPY TO D64 º $90/144: KERNAL I/O STATUS WORD ST ¼ ¾¾ +-------+---------------------------------+ ëÀ \ BIT 7 \ 1 = DEVICE NOT PRESENT (S) \ Â \ \ 1 = END OF TAPE (T) \ 3Ä \ BIT 6 \ 1 = END OF FILE (S+T) \ \Æ \ BIT 5 \ 1 = CHECKSUM ERROR (T) \ È \ BIT 4 \ 1 = DIFFERENT ERROR (T) \ ¯Ê \ BIT 3 \ 1 = TOO MANY BYTES (T) \ ×Ì \ BIT 2 \ 1 = TOO FEW BYTES (T) \ þÎ \ BIT 1 \ 1 = TIMEOUT READ (S) \ &Ð \ BIT 0 \ 1 = TIMEOUT WRITE (S) \ XÒ +-------+---------------------------------+ ^Ô Ö (S) = SERIAL BUS, (T) = TAPE   