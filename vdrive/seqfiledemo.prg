  *************** )  *   EXAMPLE >  * READ & WRITE S  * A SEQUENTIAL e  * DATA FILE {  *************** 
 "INITIALIZE DISK" ¤ A$(25) ¯ B(25) Á( 15,8,15,"I0" Ì<  1000 ÚF CR$²Ç(13) àP  ýZ " WRITE SEQ TEST FILE" 	_  	d  ************* 	e  * 2	f  *  WRITE SEQ E	g  *  TEST FILE M	h  * a	i  ************* 	n 2,8,2,"@0:SEQ TEST FILE ,S,W" 	s  1000 ²	u "ENTER A WORD, COMMA, NUMBER" Ò	v "ENTER WORD 'END' TO STOP" ã	x "A$,B";A$,B ö	 A$²"END"§ 160 
 2,A$","Ä(B)CR$; 
  1000  
  120 (
    2 <
È  ************* D
É  * V
Ê  *  READ SEQ i
Ë  *  TEST FILE q
Ì  * 
Í  ************* 
Î  §
Ï "  READ SEQ TEST FILE" ­
Ð  Ï
Ò 2,8,2,"0:SEQ TEST FILE ,S,R" Ú
×  1000 ì
Ü 2,A$(I),B(I) ö
à RS²ST á  1000 æ A$(I),B(I) #ð R S²64 § 300 5ú  RS³±0 § 400 ?I²Iª1 I 220 Q,  2 W6 t"BADDISKSTATUSIS"RS |  2 ¤ è ************ é * «ê *  READ ½ë * THE ERROR Îì *  CHANNEL Öí * éî ************ þò15,EN,EM$,ET,ES ü EN²0 §  &"ERROR ON DISK" 8EN;EM$;ET;ES @  2 F$   