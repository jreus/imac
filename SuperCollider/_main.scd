{\rtf1\ansi\ansicpg1252\cocoartf1504\cocoasubrtf830
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;\f1\fnil\fcharset0 LucidaGrande;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue191;\red0\green0\blue0;\red191\green0\blue0;
\red0\green115\blue0;\red0\green0\blue255;\red96\green96\blue96;\red255\green102\blue0;}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c75000;\csgenericrgb\c0\c0\c0;\csgenericrgb\c75000\c0\c0;
\csgenericrgb\c0\c45000\c0;\csgenericrgb\c0\c0\c100000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c100000\c40000\c0;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs30 \cf2 Server\cf3 .default = s = \cf2 Server\cf3 .internal;\
\
s.waitForBoot \{\
	a = a ? ();\
\
	\cf4 // Amplitude listener 
\f1 \uc0\u65533 
\f0  add some kind of debounce time here\cf3 \
	\cf2 SynthDef\cf3 (\cf5 \\amplistener\cf3 ,\{\cf6 |thresh=0.5|\cf3 \
		\cf6 var\cf3  in,amp,trig;\
		in = \cf2 LeakDC\cf3 .ar(\cf2 SoundIn\cf3 .ar(0));\
		amp = \cf2 Amplitude\cf3 .kr(in);\
		trig = (amp > thresh);\
		\cf2 SendReply\cf3 .kr(trig,\cf7 "/amp"\cf3 ,[amp]);\
	\}).add;\
	s.sync;\
	a.listener_synth = \cf2 Synth\cf3 (\cf5 \\amplistener\cf3 );\
\
\
	\cf4 // Load Key control\cf3 \
	\cf8 ~controlPath\cf3  = \cf7 "_control.scd"\cf3 .resolveRelative;\
	\cf8 ~controlPath\cf3 .load;\
\
\};}