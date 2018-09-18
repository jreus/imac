{\rtf1\ansi\ansicpg1252\cocoartf1504\cocoasubrtf830
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue191;
\red51\green51\blue191;\red0\green115\blue0;\red0\green0\blue255;\red96\green96\blue96;\red255\green102\blue0;
}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c75000;
\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c0\c45000\c0;\csgenericrgb\c0\c0\c100000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c100000\c40000\c0;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs36 \cf2 /**********************\
Keyboard controls & OSC responders\
\
**************/\cf3 \
\
a = a ? ();\
a.ampthresh = 0.2;\
a.ampincrement = 0.01;\
\cf2 // Window Animations\cf3 \
a.windows = []; \cf2 // array of NSWindow objects which are open\cf3 \
a.views = [];\
a.buttons = []; \cf2 // array of active NSButton objects\cf3 \
a.screenWidth = \cf4 Window\cf3 .screenBounds.right;\
a.screenHeight = \cf4 Window\cf3 .screenBounds.bottom;\
a.cleaning = \cf5 false\cf3 ;\
a.dbounceTime = 0.3;\
a.dbounceIncrement = 0.01;\
a.dbounceActive = \cf5 false\cf3 ;\
o.notNil and: \{o.remove;\}; \cf2 // OSC responder for amplitude\cf3 \
o = \cf4 OSCresponder\cf3 (\cf5 nil\cf3 , \cf6 '/amp'\cf3 , \{\cf7 |t,r,msg|\cf3 \
		\cf2 // Default responder\cf3 \
	if (a.dbounceActive == \cf5 false\cf3 ) \{\
		a.dbounceActive = \cf5 true\cf3 ;\
		(\cf8 "Amplitude: "\cf3 ++ msg[3]).postln;\
		\{ a.dbounceActive = \cf5 false\cf3 ; \}.defer(a.dbounceTime);\
	\};\
\}).add;\
c = \{\cf8 "No cleanup necessary for default audio responder."\cf3 .postln;\}; \cf2 // cleanup function\cf3 \
\
\
\cf4 Post\cf3  << \cf8 "Starting key responders...\\n"\cf3 ;\
\cf4 Keyboard\cf3 .enable(s);\
\cf4 Keyboard\cf3 .setVerbose(\cf5 true\cf3 );\
\
\
\cf2 // Keystroke Macromaker\cf3 \
a.automator = \cf4 KeyAutomator\cf3 .new;\
\
\cf2 // Add control keys to the macro ignore list\cf3 \
a.automator.ignoreKeys = [\
		\cf4 Keyboard\cf3 .getKeycode(\cf6 '1'\cf3 ),  \cf2 // record macro\cf3 \
		\cf4 Keyboard\cf3 .getKeycode(\cf6 '2'\cf3 ),  \cf2 // stop recording\cf3 \
		\cf4 Keyboard\cf3 .getKeycode(\cf6 '3'\cf3 ),  \cf2 // playback macro\cf3 \
		\cf4 Keyboard\cf3 .getKeycode(\cf6 '4'\cf3 ),  \cf2 // loop macro on/off\cf3 \
		\cf4 Keyboard\cf3 .getKeycode(\cf6 '5'\cf3 ),  \cf2 // default audio responder (do nothing)\cf3 \
		\cf4 Keyboard\cf3 .getKeycode(\cf6 '6'\cf3 ),  \cf2 // window grid\cf3 \
		\cf4 Keyboard\cf3 .getKeycode(\cf6 '7'\cf3 ),  \cf2 // window glow\cf3 \
		\cf4 Keyboard\cf3 .getKeycode(\cf6 '8'\cf3 ),  \cf2 // window slide\cf3 \
		\cf4 Keyboard\cf3 .getKeycode(\cf6 '9'\cf3 ),  \cf2 // window zoom\cf3 \
		\cf4 Keyboard\cf3 .getKeycode(\cf6 '0'\cf3 ),  \cf2 // animate desktop background\cf3 \
		\cf4 Keyboard\cf3 .getKeycode(\cf6 'equal'\cf3 ),  \cf2 // +increment amp thresh\cf3 \
		\cf4 Keyboard\cf3 .getKeycode(\cf6 'minus'\cf3 ),  \cf2 // -decrement amp thresh\cf3 \
		\cf4 Keyboard\cf3 .getKeycode(\cf6 'leftbracket'\cf3 ),  \cf2 // -decrement debounce time\cf3 \
		\cf4 Keyboard\cf3 .getKeycode(\cf6 'rightbracket'\cf3 ),  \cf2 // +increment debounce time\cf3 \
];\
\
\
\cf2 /*************** Record/Loop Key Gestures ************\
******************************************************/\cf3 \
\cf4 Post\cf3  << \cf8 "Loading Macro Recording Controls...\\n"\cf3 ;\
\
\cf4 Keyboard\cf3 .addKeyResponder(\cf6 '1'\cf3 ,\{\cf7 |val|\cf3 \
	\cf7 var\cf3  macro;\
	if (val == 1) \{\
		macro = a.automator.recordMacro(0, \cf5 true\cf3 );\
		(\cf8 "Recording Macro 0"\cf3 ).postln;\
	\};\
\});\
\
\cf4 Keyboard\cf3 .addKeyResponder(\cf6 '2'\cf3 ,\{\cf7 |val|\cf3 \
	\cf7 var\cf3  macro;\
	if (val == 1) \{\
		macro = a.automator.stopMacroRecording(0);\
		(\cf8 "Stop Recording Macro 0"\cf3 ).postln;\
	\};\
\});\
\
\cf4 Keyboard\cf3 .addKeyResponder(\cf6 '3'\cf3 ,\{\cf7 |val|\cf3 \
	\cf7 var\cf3  macro;\
	if (val == 1) \{\
		macro = a.automator.playMacro(0);\
		(\cf8 "Play Macro 0"\cf3 ).postln;\
	\};\
\});\
\
\cf4 Keyboard\cf3 .addKeyResponder(\cf6 '4'\cf3 ,\{\cf7 |val|\cf3 \
	\cf7 var\cf3  macro;\
	if (val == 1) \{\
		macro = a.automator.toggleMacroLooping(0);\
		(\cf8 "Macro 0 looping toggled:"\cf3 +macro.loop).postln;\
	\};\
\});\
\
\cf2 // Desktop animation\cf3 \
\cf4 Keyboard\cf3 .addKeyResponder(\cf6 '0'\cf3 ,\{\cf7 |val|\cf3 \
	\cf7 var\cf3  macro;\
	if (val == 1) \{\
		macro = a.automator.toggleMacroLooping(0);\
		(\cf8 "Animate Desktop BG:"\cf3 +macro.loop).postln;\
	\};\
\});\
\
\cf9 ~animatorScript\cf3  = \cf8 "/Volumes/Store/Drive/DEV/iMacMusic/AppleScript/screenshot_bg_animator.scpt"\cf3 ;\
(\cf8 "osascript"\cf3  + \cf9 ~animatorScript\cf3 ).unixCmd;\
\
\cf9 ~animatorScript\cf3  = \cf8 "/Volumes/Store/Drive/DEV/iMacMusic/AppleScript/screenshot_bg_animator.scpt"\cf3 ;\
(\cf8 "osascript"\cf3  + \cf9 ~animatorScript\cf3 ).unixCmd;\
\
\cf2 /*************** Control Listener Threshholds & Debounce ************\
*********************************************************************/\cf3 \
\cf4 Post\cf3  << \cf8 "Loading Threshhold & Debounce Controls...\\n"\cf3 ;\
\
\
\cf2 // + and - raise/lower the amp threshhold\cf3 \
\cf4 Keyboard\cf3 .addKeyResponder(\cf6 'equal'\cf3 ,\{\cf7 |val|\cf3 \
	if (val == 1) \{\
		a.ampthresh = a.ampthresh + a.ampincrement;\
		if (a.ampthresh > 1.0) \{ a.ampthresh = 1.0; \};\
		a.listener_synth.set(\cf6 \\thresh\cf3 , a.ampthresh);\
		(\cf8 "++ampthresh to:"\cf3 + a.ampthresh).postln;\
	\};\
\});\
\
\cf4 Keyboard\cf3 .addKeyResponder(\cf6 'minus'\cf3 ,\{\cf7 |val|\cf3 \
	if (val == 1) \{\
		a.ampthresh = a.ampthresh - a.ampincrement;\
		if (a.ampthresh < 0.0) \{ a.ampthresh = 0.0; \};\
		a.listener_synth.set(\cf6 \\thresh\cf3 , a.ampthresh);\
		(\cf8 "--ampthresh to:"\cf3 + a.ampthresh).postln;\
	\};\
\});\
\
\
\cf2 // [ and ] raise/lower debounce time\cf3 \
\cf4 Keyboard\cf3 .addKeyResponder(\cf6 'rightbracket'\cf3 ,\{\cf7 |val|\cf3 \
	if (val == 1) \{\
		a.dbounceTime = a.dbounceTime + a.dbounceIncrement;\
		if (a.dbounceTime > 1.0) \{ a.dbounceTime = 1.0; \};\
		(\cf8 "++dbouncetime to:"\cf3  + a.dbounceTime).postln;\
	\};\
\});\
\
\cf4 Keyboard\cf3 .addKeyResponder(\cf6 'leftbracket'\cf3 ,\{\cf7 |val|\cf3 \
	if (val == 1) \{\
		a.dbounceTime = a.dbounceTime - a.dbounceIncrement;\
		if (a.dbounceTime < 0.05) \{ a.dbounceTime = 0.05; \};\
		(\cf8 "--dbounceTime to:"\cf3 +a.dbounceTime).postln;\
	\};\
\});\
\
\
\
\cf2 /*************** Window Animations ************\
These use CocoaBridge so make sure a.cocoaBridge = true\
***********************************************/\cf3 \
\
\cf2 /*\
\
Post << "Loading CocoaBridge Responders...\\n";\
\
// 5 default responder\
Keyboard.addKeyResponder('5', \{|val|\
	if (val == 1) \{\
		"5 - default is down".postln;\
		o.notNil and: \{o.remove;\};\
		c.value; // clean up old responder\
		(\{a.cleaning == true\}).while(\{\}); // wait for last cleanup to finish\
		a.dbounceActive = false;\
		o = OSCresponder(nil, '/amp', \{|t,r,msg|\
			if (a.dbounceActive == false) \{\
				a.dbounceActive = true;\
				("Amplitude: "++ msg[3]).postln;\
				\{ a.dbounceActive = false; \}.defer(a.dbounceTime);\
			\};\
		\}).add;\
		c = \{"No Cleanup is Necessary for the Default Audio Responder.".postln;\};\
	\} \{\
		"5 - default is up".postln;\
	\};\
\});\
\
\
\
// 6 window grid\
Keyboard.addKeyResponder('6',\{|val|\
	if (val == 1) \{\
		"6 is down! Go!".postln;\
		o.notNil and: \{o.remove;\};\
		\{\
			var panelwidth, panelheight, numcols=5, numrows=5,myrect,mywin,init=false;\
			c.value; // clean up old responder\
			(\{a.cleaning == true\}).while(\{\}); // wait for last cleanup to finish\
			"Cleanup finished".postln;\
			panelwidth = a.screenWidth / numcols;\
			panelheight = a.screenHeight / numrows;\
\
			// Init grid\
			\{\
				"Init start".postln;\
				init = true;\
				numrows.do(\{|i|\
					numcols.do(\{|j|\
						myrect = Rect(j*panelwidth,i*panelheight,panelwidth,panelheight);\
						mywin = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[myrect,15,2,1]);\
						a.windows = a.windows.add(mywin);\
						//mywin.invoke("setBackgroundColor:",[Color.rand],true);\
						mywin.invoke("setTitle:",[String.fill(rrand(3,20),\{|i| rrand(10,9000).asAscii;\})],true);\
						mywin.invoke("makeKeyAndOrderFront:",[nil],defer:true);\
					\});\
				\});\
				"Init finished".postln;\
				init = false;\
			\}.fork(AppClock);\
\
			(\{init == true\}).while(\{\}); // how about a callback after initialization is done instead? This would all benefit from a class structure\
\
			a.dbounceActive = false;\
			o = OSCresponder(nil, '/amp', \{|t,r,msg|\
				if (a.dbounceActive == false) \{\
					a.dbounceActive = true;\
					("Amplitude 2: "++ msg[3]).postln;\
					\{ a.dbounceActive = false; \}.defer(a.dbounceTime);\
\
					block \{|break|\
						var vals = (1.0 / (1..20)).reverse;\
						fork(\{\
							a.windows.do(\{|thewin,ind|\
								\{\
									vals.do(\{|num,ind|\
										thewin.invoke("setAlphaValue:",[num],true);\
										0.01.wait; // animation fade speed\
									\});\
								\}.fork(AppClock);\
								0.1.wait; // window cycle speed\
							\});\
						\});\
					\};\
				\};//endif\
			\}).add;\
\
			// clean up grid\
			c = \{\
				\{\
					(\{a.cleaning == true\}).while(\{\}); // wait for last cleanup to finish				~cleaning = true; // could probably do this more reliably using a system/chain of callbacks\
					"Cleanup".postln;\
					a.windows.do(\{|thewin,i|\
						thewin.invoke("close",defer:true);\
						thewin.release;\
						0.01.wait;\
					\});\
					a.windows.removeEvery(a.windows);\
					a.cleaning = false;\
				\}.fork(AppClock);\
			\};\
		\}.fork(AppClock);\
	\} \{\
		"6 is up".postln;\
	\};\
\});\
\
\
// 7 windows glowing\
Keyboard.addKeyResponder('7',\{|val|\
	if (val == 1) \{\
		"7 is down! Go!".postln;\
		o.notNil and: \{o.remove;\};\
		\{\
			var panelwidth, panelheight, numcols=8, numrows=7,myrect,mywin,init=false,anivals;\
			c.value; // clean up old responder\
			(\{a.cleaning == true\}).while(\{\}); // wait for last cleanup to finish\
			"Cleanup finished".postln;\
			panelwidth = a.screenWidth / numcols;\
			panelheight = a.screenHeight / numrows;\
			anivals = (1.0 / (1..20)).reverse;\
			a.gridspeed = 0.05;\
\
\
			// Init grid\
			\{\
				"Init start".postln;\
				init = true;\
				numrows.do(\{|i|\
					numcols.do(\{|j|\
						myrect = Rect(j*panelwidth,i*panelheight,panelwidth,panelheight);\
						mywin = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[myrect,15,2,1]);\
						a.windows = a.windows.add(mywin);\
						//mywin.invoke("setBackgroundColor:",[Color.rand],true);\
						mywin.invoke("setTitle:",[String.fill(rrand(3,20),\{|i| rrand(10,9000).asAscii;\})],true);\
						mywin.invoke("makeKeyAndOrderFront:",[nil],defer:true);\
					\});\
				\});\
				"Init finished".postln;\
				init = false;\
			\}.fork(AppClock);\
\
			(\{init == true\}).while(\{\}); // how about a callback after initialization is done instead? This would all benefit from a class structure\
\
			a.dbounceActive = false;\
			o = OSCresponder(nil, '/amp', \{|t,r,msg|\
				var rr, gg, bb;\
				if (a.dbounceActive == false) \{\
					rr = 1.0.rand; gg=1.0.rand; bb=1.0.rand;\
					a.dbounceActive = true;\
\
					("Amplitude 3: "++ msg[3]).postln;\
					\{ a.dbounceActive = false; \}.defer(a.dbounceTime);\
\
					fork(\{\
						a.windows.do(\{|thewin,ind|\
							\{\
								anivals.do(\{|num,ind|\
									thewin.invoke("setBackgroundColor:",[Color.new(num*rr,num*gg,num*bb,1)],true);\
									0.01.wait; // single window fade speed\
								\});\
							\}.fork(AppClock);\
							a.gridspeed.wait; // grid cycle speed\
						\});\
					\});\
				\};//endif\
			\}).add;\
\
			// clean up grid\
			c = \{\
				\{\
					(\{a.cleaning == true\}).while(\{\}); // wait for last cleanup to finish				~cleaning = true; // could probably do this more reliably using a system/chain of callbacks\
					"Cleanup begin".postln;\
					a.windows.do(\{|thewin,i|\
						thewin.invoke("close",defer:true);\
						thewin.release;\
						0.01.wait;\
					\});\
					a.windows.removeEvery(a.windows);\
					"Cleanup end".postln;\
					a.cleaning = false;\
				\}.fork(AppClock);\
			\};\
		\}.fork(AppClock);\
	\} \{\
		"7 is up".postln;\
	\};\
\});\
\
\
\
// 8 windows sliding\
Keyboard.addKeyResponder('8',\{|val|\
	if (val == 1) \{\
		"8 is down! Go!".postln;\
		o.notNil and: \{o.remove;\};\
		\{\
			var panelwidth, panelheight, numpanels=6,myrect,mywin,mybut,myview;\
			c.value; // clean up old responder\
			(\{a.cleaning == true\}).while(\{\}); // wait for last cleanup to finish\
			panelwidth = a.screenWidth / (numpanels + 2);\
			panelheight = a.screenHeight / (numpanels + 4);\
\
			// Init windows\
			\{\
				numpanels.do(\{|i|\
					myrect = Rect(i%2 * (a.screenWidth - panelwidth - (2*i)),\
						(i%4 > 1).binaryValue * (a.screenHeight - panelheight),panelwidth,panelheight);\
					mywin = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[myrect,271,2,1]);\
					a.windows = a.windows.add(mywin);\
					mywin.invoke("setTitle:",[String.fill(rrand(3,20),\{|i| rrand(10,9000).asAscii;\})],true);\
					myview = SCNSObject("NSView","initWithFrame:",[mywin.invoke("frame")]);\
					a.views = a.views.add(myview);\
					mywin.invoke("setContentView:",[myview],true);\
					mybut = SCNSObject("NSButton","initWithFrame:",[Rect(panelwidth / 2,panelheight / 2,100,20)]);\
					a.buttons = a.buttons.add(mybut);\
					myview.invoke("addSubview:",[mybut],true);\
					mybut.invoke("setButtonType:",[0]);\
					mybut.invoke("setBezelStyle:",[0]);\
					mybut.invoke("setTitle:",[["OK","Apply","Quit","Cancel","Continue","Agree"].choose]);\
					mywin.invoke("makeKeyAndOrderFront:",[nil],true);\
				\});\
\
			\}.fork(AppClock);\
\
			1.wait;\
\
			// Here's where the fun starts\
			a.dbounceActive = false;\
			o = OSCresponder(nil, '/amp', \{|t,r,msg|\
				if (a.dbounceActive == false) \{\
					a.dbounceActive = true;\
					("Amplitude 4: "++ msg[3]).postln;\
					\{ a.dbounceActive = false; \}.defer(~dbounceTime);\
\
					block \{|break|\
						\{\
							var torect;\
							a.windows.do(\{|thewin,ind|\
								torect = Rect(rrand(0,a.screenWidth),rrand(100,a.screenHeight),rrand(100,300),rrand(30,200));\
								thewin.invoke("setFrame:display:animate:",[torect,1,1],true);\
								0.03.wait; // pause between windows\
							\});\
						\}.fork(AppClock);\
					\};\
				\};//endif\
			\}).add;\
\
			// clean up windows\
			c = \{\
				\{\
					(\{a.cleaning == true\}).while(\{\}); // wait for last cleanup to finish\
					a.cleaning = true;\
					"Cleanup".postln;\
					a.buttons.do(\{|thebut,i|\
						thebut.release;\
					\});\
					a.buttons.removeEvery(a.buttons);\
\
					a.views.do(\{|theview,i|\
						theview.release;\
					\});\
					a.views.removeEvery(a.views);\
\
					a.windows.do(\{|thewin,i|\
						thewin.invoke("close",defer:true);\
						thewin.release;\
						0.01.wait;\
					\});\
					a.windows.removeEvery(a.windows);\
					0.1.wait;\
					a.cleaning = false;\
				\}.fork(AppClock);\
			\};\
		\}.fork(AppClock);\
	\} \{\
		"8 is up".postln;\
	\};\
\});\
\
\
\
// 9 window zooming\
Keyboard.addKeyResponder('9',\{|val|\
	if (val == 1) \{\
		"9 is down! Go!".postln;\
		o.notNil and: \{o.remove;\};\
		\{\
			var mywin,myrect,panelwidth=10,panelheight=10,zoom=1;\
			c.value; // clean up old responder\
			(\{a.cleaning == true\}).while(\{\}); // wait for last cleanup to finish.. seems dangerous to do these while loops, at least it's on a different thread.. that could be saving me, would be best to use callbacks\
\
			a.zoomdir = 1;\
			// Init window\
			\{\
				myrect = Rect((a.screenWidth / 2) - (panelwidth / 2),(a.screenHeight / 2) - (panelheight / 2),panelwidth,panelheight);\
				mywin = SCNSObject("NSWindow","initWithContentRect:styleMask:backing:defer:",[myrect,271,2,1]);\
				a.windows = a.windows.add(mywin);\
				mywin.invoke("setTitle:",[String.fill(rrand(3,20),\{|i| rrand(10,9000).asAscii;\})],true);\
				mywin.invoke("center",defer:true);\
				a.windows = a.windows.add(mywin);\
				mywin.invoke("makeKeyAndOrderFront:",[nil],true);\
			\}.fork(AppClock);\
\
			1.wait;\
\
			// Here's where the fun starts\
			a.dbounceActive = false;\
			o = OSCresponder(nil, '/amp', \{|t,r,msg|\
				if (a.dbounceActive == false) \{\
					a.dbounceActive = true;\
					("Amplitude 9: "++ msg[3]).postln;\
					\{ a.dbounceActive = false; \}.defer(a.dbounceTime);\
					\{\
						var therect;\
						therect = mywin.invoke("frame");\
						therect.width = therect.width + (100.rand * a.zoomdir);\
						therect.height = therect.height + (50.rand * a.zoomdir);\
						if (therect.width > a.screenWidth or:(therect.height > a.screenHeight)) \{\
							a.zoomdir = -1;\
						\};\
						if (therect.width < 5 or:(therect.height < 5)) \{\
							a.zoomdir = 1;\
						\};\
						//mywin.invoke("zoom:",[nil],true);\
						//panelwidth = rrand(5,~screenWidth);panelheight = rrand(5,~screenHeight);\
						//torect = Rect((~screenWidth / 2) - (panelwidth / 2),(~screenHeight / 2) - (panelheight / 2),panelwidth,panelheight);\
						mywin.invoke("setTitle:",[String.fill(rrand(3,20),\{|i| rrand(10,9000).asAscii;\})],true);\
						mywin.invoke("setFrame:display:animate:",[therect,1,1],true);\
						mywin.invoke("center",defer:true);\
					\}.fork(AppClock);\
				\};//endif\
			\}).add;\
\
			// clean up window\
			c = \{\
				\{\
					(\{a.cleaning == true\}).while(\{\}); // wait for last cleanup to finish\
					a.cleaning = true;\
					"Cleanup".postln;\
					a.windows.do(\{|thewin,i|\
						thewin.invoke("close",defer:true);\
						thewin.release;\
						0.01.wait;\
					\});\
					a.windows.removeEvery(a.windows);\
					0.1.wait;\
					a.cleaning = false;\
				\}.fork(AppClock);\
			\};\
		\}.fork(AppClock);\
	\} \{\
		"9 is up".postln;\
	\};\
\});\
\
// Others...\
//windows minimizing / maximizing\
//something very simple and illustrative..\
//window pops up for each sound.. can it unminimize?\
\
// END COCOABRIDGE DEPENDENT CODE\
// NTS:: This stuff could be coded in Xcode more easily.\
*/\cf3 \
\
\
\
\
\cf2 /* Free the listeners & synths\
x.free;\
o.free;\
k.free;\
a.free;\
*/\cf3 \
\
\
}