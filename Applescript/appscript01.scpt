FasdUAS 1.101.10   ��   ��    k             l      ��  ��    6 0
tell application "Dashboard"	launchend tell
     � 	 	 ` 
 t e l l   a p p l i c a t i o n   " D a s h b o a r d "  	 l a u n c h  e n d   t e l l  
   
  
 l     ��������  ��  ��        l     ����  O         k           l   ��������  ��  ��     ��  U        k           I   �� ��
�� .prcskcodnull���    long  m    ���� o��     ��  I   �� ��
�� .sysodelanull��� ��� nmbr  m    ���� ��  ��    m    ���� ��    m       �                                                                                  sevs  alis    �  Macintosh HD               �y�8H+     jSystem Events.app                                               ;�K2r        ����  	                CoreServices    �y�(      �K$b       j   &   %  :Macintosh HD:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��        l     ��������  ��  ��       !   l     ��������  ��  ��   !  "�� " l      �� # $��   #nh
Hi, assuming you're using function keys to trigger Dashboard you could use the following:

tell application "System Events"
key code 105
delay 1
key code 105
end tell

This is for F13; replace 105 with one of the following depending on your set-up.

F1 122
F2 120
F3 99
F4 118
F5 96
F6 97
F7 98
F8 100
F9 101
F10 109
F11 103
F12 111
F13 105
F14 107
F15 113 

    $ � % %� 
 H i ,   a s s u m i n g   y o u ' r e   u s i n g   f u n c t i o n   k e y s   t o   t r i g g e r   D a s h b o a r d   y o u   c o u l d   u s e   t h e   f o l l o w i n g : 
 
 t e l l   a p p l i c a t i o n   " S y s t e m   E v e n t s " 
 k e y   c o d e   1 0 5 
 d e l a y   1 
 k e y   c o d e   1 0 5 
 e n d   t e l l 
 
 T h i s   i s   f o r   F 1 3 ;   r e p l a c e   1 0 5   w i t h   o n e   o f   t h e   f o l l o w i n g   d e p e n d i n g   o n   y o u r   s e t - u p . 
 
 F 1   1 2 2 
 F 2   1 2 0 
 F 3   9 9 
 F 4   1 1 8 
 F 5   9 6 
 F 6   9 7 
 F 7   9 8 
 F 8   1 0 0 
 F 9   1 0 1 
 F 1 0   1 0 9 
 F 1 1   1 0 3 
 F 1 2   1 1 1 
 F 1 3   1 0 5 
 F 1 4   1 0 7 
 F 1 5   1 1 3   
 
��       �� & '��   & ��
�� .aevtoappnull  �   � **** ' �� (���� ) *��
�� .aevtoappnull  �   � **** ( k      + +  ����  ��  ��   )   *  ���������� �� o
�� .prcskcodnull���    long
�� .sysodelanull��� ��� nmbr�� �  �kh�j Okj [OY��Uascr  ��ޭ